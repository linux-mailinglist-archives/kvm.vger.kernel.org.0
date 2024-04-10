Return-Path: <kvm+bounces-14093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 17D6A89EDAB
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 10:31:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 98D5F1F2316C
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 08:31:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD87F13FD92;
	Wed, 10 Apr 2024 08:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4YXPFTZ4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F155713F01B
	for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 08:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712737881; cv=none; b=OgH3w8VGeh9R1GGB+6RCj+G+QQ6ix8pUz6qwS9xeYvKd9fkS3eDH/e3iTL/b1kEIrx+unn99aY6EqUd1AMWORVyOFvHcUkc+wIvnj/hc0KyUYHa2OkvEoeWKLRe7OGzxP0E70LLRAR0Q2/LuDHu9LZ2p1yUV4NH/B1v3+8VY9HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712737881; c=relaxed/simple;
	bh=cpzOqPqp2FWk5BTnYrCSS1LW18sAwwLHJ+v0bKY6LVk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=N21otRbxgQli1VzaHWvkVGkZYNYVoh0AN0jvHzxx0KCdqIyA9qNg42oYzeimsaRb+RbXhhJcsBIzdKsO0HaqhaTYELpomD0g2Yz6aDhX91fmMOINCvY3Vps0B9k8GHGbvqHbbzHH3nSPvMw7D3DwuLyM/Fq9dUzDh/XN/eJiQ0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4YXPFTZ4; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a51fc011e8fso179553466b.0
        for <kvm@vger.kernel.org>; Wed, 10 Apr 2024 01:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712737877; x=1713342677; darn=vger.kernel.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RG+NK3kQHpQlT1WXed325+BJ1wFsJ9Qvvp1+whP8THg=;
        b=4YXPFTZ4z8LAHb3zaqyEevi3zyhazyZflsxZNISJ+thEM3+db1ybdKgX7H0kD9IVOd
         GNwMFHbsQlxPpJtQoOmf1Bh9wuNStXxdR3UBEQQaMWRmpsDetnA1oDPrui3Wl0Y8ElDX
         XNEePpslt/xw6D42Pa6Iptl0xx0MY75NAQGVxu5IA1Gew2aDcfQ3eStpxEIfBSTmOQug
         fKdyLX/zUO1oNF8qCGdlWvCew5ERu/LBBGIvNLjttV/GVDY4OapKTpW9xGEvsR3MhZxX
         VmtPVncoEE5VFiDWMIyTtLUHKMBRsoFViqsgVMGChPMWlrbr/SNd95tNTlitDgFX0fnD
         xYBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712737877; x=1713342677;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RG+NK3kQHpQlT1WXed325+BJ1wFsJ9Qvvp1+whP8THg=;
        b=EzBxEGHAqwj8mxFM1zW8QP5TvRwftcpReYmDVYdtEZQtKRSsVNKt46Mk2lOLLMf8Tr
         aIQD7JcyjZ4oREo9RgDdVeKIWAIVqB0bIuL3y58KwNKesH/a3QFqkztz7ZOrE/YUYw3k
         pHKKpPfLFNpIAN7ktFG/pCkgWUJO8ZpGXvr8+TBoQCdBf6SVaeCnZLP2oYx+FsbMP5ak
         bsuOalde6n01REVYJfvcyYNB1dIQBqjwTTVxEhftNFF3FLFL0WtAHDsp9SRUUTEvM/xW
         8eZNQH4LQ1xMQF+QKvmOTrUEOkhJAawhnVcBa4AXtkyOtitxLX6KAKHstfbJkC+GwUw6
         LY0g==
X-Forwarded-Encrypted: i=1; AJvYcCX7r2utQjyreldElAMzJABCPli3DU63E/1gApR7mPr1yX/0JeVztNsBoviFlPYHvvhIHDyDlKAvlmeHlpyCYS+dhhg5
X-Gm-Message-State: AOJu0YznvsY/NUeKCmPtdrufs+crWctsG0f9WRZYWK8aLolQH3jpjPal
	T0qzSgHt1XQ+9jeBLhwFXZl6Ect5WUw21m4Cjm7QZhQ2+CojPkmxxr71OJyawg==
