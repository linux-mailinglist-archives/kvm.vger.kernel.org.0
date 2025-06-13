Return-Path: <kvm+bounces-49398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EFF7AD8537
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 10:04:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4BA08188C5D1
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 08:03:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAB992727F7;
	Fri, 13 Jun 2025 08:02:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8F945948;
	Fri, 13 Jun 2025 08:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749801764; cv=none; b=c8tsUNiIu+6zV9BHenSlbRkVKG4qwodCTXTB6Jk0oG006/V/pHxRsZpn8xz2v5YuBbM1ks/rOqb7tc8FrZW4vGfAy/SuDdb5hpp+kV1Z0YDfEZZMfIM6jGyY2WfwrkBKwJGr7vCkuNtiF6zPcfAtGYE6Wf/Gor4YGQi8KdE88FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749801764; c=relaxed/simple;
	bh=aFt06c2yemkL9zrx3K8NAM4m13KMJWdAfxY1VSvf2GA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oZhIjppgjMQ3vUjqsRrIDYJumhcKLPRKDdp7Ul7HoX4OJCrOhTPB80ZKSMCLxziTPEBcJnlKE+5tw8HsNlYvXqT39cV+S9NxPnuZDh5IDhOAKSaO0ppkwLDmv/90q1yscOJThb9UYSKwpN74PV91gOhM6217w9HFojxn+f2a3uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from zq-Legion-Y7000.smartont.net (unknown [180.110.114.155])
	by APP-05 (Coremail) with SMTP id zQCowABHzAoM20tolHFJBg--.51063S2;
	Fri, 13 Jun 2025 16:02:20 +0800 (CST)
From: zhouquan@iscas.ac.cn
To: anup@brainfault.org,
	ajones@ventanamicro.com,
	atishp@atishpatra.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com
Cc: linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-perf-users@vger.kernel.org,
	Quan Zhou <zhouquan@iscas.ac.cn>
Subject: [PATCH] RISC-V: perf/kvm: Add reporting of interrupt events
Date: Fri, 13 Jun 2025 15:53:38 +0800
Message-Id: <9693132df4d0f857b8be3a75750c36b40213fcc0.1726211632.git.zhouquan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowABHzAoM20tolHFJBg--.51063S2
X-Coremail-Antispam: 1UD129KBjvJXoW3GrWrtF4xJrykCF1kZFyUGFg_yoWxCr48pw
	43CFZ2kr4FgrZrKa48GFnagF4xGFs3Xr1UGw1jgw409F4UAw1kJ3W7Wryrta4DWrZ5JrW8
	Cr1DCrWY9w1Yqr7anT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9E14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Cr0_Gr1UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lw4CEc2x0rVAKj4xxMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI4
	8JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xv
	wVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjx
	v20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20E
	Y4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267
	AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VU1aFAJUUUUU==
X-CM-SenderInfo: 52kr31xxdqqxpvfd2hldfou0/1tbiBwoMBmhLsDui7AAAsh

From: Quan Zhou <zhouquan@iscas.ac.cn>

For `perf kvm stat` on the RISC-V, in order to avoid the
occurrence of `UNKNOWN` event names, interrupts should be
reported in addition to exceptions.

testing without patch:
---
Event name                    Samples  Sample%       Time(ns)
---------------------------  --------  --------  ------------
STORE_GUEST_PAGE_FAULT   	  1496461   53.00%    889612544
UNKNOWN                        887514   31.00%    272857968
LOAD_GUEST_PAGE_FAULT          305164   10.00%    189186331
VIRTUAL_INST_FAULT              70625    2.00%    134114260
SUPERVISOR_SYSCALL              32014    1.00%     58577110
INST_GUEST_PAGE_FAULT               1    0.00%         2545

