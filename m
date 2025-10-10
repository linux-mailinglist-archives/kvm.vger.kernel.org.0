Return-Path: <kvm+bounces-59792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 18457BCEA98
	for <lists+kvm@lfdr.de>; Sat, 11 Oct 2025 00:04:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F2F174F2B49
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 22:04:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90A2627602B;
	Fri, 10 Oct 2025 22:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="asHkO5fi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF6B271A94
	for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 22:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760133859; cv=none; b=sQbSqVDStb+OegOWvqXznZBllftTrgiUMlb2dW7kKG32YtWx7pnYZ2u9CT8wo+P6/G1i2H0HIdazR98hGc4OxiG+r1eqCKrz+wFVywO24G6Bh5wHJ+ulXXONztHkdjkbiTtrepqC/W9oGgFbBIK/L/fX7p2julHDasN+7f1PXyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760133859; c=relaxed/simple;
	bh=40XLAfMvzqa0PtcYt/j+pOJSI9YEiYnvHethwkHPql4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i5BSXU17HGThJYJ2wN/5IPxBWjlVPqRIOQ2FlLaOSLsstjysv2YPrAODCm+/lUclEsze/Lyh7umSqBf3Po/TKn1yGKcWROBVk+m3xxg1PRdUzjFTGh2OLScOV1XdOzqnJlXp9j7IMpX540fFW1RPjzcGzblE/+mVCoHKVqd+Ahc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=asHkO5fi; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7811a602576so6240878b3a.0
        for <kvm@vger.kernel.org>; Fri, 10 Oct 2025 15:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760133856; x=1760738656; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wT1MCckAhcLSyUMSrRdpeLiMVOrG2aP1kLlQT+6686Q=;
        b=asHkO5finc2eNEVOVVJryeh6Mr4M9TZP28yl/dsJ3wQTVrrqmTjmoKwBDEIDdolT1u
         bMOw5HJn9y8ziGRMcHwp3yopS5GwBD2OQFFrgqJppQJdmhRF+dSjY4w+DVvrPsgKSxjE
         NiuiXs3HYm4eDhEHGspBP1Uupm3bDOi72E0zJPg47MxUAOvwZBteMMN61Wvj9bHeAWj5
         HmaGecvbnRd5krOrP9Y0brhw70KY/WH52XEL0b6ahbMTvRgXgAHP7hRu4ZXxcT7XOg6c
         f6c25J9YyIdozJQIv9s5pH6tHXDKTkPIjRDSsd08Sfc0hNv2zEOfq/aPdyjcVTY4wTYe
         Ystw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760133856; x=1760738656;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wT1MCckAhcLSyUMSrRdpeLiMVOrG2aP1kLlQT+6686Q=;
        b=PyB3wiW/QJWh55VlMSA/0tKXNjccoHywS1e2pEej0dCKQJFiJtaTmCZj0K5WF2hm3n
         WEZDx1PSJaZQHemvMyGz8xsQZaN+LnsSUfgrOqDoA6qI7BsmRUZ9TCtju2IUZvD/2AuR
         rLTi8Sk0GaQZtob5EAJl/imjHEKSyBdz5Y/WUzwtH48ceD+dXPP9/b7dXfKplwxt6jca
         bB2hwvqAYn0KkhxHt5JsnUschu+tzKqHtFMpcJaD7DujHa7gAHgUcHTv8vV2yQ6KjG7f
         eY6DvoU5zbQfoeX/vkkBR4mLQaMx+W3kfxrsOroVqiLSBpz1JZ0vKRjjpSQabO1lsxkS
         eGng==
X-Forwarded-Encrypted: i=1; AJvYcCUF7LZ+7J7Khi7oZt6aw6FH9GRqOnxaFUpk6ZFJNf3gDEcueiKFMtVzM6/y3hg/4toYV8Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/tWBRU76Ju5aD5l/a+SZBipN4wqbNxLROytfROc9tLayJs55R
	Tg00HI3rm2o/CTgXeUzPfz8kbUKUhwJXYlJlaK5aFqVAvnbyat/XqIlLp31IY2bfKxC4szwXXAF
	UoMNnVg==
