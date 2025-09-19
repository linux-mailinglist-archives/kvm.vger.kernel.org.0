Return-Path: <kvm+bounces-58256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 744C6B8B838
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:41:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3433DA037F2
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:41:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AE3D2D8384;
	Fri, 19 Sep 2025 22:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w56vZVoe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5450F2FC879
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321237; cv=none; b=AAbnFyIZ+PC6hx4ny4BCl2IdAV+N0XFFXwx1edyoqU/bLjlrPk69BYkDQu8758WLrrLfEerj/2D9xa/k75Hsqnlmo9dvqF+QvtpE0d/Cxlqtwkq14ZvVsddi/cLfah3KyGZGwkd+zFQq+idTF13I1MjtUz0YydQlSW23sCdraWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321237; c=relaxed/simple;
	bh=H85izHo3sM6kNkmT1jTPpHBNMJmymsnKRWYhCXf1xIQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rtKtfRqBodMFk6+Vb/nJdrc0F+NBiwksH7eqx4AGeQhcn2s2kBGLPKc8Mryxbn8nDQbs3LQnbrMdn06wuF3A8zqtvt+6SjbqdLpoG5dYFr45FsZMgAvxX0sa8IHUl49T9QOMeeTTdgmuGn3dAEet3AEFeNzLRTQEA6tyIzwd2cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w56vZVoe; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24ca417fb41so26512755ad.1
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321235; x=1758926035; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=PjK5+Yt+wjh8VShHpuKoKCtX5MZ19p55Nm6f0snPAks=;
        b=w56vZVoenyKCclyorDg9e9tyS218pPHL4xT1MHrtabRmtukWMBy/tosrL19uEDdmE3
         RQubKiLp0ZHiZr8/zNF1ifUZXdNfFjVznlLoczYKlrbe2wYLIPAcBh0AL4AGFFgpzwVd
         uReFVRlL8ESlYc4RGxr2GjR1uoosC9wUdqFZK4EK222jCqk3O0eOAWTPQpr3o9tEh0XJ
         Mpo/XHzSMJME1fOgPIoibdtVjszzPRPrqsoiIGo9tNcHFQ+Z/4USf8g/XLdEvvt8hxtw
         R6stVGquatqB2lQJte+m+fKyDaYsWIApOWx4yaakh7W+1mqy+mifXNTR89aK5OWcTWIM
         +u4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321235; x=1758926035;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PjK5+Yt+wjh8VShHpuKoKCtX5MZ19p55Nm6f0snPAks=;
        b=MKQYwoxAzGKwdGenuVqV24JJSh+M5Wv+cffp+kRq641qsvs3WDLe9yW9dmG4zwtrYe
         FDTmZfnsf/MCZWerne9vbk2gMFDA4NeLPQC4JvmJgJOb4jpFuTm+iqHfXdo+o0zGM+3a
         Oa79OCs0TkZT74nqzoF35urQqLmwBoHlVFAWif/yz/BQfIbwXnBX67vLuWJAuXoxPPYl
         G2EB3rLobK9EkZrWbuHHkQvxeVpnEaFDIqosAB2GOtiAA2UniB1fKSxX8Y6OUoqS4tif
         QelMRw/bWFewcRwA69ycCLs2qGmDe+54uzn7cwV4tYTISd+ckbcXDpcr8PPRZ7xATMM0
         vVIQ==
X-Gm-Message-State: AOJu0YzYbCby5uTKBPDNfFHQzlu1vtJKzibdIXzXk2uDbywSutqkfE31
	yDgMweAbKr4nj4t1BAU0lf0wX8+o7kVS7gZmevPryrGSG13ep1gpYPYVl3onYPD6eTAkFD24So0
	mDq8Q7g==
X-Google-Smtp-Source: AGHT+IH7oW74ad5r7dOGMu9LUzDr9y7Upw5+k1X7yrhcCg7TokB+Tkp43mKDPjj87CuGA4qb8Q9yBtJXo5I=
X-Received: from pjbsf15.prod.google.com ([2002:a17:90b:51cf:b0:325:220a:dd41])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:db12:b0:251:493c:43e3
 with SMTP id d9443c01a7336-269ba516161mr66907895ad.31.1758321234774; Fri, 19
 Sep 2025 15:33:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:35 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-29-seanjc@google.com>
Subject: [PATCH v16 28/51] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

From: Yang Weijiang <weijiang.yang@intel.com>

Add support for the LOAD_CET_STATE VM-Enter and VM-Exit controls, the
CET XFEATURE bits in XSS, and  advertise support for IBT and SHSTK to
userspace.  Explicitly clear IBT and SHSTK onn SVM, as additional work is
needed to enable CET on SVM, e.g. to context switch S_CET and other state.

Disable KVM CET feature if unrestricted_guest is unsupported/disabled as
KVM does not support emulating CET, as running without Unrestricted Guest
can result in KVM emulating large swaths of guest code.  While it's highly
unlikely any guest will trigger emulation while also utilizing IBT or
SHSTK, there's zero reason to allow CET without Unrestricted Guest as that
combination should only be possible when explicitly disabling
unrestricted_guest for testing purposes.

Disable CET if VMX_BASIC[bit56] == 0, i.e. if hardware strictly enforces
the presence of an Error Code based on exception vector, as attempting to
inject a #CP with an Error Code (#CP architecturally has an Error Code)
will fail due to the #CP vector historically not having an Error Code.

