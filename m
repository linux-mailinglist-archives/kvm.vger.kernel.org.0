Return-Path: <kvm+bounces-73094-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EMq3GAcAq2lxZQEAu9opvQ
	(envelope-from <kvm+bounces-73094-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 17:25:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CB0AD224DC1
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 17:25:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3155F30898EA
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 16:19:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F35A3EDACA;
	Fri,  6 Mar 2026 16:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fLDKed+2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E2A36C5A7
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 16:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772813957; cv=none; b=kInNYdZb8LEQZyISX2IvqA3eD5aWgHe3Th6++FuG9YvabLgmQvQQPvSvELklQD8XmGh0VH5KexcYAk6VijFXtSRrf3QlQ8CTApdSGAD97peaEqEtsH0elKz+jRvpK1m+OIM+fxlLQdlw+p5M8j96/DDiELeBLBYr2424UDXLjac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772813957; c=relaxed/simple;
	bh=N2zx8DABprjg/k8M9f3ytrqYd17n5LwzyxXxz99QZmQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ggDbbu8wqeOZ4mjlU1BNEblLWzq/EhWNqGr7wojy20YWiPbQDxbQhtB73aRDPsNFleepabO+PRVlpqO1DW/fCp4y33Rt/vF4kWsE+LzcocjDk2l9vNzGJqYehTIAY0TPTvUOWkM8Io0xNoolEsWUfN7QSEBlGNdq3i3UgM827vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fLDKed+2; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-8298b363fb6so3885824b3a.0
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 08:19:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772813954; x=1773418754; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DoW2JK6C0NZQvZKABxmAU/DO1MeRai2/JOxeEbvxe14=;
        b=fLDKed+2HivYSOaIpv3Oj6UPl6hKn9BZ/jjTUIhR5A9ee208jkHOIuPu/8O+VGA0FX
         iyeHQ8yqQkZInZItfd0tnHnKuvssUW+2Gu85q4qK58AcOsmLQDOe6It549Wb7omupWQc
         KmS63dlWFexn/hx9EqJ/w4bBAi4H4pzwuNFL4Mk3+xWMLNkwtFrprC+01mvBIUDRtLGp
         qBiROSsKzoRykiJX455DyNu6fB2PfCh1cu0BZNFkQGY+wRekZN7sdsKpU8Kw9qbLLeKA
         nTyZMx4Vpfxy4tzq6amjsZdFj8l1MAwSEA7Zwk1+S+AXFmw8fe+4Me7/s2Vop0zNXjru
         MuYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772813954; x=1773418754;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DoW2JK6C0NZQvZKABxmAU/DO1MeRai2/JOxeEbvxe14=;
        b=d+PZEAWjzcLOPH7EidJ8i4LG54NWA0zxPeaMVRHP7CQwppWrgc+7MzO3tR+jw9oIZz
         8weCnH1P92ArYgzYOV9SyfvY/5ysjpaNhfPP0rIXzP7TCR4ei+iISVjkl2m16DAnDxJT
         Jx0TcBKweVWyzf3JXdzUTcCaSA0zRXE6Xgp7q8CdnlzU9UVWXWCmC1ChqVHFzYu1ixVu
         FPLpZwWbc1CCS4thO9mC7PXDIsgYQQB1CYzwbpu/SCMBiV87U57js78btmW9OzeE8+DG
         ujc3a1rDXaR6DCLrcqZ4cEQmh4+9PR7zvr1vS9HsYHS9vG5/Pdvr3JS6t4wGKQUxY1SB
         CQuQ==
X-Forwarded-Encrypted: i=1; AJvYcCUG/ZUsdjkxEAzvyHThdreqOQR7qPZMC6agRuf5vkki62h/MLpRU+WE9BJzFbnyvO+UpYo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb5S5rElMn5qDYYVviOAo7reiF/LxZg/a0bU0SMzrK7le5rB6K
	yUFVi2cosdXELQ7SLH6hOHS2zs9Uetzm2caPjD/Q8F5Fh4fFzSd4Nb9tGZHz8kr7//hRSSe1DKx
	mORF8bA==
X-Received: from pfoh24.prod.google.com ([2002:aa7:86d8:0:b0:824:9ebc:1ad1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:749b:b0:81f:3ae9:3f71
 with SMTP id d2e1a72fcca58-829a2dba809mr1889033b3a.28.1772813954272; Fri, 06
 Mar 2026 08:19:14 -0800 (PST)
Date: Fri, 6 Mar 2026 08:19:12 -0800
In-Reply-To: <20260306002327.1225504-1-yosry@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260306002327.1225504-1-yosry@kernel.org>
Message-ID: <aar-gDulqlXtVDhR@google.com>
Subject: Re: [PATCH] KVM: SVM: Propagate Translation Cache Extensions to the guest
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Venkatesh Srinivas <venkateshs@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Venkatesh Srinivas <venkateshs@chromium.org>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: CB0AD224DC1
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73094-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.930];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,chromium.org:email]
X-Rspamd-Action: no action

On Fri, Mar 06, 2026, Yosry Ahmed wrote:
> From: Venkatesh Srinivas <venkateshs@chromium.org>
> 
> TCE augments the behavior of TLB invalidating instructions (INVLPG,
> INVLPGB, and INVPCID) to only invalidate translations for relevant
> intermediate mappings to the address range, rather than ALL intermdiate
> translations.
> 
> The Linux kernel has been setting EFER.TCE if supported by the CPU since
> commit 440a65b7d25f ("x86/mm: Enable AMD translation cache extensions"),
> as it may improve performance.
> 
> KVM does not need to do anything to virtualize the feature,

Please back this up with actual analysis.

> only advertise it and allow setting EFER.TCE.  Passthrough X86_FEATURE_TCE to

Advertise X86_FEATURE_TCE to userspace, not "passthrough xxx to the guest".
Because that's all KVM 

> the guest, and allow the guest to set EFER.TCE if available.
> 
> Co-developed-by: Yosry Ahmed <yosry@kernel.org>
> Signed-off-by: Yosry Ahmed <yosry@kernel.org>
> Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>

Your SoB should come last to capture that the chain of hanlding, i.e. this should
be:

  Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>
  Co-developed-by: Yosry Ahmed <yosry@kernel.org>
  Signed-off-by: Yosry Ahmed <yosry@kernel.org>

> ---
>  arch/x86/kvm/cpuid.c   | 1 +
>  arch/x86/kvm/svm/svm.c | 3 +++
>  arch/x86/kvm/x86.c     | 3 +++
>  3 files changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index fffbf087937d4..4f810f23b1d9b 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1112,6 +1112,7 @@ void kvm_initialize_cpu_caps(void)
>  		F(XOP),
>  		/* SKINIT, WDT, LWP */
>  		F(FMA4),
> +		F(TCE),
>  		F(TBM),
>  		F(TOPOEXT),
>  		VENDOR_F(PERFCTR_CORE),
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 3407deac90bd6..fee1c8cd45973 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5580,6 +5580,9 @@ static __init int svm_hardware_setup(void)
>  	if (boot_cpu_has(X86_FEATURE_AUTOIBRS))
>  		kvm_enable_efer_bits(EFER_AUTOIBRS);
>  
> +	if (boot_cpu_has(X86_FEATURE_TCE))
> +		kvm_enable_efer_bits(EFER_TCE);

Hrm, I think we should handle all of the kvm_enable_efer_bits() calls that are
conditioned only on CPU support in common code.  While it's highly unlikely Intel
CPUs will ever support more EFER-based features, if they do, then KVM will
over-report support since kvm_initialize_cpu_caps() will effectively enable the
feature, but VMX won't enable the corresponding EFER bit. 

I can't think anything that will go sideways if we rely purely on KVM caps, so
get to something like this as prep work, and then land TCE in common x86?

---
 arch/x86/kvm/svm/svm.c |  7 +------
 arch/x86/kvm/vmx/vmx.c |  4 ----
 arch/x86/kvm/x86.c     | 14 ++++++++++++++
 3 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 3407deac90bd..c23ee45f2ba8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5556,14 +5556,10 @@ static __init int svm_hardware_setup(void)
 		pr_err_ratelimited("NX (Execute Disable) not supported\n");
 		return -EOPNOTSUPP;
 	}
