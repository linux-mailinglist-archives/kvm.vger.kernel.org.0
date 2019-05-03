Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70CF312B49
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 12:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbfECKJU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 06:09:20 -0400
Received: from mga06.intel.com ([134.134.136.31]:59997 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727477AbfECKJU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 06:09:20 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 May 2019 03:09:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,425,1549958400"; 
   d="scan'208";a="139552022"
Received: from khuang2-desk.gar.corp.intel.com ([10.254.24.58])
  by orsmga008.jf.intel.com with ESMTP; 03 May 2019 03:09:16 -0700
From:   Kai Huang <kai.huang@linux.intel.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com
Cc:     sean.j.christopherson@intel.com, junaids@google.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        guangrong.xiao@gmail.com, tglx@linutronix.de, bp@alien8.de,
        hpa@zytor.com, kai.huang@intel.com,
        Kai Huang <kai.huang@linux.intel.com>
Subject: [PATCH 1/2] kvm: x86: Move kvm_set_mmio_spte_mask() from x86.c to mmu.c
Date:   Fri,  3 May 2019 22:08:52 +1200
Message-Id: <3198383324baefec8c39b31678813620f7ece647.1556877940.git.kai.huang@linux.intel.com>
X-Mailer: git-send-email 2.13.6
In-Reply-To: <cover.1556877940.git.kai.huang@linux.intel.com>
References: <cover.1556877940.git.kai.huang@linux.intel.com>
In-Reply-To: <cover.1556877940.git.kai.huang@linux.intel.com>
References: <cover.1556877940.git.kai.huang@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As a prerequisite to fix several SPTE reserved bits related calculation
errors caused by MKTME, which requires kvm_set_mmio_spte_mask() to use
local static variable defined in mmu.c.

Also move call site of kvm_set_mmio_spte_mask() from kvm_arch_init() to
kvm_mmu_module_init() so that kvm_set_mmio_spte_mask() can be static.

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Kai Huang <kai.huang@linux.intel.com>
---
 arch/x86/kvm/mmu.c | 31 +++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c | 31 -------------------------------
 2 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index b1f6451022e5..c0a3d120167b 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -5989,6 +5989,35 @@ static void mmu_destroy_caches(void)
 	kmem_cache_destroy(mmu_page_header_cache);
 }
 
+static void kvm_set_mmio_spte_mask(void)
+{
+	u64 mask;
+	int maxphyaddr = boot_cpu_data.x86_phys_bits;
+
+	/*
+	 * Set the reserved bits and the present bit of an paging-structure
+	 * entry to generate page fault with PFER.RSV = 1.
+	 */
+
+	/*
+	 * Mask the uppermost physical address bit, which would be reserved as
+	 * long as the supported physical address width is less than 52.
+	 */
+	mask = 1ull << 51;
+
+	/* Set the present bit. */
+	mask |= 1ull;
+
+	/*
+	 * If reserved bit is not supported, clear the present bit to disable
+	 * mmio page fault.
+	 */
+	if (IS_ENABLED(CONFIG_X86_64) && maxphyaddr == 52)
+		mask &= ~1ull;
+
+	kvm_mmu_set_mmio_spte_mask(mask, mask);
+}
+
 int kvm_mmu_module_init(void)
 {
 	int ret = -ENOMEM;
@@ -6005,6 +6034,8 @@ int kvm_mmu_module_init(void)
 
 	kvm_mmu_reset_all_pte_masks();
 
+	kvm_set_mmio_spte_mask();
+
 	pte_list_desc_cache = kmem_cache_create("pte_list_desc",
 					    sizeof(struct pte_list_desc),
 					    0, SLAB_ACCOUNT, NULL);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dc621f73e96b..80ab4a46ddfd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6877,35 +6877,6 @@ static struct perf_guest_info_callbacks kvm_guest_cbs = {
 	.handle_intel_pt_intr	= kvm_handle_intel_pt_intr,
 };
 
-static void kvm_set_mmio_spte_mask(void)
-{
-	u64 mask;
-	int maxphyaddr = boot_cpu_data.x86_phys_bits;
-
-	/*
-	 * Set the reserved bits and the present bit of an paging-structure
-	 * entry to generate page fault with PFER.RSV = 1.
-	 */
-
-	/*
-	 * Mask the uppermost physical address bit, which would be reserved as
-	 * long as the supported physical address width is less than 52.
-	 */
-	mask = 1ull << 51;
-
-	/* Set the present bit. */
-	mask |= 1ull;
-
-	/*
-	 * If reserved bit is not supported, clear the present bit to disable
-	 * mmio page fault.
-	 */
-	if (IS_ENABLED(CONFIG_X86_64) && maxphyaddr == 52)
-		mask &= ~1ull;
-
-	kvm_mmu_set_mmio_spte_mask(mask, mask);
-}
-
 #ifdef CONFIG_X86_64
 static void pvclock_gtod_update_fn(struct work_struct *work)
 {
@@ -7002,8 +6973,6 @@ int kvm_arch_init(void *opaque)
 	if (r)
 		goto out_free_percpu;
 
-	kvm_set_mmio_spte_mask();
-
 	kvm_x86_ops = ops;
 
 	kvm_mmu_set_mask_ptes(PT_USER_MASK, PT_ACCESSED_MASK,
-- 
2.13.6

