Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C282C58BDE5
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242267AbiHGWbz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242163AbiHGWbh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:31:37 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97491834F;
        Sun,  7 Aug 2022 15:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659910728; x=1691446728;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MjryHD9QygxcfdweTRylKf8TyhZNoq+ECeI3q06/RPQ=;
  b=VdSb6bvirF1FD0kP00pjdO7i9yih+WWAR0nQZEsyaQIqYWjD4tLlGLvz
   vtxRZ7ziW2Q52mMg5BN0nCSnKD8Y5uIToQTFt1vUUSzCg8OH5JsSA8QNj
   oUhu5fMyxDwODOUynGMyhn1btp0+HAQ2RO6ZqYE2g9+vS4aiPvUgqvYie
   ixjQ2WjfhFfqICw778kYFpwOXJJ2KvroiyVLX7FAON0SHSXLLyTEIqmmH
   lhmpOB2biUHEJNzkyv1Fe6axMvESfRfpdC5W3Ka/+fSknKI5HFOGrWtn8
   rCPSBHW7E3L3BA4iubuGGF0Oae8Q7P/qm8IWgpiGC9cUdus4TthlMHPve
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="270852829"
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="270852829"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:18:48 -0700
X-IronPort-AV: E=Sophos;i="5.93,221,1654585200"; 
   d="scan'208";a="632642298"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:18:47 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH 01/13] KVM: Update lpage info when private/shared memory are mixed
Date:   Sun,  7 Aug 2022 15:18:34 -0700
Message-Id: <80242041681cff8c215329f3d7ad02581e3e7ca2.1659854957.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854957.git.isaku.yamahata@intel.com>
References: <cover.1659854957.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Chao Peng <chao.p.peng@linux.intel.com>

Update lpage_info when private/shared memory attribute is changed.  If both
private and shared pages are within large page region, it can't be mapped
as large page. Reserve a bit in disallow_lpage to indicate a large page has
private/share pages mixed.

Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h |   8 ++
 arch/x86/kvm/mmu/mmu.c          | 152 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/mmu/mmu_internal.h |   2 +
 include/linux/kvm_host.h        |  10 +++
 virt/kvm/kvm_main.c             |   9 +-
 5 files changed, 178 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d68130be5bf7..2bdb1de9bce0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -37,6 +37,7 @@
 #include <asm/hyperv-tlfs.h>
 
 #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
+#define __KVM_HAVE_ARCH_UPDATE_MEM_ATTR
 #define __KVM_HAVE_ZAP_GFN_RANGE
 
 #define KVM_MAX_VCPUS 1024
