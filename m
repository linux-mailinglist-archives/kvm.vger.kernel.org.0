Return-Path: <kvm+bounces-38024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A6DCA340AD
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 14:46:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5176B7A4E09
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 13:44:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 961552222C3;
	Thu, 13 Feb 2025 13:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hrWDD825"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87DF2222A8
	for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 13:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739454278; cv=none; b=j9UXaQzR3yxU8cuxY1XqGDk1rISx62QwUSHlHwztzNRrVyDbz7FCX5D+LZ6MLHfyF6WOakO9WIxuXVPsbQKkRM/VEo+YB3hnzNiVOJ5YMvgZLmCgmd5ZkBFRyExASlrnRJh+BFkTL9IcvjClHfJiyufg29975evvvrt8ip2iQ6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739454278; c=relaxed/simple;
	bh=6OsRXGek1x/Zh8AmRY35oA/LL23gK80fMFmfLtmtYfA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R7vhYRNoRIlda6XYrsnGY8q/xwzj1nyhJUrvBokSBdvuuOfCMrAiReY4pxHDqk6/G7N+XHOXzOY5356epnUFUI6KCnJQzOjWdXypE4b4GBuI2+Y6p2+fz8UACG+dblDWIL6LOxVVLfkoUQ5nZpp9VFHR/oc2GXeCrDAdpljAi1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--derkling.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hrWDD825; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--derkling.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-38ddba9814bso544334f8f.3
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 05:44:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739454275; x=1740059075; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ic9Th6hBf+PoxAJPvAOFkVubxFFjGgrt31sWLioNKfE=;
        b=hrWDD82583strneykom/MzrGt1t2JzuS7VNcJLJVfZOpz1Vi/d0ISZu5DZEVaHfJ5D
         gxAl4XJ4nmqwQNkXHE+YBqppo2c/SBdTqqoAfbjLfp2Gd1b06pBXd7Xoc67vUeCCu1dn
         lbxPTaKvFUXMcynuDn2bsl4QRj+Z+VvqcnjqEUMNNymwhonbR4yIUjq0AZgTHfbcAWyi
         l52GSPM+2FJwj9+d19yOR4YDAI2bucIAQ18ufNY05U07KodiSge4FSc0WUH7DT9BHI7c
         urpteyzJ5H3HFJ7Hkcup4ppiUkqRUecSb54F24TbkPf53V5MJw2yMVcOogkWiqU5wryn
         AvmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739454275; x=1740059075;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ic9Th6hBf+PoxAJPvAOFkVubxFFjGgrt31sWLioNKfE=;
        b=TSZnRCANx4o51MFwHJIwxprmeccdEzb3FSZtnIYYxZMJ2/Rfok6njVqLvwfbFRHBBk
         VicQHqDE5Yp28jxOpk8gGdITRi7mXvgtYuGcoE+qHULTeF8KaRq7F1mElsoLMEfA91uV
         wItvDlRSPYI4yzyzRlZkOoEMf1hmNmNawbS709cAP1CMo2L7e5M/1FJMoDtub6RmYRjd
         GNNvL6WsRMUhetbHgwkIT/tIcF3WYk9CoChth1Cm1BzAKTJbdeVahA0ikwzlpofqT9Wb
         +PqG2s5wXt2LzBnK6NFljYmEjQPEylLd76EQO4A0iZ0CKRKCcF44Y4/zjA4/OpVN2gVb
         ICoQ==
X-Forwarded-Encrypted: i=1; AJvYcCUcFihplvj9bC+k0kH/0SuoeCpImeEfKI+rKHGQigEMCc6+C6PWiuk9g9qGlxr03ZvCKzI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOmeB94+clIrisgB7f790p3tUgmQ2IK9vBk3H4YLFNpdzRYK1u
	OyoQdb01vKlncSv6p7IECm4fQmSv0VzEf4uuDQUkhLO6uAtIv6TKlCAJ3cNQGbbdweRblzCtsFJ
	pIGQEcDq+vg==
