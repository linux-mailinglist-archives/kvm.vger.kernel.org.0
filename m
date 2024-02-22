Return-Path: <kvm+bounces-9353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D847D85EFDD
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 04:29:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 65D8B1F23B97
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 03:29:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BC7C225AF;
	Thu, 22 Feb 2024 03:28:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2342818E1C;
	Thu, 22 Feb 2024 03:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708572493; cv=none; b=RgjzlicdW4EFmFNeYG7MLuXLWUSR3qXFjuQrlz+WKG4ik9EflM2lHGvsbgMYgNDvgRlppVDEFyNEGgGzuZXes6BP3e97PEOVLF8YIV3AmjJhEiK3SSXugYh1w+rTK3PFm0vl/wQ1tlZJGJLt+qUIDX3TvV3KOL8MNJkAW1ePprg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708572493; c=relaxed/simple;
	bh=Do7Ps1OcBOeWjwUXEzJWNirkfRw8RhGRQugYV7Xd0n4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rLijxRMNrCVejcqamuoP7TLQG4OExXvDytk/UasM7j6fPVhBTWwRwY6ri7thdP1s6UAmYdPodGZiaeQMqOPHePHLWeP0JJMbIRkGh5ACw+JPk8D+LFqrAozkdIqfN+fHIA51pKraS4rDzXxgavgd1/P3ChVX5CiXL6dZYgkH90U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8Bx3+tJv9ZlaAoQAA--.41308S3;
	Thu, 22 Feb 2024 11:28:09 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8CxrhNDv9Zl+nM+AA--.41033S6;
	Thu, 22 Feb 2024 11:28:07 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Juergen Gross <jgross@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v5 4/6] LoongArch: Add paravirt interface for guest kernel
Date: Thu, 22 Feb 2024 11:28:01 +0800
Message-Id: <20240222032803.2177856-5-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240222032803.2177856-1-maobibo@loongson.cn>
References: <20240222032803.2177856-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8CxrhNDv9Zl+nM+AA--.41033S6
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3XFWUAw1rZrW8ur4Dur4xKrX_yoW7CFWkpa
	srAr4kWw48GFn3A39xKrWY9r15Jws7Cry2gFy3u34FyFZFqF1UXr4vqryqqFyUta1kJay0
	gFyrGws0ga1UAabCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUBab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAF
	wI0_Gr1j6F4UJwAaw2AFwI0_Jrv_JF1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2
	xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_
	Jw0_WrylYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x
	0EwIxGrwCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwCFI7km07C267AKxVWUXVWUAwC20s026c02F40E14v26r1j6r18MI8I3I0E74
	80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0
	I7IYx2IY67AKxVW5JVW7JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04
	k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7Cj
	xVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07j2MKZUUUUU=

Paravirt interface pv_ipi_init() is added here for guest kernel, it
firstly checks whether system runs on VM mode. If kernel runs on VM mode,
it will call function kvm_para_available() to detect current VMM type.
Now only KVM VMM type is detected,the paravirt function can work only if
current VMM is KVM hypervisor, since there is only KVM hypervisor
supported on LoongArch now.

There is not effective with pv_ipi_init() now, it is dummy function.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/Kconfig                        |  9 ++++
 arch/loongarch/include/asm/kvm_para.h         |  7 ++++
 arch/loongarch/include/asm/paravirt.h         | 27 ++++++++++++
 .../include/asm/paravirt_api_clock.h          |  1 +
 arch/loongarch/kernel/Makefile                |  1 +
 arch/loongarch/kernel/paravirt.c              | 41 +++++++++++++++++++
 arch/loongarch/kernel/setup.c                 |  1 +
 7 files changed, 87 insertions(+)
 create mode 100644 arch/loongarch/include/asm/paravirt.h
 create mode 100644 arch/loongarch/include/asm/paravirt_api_clock.h
 create mode 100644 arch/loongarch/kernel/paravirt.c

diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index 929f68926b34..fdaae9a0435c 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -587,6 +587,15 @@ config CPU_HAS_PREFETCH
 	bool
 	default y
 
+config PARAVIRT
+	bool "Enable paravirtualization code"
+	depends on AS_HAS_LVZ_EXTENSION
+	help
+          This changes the kernel so it can modify itself when it is run
+	  under a hypervisor, potentially improving performance significantly
+	  over full virtualization.  However, when run without a hypervisor
+	  the kernel is theoretically slower and slightly larger.
+
 config ARCH_SUPPORTS_KEXEC
 	def_bool y
 
diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/include/asm/kvm_para.h
index d48f993ae206..af5d677a9052 100644
--- a/arch/loongarch/include/asm/kvm_para.h
+++ b/arch/loongarch/include/asm/kvm_para.h
@@ -2,6 +2,13 @@
 #ifndef _ASM_LOONGARCH_KVM_PARA_H
 #define _ASM_LOONGARCH_KVM_PARA_H
 
+/*
+ * Hypercall code field
+ */
+#define HYPERVISOR_KVM			1
+#define HYPERVISOR_VENDOR_SHIFT		8
+#define HYPERCALL_CODE(vendor, code)	((vendor << HYPERVISOR_VENDOR_SHIFT) + code)
+
 /*
  * LoongArch hypercall return code
  */
diff --git a/arch/loongarch/include/asm/paravirt.h b/arch/loongarch/include/asm/paravirt.h
new file mode 100644
index 000000000000..58f7b7b89f2c
--- /dev/null
+++ b/arch/loongarch/include/asm/paravirt.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_LOONGARCH_PARAVIRT_H
+#define _ASM_LOONGARCH_PARAVIRT_H
+
+#ifdef CONFIG_PARAVIRT
+#include <linux/static_call_types.h>
+struct static_key;
+extern struct static_key paravirt_steal_enabled;
+extern struct static_key paravirt_steal_rq_enabled;
+
+u64 dummy_steal_clock(int cpu);
+DECLARE_STATIC_CALL(pv_steal_clock, dummy_steal_clock);
+
+static inline u64 paravirt_steal_clock(int cpu)
+{
+	return static_call(pv_steal_clock)(cpu);
+}
+
+int pv_ipi_init(void);
+#else
+static inline int pv_ipi_init(void)
+{
+	return 0;
+}
+
+#endif // CONFIG_PARAVIRT
+#endif
diff --git a/arch/loongarch/include/asm/paravirt_api_clock.h b/arch/loongarch/include/asm/paravirt_api_clock.h
new file mode 100644
index 000000000000..65ac7cee0dad
--- /dev/null
+++ b/arch/loongarch/include/asm/paravirt_api_clock.h
@@ -0,0 +1 @@
+#include <asm/paravirt.h>
diff --git a/arch/loongarch/kernel/Makefile b/arch/loongarch/kernel/Makefile
index 3c808c680370..662e6e9de12d 100644
--- a/arch/loongarch/kernel/Makefile
+++ b/arch/loongarch/kernel/Makefile
@@ -48,6 +48,7 @@ obj-$(CONFIG_MODULES)		+= module.o module-sections.o
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 
 obj-$(CONFIG_PROC_FS)		+= proc.o
+obj-$(CONFIG_PARAVIRT)		+= paravirt.o
 
 obj-$(CONFIG_SMP)		+= smp.o
 
diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kernel/paravirt.c
new file mode 100644
index 000000000000..5cf794e8490f
--- /dev/null
+++ b/arch/loongarch/kernel/paravirt.c
@@ -0,0 +1,41 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/export.h>
+#include <linux/types.h>
+#include <linux/jump_label.h>
+#include <linux/kvm_para.h>
+#include <asm/paravirt.h>
+#include <linux/static_call.h>
+
+struct static_key paravirt_steal_enabled;
+struct static_key paravirt_steal_rq_enabled;
+
+static u64 native_steal_clock(int cpu)
+{
+	return 0;
+}
+
+DEFINE_STATIC_CALL(pv_steal_clock, native_steal_clock);
+
+static bool kvm_para_available(void)
+{
+	static int hypervisor_type;
+	int config;
+
+	if (!hypervisor_type) {
+		config = read_cpucfg(CPUCFG_KVM_SIG);
+		if (!memcmp(&config, KVM_SIGNATURE, 4))
+			hypervisor_type = HYPERVISOR_KVM;
+	}
+
+	return hypervisor_type == HYPERVISOR_KVM;
+}
+
+int __init pv_ipi_init(void)
+{
+	if (!cpu_has_hypervisor)
+		return 0;
+	if (!kvm_para_available())
+		return 0;
+
+	return 1;
+}
diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.c
index edf2bba80130..b79a1244b56f 100644
--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -43,6 +43,7 @@
 #include <asm/efi.h>
 #include <asm/loongson.h>
 #include <asm/numa.h>
+#include <asm/paravirt.h>
 #include <asm/pgalloc.h>
 #include <asm/sections.h>
 #include <asm/setup.h>
-- 
2.39.3


