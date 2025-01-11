Return-Path: <kvm+bounces-35218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D60D7A0A3AC
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 13:52:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4467B7A405E
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 12:52:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 832CD1A01B9;
	Sat, 11 Jan 2025 12:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Mrqv6fC0"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B1E19259D;
	Sat, 11 Jan 2025 12:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736599961; cv=none; b=IPKofDrIhNcrr41sIDeC5re9EIfpG2FTlbv5SeqROyU+OhY3btTLVryCUQVVMYm2eKQ43cf4apTx83quZ+fkDiEnMnEZg8fQ4fyY/fu0pIOlJd0kzuDbAqNjP3n8yIjefDBM5UOea3EcNRAEs1t4KZOD75JcXcOg3FdtOmbGpYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736599961; c=relaxed/simple;
	bh=l3crMzuURiZFYNNZJqhlmUF6mgG6AleJhoxt/Ef1Oas=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jIvUnmHJiplA9qXLGG+yk58rZfgvKnpgkQgCYBUmeikBVOm26pmsHU+jTttPd671Xdy7mJBp5SgwIe/taN3dctxNFw/xkkBGQ61fAIIsKeNXfq6B75N1RKk9CzL8XS25VTXYflExuOFZVF3pJuN89KcriQr1lNdSuyntybGnL9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Mrqv6fC0; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5C7AF40E02BF;
	Sat, 11 Jan 2025 12:52:35 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id lrwzxQ2SD4e8; Sat, 11 Jan 2025 12:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1736599949; bh=sK93eAe06EajimDvRPRKfH+5sJbFrcP0v7PeaJCsWA8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Mrqv6fC0iHF93NI1OzFJ6RyvxM42S4M+2KHcdzA+NlhDYEPa7f4x8kEERGkyWLeMg
	 nlLDlR7VaAbI47XRTj5Tjv2YDdAQFTF8tuOwa+QnYvb1MuKUu3FJ86T1NUVzNXN5j+
	 MdKBA6NxOyHrxiZ/epJDht00A3IojdVhCMAGjBu4iqhIVTstTpyIX6nZ+XkvkQFqrN
	 HgH66l/OEIX8nmb7aX9Qhke0i3NZ6u5sNqyteEw0V1/t8GD57sLS0Bgfk83zQEG4cC
	 utvO8I2Vc1QOn8BdxsgV1WigTFz3xhicLOTDjhgp5d2qICwS8M1Q/40TqDV18D7qqG
	 u+dmu85l6P8tH1S0fyojhfdbuXOnzjxRshkdGzKF5BJAl598WHBeahuJ6FL3eH0nTO
	 8SaPSMTNxoWS7NMfcLhdSYkkMNhxV3qYTSoAKZyrijkIUPu8H3E8thhCUanJAVzifi
	 QThaU9mHy6d/vr4qR4m5Ugv8H22F+XYZpEOakc00WukYNDCINQiV/Y9IEIfVtWpbhm
	 1HOLF2n3kNeu85VHASAJUSSxkdmfAahqq8c72eLQcivAsbcRWvOrm7MEaDb466Kl+V
	 JLgcKNH6xMJMXfa19mlIdlO7I+2ox3DtqR1EVVinN2or7VKMe2cv29rIU2DiUO9si9
	 wD4s3y+oW/x/bcvOP9ZLQOkU=
Received: from zn.tnic (pd953008e.dip0.t-ipconnect.de [217.83.0.142])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3ECDC40E02C1;
	Sat, 11 Jan 2025 12:52:21 +0000 (UTC)
Date: Sat, 11 Jan 2025 13:52:15 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/bugs: KVM: Add support for SRSO_MSR_FIX
Message-ID: <20250111125215.GAZ4Jpf6tbcoS7jCzz@fat_crate.local>
References: <20241202120416.6054-1-bp@kernel.org>
 <20241202120416.6054-4-bp@kernel.org>
 <Z1oR3qxjr8hHbTpN@google.com>
 <20241216173142.GDZ2Bj_uPBG3TTPYd_@fat_crate.local>
 <Z2B2oZ0VEtguyeDX@google.com>
 <20241230111456.GBZ3KAsLTrVs77UmxL@fat_crate.local>
 <Z35_34GTLUHJTfVQ@google.com>
 <20250108154901.GFZ36ebXAZMFZJ7D8t@fat_crate.local>
 <Z36zWVBOiBF4g-mW@google.com>
 <20250108181434.GGZ37AiioQkcYbqugO@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250108181434.GGZ37AiioQkcYbqugO@fat_crate.local>

Ok,

here's a new version, I think I've addressed all outstanding review comments.

Lemme know how we should proceed here, you take it or I? Judging by the
diffstat probably I should and you ack it or so.

Also, lemme know if I should add your Co-developed-by for the user_return
portion.

Thx.

---
From: "Borislav Petkov (AMD)" <bp@alien8.de>

Add support for

  CPUID Fn8000_0021_EAX[31] (SRSO_MSR_FIX). If this bit is 1, it
  indicates that software may use MSR BP_CFG[BpSpecReduce] to mitigate
  SRSO.

