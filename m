Return-Path: <kvm+bounces-29670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7DF49AF39E
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 22:27:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACB0928298A
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 20:27:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA794216A2E;
	Thu, 24 Oct 2024 20:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qv4KrfQY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FF41AF0B0;
	Thu, 24 Oct 2024 20:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729801623; cv=none; b=bk5VGdeU5967QTZ0592QFseKEJmqjfjSxp+STYoV6SsxqrNFMDBDPQooMLn+okRdiyeZTNDg/JmqXfI2xtv9t3l5qWfbL8ZPKr37P5A7GgIvsgqaWS5HgvtX/82hLsPdhGtyYrMj3uwG5zvSwF5BNJrs7z1G95UK3vGXvgcSHpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729801623; c=relaxed/simple;
	bh=/6Ts3KsHelJX+oXQb0CDYxTihMFomt9pWLuSAm03brc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UAJ6qs51gB+/Kb2RI3FraWRtjEGKfjyL4iNp9lXTSpF5CvTGgAN/Qcy5XwNSI5GkiC3XoGmhwu5kH8uUMiVbmnWQD2zyghDwQ8qBN/zt9vdL1bUFVPWiwZjXGvniNSxcHSfRw7sDAcn+4VzbJMgVsvii0EN0xzdlEhQ0tTrRU0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qv4KrfQY; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729801621; x=1761337621;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/6Ts3KsHelJX+oXQb0CDYxTihMFomt9pWLuSAm03brc=;
  b=Qv4KrfQY3kgiiCvzwAerVBSCH/d7O0efqBZmlNgl+ys//ljf+uLd4+KG
   WUXVOlnHyJmjxdBvI8tpbVJujaQuvPAnrDBZRhkaoouNRbQ1ffgHFHH5P
   3KoZexnZ5KrPU1jjRl9nUR13+t+J5uZvpXIN0T+xPlb+9qOGYQJyfByD8
   fXtPPMz4d7GaiU8Wvb2CzQXVuu8COkqa0y7raT6ICeg4KdIZGyIJK9Qt0
   48dBt8VRvaaVY+PXVhtx5j3QrIM5NcQzYjK8TJPHZhDn+AU88LyEaRj45
   +1v1JEPtIbmNcqhWe+pCQdj8+AGcy6FUL2+mfJCm1QD2uV1PcrZQp+gKB
   g==;
X-CSE-ConnectionGUID: W4o5qPWNTiyj7vTirufEJg==
X-CSE-MsgGUID: t16T1JgyQM+SRSrTklsDWw==
X-IronPort-AV: E=McAfee;i="6700,10204,11235"; a="46939444"
X-IronPort-AV: E=Sophos;i="6.11,230,1725346800"; 
   d="scan'208";a="46939444"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 13:26:59 -0700
X-CSE-ConnectionGUID: bIanuXAySd+XfOMjG28y6A==
X-CSE-MsgGUID: 82xrGNVMRMS0PZqqNTfb0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,230,1725346800"; 
   d="scan'208";a="104021867"
Received: from soc-cp83kr3.clients.intel.com (HELO [10.24.8.117]) ([10.24.8.117])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2024 13:26:58 -0700
Message-ID: <5309ec1b-edc6-4e59-af88-b223dbf2a455@intel.com>
Date: Thu, 24 Oct 2024 13:26:57 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 37/58] KVM: x86/pmu: Switch IA32_PERF_GLOBAL_CTRL
 at VM boundary
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
 <20240801045907.4010984-38-mizhang@google.com>
Content-Language: en-US
From: "Chen, Zide" <zide.chen@intel.com>
In-Reply-To: <20240801045907.4010984-38-mizhang@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/31/2024 9:58 PM, Mingwei Zhang wrote:

> @@ -7295,6 +7299,46 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
>  					msrs[i].host, false);
>  }
>  
> +static void save_perf_global_ctrl_in_passthrough_pmu(struct vcpu_vmx *vmx)
> +{
> +	struct kvm_pmu *pmu = vcpu_to_pmu(&vmx->vcpu);
> +	int i;
> +
> +	if (vm_exit_controls_get(vmx) & VM_EXIT_SAVE_IA32_PERF_GLOBAL_CTRL) {
> +		pmu->global_ctrl = vmcs_read64(GUEST_IA32_PERF_GLOBAL_CTRL);

As commented in patch 26, compared with MSR auto save/store area
approach, the exec control way needs one relatively expensive VMCS read
on every VM exit.

> +	} else {
> +		i = pmu->global_ctrl_slot_in_autostore;
> +		pmu->global_ctrl = vmx->msr_autostore.guest.val[i].value;
> +	}
> +}
> +
> +static void load_perf_global_ctrl_in_passthrough_pmu(struct vcpu_vmx *vmx)
> +{
> +	struct kvm_pmu *pmu = vcpu_to_pmu(&vmx->vcpu);
> +	u64 global_ctrl = pmu->global_ctrl;
> +	int i;
> +
> +	if (vm_entry_controls_get(vmx) & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) {
> +		vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL, global_ctrl);

ditto.

We may optimize it by introducing a new flag pmu->global_ctrl_dirty and
update GUEST_IA32_PERF_GLOBAL_CTRL only when it's needed.  But this
makes the code even more complicated.


> +	} else {
> +		i = pmu->global_ctrl_slot_in_autoload;
> +		vmx->msr_autoload.guest.val[i].value = global_ctrl;
> +	}
> +}
> +
> +static void __atomic_switch_perf_msrs_in_passthrough_pmu(struct vcpu_vmx *vmx)
> +{
> +	load_perf_global_ctrl_in_passthrough_pmu(vmx);
> +}
> +
> +static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
> +{
> +	if (is_passthrough_pmu_enabled(&vmx->vcpu))
> +		__atomic_switch_perf_msrs_in_passthrough_pmu(vmx);
> +	else
> +		__atomic_switch_perf_msrs(vmx);
> +}
> +
>  static void vmx_update_hv_timer(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);



