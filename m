Return-Path: <kvm+bounces-42685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AA85CA7C3D4
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:31:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0FCB51B610F8
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:31:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3992821E092;
	Fri,  4 Apr 2025 19:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uUPiKIr4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572CB21E0A6;
	Fri,  4 Apr 2025 19:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795039; cv=none; b=C7MoGRDx2onQHReG+YAsSyAnd4iRjp4PyDI8pTQ6g7W74HGZQ41ONZCqapblAOVD4F/r+uwbLF0BIc4Z/bep4vKbSlGcyxzYwTI4lcb5/gVmc4KTsHM16h04PaKvif86TBkdI5HpHbVAaybS6NCPgLV/I0buYInn8XT6ItWHMEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795039; c=relaxed/simple;
	bh=AjuUc0FFA/5+B6+4iKQhP++e27O6GHDAc7fBsNlMV70=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R9ik4P+abEMyObLm60bLZ8OYoEtb+JqMe/2HdKKm1qn2kkgBh5V+yHXb1SWYmZD9gRPOiJHkWeIQ/a4swXrImA6bGztbwNzxVYOWEIlLG6c9zZfKON4o/nT6Ix5mjV8dIhtcWy03kLuvZwMlV3ci0I12D0p0gGbuC6vJnxKRXoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uUPiKIr4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87C9C4CEDD;
	Fri,  4 Apr 2025 19:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743795038;
	bh=AjuUc0FFA/5+B6+4iKQhP++e27O6GHDAc7fBsNlMV70=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uUPiKIr4a4PJQhV78MH8Y8K2yfFxuLvJ4P4ucL5DSzBUBOwGH60x2uFfWwJl3jddC
	 nSayzpGHql8vEfdiLifwUyXSmxiK4nLC3MxIsgn+GdKwBMCjp+iOggQyp1b3AekjjW
	 T5NAcfZUkCHv+ZYf53Htm9P1y3wkke58qZduYFKNSXbGhSA8xdwnItrniLp+S1FTX2
	 P2GOjVslH3flVPG+VjfaED9a65ti13O9UMuy59ENjUcPbG+mG2VIDGEXU5yb6tBcxe
	 DUeCUurwprn5qr+wrpcTbw2beeW82M30dugZy+WI57/SIccoTbJyYvZHvHNr3soz/I
	 Yv2MZXCJHb7mQ==
Date: Fri, 4 Apr 2025 12:30:35 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, amit@kernel.org, 
	kvm@vger.kernel.org, amit.shah@amd.com, thomas.lendacky@amd.com, bp@alien8.de, 
	tglx@linutronix.de, peterz@infradead.org, pawan.kumar.gupta@linux.intel.com, 
	corbet@lwn.net, mingo@redhat.com, dave.hansen@linux.intel.com, hpa@zytor.com, 
	seanjc@google.com, pbonzini@redhat.com, daniel.sneddon@linux.intel.com, 
	kai.huang@intel.com, sandipan.das@amd.com, boris.ostrovsky@oracle.com, 
	Babu.Moger@amd.com, david.kaplan@amd.com, dwmw@amazon.co.uk
Subject: Re: [PATCH v3 6/6] x86/bugs: Add RSB mitigation document
Message-ID: <s6zdqlw5w7cvd7rwry4jj4yptjkqbmuuwivbtb5encxvaertlu@xepz4av7xabd>
References: <cover.1743617897.git.jpoimboe@kernel.org>
 <d6c07c8ae337525cbb5d926d692e8969c2cf698d.1743617897.git.jpoimboe@kernel.org>
 <2b32a422-575a-403c-b373-1c6beac47c83@citrix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2b32a422-575a-403c-b373-1c6beac47c83@citrix.com>

On Fri, Apr 04, 2025 at 03:39:32AM +0100, Andrew Cooper wrote:
> On 02/04/2025 7:19 pm, Josh Poimboeuf wrote:
> > +Since 2018 there have been many Spectre CVEs related to the Return Stack
> > +Buffer (RSB).
> 
> 2017.  I, and many others, spent the whole second half of 2017 tied up
> in all of this.

Right.  Personally I got pulled in in October 2017.  Even Skylake RSB
underflow was already well understood, which led to the whole distro
IBRS vs upstream retpoline divergence debacle.

But with respect to the above sentence, the first Spectre CVEs were
disclosed in 2018.

> I'd drop the Spectre, or swap it for Speculation-related.  Simply
> "Spectre" CVEs tend to focus on the conditional and indirect predictors.

As you are well aware, a RET is basically an indirect branch.
SpectreRSB literally has Spectre in the name.  And rightfully so IMO,
it's just another way to exploit CPU branch prediction.  And the same
CPU data structures are involved.

So from my perspective, Spectre refers to the entire class of branch
prediction exploits.

But I can change it if you think that's incorrect.

