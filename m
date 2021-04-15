Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2117236088F
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 13:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232786AbhDOLvR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 07:51:17 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:17342 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232718AbhDOLvL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 07:51:11 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FLczw63WhzB10g;
        Thu, 15 Apr 2021 19:48:28 +0800 (CST)
Received: from DESKTOP-TMVL5KK.china.huawei.com (10.174.187.128) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Thu, 15 Apr 2021 19:50:38 +0800
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
Subject: [PATCH v5 4/6] KVM: arm64: Provide invalidate_icache_range at non-VHE EL2
Date:   Thu, 15 Apr 2021 19:50:30 +0800
Message-ID: <20210415115032.35760-5-wangyanan55@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210415115032.35760-1-wangyanan55@huawei.com>
References: <20210415115032.35760-1-wangyanan55@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.128]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We want to move I-cache maintenance for the guest to the stage-2
page table code for performance improvement. Before it can work,
we should first make function invalidate_icache_range available
to non-VHE EL2 to avoid compiling or program running error, as
pgtable.c is now linked into the non-VHE EL2 code for pKVM mode.

In this patch, we only introduce symbol of invalidate_icache_range
with no real functionality in nvhe/cache.S, because there haven't
been situations found currently where I-cache maintenance is also
needed in non-VHE EL2 for pKVM mode.

Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
---
 arch/arm64/kvm/hyp/nvhe/cache.S | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/cache.S b/arch/arm64/kvm/hyp/nvhe/cache.S
index 36cef6915428..a125ec9aeed2 100644
--- a/arch/arm64/kvm/hyp/nvhe/cache.S
+++ b/arch/arm64/kvm/hyp/nvhe/cache.S
@@ -11,3 +11,14 @@ SYM_FUNC_START_PI(__flush_dcache_area)
 	dcache_by_line_op civac, sy, x0, x1, x2, x3
 	ret
 SYM_FUNC_END_PI(__flush_dcache_area)
+
+/*
+ *	invalidate_icache_range(start,end)
+ *
+ *	Ensure that the I cache is invalid within specified region.
+ *
+ *	- start   - virtual start address of region
+ *	- end     - virtual end address of region
+ */
+SYM_FUNC_START(invalidate_icache_range)
+SYM_FUNC_END(invalidate_icache_range)
-- 
2.23.0

