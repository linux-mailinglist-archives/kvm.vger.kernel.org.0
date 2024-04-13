Return-Path: <kvm+bounces-14590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBAA88A3A9A
	for <lists+kvm@lfdr.de>; Sat, 13 Apr 2024 05:19:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4EA2EB235A9
	for <lists+kvm@lfdr.de>; Sat, 13 Apr 2024 03:19:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B06A818E25;
	Sat, 13 Apr 2024 03:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f6Wi6bMn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A5818633;
	Sat, 13 Apr 2024 03:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712978360; cv=none; b=OEPeWDBpEUAXDWccgdfRwtkDez658BnDPFvXyJvUlKNRhgvQC2x7eREGP3MkjIzosSQWHMYD3iA1SBCTEbC+06RVBUMyLJFBn+opzxbkOOD57qRw/VVx19LB8/4hGziX2OBCSO3iez0JeFsBPXu+aZK3spLee7x4hBeOyFtITlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712978360; c=relaxed/simple;
	bh=tlILtvfbKOnPFtHiyRvVuwQZc/uBd22Ge+UJkIuqyds=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P9D/+3HezoQY/W5QF1FfEmR4sM12x8C2vAzHWGLzQ2tzvlxGp9vBDRu38Rv57kRvLhMvs9MytFMqR3pFCeDjXGVcJ8l8WospYOpak0Fduo5dkFjsF75Z8DtraEcs3/2NEa6k8PdFcsN7jsTzVuLq6cqCHMcgHh8r03nCR6NqJCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f6Wi6bMn; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712978360; x=1744514360;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tlILtvfbKOnPFtHiyRvVuwQZc/uBd22Ge+UJkIuqyds=;
  b=f6Wi6bMnpj94ljsDv+gv6hRVd8dg2M9/vhWz1nNF5A0PYKLabJIv/Lhp
   er1UpkVnAdlXpuyn0mbsGJk6tJ5pYWVuiNmm3072KYqUm56tHSyTa+7w1
   KrgjOSfo/ff6blwtDWkdhQfRZgzzthqqypz7iAGhqy7Bf6n565QWS9e47
   LHcXjEp4wUs+j8lQevQMikk2VwaDkG10uzq/gObl93o2gmQ7+kuIVIaZu
   6hk23v1VSc5GdI1844icIegMtGKcyKDBVOcUlYea8KJEJ0XpCr43dOn40
   Qv48AYB/biyKuWK5VF40GuiKJzNb8k4Kg5eBdAod/q/e+A1V0QIMPgSOB
   g==;
X-CSE-ConnectionGUID: OGKvaGVPQmqwSXcUV6bEbA==
X-CSE-MsgGUID: qbTxctRTQrGbmTLNi2QzeA==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="25908367"
X-IronPort-AV: E=Sophos;i="6.07,198,1708416000"; 
   d="scan'208";a="25908367"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 20:19:19 -0700
X-CSE-ConnectionGUID: MZvdWcstR9a2//TqUiwu2Q==
X-CSE-MsgGUID: U28LofAETEu0YDXkt9VXzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,198,1708416000"; 
   d="scan'208";a="44670199"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.225.92]) ([10.124.225.92])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 20:19:14 -0700
Message-ID: <724e77ee-b70f-4b9e-8aaa-1ea572b14186@linux.intel.com>
Date: Sat, 13 Apr 2024 11:19:11 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
To: Sean Christopherson <seanjc@google.com>, Jim Mattson <jmattson@google.com>
Cc: Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com,
 peterz@infradead.org, mizhang@google.com, kan.liang@intel.com,
 zhenyuw@linux.intel.com, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
 zhiyuan.lv@intel.com, eranian@google.com, irogers@google.com,
 samantha.alt@intel.com, like.xu.linux@gmail.com, chao.gao@intel.com
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com>
 <20240126085444.324918-24-xiong.y.zhang@linux.intel.com>
 <ZhhZush_VOEnimuw@google.com>
 <CALMp9eS4H-WZXRCrp+6aAgwAp+qP2BgJx5ik5kA7vdyQ9qzARg@mail.gmail.com>
 <ZhhyxT66RdpiCRA2@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <ZhhyxT66RdpiCRA2@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 4/12/2024 7:31 AM, Sean Christopherson wrote:
> On Thu, Apr 11, 2024, Jim Mattson wrote:
>> On Thu, Apr 11, 2024 at 2:44 PM Sean Christopherson <seanjc@google.com> wrote:
>>>> +     /* Clear host global_ctrl and global_status MSR if non-zero. */
>>>> +     wrmsrl(MSR_CORE_PERF_GLOBAL_CTRL, 0);
>>> Why?  PERF_GLOBAL_CTRL will be auto-loaded at VM-Enter, why do it now?
>>>
>>>> +     rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, global_status);
>>>> +     if (global_status)
>>>> +             wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, global_status);
>>> This seems especially silly, isn't the full MSR being written below?  Or am I
>>> misunderstanding how these things work?
>> LOL! You expect CPU design to follow basic logic?!?
>>
>> Writing a 1 to a bit in IA32_PERF_GLOBAL_STATUS_SET sets the
>> corresponding bit in IA32_PERF_GLOBAL_STATUS to 1.
>>
>> Writing a 0 to a bit in to IA32_PERF_GLOBAL_STATUS_SET is a nop.
>>
>> To clear a bit in IA32_PERF_GLOBAL_STATUS, you need to write a 1 to
>> the corresponding bit in IA32_PERF_GLOBAL_STATUS_RESET (aka
>> IA32_PERF_GLOBAL_OVF_CTRL).
> If only C had a way to annotate what the code is doing. :-)
>
>>>> +     wrmsrl(MSR_CORE_PERF_GLOBAL_STATUS_SET, pmu->global_status);
> IIUC, that means this should be:
>
> 	if (pmu->global_status)
> 		wrmsrl(MSR_CORE_PERF_GLOBAL_STATUS_SET, pmu->global_status);
>
> or even better:
>
> 	toggle = pmu->global_status ^ global_status;
> 	if (global_status & toggle)
> 		wrmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, global_status & toggle);
> 	if (pmu->global_status & toggle)
> 		wrmsrl(MSR_CORE_PERF_GLOBAL_STATUS_SET, pmu->global_status & toggle);
Thanks, it looks better. Since PMU v4+, the MSR 
CORE_PERF_GLOBAL_OVF_CTRL is renamed to CORE_PERF_GLOBAL_STATUS_RESET 
with supporting more bits. CORE_PERF_GLOBAL_STATUS_RESET looks more 
easily understand just from name than CORE_PERF_GLOBAL_OVF_CTRL, I would 
prefer use this name in next version.

