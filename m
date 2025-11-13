Return-Path: <kvm+bounces-63114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 90088C5AA80
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:42:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0D93C341FD9
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 23:39:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1EC632ABFD;
	Thu, 13 Nov 2025 23:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cQVN2nz7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81B1331233
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 23:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763077086; cv=none; b=nsuVxKNMGTCe6k4rTk9Pbzy7diOFFnq6PfEAV75BobjwzCOksiwJE6wS2J48Sj30hTqJ5YJoCm9gljo7C5VhjOmZHOOWphyZH2mn7xLYiWyD/2b/eEwraNVz/4YKC3ePFx5BLI8kdYNKfeVTR1s4ViB8VqM95orYg+3VnHyWDmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763077086; c=relaxed/simple;
	bh=wtycuEY2azLWihklz9eK2sJ+qOCuV2/E3a/PpTiKFK0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RmVEyxBNDLY5KV1MF0J6d7EnzJo+Yic6MEK7DzQULkbl4xGRMImjlpqBzmfje2cVBmYhgqRhuHzW8c6pJ1egKVkJ/N0xf/85wmRItWfcDrkmr6cAungPAEISfUXnA9NDWxhrO7A/nvOOQBiMoOy8aHCRMpQnXpp7w322su60ZZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cQVN2nz7; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7a153ba0009so3104494b3a.1
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 15:38:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763077082; x=1763681882; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qQ9BLihijeePl6z+R4l/kmqIlHBheOPmGQ6Y3DB6Ymg=;
        b=cQVN2nz7S1maOalLN4zPYFyQa11qddOWTK0E3vSaLWiDmyr5JZS5f/1RsIih1VNZSc
         WbdVFp+2/DxnRGLbH5SZ/jx16KQgTEv76c4sih9CrWxLbsUHUzWPW3UMYeRbI5slo3KX
         aVM5hwt9pFXo0AYL37dLbUs24WEN6eheF1L5Em+08nVSO4eJIChy6QQVJQGGorjxIWxo
         TAAB8zyLs//0darEYn98b0ldcuCAyxyWHzzmoacQXFdIn0bD4JEZcc083Dp5/wIOrVdi
         2iPQU7yu4YzXzwamef96CMT5XvnOsf+5QeekNNACzC+DKv9cU3YVSUZaTH9cfvXZlZja
         Gbyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763077082; x=1763681882;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qQ9BLihijeePl6z+R4l/kmqIlHBheOPmGQ6Y3DB6Ymg=;
        b=nutp+7VRqr4E0K4PxV1Fsjxd5nAav2gWnhdFboLhD1FwR52rLtta+pzOaEGFAO0Ohi
         tgv+HhHi5O8n24zTJIUcaMgGCyoxUIA088MzwuApc3jD+D6HJtvFnUuzlzhWJCg17rOU
         1kB0fkSwsmRL2hGG2Pk70YHE/C9wGK/fizc+akBw5cGRbr348o6WsaVSG3YBop6xJKsK
         OrVCV1gP6MKgppUeQH9ZcElSkOXgN48IWl14X40ikIOvP/yXmFZ+Y9P+uL93J8NzEH/H
         ZPCXX6R5efNSdg9Y7RCqD+wTqrYIqD/tZSiD50u0/RMxtbhTcyzVrzrELvyj00RbnS9d
         OaLw==
X-Gm-Message-State: AOJu0YxTKPhQu2Nd8e2wc9y6YQhCKjNCDE3uqwn24Qttqni/yzRZ0mDK
	YESVmpCVfAe++HnJBgNfY2BChZxhcPlQgNt2BLRLCCL19nd2VOSWp4DbxDV1VZLfu4govtuQp2c
	5thDbdg==
X-Google-Smtp-Source: AGHT+IFp21U8vXtIEaH8PM9ybXHA3sulW7mjYFjo/+rs+93pjrmeK1XzGOkdPLFjeJExEkEYzWZo81FNomQ=
X-Received: from pfm8.prod.google.com ([2002:a05:6a00:728:b0:76b:f0d4:ac71])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:a28:b0:7ab:4fce:fa1c
 with SMTP id d2e1a72fcca58-7ba39ce323emr1304351b3a.1.1763077082235; Thu, 13
 Nov 2025 15:38:02 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Nov 2025 15:37:45 -0800
In-Reply-To: <20251113233746.1703361-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113233746.1703361-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251113233746.1703361-9-seanjc@google.com>
Subject: [PATCH v5 8/9] KVM: VMX: Disable L1TF L1 data cache flush if CONFIG_CPU_MITIGATIONS=n
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"

Disable support for flushing the L1 data cache to mitigate L1TF if CPU
mitigations are disabled for the entire kernel.  KVM's mitigation of L1TF
is in no way special enough to justify ignoring CONFIG_CPU_MITIGATIONS=n.

Deliberately use CPU_MITIGATIONS instead of the more precise
MITIGATION_L1TF, as MITIGATION_L1TF only controls the default behavior,
i.e. CONFIG_MITIGATION_L1TF=n doesn't completely disable L1TF mitigations
in the kernel.

Keep the vmentry_l1d_flush module param to avoid breaking existing setups,
and leverage the .set path to alert the user to the fact that
vmentry_l1d_flush will be ignored.  Don't bother validating the incoming
value; if an admin misconfigures vmentry_l1d_flush, the fact that the bad
configuration won't be detected when running with CONFIG_CPU_MITIGATIONS=n
is likely the least of their worries.

