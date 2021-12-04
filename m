Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7B7468125
	for <lists+kvm@lfdr.de>; Sat,  4 Dec 2021 01:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383763AbhLDAYZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 19:24:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383701AbhLDAYW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Dec 2021 19:24:22 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03EAAC061751
        for <kvm@vger.kernel.org>; Fri,  3 Dec 2021 16:20:58 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id q16so4603391pgq.10
        for <kvm@vger.kernel.org>; Fri, 03 Dec 2021 16:20:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=atishpatra.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=swEa7qpsajKgCxZA2Su/bxF+YJ1+Y66ngqAKD6+8Oxg=;
        b=SrtcEbUMfX6BFvl81Eh55+QTf17GQ6EYAeE50Tk/U6AT8/ZgolQh+RPi/9hAZWdMOo
         u9IZmUkU6hRuKuayvzcC8h1YJsBSSJwl6gSS7F/nVt+uMToCdKO9mKy2WmL2Ybp4eLK6
         VL7+ehzveDnbiavTshyhEPxFN2cjLDDBuLytc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=swEa7qpsajKgCxZA2Su/bxF+YJ1+Y66ngqAKD6+8Oxg=;
        b=6X1z3pM6ImiXjeR95IHVE4pjtnkuKa+2rZsNR0h9PigUJbLrl7NFFnyQ1M+TiQxh7p
         emKbAcwukRBwaJ3lulg/Ev94PrcJ1bF1vatPR73ZJF2NTNXQQ59L5fydXEm6LKasSrjh
         Tzl/+lEV9p6kgjsr8ZYpB3sfStZK1dq3BlISnjhOaJ1Ct19qx69qE64B/HEIV8w5XZwQ
         4BGoL4YRXxA0SUAGsJaP6g7/vSVlzXxQ+3sOkIbduR+qRpDgHLYc19ttiu4nrUWaEoJZ
         8wf+IR6ko2o2mgusz7DOqot26vYRJr3Bl8oQqBC2g0UrBL38HBQ+p+c1NYMge4CSnMjS
         hciw==
X-Gm-Message-State: AOAM530ZRpC6wOFmfnBnYsWhWI4Dq9uFhzuaOQ+vYxTDY3aLiTdGG1XO
        CGr0YVw4y4mOZNmhZHCouiXI
X-Google-Smtp-Source: ABdhPJwXiSVwtEhpX0ysW2nZnO0HD4Yyb2I+Rg7C1DXlmoOIB3WGxPueCJOvkBqTsSI44xhQtL9tlg==
X-Received: by 2002:a63:2cd1:: with SMTP id s200mr6991174pgs.489.1638577257563;
        Fri, 03 Dec 2021 16:20:57 -0800 (PST)
Received: from fedora.ba.rivosinc.com (99-13-229-45.lightspeed.snjsca.sbcglobal.net. [99.13.229.45])
        by smtp.gmail.com with ESMTPSA id r6sm3272402pjg.21.2021.12.03.16.20.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 16:20:57 -0800 (PST)
From:   Atish Patra <atishp@atishpatra.org>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>, Alexandre Ghiti <alex@ghiti.fr>,
        Anup Patel <anup.patel@wdc.com>,
        Greentime Hu <greentime.hu@sifive.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>,
        Ingo Molnar <mingo@kernel.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
        Nanyong Sun <sunnanyong@huawei.com>,
        Nick Kossifidis <mick@ics.forth.gr>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Pekka Enberg <penberg@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Vitaly Wool <vitaly.wool@konsulko.com>
Subject: [RFC 5/6] RISC-V: Move spinwait booting method to its own config
Date:   Fri,  3 Dec 2021 16:20:37 -0800
Message-Id: <20211204002038.113653-6-atishp@atishpatra.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211204002038.113653-1-atishp@atishpatra.org>
References: <20211204002038.113653-1-atishp@atishpatra.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Atish Patra <atishp@rivosinc.com>

The spinwait booting method should only be used for platforms with older
firmware without SBI HSM extension or M-mode firmware because spinwait
method can't support cpu hotplug, kexec or sparse hartid. It is better
to move the entire spinwait implementation to its own config which can
be disabled if required. It is enabled by default to maintain backward
compatibility and M-mode Linux.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/Kconfig          | 14 ++++++++++++++
 arch/riscv/kernel/Makefile  |  3 ++-
 arch/riscv/kernel/cpu_ops.c |  8 ++++++++
 arch/riscv/kernel/head.S    |  6 +++---
 arch/riscv/kernel/head.h    |  2 ++
 5 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 821252b65f89..4afb42d5707d 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -403,6 +403,20 @@ config RISCV_SBI_V01
 	  This config allows kernel to use SBI v0.1 APIs. This will be
 	  deprecated in future once legacy M-mode software are no longer in use.
 
