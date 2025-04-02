Return-Path: <kvm+bounces-42504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CB6AEA79545
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 20:44:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A6F657A331F
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 18:43:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0CFE1DE2BB;
	Wed,  2 Apr 2025 18:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kuMBi+ph"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDEA5C96;
	Wed,  2 Apr 2025 18:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743619460; cv=none; b=CzQzT7wEEAL6bK1jncuxhbT0/S5yMQhqpdmmIE5pjlMP4HWVc8X9fF6yZGpssTD3hcet/rBgT8LftJuFUSaN0615lWyxhHPr1tjojN4VCmCbbCTNEXjX9I/gpYW+FdyACKsVju67Sd5IgAnmE2eocKH61dHEBojAbO9A2I2j38M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743619460; c=relaxed/simple;
	bh=ND8lroqTcplq3wtyZqj1iCMd280vWD/+F8ldsuATLmU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zg1z1txjncwmoj83vzYpN0qxHiI4N+6/V+XK33aX+3HaJCYTJp33yLnmy7TWuw7fOBaSQlJb40/bbXmXo1iO+jz+VP/yCCviqTECs5fLwGxrCNOvSoPncSmYxM6HPWK+V5OSSCD91idv+So3+BUed/8gNIfV46SYjNVtGUVA5MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kuMBi+ph; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A14DC4CEDD;
	Wed,  2 Apr 2025 18:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743619459;
	bh=ND8lroqTcplq3wtyZqj1iCMd280vWD/+F8ldsuATLmU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kuMBi+phTtBs+RheZJzbBnVFv3JUwXDks02tVP1DSBV59ZH9dO3ZQDbWn3fVb7Dwv
	 oQZ50hrwn26++h5vM03jPBI6Bz1BWIxIxJLUsLwFqsO0tRFVeIbsRpvm4vnB6ZPG+/
	 mZhSPjcZg6Zy3dPQN0bfPJqJietwQbfzUXhajoWXtYf6Ok6jeClaqzYW0+96MggdY4
	 mvnlcMRqq2jPY7/5K9duJVKbX8wNk20CeYfTQPbH2/mkn7KaO6EjM04nBf5PFgsagL
	 URgD3AwfR21o0upP2laDjFnbv3gYP/UUrYTC8N+Sqh7WnpSCPaakXZxX5woKVVaNW9
	 XWEO4a1Dq7fig==
Date: Wed, 2 Apr 2025 11:44:15 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, amit@kernel.org, 
	kvm@vger.kernel.org, amit.shah@amd.com, thomas.lendacky@amd.com, tglx@linutronix.de, 
	peterz@infradead.org, pawan.kumar.gupta@linux.intel.com, corbet@lwn.net, 
	mingo@redhat.com, dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com, 
	pbonzini@redhat.com, daniel.sneddon@linux.intel.com, kai.huang@intel.com, 
	sandipan.das@amd.com, boris.ostrovsky@oracle.com, Babu.Moger@amd.com, 
	david.kaplan@amd.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com
Subject: Re: [PATCH v3 1/6] x86/bugs: Rename entry_ibpb()
Message-ID: <qeg7tr5jvmyyxvftl4k4qsa4hxga7hzvqcs2xbhfpeun5yhn3r@ua6pawrgxix5>
References: <cover.1743617897.git.jpoimboe@kernel.org>
 <a3ce1558b68a64f52ea56000f2bbdfd6e7799258.1743617897.git.jpoimboe@kernel.org>
 <20250402182928.GAZ-2CCBR2BAgpwVLf@fat_crate.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250402182928.GAZ-2CCBR2BAgpwVLf@fat_crate.local>

On Wed, Apr 02, 2025 at 08:29:28PM +0200, Borislav Petkov wrote:
> On Wed, Apr 02, 2025 at 11:19:18AM -0700, Josh Poimboeuf wrote:
> > There's nothing entry-specific about entry_ibpb().  In preparation for
> 
> Not anymore - it was done on entry back then AFAIR.
> 
> > calling it from elsewhere, rename it to __write_ibpb().
> > 
> > Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > ---
> >  arch/x86/entry/entry.S               | 7 ++++---
> >  arch/x86/include/asm/nospec-branch.h | 6 +++---
> >  arch/x86/kernel/cpu/bugs.c           | 6 +++---
> >  3 files changed, 10 insertions(+), 9 deletions(-)
> > 
> > diff --git a/arch/x86/entry/entry.S b/arch/x86/entry/entry.S
> > index d3caa31240ed..3a53319988b9 100644
> > --- a/arch/x86/entry/entry.S
> > +++ b/arch/x86/entry/entry.S
> > @@ -17,7 +17,8 @@
> >  
> >  .pushsection .noinstr.text, "ax"
> >  
> > -SYM_FUNC_START(entry_ibpb)
> > +// Clobbers AX, CX, DX
> 
> Why the ugly comment style if the rest of the file is already using the
> multiline one...

It helps it stand out more? :-)

> > +SYM_FUNC_START(__write_ibpb)
> 
> ... and why the __ ?

I was thinking the calling interface is a bit nonstandard.  But actually
it's fine to call from C as those registers are already caller-saved
anyway.  So yeah, let's drop the '__'.

-- 
Josh

