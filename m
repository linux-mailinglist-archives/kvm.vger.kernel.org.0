Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A33C77D0C4
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 19:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238731AbjHORTj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 13:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238216AbjHORTM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 13:19:12 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F211BC2;
        Tue, 15 Aug 2023 10:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692119950; x=1723655950;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5UFL8g4pHO7FMqMvTNqcXsSv7Q/kEXEGlxS+r2b9T+I=;
  b=FArx3jlro3xIWOdfhXiVlnfQhq+DQRWZMpQdytlQYeBdoY4ZTtRf/9nf
   zWcUaAGvUUcKx871bp6N0gKPMHO3+aEy/eBZwSy+UR2nmsybhSYGY+6GA
   zYWuuLIuLVI5feg0+J+lI6idfn/URbm50E6rNjnlHPQQMfvg7jQvB4gOV
   c70TwJ0Kl0/NI+46y1RDmE3MEPKCKGmhylToG0v0L+3u77Sl4WSo0zbBA
   96x/BWEGham4raLjMaLIgFYuUptj+XsDDHcIcPwMHKHhQS9optufPtZfY
   9NfJepRj+LN9EOpavA5FbmjWvJTANk4PL71j9DbbzhXij4W8aRkJuK4hA
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="436229840"
X-IronPort-AV: E=Sophos;i="6.01,175,1684825200"; 
   d="scan'208";a="436229840"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2023 10:19:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="907693400"
X-IronPort-AV: E=Sophos;i="6.01,175,1684825200"; 
   d="scan'208";a="907693400"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2023 10:19:06 -0700
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
Subject: [PATCH 6/8] KVM: gmem, x86: Add gmem hook for invalidating private memory
Date:   Tue, 15 Aug 2023 10:18:53 -0700
Message-Id: <8c9f0470ba6e5dc122f3f4e37c4dcfb6fb97b184.1692119201.git.isaku.yamahata@intel.com>
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

From: Michael Roth <michael.roth@amd.com>

TODO: add a CONFIG option that can be to completely skip arch
invalidation loop and avoid __weak references for arch/platforms that
don't need an additional invalidation hook.

In some cases, like with SEV-SNP, guest memory needs to be updated in a
platform-specific manner before it can be safely freed back to the host.
Add hooks to wire up handling of this sort when freeing memory in
response to FALLOC_FL_PUNCH_HOLE operations.

Also issue invalidations of all allocated pages when releasing the gmem
file so that the pages are not left in an unusable state when they get
freed back to the host.

Signed-off-by: Michael Roth <michael.roth@amd.com>
Link: https://lore.kernel.org/r/20230612042559.375660-3-michael.roth@amd.com

---
Changes v4 -> v5:
- Fix compile issue by adding static inline when gmem is disabled

Changes v2 -> v3:
- Newly added
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/x86.c                 |  6 +++++
 include/linux/kvm_host.h           |  3 +++
 virt/kvm/guest_mem.c               | 42 ++++++++++++++++++++++++++++++
 5 files changed, 53 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 439ba4beb5af..48f043de2ec0 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -134,6 +134,7 @@ KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
+KVM_X86_OP_OPTIONAL(gmem_invalidate)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2bc42f2887fa..17e78f9f2d17 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1735,6 +1735,7 @@ struct kvm_x86_ops {
 
 	int (*gmem_prepare)(struct kvm *kvm, struct kvm_memory_slot *slot,
 			    kvm_pfn_t pfn, gfn_t gfn, u8 *max_level);
+	void (*gmem_invalidate)(struct kvm *kvm, kvm_pfn_t start, kvm_pfn_t end);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index de195ad83ec0..b54818d02cb1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13274,6 +13274,12 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
 
+#ifdef CONFIG_KVM_PRIVATE_MEM
+void kvm_arch_gmem_invalidate(struct kvm *kvm, kvm_pfn_t start, kvm_pfn_t end)
+{
+	static_call_cond(kvm_x86_gmem_invalidate)(kvm, start, end);
+}
+#endif
 
 int kvm_spec_ctrl_test_value(u64 value)
 {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 091bc89ae805..349b0bf81fa5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2358,6 +2358,7 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 #ifdef CONFIG_KVM_PRIVATE_MEM
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 			      gfn_t gfn, kvm_pfn_t *pfn, int *max_order);
+void kvm_arch_gmem_invalidate(struct kvm *kvm, kvm_pfn_t start, kvm_pfn_t end);
 #else
 static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
@@ -2366,6 +2367,8 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 	KVM_BUG_ON(1, kvm);
 	return -EIO;
 }
+
+static inline void kvm_arch_gmem_invalidate(struct kvm *kvm, kvm_pfn_t start, kvm_pfn_t end) { }
 #endif /* CONFIG_KVM_PRIVATE_MEM */
 
 #endif
diff --git a/virt/kvm/guest_mem.c b/virt/kvm/guest_mem.c
index ed03f1d12172..342d2938716a 100644
--- a/virt/kvm/guest_mem.c
+++ b/virt/kvm/guest_mem.c
@@ -127,6 +127,46 @@ static void kvm_gmem_invalidate_end(struct kvm_gmem *gmem, pgoff_t start,
 	KVM_MMU_UNLOCK(kvm);
 }
 
+void __weak kvm_arch_gmem_invalidate(struct kvm *kvm, kvm_pfn_t start, kvm_pfn_t end)
+{
+}
+
+/* Handle arch-specific hooks needed before releasing guarded pages. */
+static void kvm_gmem_issue_arch_invalidate(struct kvm *kvm, struct file *file,
+					   pgoff_t start, pgoff_t end)
+{
+	pgoff_t file_end = i_size_read(file_inode(file)) >> PAGE_SHIFT;
+	pgoff_t index = start;
+
+	end = min(end, file_end);
+
+	while (index < end) {
+		struct folio *folio;
+		unsigned int order;
+		struct page *page;
+		kvm_pfn_t pfn;
+
+		folio = __filemap_get_folio(file->f_mapping, index,
+					    FGP_LOCK, 0);
+		if (!folio) {
+			index++;
+			continue;
+		}
+
+		page = folio_file_page(folio, index);
+		pfn = page_to_pfn(page);
+		order = folio_order(folio);
+
+		kvm_arch_gmem_invalidate(kvm, pfn, pfn + min((1ul << order), end - index));
+
+		index = folio_next_index(folio);
+		folio_unlock(folio);
+		folio_put(folio);
+
+		cond_resched();
+	}
+}
+
 static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 {
 	struct list_head *gmem_list = &inode->i_mapping->private_list;
@@ -143,6 +183,7 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	list_for_each_entry(gmem, gmem_list, entry)
 		kvm_gmem_invalidate_begin(gmem, start, end);
 
+	kvm_gmem_issue_arch_invalidate(kvm, file, start, end);
 	truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
 
 	list_for_each_entry(gmem, gmem_list, entry)
@@ -253,6 +294,7 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	 * memory, as its lifetime is associated with the inode, not the file.
 	 */
 	kvm_gmem_invalidate_begin(gmem, 0, -1ul);
+	kvm_gmem_issue_arch_invalidate(gmem->kvm, file, 0, -1ul);
 	kvm_gmem_invalidate_end(gmem, 0, -1ul);
 
 	list_del(&gmem->entry);
-- 
2.25.1

