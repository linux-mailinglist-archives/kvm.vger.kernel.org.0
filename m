Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3E06317D5
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 01:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiKUAmg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Nov 2022 19:42:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiKUAme (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Nov 2022 19:42:34 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30D9264F;
        Sun, 20 Nov 2022 16:42:30 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NFpRh3525zFqRN;
        Mon, 21 Nov 2022 08:39:12 +0800 (CST)
Received: from dggpemm500001.china.huawei.com (7.185.36.107) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 08:42:25 +0800
Received: from huawei.com (10.67.174.169) by dggpemm500001.china.huawei.com
 (7.185.36.107) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 21 Nov
 2022 08:42:25 +0800
From:   Chen Lifu <chenlifu@huawei.com>
To:     <anup@brainfault.org>, <atishp@atishpatra.org>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <aou@eecs.berkeley.edu>, <kvm@vger.kernel.org>,
        <kvm-riscv@lists.infradead.org>, <linux-riscv@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <chenlifu@huawei.com>
Subject: [PATCH -next] RISC-V: KVM: optimize kvm_arch_hardware_enable()
Date:   Mon, 21 Nov 2022 08:39:15 +0800
Message-ID: <20221121003915.2817102-1-chenlifu@huawei.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.169]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500001.china.huawei.com (7.185.36.107)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The values of CSR_HEDELEG and CSR_HIDELEG registers are constants,
so change them from variables to macros.

Signed-off-by: Chen Lifu <chenlifu@huawei.com>
---
 arch/riscv/kvm/main.c | 31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index df2d8716851f..70196b03b6f9 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -12,10 +12,21 @@
 #include <linux/kvm_host.h>
 #include <asm/csr.h>
 #include <asm/hwcap.h>
 #include <asm/sbi.h>
 
+#define EXC_HEDELEG ((1UL << EXC_INST_MISALIGNED) | \
+		     (1UL << EXC_BREAKPOINT)      | \
+		     (1UL << EXC_SYSCALL)         | \
+		     (1UL << EXC_INST_PAGE_FAULT) | \
+		     (1UL << EXC_LOAD_PAGE_FAULT) | \
+		     (1UL << EXC_STORE_PAGE_FAULT))
+
+#define IRQ_HIDELEG ((1UL << IRQ_VS_SOFT)  | \
+		     (1UL << IRQ_VS_TIMER) | \
+		     (1UL << IRQ_VS_EXT))
+
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg)
 {
 	return -EINVAL;
 }
@@ -30,29 +41,13 @@ int kvm_arch_hardware_setup(void *opaque)
 	return 0;
 }
 
 int kvm_arch_hardware_enable(void)
 {
-	unsigned long hideleg, hedeleg;
-
-	hedeleg = 0;
-	hedeleg |= (1UL << EXC_INST_MISALIGNED);
-	hedeleg |= (1UL << EXC_BREAKPOINT);
-	hedeleg |= (1UL << EXC_SYSCALL);
-	hedeleg |= (1UL << EXC_INST_PAGE_FAULT);
-	hedeleg |= (1UL << EXC_LOAD_PAGE_FAULT);
-	hedeleg |= (1UL << EXC_STORE_PAGE_FAULT);
-	csr_write(CSR_HEDELEG, hedeleg);
-
-	hideleg = 0;
-	hideleg |= (1UL << IRQ_VS_SOFT);
-	hideleg |= (1UL << IRQ_VS_TIMER);
-	hideleg |= (1UL << IRQ_VS_EXT);
-	csr_write(CSR_HIDELEG, hideleg);
-
+	csr_write(CSR_HEDELEG, EXC_HEDELEG);
+	csr_write(CSR_HIDELEG, IRQ_HIDELEG);
 	csr_write(CSR_HCOUNTEREN, -1UL);
-
 	csr_write(CSR_HVIP, 0);
 
 	return 0;
 }
 
-- 
2.37.1

