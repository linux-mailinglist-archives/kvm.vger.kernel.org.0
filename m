Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E61473524C1
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 02:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234201AbhDBA5K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 20:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234069AbhDBA5G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 20:57:06 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38CD0C06178C
        for <kvm@vger.kernel.org>; Thu,  1 Apr 2021 17:57:06 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id h134so4911966qke.1
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 17:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=cER1R/dfFtJjfhbrNzOyLV9RRl0KhAMFTqRfmNRSD/k=;
        b=ZEPo10A/i5CuK8Z7a3kFvJAVebClAmO1nr7bsFWBFhyT1y63s6sVcIDp9HPfiGzcrE
         u8KySeZmzirnyGQvb78/ORRpezMt/5dSJN1qvOHxoh25TUTPQdwOdzvInJgbCDQQ64mP
         Ah24+JFERvRlpVbxMPQdVSmzKh7oZ1iQD7Bia49W1pVT8BgOOKi+f1F4M6HCBH9esSp7
         gDp3wYD+bIhpqb5rCM0q7IXFx3ATCu8BnCvhUuTZHOmjh5MtcMA4FxdD4XcXrj9f0+KA
         jlkbJaUSMcDs5bHAkhIk2+Qh6tcl6iY+1Dbj6Ds+OGY184gsk9HFn8xjY86baHqxEVPl
         COlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=cER1R/dfFtJjfhbrNzOyLV9RRl0KhAMFTqRfmNRSD/k=;
        b=cqMATFmvtSj1MLNXBUMPmZYpWm+zDrmaN5f9fWj/03Nkok8O0ZUpneQuIgMyX8qKjy
         mRxcp2L3VVQseWFgjq2E/D/WEgiBrmidgzdkJ60HR5tlz/ps1ECaxqE/el7hjZ9qM++k
         ozDO4pDXMMYMyBXl0mPgl5tNnaXMA+ncAseIlUB4N8XRoghLDa1hdF/Rrqfh+mpfptWv
         BDBUDVR/Xq4JEBXW113yZVq6yF4z0p80O2LkPqjtSws9Cb1kKZu9bSN8R/RQVwqilOIV
         Vwcdg54vRnXiZyWDmKBukTMR6pxsaw8pbZMHSZqT+VNCQMKoTZgPkAtjYKmP8NG/8rAY
         /BBg==
X-Gm-Message-State: AOAM5308rnUKXV/gCO3BldLa3q4MT3lDAZoaXGMCloQXaOF/nCBLXxL7
        gxUmXXmhXOwcO1ir2QrZ202jPc4V8GY=
X-Google-Smtp-Source: ABdhPJxSY74pPU7B3D8hY/M1SCeH0HWvtjWfkbAtwD6kT5NPWxOt3yk7it8vs6KdBSxeSSKkBFECBYQuN8k=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:c0b4:8b8:bb34:6a56])
 (user=seanjc job=sendgmr) by 2002:ad4:4692:: with SMTP id bq18mr11010805qvb.0.1617325025366;
 Thu, 01 Apr 2021 17:57:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  1 Apr 2021 17:56:50 -0700
In-Reply-To: <20210402005658.3024832-1-seanjc@google.com>
Message-Id: <20210402005658.3024832-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210402005658.3024832-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 02/10] KVM: Move x86's MMU notifier memslot walkers to
 generic code
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the hva->gfn lookup for MMU notifiers into common code.  Every arch
does a similar lookup, and some arch code is all but identical across
multiple architectures.

In addition to consolidating code, this will allow introducing
optimizations that will benefit all architectures without incurring
multiple walks of the memslots, e.g. by taking mmu_lock if and only if a
relevant range exists in the memslots.

The use of __always_inline to avoid indirect call retpolines, as done by
x86, may also benefit other architectures.

Consolidating the lookups also fixes a wart in x86, where the legacy MMU
and TDP MMU each do their own memslot walks.

Lastly, future enhancements to the memslot implementation, e.g. to add an
interval tree to track host address, will need to touch far less arch
specific code.

