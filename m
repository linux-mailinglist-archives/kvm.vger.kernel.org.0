Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20F494A98B1
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 12:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358748AbiBDL5q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 06:57:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50721 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1358604AbiBDL5d (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 06:57:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643975853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RyK+8TNqNAO/o5qLawKAV0/5MaLr0gp+ky512a4ENu4=;
        b=JQgEbMBW3bX9F40VZ003i9GIx9rmHR1gf9Qblxy7g8uhJVYtSymtmMf6T3zJgs1EKIX7mp
        w4cJL4PUyNZW58Cr4o0ql9u5E+Cr40ocImAl1lfkUbHpF63jLv30vKu1lY4VG9y2J30Cb8
        UtBOkofK5RTRp/xK9RC04BetxyRFcmk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-346-ZK4wex1EM_-DGQLTbEDiCg-1; Fri, 04 Feb 2022 06:57:29 -0500
X-MC-Unique: ZK4wex1EM_-DGQLTbEDiCg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A1EA28710F1;
        Fri,  4 Feb 2022 11:57:28 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 338FB6E1FD;
        Fri,  4 Feb 2022 11:57:28 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com, vkuznets@redhat.com
Subject: [PATCH 16/23] KVM: MMU: remove extended bits from mmu_role
Date:   Fri,  4 Feb 2022 06:57:11 -0500
Message-Id: <20220204115718.14934-17-pbonzini@redhat.com>
In-Reply-To: <20220204115718.14934-1-pbonzini@redhat.com>
References: <20220204115718.14934-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

mmu_role represents the role of the root of the page tables.
It does not need any extended bits, as those govern only KVM's
page table walking; the is_* functions used for page table
walking always use the CPU role.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu/mmu.c          | 63 ++++++++++++++++-----------------
 arch/x86/kvm/mmu/paging_tmpl.h  |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
 4 files changed, 34 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 795b345361c8..121eefdb9991 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -433,7 +433,7 @@ struct kvm_mmu {
 	hpa_t root_hpa;
 	gpa_t root_pgd;
 	union kvm_mmu_role cpu_role;
-	union kvm_mmu_role mmu_role;
+	union kvm_mmu_page_role mmu_role;
 	u8 root_level;
 	u8 shadow_root_level;
 	bool direct_map;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 817e6cc916fc..0cb46a74e561 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2045,7 +2045,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	int collisions = 0;
 	LIST_HEAD(invalid_list);
 
-	role = vcpu->arch.mmu->mmu_role.base;
+	role = vcpu->arch.mmu->mmu_role;
 	role.level = level;
 	role.direct = direct;
 	role.access = access;
@@ -3278,7 +3278,7 @@ void kvm_mmu_free_guest_mode_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 	 * This should not be called while L2 is active, L2 can't invalidate
 	 * _only_ its own roots, e.g. INVVPID unconditionally exits.
 	 */
-	WARN_ON_ONCE(mmu->mmu_role.base.guest_mode);
+	WARN_ON_ONCE(mmu->mmu_role.guest_mode);
 
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
 		root_hpa = mmu->prev_roots[i].hpa;
@@ -4146,7 +4146,7 @@ static bool fast_pgd_switch(struct kvm_vcpu *vcpu, gpa_t new_pgd,
 
 void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
 {
-	union kvm_mmu_page_role new_role = vcpu->arch.mmu->mmu_role.base;
+	union kvm_mmu_page_role new_role = vcpu->arch.mmu->mmu_role;
 	if (!fast_pgd_switch(vcpu, new_pgd, new_role)) {
 		kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, KVM_MMU_ROOT_CURRENT);
 		return;
@@ -4696,21 +4696,21 @@ static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
 	return max_tdp_level;
 }
 
-static union kvm_mmu_role
+static union kvm_mmu_page_role
 kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
 				union kvm_mmu_role cpu_role)
 {
-	union kvm_mmu_role role = {0};
+	union kvm_mmu_page_role role = {0};
 
-	role.base.access = ACC_ALL;
-	role.base.cr0_wp = true;
-	role.base.efer_nx = true;
-	role.base.smm = cpu_role.base.smm;
-	role.base.guest_mode = cpu_role.base.guest_mode;
-	role.base.ad_disabled = (shadow_accessed_mask == 0);
-	role.base.level = kvm_mmu_get_tdp_level(vcpu);
-	role.base.direct = true;
-	role.base.has_4_byte_gpte = false;
+	role.access = ACC_ALL;
+	role.cr0_wp = true;
+	role.efer_nx = true;
+	role.smm = cpu_role.base.smm;
+	role.guest_mode = cpu_role.base.guest_mode;
+	role.ad_disabled = (shadow_accessed_mask == 0);
+	role.level = kvm_mmu_get_tdp_level(vcpu);
+	role.direct = true;
+	role.has_4_byte_gpte = false;
 
 	return role;
 }
@@ -4720,14 +4720,14 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
 	union kvm_mmu_role cpu_role = kvm_calc_cpu_role(vcpu, regs);
-	union kvm_mmu_role mmu_role = kvm_calc_tdp_mmu_root_page_role(vcpu, cpu_role);
+	union kvm_mmu_page_role mmu_role = kvm_calc_tdp_mmu_root_page_role(vcpu, cpu_role);
 
 	if (cpu_role.as_u64 == context->cpu_role.as_u64 &&
-	    mmu_role.as_u64 == context->mmu_role.as_u64)
+	    mmu_role.word == context->mmu_role.word)
 		return;
 
 	context->cpu_role.as_u64 = cpu_role.as_u64;
-	context->mmu_role.as_u64 = mmu_role.as_u64;
+	context->mmu_role.word = mmu_role.word;
 	context->page_fault = kvm_tdp_page_fault;
 	context->sync_page = nonpaging_sync_page;
 	context->invlpg = NULL;
@@ -4749,7 +4749,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 	reset_tdp_shadow_zero_bits_mask(context);
 }
 
