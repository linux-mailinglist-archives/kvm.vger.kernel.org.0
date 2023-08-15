Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB76377D0C3
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 19:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238726AbjHORTi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 13:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238704AbjHORTM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 13:19:12 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3339A1BCB;
        Tue, 15 Aug 2023 10:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692119951; x=1723655951;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fnhmYRSLLF7upnCUT+rF6FBxCOUm7AKxntdwOQGVU48=;
  b=nxlTRel/kQ67/0a8wwv1RLZj0whFlMvBgqlqGYgzQuRjPuQ9zQadzrw1
   9EysTS3mGXR+lC7PVnx/FTeAEhu1pt3MP1Y3l5Om8k1evOueMyl51STK1
   d2lIF/kA38QZC6pxsBjPrtOL9nbkPsQkfsDc+UhqtiaWwP+worWg/50VU
   DZScYAhZTn7vQC9xWiBQRjXVLgr8Z0Huo+51tRknW91ehQjfgPiX/pEc7
   PqFbOO3H0FyJXH5TWZnj8stgtA1RoXo9h+rdxaC+YiF+6oEmQkD1jBPdL
   LgVceTcQb0NxYcn1wWKiJphHyrN0+oj9ctKajh9vVqheXywypFjOdMlJt
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="436229858"
X-IronPort-AV: E=Sophos;i="6.01,175,1684825200"; 
   d="scan'208";a="436229858"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2023 10:19:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="907693416"
X-IronPort-AV: E=Sophos;i="6.01,175,1684825200"; 
   d="scan'208";a="907693416"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2023 10:19:08 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Xu Yilun <yilun.xu@intel.com>,
        Quentin Perret <qperret@google.com>, wei.w.wang@intel.com,
        Fuad Tabba <tabba@google.com>
Subject: [PATCH 8/8] RFC: KVM: gmem: Guarantee the order of destruction
Date:   Tue, 15 Aug 2023 10:18:55 -0700
Message-Id: <72655345e07a02028c9239ccb2c3633dd72bbf9d.1692119201.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1692119201.git.isaku.yamahata@intel.com>
References: <cover.1692119201.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Call kvm_flush_shadow_all() before releasing kvm gmem file on the guest
destruction.

The current gmem doesn't guarantee the destruction order between kvm gmem
and kvm_mmu_notifier_release(), which calls kvm_flush_shadow_all().  When
destructing TD guest, it's efficient to call kvm_flush_shadow_all() before
calling kvm_gmem_issue_arch_invalidate() on releasing its struct file
because kvm_flush_shadow_all() releases its host key ID (HKID).  After
releasing HKID, the TDX module doesn't have to validate the consistency of
the Secure-EPT structure.

One way is to make struct kvm to reference kvm gmem file.  The current gmem
implementation chose to make kvm gmem file to reference struct kvm.  So
reference from struct kvm to reference kvm gmem file results in a circular
reference.  Use kvm_mmu_notifier_release() to break it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 include/linux/kvm_host.h | 24 ++++++++++++++++++++++++
 virt/kvm/kvm_main.c      | 23 ++++++++++++++++++++++-
 2 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 349b0bf81fa5..d717945702a8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -594,6 +594,10 @@ struct kvm_memory_slot {
 	u16 as_id;
 
 #ifdef CONFIG_KVM_PRIVATE_MEM
+#ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
+	struct file *file;
+#endif
+	/* Private guest_mem */
 	struct {
 		struct file __rcu *file;
 		pgoff_t pgoff;
@@ -601,6 +605,26 @@ struct kvm_memory_slot {
 #endif
 };
 
+static inline int kvm_memslot_gmem_fget(struct kvm_memory_slot *memslot, int fd)
+{
+#if defined(CONFIG_KVM_PRIVATE_MEM) && defined(CONFIG_KVM_GENERIC_MMU_NOTIFIER)
+	memslot->file = fget(fd);
+	if (!memslot->file)
+		return -EBADF;
+#endif
+	return 0;
+}
+
+static inline void kvm_memslot_gmem_fput(struct kvm_memory_slot *memslot)
+{
+#if defined(CONFIG_KVM_PRIVATE_MEM) && defined(CONFIG_KVM_GENERIC_MMU_NOTIFIER)
+	if (memslot->file) {
+		fput(memslot->file);
+		memslot->file = NULL;
+	}
+#endif
+}
+
 static inline bool kvm_slot_can_be_private(const struct kvm_memory_slot *slot)
 {
 	return slot && (slot->flags & KVM_MEM_PRIVATE);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4855d0b7a859..35bc3b64b7e4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -926,6 +926,7 @@ static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
 {
 	struct kvm *kvm = mmu_notifier_to_kvm(mn);
 	int idx;
+	int i;
 
 	/*
 	 * Avoide race with kvm_gmem_release().
@@ -936,6 +937,18 @@ static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
 	idx = srcu_read_lock(&kvm->srcu);
 	kvm_flush_shadow_all(kvm);
 	srcu_read_unlock(&kvm->srcu, idx);
+
+	/* Break circular reference count: kvm->gmem, gmem->kvm. */
+	for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
+		struct kvm_memslots *slots = __kvm_memslots(kvm, i);
+		struct kvm_memory_slot *memslot;
+		struct hlist_node *tmp;
+		int bkt;
+
+		hash_for_each_safe(slots->id_hash, bkt, tmp, memslot, id_node[slots->node_idx])
+			kvm_memslot_gmem_fput(memslot);
+	}
+
 	mutex_unlock(&kvm->slots_lock);
 }
 
@@ -1008,8 +1021,10 @@ static void kvm_destroy_dirty_bitmap(struct kvm_memory_slot *memslot)
 /* This does not remove the slot from struct kvm_memslots data structures */
 static void kvm_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
-	if (slot->flags & KVM_MEM_PRIVATE)
+	if (slot->flags & KVM_MEM_PRIVATE) {
 		kvm_gmem_unbind(slot);
+		kvm_memslot_gmem_fput(slot);
+	}
 
 	kvm_destroy_dirty_bitmap(slot);
 
@@ -1734,6 +1749,8 @@ static void kvm_commit_memory_region(struct kvm *kvm,
 		if (old->dirty_bitmap && !new->dirty_bitmap)
 			kvm_destroy_dirty_bitmap(old);
 
+		kvm_memslot_gmem_fput(old);
+
 		/*
 		 * The final quirk.  Free the detached, old slot, but only its
 		 * memory, not any metadata.  Metadata, including arch specific
@@ -2088,6 +2105,9 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	new->flags = mem->flags;
 	new->userspace_addr = mem->userspace_addr;
 	if (mem->flags & KVM_MEM_PRIVATE) {
+		r = kvm_memslot_gmem_fget(new, mem->gmem_fd);
+		if (r)
+			goto out;
 		r = kvm_gmem_bind(kvm, new, mem->gmem_fd, mem->gmem_offset);
 		if (r)
 			goto out;
@@ -2103,6 +2123,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	if (mem->flags & KVM_MEM_PRIVATE)
 		kvm_gmem_unbind(new);
 out:
+	kvm_memslot_gmem_fput(new);
 	kfree(new);
 	return r;
 }
-- 
2.25.1