MIPS, PPC, and arm64 will be converted one at a time in future patches.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |   1 +
 arch/x86/kvm/mmu/mmu.c          | 127 +++++++----------
 arch/x86/kvm/mmu/tdp_mmu.c      | 241 ++++++++++++--------------------
 arch/x86/kvm/mmu/tdp_mmu.h      |  14 +-
 include/linux/kvm_host.h        |  14 ++
 virt/kvm/kvm_main.c             | 169 +++++++++++++++++++++-
 6 files changed, 317 insertions(+), 249 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 99778ac51243..a21e3698f4dc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1718,6 +1718,7 @@ asmlinkage void kvm_spurious_fault(void);
 	_ASM_EXTABLE(666b, 667b)
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
+#define KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
 
 int kvm_cpu_has_injectable_intr(struct kvm_vcpu *v);
 int kvm_cpu_has_interrupt(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index efb41f31e80a..f2046c41eb93 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1298,26 +1298,25 @@ static bool kvm_zap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 	return flush;
 }
 
-static int kvm_unmap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-			   struct kvm_memory_slot *slot, gfn_t gfn, int level,
-			   unsigned long data)
+static bool kvm_unmap_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
+			    struct kvm_memory_slot *slot, gfn_t gfn, int level,
+			    pte_t unused)
 {
 	return kvm_zap_rmapp(kvm, rmap_head, slot);
 }
 
-static int kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-			     struct kvm_memory_slot *slot, gfn_t gfn, int level,
-			     unsigned long data)
+static bool kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
+			      struct kvm_memory_slot *slot, gfn_t gfn, int level,
+			      pte_t pte)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
 	int need_flush = 0;
 	u64 new_spte;
-	pte_t *ptep = (pte_t *)data;
 	kvm_pfn_t new_pfn;
 
-	WARN_ON(pte_huge(*ptep));
-	new_pfn = pte_pfn(*ptep);
+	WARN_ON(pte_huge(pte));
+	new_pfn = pte_pfn(pte);
 
 restart:
 	for_each_rmap_spte(rmap_head, &iter, sptep) {
@@ -1326,7 +1325,7 @@ static int kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 
 		need_flush = 1;
 
-		if (pte_write(*ptep)) {
+		if (pte_write(pte)) {
 			pte_list_remove(rmap_head, sptep);
 			goto restart;
 		} else {
@@ -1414,86 +1413,52 @@ static void slot_rmap_walk_next(struct slot_rmap_walk_iterator *iterator)
 	     slot_rmap_walk_okay(_iter_);				\
 	     slot_rmap_walk_next(_iter_))
 
-typedef int (*rmap_handler_t)(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-			      struct kvm_memory_slot *slot, gfn_t gfn,
-			      int level, unsigned long data);
+typedef bool (*rmap_handler_t)(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
+			       struct kvm_memory_slot *slot, gfn_t gfn,
+			       int level, pte_t pte);
 
-static __always_inline int kvm_handle_hva_range(struct kvm *kvm,
-						unsigned long start,
-						unsigned long end,
-						unsigned long data,
-						rmap_handler_t handler)
+static __always_inline bool kvm_handle_gfn_range(struct kvm *kvm,
+						 struct kvm_gfn_range *range,
+						 rmap_handler_t handler)
 {
-	struct kvm_memslots *slots;
-	struct kvm_memory_slot *memslot;
 	struct slot_rmap_walk_iterator iterator;
-	int ret = 0;
-	int i;
+	bool ret = false;
 
-	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
-		slots = __kvm_memslots(kvm, i);
-		kvm_for_each_memslot(memslot, slots) {
-			unsigned long hva_start, hva_end;
-			gfn_t gfn_start, gfn_end;
-
-			hva_start = max(start, memslot->userspace_addr);
-			hva_end = min(end, memslot->userspace_addr +
-				      (memslot->npages << PAGE_SHIFT));
-			if (hva_start >= hva_end)
-				continue;
-			/*
-			 * {gfn(page) | page intersects with [hva_start, hva_end)} =
-			 * {gfn_start, gfn_start+1, ..., gfn_end-1}.
-			 */
-			gfn_start = hva_to_gfn_memslot(hva_start, memslot);
-			gfn_end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, memslot);
-
-			for_each_slot_rmap_range(memslot, PG_LEVEL_4K,
-						 KVM_MAX_HUGEPAGE_LEVEL,
-						 gfn_start, gfn_end - 1,
-						 &iterator)
-				ret |= handler(kvm, iterator.rmap, memslot,
-					       iterator.gfn, iterator.level, data);
-		}
-	}
+	for_each_slot_rmap_range(range->slot, PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL,
+				 range->start, range->end - 1, &iterator)
+		ret |= handler(kvm, iterator.rmap, range->slot, iterator.gfn,
+			       iterator.level, range->pte);
 
 	return ret;
 }
 
