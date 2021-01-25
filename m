Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 633283049F9
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 21:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731941AbhAZFTu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 00:19:50 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:11874 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729303AbhAYOMK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jan 2021 09:12:10 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DPWvr41hmz7Zrf;
        Mon, 25 Jan 2021 22:09:44 +0800 (CST)
Received: from DESKTOP-TMVL5KK.china.huawei.com (10.174.187.128) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Mon, 25 Jan 2021 22:10:48 +0800
From:   Yanan Wang <wangyanan55@huawei.com>
To:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        "Julien Thierry" <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>,
        Yanan Wang <wangyanan55@huawei.com>
Subject: [PATCH 2/2] KVM: arm64: Skip the cache flush when coalescing tables into a block
Date:   Mon, 25 Jan 2021 22:10:44 +0800
Message-ID: <20210125141044.380156-3-wangyanan55@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210125141044.380156-1-wangyanan55@huawei.com>
References: <20210125141044.380156-1-wangyanan55@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.128]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After dirty-logging is stopped for a VM configured with huge mappings,
KVM will recover the table mappings back to block mappings. As we only
replace the existing page tables with a block entry and the cacheability
has not been changed, the cache maintenance opreations can be skipped.

Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
---
 arch/arm64/kvm/mmu.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8e8549ea1d70..37b427dcbc4f 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -744,7 +744,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 {
 	int ret = 0;
 	bool write_fault, writable, force_pte = false;
-	bool exec_fault;
+	bool exec_fault, adjust_hugepage;
 	bool device = false;
 	unsigned long mmu_seq;
 	struct kvm *kvm = vcpu->kvm;
@@ -872,12 +872,18 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		mark_page_dirty(kvm, gfn);
 	}
 
-	if (fault_status != FSC_PERM && !device)
+	/*
+	 * There is no necessity to perform cache maintenance operations if we
+	 * will only replace the existing table mappings with a block mapping.
+	 */
+	adjust_hugepage = fault_granule < vma_pagesize ? true : false;
+	if (fault_status != FSC_PERM && !device && !adjust_hugepage)
 		clean_dcache_guest_page(pfn, vma_pagesize);
 
 	if (exec_fault) {
 		prot |= KVM_PGTABLE_PROT_X;
-		invalidate_icache_guest_page(pfn, vma_pagesize);
+		if (!adjust_hugepage)
+			invalidate_icache_guest_page(pfn, vma_pagesize);
 	}
 
 	if (device)
-- 
2.19.1

