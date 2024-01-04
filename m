Return-Path: <kvm+bounces-5650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63F64824408
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 15:43:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C8A7286A47
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 14:43:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 735D623759;
	Thu,  4 Jan 2024 14:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="NF40di81"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF8623748;
	Thu,  4 Jan 2024 14:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 4537040E00C5;
	Thu,  4 Jan 2024 14:42:49 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Um-BwKp4FekK; Thu,  4 Jan 2024 14:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1704379366; bh=dmenayIyDEohIzfSm5J+SPjurlu17a93F377Rlg3Ezg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NF40di81KTz2ML8IClx26v5lRBSKDg20NnU2kZepG0wtZw81MjeoHhl9l63zHIKJ7
	 qhh9dC7pEgOLxXb76hPtB3ZW+rge3VvCD0Bji7Zmeaotzvs3o51reiShj7+UVfzjbQ
	 +K+TftPdWJ2UA6Ikjww8Pxv6Qp8KD5Y5nH5/e1awrefDfRy1whmdj2l33aISGjc4UQ
	 erPWZklFQs8vSHoqWeR1x7Z4PmJWlADeupXGtD2oFEYQIjE9t5adMI73+mk6zKDEfw
	 dephRWr0vPjH9dd56gkGoqnukoRoSZcnJPH2qiR3GfD4M38E6EB8YNxJxb8ivSeyI2
	 Wb3b3ltqYiuNoqo3KtRfLyFv6k9+Ej0XXgaLuULilEfcR92FaKPubQLK3AxmFeUGXF
	 oGrn+dTNK7wW3hK+gZyuVJc+6ZgPEhH83LtiAxdWx0nhiLvg+z2qb6AqXiuCoo5Uh6
	 5SOtsGZO3atFxahJmrCTBWHINwTHr+1buDij5ha5zwaeCfoAs2HI4eu8G3noK8da7S
	 E5R8B0EXdNwzvHHGhZjEkBk6+XBwZwSGhUrYhnOZmDdHamTy2O5YNzpNXXJSt2gvjl
	 xYxgLVjg8CkLMsGih/F4RJA4et17HCBChOYCI0DkVknU0c4UrvwofaQ3fPpVa1KzJR
	 tmFzRHv2chtAM3BHVaU4/w34=
