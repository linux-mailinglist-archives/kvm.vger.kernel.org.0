Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0593D1BB30E
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 02:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgD1AyY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 20:54:24 -0400
Received: from mga05.intel.com ([192.55.52.43]:42479 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbgD1AyX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 20:54:23 -0400
IronPort-SDR: SB7FffDXeI1tt+vUZXoHRq047X34jtLSIJmieBLJARDDmUlx4ZKKkX5DEXSawjB8cH2RcRtq3h
 fdQyJ2AF5zPg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2020 17:54:23 -0700
IronPort-SDR: +zzRpVyzZdXBVrcbtszqBJKiiAbwc0dPNiIs1wPgxeLKq1nx5v+PFL2OpJyqC+1X9d7/ARiGOx
 joGqjmtiCnYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,325,1583222400"; 
   d="scan'208";a="260920806"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 27 Apr 2020 17:54:23 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Barret Rhoden <brho@google.com>
Subject: [PATCH 2/3] KVM: x86/mmu: Move max hugepage level to a separate #define
Date:   Mon, 27 Apr 2020 17:54:21 -0700
Message-Id: <20200428005422.4235-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200428005422.4235-1-sean.j.christopherson@intel.com>
References: <20200428005422.4235-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename PT_MAX_HUGEPAGE_LEVEL to KVM_MAX_HUGEPAGE_LEVEL and make it a
separate define in anticipation of dropping KVM's PT_*_LEVEL enums in
favor of the kernel's PG_LEVEL_* enums.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  5 ++---
 arch/x86/kvm/mmu/mmu.c          | 17 +++++++++--------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7cd68d1d0627..204f742bf096 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -114,10 +114,9 @@ enum {
 	PT_PAGE_TABLE_LEVEL   = 1,
 	PT_DIRECTORY_LEVEL    = 2,
 	PT_PDPE_LEVEL         = 3,
-	/* set max level to the biggest one */
-	PT_MAX_HUGEPAGE_LEVEL = PT_PDPE_LEVEL,
 };
-#define KVM_NR_PAGE_SIZES	(PT_MAX_HUGEPAGE_LEVEL - \
+#define KVM_MAX_HUGEPAGE_LEVEL	PT_PDPE_LEVEL
+#define KVM_NR_PAGE_SIZES	(KVM_MAX_HUGEPAGE_LEVEL - \
 				 PT_PAGE_TABLE_LEVEL + 1)
 #define KVM_HPAGE_GFN_SHIFT(x)	(((x) - 1) * 9)
 #define KVM_HPAGE_SHIFT(x)	(PAGE_SHIFT + KVM_HPAGE_GFN_SHIFT(x))
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e618472c572b..324734db25ce 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1199,7 +1199,7 @@ static void update_gfn_disallow_lpage_count(struct kvm_memory_slot *slot,
 	struct kvm_lpage_info *linfo;
 	int i;
 
-	for (i = PT_DIRECTORY_LEVEL; i <= PT_MAX_HUGEPAGE_LEVEL; ++i) {
+	for (i = PT_DIRECTORY_LEVEL; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
 		linfo = lpage_info_slot(gfn, slot, i);
 		linfo->disallow_lpage += count;
 		WARN_ON(linfo->disallow_lpage < 0);
@@ -1763,7 +1763,7 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
 	int i;
 	bool write_protected = false;
 
-	for (i = PT_PAGE_TABLE_LEVEL; i <= PT_MAX_HUGEPAGE_LEVEL; ++i) {
+	for (i = PT_PAGE_TABLE_LEVEL; i <= KVM_MAX_HUGEPAGE_LEVEL; ++i) {
 		rmap_head = __gfn_to_rmap(gfn, i, slot);
 		write_protected |= __rmap_write_protect(kvm, rmap_head, true);
 	}
@@ -1952,7 +1952,7 @@ static int kvm_handle_hva_range(struct kvm *kvm,
 			gfn_end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, memslot);
 
 			for_each_slot_rmap_range(memslot, PT_PAGE_TABLE_LEVEL,
-						 PT_MAX_HUGEPAGE_LEVEL,
+						 KVM_MAX_HUGEPAGE_LEVEL,
 						 gfn_start, gfn_end - 1,
 						 &iterator)
 				ret |= handler(kvm, iterator.rmap, memslot,
@@ -4214,7 +4214,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 {
 	int max_level;
 
-	for (max_level = PT_MAX_HUGEPAGE_LEVEL;
+	for (max_level = KVM_MAX_HUGEPAGE_LEVEL;
 	     max_level > PT_PAGE_TABLE_LEVEL;
 	     max_level--) {
 		int page_num = KVM_PAGES_PER_HPAGE(max_level);
@@ -5641,7 +5641,7 @@ slot_handle_all_level(struct kvm *kvm, struct kvm_memory_slot *memslot,
 		      slot_level_handler fn, bool lock_flush_tlb)
 {
 	return slot_handle_level(kvm, memslot, fn, PT_PAGE_TABLE_LEVEL,
-				 PT_MAX_HUGEPAGE_LEVEL, lock_flush_tlb);
+				 KVM_MAX_HUGEPAGE_LEVEL, lock_flush_tlb);
 }
 
 static __always_inline bool
@@ -5649,7 +5649,7 @@ slot_handle_large_level(struct kvm *kvm, struct kvm_memory_slot *memslot,
 			slot_level_handler fn, bool lock_flush_tlb)
 {
 	return slot_handle_level(kvm, memslot, fn, PT_PAGE_TABLE_LEVEL + 1,
-				 PT_MAX_HUGEPAGE_LEVEL, lock_flush_tlb);
+				 KVM_MAX_HUGEPAGE_LEVEL, lock_flush_tlb);
 }
 
 static __always_inline bool
@@ -5867,7 +5867,8 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 				continue;
 
 			slot_handle_level_range(kvm, memslot, kvm_zap_rmapp,
-						PT_PAGE_TABLE_LEVEL, PT_MAX_HUGEPAGE_LEVEL,
+						PT_PAGE_TABLE_LEVEL,
+						KVM_MAX_HUGEPAGE_LEVEL,
 						start, end - 1, true);
 		}
 	}
@@ -5889,7 +5890,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 
 	spin_lock(&kvm->mmu_lock);
 	flush = slot_handle_level(kvm, memslot, slot_rmap_write_protect,
-				start_level, PT_MAX_HUGEPAGE_LEVEL, false);
+				start_level, KVM_MAX_HUGEPAGE_LEVEL, false);
 	spin_unlock(&kvm->mmu_lock);
 
 	/*
-- 
2.26.0