X-Google-Smtp-Source: AGHT+IHsVDjhqLYz4R4KRsAm/rlIfcBL0hwv/AlVUy4a35ojorEEOv6cI9kzisNnwpCqevT93PAxaQ==
X-Received: by 2002:a17:907:968b:b0:a51:d235:74cf with SMTP id hd11-20020a170907968b00b00a51d23574cfmr1681270ejc.38.1712737876848;
        Wed, 10 Apr 2024 01:31:16 -0700 (PDT)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id ml16-20020a170906cc1000b00a4e670414ffsm6701933ejb.109.2024.04.10.01.31.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Apr 2024 01:31:16 -0700 (PDT)
Date: Wed, 10 Apr 2024 09:31:12 +0100
From: =?utf-8?Q?Pierre-Cl=C3=A9ment?= Tosi <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Vincent Donnefort <vdonnefort@google.com>
Subject: [PATCH v2 11/12] KVM: arm64: nVHE: Support test module for hyp kCFI
Message-ID: <gq2o2iwbb6likzsjko52ple62ub2l5ndwmy7hi23nrjxohusuw@x32vojnmuinr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Extend support for the kCFI test module to nVHE by replicating the hooks
on the KVM_RUN handler path currently existing in VHE in the nVHE code,
exporting the equivalent callback targets for triggering built-in hyp
kCFI faults, and exposing a new CONFIG_HYP_CFI_TEST-only host HVC to
implement callback registration with pKVM.

Update the test module to register the nVHE equivalent callback for test
case '1' (i.e. both EL2 hyp caller and callee are built-in) and document
that other cases are not supported outside of VHE, as they require EL2
symbols in the module, which is not currently supported for nVHE.

Note that a kernel in protected mode that doesn't support HYP_CFI_TEST
will prevent the module from registering nVHE callbacks both by not
exporting the necessary symbols (similar to VHE) but also by rejecting
the corresponding HVC, if the module tries to issue it directly.

Also note that the test module will run in pKVM (with HYP_CFI_TEST)
independently of other debug Kconfig flags but that not stacktrace will
be printed without PROTECTED_NVHE_STACKTRACE. This allows testing kCFI
under conditions closer to release builds, if desired.

Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
---
 arch/arm64/include/asm/kvm_asm.h     |  3 ++
 arch/arm64/include/asm/kvm_cfi.h     |  6 ++--
 arch/arm64/kvm/Kconfig               |  2 --
 arch/arm64/kvm/hyp/{vhe => }/cfi.c   |  0
 arch/arm64/kvm/hyp/nvhe/Makefile     |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c   | 19 ++++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c     |  7 +++++
 arch/arm64/kvm/hyp/vhe/Makefile      |  2 +-
 arch/arm64/kvm/hyp_cfi_test.c        | 44 ++++++++++++++++++++++++----
 arch/arm64/kvm/hyp_cfi_test_module.c | 24 ++++++++-------
 10 files changed, 86 insertions(+), 22 deletions(-)
 rename arch/arm64/kvm/hyp/{vhe => }/cfi.c (100%)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 24b5e6b23417..3256c91ff234 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -81,6 +81,9 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vcpu,
 	__KVM_HOST_SMCCC_FUNC___pkvm_teardown_vm,
+#ifdef CONFIG_HYP_SUPPORTS_CFI_TEST
+	__KVM_HOST_SMCCC_FUNC___kvm_register_cfi_test_cb,
+#endif
 };
 
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
diff --git a/arch/arm64/include/asm/kvm_cfi.h b/arch/arm64/include/asm/kvm_cfi.h
index 13cc7b19d838..ed6422eebce5 100644
--- a/arch/arm64/include/asm/kvm_cfi.h
+++ b/arch/arm64/include/asm/kvm_cfi.h
@@ -12,8 +12,8 @@
 
 #ifdef CONFIG_HYP_SUPPORTS_CFI_TEST
 
