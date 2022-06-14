Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F34FB54BE58
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 01:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351214AbiFNXeE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 19:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345904AbiFNXds (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 19:33:48 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9494D253
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 16:33:44 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id x1-20020a170902ec8100b0016634ff72a4so5569081plg.15
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 16:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Bv5QESz82k2xovFC3v5Zl2b+f4p4mhP9ynXaK4NEGVA=;
        b=nSQfZC+hVBY+WoIP6F2L3qJ0PfZuWs+9kcVlsWxwXVtDzxpO7ALXEjVp/dvBNWObe3
         mwBZbgQBbAVaGEfrgQBeZnre+sZMWqzM6aq+/pZhpKnHVxMwywwNmkosowbwKFcEuEE4
         ZdiPKltyakjzRaVtaoyTR1Tc4GmYqYjVnx4AB/dVUqNPB7W/LrAcrDw981LZ9atin58I
         wmPO2bV+FC/e4JfRNiyJFSC7Hc5fsbAelRyPa8ZgWdQrF1YGakby04X2G/PCI2Y/Nsw2
         gT8PRFutaRJmriZNezl5q0HRD6s+/Sn8wWvE29Z90RvKoCL622xCo9U6IUtgql5DerCT
         cyZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Bv5QESz82k2xovFC3v5Zl2b+f4p4mhP9ynXaK4NEGVA=;
        b=fh4XShEcG7kePHM67TKtD58Nm0Ud6EmUKv5h+bbWk6SzQqHR1KxD86GnzcDFU3Z7Ys
         kUnptqpIUrnzL+I5hBLv93gscOFxdHfhoXB0VQbKIWQ/MLzKWtZVG8Wu5fqIKVchyJOy
         5Tca9s1JGlhmdPaKWGoOqkl/5EZVb8OUPQEcSnzvbIYrRisxyfTX5OOx8W7tlK/7azK8
         J6Pho9fbzhh9LneiVzsCfRizM6IfqAUIbrtcz7Z7XqU84oKLTWduKVhkLKKxdARy3XjA
         cd+n1QV2IOgCWkIuM/Gv1ssOtIsil0uYjQBF1b3q/lsEp1wwAbvf5W4Blmqjyes9qjO1
         jz6A==
X-Gm-Message-State: AJIora/xsi7mB3pNPfxtxo7rI84VlWzAg3+SpnWOMN9kii9sKB2OCJGQ
        lePQNDL3ejlq0R6YWRUdG1DKnIb0q2w=
X-Google-Smtp-Source: ABdhPJyuzKNG3rHlQSwU2tyJl0qY7vPujbz8Fibp766foiNpQKaBo9RBVx/XcENdnXzDiwueAwqDxClTMRg=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:ab15:b0:168:def9:5aa0 with SMTP id
 ik21-20020a170902ab1500b00168def95aa0mr6887101plb.28.1655249624182; Tue, 14
 Jun 2022 16:33:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 23:33:25 +0000
In-Reply-To: <20220614233328.3896033-1-seanjc@google.com>
Message-Id: <20220614233328.3896033-6-seanjc@google.com>
Mime-Version: 1.0
References: <20220614233328.3896033-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 5/8] KVM: x86/mmu: Use separate namespaces for guest PTEs
 and shadow PTEs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Separate the macros for KVM's shadow PTEs (SPTE) from guest 64-bit PTEs
(PT64).  SPTE and PT64 are _mostly_ the same, but the few differences are
quite critical, e.g. *_BASE_ADDR_MASK must differentiate between host and
guest physical address spaces, and SPTE_PERM_MASK (was PT64_PERM_MASK) is
very much specific to SPTEs.

Opportunistically (and temporarily) move most guest macros into paging.h
to clearly associate them with shadow paging, and to ensure that they're
not used as of this commit.  A future patch will eliminate them entirely.

Sadly, PT32_LEVEL_BITS is left behind in mmu_internal.h because it's
needed for the quadrant calculation in kvm_mmu_get_page().  The quadrant
calculation is hot enough (when using shadow paging with 32-bit guests)
that adding a per-context helper is undesirable, and burying the
computation in paging_tmpl.h with a forward declaration isn't exactly an
improvement.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu.h              |  5 ----
 arch/x86/kvm/mmu/mmu.c          | 44 +++++++++++----------------------
 arch/x86/kvm/mmu/mmu_internal.h |  3 +++
 arch/x86/kvm/mmu/paging.h       | 17 +++++++++++++
 arch/x86/kvm/mmu/paging_tmpl.h  |  4 +--
 arch/x86/kvm/mmu/spte.c         |  2 +-
 arch/x86/kvm/mmu/spte.h         | 27 +++++++++-----------
 arch/x86/kvm/mmu/tdp_iter.c     |  6 ++---
 arch/x86/kvm/mmu/tdp_mmu.c      |  6 ++---
 9 files changed, 56 insertions(+), 58 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 6efe6bd7fb6e..a99acec925eb 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -6,11 +6,6 @@
 #include "kvm_cache_regs.h"
 #include "cpuid.h"
 
