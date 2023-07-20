Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8F7E75BB3F
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 01:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbjGTXd3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 19:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbjGTXdR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 19:33:17 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008C32726;
        Thu, 20 Jul 2023 16:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689895996; x=1721431996;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ggAHQUAr6ssNNMu9eAzv9bii3A6Zv7CddzoLl/MzcTs=;
  b=COL4TnQsm7yecA0HJnFAUxqeWYQkr+UIUJQlDNZDwDo6Fl2Uw7TZC9iZ
   bX/oCxVyFWIduMdjFpLFoeT2+mzHLzzfid9a/r5ac/V4iWVE43YzXHwyK
   mAdKH0bEmmuK60m5GYFY9SmJchIzGXQlO5svJM8RRBUSOhAXKl5UCMlh1
   9KFYfiY/CW1QdMqu7WlXcJNa1JkX+4cbIaUeswciUU+D17abQGwWuRp2W
   YSkkcXrVXdFuC8ercs5kT9eTeB3q5zQS9DWJCuSvgFpW1nEoXwTrja65R
   uX902iahVc7Hl0/ij3W2uM6K4QB2T2CTNHYVFnBgp6kA6/Td8Ue/Dtmtj
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="364355961"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="364355961"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 16:33:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="727891803"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="727891803"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 16:33:12 -0700
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
        Yuan Yao <yuan.yao@linux.intel.com>
Subject: [RFC PATCH v4 08/10] KVM: x86: Add gmem hook for invalidating private memory
Date:   Thu, 20 Jul 2023 16:32:54 -0700
Message-Id: <1233d749211c08d51f9ca5d427938d47f008af1f.1689893403.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1689893403.git.isaku.yamahata@intel.com>
References: <cover.1689893403.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
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
index a4cb248519cf..d520c6370cd6 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -135,6 +135,7 @@ KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
+KVM_X86_OP_OPTIONAL(gmem_invalidate)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index de7f0dffa135..440a4a13a93f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1738,6 +1738,7 @@ struct kvm_x86_ops {
 
 	int (*gmem_prepare)(struct kvm *kvm, struct kvm_memory_slot *slot,
 			    kvm_pfn_t pfn, gfn_t gfn, u8 *max_level);
+	void (*gmem_invalidate)(struct kvm *kvm, kvm_pfn_t start, kvm_pfn_t end);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fd6c05d1883c..2ae40fa8e178 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13284,6 +13284,12 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
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
index ce4d91585368..6c5d39e429e9 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2360,6 +2360,7 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 #ifdef CONFIG_KVM_PRIVATE_MEM
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 			      gfn_t gfn, kvm_pfn_t *pfn, int *max_order);
+void kvm_arch_gmem_invalidate(struct kvm *kvm, kvm_pfn_t start, kvm_pfn_t end);
 #else
 static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
@@ -2368,6 +2369,8 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 	KVM_BUG_ON(1, kvm);
 	return -EIO;
 }
+
+void kvm_arch_gmem_invalidate(struct kvm *kvm, kvm_pfn_t start, kvm_pfn_t end) { }
 #endif /* CONFIG_KVM_PRIVATE_MEM */
 
 #endif
diff --git a/virt/kvm/guest_mem.c b/virt/kvm/guest_mem.c
index ac185c776cda..a14eaac9dbad 100644
--- a/virt/kvm/guest_mem.c
+++ b/virt/kvm/guest_mem.c
@@ -129,6 +129,46 @@ static void kvm_gmem_invalidate_end(struct kvm_gmem *gmem, pgoff_t start,
 	KVM_MMU_UNLOCK(kvm);
 }
 
+void __weak kvm_arch_gmem_invalidate(struct kvm *kvm, kvm_pfn_t start, kvm_pfn_t end)
+{
+}
+
+/* Handle arch-specific hooks needed before releasing guarded pages. */
+static void kvm_gmem_issue_arch_invalidate(struct kvm *kvm, struct inode *inode,
+					   pgoff_t start, pgoff_t end)
+{
+	pgoff_t file_end = i_size_read(inode) >> PAGE_SHIFT;
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
+		folio = __filemap_get_folio(inode->i_mapping, index,
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
@@ -145,6 +185,7 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	list_for_each_entry(gmem, gmem_list, entry)
 		kvm_gmem_invalidate_begin(gmem, start, end);
 
+	kvm_gmem_issue_arch_invalidate(gmem->kvm, inode, start, end);
 	truncate_inode_pages_range(inode->i_mapping, offset, offset + len - 1);
 
 	list_for_each_entry(gmem, gmem_list, entry)
@@ -255,6 +296,7 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	 * memory, as its lifetime is associated with the inode, not the file.
 	 */
 	kvm_gmem_invalidate_begin(gmem, 0, -1ul);
+	kvm_gmem_issue_arch_invalidate(gmem->kvm, inode, 0, -1ul);
 	kvm_gmem_invalidate_end(gmem, 0, -1ul);
 
 	mutex_unlock(&kvm->slots_lock);
-- 
2.25.1