-int kvm_cfi_test_register_host_ctxt_cb(void (*cb)(void));
-int kvm_cfi_test_register_guest_ctxt_cb(void (*cb)(void));
+int kvm_cfi_test_register_host_ctxt_cb(void (*vhe_cb)(void), void *nvhe_cb);
+int kvm_cfi_test_register_guest_ctxt_cb(void (*vhe_cb)(void), void *nvhe_cb);
 
 #else
 
@@ -31,6 +31,8 @@ static inline int kvm_cfi_test_register_guest_ctxt_cb(void (*cb)(void))
 
 /* Symbols which the host can register as hyp callbacks; see <hyp/cfi.h>. */
 void hyp_trigger_builtin_cfi_fault(void);
+DECLARE_KVM_NVHE_SYM(hyp_trigger_builtin_cfi_fault);
 void hyp_builtin_cfi_fault_target(int unused);
+DECLARE_KVM_NVHE_SYM(hyp_builtin_cfi_fault_target);
 
 #endif /* __ARM64_KVM_CFI_H__ */
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 5daa8079a120..715c85088c06 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -75,8 +75,6 @@ config HYP_CFI_TEST
 	  Say M here to also build a module which registers callbacks triggering
 	  faults and selected by userspace through its parameters.
 
-	  Note that this feature is currently only supported in VHE mode.
-
 	  If unsure, say N.
 
 config HYP_SUPPORTS_CFI_TEST
diff --git a/arch/arm64/kvm/hyp/vhe/cfi.c b/arch/arm64/kvm/hyp/cfi.c
similarity index 100%
rename from arch/arm64/kvm/hyp/vhe/cfi.c
rename to arch/arm64/kvm/hyp/cfi.c
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 2eb915d8943f..09039d351726 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -25,6 +25,7 @@ hyp-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o
 	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o
 hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
+hyp-obj-$(CONFIG_HYP_SUPPORTS_CFI_TEST) += ../cfi.o
 hyp-obj-$(CONFIG_LIST_HARDENED) += list_debug.o
 hyp-obj-y += $(lib-objs)
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 2385fd03ed87..431860e8a98d 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -5,6 +5,7 @@
  */
 
 #include <hyp/adjust_pc.h>
+#include <hyp/cfi.h>
 
 #include <asm/pgtable-types.h>
 #include <asm/kvm_asm.h>
@@ -13,6 +14,8 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
+#include <linux/compiler.h>
+
 #include <nvhe/ffa.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
@@ -314,6 +317,19 @@ static void handle___pkvm_teardown_vm(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) = __pkvm_teardown_vm(handle);
 }
 
+#ifndef CONFIG_HYP_SUPPORTS_CFI_TEST
+__always_unused
+#endif
+static void handle___kvm_register_cfi_test_cb(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(phys_addr_t, cb_phys, host_ctxt, 1);
+	DECLARE_REG(bool, in_host_ctxt, host_ctxt, 2);
+
+	void (*cb)(void) = cb_phys ? __hyp_va(cb_phys) : NULL;
+
+	cpu_reg(host_ctxt, 1) = __kvm_register_cfi_test_cb(cb, in_host_ctxt);
+}
+
 typedef void (*hcall_t)(struct kvm_cpu_context *);
 
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] = (hcall_t)handle_##x
@@ -348,6 +364,9 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_init_vm),
 	HANDLE_FUNC(__pkvm_init_vcpu),
 	HANDLE_FUNC(__pkvm_teardown_vm),
+#ifdef CONFIG_HYP_SUPPORTS_CFI_TEST
+	HANDLE_FUNC(__kvm_register_cfi_test_cb),
+#endif
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index c50f8459e4fc..160311bf367b 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -4,6 +4,7 @@
  * Author: Marc Zyngier <marc.zyngier@arm.com>
  */
 
+#include <hyp/cfi.h>
 #include <hyp/switch.h>
 #include <hyp/sysreg-sr.h>
 
@@ -253,6 +254,9 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	bool pmu_switch_needed;
 	u64 exit_code;
 
