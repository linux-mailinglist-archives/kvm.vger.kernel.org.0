Return-Path: <kvm+bounces-57462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C3479B55A22
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 01:29:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EFF791D633F9
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 23:29:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E75328725B;
	Fri, 12 Sep 2025 23:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wOmM0Ugl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6312D94BF
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 23:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757719440; cv=none; b=JxnwXpg0fk81IHXI4Lgkbw63znHVDQQt2inWBD3aMvulQilI+rv3qZHRiNbSSfM5wxC2zPY1Y3eXm2C49VO1ZzPKVIroKJunlTcT4cnxoHW33aLbPDqzDU7NKvlJlyGfQarQgKt26dNBvKhPix79UgvvcpuP12y60DUdrlREIeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757719440; c=relaxed/simple;
	bh=gwXlOd4SESKxTmHEm0aB4LgJNSt6NPVO3zXrQRoLVKc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RMExcLPKqb2p/8BplJWulwQEuiVJgTMVrIIwGxdmVbRAV8Ta0Uh7XZjrQmJmM/NbIEvi/AjnTfltFfWjCbVLhD6Rr97CNP+Cy5MfWXnEkvbnnkEe9hJ8denTHG4AVSctweDFvDIIoIvqhBKqOPmMMkI8IaOmnfCDVqKXAw/Usn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wOmM0Ugl; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b47630f9aa7so1721155a12.1
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 16:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757719438; x=1758324238; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=NBODDyJ8GSHm9DUTRdyGD32HGoXQL/eBjTd3wE/g0ao=;
        b=wOmM0UglJju05SO/ANetoCLgYcP+Me70w8fj43Bf9dW+JDRIRRv47KUxErYo0dSDLr
         N8eGxM8GV3Gx9361xcQyfx+tq+3KC87dmLDITneiT/4ru7j8J9wZpKFGTZ/1U+R3KuVC
         aHlBgIhuedO4g6EBwnxR3F9qJgzCiVQlTpx+dFPt5B+Hk/R3nxtUWJUAgqoi/56+XJNQ
         YoF12hbprNDWgvzwJHi9/W/aPYJv9p25oD54V5yKHgghn5wjooYq/rLGt7OanQcjgx7M
         LgbyNwHUIp6DsqIN8nzpf8DPA1hi/5j2tY6oHZBVhZCv5aXElDbc+w2hbgaNTOuT6w+L
         UKcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757719438; x=1758324238;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NBODDyJ8GSHm9DUTRdyGD32HGoXQL/eBjTd3wE/g0ao=;
        b=a+pxZoMrqTFnhDasddwCXQ9fvsMfJfD3l9gb04kIdD4Gy/hFUl5WOKwfrMOudStAx8
         SVAG+oGd+jFMQmlAeWiJ4u/qslvOTZ4vK999lSV50OHOdXb5vBAOYxwxk28xkhtmv/M7
         LURF+hgbI3blOgnmxYlVmXR1q0mV17iIqZWELGcpHgEU6zij0JHoI6Xi5to3PSEFDm0o
         jZw0Zmt60I6xKIXv5ptlC7JpHJjgZlugXZ6iHDLyU+SWxbMo74XUsI92lsCd/0QFzPMQ
         RkZ8FVML28XXAJ+5sTny+2qAKD/c6DHEM7DI6RPAmLUaBUvqSeMgl45f0IA06ziO+zSX
         GjSA==
X-Gm-Message-State: AOJu0YzIuTP1PdscXSSd037uAw4BWTcaXNwQ+1yTgQXXwD8zv2Dx0a8l
	24ZytWN1BVxv0VtUomcDiFa7eEQY3707GXlNTKWLanv/yz/AdV62tCSNzPMY/YRwDbSem7DfzbH
	K3+HVMg==
