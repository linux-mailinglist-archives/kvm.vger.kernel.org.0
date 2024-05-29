Return-Path: <kvm+bounces-18296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CE458D3620
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 14:15:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 95C04B247AB
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 12:15:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13E7A181CFC;
	Wed, 29 May 2024 12:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zrAneZ4Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86357180A97
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 12:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716984902; cv=none; b=OvQEMWKO5OcA2UW28nvLZD5qeYlWx0addCJNCJy4u801kLBP8+zWPFEj/lMxQ1fnW0B9cpQOfElYIpKgwKwu3a5KChu7Ss91H6GGaa48EWD3JNoTo9JYfL5GBXrCoDIZUQjnDb+PJvbRT9WJY6ikW/yI8IuIVEvorsH2lEKz9+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716984902; c=relaxed/simple;
	bh=aNx67NqhbVPDIwlRTUNci0pmePVybS/Mw7w05xuUt0A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gjCdp578Ix+S/38oEPxJx6GXJdIscBo+N9Y7zlZlwdlJvnQ0lXDXN59q/CyroX/aIPm15aiomNP9Prvb9xGNun6Buwhwsmxjf3DjxAsq2POp3Cm+dbFNEJOZMm2fBGga0LfGpk/u24BryF8uqQNAA41tiBsqIooFzu92HVk+WWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zrAneZ4Q; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-627e7f0ca54so36733497b3.3
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 05:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716984900; x=1717589700; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2WYr4Xqu6SHeaXEynQRTMZNyZEDRWLI9UmjyxKqMZ9M=;
        b=zrAneZ4Qk+554+Sw75n8kBcwekhg2WzBQ0VepyzjZF5oDRVQyR3mkKD6OxxSc8S/CS
         T8XBFENIXjWuH3DnOUGSEz9aYptgZY3Rac7NU8Cc7MYLvb2wYRbBeyC0m44JituWBDjk
         zRF45KOVpSLXvDCZpMO2jEU0kirRV6CJehFsihNpDPcw6wOJztwXgKlVPgm4ONep8YlH
         N+VIbCrcNxQBjlUGYxPhVNUjsECERB1SvzAkAoJRoPFHdfAG/jqOyH7LqUO4K7yTyOVo
         EQeX/2NoP8rIn1Tl1ST+gQVW0puwYuqYP9opPefsD/PSWO8vdnP4zep3jZcQCzEyJ9F8
         MCdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716984900; x=1717589700;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2WYr4Xqu6SHeaXEynQRTMZNyZEDRWLI9UmjyxKqMZ9M=;
        b=UonOkdSV05mzaUu078um3xt8sDYLeXBE0g64RmnVxGIxCsnYJXa3ghpLMzrBTsY7mi
         A1fhMSPM1MDPOiAAF8bUiENG1xOI5+4NI+LhUsFwbSsmPmYXpSQBxCZrRsAbkS+wQslp
         XrkL5UCRxbXeW/3KiCy3qNwdWBUOUd3c4IXjKVYXELrUK62XCqei53W+aDi2doJBanRO
         1nvNW56dX1UpT+nZvQWKFr8v//RdGoCGXRuEmvFXyMKz+VxnMSylJ/k1+xN5IsPIUHs0
         x8ZpZ6c30fY+po1Q5cM3O8SSN1W2XSUSTFCsoUYD3Cp5HOQvXhYOqDqkJw4rlnpv39bL
         SBkw==
X-Forwarded-Encrypted: i=1; AJvYcCUpotVSu6gvH+n9l52bEX7KaOf7G2hTXg/3jBUFCRN9cLGPTsDCx5cVavvaEAeYQv4Wlz7eF8nBaujSD7ykBbKE2YzJ
X-Gm-Message-State: AOJu0Ywv+lZfX/2o6Qj6rHqu0xGA6A3zJo3YKUsF7RY+DKjQsw91zaaC
	SydPSeiAXyMF9BMr6suyaQZxERPdfUoqZ5xP+L+2Oz3f7Xnjy8S6w1DHHDHL3XT/ddzM2IRsnw=
	=
X-Google-Smtp-Source: AGHT+IHHUoIUjFzO4GjkhNWRkyuptnIeiIsPtLJmFaYxcziwtscpK8PJLaAhdGcG5Z1QL/wRAezHUEYegw==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a25:ea14:0:b0:df7:8f43:f8a3 with SMTP id
 3f1490d57ef6-df78f440daemr2830788276.0.1716984899780; Wed, 29 May 2024
 05:14:59 -0700 (PDT)
