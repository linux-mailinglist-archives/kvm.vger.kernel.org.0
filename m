Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE78B51DBB4
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 17:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442786AbiEFPPY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 11:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236500AbiEFPPX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 11:15:23 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0DD4B413;
        Fri,  6 May 2022 08:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651849900; x=1683385900;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=L6YWQuIIM2FGNzZ5T5KGst2uxyEzMB7IDJnANo650r0=;
  b=J1p2FyM3gUWyGpsTzWJ1gK2eVIX57ialmQsWTFqXljveww2J13TDLI2g
   5r+2hBW3N1SjP2DJVdMoMqZarJRUBc6t36hxywfZsGbzaZh1PI8HfvTRW
   qwMYQbdPUA/ZFCx7G7xFqIefpgdEk79WoN4R9nxSvfK9QvwcN6nbHVUzE
   MYmnQ0s2xh4oRqCPQxTj5gbbHq9vRbY1SSU3HLd8Ag0qoAkt9UeUqMSBx
   jCJECpqVbsnaTs+hS0zCxizfaMYmhIr2r9y5iTB/RL4SynTtdJeGu12qc
   EM8UXYYG3CYUZoFZXRO42bdhur+jW522UO7mDHOtqMdlueFdwrSWkxdqz
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="293701085"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="293701085"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 08:11:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="812422765"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga006.fm.intel.com with ESMTP; 06 May 2022 08:11:40 -0700
Received: from [10.252.212.236] (kliang2-MOBL.ccr.corp.intel.com [10.252.212.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id A6C7B58093E;
        Fri,  6 May 2022 08:11:33 -0700 (PDT)
Message-ID: <6838c7ec-82c2-1e92-2210-1252f9336df0@linux.intel.com>
Date:   Fri, 6 May 2022 11:11:32 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v11 15/16] KVM: x86: Add Arch LBR data MSR access
 interface
Content-Language: en-US
To:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        jmattson@google.com, seanjc@google.com, like.xu.linux@gmail.com,
        vkuznets@redhat.com, wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220506033305.5135-1-weijiang.yang@intel.com>
 <20220506033305.5135-16-weijiang.yang@intel.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <20220506033305.5135-16-weijiang.yang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/5/2022 11:33 PM, Yang Weijiang wrote:
> Arch LBR MSRs are xsave-supported, but they're operated as "independent"
> xsave feature by PMU code, i.e., during thread/process context switch,
> the MSRs are saved/restored with perf_event_task_sched_{in|out} instead
> of generic kernel fpu switch code, i.e.,save_fpregs_to_fpstate() and
> restore_fpregs_from_fpstate(). When vcpu guest/host fpu state swap happens,
> Arch LBR MSRs are retained so they can be accessed directly.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>

Reviewed-by: Kan Liang <kan.liang@linux.intel.com>

> ---
>   arch/x86/kvm/vmx/pmu_intel.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> index 3adc8f28d142..c2eab6272b35 100644
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
