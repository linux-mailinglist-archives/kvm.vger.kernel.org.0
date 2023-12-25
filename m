Return-Path: <kvm+bounces-5219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E41481E0B3
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 14:04:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F7DF1C21B11
	for <lists+kvm@lfdr.de>; Mon, 25 Dec 2023 13:04:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99F2056444;
	Mon, 25 Dec 2023 13:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZXT427gL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3DA563A1;
	Mon, 25 Dec 2023 13:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AAF6C433C8;
	Mon, 25 Dec 2023 13:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703509209;
	bh=i65yVHqfrtHAC1FsA7TLUXKq1EbxyrbVpeWkIY/6CZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZXT427gLfM0kV/iENXlWjVpcKXK0E5GPLoxwWEpooytFCeCuovrQTk+WEIgGGqh8x
	 OVcRzDL5suoRiCiPeetOg8KyBDar+wBhy43mEk7KF/SRSXZH934lG2GtJMYoCIb9jH
	 SAHmgyMJU2N//OZz9IzHWLp636MlqCVlef05rQlPV+oUCR5yx2Gt5TmGInl/dz1UMS
	 HojV2YmK1LwPBV+CeHnBMRJ05fhaAIFvv4pdqhk5df6LPB8tVkem+dzeTJauVCpVtA
	 R9+J0rSMGhdFPGv9TnXgdY9BQ5wFjkEA4qKjcafts1hfy2NGomFhSzE3TevGXmHML/
	 AN51wnmcojLxw==
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
Subject: [PATCH V12 14/14] RISC-V: paravirt: pvqspinlock: Add trace point for pv_kick/wait
Date: Mon, 25 Dec 2023 07:58:47 -0500
Message-Id: <20231225125847.2778638-15-guoren@kernel.org>
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

Add trace point for pv_kick&wait, here is the output:

ls /sys/kernel/debug/tracing/events/paravirt/
 enable   filter   pv_kick  pv_wait

cat /sys/kernel/debug/tracing/trace
 entries-in-buffer/entries-written: 33927/33927   #P:12

                                _-----=> irqs-off/BH-disabled
                               / _----=> need-resched
                              | / _---=> hardirq/softirq
                              || / _--=> preempt-depth
                              ||| / _-=> migrate-disable
                              |||| /     delay
           TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
              | |         |   |||||     |         |
             sh-100     [001] d..2.    28.312294: pv_wait: cpu 1 out of wfi
         <idle>-0       [000] d.h4.    28.322030: pv_kick: cpu 0 kick target cpu 1
             sh-100     [001] d..2.    30.982631: pv_wait: cpu 1 out of wfi
         <idle>-0       [000] d.h4.    30.993289: pv_kick: cpu 0 kick target cpu 1
             sh-100     [002] d..2.    44.987573: pv_wait: cpu 2 out of wfi
         <idle>-0       [000] d.h4.    44.989000: pv_kick: cpu 0 kick target cpu 2
         <idle>-0       [003] d.s3.    51.593978: pv_kick: cpu 3 kick target cpu 4
      rcu_sched-15      [004] d..2.    51.595192: pv_wait: cpu 4 out of wfi
lock_torture_wr-115     [004] ...2.    52.656482: pv_kick: cpu 4 kick target cpu 2
lock_torture_wr-113     [002] d..2.    52.659146: pv_wait: cpu 2 out of wfi
lock_torture_wr-114     [008] d..2.    52.659507: pv_wait: cpu 8 out of wfi
lock_torture_wr-114     [008] d..2.    52.663503: pv_wait: cpu 8 out of wfi
lock_torture_wr-113     [002] ...2.    52.666128: pv_kick: cpu 2 kick target cpu 8
lock_torture_wr-114     [008] d..2.    52.667261: pv_wait: cpu 8 out of wfi
lock_torture_wr-114     [009] .n.2.    53.141515: pv_kick: cpu 9 kick target cpu 11
lock_torture_wr-113     [002] d..2.    53.143339: pv_wait: cpu 2 out of wfi
lock_torture_wr-116     [007] d..2.    53.143412: pv_wait: cpu 7 out of wfi
lock_torture_wr-118     [000] d..2.    53.143457: pv_wait: cpu 0 out of wfi
lock_torture_wr-115     [008] d..2.    53.143481: pv_wait: cpu 8 out of wfi
lock_torture_wr-117     [011] d..2.    53.143522: pv_wait: cpu 11 out of wfi
lock_torture_wr-117     [011] ...2.    53.143987: pv_kick: cpu 11 kick target cpu 8
lock_torture_wr-115     [008] ...2.    53.144269: pv_kick: cpu 8 kick target cpu 7

