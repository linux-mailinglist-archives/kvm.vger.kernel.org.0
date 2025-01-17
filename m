Return-Path: <kvm+bounces-35850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B016FA157AF
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 19:56:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A9F807A0FC6
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 18:56:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A17F11A7264;
	Fri, 17 Jan 2025 18:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WCysitOh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3B61A0BED
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 18:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737140178; cv=none; b=D6CUX4S/5dvSYz7BLJekTIQAeq+Y2yIHxtW5m34o/oi3+YRdId92Hc6NockATE8gWCHGP+MRrouzNBpT6NQ0s/9zWHSaJpMnwug3L3ul2RCSBpn61TeBHgbXnEayCddbpAbiFnn5p1V7i3hXzWizbNV6G4t50DlHFJgK9wZsN0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737140178; c=relaxed/simple;
	bh=RJ2gfyT93kZAp4twJdM7b9tbklGcRMMHgY85MlBSWNA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EOfSJMBvhWUUmhMzrMyt1HRGnWF0E8l4sbbXwsN7uFKkmv5ypkRI0TAq88C5Fk9QfRVVwQaOuBPzAIOQ/hwyAdIOlcS2/kJMzaF0eHZ9Xn5hAn0QGRM9oLkWxgSNO9y7uyaosUAJF0S8D4I4hB7h4YtN8SQRJqvwxA/YbcbYBf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WCysitOh; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ee46799961so6986141a91.2
        for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 10:56:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737140176; x=1737744976; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JzoMT6Z9QsBST+QoVv0rnoylV95wlHgWRkPMjZNbMDg=;
        b=WCysitOhivQEgr304PI1XDpFkwBBlF1fwJRuNpUXYz956sCHUwWfU+6KEPb+hjUJUz
         tkOgXpjA6tdkCjkR9irR3Q2twjJVsrkua89/y+gsagzeDZD6qJWbsaq/aIZxyTss9/Pd
         6gmKloU9ZlTfIQQhG3UTMIe2/7y714mn+L3/pZMKYWjopH1vzBapy88ngpGEnBo/j6pt
         TV+cmZlQ1wNVSw/TypV+6sznrBcTQ483T2d4iQg8O01qu5HUwu91pkRF8Kde3DS7l67N
         KQzPy39zL6etWcPd3ikqlieAA+a+MZtD8KDbffm0VnSDDo63s0/I/SGBtevDReWw9mqc
         Hz8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737140176; x=1737744976;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JzoMT6Z9QsBST+QoVv0rnoylV95wlHgWRkPMjZNbMDg=;
        b=vCUUIlpU4jbwkRRks8NABndLFeXX1h4Dc38CDI9RHXEW054tAD9xQJiIhoxYzToP22
         g524WE3xxtszHDZTc1UMv/2HuJLXrbMbdOTwb5tqBA2dGS4OMHm4BPmCzzFosRcGUiyn
         Ui9EZIXIhuutMVIWS/fLcoKMZR078L6awfgAMMzFErUVcjtuzZQ1tpeA4qeOKhlewwN1
         f8F5AOTWmm9l9WslPTFYLc67Ka42t2Xhxf3us3tKmcCaK5KhjxQOIr4S+ekQ6VeySAIT
         28BLmQDsiY/gkji3ICtDUGH0boXPrTqCK1FAFX3HqWL/42YNdGAkPqlvzwlKb7D4hZVe
         x2hg==
X-Forwarded-Encrypted: i=1; AJvYcCULB9pVin7OlvLLMDNJ7Kf1UENv1XSAhMZcQ64aKYsomoa5s+cDbKQNz/4CZ/Bp9E8kmCc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwFgBg7emZP9dOq8kjiWOXviaqA6wF/4LRG6w6opsGEEhmtIYP
	8EN8SUPa7WnOlI5Cu5ASPUlzidgbhlhX3fjOx5zWZ40fL6/TU57GLml/sNY4hPFXxdxoqvjpxi1
	+tA==
X-Google-Smtp-Source: AGHT+IEwC1uY3gT6XUt7ZSrDXGattFmwkWQ5pTEiIiIwUlmlT7roKD2AwU/3hef24OHiJHKh+yzoy0frTYE=
X-Received: from pjbph15.prod.google.com ([2002:a17:90b:3bcf:b0:2ea:6aa8:c4ad])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3cd0:b0:2ee:aed6:9ec2
 with SMTP id 98e67ed59e1d1-2f782c926d5mr6119943a91.14.1737140176553; Fri, 17
 Jan 2025 10:56:16 -0800 (PST)