X-Google-Smtp-Source: AGHT+IEmt2UXZJnEe1UJtcincpXQTWI5cn6O38exq5yyfl7Cw8nvzEqLFcpb0oUxx5ju7E3P3gaPD70k9rU=
X-Received: from pfst43.prod.google.com ([2002:aa7:8fab:0:b0:772:43b8:ace8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:748d:b0:249:467e:ba57
 with SMTP id adf61e73a8af0-2602a59a02amr5746847637.24.1757719438289; Fri, 12
 Sep 2025 16:23:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Sep 2025 16:22:57 -0700
In-Reply-To: <20250912232319.429659-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250912232319.429659-20-seanjc@google.com>
Subject: [PATCH v15 19/41] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Yang Weijiang <weijiang.yang@intel.com>

Expose CET features to guest if KVM/host can support them, clear CPUID
feature bits if KVM/host cannot support.

Set CPUID feature bits so that CET features are available in guest CPUID.
Add CR4.CET bit support in order to allow guest set CET master control
bit.

Disable KVM CET feature if unrestricted_guest is unsupported/disabled as
KVM does not support emulating CET.

The CET load-bits in VM_ENTRY/VM_EXIT control fields should be set to make
guest CET xstates isolated from host's.

On platforms with VMX_BASIC[bit56] == 0, inject #CP at VMX entry with error
code will fail, and if VMX_BASIC[bit56] == 1, #CP injection with or without
error code is allowed. Disable CET feature bits if the MSR bit is cleared
so that nested VMM can inject #CP if and only if VMX_BASIC[bit56] == 1.

Don't expose CET feature if either of {U,S}_CET xstate bits is cleared
in host XSS or if XSAVES isn't supported.

CET MSRs are reset to 0s after RESET, power-up and INIT, clear guest CET
xsave-area fields so that guest CET MSRs are reset to 0s after the events.

Meanwhile explicitly disable SHSTK and IBT for SVM because CET KVM enabling
for SVM is not ready.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/include/asm/vmx.h      |  1 +
 arch/x86/kvm/cpuid.c            |  2 ++
 arch/x86/kvm/svm/svm.c          |  4 ++++
 arch/x86/kvm/vmx/capabilities.h |  5 +++++
 arch/x86/kvm/vmx/vmx.c          | 30 +++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h          |  6 ++++--
 arch/x86/kvm/x86.c              | 22 +++++++++++++++++++---
 arch/x86/kvm/x86.h              |  3 +++
 9 files changed, 68 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d931d72d23c9..8c106c8c9081 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -142,7 +142,7 @@
 			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
 			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
-			  | X86_CR4_LAM_SUP))
+			  | X86_CR4_LAM_SUP | X86_CR4_CET))
 
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 
diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index ce10a7e2d3d9..c85c50019523 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -134,6 +134,7 @@
 #define VMX_BASIC_DUAL_MONITOR_TREATMENT	BIT_ULL(49)
 #define VMX_BASIC_INOUT				BIT_ULL(54)
 #define VMX_BASIC_TRUE_CTLS			BIT_ULL(55)
+#define VMX_BASIC_NO_HW_ERROR_CODE_CC		BIT_ULL(56)
 
 static inline u32 vmx_basic_vmcs_revision_id(u64 vmx_basic)
 {
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index b5f87254ced7..ee05b876c656 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -944,6 +944,7 @@ void kvm_set_cpu_caps(void)
 		VENDOR_F(WAITPKG),
 		F(SGX_LC),
 		F(BUS_LOCK_DETECT),
+		X86_64_F(SHSTK),
 	);
 
 	/*
@@ -970,6 +971,7 @@ void kvm_set_cpu_caps(void)
 		F(AMX_INT8),
 		F(AMX_BF16),
 		F(FLUSH_L1D),
+		F(IBT),
 	);
 
 	if (boot_cpu_has(X86_FEATURE_AMD_IBPB_RET) &&
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1650de78648a..d4e1fdcf56da 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5223,6 +5223,10 @@ static __init void svm_set_cpu_caps(void)
 	kvm_caps.supported_perf_cap = 0;
 	kvm_caps.supported_xss = 0;
 
+	/* KVM doesn't yet support CET virtualization for SVM. */
+	kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
+	kvm_cpu_cap_clear(X86_FEATURE_IBT);
+
 	/* CPUID 0x80000001 and 0x8000000A (SVM features) */
 	if (nested) {
 		kvm_cpu_cap_set(X86_FEATURE_SVM);
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 7d290b2cb0f4..47b0dec8665a 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -76,6 +76,11 @@ static inline bool cpu_has_vmx_basic_inout(void)
 	return	vmcs_config.basic & VMX_BASIC_INOUT;
 }
 