testing with patch:
---
Event name                    Samples  Sample%       Time(ns)
---------------------------  --------  --------  ------------
IRQ_S_TIMER                   211271    58.00%  738298680600
EXC_STORE_GUEST_PAGE_FAULT    111279    30.00%  130725914800
EXC_LOAD_GUEST_PAGE_FAULT      22039     6.00%   25441480600
EXC_VIRTUAL_INST_FAULT          8913     2.00%   21015381600
IRQ_VS_EXT                      4748     1.00%   10155464300
IRQ_S_EXT                       2802     0.00%   13288775800
IRQ_S_SOFT                      1998     0.00%    4254129300

Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
---
 tools/perf/arch/riscv/util/kvm-stat.c         |  6 +-
 .../arch/riscv/util/riscv_exception_types.h   | 35 ------------
 tools/perf/arch/riscv/util/riscv_trap_types.h | 57 +++++++++++++++++++
 3 files changed, 60 insertions(+), 38 deletions(-)
 delete mode 100644 tools/perf/arch/riscv/util/riscv_exception_types.h
 create mode 100644 tools/perf/arch/riscv/util/riscv_trap_types.h

diff --git a/tools/perf/arch/riscv/util/kvm-stat.c b/tools/perf/arch/riscv/util/kvm-stat.c
index 491aef449d1a..3ea7acb5e159 100644
--- a/tools/perf/arch/riscv/util/kvm-stat.c
+++ b/tools/perf/arch/riscv/util/kvm-stat.c
@@ -9,10 +9,10 @@
 #include <memory.h>
 #include "../../../util/evsel.h"
 #include "../../../util/kvm-stat.h"
-#include "riscv_exception_types.h"
+#include "riscv_trap_types.h"
 #include "debug.h"
 
-define_exit_reasons_table(riscv_exit_reasons, kvm_riscv_exception_class);
+define_exit_reasons_table(riscv_exit_reasons, kvm_riscv_trap_class);
 
 const char *vcpu_id_str = "id";
 const char *kvm_exit_reason = "scause";
@@ -30,7 +30,7 @@ static void event_get_key(struct evsel *evsel,
 			  struct event_key *key)
 {
 	key->info = 0;
-	key->key = evsel__intval(evsel, sample, kvm_exit_reason);
+	key->key = evsel__intval(evsel, sample, kvm_exit_reason) & ~CAUSE_IRQ_FLAG;
 	key->exit_reasons = riscv_exit_reasons;
 }
 
