Return-Path: <kvm+bounces-33235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A9019E7C30
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2024 00:02:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6BF2B16D93D
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 23:02:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0384B206276;
	Fri,  6 Dec 2024 23:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a4J9FOFD"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DF922C6E5;
	Fri,  6 Dec 2024 23:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733526135; cv=none; b=GfRR92mUnXKkgiWzg0MlQtYBo4mVTtKumS3B8mMsebiXyQ+zkQWgHs/DSiS/4PtYDjXxUeaIR74BkTmDPbsotUykZYoZ7Cwu46sV35rykJjX3RsTBdS1MeIb+GMlPJga/k0vEG94w2+kQBe5CW4vE/fjR7E11c3EWNtZ5aaqkts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733526135; c=relaxed/simple;
	bh=lZixRYOSp+H+UHibPxgKZ5FY3EVM5zkYaQ6CYlgh4GM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CxE9odLOyd9HxAqzu78SASJneOSguEWzRvfJAcTEywTy79+ZsJ2YPBDVSaYXElGCd4YSrp+R0cM15o+gUO46nh4g3lMzdzHkKgv/UbZI0AmYGeJQFNhLlQFHXRY200P7vChloo35Uz8JIoJRtfDkrc9IFUZ8w6RA5c4rWk06+Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a4J9FOFD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8961C4CEDE;
	Fri,  6 Dec 2024 23:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733526134;
	bh=lZixRYOSp+H+UHibPxgKZ5FY3EVM5zkYaQ6CYlgh4GM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a4J9FOFDP5a4xtdwDJ59KdS5QLTofhGu1Q7oaMvduftx9lCIJ07mr0RCUIzD0pgE0
	 Vys2UAM2FdyTPN4JYdYqXLdRufNKPjskneo+DDgN0bWfUQ80VK+IAxcfPVreCF7kZq
	 cGWEmN/58k+6aiKIt7DSikwkyopBwE/AOnYCDg62SgGDPfjGDefA8zVzoj2mEWNV0Y
	 6WgqYaV25OHK/8sypj2hz5Bz1RoyPHz2Cf4/GJN+oMxBtYSWiRQ7rps416VZmMzRNw
	 RiBAxWGvm5ahhgs+YbboWQTRnsYM1AGGz1aXES2c6/5oar0EB8JKf+T9J05vpHot0k
	 jp+SFC3pGGO1g==
Date: Fri, 6 Dec 2024 15:02:12 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, amit@kernel.org, kvm@vger.kernel.org,
	amit.shah@amd.com, thomas.lendacky@amd.com, bp@alien8.de,
	tglx@linutronix.de, peterz@infradead.org,
	pawan.kumar.gupta@linux.intel.com, corbet@lwn.net, mingo@redhat.com,
	dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, daniel.sneddon@linux.intel.com,
	kai.huang@intel.com, sandipan.das@amd.com,
	boris.ostrovsky@oracle.com, Babu.Moger@amd.com,
	david.kaplan@amd.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com
Subject: Re: [PATCH v2 2/2] x86/bugs: Don't fill RSB on context switch with
 eIBRS
Message-ID: <20241206230212.whcnkib4icz4aabx@jpoimboe>
References: <cover.1732219175.git.jpoimboe@kernel.org>
 <d6b0c08000aa96221239ace37dd53e3f1919926c.1732219175.git.jpoimboe@kernel.org>
 <20241205233245.4xaicvusl5tfp2oi@jpoimboe>
 <20241206005300.b4uzyhtaabrrhrlx@jpoimboe>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241206005300.b4uzyhtaabrrhrlx@jpoimboe>

On Thu, Dec 05, 2024 at 04:53:03PM -0800, Josh Poimboeuf wrote:
> On Thu, Dec 05, 2024 at 03:32:47PM -0800, Josh Poimboeuf wrote:
> > On Thu, Nov 21, 2024 at 12:07:19PM -0800, Josh Poimboeuf wrote:
> > > User->user Spectre v2 attacks (including RSB) across context switches
> > > are already mitigated by IBPB in cond_mitigation(), if enabled globally
> > > or if either the prev or the next task has opted in to protection.  RSB
> > > filling without IBPB serves no purpose for protecting user space, as
> > > indirect branches are still vulnerable.
> > 
> > Question for Intel/AMD folks: where is it documented that IBPB clears
> > the RSB?  I thought I'd seen this somewhere but I can't seem to find it.
> 
> For Intel, I found this:
> 
>   https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/advisory-guidance/post-barrier-return-stack-buffer-predictions.html
> 
>   "Software that executed before the IBPB command cannot control the
>   predicted targets of indirect branches executed after the command on
>   the same logical processor. The term indirect branch in this context
>   includes near return instructions, so these predicted targets may come
>   from the RSB.
> 
>   This article uses the term RSB-barrier to refer to either an IBPB
>   command event, or (on processors which support enhanced IBRS) either a
>   VM exit with IBRS set to 1 or setting IBRS to 1 after a VM exit."
> 
> I haven't seen anything that explicit for AMD.

Found it.  As Andrew mentioned earlier, AMD IBPB only clears RSB if the
IBPB_RET CPUID bit is set.  From APM vol 3:

CPUID Fn8000_0008_EBX Extended Feature Identifiers:

30	IBPB_RET	The processor clears the return address
			predictor when MSR PRED_CMD.IBPB is written to 1.

We check that already for the IBPB entry mitigation, but now we'll also
need to do so for the context switch IBPB.

Question for AMD, does SBPB behave the same way, i.e. does it clear RSB
if IBPB_RET?

-- 
Josh

