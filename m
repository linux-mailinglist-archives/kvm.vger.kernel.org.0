Return-Path: <kvm+bounces-63113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AE92C5AA7A
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:42:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 7E6CA356146
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:39:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7473330329;
	Thu, 13 Nov 2025 23:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xLzvM7C5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C754330B21
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 23:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763077083; cv=none; b=Y5cLLF+TwOY4anfk6AQCg0njKE8VyrbnAqTqLurvfVjTDUZklUWPJoCnzllyml+ID10KLthjWYnWwd+CzVWlx6oogWGIZrM1qbIy4/iXCR3HoufkJtlMx4kCyO5YGrZt7mE9ZupbvxLHCS4ivDQGipGcVkpNlYAti0l+kKlbXDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763077083; c=relaxed/simple;
	bh=3bPudvKflH3kj1sCX5lS7gg9SOxerbLcCuk66r56odo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jdZig6yF4B6azsEETLHBe1g6XPWMHPyv4YvdLDdhdOcTuVUNwKLFykZ1AtblJVJPzfsXzntmDStKvDpMWaMCAZjy8H2o9qWd6QxLs83Nbz0DTR/A2+UicNuAA/4HVIAF2zBHFNjSzyzlf0kHTUBnGq965fmQQypqO2eYF3YxZR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xLzvM7C5; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b6ce1b57b9cso1353935a12.1
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 15:38:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763077080; x=1763681880; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=y3rOfN+A2/lHkqkN+NclIFJgOCxTEoAd8AT0UopLffg=;
        b=xLzvM7C5p8Bfa70YfOosGWO2YqEo2TO25m9BYoIRc1UtY5SlyoGh55DZYg890Lkz0T
         qOI6SDHA1maewe292Hxof3VlUgg4KnkOChMXzchTn6lV8zuJ1ynlI6jZ32+IMJ8OrD5Q
         lhseLgD9vYRRlqSzO0KKmglPbVNpTDdZLHx2ssMpowtWFmK4kUNfZfjCRqchB8vedP3H
         GCohk1w2vlE36Zm4hOnc0l4X9UJEngA/dHLLd+0/et+aHLn5wgKGZXsm7o9Xf+0oG1IB
         Aj/cB1qUjjIvjzEn1doyz0W0heHKSJufTen+nRlbq32fbAWP/TzMgp5WUMoUbIreqSno
         IJjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763077080; x=1763681880;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y3rOfN+A2/lHkqkN+NclIFJgOCxTEoAd8AT0UopLffg=;
        b=piUNPqkV9yg/zrJS/TCxRVL6uAj80arITD66CdEValhfZB9H5+GOY9CpTGc+9vO2bW
         2IJBnX5oIYxs7HcJVlKW/nio6eo8uN51AmckG3AOdChS91ucqkZX484uomtAT4y3MVOw
         LnaiRkNnZVkp5RxaoUNk88Kf06BjcCJLL2PlpoHF4voG0H5MS6DX/A+aqEfnj8JnqQdg
         IrZbiXMS6JDBnb062d7RYosAxqjKmNJ25dCT4EO8Zma7omBCQGuZeq7YIL/NcjIZ6Fxn
         bVd2rXVf4kWbdAatVnVRYAEi0VGkg9kCuLxo2vBDDOA6U+PPSf7xDZyypmoTpv4M5yzz
         yg8g==
X-Gm-Message-State: AOJu0YzB+IQXLgI443bhzBr1B0MoUlGRrxdo182miG0QojYYWdlGebDa
	byPTk2uiNvoGcg0RMldOy9GkqE/M19RjduDZnPaKhFnWD2m67KP8ww8NNzOhadLYoGVkMt3YlCa
	9SK3Nog==
X-Google-Smtp-Source: AGHT+IHo5gWtbqSMS4jNrTwaSxmrhW8XqrtYH0o1LR1MhEk949gHw6pHVjzl/xb5E5V+ut3YVq9EmercEqI=
X-Received: from pjbha6.prod.google.com ([2002:a17:90a:f3c6:b0:33b:dccb:b328])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2fc3:b0:340:fb6a:cb52
 with SMTP id 98e67ed59e1d1-343fa639820mr979903a91.25.1763077080518; Thu, 13
 Nov 2025 15:38:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 15:37:44 -0800
In-Reply-To: <20251113233746.1703361-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113233746.1703361-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251113233746.1703361-8-seanjc@google.com>
Subject: [PATCH v5 7/9] KVM: VMX: Bundle all L1 data cache flush mitigation
 code together
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"

Move vmx_l1d_flush(), vmx_cleanup_l1d_flush(), and the vmentry_l1d_flush
param code up in vmx.c so that all of the L1 data cache flushing code is
bundled together.  This will allow conditioning the mitigation code on
CONFIG_CPU_MITIGATIONS=y with minimal #ifdefs.

No functional change intended.

Reviewed-by: Brendan Jackman <jackmanb@google.com>
Reviewed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 174 ++++++++++++++++++++---------------------
 1 file changed, 87 insertions(+), 87 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e378bd4d875c..b39e083671bc 100644
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
@@ -352,6 +362,83 @@ static int vmentry_l1d_flush_get(char *s, const struct kernel_param *kp)
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
+static noinstr void vmx_l1d_flush(struct kvm_vcpu *vcpu)
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
+			return;
+	}
+
+	vcpu->stat.l1d_flush++;
+
+	if (static_cpu_has(X86_FEATURE_FLUSH_L1D)) {
+		native_wrmsrq(MSR_IA32_FLUSH_CMD, L1D_FLUSH);
+		return;
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
@@ -404,12 +491,6 @@ static void vmx_update_fb_clear_dis(struct kvm_vcpu *vcpu, struct vcpu_vmx *vmx)
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
@@ -6673,77 +6754,6 @@ int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
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
-static noinstr void vmx_l1d_flush(struct kvm_vcpu *vcpu)
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
-			return;
-	}
-
-	vcpu->stat.l1d_flush++;
-
-	if (static_cpu_has(X86_FEATURE_FLUSH_L1D)) {
-		native_wrmsrq(MSR_IA32_FLUSH_CMD, L1D_FLUSH);
-		return;
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
-}
-
 void vmx_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
@@ -8671,16 +8681,6 @@ __init int vmx_hardware_setup(void)
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
2.52.0.rc1.455.g30608eb744-goog


