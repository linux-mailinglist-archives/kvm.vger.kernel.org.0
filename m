Return-Path: <kvm+bounces-5210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C2C781E094
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 14:00:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3B2228236D
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 13:00:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6638053E22;
	Mon, 25 Dec 2023 12:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PtSRiw0x"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9672E53E14;
	Mon, 25 Dec 2023 12:59:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31591C433C9;
	Mon, 25 Dec 2023 12:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703509167;
	bh=2Z46GseDSsRZCObseUIhG4G69BCIrlr3TmvRTzx91EA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PtSRiw0xhPNgePaU6M9/aRO2qC3/tTEsRpIYTtfsj9+9cUCmssVbJC+nX75445/fw
	 lJOQOAfdIwVeuGTvXTRF+vPglUe/Pht9J1aD7f5ImxKXjlahtHb788f8GKn/2K9O9K
	 3qqkCCiDm4PdrsaJOh8/FFkF/aowRHuPIatrL0BAGTjrInw7pfbb99qhQIZmV570Ys
	 BaOMEEXLocb6zvgjgkBaEr3LEVP7md/VdWyJ1wK2wPJb1Sjlf55pUNRqu43iYoXblB
	 SmNM5T4qGCDcX6y7E4XtcsUiL4lXMYrdW7wbIEdvjLOTOVlpI2D9IcnrOLwowECkCa
	 Qn7ROvmW1Dhgg==
From: guoren@kernel.org
To: paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	guoren@kernel.org,
	panqinglin2020@iscas.ac.cn,
	bjorn@rivosinc.com,
	conor.dooley@microchip.com,
	leobras@redhat.com,
	peterz@infradead.org,
	anup@brainfault.org,
	keescook@chromium.org,
	wuwei2016@iscas.ac.cn,
	xiaoguang.xing@sophgo.com,
	chao.wei@sophgo.com,
	unicorn_wang@outlook.com,
	uwu@icenowy.me,
	jszhang@kernel.org,
	wefu@redhat.com,
	atishp@atishpatra.org
Cc: linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	Guo Ren <guoren@linux.alibaba.com>
Subject: [PATCH V12 05/14] riscv: qspinlock: Add basic queued_spinlock support
Date: Mon, 25 Dec 2023 07:58:38 -0500
Message-Id: <20231225125847.2778638-6-guoren@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231225125847.2778638-1-guoren@kernel.org>
References: <20231225125847.2778638-1-guoren@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Guo Ren <guoren@linux.alibaba.com>