-static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
-			  unsigned long data, rmap_handler_t handler)
+bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	return kvm_handle_hva_range(kvm, hva, hva + 1, data, handler);
-}
-
-int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
-			unsigned flags)
-{
-	int r;
+	bool flush;
 
-	r = kvm_handle_hva_range(kvm, start, end, 0, kvm_unmap_rmapp);
+	flush = kvm_handle_gfn_range(kvm, range, kvm_unmap_rmapp);
 
 	if (is_tdp_mmu_enabled(kvm))
-		r |= kvm_tdp_mmu_zap_hva_range(kvm, start, end);
+		flush |= kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
 
-	return r;
+	return flush;
 }
 
-int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
+bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	int r;
+	bool flush;
 
-	r = kvm_handle_hva(kvm, hva, (unsigned long)&pte, kvm_set_pte_rmapp);
+	flush = kvm_handle_gfn_range(kvm, range, kvm_set_pte_rmapp);
 
 	if (is_tdp_mmu_enabled(kvm))
-		r |= kvm_tdp_mmu_set_spte_hva(kvm, hva, &pte);
+		flush |= kvm_tdp_mmu_set_spte_gfn(kvm, range);
 
-	return r;
+	return flush;
 }
 
-static int kvm_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-			 struct kvm_memory_slot *slot, gfn_t gfn, int level,
-			 unsigned long data)
+static bool kvm_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
+			  struct kvm_memory_slot *slot, gfn_t gfn, int level,
+			  pte_t unused)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
@@ -1505,9 +1470,9 @@ static int kvm_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 	return young;
 }
 
-static int kvm_test_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-			      struct kvm_memory_slot *slot, gfn_t gfn,
-			      int level, unsigned long data)
+static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
+			       struct kvm_memory_slot *slot, gfn_t gfn,
+			       int level, pte_t unused)
 {
 	u64 *sptep;
 	struct rmap_iterator iter;
@@ -1529,29 +1494,31 @@ static void rmap_recycle(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
 
 	rmap_head = gfn_to_rmap(vcpu->kvm, gfn, sp);
 
-	kvm_unmap_rmapp(vcpu->kvm, rmap_head, NULL, gfn, sp->role.level, 0);
+	kvm_unmap_rmapp(vcpu->kvm, rmap_head, NULL, gfn, sp->role.level, __pte(0));
 	kvm_flush_remote_tlbs_with_address(vcpu->kvm, sp->gfn,
 			KVM_PAGES_PER_HPAGE(sp->role.level));
 }
 
-int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
+bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	int young = false;
+	bool young;
+
+	young = kvm_handle_gfn_range(kvm, range, kvm_age_rmapp);
 
-	young = kvm_handle_hva_range(kvm, start, end, 0, kvm_age_rmapp);
 	if (is_tdp_mmu_enabled(kvm))
-		young |= kvm_tdp_mmu_age_hva_range(kvm, start, end);
+		young |= kvm_tdp_mmu_age_gfn_range(kvm, range);
 
 	return young;
 }
 
-int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
+bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	int young = false;
+	bool young;
+
+	young = kvm_handle_gfn_range(kvm, range, kvm_test_age_rmapp);
 
-	young = kvm_handle_hva(kvm, hva, 0, kvm_test_age_rmapp);
 	if (is_tdp_mmu_enabled(kvm))
-		young |= kvm_tdp_mmu_test_age_hva(kvm, hva);
+		young |= kvm_tdp_mmu_test_age_gfn(kvm, range);
 
 	return young;
 }
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index eeb644d2eb6f..7797d24f0937 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -878,142 +878,118 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	return ret;
 }
 