Reviewed-by: Leonardo Bras <leobras@redhat.com>
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
---
 arch/riscv/kernel/qspinlock_paravirt.c        |  8 +++
 .../kernel/trace_events_filter_paravirt.h     | 60 +++++++++++++++++++
 2 files changed, 68 insertions(+)
 create mode 100644 arch/riscv/kernel/trace_events_filter_paravirt.h

diff --git a/arch/riscv/kernel/qspinlock_paravirt.c b/arch/riscv/kernel/qspinlock_paravirt.c
index 4b04c93c4b9b..0e6d11357243 100644
--- a/arch/riscv/kernel/qspinlock_paravirt.c
+++ b/arch/riscv/kernel/qspinlock_paravirt.c
@@ -9,10 +9,16 @@
 #include <asm/qspinlock_paravirt.h>
 #include <asm/sbi.h>
 
+#define CREATE_TRACE_POINTS
+#include "trace_events_filter_paravirt.h"
+
 void pv_kick(int cpu)
 {
 	sbi_ecall(SBI_EXT_PVLOCK, SBI_EXT_PVLOCK_KICK_CPU,
 		  cpuid_to_hartid_map(cpu), 0, 0, 0, 0, 0);
+
+	trace_pv_kick(smp_processor_id(), cpu);
+
 	return;
 }
 
@@ -28,6 +34,8 @@ void pv_wait(u8 *ptr, u8 val)
 		goto out;
 
 	wait_for_interrupt();
+
+	trace_pv_wait(smp_processor_id());
 out:
 	local_irq_restore(flags);
 }
diff --git a/arch/riscv/kernel/trace_events_filter_paravirt.h b/arch/riscv/kernel/trace_events_filter_paravirt.h
new file mode 100644
index 000000000000..9ff5aa451b12
--- /dev/null
+++ b/arch/riscv/kernel/trace_events_filter_paravirt.h
@@ -0,0 +1,60 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c), 2023 Alibaba Cloud
+ * Authors:
+ *	Guo Ren <guoren@linux.alibaba.com>
+ */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM paravirt
+
+#if !defined(_TRACE_PARAVIRT_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_PARAVIRT_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(pv_kick,
+	TP_PROTO(int cpu, int target),
+	TP_ARGS(cpu, target),
+
+	TP_STRUCT__entry(
+		__field(int, cpu)
+		__field(int, target)
+	),
+
+	TP_fast_assign(
+		__entry->cpu = cpu;
+		__entry->target = target;
+	),
+
+	TP_printk("cpu %d kick target cpu %d",
+		__entry->cpu,
+		__entry->target
+	)
+);
+
+TRACE_EVENT(pv_wait,
+	TP_PROTO(int cpu),
+	TP_ARGS(cpu),
+
+	TP_STRUCT__entry(
+		__field(int, cpu)
+	),
+
+	TP_fast_assign(
+		__entry->cpu = cpu;
+	),
+
+	TP_printk("cpu %d out of wfi",
+		__entry->cpu
+	)
+);
+
+#endif /* _TRACE_PARAVIRT_H || TRACE_HEADER_MULTI_READ */
+
+#undef TRACE_INCLUDE_PATH
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_PATH ../../../arch/riscv/kernel/
+#define TRACE_INCLUDE_FILE trace_events_filter_paravirt
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
2.40.1


