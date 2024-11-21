Return-Path: <kvm+bounces-32226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1113D9D44EC
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 01:30:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD14B1F21CF7
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 00:30:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BF025695;
	Thu, 21 Nov 2024 00:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NskmMvtP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A947D17BD3;
	Thu, 21 Nov 2024 00:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732148974; cv=none; b=XnFdMbagrf/TxyBIzrbcEtzCNhw6VtT6BkcmN7kPcxHNKRRPDlr/T6vxAw9dQrONNWF5wpAEDJWEYwqwnOGk1cDvRga7LILkiMmsTJLr85t9L8tdBCaTtDyRXkDbvDePG4HIZWHJvp1qimVf3560TtxvdQnjgRDOoVajsI+AYDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732148974; c=relaxed/simple;
	bh=phrRhgYgCfPmkDqDuEAIf3753TtnjCIAkP9aYzetgp8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xu90ojMnqm+jeIXzr2BYyFSN4/2nlyY+SpM+UfSo1M6ZHF2hFEd3aRdEebEcN/bnTK58Jdf7jNOOieJTYYnVBm+wGbPgApnpcVqQTtGeGdRC9ST5o/m6SsAszyfHls7sP+a+c2msJisHX1axeDpxr60HorkgpC+xdubE5LdWhuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NskmMvtP; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732148973; x=1763684973;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=phrRhgYgCfPmkDqDuEAIf3753TtnjCIAkP9aYzetgp8=;
  b=NskmMvtP/q2P4QJEsW9Tmu5w9/YfAlNFXgkIuHQiDaBL+uqYlXge/kYy
   nHu7/c+rQyUiAOFAFFHmqc5AP01kF+0OfRzmAV1Vi1ntL0u41dWghjYJz
   8BRtkHsL1nWgCzPCmWedx76FvZ1O+RHz/G+qgafoAkL4fWa4PIhd18wlQ
   ROHBeqLvUq8T7FsSbcgWlYdiDX2e1xkE1fIdDPdXsBaFlOsUF76FZa+d7
   ERNGyN8xeDGmbai+stA4tjiiMWTWffyWCt7NZ/XPkaq1wWIdWU3WFok+U
   n+WPSwXNDgGDH/gxO8uDmx9+iE+FtXVuiPfNTWMKQtg+iYN7a61LrfDd2
   Q==;
X-CSE-ConnectionGUID: 1ASUsqEdS0OKALaxwW06Ng==
X-CSE-MsgGUID: wLC0LNQLRO2ZouY2a5wXUg==
X-IronPort-AV: E=McAfee;i="6700,10204,11262"; a="32293309"
X-IronPort-AV: E=Sophos;i="6.12,171,1728975600"; 
   d="scan'208";a="32293309"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 16:29:32 -0800
X-CSE-ConnectionGUID: 7d46Jt0hTdSF1RtRaN8Cyg==
X-CSE-MsgGUID: 1PEeDZ/uTxWxElIk1xUjcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,171,1728975600"; 
   d="scan'208";a="94532489"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.245.128]) ([10.124.245.128])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2024 16:29:27 -0800
Message-ID: <9efddcf8-003e-46cd-b984-b71ba1f640d1@linux.intel.com>
Date: Thu, 21 Nov 2024 08:29:24 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 19/58] KVM: x86/pmu: Plumb through pass-through PMU
 to vcpu for Intel CPUs
To: Sean Christopherson <seanjc@google.com>
Cc: Mingwei Zhang <mizhang@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Xiong Zhang <xiong.y.zhang@intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla
 <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>,
 Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-20-mizhang@google.com> <ZzymmUKlPk7gHtup@google.com>
 <2ec98cd1-e96e-4f17-a615-a5eac54a7004@linux.intel.com>
 <Zz4K0VhK5_6N307s@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <Zz4K0VhK5_6N307s@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 11/21/2024 12:45 AM, Sean Christopherson wrote:
> On Wed, Nov 20, 2024, Dapeng Mi wrote:
>> On 11/19/2024 10:54 PM, Sean Christopherson wrote:
>>> On Thu, Aug 01, 2024, Mingwei Zhang wrote:
>>>> Plumb through pass-through PMU setting from kvm->arch into kvm_pmu on each
>>>> vcpu created. Note that enabling PMU is decided by VMM when it sets the
>>>> CPUID bits exposed to guest VM. So plumb through the enabling for each pmu
>>>> in intel_pmu_refresh().
>>> Why?  As with the per-VM snapshot, I see zero reason for this to exist, it's
>>> simply:
>>>
>>>   kvm->arch.enable_pmu && enable_mediated_pmu && pmu->version;
>>>
>>> And in literally every correct usage of pmu->passthrough, kvm->arch.enable_pmu
>>> and pmu->version have been checked (though implicitly), i.e. KVM can check
>>> enable_mediated_pmu and nothing else.
>> Ok, too many passthrough_pmu flags indeed confuse readers. Besides these
>> dependencies, mediated vPMU also depends on lapic_in_kernel(). We need to
>> set enable_mediated_pmu to false as well if lapic_in_kernel() returns false.
> No, just kill the entire vPMU.
>
> Also, the need for an in-kernel APIC isn't unique to the mediated PMU.  KVM simply
> drops PMIs if there's no APIC.
>
> If we're feeling lucky, we could try a breaking change like so:
>
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index fcd188cc389a..bb08155f6198 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -817,7 +817,7 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
>         pmu->pebs_data_cfg_mask = ~0ull;
>         bitmap_zero(pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX);
>  
> -       if (!vcpu->kvm->arch.enable_pmu)
> +       if (!vcpu->kvm->arch.enable_pmu || !lapic_in_kernel(vcpu))
>                 return;
>  
>         static_call(kvm_x86_pmu_refresh)(vcpu);
>
>
> If we don't want to risk breaking weird setups, we could restrict the behavior
> to the mediated PMU being enabled:
>
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index fcd188cc389a..bc9673190574 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -817,7 +817,8 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
>         pmu->pebs_data_cfg_mask = ~0ull;
>         bitmap_zero(pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX);
>  
> -       if (!vcpu->kvm->arch.enable_pmu)
> +       if (!vcpu->kvm->arch.enable_pmu ||
> +           (!lapic_in_kernel(vcpu) && enable_mediated_pmu))
>                 return;
>  
>         static_call(kvm_x86_pmu_refresh)(vcpu);

Sure. would adopt the latter one for safe. :)



