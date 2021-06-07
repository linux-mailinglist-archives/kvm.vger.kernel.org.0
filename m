Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F76E39D824
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 11:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhFGJEd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 05:04:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51732 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230443AbhFGJEc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Jun 2021 05:04:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623056561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cs0csa7t65m5XXMi4gqzOayl+MyH3sAO73AqdRmrWhQ=;
        b=Pwcl0Ihn5qU+lh/E+P20aqZ/+1yyp/5ZnowayUWWWg0t6JU1VqBgITWz16w35MR2i39N4g
        64HJG16CWO8vYuptCXUfMo87aLkIVjZvzxBJ9QKNprB4LuFKJjE5/15cyZozpPAd/DqkHd
        i+PrBkkwFUBgGLkgstwD4rYzdWIXreI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-z8JH8As9OJyCx-ZpXSoI3A-1; Mon, 07 Jun 2021 05:02:40 -0400
X-MC-Unique: z8JH8As9OJyCx-ZpXSoI3A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF4A480EF80;
        Mon,  7 Jun 2021 09:02:38 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B4C24100EB3D;
        Mon,  7 Jun 2021 09:02:32 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Jim Mattson <jmattson@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 4/8] KVM: nSVM: refactor the CR3 reload on migration
Date:   Mon,  7 Jun 2021 12:01:59 +0300
Message-Id: <20210607090203.133058-5-mlevitsk@redhat.com>
In-Reply-To: <20210607090203.133058-1-mlevitsk@redhat.com>
References: <20210607090203.133058-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
index 8f5dbc80f57f..e3e5775b8f1c 100644
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
 	    CC(!load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3)))
 		return -EINVAL;
 
@@ -574,7 +574,7 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 	nested_vmcb02_prepare_save(svm, vmcb12);
 
 	ret = nested_svm_load_cr3(&svm->vcpu, vmcb12->save.cr3,
-				  nested_npt_enabled(svm));
+				  nested_npt_enabled(svm), true);
 	if (ret)
 		return ret;
 
@@ -803,7 +803,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	nested_svm_uninit_mmu_context(vcpu);
 
-	rc = nested_svm_load_cr3(vcpu, svm->vmcb->save.cr3, false);
+	rc = nested_svm_load_cr3(vcpu, svm->vmcb->save.cr3, false, true);
 	if (rc)
 		return 1;
 
@@ -1299,6 +1299,19 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
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
@@ -1356,9 +1369,14 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
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
2.26.3