> >   Information about these CVEs and how to mitigate them is
> > +scattered amongst a myriad of microarchitecture-specific documents.
> 
> You should note that the AMD terms RAS and RAP are the same thing,
> considering that you link to the documents.

Ack.  What does RAS stand for?

> One question before getting further.  This seems to be focused on
> (mis)prediction of RETs ?
> 
> That's fine, but it wants spelling out, because it is distinct from the
> other class of issues when RET instructions execute in bad ways.
> 
> When lecturing, my go-to example is Spectre-v1.1 / BCBS (store which
> clobbers or aliases the return address), because an astounding number of
> things can go wrong in different ways from there.

The document is strictly related to the RSB mitigations.

> Next, before diving into the specifics, it's incredibly relevant to have
> a section briefly describing how the RSB typically works.  It's key to
> understanding the rest of the documents, and there will definitely be
> people reading the document who don't know it.
> 
> The salient points are (on CPUs since ~Nehalem era.  Confirm with Intel
> and AMD.  You can spot it in the optimisation guides, because it's where
> the phrase such as "only taken branches consume prediction resource"
> began appearing):
> 
> * Branch prediction is **prior** to instruction decode, and guesses at
> the location, type, and target of all near branches.
> * The RSB is a prediction structure used by branches predicted as CALLs
> or RETs.
> * When a CALL is predicted, the predicted return-address is pushed on
> the RSB
> * When a RET is predicted, the RSB is popped
> * Later, decode will cross-check the prediction with the instruction
> stream.  It can issue corrections to the predictor state, and restart
> prediction/fetch from the point that things appeared to go wrong.  This
> can include editing transient state in the RSB.
> 
> For the observant reader, yes, the RSB is filled using predicted
> targets.  This is why the SRSO vuln is so evil.
> 
> So, with the behaviour summarised, next some properties (disclaimer:
> varies by vendor)
> * It is logically a stack, but has finite capacity.  Executing more RET
> instructions than CALLs will underflow it.
> ** AMD reuses the -1'th entry and doesn't move the pointer
> ** Intel may fall back to a prediction from a different predictor
> * It is a structure shared across all security domains in Core/Thread. 
> Guest & Host is most relevant to the doc, but SMM/ACM/SEAM/XuCode are
> all included.
> ** Some AMD CPUs dynamically re-partition the RSB(RAS) when a sibling
> thread goes idle
> ** Some Intel CPUs only have a 32-bit wide RSB, and reuse the upper bits
> of the location for the predicted target
> ** Some Intel CPUs hardwire bit 47(?) which causes the kernel to follow
> userspace predictions.

That's some really good information.  However, I'm not sure gritty
details about how RSBs work are within the scope for this document.

My goal is for it to be as concise as possible, focused only on the
current kernel mitigations: what are the RSB-related attack vectors for
each uarch and how are we currently mitigating those?

It's basically a glorified comment, but too long to actually be one.  So
that when the next CVE comes along, one can quickly refer to this as a
refresher to see what we're already doing and why.

If the reader wants to know details about the RSB itself, or the related
exploits, there are plenty of references for them to dive into.

