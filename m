Return-Path: <kvm+bounces-61628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE4B7C22C97
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 01:32:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6382D3A9025
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 00:32:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BB361DE2AD;
	Fri, 31 Oct 2025 00:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oCTn32W1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047E4221DB0
	for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 00:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761870659; cv=none; b=nGmv0LTKJJtD7iZ5TbyMQDRyvGfFKwQUANqNZh6sNCpVzTNc/2l9jkOLh6zhPJ5c755qhztHbLt7c22/UdCtKs5GnNVX0B8alYQMyuY8UI6B+PFBVnYC8/qJa3sKj0HIhmVeYN5eencOvv2Um/ocWBhWi1mRPEvbOa3C/Pcx5XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761870659; c=relaxed/simple;
	bh=aYmWXaoH1i80BGqIeHrFdG1O1IAKwSd0+UKfWgjlogw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=S7LbQEHEcfOoil6KtrXkoCRDZit3X5UohLssBWKCaWnK7ATmKCI+R1LfbKGDrt1bWJbmJxe+ocBNkrm7lkSd8OLsIzotldknKSJUeGXnUntnJypJt7+FYGzvd5DYrLqf8QOPGF9lE1Z8CeBDyZWr5wBRuAcXHOfLOEoRYybZ5lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oCTn32W1; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33dadf7c5beso1573064a91.0
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 17:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761870657; x=1762475457; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=J+Ez2liootURycULRis0r6eLUgh70ESz5qK4iYDo4pQ=;
        b=oCTn32W1jqkTitewuU21G+lhT9OlsOvRgtAazaIHQKntZ/VR/pSE1pk5NVGVEcnBXo
         w9U11bKgLCdVTz01IRRpR5H2GpF016H1Cn5epgI6xxQekayzv0OWkOy6g7j6qwAWb6RX
         yHpypVtdyjYYM/iJt51UNIn35RaCVsERKnGWNbIVnw+bQKnS/x60gBzS+vmQd8qDJr8Y
         qmiJKuTvbIf1+MLAf+11PlUb4jR2SmdpEB/AzUQpl8QSrJnnbOZ03JG1+y/zOLg6nNZd
         U1jgI0mYkl2aWdRNQS6fvbqgR67kK+6HlERXpkxBZW43OMMj428ZOwhD5nNLbyyFBbME
         3BEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761870657; x=1762475457;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J+Ez2liootURycULRis0r6eLUgh70ESz5qK4iYDo4pQ=;
        b=v3usPgQmQqvZNjEKfTSfrc6W1Jyd58BpOm9dGMuD+n+QOzLdgYclACImjnB4/xqPKE
         udATSv2Rt0/oX9oZSKcpRP0WjVB84Qck9FOeBxSL4moEKD1c8WLWzVK3K/L2gbRwddPy
         7LzTFjcO5jS6bZ4y9XxWhtayTXatTy6ywrSGJCFuFCrTS06unMukwsOO1xuCKCotCrN8
         cVOWJV7L+WPIRYHI1jsT48LwNUfGKWxrSgkiS5VE/r/Vz/ADZ9oBqRXNhpvnTI+Qzutg
         Is4VAuBNpLCJYlPnCeqT2jrlAQ9BBFIXDYgW4dbAKdQB/eKPugh8djpu9cX8LDcbutll
         8Muw==
X-Gm-Message-State: AOJu0Yy4eei9KTkMiFV3zgDyUQfx2PlgzqcayFQPDxhzxihAoO2tQHVa
	l4FjmO9htP5VFjzVXIWgNCln/zSTTRnaBvKF/f2Mtgw6JYc8HtI9ynea1vXkylnUDCx1HAK5u2Q
	eDP9wog==
X-Google-Smtp-Source: AGHT+IFeWZiIu8lcfwk0BeqW4AcKRL0jcrFiKIe53HTAdWTNST0vC7Y2cgXO/sr9CaxDDQHI55Unzyy0ltg=
X-Received: from pjod4.prod.google.com ([2002:a17:90a:8d84:b0:33b:51fe:1a7a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3947:b0:340:7b4a:392f
 with SMTP id 98e67ed59e1d1-34083074659mr2369461a91.17.1761870657326; Thu, 30
 Oct 2025 17:30:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 17:30:38 -0700
In-Reply-To: <20251031003040.3491385-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031003040.3491385-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251031003040.3491385-7-seanjc@google.com>
Subject: [PATCH v4 6/8] KVM: VMX: Bundle all L1 data cache flush mitigation
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
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 174 ++++++++++++++++++++---------------------
 1 file changed, 87 insertions(+), 87 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5af2338c7cb8..55962146fc34 100644
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
@@ -6672,77 +6753,6 @@ int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
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
@@ -8677,16 +8687,6 @@ __init int vmx_hardware_setup(void)
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
2.51.1.930.gacf6e81ea2-goog


