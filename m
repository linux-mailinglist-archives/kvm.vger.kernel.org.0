Return-Path: <kvm+bounces-38026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F8F2A34211
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 15:31:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89E8E3ABB7C
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 14:29:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE79C23A9B8;
	Thu, 13 Feb 2025 14:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="ZdLk4zAX"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD67D227E88;
	Thu, 13 Feb 2025 14:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739456922; cv=none; b=FmFECOjUqC7lF9PJNbu7aPxWuJ0JLjoAtEPV3Eu9vjDkknDiv3eNf9XA0YbaWJIunXUXLCb8fpm+FChLnXX6i4GNu5KyeP0wWn3VcUGD3ge7MnS7JCltsAnjtFZwN8jE55RaM9CsjtLWFQhGwK/j2qZJ/NOvGZ+4L1IBBFw0LD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739456922; c=relaxed/simple;
	bh=sqMbVoTKvvkH5uAbIDEUIdsRpG+atbtgfcri7b3HgxM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n8Xjo+RcFXEH/m40IuH1dsf5nFF6TqwGXlmCeBQaMwSNYX4ixT4AwAux+wxukAb/bxPDX2keNWNl3hbpJHzC5jHCQLiPVnqvtjv9XCxEBS+v7aSXfpdYOC3S9u48C+6qhTJIJZZOWdAy7SfGkJcbWvTU58quzTwrKdzg8eS9kOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=ZdLk4zAX; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A802240E0028;
	Thu, 13 Feb 2025 14:28:36 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 3THacUTJ44bs; Thu, 13 Feb 2025 14:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1739456911; bh=JfK80UxQID4SsjIO6cABIn0sKoLEACSdQtwlOmNnbHs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZdLk4zAXQ+TnAipMGJVXg+Dw4Hf2ue7uhk9LELqYGpet5CDNtrmHvqz981KorABx2
	 DMPhmcoWrMw2o2y0l8HOg+o0S3DW+XTBMs7t/23dULrA/JP1rf9oq84M/2aojChmmD
	 6Yd4Eiwj3JsyvvmMEPvqhta+w1BX7N/69RMFGqoGThqNFBh4ApAi+jBNGz0bJY8RBQ
	 VIxwGCrmZxYAEstL4FhZm878bW6ZZonVRPngT7vA6yWX45WXv9NhFP7QJVEV7uWp/l
	 JdTyAEP4u/yQ2g+Nw+Bx8PYxjFKplsTM+7OUxlMPv8Upmlhl15I39XqzHAX5o96V0Z
	 jYXVC5Zr/y4kKmyCabHm6c0BuGyBeFC7h1WUBwg+xAGWyrsWEyrJQ9abB/ChxIN80b
	 7RRoOX1uyyATdjtdq7K5a84o51xV9eTLKMILeA6RxOWLCX6Y8FIOore9BzQ36jPJKK
	 lqZ34Q2iZ1H0WlcArcoaT/9ojpj9Aibh+L24/UVW5u5eiBTIJJL2FmiXWy71H17xdu
	 u4jWPulKnl6kn2DIDnROWcMkEDdSS3rlFZpnWLke+XTn2tORQGk8db4Na0FwapupLr
	 OgZMP39jtSptk6W055hNd8wiDRcFwUVWl32mS+yIf1rTiMMGHYAeIPxK6l7GSZ9yXf
	 ZsnJm1pQARWiHxMGzGKT8P6E=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6705040E0191;
	Thu, 13 Feb 2025 14:28:21 +0000 (UTC)
Date: Thu, 13 Feb 2025 15:28:15 +0100
From: Borislav Petkov <bp@alien8.de>
To: Patrick Bellasi <derkling@google.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Patrick Bellasi <derkling@matbug.net>,
	Brendan Jackman <jackmanb@google.com>
Subject: Re: Re: Re: [PATCH] x86/bugs: KVM: Add support for SRSO_MSR_FIX
Message-ID: <20250213142815.GBZ64Bf3zPIay9nGza@fat_crate.local>
References: <20250213105304.1888660-1-derkling@google.com>
 <20250213134408.2931040-1-derkling@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250213134408.2931040-1-derkling@google.com>

+ bjackman.

On Thu, Feb 13, 2025 at 01:44:08PM +0000, Patrick Bellasi wrote:
> Following (yet another) updated versions accounting for this.

Here's a tested one. You could've simply waited as I told you I'm working on
it.

I'm going to queue this one next week into tip once Patrick's fix becomes part
of -rc3.

Thx.

---
From: "Borislav Petkov (AMD)" <bp@alien8.de>
Date: Wed, 13 Nov 2024 13:41:10 +0100
Subject: [PATCH] x86/bugs: KVM: Add support for SRSO_MSR_FIX

Add support for

  CPUID Fn8000_0021_EAX[31] (SRSO_MSR_FIX). If this bit is 1, it
  indicates that software may use MSR BP_CFG[BpSpecReduce] to mitigate
  SRSO.

Enable BpSpecReduce to mitigate SRSO across guest/host boundaries.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
---
 Documentation/admin-guide/hw-vuln/srso.rst | 21 +++++++++++++++++++
 arch/x86/include/asm/cpufeatures.h         |  4 ++++
 arch/x86/include/asm/msr-index.h           |  1 +
 arch/x86/kernel/cpu/bugs.c                 | 24 ++++++++++++++++++----
 arch/x86/kvm/svm/svm.c                     | 14 +++++++++++++
 5 files changed, 60 insertions(+), 4 deletions(-)

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
index 508c0dad116b..43653f2704c9 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -468,6 +468,10 @@
 #define X86_FEATURE_IBPB_BRTYPE		(20*32+28) /* MSR_PRED_CMD[IBPB] flushes all branch type predictions */
 #define X86_FEATURE_SRSO_NO		(20*32+29) /* CPU is not affected by SRSO */
 #define X86_FEATURE_SRSO_USER_KERNEL_NO	(20*32+30) /* CPU is not affected by SRSO across user/kernel boundaries */
+#define X86_FEATURE_SRSO_BP_SPEC_REDUCE	(20*32+31) /*
+						    * BP_CFG[BpSpecReduce] can be used to mitigate SRSO for VMs.
+						    * (SRSO_MSR_FIX in the official doc).
+						    */
 
 /*
  * Extended auxiliary flags: Linux defined - for features scattered in various
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 72765b2fe0d8..d35519b337ba 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -721,6 +721,7 @@
 
 /* Zen4 */
 #define MSR_ZEN4_BP_CFG                 0xc001102e
+#define MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT 4
 #define MSR_ZEN4_BP_CFG_SHARED_BTB_FIX_BIT 5
 
 /* Fam 19h MSRs */
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index a5d0998d7604..1d7afc40f227 100644
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
@@ -2691,7 +2699,15 @@ static void __init srso_select_mitigation(void)
 	}
 
 out:
-	pr_info("%s\n", srso_strings[srso_mitigation]);
+	/*
+	 * Clear the feature flag if this mitigation is not selected as that
+	 * feature flag controls the BpSpecReduce MSR bit toggling in KVM.
+	 */
+	if (srso_mitigation != SRSO_MITIGATION_BP_SPEC_REDUCE)
+		setup_clear_cpu_cap(X86_FEATURE_SRSO_BP_SPEC_REDUCE);
+
+	if (srso_mitigation != SRSO_MITIGATION_NONE)
+		pr_info("%s\n", srso_strings[srso_mitigation]);
 }
 
 #undef pr_fmt
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
 
-- 
2.43.0

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