X-Google-Smtp-Source: AGHT+IEYZzpCRmily0xghqw82V0v5tJAlP1e88IaqHIGiBa0mG/fhjObsg+dPTBRUD1F9YgVNagUERgbiCI=
X-Received: from pjty5.prod.google.com ([2002:a17:90a:ca85:b0:330:7dd8:2dc2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6d8b:b0:2b5:9c2:c596
 with SMTP id adf61e73a8af0-32da80db37emr18777065637.6.1760133856526; Fri, 10
 Oct 2025 15:04:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Oct 2025 15:04:00 -0700
In-Reply-To: <20251010220403.987927-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251010220403.987927-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.740.g6adb054d12-goog
Message-ID: <20251010220403.987927-3-seanjc@google.com>
Subject: [RFC PATCH 2/4] KVM: x86: Extract VMXON and EFER.SVME enablement to kernel
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"Kirill A. Shutemov" <kas@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Dan Williams <dan.j.williams@intel.com>, Xin Li <xin@zytor.com>, 
	Kai Huang <kai.huang@intel.com>, Adrian Hunter <adrian.hunter@intel.com>
Content-Type: text/plain; charset="UTF-8"

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/events/intel/pt.c    |   1 -
 arch/x86/include/asm/reboot.h |   3 -
 arch/x86/include/asm/virt.h   |  21 +++
 arch/x86/include/asm/vmx.h    |  11 ++
 arch/x86/kernel/cpu/common.c  |   2 +
 arch/x86/kernel/reboot.c      |  11 --
 arch/x86/kvm/svm/svm.c        |  34 +---
 arch/x86/kvm/svm/vmenter.S    |  10 +-
 arch/x86/kvm/vmx/tdx.c        |   3 +-
 arch/x86/kvm/vmx/vmcs.h       |  11 --
 arch/x86/kvm/vmx/vmenter.S    |   2 +-
 arch/x86/kvm/vmx/vmx.c        | 128 +------------
 arch/x86/kvm/x86.c            |  15 +-
 arch/x86/kvm/x86.h            |   1 -
 arch/x86/virt/Makefile        |   2 +
 arch/x86/virt/hw.c            | 327 ++++++++++++++++++++++++++++++++++
 16 files changed, 392 insertions(+), 190 deletions(-)
 create mode 100644 arch/x86/include/asm/virt.h
 create mode 100644 arch/x86/virt/hw.c

diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index e8cf29d2b10c..9092f0f9de72 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -1590,7 +1590,6 @@ void intel_pt_handle_vmx(int on)
 
 	local_irq_restore(flags);
 }
-EXPORT_SYMBOL_GPL(intel_pt_handle_vmx);
 
 /*
  * PMU callbacks
diff --git a/arch/x86/include/asm/reboot.h b/arch/x86/include/asm/reboot.h
index ecd58ea9a837..512733fec370 100644
--- a/arch/x86/include/asm/reboot.h
+++ b/arch/x86/include/asm/reboot.h
@@ -28,11 +28,8 @@ void __noreturn machine_real_restart(unsigned int type);
 typedef void (cpu_emergency_virt_cb)(void);
 #if IS_ENABLED(CONFIG_KVM_X86)
 void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback);
-void cpu_emergency_unregister_virt_callback(cpu_emergency_virt_cb *callback);
 void cpu_emergency_disable_virtualization(void);
 #else
-static inline void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback) {}
-static inline void cpu_emergency_unregister_virt_callback(cpu_emergency_virt_cb *callback) {}
 static inline void cpu_emergency_disable_virtualization(void) {}
 #endif /* CONFIG_KVM_X86 */
 
diff --git a/arch/x86/include/asm/virt.h b/arch/x86/include/asm/virt.h
new file mode 100644
index 000000000000..d691a8532baa
--- /dev/null
+++ b/arch/x86/include/asm/virt.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASM_X86_VIRT_H
+#define _ASM_X86_VIRT_H
+
+#include <asm/reboot.h>
+
+#if IS_ENABLED(CONFIG_KVM_X86)
+extern bool virt_rebooting;
+
+void __init x86_virt_init(void);
+
+int x86_virt_get_cpu(int feat);
+void x86_virt_put_cpu(int feat);
+
+void x86_virt_register_emergency_callback(cpu_emergency_virt_cb *callback);
+void x86_virt_unregister_emergency_callback(cpu_emergency_virt_cb *callback);
+#else
+static __always_inline void x86_virt_init(void) {}
+#endif
+
+#endif /* _ASM_X86_VIRT_H */
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index c85c50019523..d2c7eb1c5f12 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -20,6 +20,17 @@
 #include <asm/trapnr.h>
 #include <asm/vmxfeatures.h>
 
+struct vmcs_hdr {
+	u32 revision_id:31;
+	u32 shadow_vmcs:1;
+};
+
+struct vmcs {
+	struct vmcs_hdr hdr;
+	u32 abort;
+	char data[];
+};
+
 #define VMCS_CONTROL_BIT(x)	BIT(VMX_FEATURE_##x & 0x1f)
 
 /*
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index f98ec9c7fc07..9e10a45f0924 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -70,6 +70,7 @@
 #include <asm/traps.h>
 #include <asm/sev.h>
 #include <asm/tdx.h>
+#include <asm/virt.h>
 #include <asm/posted_intr.h>
 #include <asm/runtime-const.h>
 
@@ -2119,6 +2120,7 @@ static __init void identify_boot_cpu(void)
 	cpu_detect_tlb(&boot_cpu_data);
 	setup_cr_pinning();
 
+	x86_virt_init();
 	tsx_init();
 	tdx_init();
 	lkgs_init();
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 964f6b0a3d68..ed7b3fa0d995 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -541,17 +541,6 @@ void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback)
 
 	rcu_assign_pointer(cpu_emergency_virt_callback, callback);
 }
-EXPORT_SYMBOL_GPL(cpu_emergency_register_virt_callback);
-
-void cpu_emergency_unregister_virt_callback(cpu_emergency_virt_cb *callback)
-{
-	if (WARN_ON_ONCE(rcu_access_pointer(cpu_emergency_virt_callback) != callback))
-		return;
-
-	rcu_assign_pointer(cpu_emergency_virt_callback, NULL);
-	synchronize_rcu();
-}
-EXPORT_SYMBOL_GPL(cpu_emergency_unregister_virt_callback);
 
 /*
  * Disable virtualization, i.e. VMX or SVM, to ensure INIT is recognized during
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 153c12dbf3eb..183894732d0e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -44,6 +44,7 @@
 #include <asm/traps.h>
 #include <asm/reboot.h>
 #include <asm/fpu/api.h>
+#include <asm/virt.h>
 
 #include <trace/events/ipi.h>
 
@@ -473,27 +474,11 @@ static __always_inline struct sev_es_save_area *sev_es_host_save_area(struct svm
 	return &sd->save_area->host_sev_es_save;
 }
 
-static inline void kvm_cpu_svm_disable(void)
-{
-	uint64_t efer;
-
-	wrmsrq(MSR_VM_HSAVE_PA, 0);
-	rdmsrq(MSR_EFER, efer);
-	if (efer & EFER_SVME) {
-		/*
-		 * Force GIF=1 prior to disabling SVM, e.g. to ensure INIT and
-		 * NMI aren't blocked.
-		 */
-		stgi();
-		wrmsrq(MSR_EFER, efer & ~EFER_SVME);
-	}
-}
-
 static void svm_emergency_disable_virtualization_cpu(void)
 {
-	kvm_rebooting = true;
+	virt_rebooting = true;
 
-	kvm_cpu_svm_disable();
+	wrmsrq(MSR_VM_HSAVE_PA, 0);
 }
 
 static void svm_disable_virtualization_cpu(void)
