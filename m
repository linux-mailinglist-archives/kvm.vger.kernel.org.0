Return-Path: <kvm+bounces-15761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 33D7C8B041A
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 10:19:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6C5E5B2262C
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 08:18:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D35A158877;
	Wed, 24 Apr 2024 08:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kQG+qraR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E5729CA;
	Wed, 24 Apr 2024 08:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713946727; cv=none; b=SODtBluztJhoSotqfmiP2Ko4HawuhQk+bjXCydmsaU55SjgtfgZXyf+hjBfL/nQn3Th9TnN8IWoqe6PHjRRRyi38lOKlcDan8tkHKqQZby3zPudRX0kuueNaJzKUpWoagCbzJTav5/vI5MjOB57g/foaY5BdMfnR7PxhwtuChlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713946727; c=relaxed/simple;
	bh=t/uLVgdRFsjN+GoDeqcqHTFvHC0C4nfbCxY7QDnPoHo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XWa5KJq201KjXloPPQ1ku0uuZ5KogHYgdrz+IbYrxYzqFYEeKNxFJ8Yn4EojYxf930Da7BOywB+5l75e8tZQ092ms64EVXJbc+4WFxcBmW3dUPLIeKqGNKUcvpte/6L4UjwbUjhbb8kzS2Dhulj45BE/jN0Q7ZcBSPhoGLMe3UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kQG+qraR; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713946726; x=1745482726;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=t/uLVgdRFsjN+GoDeqcqHTFvHC0C4nfbCxY7QDnPoHo=;
  b=kQG+qraR46vy6oIp2dhUu6JRHyRMtOWbMeQhdUfsNhNzNxsecoV/pzCg
   +VbZfkfJI8Rglg6BAj3NaXI8ncYI1Zf7iVACjyF0wyqG5o8HqfFujbSW+
   U4TY4nSjUyt25qlAWXR61+/vHk4jedLGPdiQUJ2TA0Ce6PDDcEpB4EX1J
   VeI13FpRvJpbPAz8r+B8EcIbmEYGkSeVSOVmtZ9YLDSbrS3b23PnmK3H3
   kz9QYxSploAOr/oR1K4RfkojrfnlH7XJiuSLui9urw/COpqLueWgvkUs4
   HpBS3nMdOT9Cs+R9KtEayGKQC1U2z/xaRf3YyVlZTt4We5d+6bFwxhQd6
   g==;
X-CSE-ConnectionGUID: I1JiSvOdQkq7tTWJsy6Nnw==
X-CSE-MsgGUID: ITH1f5B3TA+UazuT1M9Qsw==
X-IronPort-AV: E=McAfee;i="6600,9927,11053"; a="20974024"
X-IronPort-AV: E=Sophos;i="6.07,225,1708416000"; 
   d="scan'208";a="20974024"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 01:18:45 -0700
X-CSE-ConnectionGUID: 021vjcLYQpSIAYljBGoWeg==
X-CSE-MsgGUID: p/iCYArfSLKoLGTy7FBMLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,225,1708416000"; 
   d="scan'208";a="25240028"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.127]) ([10.124.245.127])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 01:18:40 -0700
Message-ID: <f843298c-db08-4fde-9887-13de18d960ac@linux.intel.com>
Date: Wed, 24 Apr 2024 16:18:37 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
To: Mingwei Zhang <mizhang@google.com>, maobibo <maobibo@loongson.cn>
Cc: Sean Christopherson <seanjc@google.com>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com,
 peterz@infradead.org, kan.liang@intel.com, zhenyuw@linux.intel.com,
 jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com,
 irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com,
 chao.gao@intel.com
References: <18b19dd4-6d76-4ed8-b784-32436ab93d06@linux.intel.com>
 <4c47b975-ad30-4be9-a0a9-f0989d1fa395@linux.intel.com>
 <CAL715WJXWQgfzgh8KqL+pAzeqL+dkF6imfRM37nQ6PkZd09mhQ@mail.gmail.com>
 <737f0c66-2237-4ed3-8999-19fe9cca9ecc@linux.intel.com>
 <CAL715W+RKCLsByfM3-0uKBWdbYgyk_hou9oC+mC9H61yR_9tyw@mail.gmail.com>
 <Zh1mKoHJcj22rKy8@google.com>
 <CAL715WJf6RdM3DQt995y4skw8LzTMk36Q2hDE34n3tVkkdtMMw@mail.gmail.com>
 <Zh2uFkfH8BA23lm0@google.com>
 <4d60384a-11e0-2f2b-a568-517b40c91b25@loongson.cn>
 <ZiaX3H3YfrVh50cs@google.com>
 <d8f3497b-9f63-e30e-0c63-253908d40ac2@loongson.cn>
 <d980dd10-e4c4-4774-b107-77b320cec9f9@linux.intel.com>
 <b5e97aa1-7683-4eff-e1e3-58ac98a8d719@loongson.cn>
 <1ec7a21c-71d0-4f3e-9fa3-3de8ca0f7315@linux.intel.com>
 <5279eabc-ca46-ee1b-b80d-9a511ba90a36@loongson.cn>
 <CAL715WJK893gQd1m9CCAjz5OkxsRc5C4ZR7yJWJXbaGvCeZxQA@mail.gmail.com>
 <b3868bf5-4e16-3435-c807-f484821fccc6@loongson.cn>
 <CAL715W++maAt2Ujfvmu1pZKS4R5EmAPebTU_h9AB8aFbdLFrTQ@mail.gmail.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <CAL715W++maAt2Ujfvmu1pZKS4R5EmAPebTU_h9AB8aFbdLFrTQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 4/24/2024 1:02 AM, Mingwei Zhang wrote:
>>> Maybe, (just maybe), it is possible to do PMU context switch at vcpu
>>> boundary normally, but doing it at VM Enter/Exit boundary when host is
>>> profiling KVM kernel module. So, dynamically adjusting PMU context
>>> switch location could be an option.
>> If there are two VMs with pmu enabled both, however host PMU is not
>> enabled. PMU context switch should be done in vcpu thread sched-out path.
>>
>> If host pmu is used also, we can choose whether PMU switch should be
>> done in vm exit path or vcpu thread sched-out path.
>>
> host PMU is always enabled, ie., Linux currently does not support KVM
> PMU running standalone. I guess what you mean is there are no active
> perf_events on the host side. Allowing a PMU context switch drifting
> from vm-enter/exit boundary to vcpu loop boundary by checking host
> side events might be a good option. We can keep the discussion, but I
> won't propose that in v2.

I suspect if it's really doable to do this deferring. This still makes 
host lose the most of capability to profile KVM. Per my understanding, 
most of KVM overhead happens in the vcpu loop, exactly speaking in 
VM-exit handling. We have no idea when host want to create perf event to 
profile KVM, it could be at any time.


>
> I guess we are off topic. Sean's suggestion is that we should put
> "perf" and "kvm" together while doing the context switch. I think this
> is quite reasonable regardless of the PMU context switch location.
>
> To execute this, I am thinking about adding a parameter or return
> value to perf_guest_enter() so that once it returns back to KVM, KVM
> gets to know which counters are active/inactive/cleared from the host
> side. Knowing that, KVM can do the context switch more efficiently.
>
> Thanks.
> -Mingwei
>

