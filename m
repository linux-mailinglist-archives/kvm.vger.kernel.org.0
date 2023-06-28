Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2C8741BDB
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 00:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbjF1WoU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 18:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbjF1Wn1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 18:43:27 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE8A271B;
        Wed, 28 Jun 2023 15:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687992206; x=1719528206;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0O4z6SfvuczhQYYUrNCDtvfPr0mE8UJ5jvjA0cCcdRQ=;
  b=dQa30bG9+xY3raAv/AHb5Ao7LfD771dQKfGFceHzVMgaGvahasKzIqvP
   56SHkiAy6REVb43sjzZRIfNN/vwJ2ZDMXaeqVspUoldiKBYb5cx6jsVyk
   yhpuEv2gZTzn3spyXHB69jDxEaCX6xz0SLeNv7fPqRtO4CBJDVIi7BjLj
   9hbV4M0WAZXvHIO9AAS3X5ZIrwEoRp+0CUA4//qoTx22zfIu+6pL7qzOt
   d9XIyrAElDnBhpCSpmF2KU8zQRhFZL4uS1PwroUEG0Qd3BjKdDCk6ZWGh
   CGrrQeld7H87WnKLn9DvMQj4kbCc0hWXz4K8fGGPAxpG3QOgsa5BTpVNg
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="392699172"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="392699172"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 15:43:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="830300014"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="830300014"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 15:43:24 -0700
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
Subject: [RFC PATCH v3 09/11] KVM: Add new members to struct kvm_gfn_range to operate on
Date:   Wed, 28 Jun 2023 15:43:08 -0700
Message-Id: <bbd17dbe371d6b12b2e7670bef6a4f080267c300.1687991811.git.isaku.yamahata@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add new members to strut kvm_gfn_range to indicate which mapping
(private-vs-shared) to operate on.  only_private and only_shared.  Update
mmu notifier, set memory attributes ioctl or KVM gmem callback to
initialize them.

It was premature for set_memory_attributes ioctl to call
kvm_unmap_gfn_range().  Instead, let kvm_arch_ste_memory_attributes()
handle it and add a new x86 vendor callback to react to memory attribute
change.  [1]

- If it's from the mmu notifier, zap shared pages only
- If it's from the KVM gmem, zap private pages only
- If setting memory attributes, vendor callback checks new attributes
  and make decisions.
  SNP would do nothing and handle it later with gmem callback
  TDX callback would do as follows.
  When it converts pages to shared, zap private pages only.
  When it converts pages to private, zap shared pages only.

TDX needs to know which mapping to operate on.  Shared-EPT vs. Secure-EPT.
The following sequence to convert the GPA to private doesn't work for TDX
because the page can already be private.

1) Update memory attributes to private in memory attributes xarray
2) Zap the GPA range irrespective of private-or-shared.
   Even if the page is already private, zap the entry.
3) EPT violation on the GPA
4) Populate the GPA as private
   The page is zeroed, and the guest has to accept the page again.

In step 2, TDX wants to zap only shared pages and skip private ones.

[1] https://lore.kernel.org/all/ZJX0hk+KpQP0KUyB@google.com/

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

---
Changes v2 -> v3:
- Drop the KVM_GFN_RANGE flags
- Updated struct kvm_gfn_range
- Change kvm_arch_set_memory_attributes() to return bool for flush
- Added set_memory_attributes x86 op for vendor backends
- Refined commit message to describe TDX care concretely

Changes v1 -> v2:
- consolidate KVM_GFN_RANGE_FLAGS_GMEM_{PUNCH_HOLE, RELEASE} into
  KVM_GFN_RANGE_FLAGS_GMEM.
- Update the commit message to describe TDX more.  Drop SEV_SNP.
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  3 +++
 arch/x86/kvm/mmu/mmu.c             | 20 +++++++++++++++-----
 include/linux/kvm_host.h           | 13 ++++++++-----
 virt/kvm/guest_mem.c               |  2 ++
 virt/kvm/kvm_main.c                | 12 ++++++------
 6 files changed, 35 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index c0143906fe6d..fc65374a8bad 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -125,6 +125,7 @@ KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
 KVM_X86_OP_OPTIONAL(vm_copy_enc_context_from)
 KVM_X86_OP_OPTIONAL(vm_move_enc_context_from)
 KVM_X86_OP_OPTIONAL(guest_memory_reclaimed)
+KVM_X86_OP_OPTIONAL_RET0(set_memory_attributes)
 KVM_X86_OP(get_msr_feature)
 KVM_X86_OP(can_emulate_instruction)
 KVM_X86_OP(apic_init_signal_blocked)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index bdf507797c73..a4af4175034b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1534,6 +1534,8 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
 	return dest_mode_logical ? APIC_DEST_LOGICAL : APIC_DEST_PHYSICAL;
 }
 