+	if (IS_ENABLED(CONFIG_HYP_SUPPORTS_CFI_TEST) && unlikely(hyp_test_host_ctxt_cfi))
+		hyp_test_host_ctxt_cfi();
+
 	/*
 	 * Having IRQs masked via PMR when entering the guest means the GIC
 	 * will not signal the CPU of interrupts of lower priority, and the
@@ -313,6 +317,9 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	__debug_switch_to_guest(vcpu);
 
+	if (IS_ENABLED(CONFIG_HYP_SUPPORTS_CFI_TEST) && unlikely(hyp_test_guest_ctxt_cfi))
+		hyp_test_guest_ctxt_cfi();
+
 	do {
 		/* Jump in the fire! */
 		exit_code = __guest_enter(vcpu);
diff --git a/arch/arm64/kvm/hyp/vhe/Makefile b/arch/arm64/kvm/hyp/vhe/Makefile
index 19ca584cc21e..951c8c00a685 100644
--- a/arch/arm64/kvm/hyp/vhe/Makefile
+++ b/arch/arm64/kvm/hyp/vhe/Makefile
@@ -9,4 +9,4 @@ ccflags-y := -D__KVM_VHE_HYPERVISOR__
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o
-obj-$(CONFIG_HYP_SUPPORTS_CFI_TEST) += cfi.o
+obj-$(CONFIG_HYP_SUPPORTS_CFI_TEST) += ../cfi.o
diff --git a/arch/arm64/kvm/hyp_cfi_test.c b/arch/arm64/kvm/hyp_cfi_test.c
index da7b25ca1b1f..6a02b43c45f6 100644
--- a/arch/arm64/kvm/hyp_cfi_test.c
+++ b/arch/arm64/kvm/hyp_cfi_test.c
@@ -6,6 +6,7 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_cfi.h>
 #include <asm/kvm_host.h>
+#include <asm/kvm_mmu.h>
 #include <asm/virt.h>
 
 #include <linux/export.h>
@@ -15,29 +16,60 @@
 /* For calling directly into the VHE hypervisor; see <hyp/cfi.h>. */
 int __kvm_register_cfi_test_cb(void (*)(void), bool);
 
-static int kvm_register_cfi_test_cb(void (*vhe_cb)(void), bool in_host_ctxt)
+static int kvm_register_nvhe_cfi_test_cb(void *cb, bool in_host_ctxt)
+{
+	extern void *kvm_nvhe_sym(hyp_test_host_ctxt_cfi);
+	extern void *kvm_nvhe_sym(hyp_test_guest_ctxt_cfi);
+
+	if (is_protected_kvm_enabled()) {
+		phys_addr_t cb_phys = cb ? virt_to_phys(cb) : 0;
+
+		/* Use HVC as only the hyp can modify its callback pointers. */
+		return kvm_call_hyp_nvhe(__kvm_register_cfi_test_cb, cb_phys,
+					 in_host_ctxt);
+	}
+
+	/*
+	 * In non-protected nVHE, the pKVM HVC is not available but the
+	 * hyp callback pointers can be accessed and modified directly.
+	 */
+	if (cb)
+		cb = kern_hyp_va(kvm_ksym_ref(cb));
+
+	if (in_host_ctxt)
+		kvm_nvhe_sym(hyp_test_host_ctxt_cfi) = cb;
+	else
+		kvm_nvhe_sym(hyp_test_guest_ctxt_cfi) = cb;
+
+	return 0;
+}
+
+static int kvm_register_cfi_test_cb(void (*vhe_cb)(void), void *nvhe_cb,
+				    bool in_host_ctxt)
 {
 	if (!is_hyp_mode_available())
 		return -ENXIO;
 
 	if (is_hyp_nvhe())
-		return -EOPNOTSUPP;
+		return kvm_register_nvhe_cfi_test_cb(nvhe_cb, in_host_ctxt);
 
 	return __kvm_register_cfi_test_cb(vhe_cb, in_host_ctxt);
 }
 
-int kvm_cfi_test_register_host_ctxt_cb(void (*cb)(void))
+int kvm_cfi_test_register_host_ctxt_cb(void (*vhe_cb)(void), void *nvhe_cb)
 {
-	return kvm_register_cfi_test_cb(cb, true);
+	return kvm_register_cfi_test_cb(vhe_cb, nvhe_cb, true);
 }
 EXPORT_SYMBOL(kvm_cfi_test_register_host_ctxt_cb);
 