Date: Wed, 29 May 2024 13:12:19 +0100
In-Reply-To: <20240529121251.1993135-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240529121251.1993135-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240529121251.1993135-14-ptosi@google.com>
Subject: [PATCH v4 13/13] KVM: arm64: nVHE: Support test module for hyp kCFI
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Extend support for the kCFI test module to nVHE by replicating the hooks
on the KVM_RUN handler path currently existing in VHE in the nVHE code,
exporting the equivalent callback targets for triggering built-in hyp
kCFI faults, and exposing a new CONFIG_HYP_CFI_TEST-only host HVC to
implement callback registration.

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

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/include/asm/kvm_asm.h     |  3 ++
 arch/arm64/include/asm/kvm_cfi.h     |  6 ++--
 arch/arm64/kvm/Kconfig               |  2 --
 arch/arm64/kvm/hyp/{vhe =3D> }/cfi.c   |  0
 arch/arm64/kvm/hyp/nvhe/Makefile     |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c   | 19 ++++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c     |  7 +++++
 arch/arm64/kvm/hyp/vhe/Makefile      |  2 +-
 arch/arm64/kvm/hyp_cfi_test.c        | 44 ++++++++++++++++++++++++----
 arch/arm64/kvm/hyp_cfi_test_module.c | 24 ++++++++-------
 10 files changed, 86 insertions(+), 22 deletions(-)
 rename arch/arm64/kvm/hyp/{vhe =3D> }/cfi.c (100%)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_=
asm.h
index a6330460d9e5..791054492920 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -79,6 +79,9 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vcpu,
 	__KVM_HOST_SMCCC_FUNC___pkvm_teardown_vm,
+#ifdef CONFIG_HYP_SUPPORTS_CFI_TEST
+	__KVM_HOST_SMCCC_FUNC___kvm_register_cfi_test_cb,
+#endif
 };
=20
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
diff --git a/arch/arm64/include/asm/kvm_cfi.h b/arch/arm64/include/asm/kvm_=
cfi.h
index 13cc7b19d838..ed6422eebce5 100644
--- a/arch/arm64/include/asm/kvm_cfi.h
+++ b/arch/arm64/include/asm/kvm_cfi.h
@@ -12,8 +12,8 @@
=20
 #ifdef CONFIG_HYP_SUPPORTS_CFI_TEST
=20
-int kvm_cfi_test_register_host_ctxt_cb(void (*cb)(void));
-int kvm_cfi_test_register_guest_ctxt_cb(void (*cb)(void));
+int kvm_cfi_test_register_host_ctxt_cb(void (*vhe_cb)(void), void *nvhe_cb=
);
+int kvm_cfi_test_register_guest_ctxt_cb(void (*vhe_cb)(void), void *nvhe_c=
b);
=20
 #else
=20
@@ -31,6 +31,8 @@ static inline int kvm_cfi_test_register_guest_ctxt_cb(voi=
d (*cb)(void))
=20
 /* Symbols which the host can register as hyp callbacks; see <hyp/cfi.h>. =
*/
 void hyp_trigger_builtin_cfi_fault(void);
+DECLARE_KVM_NVHE_SYM(hyp_trigger_builtin_cfi_fault);
 void hyp_builtin_cfi_fault_target(int unused);
+DECLARE_KVM_NVHE_SYM(hyp_builtin_cfi_fault_target);
=20
 #endif /* __ARM64_KVM_CFI_H__ */
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 5daa8079a120..715c85088c06 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -75,8 +75,6 @@ config HYP_CFI_TEST
 	  Say M here to also build a module which registers callbacks triggering
 	  faults and selected by userspace through its parameters.
=20
-	  Note that this feature is currently only supported in VHE mode.
-
 	  If unsure, say N.
=20
 config HYP_SUPPORTS_CFI_TEST
diff --git a/arch/arm64/kvm/hyp/vhe/cfi.c b/arch/arm64/kvm/hyp/cfi.c
similarity index 100%
rename from arch/arm64/kvm/hyp/vhe/cfi.c
rename to arch/arm64/kvm/hyp/cfi.c
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Mak=
efile
index 782b34b004be..115aa8880260 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -25,6 +25,7 @@ hyp-obj-y :=3D timer-sr.o sysreg-sr.o debug-sr.o switch.o=
 tlb.o hyp-init.o host.o
 	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o
 hyp-obj-y +=3D ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../en=
try.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o
+hyp-obj-$(CONFIG_HYP_SUPPORTS_CFI_TEST) +=3D ../cfi.o
 hyp-obj-$(CONFIG_LIST_HARDENED) +=3D list_debug.o
 hyp-obj-y +=3D $(lib-objs)
=20
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/h=
yp-main.c
index d5c48dc98f67..39ed06fbb190 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -5,6 +5,7 @@
  */
