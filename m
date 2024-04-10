Return-Path: <kvm+bounces-14091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E7BB689EDA6
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 10:30:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5D3851F22852
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 08:30:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D24C413DDB0;
	Wed, 10 Apr 2024 08:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XhVMMS+X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E83013D53B
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 08:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712737816; cv=none; b=cTGFq9TRKQrYyYWYfmpnKFdvlAWjHWnr2xRIPPGsv6x3QI9Fw06qElqGiPpmOkkw/veCOy8QBqXL+SA+bz7In4Q/TR0NzImMAT7rMVYzs+D1OOh0k+B2baQgAIpCQ9iBgBtmMQgHgat6KIOL638SDuswWiWhKRurihXo8sJjQW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712737816; c=relaxed/simple;
	bh=njKwkUA9WJ3YIT0OkI3ALUUZV9vR3gHV7QyHX6tpuOU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=eyK4V7D+H7gZy987tOBB7n8AGxbFOb70+a/UQGK9Hgn9g+mTrBBy5BiDYCN5gJYWvqCgGn8+rSGGWzKwy06fLUruw12FZwcxgigacPqxKpPYllnk0lr8EGubVhkRWoOFGoj9MBSSe3e2hRR5OWskLzhKqnXXXy8BEXZ275KK+L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XhVMMS+X; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-56e1bbdb362so7871981a12.1
        for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 01:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712737812; x=1713342612; darn=vger.kernel.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XU6xcBIsIab8YJPstad3M2dPguqVYWhFpd43H51xWog=;
        b=XhVMMS+X94BQwX9dL1puQ84iiq6yAOrtsFyS2oQ7NDKhAg/TVHbTa/xd2r8uRra7+x
         4doTiHBDwTxi49WavUkv/cxtpEqPTe+2vKx1rn8hoa9Qaab8vLrOM8PElIijQ2OlgCHV
         URGSb6+Bzp3q/X0/z3xJ/2HGYTOw+uV/xwm6APOBt2vheP8LNmR0n+MD00wFb19gh5rI
         P6HWaT7sVjkFf0LUVAuR88yu6hjbKgbhT7MmqwEf4GBj1cWfOjuEKyfJXLgJDur8tMZo
         Who0fb6kTydH6cvaOOHOvMEEefLtf0mamlUWI9Oo6kJWlQFN8l1Uw0f1EUMkCAs/kcf8
         0Khg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712737812; x=1713342612;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XU6xcBIsIab8YJPstad3M2dPguqVYWhFpd43H51xWog=;
        b=YLP8dBdM/V4Xjk8oxRj8GLH9GY9Q4a9zgzwLEsEEJrD1Pa/aEz6WlQWuKXQBi+ZcgF
         7JhH7qK4D8VTGX8T/HEQds9+lR3q0n1YYEx3+2R2BM+X/cDuPYopIZtFyduIk6uUUdLX
         niWKXKzJypvYC4DTFfQ2gQI1VzJGEmc9GxN9jGKVaovVvh49f5JwY3I9LSGF52ZXAG3l
         NWGhXIy28WtV8iXD55IogzSQpBVX06p9DmZtquUtTjqiHT+SB5byWRZOP94ZlOgzrYQS
         EiPI2HYb7H5Yux+zftjGBdAT0PBbKq1jJ1T4mHsD6ntf9VJBC5LVE+gptMuluF+iR3Ba
         A+1A==
X-Forwarded-Encrypted: i=1; AJvYcCU4HRU5AvJIx9elUB3y7ta6DV/Twx3rGpGvWjWDylZWTa4SFoDpStZErby0TGPTP+BtCfEO1H0aWp5gcEy+remzBzT8
X-Gm-Message-State: AOJu0Yy+raFjuTvVdOcPq8pdkhwk6NLy3o8XDKjsodPBsnSkxk+uzc+I
	H9OkmKrxEudFLNBtzZW49g043JFMvO+P/RA/tPALlWpyoWteJrRT1a15mTkGyg==