+static inline bool cpu_has_vmx_basic_no_hw_errcode(void)
+{
+	return	vmcs_config.basic & VMX_BASIC_NO_HW_ERROR_CODE_CC;
+}
+
 static inline bool cpu_has_virtual_nmis(void)
 {
 	return vmcs_config.pin_based_exec_ctrl & PIN_BASED_VIRTUAL_NMIS &&
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e8155635cb42..8d2186d6549f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2615,6 +2615,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		{ VM_ENTRY_LOAD_IA32_EFER,		VM_EXIT_LOAD_IA32_EFER },
 		{ VM_ENTRY_LOAD_BNDCFGS,		VM_EXIT_CLEAR_BNDCFGS },
 		{ VM_ENTRY_LOAD_IA32_RTIT_CTL,		VM_EXIT_CLEAR_IA32_RTIT_CTL },
+		{ VM_ENTRY_LOAD_CET_STATE,		VM_EXIT_LOAD_CET_STATE },
 	};
 
 	memset(vmcs_conf, 0, sizeof(*vmcs_conf));
@@ -4882,6 +4883,14 @@ void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);  /* 22.2.1 */
 
+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
+		vmcs_writel(GUEST_SSP, 0);
+		vmcs_writel(GUEST_INTR_SSP_TABLE, 0);
+	}
+	if (kvm_cpu_cap_has(X86_FEATURE_IBT) ||
+	    kvm_cpu_cap_has(X86_FEATURE_SHSTK))
+		vmcs_writel(GUEST_S_CET, 0);
+
 	kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
 
 	vpid_sync_context(vmx->vpid);
@@ -6349,6 +6358,10 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 	if (vmcs_read32(VM_EXIT_MSR_STORE_COUNT) > 0)
 		vmx_dump_msrs("guest autostore", &vmx->msr_autostore.guest);
 
+	if (vmentry_ctl & VM_ENTRY_LOAD_CET_STATE)
+		pr_err("S_CET = 0x%016lx, SSP = 0x%016lx, SSP TABLE = 0x%016lx\n",
+		       vmcs_readl(GUEST_S_CET), vmcs_readl(GUEST_SSP),
+		       vmcs_readl(GUEST_INTR_SSP_TABLE));
 	pr_err("*** Host State ***\n");
 	pr_err("RIP = 0x%016lx  RSP = 0x%016lx\n",
 	       vmcs_readl(HOST_RIP), vmcs_readl(HOST_RSP));
@@ -6379,6 +6392,10 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 		       vmcs_read64(HOST_IA32_PERF_GLOBAL_CTRL));
 	if (vmcs_read32(VM_EXIT_MSR_LOAD_COUNT) > 0)
 		vmx_dump_msrs("host autoload", &vmx->msr_autoload.host);
+	if (vmexit_ctl & VM_EXIT_LOAD_CET_STATE)
+		pr_err("S_CET = 0x%016lx, SSP = 0x%016lx, SSP TABLE = 0x%016lx\n",
+		       vmcs_readl(HOST_S_CET), vmcs_readl(HOST_SSP),
+		       vmcs_readl(HOST_INTR_SSP_TABLE));
 
 	pr_err("*** Control State ***\n");
 	pr_err("CPUBased=0x%08x SecondaryExec=0x%08x TertiaryExec=0x%016llx\n",
@@ -7963,7 +7980,6 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_UMIP);
 
 	/* CPUID 0xD.1 */
-	kvm_caps.supported_xss = 0;
 	if (!cpu_has_vmx_xsaves())
 		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
 
@@ -7975,6 +7991,18 @@ static __init void vmx_set_cpu_caps(void)
 
 	if (cpu_has_vmx_waitpkg())
 		kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);
