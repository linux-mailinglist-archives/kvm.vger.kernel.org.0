Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A251F245B3D
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 05:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgHQDtm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Aug 2020 23:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727818AbgHQDtj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Aug 2020 23:49:39 -0400
Received: from vultr.net.flygoat.com (vultr.net.flygoat.com [IPv6:2001:19f0:6001:3633:5400:2ff:fe8c:553])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BA11C061388
        for <kvm@vger.kernel.org>; Sun, 16 Aug 2020 20:49:39 -0700 (PDT)
Received: from localhost.localdomain (unknown [IPv6:2001:da8:20f:4430:250:56ff:fe9a:7470])
        by vultr.net.flygoat.com (Postfix) with ESMTPSA id F146C200D0;
        Mon, 17 Aug 2020 03:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com; s=vultr;
        t=1597636178; bh=Q5RJ1NIgEccdftXxouCtJty5D3e1oMIrOLeVC8dh9Iw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r/L8sn/53RTqpNEUSf7STc7jzV9+RjbiDLarYZCxsaIzipCI5kb6ug9Yffe8t48su
         nWaqprhN/TZdSjlToFtqAQ2orJENiKh8Vf5hldy5m9194cREQA+VK3gQTZNqbglJaC
         akesoJgk5caoqXZl53MxMwlSmSGeWcowMuK/HSDlVuMQoMHs9r/JTXcVSZ5KamUuLh
         6W3i1BHH14RgZiKHF977jl6449Y09mh3/eYwyyvoFGsRwt2UGJhpDT/S5QzlIur3A3
         awYmntV1GV50L3KPcHQcbAG/v+YZcehD5lK7dWFxq4I6oVbu8vH9jMeJdU+wlZ1F5L
         R9utB2FS1PW9w==
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     linux-mips@vger.kernel.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Huacai Chen <chenhc@lemote.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Paul Burton <paulburton@kernel.org>,
        WANG Xuerui <git@xen0n.name>,
        =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20=28Zhou=20Yanjie=29?= 
        <zhouyanjie@wanyeetech.com>,
        Liangliang Huang <huanglllzu@gmail.com>,
        afzal mohammed <afzal.mohd.ma@gmail.com>,
        Peter Xu <peterx@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Sergey Korolev <s.korolev@ndmsystems.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Marc Zyngier <maz@kernel.org>, Anup Patel <anup.patel@wdc.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Atish Patra <atish.patra@wdc.com>,
        Steven Price <steven.price@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Ming Lei <ming.lei@redhat.com>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 6/7] MIPS: cevt-r4k: Enable intimer for Loongson CPUs with extimer
Date:   Mon, 17 Aug 2020 11:46:45 +0800
Message-Id: <20200817034701.3515721-7-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.28.0.rc1
In-Reply-To: <20200817034701.3515721-1-jiaxun.yang@flygoat.com>
References: <20200817034701.3515721-1-jiaxun.yang@flygoat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Loongson64C and Loongson64G have extimer feature, which is sharing
Cause.TI with intimer (which is cevt-r4k).

To ensure the cevt-r4k's usability, we need to add a callback for
clock device to ensure intimer is enabled when cevt-r4k is enabled.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 arch/mips/include/asm/cpu-features.h |  4 ++++
 arch/mips/include/asm/cpu.h          |  1 +
 arch/mips/kernel/cevt-r4k.c          | 25 +++++++++++++++++++++++++
 arch/mips/kernel/cpu-probe.c         |  6 +++++-
 4 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/cpu-features.h b/arch/mips/include/asm/cpu-features.h
index 78cf7e300f12..aec458eee2a5 100644
--- a/arch/mips/include/asm/cpu-features.h
+++ b/arch/mips/include/asm/cpu-features.h
@@ -576,6 +576,10 @@
 # define cpu_has_gsexcex	__opt(MIPS_CPU_GSEXCEX)
 #endif
 
