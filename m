Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40228311E08
	for <lists+kvm@lfdr.de>; Sat,  6 Feb 2021 15:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbhBFOzI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Feb 2021 09:55:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48466 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229529AbhBFOzF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 6 Feb 2021 09:55:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612623218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=wHTi8aMade4xYKga2LpcvJGucfLZSmxiKjPP0BoFAtA=;
        b=a+DWHvLhp3YxyFs6DbAhXkWaaTFzdNjPk5rU57DfdLofAEgNmL1XN4vXbpeTUL0CpUMAAf
        N+djk7SnSUrPCDbRpCHr1K2DayZocKni5HY3dq9SuJmp1APo+2yI/a0jqlmbnP5aweG2D5
        jIhVMAh12oOmpF12N5B6XeOFVzdEGck=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-xWjnPcS6MFK8nKVf8tLqWg-1; Sat, 06 Feb 2021 09:53:36 -0500
X-MC-Unique: xWjnPcS6MFK8nKVf8tLqWg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED8D6107ACC7;
        Sat,  6 Feb 2021 14:53:34 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 95DB16A03D;
        Sat,  6 Feb 2021 14:53:34 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH] KVM: x86: compile out TDP MMU on 32-bit systems
Date:   Sat,  6 Feb 2021 09:53:33 -0500
Message-Id: <20210206145333.47314-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The TDP MMU assumes that it can do atomic accesses to 64-bit PTEs.
Rather than just disabling it, compile it out completely so that it
is possible to use for example 64-bit xchg.

To limit the number of stubs, wrap all accesses to tdp_mmu_enabled
or tdp_mmu_page with a function.  Calls to all other functions in
tdp_mmu.c are eliminated and do not even reach the linker.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/Makefile      |  3 ++-
 arch/x86/kvm/mmu/mmu.c     | 36 ++++++++++++++++++------------------
 arch/x86/kvm/mmu/tdp_mmu.c | 29 +----------------------------
 arch/x86/kvm/mmu/tdp_mmu.h | 32 ++++++++++++++++++++++++++++----
 4 files changed, 49 insertions(+), 51 deletions(-)

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index a50041235530..aeab168c5711 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -17,7 +17,8 @@ kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
 kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o xen.o \
 			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
 			   hyperv.o debugfs.o mmu/mmu.o mmu/page_track.o \
