Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC4C6127FC
	for <lists+kvm@lfdr.de>; Sun, 30 Oct 2022 07:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbiJ3G0A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 02:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiJ3GYY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 02:24:24 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9327013D;
        Sat, 29 Oct 2022 23:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667111050; x=1698647050;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YUg8weR2aBuIZsU1DmkInT5uDP4qgsrNtwkEufPJkfE=;
  b=DG7kLZrdzmX/DjvqATg8fTlIgD5eIGrClAIqC3yulhxg1irNeDZTWWVP
   /CtXe0D20v/adFGRmYna4UwiR3gMevSrNtf91Th2Z5KjMiHVQ8lGtfSt+
   OKeKWZrSgHDI3UOAgf1SMEiTRV5YfnzqcQDK+qBWVVD2SZGmtcM0fEsbU
   MegQfEHN2DP0EHCBeaLO1RNeO2Q+fkWajccfGKIhr5qDHIX6H+tis+ya0
   ILHIqUpySErN9n2fJ2xK+LY6kwUpJb4ETm0O2z2z3TqUfeenWDlm9NlsP
   9qmru/peSYNX4Wayp8R5KzjCHSJcosLhL+xwStmUexbh96BLzh+baOHot
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="395037158"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="395037158"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:04 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="878392995"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="878392995"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:04 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v10 046/108] KVM: Add flags to struct kvm_gfn_range
Date:   Sat, 29 Oct 2022 23:22:47 -0700
Message-Id: <880c1016c29624964baee580985b6a736fc7d656.1667110240.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1667110240.git.isaku.yamahata@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

kvm_unmap_gfn_range() needs to know the reason of the callback for TDX.
mmu notifier, set memattr ioctl or restrictedmem notifier.  Based on the
reason, TDX changes the behavior.  For mmu notifier, it's the operation on
shared memory slot to zap shared PTE.  For set memattr, private<->shared
conversion, zap the original PTE.  For restrictedmem, it's a hint that TDX
can ignore.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 include/linux/kvm_host.h | 8 +++++++-
 virt/kvm/kvm_main.c      | 5 ++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 839d98d56632..b658803ea2c7 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -247,12 +247,18 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
 
 
 #if defined(KVM_ARCH_WANT_MMU_NOTIFIER) || defined(CONFIG_HAVE_KVM_RESTRICTED_MEM)
+#define KVM_GFN_RANGE_FLAGS_RESTRICTED_MEM	BIT(0)
+#define KVM_GFN_RANGE_FLAGS_SET_MEM_ATTR	BIT(1)
 struct kvm_gfn_range {
 	struct kvm_memory_slot *slot;
 	gfn_t start;
 	gfn_t end;
-	pte_t pte;
+	union {
+		pte_t pte;
+		int attr;
+	};
 	bool may_block;
+	unsigned int flags;
 };
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3b05a3396f89..dda2f2ec4faa 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -676,6 +676,7 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 			gfn_range.start = hva_to_gfn_memslot(hva_start, slot);
 			gfn_range.end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, slot);
 			gfn_range.slot = slot;
+			gfn_range.flags = 0;
 
 			if (!locked) {
 				locked = true;
@@ -947,8 +948,9 @@ static void kvm_unmap_mem_range(struct kvm *kvm, gfn_t start, gfn_t end,
 	int i;
 	int r = 0;
 
-	gfn_range.pte = __pte(0);
+	gfn_range.attr = attr;
 	gfn_range.may_block = true;
+	gfn_range.flags = KVM_GFN_RANGE_FLAGS_SET_MEM_ATTR;
 
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
 		slots = __kvm_memslots(kvm, i);
@@ -1074,6 +1076,7 @@ static void kvm_restrictedmem_invalidate_begin(struct restrictedmem_notifier *no
 	gfn_range.slot = slot;
 	gfn_range.pte = __pte(0);
 	gfn_range.may_block = true;
+	gfn_range.flags = KVM_GFN_RANGE_FLAGS_RESTRICTED_MEM;
 
 	if (kvm_unmap_gfn_range(kvm, &gfn_range))
 		kvm_flush_remote_tlbs(kvm);
-- 
2.25.1

