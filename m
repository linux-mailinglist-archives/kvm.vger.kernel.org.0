Return-Path: <kvm+bounces-60222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 99B80BE54FA
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 22:05:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 310724E904F
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 20:05:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDF4521FF2E;
	Thu, 16 Oct 2025 20:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xOtfLLRt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561272DF149
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 20:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760645067; cv=none; b=QSAYjkAVC1erF6uB9oHHmpQNhclFhSlnYs4/MyWDefnK5x1rm873yM0SocAQP6qPdpcTXCDLNBPwweQj3oxBqk2dPl8Vt+Xd6k9TNwPQUN5neB73GaB6WWc2gOdM8uQpSSfCSlr+VR+th8W8WPXyOHL82fpVIl5QdaFROrPTPpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760645067; c=relaxed/simple;
	bh=yuk7NvONUNQVlqggvv8ub6LxWOfiyoba45LlVODNDco=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eZbjp791TPqCLUItwf9aBBdC+QZ1KH338L3oiz33e1y5uGhkOJdHAN9lsKHUyJV57Brj0U41w/DbdlxV/O03VMhEwNCjCsw6WTUKGqVr4wPRLCvUXF2EZevrJ0LjFUAZ1v1smNqI53ypR2dcOCjS4flmuJtaKx1KnSAa76wcMf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xOtfLLRt; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33baf262850so1164028a91.0
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 13:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760645064; x=1761249864; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=U+jp/+XcfRH9dOuRvA/UXEBka06Rhza6HVdo0nGfOSo=;
        b=xOtfLLRt2fBi5/Gb7417Lofc3CGHTyNFn2EUf+hJlAvh/ERuzcdjQ/iRbXPGwmCDkC
         boDk6DaDGHUPTuyNHL4iNbUmskrsLIZfVEzvpnM+7gEw/CagIeEs+ytc6oGzFUAHuVn3
         hw+bdyK5q1C3hwcexzpLCYYNRhbUJ1lIrsSluHIguAdNEZTRConvTPoN7hKROMVaIbXz
         jsnHaF1gRnDlbKczrFkl2A1QTejruNYniCqIoGBFO3AFulBaqFcL331GX0Gfn3mPGPNN
         z3ztL1W9pPcp7nkh4y9NBtUaGkjklOuAD96HKxMzkL+0N5R8BPWhUBDq9z9xUdmZBNLY
         qoNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760645064; x=1761249864;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U+jp/+XcfRH9dOuRvA/UXEBka06Rhza6HVdo0nGfOSo=;
        b=N4mEkyPfBNgJWz9KGdomrmLB0RiXfpOv2A1FyPJ0g94RQy6/XLPHxresZqBJPjcw+i
         Piz6lWSbXNhBgG0yMCZCzxVTIGxtpnRwuVA0ogRwr9E9NV6I28u2Ud04GoqzosS4iYbt
         OFGUKcZEs2eighDNtK/AdpAGDsNJKUaSuxVxOolfzp7ZFJOtBCNx3gd3pswnPAf0jB9V
         ogk2HInjQClkhQ+l3l+CPuaJ3ur5kptrQVwT5xIcv/ODic4tFp6sanr2lIyBFU9BM5Ka
         hpeaJzOOtol6v9RqLyOUoJzQeZMuaUI5JhRoZFyFOqAfCW0SZFdhBZ05MSHha6zvxTth
         nHCw==
X-Gm-Message-State: AOJu0Yz6XkcWTaUAK/YdskjroHy2Z5sjtvSSlCORI8nsi37bzMmf9ztW
	h4/Bb/zO+WT/aOE2sM/cEe9f/MNlHb0jGTMba1ha7XkYcDEtlU6x/KDstfIgxDw0EZ8q0No1O0M
	U3FEr4w==
X-Google-Smtp-Source: AGHT+IH2nM7xybmdxyLC9czVkjZPXYctCesmDVEcR7IkWRJE94Mg7Obq1GtFksq5gUVDT9p0d9taLBI5DcE=
X-Received: from pjkm8.prod.google.com ([2002:a17:90a:7308:b0:33b:a0cd:53ed])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3506:b0:33b:c5de:6a54
 with SMTP id 98e67ed59e1d1-33bcf8e9795mr1055685a91.23.1760645064449; Thu, 16
 Oct 2025 13:04:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 13:04:15 -0700
In-Reply-To: <20251016200417.97003-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251016200417.97003-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251016200417.97003-3-seanjc@google.com>
Subject: [PATCH v3 2/4] KVM: VMX: Bundle all L1 data cache flush mitigation
 code together
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"

