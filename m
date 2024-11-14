Return-Path: <kvm+bounces-31836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0A749C80CC
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 03:31:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5FEE2814AC
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 02:31:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ED5C1F95E;
	Thu, 14 Nov 2024 02:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Det6Mgmh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F79182C5;
	Thu, 14 Nov 2024 02:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731551504; cv=none; b=Q26rChrfBFTEvYUguUpGnoNVKA7SWeA0oHAgDtwJyMiRCiMZ9rlCiWqYa8shnl0+lsJANs0E8Iu5HSKzV6CLBcSQnrDiQ2iRxw12exzsfXy2mFHFwL23K+fJOAedtdZWRgDWw0pYqPq1dW8sP3c3/vwgje1s7S9G2CaVMTam8tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731551504; c=relaxed/simple;
	bh=ZXlkiAu/T3aJ2qHWeASAGx84yAnWg2sjO+0ha25J8Ms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jfHrzr4VzP0vyBXbBVW58pCFG1VPQ7W88b3lV2i34yVTXxVkYCm6XA43IugQEP7H2oDcRymwKp+Yze8/bFlugP3RIX2oGlflsYeGCCs1NN7JQEcCA1gYbNce0NpY1mo4a0hkzLcqcdmdVXML6olKOX8LNTOadk8psufRGhsykKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Det6Mgmh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46AD1C4CEC3;
	Thu, 14 Nov 2024 02:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731551504;
	bh=ZXlkiAu/T3aJ2qHWeASAGx84yAnWg2sjO+0ha25J8Ms=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Det6MgmhQjVbbEdyroCfzXhJDhajlshlqAxJ9nl1/q7wInpgFYu5zG93tqhT1DJrq
	 LEkoJqZRVE3QlBbpOwwnsBtQ2xAyo5XN/xSIE1v8Bm+I+/kLkULjnDxDemrn3i2237
	 peAd/17m/l0LFm3Q4UuUIBKSHwSFROpCjJ0vw/TPwr6Xkh8T2+/zdCxH2gCaFT4zv7
	 Dze6XaS4UhGYx1Bf1mwTfb4cmVTUTKLUeHIch8hoAIH5TMIMkWy7scXjTr7Ht0pEsq
	 XAl5j61HazXUItW77dE6SnNUUM1GdswzY8Fv0BsqfgnLQqHXAvQ5php4jQOi0clAmi
	 gu9PI5MTH+T2A==
Date: Wed, 13 Nov 2024 18:31:41 -0800
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
Message-ID: <20241114023141.n4n3zl7622gzsf75@jpoimboe>
References: <20241111163913.36139-1-amit@kernel.org>
 <20241111163913.36139-2-amit@kernel.org>
 <20241111193304.fjysuttl6lypb6ng@jpoimboe>
 <564a19e6-963d-4cd5-9144-2323bdb4f4e8@citrix.com>
 <20241112014644.3p2a6te3sbh5x55c@jpoimboe>
 <20241112214241.fzqq6sqszqd454ei@desk>
 <20241113202105.py5imjdy7pctccqi@jpoimboe>
 <20241114015505.6kghgq33i4m6jrm4@desk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241114015505.6kghgq33i4m6jrm4@desk>

On Wed, Nov 13, 2024 at 05:55:05PM -0800, Pawan Gupta wrote:
> > > user->user SpectreRSB is also mitigated by IBPB, so RSB filling is
> > > unnecessary when IBPB is issued. Also, when an appication does not opted-in
> > > for IBPB at context switch, spectre-v2 for that app is not mitigated,
> > > filling RSB is only a half measure in that case.
> > > 
> > > Is RSB filling really serving any purpose for userspace?
> > 
> > Indeed...
> > 
> > If we don't need to flush RSB for user->user, we'd only need to worry
> > about protecting the kernel.  Something like so?
> > 
> >   - eIBRS+!PBRSB:	no flush
> >   - eIBRS+PBRSB:	lite flush
> 
> Yes for VMexit, but not at kernel entry. PBRSB requires an unbalanced RET,
> and it is only a problem until the first retired CALL. At VMexit we do have
> unbalanced RET but not at kernel entry.
> 
> >   - everything else:	full flush
> 
> > i.e., same logic as spectre_v2_determine_rsb_fill_type_at_vmexit(), but
> > also for context switches.
> 
> Yes, assuming you mean user->kernel switch, and not process context switch.

Actually I did mean context switch.  AFAIK we don't need to flush RSB at
kernel entry.

If user->user RSB is already mitigated by IBPB, then at context switch
we only have to worry about user->kernel.  e.g., if 'next' has more (in
kernel) RETs then 'prev' had (in kernel) CALLs, the user could trigger
RSB underflow or corruption inside the kernel after the context switch.

Doesn't eIBRS already protect against that?

For PBRSB, I guess we don't need to worry about that since there would
be at least one kernel CALL before context switch.

-- 
Josh

