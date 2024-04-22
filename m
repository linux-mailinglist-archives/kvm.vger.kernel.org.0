Return-Path: <kvm+bounces-15467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D3608AC673
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 10:13:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D2C66B22131
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 08:13:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E8CD502AF;
	Mon, 22 Apr 2024 08:13:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zg8tmja5ljk3lje4ms43mwaa.icoremail.net (zg8tmja5ljk3lje4ms43mwaa.icoremail.net [209.97.181.73])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0A124CE1F;
	Mon, 22 Apr 2024 08:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.97.181.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713773601; cv=none; b=h3O15ncYZ/vV1nPoRlX+dYNle1qfUWlaibWn0nR9tSviXVocdo60wsb6j8eJKVy62OTCtI1dmdRyJp5XlUrhfw361jvtyP6hRPjEg1tcktUrCbj77BbFmPfUrW9Uue+FBhtNtQkSF4Ktvm3Qjvb/b+K02MsC3VCcJIl0Kfw4r7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713773601; c=relaxed/simple;
	bh=w/o+1Q0rJfAIZZklgThgjgdHbwjZVHrSEBxTWzDY6Ik=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=X4pWRLVSlrTHZytIUdgDSGDXoO7SpqijrSw5GZjC01/J32s2Cbgdda18J3935YMsbC/WRzQ/NSVj21BcwSyQngT0TprAGOquP2Wt2ooLnbzF7PsjSn3wFJP3Wbv4O9WLZxJLM8WB6e0niNhCMxhBAgrFqYGJJEpzE5E64U5502s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com; spf=pass smtp.mailfrom=eswincomputing.com; arc=none smtp.client-ip=209.97.181.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eswincomputing.com
Received: from localhost.localdomain (unknown [10.12.130.31])
	by app1 (Coremail) with SMTP id TAJkCgBH6OSeGyZmSBIIAA--.61881S5;
	Mon, 22 Apr 2024 16:11:13 +0800 (CST)
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
Subject: [PATCH v3 1/2] RISCV: KVM: add tracepoints for entry and exit events
Date: Mon, 22 Apr 2024 08:08:32 +0000
Message-Id: <20240422080833.8745-2-liangshenlin@eswincomputing.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240422080833.8745-1-liangshenlin@eswincomputing.com>
References: <20240422080833.8745-1-liangshenlin@eswincomputing.com>
X-CM-TRANSID:TAJkCgBH6OSeGyZmSBIIAA--.61881S5
X-Coremail-Antispam: 1UD129KBjvJXoWxXFW3CFWUur13Ar17tFW7XFb_yoW5Cr4rpF
	nruFn5W3y8JrW2k3yfZw1vgr45ZrZY9r42qr9rXrW5Ar4ktr1DJrsagrWUtr98Ary09a4S
	qFyFyFyDCw15Zw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPv14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY02Avz4vE-syl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2Iq
	xVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r
	4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY
	6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67
	AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuY
	vjfU8ZXoUUUUU
X-CM-SenderInfo: xold0whvkh0z1lq6v25zlqu0xpsx3x1qjou0bp/
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Like other architectures, RISCV KVM also needs to add these event
tracepoints to count the number of times kvm guest entry/exit.

Signed-off-by: Shenlin Liang <liangshenlin@eswincomputing.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
---
 arch/riscv/kvm/trace.h | 67 ++++++++++++++++++++++++++++++++++++++++++
 arch/riscv/kvm/vcpu.c  |  7 +++++
 2 files changed, 74 insertions(+)
 create mode 100644 arch/riscv/kvm/trace.h

diff --git a/arch/riscv/kvm/trace.h b/arch/riscv/kvm/trace.h
new file mode 100644
index 000000000000..3d54175d805c
--- /dev/null
+++ b/arch/riscv/kvm/trace.h
@@ -0,0 +1,67 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Tracepoints for RISC-V KVM
+ *
+ * Copyright 2024 Beijing ESWIN Computing Technology Co., Ltd.
+ *
+ */
+#if !defined(_TRACE_KVM_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_KVM_H
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
+	TP_printk("PC: 0x016%lx", __entry->pc)
+);
+
+TRACE_EVENT(kvm_exit,
+	TP_PROTO(struct kvm_cpu_trap *trap),
+	TP_ARGS(trap),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, sepc)
+		__field(unsigned long, scause)
+		__field(unsigned long, stval)
+		__field(unsigned long, htval)
+		__field(unsigned long, htinst)
+	),
+
+	TP_fast_assign(
+		__entry->sepc		= trap->sepc;
+		__entry->scause		= trap->scause;
+		__entry->stval		= trap->stval;
+		__entry->htval		= trap->htval;
+		__entry->htinst		= trap->htinst;
+	),
+
+	TP_printk("SEPC:0x%lx, SCAUSE:0x%lx, STVAL:0x%lx, HTVAL:0x%lx, HTINST:0x%lx",
+		__entry->sepc,
+		__entry->scause,
+		__entry->stval,
+		__entry->htval,
+		__entry->htinst)
+);
+
+#endif /* _TRACE_RSICV_KVM_H */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE trace
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index b5ca9f2e98ac..f4e27004ceb8 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -21,6 +21,9 @@
 #include <asm/cacheflush.h>
 #include <asm/kvm_vcpu_vector.h>
 
+#define CREATE_TRACE_POINTS
+#include "trace.h"
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
 
+		trace_kvm_exit(&trap);
+
 		preempt_enable();
 
 		kvm_vcpu_srcu_read_lock(vcpu);
-- 
2.37.2