+struct kvm_gfn_range;
+
 struct kvm_x86_ops {
 	const char *name;
 
@@ -1716,6 +1718,7 @@ struct kvm_x86_ops {
 	int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
 	int (*vm_move_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
 	void (*guest_memory_reclaimed)(struct kvm *kvm);
+	bool (*set_memory_attributes)(struct kvm *kvm, struct kvm_gfn_range *range);
 
 	int (*get_msr_feature)(struct kvm_msr_entry *entry);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5a80ec49bdcd..3795f447603c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7327,11 +7327,13 @@ static bool hugepage_has_attrs(struct kvm *kvm, struct kvm_memory_slot *slot,
 	return true;
 }
 
-void kvm_arch_set_memory_attributes(struct kvm *kvm,
-				    struct kvm_memory_slot *slot,
-				    unsigned long attrs,
-				    gfn_t start, gfn_t end)
+bool kvm_arch_set_memory_attributes(struct kvm *kvm, struct kvm_gfn_range *range)
 {
+	struct kvm_memory_slot *slot = range->slot;
+	unsigned long attrs = range->attributes;
+	gfn_t start = range->start;
+	gfn_t end = range->end;
+	bool flush = false;
 	int level;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
@@ -7342,7 +7344,13 @@ void kvm_arch_set_memory_attributes(struct kvm *kvm,
 	 * the slot if the slot will never consume the PRIVATE attribute.
 	 */
 	if (!kvm_slot_can_be_private(slot))
-		return;
+		return flush;
+
+	if (kvm->arch.vm_type == KVM_X86_PROTECTED_VM &&
+	    !kvm_x86_ops.set_memory_attributes)
+		flush = kvm_unmap_gfn_range(kvm, range);
+	else
+		flush = static_call(kvm_x86_set_memory_attributes)(kvm, range);
 
 	/*
 	 * The sequence matters here: upper levels consume the result of lower
@@ -7388,6 +7396,8 @@ void kvm_arch_set_memory_attributes(struct kvm *kvm,
 				hugepage_set_mixed(slot, gfn, level);
 		}
 	}
+
+	return flush;
 }
 
 void kvm_mmu_init_memslot_memory_attributes(struct kvm *kvm,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1a47cedae8a1..5ca0c8ee4292 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -260,7 +260,13 @@ struct kvm_gfn_range {
 	struct kvm_memory_slot *slot;
 	gfn_t start;
 	gfn_t end;
-	pte_t pte;
+	union {
+		unsigned long attributes;
+		pte_t pte;
+		unsigned long callback_arg; /* needs a better name */
+	};
+	bool only_private;
+	bool only_shared;
 	bool may_block;
 };
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
@@ -2323,10 +2329,7 @@ static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm, gfn_t gfn
 	return xa_to_value(xa_load(&kvm->mem_attr_array, gfn));
 }
 
-void kvm_arch_set_memory_attributes(struct kvm *kvm,
-				    struct kvm_memory_slot *slot,
-				    unsigned long attrs,
-				    gfn_t start, gfn_t end);
+bool kvm_arch_set_memory_attributes(struct kvm *kvm, struct kvm_gfn_range *range);
 
 static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
diff --git a/virt/kvm/guest_mem.c b/virt/kvm/guest_mem.c
index cdf2d84683c8..63ac006db7ee 100644
--- a/virt/kvm/guest_mem.c
+++ b/virt/kvm/guest_mem.c
@@ -117,6 +117,8 @@ static void kvm_gmem_invalidate_begin(struct kvm *kvm, struct kvm_gmem *gmem,
 			.end = slot->base_gfn + index_end - slot->gmem.index,
 			.slot = slot,
 			.pte = __pte(0),
+			.only_private = true,
+			.only_shared = false,
 			.may_block = true,
 		};
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fdef56f85174..c9bc0a6c9973 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -604,6 +604,8 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 			 * the second or later invocation of the handler).
 			 */
 			gfn_range.pte = range->pte;
+			gfn_range.only_private = false;
+			gfn_range.only_shared = true;
 			gfn_range.may_block = range->may_block;
 
 			/*
@@ -2391,7 +2393,9 @@ static void kvm_mem_attrs_changed(struct kvm *kvm, unsigned long attrs,
 	bool flush = false;
 	int i;
 
-	gfn_range.pte = __pte(0);
+	gfn_range.attributes = attrs;
+	gfn_range.only_private = false;
+	gfn_range.only_shared = false;
 	gfn_range.may_block = true;
 
 	for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
@@ -2405,11 +2409,7 @@ static void kvm_mem_attrs_changed(struct kvm *kvm, unsigned long attrs,
 				continue;
 			gfn_range.slot = slot;
 
-			flush |= kvm_unmap_gfn_range(kvm, &gfn_range);
-
-			kvm_arch_set_memory_attributes(kvm, slot, attrs,
-						       gfn_range.start,
-						       gfn_range.end);
+			flush |= kvm_arch_set_memory_attributes(kvm, &gfn_range);
 		}
 	}
 
-- 
2.25.1

