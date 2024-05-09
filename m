Return-Path: <kvm+bounces-17074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BFF38C0877
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 02:30:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17AA0281383
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 00:30:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33BCBD53B;
	Thu,  9 May 2024 00:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FMNM/G/k"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E674A1E;
	Thu,  9 May 2024 00:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715214627; cv=none; b=iYLfv7T2nyLml4Qo6ndtt9xapVCJTUPjsNwDRihIkgYzhgptuey7Wqz+DdJOx0xIvTI96l9ly1TuVPnsiLkJ3CTyQ1NIh+QUXcN4QHbEDv2CiYFenmaxTktg6x2475SWMiMaEgzxGF/B+rKWmMZNeewoL7iwqyT7r2b4tHo8x6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715214627; c=relaxed/simple;
	bh=ted70+Kuy5h9xVExwUhBMtKtr++OiqTL+QM46KCvl6c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E4OBGtvc/RavkmQO3MWTV94gYoi2aABxpPrkP/uU4YFrOc/jftJ/pFDf3jaBpNK5ihi5633N7BiyVfIFZIqVmIVHitsLcG7MeNgJd8yFIbdyggbIhsWDrke3bSE11zF2XmPrlw3GoFWN8I4uw84mRX6YfOAdChcrvux4e7dU8f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FMNM/G/k; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715214626; x=1746750626;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ted70+Kuy5h9xVExwUhBMtKtr++OiqTL+QM46KCvl6c=;
  b=FMNM/G/kZNSGLpRJzq1GKgyljNm7u6zhRN67RbwFFP4F5M93nyFj7KPo
   WFWJu0xEkD5RtJUGop9Luhsv/WZb3Vnz0L//IfpDWsglF2ma0udJ0ql6U
   QqF3jflfb04sICSNDdZdm4MYHKljYGoJf8a8dfiFnMxKyUaFFi/4RaZFP
   8qc38GcNXHcZTf2+SehYt83nplXOh0p4weVXB8UjipNY3OLUopy0R8+SU
   3j/YtmWCJdHgOWIfyZHyUqVAJdo/fm+LGXAdPnLQwFTQ3uRWLvK/xZPz7
   gIMvnxnAO8kuyV7sZOHSiNgE+3U4edNXrUro476HrBU8DwX7HG39zpSd8
   w==;
X-CSE-ConnectionGUID: NZ0Jb2TnTTCwLiW2kprLmA==
X-CSE-MsgGUID: SsDTlew5SpCB0NwYO5m7RA==
X-IronPort-AV: E=McAfee;i="6600,9927,11067"; a="11268207"
X-IronPort-AV: E=Sophos;i="6.08,146,1712646000"; 
   d="scan'208";a="11268207"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 17:30:24 -0700
X-CSE-ConnectionGUID: OltnZoKSTcK2/InVffmtjA==
X-CSE-MsgGUID: Ob3ErmGbSDmNXNtDeTBy/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,146,1712646000"; 
   d="scan'208";a="33891543"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.225.92]) ([10.124.225.92])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2024 17:30:18 -0700
Message-ID: <7b719c40-9450-45a7-bb8d-bab643d69cd3@linux.intel.com>
Date: Thu, 9 May 2024 08:30:15 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 17/54] KVM: x86/pmu: Always set global enable bits in
 passthrough mode
To: Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang
 <xiong.y.zhang@intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla
 <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>,
 Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-18-mizhang@google.com>
 <3eb01add-3776-46a8-87f7-54144692d7d7@linux.intel.com>
 <CAL715WL80ZOtAo2mT95_zW9Xhv-qOqnPjLGPMp1bJKZ1dOxhTg@mail.gmail.com>
 <fbb8306c-775b-4f00-a2a6-a0b17c8f038e@linux.intel.com>
 <ZjuIiDwbrWL7OD86@google.com>
 <CAL715W+qV6D1WfTOMLv2ZgKZnJM-hDnBL-iiVr2m1_SK1rVpjA@mail.gmail.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <CAL715W+qV6D1WfTOMLv2ZgKZnJM-hDnBL-iiVr2m1_SK1rVpjA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 5/9/2024 8:13 AM, Mingwei Zhang wrote:
> On Wed, May 8, 2024 at 7:13 AM Sean Christopherson <seanjc@google.com> wrote:
>> On Wed, May 08, 2024, Dapeng Mi wrote:
>>> On 5/8/2024 12:36 PM, Mingwei Zhang wrote:
>>>> if (pmu->passthrough && pmu->nr_arch_gp_counters)
>>>>
>>>> Since mediated passthrough PMU requires PerfMon v4 in Intel (PerfMon
>>>> v2 in AMD), once it is enabled (pmu->passthrough = true), then global
>>>> ctrl _must_ exist phyiscally. Regardless of whether we expose it to
>>>> the guest VM, at reset time, we need to ensure enabling bits for GP
>>>> counters are set (behind the screen). This is critical for AMD, since
>>>> most of the guests are usually in (AMD) PerfMon v1 in which global
>>>> ctrl MSR is inaccessible, but does exist and is operating in HW.
>>>>
>>>> Yes, if we eliminate that requirement (pmu->passthrough -> Perfmon v4
>>>> Intel / Perfmon v2 AMD), then this code will have to change. However,
>>> Yeah, that's what I'm worrying about. We ever discussed to support mediated
>>> vPMU on HW below perfmon v4. When someone implements this, he may not
>>> notice this place needs to be changed as well, this introduces a potential
>>> bug and we should avoid this.
> I think you might have worried too much about future problems, but
> yes, things are under the radar. For Intel, this version constraint
> might be ok as Perfmon v4 is skylake, which is already pretty early.
No, I don't think this is redundant worry since we did discuss this
requirement before and it could need to be supported in the future. We need
to consider the code's extensibility and not introduce potential issue.
>
> For AMD, things are slightly different, PerfMon v2 in AMD requires
> Genoa, which is pretty new. So, this problem probably could be
> something for AMD if they want to extend the new vPMU design to Milan,
> but we will see how people think. So one potential (easy) extension
> for AMD is host PerfMon v1 + guest PerfMon v1 support for mediated
> passthrough vPMU.
>
>> Just add a WARN on the PMU version.  I haven't thought much about whether or not
>> KVM should support mediated PMU for earlier hardware, but having a sanity check
>> on the assumptions of this code is reasonable even if we don't _plan_ on supporting
>> earlier hardware.
> Sure. That sounds pretty reasonable.
Good for me.
>
> Thanks.
> -Mingwei
>

