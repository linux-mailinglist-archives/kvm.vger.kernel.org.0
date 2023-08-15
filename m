Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFC377D0CA
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 19:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238750AbjHORTm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 13:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238709AbjHORTN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 13:19:13 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB211BC2;
        Tue, 15 Aug 2023 10:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692119952; x=1723655952;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0Nfl6CiEe9l9TCE09frQgEkEYx1zNWnP5lOrklwZ2vo=;
  b=fLTydvfTeUfRtxQ/AYYylpqSXzDZfycgfttQ3UPU6XIsaQNcH1KnpJij
   XwQnPZuV77GqWHybOgZPVz3slnlye5n7Yh+IKyscctecnWSJgDrgX7gMJ
   RrlhvGv4xpukYARaSAJybfyba83RwpOdMyD0NlCVkhn7Pn+eOZTH3lzvd
   nizOzTEPSTTbV0Bq7m23XxNblZCJYDZmMZpWpBT/r/J+x1CnD4kC8BKfi
   WBUk23wc0zk5vGMRXiCLPti4HTAZr4rfevG8Cxvo8poqEf907JbuKj7kZ
   8F0glBED1S5taNecPV7kr+G+yfZn2dAMO2/g6/CX8YWH/zXkUwzaDHWoe
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="362488606"
X-IronPort-AV: E=Sophos;i="6.01,175,1684825200"; 
   d="scan'208";a="362488606"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2023 10:19:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="848148978"
X-IronPort-AV: E=Sophos;i="6.01,175,1684825200"; 
   d="scan'208";a="848148978"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2023 10:19:05 -0700
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
Subject: [PATCH 4/8] KVM: gmem: protect kvm_mmu_invalidate_end()
Date:   Tue, 15 Aug 2023 10:18:51 -0700
Message-Id: <b37fb13a9aeb8683d5fdd5351cdc5034639eb2bb.1692119201.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1692119201.git.isaku.yamahata@intel.com>
References: <cover.1692119201.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

kvm_mmu_invalidate_end() updates struct kvm::mmu_invalidate_in_progress
and it's protected by kvm::mmu_lock.  call kvm_mmu_invalidate_end() before
unlocking it. Not after the unlock.

Fixes: 8e9009ca6d14 ("KVM: Introduce per-page memory attributes")
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 virt/kvm/kvm_main.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8bfeb615fc4d..49380cd62367 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -535,6 +535,7 @@ struct kvm_mmu_notifier_range {
 	} arg;
 	gfn_handler_t handler;
 	on_lock_fn_t on_lock;
+	on_unlock_fn_t before_unlock;
 	on_unlock_fn_t on_unlock;
 	bool flush_on_ret;
 	bool may_block;
@@ -629,6 +630,8 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 		kvm_flush_remote_tlbs(kvm);
 
 	if (locked) {
+		if (!IS_KVM_NULL_FN(range->before_unlock))
+			range->before_unlock(kvm);
 		KVM_MMU_UNLOCK(kvm);
 		if (!IS_KVM_NULL_FN(range->on_unlock))
 			range->on_unlock(kvm);
@@ -653,6 +656,7 @@ static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
 		.arg.pte	= pte,
 		.handler	= handler,
 		.on_lock	= (void *)kvm_null_fn,
+		.before_unlock	= (void *)kvm_null_fn,
 		.on_unlock	= (void *)kvm_null_fn,
 		.flush_on_ret	= true,
 		.may_block	= false,
@@ -672,6 +676,7 @@ static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn
 		.end		= end,
 		.handler	= handler,
 		.on_lock	= (void *)kvm_null_fn,
+		.before_unlock	= (void *)kvm_null_fn,
 		.on_unlock	= (void *)kvm_null_fn,
 		.flush_on_ret	= false,
 		.may_block	= false,
@@ -776,6 +781,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 		.end		= range->end,
 		.handler	= kvm_mmu_unmap_gfn_range,
 		.on_lock	= kvm_mmu_invalidate_begin,
+		.before_unlock	= (void *)kvm_null_fn,
 		.on_unlock	= kvm_arch_guest_memory_reclaimed,
 		.flush_on_ret	= true,
 		.may_block	= mmu_notifier_range_blockable(range),
@@ -815,6 +821,8 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 
 void kvm_mmu_invalidate_end(struct kvm *kvm)
 {
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
 	/*
 	 * This sequence increase will notify the kvm page fault that
 	 * the page that is going to be mapped in the spte could have
@@ -846,6 +854,7 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 		.end		= range->end,
 		.handler	= (void *)kvm_null_fn,
 		.on_lock	= kvm_mmu_invalidate_end,
+		.before_unlock	= (void *)kvm_null_fn,
 		.on_unlock	= (void *)kvm_null_fn,
 		.flush_on_ret	= false,
 		.may_block	= mmu_notifier_range_blockable(range),
@@ -2433,6 +2442,8 @@ static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
 		kvm_flush_remote_tlbs(kvm);
 
 	if (locked) {
+		if (!IS_KVM_NULL_FN(range->before_unlock))
+			range->before_unlock(kvm);
 		KVM_MMU_UNLOCK(kvm);
 		if (!IS_KVM_NULL_FN(range->on_unlock))
 			range->on_unlock(kvm);
@@ -2447,6 +2458,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, unsigned long attributes,
 		.end = end,
 		.handler = kvm_mmu_unmap_gfn_range,
 		.on_lock = kvm_mmu_invalidate_begin,
+		.before_unlock	= (void *)kvm_null_fn,
 		.on_unlock = (void *)kvm_null_fn,
 		.flush_on_ret = true,
 		.may_block = true,
@@ -2457,7 +2469,8 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, unsigned long attributes,
 		.arg.attributes = attributes,
 		.handler = kvm_arch_post_set_memory_attributes,
 		.on_lock = (void *)kvm_null_fn,
-		.on_unlock = kvm_mmu_invalidate_end,
+		.before_unlock = kvm_mmu_invalidate_end,
+		.on_unlock = (void *)kvm_null_fn,
 		.may_block = true,
 	};
 	unsigned long i;
-- 
2.25.1

