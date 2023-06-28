Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC74741BDE
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 00:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbjF1Wom (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 18:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbjF1Wn1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 18:43:27 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93DF2728;
        Wed, 28 Jun 2023 15:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687992206; x=1719528206;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R6aeeOVtCVl/aF4rr9VOp5md60UJagkTMuBGcdbekMM=;
  b=QOCMc1NmYINHU7HXGIdpdYk6l9m6WRlH8hbbzwzS/RUpFaMqc45O9WeT
   u3vIyxtvJ+FuqTkOJF9wrBovBww+ODBibSgapAvHrHgcV0xri33plpoqn
   ObvcdBNUzDdZKtv0JLJ67dTfytaNLwgOYACiQGDuuDHQ68m3BIn6KY4L1
   DcPuj+o+FYHnRKH0o97+f4Jm+MnTdKB/Xfi7GdQWeEwySc3/PMBAABGPZ
   BBB8PGGjWOuFEmGMM4LAubXkVRplUXx0CLuFao0vO+RDn2cdmd5CclaXt
   bSXMkPk8Z7aSq89WNozP4Qo1LpdPleneg7pXExeJn0PukPZ61Q8fypJtp
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="392699190"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="392699190"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 15:43:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="830300029"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="830300029"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 15:43:25 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Yuan Yao <yuan.yao@linux.intel.com>
Subject: [RFC PATCH v3 11/11] KVM: x86: Add gmem hook for invalidating private memory
Date:   Wed, 28 Jun 2023 15:43:10 -0700
Message-Id: <e57fc6834a49e9773f0dc54eac650b21bb7e5476.1687991811.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1687991811.git.isaku.yamahata@intel.com>
References: <cover.1687991811.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
 arch/x86/kvm/x86.c                 |  6 ++++
 include/linux/kvm_host.h           |  3 ++
 virt/kvm/guest_mem.c               | 48 ++++++++++++++++++++++++++++--
 5 files changed, 57 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index cce8621e3216..a864a2093002 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -136,6 +136,7 @@ KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
+KVM_X86_OP_OPTIONAL(gmem_invalidate)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 653f208979cf..a91d17fa2fe8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1741,6 +1741,7 @@ struct kvm_x86_ops {
 
 	int (*gmem_prepare)(struct kvm *kvm, struct kvm_memory_slot *slot,
 			    kvm_pfn_t pfn, gfn_t gfn, u8 *max_level);
+	void (*gmem_invalidate)(struct kvm *kvm, kvm_pfn_t start, kvm_pfn_t end);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b5f865f39a00..e722ace8150d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13260,6 +13260,12 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
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
index 5ca0c8ee4292..cfd98572d8be 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2346,6 +2346,7 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 #ifdef CONFIG_KVM_PRIVATE_MEM
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 			      gfn_t gfn, kvm_pfn_t *pfn, int *order);
+void kvm_arch_gmem_invalidate(struct kvm *kvm, kvm_pfn_t start, kvm_pfn_t end);
 #else
 static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
@@ -2354,6 +2355,8 @@ static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 	KVM_BUG_ON(1, kvm);
 	return -EIO;
 }
+
+void kvm_arch_gmem_invalidate(struct kvm *kvm, kvm_pfn_t start, kvm_pfn_t end) { }
 #endif /* CONFIG_KVM_PRIVATE_MEM */
 
 #endif
diff --git a/virt/kvm/guest_mem.c b/virt/kvm/guest_mem.c
index 63ac006db7ee..5b8e11760d28 100644
--- a/virt/kvm/guest_mem.c
+++ b/virt/kvm/guest_mem.c
@@ -142,16 +142,58 @@ static void kvm_gmem_invalidate_end(struct kvm *kvm, struct kvm_gmem *gmem,
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
 static long kvm_gmem_punch_hole(struct file *file, loff_t offset, loff_t len)
 {
 	struct kvm_gmem *gmem = file->private_data;
-	pgoff_t start = offset >> PAGE_SHIFT;
-	pgoff_t end = (offset + len) >> PAGE_SHIFT;
 	struct kvm *kvm = gmem->kvm;
+	pgoff_t start, end;
 
 	if (!PAGE_ALIGNED(offset) || !PAGE_ALIGNED(len))
 		return 0;
 
+	start = offset >> PAGE_SHIFT;
+	end = (offset + len) >> PAGE_SHIFT;
+
 	/*
 	 * Bindings must stable across invalidation to ensure the start+end
 	 * are balanced.
@@ -160,6 +202,7 @@ static long kvm_gmem_punch_hole(struct file *file, loff_t offset, loff_t len)
 
 	kvm_gmem_invalidate_begin(kvm, gmem, start, end);
 
+	kvm_gmem_issue_arch_invalidate(kvm, file, start, end);
 	truncate_inode_pages_range(file->f_mapping, offset, offset + len - 1);
 
 	kvm_gmem_invalidate_end(kvm, gmem, start, end);
@@ -266,6 +309,7 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	 * pointed at this file.
 	 */
 	kvm_gmem_invalidate_begin(kvm, gmem, 0, -1ul);
+	kvm_gmem_issue_arch_invalidate(gmem->kvm, file, 0, -1ul);
 	truncate_inode_pages_final(file->f_mapping);
 	kvm_gmem_invalidate_end(kvm, gmem, 0, -1ul);
 
-- 
2.25.1