X-Google-Smtp-Source: AGHT+IE4gnHyEEJM1drr58SinQXzdNwje+RjQYL3RSrhfdsN00b2mWNmVd56f/js8snWFGYcCXXaAQ==
X-Received: by 2002:a50:8d5e:0:b0:56d:f78f:8747 with SMTP id t30-20020a508d5e000000b0056df78f8747mr1696582edt.16.1712737811724;
        Wed, 10 Apr 2024 01:30:11 -0700 (PDT)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id ig4-20020a056402458400b0056e51535a2esm4332477edb.82.2024.04.10.01.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 01:30:11 -0700 (PDT)
Date: Wed, 10 Apr 2024 09:30:07 +0100
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Vincent Donnefort <vdonnefort@google.com>
Subject: [PATCH v2 09/12] KVM: arm64: VHE: Add test module for hyp kCFI
Message-ID: <4webtguoyuc4yzya6vubduzthj5bemvyufryc7erri7wgexgaf@qjnnow76jkre>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

In order to easily periodically (and potentially automatically) validate
that the hypervisor kCFI feature doesn't bitrot, introduce a way to
trigger hypervisor kCFI faults from userspace on test builds of KVM.

Add hooks in the hypervisor code to call registered callbacks (intended
to trigger kCFI faults either for the callback call itself of from
within the callback function) when running with guest or host VBAR_EL2.
As the calls are issued from the KVM_RUN ioctl handling path, userspace
gains control over when the actual triggering of the fault happens
without needing to modify the KVM uAPI.

Export kernel functions to register these callbacks from modules and
introduce a kernel module intended to contain any testing logic. By
limiting the changes to the core kernel to a strict minimum, this
architectural split allows tests to be updated (within the module)
without the need to redeploy (or recompile) the kernel (hyp) under test.

Use the module parameters as the uAPI for configuring the fault
condition being tested (i.e. either at insertion or post-insertion
using /sys/module/.../parameters), which naturally makes it impossible
for userspace to test kCFI without the module (and, inversely, makes
the module only - not KVM - responsible for exposing said uAPI).

As kCFI is implemented with a caller-side check of a callee-side value,
make the module support 4 tests based on the location of the caller and
callee (built-in or in-module), for each of the 2 hypervisor contexts
(host & guest), selected by userspace using the 'guest' or 'host' module
parameter. For this purpose, export symbols which the module can use to
configure the callbacks for in-kernel and module-to-built-in kCFI
faulting calls.

Define the module-to-kernel API to allow the module to detect that it
was loaded on a kernel built with support for it but which is running
without a hypervisor (-ENXIO) or with one that doesn't use the VHE CPU
feature (-EOPNOTSUPP), which is currently the only mode for which KVM
supports hypervisor kCFI.

Allow kernel build configs to set CONFIG_HYP_CFI_TEST to only support
the in-kernel hooks (=y) or also build the test module (=m). Use
intermediate internal Kconfig flags (CONFIG_HYP_SUPPORTS_CFI_TEST and
CONFIG_HYP_CFI_TEST_MODULE) to simplify the Makefiles and #ifdefs. As
the symbols for callback registration are only exported to modules when
CONFIG_HYP_CFI_TEST != n, it is impossible for the test module to be
non-forcefully inserted on a kernel that doesn't support it.

Note that this feature must NOT result in any noticeable change
(behavioral or binary size) when HYP_CFI_TEST_MODULE = n.

CONFIG_HYP_CFI_TEST is intentionally independent of CONFIG_CFI_CLANG, to
avoid arbitrarily limiting the number of flag combinations that can be
tested with the module.

