Return-Path: <kvm+bounces-31802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ABD89C7CE7
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 21:28:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A60C5B2385C
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 20:23:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06B712141AC;
	Wed, 13 Nov 2024 20:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="huT2mo7x"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222AC206514;
	Wed, 13 Nov 2024 20:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731529268; cv=none; b=DudytTrIAWetTKwrROwM6AbgmVwjzOiMuqFwRtZSNgoDIhf1/ezjdmMtqkEdmEjSdrJqG8Ov9+MCRfqMV7Gg5CEvaAJrIWGq3Ayy0nY2XWsYeKmWgtsz+tmzoIC7KHb7Mdeopcvgo27xdFg78xkkmo1tjgsWdf97ZundD6aaNVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731529268; c=relaxed/simple;
	bh=pZVSg10VOkAIcP4WSJXbuoBHHguSGDKtxN8ujJVyPL0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HPf0pFS+/OgrpKvYORjY5/UkL2yBRyHnrHgSOZt/oV/lGMxTbXWswDm78G+LPNRQL6HnsRT1XKAsLFvYFw0t+ZrxGTxXdTxrhGQgfYfoom3OecPOjCw8fH7od6drMJMhWjbjgLPvmSI3LUJHIo+0hNbRagBB/6TuwATB8UsqQsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=huT2mo7x; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D08D1C4CEC3;
	Wed, 13 Nov 2024 20:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731529267;
	bh=pZVSg10VOkAIcP4WSJXbuoBHHguSGDKtxN8ujJVyPL0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=huT2mo7x4OmzlsvVK19hzvAn7IYqv/MA1eomnyxHSXqOTZ9MuDgMENsms/RLmGTjH
	 Wtw8T78/ZVp3nTtWEhdM3KFQVJmiJVR7BwH2LlmLT6V3qwurJs3gZognIkwJsvZZ40
	 LtxKLJFxIo0eiyWp1AAqOOmiYc3zNvBYZxvAH1Ja4I8OmqPyz5ATZ401mYWNCjpj5f
	 XPMnuh6SOG/i4N4WXKubi4BzaXge+PMrZAnJY1rwt7KybQbdJtBaQweJjze+jykGhA
	 bCW137YurCA3FgzWSaCNyvQYTltv2Q3vSgs1uEFIfJJTrSzK/hJPpGMFYMI5pgIQo0
	 V6CA2D7kE2YNg==
Date: Wed, 13 Nov 2024 12:21:05 -0800
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
Message-ID: <20241113202105.py5imjdy7pctccqi@jpoimboe>
References: <20241111163913.36139-1-amit@kernel.org>
 <20241111163913.36139-2-amit@kernel.org>
 <20241111193304.fjysuttl6lypb6ng@jpoimboe>
 <564a19e6-963d-4cd5-9144-2323bdb4f4e8@citrix.com>
 <20241112014644.3p2a6te3sbh5x55c@jpoimboe>
 <20241112214241.fzqq6sqszqd454ei@desk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241112214241.fzqq6sqszqd454ei@desk>

On Tue, Nov 12, 2024 at 01:43:48PM -0800, Pawan Gupta wrote:
> On Mon, Nov 11, 2024 at 05:46:44PM -0800, Josh Poimboeuf wrote:
> > +	 * 1) RSB underflow ("Intel Retbleed")
> >  	 *
> >  	 *    Some Intel parts have "bottomless RSB".  When the RSB is empty,
> >  	 *    speculated return targets may come from the branch predictor,
> >  	 *    which could have a user-poisoned BTB or BHB entry.
> >  	 *
> > -	 *    AMD has it even worse: *all* returns are speculated from the BTB,
> > -	 *    regardless of the state of the RSB.
> > +	 *    When IBRS or eIBRS is enabled, the "user -> kernel" attack is
> > +	 *    mitigated by the IBRS branch prediction isolation properties, so
> > +	 *    the RSB buffer filling wouldn't be necessary to protect against
> > +	 *    this type of attack.
> >  	 *
> > -	 *    When IBRS or eIBRS is enabled, the "user -> kernel" attack
> > -	 *    scenario is mitigated by the IBRS branch prediction isolation
> > -	 *    properties, so the RSB buffer filling wouldn't be necessary to
> > -	 *    protect against this type of attack.
> > +	 *    The "user -> user" attack is mitigated by RSB filling on context
> > +	 *    switch.
> 
> user->user SpectreRSB is also mitigated by IBPB, so RSB filling is
> unnecessary when IBPB is issued. Also, when an appication does not opted-in
> for IBPB at context switch, spectre-v2 for that app is not mitigated,
> filling RSB is only a half measure in that case.
> 
> Is RSB filling really serving any purpose for userspace?

Indeed...

If we don't need to flush RSB for user->user, we'd only need to worry
about protecting the kernel.  Something like so?

  - eIBRS+!PBRSB:	no flush
  - eIBRS+PBRSB:	lite flush
  - everything else:	full flush

i.e., same logic as spectre_v2_determine_rsb_fill_type_at_vmexit(), but
also for context switches.

-- 
Josh

