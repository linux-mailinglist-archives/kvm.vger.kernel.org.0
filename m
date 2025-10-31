Return-Path: <kvm+bounces-61629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9463CC22CA0
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 01:33:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3538A3AAAF9
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 00:32:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D93E223B605;
	Fri, 31 Oct 2025 00:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l8+XVSyM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F852253A0
	for <kvm@vger.kernel.org>; Fri, 31 Oct 2025 00:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761870661; cv=none; b=Y4kOVe5cIsiQmpVsvSEeE7oH/y1zENYJSZMtZw7BmoSobNFPWeiCcLw17ldsHjqLVM7TCAz4sqGlR6S11yxvVJLRtMHjTLs0lhAIyM1E/5/s5JIX2FvQSjRXIOrE9uknA2GY7K6XfZybdX2xidJmoOggvM3RGfUC7rkBAtE227E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761870661; c=relaxed/simple;
	bh=+/nQFAES+hrWFC0pBIVYOueQkR8baZYhWUGk2XUr3do=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nubt+z/Dr7KZKMxmHaLtYy74UiVJyB3R/M+E2/n41i+PCAv0wyKtqWP6fSscer0qwosoAWM9cJyVAT32q9fvyKvyemtANpc4H54fzL9gAAvSbgyeb3GM0PFkK7sTLIBMu0JdklCLM+8tYE29lF7D+9LjFT4f7sDuWxTSKMjLaKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l8+XVSyM; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-336b646768eso1726584a91.1
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 17:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761870659; x=1762475459; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/wh7xt99UOmIbZZ3YA0srOlB+Id97FpIBwjWdRIlXIc=;
        b=l8+XVSyM4bFxwrQN8DaLPFhc9LuRattX7ueWwoowULmkIak5gIpDeDqqAuwPSweoyl
         Ow6cn8mmTlQ6ijq2FWqk9b+snZs0IAt/JY7fkY2HQNtG3eYrtR9xbSsFT2bpI4bWuvb2
         vnv7rJCh1JnHdBOv37aWACuvXQocdOaeSDTs1ycA9OU3h9jeQ+ke1z4rBcqP8HEZksVc
         AEV4U0QleYOdOUGklYZER0xAlnmoPJH9zFnjw/NHrVUMt+96rY9UKbXyOdriV5sBZuAV
         YqrRnreG/VYfwwY6GedwRJHrNWs8KntDYnI1ppXex5AYIqeXYc8GTggVtBHGejkhm4/T
         QEFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761870659; x=1762475459;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/wh7xt99UOmIbZZ3YA0srOlB+Id97FpIBwjWdRIlXIc=;
        b=PrZWi9n/xFknr/X9dou+wt7xS/MlUSDXdShb3R+GID0Ms8JmU6ZPAORGGwVzkoT5D2
         JR7OavOsNX6QbHYGlBMVCnXsNz8XBaLQ8vCFDK2jSa7YMwQbd1roj5SVxuSvFlnhcozS
         4u6IvbqaePq2qlU6MvCZds3wm4YM4FWkLLtu68OG7MrVjSuQCk02KQmu3V2QDWEqLdTz
         tB9B98Sq7B27W1mSGNLMSW99B4E94c/X7uaEGcIYg3UKcHTxLgcI1oYVz3mXbJvllzvh
         FhF7ha4T3yyC1oR+PPMNgf3CjUQluciiuEO+2r/TKZiu/dt/Jto7jOM/OGglfIWIPY8E
         YyVQ==
X-Gm-Message-State: AOJu0Yygh/HG+rC7hqGN7KD01ynqGtdjvx1NH/1Y0Yp399pKajX9ihlN
	p4wG23E9n1SBojf7k546lPaLQB7tw21p1HlzHZBQMZ7y1lgDssyNw5hkM16dzL7lEH3bcTDAv7y
	snuSwvA==
X-Google-Smtp-Source: AGHT+IEPApnG8wn21BOQC69xhg9nxg+bzKPscm/u0l8WSfyBjqi5a7Rip/bgAtivYcVxCFCMnb/7mBiNME4=
X-Received: from pjbpw15.prod.google.com ([2002:a17:90b:278f:b0:340:5488:df9e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c4c:b0:335:2823:3683
 with SMTP id 98e67ed59e1d1-34082fc1bb1mr2252055a91.9.1761870658815; Thu, 30
 Oct 2025 17:30:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 17:30:39 -0700
In-Reply-To: <20251031003040.3491385-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251031003040.3491385-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251031003040.3491385-8-seanjc@google.com>
Subject: [PATCH v4 7/8] KVM: VMX: Disable L1TF L1 data cache flush if CONFIG_CPU_MITIGATIONS=n
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
index 55962146fc34..1b5540105e4b 100644
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
@@ -7349,8 +7388,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 
 	guest_state_enter_irqoff();
 
-	if (static_branch_unlikely(&vmx_l1d_should_flush))
-		vmx_l1d_flush(vcpu);
+	vmx_l1d_flush(vcpu);
 
 	vmx_disable_fb_clear(vmx);
 
@@ -8722,14 +8760,8 @@ int __init vmx_init(void)
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
2.51.1.930.gacf6e81ea2-goog


