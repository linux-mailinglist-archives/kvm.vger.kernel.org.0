Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96D5A57B921
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 17:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234525AbiGTPE0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 11:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGTPEZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 11:04:25 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C2B550B7;
        Wed, 20 Jul 2022 08:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658329464; x=1689865464;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   mime-version:in-reply-to;
  bh=tz18PhxnPeHnQrZATJO53taqYCe8MylL6q5d1lSy9cY=;
  b=lLlZNVxL0FJbrKhWil20OGMK5kDGBderlABDS/vt5WY88EqpMprLy69v
   AqfRjGG9ms2z2wv2WOyW7MMnIS0sBAixmMC3Le5fdJ0xIX2ddbftk73FV
   FnkLP7l25bgfaj5DGtm1wvNQTdgDB8ajyR+pJqKU6Gme3/B/LRSWYKqyK
   kpsavMtuUt548qb3xd8xPN/iiofIzCT+InYE9HW9bYxDn/TfagJ510Asm
   aHZllmcYEuOWF4no1MT/+Msnxl/5bMmJfRAFUmmzqJ4bNrcl5IOSVqWWh
   ES66owciiIf+ww8Of/3vB1NBvQUAQo3hTD4/Ze6oHgBmjYT1kfn4USpSn
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10414"; a="350791456"
X-IronPort-AV: E=Sophos;i="5.92,286,1650956400"; 
   d="scan'208";a="350791456"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2022 08:04:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,286,1650956400"; 
   d="scan'208";a="595273204"
Received: from chaop.bj.intel.com (HELO localhost) ([10.240.193.75])
  by orsmga007.jf.intel.com with ESMTP; 20 Jul 2022 08:04:17 -0700
Date:   Wed, 20 Jul 2022 22:59:27 +0800
From:   Chao Peng <chao.p.peng@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 000/102] KVM TDX basic feature support
Message-ID: <20220720145927.GA124133@chaop.bj.intel.com>
Reply-To: Chao Peng <chao.p.peng@linux.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <Ys9rcnyIZlUc76iG@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ys9rcnyIZlUc76iG@google.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 14, 2022 at 01:03:46AM +0000, Sean Christopherson wrote:
...
> 
> Option D). track shared regions in an Xarray, update kvm_arch_memory_slot.lpage_info
> on insertion/removal to (dis)allow hugepages as needed.
> 
>   + efficient on KVM page fault (no new lookups)
>   + zero memory overhead (assuming KVM has to eat the cost of the Xarray anyways)
>   + straightforward to implement
>   + can (and should) be merged as part of the UPM series
> 
> I believe xa_for_each_range() can be used to see if a given 2mb/1gb range is
> completely covered (fully shared) or not covered at all (fully private), but I'm
> not 100% certain that xa_for_each_range() works the way I think it does.

Hi Sean,

Below is the implementation to support 2M as you mentioned as option D.
It's based on UPM v7 xarray code: https://lkml.org/lkml/2022/7/6/259

Everything sounds good, the only trick bit is inc/dec disallow_lpage. If
we still treat it as a count, it will be a challenge to make the inc/dec
balanced. So in this patch I stole a bit for the purpose, looks ugly.

Any feedback is welcome.

Thanks,
Chao

-----------------------------------------------------------------------
From: Chao Peng <chao.p.peng@linux.intel.com>
Date: Wed, 20 Jul 2022 11:37:18 +0800
Subject: [PATCH] KVM: Add large page support for private memory

Update lpage_info when handling KVM_MEMORY_ENCRYPT_{UN,}REG_REGION.

Reserve a bit in disallow_lpage to indicate a large page has
private/share pages mixed.

Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h |   8 +++
 arch/x86/kvm/mmu/mmu.c          | 120 +++++++++++++++++++++++++++++++-
 include/linux/kvm_host.h        |  14 ++++
 virt/kvm/kvm_main.c             |  12 +++-
 4 files changed, 150 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d460b8511041..b6ffe8b1c547 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -38,6 +38,7 @@
 
 #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
 #define __KVM_HAVE_ZAP_GFN_RANGE
+#define __KVM_HAVE_ARCH_UPDATE_MEM_ATTR
 
 #define KVM_MAX_VCPUS 1024
 
