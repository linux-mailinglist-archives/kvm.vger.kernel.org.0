Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC439450A18
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 17:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbhKOQyF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 11:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbhKOQxm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 11:53:42 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D95EC061714
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 08:50:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=nGNMDXhx9grkMKvYrI4wT7Uih8/dseVP2eQgLRCBg/0=; b=TMtDe7/vKh28/HB9y3Fen5/n4M
        UPxXlPUIE8Cq53b5nchCcyodr1o7LVnpYSJYX3IFjZjebbldYr9U9mqVu3FPwzms9ykmqifu1FykR
        Q5CrlHeh+jHvI6/WaY+NIb9gD8bGELObLCvR7rTw7KgTOqBW4BNbAnWYUL3Y4GJLYP0oLc/X8G3wb
        Y/QsE/uiLz+mI9x7OX4CAJe2Mwuv63wdUJqoz2otCfoZR8S5ai0c5HHZwCS+T27XMFTSksdvGGfUv
        8whMfTh7ECP8tfqoxRGIdsh3BjQkLPUhUO/05jChuXd3PIRS+rcT/2FzYeRGpdwDU/Gnqzc3ivGIw
        9zyDzp/Q==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmfBe-005qz4-Qc; Mon, 15 Nov 2021 16:50:31 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmfBf-0001wy-1x; Mon, 15 Nov 2021 16:50:31 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "seanjc @ google . com" <seanjc@google.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com
Subject: [PATCH 09/11] KVM: Reinstate gfn_to_pfn_cache with invalidation support
Date:   Mon, 15 Nov 2021 16:50:28 +0000
Message-Id: <20211115165030.7422-9-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211115165030.7422-1-dwmw2@infradead.org>
References: <95fae9cf56b1a7f0a5f2b9a1934e29e924908ff2.camel@infradead.org>
 <20211115165030.7422-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

This supports the rwlock-based usage mode only for now; to support the
guest_uses_pa case we need to work a few more details out. Perhaps add
a new KVM_REQ_ type for it, maybe arch-specific or not, and work out
how we can do the invalidation from invalidate_range_start and ensure
that it doesn't get reinstated before invalidate_range actually happens.

