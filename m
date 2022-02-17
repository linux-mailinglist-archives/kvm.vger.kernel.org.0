Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70EA54BAB72
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 22:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244360AbiBQVEP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 16:04:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243969AbiBQVEF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 16:04:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 59D2B165C06
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 13:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645131829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bb07ybGCMBRl5oIy12eV8DM3Y/j7y0FXE0a9BHr0sbA=;
        b=SXT7+sVt+kzL9tftzYpQU8JKzzYV22hhBQ4uUNc/0hcLVqU0i1aJrM17noG4e6TYcTSktH
        ULunN+AeSJGe15uKG+us+m+3o+tVTChNbH0isaF2EHz06kUn+8FfxXKXKvZGa9gPgjs6pk
        3wZIJ9RyIuundRlb/tabF6gZ4uR1v+Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-660-h7MQuTrJOqClz9PJVAEJXA-1; Thu, 17 Feb 2022 16:03:47 -0500
X-MC-Unique: h7MQuTrJOqClz9PJVAEJXA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8AB31800D50;
        Thu, 17 Feb 2022 21:03:46 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F0B36AB95;
        Thu, 17 Feb 2022 21:03:46 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH v2 11/18] KVM: x86/mmu: Always use current mmu's role when loading new PGD
Date:   Thu, 17 Feb 2022 16:03:33 -0500
Message-Id: <20220217210340.312449-12-pbonzini@redhat.com>
In-Reply-To: <20220217210340.312449-1-pbonzini@redhat.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since the guest PGD is now loaded after the MMU has been set up
completely, the desired role for a cache hit is simply the current
mmu_role.  There is no need to compute it again, so __kvm_mmu_new_pgd
can be folded in kvm_mmu_new_pgd.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 29 ++++-------------------------
 1 file changed, 4 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 906a9244ad28..b01160716c6a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -190,8 +190,6 @@ struct kmem_cache *mmu_page_header_cache;
 static struct percpu_counter kvm_total_used_mmu_pages;
 
 static void mmu_spte_set(u64 *sptep, u64 spte);
-static union kvm_mmu_page_role
-kvm_mmu_calc_root_page_role(struct kvm_vcpu *vcpu);
 
 struct kvm_mmu_role_regs {
 	const unsigned long cr0;
@@ -4191,10 +4189,10 @@ static bool fast_pgd_switch(struct kvm *kvm, struct kvm_mmu *mmu,
 		return cached_root_find_without_current(kvm, mmu, new_pgd, new_role);
 }
 
-static void __kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd,
-			      union kvm_mmu_page_role new_role)
+void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
+	union kvm_mmu_page_role new_role = mmu->mmu_role.base;
 
 	if (!fast_pgd_switch(vcpu->kvm, mmu, new_pgd, new_role)) {
 		/* kvm_mmu_ensure_valid_pgd will set up a new root.  */
@@ -4230,11 +4228,6 @@ static void __kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd,
 		__clear_sp_write_flooding_count(
 				to_shadow_page(vcpu->arch.mmu->root.hpa));
 }
-
-void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
-{
-	__kvm_mmu_new_pgd(vcpu, new_pgd, kvm_mmu_calc_root_page_role(vcpu));
-}
 EXPORT_SYMBOL_GPL(kvm_mmu_new_pgd);
 
 static unsigned long get_cr3(struct kvm_vcpu *vcpu)
@@ -4904,7 +4897,7 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 	new_role = kvm_calc_shadow_npt_root_page_role(vcpu, &regs);
 
 	shadow_mmu_init_context(vcpu, context, &regs, new_role);
-	__kvm_mmu_new_pgd(vcpu, nested_cr3, new_role.base);
+	kvm_mmu_new_pgd(vcpu, nested_cr3);
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_npt_mmu);
 
@@ -4960,7 +4953,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 		reset_ept_shadow_zero_bits_mask(context, execonly);
 	}
 
-	__kvm_mmu_new_pgd(vcpu, new_eptp, new_role.base);
+	kvm_mmu_new_pgd(vcpu, new_eptp);
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_ept_mmu);
 
@@ -5045,20 +5038,6 @@ void kvm_init_mmu(struct kvm_vcpu *vcpu)
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