Also note that, as VHE aliases VBAR_EL1 to VBAR_EL2 for the host,
testing hypervisor kCFI in VHE and in host context is equivalent to
testing kCFI support of the kernel itself i.e. EL1 in non-VHE and/or in
non-virtualized environments. For this reason, CONFIG_CFI_PERMISSIVE
**will** prevent the test module from triggering a hyp panic (although a
warning still gets printed) in that context.

Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
---
 arch/arm64/include/asm/kvm_cfi.h     |  36 ++++++++
 arch/arm64/kvm/Kconfig               |  22 +++++
 arch/arm64/kvm/Makefile              |   3 +
 arch/arm64/kvm/hyp/include/hyp/cfi.h |  47 ++++++++++
 arch/arm64/kvm/hyp/vhe/Makefile      |   1 +
 arch/arm64/kvm/hyp/vhe/cfi.c         |  37 ++++++++
 arch/arm64/kvm/hyp/vhe/switch.c      |   7 ++
 arch/arm64/kvm/hyp_cfi_test.c        |  43 +++++++++
 arch/arm64/kvm/hyp_cfi_test_module.c | 133 +++++++++++++++++++++++++++
 9 files changed, 329 insertions(+)
 create mode 100644 arch/arm64/include/asm/kvm_cfi.h
 create mode 100644 arch/arm64/kvm/hyp/include/hyp/cfi.h
 create mode 100644 arch/arm64/kvm/hyp/vhe/cfi.c
 create mode 100644 arch/arm64/kvm/hyp_cfi_test.c
 create mode 100644 arch/arm64/kvm/hyp_cfi_test_module.c

diff --git a/arch/arm64/include/asm/kvm_cfi.h b/arch/arm64/include/asm/kvm_cfi.h
new file mode 100644
index 000000000000..13cc7b19d838
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_cfi.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2024 - Google Inc
+ * Author: Pierre-Clément Tosi <ptosi@google.com>
+ */
+
+#ifndef __ARM64_KVM_CFI_H__
+#define __ARM64_KVM_CFI_H__
+
+#include <asm/kvm_asm.h>
+#include <linux/errno.h>
+
+#ifdef CONFIG_HYP_SUPPORTS_CFI_TEST
+
+int kvm_cfi_test_register_host_ctxt_cb(void (*cb)(void));
+int kvm_cfi_test_register_guest_ctxt_cb(void (*cb)(void));
+
+#else
+
+static inline int kvm_cfi_test_register_host_ctxt_cb(void (*cb)(void))
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int kvm_cfi_test_register_guest_ctxt_cb(void (*cb)(void))
+{
+	return -EOPNOTSUPP;
+}
+
+#endif /* CONFIG_HYP_SUPPORTS_CFI_TEST */
+
+/* Symbols which the host can register as hyp callbacks; see <hyp/cfi.h>. */
+void hyp_trigger_builtin_cfi_fault(void);
+void hyp_builtin_cfi_fault_target(int unused);
+
+#endif /* __ARM64_KVM_CFI_H__ */
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 58f09370d17e..5daa8079a120 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -65,4 +65,26 @@ config PROTECTED_NVHE_STACKTRACE
 
 	  If unsure, or not using protected nVHE (pKVM), say N.
 
+config HYP_CFI_TEST
+	tristate "KVM hypervisor kCFI test support"
+	depends on KVM
+	help
+	  Say Y or M here to build KVM with test hooks to support intentionally
+	  triggering hypervisor kCFI faults in guest or host context.
+
+	  Say M here to also build a module which registers callbacks triggering
+	  faults and selected by userspace through its parameters.
+
+	  Note that this feature is currently only supported in VHE mode.
+
+	  If unsure, say N.
+
+config HYP_SUPPORTS_CFI_TEST
+	def_bool y
+	depends on HYP_CFI_TEST
+
+config HYP_CFI_TEST_MODULE
+	def_tristate m if HYP_CFI_TEST = m
+	depends on HYP_CFI_TEST
+
 endif # VIRTUALIZATION
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index c0c050e53157..d42540ae3ea7 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -22,6 +22,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
 	 vgic/vgic-its.o vgic/vgic-debug.o
 
+kvm-$(CONFIG_HYP_SUPPORTS_CFI_TEST) += hyp_cfi_test.o
 kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
 
 always-y := hyp_constants.h hyp-constants.s
@@ -39,3 +40,5 @@ $(obj)/hyp_constants.h: $(obj)/hyp-constants.s FORCE
 
 obj-kvm := $(addprefix $(obj)/, $(kvm-y))
 $(obj-kvm): $(obj)/hyp_constants.h
