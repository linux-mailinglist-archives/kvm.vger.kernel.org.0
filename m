Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9EE73AD12
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 01:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbjFVXRm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 19:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbjFVXRk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 19:17:40 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F24C11992;
        Thu, 22 Jun 2023 16:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687475846; x=1719011846;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zBMD9h2KBgIYaddcweRh+FeZhoyrRw3SBUE0qo0cW8k=;
  b=SEjhHTfvXLCgluYg021G2iTKdA5LDkSOKdkhXU1v+CHdm2IVFUerXhJE
   h3iwWXs7bTbW5+PM2JbrDEgffMPJMht7OJ2DpeJhOixZzEg7AnpNti1BP
   ID4KuG49DywQxBD2Ze95SOAo65HONypM1B2cN8J60THygaKxMCLOr+rNF
   GcNX21PzL7JneeZufKAP1O1afH5Zuvwy46GYpTMLvTqj8HZXWRBykPWjX
   bazv26LGkceO79h0IYKF35vLBJHY8GD9tvydgt/AZ8EGmb848SZ/JFl/s
   EhBXemdGWZWs2Hu+gfM70616ikeYhMLkxtDZB1Nxifelvr3SiTS94JEj+
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="358129743"
X-IronPort-AV: E=Sophos;i="6.01,150,1684825200"; 
   d="scan'208";a="358129743"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2023 16:17:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="718285986"
X-IronPort-AV: E=Sophos;i="6.01,150,1684825200"; 
   d="scan'208";a="718285986"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2023 16:17:13 -0700
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
        Michael Roth <michael.roth@amd.com>
Subject: [RFC PATCH v2 5/6] KVM: Add flags to struct kvm_gfn_range
Date:   Thu, 22 Jun 2023 16:16:29 -0700
Message-Id: <689da77417c2f4055f02a71aab51ff603bc195af.1687474039.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1687474039.git.isaku.yamahata@intel.com>
References: <cover.1687474039.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add flags to strut kvm_gfn_range to indicate who triggered the callback
and new memory attributes.

TDX needs to know the reason for a callback by kvm_unmap_gfn_range().  mmu
notifier, set memory attributes ioctl or KVM gmem callback.  With TDX,
zapping a private page from the encrypted page table and adding the page
back to the same private GPA results in zeroing the page, and the guest has
to accept the page again.  On the change of memory attribute from private
to shared, zapping the GPA range irrespective to private-or-shared and
expecting the fault doesn't work for TDX.  Instead, zap shared pages only
and keep the private pages.  Concretely
- If it's from mmu notifier, zap shared pages.
- If it's from KVM gmem, zap private pages.
- If setting memory attributes to private, zap shared pages.
- If setting memory attributes to shared, zap private pages.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

---
Changes v1 -> v2:
- consolidate KVM_GFN_RANGE_FLAGS_GMEM_{PUNCH_HOLE, RELEASE} into
  KVM_GFN_RANGE_FLAGS_GMEM.
- Update the commit message to describe TDX more.  Drop SEV_SNP.
---
 include/linux/kvm_host.h | 10 +++++++++-
 virt/kvm/guest_mem.c     |  9 ++++++---
 virt/kvm/kvm_main.c      |  4 +++-
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1a47cedae8a1..1fe0516fcddf 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -256,12 +256,20 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
 #endif
 
 #ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
+
+#define KVM_GFN_RANGE_FLAGS_SET_MEM_ATTR	BIT(0)
+#define KVM_GFN_RANGE_FLAGS_GMEM		BIT(1)
+
 struct kvm_gfn_range {
 	struct kvm_memory_slot *slot;
 	gfn_t start;
 	gfn_t end;
-	pte_t pte;
+	union {
+		pte_t pte;
+		u64 attrs;
+	};
 	bool may_block;
+	unsigned int flags;
 };
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
diff --git a/virt/kvm/guest_mem.c b/virt/kvm/guest_mem.c
index cdf2d84683c8..387226136960 100644
--- a/virt/kvm/guest_mem.c
+++ b/virt/kvm/guest_mem.c
@@ -99,7 +99,8 @@ static struct folio *kvm_gmem_get_folio(struct file *file, pgoff_t index)
 }
 
 static void kvm_gmem_invalidate_begin(struct kvm *kvm, struct kvm_gmem *gmem,
-				      pgoff_t start, pgoff_t end)
+				      pgoff_t start, pgoff_t end,
+				      unsigned int flags)
 {
 	struct kvm_memory_slot *slot;
 	unsigned long index;
@@ -118,6 +119,7 @@ static void kvm_gmem_invalidate_begin(struct kvm *kvm, struct kvm_gmem *gmem,
 			.slot = slot,
 			.pte = __pte(0),
 			.may_block = true,
+			.flags = flags,
 		};
 
 		kvm_mmu_invalidate_range_add(kvm, gfn_range.start, gfn_range.end);
@@ -156,7 +158,8 @@ static long kvm_gmem_punch_hole(struct file *file, loff_t offset, loff_t len)
 	 */
 	filemap_invalidate_lock(file->f_mapping);
 
-	kvm_gmem_invalidate_begin(kvm, gmem, start, end);
+	kvm_gmem_invalidate_begin(kvm, gmem, start, end,
+				  KVM_GFN_RANGE_FLAGS_GMEM);
 
 	truncate_inode_pages_range(file->f_mapping, offset, offset + len - 1);
 
@@ -263,7 +266,7 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
 	 * Free the backing memory, and more importantly, zap all SPTEs that
 	 * pointed at this file.
 	 */
-	kvm_gmem_invalidate_begin(kvm, gmem, 0, -1ul);
+	kvm_gmem_invalidate_begin(kvm, gmem, 0, -1ul, KVM_GFN_RANGE_FLAGS_GMEM);
 	truncate_inode_pages_final(file->f_mapping);
 	kvm_gmem_invalidate_end(kvm, gmem, 0, -1ul);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 422d49634c56..9cdfa2fb675f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -613,6 +613,7 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 			gfn_range.start = hva_to_gfn_memslot(hva_start, slot);
 			gfn_range.end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, slot);
 			gfn_range.slot = slot;
+			gfn_range.flags = 0;
 
 			if (!locked) {
 				locked = true;
@@ -2391,8 +2392,9 @@ static void kvm_mem_attrs_changed(struct kvm *kvm, unsigned long attrs,
 	bool flush = false;
 	int i;
 
-	gfn_range.pte = __pte(0);
+	gfn_range.attrs = attrs;
 	gfn_range.may_block = true;
+	gfn_range.flags = KVM_GFN_RANGE_FLAGS_SET_MEM_ATTR;
 
 	for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
 		slots = __kvm_memslots(kvm, i);
-- 
2.25.1

