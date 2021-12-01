Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC95E464511
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 03:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346260AbhLACwf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 21:52:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346252AbhLACwd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 21:52:33 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FB4C061746
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 18:49:13 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id b13so16540405plg.2
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 18:49:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=URzZbZ6R7R2kJ9o8vLqBlpL7FLeh8IQ+A5rPUUoJ6yQ=;
        b=6oNFmRxCpOxdNdx2OzWjo0xPAMMid/TMrPpT1co3Q6rpnTrsbrQECyqIwPQE9Ap3hg
         vCy5VGzr5Vm29scqq8sJPXmgEzagC9ZWqAsj2SjkMQdciOuRMcB5C9rlYBvcB8wgkO7O
         znql8p2uJ1ydw02LxdP9VDtB4az380SknDhC09CY+wSdq5NQDa7CygV38uN3aloQKh9p
         GKFF0lga4VPx/G97WdLADAwL/9BKi3Su4z7z3iE4ChpWUfhsb/BL4knIPaCSvCf10nVS
         w3hmBX2eppwunLbJTlaXJIu4MwrMiqESi/RLR39zEucVOx8ZOtr+IarCbBP8ysIEaYdq
         cZ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=URzZbZ6R7R2kJ9o8vLqBlpL7FLeh8IQ+A5rPUUoJ6yQ=;
        b=GjHwYcO0z7IY26aEVL6iMyLdsrRDPmbF76TFxrjkdRy/zoRLs59R5wC+j0V5ipL9H2
         TBPtWSrQ3XyNlhW5ZpDBiHgCZ5I8+ljp3nzzLIqOHtuZMTnAF0pKBjmNi4WAEq7qfDM1
         qzBOTjoi3wMppKLgckPe+leurpmQLToZK4n1U5JilF57q+HqyEa7LRRatIqSkyF4KnCW
         1S2nqRvbEtRZFTcoxrKO+SQlCWCeEX7VxereyBKWcVNzXgVF2VYO5IAwWDncYZPbtI+k
         s4sEEwOj9zQ9Rj/U0Wb4AeG3jLXfFRDkQu6x1Puq+fd0fxmWdvPNRq54ZQGaLHYaVjg8
         3k7w==
X-Gm-Message-State: AOAM53256884REHnUrUWXkmJTJlzW90RM3fcmhlpCqFlx1ARtFoCHuUY
        Bj4MBVF0gspldW4tDUKgrE6gUQ==
X-Google-Smtp-Source: ABdhPJx+Txk3VAUYni427Xjp/KJevPWylRr5e7M/rGpCQr34VzNicSzdk4abmN/6VdpQcB0PHt1PsQ==
X-Received: by 2002:a17:90b:3e81:: with SMTP id rj1mr3877218pjb.31.1638326952518;
        Tue, 30 Nov 2021 18:49:12 -0800 (PST)
Received: from always-x1.bytedance.net ([61.120.150.76])
        by smtp.gmail.com with ESMTPSA id f1sm24291704pfj.184.2021.11.30.18.49.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 18:49:12 -0800 (PST)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     tglx@linutronix.de, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        zhenwei pi <pizhenwei@bytedance.com>
Subject: [PATCH v2 1/2] x86/cpu: Introduce x86_get_cpufreq_khz()
Date:   Wed,  1 Dec 2021 10:46:49 +0800
Message-Id: <20211201024650.88254-2-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211201024650.88254-1-pizhenwei@bytedance.com>
References: <20211201024650.88254-1-pizhenwei@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wrapper function x86_get_cpufreq_khz() to get frequency on a x86
platform, hide detailed implementation from proc routine.

Also export this function for the further use, a typical case is that
kvm module gets the frequency of the host and tell the guest side by
kvmclock.

Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
---
 arch/x86/include/asm/processor.h |  2 ++
 arch/x86/kernel/cpu/common.c     | 19 +++++++++++++++++++
 arch/x86/kernel/cpu/proc.c       | 13 +++----------
 3 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 355d38c0cf60..22f183dee593 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -855,4 +855,6 @@ enum mds_mitigations {
 	MDS_MITIGATION_VMWERV,
 };
 
+unsigned int x86_get_cpufreq_khz(unsigned int cpu);
+
 #endif /* _ASM_X86_PROCESSOR_H */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 0083464de5e3..997026fedbb4 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -22,6 +22,7 @@
 #include <linux/io.h>
 #include <linux/syscore_ops.h>
 #include <linux/pgtable.h>
+#include <linux/cpufreq.h>
 
 #include <asm/cmdline.h>
 #include <asm/stackprotector.h>
@@ -2104,3 +2105,21 @@ void arch_smt_update(void)
 	/* Check whether IPI broadcasting can be enabled */
 	apic_smt_update();
 }
+
+unsigned int x86_get_cpufreq_khz(unsigned int cpu)
+{
+	unsigned int freq = 0;
+
+	if (!cpu_feature_enabled(X86_FEATURE_TSC))
+		return 0;
+
+	freq = aperfmperf_get_khz(cpu);
+	if (!freq)
+		freq = cpufreq_quick_get(cpu);
+
+	if (!freq)
+		freq = cpu_khz;
+
+	return freq;
+}
+EXPORT_SYMBOL_GPL(x86_get_cpufreq_khz);
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 4eec8889b0ff..8ed17f969f72 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -3,7 +3,6 @@
 #include <linux/timex.h>
 #include <linux/string.h>
 #include <linux/seq_file.h>
-#include <linux/cpufreq.h>
 
 #include "cpu.h"
 
@@ -61,7 +60,7 @@ static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
 static int show_cpuinfo(struct seq_file *m, void *v)
 {
 	struct cpuinfo_x86 *c = v;
-	unsigned int cpu;
+	unsigned int cpu, freq;
 	int i;
 
 	cpu = c->cpu_index;
@@ -83,16 +82,10 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	if (c->microcode)
 		seq_printf(m, "microcode\t: 0x%x\n", c->microcode);
 
-	if (cpu_has(c, X86_FEATURE_TSC)) {
-		unsigned int freq = aperfmperf_get_khz(cpu);
-
-		if (!freq)
-			freq = cpufreq_quick_get(cpu);
-		if (!freq)
-			freq = cpu_khz;
+	freq = x86_get_cpufreq_khz(cpu);
+	if (freq)
 		seq_printf(m, "cpu MHz\t\t: %u.%03u\n",
 			   freq / 1000, (freq % 1000));
-	}
 
 	/* Cache size */
 	if (c->x86_cache_size)
-- 
2.25.1

