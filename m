Return-Path: <kvm+bounces-32783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 849F59DF1BC
	for <lists+kvm@lfdr.de>; Sat, 30 Nov 2024 16:32:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 458CA281751
	for <lists+kvm@lfdr.de>; Sat, 30 Nov 2024 15:32:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D4FE1A01CD;
	Sat, 30 Nov 2024 15:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="aynTPl/x"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BA642AA4;
	Sat, 30 Nov 2024 15:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732980731; cv=none; b=NtI1hAmX4zWAxjosbBxFkS6BGuIQmXeFq7gQR1KEkOuHLauCzVHCH1c7mIIWJZUgmTwNFB0wJKoS7YBSraXBBAuuIldEJ86RGQpfrCHrHmpdPyXLbTmwo+9ERjq86sIseNXeZnSxATl/jLaUtiEBHoh7AzrAiWh6Kocf+rMQfm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732980731; c=relaxed/simple;
	bh=atd39sfEYa8AIRbwz1neam2CeZ8nON8tmLneXGitKMc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oFf2/ScCoN0jZ2iHRDLBLOno4hIdKC95Gpf05c9j5mXHTIPqjgUKRmnDveOuf8Xo2hJnKbHY3QFpD6oxcOnIFP7w2DuMHBYTwhCLv9eH0aKbnpweps+Sdn53AWDf0MVan+RCtSkW87ZAaUhl0KdhZc5BK73MURBQmFGpuj1C2og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=aynTPl/x; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id CA27A40E0200;
	Sat, 30 Nov 2024 15:31:59 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id uBT9kWPmAc2E; Sat, 30 Nov 2024 15:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1732980715; bh=p0Xw2eWTFHf6G7iX5vOYtx2ePwAye/zsUxP/14IJGHQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aynTPl/xWnA+iMfn/p/+8WOBZi5ePzg5RGaW4lAashPG0DmTqk3i2hEbkqrucopUf
	 Z1ISlwsYs5KBfpdmgE3vS4g1N6MXpzBrrvZ1+sLoogQN04GOQDWoKjs+9Mc2ZNtoYE
	 JonlMAQC6uSo+5MEscQnfmpTo17aE8G5/gRYGJokgtf7a2L+w5wdLsNIRDzaXCtg3a
	 WPE/HjzJ+MoM85PNzmp9+Fgt2bgscEy7C/ZQFEczDWYm0TbXWMD97yrdx6KeH+wQjo
	 /Nlhi9MR6K+0UVKA9oaWdiI0vssbaE3cEqD9HVK/zxUmQxfrjZMYmm9xQtjweX344T
	 gsLpep4/Fz0hqxanCQvYtjzuYS42wEIAbn5i/xPDhUXBwmX+ohDov/jaU1PI3tVWRg
	 G6zSibqnwDnYvFKyWKe2PcWkLZojwSHDaGCETBvjQojnSpND9UzJxfZGl67WvFAFla
	 Y5rIkwR9tbjn3wgq5UUR2iPqph+rN9U/hJsiTq8G4OveVtJIKBxgzMcBdCzQTb2xDs
	 YSY/7f5yw9mAM+3sxFYli0JBDrbMFs7XaahP3ezbNYGWR5qFNBSg27qXeypu5IPVZ3
	 MIflUmJ04ZVmPlPKhgDbShuHLv9DwUXPA+Mf9AF3LyIk+F+SRd1keN7FIwTgDMgKSe
	 zgB84kFEHoN7dwUP3YzxZsms=
Received: from zn.tnic (p200300Ea9736A15f329c23FFfEa6A903.dip0.t-ipconnect.de [IPv6:2003:ea:9736:a15f:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 72AB540E0196;
	Sat, 30 Nov 2024 15:31:31 +0000 (UTC)
Date: Sat, 30 Nov 2024 16:31:25 +0100
From: Borislav Petkov <bp@alien8.de>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, amit@kernel.org,
	kvm@vger.kernel.org, amit.shah@amd.com, thomas.lendacky@amd.com,
	tglx@linutronix.de, peterz@infradead.org,
	pawan.kumar.gupta@linux.intel.com, corbet@lwn.net, mingo@redhat.com,
	dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, daniel.sneddon@linux.intel.com,
	kai.huang@intel.com, sandipan.das@amd.com,
	boris.ostrovsky@oracle.com, Babu.Moger@amd.com,
	david.kaplan@amd.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com
Subject: Re: [PATCH v2 1/2] x86/bugs: Don't fill RSB on VMEXIT with
 eIBRS+retpoline
Message-ID: <20241130153125.GBZ0svzaVIMOHBOBS2@fat_crate.local>
References: <cover.1732219175.git.jpoimboe@kernel.org>
 <9bd7809697fc6e53c7c52c6c324697b99a894013.1732219175.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9bd7809697fc6e53c7c52c6c324697b99a894013.1732219175.git.jpoimboe@kernel.org>

On Thu, Nov 21, 2024 at 12:07:18PM -0800, Josh Poimboeuf wrote:
> eIBRS protects against RSB underflow/poisoning attacks.  Adding
> retpoline to the mix doesn't change that.  Retpoline has a balanced
> CALL/RET anyway.

This is exactly why I've been wanting for us to document our mitigations for
a long time now.

A bunch of statements above for which I can only rhyme up they're correct if
I search for the vendor docs. On the AMD side I've found:

"When Automatic IBRS is enabled, the internal return address stack used for
return address predictions is cleared on VMEXIT."

APM v2, p. 58/119

For the Intel side I'm not that lucky. There's something here:

https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/branch-history-injection.html

Or is it this one:

https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/speculative-execution-side-channel-mitigations.html#inpage-nav-1-3-undefined

Or is this written down explicitly in some other doc?

In any case, I'd like for us to do have a piece of text accompanying such
patches, perhaps here:

Documentation/admin-guide/hw-vuln/spectre.rst

which quotes the vendor docs.

The current thread(s) on the matter already show how much confused we all are
by all the possible mitigation options, uarch speculative dances etc etc.

> So the current full RSB filling on VMEXIT with eIBRS+retpoline is
> overkill.  Disable it (or do the VMEXIT_LITE mitigation if needed).
> 
> Suggested-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> Reviewed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> Reviewed-by: Amit Shah <amit.shah@amd.com>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
>  arch/x86/kernel/cpu/bugs.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index 47a01d4028f6..68bed17f0980 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -1605,20 +1605,20 @@ static void __init spectre_v2_determine_rsb_fill_type_at_vmexit(enum spectre_v2_
>  	case SPECTRE_V2_NONE:
>  		return;
>  
> -	case SPECTRE_V2_EIBRS_LFENCE:
>  	case SPECTRE_V2_EIBRS:
> +	case SPECTRE_V2_EIBRS_LFENCE:
> +	case SPECTRE_V2_EIBRS_RETPOLINE:
>  		if (boot_cpu_has_bug(X86_BUG_EIBRS_PBRSB)) {
> -			setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT_LITE);
>  			pr_info("Spectre v2 / PBRSB-eIBRS: Retire a single CALL on VMEXIT\n");
> +			setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT_LITE);

Why are you swapping those?

>  		}
>  		return;
>  
> -	case SPECTRE_V2_EIBRS_RETPOLINE:
>  	case SPECTRE_V2_RETPOLINE:
>  	case SPECTRE_V2_LFENCE:
>  	case SPECTRE_V2_IBRS:
> -		setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT);
>  		pr_info("Spectre v2 / SpectreRSB : Filling RSB on VMEXIT\n");
> +		setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT);

Ditto?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

