Return-Path: <kvm+bounces-31841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C59D49C8474
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 09:01:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7E2D01F23A9B
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 08:01:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63F141F666B;
	Thu, 14 Nov 2024 08:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I8iepwEM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0746B1EBFF2;
	Thu, 14 Nov 2024 08:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731571282; cv=none; b=q8n1Hn3EXYe55cjXPJI8Ao2JDqFf3ur1oM6T8DmLg0PP4+VGrtD5fHMbe97oHmApXM6IPPJ1Ub5e0FkU8ctSPFlpODJDH2OoWm/VCWZ/SmelZkeeOzx+2n3sP5gLVPatM5FsCYOkWaEwCl+wBNpyhPjkCPcbUbv8zEgPD4A2+S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731571282; c=relaxed/simple;
	bh=9rI4sdRn+Ppp70uZBrM1rPa1ZmMTrZpqNCDttih3ltY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g7vSIxl6jzHFJR7t9EBydPjGYbcp4w0/DR7DHfkppRtn5qGiva5/AnRZK8y0JNwwicHWuuEhA1ojNR2uR1ccVZ6MI6ugf4LwXbnFQHT19nA5/ZQgo5DKZQnYj3FANJNhXdFPBkUOW9rIlZgS6cP5BGHwodUMrViIvXMRmebs2ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I8iepwEM; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731571282; x=1763107282;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9rI4sdRn+Ppp70uZBrM1rPa1ZmMTrZpqNCDttih3ltY=;
  b=I8iepwEMyBES4ssTYI8bvhZDHZcQcp3rIIp/c5D1VUgWtvrjhnzIbvYh
   4Dv6k9raIHeTN82Bt/tQHYL/suWBDFIq9XdD7Q9/ExGeEenrILrfBYFo3
   iCuHErs/hPB175sg2HlC5MoNQZSLt+y/EXd/pDZVPLWR3rvkfIgGXmzyq
   l7Te3N9BfktFrNtdMXDcyiebKGBnP9uRJvVziRw0nMM0bomtkZn7GMIE7
   EpVlJ3+MIaddrdLzttsr624jBSNE5QWvLOzbIaV6O5ghsrpHIyhM6Shc9
   Z6nqtSJVVDohStx3cUzIYYulZOvs3QM+hhrpvOhe/XXSiKye4rc6KZT07
   g==;
X-CSE-ConnectionGUID: bVmjvFdISHGTpWYrJow5Fg==
X-CSE-MsgGUID: DIo60f5eQFauMXfRt2Oh9A==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="54035678"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="54035678"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2024 00:01:17 -0800
X-CSE-ConnectionGUID: QfC/dlgRTdSOre6kYgo2gQ==
X-CSE-MsgGUID: t/azFh5WTbWggIEy4Yu3wA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,153,1728975600"; 
   d="scan'208";a="92176869"
Received: from beginmax-mobl.amr.corp.intel.com (HELO desk) ([10.125.147.24])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2024 00:01:15 -0800
Date: Thu, 14 Nov 2024 00:01:16 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
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
Message-ID: <20241114075403.7wxou7g5udaljprv@desk>
References: <20241111163913.36139-1-amit@kernel.org>
 <20241111163913.36139-2-amit@kernel.org>
 <20241111193304.fjysuttl6lypb6ng@jpoimboe>
 <564a19e6-963d-4cd5-9144-2323bdb4f4e8@citrix.com>
 <20241112014644.3p2a6te3sbh5x55c@jpoimboe>
 <20241112214241.fzqq6sqszqd454ei@desk>
 <20241113202105.py5imjdy7pctccqi@jpoimboe>
 <20241114015505.6kghgq33i4m6jrm4@desk>
 <20241114023141.n4n3zl7622gzsf75@jpoimboe>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241114023141.n4n3zl7622gzsf75@jpoimboe>

On Wed, Nov 13, 2024 at 06:31:41PM -0800, Josh Poimboeuf wrote:
> On Wed, Nov 13, 2024 at 05:55:05PM -0800, Pawan Gupta wrote:
> > > > user->user SpectreRSB is also mitigated by IBPB, so RSB filling is
> > > > unnecessary when IBPB is issued. Also, when an appication does not opted-in
> > > > for IBPB at context switch, spectre-v2 for that app is not mitigated,
> > > > filling RSB is only a half measure in that case.
> > > > 
> > > > Is RSB filling really serving any purpose for userspace?
> > > 
> > > Indeed...
> > > 
> > > If we don't need to flush RSB for user->user, we'd only need to worry
> > > about protecting the kernel.  Something like so?
> > > 
> > >   - eIBRS+!PBRSB:	no flush
> > >   - eIBRS+PBRSB:	lite flush
> > 
> > Yes for VMexit, but not at kernel entry. PBRSB requires an unbalanced RET,
> > and it is only a problem until the first retired CALL. At VMexit we do have
> > unbalanced RET but not at kernel entry.
> > 
> > >   - everything else:	full flush
> > 
> > > i.e., same logic as spectre_v2_determine_rsb_fill_type_at_vmexit(), but
> > > also for context switches.
> > 
> > Yes, assuming you mean user->kernel switch, and not process context switch.
> 
> Actually I did mean context switch.  AFAIK we don't need to flush RSB at
> kernel entry.
> 
> If user->user RSB is already mitigated by IBPB, then at context switch
> we only have to worry about user->kernel.  e.g., if 'next' has more (in
> kernel) RETs then 'prev' had (in kernel) CALLs, the user could trigger
> RSB underflow or corruption inside the kernel after the context switch.

Yes, this condition can cause RSB underflow, but that is not enough. More
importantly an attacker also needs to control the target of RET.

> Doesn't eIBRS already protect against that?

Yes, eIBRS does protect against that, because the alternate predictor (TA)
is isolated by eIBRS from user influence.

> For PBRSB, I guess we don't need to worry about that since there would
> be at least one kernel CALL before context switch.

Right. So the case where we need RSB filling at context switch is
retpoline+CDT mitigation.