X-Google-Smtp-Source: AGHT+IGLocNDrDAUHRipa45b7Hp8ZAewQIBybLdatWxi3yDfOOAsMV/ODoaKBMvmEBc9yRxstLYJXyCfkeHfrw==
X-Received: from wmbet10.prod.google.com ([2002:a05:600c:818a:b0:439:5517:7ade])
 (user=derkling job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:1786:b0:38f:225b:3122 with SMTP id ffacd0b85a97d-38f24519c10mr4401962f8f.44.1739454275258;
 Thu, 13 Feb 2025 05:44:35 -0800 (PST)
Date: Thu, 13 Feb 2025 13:44:08 +0000
In-Reply-To: <20250213105304.1888660-1-derkling@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250213105304.1888660-1-derkling@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250213134408.2931040-1-derkling@google.com>
Subject: Re: Re: Re: [PATCH] x86/bugs: KVM: Add support for SRSO_MSR_FIX
From: Patrick Bellasi <derkling@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Josh Poimboeuf <jpoimboe@redhat.com>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Patrick Bellasi <derkling@matbug.net>
Content-Type: text/plain; charset="UTF-8"

And, of course, this bit:

> diff --git a/tools/arch/x86/include/asm/msr-index.h b/tools/arch/x86/include/asm/msr-index.h
> index 3ae84c3b8e6db..1372a569fb585 100644
> --- a/tools/arch/x86/include/asm/msr-index.h
> +++ b/tools/arch/x86/include/asm/msr-index.h
> @@ -717,6 +717,7 @@
> >
>  /* Zen4 */
>  #define MSR_ZEN4_BP_CFG                 0xc001102e
> +#define MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT 4

has to be added to arch/x86/include/asm/msr-index.h as well.

Following (yet another) updated versions accounting for this.

Best,
Patrick

---

From: Borislav Petkov <bp@alien8.de>

Add support for

  CPUID Fn8000_0021_EAX[31] (SRSO_MSR_FIX). If this bit is 1, it
  indicates that software may use MSR BP_CFG[BpSpecReduce] to mitigate
  SRSO.

enable this BpSpecReduce bit to mitigate SRSO across guest/host
boundaries.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Patrick Bellasi <derkling@google.com>
---
 Documentation/admin-guide/hw-vuln/srso.rst | 20 ++++++++++++++++++++
 arch/x86/include/asm/cpufeatures.h         |  1 +
 arch/x86/include/asm/msr-index.h           |  1 +
 arch/x86/kernel/cpu/bugs.c                 | 21 +++++++++++++++++----
 arch/x86/kvm/svm/svm.c                     | 14 ++++++++++++++
 tools/arch/x86/include/asm/msr-index.h     |  1 +
 6 files changed, 54 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/hw-vuln/srso.rst b/Documentation/admin-guide/hw-vuln/srso.rst
index 2ad1c05b8c883..49680ab99c393 100644
--- a/Documentation/admin-guide/hw-vuln/srso.rst
+++ b/Documentation/admin-guide/hw-vuln/srso.rst
@@ -104,6 +104,26 @@ The possible values in this file are:
 
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
 
 
 In order to exploit vulnerability, an attacker needs to:
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 508c0dad116bc..c46754298507b 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -468,6 +468,7 @@
 #define X86_FEATURE_IBPB_BRTYPE		(20*32+28) /* MSR_PRED_CMD[IBPB] flushes all branch type predictions */
 #define X86_FEATURE_SRSO_NO		(20*32+29) /* CPU is not affected by SRSO */
 #define X86_FEATURE_SRSO_USER_KERNEL_NO	(20*32+30) /* CPU is not affected by SRSO across user/kernel boundaries */
+#define X86_FEATURE_SRSO_BP_SPEC_REDUCE	(20*32+31) /* BP_CFG[BpSpecReduce] can be used to mitigate SRSO for VMs (SRSO_MSR_FIX in AMD docs). */
 
 /*
  * Extended auxiliary flags: Linux defined - for features scattered in various
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 9a71880eec070..6bbc8836d6766 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -720,6 +720,7 @@
 
 /* Zen4 */
 #define MSR_ZEN4_BP_CFG                 0xc001102e
+#define MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT 4
 #define MSR_ZEN4_BP_CFG_SHARED_BTB_FIX_BIT 5
 
 /* Fam 19h MSRs */
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index a5d0998d76049..d2007dbfcc1cc 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -2522,6 +2522,7 @@ enum srso_mitigation {
 	SRSO_MITIGATION_SAFE_RET,
 	SRSO_MITIGATION_IBPB,
 	SRSO_MITIGATION_IBPB_ON_VMEXIT,
+	SRSO_MITIGATION_BP_SPEC_REDUCE,
 };
 
 enum srso_mitigation_cmd {
@@ -2539,7 +2540,8 @@ static const char * const srso_strings[] = {
 	[SRSO_MITIGATION_MICROCODE]		= "Vulnerable: Microcode, no safe RET",
 	[SRSO_MITIGATION_SAFE_RET]		= "Mitigation: Safe RET",
 	[SRSO_MITIGATION_IBPB]			= "Mitigation: IBPB",
-	[SRSO_MITIGATION_IBPB_ON_VMEXIT]	= "Mitigation: IBPB on VMEXIT only"
+	[SRSO_MITIGATION_IBPB_ON_VMEXIT]	= "Mitigation: IBPB on VMEXIT only",
+	[SRSO_MITIGATION_BP_SPEC_REDUCE]	= "Mitigation: Reduced Speculation"
 };
 
 static enum srso_mitigation srso_mitigation __ro_after_init = SRSO_MITIGATION_NONE;
@@ -2578,7 +2580,7 @@ static void __init srso_select_mitigation(void)
 	    srso_cmd == SRSO_CMD_OFF) {
 		if (boot_cpu_has(X86_FEATURE_SBPB))
 			x86_pred_cmd = PRED_CMD_SBPB;
-		return;
+		goto out;
 	}
 
 	if (has_microcode) {
@@ -2590,7 +2592,7 @@ static void __init srso_select_mitigation(void)
 		 */
 		if (boot_cpu_data.x86 < 0x19 && !cpu_smt_possible()) {
 			setup_force_cpu_cap(X86_FEATURE_SRSO_NO);
-			return;
+			goto out;
 		}
 
 		if (retbleed_mitigation == RETBLEED_MITIGATION_IBPB) {
@@ -2670,6 +2672,12 @@ static void __init srso_select_mitigation(void)
 
 ibpb_on_vmexit:
 	case SRSO_CMD_IBPB_ON_VMEXIT:
+		if (boot_cpu_has(X86_FEATURE_SRSO_BP_SPEC_REDUCE)) {
+			pr_notice("Reducing speculation to address VM/HV SRSO attack vector.\n");
+			srso_mitigation = SRSO_MITIGATION_BP_SPEC_REDUCE;
+			break;
+		}
+
 		if (IS_ENABLED(CONFIG_MITIGATION_IBPB_ENTRY)) {
 			if (has_microcode) {
 				setup_force_cpu_cap(X86_FEATURE_IBPB_ON_VMEXIT);
@@ -2691,7 +2699,12 @@ static void __init srso_select_mitigation(void)
 	}
 
 out:
-	pr_info("%s\n", srso_strings[srso_mitigation]);
+
+	if (srso_mitigation != SRSO_MITIGATION_BP_SPEC_REDUCE)
+		setup_clear_cpu_cap(X86_FEATURE_SRSO_BP_SPEC_REDUCE);
+
+	if (srso_mitigation != SRSO_MITIGATION_NONE)
+		pr_info("%s\n", srso_strings[srso_mitigation]);
 }
 
 #undef pr_fmt
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7640a84e554a6..6ea3632af5807 100644
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
 
diff --git a/tools/arch/x86/include/asm/msr-index.h b/tools/arch/x86/include/asm/msr-index.h
index 3ae84c3b8e6db..1372a569fb585 100644
--- a/tools/arch/x86/include/asm/msr-index.h
+++ b/tools/arch/x86/include/asm/msr-index.h
@@ -717,6 +717,7 @@
 
 /* Zen4 */
 #define MSR_ZEN4_BP_CFG                 0xc001102e
+#define MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT 4
 #define MSR_ZEN4_BP_CFG_SHARED_BTB_FIX_BIT 5
 
 /* Fam 19h MSRs */
-- 
2.48.1.601.g30ceb7b040-goog


