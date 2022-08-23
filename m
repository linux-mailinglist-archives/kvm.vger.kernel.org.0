Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC0C59D15B
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 08:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240686AbiHWGdU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 02:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbiHWGdR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 02:33:17 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27BA218D;
        Mon, 22 Aug 2022 23:33:15 -0700 (PDT)
Received: from canpemm500002.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MBfWp43NjzGpnk;
        Tue, 23 Aug 2022 14:31:34 +0800 (CST)
Received: from huawei.com (10.175.124.27) by canpemm500002.china.huawei.com
 (7.192.104.244) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 23 Aug
 2022 14:33:12 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>
CC:     <x86@kernel.org>, <hpa@zytor.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linmiaohe@huawei.com>
Subject: [PATCH] kvm: x86: mmu: fix memoryleak in kvm_mmu_vendor_module_init()
Date:   Tue, 23 Aug 2022 14:32:37 +0800
Message-ID: <20220823063237.47299-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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

When register_shrinker() fails, we forgot to release the percpu counter
kvm_total_used_mmu_pages leading to memoryleak. Fix this issue by calling
percpu_counter_destroy() when register_shrinker() fails.

Fixes: ab271bd4dfd5 ("x86: kvm: propagate register_shrinker return code")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 arch/x86/kvm/mmu/mmu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e418ef3ecfcb..d25d55b1f0b5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6702,10 +6702,12 @@ int kvm_mmu_vendor_module_init(void)
 
 	ret = register_shrinker(&mmu_shrinker, "x86-mmu");
 	if (ret)
-		goto out;
+		goto out_shrinker;
 
 	return 0;
 
+out_shrinker:
+	percpu_counter_destroy(&kvm_total_used_mmu_pages);
 out:
 	mmu_destroy_caches();
 	return ret;
-- 
2.23.0

