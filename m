Return-Path: <kvm+bounces-16052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 174488B3926
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 15:56:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8996286858
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 13:56:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BC3B15575C;
	Fri, 26 Apr 2024 13:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bajOi7Q0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1A1152DE6;
	Fri, 26 Apr 2024 13:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714139646; cv=none; b=qiXr+/Vtyvw3ek/7lAzlGnVv8SG1+RW8PYQxOXz6e3s/4Nfu7SCYdEjxlS8s77QDrHfA6VLN0vjbimgsvvT6asmIp3g9Rn2gSWtlR15Y+NkXQhsRaAtgCB8IxG4kc4IqHepH1YsdipxvDGgJ207nSYik4bBMOV6xHQKI/zb6jGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714139646; c=relaxed/simple;
	bh=bAxQvKHPxifR8Q+hfGehNFp9bGXBbIA6BrOH/rfmmCg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IkaXUNESLAYFmvfMpiGWBxU2wDa/hYMSiEqFnS4X1vkRQGsdAay3OFStVAo9Rfb8QWYa2CgBH+cqbGzKqSqDO7tAr493Tj1t+vPP5EyX3jPOuCufDjvhJo/I6IN/rMSXe0wFfQmG8H7Tk5HopXq3Iq/vBvv3Q0lNHseSa8TOYg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bajOi7Q0; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714139645; x=1745675645;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bAxQvKHPxifR8Q+hfGehNFp9bGXBbIA6BrOH/rfmmCg=;
  b=bajOi7Q0pcSyNXuFFJt6aHiTZhvwXd/6138yMkwPEAZMLehxCGvF1P5Q
   1JRXG8ezTqOZk1LnmdcpYzJ7D/WIBQ4UNJdTvv0jDid0vo7Afg6eIiTua
   ECQPXZ1K96H4lRJxjkbN5F1VFE+kJJVHOpulv6BeQfQ8T2c6sUal//NF4
   3ENpqmD0Zg1g0vnu4OzkuBBdaeAWOb37OdyU9K3xUfxPx9hGbKGY3vcpC
   //oxjug7nDKf3wc/KC+LLzkxMAVMXJn8TYUbjXk7ru4tn8XFlgbjINgt/
   rTd9ei0V/o+3SkBgB16nv4KxzezcC2tljrnLwi47FjuJ4phSRx3hscLYt
   Q==;
X-CSE-ConnectionGUID: /pONWJr7SPOXzCDZXDflzA==
X-CSE-MsgGUID: dnlJfU6PSamyKeeCFrFXAA==
X-IronPort-AV: E=McAfee;i="6600,9927,11056"; a="21279808"
X-IronPort-AV: E=Sophos;i="6.07,232,1708416000"; 
   d="scan'208";a="21279808"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 06:54:03 -0700
X-CSE-ConnectionGUID: 1kOa4ofjSCepnR1fziNLxw==
X-CSE-MsgGUID: 3vqCDBAgR12hvaQWf3DXlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,232,1708416000"; 
   d="scan'208";a="25428927"
Received: from linux.intel.com ([10.54.29.200])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 06:54:03 -0700
Received: from [10.212.113.23] (kliang2-mobl1.ccr.corp.intel.com [10.212.113.23])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id 1632C20B8CF1;
	Fri, 26 Apr 2024 06:54:00 -0700 (PDT)
Message-ID: <a55aca0f-47b0-4c0a-b4dc-089018bd9419@linux.intel.com>
Date: Fri, 26 Apr 2024 09:53:59 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
To: Sean Christopherson <seanjc@google.com>
Cc: Mingwei Zhang <mizhang@google.com>, Dapeng Mi
 <dapeng1.mi@linux.intel.com>, maobibo <maobibo@loongson.cn>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com,
 peterz@infradead.org, kan.liang@intel.com, zhenyuw@linux.intel.com,
 jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com,
 irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com,
 chao.gao@intel.com
References: <CAL715WJK893gQd1m9CCAjz5OkxsRc5C4ZR7yJWJXbaGvCeZxQA@mail.gmail.com>
 <b3868bf5-4e16-3435-c807-f484821fccc6@loongson.cn>
 <CAL715W++maAt2Ujfvmu1pZKS4R5EmAPebTU_h9AB8aFbdLFrTQ@mail.gmail.com>
 <f843298c-db08-4fde-9887-13de18d960ac@linux.intel.com>
 <Zikeh2eGjwzDbytu@google.com>
 <7834a811-4764-42aa-8198-55c4556d947b@linux.intel.com>
 <CAL715WKh8VBJ-O50oqSnCqKPQo4Bor_aMnRZeS_TzJP3ja8-YQ@mail.gmail.com>
 <6af2da05-cb47-46f7-b129-08463bc9469b@linux.intel.com>
 <CAL715W+zeqKenPLP2Fm9u_BkGRKAk-mncsOxrg=EKs74qK5f1Q@mail.gmail.com>
 <42acf1fc-1603-4ac5-8a09-edae2d85963d@linux.intel.com>
 <ZirPGnSDUzD-iWwc@google.com>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <ZirPGnSDUzD-iWwc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2024-04-25 5:46 p.m., Sean Christopherson wrote:
> On Thu, Apr 25, 2024, Kan Liang wrote:
>> On 2024-04-25 4:16 p.m., Mingwei Zhang wrote:
>>> On Thu, Apr 25, 2024 at 9:13 AM Liang, Kan <kan.liang@linux.intel.com> wrote:
>>>> It should not happen. For the current implementation, perf rejects all
>>>> the !exclude_guest system-wide event creation if a guest with the vPMU
>>>> is running.
>>>> However, it's possible to create an exclude_guest system-wide event at
>>>> any time. KVM cannot use the information from the VM-entry to decide if
>>>> there will be active perf events in the VM-exit.
>>>
>>> Hmm, why not? If there is any exclude_guest system-wide event,
>>> perf_guest_enter() can return something to tell KVM "hey, some active
>>> host events are swapped out. they are originally in counter #2 and
>>> #3". If so, at the time when perf_guest_enter() returns, KVM will ack
>>> that and keep it in its pmu data structure.
>>
>> I think it's possible that someone creates !exclude_guest event after
> 
> I assume you mean an exclude_guest=1 event?  Because perf should be in a state
> where it rejects exclude_guest=0 events.
>

Right.

>> the perf_guest_enter(). The stale information is saved in the KVM. Perf
>> will schedule the event in the next perf_guest_exit(). KVM will not know it.
> 
> Ya, the creation of an event on a CPU that currently has guest PMU state loaded
> is what I had in mind when I suggested a callback in my sketch:
> 
>  :  D. Add a perf callback that is invoked from IRQ context when perf wants to
>  :     configure a new PMU-based events, *before* actually programming the MSRs,
>  :     and have KVM's callback put the guest PMU state
> 
> It's a similar idea to TIF_NEED_FPU_LOAD, just that instead of a common chunk of
> kernel code swapping out the guest state (kernel_fpu_begin()), it's a callback
> into KVM.

Yes, a callback should be required. I think it should be done right
before switching back to the host perf events, so there are an accurate
active event list.

Thanks,
Kan