@@ -935,6 +936,13 @@ struct kvm_vcpu_arch {
 #endif
 };
 
+/*
+ * Use a bit in disallow_lpage to indicate private/shared pages mixed at the
+ * level. The remaining bits will be used as a reference count for other users.
+ */
+#define KVM_LPAGE_PRIVATE_SHARED_MIXED		(1U << 31)
+#define KVM_LPAGE_COUNT_MAX 			((1U << 31) - 1)
+
 struct kvm_lpage_info {
 	int disallow_lpage;
 };
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 771ffd147e77..d040eeaf1f1c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -843,11 +843,16 @@ static void update_gfn_disallow_lpage_count(const struct kvm_memory_slot *slot,
 {
 	struct kvm_lpage_info *linfo;
 	int i;
+	int disallow_count;
 
 	for (i = PG_LEVEL_2M; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
 		linfo = lpage_info_slot(gfn, slot, i);
+
+		disallow_count = linfo->disallow_lpage & KVM_LPAGE_COUNT_MAX;
+		WARN_ON(disallow_count + count < 0 ||
+			disallow_count > KVM_LPAGE_COUNT_MAX - count);
+
 		linfo->disallow_lpage += count;
-		WARN_ON(linfo->disallow_lpage < 0);
 	}
 }
 
@@ -7246,3 +7251,116 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
 	if (kvm->arch.nx_lpage_recovery_thread)
 		kthread_stop(kvm->arch.nx_lpage_recovery_thread);
 }
+
+static bool mem_attr_is_mixed(struct kvm *kvm, unsigned int attr,
+			      gfn_t start, gfn_t end)
+{
+	XA_STATE(xas, &kvm->mem_attr_array, start);
+	gfn_t gfn = start;
+	void *entry;
+	bool shared, private;
+	bool mixed = false;
+
+	if (attr == KVM_MEM_ATTR_SHARED) {
+		shared = true;
+		private = false;
+	} else {
+		shared = false;
+		private = true;
+	}
+
+	rcu_read_lock();
+	entry = xas_load(&xas);
+	while (gfn < end) {
+		if (xas_retry(&xas, entry))
+			continue;
+
+		KVM_BUG_ON(gfn != xas.xa_index, kvm);
+
+		if (entry)
+			private = true;
+		else
+			shared = true;
+
+		if (private && shared) {
+			mixed = true;
+			goto out;
+		}
+
+		entry = xas_next(&xas);
+		gfn++;
+	}
+out:
+	rcu_read_unlock();
+	return mixed;
+}
+
+static inline void update_mixed(struct kvm_lpage_info *linfo, bool mixed)
+{
+	if (mixed)
+		linfo->disallow_lpage |= KVM_LPAGE_PRIVATE_SHARED_MIXED;
+	else
+		linfo->disallow_lpage &= ~KVM_LPAGE_PRIVATE_SHARED_MIXED;
+}
+
+static void update_mem_lpage_info(struct kvm *kvm,
+				  struct kvm_memory_slot *slot,
+				  unsigned int attr,
+				  gfn_t start, gfn_t end)
+{
+	unsigned long lpage_start, lpage_end;
+	unsigned long gfn, pages, mask;
+	int level;
+
+	for (level = PG_LEVEL_2M; level <= KVM_MAX_HUGEPAGE_LEVEL; level++) {
+		pages = KVM_PAGES_PER_HPAGE(level);
+		mask = ~(pages - 1);
+		lpage_start = start & mask;
+		lpage_end = end & mask;
+
+		/*
+		 * We only need to scan the head and tail page, for middle pages
+		 * we know they are not mixed.
+		 */
+		update_mixed(lpage_info_slot(lpage_start, slot, level),
+			     mem_attr_is_mixed(kvm, attr, lpage_start,
+							  lpage_start + pages));
+
+		if (lpage_start == lpage_end)
+			return;
+
+		for (gfn = lpage_start + pages; gfn < lpage_end; gfn += pages) {
+			update_mixed(lpage_info_slot(gfn, slot, level), false);
+		}
+
+		update_mixed(lpage_info_slot(lpage_end, slot, level),
+			     mem_attr_is_mixed(kvm, attr, lpage_end,
+							  lpage_end + pages));
+	}
+}
+
+void kvm_arch_update_mem_attr(struct kvm *kvm, unsigned int attr,
+			      gfn_t start, gfn_t end)
+{
+	struct kvm_memory_slot *slot;
+	struct kvm_memslots *slots;
+	struct kvm_memslot_iter iter;
+	int i;
+
+	WARN_ONCE(!(attr & (KVM_MEM_ATTR_PRIVATE | KVM_MEM_ATTR_SHARED)),
+			"Unsupported mem attribute.\n");
+
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		slots = __kvm_memslots(kvm, i);
+
+		kvm_for_each_memslot_in_gfn_range(&iter, slots, start, end) {
+			slot = iter.slot;
+			start = max(start, slot->base_gfn);
+			end = min(end, slot->base_gfn + slot->npages);
+			if (WARN_ON_ONCE(start >= end))
+				continue;
+
+			update_mem_lpage_info(kvm, slot, attr, start, end);
+		}
+	}
+}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d45f00f5b3ee..7b18fcd71df5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2282,6 +2282,10 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 #define  KVM_DIRTY_RING_MAX_ENTRIES  65536
 
 #ifdef CONFIG_HAVE_KVM_PRIVATE_MEM