+
+	/*
+	 * Disable CET if unrestricted_guest is unsupported as KVM doesn't
+	 * enforce CET HW behaviors in emulator. On platforms with
+	 * VMX_BASIC[bit56] == 0, inject #CP at VMX entry with error code
+	 * fails, so disable CET in this case too.
+	 */
+	if (!cpu_has_load_cet_ctrl() || !enable_unrestricted_guest ||
+	    !cpu_has_vmx_basic_no_hw_errcode()) {
+		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
+		kvm_cpu_cap_clear(X86_FEATURE_IBT);
+	}
 }
 
 static bool vmx_is_io_intercepted(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 24d65dac5e89..08a9a0075404 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -484,7 +484,8 @@ static inline u8 vmx_get_rvi(void)
 	 VM_ENTRY_LOAD_IA32_EFER |					\
 	 VM_ENTRY_LOAD_BNDCFGS |					\
 	 VM_ENTRY_PT_CONCEAL_PIP |					\
-	 VM_ENTRY_LOAD_IA32_RTIT_CTL)
+	 VM_ENTRY_LOAD_IA32_RTIT_CTL |					\
+	 VM_ENTRY_LOAD_CET_STATE)
 
 #define __KVM_REQUIRED_VMX_VM_EXIT_CONTROLS				\
 	(VM_EXIT_SAVE_DEBUG_CONTROLS |					\
@@ -506,7 +507,8 @@ static inline u8 vmx_get_rvi(void)
 	       VM_EXIT_LOAD_IA32_EFER |					\
 	       VM_EXIT_CLEAR_BNDCFGS |					\
 	       VM_EXIT_PT_CONCEAL_PIP |					\
-	       VM_EXIT_CLEAR_IA32_RTIT_CTL)
+	       VM_EXIT_CLEAR_IA32_RTIT_CTL |				\
+	       VM_EXIT_LOAD_CET_STATE)
 
 #define KVM_REQUIRED_VMX_PIN_BASED_VM_EXEC_CONTROL			\
 	(PIN_BASED_EXT_INTR_MASK |					\
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 15f208c44cbd..c78acab2ff3f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -226,7 +226,8 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
  * PT via guest XSTATE would clobber perf state), i.e. KVM doesn't support
  * IA32_XSS[bit 8] (guests can/must use RDMSR/WRMSR to save/restore PT MSRs).
  */
-#define KVM_SUPPORTED_XSS     0
+#define KVM_SUPPORTED_XSS	(XFEATURE_MASK_CET_USER | \
+				 XFEATURE_MASK_CET_KERNEL)
 
 bool __read_mostly allow_smaller_maxphyaddr = 0;
 EXPORT_SYMBOL_GPL(allow_smaller_maxphyaddr);
@@ -10080,6 +10081,20 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
 		kvm_caps.supported_xss = 0;
 
+	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
+	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
+		kvm_caps.supported_xss &= ~(XFEATURE_MASK_CET_USER |
+					    XFEATURE_MASK_CET_KERNEL);
+
+	if ((kvm_caps.supported_xss & (XFEATURE_MASK_CET_USER |
+	     XFEATURE_MASK_CET_KERNEL)) !=
+	    (XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)) {
+		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
+		kvm_cpu_cap_clear(X86_FEATURE_IBT);
+		kvm_caps.supported_xss &= ~(XFEATURE_MASK_CET_USER |
+					    XFEATURE_MASK_CET_KERNEL);
+	}
+
 	if (kvm_caps.has_tsc_control) {
 		/*
 		 * Make sure the user can only configure tsc_khz values that
@@ -12735,10 +12750,11 @@ static void kvm_xstate_reset(struct kvm_vcpu *vcpu, bool init_event)
 	/*
 	 * On INIT, only select XSTATE components are zeroed, most components
 	 * are unchanged.  Currently, the only components that are zeroed and
-	 * supported by KVM are MPX related.
+	 * supported by KVM are MPX and CET related.
 	 */
 	xfeatures_mask = (kvm_caps.supported_xcr0 | kvm_caps.supported_xss) &
-			 (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR);
+			 (XFEATURE_MASK_BNDREGS | XFEATURE_MASK_BNDCSR |
+			  XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL);
 	if (!xfeatures_mask)
 		return;
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 65cbd454c4f1..f3dc77f006f9 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -680,6 +680,9 @@ static inline bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		__reserved_bits |= X86_CR4_PCIDE;       \
 	if (!__cpu_has(__c, X86_FEATURE_LAM))           \
 		__reserved_bits |= X86_CR4_LAM_SUP;     \
+	if (!__cpu_has(__c, X86_FEATURE_SHSTK) &&       \
+	    !__cpu_has(__c, X86_FEATURE_IBT))           \
+		__reserved_bits |= X86_CR4_CET;         \
 	__reserved_bits;                                \
 })
 
-- 
2.51.0.384.g4c02a37b29-goog


