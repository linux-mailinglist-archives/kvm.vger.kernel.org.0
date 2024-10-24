Return-Path: <kvm+bounces-29669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D19909AF39D
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 22:27:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3CAF1C2264B
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 20:27:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE3691FBF5E;
	Thu, 24 Oct 2024 20:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JIgt6QEV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B38517623F;
	Thu, 24 Oct 2024 20:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729801621; cv=none; b=egG8SAq3OVxS03sdYC+J332LbGpmay1joyS/VrZZ3vtl29P0ex/aNiK3c0dMFZ9H9YLkzxBDLEHyzVIZtn2MDfovmA+Kf4rYIv55i63o4hymBzLGNC03spC0saw8sMPpNaNz+w4IU0aoOq4uzWGASY7MU76F2iumBEOu9s3nPIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729801621; c=relaxed/simple;
	bh=lZtWwSjaGMWAGF5DN+7xW1hCdAlUYsizrj+Iwknsrdw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=psRgV4JnCGHdJrap3hAtLXRp8DbjQtSciKWabna5peyHSU66Jz/j4sZE7iFHZ1GKvMU04yPwsbV8R8mLdTNifmejgq3Sr226IhJsmuHghQQSm8HOLTJf3iwniIXw5/r5+k7lpgSpMhodF2XcQ45YLqqs9MUVHNg277XPh6oUTJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JIgt6QEV; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729801619; x=1761337619;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lZtWwSjaGMWAGF5DN+7xW1hCdAlUYsizrj+Iwknsrdw=;
  b=JIgt6QEVcRYxRRltG+pdZdYk6n9m6EFki9i6XFXHYMMCfX6AG6QfqZQV
   PLAkuiXBz+tI3XB1Ki+LVIXsXj/K0p5xwsSbNwh9ZdO0HAsAXLpg0cs5w
   AC3oZJqdxtP4FRnti2UldON0+isOAaeDeky20RdB1eiPF2mrHS5ZSAdRb
   JPpQxxLaUG7cB6V1FfmQlR37cv918mGs9N+1l4ALrIGfDPNn/+DGKpK+B
   jqEz5+aS92EU0nwEqL8HhSYQmQrJY8W7u0krdb/RqY1Rrun1XqVJcvEoC
   f/SKBIW1m3OEc3Io21SefcBRR1WV7gI9IzkZWCHzvujnMoBENcci2u/rr
   A==;
X-CSE-ConnectionGUID: JTKBzCc7QyO8OxkO+D9kTQ==
X-CSE-MsgGUID: TXaRDZW5Rh28hdb5cxYVJQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11235"; a="46939439"
X-IronPort-AV: E=Sophos;i="6.11,230,1725346800"; 
   d="scan'208";a="46939439"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 13:26:58 -0700
X-CSE-ConnectionGUID: CYzB3RKGT6Gbf9flFSB19A==
X-CSE-MsgGUID: dTDx9JIFRdqkX+lCbSRFcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,230,1725346800"; 
   d="scan'208";a="104021857"
Received: from soc-cp83kr3.clients.intel.com (HELO [10.24.8.117]) ([10.24.8.117])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 13:26:56 -0700
Message-ID: <6624e013-7bb5-4ae3-b11a-8c883cf2c77f@intel.com>
Date: Thu, 24 Oct 2024 13:26:55 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 26/58] KVM: x86/pmu: Manage MSR interception for
 IA32_PERF_GLOBAL_CTRL
To: Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla
 <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-27-mizhang@google.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <20240801045907.4010984-27-mizhang@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/31/2024 9:58 PM, Mingwei Zhang wrote:

> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 339742350b7a..34a420fa98c5 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4394,6 +4394,97 @@ static u32 vmx_pin_based_exec_ctrl(struct vcpu_vmx *vmx)
>  	return pin_based_exec_ctrl;
>  }
>  
> +static void vmx_set_perf_global_ctrl(struct vcpu_vmx *vmx)
> +{
> +	u32 vmentry_ctrl = vm_entry_controls_get(vmx);
> +	u32 vmexit_ctrl = vm_exit_controls_get(vmx);
> +	struct vmx_msrs *m;
> +	int i;
> +
> +	if (cpu_has_perf_global_ctrl_bug() ||
> +	    !is_passthrough_pmu_enabled(&vmx->vcpu)) {
> +		vmentry_ctrl &= ~VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
> +		vmexit_ctrl &= ~VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL;
> +		vmexit_ctrl &= ~VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL;
> +	}
> +
> +	if (is_passthrough_pmu_enabled(&vmx->vcpu)) {
> +		/*
> +		 * Setup auto restore guest PERF_GLOBAL_CTRL MSR at vm entry.
> +		 */
> +		if (vmentry_ctrl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) {
> +			vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL, 0);

To save and restore Global Ctrl MSR at VMX transitions, I'm wondering if
there are particular reasons why we prefer VMCS exec control over
VMX-transition MSR areas? If no, I'd suggest to use the MSR area
approach only for two reasons:

1. Simpler code. In this patch set, in total it takes ~100 LOC to handle
the switch of this MSR.
2. With exec ctr approach, it needs one expensive VMCS read instruction
to save guest Global Ctrl on every VM exit and one VMCS write in VM
entry. (covered in patch 37)


> +		} else {
> +			m = &vmx->msr_autoload.guest;
> +			i = vmx_find_loadstore_msr_slot(m, MSR_CORE_PERF_GLOBAL_CTRL);
> +			if (i < 0) {
> +				i = m->nr++;
> +				vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, m->nr);
> +			}
> +			m->val[i].index = MSR_CORE_PERF_GLOBAL_CTRL;
> +			m->val[i].value = 0;
> +		}
> +		/*
> +		 * Setup auto clear host PERF_GLOBAL_CTRL msr at vm exit.
> +		 */
> +		if (vmexit_ctrl & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL) {
> +			vmcs_write64(HOST_IA32_PERF_GLOBAL_CTRL, 0);

ditto.

> +		} else {
> +			m = &vmx->msr_autoload.host;
> +			i = vmx_find_loadstore_msr_slot(m, MSR_CORE_PERF_GLOBAL_CTRL);
> +			if (i < 0) {
> +				i = m->nr++;
> +				vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, m->nr);
> +			}
> +			m->val[i].index = MSR_CORE_PERF_GLOBAL_CTRL;
> +			m->val[i].value = 0;
> +		}
> +		/*
> +		 * Setup auto save guest PERF_GLOBAL_CTRL msr at vm exit
> +		 */
> +		if (!(vmexit_ctrl & VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL)) {
> +			m = &vmx->msr_autostore.guest;
> +			i = vmx_find_loadstore_msr_slot(m, MSR_CORE_PERF_GLOBAL_CTRL);
> +			if (i < 0) {
> +				i = m->nr++;
> +				vmcs_write32(VM_EXIT_MSR_STORE_COUNT, m->nr);
> +			}
> +			m->val[i].index = MSR_CORE_PERF_GLOBAL_CTRL;
> +		}
> +	} else {
> +		if (!(vmentry_ctrl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)) {
> +			m = &vmx->msr_autoload.guest;
> +			i = vmx_find_loadstore_msr_slot(m, MSR_CORE_PERF_GLOBAL_CTRL);
> +			if (i >= 0) {
> +				m->nr--;
> +				m->val[i] = m->val[m->nr];
> +				vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, m->nr);
> +			}
> +		}
> +		if (!(vmexit_ctrl & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)) {
> +			m = &vmx->msr_autoload.host;
> +			i = vmx_find_loadstore_msr_slot(m, MSR_CORE_PERF_GLOBAL_CTRL);
> +			if (i >= 0) {
> +				m->nr--;
> +				m->val[i] = m->val[m->nr];
> +				vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, m->nr);
> +			}
> +		}
> +		if (!(vmexit_ctrl & VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL)) {
> +			m = &vmx->msr_autostore.guest;
> +			i = vmx_find_loadstore_msr_slot(m, MSR_CORE_PERF_GLOBAL_CTRL);
> +			if (i >= 0) {
> +				m->nr--;
> +				m->val[i] = m->val[m->nr];
> +				vmcs_write32(VM_EXIT_MSR_STORE_COUNT, m->nr);
> +			}
> +		}
> +	}
> +
> +	vm_entry_controls_set(vmx, vmentry_ctrl);
> +	vm_exit_controls_set(vmx, vmexit_ctrl);
> +}
> +
>  static u32 vmx_vmentry_ctrl(void)
>  {
>  	u32 vmentry_ctrl = vmcs_config.vmentry_ctrl;



