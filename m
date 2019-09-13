Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6B9CB1758
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 04:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbfIMCqP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 22:46:15 -0400
Received: from mga07.intel.com ([134.134.136.100]:58605 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726647AbfIMCqP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 22:46:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 19:46:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="176159503"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 12 Sep 2019 19:46:13 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        James Harvey <jamespharvey20@gmail.com>,
        Alex Willamson <alex.williamson@redhat.com>
Subject: [PATCH 01/11] KVM: x86/mmu: Reintroduce fast invalidate/zap for flushing memslot
Date:   Thu, 12 Sep 2019 19:46:02 -0700
Message-Id: <20190913024612.28392-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190913024612.28392-1-sean.j.christopherson@intel.com>
References: <20190913024612.28392-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reintroduce the fast invalidate mechanism and use it when zapping shadow
pages in response to a memslot being deleted/moved.  Using the fast
mechanism fixes a livelock reported by James Harvey that was introduced
by commit d012a06ab1d23 ("Revert "KVM: x86/mmu: Zap only the relevant
pages when removing a memslot"").

The livelock occurs because kvm_mmu_zap_all() as it exists today will
voluntarily reschedule and drop KVM's mmu_lock, which allows other vCPUs
to add shadow pages.  With enough vCPUs, kvm_mmu_zap_all() can get stuck
in an infinite loop as it can never zap all pages before observing lock
contention or the need to reschedule.

The equivalent of kvm_mmu_zap_all() that was in use at the time of
the reverted commit (4e103134b8623, "KVM: x86/mmu: Zap only the relevant
pages when removing a memslot") employed a fast invalidate mechanism and
was not susceptible to the above livelock.  Restore the fast invalidate
code and use it when flushing a memslot.

Reverting the revert (commit d012a06ab1d23) is not a viable option as
the revert is needed to fix a regression that occurs when the guest has
one or more assigned devices.

Alternatively, the livelock could be eliminated by removing the
conditional reschedule from kvm_mmu_zap_all().  However, although
removing the reschedule would be a smaller code change, it's less safe
in the sense that the resulting kvm_mmu_zap_all() hasn't been used in
the wild for flushing memslots since the fast invalidate mechanism was
introduced by commit 6ca18b6950f8d ("KVM: x86: use the fast way to
invalidate all pages"), back in 2013.

For all intents and purposes, this is a revert of commit ea145aacf4ae8
("Revert "KVM: MMU: fast invalidate all pages"") and a partial revert of
commit 7390de1e99a70 ("Revert "KVM: x86: use the fast way to invalidate
all pages""), i.e. restores the behavior of commit 5304b8d37c2a5 ("KVM:
MMU: fast invalidate all pages") and commit 6ca18b6950f8d ("KVM: x86:
use the fast way to invalidate all pages") respectively.

Fixes: d012a06ab1d23 ("Revert "KVM: x86/mmu: Zap only the relevant pages when removing a memslot"")
Reported-by: James Harvey <jamespharvey20@gmail.com>
Cc: Alex Willamson <alex.williamson@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |   2 +
 arch/x86/kvm/mmu.c              | 101 +++++++++++++++++++++++++++++++-
 2 files changed, 101 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 44a5ce57a905..fc279b513446 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -335,6 +335,7 @@ struct kvm_mmu_page {
 	int root_count;          /* Currently serving as active root */
 	unsigned int unsync_children;
 	struct kvm_rmap_head parent_ptes; /* rmap pointers to parent sptes */
+	unsigned long mmu_valid_gen;
 	DECLARE_BITMAP(unsync_child_bitmap, 512);
 
 #ifdef CONFIG_X86_32
@@ -856,6 +857,7 @@ struct kvm_arch {
 	unsigned long n_requested_mmu_pages;
 	unsigned long n_max_mmu_pages;
 	unsigned int indirect_shadow_pages;
+	unsigned long mmu_valid_gen;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
 	/*
 	 * Hash table of struct kvm_mmu_page.
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 4c45ff0cfbd0..5ac5e3f50f92 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2097,6 +2097,12 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct
 	if (!direct)
 		sp->gfns = mmu_memory_cache_alloc(&vcpu->arch.mmu_page_cache);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
+
+	/*
+	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
+	 * depends on valid pages being added to the head of the list.  See
+	 * comments in kvm_zap_obsolete_pages().
+	 */
 	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
 	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
 	return sp;
@@ -2246,7 +2252,7 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 #define for_each_valid_sp(_kvm, _sp, _gfn)				\
 	hlist_for_each_entry(_sp,					\
 	  &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)], hash_link) \
-		if ((_sp)->role.invalid) {    \
+		if (is_obsolete_sp((_kvm), (_sp)) || (_sp)->role.invalid) {    \
 		} else
 
 #define for_each_gfn_indirect_valid_sp(_kvm, _sp, _gfn)			\
@@ -2303,6 +2309,11 @@ static void kvm_mmu_audit(struct kvm_vcpu *vcpu, int point) { }
 static void mmu_audit_disable(void) { }
 #endif
 
+static bool is_obsolete_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
+{
+	return unlikely(sp->mmu_valid_gen != kvm->arch.mmu_valid_gen);
+}
+
 static bool kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			 struct list_head *invalid_list)
 {
@@ -2527,6 +2538,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		if (level > PT_PAGE_TABLE_LEVEL && need_sync)
 			flush |= kvm_sync_pages(vcpu, gfn, &invalid_list);
 	}
+	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
 	clear_page(sp->spt);
 	trace_kvm_mmu_get_page(sp, true);
 
@@ -4236,6 +4248,13 @@ static bool fast_cr3_switch(struct kvm_vcpu *vcpu, gpa_t new_cr3,
 			return false;
 
 		if (cached_root_available(vcpu, new_cr3, new_role)) {
+			/*
+			 * It is possible that the cached previous root page is
+			 * obsolete because of a change in the MMU generation
+			 * number. However, changing the generation number is
+			 * accompanied by KVM_REQ_MMU_RELOAD, which will free
+			 * the root set here and allocate a new one.
+			 */
 			kvm_make_request(KVM_REQ_LOAD_CR3, vcpu);
 			if (!skip_tlb_flush) {
 				kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
@@ -5652,11 +5671,89 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 	return alloc_mmu_pages(vcpu);
 }
 
+
+static void kvm_zap_obsolete_pages(struct kvm *kvm)
+{
+	struct kvm_mmu_page *sp, *node;
+	LIST_HEAD(invalid_list);
+	int ign;
+
+restart:
+	list_for_each_entry_safe_reverse(sp, node,
+	      &kvm->arch.active_mmu_pages, link) {
+		/*
+		 * No obsolete valid page exists before a newly created page
+		 * since active_mmu_pages is a FIFO list.
+		 */
+		if (!is_obsolete_sp(kvm, sp))
+			break;
+
+		/*
+		 * Do not repeatedly zap a root page to avoid unnecessary
+		 * KVM_REQ_MMU_RELOAD, otherwise we may not be able to
+		 * progress:
+		 *    vcpu 0                        vcpu 1
+		 *                         call vcpu_enter_guest():
+		 *                            1): handle KVM_REQ_MMU_RELOAD
+		 *                                and require mmu-lock to
+		 *                                load mmu
+		 * repeat:
+		 *    1): zap root page and
+		 *        send KVM_REQ_MMU_RELOAD
+		 *
+		 *    2): if (cond_resched_lock(mmu-lock))
+		 *
+		 *                            2): hold mmu-lock and load mmu
+		 *
+		 *                            3): see KVM_REQ_MMU_RELOAD bit
+		 *                                on vcpu->requests is set
+		 *                                then return 1 to call
+		 *                                vcpu_enter_guest() again.
+		 *            goto repeat;
+		 *
+		 * Since we are reversely walking the list and the invalid
+		 * list will be moved to the head, skip the invalid page
+		 * can help us to avoid the infinity list walking.
+		 */
+		if (sp->role.invalid)
+			continue;
+
+		if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
+			kvm_mmu_commit_zap_page(kvm, &invalid_list);
+			cond_resched_lock(&kvm->mmu_lock);
+			goto restart;
+		}
+
+		if (__kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list, &ign))
+			goto restart;
+	}
+
+	kvm_mmu_commit_zap_page(kvm, &invalid_list);
+}
+
+/*
+ * Fast invalidate all shadow pages and use lock-break technique
+ * to zap obsolete pages.
+ *
+ * It's required when memslot is being deleted or VM is being
+ * destroyed, in these cases, we should ensure that KVM MMU does
+ * not use any resource of the being-deleted slot or all slots
+ * after calling the function.
+ */
+static void kvm_mmu_zap_all_fast(struct kvm *kvm)
+{
+	spin_lock(&kvm->mmu_lock);
+	kvm->arch.mmu_valid_gen++;
+
+	kvm_zap_obsolete_pages(kvm);
+	spin_unlock(&kvm->mmu_lock);
+}
+
 static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
 			struct kvm_memory_slot *slot,
 			struct kvm_page_track_notifier_node *node)
 {
-	kvm_mmu_zap_all(kvm);
+	kvm_mmu_zap_all_fast(kvm);
 }
 
 void kvm_mmu_init_vm(struct kvm *kvm)
-- 
2.22.0

