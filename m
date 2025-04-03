Return-Path: <kvm+bounces-42551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C57FA79D5B
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 09:49:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A47E91894462
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 07:49:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E0AADDA9;
	Thu,  3 Apr 2025 07:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f0Ia45so"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71EDB193402;
	Thu,  3 Apr 2025 07:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743666532; cv=none; b=ryRx2RH3I8uPVDedqsfS0yJAmXqECfnw7Tjjw0NpURk8ZIFZzYZVZq5LbZMfAzUayMgcfVvHXxcIEhC30gNMC71m9wPAfII/GVb/XYHLEiB7Oky2voiTlHQPSRWuWAsnCxFtxFjJ3TXYf4zCCnVWrbwTSOtx0/FMHoRKDdDM6jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743666532; c=relaxed/simple;
	bh=JKHMbrz5aWBVgO+ChNZ07uaUlRSflD7s97HDUzhEB3U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DeEA677KZ1gAIBPGDWEIJ5EhDww8gM9cR/vzrlv/4TTkGlFxngkQizDuZiEdEMjVnWNn3w77P2A3tyKxiwNAscqslkw01X9WxnujWhvgrpEWeAv5TwnASjBiw8zDtO1h80P8JMmC75cFOj0bsMBlaZs2D9WlZUly8Z4J3cE0I90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f0Ia45so; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793BCC4CEE3;
	Thu,  3 Apr 2025 07:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743666532;
	bh=JKHMbrz5aWBVgO+ChNZ07uaUlRSflD7s97HDUzhEB3U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f0Ia45so8yQhjiKBRJnbfuax9XzNHGF9hsy1x/8IX0y/A3bPQbDsO/hzujH5X5jfS
	 AUs9+zbwAo/dDBDFFGz23Q5ap0LwsL+7QZFEsUjaiaHJ64ds1SWUBajKfj1pkenh5l
	 D2IhLGzApxYtCwP57SDKO4ohE72kwHllaqQvc1fKUUolv4keY3lMSDiMQVB5VxtDEa
	 S5cUsIAQQnFN4COfmpovvy6R8JT5cdlpfVuRrcq7FaciW3Yb5sfl86hBz3NamSD7D/
	 lNj7Fh+0SIkwacVxZVYAb9/l8jS4+FPaXVFp3+Ej6B2UvT+F0LYLhq8pO/KlEvmGQK
	 T+iFxTC3xnSeg==
Date: Thu, 3 Apr 2025 00:48:49 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, amit@kernel.org, 
	kvm@vger.kernel.org, amit.shah@amd.com, thomas.lendacky@amd.com, bp@alien8.de, 
	tglx@linutronix.de, peterz@infradead.org, pawan.kumar.gupta@linux.intel.com, 
	corbet@lwn.net, mingo@redhat.com, dave.hansen@linux.intel.com, hpa@zytor.com, 
	seanjc@google.com, pbonzini@redhat.com, daniel.sneddon@linux.intel.com, 
	kai.huang@intel.com, sandipan.das@amd.com, boris.ostrovsky@oracle.com, 
	Babu.Moger@amd.com, david.kaplan@amd.com, dwmw@amazon.co.uk, 
	andrew.cooper3@citrix.com
Subject: Re: [PATCH v3 6/6] x86/bugs: Add RSB mitigation document
Message-ID: <pqwdrzrd7i34batgjm2edrbizl4z5oyjnmzzei2m6tn2cybzcm@sk2p4w2jrrxp>
References: <cover.1743617897.git.jpoimboe@kernel.org>
 <d6c07c8ae337525cbb5d926d692e8969c2cf698d.1743617897.git.jpoimboe@kernel.org>
 <Z-35GYpMU0GJ5Z6j@archie.me>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z-35GYpMU0GJ5Z6j@archie.me>

On Thu, Apr 03, 2025 at 09:57:29AM +0700, Bagas Sanjaya wrote:
> On Wed, Apr 02, 2025 at 11:19:23AM -0700, Josh Poimboeuf wrote:
> > +    Note that some Intel CPUs are susceptible to Post-barrier Return
> > +    Stack Buffer Predictions (PBRSB)[#intel-pbrsb]_, where the last CALL
> > +    from the guest can be used to predict the first unbalanced RET.  In
> > +    this case the PBRSB mitigation is needed in addition to eIBRS.
> 
> I get Sphinx unreferenced footnote warning:
> 
> Documentation/admin-guide/hw-vuln/rsb.rst:221: WARNING: Footnote [#] is not referenced. [ref.footnote]
> 
> To fix that, I have to separate the footnote:
> 
> ---- >8 ----
> diff --git a/Documentation/admin-guide/hw-vuln/rsb.rst b/Documentation/admin-guide/hw-vuln/rsb.rst
> index 97bf75993d5d43..dd727048b00204 100644
> --- a/Documentation/admin-guide/hw-vuln/rsb.rst
> +++ b/Documentation/admin-guide/hw-vuln/rsb.rst
> @@ -102,7 +102,7 @@ there are unbalanced CALLs/RETs after a context switch or VMEXIT.
>  	at the time of the VM exit." [#intel-eibrs-vmexit]_
>  
>      Note that some Intel CPUs are susceptible to Post-barrier Return
> -    Stack Buffer Predictions (PBRSB)[#intel-pbrsb]_, where the last CALL
> +    Stack Buffer Predictions (PBRSB) [#intel-pbrsb]_, where the last CALL
>      from the guest can be used to predict the first unbalanced RET.  In
>      this case the PBRSB mitigation is needed in addition to eIBRS.

Fixed, thanks!

-- 
Josh

