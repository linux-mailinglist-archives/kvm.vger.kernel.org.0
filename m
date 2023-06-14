Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E6B722B73
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 17:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234979AbjFEPk6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 11:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234911AbjFEPkg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 11:40:36 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9307A10B
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 08:40:29 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1b02d0942caso22484105ad.1
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 08:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1685979629; x=1688571629;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ShTLilbxMyWLUQGoTSAD12rpTJu8sGTqDWBHoo4WTRA=;
        b=RqN9ZmR50wIWqZyNAaUyXSKQkkoOCrNgGrYpV8HX55CJ2hj0Zgi9KgPtiP3uaGquro
         cabixdl5dULRIQwjV+wsruAnV7wvAec4Tyhp3uArmZxCn9oAS+49B89FTOFoY6HX6va/
         a66Xobd4wMb69AqfGVSXC+R6ZpKrdMSnPiI0jXO6dCG7J39Q+dMP9crOxImwT690ZD4x
         0ADYj2ltn4F3e6YfEYUUFC5y8z+/0t1B3cMMsF6I0ylwf0fkJoxC2LfGvDP4mV3GXpMJ
         m3PTnh6o9cpNoVjp0cDVwLe9l7iWdmx8en09CB/XItjUj0IqiuGUpff6nRuoJ2HCJ/Q5
         GBHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685979629; x=1688571629;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ShTLilbxMyWLUQGoTSAD12rpTJu8sGTqDWBHoo4WTRA=;
        b=NVuyGzgxrIlouaCv+iisZB2RY5v/NRVC2ycXMgTz43aPxUcMbouvujZ1PO9I+k+FG3
         iiuUdACPN3p8frLvZCNovaz8mVi0HB/pdwSykQUm0QogrIvWKuZ1nnWXmJFvwRSpyz84
         Dv2C+cgl4oR4DsUDof0O8hkxL8EacY2m1yINZbUovS7a4ySiXHSjLf3OIPLZHxElLpZF
         MsMxA8h4eb+e/C5o3ZZmI2FhbvlMq7NffAeR4TopZrn2LnVag5imwXonXqM6i8W0gbPh
         dKx7cLDSOYYR16Xlpa57KLhJerxR3hmjAf6z9iXhuCEVlM+2H6rYlVWVajG/pjZGRORX
         uhXA==
X-Gm-Message-State: AC+VfDyXIzxiuxI/KN7qyXDNxxkwLY6KX/olzcFDIpd8yLs4CuYrnMr5
        Kwyr1w10v+xhP0SSk600PT/A2A==
X-Google-Smtp-Source: ACHHUZ5oy2CNE0jOxLsgkHbef63bspI+MqBmAWzHXrdzwFPqmy8wWcGTWTYvgZCNw/CRReweWkmBwA==
X-Received: by 2002:a17:902:6b43:b0:1b2:2c0c:d3fa with SMTP id g3-20020a1709026b4300b001b22c0cd3famr157669plt.9.1685979629024;
        Mon, 05 Jun 2023 08:40:29 -0700 (PDT)
Received: from hsinchu26.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id jk19-20020a170903331300b001b0aec3ed59sm6725962plb.256.2023.06.05.08.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 08:40:28 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Vincent Chen <vincent.chen@sifive.com>,
        Andy Chiu <andy.chiu@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Guo Ren <guoren@kernel.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        Alexandre Ghiti <alexghiti@rivosinc.com>,
        Li Zhengyu <lizhengyu3@huawei.com>,
        Sia Jee Heng <jeeheng.sia@starfivetech.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        Anup Patel <apatel@ventanamicro.com>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Atish Patra <atishp@rivosinc.com>,
        Ley Foon Tan <leyfoon.tan@starfivetech.com>,
        Evan Green <evan@rivosinc.com>,
        Sunil V L <sunilvl@ventanamicro.com>