> > +* All attack vectors can potentially be mitigated by flushing out any
> > +  poisoned RSB entries using an RSB filling sequence
> > +  [#intel-rsb-filling]_ [#amd-rsb-filling]_ when transitioning between
> > +  untrusted and trusted domains.  But this has a performance impact and
> > +  should be avoided whenever possible.
> 
> More importantly, 32-entry RSB stuffing loops are only applicable to
> pre-eIBRS and pre-ERAPS hardware.
> 
> They are known unsafe to use on newer microarchitectures, inc Gracemont
> (128 entries) and Zen5 (64 entries).

Right now we're doing 32 entries regardless of CPU model.  Do we need to
increase the loop count for newer HW?  Have any references handy?

> > +  * AMD:
> > +	IBPB (or SBPB [#amd-sbpb]_ if used) automatically clears the RSB
> > +	if IBPB_RET is set in CPUID [#amd-ibpb-rsb]_.  Otherwise the RSB
> > +	filling sequence [#amd-rsb-filling]_ must be always be done in
> > +	addition to IBPB.
> 
> Honestly, I dislike this way of characterising it.   IBPB was very
> clearly spec'd to flush all indirect prediction structures, and some AMD
> CPUs have an errata where this isn't true and has to be filled in by the OS.

I don't see how that statement characterizes anything, it just describes
the relevant facts as concisely as possible.

> > +* On context switch, user->kernel attacks are mitigated by SMEP, as user
> > +  space can only insert its own return addresses into the RSB:
> 
> It's more subtle than this (see the 32-bit wide prediction).
> 
> A user/supervisor split address space limits the ranges of addresses
> that userspace can insert into the predictor.
> 
> There is a corner case at the canonical boundary.  Userspace can insert
> the first non-canonincal address, and on some CPUs, this is interpreted
> as the first high canonical address.  Guard pages on both sides of the
> canonical boundary mitigate this.

Ack.  Have a reference handy?

> In the unbalanced case for user->kernel, a bad prediction really is made
> (coming out of the RSB), and it's only the SMEP #PF at instruction fetch
> which prevents you speculatively executing in userspace.

Right, I should probably clarify that a bit more.

> In the 32-bit width case, the kernel predicts to {high_kern:low_user}
> target.

Ok.  But blocked by SMEP regardless.

> > +On AMD, poisoned RSB entries can also be created by the AMD Retbleed
> > +variant [#retbleed-paper]_ and/or Speculative Return Stack Overflow
> > +[#amd-srso]_ (Inception [#inception-paper]_).  These attacks are made
> > +possible by Branch Type Confusion [#amd-btc]_.  The kernel protects
> > +itself by replacing every RET in the kernel with a branch to a single
> > +safe RET.
> 
> BTC and SRSO are unrelated things.
> 
> "predicted branch types" is an inherent property of the predictor.  BTC
> is specifically the case where decode doesn't halt, and still issues the
> wrong uops into the pipeline to execute.
> 
> SRSO goes entirely wrong at the BP/IF stages (BP racing ahead while IF
> is stalled unable to fetch anything), so the damage is done by the time
> Decode sees the instruction stream.

As a simple software engineer, I was under the impression that SRSO is a
special case of BTC.  Apparently I was wrong :-)

> You also need to cover the AMD going-idle issue where the other thread's
> RSB entries magically appear in my RSB, and my head/tail pointer is
> reset to a random position.

I'm not familiar with that one, do you have a reference?

> > +RSB underflow (Intel only)
> > +==========================
> 
> Well, not really.  AMD can underflow too.  It just picks a fixed entry
> and keeps on reusing that.  (Great for the alarming number of
> programming languages which consider recursion a virtue.)

I'm not sure that's relevant here since there are no mitigations needed
for that?

> > +* On context switch, user->user underflow attacks are mitigated by the
> > +  conditional IBPB [#cond-ibpb]_ on context switch which clears the BTB:
> > +
> > +  * "The indirect branch predictor barrier (IBPB) is an indirect branch
> > +    control mechanism that establishes a barrier, preventing software
> > +    that executed before the barrier from controlling the predicted
> > +    targets of indirect branches executed after the barrier on the same
> > +    logical processor." [#intel-ibpb-btb]_
> > +
> > +    .. note::
> > +       I wasn't able to find any offical documentation from Intel
> > +       explicitly stating that IBPB clears the BTB.  However, it's
> > +       broadly known to be true and relied upon in several mitigations.
> 
> Part of this is because when the vendors say the BTB, they're
> translating their internal names into what academia calls them.
> 
> "Flush the BTB" isn't a helpful statement anyway.  See AMD's IBPB vs
> SBPB which controls whether the branch types predictions remain intact.
> 
> Given how many rounds of Intel microcode there have been making IBPB
> scrub more, it clearly wasn't scrubbing everything in the first place.

Any suggestions for how I can improve the wording here?  I want to
explain why IBPB protects against RSB underflow and how we know that.

I should probably also mention IBPB_RET here as well.

> > +* On context switch and VMEXIT, user->kernel and guest->host underflows
> > +  are mitigated by IBRS or eIBRS:
> > +
> > +  * "Enabling IBRS (including enhanced IBRS) will mitigate the "RSBU"
> > +    attack demonstrated by the researchers.
> 
> Yeah, except it doesn't.  Intra-mode BTI is a thing, and that will leak
> your secrets too.

Ok, I'll add a mention of that.

> >  As previously documented,
> > +    Intel recommends the use of enhanced IBRS, where supported. This
> > +    includes any processor that enumerates RRSBA but not RRSBA_DIS_S."
> > +    [#intel-rsbu]_
> > +
> > +  As an alternative to classic IBRS, call depth tracking can be used to
> 
> legacy IBRS.  Please don't invent yet another term for it :), and
> "classic" further implies there might be a time when anyone looks back
> fondly on it.

:-)

> > +Restricted RSB Alternate (RRSBA)
> > +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> This needs to discuss RSBA and RRSBA.  They're distinct.  To a first
> approximation, RRSBA == RSBA + eIBRS.  The "restricted" nature is
> "mode-tagged predictions".

RSBA is the original Intel Retbleed, right?  That was discussed
extensively in the preceding section.  I can mention that Intel Retbleed
may also be referred to as RSBA.

> > +However if the kernel uses retpolines instead of eIBRS, it needs to
> > +disable RRSBA:
> > +
> > +* "Where software is using retpoline as a mitigation for BHI or
> > +  intra-mode BTI, and the processor both enumerates RRSBA and
> > +  enumerates RRSBA_DIS controls, it should disable this behavior. "
> > +  [#intel-retpoline-rrsba]_
> 
> IIRC, not all CPUs which suffer RRSBA have the RRSBA_DIS_* controls.

Hm, have a reference for that?

-- 
Josh

