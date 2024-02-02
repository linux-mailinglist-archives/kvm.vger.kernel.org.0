Return-Path: <kvm+bounces-7787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 891AD84667C
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 04:25:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD3831C25E8A
	for <lists+kvm@lfdr.de>; Fri,  2 Feb 2024 03:25:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B295DF6A;
	Fri,  2 Feb 2024 03:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bgp8+FGZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE4AC8EA;
	Fri,  2 Feb 2024 03:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706844325; cv=none; b=b22vttmZIiQBWxarWTXbUyrtOkP5yHMRjsDVKg2FZH6Ng3OaZSvdXtIr5N5nCycUqgcC+wKMM5INep3uuaM/3GSQs31Ag8rFaaCL0MAdcEYC6xSoKfOWk+txYqPQ1vXI2RnsbfwcZ2jzTGUmM+9OKWGbz9gttNpph0cNJiFSHgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706844325; c=relaxed/simple;
	bh=6JqwBoAYIpZHTWPrTkTxeOxbUvcbFl6Mfyl54IrBp/M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kS47Y1KrEwr/87Dt0m5H43H9Ijqesd9RXDjj3CPqGwZgo3Zr5l/AJiAy70Bt24mYHCOr6aAzRsFpJJ7lgSK3DDlzAG2Af4l6GY7wWTuA39SV6MaeaDcRZTd5LQ49FWO1gCir8uImygMD09PUHlDTJtcILdEVUwTql7GKFs5U0gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bgp8+FGZ; arc=none smtp.client-ip=134.134.136.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706844323; x=1738380323;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6JqwBoAYIpZHTWPrTkTxeOxbUvcbFl6Mfyl54IrBp/M=;
  b=Bgp8+FGZmsTjn170M+2QYXjtyAmMPanAwKDirlHAAYDvWBhuSNUpZl5P
   Bj7yE9E9Qrk0X2eHl+5clyzYWTKZTs5MnD4ipy5akd5VnAzbaIZOhwke7
   nlsO3PEBZgfAP/+hYM0CzGzyM73TEFZpUpy1z5eKMJx/QoSnS8GEltg3u
   qhJgUXH+6N8iubth2o3nRWknmf8kUvOAl5u3WXcjcnHJSHJf5cU0Gnwd0
   BeE5E0B6HiuIvAvGg404Cs/lsZt7criDl9nlJcHFKLSGo93IfvT7HDUsz
   tKRW26BuylSyG5Wuj4dbzgUeC2QmS0yjgPLg0JweSrmx9XLBRYSN7kkzg
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="394510780"
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="394510780"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 19:25:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,237,1701158400"; 
   d="scan'208";a="4575907"
Received: from xiongzha-mobl1.ccr.corp.intel.com (HELO [10.93.0.73]) ([10.93.0.73])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 19:25:20 -0800
Message-ID: <9098e8bb-cbe4-432c-98d6-ce96a4f7094f@linux.intel.com>
Date: Fri, 2 Feb 2024 11:25:14 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86/pmu: Fix type length error when reading
 pmu->fixed_ctr_ctrl
To: Sean Christopherson <seanjc@google.com>,
 Mingwei Zhang <mizhang@google.com>
Cc: Dongli Zhang <dongli.zhang@oracle.com>,
 Paolo Bonzini <pbonzini@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240123221220.3911317-1-mizhang@google.com>
 <ZbpqoU49k44xR4zB@google.com>
 <368248d0-d379-23c8-dedf-af7e1e8d23c7@oracle.com>
 <CAL715WJDesggP0S0M0SWX2QaFfjBNdqD1j1tDU10Qxk6h7O0pA@mail.gmail.com>
 <ZbvUyaEypRmb2s73@google.com> <ZbvjKtsVjpuQmKE2@google.com>
 <ZbvyrvvZM-Tocza2@google.com>
Content-Language: en-US
From: "Zhang, Xiong Y" <xiong.y.zhang@linux.intel.com>
In-Reply-To: <ZbvyrvvZM-Tocza2@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/2/2024 3:36 AM, Sean Christopherson wrote:
> On Thu, Feb 01, 2024, Mingwei Zhang wrote:
>> On Thu, Feb 01, 2024, Sean Christopherson wrote:
>>> On Wed, Jan 31, 2024, Mingwei Zhang wrote:
>>>>> The PMC is still active while the VM side handle_pmi_common() is not going to handle it?
>>>>
>>>> hmm, so the new value is '0', but the old value is non-zero, KVM is
>>>> supposed to zero out (stop) the fix counter), but it skips it. This
>>>> leads to the counter continuously increasing until it overflows, but
>>>> guest PMU thought it had disabled it. That's why you got this warning?
>>>
>>> No, that can't happen, and KVM would have a massive bug if that were the case.
>>> The truncation can _only_ cause bits to disappear, it can't magically make bits
>>> appear, i.e. the _only_ way this can cause a problem is for KVM to incorrectly
>>> think a PMC is being disabled.
>>
>> The reason why the bug does not happen is because there is global
>> control. So disabling a counter will be effectively done in the global
>> disable part, ie., when guest PMU writes to MSR 0x38f.
> 
> 
>>> fixed PMC is disabled. KVM will pause the counter in reprogram_counter(), and
>>> then leave the perf event paused counter as pmc_event_is_allowed() will return
>>> %false due to the PMC being locally disabled.
>>>
>>> But in this case, _if_ the counter is actually enabled, KVM will simply reprogram
>>> the PMC.  Reprogramming is unnecessary and wasteful, but it's not broken.
>>
>> no, if the counter is actually enabled, but then it is assigned to
>> old_fixed_ctr_ctrl, the value is truncated. When control goes to the
>> check at the time of disabling the counter, KVM thinks it is disabled,
>> since the value is already truncated to 0. So KVM will skip by saying
>> "oh, the counter is already disabled, why reprogram? No need!".
> 
> Ooh, I had them backwards.  KVM can miss 1=>0, but not 0=>1.  I'll apply this
> for 6.8; does this changelog work for you?
> 
>   Use a u64 instead of a u8 when taking a snapshot of pmu->fixed_ctr_ctrl
>   when reprogramming fixed counters, as truncating the value results in KVM
>   thinking all fixed counters, except counter 0, 
each counter has four bits in fixed_ctr_ctrl, here u8 could cover counter 0 and counter 1, so "except counter 0" can be modified to "except counter 0 and 1" 
> are already disabled.  
>   a result, if the guest disables a fixed counter, KVM will get a false
>   negative and fail to reprogram/disable emulation of the counter, which can
>   leads to spurious PMIs in the guest.
> 