-int kvm_cfi_test_register_guest_ctxt_cb(void (*cb)(void))
+int kvm_cfi_test_register_guest_ctxt_cb(void (*vhe_cb)(void), void *nvhe_cb)
 {
-	return kvm_register_cfi_test_cb(cb, false);
+	return kvm_register_cfi_test_cb(vhe_cb, nvhe_cb, false);
 }
 EXPORT_SYMBOL(kvm_cfi_test_register_guest_ctxt_cb);
 
 /* Hypervisor callbacks for the test module to register. */
 EXPORT_SYMBOL(hyp_trigger_builtin_cfi_fault);
+EXPORT_SYMBOL(kvm_nvhe_sym(hyp_trigger_builtin_cfi_fault));
 EXPORT_SYMBOL(hyp_builtin_cfi_fault_target);
+EXPORT_SYMBOL(kvm_nvhe_sym(hyp_builtin_cfi_fault_target));
diff --git a/arch/arm64/kvm/hyp_cfi_test_module.c b/arch/arm64/kvm/hyp_cfi_test_module.c
index eeda4be4d3ef..63a5e99cb164 100644
--- a/arch/arm64/kvm/hyp_cfi_test_module.c
+++ b/arch/arm64/kvm/hyp_cfi_test_module.c
@@ -20,9 +20,9 @@ static int set_guest_mode(const char *val, const struct kernel_param *kp);
 #define M_DESC \
 	"\n\t0: none" \
 	"\n\t1: built-in caller & built-in callee" \
-	"\n\t2: built-in caller & module callee" \
-	"\n\t3: module caller & built-in callee" \
-	"\n\t4: module caller & module callee"
+	"\n\t2: built-in caller & module callee (VHE only)" \
+	"\n\t3: module caller & built-in callee (VHE only)" \
+	"\n\t4: module caller & module callee (VHE only)"
 
 static unsigned int host_mode;
 module_param_call(host, set_host_mode, param_get_uint, &host_mode, 0644);
@@ -40,7 +40,7 @@ static void hyp_cfi_module2module_test_target(int);
 static void hyp_cfi_builtin2module_test_target(int);
 
 static int set_param_mode(const char *val, const struct kernel_param *kp,
-			 int (*register_cb)(void (*)(void)))
+			 int (*register_cb)(void (*)(void), void *))
 {
 	unsigned int *mode = kp->arg;
 	int err;
@@ -51,15 +51,17 @@ static int set_param_mode(const char *val, const struct kernel_param *kp,
 
 	switch (*mode) {
 	case 0:
-		return register_cb(NULL);
+		return register_cb(NULL, NULL);
 	case 1:
-		return register_cb(hyp_trigger_builtin_cfi_fault);
+		return register_cb(hyp_trigger_builtin_cfi_fault,
+				   kvm_nvhe_sym(hyp_trigger_builtin_cfi_fault));
 	case 2:
-		return register_cb((void *)hyp_cfi_builtin2module_test_target);
+		return register_cb((void *)hyp_cfi_builtin2module_test_target,
+				   NULL);
 	case 3:
-		return register_cb(trigger_module2builtin_cfi_fault);
+		return register_cb(trigger_module2builtin_cfi_fault, NULL);
 	case 4:
-		return register_cb(trigger_module2module_cfi_fault);
+		return register_cb(trigger_module2module_cfi_fault, NULL);
 	default:
 		return -EINVAL;
 	}
@@ -79,11 +81,11 @@ static void __exit exit_hyp_cfi_test(void)
 {
 	int err;
 
-	err = kvm_cfi_test_register_host_ctxt_cb(NULL);
+	err = kvm_cfi_test_register_host_ctxt_cb(NULL, NULL);
 	if (err)
 		pr_err("Failed to unregister host context trigger: %d\n", err);
 
-	err = kvm_cfi_test_register_guest_ctxt_cb(NULL);
+	err = kvm_cfi_test_register_guest_ctxt_cb(NULL, NULL);
 	if (err)
 		pr_err("Failed to unregister guest context trigger: %d\n", err);
 }
-- 
2.44.0.478.gd926399ef9-goog


-- 
Pierre

