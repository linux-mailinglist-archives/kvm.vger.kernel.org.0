Return-Path: <kvm+bounces-32041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 510E09D1F85
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 06:21:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0ACBD2824AE
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 05:21:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34C2614B06A;
	Tue, 19 Nov 2024 05:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WxOjR19I"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A512D10F4;
	Tue, 19 Nov 2024 05:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731993657; cv=none; b=XrqllD+qhk73qElTk+1Ep4/JA017ETJJfVB+BuqVV+lUMJM91QR62IP348BaQaXWM7w/1X8tuVl4JujmSdqREw0UaskSk2URX2L72vHTB22a4XO/EpW/OaPaYtniSJLDFec+/geaUCsl1XJnYW3LRtM3FUKF+Ij3vnKqi5hilXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731993657; c=relaxed/simple;
	bh=0LhOlYtoc+K47jwExqOnxJaoaJo4F51d8htmJO6ZKfY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OL4upsrUm+r2IVZd0OY1qCyKo+KFErXNSjkfDnvLMZlCSlYDeu0sQkiWWKTbxxqzRCb/Lokh6eD2RdQBrtROAbcGVaGCX+Pl/CetwW+8/taOFFG4QXG+wFF8HjUswqKcIbkQq6NOnrubOdw5nIIUDu/Jwd1193glASxMss44llA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WxOjR19I; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731993656; x=1763529656;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0LhOlYtoc+K47jwExqOnxJaoaJo4F51d8htmJO6ZKfY=;
  b=WxOjR19I82ru96KsLmgM8/e9k1E5jEyxmGS9J1hCndm98s1x2amQA9Ya
   T+wsQyQOHDQT3IXVzfzGOeKoYlBuieuYQ0RXVadD4mmE3xWTvDN247uAy
   XbRbjk+HPgWqLitwa0wOXDkA/D4sIMbF9bnfdQl4r2iQcef4ls74pV7kb
   Nu6AFD6CdMagcC4l/sap/04b3/cJjV9nMlJlviJIZv98+BUeF5GDzDhYv
   v0BbEIKfobJPdjtuAPSb1/XSczI6ptK7g0scXPS16BBXlj37vFki+FFlr
   lXOZEan2BUHu3kz4Kh2op1oxjM0AXJXJ44M3CyEqLXIoWbvIISwpi5xK1
   w==;
X-CSE-ConnectionGUID: hYfZ+BwQRiKOgwSZxgc3Dg==
X-CSE-MsgGUID: C7NX9JX/R0KfmDPki/GsUg==
X-IronPort-AV: E=McAfee;i="6700,10204,11260"; a="42493218"
X-IronPort-AV: E=Sophos;i="6.12,165,1728975600"; 
   d="scan'208";a="42493218"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2024 21:20:55 -0800
X-CSE-ConnectionGUID: RsnebyIzSzmm+xyjIVplaw==
X-CSE-MsgGUID: YH0kDcsPQcetdkiwcmLkZA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="94498719"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2024 21:20:49 -0800
Message-ID: <67013550-9739-4943-812f-4ba6f01e4fb4@linux.intel.com>
Date: Tue, 19 Nov 2024 13:20:47 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 37/58] KVM: x86/pmu: Switch IA32_PERF_GLOBAL_CTRL
 at VM boundary
To: Sean Christopherson <seanjc@google.com>
Cc: Zide Chen <zide.chen@intel.com>, Mingwei Zhang <mizhang@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>,
 Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-38-mizhang@google.com>
 <5309ec1b-edc6-4e59-af88-b223dbf2a455@intel.com>
 <c21d02a3-4315-41f4-b873-bf28041a0d82@linux.intel.com>
 <Zzvt_fNw0U34I9bJ@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <Zzvt_fNw0U34I9bJ@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 11/19/2024 9:46 AM, Sean Christopherson wrote:
> On Fri, Oct 25, 2024, Dapeng Mi wrote:
>> On 10/25/2024 4:26 AM, Chen, Zide wrote:
>>> On 7/31/2024 9:58 PM, Mingwei Zhang wrote:
>>>
>>>> @@ -7295,6 +7299,46 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
>>>>  					msrs[i].host, false);
>>>>  }
>>>>  
>>>> +static void save_perf_global_ctrl_in_passthrough_pmu(struct vcpu_vmx *vmx)
>>>> +{
>>>> +	struct kvm_pmu *pmu = vcpu_to_pmu(&vmx->vcpu);
>>>> +	int i;
>>>> +
>>>> +	if (vm_exit_controls_get(vmx) & VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL) {
>>>> +		pmu->global_ctrl = vmcs_read64(GUEST_IA32_PERF_GLOBAL_CTRL);
>>> As commented in patch 26, compared with MSR auto save/store area
>>> approach, the exec control way needs one relatively expensive VMCS read
>>> on every VM exit.
>> Anyway, let us have a evaluation and data speaks.
> No, drop the unconditional VMREAD and VMWRITE, one way or another.  No benchmark
> will notice ~50 extra cycles, but if we write poor code for every feature, those
> 50 cycles per feature add up.
>
> Furthermore, checking to see if the CPU supports the load/save VMCS controls at
> runtime beyond ridiculous.  The mediated PMU requires ***VERSION 4***; if a CPU
> supports PMU version 4 and doesn't support the VMCS controls, KVM should yell and
> disable the passthrough PMU.  The amount of complexity added here to support a
> CPU that should never exist is silly.
>
>>>> +static void load_perf_global_ctrl_in_passthrough_pmu(struct vcpu_vmx *vmx)
>>>> +{
>>>> +	struct kvm_pmu *pmu = vcpu_to_pmu(&vmx->vcpu);
>>>> +	u64 global_ctrl = pmu->global_ctrl;
>>>> +	int i;
>>>> +
>>>> +	if (vm_entry_controls_get(vmx) & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) {
>>>> +		vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL, global_ctrl);
>>> ditto.
>>>
>>> We may optimize it by introducing a new flag pmu->global_ctrl_dirty and
>>> update GUEST_IA32_PERF_GLOBAL_CTRL only when it's needed.  But this
>>> makes the code even more complicated.
> I haven't looked at surrounding code too much, but I guarantee there's _zero_
> reason to eat a VMWRITE+VMREAD on every transition.  If, emphasis on *if*, KVM
> accesses PERF_GLOBAL_CTRL frequently, e.g. on most exits, then add a VCPU_EXREG_XXX
> and let KVM's caching infrastructure do the heavy lifting.  Don't reinvent the
> wheel.  But first, convince the world that KVM actually accesses the MSR somewhat
> frequently.

Sean, let me give more background here.

VMX supports two ways to save/restore PERF_GLOBAL_CTRL MSR, one is to
leverage VMCS_EXIT_CTRL/VMCS_ENTRY_CTRL to save/restore guest
PERF_GLOBAL_CTRL value to/from VMCS guest state. The other is to use the
VMCS MSR auto-load/restore bitmap to save/restore guest PERF_GLOBAL_CTRL. 

Currently we prefer to use the former way to save/restore guest
PERF_GLOBAL_CTRL as long as HW supports it. There is a limitation on the
MSR auto-load/restore feature. When there are multiple MSRs, the MSRs are
saved/restored in the order of MSR index. As the suggestion of SDM,
PERF_GLOBAL_CTRL should always be written at last after all other PMU MSRs
are manipulated. So if there are some PMU MSRs whose index is larger than
PERF_GLOBAL_CTRL (It would be true in archPerfmon v6+, all PMU MSRs in the
new MSR range have larger index than PERF_GLOBAL_CTRL), these PMU MSRs
would be restored after PERF_GLOBAL_CTRL. That would break the rule. Of
course, it's good to save/restore PERF_GLOBAL_CTRL right now with the VMCS
VMCS MSR auto-load/restore bitmap feature since only one PMU MSR
PERF_GLOBAL_CTRL is saved/restored in current implementation.

PERF_GLOBAL_CTRL MSR could be frequently accessed by perf/pmu driver, e.g.
on each task switch, so PERF_GLOBAL_CTRL MSR is configured to passthrough
to reduce the performance impact in mediated vPMU proposal if guest own all
PMU HW resource. But if guest only owns part of PMU HW resource,
PERF_GLOBAL_CTRL would be set to interception mode.

I suppose KVM doesn't need access PERF_GLOBAL_CTRL in passthrough mode.
This piece of code is intently just for PERF_GLOBAL_CTRL interception mode,
but think twice it looks unnecessary to save/restore PERF_GLOBAL_CTRL via
VMCS as KVM would always maintain the guest PERF_GLOBAL_CTRL value? Anyway,
this part of code can be optimized.


>
> I'll do a more thorough review of this series in the coming weeks (days?).  I
> singled out this one because I happened to stumble across the code when digging
> into something else.
Thanks, look forward to your more comments.