-#define PT64_PT_BITS 9
-#define PT64_ENT_PER_PAGE __PT_ENT_PER_PAGE(PT64_PT_BITS)
-#define PT32_PT_BITS 10
-#define PT32_ENT_PER_PAGE __PT_ENT_PER_PAGE(PT32_PT_BITS)
-
 #define PT_WRITABLE_SHIFT 1
 #define PT_USER_SHIFT 2
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b3edff05a53a..81f2e58dc85b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -111,20 +111,6 @@ module_param(dbg, bool, 0644);
 
 #define PTE_PREFETCH_NUM		8
 
-#define PT32_LEVEL_BITS 10
-
-#define PT32_LEVEL_SHIFT(level) __PT_LEVEL_SHIFT(level, PT32_LEVEL_BITS)
-
-#define PT32_LVL_OFFSET_MASK(level) \
-	__PT_LVL_OFFSET_MASK(PT32_BASE_ADDR_MASK, level, PT32_LEVEL_BITS)
-
-#define PT32_INDEX(address, level) __PT_INDEX(address, level, PT32_LEVEL_BITS)
-
-#define PT32_BASE_ADDR_MASK PAGE_MASK
-
-#define PT32_LVL_ADDR_MASK(level) \
-	__PT_LVL_ADDR_MASK(PT32_BASE_ADDR_MASK, level, PT32_LEVEL_BITS)
-
 #include <trace/events/kvm.h>
 
 /* make pte_list_desc fit well in cache lines */
@@ -704,7 +690,7 @@ static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
 	if (!sp->role.direct)
 		return sp->gfns[index];
 
-	return sp->gfn + (index << ((sp->role.level - 1) * PT64_LEVEL_BITS));
+	return sp->gfn + (index << ((sp->role.level - 1) * SPTE_LEVEL_BITS));
 }
 
 static void kvm_mmu_page_set_gfn(struct kvm_mmu_page *sp, int index, gfn_t gfn)
@@ -1776,7 +1762,7 @@ static int __mmu_unsync_walk(struct kvm_mmu_page *sp,
 			continue;
 		}
 
-		child = to_shadow_page(ent & PT64_BASE_ADDR_MASK);
+		child = to_shadow_page(ent & SPTE_BASE_ADDR_MASK);
 
 		if (child->unsync_children) {
 			if (mmu_pages_add(pvec, child, i))
@@ -2027,8 +2013,8 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	role.direct = direct;
 	role.access = access;
 	if (role.has_4_byte_gpte) {
-		quadrant = gaddr >> (PAGE_SHIFT + (PT64_PT_BITS * level));
-		quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
+		quadrant = gaddr >> (PAGE_SHIFT + (SPTE_LEVEL_BITS * level));
+		quadrant &= (1 << ((PT32_LEVEL_BITS - SPTE_LEVEL_BITS) * level)) - 1;
 		role.quadrant = quadrant;
 	}
 	if (level <= vcpu->arch.mmu->cpu_role.base.level)
@@ -2132,7 +2118,7 @@ static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterato
 
 		iterator->shadow_addr
 			= vcpu->arch.mmu->pae_root[(addr >> 30) & 3];
-		iterator->shadow_addr &= PT64_BASE_ADDR_MASK;
+		iterator->shadow_addr &= SPTE_BASE_ADDR_MASK;
 		--iterator->level;
 		if (!iterator->shadow_addr)
 			iterator->level = 0;
@@ -2151,7 +2137,7 @@ static bool shadow_walk_okay(struct kvm_shadow_walk_iterator *iterator)
 	if (iterator->level < PG_LEVEL_4K)
 		return false;
 
-	iterator->index = SHADOW_PT_INDEX(iterator->addr, iterator->level);
+	iterator->index = SPTE_INDEX(iterator->addr, iterator->level);
 	iterator->sptep	= ((u64 *)__va(iterator->shadow_addr)) + iterator->index;
 	return true;
 }
@@ -2164,7 +2150,7 @@ static void __shadow_walk_next(struct kvm_shadow_walk_iterator *iterator,
 		return;
 	}
 
