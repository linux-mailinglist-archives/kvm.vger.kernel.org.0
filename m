Return-Path: <kvm+bounces-51257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 26ACBAF0AD4
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 07:42:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 634FE1C0470C
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 05:43:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1847D1F463A;
	Wed,  2 Jul 2025 05:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gb8YhKjn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2951F237E
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 05:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751434971; cv=none; b=USLgOyhEC+NMLQwsRTgSrWF6QuaE3s4JOWi4dQacpQyvmn6vLwXd6Asg0G0KI1sXd8MJ61/zOfhQm9X08C3W8GMNlVbGsRYE8bSrWttJctBSG9UOusa/8pCaYPYdYnLYBNYmmqCBWWgP4lgqdIwqJBaniMlYD90NdLfjUStBwuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751434971; c=relaxed/simple;
	bh=JJu1pmmEn3alemdY/GcZx7/cDMvAq6dvoCyNi0CgS2Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hup0OpOasWLxVnIH+k0g15oiTbWbQLypBJBXPefcdAZXZUYKLPKey1RnIf1wsxjgX2J3DA91Pv1RzQaerSDZ26ZcEeNfxzwddYccF39VlJw7+XAZnwN4AOCgYAdLFrsUI86oBZ3MRonOLWadGwIiuOEBvg3uem1wy52mIyV/+iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gb8YhKjn; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751434969; x=1782970969;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JJu1pmmEn3alemdY/GcZx7/cDMvAq6dvoCyNi0CgS2Y=;
  b=gb8YhKjnotn7nLuoi3/FIHjMxPr+NOszcE+JXrB0lRuY0W17ePWLfSrK
   oQwY8g3f+e7JYf1QKnwHZXM24opZ6Y9OIsoEV2lVArFjC33sjJ/zZy9Dp
   gdsXWLkIomtHSDZy4cNbPSQoihsql65Z/tKXte6ZGveCbp38bv5rkHoCU
   e+cdsT85DvjzMAlLjU8JdPlCU1cJcoYrUNgNtz6s85JptAq/wr4drAT9k
   K4rGsZRISDX+DuvryThl7a2bYjIqkFSB1ivv+/K6EKeUraxwoISRh1Xwk
   47em0WI4ZKUyLXZavYYxbmS9pqi/uRiFy/se3oy8xvwRaxu5ZLD60+vNC
   A==;
X-CSE-ConnectionGUID: K1bPJIulRK6OAMir2KxPpQ==
X-CSE-MsgGUID: f5cJH0xCTYqIdOrl0Jy04A==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="41347888"
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="41347888"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 22:42:48 -0700
X-CSE-ConnectionGUID: H3MZBqqZQZ2uSfRfKb7nHQ==
X-CSE-MsgGUID: QqYDOrwuSy+jl9lKGS8glw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="153441060"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.80]) ([10.124.240.80])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 22:42:44 -0700
Message-ID: <e55fcee5-73e6-404e-834e-f5ed51e2042d@linux.intel.com>
Date: Wed, 2 Jul 2025 13:42:41 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 9/9] target/i386/kvm: don't stop Intel PMU counters
To: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
 sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
 like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
 alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
 davydov-max@yandex-team.ru, xiaoyao.li@intel.com, joe.jin@oracle.com,
 ewanhai-oc@zhaoxin.com, ewanhai@zhaoxin.com
References: <20250624074421.40429-1-dongli.zhang@oracle.com>
 <20250624074421.40429-10-dongli.zhang@oracle.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250624074421.40429-10-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/24/2025 3:43 PM, Dongli Zhang wrote:
> PMU MSRs are set by QEMU only at levels >= KVM_PUT_RESET_STATE,
> excluding runtime. Therefore, updating these MSRs without stopping events
> should be acceptable.
>
> In addition, KVM creates kernel perf events with host mode excluded
> (exclude_host = 1). While the events remain active, they don't increment
> the counter during QEMU vCPU userspace mode.
>
> Finally, The kvm_put_msrs() sets the MSRs using KVM_SET_MSRS. The x86 KVM
> processes these MSRs one by one in a loop, only saving the config and
> triggering the KVM_REQ_PMU request. This approach does not immediately stop
> the event before updating PMC. This approach is true since Linux kernel
> commit 68fb4757e867 ("KVM: x86/pmu: Defer reprogram_counter() to
> kvm_pmu_handle_event"), that is, v6.2.
>
> No Fixed tag is going to be added for the commit 0d89436786b0 ("kvm:
> migrate vPMU state"), because this isn't a bugfix.
>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> ---
> Changed since v3:
>   - Re-order reasons in commit messages.
>   - Mention KVM's commit 68fb4757e867 (v6.2).
>   - Keep Zhao's review as there isn't code change.
>
>  target/i386/kvm/kvm.c | 9 ---------
>  1 file changed, 9 deletions(-)
>
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 4bbdf996ef..207de21404 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -4186,13 +4186,6 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>          }
>  
>          if ((IS_INTEL_CPU(env) || IS_ZHAOXIN_CPU(env)) && pmu_version > 0) {
> -            if (pmu_version > 1) {
> -                /* Stop the counter.  */
> -                kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
> -                kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
> -            }
> -
> -            /* Set the counter values.  */
>              for (i = 0; i < num_pmu_fixed_counters; i++) {
>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR0 + i,
>                                    env->msr_fixed_counters[i]);
> @@ -4208,8 +4201,6 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>                                    env->msr_global_status);
>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
>                                    env->msr_global_ovf_ctrl);
> -
> -                /* Now start the PMU.  */
>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL,
>                                    env->msr_fixed_ctr_ctrl);
>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL,

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