Subject: [PATCH -next v21 08/27] riscv: Introduce riscv_v_vsize to record size of Vector context
Date:   Mon,  5 Jun 2023 11:07:05 +0000
Message-Id: <20230605110724.21391-9-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230605110724.21391-1-andy.chiu@sifive.com>
References: <20230605110724.21391-1-andy.chiu@sifive.com>
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
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
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Tested-by: Heiko Stuebner <heiko.stuebner@vrull.eu>
Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>
---
Changelog V19:
 - Fix grammar in WARN() (Conor)
Changelog V18:
 - Detect inconsistent VLEN setup on an SMP system (Heiko).
---
 arch/riscv/include/asm/vector.h |  8 ++++++++
 arch/riscv/kernel/Makefile      |  1 +
 arch/riscv/kernel/cpufeature.c  |  2 ++
 arch/riscv/kernel/smpboot.c     |  7 +++++++
 arch/riscv/kernel/vector.c      | 36 +++++++++++++++++++++++++++++++++
 5 files changed, 54 insertions(+)
 create mode 100644 arch/riscv/kernel/vector.c

diff --git a/arch/riscv/include/asm/vector.h b/arch/riscv/include/asm/vector.h
index 51bb37232943..df3b5caecc87 100644
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
 	return riscv_has_extension_unlikely(RISCV_ISA_EXT_v);
@@ -30,7 +34,11 @@ static __always_inline void riscv_v_disable(void)
 
 #else /* ! CONFIG_RISCV_ISA_V  */
 
+struct pt_regs;
+
+static inline int riscv_v_setup_vsize(void) { return -EOPNOTSUPP; }
 static __always_inline bool has_vector(void) { return false; }
+#define riscv_v_vsize (0)
 
 #endif /* CONFIG_RISCV_ISA_V */
 
diff --git a/arch/riscv/kernel/Makefile b/arch/riscv/kernel/Makefile
index fbdccc21418a..c51f34c2756a 100644
--- a/arch/riscv/kernel/Makefile
+++ b/arch/riscv/kernel/Makefile
@@ -56,6 +56,7 @@ obj-$(CONFIG_MMU) += vdso.o vdso/
 
 obj-$(CONFIG_RISCV_M_MODE)	+= traps_misaligned.o
 obj-$(CONFIG_FPU)		+= fpu.o
+obj-$(CONFIG_RISCV_ISA_V)	+= vector.o
 obj-$(CONFIG_SMP)		+= smpboot.o
 obj-$(CONFIG_SMP)		+= smp.o
 obj-$(CONFIG_SMP)		+= cpu_ops.o
diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
index 7aaf92fff64e..28032b083463 100644
--- a/arch/riscv/kernel/cpufeature.c
+++ b/arch/riscv/kernel/cpufeature.c
@@ -18,6 +18,7 @@
 #include <asm/hwcap.h>
 #include <asm/patch.h>
 #include <asm/processor.h>
+#include <asm/vector.h>
 
 #define NUM_ALPHA_EXTS ('z' - 'a' + 1)
 
@@ -269,6 +270,7 @@ void __init riscv_fill_hwcap(void)
 	}
 
 	if (elf_hwcap & COMPAT_HWCAP_ISA_V) {
+		riscv_v_setup_vsize();
 		/*
 		 * ISA string in device tree might have 'v' flag, but
 		 * CONFIG_RISCV_ISA_V is disabled in kernel.
diff --git a/arch/riscv/kernel/smpboot.c b/arch/riscv/kernel/smpboot.c
index 445a4efee267..66011bf2b36e 100644
--- a/arch/riscv/kernel/smpboot.c
+++ b/arch/riscv/kernel/smpboot.c
@@ -31,6 +31,8 @@
 #include <asm/tlbflush.h>
 #include <asm/sections.h>
 #include <asm/smp.h>
+#include <uapi/asm/hwcap.h>
+#include <asm/vector.h>
 
 #include "head.h"
 
@@ -169,6 +171,11 @@ asmlinkage __visible void smp_callin(void)
 	set_cpu_online(curr_cpuid, 1);
 	probe_vendor_features(curr_cpuid);
 
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
index 000000000000..120f1ce9abf9
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
+		WARN(1, "RISCV_ISA_V only supports one vlenb on SMP systems");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
-- 
2.17.1

