Return-Path: <kvm+bounces-33179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C6F1D9E6128
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 00:13:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABD4D16A10D
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 23:13:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 573481D5165;
	Thu,  5 Dec 2024 23:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="afK5MMt7"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE1E1CCEED;
	Thu,  5 Dec 2024 23:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733440403; cv=none; b=l4fmJzAWFQOkUQlv/JajFhZxXs1IPdoI2gUHiGd8jNR6GvMLxALRHWrag64iXdeo9shkyihmcTWQLbkXgruaMkrxDmi8zCPLiaYVtWHDq3HqdEHtgEd5PcN2nL+7lEKwKyZLk8xmqeTPFD95pjKgWKh2CuSxSJ59MyxxKYwcQ9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733440403; c=relaxed/simple;
	bh=IO4hrK0S/+RID0j7qtzrhZtApZ7SQ8u7IsNN4RFfdBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lay75CTuKKghzv8V4owGkguvGacr7kTRlZ/ucpK6K7/VJTDa1fiMOU1Id4JsQwMA1+UKGNg3tRAC/1f0DjskPASRx3G0kTdgE3FV1c5NtABJZ/CxqOAR0DQyEdwFmn62kaFIVfa/ykQMa6QQtkdXgHqGInt6z8AK1/xRDCpW9Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=afK5MMt7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40BD7C4CED1;
	Thu,  5 Dec 2024 23:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733440403;
	bh=IO4hrK0S/+RID0j7qtzrhZtApZ7SQ8u7IsNN4RFfdBc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=afK5MMt7bq6ohZ4rXkbvNrzv0n4xfc4JMBlf30UKJ8jhMdGX56GaiJ2fxUYachxRo
	 Yuv7b6ESDdw+vphmkEi6rNVAT6k6HE7QWItbU36CJMQw+jtaF4qQKk5VT+ANPGh0cQ
	 4naIUvpplPfREBoXgwsl4G4aynxW7ZE0aFvQr4NYCc3R2drBs71oG4mi2pVt+ihJhH
	 lhV52rJiCXAHbDFeeKjms9EQsU40CMh4g6d10YZX89Cyn+Y490II4f4S3v6cer8xe+
	 6L6DollGgHUuVYxaHZk5NLM2NZJN4PDaH9JfLS496gtlHDg2Md1vLGqbZ3E6EQjsr8
	 eZgTYfvsf7sYA==
Date: Thu, 5 Dec 2024 15:13:20 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Borislav Petkov <bp@alien8.de>
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
Message-ID: <20241205231320.zv737k57pfqqfu36@jpoimboe>
References: <cover.1732219175.git.jpoimboe@kernel.org>
 <9bd7809697fc6e53c7c52c6c324697b99a894013.1732219175.git.jpoimboe@kernel.org>
 <20241130153125.GBZ0svzaVIMOHBOBS2@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241130153125.GBZ0svzaVIMOHBOBS2@fat_crate.local>

On Sat, Nov 30, 2024 at 04:31:25PM +0100, Borislav Petkov wrote:
> On Thu, Nov 21, 2024 at 12:07:18PM -0800, Josh Poimboeuf wrote:
> > --- a/arch/x86/kernel/cpu/bugs.c
> > +++ b/arch/x86/kernel/cpu/bugs.c
> > @@ -1605,20 +1605,20 @@ static void __init spectre_v2_determine_rsb_fill_type_at_vmexit(enum spectre_v2_
> >  	case SPECTRE_V2_NONE:
> >  		return;
> >  
> > -	case SPECTRE_V2_EIBRS_LFENCE:
> >  	case SPECTRE_V2_EIBRS:
> > +	case SPECTRE_V2_EIBRS_LFENCE:
> > +	case SPECTRE_V2_EIBRS_RETPOLINE:
> >  		if (boot_cpu_has_bug(X86_BUG_EIBRS_PBRSB)) {
> > -			setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT_LITE);
> >  			pr_info("Spectre v2 / PBRSB-eIBRS: Retire a single CALL on VMEXIT\n");
> > +			setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT_LITE);
> 
> Why are you swapping those?
> 
> >  		}
> >  		return;
> >  
> > -	case SPECTRE_V2_EIBRS_RETPOLINE:
> >  	case SPECTRE_V2_RETPOLINE:
> >  	case SPECTRE_V2_LFENCE:
> >  	case SPECTRE_V2_IBRS:
> > -		setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT);
> >  		pr_info("Spectre v2 / SpectreRSB : Filling RSB on VMEXIT\n");
> > +		setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT);
> 
> Ditto?

It's more readable that way, similar to how a comment goes before code.

-- 
Josh