diff --git a/tools/perf/arch/riscv/util/riscv_exception_types.h b/tools/perf/arch/riscv/util/riscv_exception_types.h
deleted file mode 100644
index c49b8fa5e847..000000000000
--- a/tools/perf/arch/riscv/util/riscv_exception_types.h
+++ /dev/null
@@ -1,35 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#ifndef ARCH_PERF_RISCV_EXCEPTION_TYPES_H
-#define ARCH_PERF_RISCV_EXCEPTION_TYPES_H
-
-#define EXC_INST_MISALIGNED 0
-#define EXC_INST_ACCESS 1
-#define EXC_INST_ILLEGAL 2
-#define EXC_BREAKPOINT 3
-#define EXC_LOAD_MISALIGNED 4
-#define EXC_LOAD_ACCESS 5
-#define EXC_STORE_MISALIGNED 6
-#define EXC_STORE_ACCESS 7
-#define EXC_SYSCALL 8
-#define EXC_HYPERVISOR_SYSCALL 9
-#define EXC_SUPERVISOR_SYSCALL 10
-#define EXC_INST_PAGE_FAULT 12
-#define EXC_LOAD_PAGE_FAULT 13
-#define EXC_STORE_PAGE_FAULT 15
-#define EXC_INST_GUEST_PAGE_FAULT 20
-#define EXC_LOAD_GUEST_PAGE_FAULT 21
-#define EXC_VIRTUAL_INST_FAULT 22
-#define EXC_STORE_GUEST_PAGE_FAULT 23
-
-#define EXC(x) {EXC_##x, #x }
-
-#define kvm_riscv_exception_class                                         \
-	EXC(INST_MISALIGNED), EXC(INST_ACCESS), EXC(INST_ILLEGAL),         \
-	EXC(BREAKPOINT), EXC(LOAD_MISALIGNED), EXC(LOAD_ACCESS),           \
-	EXC(STORE_MISALIGNED), EXC(STORE_ACCESS), EXC(SYSCALL),            \
-	EXC(HYPERVISOR_SYSCALL), EXC(SUPERVISOR_SYSCALL),                  \
-	EXC(INST_PAGE_FAULT), EXC(LOAD_PAGE_FAULT), EXC(STORE_PAGE_FAULT), \
-	EXC(INST_GUEST_PAGE_FAULT), EXC(LOAD_GUEST_PAGE_FAULT),            \
-	EXC(VIRTUAL_INST_FAULT), EXC(STORE_GUEST_PAGE_FAULT)
-
-#endif /* ARCH_PERF_RISCV_EXCEPTION_TYPES_H */
diff --git a/tools/perf/arch/riscv/util/riscv_trap_types.h b/tools/perf/arch/riscv/util/riscv_trap_types.h
new file mode 100644
index 000000000000..854e9d95524d
--- /dev/null
+++ b/tools/perf/arch/riscv/util/riscv_trap_types.h
@@ -0,0 +1,57 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef ARCH_PERF_RISCV_TRAP_TYPES_H
+#define ARCH_PERF_RISCV_TRAP_TYPES_H
+
+/* Exception cause high bit - is an interrupt if set */
+#define CAUSE_IRQ_FLAG		(_AC(1, UL) << (__riscv_xlen - 1))
+
+/* Interrupt causes (minus the high bit) */
+#define IRQ_S_SOFT 1
+#define IRQ_VS_SOFT 2
+#define IRQ_M_SOFT 3
+#define IRQ_S_TIMER 5
+#define IRQ_VS_TIMER 6
+#define IRQ_M_TIMER 7
+#define IRQ_S_EXT 9
+#define IRQ_VS_EXT 10
+#define IRQ_M_EXT 11
+#define IRQ_S_GEXT 12
+#define IRQ_PMU_OVF 13
+
+/* Exception causes */
+#define EXC_INST_MISALIGNED 0
+#define EXC_INST_ACCESS 1
+#define EXC_INST_ILLEGAL 2
+#define EXC_BREAKPOINT 3
+#define EXC_LOAD_MISALIGNED 4
+#define EXC_LOAD_ACCESS 5
+#define EXC_STORE_MISALIGNED 6
+#define EXC_STORE_ACCESS 7
+#define EXC_SYSCALL 8
+#define EXC_HYPERVISOR_SYSCALL 9
+#define EXC_SUPERVISOR_SYSCALL 10
+#define EXC_INST_PAGE_FAULT 12
+#define EXC_LOAD_PAGE_FAULT 13
+#define EXC_STORE_PAGE_FAULT 15
+#define EXC_INST_GUEST_PAGE_FAULT 20
+#define EXC_LOAD_GUEST_PAGE_FAULT 21
+#define EXC_VIRTUAL_INST_FAULT 22
+#define EXC_STORE_GUEST_PAGE_FAULT 23
+
+#define TRAP(x) { x, #x }
+
+#define kvm_riscv_trap_class \
+	TRAP(IRQ_S_SOFT), TRAP(IRQ_VS_SOFT), TRAP(IRQ_M_SOFT), \
+	TRAP(IRQ_S_TIMER), TRAP(IRQ_VS_TIMER), TRAP(IRQ_M_TIMER), \
+	TRAP(IRQ_S_EXT), TRAP(IRQ_VS_EXT), TRAP(IRQ_M_EXT), \
+	TRAP(IRQ_S_GEXT), TRAP(IRQ_PMU_OVF), \
+	TRAP(EXC_INST_MISALIGNED), TRAP(EXC_INST_ACCESS), TRAP(EXC_INST_ILLEGAL), \
+	TRAP(EXC_BREAKPOINT), TRAP(EXC_LOAD_MISALIGNED), TRAP(EXC_LOAD_ACCESS), \
+	TRAP(EXC_STORE_MISALIGNED), TRAP(EXC_STORE_ACCESS), TRAP(EXC_SYSCALL), \
+	TRAP(EXC_HYPERVISOR_SYSCALL), TRAP(EXC_SUPERVISOR_SYSCALL), \
+	TRAP(EXC_INST_PAGE_FAULT), TRAP(EXC_LOAD_PAGE_FAULT), \
+	TRAP(EXC_STORE_PAGE_FAULT), TRAP(EXC_INST_GUEST_PAGE_FAULT), \
+	TRAP(EXC_LOAD_GUEST_PAGE_FAULT), TRAP(EXC_VIRTUAL_INST_FAULT), \
+	TRAP(EXC_STORE_GUEST_PAGE_FAULT)
+
+#endif /* ARCH_PERF_RISCV_TRAP_TYPES_H */

base-commit: da3ea35007d0af457a0afc87e84fddaebc4e0b63
-- 
2.34.1


