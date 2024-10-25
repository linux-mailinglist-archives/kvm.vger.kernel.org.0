Return-Path: <kvm+bounces-29684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74A4D9AF7B2
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 04:51:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 84DA71C213E2
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 02:51:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D29A18A951;
	Fri, 25 Oct 2024 02:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gqRRKTva"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A9D1531C4;
	Fri, 25 Oct 2024 02:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729824707; cv=none; b=W5dBwNB8fM9L5T2HLE2AtM1uFxNaLtqrIwWeGU9qgmGGiTWQUaGy1FBoa7encOaPhkAQA3nXsURic1WKBipI+Li2vsEiddGsARsyiNOu3YJp+0OdM9WbHE+1ioBlX2sgn+3rQ16iFz3AgxCcoyNbQi4gzewBKgIxG3brdNsimrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729824707; c=relaxed/simple;
	bh=MiBw33vNZUy35DRG9WDiAdM7F4vciHQRd8BNTVBIfto=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r8r7MP7c9wk1UonW9L6lev2quymmzZzOFIJmWQQtenE1pJHYuu9nXqDeXSiuHDn7OMLYJjZpWg+yNFu3rOXuwota2hZ+bT+5Tja1u7rz0yMfyV0AJ+rBIugxajV10NYivlDTZj20CBojDLLkiJblF3YZSPT4EFs/03I+op+NMBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gqRRKTva; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729824706; x=1761360706;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MiBw33vNZUy35DRG9WDiAdM7F4vciHQRd8BNTVBIfto=;
  b=gqRRKTvaXsySDXTEUiNFuIQ2SN/hplS9elEIGRDZM096SN7jX7ua31q6
   SSe+8EX4evTA2vpvOEteEIGVjT1mp7dQ+Thomm1ByUeVaT5ZJPUBCxpNt
   cfAfr7MC9OH5v5RQ7yyl91rqXtPhKQOVCSLKFkeQ0DxvLNo4chhNRV3Pj
   hk+m9tmlh1B0AxuOyC1wNl+Qk1mVHYxsTfC78lZ47URQA6I8CHbJv/MOk
   awRV8281tUzJOddk8u5fH6lSxx2Qq6c8xs8I5V/WHsHWjUIw+UwyZrc+P
   MzdJzyiKtKKnYEPvnfxRGufSJGDOCu8hGOXfSv6As31faW43T8vvgTwYB
   Q==;
X-CSE-ConnectionGUID: K1AqDgTCSB6DGQ9TT3oQBw==
X-CSE-MsgGUID: hZkrbahmQnmTuZKjqSRljg==
X-IronPort-AV: E=McAfee;i="6700,10204,11235"; a="33393422"
X-IronPort-AV: E=Sophos;i="6.11,231,1725346800"; 
   d="scan'208";a="33393422"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 19:51:45 -0700
X-CSE-ConnectionGUID: PuhtXlWOQG6yx+69Iimk/g==
X-CSE-MsgGUID: LltUe5VmT6eSUHKfnFIXnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,231,1725346800"; 
   d="scan'208";a="85893736"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.125.240.3]) ([10.125.240.3])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 19:51:39 -0700
Message-ID: <c21d02a3-4315-41f4-b873-bf28041a0d82@linux.intel.com>
Date: Fri, 25 Oct 2024 10:51:35 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 37/58] KVM: x86/pmu: Switch IA32_PERF_GLOBAL_CTRL
 at VM boundary
To: "Chen, Zide" <zide.chen@intel.com>, Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-38-mizhang@google.com>
 <5309ec1b-edc6-4e59-af88-b223dbf2a455@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <5309ec1b-edc6-4e59-af88-b223dbf2a455@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 10/25/2024 4:26 AM, Chen, Zide wrote:
>
> On 7/31/2024 9:58 PM, Mingwei Zhang wrote:
>
>> @@ -7295,6 +7299,46 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
>>  					msrs[i].host, false);
>>  }
>>  
>> +static void save_perf_global_ctrl_in_passthrough_pmu(struct vcpu_vmx *vmx)
>> +{
>> +	struct kvm_pmu *pmu = vcpu_to_pmu(&vmx->vcpu);
>> +	int i;
>> +
>> +	if (vm_exit_controls_get(vmx) & VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL) {
>> +		pmu->global_ctrl = vmcs_read64(GUEST_IA32_PERF_GLOBAL_CTRL);
> As commented in patch 26, compared with MSR auto save/store area
> approach, the exec control way needs one relatively expensive VMCS read
> on every VM exit.

Anyway, let us have a evaluation and data speaks.


>
>> +	} else {
>> +		i = pmu->global_ctrl_slot_in_autostore;
>> +		pmu->global_ctrl = vmx->msr_autostore.guest.val[i].value;
>> +	}
>> +}
>> +
>> +static void load_perf_global_ctrl_in_passthrough_pmu(struct vcpu_vmx *vmx)
>> +{
>> +	struct kvm_pmu *pmu = vcpu_to_pmu(&vmx->vcpu);
>> +	u64 global_ctrl = pmu->global_ctrl;
>> +	int i;
>> +
>> +	if (vm_entry_controls_get(vmx) & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) {
>> +		vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL, global_ctrl);
> ditto.
>
> We may optimize it by introducing a new flag pmu->global_ctrl_dirty and
> update GUEST_IA32_PERF_GLOBAL_CTRL only when it's needed.  But this
> makes the code even more complicated.
>
>
>> +	} else {
>> +		i = pmu->global_ctrl_slot_in_autoload;
>> +		vmx->msr_autoload.guest.val[i].value = global_ctrl;
>> +	}
>> +}
>> +
>> +static void __atomic_switch_perf_msrs_in_passthrough_pmu(struct vcpu_vmx *vmx)
>> +{
>> +	load_perf_global_ctrl_in_passthrough_pmu(vmx);
>> +}
>> +
>> +static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
>> +{
>> +	if (is_passthrough_pmu_enabled(&vmx->vcpu))
>> +		__atomic_switch_perf_msrs_in_passthrough_pmu(vmx);
>> +	else
>> +		__atomic_switch_perf_msrs(vmx);
>> +}
>> +
>>  static void vmx_update_hv_timer(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>>  {
>>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>