-typedef int (*tdp_handler_t)(struct kvm *kvm, struct kvm_memory_slot *slot,
-			     struct kvm_mmu_page *root, gfn_t start, gfn_t end,
-			     unsigned long data);
-
-static __always_inline int kvm_tdp_mmu_handle_hva_range(struct kvm *kvm,
-							unsigned long start,
-							unsigned long end,
-							unsigned long data,
-							tdp_handler_t handler)
+bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
+				 bool flush)
 {
-	struct kvm_memslots *slots;
-	struct kvm_memory_slot *memslot;
 	struct kvm_mmu_page *root;
-	int ret = 0;
-	int as_id;
 
-	for (as_id = 0; as_id < KVM_ADDRESS_SPACE_NUM; as_id++) {
-		for_each_tdp_mmu_root_yield_safe(kvm, root, as_id) {
-			slots = __kvm_memslots(kvm, as_id);
-			kvm_for_each_memslot(memslot, slots) {
-				unsigned long hva_start, hva_end;
-				gfn_t gfn_start, gfn_end;
+	for_each_tdp_mmu_root(kvm, root, range->slot->as_id)
+		flush |= zap_gfn_range(kvm, root, range->start, range->end,
+				       false, flush);
+
+	return flush;
+}
+
+typedef bool (*tdp_handler_t)(struct kvm *kvm, struct tdp_iter *iter,
+			      struct kvm_gfn_range *range);
+
+static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
+						   struct kvm_gfn_range *range,
+						   tdp_handler_t handler)
+{
+	struct kvm_mmu_page *root;
+	struct tdp_iter iter;
+	bool ret = false;
 
-				hva_start = max(start, memslot->userspace_addr);
-				hva_end = min(end, memslot->userspace_addr +
-					(memslot->npages << PAGE_SHIFT));
-				if (hva_start >= hva_end)
-					continue;
-				/*
-				 * {gfn(page) | page intersects with [hva_start, hva_end)} =
-				 * {gfn_start, gfn_start+1, ..., gfn_end-1}.
-				 */
-				gfn_start = hva_to_gfn_memslot(hva_start, memslot);
-				gfn_end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, memslot);
+	rcu_read_lock();
 
-				ret |= handler(kvm, memslot, root, gfn_start,
-					gfn_end, data);
-			}
-		}
+	for_each_tdp_mmu_root(kvm, root, range->slot->as_id) {
+		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end)
+			ret |= handler(kvm, &iter, range);
 	}
 
+	rcu_read_unlock();
+
 	return ret;
 }
 
-static __always_inline int kvm_tdp_mmu_handle_hva(struct kvm *kvm,
-						  unsigned long addr,
-						  unsigned long data,
-						  tdp_handler_t handler)
-{
-	return kvm_tdp_mmu_handle_hva_range(kvm, addr, addr + 1, data, handler);
-}
-
-static int zap_gfn_range_hva_wrapper(struct kvm *kvm,
-				     struct kvm_memory_slot *slot,
-				     struct kvm_mmu_page *root, gfn_t start,
-				     gfn_t end, unsigned long unused)
-{
-	return zap_gfn_range(kvm, root, start, end, false, false);
-}
-
-int kvm_tdp_mmu_zap_hva_range(struct kvm *kvm, unsigned long start,
-			      unsigned long end)
-{
-	return kvm_tdp_mmu_handle_hva_range(kvm, start, end, 0,
-					    zap_gfn_range_hva_wrapper);
-}
-
 /*
  * Mark the SPTEs range of GFNs [start, end) unaccessed and return non-zero
  * if any of the GFNs in the range have been accessed.
  */