Date: Fri, 17 Jan 2025 10:56:15 -0800
In-Reply-To: <20250111125215.GAZ4Jpf6tbcoS7jCzz@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241202120416.6054-4-bp@kernel.org> <Z1oR3qxjr8hHbTpN@google.com>
 <20241216173142.GDZ2Bj_uPBG3TTPYd_@fat_crate.local> <Z2B2oZ0VEtguyeDX@google.com>
 <20241230111456.GBZ3KAsLTrVs77UmxL@fat_crate.local> <Z35_34GTLUHJTfVQ@google.com>
 <20250108154901.GFZ36ebXAZMFZJ7D8t@fat_crate.local> <Z36zWVBOiBF4g-mW@google.com>
 <20250108181434.GGZ37AiioQkcYbqugO@fat_crate.local> <20250111125215.GAZ4Jpf6tbcoS7jCzz@fat_crate.local>
Message-ID: <Z4qnzwNYGubresFS@google.com>
Subject: Re: [PATCH] x86/bugs: KVM: Add support for SRSO_MSR_FIX
From: Sean Christopherson <seanjc@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Josh Poimboeuf <jpoimboe@redhat.com>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Sat, Jan 11, 2025, Borislav Petkov wrote:
> Ok,
> 
> here's a new version, I think I've addressed all outstanding review comments.
> 
> Lemme know how we should proceed here, you take it or I? Judging by the
> diffstat probably I should and you ack it or so.

No preference, either way works for me.

> Also, lemme know if I should add your Co-developed-by for the user_return
> portion.

Heh, no preference again.  In case you want to add Co-developed-by, here's my SoB:

Signed-off-by: Sean Christopherson <seanjc@google.com>

>  In order to exploit vulnerability, an attacker needs to:
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 508c0dad116b..471447a31605 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -468,6 +468,7 @@
>  #define X86_FEATURE_IBPB_BRTYPE		(20*32+28) /* MSR_PRED_CMD[IBPB] flushes all branch type predictions */
>  #define X86_FEATURE_SRSO_NO		(20*32+29) /* CPU is not affected by SRSO */
>  #define X86_FEATURE_SRSO_USER_KERNEL_NO	(20*32+30) /* CPU is not affected by SRSO across user/kernel boundaries */
> +#define X86_FEATURE_SRSO_MSR_FIX	(20*32+31) /* MSR BP_CFG[BpSpecReduce] can be used to mitigate SRSO for VMs */

Any objection to calling this X86_FEATURE_SRSO_BP_SPEC_REDUCE?  More below.

> @@ -2540,12 +2541,19 @@ static const char * const srso_strings[] = {
>  	[SRSO_MITIGATION_MICROCODE]		= "Vulnerable: Microcode, no safe RET",
>  	[SRSO_MITIGATION_SAFE_RET]		= "Mitigation: Safe RET",
>  	[SRSO_MITIGATION_IBPB]			= "Mitigation: IBPB",
> -	[SRSO_MITIGATION_IBPB_ON_VMEXIT]	= "Mitigation: IBPB on VMEXIT only"
> +	[SRSO_MITIGATION_IBPB_ON_VMEXIT]	= "Mitigation: IBPB on VMEXIT only",
> +	[SRSO_MITIGATION_BP_SPEC_REDUCE]	= "Mitigation: Reduced Speculation"
>  };
>  
>  static enum srso_mitigation srso_mitigation __ro_after_init = SRSO_MITIGATION_NONE;
>  static enum srso_mitigation_cmd srso_cmd __ro_after_init = SRSO_CMD_SAFE_RET;
>  
> +bool srso_spec_reduce_enabled(void)
> +{
> +	return srso_mitigation == SRSO_MITIGATION_BP_SPEC_REDUCE;

At the risk of getting too clever, what if we use the X86_FEATURE to communicate
that KVM should toggle the magic MSR?  That'd avoid the helper+export, and up to
this point "srso_mitigation" has been used only for documentation purposes.

The flag just needs to be cleared in two locations, which doesn't seem too awful.
Though if we go that route, SRSO_MSR_FIX is a pretty crappy name :-)

> diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c
> index 4bf4fad5b148..5a18ecc04a6c 100644
> --- a/arch/x86/lib/msr.c
> +++ b/arch/x86/lib/msr.c
> @@ -103,6 +103,7 @@ int msr_set_bit(u32 msr, u8 bit)
>  {
>  	return __flip_bit(msr, bit, true);
>  }
> +EXPORT_SYMBOL_GPL(msr_set_bit);
>  
>  /**
>   * msr_clear_bit - Clear @bit in a MSR @msr.
> @@ -118,6 +119,7 @@ int msr_clear_bit(u32 msr, u8 bit)
>  {
>  	return __flip_bit(msr, bit, false);
>  }
> +EXPORT_SYMBOL_GPL(msr_clear_bit);

These exports are no longer necessary.

Compile tested only...

---
 Documentation/admin-guide/hw-vuln/srso.rst | 21 +++++++++++++++++++++
 arch/x86/include/asm/cpufeatures.h         |  1 +
 arch/x86/include/asm/msr-index.h           |  1 +
 arch/x86/kernel/cpu/bugs.c                 | 15 ++++++++++++++-
 arch/x86/kvm/svm/svm.c                     | 14 ++++++++++++++
 5 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/hw-vuln/srso.rst b/Documentation/admin-guide/hw-vuln/srso.rst
index 2ad1c05b8c88..b856538083a2 100644
--- a/Documentation/admin-guide/hw-vuln/srso.rst
+++ b/Documentation/admin-guide/hw-vuln/srso.rst
@@ -104,6 +104,27 @@ The possible values in this file are:
 
    (spec_rstack_overflow=ibpb-vmexit)
 
+ * 'Mitigation: Reduced Speculation':
+
+   This mitigation gets automatically enabled when the above one "IBPB on
+   VMEXIT" has been selected and the CPU supports the BpSpecReduce bit.
+
+   It gets automatically enabled on machines which have the
+   SRSO_USER_KERNEL_NO=1 CPUID bit. In that case, the code logic is to switch
+   to the above =ibpb-vmexit mitigation because the user/kernel boundary is
+   not affected anymore and thus "safe RET" is not needed.
+
+   After enabling the IBPB on VMEXIT mitigation option, the BpSpecReduce bit
+   is detected (functionality present on all such machines) and that
+   practically overrides IBPB on VMEXIT as it has a lot less performance
+   impact and takes care of the guest->host attack vector too.
+
+   Currently, the mitigation uses KVM's user_return approach
+   (kvm_set_user_return_msr()) to set the BpSpecReduce bit when a vCPU runs
+   a guest and reset it upon return to host userspace or when the KVM module
+   is unloaded. The intent being, the small perf impact of BpSpecReduce should
+   be incurred only when really necessary.
+
 
 
 In order to exploit vulnerability, an attacker needs to:
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 0e2d81763615..00f2649c36ab 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -466,6 +466,7 @@
 #define X86_FEATURE_IBPB_BRTYPE		(20*32+28) /* MSR_PRED_CMD[IBPB] flushes all branch type predictions */
 #define X86_FEATURE_SRSO_NO		(20*32+29) /* CPU is not affected by SRSO */
 #define X86_FEATURE_SRSO_USER_KERNEL_NO	(20*32+30) /* CPU is not affected by SRSO across user/kernel boundaries */
+#define X86_FEATURE_SRSO_BP_SPEC_REDUCE	(20*32+31) /* MSR BP_CFG[BpSpecReduce] can be used to mitigate SRSO for VMs */
 
 /*
  * Extended auxiliary flags: Linux defined - for features scattered in various
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 3ae84c3b8e6d..1372a569fb58 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -717,6 +717,7 @@
 
 /* Zen4 */
 #define MSR_ZEN4_BP_CFG                 0xc001102e