-	iterator->shadow_addr = spte & PT64_BASE_ADDR_MASK;
+	iterator->shadow_addr = spte & SPTE_BASE_ADDR_MASK;
 	--iterator->level;
 }
 
@@ -2203,7 +2189,7 @@ static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		 * so we should update the spte at this point to get
 		 * a new sp with the correct access.
 		 */
-		child = to_shadow_page(*sptep & PT64_BASE_ADDR_MASK);
+		child = to_shadow_page(*sptep & SPTE_BASE_ADDR_MASK);
 		if (child->role.access == direct_access)
 			return;
 
@@ -2224,7 +2210,7 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
 		if (is_last_spte(pte, sp->role.level)) {
 			drop_spte(kvm, spte);
 		} else {
-			child = to_shadow_page(pte & PT64_BASE_ADDR_MASK);
+			child = to_shadow_page(pte & SPTE_BASE_ADDR_MASK);
 			drop_parent_pte(child, spte);
 
 			/*
@@ -2250,7 +2236,7 @@ static int kvm_mmu_page_unlink_children(struct kvm *kvm,
 	int zapped = 0;
 	unsigned i;
 
-	for (i = 0; i < PT64_ENT_PER_PAGE; ++i)
+	for (i = 0; i < SPTE_ENT_PER_PAGE; ++i)
 		zapped += mmu_page_zap_pte(kvm, sp, sp->spt + i, invalid_list);
 
 	return zapped;
@@ -2663,7 +2649,7 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 			struct kvm_mmu_page *child;
 			u64 pte = *sptep;
 
-			child = to_shadow_page(pte & PT64_BASE_ADDR_MASK);
+			child = to_shadow_page(pte & SPTE_BASE_ADDR_MASK);
 			drop_parent_pte(child, sptep);
 			flush = true;
 		} else if (pfn != spte_to_pfn(*sptep)) {
@@ -3252,7 +3238,7 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
 	if (!VALID_PAGE(*root_hpa))
 		return;
 
-	sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
+	sp = to_shadow_page(*root_hpa & SPTE_BASE_ADDR_MASK);
 	if (WARN_ON(!sp))
 		return;
 
@@ -3724,7 +3710,7 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 		hpa_t root = vcpu->arch.mmu->pae_root[i];
 
 		if (IS_VALID_PAE_ROOT(root)) {
-			root &= PT64_BASE_ADDR_MASK;
+			root &= SPTE_BASE_ADDR_MASK;
 			sp = to_shadow_page(root);
 			mmu_sync_children(vcpu, sp, true);
 		}
@@ -5186,11 +5172,11 @@ static bool need_remote_flush(u64 old, u64 new)
 		return false;
 	if (!is_shadow_present_pte(new))
 		return true;
-	if ((old ^ new) & PT64_BASE_ADDR_MASK)
+	if ((old ^ new) & SPTE_BASE_ADDR_MASK)
 		return true;
 	old ^= shadow_nx_mask;
 	new ^= shadow_nx_mask;
-	return (old & ~new & PT64_PERM_MASK) != 0;
+	return (old & ~new & SPTE_PERM_MASK) != 0;
 }
 
 static u64 mmu_pte_write_fetch_gpte(struct kvm_vcpu *vcpu, gpa_t *gpa,
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 5e1e3c8f8aaa..cb9d4d358335 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -20,6 +20,9 @@ extern bool dbg;
 #define MMU_WARN_ON(x) do { } while (0)
 #endif
 
+/* The number of bits for 32-bit PTEs is to needed compute the quandrant. */
+#define PT32_LEVEL_BITS 10
+
 /* Page table builder macros common to shadow (host) PTEs and guest PTEs. */
 #define __PT_LEVEL_SHIFT(level, bits_per_level)	\
 	(PAGE_SHIFT + ((level) - 1) * (bits_per_level))
diff --git a/arch/x86/kvm/mmu/paging.h b/arch/x86/kvm/mmu/paging.h
index 23f3f64b8092..6a63727cc7e8 100644
--- a/arch/x86/kvm/mmu/paging.h
+++ b/arch/x86/kvm/mmu/paging.h
@@ -5,11 +5,28 @@
 
 #define GUEST_PT64_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
 
+#define PT64_LEVEL_BITS 9
+
+#define PT64_INDEX(address, level) __PT_INDEX(address, level, PT64_LEVEL_BITS)
+
 #define PT64_LVL_ADDR_MASK(level) \
 	__PT_LVL_ADDR_MASK(GUEST_PT64_BASE_ADDR_MASK, level, PT64_LEVEL_BITS)
 
 #define PT64_LVL_OFFSET_MASK(level) \
 	__PT_LVL_OFFSET_MASK(GUEST_PT64_BASE_ADDR_MASK, level, PT64_LEVEL_BITS)
 
+
+#define PT32_LEVEL_SHIFT(level) __PT_LEVEL_SHIFT(level, PT32_LEVEL_BITS)
+
+#define PT32_LVL_OFFSET_MASK(level) \
+	__PT_LVL_OFFSET_MASK(PT32_BASE_ADDR_MASK, level, PT32_LEVEL_BITS)
+
+#define PT32_INDEX(address, level) __PT_INDEX(address, level, PT32_LEVEL_BITS)
+
+#define PT32_BASE_ADDR_MASK PAGE_MASK
+
+#define PT32_LVL_ADDR_MASK(level) \
+	__PT_LVL_ADDR_MASK(PT32_BASE_ADDR_MASK, level, PT32_LEVEL_BITS)
+
 #endif /* __KVM_X86_PAGING_H */
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 55fd35b1b227..d68cc7a5ef81 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -899,7 +899,7 @@ static gpa_t FNAME(get_level1_sp_gpa)(struct kvm_mmu_page *sp)
 	WARN_ON(sp->role.level != PG_LEVEL_4K);
 
 	if (PTTYPE == 32)
-		offset = sp->role.quadrant << PT64_LEVEL_BITS;
+		offset = sp->role.quadrant << SPTE_LEVEL_BITS;
 
 	return gfn_to_gpa(sp->gfn) + offset * sizeof(pt_element_t);
 }
