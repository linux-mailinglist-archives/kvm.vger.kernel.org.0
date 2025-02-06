Return-Path: <kvm+bounces-37483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC7EFA2AAA5
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 15:03:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 35D667A4494
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 14:02:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B612226884;
	Thu,  6 Feb 2025 14:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zq7UBGH5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F321C6FE0
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 14:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738850600; cv=none; b=Gue6FVLNaP7cNL0HxR0WC04pfgHLuNggWIZ8dBmLoUhTq+zW0TfVFrsKpm0lLGZo4aAec6cOaaZZtsxHY7iqyvi2/O+ISHVh72xvl7EcC1HiLK9u6Oz5bck+VHu5+vqizHJJso2EwT/6XPSCJQXwSvCazIaTIl1XvCtfNq4m1Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738850600; c=relaxed/simple;
	bh=5HfmyYU47Yo8Mg89L6hc3hs2QgBq3rcWfXeIDFRabrY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MnTke7dM7kcXX3cN2kDzwJ/XezthFB2JYN1VT5Q8p9Ebjh6wtlqG1SzUR+gXjz8h2EG5dxodjyDCgl59wR6yTx04U0VpLEVei6Tb9gDT4uH/HB/mX5r57xI9uJn63uYqbahuKtZ/mLdMZ1cGcNYJUeL2sD1pXfiDe3cn+xtdvWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zq7UBGH5; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738850598; x=1770386598;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5HfmyYU47Yo8Mg89L6hc3hs2QgBq3rcWfXeIDFRabrY=;
  b=Zq7UBGH5TnCcPxnA8mO9A/SblDovmT/lIwLtUPI3MScmKEtJfgNKitFv
   sbj5C25oYCoZgYLoWa8z50emqw9cYRGrOcvl7I2gLpEZnYR3UwfR9NG2R
   EdoFj6UY7TYw/PoHipBCn9Tt1giwa672HvYGpT1IgMRluXGi3QK0b68+N
   tFbfMEgroaW+vcHNmXJfToqRFo++nrwTAXbPP/eVuisTrYuELtF3sqNKs
   +kbR2n7l70p7HX1MVLUKupscrVHdCmW6FJDhVYYTTfyjOVgTUKVfrtyX1
   sAGJeO9BRxXQ57ocNQyQBPSdul9ZQR/sG6HG9dh3MnJMBkHDtx1Mn8OcG
   w==;
X-CSE-ConnectionGUID: ZMR/rqCeQuu/5KILK6Ju8Q==
X-CSE-MsgGUID: gys1x9PFQXicv6MB61UJRw==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="27054495"
X-IronPort-AV: E=Sophos;i="6.13,264,1732608000"; 
   d="scan'208";a="27054495"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2025 06:03:16 -0800
X-CSE-ConnectionGUID: 7pf8A9zfSR2Dg+23jhjvlQ==
X-CSE-MsgGUID: vlg2A+STQTW+U7ie6oNbtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="111068581"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa010.jf.intel.com with ESMTP; 06 Feb 2025 06:03:10 -0800
Date: Thu, 6 Feb 2025 22:22:39 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>, Eric Auger <eauger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>,
	Sebastian Ott <sebott@redhat.com>, Gavin Shan <gshan@redhat.com>,
	qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
	Dapeng Mi <dapeng1.mi@intel.com>, Yi Lai <yi1.lai@intel.com>
Subject: Re: [RFC v2 3/5] i386/kvm: Support event with select & umask format
 in KVM PMU filter
Message-ID: <Z6TFr49Cnhe1s4/5@intel.com>
References: <20250122090517.294083-1-zhao1.liu@intel.com>
 <20250122090517.294083-4-zhao1.liu@intel.com>
 <87zfj01z8x.fsf@pond.sub.org>
 <Z6SG2NLxxhz4adlV@intel.com>
 <Z6SEIqhJEWrMWTU1@redhat.com>
 <878qqjqskm.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878qqjqskm.fsf@pond.sub.org>

> >> > > The select&umask is the common way for x86 to identify the PMU event,
> >> > > so support this way as the "x86-default" format in kvm-pmu-filter
> >> > > object.
> >> > 
> >> > So, format 'raw' lets you specify the PMU event code as a number, wheras
> >> > 'x86-default' lets you specify it as select and umask, correct?
> >> 
> >> Yes!
> >> 
> >> > Why do we want both?
> >> 
> >> This 2 formats are both wildly used in x86(for example, in perf tool).
> >> 
> >> x86 documents usually specify the umask and select fields.
> >> 
> >> But raw format could also be applied for ARM since ARM just uses a number
> >> to encode event.
> 
> Is it really too much to ask of the client to compute a raw value from
> umask and select values?

I understand you're wondering if we can omit the select+umask format...

In principle, having either one should work correctly... The additional
support for the umask+select format is more user-friendly and doesn't
introduce much complexity in the code.

My own observation is that Intel's doc rarely uses the raw format
directly, whereas AMD uses the raw format relatively more often.
Personally, when using the perf tool, I prefer the umask+select format.

Even if only the raw format is supported, users still need to be aware
of the umask+select format because there is the third format - "masked
entry" (which tries to mask a group of events with same select, patch 4).

So I would like to keep both raw and umask+select formats if possible.

...

> >> > > +#
> >> > > +# x86 PMU event encoding with select and umask.
> >> > > +# raw_event = ((select & 0xf00UL) << 24) | \
> >> > > +#              (select) & 0xff) | \
> >> > > +#              ((umask) & 0xff) << 8)
> >> > 
> >> > Sphinx rejects this with "Unexpected indentation."
> >> > 
> >> > Is the formula needed here?
> >> 
> >> I tried to explain the relationship between raw format and umask+select.
> >> 
> >> Emm, where do you think is the right place to put the document like
> >> this?
> 
> Do users need to know how to compute the raw event value from @select
> and @umask?

Yes, because it's also a unified calculation. AMD and Intel have
differences in bits for supported select field, but this calculation
(which follows from the KVM code) makes both compatible.

> If yes, is C code the best way?
> 
> Here's another way:
> 
>     bits  0..7 : bits 0..7 of @select
>     bits  8..15: @umask
>     bits 24..27: bits 8..11 of @select
>     all other bits: zero
>

Thank you! This is what I want.