+#ifndef cpu_has_extimer
+# define cpu_has_extimer	__opt(MIPS_CPU_EXTIMER)
+#endif
+
 #ifdef CONFIG_SMP
 /*
  * Some systems share FTLB RAMs between threads within a core (siblings in
diff --git a/arch/mips/include/asm/cpu.h b/arch/mips/include/asm/cpu.h
index 388a82f28a87..854e1b44254b 100644
--- a/arch/mips/include/asm/cpu.h
+++ b/arch/mips/include/asm/cpu.h
@@ -429,6 +429,7 @@ enum cpu_type_enum {
 #define MIPS_CPU_MAC_2008_ONLY	BIT_ULL(60)	/* CPU Only support MAC2008 Fused multiply-add instruction */
 #define MIPS_CPU_FTLBPAREX	BIT_ULL(61)	/* CPU has FTLB parity exception */
 #define MIPS_CPU_GSEXCEX	BIT_ULL(62)	/* CPU has GSExc exception */
+#define MIPS_CPU_EXTIMER	BIT_ULL(63)	/* CPU has External Timer (Loongson) */
 
 /*
  * CPU ASE encodings
diff --git a/arch/mips/kernel/cevt-r4k.c b/arch/mips/kernel/cevt-r4k.c
index d396b1011fee..a6e56e9d4e70 100644
--- a/arch/mips/kernel/cevt-r4k.c
+++ b/arch/mips/kernel/cevt-r4k.c
@@ -15,6 +15,8 @@
 
 #include <asm/time.h>
 #include <asm/cevt-r4k.h>
+#include <asm/cpu-features.h>
+#include <asm/mipsregs.h>
 
 static int mips_next_event(unsigned long delta,
 			   struct clock_event_device *evt)
@@ -302,6 +304,24 @@ core_initcall(r4k_register_cpufreq_notifier);
 
 #endif /* !CONFIG_CPU_FREQ */
 
+#ifdef CONFIG_CPU_LOONGSON64
+static int c0_compare_int_enable(struct clock_event_device *cd)
+{
+	if (cpu_has_extimer)
+		set_c0_config6(LOONGSON_CONF6_INTIMER);
+
+	return 0;
+}
+
+static int c0_compare_int_disable(struct clock_event_device *cd)
+{
+	if (cpu_has_extimer)
+		clear_c0_config6(LOONGSON_CONF6_INTIMER);
+
+	return 0;
+}
+#endif
+
 int r4k_clockevent_percpu_init(int cpu)
 {
 	struct clock_event_device *cd;
@@ -330,6 +350,11 @@ int r4k_clockevent_percpu_init(int cpu)
 	cd->set_next_event	= mips_next_event;
 	cd->event_handler	= mips_event_handler;
 
+#ifdef CONFIG_CPU_LOONGSON64
+	cd->set_state_oneshot = c0_compare_int_enable;
+	cd->set_state_shutdown = c0_compare_int_disable;
+#endif
+
 	clockevents_config_and_register(cd, mips_hpt_frequency, min_delta, 0x7fffffff);
 
 	return 0;
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index e2955f1f6316..f41e8d4f6d84 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -2030,6 +2030,9 @@ static inline void decode_cpucfg(struct cpuinfo_mips *c)
 	if (cfg2 & LOONGSON_CFG2_LEXT2)
 		c->ases |= MIPS_ASE_LOONGSON_EXT2;
 
+	if (cfg2 & LOONGSON_CFG2_LLFTP)
+		c->options |= MIPS_CPU_EXTIMER;
+
 	if (cfg2 & LOONGSON_CFG2_LSPW) {
 		c->options |= MIPS_CPU_LDPTE;
 		c->guest.options |= MIPS_CPU_LDPTE;
@@ -2088,7 +2091,8 @@ static inline void cpu_probe_loongson(struct cpuinfo_mips *c, unsigned int cpu)
 		 * Also some early Loongson-3A2000 had wrong TLB type in Config
 		 * register, we correct it here.
 		 */
-		c->options |= MIPS_CPU_FTLB | MIPS_CPU_TLBINV | MIPS_CPU_LDPTE;
+		c->options |= MIPS_CPU_FTLB | MIPS_CPU_TLBINV | MIPS_CPU_LDPTE |
+			      MIPS_CPU_EXTIMER;
 		c->writecombine = _CACHE_UNCACHED_ACCELERATED;
 		c->ases |= (MIPS_ASE_LOONGSON_MMI | MIPS_ASE_LOONGSON_CAM |
 			MIPS_ASE_LOONGSON_EXT | MIPS_ASE_LOONGSON_EXT2);
-- 
2.28.0.rc1

