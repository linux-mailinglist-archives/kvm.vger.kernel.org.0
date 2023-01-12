Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C322667B7C
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240380AbjALQnF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:43:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240183AbjALQib (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:38:31 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8EE1B1DA;
        Thu, 12 Jan 2023 08:34:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541242; x=1705077242;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8tKpWJ6dGu0PFUpmHJd6TKXbCbQWdvtgkc200MFqP1s=;
  b=gfJCV5HIKJXZJBNfF9nbEnoYqjlA+jWwaG+9j8+s39LHYYXf+i85XZX5
   ATYYVZ1u15DFQ2ARh3OxiTz1TyS5HVZXaLpLkn8/pKj0Sli/5CtIQY2qp
   7ZwVvlor072BUvrSYAvAVBGoP7vQkDRJ+eOX1jnJRKFEoFsHXKbG6eRjo
   RN9uCeb0taWD9fmmsZ6wlcJf9+oFPlDfkManQDx9xLR+NcTBDQvWJsBBj
   iLKEKofZ+MoKi0U0ZZCLy1h9yVhyR68qgix1RTc1+dSJZ5cU8eucN2KG2
   MdEcO7diPbDLyrD+5FZ10xOK6xST1JJ3iYXY9qI3Gq60aWc6xtm+V4iaT
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323811852"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323811852"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:27 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="721151777"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="721151777"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:27 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 042/113] KVM: Add flags to struct kvm_gfn_range
Date:   Thu, 12 Jan 2023 08:31:50 -0800
Message-Id: <3e5e7c40608e9fc1b3aff53fca0ba9b3a37744b3.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
shared memory slot to zap shared PTE.  For set memattr, it's the operation
of private<->shared conversion, zap the original PTE.  For restrictedmem,
it's punching a hole of the range, zap the corresponding PTE.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 include/linux/kvm_host.h | 9 ++++++++-
 virt/kvm/kvm_main.c      | 5 ++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index cd1f3634dd6a..0c3b9cf0a731 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -256,12 +256,19 @@ bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
 #endif
 
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
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6c61b71b56d2..aef8802b188e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -669,6 +669,7 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 			gfn_range.start = hva_to_gfn_memslot(hva_start, slot);
 			gfn_range.end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, slot);
 			gfn_range.slot = slot;
+			gfn_range.flags = 0;
 
 			if (!locked) {
 				locked = true;
@@ -971,6 +972,7 @@ static void kvm_restrictedmem_invalidate_begin(struct restrictedmem_notifier *no
 	gfn_range.slot = slot;
 	gfn_range.pte = __pte(0);
 	gfn_range.may_block = true;
+	gfn_range.flags = KVM_GFN_RANGE_FLAGS_RESTRICTED_MEM;
 
 	idx = srcu_read_lock(&kvm->srcu);
 	KVM_MMU_LOCK(kvm);
@@ -2511,8 +2513,9 @@ static void kvm_unmap_mem_range(struct kvm *kvm, gfn_t start, gfn_t end,
 	int i;
 	int r = 0;
 
-	gfn_range.pte = __pte(0);
+	gfn_range.attrs = attrs;
 	gfn_range.may_block = true;
+	gfn_range.flags = KVM_GFN_RANGE_FLAGS_SET_MEM_ATTR;
 
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
 		slots = __kvm_memslots(kvm, i);
-- 
2.25.1

