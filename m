Return-Path: <kvm+bounces-15841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14D2F8B0F45
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 17:59:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3180FB2E915
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 15:57:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B3EC1607A7;
	Wed, 24 Apr 2024 15:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WsJwcaBg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC98B15F406
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 15:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713974239; cv=none; b=iBp2HchUOZ5oVtSDHPdPja9UmGCf7nWk+lKo8ItH9xMf+KTc3YFpgKeP2/RNb67FbdJY4/zbtEMlqp/hJiABJfPTCCeOIcILC7Kdv6PJCyPaRc+A4CyEn1oY1W+T/3CvyQk1XjHbN6zlQs9QmrX3jnF2qWGxJgestFjLuwbGApQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713974239; c=relaxed/simple;
	bh=szSvnPPOZogSbQg2l5FImdE9D+W2Mso6/U/ehpDLjtg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W51YC3S9HppePGP8QYHs91vR3QvtyGuxkJy8emw8FfAhj2+Z68aiBspuUpcvyYEemknAK93O8yQrVM97vUIe7lPvlF1e8Ex6PlgkGzm7Eun6SXrpRcGRPLVhLIpyVJCaS+nL3UgmPHKLivs0qViHwi+WpLMimtS9011QfCLqVVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WsJwcaBg; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713974237; x=1745510237;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=szSvnPPOZogSbQg2l5FImdE9D+W2Mso6/U/ehpDLjtg=;
  b=WsJwcaBgJd9tLP2x3lfQa9L+ndOg/W1C3nWi+XfFQpALwYMTJsdWWolb
   3lKoGne2cwstsrSLwOZzvWJMj5Bt9C88EtLA/OiSZGLsOfPpKFwVdLzrU
   8WEscwtU1ZvCfwspDVMvYWkqyqx6KSbfSseamFzDWrSj8ONMy23i0v9rP
   WOKqz6dlwiIRrVfPTsa8GywGPjthDFAxF3yRvaksrotCrMY4earNza2Gd
   Tu9kDDlchPRfBvvJXjGFam7zOSS4yAMXkOMz9Wa+fvfmGCOulnMb01cGc
   pqMAZlFYEwULcCFDKPpu2CViUa1vk49uwxF1r52+/pjH6hOFjs8muvI1o
   w==;
X-CSE-ConnectionGUID: fXxkeUG4Qqim+AmXINAZlQ==
X-CSE-MsgGUID: Pi0D248PQKiwJt9zOMnmpQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9776171"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="9776171"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 08:57:17 -0700
X-CSE-ConnectionGUID: sPs8qcndRmmnxNGDQsUxSw==
X-CSE-MsgGUID: DrAM4+fPRKKgQpa+TloHrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="24770849"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 08:57:14 -0700
Message-ID: <fb252e78-2e71-4422-9499-9eac69102eec@intel.com>
Date: Wed, 24 Apr 2024 23:57:11 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-9.1 0/7] target/i386/kvm: Cleanup the kvmclock feature
 name
To: Zhao Liu <zhao1.liu@linux.intel.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Richard Henderson <richard.henderson@linaro.org>,
 Eduardo Habkost <eduardo@habkost.net>, "Michael S . Tsirkin"
 <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Tim Wiederhake <twiederh@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, Zhao Liu <zhao1.liu@intel.com>
References: <20240329101954.3954987-1-zhao1.liu@linux.intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240329101954.3954987-1-zhao1.liu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/29/2024 6:19 PM, Zhao Liu wrote:
> From: Zhao Liu <zhao1.liu@intel.com>
> 
> Hi list,
> 
> This series is based on Paolo's guest_phys_bits patchset [1].
> 
> Currently, the old and new kvmclocks have the same feature name
> "kvmclock" in FeatureWordInfo[FEAT_KVM].
> 
> When I tried to dig into the history of this unusual naming and fix it,
> I realized that Tim was already trying to rename it, so I picked up his
> renaming patch [2] (with a new commit message and other minor changes).
> 
> 13 years age, the same name was introduced in [3], and its main purpose
> is to make it easy for users to enable/disable 2 kvmclocks. Then, in
> 2012, Don tried to rename the new kvmclock, but the follow-up did not
> address Igor and Eduardo's comments about compatibility.
> 
> Tim [2], not long ago, and I just now, were both puzzled by the naming
> one after the other.

The commit message of [3] said the reason clearly:

   When we tweak flags involving this value - specially when we use "-",
   we have to act on both.

So you are trying to change it to "when people want to disable kvmclock, 
they need to use '-kvmclock,-kvmclock2' instead of '-kvmclock'"

IMHO, I prefer existing code and I don't see much value of 
differentiating them. If the current code puzzles you, then we can add 
comment to explain.

> So, this series is to push for renaming the new kvmclock feature to
> "kvmclock2" and adding compatibility support for older machines (PC 9.0
> and older).
> 
> Finally, let's put an end to decades of doubt about this name.
> 
> 
> Next Step
> =========
> 
> This series just separates the two kvmclocks from the naming, and in
> subsequent patches I plan to stop setting kvmclock(old kcmclock) by
> default as long as KVM supports kvmclock2 (new kvmclock).

No. It will break existing guests that use KVM_FEATURE_CLOCKSOURCE.

> Also, try to deprecate the old kvmclock in KVM side.
> 
> [1]: https://lore.kernel.org/qemu-devel/20240325141422.1380087-1-pbonzini@redhat.com/
> [2]: https://lore.kernel.org/qemu-devel/20230908124534.25027-4-twiederh@redhat.com/
> [3]: https://lore.kernel.org/qemu-devel/1300401727-5235-3-git-send-email-glommer@redhat.com/
> [4]: https://lore.kernel.org/qemu-devel/1348171412-23669-3-git-send-email-Don@CloudSwitch.com/
> 
> Thanks and Best Regards,
> Zhao
> 
> ---
> Tim Wiederhake (1):
>    target/i386: Fix duplicated kvmclock name in FEAT_KVM
> 
> Zhao Liu (6):
>    target/i386/kvm: Add feature bit definitions for KVM CPUID
>    target/i386/kvm: Remove local MSR_KVM_WALL_CLOCK and
>      MSR_KVM_SYSTEM_TIME definitions
>    target/i386/kvm: Only Save/load kvmclock MSRs when kvmclock enabled
>    target/i386/kvm: Save/load MSRs of new kvmclock
>      (KVM_FEATURE_CLOCKSOURCE2)
>    target/i386/kvm: Add legacy_kvmclock cpu property
>    target/i386/kvm: Update comment in kvm_cpu_realizefn()
> 
>   hw/i386/kvm/clock.c       |  5 ++--
>   hw/i386/pc.c              |  1 +
>   target/i386/cpu.c         |  3 +-
>   target/i386/cpu.h         | 32 +++++++++++++++++++++
>   target/i386/kvm/kvm-cpu.c | 25 ++++++++++++++++-
>   target/i386/kvm/kvm.c     | 59 +++++++++++++++++++++++++--------------
>   6 files changed, 99 insertions(+), 26 deletions(-)
> 