-static union kvm_mmu_role
+static union kvm_mmu_page_role
 kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
 				   union kvm_mmu_role role)
 {
@@ -4760,19 +4760,19 @@ kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
 	else
 		role.base.level = PT64_ROOT_4LEVEL;
 
-	return role;
+	return role.base;
 }
 
 static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
 				    union kvm_mmu_role cpu_role,
-				    union kvm_mmu_role mmu_role)
+				    union kvm_mmu_page_role mmu_role)
 {
 	if (cpu_role.as_u64 == context->cpu_role.as_u64 &&
-	    mmu_role.as_u64 == context->mmu_role.as_u64)
+	    mmu_role.word == context->mmu_role.word)
 		return;
 
 	context->cpu_role.as_u64 = cpu_role.as_u64;
-	context->mmu_role.as_u64 = mmu_role.as_u64;
+	context->mmu_role.word = mmu_role.word;
 
 	if (!is_cr0_pg(context))
 		nonpaging_init_context(context);
@@ -4783,7 +4783,7 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
 	context->root_level = cpu_role.base.level;
 
 	reset_guest_paging_metadata(vcpu, context);
-	context->shadow_root_level = mmu_role.base.level;
+	context->shadow_root_level = mmu_role.level;
 }
 
 static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
@@ -4791,7 +4791,7 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
 	union kvm_mmu_role cpu_role = kvm_calc_cpu_role(vcpu, regs);
-	union kvm_mmu_role mmu_role =
+	union kvm_mmu_page_role mmu_role =
 		kvm_calc_shadow_mmu_root_page_role(vcpu, cpu_role);
 
 	shadow_mmu_init_context(vcpu, context, cpu_role, mmu_role);
@@ -4807,13 +4807,12 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
 	reset_shadow_zero_bits_mask(vcpu, context, true);
 }
 
-static union kvm_mmu_role
+static union kvm_mmu_page_role
 kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu,
 				   union kvm_mmu_role role)
 {
 	role.base.level = kvm_mmu_get_tdp_level(vcpu);
-
-	return role;
+	return role.base;
 }
 
 void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
@@ -4826,7 +4825,7 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 		.efer = efer,
 	};
 	union kvm_mmu_role cpu_role = kvm_calc_cpu_role(vcpu, &regs);
-	union kvm_mmu_role mmu_role = kvm_calc_shadow_npt_root_page_role(vcpu, cpu_role);
+	union kvm_mmu_page_role mmu_role = kvm_calc_shadow_npt_root_page_role(vcpu, cpu_role);
 
 	shadow_mmu_init_context(vcpu, context, cpu_role, mmu_role);
 	reset_shadow_zero_bits_mask(vcpu, context, is_efer_nx(context));
@@ -4866,7 +4865,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 	if (new_role.as_u64 != context->cpu_role.as_u64) {
 		/* EPT, and thus nested EPT, does not consume CR0, CR4, nor EFER. */
 		context->cpu_role.as_u64 = new_role.as_u64;
-		context->mmu_role.as_u64 = new_role.as_u64;
+		context->mmu_role.word = new_role.base.word;
 
 		context->shadow_root_level = level;
 
@@ -4968,9 +4967,9 @@ void kvm_mmu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu->arch.root_mmu.cpu_role.base.level = 0;
 	vcpu->arch.guest_mmu.cpu_role.base.level = 0;
 	vcpu->arch.nested_mmu.cpu_role.base.level = 0;
-	vcpu->arch.root_mmu.mmu_role.base.level = 0;
-	vcpu->arch.guest_mmu.mmu_role.base.level = 0;
-	vcpu->arch.nested_mmu.mmu_role.base.level = 0;
+	vcpu->arch.root_mmu.mmu_role.level = 0;
+	vcpu->arch.guest_mmu.mmu_role.level = 0;
+	vcpu->arch.nested_mmu.mmu_role.level = 0;
 	kvm_mmu_reset_context(vcpu);
 
 	/*
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 1b5c7d03f94b..847c4339e4d9 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1025,7 +1025,7 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
  */
 static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 {
-	union kvm_mmu_page_role mmu_role = vcpu->arch.mmu->mmu_role.base;
+	union kvm_mmu_page_role mmu_role = vcpu->arch.mmu->mmu_role;
 	int i;
 	bool host_writable;
 	gpa_t first_pte_gpa;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 8def8f810cb0..dd4c78833016 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -209,7 +209,7 @@ static void tdp_mmu_init_child_sp(struct kvm_mmu_page *child_sp,
 
 hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 {
-	union kvm_mmu_page_role role = vcpu->arch.mmu->mmu_role.base;
+	union kvm_mmu_page_role role = vcpu->arch.mmu->mmu_role;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_page *root;
 
-- 
2.31.1