-static int age_gfn_range(struct kvm *kvm, struct kvm_memory_slot *slot,
-			 struct kvm_mmu_page *root, gfn_t start, gfn_t end,
-			 unsigned long unused)
+static bool age_gfn_range(struct kvm *kvm, struct tdp_iter *iter,
+			  struct kvm_gfn_range *range)
 {
-	struct tdp_iter iter;
-	int young = 0;
-	u64 new_spte;
+	u64 new_spte = 0;
 
-	rcu_read_lock();
+	/* If we have a non-accessed entry we don't need to change the pte. */
+	if (!is_accessed_spte(iter->old_spte))
+		return false;
 
-	tdp_root_for_each_leaf_pte(iter, root, start, end) {
+	new_spte = iter->old_spte;
+
+	if (spte_ad_enabled(new_spte)) {
+		new_spte &= ~shadow_accessed_mask;
+	} else {
 		/*
-		 * If we have a non-accessed entry we don't need to change the
-		 * pte.
+		 * Capture the dirty status of the page, so that it doesn't get
+		 * lost when the SPTE is marked for access tracking.
 		 */
-		if (!is_accessed_spte(iter.old_spte))
-			continue;
-
-		new_spte = iter.old_spte;
-
-		if (spte_ad_enabled(new_spte)) {
-			new_spte &= ~shadow_accessed_mask;
-		} else {
-			/*
-			 * Capture the dirty status of the page, so that it doesn't get
-			 * lost when the SPTE is marked for access tracking.
-			 */
-			if (is_writable_pte(new_spte))
-				kvm_set_pfn_dirty(spte_to_pfn(new_spte));
-
-			new_spte = mark_spte_for_access_track(new_spte);
-		}
-
-		tdp_mmu_set_spte_no_acc_track(kvm, &iter, new_spte);
-		young = 1;
+		if (is_writable_pte(new_spte))
+			kvm_set_pfn_dirty(spte_to_pfn(new_spte));
+
+		new_spte = mark_spte_for_access_track(new_spte);
 	}
 
-	rcu_read_unlock();
+	tdp_mmu_set_spte_no_acc_track(kvm, iter, new_spte);
 
-	return young;
+	return true;
 }
 
-int kvm_tdp_mmu_age_hva_range(struct kvm *kvm, unsigned long start,
-			      unsigned long end)
+bool kvm_tdp_mmu_age_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	return kvm_tdp_mmu_handle_hva_range(kvm, start, end, 0,
-					    age_gfn_range);
+	return kvm_tdp_mmu_handle_gfn(kvm, range, age_gfn_range);
 }
 
-static int test_age_gfn(struct kvm *kvm, struct kvm_memory_slot *slot,
-			struct kvm_mmu_page *root, gfn_t gfn, gfn_t end,
-			unsigned long unused)
+static bool test_age_gfn(struct kvm *kvm, struct tdp_iter *iter,
+			 struct kvm_gfn_range *range)
 {
-	struct tdp_iter iter;
-
-	tdp_root_for_each_leaf_pte(iter, root, gfn, end)
-		if (is_accessed_spte(iter.old_spte))
-			return 1;
+	return is_accessed_spte(iter->old_spte);
+}
 
-	return 0;
+bool kvm_tdp_mmu_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	return kvm_tdp_mmu_handle_gfn(kvm, range, test_age_gfn);
 }
 
-int kvm_tdp_mmu_test_age_hva(struct kvm *kvm, unsigned long hva)
+static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
+			 struct kvm_gfn_range *range)
 {
-	return kvm_tdp_mmu_handle_hva(kvm, hva, 0, test_age_gfn);
+	u64 new_spte;
+
+	/* Huge pages aren't expected to be modified without first being zapped. */
+	WARN_ON(pte_huge(range->pte) || range->start + 1 != range->end);
+
+	if (iter->level != PG_LEVEL_4K ||
+	    !is_shadow_present_pte(iter->old_spte))
+		return false;
+
+	/*
+	 * Note, when changing a read-only SPTE, it's not strictly necessary to
+	 * zero the SPTE before setting the new PFN, but doing so preserves the
+	 * invariant that the PFN of a present * leaf SPTE can never change.
+	 * See __handle_changed_spte().
+	 */
+	tdp_mmu_set_spte(kvm, iter, 0);
+
+	if (!pte_write(range->pte)) {
+		new_spte = kvm_mmu_changed_pte_notifier_make_spte(iter->old_spte,
+								  pte_pfn(range->pte));
+
+		tdp_mmu_set_spte(kvm, iter, new_spte);
+	}
+
+	return true;
 }
 
 /*
@@ -1022,60 +998,15 @@ int kvm_tdp_mmu_test_age_hva(struct kvm *kvm, unsigned long hva)
  * notifier.
  * Returns non-zero if a flush is needed before releasing the MMU lock.
  */
