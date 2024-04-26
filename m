Return-Path: <kvm+bounces-16076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 11D458B3FE0
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 21:07:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C14E1F24257
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 19:07:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B5BA171A1;
	Fri, 26 Apr 2024 19:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RGrlB1ut"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5BE14287;
	Fri, 26 Apr 2024 19:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714158414; cv=none; b=CntuY6JlhTVE1GQFcBiNspcgwnznM5Y0AczwImWexIUKFLddnd1XUpicczmzdJG2CNWKxmKpm2NSQxeV1wjancfZBUlQCiPcDxjAfFQNvc7dDkwnMDFOqv+rWagnvyIrpWfAERcFU6QBJrGBszMHCXYA6tMNzYKSfphzL4ODs9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714158414; c=relaxed/simple;
	bh=m9b6G40kp1afnmm0V5y0dvG81PdgNevnz6Gc/nN0Sf8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rUnX02PPx86lwGqBuWCkeKu52lSGDmXeTTLaJl5drNM/X/HV2AMhCE9AJy1t166DvRu/d5Nly4SgFpRGVgFMKWCkfeGjXPKyRjf65y0OXPHVUuYybIHW6CNX1CtJDjsIg22BimEaJbyh8pk7FQfHBdI1Fi5sJDjXLapOzVelE90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RGrlB1ut; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714158413; x=1745694413;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=m9b6G40kp1afnmm0V5y0dvG81PdgNevnz6Gc/nN0Sf8=;
  b=RGrlB1utRaXljp6uZQeXSWW/+VMrhLoSUwUNFOA4m3vZ2DdlQUhced0M
   WP5HySUeLBCQ2YDrGxZwd5HDCugila+F3g7ZKTY3RMg+u5OZFKX8PJqRT
   iu471pG8aX2KDRQpL/NmycwnKh28KK1Quohv5TlGPZ/VNXmV5UDsr9TTk
   HgkHJ0hA9PzCVttvnhBxyePinSnCXGCqNkX91V9kroS9yKh3ZcmjAjzbT
   IlkYzz66e2/5ip967d7oDhJWIalp4bHJeBmioE2gbkAxipLop5+cdFhnM
   ZbFW3cug21lk7cvOhk9c90XWzfx1DzYS/sa4h43R7yUNPNaKy8nzK47L1
   A==;
X-CSE-ConnectionGUID: Kd2e5eS1QeyM+ksOPqqkIg==
X-CSE-MsgGUID: Oybc3LkXQMiNNpK/ForycA==
X-IronPort-AV: E=McAfee;i="6600,9927,11056"; a="20590719"
X-IronPort-AV: E=Sophos;i="6.07,233,1708416000"; 
   d="scan'208";a="20590719"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 12:06:52 -0700
X-CSE-ConnectionGUID: X4wpaZ3zSZKqBzol14fJpw==
X-CSE-MsgGUID: AaoO5+1XSUaac9KrS8UyPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,233,1708416000"; 
   d="scan'208";a="25910869"
Received: from linux.intel.com ([10.54.29.200])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 12:06:51 -0700
Received: from [10.212.113.23] (kliang2-mobl1.ccr.corp.intel.com [10.212.113.23])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id 7382E20B5739;
	Fri, 26 Apr 2024 12:06:49 -0700 (PDT)
Message-ID: <5f5bcbc0-e2ef-4232-a56a-fda93c6a569e@linux.intel.com>
Date: Fri, 26 Apr 2024 15:06:48 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of PMU
 state for Intel CPU
To: Mingwei Zhang <mizhang@google.com>
Cc: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>,
 Sean Christopherson <seanjc@google.com>, maobibo <maobibo@loongson.cn>,
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
 <77913327-2115-42b5-850a-04ef0581faa7@linux.intel.com>
 <CAL715WJCHJD_wcJ+r4TyWfvmk9uNT_kPy7Pt=CHkB-Sf0D4Rqw@mail.gmail.com>
 <ff4a4229-04ac-4cbf-8aea-c84ccfa96e0b@linux.intel.com>
 <CAL715WJKL5__8RU0xxUf0HifNVQBDRODE54O2bwOx45w67TQTQ@mail.gmail.com>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <CAL715WJKL5__8RU0xxUf0HifNVQBDRODE54O2bwOx45w67TQTQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024-04-26 2:41 p.m., Mingwei Zhang wrote:
>>> So this requires vcpu->pmu has two pieces of state information: 1) the
>>> flag similar to TIF_NEED_FPU_LOAD; 2) host perf context info (phase #1
>>> just a boolean; phase #2, bitmap of occupied counters).
>>>
>>> This is a non-trivial optimization on the PMU context switch. I am
>>> thinking about splitting them into the following phases:
>>>
>>> 1) lazy PMU context switch, i.e., wait until the guest touches PMU MSR
>>> for the 1st time.
>>> 2) fast PMU context switch on KVM side, i.e., KVM checking event
>>> selector value (enable/disable) and selectively switch PMU state
>>> (reducing rd/wr msrs)
>>> 3) dynamic PMU context boundary, ie., KVM can dynamically choose PMU
>>> context switch boundary depending on existing active host-level
>>> events.
>>> 3.1) more accurate dynamic PMU context switch, ie., KVM checking
>>> host-level counter position and further reduces the number of msr
>>> accesses.
>>> 4) guest PMU context preemption, i.e., any new host-level perf
>>> profiling can immediately preempt the guest PMU in the vcpu loop
>>> (instead of waiting for the next PMU context switch in KVM).
>> I'm not quit sure about the 4.
>> The new host-level perf must be an exclude_guest event. It should not be
>> scheduled when a guest is using the PMU. Why do we want to preempt the
>> guest PMU? The current implementation in perf doesn't schedule any
>> exclude_guest events when a guest is running.
> right. The grey area is the code within the KVM_RUN loop, but
> _outside_ of the guest. This part of the code is on the "host" side.
> However, for efficiency reasons, KVM defers the PMU context switch by
> retaining the guest PMU MSR values within the loop. 

I assume you mean the optimization of moving the context switch from
VM-exit/entry boundary to the vCPU boundary.

> Optimization 4
> allows the host side to immediately profiling this part instead of
> waiting for vcpu to reach to PMU context switch locations. Doing so
> will generate more accurate results.

If so, I think the 4 is a must to have. Otherwise, it wouldn't honer the
definition of the exclude_guest. Without 4, it brings some random blind
spots, right?

> 
> Do we want to preempt that? I think it depends. For regular cloud
> usage, we don't. But for any other usages where we want to prioritize
> KVM/VMM profiling over guest vPMU, it is useful.
> 
> My current opinion is that optimization 4 is something nice to have.
> But we should allow people to turn it off just like we could choose to
> disable preempt kernel.

The exclude_guest means everything but the guest. I don't see a reason
why people want to turn it off and get some random blind spots.

Thanks,
Kan