Reviewed-by: Brendan Jackman <jackmanb@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/hardirq.h |  4 +--
 arch/x86/kvm/vmx/vmx.c         | 56 ++++++++++++++++++++++++++--------
 2 files changed, 46 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index f00c09ffe6a9..6b6d472baa0b 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -5,7 +5,7 @@
 #include <linux/threads.h>
 
 typedef struct {
-#if IS_ENABLED(CONFIG_KVM_INTEL)
+#if IS_ENABLED(CONFIG_CPU_MITIGATIONS) && IS_ENABLED(CONFIG_KVM_INTEL)
 	u8	     kvm_cpu_l1tf_flush_l1d;
 #endif
 	unsigned int __nmi_count;	/* arch dependent */
@@ -68,7 +68,7 @@ extern u64 arch_irq_stat(void);
 DECLARE_PER_CPU_CACHE_HOT(u16, __softirq_pending);
 #define local_softirq_pending_ref       __softirq_pending
 
-#if IS_ENABLED(CONFIG_KVM_INTEL)
+#if IS_ENABLED(CONFIG_CPU_MITIGATIONS) && IS_ENABLED(CONFIG_KVM_INTEL)
 /*
  * This function is called from noinstr interrupt contexts
  * and must be inlined to not get instrumentation.
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b39e083671bc..ae6b102b1570 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -203,6 +203,7 @@ module_param(pt_mode, int, S_IRUGO);
 
 struct x86_pmu_lbr __ro_after_init vmx_lbr_caps;
 
+#ifdef CONFIG_CPU_MITIGATIONS
 static DEFINE_STATIC_KEY_FALSE(vmx_l1d_should_flush);
 static DEFINE_STATIC_KEY_FALSE(vmx_l1d_flush_cond);
 static DEFINE_MUTEX(vmx_l1d_flush_mutex);
@@ -225,7 +226,7 @@ static const struct {
 #define L1D_CACHE_ORDER 4
 static void *vmx_l1d_flush_pages;
 
-static int vmx_setup_l1d_flush(enum vmx_l1d_flush_state l1tf)
+static int __vmx_setup_l1d_flush(enum vmx_l1d_flush_state l1tf)
 {
 	struct page *page;
 	unsigned int i;
@@ -302,6 +303,16 @@ static int vmx_setup_l1d_flush(enum vmx_l1d_flush_state l1tf)
 	return 0;
 }
 
+static int vmx_setup_l1d_flush(void)
+{
+	/*
+	 * Hand the parameter mitigation value in which was stored in the pre
+	 * module init parser. If no parameter was given, it will contain
+	 * 'auto' which will be turned into the default 'cond' mitigation mode.
+	 */
+	return __vmx_setup_l1d_flush(vmentry_l1d_flush_param);
+}
+
 static void vmx_cleanup_l1d_flush(void)
 {
 	if (vmx_l1d_flush_pages) {
@@ -349,7 +360,7 @@ static int vmentry_l1d_flush_set(const char *s, const struct kernel_param *kp)
 	}
 
 	mutex_lock(&vmx_l1d_flush_mutex);
-	ret = vmx_setup_l1d_flush(l1tf);
+	ret = __vmx_setup_l1d_flush(l1tf);
 	mutex_unlock(&vmx_l1d_flush_mutex);
 	return ret;
 }
@@ -376,6 +387,9 @@ static noinstr void vmx_l1d_flush(struct kvm_vcpu *vcpu)
 {
 	int size = PAGE_SIZE << L1D_CACHE_ORDER;
 
+	if (!static_branch_unlikely(&vmx_l1d_should_flush))
+		return;
+
 	/*
 	 * This code is only executed when the flush mode is 'cond' or
 	 * 'always'
@@ -433,6 +447,31 @@ static noinstr void vmx_l1d_flush(struct kvm_vcpu *vcpu)
 		: "eax", "ebx", "ecx", "edx");
 }
 
+#else /* CONFIG_CPU_MITIGATIONS*/
+static int vmx_setup_l1d_flush(void)
+{
+	l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_NEVER;
+	return 0;
+}
+static void vmx_cleanup_l1d_flush(void)
+{
+	l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_AUTO;
+}
+static __always_inline void vmx_l1d_flush(struct kvm_vcpu *vcpu)
+{
+
+}
+static int vmentry_l1d_flush_set(const char *s, const struct kernel_param *kp)
+{
+	pr_warn_once("Kernel compiled without mitigations, ignoring vmentry_l1d_flush\n");
+	return 0;
+}
+static int vmentry_l1d_flush_get(char *s, const struct kernel_param *kp)
+{
+	return sysfs_emit(s, "never\n");
+}
+#endif
+
 static const struct kernel_param_ops vmentry_l1d_flush_ops = {
 	.set = vmentry_l1d_flush_set,
 	.get = vmentry_l1d_flush_get,
@@ -7350,8 +7389,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 
 	guest_state_enter_irqoff();
 
-	if (static_branch_unlikely(&vmx_l1d_should_flush))
-		vmx_l1d_flush(vcpu);
+	vmx_l1d_flush(vcpu);
 
 	vmx_disable_fb_clear(vmx);
 
@@ -8716,14 +8754,8 @@ int __init vmx_init(void)
 	if (r)
 		return r;
 
-	/*
-	 * Must be called after common x86 init so enable_ept is properly set
-	 * up. Hand the parameter mitigation value in which was stored in
-	 * the pre module init parser. If no parameter was given, it will
-	 * contain 'auto' which will be turned into the default 'cond'
-	 * mitigation mode.
-	 */
-	r = vmx_setup_l1d_flush(vmentry_l1d_flush_param);
+	/* Must be called after common x86 init so enable_ept is setup. */
+	r = vmx_setup_l1d_flush();
 	if (r)
 		goto err_l1d_flush;
 
-- 
2.52.0.rc1.455.g30608eb744-goog