@@ -502,7 +487,7 @@ static void svm_disable_virtualization_cpu(void)
 	if (tsc_scaling)
 		__svm_write_tsc_multiplier(SVM_TSC_RATIO_DEFAULT);
 
-	kvm_cpu_svm_disable();
+	x86_virt_put_cpu(X86_FEATURE_SVM);
 
 	amd_pmu_disable_virt();
 }
@@ -511,12 +496,12 @@ static int svm_enable_virtualization_cpu(void)
 {
 
 	struct svm_cpu_data *sd;
-	uint64_t efer;
 	int me = raw_smp_processor_id();
+	int r;
 
-	rdmsrq(MSR_EFER, efer);
-	if (efer & EFER_SVME)
-		return -EBUSY;
+	r = x86_virt_get_cpu(X86_FEATURE_SVM);
+	if (r)
+		return r;
 
 	sd = per_cpu_ptr(&svm_data, me);
 	sd->asid_generation = 1;
@@ -524,8 +509,6 @@ static int svm_enable_virtualization_cpu(void)
 	sd->next_asid = sd->max_asid + 1;
 	sd->min_asid = max_sev_asid + 1;
 
-	wrmsrq(MSR_EFER, efer | EFER_SVME);
-
 	wrmsrq(MSR_VM_HSAVE_PA, sd->save_area_pa);
 
 	if (static_cpu_has(X86_FEATURE_TSCRATEMSR)) {
@@ -536,7 +519,6 @@ static int svm_enable_virtualization_cpu(void)
 		__svm_write_tsc_multiplier(SVM_TSC_RATIO_DEFAULT);
 	}
 
-
 	/*
 	 * Get OSVW bits.
 	 *
diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 235c4af6b692..c61cd7830751 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -269,16 +269,16 @@ SYM_FUNC_START(__svm_vcpu_run)
 	RESTORE_GUEST_SPEC_CTRL_BODY
 	RESTORE_HOST_SPEC_CTRL_BODY (%_ASM_SP)
 
-10:	cmpb $0, _ASM_RIP(kvm_rebooting)
+10:	cmpb $0, _ASM_RIP(virt_rebooting)
 	jne 2b
 	ud2
-30:	cmpb $0, _ASM_RIP(kvm_rebooting)
+30:	cmpb $0, _ASM_RIP(virt_rebooting)
 	jne 4b
 	ud2
-50:	cmpb $0, _ASM_RIP(kvm_rebooting)
+50:	cmpb $0, _ASM_RIP(virt_rebooting)
 	jne 6b
 	ud2
-70:	cmpb $0, _ASM_RIP(kvm_rebooting)
+70:	cmpb $0, _ASM_RIP(virt_rebooting)
 	jne 8b
 	ud2
 
@@ -365,7 +365,7 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	RESTORE_GUEST_SPEC_CTRL_BODY
 	RESTORE_HOST_SPEC_CTRL_BODY %sil
 
-3:	cmpb $0, kvm_rebooting(%rip)
+3:	cmpb $0, virt_rebooting(%rip)
 	jne 2b
 	ud2
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 097304bf1e1d..bbf5ee7ec6ba 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -6,6 +6,7 @@
 #include <linux/misc_cgroup.h>
 #include <linux/mmu_context.h>
 #include <asm/tdx.h>
+#include <asm/virt.h>
 #include "capabilities.h"
 #include "mmu.h"
 #include "x86_ops.h"
@@ -2069,7 +2070,7 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 	 * TDX_SEAMCALL_VMFAILINVALID.
 	 */
 	if (unlikely((vp_enter_ret & TDX_SW_ERROR) == TDX_SW_ERROR)) {
-		KVM_BUG_ON(!kvm_rebooting, vcpu->kvm);
+		KVM_BUG_ON(!virt_rebooting, vcpu->kvm);
 		goto unhandled_exit;
 	}
 
diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index b25625314658..2ab6ade006c7 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -13,17 +13,6 @@
 
 #define ROL16(val, n) ((u16)(((u16)(val) << (n)) | ((u16)(val) >> (16 - (n)))))
 
-struct vmcs_hdr {
-	u32 revision_id:31;
-	u32 shadow_vmcs:1;
-};
-
-struct vmcs {
-	struct vmcs_hdr hdr;
-	u32 abort;
-	char data[];
-};
-
 DECLARE_PER_CPU(struct vmcs *, current_vmcs);
 
 /*
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 0a6cf5bff2aa..476b65362a6f 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -293,7 +293,7 @@ SYM_INNER_LABEL_ALIGN(vmx_vmexit, SYM_L_GLOBAL)
 	RET
 
 .Lfixup:
-	cmpb $0, _ASM_RIP(kvm_rebooting)
+	cmpb $0, _ASM_RIP(virt_rebooting)
 	jne .Lvmfail
 	ud2
 .Lvmfail:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 546272a5d34d..229abfa13836 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -49,6 +49,7 @@
 #include <asm/msr.h>
 #include <asm/mwait.h>
 #include <asm/spec-ctrl.h>
+#include <asm/virt.h>
 #include <asm/vmx.h>
 
 #include <trace/events/ipi.h>
@@ -468,7 +469,6 @@ noinline void invept_error(unsigned long ext, u64 eptp)
 	vmx_insn_failed("invept failed: ext=0x%lx eptp=%llx\n", ext, eptp);
 }
 
-static DEFINE_PER_CPU(struct vmcs *, vmxarea);
 DEFINE_PER_CPU(struct vmcs *, current_vmcs);
 /*
  * We maintain a per-CPU linked-list of VMCS loaded on that CPU. This is needed
@@ -675,44 +675,13 @@ static int vmx_set_guest_uret_msr(struct vcpu_vmx *vmx,
 	return ret;
 }
 
-/*
- * Disable VMX and clear CR4.VMXE (even if VMXOFF faults)
- *
- * Note, VMXOFF causes a #UD if the CPU is !post-VMXON, but it's impossible to
- * atomically track post-VMXON state, e.g. this may be called in NMI context.
- * Eat all faults as all other faults on VMXOFF faults are mode related, i.e.
- * faults are guaranteed to be due to the !post-VMXON check unless the CPU is
- * magically in RM, VM86, compat mode, or at CPL>0.
- */
-static int kvm_cpu_vmxoff(void)
-{
-	asm goto("1: vmxoff\n\t"
-			  _ASM_EXTABLE(1b, %l[fault])
-			  ::: "cc", "memory" : fault);
-
-	cr4_clear_bits(X86_CR4_VMXE);
-	return 0;
-
-fault:
-	cr4_clear_bits(X86_CR4_VMXE);
-	return -EIO;
-}
-
 void vmx_emergency_disable_virtualization_cpu(void)
 {
 	int cpu = raw_smp_processor_id();
 	struct loaded_vmcs *v;
 
-	kvm_rebooting = true;
-
-	/*
-	 * Note, CR4.VMXE can be _cleared_ in NMI context, but it can only be
-	 * set in task context.  If this races with VMX is disabled by an NMI,
-	 * VMCLEAR and VMXOFF may #UD, but KVM will eat those faults due to
-	 * kvm_rebooting set.
-	 */
-	if (!(__read_cr4() & X86_CR4_VMXE))
-		return;
+	WARN_ON_ONCE(!virt_rebooting);
+	virt_rebooting = true;
 
 	list_for_each_entry(v, &per_cpu(loaded_vmcss_on_cpu, cpu),
 			    loaded_vmcss_on_cpu_link) {
@@ -720,8 +689,6 @@ void vmx_emergency_disable_virtualization_cpu(void)
 		if (v->shadow_vmcs)
 			vmcs_clear(v->shadow_vmcs);
 	}
-
-	kvm_cpu_vmxoff();
 }
 
 static void __loaded_vmcs_clear(void *arg)
@@ -2819,34 +2786,9 @@ int vmx_check_processor_compat(void)
 	return 0;
 }
 
