Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEC485E629E
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 14:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbiIVMlT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 08:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiIVMlR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 08:41:17 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5DA1E7239;
        Thu, 22 Sep 2022 05:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663850475; x=1695386475;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2XrBvsqAS2iekK6smQOUXQvJir1/aMIF8ljeQsISlsI=;
  b=gJsM8dQ+Ntn2gjkXVqqeZxDr3FFrJ01zJuWOA5p1DkQxThaXN979S1vp
   lUiH3ghias5vZVNd4ztXVK8Cr7w4PetGm98S+nKzOhOcYwBlC+LkvwwDo
   +G9nSjJEhDzdx44a/d/k+umsoAwuhBgOKH2+7Dj5RC1jAW9kkZlgPevHZ
   cFG+tkO+F90x8Ah/RMgo1XweN77N7H2wgMSSIY0b6CegEboQEOFHtncQT
   ZdAfq9aP6/Nvq5QTenjTFCRAi+sz0HqYpdvX+RWkPaA9A/tJfLMTL4sEm
   EG6Z4cIEh//DDH67nNoXgPfgsyTyy6KOjog4OA4MNK/GUg+DtBohArsvn
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="287365286"
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="287365286"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 05:41:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="688279050"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga004.fm.intel.com with ESMTP; 22 Sep 2022 05:41:15 -0700
Received: from [10.252.210.171] (kliang2-mobl1.ccr.corp.intel.com [10.252.210.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 78829580AD7;
        Thu, 22 Sep 2022 05:41:13 -0700 (PDT)
Message-ID: <e354250c-cfb6-a48d-73cd-b703f670af57@linux.intel.com>
Date:   Thu, 22 Sep 2022 08:41:12 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2 1/2] perf/x86/intel: Expose EPT-friendly PEBS for SPR
 and future models
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org
References: <20220922051929.89484-1-likexu@tencent.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <20220922051929.89484-1-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2022-09-22 1:19 a.m., Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> According to Intel SDM, the EPT-friendly PEBS is supported by all the
> platforms after ICX, ADL and the future platforms with PEBS format 5.
> 
> Currently the only in-kernel user of this capability is KVM, which has
> very limited support for hybrid core pmu, so ADL and its successors do
> not currently expose this capability. When both hybrid core and PEBS
> format 5 are present, KVM will decide on its own merits.
> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: linux-perf-users@vger.kernel.org
> Suggested-by: Kan Liang <kan.liang@linux.intel.com>
> Signed-off-by: Like Xu <likexu@tencent.com>


Reviewed-by: Kan Liang <kan.liang@linux.intel.com>

Thanks,
Kan

> ---
> V1 -> V2 Changelog:
> - the perf part should be a separate patch; (Kan)
> - apply PEBS format 5 to avoid patching every future model; (Kan)
> 
>  arch/x86/events/intel/core.c | 1 +
>  arch/x86/events/intel/ds.c   | 4 +++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
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
> diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
> index ba60427caa6d..4e937f685cdc 100644
> --- a/arch/x86/events/intel/ds.c
> +++ b/arch/x86/events/intel/ds.c
> @@ -2253,8 +2253,10 @@ void __init intel_ds_init(void)
>  			x86_pmu.large_pebs_flags |= PERF_SAMPLE_TIME;
>  			break;
>  
> -		case 4:
>  		case 5:
> +			x86_pmu.pebs_ept = 1;
> +			fallthrough;
> +		case 4:
>  			x86_pmu.drain_pebs = intel_pmu_drain_pebs_icl;
>  			x86_pmu.pebs_record_size = sizeof(struct pebs_basic);
>  			if (x86_pmu.intel_cap.pebs_baseline) {