-static int set_tdp_spte(struct kvm *kvm, struct kvm_memory_slot *slot,
-			struct kvm_mmu_page *root, gfn_t gfn, gfn_t end,
-			unsigned long data)
+bool kvm_tdp_mmu_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	struct tdp_iter iter;
-	pte_t *ptep = (pte_t *)data;
-	kvm_pfn_t new_pfn;
-	u64 new_spte;
-	int need_flush = 0;
+	bool flush = kvm_tdp_mmu_handle_gfn(kvm, range, set_spte_gfn);
 
-	rcu_read_lock();
+	/* FIXME: return 'flush' instead of flushing here. */
+	if (flush)
+		kvm_flush_remote_tlbs_with_address(kvm, range->start, 1);
 
-	WARN_ON(pte_huge(*ptep) || (gfn + 1) != end);
-
-	new_pfn = pte_pfn(*ptep);
-
-	tdp_root_for_each_leaf_pte(iter, root, gfn, gfn + 1) {
-		if (iter.level != PG_LEVEL_4K)
-			continue;
-
-		if (!is_shadow_present_pte(iter.old_spte))
-			break;
-
-		/*
-		 * Note, when changing a read-only SPTE, it's not strictly
-		 * necessary to zero the SPTE before setting the new PFN, but
-		 * doing so preserves the invariant that the PFN of a present
-		 * leaf SPTE can never change.  See __handle_changed_spte().
-		 */
-		tdp_mmu_set_spte(kvm, &iter, 0);
-
-		if (!pte_write(*ptep)) {
-			new_spte = kvm_mmu_changed_pte_notifier_make_spte(
-					iter.old_spte, new_pfn);
-
-			tdp_mmu_set_spte(kvm, &iter, new_spte);
-		}
-
-		need_flush = 1;
-	}
-
-	if (need_flush)
-		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
-
-	rcu_read_unlock();
-
-	return 0;
-}
-
-int kvm_tdp_mmu_set_spte_hva(struct kvm *kvm, unsigned long address,
-			     pte_t *host_ptep)
-{
-	return kvm_tdp_mmu_handle_hva(kvm, address, (unsigned long)host_ptep,
-				      set_tdp_spte);
+	return false;
 }
 
 /*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index bf3ce169122e..ee8efa58902f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -38,15 +38,11 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 		    int map_writable, int max_level, kvm_pfn_t pfn,
 		    bool prefault);
 
-int kvm_tdp_mmu_zap_hva_range(struct kvm *kvm, unsigned long start,
-			      unsigned long end);
-
-int kvm_tdp_mmu_age_hva_range(struct kvm *kvm, unsigned long start,
-			      unsigned long end);
-int kvm_tdp_mmu_test_age_hva(struct kvm *kvm, unsigned long hva);
-
-int kvm_tdp_mmu_set_spte_hva(struct kvm *kvm, unsigned long address,
-			     pte_t *host_ptep);
+bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
+				 bool flush);
+bool kvm_tdp_mmu_age_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
+bool kvm_tdp_mmu_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
+bool kvm_tdp_mmu_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
 
 bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
 			     int min_level);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e6d77353025c..e6bb401dd856 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -219,11 +219,25 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
 #endif
 
 #ifdef KVM_ARCH_WANT_MMU_NOTIFIER
+#ifdef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
+struct kvm_gfn_range {
+	struct kvm_memory_slot *slot;
+	gfn_t start;
+	gfn_t end;
+	pte_t pte;
+	bool may_block;
+};
+bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
+bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
+bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
+bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
+#else
 int kvm_unmap_hva_range(struct kvm *kvm,
 			unsigned long start, unsigned long end, unsigned flags);
 int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
 int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
 int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
+#endif /* KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS */
 #endif
 
 enum {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8df091950161..7a7e62ae5eb4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -451,14 +451,131 @@ static void kvm_mmu_notifier_invalidate_range(struct mmu_notifier *mn,
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
+#ifdef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
+
+typedef bool (*hva_handler_t)(struct kvm *kvm, struct kvm_gfn_range *range);
+
+struct kvm_hva_range {
+	unsigned long start;
+	unsigned long end;
+	pte_t pte;
+	hva_handler_t handler;
+	bool flush_on_ret;
+	bool may_block;
+};
+
+static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
+						  const struct kvm_hva_range *range)
+{
+	struct kvm_memory_slot *slot;
+	struct kvm_memslots *slots;
+	struct kvm_gfn_range gfn_range;
+	bool ret = false;
+	int i, idx;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	idx = srcu_read_lock(&kvm->srcu);
+
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		slots = __kvm_memslots(kvm, i);
+		kvm_for_each_memslot(slot, slots) {
+			unsigned long hva_start, hva_end;
+
+			hva_start = max(range->start, slot->userspace_addr);
+			hva_end = min(range->end, slot->userspace_addr +
+						  (slot->npages << PAGE_SHIFT));
+			if (hva_start >= hva_end)
+				continue;
+
+			/*
+			 * To optimize for the likely case where the address
+			 * range is covered by zero or one memslots, don't
+			 * bother making these conditional (to avoid writes on
+			 * the second or later invocation of the handler).
+			 */
+			gfn_range.pte = range->pte;
+			gfn_range.may_block = range->may_block;
+
+			/*
+			 * {gfn(page) | page intersects with [hva_start, hva_end)} =
+			 * {gfn_start, gfn_start+1, ..., gfn_end-1}.
+			 */
+			gfn_range.start = hva_to_gfn_memslot(hva_start, slot);
+			gfn_range.end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, slot);
+			gfn_range.slot = slot;
+
+			ret |= range->handler(kvm, &gfn_range);
+		}
+	}
+
+	if (range->flush_on_ret && (ret || kvm->tlbs_dirty))
+		kvm_flush_remote_tlbs(kvm);
+
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	/* The notifiers are averse to booleans. :-( */
+	return (int)ret;
+}
+
+static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
+						unsigned long start,
+						unsigned long end,
+						pte_t pte,
+						hva_handler_t handler)
+{
+	struct kvm *kvm = mmu_notifier_to_kvm(mn);
+	const struct kvm_hva_range range = {
+		.start		= start,
+		.end		= end,
+		.pte		= pte,
+		.handler	= handler,
+		.flush_on_ret	= true,
+		.may_block	= false,
+	};
+	int ret;
+
+	KVM_MMU_LOCK(kvm);
+	ret = __kvm_handle_hva_range(kvm, &range);
+	KVM_MMU_UNLOCK(kvm);
+
+	return ret;
+}
+
+static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn,
+							 unsigned long start,
+							 unsigned long end,
+							 hva_handler_t handler)
+{
+	struct kvm *kvm = mmu_notifier_to_kvm(mn);
+	const struct kvm_hva_range range = {
+		.start		= start,
+		.end		= end,
+		.pte		= __pte(0),
+		.handler	= handler,
+		.flush_on_ret	= false,
+		.may_block	= false,
+	};
+	int ret;
+
+	KVM_MMU_LOCK(kvm);
+	ret = __kvm_handle_hva_range(kvm, &range);
+	KVM_MMU_UNLOCK(kvm);
+
+	return ret;
+}
+#endif /* KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS */
+
 static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 					struct mm_struct *mm,
 					unsigned long address,
 					pte_t pte)
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
-	int idx;
 