@@ -981,6 +982,13 @@ struct kvm_vcpu_arch {
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
index c61fb6848d0d..a03aa609a0da 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -818,11 +818,16 @@ static void update_gfn_disallow_lpage_count(const struct kvm_memory_slot *slot,
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
 
@@ -7236,3 +7241,148 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
 	if (kvm->arch.nx_lpage_recovery_thread)
 		kthread_stop(kvm->arch.nx_lpage_recovery_thread);
 }
+
+bool kvm_mem_attr_is_mixed(struct kvm_memory_slot *slot, gfn_t gfn, int level)
+{
+	gfn_t pages = KVM_PAGES_PER_HPAGE(level);
+	gfn_t mask = ~(pages - 1);
+	struct kvm_lpage_info *linfo = lpage_info_slot(gfn & mask, slot, level);
+
+	WARN_ON(level == PG_LEVEL_4K);
+	return linfo->disallow_lpage & KVM_LPAGE_PRIVATE_SHARED_MIXED;
+}
+
+static void update_mixed(struct kvm_lpage_info *linfo, bool mixed)
+{
+	if (mixed)
+		linfo->disallow_lpage |= KVM_LPAGE_PRIVATE_SHARED_MIXED;
+	else
+		linfo->disallow_lpage &= ~KVM_LPAGE_PRIVATE_SHARED_MIXED;
+}
+
+static bool __mem_attr_is_mixed(struct kvm *kvm, gfn_t start, gfn_t end)
+{
+	XA_STATE(xas, &kvm->mem_attr_array, start);
+	bool mixed = false;
+	gfn_t gfn = start;
+	void *s_entry;
+	void *entry;
+
+	rcu_read_lock();
+	s_entry = xas_load(&xas);
+	while (gfn < end) {
+		if (xas_retry(&xas, entry))
+			continue;
+
+		KVM_BUG_ON(gfn != xas.xa_index, kvm);
+
+		entry = xas_next(&xas);
+		if (entry != s_entry) {
+			mixed = true;
+			break;
+		}
+		gfn++;
+	}
+	rcu_read_unlock();
+	return mixed;
+}
+
+static bool mem_attr_is_mixed(struct kvm *kvm,
+			      struct kvm_memory_slot *slot, int level,
+			      gfn_t start, gfn_t end)
+{
+	struct kvm_lpage_info *child_linfo;
+	unsigned long child_pages;
+	bool mixed = false;
+	unsigned long gfn;
+	void *entry;
+
+	if (WARN_ON(level == PG_LEVEL_4K))
+		return false;
+
+	if (level == PG_LEVEL_2M)
+		return __mem_attr_is_mixed(kvm, start, end);
+
+	/* This assumes that level - 1 is already updated. */
+	rcu_read_lock();
+	child_pages = KVM_PAGES_PER_HPAGE(level - 1);
+	entry = xa_load(&kvm->mem_attr_array, start);
+	for (gfn = start; gfn < end; gfn += child_pages) {
+		child_linfo = lpage_info_slot(gfn, slot, level - 1);
+		if (child_linfo->disallow_lpage & KVM_LPAGE_PRIVATE_SHARED_MIXED) {
+			mixed = true;
+			break;
+		}
+		if (xa_load(&kvm->mem_attr_array, gfn) != entry) {
+			mixed = true;
+			break;
+		}
+	}
+	rcu_read_unlock();
+	return mixed;
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
+		lpage_end = (end - 1) & mask;
+
+		/*
+		 * We only need to scan the head and tail page, for middle pages
+		 * we know they are not mixed.
+		 */
+		update_mixed(lpage_info_slot(lpage_start, slot, level),
+			     mem_attr_is_mixed(kvm, slot, level,
+					       lpage_start, lpage_start + pages));
+
+		if (lpage_start == lpage_end)
+			return;
+
+		for (gfn = lpage_start + pages; gfn < lpage_end; gfn += pages) {
+			update_mixed(lpage_info_slot(gfn, slot, level), false);
+		}
+
+		update_mixed(lpage_info_slot(lpage_end, slot, level),
+			     mem_attr_is_mixed(kvm, slot, level,
+					       lpage_end, lpage_end + pages));
+	}
+}
+
+void kvm_arch_update_mem_attr(struct kvm *kvm, unsigned int attr,
+			      gfn_t start, gfn_t end)
+{
+	struct kvm_memory_slot *slot;
+	struct kvm_memslots *slots;
+	struct kvm_memslot_iter iter;
+	int idx;
+	int i;
+
+	WARN_ONCE(!(attr & (KVM_MEM_ATTR_PRIVATE | KVM_MEM_ATTR_SHARED)),
+		  "Unsupported mem attribute.\n");
+
+	idx = srcu_read_lock(&kvm->srcu);
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
+	srcu_read_unlock(&kvm->srcu, idx);
+}
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 4b581209b3b9..e5d5fea29bfa 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -259,6 +259,8 @@ static inline gfn_t kvm_gfn_for_root(struct kvm *kvm, struct kvm_mmu_page *root,
 }
 #endif
 
+bool kvm_mem_attr_is_mixed(struct kvm_memory_slot *slot, gfn_t gfn, int level);
+
 static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
 {
 	/*
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3c29e0eb754c..7e3d582cc1ba 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2295,6 +2295,16 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 /* Max number of entries allowed for each kvm dirty ring */
 #define  KVM_DIRTY_RING_MAX_ENTRIES  65536
 
+#ifdef __KVM_HAVE_ARCH_UPDATE_MEM_ATTR
+void kvm_arch_update_mem_attr(struct kvm *kvm, unsigned int attr,
+			      gfn_t start, gfn_t end);
+#else
+static inline void kvm_arch_update_mem_attr(struct kvm *kvm, unsigned int attr,
+					    gfn_t start, gfn_t end)
+{
+}
+#endif /* __KVM_HAVE_ARCH_UPDATE_MEM_ATTR */
+
 #ifdef CONFIG_HAVE_KVM_PRIVATE_MEM
 static inline int kvm_private_mem_get_pfn(struct kvm_memory_slot *slot,
 					  gfn_t gfn, kvm_pfn_t *pfn, int *order)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2ec940354749..9f9b2c0e7afc 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -943,6 +943,7 @@ EXPORT_SYMBOL_GPL(kvm_vm_reserve_mem_attr);
 int kvm_vm_set_mem_attr(struct kvm *kvm, int attr, gfn_t start, gfn_t end)
 {
 	void *entry;
+	int r;
 
 	/* By default, the entry is private. */
 	switch (attr) {
@@ -958,8 +959,12 @@ int kvm_vm_set_mem_attr(struct kvm *kvm, int attr, gfn_t start, gfn_t end)
 	}
 
 	WARN_ON(start >= end);
-	return xa_err(xa_store_range(&kvm->mem_attr_array, start, end - 1,
-				     entry, GFP_KERNEL_ACCOUNT));
+	r = xa_err(xa_store_range(&kvm->mem_attr_array, start, end - 1,
+				  entry, GFP_KERNEL_ACCOUNT));
+	if (r)
+		return r;
+	kvm_arch_update_mem_attr(kvm, attr, start, end);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(kvm_vm_set_mem_attr);
 #endif /* CONFIG_HAVE_KVM_PRIVATE_MEM_ATTR */
-- 
2.25.1

