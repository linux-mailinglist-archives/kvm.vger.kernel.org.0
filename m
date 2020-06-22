Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158E72041DF
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 22:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730449AbgFVUVA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 16:21:00 -0400
Received: from mga07.intel.com ([134.134.136.100]:62017 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728745AbgFVUUi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 16:20:38 -0400
IronPort-SDR: jAAIWjmKGLn8U41LUUN7vDcbZTOdIzNKp5rxxzHiuyBcJbJmGyT/lcFEOloD714MrZSXG9hhEI
 umQR7+48gHNw==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="209057482"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="209057482"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 13:20:37 -0700
IronPort-SDR: WJTSeeBv8SkuO1JJWrdwFHVGCL0wNFlb6EBPUSrlb7v8/+Eny0F4WBU0SZs0/T2i76/1aldOAB
 twFu4wbCCDCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="478506333"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga006.fm.intel.com with ESMTP; 22 Jun 2020 13:20:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] KVM: x86/mmu: Make kvm_mmu_page definition and accessor internal-only
Date:   Mon, 22 Jun 2020 13:20:32 -0700
Message-Id: <20200622202034.15093-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200622202034.15093-1-sean.j.christopherson@intel.com>
References: <20200622202034.15093-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make 'struct kvm_mmu_page' MMU-only, nothing outside of the MMU should
be poking into the gory details of shadow pages.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 46 ++-----------------------------
 arch/x86/kvm/mmu/mmu_internal.h | 48 +++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 44 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f8998e97457f..86933c467a1e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -322,43 +322,6 @@ struct kvm_rmap_head {
 	unsigned long val;
 };
 
-struct kvm_mmu_page {
-	struct list_head link;
-	struct hlist_node hash_link;
-	struct list_head lpage_disallowed_link;
-
-	bool unsync;
-	u8 mmu_valid_gen;
-	bool mmio_cached;
-	bool lpage_disallowed; /* Can't be replaced by an equiv large page */
-
-	/*
-	 * The following two entries are used to key the shadow page in the
-	 * hash table.
-	 */
-	union kvm_mmu_page_role role;
-	gfn_t gfn;
-
-	u64 *spt;
-	/* hold the gfn of each spte inside spt */
-	gfn_t *gfns;
-	int root_count;          /* Currently serving as active root */
-	unsigned int unsync_children;
-	struct kvm_rmap_head parent_ptes; /* rmap pointers to parent sptes */
-	DECLARE_BITMAP(unsync_child_bitmap, 512);
-
-#ifdef CONFIG_X86_32
-	/*
-	 * Used out of the mmu-lock to avoid reading spte values while an
-	 * update is in progress; see the comments in __get_spte_lockless().
-	 */
-	int clear_spte_count;
-#endif
-
-	/* Number of writes since the last time traversal visited this page.  */
-	atomic_t write_flooding_count;
-};
-
 struct kvm_pio_request {
 	unsigned long linear_rip;
 	unsigned long count;
@@ -384,6 +347,8 @@ struct kvm_mmu_root_info {
 
 #define KVM_MMU_NUM_PREV_ROOTS 3
 
+struct kvm_mmu_page;
+
 /*
  * x86 supports 4 paging modes (5-level 64-bit, 4-level 64-bit, 3-level 32-bit,
  * and 2-level 32-bit).  The kvm_mmu structure abstracts the details of the
@@ -1557,13 +1522,6 @@ static inline gpa_t translate_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
 	return gpa;
 }
 
-static inline struct kvm_mmu_page *page_header(hpa_t shadow_page)
-{
-	struct page *page = pfn_to_page(shadow_page >> PAGE_SHIFT);
-
-	return (struct kvm_mmu_page *)page_private(page);
-}
-
 static inline u16 kvm_read_ldt(void)
 {
 	u16 ldt;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index d7938c37c7de..8afa60f0a1a5 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -2,6 +2,54 @@
 #ifndef __KVM_X86_MMU_INTERNAL_H
 #define __KVM_X86_MMU_INTERNAL_H
 
+#include <linux/types.h>
+
+#include <asm/kvm_host.h>
+
+struct kvm_mmu_page {
+	struct list_head link;
+	struct hlist_node hash_link;
+	struct list_head lpage_disallowed_link;
+
+	bool unsync;
+	u8 mmu_valid_gen;
+	bool mmio_cached;
+	bool lpage_disallowed; /* Can't be replaced by an equiv large page */
+
+	/*
+	 * The following two entries are used to key the shadow page in the
+	 * hash table.
+	 */
+	union kvm_mmu_page_role role;
+	gfn_t gfn;
+
+	u64 *spt;
+	/* hold the gfn of each spte inside spt */
+	gfn_t *gfns;
+	int root_count;          /* Currently serving as active root */
+	unsigned int unsync_children;
+	struct kvm_rmap_head parent_ptes; /* rmap pointers to parent sptes */
+	DECLARE_BITMAP(unsync_child_bitmap, 512);
+
+#ifdef CONFIG_X86_32
+	/*
+	 * Used out of the mmu-lock to avoid reading spte values while an
+	 * update is in progress; see the comments in __get_spte_lockless().
+	 */
+	int clear_spte_count;
+#endif
+
+	/* Number of writes since the last time traversal visited this page.  */
+	atomic_t write_flooding_count;
+};
+
+static inline struct kvm_mmu_page *page_header(hpa_t shadow_page)
+{
+	struct page *page = pfn_to_page(shadow_page >> PAGE_SHIFT);
+
+	return (struct kvm_mmu_page *)page_private(page);
+}
+
 void kvm_mmu_gfn_disallow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_mmu_gfn_allow_lpage(struct kvm_memory_slot *slot, gfn_t gfn);
 bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
-- 
2.26.0

