Return-Path: <kvm+bounces-16427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A71CB8B9FC3
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 19:46:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA4A52833B4
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 17:46:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2A60171068;
	Thu,  2 May 2024 17:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RA/NMAUm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280451553BB;
	Thu,  2 May 2024 17:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714671990; cv=none; b=Whr1NBVf+PkJv5wW0zp9CbKZKwS0LrQEWskAtPsXiDiJDtOQ+08ec/167pjWMofPWV72sZbRYGl+gpu5/L2+XldUHUak7/LdzxOKV2xNxxNCNl7W6kJ3r0nDQWd1NFYZ8R9EnCq/IfAFVB/msWLG+bJjaeTRYe1x1/WEDuxLQ0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714671990; c=relaxed/simple;
	bh=HeQLmynCEdrx0ZemmTQx7mv6WQ0lAPV/6AimhMM3UFg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GVHPNGOP0vYlSFrnDBF283rs74gHvaOQ3jiQySy2CdiIEGzRENU3wH8WG9KlTkQNFNGTn4ma3+SjkfgDqAsLp0e1PpaTXaaKTKBL1dXjyx6xq9DkfPxOpdjpZ6SBUtEAtDzTrkyLjmcfw63JEy5OhtQchnao8H4Df7SOA7YWNQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RA/NMAUm; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714671989; x=1746207989;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HeQLmynCEdrx0ZemmTQx7mv6WQ0lAPV/6AimhMM3UFg=;
  b=RA/NMAUmoJdUjtQidWqie0IuNhdp9MpeTnw64BdH7oU7Z3kqiOgx9cX8
   GGixLwfVxSqrZJ8mxupl54Bxdaj6iew4/iQXEUSkn/4SI2XRqSIQdw1Hz
   JC/9sKAnzTe+ytnp4Fb5GmxKqL/O13e6SuB+m/h+pxhyJCyBniGqX9VVs
   GECiYMZXixV6l1GNzZYqGBwLAa8nkRJ0dFWmSde7V39AOBN+3YP+jJwtP
   j+2zbVTOHq+nNKCZ6OuyvCFyRSUZdU4bH0DO1aBuNv4JsJJmAVDzb3oOF
   bYVA+H8uUCHaPpSJWOvbR3yFU+FGEJufWpFW4DK++YqCLPpbG98J7jRpW
   g==;
X-CSE-ConnectionGUID: R7WaVfXcSluMIvcqe0GjWw==
X-CSE-MsgGUID: ZSVtEAa0T9mwxEvRdTL3wA==
X-IronPort-AV: E=McAfee;i="6600,9927,11062"; a="10389973"
X-IronPort-AV: E=Sophos;i="6.07,247,1708416000"; 
   d="scan'208";a="10389973"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2024 10:46:29 -0700
X-CSE-ConnectionGUID: ymGqJ6kjQdKp0tBGPH4Dsg==
X-CSE-MsgGUID: Kar+4KmDQI+qINBQgegm8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,247,1708416000"; 
   d="scan'208";a="27205274"
Received: from ramanisw-mobl.amr.corp.intel.com (HELO [10.251.17.226]) ([10.251.17.226])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2024 10:46:28 -0700
Message-ID: <893ac578-baaf-4f4f-96ee-e012dfc073a8@intel.com>
Date: Thu, 2 May 2024 10:46:27 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 04/27] x86/fpu/xstate: Introduce
 XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
To: Sean Christopherson <seanjc@google.com>,
 Yang Weijiang <weijiang.yang@intel.com>
Cc: pbonzini@redhat.com, x86@kernel.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, peterz@infradead.org, chao.gao@intel.com,
 rick.p.edgecombe@intel.com, mlevitsk@redhat.com, john.allen@amd.com
References: <20240219074733.122080-1-weijiang.yang@intel.com>
 <20240219074733.122080-5-weijiang.yang@intel.com>
 <ZjKNxt1Sq71DI0K8@google.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <ZjKNxt1Sq71DI0K8@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/1/24 11:45, Sean Christopherson wrote:
> On Sun, Feb 18, 2024, Yang Weijiang wrote:
>> Define a new XFEATURE_MASK_KERNEL_DYNAMIC mask to specify the features
> I still don't understand why this is being called DYNAMIC.  CET_SS isn't dynamic,
> as KVM is _always_ allowed to save/restore CET_SS, i.e. whether or not KVM can
> expose CET_SS to a guest is a static, boot-time decision.  Whether or not a guest
> XSS actually enables CET_SS is "dynamic", but that's true of literally every
> xfeature in XCR0 and XSS.
> 
> XFEATURE_MASK_XTILE_DATA is labeled as dynamic because userspace has to explicitly
> request that XTILE_DATA be enabled, and thus whether or not KVM is allowed to
> expose XTILE_DATA to the guest is a dynamic, runtime decision.
> 
> So IMO, the umbrella macro should be XFEATURE_MASK_KERNEL_GUEST_ONLY.

Here's how I got that naming.  First, "static" features are always
there.  "Dynamic" features might or might not be there.  I was also much
more focused on what's in the XSAVE buffer than on the enabling itself,
which are _slightly_ different.

Then, it's a matter of whether the feature is user or supervisor.  The
kernel might need new state for multiple reasons.  Think of LBR state as
an example.  The kernel might want LBR state around for perf _or_ so it
can be exposed to a guest.

I just didn't want to tie it to "GUEST" too much in case we have more of
these things come along that get used for things unrelated to KVM.
Obviously, at this point, we've only got one and KVM is the only user so
the delta that I was worried about doesn't actually exist.

So I still prefer calling it "KERNEL" over "GUEST".  But I also don't
feel strongly about it and I've said my peace.  I won't NAK it one way
or the other.

