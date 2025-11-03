Return-Path: <kvm+bounces-61920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A8A5C2E4D9
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 23:45:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BB3F3B6CFD
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 22:45:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CBC02E6CD7;
	Mon,  3 Nov 2025 22:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c6+5qH34"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE72128E5;
	Mon,  3 Nov 2025 22:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762209949; cv=none; b=O6J+cy7vpLYQh5SvMbVUgNaCcjdxXanFdT2raj6RnqpctSe37KgHZ92US9yBUHmTGaV42BAq82JGboO8pcL4sKoxMHwFhBCygLT809JZwMUzeVhwHCT8oS4DN+vumzzDqBpkLYwb4637OGNtMPmVxOT4j7sOy/kEruXe2xxs5V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762209949; c=relaxed/simple;
	bh=jTAKJOw5wZmTht45RhDChBQjaEOWBM5c3xoxwnlU0cc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iQ0wTMpiWw7yAo5Ut5MKQ/K6fh+9/4FUEPex2vtLyZdyh17g3frzXPCBvrRmkRi7b/Up2NdIqe8GJuT5e3jKOdqCZiKRMFkcrNAOptxW2QMLUAV5ntBlMzG0KqMptiwe5WhZ1aRJ1JMZv9Au0KrVk+L75/sb9ORkY65PerqXS3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c6+5qH34; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762209947; x=1793745947;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jTAKJOw5wZmTht45RhDChBQjaEOWBM5c3xoxwnlU0cc=;
  b=c6+5qH34G1z2r3UL+HnlGr+owBT61CQIVQJm7rX74FKRhdMtWZQeAXkT
   DkXnMQr9mxN/XqzhDocn/NYg8fjCYxXHpYyoYAiZ/x/jIYldSfBmjkxXp
   eirdopVS5UVaT9CRbDiGVLB9UL3MbC+1Rp/e+yUTf57EDRPLNSx1XJ9w1
   iYaGRNU97pu0+H0ujCjuidY4MdnZLYRoQ3BROGCr8xhQ9an3gKtcDMIjp
   H/dDvKK++NllaRFqjhbVLXFS0JYQ6wcsDW+r7hGIGIALwFSaFT0yCV3Rh
   EslCY8Tv6nxAeDry4z+7JwMq0plrKYGuunkLH4kHsQwz1QE6uJPjQtNIt
   w==;
X-CSE-ConnectionGUID: f1F1/KoIQIql6yw9VHAhTQ==
X-CSE-MsgGUID: vZjMHuHfTrWtokEQ7PVPtw==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="64214978"
X-IronPort-AV: E=Sophos;i="6.19,277,1754982000"; 
   d="scan'208";a="64214978"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 14:45:46 -0800
X-CSE-ConnectionGUID: qvAQusjxQTSdfNGAsWw9Qg==
X-CSE-MsgGUID: xQFeSJgsSUmf12nTtK1ocw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,277,1754982000"; 
   d="scan'208";a="186938159"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO desk) ([10.124.220.244])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 14:45:45 -0800
Date: Mon, 3 Nov 2025 14:45:37 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: Re: [PATCH v3 1/3] x86/bhi: Add BHB clearing for CPUs with larger
 branch history
Message-ID: <20251103224337.cljudozqjv7auy3p@desk>
References: <20251027-vmscape-bhb-v3-0-5793c2534e93@linux.intel.com>
 <20251027-vmscape-bhb-v3-1-5793c2534e93@linux.intel.com>
 <40dd7445-a94d-4b90-8a8a-56c15386866a@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40dd7445-a94d-4b90-8a8a-56c15386866a@intel.com>

On Mon, Nov 03, 2025 at 12:04:50PM -0800, Dave Hansen wrote:
> On 10/27/25 16:43, Pawan Gupta wrote:
> > Add a version of clear_bhb_loop() that works on CPUs with larger branch
> > history table such as Alder Lake and newer. This could serve as a cheaper
> > alternative to IBPB mitigation for VMSCAPE.
> 
> This is missing a bit of background about clear_bhb_loop(). What does it
> mitigate? This is also a better place to talk about why this loop exists
> if it doesn't work on newer CPUs.
> 
> In other words, please mention BHI_DIS_S here.

Sure, will add the background on clear_bhb_loop() and BHI_DIS_S.

> > clear_bhb_loop() and the new clear_bhb_long_loop() only differ in the loop
> > counter. Convert the asm implementation of clear_bhb_loop() into a macro
> > that is used by both the variants, passing counter as an argument.
> 
> I find these a lot easier to review if you separate out the refactoring
> from the new work. I know it's not a lot of code, but refactor first,
> then add he new function in a separate patch.

Ya, thats a better way to do it, I will split the patch.

> > +/*
> > + * A longer version of clear_bhb_loop to ensure that the BHB is cleared on CPUs
> 
> "clear_bhb_loop()", please.

Will fix.

> > + * with larger branch history tables (i.e. Alder Lake and newer). BHI_DIS_S
> > + * protects the kernel, but to mitigate the guest influence on the host
> > + * userspace either IBPB or this sequence should be used. See VMSCAPE bug.
> > + */
> > +SYM_FUNC_START(clear_bhb_long_loop)
> > +	__CLEAR_BHB_LOOP 12, 7
> > +SYM_FUNC_END(clear_bhb_long_loop)
> > +EXPORT_SYMBOL_GPL(clear_bhb_long_loop)
> > +STACK_FRAME_NON_STANDARD(clear_bhb_long_loop)
> 
> All the pieces are out there, but I feel like we need this in one place,
> somewhere:
> 
> BHI_DIS_S:  Mitigates user=>kernel attacks on new CPUs. Faster than the
>             long loop.
> Long Loop:  Mitigates guest=>host userspace attacks on new CPUs. Would
> 	    also work for user=>kernel, but BHI_DIS_S is faster.
> Short Loop: The only choice on older CPUs. Used for both user=>kernel
> 	    and guest=>host userspace mitigation.

Sure, I will capture them in one place. I guess this should also go in the
documentation.

