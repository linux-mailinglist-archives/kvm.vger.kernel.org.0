Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED2B55137B8
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 17:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348779AbiD1PIt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 11:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230392AbiD1PIr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 11:08:47 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0DD6289AF;
        Thu, 28 Apr 2022 08:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651158331; x=1682694331;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=eOK5HE/oeuSepL/hJEIhyFK1/8Mn9ZDugt6wwTOmKLM=;
  b=aXkbQ7YdroWWcv7nZf3WFKOiRtpFP+85k3uo/LASPD1y0neuifA2nx72
   SypFP8BY3n5JgEUGVXH2knFq4Tz92f2tl+pHRjiu/9uItB+FUsB+DvhFS
   iD6K9CPxHX/Ynn31vGXddVVoIp/zdhM1bjkNpUoHufLWm1+bY+fwvT6VK
   RMRZ2fKv41ZXDRlpObrBQCLEMM8hAsc5K9pRBq9xtW2hWQ2zSdeq8FoOi
   mwAlQR+2owUGc9SRJbDJH7KbJeAG1F2+jUP5cDLOtHBqHZCPFsTfp8jq6
   FFnHTaw6fcfLJNwXsO3MvyqrlZN1JXZMtiAOAoReokwg7U0fIEhLBwLco
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10330"; a="246873976"
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="246873976"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 08:05:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="651255558"
Received: from linux.intel.com ([10.54.29.200])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Apr 2022 08:05:31 -0700
Received: from [10.209.10.70] (kliang2-MOBL.ccr.corp.intel.com [10.209.10.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 2D891580689;
        Thu, 28 Apr 2022 08:05:30 -0700 (PDT)
Message-ID: <6f2107fd-4475-86c7-e410-fe02c37b0f4d@linux.intel.com>
Date:   Thu, 28 Apr 2022 11:05:29 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v10 15/16] KVM: x86: Add Arch LBR data MSR access
 interface
Content-Language: en-US
To:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        jmattson@google.com, seanjc@google.com, like.xu.linux@gmail.com,
        vkuznets@redhat.com, wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220422075509.353942-1-weijiang.yang@intel.com>
 <20220422075509.353942-16-weijiang.yang@intel.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <20220422075509.353942-16-weijiang.yang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/22/2022 3:55 AM, Yang Weijiang wrote:
> Arch LBR MSRs are xsave-supported, but they're operated as "independent"
> xsave feature by PMU code, i.e., during thread/process context switch,
> the MSRs are saved/restored with PMU specific code instead of generic
> kernel fpu XSAVES/XRSTORS operation. 

During thread/process context switch, Linux perf still uses the 
XSAVES/XRSTORS operation to save/restore the LBR MSRs.

Linux perf only manipulates these MSRs only when the xsave feature is 
not supported.

Thanks,
Kan

> When vcpu guest/host fpu state swap
> happens, Arch LBR MSRs won't be touched so access them directly.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>   arch/x86/kvm/vmx/pmu_intel.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 79eecbffa07b..5f81644c4612 100644
> --- a/arch/x86/kvm/vmx/pmu_intel.c
> +++ b/arch/x86/kvm/vmx/pmu_intel.c
> @@ -431,6 +431,11 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   	case MSR_ARCH_LBR_CTL:
>   		msr_info->data = vmcs_read64(GUEST_IA32_LBR_CTL);
>   		return 0;
> +	case MSR_ARCH_LBR_FROM_0 ... MSR_ARCH_LBR_FROM_0 + 31:
> +	case MSR_ARCH_LBR_TO_0 ... MSR_ARCH_LBR_TO_0 + 31:
> +	case MSR_ARCH_LBR_INFO_0 ... MSR_ARCH_LBR_INFO_0 + 31:
> +		rdmsrl(msr_info->index, msr_info->data);
> +		return 0;
>   	default:
>   		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>   		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
> @@ -512,6 +517,11 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		    (data & ARCH_LBR_CTL_LBREN))
>   			intel_pmu_create_guest_lbr_event(vcpu);
>   		return 0;
> +	case MSR_ARCH_LBR_FROM_0 ... MSR_ARCH_LBR_FROM_0 + 31:
> +	case MSR_ARCH_LBR_TO_0 ... MSR_ARCH_LBR_TO_0 + 31:
> +	case MSR_ARCH_LBR_INFO_0 ... MSR_ARCH_LBR_INFO_0 + 31:
> +		wrmsrl(msr_info->index, msr_info->data);
> +		return 0;
>   	default:
>   		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>   		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
