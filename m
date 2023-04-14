Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4123E6E27D1
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 17:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbjDNP7w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 11:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbjDNP7r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 11:59:47 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E07903A
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 08:59:36 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id h24-20020a17090a9c1800b002404be7920aso19095028pjp.5
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 08:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1681487976; x=1684079976;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=B94BkZ7daghX/inmD9rHvCSaX9DVRA1XEaP0tUQccbw=;
        b=LGr6tEu6iREyythLaMUfkOHD8BAkTlTDZJ8giXkI8tJt21GrojUizZGrI2hy59fwpj
         wO0jlf/s0CaWkqSF7QDb7Rl1tZLYhOXuUf/Y01Q2DD7vvmQXoSvRT+2Hdn/pWWnkhQF8
         RW1jo+54Pnl0cCKNIHu9VbvqZI2g5MVkieqIrQY4kalhyMuzxm5oqrvkaemp6my8/ADd
         7u5FslGK6m6ZXU+DlTmjpF5W6IhBTWJbMA82hUN6bHj8X0AuYrTiJCOo5WcblZ39lg/n
         I54+3Jwev4NKkR0L+CxitJE1odf5zuDsAjI32yqzhYraD3WGZ4pKxTjl9YQtc5W2fLsx
         jp5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681487976; x=1684079976;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B94BkZ7daghX/inmD9rHvCSaX9DVRA1XEaP0tUQccbw=;
        b=CZpGV6jna5yeQ5J1wEQbQDPuHFrEubLaq80n8IKqUNc0nYPnv90sqIPrBguiXaQHmr
         5SHKLgWhTfIgPeE/xYUpDiA/wvFDmxhYPZuw6UQSIfogvvdmSZkfF+GZ0+j3v8tOPkSE
         ut8l8XXEE5wFh8S8q3HgDXj6d0SuTTPb0kfQAQuqXSmC0qexMkzRol+ULcCW6AlZqY/l
         jzLdT5a/CIxhmA4IWTpGwIlX7oo3gMNKG73yqT4N0IYpVXZBCS0AFyIEPk5045ryCFqV
         yZMSyVQuhB8QOMAjOIJ3aF7eDBRUl9Y3IJdzsyOdv+hfpZUEPSsj0Ihv05F84BzdrfFf
         BUvg==
X-Gm-Message-State: AAQBX9ftgeK3vlGdifIQwiOZ6kfHRTGm7np0n1ClEVHHScVjwIuo9t9/
        VoB5YsvL5BSG33T1hq/adlT5qw==
X-Google-Smtp-Source: AKy350Z/GDCabIKjwCihnSew4qRlImLymQVij6vd9gfZIWbugGjsZpJbbJRbZrStHp+sqZMowbsY5w==
X-Received: by 2002:a17:90b:215:b0:23d:376a:c2bc with SMTP id fy21-20020a17090b021500b0023d376ac2bcmr6023241pjb.5.1681487976338;
        Fri, 14 Apr 2023 08:59:36 -0700 (PDT)
Received: from hsinchu25.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id br8-20020a17090b0f0800b00240d4521958sm3083584pjb.18.2023.04.14.08.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 08:59:35 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Li Zhengyu <lizhengyu3@huawei.com>,
        Liao Chang <liaochang1@huawei.com>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Philipp Tomsich <philipp.tomsich@vrull.eu>,
        Sunil V L <sunilvl@ventanamicro.com>,
        Ley Foon Tan <leyfoon.tan@starfivetech.com>
Subject: [PATCH -next v18 07/20] riscv: Introduce riscv_v_vsize to record size of Vector context
Date:   Fri, 14 Apr 2023 15:58:30 +0000
Message-Id: <20230414155843.12963-8-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230414155843.12963-1-andy.chiu@sifive.com>
References: <20230414155843.12963-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Greentime Hu <greentime.hu@sifive.com>

This patch is used to detect the size of CPU vector registers and use
riscv_v_vsize to save the size of all the vector registers. It assumes all
harts has the same capabilities in a SMP system. If a core detects VLENB
that is different from the boot core, then it warns and turns off V
support for user space.

Co-developed-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Co-developed-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
---

Changes in v18:
 - Detect inconsistent VLEN setup on an SMP system (Heiko).

 arch/riscv/include/asm/vector.h |  8 ++++++++
 arch/riscv/kernel/Makefile      |  1 +
 arch/riscv/kernel/cpufeature.c  |  2 ++
 arch/riscv/kernel/smpboot.c     |  7 +++++++
 arch/riscv/kernel/vector.c      | 36 +++++++++++++++++++++++++++++++++
 5 files changed, 54 insertions(+)
 create mode 100644 arch/riscv/kernel/vector.c

diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vector.h
index dfe5a321b2b4..68c9fe831a41 100644
--- a/arch/riscv/include/asm/vector.h
+++ b/arch/riscv/include/asm/vector.h
@@ -7,12 +7,16 @@
 #define __ASM_RISCV_VECTOR_H
 
 #include <linux/types.h>
+#include <uapi/asm-generic/errno.h>
 
 #ifdef CONFIG_RISCV_ISA_V
 
 #include <asm/hwcap.h>
 #include <asm/csr.h>
 
+extern unsigned long riscv_v_vsize;
+int riscv_v_setup_vsize(void);
+
 static __always_inline bool has_vector(void)
 {
 	return riscv_has_extension_likely(RISCV_ISA_EXT_v);
@@ -30,7 +34,11 @@ static __always_inline void riscv_v_disable(void)
 
 #else /* ! CONFIG_RISCV_ISA_V  */
 
+struct pt_regs;
+
+static inline int riscv_v_setup_vsize(void) { return -EOPNOTSUPP; }
 static __always_inline bool has_vector(void) { return false; }
+#define riscv_v_vsize (0)
 
 #endif /* CONFIG_RISCV_ISA_V */
 
diff --git a/arch/riscv/kernel/Makefile b/arch/riscv/kernel/Makefile
index 392fa6e35d4a..be23a021ec32 100644
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
index 923ca75f2192..267070f3cc9e 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -17,6 +17,7 @@
 #include <asm/hwcap.h>
 #include <asm/patch.h>
 #include <asm/processor.h>
+#include <asm/vector.h>
 
 #define NUM_ALPHA_EXTS ('z' - 'a' + 1)
 
@@ -263,6 +264,7 @@ void __init riscv_fill_hwcap(void)
 	}
 
 	if (elf_hwcap & COMPAT_HWCAP_ISA_V) {
+		riscv_v_setup_vsize();
 		/*
 		 * ISA string in device tree might have 'v' flag, but
 		 * CONFIG_RISCV_ISA_V is disabled in kernel.
diff --git a/arch/riscv/kernel/smpboot.c b/arch/riscv/kernel/smpboot.c
index ddb2afba6d25..67ae124db5a4 100644
--- a/arch/riscv/kernel/smpboot.c
+++ b/arch/riscv/kernel/smpboot.c
@@ -32,6 +32,8 @@
 #include <asm/sections.h>
 #include <asm/sbi.h>
 #include <asm/smp.h>
+#include <uapi/asm/hwcap.h>
+#include <asm/vector.h>
 
 #include "head.h"
 
@@ -169,6 +171,11 @@ asmlinkage __visible void smp_callin(void)
 	numa_add_cpu(curr_cpuid);
 	set_cpu_online(curr_cpuid, 1);
 
+	if (has_vector()) {
+		if (riscv_v_setup_vsize())
+			elf_hwcap &= ~COMPAT_HWCAP_ISA_V;
+	}
+
 	/*
 	 * Remote TLB flushes are ignored while the CPU is offline, so emit
 	 * a local TLB flush right now just in case.
diff --git a/arch/riscv/kernel/vector.c b/arch/riscv/kernel/vector.c
new file mode 100644
index 000000000000..53bb32546248
--- /dev/null
+++ b/arch/riscv/kernel/vector.c
@@ -0,0 +1,36 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2023 SiFive
+ * Author: Andy Chiu <andy.chiu@sifive.com>
+ */
+#include <linux/export.h>
+
+#include <asm/vector.h>
+#include <asm/csr.h>
+#include <asm/elf.h>
+#include <asm/bug.h>
+
+unsigned long riscv_v_vsize __read_mostly;
+EXPORT_SYMBOL_GPL(riscv_v_vsize);
+
+int riscv_v_setup_vsize(void)
+{
+	unsigned long this_vsize;
+
+	/* There are 32 vector registers with vlenb length. */
+	riscv_v_enable();
+	this_vsize = csr_read(CSR_VLENB) * 32;
+	riscv_v_disable();
+
+	if (!riscv_v_vsize) {
+		riscv_v_vsize = this_vsize;
+		return 0;
+	}
+
+	if (riscv_v_vsize != this_vsize) {
+		WARN(1, "RISCV_ISA_V only supports one vlenb on SMP system");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
-- 
2.17.1

