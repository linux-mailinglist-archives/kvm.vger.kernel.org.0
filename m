Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C86E86A3CAD
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbjB0I0a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbjB0IZn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:25:43 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 230B51D910;
        Mon, 27 Feb 2023 00:24:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486263; x=1709022263;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dNS0sA+3cs/IyUzhFlhglO96msoXa6kMetWLyhQaOEw=;
  b=dVnjVbUqGzG5Inl7DaOCnr54yp8+0livfZuS3r7dZUvZ3aBpqK00O85W
   XFqo+9/4EuCNdFrbvkVa0cB+iSwNuyCSH4PUVAqeuJ7uSDsuQw1rhaUbH
   Qut9cjCxuNGeafPPBljdYkHrfcTlrvdj8PzxMjhygyxPsjyXzZpcVCakP
   51pw3/0bJC7ZzcJ0ElUQjMujaHNYXdj7u+I0w4U6zm6uVVFqOqmri6me5
   D5wYYFtwMRU61RugWatU01tE2m14XVhlpUqX3xAJjDaRHe6a3g/JaN8wp
   uOzHrQ6l7rAS+K8lVNJBJ3V1GkSzMESkLCxXMsd+IKHUcM43mZsTRnt6D
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317608822"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317608822"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:07 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242177"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242177"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:07 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v12 037/106] KVM: Add flags to struct kvm_gfn_range
Date:   Mon, 27 Feb 2023 00:22:36 -0800
Message-Id: <3f815ce9665313a5f1fedcf6afebb746ea6de678.1677484918.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1677484918.git.isaku.yamahata@intel.com>
References: <cover.1677484918.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index f6470338d5fa..5e4bf78025e3 100644
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