-			   mmu/spte.o mmu/tdp_iter.o mmu/tdp_mmu.o
+			   mmu/spte.o
+kvm-$(CONFIG_X86_64) += mmu/tdp_iter.o mmu/tdp_mmu.o
 
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
 			   vmx/evmcs.o vmx/nested.o vmx/posted_intr.o
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 86af58294272..bebb66c6d068 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1225,7 +1225,7 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 {
 	struct kvm_rmap_head *rmap_head;
 
-	if (kvm->arch.tdp_mmu_enabled)
+	if (is_tdp_mmu_enabled(kvm))
 		kvm_tdp_mmu_clear_dirty_pt_masked(kvm, slot,
 				slot->base_gfn + gfn_offset, mask, true);
 	while (mask) {
@@ -1254,7 +1254,7 @@ void kvm_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 {
 	struct kvm_rmap_head *rmap_head;
 
-	if (kvm->arch.tdp_mmu_enabled)
+	if (is_tdp_mmu_enabled(kvm))
 		kvm_tdp_mmu_clear_dirty_pt_masked(kvm, slot,
 				slot->base_gfn + gfn_offset, mask, false);
 	while (mask) {
@@ -1310,7 +1310,7 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 		write_protected |= __rmap_write_protect(kvm, rmap_head, true);
 	}
 
-	if (kvm->arch.tdp_mmu_enabled)
+	if (is_tdp_mmu_enabled(kvm))
 		write_protected |=
 			kvm_tdp_mmu_write_protect_gfn(kvm, slot, gfn);
 
@@ -1522,7 +1522,7 @@ int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
 
 	r = kvm_handle_hva_range(kvm, start, end, 0, kvm_unmap_rmapp);
 
-	if (kvm->arch.tdp_mmu_enabled)
+	if (is_tdp_mmu_enabled(kvm))
 		r |= kvm_tdp_mmu_zap_hva_range(kvm, start, end);
 
 	return r;
@@ -1534,7 +1534,7 @@ int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
 
 	r = kvm_handle_hva(kvm, hva, (unsigned long)&pte, kvm_set_pte_rmapp);
 
-	if (kvm->arch.tdp_mmu_enabled)
+	if (is_tdp_mmu_enabled(kvm))
 		r |= kvm_tdp_mmu_set_spte_hva(kvm, hva, &pte);
 
 	return r;
@@ -1589,7 +1589,7 @@ int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
 	int young = false;
 
 	young = kvm_handle_hva_range(kvm, start, end, 0, kvm_age_rmapp);
-	if (kvm->arch.tdp_mmu_enabled)
+	if (is_tdp_mmu_enabled(kvm))
 		young |= kvm_tdp_mmu_age_hva_range(kvm, start, end);
 
 	return young;
@@ -1600,7 +1600,7 @@ int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
 	int young = false;
 
 	young = kvm_handle_hva(kvm, hva, 0, kvm_test_age_rmapp);
-	if (kvm->arch.tdp_mmu_enabled)
+	if (is_tdp_mmu_enabled(kvm))
 		young |= kvm_tdp_mmu_test_age_hva(kvm, hva);
 
 	return young;
@@ -3155,7 +3155,7 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
 	sp = to_shadow_page(*root_hpa & PT64_BASE_ADDR_MASK);
 
 	if (kvm_mmu_put_root(kvm, sp)) {
-		if (sp->tdp_mmu_page)
+		if (is_tdp_mmu_page(sp))
 			kvm_tdp_mmu_free_root(kvm, sp);
 		else if (sp->role.invalid)
 			kvm_mmu_prepare_zap_page(kvm, sp, invalid_list);
@@ -3249,7 +3249,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 	hpa_t root;
 	unsigned i;
 
-	if (vcpu->kvm->arch.tdp_mmu_enabled) {
+	if (is_tdp_mmu_enabled(vcpu->kvm)) {
 		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
 
 		if (!VALID_PAGE(root))
@@ -5411,7 +5411,7 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 
 	kvm_zap_obsolete_pages(kvm);
 
-	if (kvm->arch.tdp_mmu_enabled)
+	if (is_tdp_mmu_enabled(kvm))
 		kvm_tdp_mmu_zap_all(kvm);
 
 	write_unlock(&kvm->mmu_lock);
@@ -5474,7 +5474,7 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 		}
 	}
 
-	if (kvm->arch.tdp_mmu_enabled) {
+	if (is_tdp_mmu_enabled(kvm)) {
 		flush = kvm_tdp_mmu_zap_gfn_range(kvm, gfn_start, gfn_end);
 		if (flush)
 			kvm_flush_remote_tlbs(kvm);
@@ -5498,7 +5498,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 	write_lock(&kvm->mmu_lock);
 	flush = slot_handle_level(kvm, memslot, slot_rmap_write_protect,
 				start_level, KVM_MAX_HUGEPAGE_LEVEL, false);
-	if (kvm->arch.tdp_mmu_enabled)
+	if (is_tdp_mmu_enabled(kvm))
 		flush |= kvm_tdp_mmu_wrprot_slot(kvm, memslot, PG_LEVEL_4K);
 	write_unlock(&kvm->mmu_lock);
 
@@ -5564,7 +5564,7 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 	slot_handle_leaf(kvm, (struct kvm_memory_slot *)memslot,
 			 kvm_mmu_zap_collapsible_spte, true);
 
-	if (kvm->arch.tdp_mmu_enabled)
+	if (is_tdp_mmu_enabled(kvm))
 		kvm_tdp_mmu_zap_collapsible_sptes(kvm, memslot);
 	write_unlock(&kvm->mmu_lock);
 }
@@ -5591,7 +5591,7 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 
 	write_lock(&kvm->mmu_lock);
 	flush = slot_handle_leaf(kvm, memslot, __rmap_clear_dirty, false);
-	if (kvm->arch.tdp_mmu_enabled)
+	if (is_tdp_mmu_enabled(kvm))
 		flush |= kvm_tdp_mmu_clear_dirty_slot(kvm, memslot);
 	write_unlock(&kvm->mmu_lock);
 
@@ -5614,7 +5614,7 @@ void kvm_mmu_slot_largepage_remove_write_access(struct kvm *kvm,
 	write_lock(&kvm->mmu_lock);
 	flush = slot_handle_large_level(kvm, memslot, slot_rmap_write_protect,
 					false);
-	if (kvm->arch.tdp_mmu_enabled)
+	if (is_tdp_mmu_enabled(kvm))
 		flush |= kvm_tdp_mmu_wrprot_slot(kvm, memslot, PG_LEVEL_2M);
 	write_unlock(&kvm->mmu_lock);
 
@@ -5630,7 +5630,7 @@ void kvm_mmu_slot_set_dirty(struct kvm *kvm,
 
 	write_lock(&kvm->mmu_lock);
 	flush = slot_handle_all_level(kvm, memslot, __rmap_set_dirty, false);
-	if (kvm->arch.tdp_mmu_enabled)
+	if (is_tdp_mmu_enabled(kvm))
 		flush |= kvm_tdp_mmu_slot_set_dirty(kvm, memslot);
 	write_unlock(&kvm->mmu_lock);
 
@@ -5658,7 +5658,7 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 
 	kvm_mmu_commit_zap_page(kvm, &invalid_list);
 
-	if (kvm->arch.tdp_mmu_enabled)
+	if (is_tdp_mmu_enabled(kvm))
 		kvm_tdp_mmu_zap_all(kvm);
 
 	write_unlock(&kvm->mmu_lock);
@@ -5969,7 +5969,7 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 				      struct kvm_mmu_page,
 				      lpage_disallowed_link);
 		WARN_ON_ONCE(!sp->lpage_disallowed);
-		if (sp->tdp_mmu_page) {
+		if (is_tdp_mmu_page(sp)) {
 			kvm_tdp_mmu_zap_gfn_range(kvm, sp->gfn,
 				sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level));
 		} else {
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index aa0845d5e1e4..ec99e50a7ba7 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -10,24 +10,13 @@
 #include <asm/cmpxchg.h>
 #include <trace/events/kvm.h>
 
-#ifdef CONFIG_X86_64
 static bool __read_mostly tdp_mmu_enabled = false;
 module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0644);
-#endif
-
-static bool is_tdp_mmu_enabled(void)
-{
-#ifdef CONFIG_X86_64
-	return tdp_enabled && READ_ONCE(tdp_mmu_enabled);
-#else
-	return false;
-#endif /* CONFIG_X86_64 */
-}
 
 /* Initializes the TDP MMU for the VM, if enabled. */
 void kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 {
-	if (!is_tdp_mmu_enabled())
+	if (!tdp_enabled || !READ_ONCE(tdp_mmu_enabled))
 		return;
 
 	/* This should not be changed for the lifetime of the VM. */
@@ -96,22 +85,6 @@ static inline struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 #define for_each_tdp_mmu_root(_kvm, _root)				\
 	list_for_each_entry(_root, &_kvm->arch.tdp_mmu_roots, link)
 
-bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
-{
-	struct kvm_mmu_page *sp;
-
-	if (!kvm->arch.tdp_mmu_enabled)
-		return false;
-	if (WARN_ON(!VALID_PAGE(hpa)))
-		return false;
-
-	sp = to_shadow_page(hpa);
-	if (WARN_ON(!sp))
-		return false;
-
-	return sp->tdp_mmu_page && sp->root_count;
-}
-
 static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			  gfn_t start, gfn_t end, bool can_yield);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index cbbdbadd1526..b4b65e3699b3 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -5,10 +5,6 @@
 
 #include <linux/kvm_host.h>
 
-void kvm_mmu_init_tdp_mmu(struct kvm *kvm);
-void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
-
-bool is_tdp_mmu_root(struct kvm *kvm, hpa_t root);
 hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
 void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root);
 
@@ -47,4 +43,32 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 			 int *root_level);
 
+#ifdef CONFIG_X86_64
+void kvm_mmu_init_tdp_mmu(struct kvm *kvm);
+void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
+static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return kvm->arch.tdp_mmu_enabled; }
+static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return sp->tdp_mmu_page; }
+#else
+static inline void kvm_mmu_init_tdp_mmu(struct kvm *kvm) {}
+static inline void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm) {}
+static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return false; }
+static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return false; }
+#endif
+
+static inline bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
+{
+	struct kvm_mmu_page *sp;
+
+	if (!is_tdp_mmu_enabled(kvm))
+		return false;
+	if (WARN_ON(!VALID_PAGE(hpa)))
+		return false;
+
+	sp = to_shadow_page(hpa);
+	if (WARN_ON(!sp))
+		return false;
+
+	return is_tdp_mmu_page(sp) && sp->root_count;
+}
+
 #endif /* __KVM_X86_MMU_TDP_MMU_H */
-- 
2.26.2