This much is good enough to start testing for Xen event channels though.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 include/linux/kvm_host.h  |  14 +++
 include/linux/kvm_types.h |  18 +++
 virt/kvm/kvm_main.c       | 250 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 282 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index c310648cc8f1..762bf2586feb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -559,6 +559,10 @@ struct kvm {
 	unsigned long mn_active_invalidate_count;
 	struct rcuwait mn_memslots_update_rcuwait;
 
+	/* For invalidation of gfn_to_pfn_caches */
+	struct list_head gpc_list;
+	spinlock_t gpc_lock;
+
 	/*
 	 * created_vcpus is protected by kvm->lock, and is incremented
 	 * at the beginning of KVM_CREATE_VCPU.  online_vcpus is only
@@ -966,6 +970,16 @@ int kvm_vcpu_write_guest(struct kvm_vcpu *vcpu, gpa_t gpa, const void *data,
 			 unsigned long len);
 void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn);
 
+int kvm_gfn_to_pfn_cache_init(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
+			      struct kvm_vcpu *vcpu, bool guest_uses_pa,
+			      bool kernel_map, gpa_t gpa, unsigned long len,
+			      bool write);
+int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
+				 gpa_t gpa, unsigned long len, bool write);
+bool kvm_gfn_to_pfn_cache_check(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
+				gpa_t gpa, unsigned long len);
+void kvm_gfn_to_pfn_cache_destroy(struct kvm *kvm, struct gfn_to_pfn_cache *gpc);
+
 void kvm_sigset_activate(struct kvm_vcpu *vcpu);
 void kvm_sigset_deactivate(struct kvm_vcpu *vcpu);
 
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 234eab059839..896bd78a30e3 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -19,6 +19,7 @@ struct kvm_memslots;
 enum kvm_mr_change;
 
 #include <linux/types.h>
+#include <linux/spinlock_types.h>
 
 #include <asm/kvm_types.h>
 
@@ -53,6 +54,23 @@ struct gfn_to_hva_cache {
 	struct kvm_memory_slot *memslot;
 };
 
+struct gfn_to_pfn_cache {
+	u64 generation;
+	gpa_t gpa;
+	unsigned long uhva;
+	struct kvm_memory_slot *memslot;
+	struct kvm_vcpu *vcpu;
+	struct list_head list;
+	rwlock_t lock;
+	void *khva;
+	kvm_pfn_t pfn;
+	bool active;
+	bool valid;
+	bool dirty;
+	bool guest_uses_pa;
+	bool kernel_map;
+};
+
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
 /*
  * Memory caches are used to preallocate memory ahead of various MMU flows,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9646bb9112c1..7382aa45d5e8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -458,6 +458,9 @@ static inline struct kvm *mmu_notifier_to_kvm(struct mmu_notifier *mn)
 	return container_of(mn, struct kvm, mmu_notifier);
 }
 
+static void gfn_to_pfn_cache_invalidate(struct kvm *kvm, unsigned long start,
+					unsigned long end, bool may_block);
+
 static void kvm_mmu_notifier_invalidate_range(struct mmu_notifier *mn,
 					      struct mm_struct *mm,
 					      unsigned long start, unsigned long end)
@@ -465,6 +468,8 @@ static void kvm_mmu_notifier_invalidate_range(struct mmu_notifier *mn,
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 	int idx;
 
+	gfn_to_pfn_cache_invalidate(kvm, start, end, false);
+
 	idx = srcu_read_lock(&kvm->srcu);
 	kvm_arch_mmu_notifier_invalidate_range(kvm, start, end);
 	srcu_read_unlock(&kvm->srcu, idx);
@@ -1051,6 +1056,9 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	spin_lock_init(&kvm->mn_invalidate_lock);
 	rcuwait_init(&kvm->mn_memslots_update_rcuwait);
 
+	INIT_LIST_HEAD(&kvm->gpc_list);
+	spin_lock_init(&kvm->gpc_lock);
+
 	INIT_LIST_HEAD(&kvm->devices);
 
 	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
@@ -2618,6 +2626,248 @@ void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map, bool dirty)
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_unmap);
 
+static void gfn_to_pfn_cache_invalidate(struct kvm *kvm, unsigned long start,
+					unsigned long end, bool may_block)
+{
+	bool wake_vcpus = false, wake_all_vcpus = false;
+	DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
+	struct gfn_to_pfn_cache *gpc;
+	bool called = false;
+
+	spin_lock(&kvm->gpc_lock);
+	list_for_each_entry(gpc, &kvm->gpc_list, list) {
+		write_lock_irq(&gpc->lock);
+
+		/* Only a single page so no need to care about length */
+		if (gpc->valid && !is_error_noslot_pfn(gpc->pfn) &&
+		    gpc->uhva >= start && gpc->uhva < end) {
+			gpc->valid = false;
+
+			if (gpc->dirty) {
+				int idx = srcu_read_lock(&kvm->srcu);
+				mark_page_dirty(kvm, gpa_to_gfn(gpc->gpa));
+				srcu_read_unlock(&kvm->srcu, idx);
+
+				kvm_set_pfn_dirty(gpc->pfn);
+				gpc->dirty = false;
+			}
+
+			/*
+			 * If a guest vCPU could be using the physical address,
+			 * it needs to be woken.
+			 */
+			if (gpc->guest_uses_pa) {
+				if (wake_all_vcpus) {
+					/* Nothing to do */
+				} else if (gpc->vcpu) {
+					/* Only need to wake one vCPU for this */
+					if (!wake_vcpus) {
+						wake_vcpus = true;
+						bitmap_zero(vcpu_bitmap, KVM_MAX_VCPUS);
+					}
+					__set_bit(gpc->vcpu->vcpu_idx, vcpu_bitmap);
+				} else
+					wake_all_vcpus = true;
+				}
+			}
+		write_unlock_irq(&gpc->lock);
+	}
+	spin_unlock(&kvm->gpc_lock);
+
+#if 0
+	unsigned int req = KVM_REQ_GPC_INVALIDATE;
+
+	/*
+	 * If the OOM reaper is active, then all vCPUs should have been stopped
+	 * already, so perform the request without KVM_REQUEST_WAIT and be sad
+	 * if anything needed to be woken.
+	 */
+	if (!may_block)
+		req |= ~KVM_REQUEST_WAIT;
+
+	if (wake_all_vcpus) {
+		called = kvm_make_all_cpus_request(kvm, req);
+	} else if (wake_vcpus) {
+		called = kvm_make_vcpus_request_mask(kvm, req, vcpu_bitmap);
+	}
+#endif
+	WARN_ON_ONCE(called && !may_block);
+}
+
+bool kvm_gfn_to_pfn_cache_check(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
+				gpa_t gpa, unsigned long len)
+{
+	struct kvm_memslots *slots = kvm_memslots(kvm);
+
+	if ((gpa & ~PAGE_MASK) + len > PAGE_SIZE)
+		return false;
+
+	if (gpc->gpa != gpa || gpc->generation != slots->generation ||
+	    kvm_is_error_hva(gpc->uhva))
+		return false;
+
+	if (!gpc->valid)
+		return false;
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(kvm_gfn_to_pfn_cache_check);
+
+int kvm_gfn_to_pfn_cache_refresh(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
+				 gpa_t gpa, unsigned long len, bool write)
+{
+	struct kvm_memslots *slots = kvm_memslots(kvm);
+	unsigned long page_offset = gpa & ~PAGE_MASK;
+	kvm_pfn_t old_pfn, new_pfn;
+	unsigned long old_uhva;
+	gpa_t old_gpa;
+	void *old_khva;
+	bool old_valid, old_dirty;
+	int ret = 0;
+
+	/*
+	 * If must fit within a single page. The 'len' argument is
+	 * only to enforce that.
+	 */
+	if (page_offset + len > PAGE_SIZE)
+		return -EINVAL;
+
+	write_lock_irq(&gpc->lock);
+
+	old_gpa = gpc->gpa;
+	old_pfn = gpc->pfn;
+	old_khva = gpc->khva;
+	old_uhva = gpc->uhva;
+	old_valid = gpc->valid;
+	old_dirty = gpc->dirty;
+
+	/* If the userspace HVA is invalid, refresh that first */
+	if (gpc->gpa != gpa || gpc->generation != slots->generation ||
+	    kvm_is_error_hva(gpc->uhva)) {
+		gfn_t gfn = gpa_to_gfn(gpa);
+
+		gpc->dirty = false;
+		gpc->gpa = gpa;
+		gpc->generation = slots->generation;
+		gpc->memslot = __gfn_to_memslot(slots, gfn);
+		gpc->uhva = gfn_to_hva_memslot(gpc->memslot, gfn);
+
+		if (kvm_is_error_hva(gpc->uhva)) {
+			ret = -EFAULT;
+			goto out;
+		}
+
+		gpc->uhva += page_offset;
+	}
+
+	/*
+	 * If the userspace HVA changed or the PFN was already invalid,
+	 * drop the lock and do the HVA to PFN lookup again.
+	 */
+	if (!old_valid || old_uhva != gpc->uhva) {
+		unsigned long uhva = gpc->uhva;
+		void *new_khva = NULL;
+
+		/* Placeholders for "hva is valid but not yet mapped" */
+		gpc->pfn = KVM_PFN_ERR_FAULT;
+		gpc->khva = NULL;
+		gpc->valid = true;
+
+		write_unlock_irq(&gpc->lock);
+
+		new_pfn = hva_to_pfn(uhva, false, NULL, true, NULL);
+		if (is_error_noslot_pfn(new_pfn))
+			ret = -EFAULT;
+		else if (gpc->kernel_map) {
+			if (new_pfn == old_pfn) {
+				new_khva = (void *)((unsigned long)old_khva - page_offset);
+				old_pfn = KVM_PFN_ERR_FAULT;
+				old_khva = NULL;
+			} else if (pfn_valid(new_pfn)) {
+				new_khva = kmap(pfn_to_page(new_pfn));
+#ifdef CONFIG_HAS_IOMEM
+			} else {
+				new_khva = memremap(pfn_to_hpa(new_pfn), PAGE_SIZE, MEMREMAP_WB);
+#endif
+			}
+			if (!new_khva)
+				ret = -EFAULT;
+		}
+
+		write_lock_irq(&gpc->lock);
+		if (ret) {
+			gpc->valid = false;
+			gpc->pfn = KVM_PFN_ERR_FAULT;
+			gpc->khva = NULL;
+		} else {
+			/* At this point, gpc->valid may already have been cleared */
+			gpc->pfn = new_pfn;
+			gpc->khva = new_khva + page_offset;
+		}
+	}
+
+ out:
+	if (ret)
+		gpc->dirty = false;
+	else
+		gpc->dirty = write;
+
+	write_unlock_irq(&gpc->lock);
+
+	/* Unmap the old page if it was mapped before */
+	if (!is_error_noslot_pfn(old_pfn)) {
+		if (pfn_valid(old_pfn)) {
+			kunmap(pfn_to_page(old_pfn));
+#ifdef CONFIG_HAS_IOMEM
+		} else {
+			memunmap(old_khva);
+#endif
+		}
+		kvm_release_pfn(old_pfn, old_dirty);
+		if (old_dirty)
+			mark_page_dirty(kvm, old_gpa);
+	}
+
+	return ret;
+}
+
+int kvm_gfn_to_pfn_cache_init(struct kvm *kvm, struct gfn_to_pfn_cache *gpc,
+			      struct kvm_vcpu *vcpu, bool guest_uses_pa,
+			      bool kernel_map, gpa_t gpa, unsigned long len,
+			      bool write)
+{
+	if (!gpc->active) {
+		rwlock_init(&gpc->lock);
+
+		gpc->khva = NULL;
+		gpc->pfn = KVM_PFN_ERR_FAULT;
+		gpc->uhva = KVM_HVA_ERR_BAD;
+		gpc->vcpu = vcpu;
+		gpc->guest_uses_pa = guest_uses_pa;
+		gpc->kernel_map = kernel_map;
+		gpc->valid = false;
+		gpc->active = true;
+
+		spin_lock(&kvm->gpc_lock);
+		list_add(&gpc->list, &kvm->gpc_list);
+		spin_unlock(&kvm->gpc_lock);
+	}
+	return kvm_gfn_to_pfn_cache_refresh(kvm, gpc, gpa, len, write);
+}
+
+void kvm_gfn_to_pfn_cache_destroy(struct kvm *kvm, struct gfn_to_pfn_cache *gpc)
+{
+	if (gpc->active) {
+		spin_lock(&kvm->gpc_lock);
+		list_del(&gpc->list);
+		spin_unlock(&kvm->gpc_lock);
+
+		/* In failing, it will tear down any existing mapping */
+		(void)kvm_gfn_to_pfn_cache_refresh(kvm, gpc, GPA_INVALID, 0, false);
+		gpc->active = false;
+	}
+}
+
 struct page *kvm_vcpu_gfn_to_page(struct kvm_vcpu *vcpu, gfn_t gfn)
 {
 	kvm_pfn_t pfn;
-- 
2.31.1

