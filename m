Return-Path: <kvm+bounces-29682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CC299AF78E
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 04:36:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0DC341F22AD8
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 02:36:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A69218A6B0;
	Fri, 25 Oct 2024 02:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e0BZkFX5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F3C225DA;
	Fri, 25 Oct 2024 02:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729823809; cv=none; b=V0mCISf8SS61yYkvMqcx9/UVeUfY61jhtCY6vawAfyGwqcyJvHlnv63jcH2M3X3MeF2LQqQGmUuU2aPUQRiBvpmtiSXl1f/o1S8KYFkAQt3PxHg5GVCRq8JdaWtC/8yQtFDZeWum5zjewLAhEURl6jP1aKGi3b5BThj3VWisZA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729823809; c=relaxed/simple;
	bh=svTrcYQKe/gJN7AL9PunWToGd+/e93QBPnvhYm4KCCQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aCgvqNHO8+9U5pV36zJsQkjofroZhlNSA6waIRPau5vDg4lMDd8fZWzbK4c+Qos9zjwskEz5N+8qSnhVDy+0dTdKj88XDhC6eUK5damQ4DOiVhAk0Gh0Am+HsNLXNYkgtOflfhdHdnuuudIi8YuvdZJtT1/4JnhwBn7IlOCejrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e0BZkFX5; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729823807; x=1761359807;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=svTrcYQKe/gJN7AL9PunWToGd+/e93QBPnvhYm4KCCQ=;
  b=e0BZkFX5nxPOp3VOBOvVTO7xwRcLU+OhghRWeyjfP7vBhFPbK8QB9cJJ
   iLuIBGyGkb9ivxcrsVunAMBvDUzNAi9EKKK+K5mVYBXP/1lq8xdsQyvOM
   lqDTN40aLQjBPDVKoKmNwswqqvc9jlwjNcXJ8Z6yjpeu4VfdyoorCjuc4
   kbQAVpAtXNec+NoMzyhwAbNA1mgFAqLk6l5iiTG+OjuRR2s8cVLT8QZAY
   fPkVaXMWY0JgyBu2gRcNaS+ZII3OFchec487WZL/faNquFYUp6u7vl4th
   T9gVNFGLSjTzkmOAb6ye/Vx5H+zhOpEQXzYwmkYyab/VXexdtlF9DT9Ke
   w==;
X-CSE-ConnectionGUID: 38VUlryYS2Cvp6ZicF6nug==
X-CSE-MsgGUID: poeiw2SsR+Cux0Tomkt5pg==
X-IronPort-AV: E=McAfee;i="6700,10204,11235"; a="46967524"
X-IronPort-AV: E=Sophos;i="6.11,231,1725346800"; 
   d="scan'208";a="46967524"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 19:36:46 -0700
X-CSE-ConnectionGUID: OgwOgPEVSWWjIc8rzb+oBw==
X-CSE-MsgGUID: HA3GH9CqQKOsqdcEw7TKUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,231,1725346800"; 
   d="scan'208";a="85374061"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.125.240.3]) ([10.125.240.3])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 19:36:42 -0700
Message-ID: <a07e97a0-3120-4c1c-ac93-ca8309bd4148@linux.intel.com>
Date: Fri, 25 Oct 2024 10:36:38 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 26/58] KVM: x86/pmu: Manage MSR interception for
 IA32_PERF_GLOBAL_CTRL
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
 <20240801045907.4010984-27-mizhang@google.com>
 <6624e013-7bb5-4ae3-b11a-8c883cf2c77f@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <6624e013-7bb5-4ae3-b11a-8c883cf2c77f@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 10/25/2024 4:26 AM, Chen, Zide wrote:
