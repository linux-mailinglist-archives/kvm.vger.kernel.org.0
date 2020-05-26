Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3682F1E289D
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 19:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389371AbgEZRYV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 13:24:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58971 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389354AbgEZRX7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 13:23:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590513837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t0i45HR53GHJBPiV9ZMKrYpIjTwg8e0xme5Ids+GP08=;
        b=DrQLkAl6ogfW9xkwBk17FKzzsy5CF8404721ThrUJiUMDeqrthnfRE+mVH99pc6olmbN3v
        iAeCygIN4H18pq4YNPaxesdl79Yg8kq1vzsdfgi9xOzNlhZw7URaI7EQznm4oJTobuj7LX
        AUvXAhFrXKsuwuGCey35ib3vKWEp+J0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-kvC8sjECMN2maULTRHfVLA-1; Tue, 26 May 2020 13:23:56 -0400
X-MC-Unique: kvC8sjECMN2maULTRHfVLA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD011107ACCD;
        Tue, 26 May 2020 17:23:54 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2CD9F5D9E7;
        Tue, 26 May 2020 17:23:54 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, mlevitsk@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 26/28] KVM: MMU: pass arbitrary CR0/CR4/EFER to kvm_init_shadow_mmu
Date:   Tue, 26 May 2020 13:23:06 -0400
Message-Id: <20200526172308.111575-27-pbonzini@redhat.com>
In-Reply-To: <20200526172308.111575-1-pbonzini@redhat.com>
References: <20200526172308.111575-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows fetching the registers from the hsave area when setting
up the NPT shadow MMU, and is needed for KVM_SET_NESTED_STATE (which
runs long after the CR0, CR4 and EFER values in vcpu have been switched
to hold L2 guest state).

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu.h        |  2 +-
 arch/x86/kvm/mmu/mmu.c    | 14 +++++++++-----
 arch/x86/kvm/svm/nested.c |  5 ++++-
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 8a3b1bce722a..45c1ae872a34 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -57,7 +57,7 @@ void
 reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
 
 void kvm_init_mmu(struct kvm_vcpu *vcpu, bool reset_roots);
-void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu);
+void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4, u32 efer);
 void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 			     bool accessed_dirty, gpa_t new_eptp);
 bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2df0f347655a..fbc061df57ab 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4956,7 +4956,7 @@ kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu, bool base_only)
 	return role;
 }
 
-void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu)
+void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4, u32 efer)
 {
 	struct kvm_mmu *context = vcpu->arch.mmu;
 	union kvm_mmu_role new_role =
@@ -4965,11 +4965,11 @@ void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu)
 	if (new_role.as_u64 == context->mmu_role.as_u64)
 		return;
 
-	if (!is_paging(vcpu))
+	if (!(cr0 & X86_CR0_PG))
 		nonpaging_init_context(vcpu, context);
-	else if (is_long_mode(vcpu))
+	else if (efer & EFER_LMA)
 		paging64_init_context(vcpu, context);
-	else if (is_pae(vcpu))
+	else if (cr4 & X86_CR4_PAE)
 		paging32E_init_context(vcpu, context);
 	else
 		paging32_init_context(vcpu, context);
@@ -5047,7 +5047,11 @@ static void init_kvm_softmmu(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *context = vcpu->arch.mmu;
 
-	kvm_init_shadow_mmu(vcpu);
+	kvm_init_shadow_mmu(vcpu,
+			    kvm_read_cr0_bits(vcpu, X86_CR0_PG),
+			    kvm_read_cr4_bits(vcpu, X86_CR4_PAE),
+			    vcpu->arch.efer);
+
 	context->get_guest_pgd     = get_cr3;
 	context->get_pdptr         = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index e63e62d12acd..840662e66976 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -80,10 +80,13 @@ static unsigned long nested_svm_get_tdp_cr3(struct kvm_vcpu *vcpu)
 
 static void nested_svm_init_mmu_context(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb *hsave = svm->nested.hsave;
+
 	WARN_ON(mmu_is_nested(vcpu));
 
 	vcpu->arch.mmu = &vcpu->arch.guest_mmu;
-	kvm_init_shadow_mmu(vcpu);
+	kvm_init_shadow_mmu(vcpu, X86_CR0_PG, hsave->save.cr4, hsave->save.efer);
 	vcpu->arch.mmu->get_guest_pgd     = nested_svm_get_tdp_cr3;
 	vcpu->arch.mmu->get_pdptr         = nested_svm_get_tdp_pdptr;
 	vcpu->arch.mmu->inject_page_fault = nested_svm_inject_npf_exit;
-- 
2.26.2


