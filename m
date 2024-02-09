Return-Path: <kvm+bounces-8454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DBF184FB05
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 18:29:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E39AE1F233EA
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 17:29:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A45CB7E77F;
	Fri,  9 Feb 2024 17:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="UwPkD79u"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC5053398;
	Fri,  9 Feb 2024 17:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707499763; cv=none; b=Dc32LrXK2MXeBuWdATpPl1Ja9xXXC+cPw3GJCwqqI8IiTGnYPdLJ6eQn3IGXPcu6gi5R6g0vcIUuwLRZeLxruLB32WY3UXCcTWMML1fYnZ93g+hoQWM/y+C49ZZlEUJ0CMxY3UaRBpjm5VexI6npfVuVC7xq+oFIXNCjpOKI6dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707499763; c=relaxed/simple;
	bh=EkSrADbaed32E6a2US7Oxs/9b3BCmWx75oCYAcCz+8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RhXZgCwZvNyUi8PgcJx8G3x6mJHSSKM4ANVAhTVdUQKc5j+E/4xYyQcwS4iY9TqLCFkWfmnYk8Mf/o6PKxIPzXsYUH1NGWBCV186RPid3UbeeBOK4pCEtSH/gak2mKy8ONGEZQrd4l7+XL2+MOdyfWkTT3AOrEBVV+6Cpw97TtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=UwPkD79u; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A4DA040E0192;
	Fri,  9 Feb 2024 17:29:16 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id qdR596g8WX8w; Fri,  9 Feb 2024 17:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1707499754; bh=Nhpf7nFX+VKx5DMtuC+3xgYTTGAyZzaetOFhzVHC8Nc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UwPkD79uaru0szKr6LQup8rGQC0VLRA/G/HDHxKu11YMBHKC2jaiLhqUpwQoSIO9p
	 DRsQSpe/jxN3Enz/X09DGOQiQBjewfZ1xnKHausobJ+gR0sBoupHZJKm4f5OmoKDgB
	 W38NtSDJZ3BRM607eMJLifVaz6VdVPqtEi1QENlY5FyG2kdYO4T6b81pX4wRb0tTjw
	 TxyiGnC56cVzvu4k9ma31gI+bDKoVKqjpx06jLwV+OvFyzwq/5ddaN5tey4b+HXytM
	 Ip9vi0qekSL4KiF5gPN1b9kbmN47QBqZ83fXMXhfMvphOY4l6KGNHPrstgcOsnrx+s
	 Dc4J1Na4gAe16xnha/Jq8JabC4UE37ci5R/pbA0RMIpN/DMLBnn9apLa5J6sZA69TY
	 8CDs8yR5SOELuhpnId/yRtbt9PlWYRrdxfQJZFGYNMimcztCfp//t2a16QRss+WbaQ
	 B9KexYWD+UeBtqy5Rd7ehvcddc+KOWn05uogF9HLdRzMbEYblWWuWCW254eaogFM6F
	 0fTuWLQHK4YVyi8FlmBKWV6vvxuvinjWk95cmCADnGDrpztkVUKXBCJBdQX/eX7J/V
	 fiNSSnwcucFzD/dcwUs1/673SbH+A3dk0TiqvWRGCAEBSONNvp4qgaP089LKnPDVH1
	 sHNzieMnPfmaQc4voF98lHf4=
Received: from zn.tnic (pd953021b.dip0.t-ipconnect.de [217.83.2.27])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DE2CA40E00B2;
	Fri,  9 Feb 2024 17:28:48 +0000 (UTC)
Date: Fri, 9 Feb 2024 18:28:43 +0100
From: Borislav Petkov <bp@alien8.de>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Andy Lutomirski <luto@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
	ak@linux.intel.com, tim.c.chen@linux.intel.com,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	Alyssa Milburn <alyssa.milburn@linux.intel.com>,
	Daniel Sneddon <daniel.sneddon@linux.intel.com>,
	antonio.gomez.iglesias@linux.intel.com,
	Alyssa Milburn <alyssa.milburn@intel.com>, stable@kernel.org
Subject: Re: [PATCH  v7 1/6] x86/bugs: Add asm helpers for executing VERW
Message-ID: <20240209172843.GUZcZgy7EktXgKZQoc@fat_crate.local>
References: <20240204-delay-verw-v7-0-59be2d704cb2@linux.intel.com>
 <20240204-delay-verw-v7-1-59be2d704cb2@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240204-delay-verw-v7-1-59be2d704cb2@linux.intel.com>

On Sun, Feb 04, 2024 at 11:18:59PM -0800, Pawan Gupta wrote:
>  .popsection
> +
> +/*
> + * Defines the VERW operand that is disguised as entry code so that

"Define..."

> + * it can be referenced with KPTI enabled. This ensures VERW can be

"Ensure..."

But committer can fix those.

> + * used late in exit-to-user path after page tables are switched.
> + */
> +.pushsection .entry.text, "ax"
> +
> +.align L1_CACHE_BYTES, 0xcc
> +SYM_CODE_START_NOALIGN(mds_verw_sel)
> +	UNWIND_HINT_UNDEFINED
> +	ANNOTATE_NOENDBR
> +	.word __KERNEL_DS
> +.align L1_CACHE_BYTES, 0xcc
> +SYM_CODE_END(mds_verw_sel);
> +/* For KVM */
> +EXPORT_SYMBOL_GPL(mds_verw_sel);
> +
> +.popsection
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index fdf723b6f6d0..2b62cdd8dd12 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -95,7 +95,7 @@
>  #define X86_FEATURE_SYSENTER32		( 3*32+15) /* "" sysenter in IA32 userspace */
>  #define X86_FEATURE_REP_GOOD		( 3*32+16) /* REP microcode works well */
>  #define X86_FEATURE_AMD_LBR_V2		( 3*32+17) /* AMD Last Branch Record Extension Version 2 */
> -/* FREE, was #define X86_FEATURE_LFENCE_RDTSC		( 3*32+18) "" LFENCE synchronizes RDTSC */
> +#define X86_FEATURE_CLEAR_CPU_BUF	( 3*32+18) /* "" Clear CPU buffers using VERW */
>  #define X86_FEATURE_ACC_POWER		( 3*32+19) /* AMD Accumulated Power Mechanism */
>  #define X86_FEATURE_NOPL		( 3*32+20) /* The NOPL (0F 1F) instructions */
>  #define X86_FEATURE_ALWAYS		( 3*32+21) /* "" Always-present feature */
> diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> index 262e65539f83..ec85dfe67123 100644
> --- a/arch/x86/include/asm/nospec-branch.h
> +++ b/arch/x86/include/asm/nospec-branch.h
> @@ -315,6 +315,21 @@
>  #endif
>  .endm
>  
> +/*
> + * Macros to execute VERW instruction that mitigate transient data sampling
> + * attacks such as MDS. On affected systems a microcode update overloaded VERW
> + * instruction to also clear the CPU buffers. VERW clobbers CFLAGS.ZF.
> + *
> + * Note: Only the memory operand variant of VERW clears the CPU buffers.
> + */
> +.macro EXEC_VERW

I think I asked this already:

Why isn't this called simply "VERW"?

There's no better name as this is basically the insn itself...

> +	verw _ASM_RIP(mds_verw_sel)
> +.endm

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

