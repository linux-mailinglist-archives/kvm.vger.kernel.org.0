Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1C56A2031
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 18:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbjBXRC1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 12:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbjBXRCZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 12:02:25 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5386B151
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 09:02:16 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id y2so12816706pjg.3
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 09:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jdBCcSWmD/x09vfaLkK8fboQxvooLDnkzeel7XCFY9U=;
        b=bZZevSe2DQytVTGOyFQ2xDnTw4PQL3rigDBvzkiepYBQx/QHxvAQAmL2vOoZX8HUmD
         TXtGgHS6RG0EzPPRNc1AY0KbRvPhnyy1R1qMeUAGqAHlTzpyeauB1qV8Gbu1SN/Zz6E9
         o7UKRmu99/FyIPJmWYe8037CRfiiUausqb7IjxXETTwtCm1MBjjPmHQK0TgZRQsmQ8W1
         PurxMJG2xi94kXD2y/n9Y/VDzhksTH1r6CKgTrSFronmPumFPHyEHimlXQNzEMl/M1zf
         QfnF9MWDYNysGvzdFaTQAjfyMkYrBdYRBezTWS/sr9xVJzgWEj080N/i1aUTHl4W0pb5
         CKVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jdBCcSWmD/x09vfaLkK8fboQxvooLDnkzeel7XCFY9U=;
        b=s2P52YvHUaHFrqb21St8pKM2NrSr6yQjyyyvFBShOiPH8cGG7zTRoxwZNg7ywOrNIt
         jk9k9Np47njV+VuZukRSGJvy/XaTxJG/QtnqXp9Ii1Jhzd2oW87Gn/pOpR2X3Vsa/lHK
         24ZfnWRP3+40udWrQHoc37bY0AGCa8eLE5e4reJmZ1C/20cdfxf9cX68uL4Sxioj9lHy
         HRLIX89seNBdzoUd+SKa0TlKi1QpZ4tn6qnElRD1Uqj5IbJQvqymgOrpe1VVmQnCT0MW
         yNnoi5dCoM1PYaVeAa+A5xvaczsCfKZMqL73Q6dFMs8a992k1vxyv9fCIV/NKGYDBnFD
         6OLQ==
X-Gm-Message-State: AO0yUKWLk/pq8i4btMJFLys5tq/yGeFDYpmYBz/zvwZS39R+rGFiFpfQ
        7c+KMxtTQG9hgKta7LblHQbyOQ==
X-Google-Smtp-Source: AK7set/VIz4IdFcCcmfDfMawU19KMH70KUxyj7igMRlChX/KsDv5plpD+hAzyc5Oik79mqw8pbV61g==
X-Received: by 2002:a17:902:d4cb:b0:19a:b033:2bb0 with SMTP id o11-20020a170902d4cb00b0019ab0332bb0mr21485385plg.46.1677258136106;
        Fri, 24 Feb 2023 09:02:16 -0800 (PST)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id b12-20020a170902b60c00b0019472226769sm9234731pls.251.2023.02.24.09.02.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 09:02:15 -0800 (PST)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Changbin Du <changbin.du@intel.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Li Zhengyu <lizhengyu3@huawei.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Tsukasa OI <research_trasio@irq.a4lg.com>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH -next v14 07/19] riscv: Introduce riscv_v_vsize to record size of Vector context
Date:   Fri, 24 Feb 2023 17:01:06 +0000
Message-Id: <20230224170118.16766-8-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230224170118.16766-1-andy.chiu@sifive.com>
References: <20230224170118.16766-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Greentime Hu <greentime.hu@sifive.com>

This patch is used to detect the size of CPU vector registers and use
riscv_v_vsize to save the size of all the vector registers. It assumes all
harts has the same capabilities in a SMP system.

[guoren@linux.alibaba.com: add has_vector checking]
Co-developed-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
---
 arch/riscv/include/asm/vector.h |  5 +++++
 arch/riscv/kernel/Makefile      |  1 +
 arch/riscv/kernel/cpufeature.c  |  2 ++
 arch/riscv/kernel/vector.c      | 21 +++++++++++++++++++++
 4 files changed, 29 insertions(+)
 create mode 100644 arch/riscv/kernel/vector.c

diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vector.h
index dfe5a321b2b4..692d3ee2d2d3 100644
--- a/arch/riscv/include/asm/vector.h
+++ b/arch/riscv/include/asm/vector.h
@@ -13,6 +13,9 @@
 #include <asm/hwcap.h>
 #include <asm/csr.h>
 
+extern unsigned long riscv_v_vsize;
+void riscv_v_setup_vsize(void);
+
 static __always_inline bool has_vector(void)
 {
 	return riscv_has_extension_likely(RISCV_ISA_EXT_v);
@@ -31,6 +34,8 @@ static __always_inline void riscv_v_disable(void)
 #else /* ! CONFIG_RISCV_ISA_V  */
 
 static __always_inline bool has_vector(void) { return false; }
+#define riscv_v_vsize (0)
+#define riscv_v_setup_vsize()	 do {} while (0)
 
 #endif /* CONFIG_RISCV_ISA_V */
 
diff --git a/arch/riscv/kernel/Makefile b/arch/riscv/kernel/Makefile
index 4cf303a779ab..48d345a5f326 100644
--- a/arch/riscv/kernel/Makefile
+++ b/arch/riscv/kernel/Makefile
@@ -55,6 +55,7 @@ obj-$(CONFIG_MMU) += vdso.o vdso/
 
 obj-$(CONFIG_RISCV_M_MODE)	+= traps_misaligned.o
 obj-$(CONFIG_FPU)		+= fpu.o
+obj-$(CONFIG_RISCV_ISA_V)	+= vector.o
 obj-$(CONFIG_SMP)		+= smpboot.o
 obj-$(CONFIG_SMP)		+= smp.o
 obj-$(CONFIG_SMP)		+= cpu_ops.o
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 4b82a01f5603..e6d53e2e672b 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -22,6 +22,7 @@
 #include <asm/processor.h>
 #include <asm/smp.h>
 #include <asm/switch_to.h>
+#include <asm/vector.h>
 
 #define NUM_ALPHA_EXTS ('z' - 'a' + 1)
 
@@ -257,6 +258,7 @@ void __init riscv_fill_hwcap(void)
 	}
 
 	if (elf_hwcap & COMPAT_HWCAP_ISA_V) {
+		riscv_v_setup_vsize();
 		/*
 		 * ISA string in device tree might have 'v' flag, but
 		 * CONFIG_RISCV_ISA_V is disabled in kernel.
diff --git a/arch/riscv/kernel/vector.c b/arch/riscv/kernel/vector.c
new file mode 100644
index 000000000000..082baf2a061f
--- /dev/null
+++ b/arch/riscv/kernel/vector.c
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2023 SiFive
+ * Author: Andy Chiu <andy.chiu@sifive.com>
+ */
+#include <linux/export.h>
+
+#include <asm/vector.h>
+#include <asm/csr.h>
+
+unsigned long riscv_v_vsize __read_mostly;
+EXPORT_SYMBOL_GPL(riscv_v_vsize);
+
+void riscv_v_setup_vsize(void)
+{
+	/* There are 32 vector registers with vlenb length. */
+	riscv_v_enable();
+	riscv_v_vsize = csr_read(CSR_VLENB) * 32;
+	riscv_v_disable();
+}
+
-- 
2.17.1

