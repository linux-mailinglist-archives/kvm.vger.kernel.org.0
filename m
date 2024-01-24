Return-Path: <kvm+bounces-6801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A827683A2C3
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 08:21:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DBDEA1C27911
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 07:20:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D266917BCA;
	Wed, 24 Jan 2024 07:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Y01JgCM9"
X-Original-To: kvm@vger.kernel.org
Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFE717BAC
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 07:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706080756; cv=none; b=Aeo0+IBgshNCaQ61NFM6p0BLaZQtNbA2mwfmUA0Vp2Y4R7T50G2H4Kit8uJhDnZNd+r+saGpdl6d4WvnswDWNdgy6MwDAM1CAYdFMTt6NMqriRnHmq7SHfnQmVXFrAHJGtUC2u7BaTgkUQdkedvm7RNiLPu7Rc02L7vkiNCBoc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706080756; c=relaxed/simple;
	bh=QFyiEo3+TiEr0Bo6kHfuZQiEYBr1486gm2YVkV7b49c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=ulkyKh2FmeQaiDZhP40jmJg2zSfREHAHR0kvnlhD9Y9xvNXdX24HJpongazI/ood3lIiZwn7qx0AgIjff57eT0Fzc2Dh5ZX1vlYuBm6oCuSTgLbwINyWLlETRvb1jdJyjUq0mKaLYuOxWCVFAZCWsb8QRDgJscvxREbzXzBixoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Y01JgCM9; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706080752;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=janxYoPaAcabShJw0sBS+m8iKX71ECiHDtuIEwA1P4c=;
	b=Y01JgCM9e13dqfTGCQ5Lf368ONvbbXU2Qs9gCcyotklBuT/ZIeClY1hxcGrzjdJtHjXZO1
	clv7XPsT9GJZG3TdvHDr2pVJ5+WxDjLR4yelfUAnojbPjKfcTLc7khBUVe6WZqPc8y4fbH
	U31SoKqQ1GqDF6PEfgAITeJbGVTqKYg=
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
Subject: [kvm-unit-tests PATCH 22/24] riscv: Add isa string parsing
Date: Wed, 24 Jan 2024 08:18:38 +0100
Message-ID: <20240124071815.6898-48-andrew.jones@linux.dev>
In-Reply-To: <20240124071815.6898-26-andrew.jones@linux.dev>
References: <20240124071815.6898-26-andrew.jones@linux.dev>
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
---
 lib/riscv/asm/isa.h       | 18 +++++++++
 lib/riscv/asm/processor.h |  1 +
 lib/riscv/processor.c     | 84 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 103 insertions(+)
 create mode 100644 lib/riscv/asm/isa.h

diff --git a/lib/riscv/asm/isa.h b/lib/riscv/asm/isa.h
new file mode 100644
index 000000000000..4cb467b77077
--- /dev/null
+++ b/lib/riscv/asm/isa.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASMRISCV_ISA_H_
+#define _ASMRISCV_ISA_H_
+#include <bitops.h>
+#include <asm/setup.h>
+
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
+#endif /* _ASMRISCV_ISA_H_ */
diff --git a/lib/riscv/asm/processor.h b/lib/riscv/asm/processor.h
index d8b7018c9102..928a988b471a 100644
--- a/lib/riscv/asm/processor.h
+++ b/lib/riscv/asm/processor.h
@@ -11,6 +11,7 @@ typedef void (*exception_fn)(struct pt_regs *);
 struct thread_info {
 	int cpu;
 	unsigned long hartid;
+	unsigned long isa[1];
 	exception_fn exception_handlers[EXCEPTION_CAUSE_MAX];
 };
 
diff --git a/lib/riscv/processor.c b/lib/riscv/processor.c
index 7248cf4c5ca6..02ac35890ded 100644
--- a/lib/riscv/processor.c
+++ b/lib/riscv/processor.c
@@ -3,7 +3,11 @@
  * Copyright (C) 2023, Ventana Micro Systems Inc., Andrew Jones <ajones@ventanamicro.com>
  */
 #include <libcflat.h>
+#include <bitops.h>
+#include <devicetree.h>
+#include <string.h>
 #include <asm/csr.h>
+#include <asm/isa.h>
 #include <asm/processor.h>
 #include <asm/setup.h>
 
@@ -53,10 +57,90 @@ void install_exception_handler(unsigned long cause, void (*handler)(struct pt_re
 	info->exception_handlers[cause] = handler;
 }
 
+static int isa_bit(const char *name, int len)
+{
+	/*
+	 * We assume and use several extensions, such as Zicsr and Zifencei.
+	 * Here we only look for extensions which we don't assume and still
+	 * may want to use.
+	 */
+#define ISA_CMP(name, len, ext) \
+	((len) == sizeof(ext) - 1 && !strncasecmp(name, ext, len))
+
+	if (ISA_CMP(name, len, "sstc"))
+		return ISA_SSTC;
+
+#undef ISA_CMP
+	return ISA_MAX;
+}
+
+static void isa_parse(unsigned long *isa, const char *isa_string, int len)
+{
+	assert(isa_string[0] == 'r' && isa_string[1] == 'v');
+#if __riscv_xlen == 32
+	assert(isa_string[2] == '3' && isa_string[3] == '2');
+#else
+	assert(isa_string[2] == '6' && isa_string[3] == '4');
+#endif
+
+	for (int i = 4; i < len; ++i) {
+		int nr;
+
+		if (isa_string[i] == '_') {
+			const char *multi = &isa_string[++i];
+			int start = i;
+
+			while (i < len && isa_string[i] != '_')
+				++i;
+			nr = isa_bit(multi, i - start);
+			if (i < len)
+				--i;
+		} else {
+			nr = isa_bit(&isa_string[i], 1);
+		}
+
+		if (nr < ISA_MAX)
+			set_bit(nr, isa);
+	}
+}
+
+static void isa_init_fdt(int cpu_node, u64 hartid, void *data)
+{
+	struct thread_info *info = (struct thread_info *)data;
+	const struct fdt_property *prop;
+	int len;
+
+	if (hartid != info->hartid)
+		return;
+
+	prop = fdt_get_property(dt_fdt(), cpu_node, "riscv,isa", &len);
+	assert(prop);
+
+	isa_parse(info->isa, prop->data, len);
+}
+
+static void isa_init_acpi(void)
+{
+	assert_msg(false, "ACPI not available");
+}
+
+static void isa_init(struct thread_info *info)
+{
+	int ret;
+
+	if (dt_available()) {
+		ret = dt_for_each_cpu_node(isa_init_fdt, info);
+		assert(ret == 0);
+	} else {
+		isa_init_acpi();
+	}
+}
+
 void thread_info_init(void)
 {
 	unsigned long hartid = csr_read(CSR_SSCRATCH);
 	int cpu = hartid_to_cpu(hartid);
 
+	isa_init(&cpus[cpu]);
 	csr_write(CSR_SSCRATCH, &cpus[cpu]);
 }
-- 
2.43.0