+
+obj-$(CONFIG_HYP_CFI_TEST_MODULE) += hyp_cfi_test_module.o
diff --git a/arch/arm64/kvm/hyp/include/hyp/cfi.h b/arch/arm64/kvm/hyp/include/hyp/cfi.h
new file mode 100644
index 000000000000..c6536040bc06
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/hyp/cfi.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2024 - Google Inc
+ * Author: Pierre-Clément Tosi <ptosi@google.com>
+ */
+
+#ifndef __ARM64_KVM_HYP_CFI_H__
+#define __ARM64_KVM_HYP_CFI_H__
+
+#include <asm/bug.h>
+#include <asm/errno.h>
+
+#include <linux/compiler.h>
+
+#ifdef CONFIG_HYP_SUPPORTS_CFI_TEST
+
+int __kvm_register_cfi_test_cb(void (*cb)(void), bool in_host_ctxt);
+
+extern void (*hyp_test_host_ctxt_cfi)(void);
+extern void (*hyp_test_guest_ctxt_cfi)(void);
+
+/* Hypervisor callbacks for the host to register. */
+void hyp_trigger_builtin_cfi_fault(void);
+void hyp_builtin_cfi_fault_target(int unused);
+
+#else
+
+static inline
+int __kvm_register_cfi_test_cb(void (*cb)(void), bool in_host_ctxt)
+{
+	return -EOPNOTSUPP;
+}
+
+#define hyp_test_host_ctxt_cfi ((void(*)(void))(NULL))
+#define hyp_test_guest_ctxt_cfi ((void(*)(void))(NULL))
+
+static inline void hyp_trigger_builtin_cfi_fault(void)
+{
+}
+
+static inline void hyp_builtin_cfi_fault_target(int __always_unused unused)
+{
+}
+
+#endif /* CONFIG_HYP_SUPPORTS_CFI_TEST */
+
+#endif /* __ARM64_KVM_HYP_CFI_H__ */
diff --git a/arch/arm64/kvm/hyp/vhe/Makefile b/arch/arm64/kvm/hyp/vhe/Makefile
index 3b9e5464b5b3..19ca584cc21e 100644
--- a/arch/arm64/kvm/hyp/vhe/Makefile
+++ b/arch/arm64/kvm/hyp/vhe/Makefile
@@ -9,3 +9,4 @@ ccflags-y := -D__KVM_VHE_HYPERVISOR__
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o
+obj-$(CONFIG_HYP_SUPPORTS_CFI_TEST) += cfi.o
diff --git a/arch/arm64/kvm/hyp/vhe/cfi.c b/arch/arm64/kvm/hyp/vhe/cfi.c
new file mode 100644
index 000000000000..5849f239e27f
--- /dev/null
+++ b/arch/arm64/kvm/hyp/vhe/cfi.c
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2024 - Google Inc
+ * Author: Pierre-Clément Tosi <ptosi@google.com>
+ */
+#include <asm/rwonce.h>
+
+#include <hyp/cfi.h>
+
+void (*hyp_test_host_ctxt_cfi)(void);
+void (*hyp_test_guest_ctxt_cfi)(void);
+
+int __kvm_register_cfi_test_cb(void (*cb)(void), bool in_host_ctxt)
+{
+	if (in_host_ctxt)
+		hyp_test_host_ctxt_cfi = cb;
+	else
+		hyp_test_guest_ctxt_cfi = cb;
+
+	return 0;
+}
+
+void hyp_builtin_cfi_fault_target(int __always_unused unused)
+{
+}
+
+void hyp_trigger_builtin_cfi_fault(void)
+{
+	/* Intentional UB cast & dereference, to trigger a kCFI fault. */
+	void (*target)(void) = (void *)&hyp_builtin_cfi_fault_target;
+
+	/*
+	 * READ_ONCE() prevents this indirect call from being optimized out,
+	 * forcing the compiler to generate the kCFI check before the branch.
+	 */
+	READ_ONCE(target)();
+}
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 9db04a286398..b3268933b093 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -4,6 +4,7 @@
  * Author: Marc Zyngier <marc.zyngier@arm.com>
  */
 
