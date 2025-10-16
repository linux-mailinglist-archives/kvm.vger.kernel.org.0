Return-Path: <kvm+bounces-60223-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 55846BE5503
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 22:05:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 828B319C7945
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 20:05:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4492F2E1EEC;
	Thu, 16 Oct 2025 20:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VmLNRsE7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F282DFA5A
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 20:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760645068; cv=none; b=BR3rAgCybH1h8nMjCLFge7UdurE4sV5VIgfwWakFxeOkhth3jGthlwyqjo1z61epOoBnqPQFea4ZO7RmNP2363QKKb0SSMGi9OvioZlGLdURstkaep/fboqbA9nd3IoVWYFHd2ZeMe5ul7QTmMoJZV13F4bTdMGEkORl/5uCnnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760645068; c=relaxed/simple;
	bh=+BI3vZGhl1OUxVrO7t7nTf9aykzXpRRBJCRI1x4Dzk4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JAzAvYOCWCtdBDntgOwBMXMJ0w7Xo8YAJCebh8qHlmZXZwN5G10cLiK6Xnop5PhvI15E0f15ibrScv88Fb0EP7XVrVS9UP68iIi9UduHcOe/j4dJkVlifZWUXLhUqTufNng97VcCcbjRh3FSL5yNEmfhRNa8UiRfFU2jso9Nyps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VmLNRsE7; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3304def7909so1052924a91.3
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 13:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760645066; x=1761249866; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=gICh0D9JnzmBW3pvgKeRu2d75Fu8xaMjYi9X/63uYNM=;
        b=VmLNRsE7dNJrYlWaZVNk4G/bimpLGAopdeQPhhhDheyIWYOT7pHHMZ6nKIV9alOfLr
         vWdhEBP9fEKawvjs4odiWL0I3w/8+PpreDTQuadUiGyXH6VocSIpP2ockQyIgFICv2iw
         9oyRgQqWQ6+euG4ljQnwTBF076YeMeWYPVVICub6/c+PPQ268xAKmMxlzGrYGBnpfDh6
         d7IkDAtF6WnRySlPghdrgZ8y8Lo/AyjZHm9VD9evT48irh83Kbd/Zcg95aZ6uFwlVmyV
         dw8HBAI4co2xi8FppV3F/XofbnXK6lkDRc7vGdWaajDQbAdn485e2T4cfP6j3/C0aIhN
         7tlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760645066; x=1761249866;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gICh0D9JnzmBW3pvgKeRu2d75Fu8xaMjYi9X/63uYNM=;
        b=W8/wVWvPTrJrvOg4Vh6Wl+jJ4R3Hg68Yw2tw/llGrxKm/fFjzNOeFVo6+6hQyANbjr
         ITu8rYELzB8gpD3KEkaPWcgpoFm4ks+J9dVcI39aXPXuo+XRAAr1hSYkCmiJvaTx77vw
         LM7dxkAQSNP966EjLBY0CZhiYTajqY8nIaWL6uFrvOvAMuP6aHF1Ss9yGExkbMNWm9vt
         Cn4D0SSPHLWnyHbgo9Rq7rTF4xPKFLyrjg9gULyWnTc7ObXq/x+BaNU35wgqawROn6fK
         Kd8vJsFWuVdCkPGxZ4BvqzdqijQlBf882QkWlnaVgQUWqSAzpmND8Zflsb9P3WrxueWC
         RLCQ==
X-Gm-Message-State: AOJu0Yzy1nlDbaFDOMYV7pP6ewEl9O3e1Qj4etgyIiS25MzblWrsmjAU
	UeBauFVbyGO1SqJzCxrw0jFg+bTat8Iy7TqHfhLUeu7vt4YYCx5WJNZ+VFO4+p7eL+wANrbRrfV
	h3JogYA==
X-Google-Smtp-Source: AGHT+IHztc2TqgDKpEmWp9jAwqakrYMvnNulb8h0c+tFEAFFdKTRQ4mRZOTbzsyI2FnZxXK4m2S9f8WNbU0=
X-Received: from pjbsr14.prod.google.com ([2002:a17:90b:4e8e:b0:33b:8b81:9086])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3942:b0:336:bfce:3b48
 with SMTP id 98e67ed59e1d1-33bcf87f431mr1266128a91.9.1760645066002; Thu, 16
 Oct 2025 13:04:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 13:04:16 -0700
In-Reply-To: <20251016200417.97003-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251016200417.97003-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251016200417.97003-4-seanjc@google.com>
Subject: [PATCH v3 3/4] KVM: VMX: Disable L1TF L1 data cache flush if CONFIG_CPU_MITIGATIONS=n
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
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
index cd8ae1b2ae55..e91d99211efe 100644
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
+	return vmx_setup_l1d_flush(vmentry_l1d_flush_param);
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
@@ -376,6 +387,9 @@ static noinstr bool vmx_l1d_flush(struct kvm_vcpu *vcpu)
 {
 	int size = PAGE_SIZE << L1D_CACHE_ORDER;
 
+	if (!static_branch_unlikely(&vmx_l1d_should_flush))
+		return false;
+
 	/*
 	 * This code is only executed when the flush mode is 'cond' or
 	 * 'always'
@@ -434,6 +448,31 @@ static noinstr bool vmx_l1d_flush(struct kvm_vcpu *vcpu)
 	return true;
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
+static __always_inline bool vmx_l1d_flush(struct kvm_vcpu *vcpu)
+{
+	return false;
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
@@ -7341,8 +7380,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	 * and is affected by MMIO Stale Data. In such cases mitigation in only
 	 * needed against an MMIO capable guest.
 	 */
-	if (static_branch_unlikely(&vmx_l1d_should_flush) &&
-	    vmx_l1d_flush(vcpu))
+	if (vmx_l1d_flush(vcpu))
 		;
 	else if (static_branch_unlikely(&cpu_buf_vm_clear) &&
 		 (flags & VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO))
@@ -8718,14 +8756,8 @@ int __init vmx_init(void)
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
2.51.0.858.gf9c4a03a3a-goog


