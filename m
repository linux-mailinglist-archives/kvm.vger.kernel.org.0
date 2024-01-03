Return-Path: <kvm+bounces-5504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B36898228D9
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 08:17:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3D7F11F23C8C
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 07:17:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9849B18AEB;
	Wed,  3 Jan 2024 07:16:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B47FF18021;
	Wed,  3 Jan 2024 07:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.2.5.213])
	by gateway (Coremail) with SMTP id _____8AxCurBCZVly3IBAA--.1592S3;
	Wed, 03 Jan 2024 15:16:17 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.213])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Dxqb2_CZVlm1EYAA--.43800S6;
	Wed, 03 Jan 2024 15:16:16 +0800 (CST)
From: Bibo Mao <maobibo@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Juergen Gross <jgross@suse.com>
Cc: loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH 4/5] LoongArch: Add paravirt interface for guest kernel
Date: Wed,  3 Jan 2024 15:16:14 +0800
Message-Id: <20240103071615.3422264-5-maobibo@loongson.cn>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240103071615.3422264-1-maobibo@loongson.cn>
References: <20240103071615.3422264-1-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Dxqb2_CZVlm1EYAA--.43800S6
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3JF1kZFyDur48Cr45CFWfJFc_yoW7Cw4xpa
	4DAr4kWa18GF1fA39xKrW5ur15Jws7Cry29Fya934FyFsFqr1UXr1vgryqqFyDtaykJay0
	gFyrGws0ga1UJabCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUk2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r4j6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q6rW5McIj6I8E87Iv
	67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2
	Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s02
	6x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0x
	vE2Ix0cI8IcVAFwI0_Gr0_Xr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE
	42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6x
	kF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUoxR6UUUUU

The patch add paravirt interface for guest kernel, it checks whether
system runs on VM mode. If it is, it will detect hypervisor type. And
returns true it is KVM hypervisor, else return false. Currently only
KVM hypervisor is supported, so there is only hypervisor detection
for KVM type.

Signed-off-by: Bibo Mao <maobibo@loongson.cn>
---
 arch/loongarch/Kconfig                        |  8 ++++
 arch/loongarch/include/asm/kvm_para.h         |  7 ++++
 arch/loongarch/include/asm/paravirt.h         | 27 ++++++++++++
 .../include/asm/paravirt_api_clock.h          |  1 +
 arch/loongarch/kernel/Makefile                |  1 +
 arch/loongarch/kernel/paravirt.c              | 41 +++++++++++++++++++
 arch/loongarch/kernel/setup.c                 |  2 +
 7 files changed, 87 insertions(+)
 create mode 100644 arch/loongarch/include/asm/paravirt.h
 create mode 100644 arch/loongarch/include/asm/paravirt_api_clock.h
 create mode 100644 arch/loongarch/kernel/paravirt.c

diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index ee123820a476..940e5960d297 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -564,6 +564,14 @@ config CPU_HAS_PREFETCH
 	bool
 	default y
 
+config PARAVIRT
+	bool "Enable paravirtualization code"
+	help
+          This changes the kernel so it can modify itself when it is run
+	  under a hypervisor, potentially improving performance significantly
+	  over full virtualization.  However, when run without a hypervisor
+	  the kernel is theoretically slower and slightly larger.
+
 config ARCH_SUPPORTS_KEXEC
 	def_bool y
 
diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/include/asm/kvm_para.h
index 9425d3b7e486..41200e922a82 100644
--- a/arch/loongarch/include/asm/kvm_para.h
+++ b/arch/loongarch/include/asm/kvm_para.h
@@ -2,6 +2,13 @@
 #ifndef _ASM_LOONGARCH_KVM_PARA_H
 #define _ASM_LOONGARCH_KVM_PARA_H
 
+/*
+ * Hypcall code field
+ */
+#define HYPERVISOR_KVM			1
+#define HYPERVISOR_VENDOR_SHIFT		8
+#define HYPERCALL_CODE(vendor, code)	((vendor << HYPERVISOR_VENDOR_SHIFT) + code)
+
 /*
  * LoongArch hypcall return code
  */
diff --git a/arch/loongarch/include/asm/paravirt.h b/arch/loongarch/include/asm/paravirt.h
new file mode 100644
index 000000000000..b64813592ba0
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
+int pv_guest_init(void);
+#else
+static inline int pv_guest_init(void)
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
index 000000000000..21d01d05791a
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
+int __init pv_guest_init(void)
+{
+	if (!cpu_has_hypervisor)
+		return 0;
+	if (!kvm_para_available())
+		return 0;
+
+	return 1;
+}
diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.c
index d183a745fb85..fa680bdd0bd1 100644
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
@@ -376,6 +377,7 @@ void __init platform_init(void)
 	pr_info("The BIOS Version: %s\n", b_info.bios_version);
 
 	efi_runtime_init();
+	pv_guest_init();
 }
 
 static void __init check_kernel_sections_mem(void)
-- 
2.39.3