Move vmx_l1d_flush(), vmx_cleanup_l1d_flush(), and the vmentry_l1d_flush
param code up in vmx.c so that all of the L1 data cache flushing code is
bundled together.  This will allow conditioning the mitigation code on
CONFIG_CPU_MITIGATIONS=y with minimal #ifdefs.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 176 ++++++++++++++++++++---------------------
 1 file changed, 88 insertions(+), 88 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ce556d5dc39b..cd8ae1b2ae55 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -302,6 +302,16 @@ static int vmx_setup_l1d_flush(enum vmx_l1d_flush_state l1tf)
 	return 0;
 }
 
+static void vmx_cleanup_l1d_flush(void)
+{
+	if (vmx_l1d_flush_pages) {
+		free_pages((unsigned long)vmx_l1d_flush_pages, L1D_CACHE_ORDER);
+		vmx_l1d_flush_pages = NULL;
+	}
+	/* Restore state so sysfs ignores VMX */
+	l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_AUTO;
+}
+
 static int vmentry_l1d_flush_parse(const char *s)
 {
 	unsigned int i;
@@ -352,6 +362,84 @@ static int vmentry_l1d_flush_get(char *s, const struct kernel_param *kp)
 	return sysfs_emit(s, "%s\n", vmentry_l1d_param[l1tf_vmx_mitigation].option);
 }
 
+/*
+ * Software based L1D cache flush which is used when microcode providing
+ * the cache control MSR is not loaded.
+ *
+ * The L1D cache is 32 KiB on Nehalem and later microarchitectures, but to
+ * flush it is required to read in 64 KiB because the replacement algorithm
+ * is not exactly LRU. This could be sized at runtime via topology
+ * information but as all relevant affected CPUs have 32KiB L1D cache size
+ * there is no point in doing so.
+ */
+static noinstr bool vmx_l1d_flush(struct kvm_vcpu *vcpu)
+{
+	int size = PAGE_SIZE << L1D_CACHE_ORDER;
+
+	/*
+	 * This code is only executed when the flush mode is 'cond' or
+	 * 'always'
+	 */
+	if (static_branch_likely(&vmx_l1d_flush_cond)) {
+		bool flush_l1d;
+
+		/*
+		 * Clear the per-vcpu flush bit, it gets set again if the vCPU
+		 * is reloaded, i.e. if the vCPU is scheduled out or if KVM
+		 * exits to userspace, or if KVM reaches one of the unsafe
+		 * VMEXIT handlers, e.g. if KVM calls into the emulator.
+		 */
+		flush_l1d = vcpu->arch.l1tf_flush_l1d;
+		vcpu->arch.l1tf_flush_l1d = false;
+
+		/*
+		 * Clear the per-cpu flush bit, it gets set again from
+		 * the interrupt handlers.
+		 */
+		flush_l1d |= kvm_get_cpu_l1tf_flush_l1d();
+		kvm_clear_cpu_l1tf_flush_l1d();
+
+		if (!flush_l1d)
+			return false;
+	}
+
+	vcpu->stat.l1d_flush++;
+
+	if (static_cpu_has(X86_FEATURE_FLUSH_L1D)) {
+		native_wrmsrq(MSR_IA32_FLUSH_CMD, L1D_FLUSH);
+		return true;
+	}
+
+	asm volatile(
+		/* First ensure the pages are in the TLB */
+		"xorl	%%eax, %%eax\n"
+		".Lpopulate_tlb:\n\t"
+		"movzbl	(%[flush_pages], %%" _ASM_AX "), %%ecx\n\t"
+		"addl	$4096, %%eax\n\t"
+		"cmpl	%%eax, %[size]\n\t"
+		"jne	.Lpopulate_tlb\n\t"
+		"xorl	%%eax, %%eax\n\t"
+		"cpuid\n\t"
+		/* Now fill the cache */
+		"xorl	%%eax, %%eax\n"
+		".Lfill_cache:\n"
+		"movzbl	(%[flush_pages], %%" _ASM_AX "), %%ecx\n\t"
+		"addl	$64, %%eax\n\t"
+		"cmpl	%%eax, %[size]\n\t"
+		"jne	.Lfill_cache\n\t"
+		"lfence\n"
+		:: [flush_pages] "r" (vmx_l1d_flush_pages),
+		    [size] "r" (size)
+		: "eax", "ebx", "ecx", "edx");
+	return true;
+}
+
+static const struct kernel_param_ops vmentry_l1d_flush_ops = {
+	.set = vmentry_l1d_flush_set,
+	.get = vmentry_l1d_flush_get,
+};
+module_param_cb(vmentry_l1d_flush, &vmentry_l1d_flush_ops, NULL, 0644);
+
 static __always_inline void vmx_disable_fb_clear(struct vcpu_vmx *vmx)
 {
 	u64 msr;
@@ -404,12 +492,6 @@ static void vmx_update_fb_clear_dis(struct kvm_vcpu *vcpu, struct vcpu_vmx *vmx)
 		vmx->disable_fb_clear = false;
 }
 
