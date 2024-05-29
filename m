Return-Path: <kvm+bounces-18295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CB4568D361F
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 14:15:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43F911F26178
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 12:15:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 088F9181CEA;
	Wed, 29 May 2024 12:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NHSO0RzI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C45B180A92
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 12:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716984900; cv=none; b=ETIO2JX3aX6pkZt7zZnYCKUjSS4RRyzI+nD4ZGJGaqiEuDWzA98avW0hdc/KM3H9Ukih8eewpX31EqJqjzXWocnICptTZMFEcJNAlmQcqOosMYgBO3lftg7zFJzNqr8uJ018m6ELfM0U7IVlJMaQTNeIfO97vrQOgSDj748JzuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716984900; c=relaxed/simple;
	bh=w/OwqY7DTBtD/BmP+AMgJ3tEunuTuRYCMp3ThRXQ3OU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Cq1FdQFYixM6OwR0jVR7n4XVfsBdXBy6vJHZouoe7kj8QzmnyvC5uw91bkBoWl2ShwUqEk9G6ItrTB88DMr9WR40VSh/U4/10ykqICn8sYLpT3Nba6IRHA7+intZCogjTNEPW+EaleLpNCsH2lXBzlXRZKotZhYwEGNLJXE4QTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NHSO0RzI; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-df78acd5bbbso3131293276.1
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 05:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716984897; x=1717589697; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uRgrsfnu4k+NI/qYYv/tuJDICq7UcPQuz5rX48+teys=;
        b=NHSO0RzIMbMoowgkwXbrtlWFvqNImqpSD7G6cwgLpHdp488EvCWfORJCFZ6j4zCo85
         YNL0HrcyTU4thAGDoUNRQr/mLsp9F9QrV9iMfHsMAkCytx8uJNR6HbkF2ji7Pa81HSVc
         KwVhcAz3esbVP5bsWX3CfzYK5LKO8A2ZNquQ7mdM9QheQsj5ZeVAWpnuLz1Zo8Pf273X
         hmOg1lV2rPyDXEtQWYczIH3bsz8OYyf3Uprtr+qV6roHJ49k7CxUUKb2B+HaWslhtZEB
         zXgE3MYXiYz1Px3/1yjUmBkqmet5Sc0TnCK9KYeLz4P4b11xHjQARgwsLFYjsGQoq+xt
         Ak0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716984897; x=1717589697;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uRgrsfnu4k+NI/qYYv/tuJDICq7UcPQuz5rX48+teys=;
        b=O0GqUqo8FwHND2uVJZNPdSrzKjZe5DsJ8EW8IE9wqnsS8vyPJz9LU5UQ9qaaZEXgQ+
         Yxedd/2ka8iO8nVkTK9bWdAJTiPNKmRVk4106rGw1B8kleWI0tDmXf2vQXZEXP09btxT
         +kxDaQYvbyNS0EdGB5mMaxfnw9DZakXsGyPCsgu+sWP/1Hk/r6AsY7mNU5MMC/yMCsNp
         j12sHnxtM3qzya3cCtJyb/LRyU1FMVOExBMse6UweqIxcgfkZHOmlwF7pSez1tPErQFK
         mutmqp6p/3Ewxhvf70aydtrpYzvLXpGL/8CP8yzPDlorVGKD2f5MQYEMpfNjHGTSmC5f
         iGbw==
X-Forwarded-Encrypted: i=1; AJvYcCX55KaJTR1nCNDhbv60vkcTBnnIEGeRm1N+EyYwHt5UR05xufwYoWpFBH+tHJClvaqgkE+Mx+Kw7hxvO2J6hSLUuvoV
X-Gm-Message-State: AOJu0YwEKUR66znjiNWFuB4ngVW7y1eA5IFgMpGjsG5rpfqAvaRXQmrT
	BAE4K25hvEJMDQfYkF3JP+a7JTy43DlSHNmsj+Qau/0jKwr5fTJnxVGOfKbYWHa7v47RUFAjZA=
	=
X-Google-Smtp-Source: AGHT+IFkQb5OxQ4pScFZIWRQEFsGIMu9g6HuNiBaUgrqAIayPXl97t9kWzQUkwXiZZdHCWHOqYzW82AA/Q==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:6902:1207:b0:dee:7884:acc7 with SMTP id
 3f1490d57ef6-df77214fd6dmr1189597276.1.1716984897529; Wed, 29 May 2024
 05:14:57 -0700 (PDT)
