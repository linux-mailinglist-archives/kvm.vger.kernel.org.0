Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C87D7883F0
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 11:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbjHYJhc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 05:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244407AbjHYJhO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 05:37:14 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 805361FFF
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 02:37:09 -0700 (PDT)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4RXFFb4GbFz6D8WF;
        Fri, 25 Aug 2023 17:36:19 +0800 (CST)
Received: from A2006125610.china.huawei.com (10.202.227.178) by
 lhrpeml500005.china.huawei.com (7.191.163.240) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Fri, 25 Aug 2023 10:37:01 +0100
From:   Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To:     <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <maz@kernel.org>,
        <will@kernel.org>, <catalin.marinas@arm.com>,
        <oliver.upton@linux.dev>
CC:     <james.morse@arm.com>, <suzuki.poulose@arm.com>,
        <yuzenghui@huawei.com>, <zhukeqian1@huawei.com>,
        <jonathan.cameron@huawei.com>, <linuxarm@huawei.com>
Subject: [RFC PATCH v2 6/8] KVM: arm64: Only write protect selected PTE
Date:   Fri, 25 Aug 2023 10:35:26 +0100
Message-ID: <20230825093528.1637-7-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
References: <20230825093528.1637-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.202.227.178]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Keqian Zhu <zhukeqian1@huawei.com>

This function write protects all PTEs between the ffs and fls of mask.
There may be unset bits between this range. It works well under pure
software dirty log, as software dirty log is not working during this
process.

But it will unexpectly clear dirty status of PTE when hardware dirty
log is enabled. So change it to only write protect selected PTE.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 arch/arm64/kvm/mmu.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index f5ae4b97df4d..34251932560e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1132,10 +1132,17 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	phys_addr_t base_gfn = slot->base_gfn + gfn_offset;
 	phys_addr_t start = (base_gfn +  __ffs(mask)) << PAGE_SHIFT;
 	phys_addr_t end = (base_gfn + __fls(mask) + 1) << PAGE_SHIFT;
+	int rs, re;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
-	stage2_wp_range(&kvm->arch.mmu, start, end);
+	for_each_set_bitrange(rs, re, &mask, BITS_PER_LONG) {
+		phys_addr_t addr_s, addr_e;
+
+		addr_s = (base_gfn + rs) << PAGE_SHIFT;
+		addr_e = (base_gfn + re) << PAGE_SHIFT;
+		stage2_wp_range(&kvm->arch.mmu, addr_s, addr_e);
+	}
 
 	/*
 	 * Eager-splitting is done when manual-protect is set.  We
-- 
2.34.1

