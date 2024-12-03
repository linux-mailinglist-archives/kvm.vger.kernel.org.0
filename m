Return-Path: <kvm+bounces-32919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B8549E1B31
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 12:43:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E56A0164A86
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 11:43:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEB2D1E47A8;
	Tue,  3 Dec 2024 11:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="bvIPASl/"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2812A1E048B;
	Tue,  3 Dec 2024 11:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733226199; cv=none; b=Qce/0GWYVuQGyVvm3VKbaj0MVWNTrFeo1w4CX+QeozZUyjjRs+CQQ+45J/Z7AB+YmslhzE75CGikTvsA+x0vt+nkp3vQEuHHemAiXV7UwwAwR6kwntNFStmkORRoDxoL6BpVrBgG7CtqkW+t9PIMjz5s4+b0LSKezqsWlHFE5+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733226199; c=relaxed/simple;
	bh=TP4oWWRoWB9oDoCBaM6wd7B2S+SZW4juNLdha6OOrYs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=De51HtzC7BOMZANe4lIjxhjzlkRIH+6JfgOAc6Vt3vjoK7SlMEyW6cA27rtH3ykM7TzsKcd1qxWmjMslcU5xhFKKF8caQ07hhZIn3niP8iE/yY5uB7jkcAef3sZRpoX7QSKhj1ea6tVyMRrOncT8RzYcXRQUyWIfPiuxqQsI02k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=bvIPASl/; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 6FA4240E0274;
	Tue,  3 Dec 2024 11:43:13 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id tzzPdu0d0kB3; Tue,  3 Dec 2024 11:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1733226188; bh=se2wt5/NEXsNDYgytFIIFUWOZroMU1ML1ye6Yajp2Jg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bvIPASl/5eM3e1aRqwr3BPcKCOstbQC8ZNpNgE1Q/DrT3oo82ssfNFAm0Ao7gN0Vt
	 U3kiUJlHFkZEGqW+5KhJmoBYCMEyX8yPrQh/tAuMW6QRbcVntK6Euk08+SQlQxCswA
	 +Bdn+oxdM+TbCEiIkILXMNNQRTFZKMCsWcVJnNeVkvTptjBwV+VbdVqt7b5KMxEgB7
	 aziz09VRwNzL+/AVr3hn7Ru6K++2eqUmSQ7NMKMp4xThxaNmxk7U3GY0Gep+prhqRI
	 pju+8W1mePCqfM5AIzSqJPTXv1g3i6pHAq32MdfHqsU82rERL8qT+6xPRu5pW9E0/c
	 qcnZu7XoLx4Y2IDnSTOpRb8eoJq0Qv6ACJlCKNYcXH95ZzJdULxvBwF4fAhuPr7p3Q
	 rY3v+GNmFP2dTiBSia/nLqk60j2m/h5bfEgg4JEs5VjnimdHl0Mx4QtKFwCyiURBnj
	 vPxkD+Tu5UBWfgz3j3YOhYeP1TfOOX9RI1cjRmLVq14JxGLt6g1Fj0gGVHDAOx+bl6
	 mMpixm4YTPDbP/yg1DnEjPb39CzcsGYv4zBvxa8lPZjTHkHzKlCQKzJ3IMyy35wUvT
	 WBv03iETPWk5+AO6H0ENNLmeM3JZyw4pu/to/qKZ3AIqbf4J1WB0bh1s0veTtcoQHb
	 6l2DLkAR0vH9yot7cF0W9ljs=
Received: from zn.tnic (pd9530b86.dip0.t-ipconnect.de [217.83.11.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id ED3D540E01A2;
	Tue,  3 Dec 2024 11:42:43 +0000 (UTC)
Date: Tue, 3 Dec 2024 12:42:38 +0100
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
Subject: Re: [PATCH v2 2/2] x86/bugs: Don't fill RSB on context switch with
 eIBRS
Message-ID: <20241203114238.GCZ07urmujPfwsDJ4G@fat_crate.local>
References: <cover.1732219175.git.jpoimboe@kernel.org>
 <d6b0c08000aa96221239ace37dd53e3f1919926c.1732219175.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d6b0c08000aa96221239ace37dd53e3f1919926c.1732219175.git.jpoimboe@kernel.org>

On Thu, Nov 21, 2024 at 12:07:19PM -0800, Josh Poimboeuf wrote:
> @@ -1579,31 +1579,48 @@ static void __init spec_ctrl_disable_kernel_rrsba(void)
>  	rrsba_disabled = true;
>  }
>  
> -static void __init spectre_v2_determine_rsb_fill_type_at_vmexit(enum spectre_v2_mitigation mode)
> +static void __init spectre_v2_mitigate_rsb(enum spectre_v2_mitigation mode)

mitigate the return stack buffer?

The previous name was describing better what this function does...

Perhaps

	spectre_v2_determine_rsb_handling()

or so. "Handling" to mean, what do to with the RSB based on the selected
Spectre v2 mitigation.

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

This is exactly what I mean with expanding this in Documentation/: Which parts
are those? 

> +	 *    speculated return targets may come from the branch predictor,
> +	 *    which could have a user-poisoned BTB or BHB entry.

Also there we could explain what those alternative predictors are:

"RSBA: The processor supports RSB Alternate. Alternative branch predictors may
be used by RET instructions when the RSB is empty."

https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/speculative-execution-side-channel-mitigations.html

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

I like the explanation of every attack vector. I'd like even more if that were
expanded in Documentation/ and we can always go look it up there when touching
this code or reviewing patches touching it.

>  	 *
>  	 * 2) Poisoned RSB entry
>  	 *
> -	 * When retpoline is enabled, both are mitigated by filling/clearing
> -	 * the RSB.
> +	 *    On a context switch, the previous task can poison RSB entries
> +	 *    used by the next task, controlling its speculative return
> +	 *    targets.  Poisoned RSB entries can also be created by "AMD
> +	 *    Retbleed" or SRSO.

"... by the AMD Retbleed variant... "

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

we call it "RSB filling" above. What's the difference?

The hw *IBRS* vs our RSB stuffing sw sequence?

> +	 *    guest->host attacks are mitigated by eIBRS or RSB clearing on
> +	 *    VMEXIT.

I think you mean our sw RSB stuffing sequence here.

> eIBRS implementations with X86_BUG_EIBRS_PBRSB still
> +	 *    need "lite" RSB filling which retires a CALL before the first
> +	 *    RET.
>  	 */
>  	switch (mode) {
>  	case SPECTRE_V2_NONE:
> -		return;
> +		break;
>  
>  	case SPECTRE_V2_EIBRS:
>  	case SPECTRE_V2_EIBRS_LFENCE:
> @@ -1612,18 +1629,21 @@ static void __init spectre_v2_determine_rsb_fill_type_at_vmexit(enum spectre_v2_
>  			pr_info("Spectre v2 / PBRSB-eIBRS: Retire a single CALL on VMEXIT\n");
>  			setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT_LITE);
>  		}
> -		return;
> +		break;
>  
>  	case SPECTRE_V2_RETPOLINE:
>  	case SPECTRE_V2_LFENCE:
>  	case SPECTRE_V2_IBRS:
> -		pr_info("Spectre v2 / SpectreRSB : Filling RSB on VMEXIT\n");
> +		pr_info("Spectre v2 / SpectreRSB: Filling RSB on context switch and VMEXIT\n");
> +		setup_force_cpu_cap(X86_FEATURE_RSB_CTXSW);

Aha, with "RSB filling" you mean our sw sequence.

It would be good to have those explained properly and have some text
establishing the terminology we're using.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