Clear S_CET and SSP-related VMCS on "reset" to emulate the architectural
of CET MSRs and SSP being reset to 0 after RESET, power-up and INIT.  Note,
KVM already clears guest CET state that is managed via XSTATE in
kvm_xstate_reset().

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
[sean: move some bits to separate patches, massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/vmx.h      |  1 +
 arch/x86/kvm/cpuid.c            |  2 ++
 arch/x86/kvm/svm/svm.c          |  4 ++++
 arch/x86/kvm/vmx/capabilities.h |  5 +++++
 arch/x86/kvm/vmx/vmx.c          | 30 +++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h          |  6 ++++--
 6 files changed, 45 insertions(+), 3 deletions(-)

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
index b5c4cb13630c..b861a88083e1 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -946,6 +946,7 @@ void kvm_set_cpu_caps(void)
 		VENDOR_F(WAITPKG),
 		F(SGX_LC),
 		F(BUS_LOCK_DETECT),
+		X86_64_F(SHSTK),
 	);
 
 	/*
@@ -990,6 +991,7 @@ void kvm_set_cpu_caps(void)
 		F(AMX_INT8),
 		F(AMX_BF16),
 		F(FLUSH_L1D),
+		F(IBT),
 	);
 
 	if (boot_cpu_has(X86_FEATURE_AMD_IBPB_RET) &&
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 67f4eed01526..73dde1645e46 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5221,6 +5221,10 @@ static __init void svm_set_cpu_caps(void)
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
index 59c83888bdc0..02aadb9d730e 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -73,6 +73,11 @@ static inline bool cpu_has_vmx_basic_inout(void)
 	return	vmcs_config.basic & VMX_BASIC_INOUT;
 }
 
+static inline bool cpu_has_vmx_basic_no_hw_errcode_cc(void)
+{
+	return	vmcs_config.basic & VMX_BASIC_NO_HW_ERROR_CODE_CC;
+}
+
 static inline bool cpu_has_virtual_nmis(void)
 {
 	return vmcs_config.pin_based_exec_ctrl & PIN_BASED_VIRTUAL_NMIS &&
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a7d9e60b2771..69e35440cee7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2615,6 +2615,7 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		{ VM_ENTRY_LOAD_IA32_EFER,		VM_EXIT_LOAD_IA32_EFER },
 		{ VM_ENTRY_LOAD_BNDCFGS,		VM_EXIT_CLEAR_BNDCFGS },
 		{ VM_ENTRY_LOAD_IA32_RTIT_CTL,		VM_EXIT_CLEAR_IA32_RTIT_CTL },
+		{ VM_ENTRY_LOAD_CET_STATE,		VM_EXIT_LOAD_CET_STATE },
 	};
 
 	memset(vmcs_conf, 0, sizeof(*vmcs_conf));
@@ -4881,6 +4882,14 @@ void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
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
@@ -6348,6 +6357,10 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 	if (vmcs_read32(VM_EXIT_MSR_STORE_COUNT) > 0)
 		vmx_dump_msrs("guest autostore", &vmx->msr_autostore.guest);
 
+	if (vmentry_ctl & VM_ENTRY_LOAD_CET_STATE)
+		pr_err("S_CET = 0x%016lx, SSP = 0x%016lx, SSP TABLE = 0x%016lx\n",
+		       vmcs_readl(GUEST_S_CET), vmcs_readl(GUEST_SSP),
+		       vmcs_readl(GUEST_INTR_SSP_TABLE));
 	pr_err("*** Host State ***\n");
 	pr_err("RIP = 0x%016lx  RSP = 0x%016lx\n",
 	       vmcs_readl(HOST_RIP), vmcs_readl(HOST_RSP));
@@ -6378,6 +6391,10 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 		       vmcs_read64(HOST_IA32_PERF_GLOBAL_CTRL));
 	if (vmcs_read32(VM_EXIT_MSR_LOAD_COUNT) > 0)
 		vmx_dump_msrs("host autoload", &vmx->msr_autoload.host);
+	if (vmexit_ctl & VM_EXIT_LOAD_CET_STATE)
+		pr_err("S_CET = 0x%016lx, SSP = 0x%016lx, SSP TABLE = 0x%016lx\n",
+		       vmcs_readl(HOST_S_CET), vmcs_readl(HOST_SSP),
+		       vmcs_readl(HOST_INTR_SSP_TABLE));
 
 	pr_err("*** Control State ***\n");
 	pr_err("CPUBased=0x%08x SecondaryExec=0x%08x TertiaryExec=0x%016llx\n",
@@ -7959,7 +7976,6 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_UMIP);
 
 	/* CPUID 0xD.1 */
-	kvm_caps.supported_xss = 0;
 	if (!cpu_has_vmx_xsaves())
 		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
 
@@ -7971,6 +7987,18 @@ static __init void vmx_set_cpu_caps(void)
 
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
+	    !cpu_has_vmx_basic_no_hw_errcode_cc()) {
+		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
+		kvm_cpu_cap_clear(X86_FEATURE_IBT);
+	}
 }
 
 static bool vmx_is_io_intercepted(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 23d6e89b96f2..af8224e074ee 100644
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
-- 
2.51.0.470.ga7dc726c21-goog