+#ifndef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
+	int idx;
+#endif
 	trace_kvm_set_spte_hva(address);
 
 	/*
@@ -468,6 +585,9 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 	 */
 	WARN_ON_ONCE(!kvm->mmu_notifier_count);
 
+#ifdef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
+	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_set_spte_gfn);
+#else
 	idx = srcu_read_lock(&kvm->srcu);
 
 	KVM_MMU_LOCK(kvm);
@@ -477,17 +597,32 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
 
 	KVM_MMU_UNLOCK(kvm);
 	srcu_read_unlock(&kvm->srcu, idx);
+#endif
 }
 
 static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 					const struct mmu_notifier_range *range)
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
+#ifdef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
+	const struct kvm_hva_range hva_range = {
+		.start		= range->start,
+		.end		= range->end,
+		.pte		= __pte(0),
+		.handler	= kvm_unmap_gfn_range,
+		.flush_on_ret	= true,
+		.may_block	= mmu_notifier_range_blockable(range),
+	};
+#else
 	int need_tlb_flush = 0, idx;
+#endif
 
 	trace_kvm_unmap_hva_range(range->start, range->end);
 
+#ifndef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
 	idx = srcu_read_lock(&kvm->srcu);
+#endif
+
 	KVM_MMU_LOCK(kvm);
 	/*
 	 * The count increase must become visible at unlock time as no
@@ -513,14 +648,21 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 		kvm->mmu_notifier_range_end =
 			max(kvm->mmu_notifier_range_end, range->end);
 	}
+
+#ifdef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
+	__kvm_handle_hva_range(kvm, &hva_range);
+#else
 	need_tlb_flush = kvm_unmap_hva_range(kvm, range->start, range->end,
 					     range->flags);
 	/* we've to flush the tlb before the pages can be freed */
 	if (need_tlb_flush || kvm->tlbs_dirty)
 		kvm_flush_remote_tlbs(kvm);