+
+#define KVM_MEM_ATTR_SHARED	0x0001
+#define KVM_MEM_ATTR_PRIVATE	0x0002
+
 static inline int kvm_private_mem_get_pfn(struct kvm_memory_slot *slot,
 					  gfn_t gfn, kvm_pfn_t *pfn, int *order)
 {
@@ -2307,6 +2311,16 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 	return !!xa_load(&kvm->mem_attr_array, gfn);
 }
 
+#ifdef __KVM_HAVE_ARCH_UPDATE_MEM_ATTR
+void kvm_arch_update_mem_attr(struct kvm *kvm, unsigned int attr,
+			      gfn_t start, gfn_t end);
+#else
+static inline void kvm_arch_update_mem_attr(struct kvm *kvm, unsigned int attr,
+					    gfn_t start, gfn_t end)
+{
+}
+#endif
+
 #endif /* CONFIG_HAVE_KVM_PRIVATE_MEM */
 
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1ba4b9e5449c..1d22c8603f91 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -863,12 +863,12 @@ static int kvm_init_mmu_notifier(struct kvm *kvm)
 #endif /* CONFIG_MMU_NOTIFIER && KVM_ARCH_WANT_MMU_NOTIFIER */
 
 #ifdef CONFIG_HAVE_KVM_PRIVATE_MEM
-#define KVM_MEM_ATTR_PRIVATE	0x0001
 static int kvm_vm_ioctl_set_encrypted_region(struct kvm *kvm, unsigned int ioctl,
 					     struct kvm_enc_region *region)
 {
 	unsigned long start, end;
 	void *entry;
+	int attr;
 	int r;
 
 	if (region->size == 0 || region->addr + region->size < region->addr)
@@ -879,13 +879,19 @@ static int kvm_vm_ioctl_set_encrypted_region(struct kvm *kvm, unsigned int ioctl
 	start = region->addr >> PAGE_SHIFT;
 	end = (region->addr + region->size - 1) >> PAGE_SHIFT;
 
-	entry = ioctl == KVM_MEMORY_ENCRYPT_REG_REGION ?
-				xa_mk_value(KVM_MEM_ATTR_PRIVATE) : NULL;
+	if (ioctl == KVM_MEMORY_ENCRYPT_REG_REGION) {
+		attr = KVM_MEM_ATTR_PRIVATE;
+		entry = xa_mk_value(KVM_MEM_ATTR_PRIVATE);
+	} else {
+		attr = KVM_MEM_ATTR_SHARED;
+		entry = NULL;
+	}
 
 	r = xa_err(xa_store_range(&kvm->mem_attr_array, start, end,
 					entry, GFP_KERNEL_ACCOUNT));
 
 	kvm_zap_gfn_range(kvm, start, end + 1);
+	kvm_arch_update_mem_attr(kvm, attr, start, end + 1);
 
 	return r;
 }
-- 
2
