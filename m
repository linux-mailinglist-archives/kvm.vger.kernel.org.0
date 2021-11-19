Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E99824579CE
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 00:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236501AbhKTABt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 19:01:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236152AbhKTABV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 19:01:21 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5AC8C06173E
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 15:58:18 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id pg9-20020a17090b1e0900b001a689204b52so7484114pjb.0
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 15:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bEq6kwsGlJixZVgAv3CUce1H9nK4ADw+62+7N53XAYs=;
        b=GKm3oFtEl/vKHCcbQsCpBhn9CrwXLXZPY7uYiR+Le8/eDyIr1HsVjvi/00exiiwOhF
         F1RhN25/KJRp2zP/+edLUlvK7i5hSlIWdtLGq8beOwPbLlsAc8+4UJeZ5BP6Ei7B8CFZ
         JUx2LZ/TwYYvWqjEvGTYHR87J3g3ihDTGMUa2nr4MO2FllPVgiIJeXhIBXB6t3yBphLT
         cwSFEHvv0Glh5Cbm5HflMIslN9iI8zAm66pJX4BHGVfbmvU0GDdPL14kAlcB7bJPTPfR
         Ew9kMW8ytp14yTU4eqizaGooQf2urkC+JBRmCAyMG+w7DqyiL8vzHVPQRoL2cpis+JD5
         mcog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bEq6kwsGlJixZVgAv3CUce1H9nK4ADw+62+7N53XAYs=;
        b=PsFYWi8X5bfAObifG3Ulq1peQ29laitSIgZ/U7HFAiOho1/g5I4FbqBaEe9CqjoKCy
         C9eTrcTSUMA/fHINGah8KGbrkrRO0ahD73FrOHDwLeawus7JL+foDO0rpaVuXg3pxMU+
         eJYRsIGDRUVnhgOGo602JvpWhO8H1AVjNMrOhi3bWkdf8R6Y884PiaIp737Wqy7ftYmR
         lD2Q3+DhWM58MkOKP6NrmboSyLldxJuDfwEOSNGlM3L1e5PVEb5yxcD5QY1wwWhK1qgv
         +UTqnuAXX9XZjPu8QxkbzbWKIgMtg6Q1cMmNIVBSaGFxUaPWXo9AKfiKziYB6ZqNyyzH
         pzmA==
X-Gm-Message-State: AOAM532hlxcQ4rYzowPkJaWgfIeYEvrHKV9Mmfu4jWiQaSWeA35cRFc+
        DtlftBZr7xeZFRj5OQF9n9vIR2BeVQprUA==
X-Google-Smtp-Source: ABdhPJx6WLjwzwkSIJDC2kZ6nBkzcxNQZJcUrSVxixUY4nlSMrmb42RaIGHplK/00Q5IzF7tCHhrRIAojt4p6A==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:615:: with SMTP id
 gb21mr4827648pjb.10.1637366298243; Fri, 19 Nov 2021 15:58:18 -0800 (PST)
Date:   Fri, 19 Nov 2021 23:57:49 +0000
In-Reply-To: <20211119235759.1304274-1-dmatlack@google.com>
Message-Id: <20211119235759.1304274-6-dmatlack@google.com>
Mime-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [RFC PATCH 05/15] KVM: x86/mmu: Abstract mmu caches out to a separate struct
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the kvm_mmu_memory_cache structs into a separate wrapper struct.
This is in preparation for eagerly splitting all large pages during
VM-ioctls (i.e. not in the vCPU fault path) which will require adding
kvm_mmu_memory_cache structs to struct kvm_arch.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/include/asm/kvm_host.h | 12 ++++---
 arch/x86/kvm/mmu/mmu.c          | 59 ++++++++++++++++++++++-----------
 arch/x86/kvm/mmu/tdp_mmu.c      |  7 ++--
 3 files changed, 52 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1fcb345bc107..2a7564703ea6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -612,6 +612,13 @@ struct kvm_vcpu_xen {
 	u64 runstate_times[4];
 };
 