enable this BpSpecReduce bit to mitigate SRSO across guest/host
boundaries.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
---
 Documentation/admin-guide/hw-vuln/srso.rst | 21 +++++++++++++++++++++
 arch/x86/include/asm/cpufeatures.h         |  1 +
 arch/x86/include/asm/msr-index.h           |  1 +
 arch/x86/include/asm/processor.h           |  1 +
 arch/x86/kernel/cpu/bugs.c                 | 16 +++++++++++++++-
 arch/x86/kvm/svm/svm.c                     | 14 ++++++++++++++
 arch/x86/lib/msr.c                         |  2 ++
 7 files changed, 55 insertions(+), 1 deletion(-)

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
index 508c0dad116b..471447a31605 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -468,6 +468,7 @@
 #define X86_FEATURE_IBPB_BRTYPE		(20*32+28) /* MSR_PRED_CMD[IBPB] flushes all branch type predictions */
 #define X86_FEATURE_SRSO_NO		(20*32+29) /* CPU is not affected by SRSO */
 #define X86_FEATURE_SRSO_USER_KERNEL_NO	(20*32+30) /* CPU is not affected by SRSO across user/kernel boundaries */
+#define X86_FEATURE_SRSO_MSR_FIX	(20*32+31) /* MSR BP_CFG[BpSpecReduce] can be used to mitigate SRSO for VMs */
 
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
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index c0cd10182e90..a956cd578df6 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -762,6 +762,7 @@ enum mds_mitigations {
 };
 
 extern bool gds_ucode_mitigated(void);
+extern bool srso_spec_reduce_enabled(void);
 
 /*
  * Make previous memory operations globally visible before
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 5a505aa65489..07c04b3844fc 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -2523,6 +2523,7 @@ enum srso_mitigation {
 	SRSO_MITIGATION_SAFE_RET,
 	SRSO_MITIGATION_IBPB,
 	SRSO_MITIGATION_IBPB_ON_VMEXIT,
+	SRSO_MITIGATION_BP_SPEC_REDUCE,
 };
 
 enum srso_mitigation_cmd {
@@ -2540,12 +2541,19 @@ static const char * const srso_strings[] = {
 	[SRSO_MITIGATION_MICROCODE]		= "Vulnerable: Microcode, no safe RET",
 	[SRSO_MITIGATION_SAFE_RET]		= "Mitigation: Safe RET",
 	[SRSO_MITIGATION_IBPB]			= "Mitigation: IBPB",
-	[SRSO_MITIGATION_IBPB_ON_VMEXIT]	= "Mitigation: IBPB on VMEXIT only"
+	[SRSO_MITIGATION_IBPB_ON_VMEXIT]	= "Mitigation: IBPB on VMEXIT only",
+	[SRSO_MITIGATION_BP_SPEC_REDUCE]	= "Mitigation: Reduced Speculation"
 };
 
 static enum srso_mitigation srso_mitigation __ro_after_init = SRSO_MITIGATION_NONE;
 static enum srso_mitigation_cmd srso_cmd __ro_after_init = SRSO_CMD_SAFE_RET;
 
+bool srso_spec_reduce_enabled(void)
+{
+	return srso_mitigation == SRSO_MITIGATION_BP_SPEC_REDUCE;
+}
+EXPORT_SYMBOL_GPL(srso_spec_reduce_enabled);
+
 static int __init srso_parse_cmdline(char *str)
 {
 	if (!str)
@@ -2663,6 +2671,12 @@ static void __init srso_select_mitigation(void)
 
 ibpb_on_vmexit:
 	case SRSO_CMD_IBPB_ON_VMEXIT:
+		if (boot_cpu_has(X86_FEATURE_SRSO_MSR_FIX)) {
+			pr_notice("Reducing speculation to address VM/HV SRSO attack vector.\n");
+			srso_mitigation = SRSO_MITIGATION_BP_SPEC_REDUCE;
+			break;
+		}
+
 		if (IS_ENABLED(CONFIG_MITIGATION_SRSO)) {
 			if (!boot_cpu_has(X86_FEATURE_ENTRY_IBPB) && has_microcode) {
 				setup_force_cpu_cap(X86_FEATURE_IBPB_ON_VMEXIT);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 21dacd312779..59656fd51d57 100644
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
 
+	if (srso_spec_reduce_enabled())
+		kvm_set_user_return_msr(zen4_bp_cfg_uret_slot,
+					BIT_ULL(MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT),
+					BIT_ULL(MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT));
+
 	svm->guest_state_loaded = true;
 }
 
@@ -5298,6 +5304,14 @@ static __init int svm_hardware_setup(void)
 
 	tsc_aux_uret_slot = kvm_add_user_return_msr(MSR_TSC_AUX);
 
+	if (srso_spec_reduce_enabled()) {
+		zen4_bp_cfg_uret_slot = kvm_add_user_return_msr(MSR_ZEN4_BP_CFG);
+		if (WARN_ON_ONCE(zen4_bp_cfg_uret_slot < 0)) {
+			r = -EIO;
+			goto err;
+		}
+	}
+
 	if (boot_cpu_has(X86_FEATURE_AUTOIBRS))
 		kvm_enable_efer_bits(EFER_AUTOIBRS);
 
diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c
index 4bf4fad5b148..5a18ecc04a6c 100644
--- a/arch/x86/lib/msr.c
+++ b/arch/x86/lib/msr.c
@@ -103,6 +103,7 @@ int msr_set_bit(u32 msr, u8 bit)
 {
 	return __flip_bit(msr, bit, true);
 }
+EXPORT_SYMBOL_GPL(msr_set_bit);
 
 /**
  * msr_clear_bit - Clear @bit in a MSR @msr.
@@ -118,6 +119,7 @@ int msr_clear_bit(u32 msr, u8 bit)
 {
 	return __flip_bit(msr, bit, false);
 }
+EXPORT_SYMBOL_GPL(msr_clear_bit);
 
 #ifdef CONFIG_TRACEPOINTS
 void do_trace_write_msr(unsigned int msr, u64 val, int failed)
-- 
2.43.0


-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

