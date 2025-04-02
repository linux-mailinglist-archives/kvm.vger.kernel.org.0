Return-Path: <kvm+bounces-42508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8601AA7962B
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 21:59:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F17B418953EE
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 19:59:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D53811EF0B6;
	Wed,  2 Apr 2025 19:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cm4hVhl4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033336AA7;
	Wed,  2 Apr 2025 19:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743623948; cv=none; b=iMy/Exl9evUgD0ZJTDsg2cHRh/CTZ4J7AbObigjjX8QIamBOU53zPgNZTMR15Unj5D8pa+Vpfc3X02VAgqEJPrZfLz1IcPqCSQvX7ycAH1wrQyd3lQkvMPQW9J82SN42NYUXZ4ic0jLIQMZJn4UyG2mOgqvxbMrZgQQxurA5KJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743623948; c=relaxed/simple;
	bh=Bn+u6Kx45nDcLdfvNklpiLTe4/XcNWu6wxgrWAIrdHE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FmVbEdLfOvYgZf9GbPtbvZEl41z3TsxDNXppgy+v38b5lR9B8kpRfLSAWtzTTXSUIAMOgcyQXLZzC3H2Uy0/egFrfzPUTmjdUQgvSHkxPlSENjO3FXMdZYLHkaDccUccBG+eOL1USkvnbNm8GhEM2a66jLW6wnGhnY9oxKGL0QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cm4hVhl4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292E9C4CEDD;
	Wed,  2 Apr 2025 19:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743623947;
	bh=Bn+u6Kx45nDcLdfvNklpiLTe4/XcNWu6wxgrWAIrdHE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Cm4hVhl4k+0sff4W5VEgYulv8qj9NlsxjbA6m2IZqleENZRRgKe3xjavD5Jlg/Lg1
	 H3uHR2sS0CKj6pnNU9iwc/ppywnxvOVcrcQX31tTE12zj3Lzkumz4JJcA6ZEzhTgfg
	 ayP1a3+AxfoH96UGOSADcJnONEHmda4hPAt6f1mgA2oQ3kQ0sM2Eugdoiy+yPNrrbo
	 ueN+J/KYk6oAmeTTuPoMZDRbhAG/oox/nXUOD1MO9X1MK06LYqfWw8EnpYAYDiSXI/
	 iv24vk8USsmmj1HC7fKgoKzR6QdloUJ4xHLU0nXXk/loR83csnWKDf3hIChOLmzK4S
	 kt26Y5ecHOpOg==
Date: Wed, 2 Apr 2025 21:58:59 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, amit@kernel.org,
	kvm@vger.kernel.org, amit.shah@amd.com, thomas.lendacky@amd.com,
	bp@alien8.de, tglx@linutronix.de, peterz@infradead.org,
	pawan.kumar.gupta@linux.intel.com, corbet@lwn.net, mingo@redhat.com,
	dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, daniel.sneddon@linux.intel.com,
	kai.huang@intel.com, sandipan.das@amd.com,
	boris.ostrovsky@oracle.com, Babu.Moger@amd.com,
	david.kaplan@amd.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com
Subject: Re: [PATCH v3 6/6] x86/bugs: Add RSB mitigation document
Message-ID: <Z-2XAx9u8l-73aXM@gmail.com>
References: <cover.1743617897.git.jpoimboe@kernel.org>
 <d6c07c8ae337525cbb5d926d692e8969c2cf698d.1743617897.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6c07c8ae337525cbb5d926d692e8969c2cf698d.1743617897.git.jpoimboe@kernel.org>


* Josh Poimboeuf <jpoimboe@kernel.org> wrote:

> Create a document to summarize hard-earned knowledge about RSB-related
> mitigations, with references, and replace the overly verbose yet
> incomplete comments with a reference to the document.

Just a few nits:

> +RSB poisoning (Intel and AMD)
> +=============================
> +
> +SpectreRSB
> +~~~~~~~~~~
>
>+
>+RSB poisoning is a technique used by Spectre-RSB [#spectre-rsb]_ where
>+an attacker poisons an RSB entry to cause a victim's return instruction
>+to speculate to an attacker-controlled address.  This can happen when
>+there are unbalanced CALLs/RETs after a context switch or VMEXIT.

s/Spectre-RSB
 /SpectreRSB

Which is the name the title just a few lines above uses, and which 
appears to be broadly the in-tree consensus spelling as well.

> +
> +AMD Retbleed / SRSO / Branch Type Confusion
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Nit: the underline is one character too long. :-)

> +On AMD, poisoned RSB entries can also be created by the AMD Retbleed
> +variant [#retbleed-paper]_ and/or Speculative Return Stack Overflow
> +[#amd-srso]_ (Inception [#inception-paper]_).  These attacks are made
> +possible by Branch Type Confusion [#amd-btc]_.  The kernel protects
> +itself by replacing every RET in the kernel with a branch to a single
> +safe RET.

s/Retbleed
 /RETBleed

Seems to be the consensus spelling in-tree. (There's a few more cases 
in this document as well.)

> +	 * WARNING! There are many subtleties to consider when changing *any*
> +	 * code related to RSB-related mitigations.  Before doing so, carefully
> +	 * read the following document, and update if necessary:
>  	 *
> +	 *   Documentation/admin-guide/hw-vuln/rsb.rst
>  	 *
> +	 * In an overly simplified nutshell:
>  	 *
> +	 *   - User->user RSB attacks are conditionally mitigated during
> +	 *     context switch by cond_mitigation -> __write_ibpb().

s/during context switch
 /during context switches

>  	 *
> +	 *   - User->kernel and guest->host attacks are mitigated by eIBRS or
> +	 *     RSB filling.
>  	 *
> +	 *     Though, depending on config, note that other alternative
> +	 *     mitigations may end up getting used instead, e.g., IBPB on
> +	 *     entry/vmexit, call depth tracking, or return thunks.
>  	 */

s/__write_ibpb()
 /write_ibpb()

as per the discussion under patch #1.

Thanks,

	Ingo

