Return-Path: <kvm+bounces-38021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E07A1A33D06
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 11:53:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 047E07A3D38
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 10:53:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 731A42135CD;
	Thu, 13 Feb 2025 10:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E32+R2Cw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38F3212FAC
	for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 10:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739444025; cv=none; b=RB4v1yYHL4FpOxkXQcE9JopKMJn2RTyBmML9SNGkAP3qKrWPutMUFqY5RQZ5503WLc7M+FIvt9M7SYu1QyhSxSJjrRg/fLj761UkcvSGMYdie5E6jYJRnYg12ujlDH4sVF1VHDEIDEUDfpekcjGf+a0zH5s7aMtWZtmGV9oeAQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739444025; c=relaxed/simple;
	bh=CxdSoIHuO3hDAjz4B5KLTm/OYqVLRMNIIpY0qRy4XtM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z4iJB2+BwtV67fvPyojlcdMrF24S5Jqr9AnsSJd3Qn0q5vTjGGWQ6PIn+U9BD460oEmfzLpIWitziGCO9gUbAS+HRDH+BEd/eNmwpmftAPhrvBxydf/6RctwMW6e7E21CEjxWIoREo/j4DpQqc52TGNzWWO0qnJ+JoTjscHWzMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--derkling.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E32+R2Cw; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--derkling.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-38f27bddeeeso365224f8f.3
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 02:53:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739444022; x=1740048822; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LH65o5YRE1ZNPyB4JSqw2z5nXm8tS/ZU1Ybl+xJhaus=;
        b=E32+R2Cwh+yVluyu/0VqhtKavKg1FiQF/Se24rbqKNV14aalP9ZPcE+wOAjx1odpWA
         zcNW3YhPVl0Q1ARNvKXzuW+5EeJqB/BHO1Sn3I3lOOUXn4qP5GY7Mm5Z7EqEmvDSohrv
         FX95VD2ZHj6O3m9Qfu1p7PrbLfGWGeY0mfuxCEFZpn1Nawi1di8iDJOk6a6lU+s+HvtI
         ZMYCHMPraGy3ZLlOD6EaAYBhobGJvL6OdexnaPV0MvUeChiRgWADZVhQGlAZ+TDsF7AK
         fWgiWxK+WIZG+nNShObkoJvhmvXaZwIQ9h1uDMlbmyr4mpyjxpawGQV41vBYSePvmgEY
         wc6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739444022; x=1740048822;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LH65o5YRE1ZNPyB4JSqw2z5nXm8tS/ZU1Ybl+xJhaus=;
        b=Yw1GnGEU4CvdQ3RjPzNDOV9TlAkPLa4s884SUhdstVyxOpa7poKrDVV33OuqRrePuS
         aFvQWngiRp177mYRskfrbuJiPPApv9HVzj792OOPCtbgVxsvtuHq/eqeIApUOh3rGe5P
         uXyh/sDNPiw616VvBo3z9MWcRTA7Y9FrLode601SURbW9RG3/10uojLQG0vgWk7HlVFp
         1DACeVlCgllQq7SHUiURSs/84+ffr+DNjMVwSKFxkrCBgR8JB+wA1/7NNBC1L9LalvWV
         aRtdmf7V7J4h+CHa6lORu97uXT5ZcCzf8S8fxrCY+WSQZFsbgC9FdrCXt5CC9Jrwks3u
         70mQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYR0iviJ+Qo6A5bPUPnoPk4E4Q2hayyvcCUKqzHP05NT0RQ79y157W/uMomlOMGZiDzWk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKoaYuEvL3Q2OtTQj2UibpCjWjZlb9xhoiKskfaN9rkmPbjrmH
	zKWrtI27cCPCp6GPPOEJrxIHONROafaMRfwK4Gl2v0ty9+wYkynm2smwRrpDH/8/QmMAf4O55bQ
	tV3Frok+NXA==
X-Google-Smtp-Source: AGHT+IFxznP0aCdnsFpcLgdw7/40LdRcVDzdZgumVDt95Dc2hRgsaFtKg75OlD16IyilijGhRybsgT2KdZ3HCQ==
X-Received: from wmsp21.prod.google.com ([2002:a05:600c:1d95:b0:439:4829:ec32])
 (user=derkling job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:90:b0:38d:d92e:5f7a with SMTP id ffacd0b85a97d-38f244ee0f5mr2519203f8f.28.1739444022091;
 Thu, 13 Feb 2025 02:53:42 -0800 (PST)
Date: Thu, 13 Feb 2025 10:53:04 +0000
In-Reply-To: <20250123170149.GCZ5J1_WovzHQzo0cW@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250123170149.GCZ5J1_WovzHQzo0cW@fat_crate.local>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250213105304.1888660-1-derkling@google.com>
Subject: Re: Re: [PATCH] x86/bugs: KVM: Add support for SRSO_MSR_FIX
From: Patrick Bellasi <derkling@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Josh Poimboeuf <jpoimboe@redhat.com>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Patrick Bellasi <derkling@matbug.net>
Content-Type: text/plain; charset="UTF-8"

FWIW, this should be the updated version of the patch with all the review
comments posted so far.

Posting here just to have an overall view of how the new patch should look like.
This is also based on todays Linus's master branch.

Compile tested only...

Best,
Patrick

---
From: "Borislav Petkov (AMD)" <bp@alien8.de>

Add support for

  CPUID Fn8000_0021_EAX[31] (SRSO_MSR_FIX). If this bit is 1, it
  indicates that software may use MSR BP_CFG[BpSpecReduce] to mitigate
  SRSO.

enable this BpSpecReduce bit to mitigate SRSO across guest/host
boundaries.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
---
 Documentation/admin-guide/hw-vuln/srso.rst | 20 ++++++++++++++++++++
 arch/x86/include/asm/cpufeatures.h         |  1 +
 arch/x86/kernel/cpu/bugs.c                 | 21 +++++++++++++++++----
 arch/x86/kvm/svm/svm.c                     | 14 ++++++++++++++
 tools/arch/x86/include/asm/msr-index.h     |  1 +
 5 files changed, 53 insertions(+), 4 deletions(-)

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


