Return-Path: <kvm+bounces-5669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 72BA78248DC
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 20:16:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 15BAAB24EA8
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 19:16:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F54D2C697;
	Thu,  4 Jan 2024 19:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="luapagr2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E752C18C;
	Thu,  4 Jan 2024 19:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704395773; x=1735931773;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ku8FLhwOfPcaG2mT+8xsOiO9kv0YTJBmD9TowHalxgM=;
  b=luapagr24kVIb+Y0Mg3bX4xQ0i7G76cwpGmUheVtefSAJDLwZ2pyIrw6
   BlA5KLN+4OJ7idoNv2Lfoh82g37nD6bCofMRzyk+hItPe5f4ASgtO7YMn
   auNgFQQikNkjk44ans5tuHmuX5JzPcnmI9BVeGjE/MKzt7aSfsVDTnxPz
   TNw8y8sC2nQIIU/EpRS8yISA+wKZiTw3aNL9R+Ak+hIoe3h6Y+6Fhivv2
   +nueC1+hVcJjeVWXcqRpLVh0XIPz9HsZeeOXZbYALXSla/30Fv5Ojjq22
   6Vn5LMsexzqqBPu8mep52mvZGZ6ASwpLYKKeqGKIs77rco2LAlG7T1ljf
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="396223699"
X-IronPort-AV: E=Sophos;i="6.04,331,1695711600"; 
   d="scan'208";a="396223699"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2024 11:16:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="814740125"
X-IronPort-AV: E=Sophos;i="6.04,331,1695711600"; 
   d="scan'208";a="814740125"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2024 11:16:12 -0800
Received: from [10.209.154.172] (kliang2-mobl1.ccr.corp.intel.com [10.209.154.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id CD158580DC7;
	Thu,  4 Jan 2024 11:16:10 -0800 (PST)
Message-ID: <0f9e80de-040d-4803-954f-311b846730c6@linux.intel.com>
Date: Thu, 4 Jan 2024 14:16:09 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86/pmu: fix masking logic for
 MSR_CORE_PERF_GLOBAL_CTRL
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, peterz@infradead.org, linux-perf-users@vger.kernel.org,
 leitao@debian.org, acme@kernel.org, mingo@redhat.com,
 "Paul E . McKenney" <paulmck@kernel.org>, stable@vger.kernel.org,
 Like Xu <like.xu.linux@gmail.com>
References: <20240104153939.129179-1-pbonzini@redhat.com>
 <a327286a-36a6-4cdc-92bd-777fb763d88a@linux.intel.com>
 <ZZbuwU8ShrcXWdMY@google.com>
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <ZZbuwU8ShrcXWdMY@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024-01-04 1:22 p.m., Sean Christopherson wrote:
> On Thu, Jan 04, 2024, Liang, Kan wrote:
>>
>>
>> On 2024-01-04 10:39 a.m., Paolo Bonzini wrote:
>>> When commit c59a1f106f5c ("KVM: x86/pmu: Add IA32_PEBS_ENABLE
>>> MSR emulation for extended PEBS") switched the initialization of
>>> cpuc->guest_switch_msrs to use compound literals, it screwed up
>>> the boolean logic:
>>>
>>> +	u64 pebs_mask = cpuc->pebs_enabled & x86_pmu.pebs_capable;
>>> ...
>>> -	arr[0].guest = intel_ctrl & ~cpuc->intel_ctrl_host_mask;
>>> -	arr[0].guest &= ~(cpuc->pebs_enabled & x86_pmu.pebs_capable);
>>> +               .guest = intel_ctrl & (~cpuc->intel_ctrl_host_mask | ~pebs_mask),
>>>
>>> Before the patch, the value of arr[0].guest would have been intel_ctrl &
>>> ~cpuc->intel_ctrl_host_mask & ~pebs_mask.  The intent is to always treat
>>> PEBS events as host-only because, while the guest runs, there is no way
>>> to tell the processor about the virtual address where to put PEBS records
>>> intended for the host.
>>>
>>> Unfortunately, the new expression can be expanded to
>>>
>>> 	(intel_ctrl & ~cpuc->intel_ctrl_host_mask) | (intel_ctrl & ~pebs_mask)
>>>
>>> which makes no sense; it includes any bit that isn't *both* marked as
>>> exclude_guest and using PEBS.  So, reinstate the old logic.  
>>
>> I think the old logic will completely disable the PEBS in guest
>> capability. Because the counter which is assigned to a guest PEBS event
>> will also be set in the pebs_mask. The old logic disable the counter in
>> GLOBAL_CTRL in guest. Nothing will be counted.
>>
>> Like once proposed a fix in the intel_guest_get_msrs().
>> https://lore.kernel.org/lkml/20231129095055.88060-1-likexu@tencent.com/
>> It should work for the issue.
> 
> No, that patch only affects the path where hardware supports enabling PEBS in the
> the guest, i.e. intel_guest_get_msrs() will bail before getting to that code due
> to the lack of x86_pmu.pebs_ept support, which IIUC is all pre-Icelake Intel CPUs.
> 
> 	if (!kvm_pmu || !x86_pmu.pebs_ept)
> 		return arr;
>

True, we have to disable all PEBS counters for pre-ICL as well.

I think what I missed is that the disable here is temporary. The
arr[global_ctrl].guest will be updated later for the x86_pmu.pebs_ept
platform, so the guest PEBS event should still work.

The patch looks good to me.

Reviewed-by: Kan Liang <kan.liang@linux.intel.com>

Thanks,
Kan

