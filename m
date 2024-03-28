Return-Path: <kvm+bounces-12950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8267188F5DD
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 04:20:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 371CA2A3B9C
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 03:20:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 513A2364A5;
	Thu, 28 Mar 2024 03:20:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zg8tmja5ljk3lje4ms43mwaa.icoremail.net (zg8tmja5ljk3lje4ms43mwaa.icoremail.net [209.97.181.73])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DF821C680;
	Thu, 28 Mar 2024 03:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.97.181.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711596026; cv=none; b=QLZNggBduo85VkQ6WN43/yNEWa+MjbJz4ODHvcaoXILKsv72l9TgmqOuw97/suGse7bdaCb+ISh+cxCrxn1QaY1uJjjhyeRhWtFpk5gaYTw8DGfS65nB3DOvQ25t/NAmyHToy0eyFfVhDO5XBy+0KOO8VveNydU/s59+jCdQUFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711596026; c=relaxed/simple;
	bh=lK/aYNgNeC3tGBp/BVxjGcGiyPKFhFWCXSbJr7n/9Mc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=aoicRmz3ujElWe2BS7z4BlAwGZ7i1sk1AYaU84y0lnhX9jzmeKJ25u8Yj/mBzR5t/1b4dawvq40wkN9fwFrLXE1vhF3wTay99ANZdXllzx2S0mzGWEuNEcAJjCL8FeZqu8hUxhRD9AUcoUbL2k5vE/yuUBWAmz4CPzpQJ3QOzfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com; spf=pass smtp.mailfrom=eswincomputing.com; arc=none smtp.client-ip=209.97.181.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eswincomputing.com
Received: from localhost.localdomain (unknown [10.12.130.31])
	by app1 (Coremail) with SMTP id TAJkCgDniOWq4QRmwD8DAA--.28501S5;
	Thu, 28 Mar 2024 11:19:09 +0800 (CST)
From: Shenlin Liang <liangshenlin@eswincomputing.com>
To: anup@brainfault.org,
	atishp@atishpatra.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	peterz@infradead.org,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com,
	jolsa@kernel.org,
	irogers@google.com,
	adrian.hunter@intel.com,
	linux-perf-users@vger.kernel.org
Cc: Shenlin Liang <liangshenlin@eswincomputing.com>
Subject: [PATCH 1/2] RISCV: KVM: add tracepoints for entry and exit events
Date: Thu, 28 Mar 2024 03:12:19 +0000
Message-Id: <20240328031220.1287-2-liangshenlin@eswincomputing.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240328031220.1287-1-liangshenlin@eswincomputing.com>
References: <20240328031220.1287-1-liangshenlin@eswincomputing.com>
X-CM-TRANSID:TAJkCgDniOWq4QRmwD8DAA--.28501S5
X-Coremail-Antispam: 1UD129KBjvJXoWxXFWfJF15Cry5AFy7uw1xKrg_yoW5AFyrpF
	1Dur98W3yrJrW7C34fZwnYgr45Zr9Y9r17try7WrW5Jr4vyF1kJrsagFWDtry5Ary09a4S
	vF95WFyqk3W5XaUanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUml14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY02Avz4vE-syl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxY
	O2xFxVAFwI0_Jw0_GFylx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGV
	WUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_
	JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rV
	WUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4U
	JbIYCTnIWIevJa73UjIFyTuYvjfUbpnQUUUUU
X-CM-SenderInfo: xold0whvkh0z1lq6v25zlqu0xpsx3x1qjou0bp/
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Like other architectures, RISCV KVM also needs to add these event
tracepoints to count the number of times kvm guest entry/exit.

Signed-off-by: Shenlin Liang <liangshenlin@eswincomputing.com>
---
 arch/riscv/kvm/trace_riscv.h | 60 ++++++++++++++++++++++++++++++++++++
 arch/riscv/kvm/vcpu.c        |  7 +++++
 2 files changed, 67 insertions(+)
 create mode 100644 arch/riscv/kvm/trace_riscv.h

diff --git a/arch/riscv/kvm/trace_riscv.h b/arch/riscv/kvm/trace_riscv.h
new file mode 100644
index 000000000000..5848083c7a5e
--- /dev/null
+++ b/arch/riscv/kvm/trace_riscv.h
@@ -0,0 +1,60 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Tracepoints for RISC-V KVM
+ *
+ * Copyright 2024 Beijing ESWIN Computing Technology Co., Ltd.
+ *
+ */
+#if !defined(_TRACE_RSICV_KVM_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_RSICV_KVM_H
+
+#include <linux/tracepoint.h>
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM kvm
+
+TRACE_EVENT(kvm_entry,
+	TP_PROTO(struct kvm_vcpu *vcpu),
+	TP_ARGS(vcpu),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, pc)
+	),
+
+	TP_fast_assign(
+		__entry->pc	= vcpu->arch.guest_context.sepc;
+	),
+
+	TP_printk("PC: 0x%016lx", __entry->pc)
+);
+
+TRACE_EVENT(kvm_exit,
+	TP_PROTO(struct kvm_vcpu *vcpu, unsigned long exit_reason,
+			unsigned long scause),
+	TP_ARGS(vcpu, exit_reason, scause),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, pc)
+		__field(unsigned long, exit_reason)
+		__field(unsigned long, scause)
+	),
+
+	TP_fast_assign(
+		__entry->pc		= vcpu->arch.guest_context.sepc;
+		__entry->exit_reason	= exit_reason;
+		__entry->scause		= scause;
+	),
+
+	TP_printk("EXIT_REASON:0x%lx,PC: 0x%016lx,SCAUSE:0x%lx",
+			__entry->exit_reason, __entry->pc, __entry->scause)
+);
+
+#endif /* _TRACE_RSICV_KVM_H */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE trace_riscv
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index b5ca9f2e98ac..ed0932f0d514 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -21,6 +21,9 @@
 #include <asm/cacheflush.h>
 #include <asm/kvm_vcpu_vector.h>
 
+#define CREATE_TRACE_POINTS
+#include "trace_riscv.h"
+
 const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	KVM_GENERIC_VCPU_STATS(),
 	STATS_DESC_COUNTER(VCPU, ecall_exit_stat),
@@ -782,6 +785,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 */
 		kvm_riscv_local_tlb_sanitize(vcpu);
 
+		trace_kvm_entry(vcpu);
+
 		guest_timing_enter_irqoff();
 
 		kvm_riscv_vcpu_enter_exit(vcpu);
@@ -820,6 +825,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		local_irq_enable();
 
+		trace_kvm_exit(vcpu, run->exit_reason, trap.scause);
+
 		preempt_enable();
 
 		kvm_vcpu_srcu_read_lock(vcpu);
-- 
2.37.2