=20
 #include <hyp/adjust_pc.h>
+#include <hyp/cfi.h>
=20
 #include <asm/pgtable-types.h>
 #include <asm/kvm_asm.h>
@@ -13,6 +14,8 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
=20
+#include <linux/compiler.h>
+
 #include <nvhe/ffa.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
@@ -301,6 +304,19 @@ static void handle___pkvm_teardown_vm(struct kvm_cpu_c=
ontext *host_ctxt)
 	cpu_reg(host_ctxt, 1) =3D __pkvm_teardown_vm(handle);
 }
=20
+#ifndef CONFIG_HYP_SUPPORTS_CFI_TEST
+__always_unused
+#endif
+static void handle___kvm_register_cfi_test_cb(struct kvm_cpu_context *host=
_ctxt)
+{
+	DECLARE_REG(phys_addr_t, cb_phys, host_ctxt, 1);
+	DECLARE_REG(bool, in_host_ctxt, host_ctxt, 2);
+
+	void (*cb)(void) =3D cb_phys ? __hyp_va(cb_phys) : NULL;
+
+	cpu_reg(host_ctxt, 1) =3D __kvm_register_cfi_test_cb(cb, in_host_ctxt);
+}
+
 typedef void (*hcall_t)(struct kvm_cpu_context *);
=20
 #define HANDLE_FUNC(x)	[__KVM_HOST_SMCCC_FUNC_##x] =3D (hcall_t)handle_##x
@@ -333,6 +349,9 @@ static const hcall_t host_hcall[] =3D {
 	HANDLE_FUNC(__pkvm_init_vm),
 	HANDLE_FUNC(__pkvm_init_vcpu),
 	HANDLE_FUNC(__pkvm_teardown_vm),
+#ifdef CONFIG_HYP_SUPPORTS_CFI_TEST
+	HANDLE_FUNC(__kvm_register_cfi_test_cb),
+#endif
 };
=20
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/swi=
tch.c
index 6758cd905570..52d2fada9e19 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -4,6 +4,7 @@
  * Author: Marc Zyngier <marc.zyngier@arm.com>
  */
=20
+#include <hyp/cfi.h>
 #include <hyp/switch.h>
 #include <hyp/sysreg-sr.h>
=20
@@ -249,6 +250,9 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	bool pmu_switch_needed;
 	u64 exit_code;
=20
+	if (IS_ENABLED(CONFIG_HYP_SUPPORTS_CFI_TEST) && unlikely(hyp_test_host_ct=
xt_cfi))
+		hyp_test_host_ctxt_cfi();
+
 	/*
 	 * Having IRQs masked via PMR when entering the guest means the GIC
 	 * will not signal the CPU of interrupts of lower priority, and the
@@ -309,6 +313,9 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
=20
 	__debug_switch_to_guest(vcpu);
=20
+	if (IS_ENABLED(CONFIG_HYP_SUPPORTS_CFI_TEST) && unlikely(hyp_test_guest_c=
txt_cfi))
+		hyp_test_guest_ctxt_cfi();
+
 	do {
 		/* Jump in the fire! */
 		exit_code =3D __guest_enter(vcpu);
diff --git a/arch/arm64/kvm/hyp/vhe/Makefile b/arch/arm64/kvm/hyp/vhe/Makef=
ile
index 19ca584cc21e..951c8c00a685 100644
--- a/arch/arm64/kvm/hyp/vhe/Makefile
+++ b/arch/arm64/kvm/hyp/vhe/Makefile
@@ -9,4 +9,4 @@ ccflags-y :=3D -D__KVM_VHE_HYPERVISOR__
 obj-y :=3D timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o
 obj-y +=3D ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.=
o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o
-obj-$(CONFIG_HYP_SUPPORTS_CFI_TEST) +=3D cfi.o
+obj-$(CONFIG_HYP_SUPPORTS_CFI_TEST) +=3D ../cfi.o
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
=20
 #include <linux/export.h>
@@ -15,29 +16,60 @@
 /* For calling directly into the VHE hypervisor; see <hyp/cfi.h>. */
 int __kvm_register_cfi_test_cb(void (*)(void), bool);
