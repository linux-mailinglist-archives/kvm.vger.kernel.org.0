Return-Path: <kvm+bounces-58245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C985CB8B7FC
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:38:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9297E3B7EE1
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:38:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E35EA2ECEA9;
	Fri, 19 Sep 2025 22:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gjNZ85FR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBB12EB875
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321219; cv=none; b=rk+EZTzCCeQGAsyEoZuhNnRujClY8eZkLErdG/FgrWJuAUG7cQQHKMX47IMgUMLWiMCj8naLGYp9msHxqUkasvRuwazvgygZU+T9CmOwAFjSC9AKQ1L6FpBPnz5vOUPnyKo3dRytk3yWi9zJV/r10loEqNpQE8VXZxJeYGIJjsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321219; c=relaxed/simple;
	bh=Q70/k7kT3C/xIAA2GvN8tKo5xDe3waYj/eHHxlJ71QE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pEsRc4Sqrh7HtqH8j/G+0eFpcDMfuCBbnpyiCsluVkiueSbDT1YuMgrH7USL+zxcdY5eqIhkfiwpuqffSqLj/rKDMER+s4qckd7kIsuqzISIlbX7lRIgwfKFptkq9CHXtOou4QXmQzdk5AbelSFI4tg8ffcs8WmbjOP8Rr8J480=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gjNZ85FR; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32eae48beaaso2698357a91.0
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321216; x=1758926016; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=AtRSpHI34hOTr14h2nQSWbxYtSYTs8P2X4VzmIFoGGY=;
        b=gjNZ85FRJFJfrKtZ7gHqJpWSzn1oIhKHWOyowPLv/xHxFgIXCeOOL7FiuZCx7ut50P
         W1VAa3ewiOYfFQuDA51Lj2wYeA6TjnvRR7pvhk94jS7ocPL1mX95PB02kod9BkJEhUlA
         N3MRzjKQuwswx1TVRDqgoFaiE2xA5L9TxfmT0Lr+lHKq/j00CARK8B1joJXcyJZQQ2JE
         P2FqPPUGbJ+ajU6KxWNC6zU9RZm7xOotu3zPmm3K8gRycovfe7ZaLohC35r7F503nHbb
         VpvGqfmO7uSiwSsYYaObVQ4BbH5FlEnXe5T3Flzw5tcSMtv+PUiZMjdgnbSKplW2ciiA
         AaDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321216; x=1758926016;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AtRSpHI34hOTr14h2nQSWbxYtSYTs8P2X4VzmIFoGGY=;
        b=LEDbnC9zbFBoPO+4IvR2sl8GG5OhwkNCdKRx0tQQ09WbDN51AelkLopRFbtLZQwvbN
         OM/eq3f8tQzgwASTt5Bz6leYszuM6X1jdZ9KTDqLRakeHsj0pVPaRkW5BJmCHOnXm6MJ
         CiUu6XeA1YCa7YbEkvoyR5PFhSeLv0b1JuZSkWXfi0faEvlmdjbmBYsgLWIeGEvkzxqR
         EMCtdswz9n2XsYElmAuoofUjXuJNUbkDZSPNAng7Do+YewpAPKkTU6iXjYzXN1kpl4EI
         /dFuzXNYWBocsRYjlcsm+U8xHEoNI1xzBRTU9jCoejtSv8vDJgv7OZX+m+cfFZL9YNR4
         ff2A==
X-Gm-Message-State: AOJu0YxwozKgMxZyuQg3CHVsHslAzAZ49R/UGMmNquvvSSIX/aNLm942
	emae07ZTecfRafxVRwrUiKO7UQakuPwgObVrAo8TMKjeaiZkzh0me35TCrbMIWXMlalxe5T+kDD
	j+DSYVQ==
X-Google-Smtp-Source: AGHT+IFXLtgMEwJfJvCkz3ezqcjpkSQU3hEfExnTcdinaUlwRHSERdOcM8Vkmlk4Ob3hgkUERHIIWXSRSy0=
X-Received: from pjbqx3.prod.google.com ([2002:a17:90b:3e43:b0:330:793a:2e77])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5585:b0:330:84dc:d129
 with SMTP id 98e67ed59e1d1-33098387b2bmr5494044a91.36.1758321216510; Fri, 19
 Sep 2025 15:33:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:24 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-18-seanjc@google.com>
