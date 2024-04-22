Return-Path: <kvm+bounces-15466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 235B08AC670
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 10:13:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8ED6E1F21687
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 08:13:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9219C50241;
	Mon, 22 Apr 2024 08:13:21 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [20.231.56.155])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E972A48CF2;
	Mon, 22 Apr 2024 08:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=20.231.56.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713773601; cv=none; b=sYa37qukEJpuGIrXyt+PWFL1eK47PLEr2skw264CanO4BHRCPRIOGXMGD2mw5CRzsC5BDJhoB3lnYY0utXBDHXlm1JeqZDYMUFpC/3bw+rPUo81sQOK/iST5V9nsqm/0x5ohDAQWnArAFguY10HSZSkSpUMQsHSRdghDjFDWsMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713773601; c=relaxed/simple;
	bh=D11aR4qjQ/yu8clsey/FaiMV5oRaZzQwh1LzxDxIr/k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=i3Zqi6PiNdgsnD+8oMzLUxPWQXLe4DOMmWKXV1ZHFIu0i+fZOMODw2SPENjQgFpgXXu5JCDxzSeuO0o5B5lvGTz3jM5pN9+5lMWjMxFwUwuir3hPjLJQSwN/h9M2rZy/NGWRR/RaBbzbOBYecJa7XCe1TTeRGhjn7A5yUF6peGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com; spf=pass smtp.mailfrom=eswincomputing.com; arc=none smtp.client-ip=20.231.56.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=eswincomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eswincomputing.com
Received: from localhost.localdomain (unknown [10.12.130.31])
	by app1 (Coremail) with SMTP id TAJkCgBH6OSeGyZmSBIIAA--.61881S6;
	Mon, 22 Apr 2024 16:11:14 +0800 (CST)
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
Subject: [PATCH v3 2/2] perf kvm/riscv: Port perf kvm stat to RISC-V
Date: Mon, 22 Apr 2024 08:08:33 +0000
Message-Id: <20240422080833.8745-3-liangshenlin@eswincomputing.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240422080833.8745-1-liangshenlin@eswincomputing.com>
References: <20240422080833.8745-1-liangshenlin@eswincomputing.com>
X-CM-TRANSID:TAJkCgBH6OSeGyZmSBIIAA--.61881S6
X-Coremail-Antispam: 1UD129KBjvJXoW3AFW7tFWrZw48ur4kWrW3KFg_yoW7Cr1Dpa
	n7CF90kw4rK39xu34fCFs2gF4fGws3WFy5K340grWjvF42y3y8J3WIgF90kF9rXr4kJrW8
	A3W5WrWvk34rJaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPm14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY02Avz4vE-syl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2Iq
	xVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r
	4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY
	6xkF7I0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aV
	AFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZE
	Xa7VUbdOz7UUUUU==
X-CM-SenderInfo: xold0whvkh0z1lq6v25zlqu0xpsx3x1qjou0bp/
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

'perf kvm stat report/record' generates a statistical analysis of KVM
events and can be used to analyze guest exit reasons.

"report" reports statistical analysis of guest exit events.

To record kvm events on the host:
 # perf kvm stat record -a

To report kvm VM EXIT events:
 # perf kvm stat report --event=vmexit

Signed-off-by: Shenlin Liang <liangshenlin@eswincomputing.com>
---
 tools/perf/arch/riscv/Makefile                |  1 +
 tools/perf/arch/riscv/util/Build              |  1 +
 tools/perf/arch/riscv/util/kvm-stat.c         | 79 +++++++++++++++++++
 .../arch/riscv/util/riscv_exception_types.h   | 35 ++++++++
 4 files changed, 116 insertions(+)
 create mode 100644 tools/perf/arch/riscv/util/kvm-stat.c
 create mode 100644 tools/perf/arch/riscv/util/riscv_exception_types.h

diff --git a/tools/perf/arch/riscv/Makefile b/tools/perf/arch/riscv/Makefile
index a8d25d005207..e1e445615536 100644
--- a/tools/perf/arch/riscv/Makefile
+++ b/tools/perf/arch/riscv/Makefile
@@ -3,3 +3,4 @@ PERF_HAVE_DWARF_REGS := 1
 endif
 PERF_HAVE_ARCH_REGS_QUERY_REGISTER_OFFSET := 1
 PERF_HAVE_JITDUMP := 1
+HAVE_KVM_STAT_SUPPORT := 1
\ No newline at end of file
diff --git a/tools/perf/arch/riscv/util/Build b/tools/perf/arch/riscv/util/Build
index 603dbb5ae4dc..d72b04f8d32b 100644
--- a/tools/perf/arch/riscv/util/Build
+++ b/tools/perf/arch/riscv/util/Build
@@ -1,5 +1,6 @@
 perf-y += perf_regs.o
 perf-y += header.o
 