+#include <hyp/cfi.h>
 #include <hyp/switch.h>
 
 #include <linux/arm-smccc.h>
@@ -221,6 +222,9 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_context *guest_ctxt;
 	u64 exit_code;
 
+	if (IS_ENABLED(CONFIG_HYP_SUPPORTS_CFI_TEST) && unlikely(hyp_test_host_ctxt_cfi))
+		hyp_test_host_ctxt_cfi();
+
 	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
 	host_ctxt->__hyp_running_vcpu = vcpu;
 	guest_ctxt = &vcpu->arch.ctxt;
@@ -245,6 +249,9 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	else
 		vcpu_clear_flag(vcpu, VCPU_HYP_CONTEXT);
 
+	if (IS_ENABLED(CONFIG_HYP_SUPPORTS_CFI_TEST) && unlikely(hyp_test_guest_ctxt_cfi))
+		hyp_test_guest_ctxt_cfi();
+
 	do {
 		/* Jump in the fire! */
 		exit_code = __guest_enter(vcpu);
diff --git a/arch/arm64/kvm/hyp_cfi_test.c b/arch/arm64/kvm/hyp_cfi_test.c
new file mode 100644
index 000000000000..da7b25ca1b1f
--- /dev/null
+++ b/arch/arm64/kvm/hyp_cfi_test.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2024 - Google Inc
+ * Author: Pierre-Clément Tosi <ptosi@google.com>
+ */
+#include <asm/kvm_asm.h>
+#include <asm/kvm_cfi.h>
+#include <asm/kvm_host.h>
+#include <asm/virt.h>
+
+#include <linux/export.h>
+#include <linux/stddef.h>
+#include <linux/types.h>
+
+/* For calling directly into the VHE hypervisor; see <hyp/cfi.h>. */
+int __kvm_register_cfi_test_cb(void (*)(void), bool);
+
+static int kvm_register_cfi_test_cb(void (*vhe_cb)(void), bool in_host_ctxt)
+{
+	if (!is_hyp_mode_available())
+		return -ENXIO;
+
+	if (is_hyp_nvhe())
+		return -EOPNOTSUPP;
+
+	return __kvm_register_cfi_test_cb(vhe_cb, in_host_ctxt);
+}
+
+int kvm_cfi_test_register_host_ctxt_cb(void (*cb)(void))
+{
+	return kvm_register_cfi_test_cb(cb, true);
+}
+EXPORT_SYMBOL(kvm_cfi_test_register_host_ctxt_cb);
+
+int kvm_cfi_test_register_guest_ctxt_cb(void (*cb)(void))
+{
+	return kvm_register_cfi_test_cb(cb, false);
+}
+EXPORT_SYMBOL(kvm_cfi_test_register_guest_ctxt_cb);
+
+/* Hypervisor callbacks for the test module to register. */
+EXPORT_SYMBOL(hyp_trigger_builtin_cfi_fault);
+EXPORT_SYMBOL(hyp_builtin_cfi_fault_target);
diff --git a/arch/arm64/kvm/hyp_cfi_test_module.c b/arch/arm64/kvm/hyp_cfi_test_module.c
new file mode 100644
index 000000000000..eeda4be4d3ef
--- /dev/null
+++ b/arch/arm64/kvm/hyp_cfi_test_module.c
@@ -0,0 +1,133 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2024 - Google Inc
+ * Author: Pierre-Clément Tosi <ptosi@google.com>
+ */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <asm/kvm_asm.h>
+#include <asm/kvm_cfi.h>
+#include <asm/rwonce.h>
+
+#include <linux/init.h>
+#include <linux/kstrtox.h>
+#include <linux/module.h>
+#include <linux/printk.h>
+
+static int set_host_mode(const char *val, const struct kernel_param *kp);
+static int set_guest_mode(const char *val, const struct kernel_param *kp);
+
+#define M_DESC \
+	"\n\t0: none" \
+	"\n\t1: built-in caller & built-in callee" \
+	"\n\t2: built-in caller & module callee" \
+	"\n\t3: module caller & built-in callee" \
+	"\n\t4: module caller & module callee"
+
+static unsigned int host_mode;
+module_param_call(host, set_host_mode, param_get_uint, &host_mode, 0644);
+MODULE_PARM_DESC(host,
+		 "Hypervisor kCFI fault test case in host context:" M_DESC);
+
+static unsigned int guest_mode;
+module_param_call(guest, set_guest_mode, param_get_uint, &guest_mode, 0644);
+MODULE_PARM_DESC(guest,
+		 "Hypervisor kCFI fault test case in guest context:" M_DESC);
+
+static void trigger_module2module_cfi_fault(void);
+static void trigger_module2builtin_cfi_fault(void);
+static void hyp_cfi_module2module_test_target(int);
+static void hyp_cfi_builtin2module_test_target(int);
+
+static int set_param_mode(const char *val, const struct kernel_param *kp,
+			 int (*register_cb)(void (*)(void)))
+{
+	unsigned int *mode = kp->arg;
+	int err;
+
+	err = param_set_uint(val, kp);
+	if (err)
+		return err;
+
+	switch (*mode) {
+	case 0:
+		return register_cb(NULL);
+	case 1:
+		return register_cb(hyp_trigger_builtin_cfi_fault);
+	case 2:
+		return register_cb((void *)hyp_cfi_builtin2module_test_target);
+	case 3:
+		return register_cb(trigger_module2builtin_cfi_fault);
+	case 4:
+		return register_cb(trigger_module2module_cfi_fault);
+	default:
+		return -EINVAL;
+	}
+}
+
+static int set_host_mode(const char *val, const struct kernel_param *kp)
+{
+	return set_param_mode(val, kp, kvm_cfi_test_register_host_ctxt_cb);
+}
+
+static int set_guest_mode(const char *val, const struct kernel_param *kp)
+{
+	return set_param_mode(val, kp, kvm_cfi_test_register_guest_ctxt_cb);
+}
+
+static void __exit exit_hyp_cfi_test(void)
+{
+	int err;
+
+	err = kvm_cfi_test_register_host_ctxt_cb(NULL);
+	if (err)
+		pr_err("Failed to unregister host context trigger: %d\n", err);
+
+	err = kvm_cfi_test_register_guest_ctxt_cb(NULL);
+	if (err)
+		pr_err("Failed to unregister guest context trigger: %d\n", err);
+}
+module_exit(exit_hyp_cfi_test);
+
+static void trigger_module2builtin_cfi_fault(void)
+{
+	/* Intentional UB cast & dereference, to trigger a kCFI fault. */
+	void (*target)(void) = (void *)&hyp_builtin_cfi_fault_target;
+
+	/*
+	 * READ_ONCE() prevents this indirect call from being optimized out,
+	 * forcing the compiler to generate the kCFI check before the branch.
+	 */
+	READ_ONCE(target)();
+
+	pr_err_ratelimited("%s: Survived a kCFI violation\n", __func__);
+}
+
+static void trigger_module2module_cfi_fault(void)
+{
+	/* Intentional UB cast & dereference, to trigger a kCFI fault. */
+	void (*target)(void) = (void *)&hyp_cfi_module2module_test_target;
+
+	/*
+	 * READ_ONCE() prevents this indirect call from being optimized out,
+	 * forcing the compiler to generate the kCFI check before the branch.
+	 */
+	READ_ONCE(target)();
+
+	pr_err_ratelimited("%s: Survived a kCFI violation\n", __func__);
+}
+
+/* Use different functions, for clearer symbols in kCFI panic reports. */
+static noinline
+void hyp_cfi_module2module_test_target(int __always_unused unused)
+{
+}
+
+static noinline
+void hyp_cfi_builtin2module_test_target(int __always_unused unused)
+{
+}
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pierre-Clément Tosi <ptosi@google.com>");
+MODULE_DESCRIPTION("KVM hypervisor kCFI test module");
-- 
2.44.0.478.gd926399ef9-goog


-- 
Pierre