=20
-static int kvm_register_cfi_test_cb(void (*vhe_cb)(void), bool in_host_ctx=
t)
+static int kvm_register_nvhe_cfi_test_cb(void *cb, bool in_host_ctxt)
+{
+	extern void *kvm_nvhe_sym(hyp_test_host_ctxt_cfi);
+	extern void *kvm_nvhe_sym(hyp_test_guest_ctxt_cfi);
+
+	if (is_protected_kvm_enabled()) {
+		phys_addr_t cb_phys =3D cb ? virt_to_phys(cb) : 0;
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
+		cb =3D kern_hyp_va(kvm_ksym_ref(cb));
+
+	if (in_host_ctxt)
+		kvm_nvhe_sym(hyp_test_host_ctxt_cfi) =3D cb;
+	else
+		kvm_nvhe_sym(hyp_test_guest_ctxt_cfi) =3D cb;
+
+	return 0;
+}
+
+static int kvm_register_cfi_test_cb(void (*vhe_cb)(void), void *nvhe_cb,
+				    bool in_host_ctxt)
 {
 	if (!is_hyp_mode_available())
 		return -ENXIO;
=20
 	if (is_hyp_nvhe())
-		return -EOPNOTSUPP;
+		return kvm_register_nvhe_cfi_test_cb(nvhe_cb, in_host_ctxt);
=20
 	return __kvm_register_cfi_test_cb(vhe_cb, in_host_ctxt);
 }
=20
-int kvm_cfi_test_register_host_ctxt_cb(void (*cb)(void))
+int kvm_cfi_test_register_host_ctxt_cb(void (*vhe_cb)(void), void *nvhe_cb=
)
 {
-	return kvm_register_cfi_test_cb(cb, true);
+	return kvm_register_cfi_test_cb(vhe_cb, nvhe_cb, true);
 }
 EXPORT_SYMBOL(kvm_cfi_test_register_host_ctxt_cb);
=20
-int kvm_cfi_test_register_guest_ctxt_cb(void (*cb)(void))
+int kvm_cfi_test_register_guest_ctxt_cb(void (*vhe_cb)(void), void *nvhe_c=
b)
 {
-	return kvm_register_cfi_test_cb(cb, false);
+	return kvm_register_cfi_test_cb(vhe_cb, nvhe_cb, false);
 }
 EXPORT_SYMBOL(kvm_cfi_test_register_guest_ctxt_cb);
=20
 /* Hypervisor callbacks for the test module to register. */
 EXPORT_SYMBOL(hyp_trigger_builtin_cfi_fault);
+EXPORT_SYMBOL(kvm_nvhe_sym(hyp_trigger_builtin_cfi_fault));
 EXPORT_SYMBOL(hyp_builtin_cfi_fault_target);
+EXPORT_SYMBOL(kvm_nvhe_sym(hyp_builtin_cfi_fault_target));
diff --git a/arch/arm64/kvm/hyp_cfi_test_module.c b/arch/arm64/kvm/hyp_cfi_=
test_module.c
index eeda4be4d3ef..63a5e99cb164 100644
--- a/arch/arm64/kvm/hyp_cfi_test_module.c
+++ b/arch/arm64/kvm/hyp_cfi_test_module.c
@@ -20,9 +20,9 @@ static int set_guest_mode(const char *val, const struct k=
ernel_param *kp);
 #define M_DESC \
 	"\n\t0: none" \
 	"\n\t1: built-in caller & built-in callee" \
-	"\n\t2: built-in caller & module callee" \
-	"\n\t3: module caller & built-in callee" \
-	"\n\t4: module caller & module callee"
+	"\n\t2: built-in caller & module callee (VHE only)" \
+	"\n\t3: module caller & built-in callee (VHE only)" \
+	"\n\t4: module caller & module callee (VHE only)"
=20
 static unsigned int host_mode;
 module_param_call(host, set_host_mode, param_get_uint, &host_mode, 0644);
@@ -40,7 +40,7 @@ static void hyp_cfi_module2module_test_target(int);
 static void hyp_cfi_builtin2module_test_target(int);
=20
 static int set_param_mode(const char *val, const struct kernel_param *kp,
-			 int (*register_cb)(void (*)(void)))
+			 int (*register_cb)(void (*)(void), void *))
 {
 	unsigned int *mode =3D kp->arg;
 	int err;
@@ -51,15 +51,17 @@ static int set_param_mode(const char *val, const struct=
 kernel_param *kp,
=20
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
=20
-	err =3D kvm_cfi_test_register_host_ctxt_cb(NULL);
+	err =3D kvm_cfi_test_register_host_ctxt_cb(NULL, NULL);
 	if (err)
 		pr_err("Failed to unregister host context trigger: %d\n", err);
=20
-	err =3D kvm_cfi_test_register_guest_ctxt_cb(NULL);
+	err =3D kvm_cfi_test_register_guest_ctxt_cb(NULL, NULL);
 	if (err)
 		pr_err("Failed to unregister guest context trigger: %d\n", err);
 }
--=20
2.45.1.288.g0e0cd299f1-goog