-static const struct kernel_param_ops vmentry_l1d_flush_ops = {
-	.set = vmentry_l1d_flush_set,
-	.get = vmentry_l1d_flush_get,
-};
-module_param_cb(vmentry_l1d_flush, &vmentry_l1d_flush_ops, NULL, 0644);
-
 static u32 vmx_segment_access_rights(struct kvm_segment *var);
 
 void vmx_vmexit(void);
@@ -6653,78 +6735,6 @@ int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	return ret;
 }
 
-/*
- * Software based L1D cache flush which is used when microcode providing
- * the cache control MSR is not loaded.
- *
- * The L1D cache is 32 KiB on Nehalem and later microarchitectures, but to
- * flush it is required to read in 64 KiB because the replacement algorithm
- * is not exactly LRU. This could be sized at runtime via topology
- * information but as all relevant affected CPUs have 32KiB L1D cache size
- * there is no point in doing so.
- */
-static noinstr bool vmx_l1d_flush(struct kvm_vcpu *vcpu)
-{
-	int size = PAGE_SIZE << L1D_CACHE_ORDER;
-
-	/*
-	 * This code is only executed when the flush mode is 'cond' or
-	 * 'always'
-	 */
-	if (static_branch_likely(&vmx_l1d_flush_cond)) {
-		bool flush_l1d;
-
-		/*
-		 * Clear the per-vcpu flush bit, it gets set again if the vCPU
-		 * is reloaded, i.e. if the vCPU is scheduled out or if KVM
-		 * exits to userspace, or if KVM reaches one of the unsafe
-		 * VMEXIT handlers, e.g. if KVM calls into the emulator.
-		 */
-		flush_l1d = vcpu->arch.l1tf_flush_l1d;
-		vcpu->arch.l1tf_flush_l1d = false;
-
-		/*
-		 * Clear the per-cpu flush bit, it gets set again from
-		 * the interrupt handlers.
-		 */
-		flush_l1d |= kvm_get_cpu_l1tf_flush_l1d();
-		kvm_clear_cpu_l1tf_flush_l1d();
-
-		if (!flush_l1d)
-			return false;
-	}
-
-	vcpu->stat.l1d_flush++;
-
-	if (static_cpu_has(X86_FEATURE_FLUSH_L1D)) {
-		native_wrmsrq(MSR_IA32_FLUSH_CMD, L1D_FLUSH);
-		return true;
-	}
-
-	asm volatile(
-		/* First ensure the pages are in the TLB */
-		"xorl	%%eax, %%eax\n"
-		".Lpopulate_tlb:\n\t"
-		"movzbl	(%[flush_pages], %%" _ASM_AX "), %%ecx\n\t"
-		"addl	$4096, %%eax\n\t"
-		"cmpl	%%eax, %[size]\n\t"
-		"jne	.Lpopulate_tlb\n\t"
-		"xorl	%%eax, %%eax\n\t"
-		"cpuid\n\t"
-		/* Now fill the cache */
-		"xorl	%%eax, %%eax\n"
-		".Lfill_cache:\n"
-		"movzbl	(%[flush_pages], %%" _ASM_AX "), %%ecx\n\t"
-		"addl	$64, %%eax\n\t"
-		"cmpl	%%eax, %[size]\n\t"
-		"jne	.Lfill_cache\n\t"
-		"lfence\n"
-		:: [flush_pages] "r" (vmx_l1d_flush_pages),
-		    [size] "r" (size)
-		: "eax", "ebx", "ecx", "edx");
-	return true;
-}
-
 void vmx_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
@@ -8673,16 +8683,6 @@ __init int vmx_hardware_setup(void)
 	return r;
 }
 
-static void vmx_cleanup_l1d_flush(void)
-{
-	if (vmx_l1d_flush_pages) {
-		free_pages((unsigned long)vmx_l1d_flush_pages, L1D_CACHE_ORDER);
-		vmx_l1d_flush_pages = NULL;
-	}
-	/* Restore state so sysfs ignores VMX */
-	l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_AUTO;
-}
-
 void vmx_exit(void)
 {
 	allow_smaller_maxphyaddr = false;
-- 
2.51.0.858.gf9c4a03a3a-goog


