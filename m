Return-Path: <kvm+bounces-7168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BC5683DBC8
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 15:26:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9EB221F25691
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 14:26:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DDCA1F606;
	Fri, 26 Jan 2024 14:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cSf6sJNB"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4361EB27
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 14:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706279069; cv=none; b=poWLjkdGqJB/Ipo3EQiKsTpqPZgkSeb9uUnBkgwoR3z6vV0b6nCaCOv+UrSHk6dDqz+ZEAMmhqVXaImSoNOtCTEaMR8X69rtN7NpJBOy0LbWQKVWtUVEG4RkG141JaeDNwrkLwSsGKC2QIKLBfUPP7/jTCpyjDEue/7QjQLZEJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706279069; c=relaxed/simple;
	bh=vSlJ7Ct1DAGV8YQbegg4W2ipKGldsefQuf1ja8MugpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=AN5X9QBGGtSQzXaQ9Pj5eQ1MQi4W5Bl8dTguUCtSgq+938wZjgjlb5F8LW9nWWbXX7LsQJ8jQpRAgo4ecPDMn6hIHJ7TmxMuQFnf3ONLqU0w+vWXQxWgNA8EUn0G9gT3xfqST2U+ITvcquEnjisRRYirTECIhPIoWjirdva/Vhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cSf6sJNB; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706279066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=utoylgPTkJdXuAHqdAXp52bAVwYjYgFvheHgylCUS70=;
	b=cSf6sJNBlayx+5i2UKKh1cEpVGX+R+gFpPJ2dZS5nc9/HxbtsexmA3uuf0rhQeCD8zIcsd
	93qd8WWpCXehoaD5bimLsW7PD+pf9wX19WlLObsghwGOMg0FdXeYcatPaORBT75UN9R7ly
	S6A3rn9+cgyc9KM9PiAeOTRsIyKulyA=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com,
	anup@brainfault.org,
	atishp@atishpatra.org,
	pbonzini@redhat.com,
	thuth@redhat.com,
	alexandru.elisei@arm.com,
	eric.auger@redhat.com
Subject: [kvm-unit-tests PATCH v2 22/24] riscv: Add isa string parsing
Date: Fri, 26 Jan 2024 15:23:47 +0100
Message-ID: <20240126142324.66674-48-andrew.jones@linux.dev>
In-Reply-To: <20240126142324.66674-26-andrew.jones@linux.dev>
References: <20240126142324.66674-26-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We can probably get away with just assuming several important
and popular extensions (at least everything covered by G), but
we'll also want to use some extensions which we should ensure
are present by parsing the isa string. Add a parser and already
apply it to Sstc.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
Acked-by: Thomas Huth <thuth@redhat.com>
---
 lib/riscv/asm/isa.h       |  33 ++++++++++
 lib/riscv/asm/processor.h |   1 +
 lib/riscv/isa.c           | 126 ++++++++++++++++++++++++++++++++++++++
 lib/riscv/processor.c     |   2 +
 riscv/Makefile            |   1 +
 5 files changed, 163 insertions(+)
 create mode 100644 lib/riscv/asm/isa.h
 create mode 100644 lib/riscv/isa.c

diff --git a/lib/riscv/asm/isa.h b/lib/riscv/asm/isa.h
new file mode 100644
index 000000000000..df874173f4ed
--- /dev/null
+++ b/lib/riscv/asm/isa.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASMRISCV_ISA_H_
+#define _ASMRISCV_ISA_H_
+#include <bitops.h>
+#include <asm/setup.h>
+
+/*
+ * We assume and use several extensions, such as Zicsr and Zifencei.
+ * Here we only track extensions which we don't assume and the
+ * framework may want to use. Unit tests may check for extensions
+ * by name not tracked here with cpu_has_extension_name()
+ */
+enum {
+	ISA_SSTC,
+	ISA_MAX,
+};
+_Static_assert(ISA_MAX <= __riscv_xlen, "Need to increase thread_info.isa");
+
+static inline bool cpu_has_extension(int cpu, int ext)
+{
+	return test_bit(ext, cpus[cpu].isa);
+}
+
+bool cpu_has_extension_name(int cpu, const char *ext);
+
+static inline bool has_ext(const char *ext)
+{
+	return cpu_has_extension_name(current_thread_info()->cpu, ext);
+}
+
+void isa_init(struct thread_info *info);
+
+#endif /* _ASMRISCV_ISA_H_ */
diff --git a/lib/riscv/asm/processor.h b/lib/riscv/asm/processor.h
index f20774d02d8e..32c499d0c0ab 100644
--- a/lib/riscv/asm/processor.h
+++ b/lib/riscv/asm/processor.h
@@ -11,6 +11,7 @@ typedef void (*exception_fn)(struct pt_regs *);
 struct thread_info {
 	int cpu;
 	unsigned long hartid;
+	unsigned long isa[1];
 	exception_fn exception_handlers[EXCEPTION_CAUSE_MAX];
 };
 