+perf-$(CONFIG_LIBTRACEEVENT) += kvm-stat.o
 perf-$(CONFIG_DWARF) += dwarf-regs.o
 perf-$(CONFIG_LIBDW_DWARF_UNWIND) += unwind-libdw.o
diff --git a/tools/perf/arch/riscv/util/kvm-stat.c b/tools/perf/arch/riscv/util/kvm-stat.c
new file mode 100644
index 000000000000..58813049fc45
--- /dev/null
+++ b/tools/perf/arch/riscv/util/kvm-stat.c
@@ -0,0 +1,79 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Arch specific functions for perf kvm stat.
+ *
+ * Copyright 2024 Beijing ESWIN Computing Technology Co., Ltd.
+ *
+ */
+#include <errno.h>
+#include <memory.h>
+#include "../../../util/evsel.h"
+#include "../../../util/kvm-stat.h"
+#include "riscv_exception_types.h"
+#include "debug.h"
+
+define_exit_reasons_table(riscv_exit_reasons, kvm_riscv_exception_class);
+
+const char *vcpu_id_str = "id";
+const char *kvm_exit_reason = "scause";
+const char *kvm_entry_trace = "kvm:kvm_entry";
+const char *kvm_exit_trace = "kvm:kvm_exit";
+
+const char *kvm_events_tp[] = {
+	"kvm:kvm_entry",
+	"kvm:kvm_exit",
+	NULL,
+};
+
+static void event_get_key(struct evsel *evsel,
+			  struct perf_sample *sample,
+			  struct event_key *key)
+{
+	key->info = 0;
+	key->key = evsel__intval(evsel, sample, kvm_exit_reason);
+	key->key = (int)key->key;
+	key->exit_reasons = riscv_exit_reasons;
+}
+
+static bool event_begin(struct evsel *evsel,
+			struct perf_sample *sample __maybe_unused,
+			struct event_key *key __maybe_unused)
+{
+	return evsel__name_is(evsel, kvm_entry_trace);
+}
+
+static bool event_end(struct evsel *evsel,
+		      struct perf_sample *sample,
+		      struct event_key *key)
+{
+	if (evsel__name_is(evsel, kvm_exit_trace)) {
+		event_get_key(evsel, sample, key);
+		return true;
+	}
+	return false;
+}
+
+static struct kvm_events_ops exit_events = {
+	.is_begin_event = event_begin,
+	.is_end_event	= event_end,
+	.decode_key	= exit_event_decode_key,
+	.name		= "VM-EXIT"
+};
+
+struct kvm_reg_events_ops kvm_reg_events_ops[] = {
+	{
+		.name	= "vmexit",
+		.ops	= &exit_events,
+	},
+	{ NULL, NULL },
+};
+
+const char * const kvm_skip_events[] = {
+	NULL,
+};
+
+int cpu_isa_init(struct perf_kvm_stat *kvm, const char *cpuid __maybe_unused)
+{
+	kvm->exit_reasons_isa = "riscv64";
+	return 0;
+}
diff --git a/tools/perf/arch/riscv/util/riscv_exception_types.h b/tools/perf/arch/riscv/util/riscv_exception_types.h
new file mode 100644
index 000000000000..c49b8fa5e847
--- /dev/null
+++ b/tools/perf/arch/riscv/util/riscv_exception_types.h
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef ARCH_PERF_RISCV_EXCEPTION_TYPES_H
+#define ARCH_PERF_RISCV_EXCEPTION_TYPES_H
+
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
+#define EXC(x) {EXC_##x, #x }
+
+#define kvm_riscv_exception_class                                         \
+	EXC(INST_MISALIGNED), EXC(INST_ACCESS), EXC(INST_ILLEGAL),         \
+	EXC(BREAKPOINT), EXC(LOAD_MISALIGNED), EXC(LOAD_ACCESS),           \
+	EXC(STORE_MISALIGNED), EXC(STORE_ACCESS), EXC(SYSCALL),            \
+	EXC(HYPERVISOR_SYSCALL), EXC(SUPERVISOR_SYSCALL),                  \
+	EXC(INST_PAGE_FAULT), EXC(LOAD_PAGE_FAULT), EXC(STORE_PAGE_FAULT), \
+	EXC(INST_GUEST_PAGE_FAULT), EXC(LOAD_GUEST_PAGE_FAULT),            \
+	EXC(VIRTUAL_INST_FAULT), EXC(STORE_GUEST_PAGE_FAULT)
+
+#endif /* ARCH_PERF_RISCV_EXCEPTION_TYPES_H */
-- 
2.37.2


