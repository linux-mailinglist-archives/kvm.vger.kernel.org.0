Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC647142E0
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 06:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbjE2EZv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 00:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbjE2EZK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 00:25:10 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 406011BCA;
        Sun, 28 May 2023 21:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685334175; x=1716870175;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UfQhankowrOfocqHnx82KgNDag+zEFmpnCWpxYUwfxU=;
  b=Dk7a0CIy+5u0RYQ5Ad4Wiz7mbSVL7qCPKt0J8+J5ODeY6R0WQpGid9xf
   9ie/RBOSzdhwyFhmRxH/qYokFs4Xj/nQbEy9PtmZNUlfkN4or56EVDADV
   261XxppdhhpeXZk+UaibnC7OrUWJh1D+FkN6UUgImGDySDuv7Ep8IBj5/
   givEL0Qyt9FjyB+N0CNNzKCNoBekYxViMGueHGitYp0Zmt8N+Tu5uJbJn
   MDJmsCIOxYma/zUczs1sdsSr5d4aBvZPyPhB2Q0/jPTAI73/qJTSyOeFD
   eAnvvTeJooAAjHmgs0rvHXDMgRBnep4p9Y+Uzn1O5YCWVpmM8DPXAZvGb
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="334965972"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="334965972"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="775784300"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="775784300"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:14 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com
Subject: [PATCH v14 043/113] KVM: Add flags to struct kvm_gfn_range
Date:   Sun, 28 May 2023 21:19:25 -0700
Message-Id: <b0018f31c00a4f24b82806a1f23733a769db84f6.1685333727.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1685333727.git.isaku.yamahata@intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
 virt/kvm/guest_mem.c     |  1 +
 virt/kvm/kvm_main.c      |  4 +++-
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 44d8209d9869..d97eeba38774 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -256,12 +256,20 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
 #endif
 
 #ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
+
+#define KVM_GFN_RANGE_FLAGS_GMEM		BIT(0)
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
diff --git a/virt/kvm/guest_mem.c b/virt/kvm/guest_mem.c
index 41f89d9c8118..647c0503f79f 100644
--- a/virt/kvm/guest_mem.c
+++ b/virt/kvm/guest_mem.c
@@ -116,6 +116,7 @@ static void kvm_gmem_invalidate_begin(struct kvm *kvm, struct kvm_gmem *gmem,
 			.slot = slot,
 			.pte = __pte(0),
 			.may_block = true,
+			.flags = KVM_GFN_RANGE_FLAGS_GMEM,
 		};
 
 		if (WARN_ON_ONCE(start < slot->gmem.index ||
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0d8edc686e9d..49a64f040df5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -629,6 +629,7 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 			gfn_range.start = hva_to_gfn_memslot(hva_start, slot);
 			gfn_range.end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, slot);
 			gfn_range.slot = slot;
+			gfn_range.flags = 0;
 
 			if (!locked) {
 				locked = true;
@@ -2421,8 +2422,9 @@ static void kvm_mem_attrs_changed(struct kvm *kvm, unsigned long attrs,
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