-static int kvm_cpu_vmxon(u64 vmxon_pointer)
-{
-	u64 msr;
-
-	cr4_set_bits(X86_CR4_VMXE);
-
-	asm goto("1: vmxon %[vmxon_pointer]\n\t"
-			  _ASM_EXTABLE(1b, %l[fault])
-			  : : [vmxon_pointer] "m"(vmxon_pointer)
-			  : : fault);
-	return 0;
-
-fault:
-	WARN_ONCE(1, "VMXON faulted, MSR_IA32_FEAT_CTL (0x3a) = 0x%llx\n",
-		  rdmsrq_safe(MSR_IA32_FEAT_CTL, &msr) ? 0xdeadbeef : msr);
-	cr4_clear_bits(X86_CR4_VMXE);
-
-	return -EFAULT;
-}
-
 int vmx_enable_virtualization_cpu(void)
 {
 	int cpu = raw_smp_processor_id();
-	u64 phys_addr = __pa(per_cpu(vmxarea, cpu));
-	int r;
-
-	if (cr4_read_shadow() & X86_CR4_VMXE)
-		return -EBUSY;
 
 	/*
 	 * This can happen if we hot-added a CPU but failed to allocate
@@ -2855,15 +2797,7 @@ int vmx_enable_virtualization_cpu(void)
 	if (kvm_is_using_evmcs() && !hv_get_vp_assist_page(cpu))
 		return -EFAULT;
 
-	intel_pt_handle_vmx(1);
-
-	r = kvm_cpu_vmxon(phys_addr);
-	if (r) {
-		intel_pt_handle_vmx(0);
-		return r;
-	}
-
-	return 0;
+	return x86_virt_get_cpu(X86_FEATURE_VMX);
 }
 
 static void vmclear_local_loaded_vmcss(void)
@@ -2880,12 +2814,9 @@ void vmx_disable_virtualization_cpu(void)
 {
 	vmclear_local_loaded_vmcss();
 
-	if (kvm_cpu_vmxoff())
-		kvm_spurious_fault();
+	x86_virt_put_cpu(X86_FEATURE_VMX);
 
 	hv_reset_evmcs();
-
-	intel_pt_handle_vmx(0);
 }
 
 struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags)
@@ -2963,47 +2894,6 @@ int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
 	return -ENOMEM;
 }
 
-static void free_kvm_area(void)
-{
-	int cpu;
-
-	for_each_possible_cpu(cpu) {
-		free_vmcs(per_cpu(vmxarea, cpu));
-		per_cpu(vmxarea, cpu) = NULL;
-	}
-}
-
-static __init int alloc_kvm_area(void)
-{
-	int cpu;
-
-	for_each_possible_cpu(cpu) {
-		struct vmcs *vmcs;
-
-		vmcs = alloc_vmcs_cpu(false, cpu, GFP_KERNEL);
-		if (!vmcs) {
-			free_kvm_area();
-			return -ENOMEM;
-		}
-
-		/*
-		 * When eVMCS is enabled, alloc_vmcs_cpu() sets
-		 * vmcs->revision_id to KVM_EVMCS_VERSION instead of
-		 * revision_id reported by MSR_IA32_VMX_BASIC.
-		 *
-		 * However, even though not explicitly documented by
-		 * TLFS, VMXArea passed as VMXON argument should
-		 * still be marked with revision_id reported by
-		 * physical CPU.
-		 */
-		if (kvm_is_using_evmcs())
-			vmcs->hdr.revision_id = vmx_basic_vmcs_revision_id(vmcs_config.basic);
-
-		per_cpu(vmxarea, cpu) = vmcs;
-	}
-	return 0;
-}
-
 static void fix_pmode_seg(struct kvm_vcpu *vcpu, int seg,
 		struct kvm_segment *save)
 {
@@ -8328,8 +8218,6 @@ void vmx_hardware_unsetup(void)
 
 	if (nested)
 		nested_vmx_hardware_unsetup();
-
-	free_kvm_area();
 }
 
 void vmx_vm_destroy(struct kvm *kvm)
