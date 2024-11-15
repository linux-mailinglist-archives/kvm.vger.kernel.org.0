Return-Path: <kvm+bounces-31951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 027919CF348
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 18:51:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6901288B38
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 17:51:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E18A1D63FE;
	Fri, 15 Nov 2024 17:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lHzpx8F+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C066F1D5ABF;
	Fri, 15 Nov 2024 17:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731693062; cv=none; b=cFCmabh5cOirWszsD1vhJ5iTeLmgILkeLnxxoBH6Ae4/t0kwUsaU9IcUGOQIMpRpbweRbssPcVRbLTt/yzQJnDBtxExC492iEs2E6mfhdzfGxoszoZig3U0/SlmWUAnkpudUN3Ws8pPBBLxDDbQhbrN/7beNSOhQdeKV09FipTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731693062; c=relaxed/simple;
	bh=eOClkgrOVtMDm45l3c+YNZVXOx9yYAT8GkXLpLBSVLk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XwXfsiU9KRg0OHN6txgZ8h3DeijFI0ebkeyL6dz5stxdscyQ6AH7eEBaaKd4xajnXrilgcoYg3DUZWmp8z7FtpnsCVteTR92vx8ANzfjVjuIWTs9QgD6b5/LNgoW5X0pv9YBGigDGrGZyBeY24n4c05RNE0Q1BsNc+9l6Jfk5/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lHzpx8F+; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731693061; x=1763229061;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eOClkgrOVtMDm45l3c+YNZVXOx9yYAT8GkXLpLBSVLk=;
  b=lHzpx8F+nIml8OxrDKnd/kRvm7MR6lax+XpWrVyQ2d5Byf06klZHWOdQ
   U+IgTdyPKYPhWpm1ZapKNBbAdAD7seOWtpmo7MAo4asQcKidYe4Hk5jAB
   S4eplyZLVqf6TpoA7vdB/ukx+wMIcrnW2qDjbOmHPmkNUQgtN9Q6Z+KiQ
   oyCqglXV48F70KGM4Qzi27hKZk7mvnkIgTSXOFoZnDUcJIAK2YKwM3Yzz
   32QeQJfad6i90o1EFHyO2z/qLsaSWE7LbVOGyKDZ9NT6KinD0vyELZMzn
   7llkPuOInnyObSk1JXXkLp0mCBQdZQ08gaeBmmo1MthWDtYo18auMxO0M
   w==;
X-CSE-ConnectionGUID: fT3isI6dT9C2KXelWCsUNA==
X-CSE-MsgGUID: 8+Fyc/vlQXKKjX7plPlPPg==
X-IronPort-AV: E=McAfee;i="6700,10204,11257"; a="31552189"
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="31552189"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 09:51:00 -0800
X-CSE-ConnectionGUID: /PICrEOzSBOkM4HFyehSMw==
X-CSE-MsgGUID: s1Pp92IeQPyEIC0WsvzYXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="88386465"
Received: from howardworkpc.ccr.corp.intel.com (HELO desk) ([10.125.145.119])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 09:50:58 -0800
Date: Fri, 15 Nov 2024 09:50:47 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>, Amit Shah <amit@kernel.org>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
	linux-doc@vger.kernel.org, amit.shah@amd.com,
	thomas.lendacky@amd.com, bp@alien8.de, tglx@linutronix.de,
	peterz@infradead.org, corbet@lwn.net, mingo@redhat.com,
	dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, daniel.sneddon@linux.intel.com,
	kai.huang@intel.com, sandipan.das@amd.com,
	boris.ostrovsky@oracle.com, Babu.Moger@amd.com,
	david.kaplan@amd.com, dwmw@amazon.co.uk
Subject: Re: [RFC PATCH v2 1/3] x86: cpu/bugs: update SpectreRSB comments for
 AMD
Message-ID: <20241115175047.bszpeakeodajczav@desk>
References: <20241111163913.36139-2-amit@kernel.org>
 <20241111193304.fjysuttl6lypb6ng@jpoimboe>
 <564a19e6-963d-4cd5-9144-2323bdb4f4e8@citrix.com>
 <20241112014644.3p2a6te3sbh5x55c@jpoimboe>
 <20241112214241.fzqq6sqszqd454ei@desk>
 <20241113202105.py5imjdy7pctccqi@jpoimboe>
 <20241114015505.6kghgq33i4m6jrm4@desk>
 <20241114023141.n4n3zl7622gzsf75@jpoimboe>
 <20241114075403.7wxou7g5udaljprv@desk>
 <20241115054836.oubgh4jbyvjum4tk@jpoimboe>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241115054836.oubgh4jbyvjum4tk@jpoimboe>

