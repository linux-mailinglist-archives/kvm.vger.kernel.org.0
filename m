Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B8836B233
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 13:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233348AbhDZLPQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 07:15:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40415 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233205AbhDZLPE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Apr 2021 07:15:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619435663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6XVGhAXBfo9MgQy1ty+oqe6SntrES8m23Sof78r/E/E=;
        b=IZXpeb5TvGbeASyH4WcqkzNxmY0dHKVSgTvd1sp9nX6qBLJER3Z41Hqn8YKJKQL6oNAasD
        /fvupI8n3pTbjMe9yJM3K5hYyrZrwArPdplJyH060xXPmEyoCgCO20dVimK75mM2Bvy5Si
        sK+lgPGrUMT0+vahbxAoItuFQB9BkK4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-T7jfQD7PPQiPaeAlmnN-3A-1; Mon, 26 Apr 2021 07:14:21 -0400
X-MC-Unique: T7jfQD7PPQiPaeAlmnN-3A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D124F108BC2F;
        Mon, 26 Apr 2021 11:13:45 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.73])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 316595D9D0;
        Mon, 26 Apr 2021 11:13:40 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 1/6] KVM: nSVM: refactor the CR3 reload on migration
Date:   Mon, 26 Apr 2021 14:13:28 +0300
Message-Id: <20210426111333.967729-2-mlevitsk@redhat.com>
In-Reply-To: <20210426111333.967729-1-mlevitsk@redhat.com>
References: <20210426111333.967729-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Document the actual reason why we need to do it
on migration and move the call to svm_set_nested_state
to be closer to VMX code.

To avoid loading the PDPTRs from possibly not up to date memory map,
in nested_svm_load_cr3 after the move, move this code to
.get_nested_state_pages.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 540d43ba2cf4..ceb37ed1dc98 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -385,12 +385,12 @@ static inline bool nested_npt_enabled(struct vcpu_svm *svm)
  * if we are emulating VM-Entry into a guest with NPT enabled.
  */
 static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
-			       bool nested_npt)
+			       bool nested_npt, bool reload_pdptrs)
 {
 	if (CC(kvm_vcpu_is_illegal_gpa(vcpu, cr3)))
 		return -EINVAL;
 
-	if (!nested_npt && is_pae_paging(vcpu) &&
+	if (reload_pdptrs && !nested_npt && is_pae_paging(vcpu) &&
 	    (cr3 != kvm_read_cr3(vcpu) || pdptrs_changed(vcpu))) {
 		if (CC(!load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3)))
 			return -EINVAL;
@@ -576,7 +576,7 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 	nested_vmcb02_prepare_save(svm, vmcb12);
 
 	ret = nested_svm_load_cr3(&svm->vcpu, vmcb12->save.cr3,
-				  nested_npt_enabled(svm));
+				  nested_npt_enabled(svm), true);
 	if (ret)
 		return ret;
 
@@ -806,7 +806,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	nested_svm_uninit_mmu_context(vcpu);
 
-	rc = nested_svm_load_cr3(vcpu, svm->vmcb->save.cr3, false);
+	rc = nested_svm_load_cr3(vcpu, svm->vmcb->save.cr3, false, true);
 	if (rc)
 		return 1;
 
@@ -1291,6 +1291,19 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	    !nested_vmcb_valid_sregs(vcpu, save))
 		goto out_free;
 
+	/*
+	 * While the nested guest CR3 is already checked and set by
+	 * KVM_SET_SREGS, it was set when nested state was yet loaded,
+	 * thus MMU might not be initialized correctly.
+	 * Set it again to fix this.
+	 */
+
+	ret = nested_svm_load_cr3(&svm->vcpu, vcpu->arch.cr3,
+				  nested_npt_enabled(svm), false);
+	if (WARN_ON_ONCE(ret))
+		goto out_free;
+
+
 	/*
 	 * All checks done, we can enter guest mode. Userspace provides
 	 * vmcb12.control, which will be combined with L1 and stored into
@@ -1343,9 +1356,14 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 	if (WARN_ON(!is_guest_mode(vcpu)))
 		return true;
 
-	if (nested_svm_load_cr3(&svm->vcpu, vcpu->arch.cr3,
-				nested_npt_enabled(svm)))
-		return false;
+	if (!nested_npt_enabled(svm) && is_pae_paging(vcpu))
+		/*
+		 * Reload the guest's PDPTRs since after a migration
+		 * the guest CR3 might be restored prior to setting the nested
+		 * state which can lead to a load of wrong PDPTRs.
+		 */
+		if (CC(!load_pdptrs(vcpu, vcpu->arch.walk_mmu, vcpu->arch.cr3)))
+			return false;
 
 	if (!nested_svm_vmrun_msrpm(svm)) {
 		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-- 
2.26.2

