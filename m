Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1E42303F11
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 14:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404902AbhAZNnT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 08:43:19 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:11889 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404879AbhAZNnB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 08:43:01 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DQ7DK21PRz7bHL;
        Tue, 26 Jan 2021 21:41:05 +0800 (CST)
Received: from DESKTOP-TMVL5KK.china.huawei.com (10.174.187.128) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Tue, 26 Jan 2021 21:42:08 +0800
From:   Yanan Wang <wangyanan55@huawei.com>
To:     <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
CC:     Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <wanghaibin.wang@huawei.com>, <yezengruan@huawei.com>,
        <zhukeqian1@huawei.com>, <yuzenghui@huawei.com>,
        Yanan Wang <wangyanan55@huawei.com>
Subject: [RFC PATCH v1 3/5] KVM: arm64: Support usage of TTRem in guest stage-2 translation
Date:   Tue, 26 Jan 2021 21:42:00 +0800
Message-ID: <20210126134202.381996-4-wangyanan55@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20210126134202.381996-1-wangyanan55@huawei.com>
References: <20210126134202.381996-1-wangyanan55@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.128]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As TTrem can be used when coalesce existing table mappings into a block
in guest stage-2 translation, so just support usage of it.

Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 4d177ce1d536..c8b959e3951b 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -437,6 +437,7 @@ struct stage2_map_data {
 
 	struct kvm_s2_mmu		*mmu;
 	struct kvm_mmu_memory_cache	*memcache;
+	u32				ttrem_level;
 };
 
 static int stage2_map_set_prot_attr(enum kvm_pgtable_prot prot,
@@ -633,6 +634,7 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		.phys		= ALIGN_DOWN(phys, PAGE_SIZE),
 		.mmu		= pgt->mmu,
 		.memcache	= mc,
+		.ttrem_level	= system_support_level_of_ttrem(),
 	};
 	struct kvm_pgtable_walker walker = {
 		.cb		= stage2_map_walker,
-- 
2.19.1

