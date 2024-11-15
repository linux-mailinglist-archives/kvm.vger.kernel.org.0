Return-Path: <kvm+bounces-31953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 787729CF3B4
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 19:14:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 89D9CB34751
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 18:10:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EDEF1D90C8;
	Fri, 15 Nov 2024 18:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k38b0/Zm"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219021D63D8;
	Fri, 15 Nov 2024 18:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731694208; cv=none; b=OpK7qxw3N99en9vqHbxCC41YtagbHPz2SQYXxVx4v0kZ7Rk+mEOHjt1aoVZ5NevWTZ+YN8HdiCMg41w/iLTV9a4LVFJ9PH2Ihru7zcTL0h7zPdT7H2hXGOnbTooHcx3lSPYVwWFsAULEuwnVQG4pipETU6M//haJ1DQzRzQ1XnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731694208; c=relaxed/simple;
	bh=YgDWh7MuRJtreRCSinehYy17Xkaqrqv27zLpvuYPGZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RACB35NUwrdfQ1EVOtP8AwpgQAjOsx0+5x3sCGRJx0tOZaROu8UXU2uMnkhBS24l4htEYmKQ2iAw4PV5loPxb6Km9SRO+or1f4gFU7c8Zsglt8BuVRSGRAw3savC9AB2ZAin3xPYZ6cj9Jz6md+HCKvlFGbmCiw7CAQ5wYQWmwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k38b0/Zm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0880C4CECF;
	Fri, 15 Nov 2024 18:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731694207;
	bh=YgDWh7MuRJtreRCSinehYy17Xkaqrqv27zLpvuYPGZY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k38b0/ZmWxERO66g5HXAEdXIc+zOPIaOdzsFdis2xGnymjnKpTPKTyJRtcAREAG/r
	 p7J69wCgMMtYlC5G/Wz2CffKTn9W0wPpcNOhxvZxATbwqy4Y/bB3Xydzk1YIfN6klJ
	 rV3Faa8hurhsSfFL++/to3cukwlNiP/ZM4jyJHB7ybS0xnTpERsGGOcCQC5KRWvC4v
	 hIWUxV+3YrrIdQKqAUeIQCHB0+ge7kEvFpWqckqpDre+3hVdR8/SiaTzuZcBmLgjBc
	 pLOXrzJFQTiBmm0nmaV5CWbSKyeslozweQFlQM8KUGmDhwiMwxUfcPLjONCFVQDbCc
	 4M9mBMhDDeedg==
Date: Fri, 15 Nov 2024 10:10:05 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
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
Message-ID: <20241115181005.xxlebbykksmimgqj@jpoimboe>
References: <20241111193304.fjysuttl6lypb6ng@jpoimboe>
 <564a19e6-963d-4cd5-9144-2323bdb4f4e8@citrix.com>
 <20241112014644.3p2a6te3sbh5x55c@jpoimboe>
 <20241112214241.fzqq6sqszqd454ei@desk>
 <20241113202105.py5imjdy7pctccqi@jpoimboe>
 <20241114015505.6kghgq33i4m6jrm4@desk>
 <20241114023141.n4n3zl7622gzsf75@jpoimboe>
 <20241114075403.7wxou7g5udaljprv@desk>
 <20241115054836.oubgh4jbyvjum4tk@jpoimboe>
 <20241115175047.bszpeakeodajczav@desk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241115175047.bszpeakeodajczav@desk>

On Fri, Nov 15, 2024 at 09:50:47AM -0800, Pawan Gupta wrote:
> This LGTM.
> 
> I think SPECTRE_V2_EIBRS_RETPOLINE is placed in the wrong leg, it
> doesn't need RSB filling on context switch, and only needs VMEXIT_LITE.
> Does below change on top of your patch look okay?

Yeah, I was wondering about that too.  Since it changes existing
VMEXIT_LITE behavior I'll make it a separate patch.  And I'll probably
do the comment changes in a separate patch as well.

> ---
> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
> index 7b9c0a21e478..d3b9a0d7a2b5 100644
> --- a/arch/x86/kernel/cpu/bugs.c
> +++ b/arch/x86/kernel/cpu/bugs.c
> @@ -1622,6 +1622,7 @@ static void __init spectre_v2_mitigate_rsb(enum spectre_v2_mitigation mode)
>  	case SPECTRE_V2_NONE:
>  		return;
>  
> +	case SPECTRE_V2_EIBRS_RETPOLINE:
>  	case SPECTRE_V2_EIBRS_LFENCE:
>  	case SPECTRE_V2_EIBRS:
>  		if (boot_cpu_has_bug(X86_BUG_EIBRS_PBRSB)) {
> @@ -1630,7 +1631,6 @@ static void __init spectre_v2_mitigate_rsb(enum spectre_v2_mitigation mode)
>  		}
>  		return;
>  
> -	case SPECTRE_V2_EIBRS_RETPOLINE:
>  	case SPECTRE_V2_RETPOLINE:
>  	case SPECTRE_V2_LFENCE:
>  	case SPECTRE_V2_IBRS:

-- 
Josh

