Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A378B5AFE89
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 10:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbiIGIHn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Sep 2022 04:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbiIGIHh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Sep 2022 04:07:37 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD348306B;
        Wed,  7 Sep 2022 01:07:33 -0700 (PDT)
Received: from canpemm500002.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MMvsR4V9RzmVfL;
        Wed,  7 Sep 2022 16:03:55 +0800 (CST)
Received: from huawei.com (10.175.124.27) by canpemm500002.china.huawei.com
 (7.192.104.244) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 7 Sep
 2022 16:07:29 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>
CC:     <x86@kernel.org>, <hpa@zytor.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linmiaohe@huawei.com>
Subject: [PATCH] KVM: x86/mmu: add missing update to max_mmu_rmap_size
Date:   Wed, 7 Sep 2022 16:06:57 +0800
Message-ID: <20220907080657.42898-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500002.china.huawei.com (7.192.104.244)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The update to statistic max_mmu_rmap_size is unintentionally removed by
commit 4293ddb788c1 ("KVM: x86/mmu: Remove redundant spte present check
in mmu_set_spte"). Add missing update to it or max_mmu_rmap_size will
always be nonsensical 0.

Fixes: 4293ddb788c1 ("KVM: x86/mmu: Remove redundant spte present check in mmu_set_spte")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d25d55b1f0b5..858bc53cfab4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1596,6 +1596,8 @@ static void __rmap_add(struct kvm *kvm,
 	rmap_head = gfn_to_rmap(gfn, sp->role.level, slot);
 	rmap_count = pte_list_add(cache, spte, rmap_head);
 
+	if (rmap_count > kvm->stat.max_mmu_rmap_size)
+		kvm->stat.max_mmu_rmap_size = rmap_count;
 	if (rmap_count > RMAP_RECYCLE_THRESHOLD) {
 		kvm_zap_all_rmap_sptes(kvm, rmap_head);
 		kvm_flush_remote_tlbs_with_address(
-- 
2.23.0

