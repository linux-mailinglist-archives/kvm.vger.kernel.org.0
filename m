Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7D873AB1C0
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 12:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbhFQLAo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 07:00:44 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7467 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232234AbhFQLAl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 07:00:41 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G5Jqq0vSBzZhmL;
        Thu, 17 Jun 2021 18:55:35 +0800 (CST)
Received: from dggpemm500023.china.huawei.com (7.185.36.83) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 17 Jun 2021 18:58:31 +0800
Received: from DESKTOP-TMVL5KK.china.huawei.com (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 17 Jun 2021 18:58:30 +0800
From:   Yanan Wang <wangyanan55@huawei.com>
To:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        "Quentin Perret" <qperret@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        Gavin Shan <gshan@redhat.com>, <wanghaibin.wang@huawei.com>,
        <zhukeqian1@huawei.com>, <yuzenghui@huawei.com>,
        Yanan Wang <wangyanan55@huawei.com>
Subject: [PATCH v7 3/4] KVM: arm64: Tweak parameters of guest cache maintenance functions
Date:   Thu, 17 Jun 2021 18:58:23 +0800
Message-ID: <20210617105824.31752-4-wangyanan55@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210617105824.31752-1-wangyanan55@huawei.com>
References: <20210617105824.31752-1-wangyanan55@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500023.china.huawei.com (7.185.36.83)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adjust the parameter "kvm_pfn_t pfn" of __clean_dcache_guest_page
and __invalidate_icache_guest_page to "void *va", which paves the
way for converting these two guest CMO functions into callbacks in
structure kvm_pgtable_mm_ops. No functional change.

Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
---
 arch/arm64/include/asm/kvm_mmu.h |  9 ++-------
 arch/arm64/kvm/mmu.c             | 28 +++++++++++++++-------------
 2 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 25ed956f9af1..6844a7550392 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -187,10 +187,8 @@ static inline bool vcpu_has_cache_enabled(struct kvm_vcpu *vcpu)
 	return (vcpu_read_sys_reg(vcpu, SCTLR_EL1) & 0b101) == 0b101;
 }
 
-static inline void __clean_dcache_guest_page(kvm_pfn_t pfn, unsigned long size)
+static inline void __clean_dcache_guest_page(void *va, size_t size)
 {
-	void *va = page_address(pfn_to_page(pfn));
-
 	/*
 	 * With FWB, we ensure that the guest always accesses memory using
 	 * cacheable attributes, and we don't have to clean to PoC when
@@ -203,16 +201,13 @@ static inline void __clean_dcache_guest_page(kvm_pfn_t pfn, unsigned long size)
 	kvm_flush_dcache_to_poc(va, size);
 }
 
-static inline void __invalidate_icache_guest_page(kvm_pfn_t pfn,
-						  unsigned long size)
+static inline void __invalidate_icache_guest_page(void *va, size_t size)
 {
 	if (icache_is_aliasing()) {
 		/* any kind of VIPT cache */
 		__flush_icache_all();
 	} else if (is_kernel_in_hyp_mode() || !icache_is_vpipt()) {
 		/* PIPT or VPIPT at EL2 (see comment in __kvm_tlb_flush_vmid_ipa) */
-		void *va = page_address(pfn_to_page(pfn));
-
 		invalidate_icache_range((unsigned long)va,
 					(unsigned long)va + size);
 	}
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 5742ba765ff9..b980f8a47cbb 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -126,6 +126,16 @@ static void *kvm_host_va(phys_addr_t phys)
 	return __va(phys);
 }
 
+static void clean_dcache_guest_page(void *va, size_t size)
+{
+	__clean_dcache_guest_page(va, size);
+}
+
+static void invalidate_icache_guest_page(void *va, size_t size)
+{
+	__invalidate_icache_guest_page(va, size);
+}
+
 /*
  * Unmapping vs dcache management:
  *
@@ -693,16 +703,6 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	kvm_mmu_write_protect_pt_masked(kvm, slot, gfn_offset, mask);
 }
 
-static void clean_dcache_guest_page(kvm_pfn_t pfn, unsigned long size)
-{
-	__clean_dcache_guest_page(pfn, size);
-}
-
-static void invalidate_icache_guest_page(kvm_pfn_t pfn, unsigned long size)
-{
-	__invalidate_icache_guest_page(pfn, size);
-}
-
 static void kvm_send_hwpoison_signal(unsigned long address, short lsb)
 {
 	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, current);
@@ -1013,11 +1013,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		prot |= KVM_PGTABLE_PROT_W;
 
 	if (fault_status != FSC_PERM && !device)
-		clean_dcache_guest_page(pfn, vma_pagesize);
+		clean_dcache_guest_page(page_address(pfn_to_page(pfn)),
+					vma_pagesize);
 
 	if (exec_fault) {
 		prot |= KVM_PGTABLE_PROT_X;
-		invalidate_icache_guest_page(pfn, vma_pagesize);
+		invalidate_icache_guest_page(page_address(pfn_to_page(pfn)),
+					     vma_pagesize);
 	}
 
 	if (device)
@@ -1219,7 +1221,7 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	 * We've moved a page around, probably through CoW, so let's treat it
 	 * just like a translation fault and clean the cache to the PoC.
 	 */
-	clean_dcache_guest_page(pfn, PAGE_SIZE);
+	clean_dcache_guest_page(page_address(pfn_to_page(pfn), PAGE_SIZE);
 
 	/*
 	 * The MMU notifiers will have unmapped a huge PMD before calling
-- 
2.23.0