The requirements of qspinlock have been documented by commit:
a8ad07e5240c ("asm-generic: qspinlock: Indicate the use of mixed-size
atomics").

Although RISC-V ISA gives out a weaker forward guarantee LR/SC, which
doesn't satisfy the requirements of qspinlock above, it won't prevent
some riscv vendors from implementing a strong fwd guarantee LR/SC in
microarchitecture to match xchg_tail requirement. T-HEAD C9xx processor
is the one.

We've tested the patch on SOPHGO sg2042 & th1520 and passed the stress
test on Fedora & Ubuntu & OpenEuler ... Here is the performance
comparison between qspinlock and ticket_lock on sg2042 (64 cores):

sysbench test=threads threads=32 yields=100 lock=8 (+13.8%):
  queued_spinlock 0.5109/0.00
  ticket_spinlock 0.5814/0.00

perf futex/hash (+6.7%):
  queued_spinlock 1444393 operations/sec (+- 0.09%)
  ticket_spinlock 1353215 operations/sec (+- 0.15%)

perf futex/wake-parallel (+8.6%):
  queued_spinlock (waking 1/64 threads) in 0.0253 ms (+-2.90%)
  ticket_spinlock (waking 1/64 threads) in 0.0275 ms (+-3.12%)

perf futex/requeue (+4.2%):
  queued_spinlock Requeued 64 of 64 threads in 0.0785 ms (+-0.55%)
  ticket_spinlock Requeued 64 of 64 threads in 0.0818 ms (+-4.12%)

System Benchmarks (+6.4%)
  queued_spinlock:
    System Benchmarks Index Values               BASELINE       RESULT    INDEX
    Dhrystone 2 using register variables         116700.0  628613745.4  53865.8
    Double-Precision Whetstone                       55.0     182422.8  33167.8
    Execl Throughput                                 43.0      13116.6   3050.4
    File Copy 1024 bufsize 2000 maxblocks          3960.0    7762306.2  19601.8
    File Copy 256 bufsize 500 maxblocks            1655.0    3417556.8  20649.9
    File Copy 4096 bufsize 8000 maxblocks          5800.0    7427995.7  12806.9
    Pipe Throughput                               12440.0   23058600.5  18535.9
    Pipe-based Context Switching                   4000.0    2835617.7   7089.0
    Process Creation                                126.0      12537.3    995.0
    Shell Scripts (1 concurrent)                     42.4      57057.4  13456.9
    Shell Scripts (8 concurrent)                      6.0       7367.1  12278.5
    System Call Overhead                          15000.0   33308301.3  22205.5
                                                                       ========
    System Benchmarks Index Score                                       12426.1

  ticket_spinlock:
    System Benchmarks Index Values               BASELINE       RESULT    INDEX
    Dhrystone 2 using register variables         116700.0  626541701.9  53688.2
    Double-Precision Whetstone                       55.0     181921.0  33076.5
    Execl Throughput                                 43.0      12625.1   2936.1
    File Copy 1024 bufsize 2000 maxblocks          3960.0    6553792.9  16550.0
    File Copy 256 bufsize 500 maxblocks            1655.0    3189231.6  19270.3
    File Copy 4096 bufsize 8000 maxblocks          5800.0    7221277.0  12450.5
    Pipe Throughput                               12440.0   20594018.7  16554.7
    Pipe-based Context Switching                   4000.0    2571117.7   6427.8
    Process Creation                                126.0      10798.4    857.0
    Shell Scripts (1 concurrent)                     42.4      57227.5  13497.1
    Shell Scripts (8 concurrent)                      6.0       7329.2  12215.3
    System Call Overhead                          15000.0   30766778.4  20511.2
                                                                       ========
    System Benchmarks Index Score                                       11670.7

The qspinlock has a significant improvement on SOPHGO SG2042 64
cores platform than the ticket_lock.

Reviewed-by: Leonardo Bras <leobras@redhat.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
---
 arch/riscv/Kconfig                | 16 ++++++++++++++++
 arch/riscv/include/asm/Kbuild     |  4 +++-
 arch/riscv/include/asm/spinlock.h | 18 ++++++++++++++++++
 3 files changed, 37 insertions(+), 1 deletion(-)
 create mode 100644 arch/riscv/include/asm/spinlock.h

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 24c1799e2ec4..f345df0763b2 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -432,6 +432,22 @@ config NODES_SHIFT
 	  Specify the maximum number of NUMA Nodes available on the target
 	  system.  Increases memory reserved to accommodate various tables.
 
+choice
+	prompt "RISC-V spinlock type"
+	default RISCV_TICKET_SPINLOCKS
+
+config RISCV_TICKET_SPINLOCKS
+	bool "Using ticket spinlock"
+
+config RISCV_QUEUED_SPINLOCKS
+	bool "Using queued spinlock"
+	depends on SMP && MMU
+	select ARCH_USE_QUEUED_SPINLOCKS
+	help
+	  Make sure your micro arch give cmpxchg/xchg forward progress
+	  guarantee. Otherwise, stay at ticket-lock.
+endchoice
+
 config RISCV_ALTERNATIVE
 	bool
 	depends on !XIP_KERNEL
diff --git a/arch/riscv/include/asm/Kbuild b/arch/riscv/include/asm/Kbuild
index 504f8b7e72d4..ad72f2bd4cc9 100644
--- a/arch/riscv/include/asm/Kbuild
+++ b/arch/riscv/include/asm/Kbuild
@@ -2,10 +2,12 @@
 generic-y += early_ioremap.h
 generic-y += flat.h
 generic-y += kvm_para.h
+generic-y += mcs_spinlock.h
 generic-y += parport.h
-generic-y += spinlock.h
 generic-y += spinlock_types.h
+generic-y += ticket_spinlock.h
 generic-y += qrwlock.h
 generic-y += qrwlock_types.h
+generic-y += qspinlock.h
 generic-y += user.h
 generic-y += vmlinux.lds.h
diff --git a/arch/riscv/include/asm/spinlock.h b/arch/riscv/include/asm/spinlock.h
new file mode 100644
index 000000000000..98a3da4b1056
--- /dev/null
+++ b/arch/riscv/include/asm/spinlock.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __ASM_RISCV_SPINLOCK_H
+#define __ASM_RISCV_SPINLOCK_H
+
+#ifdef CONFIG_QUEUED_SPINLOCKS
+#define _Q_PENDING_LOOPS	(1 << 9)
+#endif
+
+#ifdef CONFIG_QUEUED_SPINLOCKS
+#include <asm/qspinlock.h>
+#else
+#include <asm/ticket_spinlock.h>
+#endif
+
+#include <asm/qrwlock.h>
+
+#endif /* __ASM_RISCV_SPINLOCK_H */
-- 
2.40.1


