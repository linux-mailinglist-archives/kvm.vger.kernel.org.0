Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC20E6B693A
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 19:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbjCLSA0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 14:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbjCLR7i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 13:59:38 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FAA81A481;
        Sun, 12 Mar 2023 10:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678643901; x=1710179901;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/iwgvZoLkV+XwFmAi8g9NAv7l9e15O/03OqBEW366BA=;
  b=GgZkjAQIusWkOIyljoZc7XZNFeGE398UkOuXz5/Ijq7032eCO5DctgUe
   smos+Who5r0JWz1WrWGdiB+nnaYOgpMwmk8w2Fz19MByeP9cR5sYyfY7W
   +yWFJ63Zs65ClwwX4uSqld5v0B4ob+j+hKyToPy67VI8XAaoPuRwmq9VX
   Mjn7af3SiGBLgyyPyLLX2YpY3peZBuwEK03X7yQm+5p42AlCiWopLSE6L
   5vTYOtysIf7uNiSErrPaN0+9kBTmgFZAcEwEZAj3OclSLfZcnKw2NQbxO
   S3qsKJx5ZmuF4hI3JM2msvxi6ylZeTMTQI8/vGHc4Olh5mYNaHwFDQPqb
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="316659866"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316659866"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="742596618"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="742596618"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:04 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v13 043/113] KVM: Add flags to struct kvm_gfn_range
Date:   Sun, 12 Mar 2023 10:56:07 -0700
Message-Id: <6dbe73a2d6d3040a0e6dac8a720c1e3c981e1864.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1678643051.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

kvm_unmap_gfn_range() needs to know the reason of the callback for TDX.
mmu notifier, set memattr ioctl or restrictedmem notifier.  Based on the
reason, TDX changes the behavior.  For mmu notifier, it's the operation on
shared memory slot to zap shared PTE.  For set memattr, it's the operation
of private<->shared conversion, zap the original PTE.  For restrictedmem,
it's punching a hole of the range, zap the corresponding PTE.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 include/linux/kvm_host.h | 10 +++++++++-
 virt/kvm/kvm_main.c      |  5 ++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 115cdca6384f..5a144497c930 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -257,12 +257,20 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
 #endif
 
 #ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
+
+#define KVM_GFN_RANGE_FLAGS_RESTRICTED_MEM	BIT(0)
+#define KVM_GFN_RANGE_FLAGS_SET_MEM_ATTR	BIT(1)
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
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 87400796df6e..d6db3f19ad74 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -626,6 +626,7 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 			gfn_range.start = hva_to_gfn_memslot(hva_start, slot);
 			gfn_range.end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, slot);
 			gfn_range.slot = slot;
+			gfn_range.flags = 0;
 
 			if (!locked) {
 				locked = true;
@@ -957,6 +958,7 @@ static int restrictedmem_get_gfn_range(struct kvm_memory_slot *slot,
 	range->slot = slot;
 	range->pte = __pte(0);
 	range->may_block = true;
+	range->flags = KVM_GFN_RANGE_FLAGS_RESTRICTED_MEM;
 	return 0;
 }
 
@@ -2557,8 +2559,9 @@ static void kvm_mem_attrs_changed(struct kvm *kvm, unsigned long attrs,
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

