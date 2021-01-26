Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 964AE303E83
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 14:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404676AbhAZNP5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 08:15:57 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:11509 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391849AbhAZMrN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 07:47:13 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DQ5yX0p1NzjDQL;
        Tue, 26 Jan 2021 20:44:04 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.184.42) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Tue, 26 Jan 2021 20:45:06 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <maz@kernel.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>,
        <xiexiangyou@huawei.com>, <zhengchuan@huawei.com>,
        <yubihong@huawei.com>
Subject: [RFC PATCH 6/7] kvm: arm64: Only write protect selected PTE
Date:   Tue, 26 Jan 2021 20:44:43 +0800
Message-ID: <20210126124444.27136-7-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210126124444.27136-1-zhukeqian1@huawei.com>
References: <20210126124444.27136-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This function write protects all PTEs between the ffs and fls of mask.
There may has unset bit between this range. It works well under pure
software dirty log, as software dirty log is not working during this
process.

But it will unexpectly clear dirty status of PTE when hardware dirty
log is enabled. So change it to only write protect selected PTE.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 arch/arm64/kvm/mmu.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 18717fd12731..2f8c6770a4dc 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -589,10 +589,14 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 		gfn_t gfn_offset, unsigned long mask)
 {
 	phys_addr_t base_gfn = slot->base_gfn + gfn_offset;
-	phys_addr_t start = (base_gfn +  __ffs(mask)) << PAGE_SHIFT;
-	phys_addr_t end = (base_gfn + __fls(mask) + 1) << PAGE_SHIFT;
+	phys_addr_t start, end;
+	int rs, re;
 
-	stage2_wp_range(&kvm->arch.mmu, start, end);
+	bitmap_for_each_set_region(&mask, rs, re, 0, BITS_PER_LONG) {
+		start = (base_gfn + rs) << PAGE_SHIFT;
+		end = (base_gfn + re) << PAGE_SHIFT;
+		stage2_wp_range(&kvm->arch.mmu, start, end);
+	}
 }
 
 /*
-- 
2.19.1

