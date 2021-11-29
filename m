Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25A79460E6E
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 06:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233394AbhK2F2a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 00:28:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbhK2F0a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 00:26:30 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38012C061748
        for <kvm@vger.kernel.org>; Sun, 28 Nov 2021 21:23:13 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so14606334pju.3
        for <kvm@vger.kernel.org>; Sun, 28 Nov 2021 21:23:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wq9RzdauOWtYeDKXYH0QcmusFkbepqiiPKAstjqHJUA=;
        b=sBOUIg85/I2JQjrml2LqQ+sbayuB0PDTVqmKImwcNzUWsr94lH1+BchsxXHP5XjSLm
         upD+vgg05rNM8phJtJd/mH8F5KM2+jc8vyE9LrVO7eyIt3dPrpNNBwzfNjDbFFK3mw7w
         9mhmucdlrqJthe0UZvnJ7XIDWzE5tTSLgwe3thDUOUIAl2dCShOpEDAHsPlb3MtE1VDA
         Jk+6qabASqQE+aCW7GbPoHCiFPp5100eMYBRXNZ8hgEEmzpKTAHF8DKvoxNdO9aemK0e
         NRgbbXIcenQrJ4HwLj1/Wsl1e910We5zzIiERNZUmdyrUnIthUxI4ixxPopTKWfm7vEq
         5R1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Wq9RzdauOWtYeDKXYH0QcmusFkbepqiiPKAstjqHJUA=;
        b=AmKZK0w3g8mKgFynOKPnQgnlP8MmHvk3Oq0vWe22mGGhJ5IrfZYqks+wCCLRA2bOcD
         c0M10WkNf4MXPr00ukZHi4WT9LraNxJHZHA6DL+Hr+Beyd9x9TAIqi8jhrCcUptUlOCD
         M26YlDjsFj5fSi9tHBv6TqQz7vRaCzNWP88wRKj/A+pdlH3fv4iTeRhEwS7q71k2+Px/
         h6D1bxn0U5nSzQ0YGqwc/rVM4PxpXhWdcefdvT6LEuorI0faLQYHGevEkpUG+qDgBZ2Y
         MJp0swmD6cskrL/nVTB4Am3KAxLwCUAUt11HWYYftmO29d6dDvu3qGCOIxN6mkEwGC8o
         YzoA==
X-Gm-Message-State: AOAM533Qy428Z73xYbDHjHef6iZsog/ZLKPWiaVTw6bIsGVHy8re1rXz
        u6CGlqPxgSJRJ815EyWRko4TSuo4oywIwQ==
X-Google-Smtp-Source: ABdhPJyYRbDdzBVtYWoesfGKJeyRVSotS/j/PHaXg7pMvRLH5D7TpOCQZvDukizKax3zkQKrFiuLrQ==
X-Received: by 2002:a17:902:b615:b0:143:bbf0:aad0 with SMTP id b21-20020a170902b61500b00143bbf0aad0mr57621547pls.12.1638163392808;
        Sun, 28 Nov 2021 21:23:12 -0800 (PST)
Received: from sushi.bytedance.net ([61.120.150.74])
        by smtp.gmail.com with ESMTPSA id t13sm14753683pfl.214.2021.11.28.21.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 21:23:12 -0800 (PST)
From:   zhenwei pi <pizhenwei@bytedance.com>
To:     tglx@linutronix.de, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        zhenwei pi <pizhenwei@bytedance.com>
Subject: [PATCH 1/2] x86/cpu: introduce x86_get_freq
Date:   Mon, 29 Nov 2021 13:20:37 +0800
Message-Id: <20211129052038.43758-1-pizhenwei@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wrapper function x86_get_freq to get freq on a x86 platform, hide
detailed implementation for proc routine.
Also export this function for the further use, a typical case is that
kvm module gets the freq of the host and tell the guest side by
kvmclock.

Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
---
 arch/x86/include/asm/processor.h |  2 ++
 arch/x86/kernel/cpu/common.c     | 18 ++++++++++++++++++
 arch/x86/kernel/cpu/proc.c       | 13 +++----------
 3 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 355d38c0cf60..753ab64b7bf3 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -855,4 +855,6 @@ enum mds_mitigations {
 	MDS_MITIGATION_VMWERV,
 };
 
+unsigned int x86_get_freq(unsigned int cpu);
+
 #endif /* _ASM_X86_PROCESSOR_H */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 0083464de5e3..fc6c8ba7a777 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -22,6 +22,7 @@
 #include <linux/io.h>
 #include <linux/syscore_ops.h>
 #include <linux/pgtable.h>
+#include <linux/cpufreq.h>
 
 #include <asm/cmdline.h>
 #include <asm/stackprotector.h>
@@ -2104,3 +2105,20 @@ void arch_smt_update(void)
 	/* Check whether IPI broadcasting can be enabled */
 	apic_smt_update();
 }
+
+unsigned int x86_get_freq(unsigned int cpu)
+{
+	unsigned int freq = 0;
+
+	if (cpu_has(&cpu_data(cpu), X86_FEATURE_TSC)) {
+		freq = aperfmperf_get_khz(cpu);
+		if (!freq)
+			freq = cpufreq_quick_get(cpu);
+
+		if (!freq)
+			freq = cpu_khz;
+	}
+
+	return freq;
+}
+EXPORT_SYMBOL_GPL(x86_get_freq);
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 4eec8889b0ff..5384b3a2258e 100644
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
+	freq = x86_get_freq(cpu);
+	if (freq)
 		seq_printf(m, "cpu MHz\t\t: %u.%03u\n",
 			   freq / 1000, (freq % 1000));
-	}
 
 	/* Cache size */
 	if (c->x86_cache_size)
-- 
2.25.1

