Return-Path: <kvm+bounces-15888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 812988B19C0
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 05:56:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B2ED1C2136C
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 03:56:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CBB72B9DE;
	Thu, 25 Apr 2024 03:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KlGh8pyd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96892381BD;
	Thu, 25 Apr 2024 03:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714017359; cv=none; b=KJPCYvPWGwY54mm08dyQORtcQZYyq7IQmmaOJWd018RWu+NCAftNGMOz6Qp41oPdOpATxlkJAZ4Zhqd0ZXL+gyPf6p4KOXS4fROhWDr6QRvYqQMCYK1H6QF0JrOoqwa9NQu4x+FRmyKhR7Cow1ZuMHaObxOR/HJvVLxX4NOSbpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714017359; c=relaxed/simple;
	bh=lpblbahiz8bPblDm/1AOlijrM4+br6b34TjTLViMY4M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hkwN3HBhBXN9bHSrfCMrPZNsT14fqXE9s4Q1VjJitzCF/zQvmnsk7LSs1bzZCXhsDmCOfa618GvQj2tCQ8XMzFr8TrzpVXiulTCxUNAxin70Z11ZF2ayaPi/bL1fYXGjY7JIYnGPxkLNHiCVWsxw8bAks27z3eChWuDzpocTDhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KlGh8pyd; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714017358; x=1745553358;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lpblbahiz8bPblDm/1AOlijrM4+br6b34TjTLViMY4M=;
  b=KlGh8pydX9JBqXNTkF/Qbxe0kJDFDttvFmo6/pG4Sr/Ch3awdEIXGvty
   wXIwVpicwWYXr5FmxeAJh1P4gOuM78XKvMrqSRx1IYh3ZZ57zqZyKhF9u
   O4yK36fZm/77Au/Ol9OqAFqRW+nHKfA4WdIMGLRGuXHBxphkiWdWiMSli
   jU52zyHeXJkXJz7MdGIW2XRfPuBQPTN4rdZkabu/Z3Rk5F8piJYqKIuc1
   uo0FplQzycs2pz1TVhiTKAv7Q6G2qsUyO1TjPV3AAkv224Nzxdih1gXEB
   iboHKhguz3OBmGCuslB8VpzJm6JC5vs188BLcaEc0qzANVG1XP0o5234s
   Q==;
X-CSE-ConnectionGUID: 0RJn/3ZNSO+v3Orno+EFaw==
X-CSE-MsgGUID: Kz2Bj+WzQS+4jBg0fVls0A==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="10215933"
X-IronPort-AV: E=Sophos;i="6.07,228,1708416000"; 
   d="scan'208";a="10215933"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 20:55:57 -0700
X-CSE-ConnectionGUID: Rq8PEeZJRJ2aKqOraVbXLg==
X-CSE-MsgGUID: WyTUdei7SX6gOfkKNXVeUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,228,1708416000"; 
   d="scan'208";a="48174436"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.127]) ([10.124.245.127])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 20:55:53 -0700
Message-ID: <7834a811-4764-42aa-8198-55c4556d947b@linux.intel.com>
Date: Thu, 25 Apr 2024 11:55:50 +0800
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
Cc: Mingwei Zhang <mizhang@google.com>, maobibo <maobibo@loongson.cn>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com,
 peterz@infradead.org, kan.liang@intel.com, zhenyuw@linux.intel.com,
 jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com,
 irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com,
 chao.gao@intel.com
References: <ZiaX3H3YfrVh50cs@google.com>
 <d8f3497b-9f63-e30e-0c63-253908d40ac2@loongson.cn>
 <d980dd10-e4c4-4774-b107-77b320cec9f9@linux.intel.com>
 <b5e97aa1-7683-4eff-e1e3-58ac98a8d719@loongson.cn>
 <1ec7a21c-71d0-4f3e-9fa3-3de8ca0f7315@linux.intel.com>
 <5279eabc-ca46-ee1b-b80d-9a511ba90a36@loongson.cn>
 <CAL715WJK893gQd1m9CCAjz5OkxsRc5C4ZR7yJWJXbaGvCeZxQA@mail.gmail.com>
 <b3868bf5-4e16-3435-c807-f484821fccc6@loongson.cn>
 <CAL715W++maAt2Ujfvmu1pZKS4R5EmAPebTU_h9AB8aFbdLFrTQ@mail.gmail.com>
 <f843298c-db08-4fde-9887-13de18d960ac@linux.intel.com>
 <Zikeh2eGjwzDbytu@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <Zikeh2eGjwzDbytu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 4/24/2024 11:00 PM, Sean Christopherson wrote:
> On Wed, Apr 24, 2024, Dapeng Mi wrote:
>> On 4/24/2024 1:02 AM, Mingwei Zhang wrote:
>>>>> Maybe, (just maybe), it is possible to do PMU context switch at vcpu
>>>>> boundary normally, but doing it at VM Enter/Exit boundary when host is
>>>>> profiling KVM kernel module. So, dynamically adjusting PMU context
>>>>> switch location could be an option.
>>>> If there are two VMs with pmu enabled both, however host PMU is not
>>>> enabled. PMU context switch should be done in vcpu thread sched-out path.
>>>>
>>>> If host pmu is used also, we can choose whether PMU switch should be
>>>> done in vm exit path or vcpu thread sched-out path.
>>>>
>>> host PMU is always enabled, ie., Linux currently does not support KVM
>>> PMU running standalone. I guess what you mean is there are no active
>>> perf_events on the host side. Allowing a PMU context switch drifting
>>> from vm-enter/exit boundary to vcpu loop boundary by checking host
>>> side events might be a good option. We can keep the discussion, but I
>>> won't propose that in v2.
>> I suspect if it's really doable to do this deferring. This still makes host
>> lose the most of capability to profile KVM. Per my understanding, most of
>> KVM overhead happens in the vcpu loop, exactly speaking in VM-exit handling.
>> We have no idea when host want to create perf event to profile KVM, it could
>> be at any time.
> No, the idea is that KVM will load host PMU state asap, but only when host PMU
> state actually needs to be loaded, i.e. only when there are relevant host events.
>
> If there are no host perf events, KVM keeps guest PMU state loaded for the entire
> KVM_RUN loop, i.e. provides optimal behavior for the guest.  But if a host perf
> events exists (or comes along), the KVM context switches PMU at VM-Enter/VM-Exit,
> i.e. lets the host profile almost all of KVM, at the cost of a degraded experience
> for the guest while host perf events are active.

I see. So KVM needs to provide a callback which needs to be called in 
the IPI handler. The KVM callback needs to be called to switch PMU state 
before perf really enabling host event and touching PMU MSRs. And only 
the perf event with exclude_guest attribute is allowed to create on 
host. Thanks.


>
> My original sketch: https://lore.kernel.org/all/ZR3eNtP5IVAHeFNC@google.com

