Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F5B1E8219
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 17:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgE2Pke (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 11:40:34 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:29399 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727966AbgE2Pjx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 May 2020 11:39:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590766791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pS3ccCDVdCnm43v0XIYJwci/rbPO02eSgYyCxxBhDpY=;
        b=EyQvNKk0yYJSjTx6BO/n4qRYmnpSnALkkEDcm7iUZVYXMBOwjzWBhVufS7PsDBT1Uvx8Vn
        W9TRCtBHvjiPb5uuXn9Y5NfrDBuoq72V4MVwrUtcMeLGRJJGnBa7nwNQbcGcRKEAWwCQEF
        UheGcZnnH4I1l4dYa9u2MBucBtUzoN4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-EMbVDzFXNgy2F3TJRzGOzA-1; Fri, 29 May 2020 11:39:50 -0400
X-MC-Unique: EMbVDzFXNgy2F3TJRzGOzA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2143319057A3;
        Fri, 29 May 2020 15:39:49 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF30E10013C2;
        Fri, 29 May 2020 15:39:48 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 26/30] KVM: MMU: pass arbitrary CR0/CR4/EFER to kvm_init_shadow_mmu
Date:   Fri, 29 May 2020 11:39:30 -0400
Message-Id: <20200529153934.11694-27-pbonzini@redhat.com>
In-Reply-To: <20200529153934.11694-1-pbonzini@redhat.com>
References: <20200529153934.11694-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
index 048e865ad485..0ad06bfe2c2c 100644
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
index fd1c9145505c..2e62a03410c7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4952,7 +4952,7 @@ kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu, bool base_only)
 	return role;
 }
 
-void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu)
+void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4, u32 efer)
 {
 	struct kvm_mmu *context = vcpu->arch.mmu;
 	union kvm_mmu_role new_role =
@@ -4961,11 +4961,11 @@ void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu)
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
@@ -5043,7 +5043,11 @@ static void init_kvm_softmmu(struct kvm_vcpu *vcpu)
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
index 369eca73fe3e..c712fe577029 100644
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