@@ -1034,7 +1034,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 
 	first_pte_gpa = FNAME(get_level1_sp_gpa)(sp);
 
-	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
+	for (i = 0; i < SPTE_ENT_PER_PAGE; i++) {
 		u64 *sptep, spte;
 		struct kvm_memory_slot *slot;
 		unsigned pte_access;
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index cda1851ec155..242e4828d7df 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -301,7 +301,7 @@ u64 kvm_mmu_changed_pte_notifier_make_spte(u64 old_spte, kvm_pfn_t new_pfn)
 {
 	u64 new_spte;
 
-	new_spte = old_spte & ~PT64_BASE_ADDR_MASK;
+	new_spte = old_spte & ~SPTE_BASE_ADDR_MASK;
 	new_spte |= (u64)new_pfn << PAGE_SHIFT;
 
 	new_spte &= ~PT_WRITABLE_MASK;
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index d5a8183b7232..121c5eaaec77 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -36,12 +36,12 @@ extern bool __read_mostly enable_mmio_caching;
 static_assert(SPTE_TDP_AD_ENABLED_MASK == 0);
 
 #ifdef CONFIG_DYNAMIC_PHYSICAL_MASK
-#define PT64_BASE_ADDR_MASK (physical_mask & ~(u64)(PAGE_SIZE-1))
+#define SPTE_BASE_ADDR_MASK (physical_mask & ~(u64)(PAGE_SIZE-1))
 #else
-#define PT64_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
+#define SPTE_BASE_ADDR_MASK (((1ULL << 52) - 1) & ~(u64)(PAGE_SIZE-1))
 #endif
 
-#define PT64_PERM_MASK (PT_PRESENT_MASK | PT_WRITABLE_MASK | shadow_user_mask \
+#define SPTE_PERM_MASK (PT_PRESENT_MASK | PT_WRITABLE_MASK | shadow_user_mask \
 			| shadow_x_mask | shadow_nx_mask | shadow_me_mask)
 
 #define ACC_EXEC_MASK    1
@@ -50,16 +50,13 @@ static_assert(SPTE_TDP_AD_ENABLED_MASK == 0);
 #define ACC_ALL          (ACC_EXEC_MASK | ACC_WRITE_MASK | ACC_USER_MASK)
 
 /* The mask for the R/X bits in EPT PTEs */
-#define PT64_EPT_READABLE_MASK			0x1ull
-#define PT64_EPT_EXECUTABLE_MASK		0x4ull
+#define SPTE_EPT_READABLE_MASK			0x1ull
+#define SPTE_EPT_EXECUTABLE_MASK		0x4ull
 
-#define PT64_LEVEL_BITS 9
-
-#define PT64_LEVEL_SHIFT(level) __PT_LEVEL_SHIFT(level, PT64_LEVEL_BITS)
-
-#define PT64_INDEX(address, level) __PT_INDEX(address, level, PT64_LEVEL_BITS)
-
-#define SHADOW_PT_INDEX(addr, level) PT64_INDEX(addr, level)
+#define SPTE_LEVEL_BITS			9
+#define SPTE_LEVEL_SHIFT(level)		__PT_LEVEL_SHIFT(level, SPTE_LEVEL_BITS)
+#define SPTE_INDEX(address, level)	__PT_INDEX(address, level, SPTE_LEVEL_BITS)
+#define SPTE_ENT_PER_PAGE		__PT_ENT_PER_PAGE(SPTE_LEVEL_BITS)
 
 /*
  * The mask/shift to use for saving the original R/X bits when marking the PTE
@@ -68,8 +65,8 @@ static_assert(SPTE_TDP_AD_ENABLED_MASK == 0);
  * restored only when a write is attempted to the page.  This mask obviously
  * must not overlap the A/D type mask.
  */
-#define SHADOW_ACC_TRACK_SAVED_BITS_MASK (PT64_EPT_READABLE_MASK | \
-					  PT64_EPT_EXECUTABLE_MASK)
+#define SHADOW_ACC_TRACK_SAVED_BITS_MASK (SPTE_EPT_READABLE_MASK | \
+					  SPTE_EPT_EXECUTABLE_MASK)
 #define SHADOW_ACC_TRACK_SAVED_BITS_SHIFT 54
 #define SHADOW_ACC_TRACK_SAVED_MASK	(SHADOW_ACC_TRACK_SAVED_BITS_MASK << \
 					 SHADOW_ACC_TRACK_SAVED_BITS_SHIFT)