-	kvm_enable_efer_bits(EFER_NX);
 
 	kvm_caps.supported_xcr0 &= ~(XFEATURE_MASK_BNDREGS |
 				     XFEATURE_MASK_BNDCSR);
 
-	if (boot_cpu_has(X86_FEATURE_FXSR_OPT))
-		kvm_enable_efer_bits(EFER_FFXSR);
-
 	if (tsc_scaling) {
 		if (!boot_cpu_has(X86_FEATURE_TSCRATEMSR)) {
 			tsc_scaling = false;
@@ -5577,8 +5573,7 @@ static __init int svm_hardware_setup(void)
 
 	tsc_aux_uret_slot = kvm_add_user_return_msr(MSR_TSC_AUX);
 
-	if (boot_cpu_has(X86_FEATURE_AUTOIBRS))
-		kvm_enable_efer_bits(EFER_AUTOIBRS);
+
 
 	/* Check for pause filtering support */
 	if (!boot_cpu_has(X86_FEATURE_PAUSEFILTER)) {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9302c16571cd..2b8a7456039c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8583,10 +8583,6 @@ __init int vmx_hardware_setup(void)
 
 	vmx_setup_user_return_msrs();
 
-
-	if (boot_cpu_has(X86_FEATURE_NX))
-		kvm_enable_efer_bits(EFER_NX);
-
 	if (boot_cpu_has(X86_FEATURE_MPX)) {
 		rdmsrq(MSR_IA32_BNDCFGS, host_bndcfgs);
 		WARN_ONCE(host_bndcfgs, "BNDCFGS in host will be lost");
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 879cdeb6adde..0b5d48e75b65 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10025,6 +10025,18 @@ void kvm_setup_xss_caps(void)
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_setup_xss_caps);
 
+static void kvm_setup_efer_caps(void)
+{
+	if (kvm_cpu_cap_has(X86_FEATURE_NX))
+		kvm_enable_efer_bits(EFER_NX);
+
+	if (kvm_cpu_cap_has(X86_FEATURE_FXSR_OPT))
+		kvm_enable_efer_bits(EFER_FFXSR);
+
+	if (kvm_cpu_cap_has(X86_FEATURE_AUTOIBRS))
+		kvm_enable_efer_bits(EFER_AUTOIBRS);
+}
+
 static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
 {
 	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
@@ -10161,6 +10173,8 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	if (r != 0)
 		goto out_mmu_exit;
 
+	kvm_setup_efer_caps();
+
 	enable_device_posted_irqs &= enable_apicv &&
 				     irq_remapping_cap(IRQ_POSTING_CAP);
 

base-commit: 5128b972fb2801ad9aca54d990a75611ab5283a9
-- 