diff --git a/lib/riscv/isa.c b/lib/riscv/isa.c
new file mode 100644
index 000000000000..bc1c9c72045c
--- /dev/null
+++ b/lib/riscv/isa.c
@@ -0,0 +1,126 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2023, Ventana Micro Systems Inc., Andrew Jones <ajones@ventanamicro.com>
+ */
+#include <libcflat.h>
+#include <bitops.h>
+#include <devicetree.h>
+#include <string.h>
+#include <asm/isa.h>
+#include <asm/setup.h>
+
+typedef void (*isa_func_t)(const char *, int, void *);
+
+struct isa_info {
+	unsigned long hartid;
+	isa_func_t func;
+	void *data;
+};
+
+static bool isa_match(const char *ext, const char *name, int len)
+{
+	return len == strlen(ext) && !strncasecmp(name, ext, len);
+}
+
+struct isa_check {
+	const char *ext;
+	bool found;
+};
+
+static void isa_name(const char *name, int len, void *data)
+{
+	struct isa_check *check = (struct isa_check *)data;
+
+	if (isa_match(check->ext, name, len))
+		check->found = true;
+}
+
+static void isa_bit(const char *name, int len, void *data)
+{
+	struct thread_info *info = (struct thread_info *)data;
+
+	if (isa_match("sstc", name, len))
+		set_bit(ISA_SSTC, info->isa);
+}
+
+static void isa_parse(const char *isa_string, int len, struct isa_info *info)
+{
+	assert(isa_string[0] == 'r' && isa_string[1] == 'v');
+#if __riscv_xlen == 32
+	assert(isa_string[2] == '3' && isa_string[3] == '2');
+#else
+	assert(isa_string[2] == '6' && isa_string[3] == '4');
+#endif
+
+	for (int i = 4; i < len; ++i) {
+		if (isa_string[i] == '_') {
+			const char *multi = &isa_string[++i];
+			int start = i;
+
+			while (i < len - 1 && isa_string[i] != '_')
+				++i;
+			info->func(multi, i - start, info->data);
+			if (i < len - 1)
+				--i;
+		} else {
+			info->func(&isa_string[i], 1, info->data);
+		}
+	}
+}
+
+static void isa_parse_fdt(int cpu_node, u64 hartid, void *data)
+{
+	struct isa_info *info = (struct isa_info *)data;
+	const struct fdt_property *prop;
+	int len;
+
+	if (hartid != info->hartid)
+		return;
+
+	prop = fdt_get_property(dt_fdt(), cpu_node, "riscv,isa", &len);
+	assert(prop);
+
+	isa_parse(prop->data, len, info);
+}
+
+static void isa_init_acpi(void)
+{
+	assert_msg(false, "ACPI not available");
+}
+
+void isa_init(struct thread_info *ti)
+{
+	struct isa_info info = {
+		.hartid = ti->hartid,
+		.func = isa_bit,
+		.data = ti,
+	};
+	int ret;
+
+	if (dt_available()) {
+		ret = dt_for_each_cpu_node(isa_parse_fdt, &info);
+		assert(ret == 0);
+	} else {
+		isa_init_acpi();
+	}
+}
+
+bool cpu_has_extension_name(int cpu, const char *ext)
+{
+	struct isa_info info = {
+		.hartid = cpus[cpu].hartid,
+		.func = isa_name,
+		.data = &(struct isa_check){ .ext = ext, },
+	};
+	struct isa_check *check = info.data;
+	int ret;
+
+	if (dt_available()) {
+		ret = dt_for_each_cpu_node(isa_parse_fdt, &info);
+		assert(ret == 0);
+	} else {
+		assert_msg(false, "ACPI not available");
+	}
+
+	return check->found;
+}
diff --git a/lib/riscv/processor.c b/lib/riscv/processor.c
index 2bfbd4e9b274..e0904209c0da 100644
--- a/lib/riscv/processor.c
+++ b/lib/riscv/processor.c
@@ -4,6 +4,7 @@
  */
 #include <libcflat.h>
 #include <asm/csr.h>
+#include <asm/isa.h>
 #include <asm/processor.h>
 #include <asm/setup.h>
 
@@ -58,5 +59,6 @@ void thread_info_init(void)
 	unsigned long hartid = csr_read(CSR_SSCRATCH);
 	int cpu = hartid_to_cpu(hartid);
 
+	isa_init(&cpus[cpu]);
 	csr_write(CSR_SSCRATCH, &cpus[cpu]);
 }
diff --git a/riscv/Makefile b/riscv/Makefile
index 61a1ff88d8ec..b51d9edfb792 100644
--- a/riscv/Makefile
+++ b/riscv/Makefile
@@ -30,6 +30,7 @@ cflatobjs += lib/on-cpus.o
 cflatobjs += lib/vmalloc.o
 cflatobjs += lib/riscv/bitops.o
 cflatobjs += lib/riscv/io.o
+cflatobjs += lib/riscv/isa.o
 cflatobjs += lib/riscv/mmu.o
 cflatobjs += lib/riscv/processor.o
 cflatobjs += lib/riscv/sbi.o
-- 
2.43.0