+struct kvm_mmu_memory_caches {
+	struct kvm_mmu_memory_cache pte_list_desc_cache;
+	struct kvm_mmu_memory_cache shadow_page_cache;
+	struct kvm_mmu_memory_cache gfn_array_cache;
+	struct kvm_mmu_memory_cache page_header_cache;
+};
+
 struct kvm_vcpu_arch {
 	/*
 	 * rip and regs accesses must go through
@@ -681,10 +688,7 @@ struct kvm_vcpu_arch {
 	 */
 	struct kvm_mmu *walk_mmu;
 
-	struct kvm_mmu_memory_cache mmu_pte_list_desc_cache;
-	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
-	struct kvm_mmu_memory_cache mmu_gfn_array_cache;
-	struct kvm_mmu_memory_cache mmu_page_header_cache;
+	struct kvm_mmu_memory_caches mmu_caches;
 
 	/*
 	 * QEMU userspace and the guest each have their own FPU state.
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1146f87044a6..537952574211 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -732,38 +732,60 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
 
 static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 {
+	struct kvm_mmu_memory_caches *mmu_caches;
 	int r;
 
+	mmu_caches = &vcpu->arch.mmu_caches;
+
 	/* 1 rmap, 1 parent PTE per level, and the prefetched rmaps. */
-	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
+	r = kvm_mmu_topup_memory_cache(&mmu_caches->pte_list_desc_cache,
 				       1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
 	if (r)
 		return r;
-	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
+	r = kvm_mmu_topup_memory_cache(&mmu_caches->shadow_page_cache,
 				       PT64_ROOT_MAX_LEVEL);
 	if (r)
 		return r;
 	if (maybe_indirect) {
-		r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_gfn_array_cache,
+		r = kvm_mmu_topup_memory_cache(&mmu_caches->gfn_array_cache,
 					       PT64_ROOT_MAX_LEVEL);
 		if (r)
 			return r;
 	}
-	return kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache,
+	return kvm_mmu_topup_memory_cache(&mmu_caches->page_header_cache,
 					  PT64_ROOT_MAX_LEVEL);
 }
 
 static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 {
-	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
-	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
-	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_gfn_array_cache);
-	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
+	struct kvm_mmu_memory_caches *mmu_caches;
+
+	mmu_caches = &vcpu->arch.mmu_caches;
+
+	kvm_mmu_free_memory_cache(&mmu_caches->pte_list_desc_cache);
+	kvm_mmu_free_memory_cache(&mmu_caches->shadow_page_cache);
+	kvm_mmu_free_memory_cache(&mmu_caches->gfn_array_cache);
+	kvm_mmu_free_memory_cache(&mmu_caches->page_header_cache);
+}
+
+static void mmu_init_memory_caches(struct kvm_mmu_memory_caches *caches)
+{
+	caches->pte_list_desc_cache.kmem_cache = pte_list_desc_cache;
+	caches->pte_list_desc_cache.gfp_zero = __GFP_ZERO;
+
+	caches->page_header_cache.kmem_cache = mmu_page_header_cache;
+	caches->page_header_cache.gfp_zero = __GFP_ZERO;
+
+	caches->shadow_page_cache.gfp_zero = __GFP_ZERO;
 }
 
 static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_vcpu *vcpu)
 {
-	return kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_pte_list_desc_cache);
+	struct kvm_mmu_memory_caches *mmu_caches;
+
+	mmu_caches = &vcpu->arch.mmu_caches;
+
+	return kvm_mmu_memory_cache_alloc(&mmu_caches->pte_list_desc_cache);
 }
 
 static void mmu_free_pte_list_desc(struct pte_list_desc *pte_list_desc)
@@ -1071,7 +1093,7 @@ static bool rmap_can_add(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu_memory_cache *mc;
 
-	mc = &vcpu->arch.mmu_pte_list_desc_cache;
+	mc = &vcpu->arch.mmu_caches.pte_list_desc_cache;
 	return kvm_mmu_memory_cache_nr_free_objects(mc);
 }
 
@@ -1742,12 +1764,15 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
 
 static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct)
 {
+	struct kvm_mmu_memory_caches *mmu_caches;
 	struct kvm_mmu_page *sp;
 
-	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
-	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
+	mmu_caches = &vcpu->arch.mmu_caches;
+
+	sp = kvm_mmu_memory_cache_alloc(&mmu_caches->page_header_cache);
+	sp->spt = kvm_mmu_memory_cache_alloc(&mmu_caches->shadow_page_cache);
 	if (!direct)
-		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
+		sp->gfns = kvm_mmu_memory_cache_alloc(&mmu_caches->gfn_array_cache);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
 	/*
@@ -5544,13 +5569,7 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 {
 	int ret;
 
-	vcpu->arch.mmu_pte_list_desc_cache.kmem_cache = pte_list_desc_cache;
-	vcpu->arch.mmu_pte_list_desc_cache.gfp_zero = __GFP_ZERO;
-
-	vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
-	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
-
-	vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
+	mmu_init_memory_caches(&vcpu->arch.mmu_caches);
 
 	vcpu->arch.mmu = &vcpu->arch.root_mmu;
 	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 9ee3f4f7fdf5..b70707a7fe87 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -175,10 +175,13 @@ static union kvm_mmu_page_role page_role_for_level(struct kvm_vcpu *vcpu,
 static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 					       int level)
 {
+	struct kvm_mmu_memory_caches *mmu_caches;
 	struct kvm_mmu_page *sp;
 
-	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
-	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
+	mmu_caches = &vcpu->arch.mmu_caches;
+
+	sp = kvm_mmu_memory_cache_alloc(&mmu_caches->page_header_cache);
+	sp->spt = kvm_mmu_memory_cache_alloc(&mmu_caches->shadow_page_cache);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
 	sp->role.word = page_role_for_level(vcpu, level).word;
-- 
2.34.0.rc2.393.gf8c9666880-goog

