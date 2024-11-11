Return-Path: <kvm+bounces-31530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 506329C4705
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 21:39:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 079C31F2350F
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 20:39:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 786751BC061;
	Mon, 11 Nov 2024 20:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ad02di1u"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920E21AE014;
	Mon, 11 Nov 2024 20:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731357549; cv=none; b=DvU0YKvX1IZueMKHaeUR6jy6lKnM2pI2NzS8HWs115bD2bFDSQmyzByiElf88l1SqEY5ajqFihNmO/k4sFLMAaTHM1oN+Byv5/UhgrnwiFJLtoVf6MhxZ6PvY6pKrMMNKjCgcyiaylmwc6bkXP0zCvBkqERCM+VgrHygcwhQ+bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731357549; c=relaxed/simple;
	bh=RskXYQD5wDxn7QTheUTZ7haO83xm9MxhhQdS2pfNkCM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LzXbLWzamtaYLWJG+/yZrZzM/ffBNY/KY7SUKkNKe9Pf5dox2U/7z+JTScKLLsmWRZMuFGBHTmOFXXEo7FTIlo9V7yf/JkGSPKjQMWdD9Bm/2M7tis/iVwf99E4makrrgZQKOQdUzuDMxvqZ816iTNYj5e208YpJNVPDYL+/DLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ad02di1u; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58896C4CECF;
	Mon, 11 Nov 2024 20:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731357549;
	bh=RskXYQD5wDxn7QTheUTZ7haO83xm9MxhhQdS2pfNkCM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ad02di1uRK6TijSYu3ChQ2iIEsTtsd+Is3e43hvt265ilw6K9fbfaI76jJHnUd+ql
	 SKuI+iE8TuVRKINajCyo28tttGdcLlqgdcDB8n2RIlkz/IBSBn8zI3/NqkMf2EVZV0
	 A9c81jNwcDSYozpMU379FrEn6vhQxTDsWx3OVrAorWaahb8FbdOJ4RMNrmUE7evUav
	 MUULkAM24LbdMZHNKoAmbpbTIME9GViIr4kciB3WbmHiSnw0U2OtG1MSmYOT0Z3I+2
	 Yqc17b9w0lvhiQ41izyiQaGj/prRWcmPghnPQhxIZP1Ztakh2VeepMw1GiZSJi/9sO
	 eMHXl0VnBb8Ig==
Date: Mon, 11 Nov 2024 12:39:06 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: "Kaplan, David" <David.Kaplan@amd.com>
Cc: Amit Shah <amit@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"Shah, Amit" <Amit.Shah@amd.com>,
	"Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
	"bp@alien8.de" <bp@alien8.de>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"pawan.kumar.gupta@linux.intel.com" <pawan.kumar.gupta@linux.intel.com>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"hpa@zytor.com" <hpa@zytor.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"daniel.sneddon@linux.intel.com" <daniel.sneddon@linux.intel.com>,
	"kai.huang@intel.com" <kai.huang@intel.com>,
	"Das1, Sandipan" <Sandipan.Das@amd.com>,
	"boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
	"Moger, Babu" <Babu.Moger@amd.com>,
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>,
	"andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Subject: Re: [RFC PATCH v2 1/3] x86: cpu/bugs: update SpectreRSB comments for
 AMD
Message-ID: <20241111203906.a2y55qoi767hcmht@jpoimboe>
References: <20241111163913.36139-1-amit@kernel.org>
 <20241111163913.36139-2-amit@kernel.org>
 <20241111193304.fjysuttl6lypb6ng@jpoimboe>
 <LV3PR12MB9265A6B2030DAE155E7B560B94582@LV3PR12MB9265.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <LV3PR12MB9265A6B2030DAE155E7B560B94582@LV3PR12MB9265.namprd12.prod.outlook.com>

On Mon, Nov 11, 2024 at 07:58:03PM +0000, Kaplan, David wrote:
> > I'm thinking the comments need more clarification in light of BTC and SRSO.
> >
> > This:
> >
> > > -      *    AMD has it even worse: *all* returns are speculated from the BTB,
> > > -      *    regardless of the state of the RSB.
> >
> > is still true (mostly: "all" should be "some"), though it doesn't belong in the "RSB
> > underflow" section.
> >
> > Also the RSB stuffing not only mitigates RET, it mitigates any other instruction
> > which happen to be predicted as a RET.  Which is presumably why it's still needed
> > even when SRSO is enabled.
> >
> 
> While that's partly true, I'm not sure I'm understanding which
> scenario you're concerned with.  As noted in the AMD BTC whitepaper,
> there are various types of potential mis-speculation depending on what
> the actual branch is. The 'late redirect' ones are the most concerning
> since those have enough of a speculation window to be able to do a
> load-op-load gadget.  The only 'late redirect' case involving an
> instruction being incorrectly predicted as a RET is when the actual
> instruction is an indirect JMP/CALL.  But those instructions are
> either removed entirely (due to retpoline) or being protected with
> IBRS.  The cases of other instructions (like Jcc) being predicted as a
> RET are subject to the 'early redirect' behavior which is much more
> limited (and note that these can also be predicted as indirect
> branches for which there is no special protection).  So I'm not sure
> why BTC specifically would necessitate needing to stuff the RSB here.
> 
> Also, BTC only affects some AMD parts (not Family 19h and later for
> instance).

This is why it's important to spell out all the different cases in the
comments.  I was attempting to document the justifications for the
existing behavior.

You make some good points, though backing up a bit, I realize my comment
was flawed for another reason: the return thunks only protect the
kernel, but RSB filling on context switch is meant to protect user
space.

So, never mind...

-- 
Josh

