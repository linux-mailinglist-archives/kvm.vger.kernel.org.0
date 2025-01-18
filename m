Return-Path: <kvm+bounces-35919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 962DDA15DA3
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 16:27:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E0EEE1886E84
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2025 15:27:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06D2EEEA9;
	Sat, 18 Jan 2025 15:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="EykxuI82"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4906190497;
	Sat, 18 Jan 2025 15:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737214041; cv=none; b=EO4VQkHrmJ3ekAjeTt0c8E+6UBzNHFpWl15bMQnHRJzHWk/R1NRAm7C/jS6uinixLZdhpHadsPA4gMmpQARpk3TLmoWbWMMTqz5U6ZdXa5vNB3GdeyWmaKQJvAJj7ajU5Tv1390+4YrHjRyaoqtt+0xRJ3yzqgtb9NsUhnyfz2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737214041; c=relaxed/simple;
	bh=K3P23oaaNDMXZwEiv1s1kN7nXc8IVMIXVnMSdv2uMNs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ebg+HiFFWfCP/9MK1523PFZwiYlQdbNQ702eCyacDD1P0P/gfi/Dum9eQ+0NS22W4VJinQvS1sSbrhVtwdiLr2YHnGsOnhR3U+wxsBws3RtyfWW3kYt35TldLte0YJYl2tsFDsdgK/S2/TowsW838jODNAD6kvmN85bVU18rijg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=EykxuI82; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 95CB640E0379;
	Sat, 18 Jan 2025 15:27:15 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id cr8wBz0X17PC; Sat, 18 Jan 2025 15:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1737214031; bh=LXLlK4RZAar8K//R4fTEtS4sKK1p59a+4ZHr4baKnMY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EykxuI82IPgldWCdxdzuSNnybn2ma13KSDhuN6wOotvRaaWPQOJAVdoVF3qMOh2d5
	 US8p6TyMCFd3vQizx/3F25Fc2y0TJg8Bi+oLqcxQv/FwUtASYrkXcNtc/1wG4As5/X
	 ShWfVWLs0VNjV3+qYcn2EXvMbFgJHD9UnkqoFuNs8F0KdirDx3CVJX/MHJbrcpSEXl
	 n3FYE6g84qeo8PWp/n3H0WpHdpaE2JH7lLCiyWi2jTY+Tkb3+0ojJrAuHLPgMvQ0/f
	 jdgKBDeDWjJ4pExS/D+izWX3Fd5ZobwPtIwxOUMGlI0euuNBUkEWMv5oJKlwRJ5exX
	 ZyEPNr6RKLY1C77wLWBd/SHPYOb5ahByPBYhq+PqSUEKN4uGQIJdRV19W2vDw16ceH
	 4dgoiacVqjVJxcGJKeR30hKH7vV4LxQNqfOF+P14NSjjydcp4x/Qmf8/1AI1HGMPwO
	 EpMrEHYJsXfz0ERwTcyTJVtTF7Fbc5LhsdIV1ky0ZlhaWzh3UPL8W3zRQsGlwI9tQK
	 T2VWanI8A2OhYL81BiR6powpIUPxCUvx+bp/grYiXPqRaEErGNP15/zMY8QBXeiOuD
	 X/NK+yk0NxvwupJwkJW8m+6Hnrx+7gQv0XtPWzLa3bBnK3Qj4txPWo5TmXO7r8xWTN
	 mS00YpIhxgecmJkLGOJ4cOqk=