Subject: [PATCH v16 17/51] KVM: VMX: Set host constant supervisor states to
 VMCS fields
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

Save constant values to HOST_{S_CET,SSP,INTR_SSP_TABLE} field explicitly.
Kernel IBT is supported and the setting in MSR_IA32_S_CET is static after
post-boot(The exception is BIOS call case but vCPU thread never across it)
and KVM doesn't need to refresh HOST_S_CET field before every VM-Enter/
VM-Exit sequence.

Host supervisor shadow stack is not enabled now and SSP is not accessible
to kernel mode, thus it's safe to set host IA32_INT_SSP_TAB/SSP VMCS field
to 0s. When shadow stack is enabled for CPL3, SSP is reloaded from PL3_SSP
before it exits to userspace. Check SDM Vol 2A/B Chapter 3/4 for SYSCALL/
SYSRET/SYSENTER SYSEXIT/RDSSP/CALL etc.

Prevent KVM module loading if host supervisor shadow stack SHSTK_EN is set
in MSR_IA32_S_CET as KVM cannot co-exit with it correctly.

Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
[sean: snapshot host S_CET if SHSTK *or* IBT is supported]
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/capabilities.h |  4 ++++
 arch/x86/kvm/vmx/vmx.c          | 15 +++++++++++++++
 arch/x86/kvm/x86.c              | 12 ++++++++++++
 arch/x86/kvm/x86.h              |  1 +
 4 files changed, 32 insertions(+)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index f614428dbeda..59c83888bdc0 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -100,6 +100,10 @@ static inline bool cpu_has_load_perf_global_ctrl(void)
 	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
 }
 
+static inline bool cpu_has_load_cet_ctrl(void)
+{
+	return (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_CET_STATE);
+}
 static inline bool cpu_has_vmx_mpx(void)
 {
 	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_BNDCFGS;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5fe4a4b8efb1..a7d9e60b2771 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4325,6 +4325,21 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
 
 	if (cpu_has_load_ia32_efer())
 		vmcs_write64(HOST_IA32_EFER, kvm_host.efer);
+
+	/*
+	 * Supervisor shadow stack is not enabled on host side, i.e.,
+	 * host IA32_S_CET.SHSTK_EN bit is guaranteed to 0 now, per SDM
+	 * description(RDSSP instruction), SSP is not readable in CPL0,
+	 * so resetting the two registers to 0s at VM-Exit does no harm
+	 * to kernel execution. When execution flow exits to userspace,
+	 * SSP is reloaded from IA32_PL3_SSP. Check SDM Vol.2A/B Chapter
+	 * 3 and 4 for details.
+	 */
+	if (cpu_has_load_cet_ctrl()) {
+		vmcs_writel(HOST_S_CET, kvm_host.s_cet);
+		vmcs_writel(HOST_SSP, 0);
+		vmcs_writel(HOST_INTR_SSP_TABLE, 0);
+	}
 }
 
 void set_cr4_guest_host_mask(struct vcpu_vmx *vmx)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fee90388a861..d2cccc7594d4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9997,6 +9997,18 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 		return -EIO;
 	}
 
+	if (boot_cpu_has(X86_FEATURE_SHSTK) || boot_cpu_has(X86_FEATURE_IBT)) {
+		rdmsrq(MSR_IA32_S_CET, kvm_host.s_cet);
+		/*
+		 * Linux doesn't yet support supervisor shadow stacks (SSS), so
+		 * KVM doesn't save/restore the associated MSRs, i.e. KVM may
+		 * clobber the host values.  Yell and refuse to load if SSS is
+		 * unexpectedly enabled, e.g. to avoid crashing the host.
+		 */
+		if (WARN_ON_ONCE(kvm_host.s_cet & CET_SHSTK_EN))
+			return -EIO;
+	}
+
 	memset(&kvm_caps, 0, sizeof(kvm_caps));
 
 	x86_emulator_cache = kvm_alloc_emulator_cache();
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 076eccba0f7e..65cbd454c4f1 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -50,6 +50,7 @@ struct kvm_host_values {
 	u64 efer;
 	u64 xcr0;
 	u64 xss;
+	u64 s_cet;
 	u64 arch_capabilities;
 };
 
-- 
2.51.0.470.ga7dc726c21-goog


