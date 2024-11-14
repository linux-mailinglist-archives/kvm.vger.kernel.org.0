Return-Path: <kvm+bounces-31834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EAA49C8044
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 02:55:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1032B1F22FC1
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 01:55:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E9DB1E47A0;
	Thu, 14 Nov 2024 01:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dYsn8M7J"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E1728382;
	Thu, 14 Nov 2024 01:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731549309; cv=none; b=DFFE9smx0fwlGJJDpit4GyN0JRDC0hcoSVXg2go6c6x+Yr5nRti9ZfaNVLCIi0BgPnqwn4Je/n+35JTzG8uqlnbyzRwJzHbkFfAtMhlP2twX8TZpPLItD3a5IO9aLT9hlGY6DFuyrdEDwZi6Kj+x5ymEGG9OFrW66ABnoM8RFWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731549309; c=relaxed/simple;
	bh=vmkVDPTg1NL7GHsswzT3gPIjKiH4WwiCxEbuAvS3TZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HNG+B3qVF47nOOLk2LpYZw44iT6PXBzS5t2trk6MVGMV0s76UtWMrtD1Q8piDBCMtDlB8C2BT1lbFFLklqpqem4Pnewipw3Tq2DSMVcXspflxVtR0P10JFbwm59m1D4vShv+8hgY8FFtOe2gipaJbluHZDjWx7Y5r6pSVc0L5Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dYsn8M7J; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731549308; x=1763085308;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vmkVDPTg1NL7GHsswzT3gPIjKiH4WwiCxEbuAvS3TZ4=;
  b=dYsn8M7J8sjXkPOZNLs0DHTfi7eZZDUvPFKWTKN6W8z4cDZWzA1qbNfK
   XyXfZ0jzt9T8a9VtAmNUMUj1hH7ffbQV1U+hV2aUL95tgIsjR1lOZtfCm
   hTTLNF+Udj2HaFvNeQN2dzvqaVTf3WEG7lnTiIlyYLfXrjJcw8nfntMz7
   pD+5nXQt/uSXxxN3QAbGMHekye5m7SIu712FJg4mqNdtE09O/nSkR5+k5
   5TSDa/qWk2IYyuh1JkUfQ9Ii0kCijm7EOf9/wwvfj8jd1szNeYiYmWvF4
   4P9w8JnCEqIKJtj++zOtothRd60i8aJaZOk8ZP/QGvdpbj7LjcnsGB4Hg
   w==;
X-CSE-ConnectionGUID: 226cERTES7GNxkuJ7I+eQA==
X-CSE-MsgGUID: 9qJQHh+ZTV6X3hXVb+m3Mw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="31242014"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="31242014"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 17:55:08 -0800
X-CSE-ConnectionGUID: IKsPaOP9QLKWB3iu2y5sKA==
X-CSE-MsgGUID: 9poty6BCRiuqgQNzYasy+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="88473321"
Received: from beginmax-mobl.amr.corp.intel.com (HELO desk) ([10.125.147.24])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 17:55:05 -0800
Date: Wed, 13 Nov 2024 17:55:05 -0800
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
Message-ID: <20241114015505.6kghgq33i4m6jrm4@desk>
References: <20241111163913.36139-1-amit@kernel.org>
 <20241111163913.36139-2-amit@kernel.org>
 <20241111193304.fjysuttl6lypb6ng@jpoimboe>
 <564a19e6-963d-4cd5-9144-2323bdb4f4e8@citrix.com>
 <20241112014644.3p2a6te3sbh5x55c@jpoimboe>
 <20241112214241.fzqq6sqszqd454ei@desk>
 <20241113202105.py5imjdy7pctccqi@jpoimboe>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241113202105.py5imjdy7pctccqi@jpoimboe>

On Wed, Nov 13, 2024 at 12:21:05PM -0800, Josh Poimboeuf wrote:
> On Tue, Nov 12, 2024 at 01:43:48PM -0800, Pawan Gupta wrote:
> > On Mon, Nov 11, 2024 at 05:46:44PM -0800, Josh Poimboeuf wrote:
> > > +	 * 1) RSB underflow ("Intel Retbleed")
> > >  	 *
> > >  	 *    Some Intel parts have "bottomless RSB".  When the RSB is empty,
> > >  	 *    speculated return targets may come from the branch predictor,
> > >  	 *    which could have a user-poisoned BTB or BHB entry.
> > >  	 *
> > > -	 *    AMD has it even worse: *all* returns are speculated from the BTB,
> > > -	 *    regardless of the state of the RSB.
> > > +	 *    When IBRS or eIBRS is enabled, the "user -> kernel" attack is
> > > +	 *    mitigated by the IBRS branch prediction isolation properties, so
> > > +	 *    the RSB buffer filling wouldn't be necessary to protect against
> > > +	 *    this type of attack.
> > >  	 *
> > > -	 *    When IBRS or eIBRS is enabled, the "user -> kernel" attack
> > > -	 *    scenario is mitigated by the IBRS branch prediction isolation
> > > -	 *    properties, so the RSB buffer filling wouldn't be necessary to
> > > -	 *    protect against this type of attack.
> > > +	 *    The "user -> user" attack is mitigated by RSB filling on context
> > > +	 *    switch.
> > 
> > user->user SpectreRSB is also mitigated by IBPB, so RSB filling is
> > unnecessary when IBPB is issued. Also, when an appication does not opted-in
> > for IBPB at context switch, spectre-v2 for that app is not mitigated,
> > filling RSB is only a half measure in that case.
> > 
> > Is RSB filling really serving any purpose for userspace?
> 
> Indeed...
> 
> If we don't need to flush RSB for user->user, we'd only need to worry
> about protecting the kernel.  Something like so?
> 
>   - eIBRS+!PBRSB:	no flush
>   - eIBRS+PBRSB:	lite flush

Yes for VMexit, but not at kernel entry. PBRSB requires an unbalanced RET,
and it is only a problem until the first retired CALL. At VMexit we do have
unbalanced RET but not at kernel entry.

>   - everything else:	full flush

> i.e., same logic as spectre_v2_determine_rsb_fill_type_at_vmexit(), but
> also for context switches.

Yes, assuming you mean user->kernel switch, and not process context switch.

