Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4779245B37
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 05:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgHQDs7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Aug 2020 23:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgHQDs6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Aug 2020 23:48:58 -0400
Received: from vultr.net.flygoat.com (vultr.net.flygoat.com [IPv6:2001:19f0:6001:3633:5400:2ff:fe8c:553])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02382C061388;
        Sun, 16 Aug 2020 20:48:58 -0700 (PDT)
Received: from localhost.localdomain (unknown [IPv6:2001:da8:20f:4430:250:56ff:fe9a:7470])
        by vultr.net.flygoat.com (Postfix) with ESMTPSA id 736DC1FF02;
        Mon, 17 Aug 2020 03:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com; s=vultr;
        t=1597636137; bh=DG4HaU9QQ7zmJ9disDopHNWXYPU0r4P16T3M3Oeh0v8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k7y+m7oobNcnyEw8zisBtP5mbOJfk/nHNionO299OhfazRxuu1Ik2h3aNwJc0Bjtr
         YC2DWMLXLRBqTZbz7U8lYyavuysFGo5mny+x/JaD9jIgpg7g12zWVVJEEiPa2RkGnL
         VZjeiI8j6CNaMDpspo/a2gLkFHXrj3vkRi702ZdnuOWfg9VC0VeLIkcs47lw8qERPD
         IdnxQZ3MLRoWhKzEh3MDNzEIC3bw6MMlsQuYQSKhm2EklZRF8lqNZQEA7tp/dBlKMO
         v3kPsV0ARo+o12jsFEKkG6SjKdbHoxW1YcLLc5kZJe2iaowOfvacCUFIc/Hu8sOmJE
         iEtXFe9m5XvvA==
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     linux-mips@vger.kernel.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Huacai Chen <chenhc@lemote.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Burton <paulburton@kernel.org>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        WANG Xuerui <git@xen0n.name>,
        =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20=28Zhou=20Yanjie=29?= 
        <zhouyanjie@wanyeetech.com>,
        Liangliang Huang <huanglllzu@gmail.com>,
        afzal mohammed <afzal.mohd.ma@gmail.com>,
        Peter Xu <peterx@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sergey Korolev <s.korolev@ndmsystems.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Anup Patel <anup.patel@wdc.com>, Marc Zyngier <maz@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Steven Price <steven.price@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        Ming Lei <ming.lei@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Mike Leach <mike.leach@linaro.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 4/7] MIPS: Loongson64: Remove custom count sync procudure
Date:   Mon, 17 Aug 2020 11:46:43 +0800
Message-Id: <20200817034701.3515721-5-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.28.0.rc1
In-Reply-To: <20200817034701.3515721-1-jiaxun.yang@flygoat.com>
References: <20200817034701.3515721-1-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now we have hotplug aware reliable sync-r4k, we can simply use
that instead of our IPI based implementation.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/include/asm/smp.h |  1 -
 arch/mips/loongson64/smp.c  | 32 ++------------------------------
 2 files changed, 2 insertions(+), 31 deletions(-)

diff --git a/arch/mips/include/asm/smp.h b/arch/mips/include/asm/smp.h
index 5d9ff61004ca..2300cc0bba34 100644
--- a/arch/mips/include/asm/smp.h
+++ b/arch/mips/include/asm/smp.h
@@ -52,7 +52,6 @@ extern int __cpu_logical_map[NR_CPUS];
 #define SMP_CALL_FUNCTION	0x2
 /* Octeon - Tell another core to flush its icache */
 #define SMP_ICACHE_FLUSH	0x4
-#define SMP_ASK_C0COUNT		0x8
 
 /* Mask of CPUs which are currently definitely operating coherently */
 extern cpumask_t cpu_coherent_mask;
diff --git a/arch/mips/loongson64/smp.c b/arch/mips/loongson64/smp.c
index e744e1bee49e..d6a3a7c3d1b2 100644
--- a/arch/mips/loongson64/smp.c
+++ b/arch/mips/loongson64/smp.c
@@ -32,7 +32,6 @@ static void *ipi_clear0_regs[16];
 static void *ipi_status0_regs[16];
 static void *ipi_en0_regs[16];
 static void *ipi_mailbox_buf[16];
-static uint32_t core0_c0count[NR_CPUS];
 
 /* read a 32bit value from ipi register */
 #define loongson3_ipi_read32(addr) readl(addr)
@@ -307,8 +306,8 @@ loongson3_send_ipi_mask(const struct cpumask *mask, unsigned int action)
 
 static irqreturn_t loongson3_ipi_interrupt(int irq, void *dev_id)
 {
-	int i, cpu = smp_processor_id();
-	unsigned int action, c0count;
+	int cpu = smp_processor_id();
+	unsigned int action;
 
 	action = ipi_read_clear(cpu);
 
@@ -321,15 +320,6 @@ static irqreturn_t loongson3_ipi_interrupt(int irq, void *dev_id)
 		irq_exit();
 	}
 
-	if (action & SMP_ASK_C0COUNT) {
-		BUG_ON(cpu != 0);
-		c0count = read_c0_count();
-		c0count = c0count ? c0count : 1;
-		for (i = 1; i < nr_cpu_ids; i++)
-			core0_c0count[i] = c0count;
-		__wbflush(); /* Let others see the result ASAP */
-	}
-
 	return IRQ_HANDLED;
 }
 
@@ -340,7 +330,6 @@ static irqreturn_t loongson3_ipi_interrupt(int irq, void *dev_id)
 static void loongson3_init_secondary(void)
 {
 	int i;
-	uint32_t initcount;
 	unsigned int cpu = smp_processor_id();
 	unsigned int imask = STATUSF_IP7 | STATUSF_IP6 |
 			     STATUSF_IP3 | STATUSF_IP2;
@@ -356,23 +345,6 @@ static void loongson3_init_secondary(void)
 		     cpu_logical_map(cpu) % loongson_sysconf.cores_per_package);
 	cpu_data[cpu].package =
 		cpu_logical_map(cpu) / loongson_sysconf.cores_per_package;
-
-	i = 0;
-	core0_c0count[cpu] = 0;
-	loongson3_send_ipi_single(0, SMP_ASK_C0COUNT);
-	while (!core0_c0count[cpu]) {
-		i++;
-		cpu_relax();
-	}
-
-	if (i > MAX_LOOPS)
-		i = MAX_LOOPS;
-	if (cpu_data[cpu].package)
-		initcount = core0_c0count[cpu] + i;
-	else /* Local access is faster for loops */
-		initcount = core0_c0count[cpu] + i/2;
-
-	write_c0_count(initcount);
 }
 
 static void loongson3_smp_finish(void)
-- 
2.28.0.rc1