@@ -8634,10 +8522,6 @@ __init int vmx_hardware_setup(void)
 			return r;
 	}
 
-	r = alloc_kvm_area();
-	if (r && nested)
-		nested_vmx_hardware_unsetup();
-
 	kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
 
 	/*
@@ -8663,7 +8547,7 @@ __init int vmx_hardware_setup(void)
 
 	kvm_caps.inapplicable_quirks &= ~KVM_X86_QUIRK_IGNORE_GUEST_PAT;
 
-	return r;
+	return 0;
 }
 
 static void vmx_cleanup_l1d_flush(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 910a51370768..9cfed304035f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -84,6 +84,8 @@
 #include <asm/intel_pt.h>
 #include <asm/emulate_prefix.h>
 #include <asm/sgx.h>
+#include <asm/virt.h>
+
 #include <clocksource/hyperv_timer.h>
 
 #define CREATE_TRACE_POINTS
@@ -705,9 +707,6 @@ static void drop_user_return_notifiers(void)
 		kvm_on_user_return(&msrs->urn);
 }
 
-__visible bool kvm_rebooting;
-EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_rebooting);
-
 /*
  * Handle a fault on a hardware virtualization (VMX or SVM) instruction.
  *
@@ -718,7 +717,7 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_rebooting);
 noinstr void kvm_spurious_fault(void)
 {
 	/* Fault while not rebooting.  We want the trace. */
