Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFC84A98AA
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 12:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358659AbiBDL5h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 06:57:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30964 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358542AbiBDL51 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 06:57:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643975847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fkKYEfyzy0ipD48Cu9xppCXPtPIRhSzneIy4U+9hHCY=;
        b=AIo5TW79uwGWMP/IVVQaYhCSrEutQETteVbwm5Q4EM3VE80xgKHmuarH182Q760SJuqwCx
        PKs2731uwA99SXEn8+kFFdxS59Gx9EL7Ml18RHjRubOpP5s2A1idNjJCaNcbIi5TOsILeR
        NU5H/qLNCqb7P1v7t94LKYISjASp8Cg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-398-4yVODtwiNpSUmarTOQWBJA-1; Fri, 04 Feb 2022 06:57:24 -0500
X-MC-Unique: 4yVODtwiNpSUmarTOQWBJA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 41931190B2A6;
        Fri,  4 Feb 2022 11:57:23 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA5A31081172;
        Fri,  4 Feb 2022 11:57:22 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com, vkuznets@redhat.com
Subject: [PATCH 07/23] KVM: MMU: remove kvm_mmu_calc_root_page_role
Date:   Fri,  4 Feb 2022 06:57:02 -0500
Message-Id: <20220204115718.14934-8-pbonzini@redhat.com>
In-Reply-To: <20220204115718.14934-1-pbonzini@redhat.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since the guest PGD is now loaded after the MMU has been set up
completely, the desired role for a cache hit is simply the current
mmu_role.  There is no need to compute it again, so __kvm_mmu_new_pgd
can be folded in kvm_mmu_new_pgd.

As an aside, the !tdp_enabled case in the function was dead code,
and that also gets mopped up as a side effect.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 29 ++++-------------------------
 1 file changed, 4 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b8ab16323629..42475e4c2a48 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -190,8 +190,6 @@ struct kmem_cache *mmu_page_header_cache;
 static struct percpu_counter kvm_total_used_mmu_pages;
 
 static void mmu_spte_set(u64 *sptep, u64 spte);
-static union kvm_mmu_page_role
-kvm_mmu_calc_root_page_role(struct kvm_vcpu *vcpu);
 
 struct kvm_mmu_role_regs {
 	const unsigned long cr0;
@@ -4159,9 +4157,9 @@ static bool fast_pgd_switch(struct kvm_vcpu *vcpu, gpa_t new_pgd,
 	return false;
 }
 
-static void __kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd,
-			      union kvm_mmu_page_role new_role)
+void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
 {
+	union kvm_mmu_page_role new_role = vcpu->arch.mmu->mmu_role.base;
 	if (!fast_pgd_switch(vcpu, new_pgd, new_role)) {
 		kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, KVM_MMU_ROOT_CURRENT);
 		return;
@@ -4196,11 +4194,6 @@ static void __kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd,
 		__clear_sp_write_flooding_count(
 				to_shadow_page(vcpu->arch.mmu->root_hpa));
 }
-
-void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
-{
-	__kvm_mmu_new_pgd(vcpu, new_pgd, kvm_mmu_calc_root_page_role(vcpu));
-}
 EXPORT_SYMBOL_GPL(kvm_mmu_new_pgd);
 
 static unsigned long get_cr3(struct kvm_vcpu *vcpu)
@@ -4871,7 +4864,7 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 
 	shadow_mmu_init_context(vcpu, context, &regs, new_role);
 	reset_shadow_zero_bits_mask(vcpu, context, is_efer_nx(context));
-	__kvm_mmu_new_pgd(vcpu, nested_cr3, new_role.base);
+	kvm_mmu_new_pgd(vcpu, nested_cr3);
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_npt_mmu);
 
@@ -4923,7 +4916,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 		reset_ept_shadow_zero_bits_mask(context, execonly);
 	}
 
-	__kvm_mmu_new_pgd(vcpu, new_eptp, new_role.base);
+	kvm_mmu_new_pgd(vcpu, new_eptp);
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_ept_mmu);
 
@@ -5009,20 +5002,6 @@ void kvm_init_mmu(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_init_mmu);
 
-static union kvm_mmu_page_role
-kvm_mmu_calc_root_page_role(struct kvm_vcpu *vcpu)
-{
-	struct kvm_mmu_role_regs regs = vcpu_to_role_regs(vcpu);
-	union kvm_mmu_role role;
-
-	if (tdp_enabled)
-		role = kvm_calc_tdp_mmu_root_page_role(vcpu, &regs, true);
-	else
-		role = kvm_calc_shadow_mmu_root_page_role(vcpu, &regs, true);
-
-	return role.base;
-}
-
 void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	/*
-- 
2.31.1