Received: from zn.tnic (pd9530f8c.dip0.t-ipconnect.de [217.83.15.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5D82A40E0196;
	Thu,  4 Jan 2024 14:42:08 +0000 (UTC)
Date: Thu, 4 Jan 2024 15:42:02 +0100
From: Borislav Petkov <bp@alien8.de>
To: Michael Roth <michael.roth@amd.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev,
	linux-mm@kvack.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
	ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
	rientjes@google.com, tobin@ibm.com, vbabka@suse.cz,
	kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
	pankaj.gupta@amd.com, liam.merwick@oracle.com, zhi.a.wang@intel.com,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v1 04/26] x86/sev: Add the host SEV-SNP initialization
 support
Message-ID: <20240104144202.GGZZbDuutFUFmktT7M@fat_crate.local>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-5-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231230161954.569267-5-michael.roth@amd.com>

On Sat, Dec 30, 2023 at 10:19:32AM -0600, Michael Roth wrote:
> +	if (cpu_has(c, X86_FEATURE_SEV_SNP)) {
> +		/*
> +		 * RMP table entry format is not architectural and it can vary by processor
> +		 * and is defined by the per-processor PPR. Restrict SNP support on the
> +		 * known CPU model and family for which the RMP table entry format is
> +		 * currently defined for.
> +		 */
> +		if (!(c->x86 == 0x19 && c->x86_model <= 0xaf) &&
> +		    !(c->x86 == 0x1a && c->x86_model <= 0xf))
> +			setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
> +		else if (!snp_probe_rmptable_info())
> +			setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
> +	}

IOW, this below.

Lemme send the ZEN5 thing as a separate patch.

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 9492dcad560d..0fa702673e73 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -81,10 +81,8 @@
 #define X86_FEATURE_K6_MTRR		( 3*32+ 1) /* AMD K6 nonstandard MTRRs */
 #define X86_FEATURE_CYRIX_ARR		( 3*32+ 2) /* Cyrix ARRs (= MTRRs) */
 #define X86_FEATURE_CENTAUR_MCR		( 3*32+ 3) /* Centaur MCRs (= MTRRs) */
-
-/* CPU types for specific tunings: */
 #define X86_FEATURE_K8			( 3*32+ 4) /* "" Opteron, Athlon64 */
-/* FREE, was #define X86_FEATURE_K7			( 3*32+ 5) "" Athlon */
+#define X86_FEATURE_ZEN5		( 3*32+ 5) /* "" CPU based on Zen5 microarchitecture */
 #define X86_FEATURE_P3			( 3*32+ 6) /* "" P3 */
 #define X86_FEATURE_P4			( 3*32+ 7) /* "" P4 */
 #define X86_FEATURE_CONSTANT_TSC	( 3*32+ 8) /* TSC ticks at a constant rate */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 0f0d425f0440..46335c2df083 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -539,7 +539,7 @@ static void bsp_init_amd(struct cpuinfo_x86 *c)
 
 	/* Figure out Zen generations: */
 	switch (c->x86) {
-	case 0x17: {
+	case 0x17:
 		switch (c->x86_model) {
 		case 0x00 ... 0x2f:
 		case 0x50 ... 0x5f:
@@ -555,8 +555,8 @@ static void bsp_init_amd(struct cpuinfo_x86 *c)
 			goto warn;
 		}
 		break;
-	}
-	case 0x19: {
+
+	case 0x19:
 		switch (c->x86_model) {
 		case 0x00 ... 0x0f:
 		case 0x20 ... 0x5f:
@@ -570,20 +570,31 @@ static void bsp_init_amd(struct cpuinfo_x86 *c)
 			goto warn;
 		}
 		break;
-	}
+
+	case 0x1a:
+		switch (c->x86_model) {
+		case 0x00 ... 0x0f:
+			setup_force_cpu_cap(X86_FEATURE_ZEN5);
+			break;
+		default:
+			goto warn;
+		}
+		break;
+
 	default:
 		break;
 	}
 
 	if (cpu_has(c, X86_FEATURE_SEV_SNP)) {
 		/*
-		 * RMP table entry format is not architectural and it can vary by processor
+		 * RMP table entry format is not architectural, can vary by processor
 		 * and is defined by the per-processor PPR. Restrict SNP support on the
 		 * known CPU model and family for which the RMP table entry format is
 		 * currently defined for.
 		 */
-		if (!(c->x86 == 0x19 && c->x86_model <= 0xaf) &&
-		    !(c->x86 == 0x1a && c->x86_model <= 0xf))
+		if (!boot_cpu_has(X86_FEATURE_ZEN3) &&
+		    !boot_cpu_has(X86_FEATURE_ZEN4) &&
+		    !boot_cpu_has(X86_FEATURE_ZEN5))
 			setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
 		else if (!snp_probe_rmptable_info())
 			setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
@@ -1055,6 +1066,11 @@ static void init_amd_zen4(struct cpuinfo_x86 *c)
 		msr_set_bit(MSR_ZEN4_BP_CFG, MSR_ZEN4_BP_CFG_SHARED_BTB_FIX_BIT);
 }
 
+static void init_amd_zen5(struct cpuinfo_x86 *c)
+{
+	init_amd_zen_common();
+}
+
 static void init_amd(struct cpuinfo_x86 *c)
 {
 	u64 vm_cr;
@@ -1100,6 +1116,8 @@ static void init_amd(struct cpuinfo_x86 *c)
 		init_amd_zen3(c);
 	else if (boot_cpu_has(X86_FEATURE_ZEN4))
 		init_amd_zen4(c);
+	else if (boot_cpu_has(X86_FEATURE_ZEN5))
+		init_amd_zen5(c);
 
 	/*
 	 * Enable workaround for FXSAVE leak on CPUs


-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