>
> On 7/31/2024 9:58 PM, Mingwei Zhang wrote:
>
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 339742350b7a..34a420fa98c5 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -4394,6 +4394,97 @@ static u32 vmx_pin_based_exec_ctrl(struct vcpu_vmx *vmx)
>>  	return pin_based_exec_ctrl;
>>  }
>>  
>> +static void vmx_set_perf_global_ctrl(struct vcpu_vmx *vmx)
>> +{
>> +	u32 vmentry_ctrl = vm_entry_controls_get(vmx);
>> +	u32 vmexit_ctrl = vm_exit_controls_get(vmx);
>> +	struct vmx_msrs *m;
>> +	int i;
>> +
>> +	if (cpu_has_perf_global_ctrl_bug() ||
>> +	    !is_passthrough_pmu_enabled(&vmx->vcpu)) {
>> +		vmentry_ctrl &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
>> +		vmexit_ctrl &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
>> +		vmexit_ctrl &= ~VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL;
>> +	}
>> +
>> +	if (is_passthrough_pmu_enabled(&vmx->vcpu)) {
>> +		/*
>> +		 * Setup auto restore guest PERF_GLOBAL_CTRL MSR at vm entry.
>> +		 */
>> +		if (vmentry_ctrl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) {
>> +			vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL, 0);
> To save and restore Global Ctrl MSR at VMX transitions, I'm wondering if
> there are particular reasons why we prefer VMCS exec control over
> VMX-transition MSR areas? If no, I'd suggest to use the MSR area
> approach only for two reasons:
>
> 1. Simpler code. In this patch set, in total it takes ~100 LOC to handle
> the switch of this MSR.
> 2. With exec ctr approach, it needs one expensive VMCS read instruction
> to save guest Global Ctrl on every VM exit and one VMCS write in VM
> entry. (covered in patch 37)

In my opinion, there could be two reasons that we prefer to use VMCS exec
control to save/restore GLOBAL_CTRL MSR.

1. VMCS exec_control save/load is prior of MSR area save/load in
VM-Exit/VM-Entry process.

    Take VM-Exit as example, the sequence (copy from SDM Chapter 28 "VM
EXITS") is

    "

    2. Processor state is saved in the guest-state area (Section 28.3).

    3. MSRs may be saved in the VM-exit MSR-store area (Section 28.4).

    4. The following may be performed in parallel and in any order (Section
28.5):

        — Processor state is loaded based in part on the host-state area
and some VM-exit controls.

        — Address-range monitoring is cleared.

    5. MSRs may be loaded from the VM-exit MSR-load area (Section 28.6).

    "

    In our mediated vPMU implementation, we hope the guest counters are
disabled (Load 0 host global_ctrl) ASAP. That could help to avoid some race
condition issues, such as guest overflow PMI leaks into host in VM-Exit
process in theory, although we don't really observe it on Intel platforms.


2. Currently VMX save/restore the MSRs in MSR auto-load/restore area with
MSR index. As the recommendation from SDM, GLOBAL_CTRL MSR should be
enabled at last among all PMU MSRs. If there are multiple PMU MSRs in the
MSR auto-load/restore area, the restoring sequence may not meet this
requirement as GLOBAL_CTRL doesn't always have the largest MSR index. Of
course, we don't have this issue right now since current implementation
only save/restore one MSR global_ctrl with MSR auto-load/store area.


But yes, frequent vmcs_read()/vmcs_write() indeed brings some kind of
performance hit. We may need to do a performance evaluation and look at how
big the performance impact is.



>
>
>> +		} else {
>> +			m = &vmx->msr_autoload.guest;
>> +			i = vmx_find_loadstore_msr_slot(m, MSR_CORE_PERF_GLOBAL_CTRL);
>> +			if (i < 0) {
>> +				i = m->nr++;
>> +				vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, m->nr);
>> +			}
>> +			m->val[i].index = MSR_CORE_PERF_GLOBAL_CTRL;
>> +			m->val[i].value = 0;
>> +		}
>> +		/*
>> +		 * Setup auto clear host PERF_GLOBAL_CTRL msr at vm exit.
>> +		 */
>> +		if (vmexit_ctrl & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL) {
>> +			vmcs_write64(HOST_IA32_PERF_GLOBAL_CTRL, 0);
> ditto.
>
>> +		} else {
>> +			m = &vmx->msr_autoload.host;
>> +			i = vmx_find_loadstore_msr_slot(m, MSR_CORE_PERF_GLOBAL_CTRL);
>> +			if (i < 0) {
>> +				i = m->nr++;
>> +				vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, m->nr);
>> +			}
>> +			m->val[i].index = MSR_CORE_PERF_GLOBAL_CTRL;
>> +			m->val[i].value = 0;
>> +		}
>> +		/*
>> +		 * Setup auto save guest PERF_GLOBAL_CTRL msr at vm exit
>> +		 */
>> +		if (!(vmexit_ctrl & VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL)) {
>> +			m = &vmx->msr_autostore.guest;
>> +			i = vmx_find_loadstore_msr_slot(m, MSR_CORE_PERF_GLOBAL_CTRL);
>> +			if (i < 0) {
>> +				i = m->nr++;
>> +				vmcs_write32(VM_EXIT_MSR_STORE_COUNT, m->nr);
>> +			}
>> +			m->val[i].index = MSR_CORE_PERF_GLOBAL_CTRL;
>> +		}
>> +	} else {
>> +		if (!(vmentry_ctrl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)) {
>> +			m = &vmx->msr_autoload.guest;
>> +			i = vmx_find_loadstore_msr_slot(m, MSR_CORE_PERF_GLOBAL_CTRL);
>> +			if (i >= 0) {
>> +				m->nr--;
>> +				m->val[i] = m->val[m->nr];
>> +				vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, m->nr);
>> +			}
>> +		}
>> +		if (!(vmexit_ctrl & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)) {
>> +			m = &vmx->msr_autoload.host;
>> +			i = vmx_find_loadstore_msr_slot(m, MSR_CORE_PERF_GLOBAL_CTRL);
>> +			if (i >= 0) {
>> +				m->nr--;
>> +				m->val[i] = m->val[m->nr];
>> +				vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, m->nr);
>> +			}
>> +		}
>> +		if (!(vmexit_ctrl & VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL)) {
>> +			m = &vmx->msr_autostore.guest;
>> +			i = vmx_find_loadstore_msr_slot(m, MSR_CORE_PERF_GLOBAL_CTRL);
>> +			if (i >= 0) {
>> +				m->nr--;
>> +				m->val[i] = m->val[m->nr];
>> +				vmcs_write32(VM_EXIT_MSR_STORE_COUNT, m->nr);
>> +			}
>> +		}
>> +	}
>> +
>> +	vm_entry_controls_set(vmx, vmentry_ctrl);
>> +	vm_exit_controls_set(vmx, vmexit_ctrl);
>> +}
>> +
>>  static u32 vmx_vmentry_ctrl(void)
>>  {
>>  	u32 vmentry_ctrl = vmcs_config.vmentry_ctrl;
>