-	BUG_ON(!kvm_rebooting);
+	BUG_ON(!virt_rebooting);
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_spurious_fault);
 
@@ -12975,12 +12974,12 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_vcpu_deliver_sipi_vector);
 
 void kvm_arch_enable_virtualization(void)
 {
-	cpu_emergency_register_virt_callback(kvm_x86_ops.emergency_disable_virtualization_cpu);
+	x86_virt_register_emergency_callback(kvm_x86_ops.emergency_disable_virtualization_cpu);
 }
 
 void kvm_arch_disable_virtualization(void)
 {
-	cpu_emergency_unregister_virt_callback(kvm_x86_ops.emergency_disable_virtualization_cpu);
+	x86_virt_unregister_emergency_callback(kvm_x86_ops.emergency_disable_virtualization_cpu);
 }
 
 int kvm_arch_enable_virtualization_cpu(void)
@@ -13082,11 +13081,11 @@ int kvm_arch_enable_virtualization_cpu(void)
 void kvm_arch_shutdown(void)
 {
 	/*
-	 * Set kvm_rebooting to indicate that KVM has asynchronously disabled
+	 * Set virt_rebooting to indicate that KVM has asynchronously disabled
 	 * hardware virtualization, i.e. that relevant errors and exceptions
 	 * aren't entirely unexpected.
 	 */
-	kvm_rebooting = true;
+	virt_rebooting = true;
 }
 
 void kvm_arch_disable_virtualization_cpu(void)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index d2ebe3232f55..f3dc77f006f9 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -54,7 +54,6 @@ struct kvm_host_values {
 	u64 arch_capabilities;
 };
 
-extern bool kvm_rebooting;
 void kvm_spurious_fault(void);
 
 #define SIZE_OF_MEMSLOTS_HASHTABLE \