Date: Wed, 29 May 2024 13:12:18 +0100
In-Reply-To: <20240529121251.1993135-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240529121251.1993135-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240529121251.1993135-13-ptosi@google.com>
Subject: [PATCH v4 12/13] KVM: arm64: VHE: Add test module for hyp kCFI
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

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
the in-kernel hooks (=3Dy) or also build the test module (=3Dm). Use
intermediate internal Kconfig flags (CONFIG_HYP_SUPPORTS_CFI_TEST and
CONFIG_HYP_CFI_TEST_MODULE) to simplify the Makefiles and #ifdefs. As
the symbols for callback registration are only exported to modules when
CONFIG_HYP_CFI_TEST !=3D n, it is impossible for the test module to be
non-forcefully inserted on a kernel that doesn't support it.

Note that this feature must NOT result in any noticeable change
(behavioral or binary size) when HYP_CFI_TEST_MODULE =3D n.

CONFIG_HYP_CFI_TEST is intentionally independent of CONFIG_CFI_CLANG, to
avoid arbitrarily limiting the number of flag combinations that can be
tested with the module.

Also note that, as VHE aliases VBAR_EL1 to VBAR_EL2 for the host,
testing hypervisor kCFI in VHE and in host context is equivalent to
testing kCFI support of the kernel itself i.e. EL1 in non-VHE and/or in
non-virtualized environments. For this reason, CONFIG_CFI_PERMISSIVE
**will** prevent the test module from triggering a hyp panic (although a
warning still gets printed) in that context.

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
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

diff --git a/arch/arm64/include/asm/kvm_cfi.h b/arch/arm64/include/asm/kvm_=
cfi.h
new file mode 100644
index 000000000000..13cc7b19d838
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_cfi.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2024 - Google Inc
+ * Author: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
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
+/* Symbols which the host can register as hyp callbacks; see <hyp/cfi.h>. =
*/
+void hyp_trigger_builtin_cfi_fault(void);
+void hyp_builtin_cfi_fault_target(int unused);
+
+#endif /* __ARM64_KVM_CFI_H__ */
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 58f09370d17e..5daa8079a120 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -65,4 +65,26 @@ config PROTECTED_NVHE_STACKTRACE
=20
 	  If unsure, or not using protected nVHE (pKVM), say N.
=20
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
+	def_tristate m if HYP_CFI_TEST =3D m
+	depends on HYP_CFI_TEST
+
 endif # VIRTUALIZATION
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index a6497228c5a8..303be42ad90a 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -22,6 +22,7 @@ kvm-y +=3D arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.=
o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
 	 vgic/vgic-its.o vgic/vgic-debug.o
=20
+kvm-$(CONFIG_HYP_SUPPORTS_CFI_TEST) +=3D hyp_cfi_test.o
 kvm-$(CONFIG_HW_PERF_EVENTS)  +=3D pmu-emul.o pmu.o
 kvm-$(CONFIG_ARM64_PTR_AUTH)  +=3D pauth.o
=20
@@ -40,3 +41,5 @@ $(obj)/hyp_constants.h: $(obj)/hyp-constants.s FORCE
=20
 obj-kvm :=3D $(addprefix $(obj)/, $(kvm-y))
 $(obj-kvm): $(obj)/hyp_constants.h
+
+obj-$(CONFIG_HYP_CFI_TEST_MODULE) +=3D hyp_cfi_test_module.o
diff --git a/arch/arm64/kvm/hyp/include/hyp/cfi.h b/arch/arm64/kvm/hyp/incl=
ude/hyp/cfi.h
new file mode 100644
index 000000000000..c6536040bc06
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/hyp/cfi.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2024 - Google Inc
+ * Author: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
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
+static inline void hyp_builtin_cfi_fault_target(int __always_unused unused=
)
+{
+}
+
+#endif /* CONFIG_HYP_SUPPORTS_CFI_TEST */
+
+#endif /* __ARM64_KVM_HYP_CFI_H__ */
diff --git a/arch/arm64/kvm/hyp/vhe/Makefile b/arch/arm64/kvm/hyp/vhe/Makef=
ile
index 3b9e5464b5b3..19ca584cc21e 100644
--- a/arch/arm64/kvm/hyp/vhe/Makefile
+++ b/arch/arm64/kvm/hyp/vhe/Makefile
@@ -9,3 +9,4 @@ ccflags-y :=3D -D__KVM_VHE_HYPERVISOR__
 obj-y :=3D timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o
 obj-y +=3D ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.=