Received: from zn.tnic (p200300ea971F9362329c23fFFEa6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:9362:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3225940E0289;
	Sat, 18 Jan 2025 15:27:03 +0000 (UTC)
Date: Sat, 18 Jan 2025 16:26:55 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/bugs: KVM: Add support for SRSO_MSR_FIX
Message-ID: <20250118152655.GBZ4vIP44MivU2Bv0i@fat_crate.local>
References: <Z1oR3qxjr8hHbTpN@google.com>
 <20241216173142.GDZ2Bj_uPBG3TTPYd_@fat_crate.local>
 <Z2B2oZ0VEtguyeDX@google.com>
 <20241230111456.GBZ3KAsLTrVs77UmxL@fat_crate.local>
 <Z35_34GTLUHJTfVQ@google.com>
 <20250108154901.GFZ36ebXAZMFZJ7D8t@fat_crate.local>
 <Z36zWVBOiBF4g-mW@google.com>
 <20250108181434.GGZ37AiioQkcYbqugO@fat_crate.local>
 <20250111125215.GAZ4Jpf6tbcoS7jCzz@fat_crate.local>
 <Z4qnzwNYGubresFS@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z4qnzwNYGubresFS@google.com>

On Fri, Jan 17, 2025 at 10:56:15AM -0800, Sean Christopherson wrote:
> No preference, either way works for me.

Yeah, too late now. Will queue it after -rc1.

> Heh, no preference again.  In case you want to add Co-developed-by, here's my SoB:
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Thanks. Added.

> Any objection to calling this X86_FEATURE_SRSO_BP_SPEC_REDUCE?  More below.

It sure is a better name. Lets leave SRSO_MSR_FIX in the comment so that
grepping can find it as SRSO_MSR_FIX is what is in the official doc. IOW:

+#define X86_FEATURE_SRSO_BP_SPEC_REDUCE        (20*32+31) /*
+                                                   * BP_CFG[BpSpecReduce] can be used to mitigate SRSO for VMs.
+                                                   * (SRSO_MSR_FIX in the official doc).
+

> At the risk of getting too clever, what if we use the X86_FEATURE to communicate
> that KVM should toggle the magic MSR?

Not too clever at all. I myself have used exactly this scheme to communicate
settings to other code and actually I should've thought about it... :-\

Definitely better than the silly export.

> That'd avoid the helper+export, and up to this point "srso_mitigation" has
> been used only for documentation purposes.
> 
> The flag just needs to be cleared in two locations, which doesn't seem too
> awful.  Though if we go that route, SRSO_MSR_FIX is a pretty crappy name :-)

Yap, most def.

> These exports are no longer necessary.

Doh.

> Compile tested only...

Tested on hw.

Thanks!

---
From: "Borislav Petkov (AMD)" <bp@alien8.de>
Date: Wed, 13 Nov 2024 13:41:10 +0100
Subject: [PATCH] x86/bugs: KVM: Add support for SRSO_MSR_FIX

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
 Documentation/admin-guide/hw-vuln/srso.rst | 21 +++++++++++++++++++++
 arch/x86/include/asm/cpufeatures.h         |  4 ++++
 arch/x86/include/asm/msr-index.h           |  1 +
 arch/x86/kernel/cpu/bugs.c                 | 14 +++++++++++++-
 arch/x86/kvm/svm/svm.c                     | 14 ++++++++++++++
 5 files changed, 53 insertions(+), 1 deletion(-)

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
index 3f3e2bc99162..4cbd461081a1 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -719,6 +719,7 @@
 
 /* Zen4 */
 #define MSR_ZEN4_BP_CFG                 0xc001102e
+#define MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT 4
 #define MSR_ZEN4_BP_CFG_SHARED_BTB_FIX_BIT 5
 
 /* Fam 19h MSRs */
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 5a505aa65489..9e3ea7f1b358 100644
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
@@ -2663,6 +2665,12 @@ static void __init srso_select_mitigation(void)
 
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
@@ -2684,6 +2692,10 @@ static void __init srso_select_mitigation(void)
 	}
 
 out:
+
+	if (srso_mitigation != SRSO_MITIGATION_BP_SPEC_REDUCE)
+		setup_clear_cpu_cap(X86_FEATURE_SRSO_BP_SPEC_REDUCE);
+
 	pr_info("%s\n", srso_strings[srso_mitigation]);
 }
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 21dacd312779..ee14833f00e5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -256,6 +256,7 @@ DEFINE_PER_CPU(struct svm_cpu_data, svm_data);
  * defer the restoration of TSC_AUX until the CPU returns to userspace.
  */
 static int tsc_aux_uret_slot __read_mostly = -1;
+static int zen4_bp_cfg_uret_slot __ro_after_init = -1;
 
 static const u32 msrpm_ranges[] = {0, 0xc0000000, 0xc0010000};
 
@@ -1541,6 +1542,11 @@ static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	    (!boot_cpu_has(X86_FEATURE_V_TSC_AUX) || !sev_es_guest(vcpu->kvm)))
 		kvm_set_user_return_msr(tsc_aux_uret_slot, svm->tsc_aux, -1ull);
 
+	if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE))
+		kvm_set_user_return_msr(zen4_bp_cfg_uret_slot,
+					BIT_ULL(MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT),
+					BIT_ULL(MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT));
+
 	svm->guest_state_loaded = true;
 }
 
@@ -5298,6 +5304,14 @@ static __init int svm_hardware_setup(void)
 
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