diff --git a/arch/x86/virt/Makefile b/arch/x86/virt/Makefile
index ea343fc392dc..6e485751650c 100644
--- a/arch/x86/virt/Makefile
+++ b/arch/x86/virt/Makefile
@@ -1,2 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-y	+= svm/ vmx/
+
+obj-$(subst m,y,$(CONFIG_KVM_X86)) += hw.o
\ No newline at end of file
diff --git a/arch/x86/virt/hw.c b/arch/x86/virt/hw.c
new file mode 100644
index 000000000000..12e59cd3da2d
--- /dev/null
+++ b/arch/x86/virt/hw.c
@@ -0,0 +1,327 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/cpu.h>
+#include <linux/cpumask.h>
+#include <linux/errno.h>
+#include <linux/kvm_types.h>
+#include <linux/list.h>
+#include <linux/percpu.h>
+
+#include <asm/perf_event.h>
+#include <asm/processor.h>
+#include <asm/virt.h>
+#include <asm/vmx.h>
+
+static bool x86_virt_initialized __ro_after_init;
+
+__visible bool virt_rebooting;
+EXPORT_SYMBOL_GPL(virt_rebooting);
+
+static DEFINE_PER_CPU(int, virtualization_nr_users);
+
+static cpu_emergency_virt_cb __rcu *kvm_emergency_callback;
+
+void x86_virt_register_emergency_callback(cpu_emergency_virt_cb *callback)
+{
+	if (WARN_ON_ONCE(rcu_access_pointer(kvm_emergency_callback)))
+		return;
+
+	rcu_assign_pointer(kvm_emergency_callback, callback);
+}
+EXPORT_SYMBOL_FOR_MODULES(x86_virt_register_emergency_callback, "kvm");
+
+void x86_virt_unregister_emergency_callback(cpu_emergency_virt_cb *callback)
+{
+	if (WARN_ON_ONCE(rcu_access_pointer(kvm_emergency_callback) != callback))
+		return;
+
+	rcu_assign_pointer(kvm_emergency_callback, NULL);
+	synchronize_rcu();
+}
+EXPORT_SYMBOL_FOR_MODULES(x86_virt_unregister_emergency_callback, "kvm");
+
+static void x86_virt_invoke_kvm_emergency_callback(void)
+{
+	cpu_emergency_virt_cb *kvm_callback;
+
+	kvm_callback = rcu_dereference(kvm_emergency_callback);
+	if (kvm_callback)
+		kvm_callback();
+}
+
+#if IS_ENABLED(CONFIG_KVM_INTEL)
+static DEFINE_PER_CPU(struct vmcs *, root_vmcs);
+
+static int x86_virt_cpu_vmxon(void)
+{
+	u64 vmxon_pointer = __pa(per_cpu(root_vmcs, raw_smp_processor_id()));
+	u64 msr;
+
+	cr4_set_bits(X86_CR4_VMXE);
+
+	asm goto("1: vmxon %[vmxon_pointer]\n\t"
+			  _ASM_EXTABLE(1b, %l[fault])
+			  : : [vmxon_pointer] "m"(vmxon_pointer)
+			  : : fault);
+	return 0;
+
+fault:
+	WARN_ONCE(1, "VMXON faulted, MSR_IA32_FEAT_CTL (0x3a) = 0x%llx\n",
+		  rdmsrq_safe(MSR_IA32_FEAT_CTL, &msr) ? 0xdeadbeef : msr);
+	cr4_clear_bits(X86_CR4_VMXE);
+
+	return -EFAULT;
+}
+
+static int x86_vmx_get_cpu(void)
+{
+	int r;
+
+	if (cr4_read_shadow() & X86_CR4_VMXE)
+		return -EBUSY;
+
+	intel_pt_handle_vmx(1);
+
+	r = x86_virt_cpu_vmxon();
+	if (r) {
+		intel_pt_handle_vmx(0);
+		return r;
+	}
+
+	return 0;
+}
+
+/*
+ * Disable VMX and clear CR4.VMXE (even if VMXOFF faults)
+ *
+ * Note, VMXOFF causes a #UD if the CPU is !post-VMXON, but it's impossible to
+ * atomically track post-VMXON state, e.g. this may be called in NMI context.
+ * Eat all faults as all other faults on VMXOFF faults are mode related, i.e.
+ * faults are guaranteed to be due to the !post-VMXON check unless the CPU is
+ * magically in RM, VM86, compat mode, or at CPL>0.
+ */
+static int x86_vmx_cpu_vmxoff(void)
+{
+	asm goto("1: vmxoff\n\t"
+		 _ASM_EXTABLE(1b, %l[fault])
+		 ::: "cc", "memory" : fault);
+
+	cr4_clear_bits(X86_CR4_VMXE);
+	return 0;
+
+fault:
+	cr4_clear_bits(X86_CR4_VMXE);
+	return -EIO;
+}
+
+static void x86_vmx_put_cpu(void)
+{
+	if (x86_vmx_cpu_vmxoff())
+		BUG_ON(!virt_rebooting);
+
+	intel_pt_handle_vmx(0);
+}
+
+static void x86_vmx_emergency_disable_virtualization_cpu(void)
+{
+	virt_rebooting = true;
+
+	/*
+	 * Note, CR4.VMXE can be _cleared_ in NMI context, but it can only be
+	 * set in task context.  If this races with VMX being disabled via NMI,
+	 * VMCLEAR and VMXOFF may #UD, but the kernel will eat those faults due
+	 * to virt_rebooting being set.
+	 */
+	if (!(__read_cr4() & X86_CR4_VMXE))
+		return;
+
+	x86_virt_invoke_kvm_emergency_callback();
+
+	x86_vmx_cpu_vmxoff();
+}
+
+static __init void x86_vmx_exit(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		free_page((unsigned long)per_cpu(root_vmcs, cpu));
+		per_cpu(root_vmcs, cpu) = NULL;
+	}
+}
+
+static __init cpu_emergency_virt_cb *x86_vmx_init(void)
+{
+	u64 basic_msr;
+	u32 rev_id;
+	int cpu;
+
+	rdmsrq(MSR_IA32_VMX_BASIC, basic_msr);
+
+	/* IA-32 SDM Vol 3B: VMCS size is never greater than 4kB. */
+	if (WARN_ON_ONCE(vmx_basic_vmcs_size(basic_msr) > PAGE_SIZE))
+		return NULL;
+
+	/*
+	 * Even if eVMCS is enabled (or will be enabled?), and even though not
+	 * explicitly documented by TLFS, the root VMCS  passed to VMXON should
+	 * still be marked with the revision_id reported by the physical CPU.
+	 */
+	rev_id = vmx_basic_vmcs_revision_id(basic_msr);
+
+	for_each_possible_cpu(cpu) {
+		int node = cpu_to_node(cpu);
+		struct page *page;
+		struct vmcs *vmcs;
+
+		page = __alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO , 0);
+		if (!page) {
+			x86_vmx_exit();
+			return NULL;
+		}
+
+		vmcs = page_address(page);
+		vmcs->hdr.revision_id = rev_id;
+		per_cpu(root_vmcs, cpu) = vmcs;
+	}
+
+	return x86_vmx_emergency_disable_virtualization_cpu;
+}
+#else
+static int x86_vmx_get_cpu(void) { BUILD_BUG_ON(1); return -EOPNOTSUPP; }
+static void x86_vmx_put_cpu(void) { BUILD_BUG_ON(1); }
+static __init cpu_emergency_virt_cb *x86_vmx_init(void) { BUILD_BUG_ON(1); return NULL; }
+#endif
+
+#if IS_ENABLED(CONFIG_KVM_AMD)
+static int x86_svm_get_cpu(void)
+{
+	u64 efer;
+
+	rdmsrq(MSR_EFER, efer);
+	if (efer & EFER_SVME)
+		return -EBUSY;
+
+	wrmsrq(MSR_EFER, efer | EFER_SVME);
+	return 0;
+}
+
+static void x86_svm_put_cpu(void)
+{
+	u64 efer;
+
+	rdmsrq(MSR_EFER, efer);
+	if (efer & EFER_SVME) {
+		/*
+		 * Force GIF=1 prior to disabling SVM, e.g. to ensure INIT and
+		 * NMI aren't blocked.
+		 */
+		asm goto("1: stgi\n\t"
+			 _ASM_EXTABLE(1b, %l[fault])
+			 ::: "memory" : fault);
+		wrmsrq(MSR_EFER, efer & ~EFER_SVME);
+	}
+	return;
+
+fault:
+	wrmsrq(MSR_EFER, efer & ~EFER_SVME);
+	BUG_ON(!virt_rebooting);
+}
+static void x86_svm_emergency_disable_virtualization_cpu(void)
+{
+	virt_rebooting = true;
+
+	/*
+	 * Note, CR4.VMXE can be _cleared_ in NMI context, but it can only be
+	 * set in task context.  If this races with VMX being disabled via NMI,
+	 * VMCLEAR and VMXOFF may #UD, but the kernel will eat those faults due
+	 * to virt_rebooting being set.
+	 */
+	if (!(__read_cr4() & X86_CR4_VMXE))
+		return;
+
+	x86_virt_invoke_kvm_emergency_callback();
+
+	x86_svm_put_cpu();
+}
+static __init cpu_emergency_virt_cb *x86_svm_init(void)
+{
+	return x86_svm_emergency_disable_virtualization_cpu;
+}
+#else
+static int x86_svm_get_cpu(void) { BUILD_BUG_ON(1); return -EOPNOTSUPP; }
+static void x86_svm_put_cpu(void) { BUILD_BUG_ON(1); }
+static __init cpu_emergency_virt_cb *x86_svm_init(void) { BUILD_BUG_ON(1); return NULL; }
+#endif
+
+static __always_inline bool x86_virt_is_vmx(void)
+{
+	return IS_ENABLED(CONFIG_KVM_INTEL) &&
+	       cpu_feature_enabled(X86_FEATURE_VMX);
+}
+
+static __always_inline bool x86_virt_is_svm(void)
+{
+	return IS_ENABLED(CONFIG_KVM_AMD) &&
+	       cpu_feature_enabled(X86_FEATURE_SVM);
+}
+
+int x86_virt_get_cpu(int feat)
+{
+	int r;
+
+	if (!x86_virt_initialized)
+		return -EOPNOTSUPP;
+
+	if (this_cpu_inc_return(virtualization_nr_users) > 1)
+		return 0;
+
+	if (x86_virt_is_vmx() && feat == X86_FEATURE_VMX)
+		r = x86_vmx_get_cpu();
+	else if (x86_virt_is_svm() && feat == X86_FEATURE_SVM)
+		r = x86_svm_get_cpu();
+	else
+		r = -EOPNOTSUPP;
+
+	if (r)
+		WARN_ON_ONCE(this_cpu_dec_return(virtualization_nr_users));
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(x86_virt_get_cpu);
+
+void x86_virt_put_cpu(int feat)
+{
+	if (WARN_ON_ONCE(!this_cpu_read(virtualization_nr_users)))
+		return;
+
+	if (this_cpu_dec_return(virtualization_nr_users) && !virt_rebooting)
+		return;
+
+	if (x86_virt_is_vmx() && feat == X86_FEATURE_VMX)
+		x86_vmx_put_cpu();
+	else if (x86_virt_is_svm() && feat == X86_FEATURE_SVM)
+		x86_svm_put_cpu();
+	else
+		WARN_ON_ONCE(1);
+}
+EXPORT_SYMBOL_GPL(x86_virt_put_cpu);
+
+void __init x86_virt_init(void)
+{
+	cpu_emergency_virt_cb *vmx_cb = NULL, *svm_cb = NULL;
+
+	if (x86_virt_is_vmx())
+		vmx_cb = x86_vmx_init();
+
+	if (x86_virt_is_svm())
+		svm_cb = x86_svm_init();
+
+	if (!vmx_cb && !svm_cb)
+		return;
+
+	if (WARN_ON_ONCE(vmx_cb && svm_cb))
+		return;
+
+	cpu_emergency_register_virt_callback(vmx_cb ? : svm_cb);
+	x86_virt_initialized = true;
+}
-- 
2.51.0.740.g6adb054d12-goog


