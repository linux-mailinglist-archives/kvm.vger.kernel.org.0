Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98A165BFF95
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 16:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbiIUOKy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 10:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiIUOKp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 10:10:45 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81CD296FCD;
        Wed, 21 Sep 2022 07:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663769439; x=1695305439;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=1B7Dyw77wD4eqWT6V7NIZ8Z1Kfyko1bRqXwoldD6JEY=;
  b=I8yIVKFL6tSjRIR0A8IX1Etcq/o9o2m5JqlMiBUn8GH8AAjjPUIzqie9
   y9uDLDIagUB2VGA2Gc1vQEHjxvKz2TnnGHkMLxgOt8jceEA36MBDbSWih
   5qnjwy9n8jptFNoJjy9zecNS7sHifyc4DNwgBiVauN4oUycyeFyPNKQfD
   Kk+c7qogb+OPDi/nvrwBsFUV8791Hu7BslW8vM2jYpGRdZ19e6WjnI1P7
   /N+m1d82UKg8cxz6SRXKVNMbFW1HB6Mwlyce6jhnsLxwa4WZJspvvKS/N
   Abbt7SnbvCUWogoihlA5Xh9Zs//pP3ax0lAwCDNOhwgg49blhwwfeQP8f
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="298728605"
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="298728605"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 07:10:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="621699266"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga007.fm.intel.com with ESMTP; 21 Sep 2022 07:10:38 -0700
Received: from [10.252.210.198] (kliang2-mobl1.ccr.corp.intel.com [10.252.210.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 98608580D43;
        Wed, 21 Sep 2022 07:10:37 -0700 (PDT)
Message-ID: <610fa0f0-39da-0bb2-11f5-249341e1ae7d@linux.intel.com>
Date:   Wed, 21 Sep 2022 10:10:36 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Jim Mattson <jmattson@google.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220921064827.936-1-likexu@tencent.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
Subject: Re: [PATCH] KVM: x86/pmu: Add PEBS support for Intel Sapphire Rapids
In-Reply-To: <20220921064827.936-1-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2022-09-21 2:48 a.m., Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> Virtualization support for SPR PEBS has officially available in the
> Intel SDM (June 2022) and has been validated on late stepping machines:
> 
> Compared to Ice Lake Server, the PDIR counter available (Fixed 0) on SPR
> is unchanged, but the capability is enhanced to Instruction-Accurate PDIR
> (PDIR++), where PEBS is taken on the next instruction after the one that
> caused the overflow. Also, it introduces a new Precise Distribution (PDist)
> facility that eliminates the skid when a precise event is programmed
> on general programmable counter 0.
> 
> For guest usage, KVM will raise attr.precise_ip to 3 in both cases
> mentioned above, requesting the correct hardware counter (PRIR++
> or PDist) from the perf sub-system on the host as usual.
> 
> Cc: Kan Liang <kan.liang@linux.intel.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/events/intel/core.c |  1 +
>  arch/x86/kvm/pmu.c           | 17 ++++++++++++++---
>  2 files changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> index 2db93498ff71..804540ba4599 100644
> --- a/arch/x86/events/intel/core.c
> +++ b/arch/x86/events/intel/core.c
> @@ -6288,6 +6288,7 @@ __init int intel_pmu_init(void)
>  		x86_pmu.pebs_constraints = intel_spr_pebs_event_constraints;
>  		x86_pmu.extra_regs = intel_spr_extra_regs;
>  		x86_pmu.limit_period = spr_limit_period;
> +		x86_pmu.pebs_ept = 1;
>  		x86_pmu.pebs_aliases = NULL;
>  		x86_pmu.pebs_prec_dist = true;
>  		x86_pmu.pebs_block = true;


I think the perf patch should be a separate patch.

According to the SDM, the EPT-friendly PEBS is supported by all the
platforms after ICX and ADL.

Besides the SPR, I think we should further patch the future platforms
with PEBS format 5 as below as well, to avoid patching every future model.

diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 3ece4ab54d2c..4608d5821e38 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -2333,8 +2333,10 @@ void __init intel_ds_init(void)
 			x86_pmu.large_pebs_flags |= PERF_SAMPLE_TIME;
 			break;

-		case 4:
 		case 5:
+			x86_pmu.pebs_ept = 1;
+			fallthrough;
+		case 4:
 			x86_pmu.drain_pebs = intel_pmu_drain_pebs_icl;
 			x86_pmu.pebs_record_size = sizeof(struct pebs_basic);
 			if (x86_pmu.intel_cap.pebs_baseline) {




> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index 02f9e4f245bd..81e9d7c2332d 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -28,9 +28,18 @@
>  struct x86_pmu_capability __read_mostly kvm_pmu_cap;
>  EXPORT_SYMBOL_GPL(kvm_pmu_cap);
>  
> -static const struct x86_cpu_id vmx_icl_pebs_cpu[] = {
> +/* Precise Distribution of Instructions Retired (PDIR) */
> +static const struct x86_cpu_id vmx_pebs_pdir_cpu[] = {
>  	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D, NULL),
>  	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X, NULL),
> +	/* Instruction-Accurate PDIR (PDIR++) */
> +	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X, NULL),
> +	{}
> +};
> +
> +/* Precise Distribution (PDist) */
> +static const struct x86_cpu_id vmx_pebs_pdist_cpu[] = {
> +	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X, NULL),
>  	{}
>  };
>  
> @@ -181,12 +190,14 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
>  		 * the accuracy of the PEBS profiling result, because the "event IP"
>  		 * in the PEBS record is calibrated on the guest side.
>  		 *
> -		 * On Icelake everything is fine. Other hardware (GLC+, TNT+) that
> +		 * On Icelake everything is fine. Other hardware (TNT+) that
>  		 * could possibly care here is unsupported and needs changes.
>  		 */
>  		attr.precise_ip = 1;
> -		if (x86_match_cpu(vmx_icl_pebs_cpu) && pmc->idx == 32)
> +		if ((pmc->idx == 32 && x86_match_cpu(vmx_pebs_pdir_cpu)) ||
> +		    (pmc->idx == 0 && x86_match_cpu(vmx_pebs_pdist_cpu))) {


It may be better to move the check into a function. There may be other
conditions that require the max precise level later. Something like below.
	if (need_max_precise(pmc))

Thanks,
Kan

>  			attr.precise_ip = 3;
> +		}
>  	}
>  
>  	event = perf_event_create_kernel_counter(&attr, -1, current,