+config RISCV_BOOT_SPINWAIT
+	bool "Spinwait booting method"
+	depends on SMP
+	default y
+	help
+	  This enables support for booting Linux via spinwait method. In the
+	  spinwait method, all cores randomly jump to Linux. One of the core
+	  gets chosen via lottery and all other keeps spinning on a percpu
+	  variable. This method can not support cpu hotplug and sparse hartid
+	  scheme. It should be only enabled for M-mode Linux or platforms relying
+	  on older firmware without SBI HSM extension. All other platform should
+	  rely on ordered booing via SBI HSM extension which gets chosen
+          dynamically at runtime if the firmware supports it.
+
 config KEXEC
 	bool "Kexec system call"
 	select KEXEC_CORE
diff --git a/arch/riscv/kernel/Makefile b/arch/riscv/kernel/Makefile
index 3397ddac1a30..612556faa527 100644
--- a/arch/riscv/kernel/Makefile
+++ b/arch/riscv/kernel/Makefile
@@ -43,7 +43,8 @@ obj-$(CONFIG_FPU)		+= fpu.o
 obj-$(CONFIG_SMP)		+= smpboot.o
 obj-$(CONFIG_SMP)		+= smp.o
 obj-$(CONFIG_SMP)		+= cpu_ops.o
-obj-$(CONFIG_SMP)		+= cpu_ops_spinwait.o
+
+obj-$(CONFIG_RISCV_BOOT_SPINWAIT) += cpu_ops_spinwait.o
 obj-$(CONFIG_MODULES)		+= module.o
 obj-$(CONFIG_MODULE_SECTIONS)	+= module-sections.o
 
diff --git a/arch/riscv/kernel/cpu_ops.c b/arch/riscv/kernel/cpu_ops.c
index c1e30f403c3b..170d07e57721 100644
--- a/arch/riscv/kernel/cpu_ops.c
+++ b/arch/riscv/kernel/cpu_ops.c
@@ -15,7 +15,15 @@
 const struct cpu_operations *cpu_ops[NR_CPUS] __ro_after_init;
 
 extern const struct cpu_operations cpu_ops_sbi;
+#ifdef CONFIG_RISCV_BOOT_SPINWAIT
 extern const struct cpu_operations cpu_ops_spinwait;
+#else
+const struct cpu_operations cpu_ops_spinwait = {
+	.name		= "",
+	.cpu_prepare	= NULL,
+	.cpu_start	= NULL,
+};
+#endif
 
 void __init cpu_set_ops(int cpuid)
 {
diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
index 9f16bfe9307e..4a694e15b95b 100644
--- a/arch/riscv/kernel/head.S
+++ b/arch/riscv/kernel/head.S
@@ -259,7 +259,7 @@ pmp_done:
 	li t0, SR_FS
 	csrc CSR_STATUS, t0
 
-#ifdef CONFIG_SMP
+#ifdef CONFIG_RISCV_BOOT_SPINWAIT
 	li t0, CONFIG_NR_CPUS
 	blt a0, t0, .Lgood_cores
 	tail .Lsecondary_park
@@ -285,7 +285,7 @@ pmp_done:
 	beq t0, t1, .Lsecondary_start
 
 #endif /* CONFIG_XIP */
-#endif /* CONFIG_SMP */
+#endif /* CONFIG_RISCV_BOOT_SPINWAIT */
 
 #ifdef CONFIG_XIP_KERNEL
 	la sp, _end + THREAD_SIZE
@@ -344,7 +344,7 @@ clear_bss_done:
 	call soc_early_init
 	tail start_kernel
 
-#ifdef CONFIG_SMP
+#if defined(CONFIG_SMP) && defined(CONFIG_RISCV_BOOT_SPINWAIT)
 .Lsecondary_start:
 	/* Set trap vector to spin forever to help debug */
 	la a3, .Lsecondary_park
diff --git a/arch/riscv/kernel/head.h b/arch/riscv/kernel/head.h
index 5393cca77790..726731ada534 100644
--- a/arch/riscv/kernel/head.h
+++ b/arch/riscv/kernel/head.h
@@ -16,7 +16,9 @@ asmlinkage void __init setup_vm(uintptr_t dtb_pa);
 asmlinkage void __init __copy_data(void);
 #endif
 
+#ifdef CONFIG_RISCV_BOOT_SPINWAIT
 extern void *__cpu_spinwait_stack_pointer[];
 extern void *__cpu_spinwait_task_pointer[];
+#endif
 
 #endif /* __ASM_HEAD_H */
-- 
2.33.1