@@ -281,7 +278,7 @@ static inline bool is_executable_pte(u64 spte)
 
 static inline kvm_pfn_t spte_to_pfn(u64 pte)
 {
-	return (pte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
+	return (pte & SPTE_BASE_ADDR_MASK) >> PAGE_SHIFT;
 }
 
 static inline bool is_accessed_spte(u64 spte)
diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index ee4802d7b36c..9c65a64a56d9 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -11,7 +11,7 @@
 static void tdp_iter_refresh_sptep(struct tdp_iter *iter)
 {
 	iter->sptep = iter->pt_path[iter->level - 1] +
-		SHADOW_PT_INDEX(iter->gfn << PAGE_SHIFT, iter->level);
+		SPTE_INDEX(iter->gfn << PAGE_SHIFT, iter->level);
 	iter->old_spte = kvm_tdp_mmu_read_spte(iter->sptep);
 }
 
@@ -116,8 +116,8 @@ static bool try_step_side(struct tdp_iter *iter)
 	 * Check if the iterator is already at the end of the current page
 	 * table.
 	 */
-	if (SHADOW_PT_INDEX(iter->gfn << PAGE_SHIFT, iter->level) ==
-            (PT64_ENT_PER_PAGE - 1))
+	if (SPTE_INDEX(iter->gfn << PAGE_SHIFT, iter->level) ==
+	    (SPTE_ENT_PER_PAGE - 1))
 		return false;
 
 	iter->gfn += KVM_PAGES_PER_HPAGE(iter->level);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7b9265d67131..26cb9fed2f18 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -425,7 +425,7 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 
 	tdp_mmu_unlink_sp(kvm, sp, shared);
 
-	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
+	for (i = 0; i < SPTE_ENT_PER_PAGE; i++) {
 		tdp_ptep_t sptep = pt + i;
 		gfn_t gfn = base_gfn + i * KVM_PAGES_PER_HPAGE(level);
 		u64 old_spte;
@@ -1487,7 +1487,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 	 * No need for atomics when writing to sp->spt since the page table has
 	 * not been linked in yet and thus is not reachable from any other CPU.
 	 */
-	for (i = 0; i < PT64_ENT_PER_PAGE; i++)
+	for (i = 0; i < SPTE_ENT_PER_PAGE; i++)
 		sp->spt[i] = make_huge_page_split_spte(huge_spte, level, i);
 
 	/*
@@ -1507,7 +1507,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 	 * are overwriting from the page stats. But we have to manually update
 	 * the page stats with the new present child pages.
 	 */
-	kvm_update_page_stats(kvm, level - 1, PT64_ENT_PER_PAGE);
+	kvm_update_page_stats(kvm, level - 1, SPTE_ENT_PER_PAGE);
 
 out:
 	trace_kvm_mmu_split_huge_page(iter->gfn, huge_spte, level, ret);
-- 
2.36.1.476.g0c4daa206d-goog