+#define MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT 4
 #define MSR_ZEN4_BP_CFG_SHARED_BTB_FIX_BIT 5
 
 /* Fam 19h MSRs */
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 8854d9bce2a5..971d3373eeaf 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -2523,6 +2523,7 @@ enum srso_mitigation {
 	SRSO_MITIGATION_SAFE_RET,
 	SRSO_MITIGATION_IBPB,
 	SRSO_MITIGATION_IBPB_ON_VMEXIT,
+	SRSO_MITIGATION_BP_SPEC_REDUCE,
 };
 
 enum srso_mitigation_cmd {
@@ -2540,7 +2541,8 @@ static const char * const srso_strings[] = {
 	[SRSO_MITIGATION_MICROCODE]		= "Vulnerable: Microcode, no safe RET",
 	[SRSO_MITIGATION_SAFE_RET]		= "Mitigation: Safe RET",
 	[SRSO_MITIGATION_IBPB]			= "Mitigation: IBPB",
-	[SRSO_MITIGATION_IBPB_ON_VMEXIT]	= "Mitigation: IBPB on VMEXIT only"
+	[SRSO_MITIGATION_IBPB_ON_VMEXIT]	= "Mitigation: IBPB on VMEXIT only",
+	[SRSO_MITIGATION_BP_SPEC_REDUCE]	= "Mitigation: Reduced Speculation"
 };
 
 static enum srso_mitigation srso_mitigation __ro_after_init = SRSO_MITIGATION_NONE;
@@ -2577,6 +2579,8 @@ static void __init srso_select_mitigation(void)
 	if (!boot_cpu_has_bug(X86_BUG_SRSO) ||
 	    cpu_mitigations_off() ||
 	    srso_cmd == SRSO_CMD_OFF) {
+		setup_clear_cpu_cap(X86_FEATURE_SRSO_BP_SPEC_REDUCE);
+
 		if (boot_cpu_has(X86_FEATURE_SBPB))
 			x86_pred_cmd = PRED_CMD_SBPB;
 		return;
@@ -2665,6 +2669,12 @@ static void __init srso_select_mitigation(void)
 
 ibpb_on_vmexit:
 	case SRSO_CMD_IBPB_ON_VMEXIT:
+		if (boot_cpu_has(X86_FEATURE_SRSO_BP_SPEC_REDUCE)) {
+			pr_notice("Reducing speculation to address VM/HV SRSO attack vector.\n");
+			srso_mitigation = SRSO_MITIGATION_BP_SPEC_REDUCE;
+			break;
+		}
+
 		if (IS_ENABLED(CONFIG_MITIGATION_SRSO)) {
 			if (!boot_cpu_has(X86_FEATURE_ENTRY_IBPB) && has_microcode) {
 				setup_force_cpu_cap(X86_FEATURE_IBPB_ON_VMEXIT);
@@ -2686,6 +2696,9 @@ static void __init srso_select_mitigation(void)
 	}
 
 out:
+	if (srso_mitigation != SRSO_MITIGATION_BP_SPEC_REDUCE)
+		setup_clear_cpu_cap(X86_FEATURE_SRSO_BP_SPEC_REDUCE);
+
 	pr_info("%s\n", srso_strings[srso_mitigation]);
 }
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7640a84e554a..6ea3632af580 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -257,6 +257,7 @@ DEFINE_PER_CPU(struct svm_cpu_data, svm_data);
  * defer the restoration of TSC_AUX until the CPU returns to userspace.
  */
 static int tsc_aux_uret_slot __read_mostly = -1;
+static int zen4_bp_cfg_uret_slot __ro_after_init = -1;
 
 static const u32 msrpm_ranges[] = {0, 0xc0000000, 0xc0010000};
 
@@ -1540,6 +1541,11 @@ static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	    (!boot_cpu_has(X86_FEATURE_V_TSC_AUX) || !sev_es_guest(vcpu->kvm)))
 		kvm_set_user_return_msr(tsc_aux_uret_slot, svm->tsc_aux, -1ull);
 
+	if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
+		kvm_set_user_return_msr(zen4_bp_cfg_uret_slot,
+					BIT_ULL(MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT),
+					BIT_ULL(MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT));
+
 	svm->guest_state_loaded = true;
 }
 
@@ -5306,6 +5312,14 @@ static __init int svm_hardware_setup(void)
 
 	tsc_aux_uret_slot = kvm_add_user_return_msr(MSR_TSC_AUX);
 
+	if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE)) {
+		zen4_bp_cfg_uret_slot = kvm_add_user_return_msr(MSR_ZEN4_BP_CFG);
+		if (WARN_ON_ONCE(zen4_bp_cfg_uret_slot < 0)) {
+			r = -EIO;
+			goto err;
+		}
+	}
+
 	if (boot_cpu_has(X86_FEATURE_AUTOIBRS))
 		kvm_enable_efer_bits(EFER_AUTOIBRS);
 

base-commit: 9bec4a1f4ea92b99f96894e0c51c192b5345aa91
-- 