+#endif
 
 	KVM_MMU_UNLOCK(kvm);
+#ifndef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
 	srcu_read_unlock(&kvm->srcu, idx);
+#endif
 
 	return 0;
 }
@@ -554,11 +696,15 @@ static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
 					      unsigned long start,
 					      unsigned long end)
 {
+#ifndef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 	int young, idx;
-
+#endif
 	trace_kvm_age_hva(start, end);
 
+#ifdef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
+	return kvm_handle_hva_range(mn, start, end, __pte(0), kvm_age_gfn);
+#else
 	idx = srcu_read_lock(&kvm->srcu);
 	KVM_MMU_LOCK(kvm);
 
@@ -570,6 +716,7 @@ static int kvm_mmu_notifier_clear_flush_young(struct mmu_notifier *mn,
 	srcu_read_unlock(&kvm->srcu, idx);
 
 	return young;
+#endif
 }
 
 static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
@@ -577,13 +724,13 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
 					unsigned long start,
 					unsigned long end)
 {
+#ifndef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 	int young, idx;
+#endif
 
 	trace_kvm_age_hva(start, end);
 
-	idx = srcu_read_lock(&kvm->srcu);
-	KVM_MMU_LOCK(kvm);
 	/*
 	 * Even though we do not flush TLB, this will still adversely
 	 * affect performance on pre-Haswell Intel EPT, where there is
@@ -597,22 +744,33 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
 	 * cadence. If we find this inaccurate, we might come up with a
 	 * more sophisticated heuristic later.
 	 */
+#ifdef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
+	return kvm_handle_hva_range_no_flush(mn, start, end, kvm_age_gfn);
+#else
+	idx = srcu_read_lock(&kvm->srcu);
+	KVM_MMU_LOCK(kvm);
 	young = kvm_age_hva(kvm, start, end);
 	KVM_MMU_UNLOCK(kvm);
 	srcu_read_unlock(&kvm->srcu, idx);
 
 	return young;
+#endif
 }
 
 static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
 				       struct mm_struct *mm,
 				       unsigned long address)
 {
+#ifndef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 	int young, idx;
-
+#endif
 	trace_kvm_test_age_hva(address);
 
+#ifdef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
+	return kvm_handle_hva_range_no_flush(mn, address, address + 1,
+					     kvm_test_age_gfn);
+#else
 	idx = srcu_read_lock(&kvm->srcu);
 	KVM_MMU_LOCK(kvm);
 	young = kvm_test_age_hva(kvm, address);
@@ -620,6 +778,7 @@ static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
 	srcu_read_unlock(&kvm->srcu, idx);
 
 	return young;
+#endif
 }
 
 static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
-- 
2.31.0.208.g409f899ff0-goog

