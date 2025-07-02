Return-Path: <kvm+bounces-51250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62C4CAF0966
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 05:48:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C44C426D96
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 03:47:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 928AC1D7E41;
	Wed,  2 Jul 2025 03:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V5jURP7q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4EC2629D
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 03:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751428085; cv=none; b=eEEyz8iauyn4ktaNH37IFIkUZipezgD+2gFn51a4CjU9QClsyIgOBZ40dyL+AhAXG6VTwNcsKWWtKk3nczFBpi+QYa9jK5ErSkvYeCh3oAn9Dg1L0hEvi4WFFr4rIx5mMovYwpXCchuEjHbZBqAfXf04UL7gahefmuAeNdXuP7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751428085; c=relaxed/simple;
	bh=dUJSWas4bJCDz+3vCVgh4blko/WfxGUXU9eqB5oU+gI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W6gW3MYsrJPJ5NlxSpjolouIGI7/DxNi/N3ydTRX5tfeGDVJYNmaS8uL6L1imf5xPvH4ELVtP7aRANaWcr0c9Qnb1cLHBV86mn2VLjNyEvf7hBanxqgleJPNJdYsl+Aer1pvalDEqst6uOvFrrzH1RyRH6dARGdMuC9qBqdpZak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V5jURP7q; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751428084; x=1782964084;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dUJSWas4bJCDz+3vCVgh4blko/WfxGUXU9eqB5oU+gI=;
  b=V5jURP7q+PjQ/RslUgyu1CZc8Us/eI3mvhVXq1fOh87LmWL0Kbx2YLrK
   2xZi5sJgH5y1WhkCPtgDM2MwI5VZCJXS9akzK6/31RZO+G+BQXB3jL5ya
   352FDKDsdI9AtGGZjAap9gJkFM+606eLHn9+SK0Eqv3mUslhVWZTPQuq5
   Stue9cEx1h/rFZhQxsn/9LUpW0kN1lOlfnl2pqCJU+8YgZyl3t0XI2Jf7
   TKcTlVeR5Ld+pVPjEbLz8FqYCz3L9Z4uGx3IWmfkoQajmPXUS/9xRn/hm
   lDzO0V+kSqDTqX5Z+FBP/jFo++iz6Nug6Uvlj3UboUnRA7tTyUIWdw7aA
   A==;
X-CSE-ConnectionGUID: Wsnptef6SaKdgotQkCyqAQ==
X-CSE-MsgGUID: AV0lzvd8QOy47ci+VHC2pQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="57518069"
X-IronPort-AV: E=Sophos;i="6.16,280,1744095600"; 
   d="scan'208";a="57518069"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 20:48:03 -0700
X-CSE-ConnectionGUID: ypFfP/t6Q6ywZOmI6/widQ==
X-CSE-MsgGUID: Ragv6DtvRdGCKD68XPdxuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,280,1744095600"; 
   d="scan'208";a="153578290"
Received: from jiatingt-mobl.ccr.corp.intel.com (HELO [10.124.240.80]) ([10.124.240.80])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 20:47:58 -0700
Message-ID: <9f75dc33-303a-4b04-a30d-cd530676108d@linux.intel.com>
Date: Wed, 2 Jul 2025 11:47:56 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/9] target/i386/kvm: set KVM_PMU_CAP_DISABLE if "-pmu"
 is configured
To: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
 sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
 like.xu.linux@gmail.com, groug@kaod.org, khorenko@virtuozzo.com,
 alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
 davydov-max@yandex-team.ru, xiaoyao.li@intel.com, joe.jin@oracle.com,
 ewanhai-oc@zhaoxin.com, ewanhai@zhaoxin.com
References: <20250624074421.40429-1-dongli.zhang@oracle.com>
 <20250624074421.40429-4-dongli.zhang@oracle.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20250624074421.40429-4-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 6/24/2025 3:43 PM, Dongli Zhang wrote:
> Although AMD PERFCORE and PerfMonV2 are removed when "-pmu" is configured,
> there is no way to fully disable KVM AMD PMU virtualization. Neither
> "-cpu host,-pmu" nor "-cpu EPYC" achieves this.
>
> As a result, the following message still appears in the VM dmesg:
>
> [    0.263615] Performance Events: AMD PMU driver.
>
> However, the expected output should be:
>
> [    0.596381] Performance Events: PMU not available due to virtualization, using software events only.
> [    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled
>
> This occurs because AMD does not use any CPUID bit to indicate PMU
> availability.
>
> To address this, KVM_CAP_PMU_CAPABILITY is used to set KVM_PMU_CAP_DISABLE
> when "-pmu" is configured.
>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> ---
> Changed since v1:
>   - Switch back to the initial implementation with "-pmu".
> https://lore.kernel.org/all/20221119122901.2469-3-dongli.zhang@oracle.com
>   - Mention that "KVM_PMU_CAP_DISABLE doesn't change the PMU behavior on
>     Intel platform because current "pmu" property works as expected."
> Changed since v2:
>   - Change has_pmu_cap to pmu_cap.
>   - Use (pmu_cap & KVM_PMU_CAP_DISABLE) instead of only pmu_cap in if
>     statement.
>   - Add Reviewed-by from Xiaoyao and Zhao as the change is minor.
> Changed since v5:
>   - Re-base on top of most recent mainline QEMU.
>   - To resolve conflicts, move the PMU related code before the
>     call site of is_tdx_vm().
>
>  target/i386/kvm/kvm.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
>
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 234878c613..15155b79b5 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -178,6 +178,8 @@ static int has_triple_fault_event;
>  
>  static bool has_msr_mcg_ext_ctl;
>  
> +static int pmu_cap;
> +
>  static struct kvm_cpuid2 *cpuid_cache;
>  static struct kvm_cpuid2 *hv_cpuid_cache;
>  static struct kvm_msr_list *kvm_feature_msrs;
> @@ -2062,6 +2064,33 @@ full:
>  
>  int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
>  {
> +    static bool first = true;
> +    int ret;
> +
> +    if (first) {
> +        first = false;
> +
> +        /*
> +         * Since Linux v5.18, KVM provides a VM-level capability to easily
> +         * disable PMUs; however, QEMU has been providing PMU property per
> +         * CPU since v1.6. In order to accommodate both, have to configure
> +         * the VM-level capability here.
> +         *
> +         * KVM_PMU_CAP_DISABLE doesn't change the PMU
> +         * behavior on Intel platform because current "pmu" property works
> +         * as expected.
> +         */
> +        if ((pmu_cap & KVM_PMU_CAP_DISABLE) && !X86_CPU(cpu)->enable_pmu) {
> +            ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
> +                                    KVM_PMU_CAP_DISABLE);
> +            if (ret < 0) {
> +                error_setg_errno(errp, -ret,
> +                                 "Failed to set KVM_PMU_CAP_DISABLE");
> +                return ret;
> +            }
> +        }
> +    }
> +
>      if (is_tdx_vm()) {
>          return tdx_pre_create_vcpu(cpu, errp);
>      }
> @@ -3363,6 +3392,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>          }
>      }
>  
> +    pmu_cap = kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY);
> +
>      return 0;
>  }
>  

LGTM.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>