o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o
+obj-$(CONFIG_HYP_SUPPORTS_CFI_TEST) +=3D cfi.o
diff --git a/arch/arm64/kvm/hyp/vhe/cfi.c b/arch/arm64/kvm/hyp/vhe/cfi.c
new file mode 100644
index 000000000000..5849f239e27f
--- /dev/null
+++ b/arch/arm64/kvm/hyp/vhe/cfi.c
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2024 - Google Inc
+ * Author: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
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
+		hyp_test_host_ctxt_cfi =3D cb;
+	else
+		hyp_test_guest_ctxt_cfi =3D cb;
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
+	void (*target)(void) =3D (void *)&hyp_builtin_cfi_fault_target;
+
+	/*
+	 * READ_ONCE() prevents this indirect call from being optimized out,
+	 * forcing the compiler to generate the kCFI check before the branch.
+	 */
+	READ_ONCE(target)();
+}
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switc=
h.c
index 6c64783c3e00..fe70220876b4 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -4,6 +4,7 @@
  * Author: Marc Zyngier <marc.zyngier@arm.com>
  */
=20
+#include <hyp/cfi.h>
 #include <hyp/switch.h>
=20
 #include <linux/arm-smccc.h>
@@ -311,6 +312,9 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_context *guest_ctxt;
 	u64 exit_code;
=20
+	if (IS_ENABLED(CONFIG_HYP_SUPPORTS_CFI_TEST) && unlikely(hyp_test_host_ct=
xt_cfi))
+		hyp_test_host_ctxt_cfi();
+
 	host_ctxt =3D host_data_ptr(host_ctxt);
 	guest_ctxt =3D &vcpu->arch.ctxt;
=20
@@ -329,6 +333,9 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	sysreg_restore_guest_state_vhe(guest_ctxt);
 	__debug_switch_to_guest(vcpu);
=20
+	if (IS_ENABLED(CONFIG_HYP_SUPPORTS_CFI_TEST) && unlikely(hyp_test_guest_c=
txt_cfi))
+		hyp_test_guest_ctxt_cfi();
+
 	do {
 		/* Jump in the fire! */
 		exit_code =3D __guest_enter(vcpu);
diff --git a/arch/arm64/kvm/hyp_cfi_test.c b/arch/arm64/kvm/hyp_cfi_test.c
new file mode 100644
index 000000000000..da7b25ca1b1f
--- /dev/null
+++ b/arch/arm64/kvm/hyp_cfi_test.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2024 - Google Inc
+ * Author: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
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
+static int kvm_register_cfi_test_cb(void (*vhe_cb)(void), bool in_host_ctx=
t)
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
diff --git a/arch/arm64/kvm/hyp_cfi_test_module.c b/arch/arm64/kvm/hyp_cfi_=
test_module.c
new file mode 100644
index 000000000000..eeda4be4d3ef
--- /dev/null
+++ b/arch/arm64/kvm/hyp_cfi_test_module.c
@@ -0,0 +1,133 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2024 - Google Inc
+ * Author: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
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
+module_param_call(guest, set_guest_mode, param_get_uint, &guest_mode, 0644=
);
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
+	unsigned int *mode =3D kp->arg;
+	int err;
+
+	err =3D param_set_uint(val, kp);
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
+	err =3D kvm_cfi_test_register_host_ctxt_cb(NULL);
+	if (err)
+		pr_err("Failed to unregister host context trigger: %d\n", err);
+
+	err =3D kvm_cfi_test_register_guest_ctxt_cb(NULL);
+	if (err)
+		pr_err("Failed to unregister guest context trigger: %d\n", err);
+}
+module_exit(exit_hyp_cfi_test);
+
+static void trigger_module2builtin_cfi_fault(void)
+{
+	/* Intentional UB cast & dereference, to trigger a kCFI fault. */
+	void (*target)(void) =3D (void *)&hyp_builtin_cfi_fault_target;
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
+	void (*target)(void) =3D (void *)&hyp_cfi_module2module_test_target;
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
+MODULE_AUTHOR("Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>");
+MODULE_DESCRIPTION("KVM hypervisor kCFI test module");
--=20
2.45.1.288.g0e0cd299f1-goog