On Thu, Nov 14, 2024 at 09:48:36PM -0800, Josh Poimboeuf wrote:
> According to the docs, classic IBRS also needs RSB filling at context
> switch to protect against corrupt RSB entries (as opposed to RSB
> underflow).

Correct.

> Something like so...
> 
> 
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index 47a01d4028f6..7b9c0a21e478 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -1579,27 +1579,44 @@ static void __init spec_ctrl_disable_kernel_rrsba(void)
>  	rrsba_disabled = true;
>  }
>  
> -static void __init spectre_v2_determine_rsb_fill_type_at_vmexit(enum spectre_v2_mitigation mode)
> +static void __init spectre_v2_mitigate_rsb(enum spectre_v2_mitigation mode)
>  {
>  	/*
> -	 * Similar to context switches, there are two types of RSB attacks
> -	 * after VM exit:
> +	 * In general there are two types of RSB attacks:
>  	 *
> -	 * 1) RSB underflow
> +	 * 1) RSB underflow ("Intel Retbleed")
> +	 *
> +	 *    Some Intel parts have "bottomless RSB".  When the RSB is empty,
> +	 *    speculated return targets may come from the branch predictor,
> +	 *    which could have a user-poisoned BTB or BHB entry.
> +	 *
> +	 *    user->user attacks are mitigated by IBPB on context switch.
> +	 *
> +	 *    user->kernel attacks via context switch are mitigated by IBRS,
> +	 *    eIBRS, or RSB filling.
> +	 *
> +	 *    user->kernel attacks via kernel entry are mitigated by IBRS,
> +	 *    eIBRS, or call depth tracking.
> +	 *
> +	 *    On VMEXIT, guest->host attacks are mitigated by IBRS, eIBRS, or
> +	 *    RSB filling.
>  	 *
>  	 * 2) Poisoned RSB entry
>  	 *
> -	 * When retpoline is enabled, both are mitigated by filling/clearing
> -	 * the RSB.
> +	 *    On a context switch, the previous task can poison RSB entries
> +	 *    used by the next task, controlling its speculative return
> +	 *    targets.  Poisoned RSB entries can also be created by "AMD
> +	 *    Retbleed" or SRSO.
>  	 *
> -	 * When IBRS is enabled, while #1 would be mitigated by the IBRS branch
> -	 * prediction isolation protections, RSB still needs to be cleared
> -	 * because of #2.  Note that SMEP provides no protection here, unlike
> -	 * user-space-poisoned RSB entries.
> +	 *    user->user attacks are mitigated by IBPB on context switch.
>  	 *
> -	 * eIBRS should protect against RSB poisoning, but if the EIBRS_PBRSB
> -	 * bug is present then a LITE version of RSB protection is required,
> -	 * just a single call needs to retire before a RET is executed.
> +	 *    user->kernel attacks via context switch are prevented by
> +	 *    SMEP+eIBRS+SRSO mitigations, or RSB clearing.
> +	 *
> +	 *    guest->host attacks are mitigated by eIBRS or RSB clearing on
> +	 *    VMEXIT.  eIBRS implementations with X86_BUG_EIBRS_PBRSB still
> +	 *    need "lite" RSB filling which retires a CALL before the first
> +	 *    RET.
>  	 */
>  	switch (mode) {
>  	case SPECTRE_V2_NONE:
> @@ -1608,8 +1625,8 @@ static void __init spectre_v2_determine_rsb_fill_type_at_vmexit(enum spectre_v2_
>  	case SPECTRE_V2_EIBRS_LFENCE:
>  	case SPECTRE_V2_EIBRS:
>  		if (boot_cpu_has_bug(X86_BUG_EIBRS_PBRSB)) {
> -			setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT_LITE);
>  			pr_info("Spectre v2 / PBRSB-eIBRS: Retire a single CALL on VMEXIT\n");
> +			setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT_LITE);
>  		}
>  		return;
>  
> @@ -1617,12 +1634,13 @@ static void __init spectre_v2_determine_rsb_fill_type_at_vmexit(enum spectre_v2_
>  	case SPECTRE_V2_RETPOLINE:
>  	case SPECTRE_V2_LFENCE:
>  	case SPECTRE_V2_IBRS:
> +		pr_info("Spectre v2 / SpectreRSB : Filling RSB on context switch and VMEXIT\n");
> +		setup_force_cpu_cap(X86_FEATURE_RSB_CTXSW);
>  		setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT);
> -		pr_info("Spectre v2 / SpectreRSB : Filling RSB on VMEXIT\n");
>  		return;
>  	}
>  
> -	pr_warn_once("Unknown Spectre v2 mode, disabling RSB mitigation at VM exit");
> +	pr_warn_once("Unknown Spectre v2 mode, disabling RSB mitigation\n");
>  	dump_stack();
>  }
>  
> @@ -1817,48 +1835,7 @@ static void __init spectre_v2_select_mitigation(void)
>  	spectre_v2_enabled = mode;
>  	pr_info("%s\n", spectre_v2_strings[mode]);
>  
> -	/*
> -	 * If Spectre v2 protection has been enabled, fill the RSB during a
> -	 * context switch.  In general there are two types of RSB attacks
> -	 * across context switches, for which the CALLs/RETs may be unbalanced.
> -	 *
> -	 * 1) RSB underflow
> -	 *
> -	 *    Some Intel parts have "bottomless RSB".  When the RSB is empty,
> -	 *    speculated return targets may come from the branch predictor,
> -	 *    which could have a user-poisoned BTB or BHB entry.
> -	 *
> -	 *    AMD has it even worse: *all* returns are speculated from the BTB,
> -	 *    regardless of the state of the RSB.
> -	 *
> -	 *    When IBRS or eIBRS is enabled, the "user -> kernel" attack
> -	 *    scenario is mitigated by the IBRS branch prediction isolation
> -	 *    properties, so the RSB buffer filling wouldn't be necessary to
> -	 *    protect against this type of attack.
> -	 *
> -	 *    The "user -> user" attack scenario is mitigated by RSB filling.
> -	 *
> -	 * 2) Poisoned RSB entry
> -	 *
> -	 *    If the 'next' in-kernel return stack is shorter than 'prev',
> -	 *    'next' could be tricked into speculating with a user-poisoned RSB
> -	 *    entry.
> -	 *
> -	 *    The "user -> kernel" attack scenario is mitigated by SMEP and
> -	 *    eIBRS.
> -	 *
> -	 *    The "user -> user" scenario, also known as SpectreBHB, requires
> -	 *    RSB clearing.
> -	 *
> -	 * So to mitigate all cases, unconditionally fill RSB on context
> -	 * switches.
> -	 *
> -	 * FIXME: Is this pointless for retbleed-affected AMD?
> -	 */
> -	setup_force_cpu_cap(X86_FEATURE_RSB_CTXSW);
> -	pr_info("Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch\n");
> -
> -	spectre_v2_determine_rsb_fill_type_at_vmexit(mode);
> +	spectre_v2_mitigate_rsb(mode);
>  
>  	/*
>  	 * Retpoline protects the kernel, but doesn't protect firmware.  IBRS

This LGTM.

I think SPECTRE_V2_EIBRS_RETPOLINE is placed in the wrong leg, it
doesn't need RSB filling on context switch, and only needs VMEXIT_LITE.
Does below change on top of your patch look okay?

---
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 7b9c0a21e478..d3b9a0d7a2b5 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1622,6 +1622,7 @@ static void __init spectre_v2_mitigate_rsb(enum spectre_v2_mitigation mode)
 	case SPECTRE_V2_NONE:
 		return;
 
+	case SPECTRE_V2_EIBRS_RETPOLINE:
 	case SPECTRE_V2_EIBRS_LFENCE:
 	case SPECTRE_V2_EIBRS:
 		if (boot_cpu_has_bug(X86_BUG_EIBRS_PBRSB)) {
@@ -1630,7 +1631,6 @@ static void __init spectre_v2_mitigate_rsb(enum spectre_v2_mitigation mode)
 		}
 		return;
 
-	case SPECTRE_V2_EIBRS_RETPOLINE:
 	case SPECTRE_V2_RETPOLINE:
 	case SPECTRE_V2_LFENCE:
 	case SPECTRE_V2_IBRS:

