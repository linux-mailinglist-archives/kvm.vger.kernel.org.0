Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD91784F64
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 05:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbjHWDlx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 23:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbjHWDlx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 23:41:53 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40470CF2;
        Tue, 22 Aug 2023 20:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692762111; x=1724298111;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mjPtcCXgRvgnCKnH7d3zDGsxkc2orDuelhXK1xkyMoM=;
  b=k5SPo/OH03ktUlsQKcEsvCnF0d5PqykoclecaO9IVPiaePC4VIp2Qt//
   emNt3IGXfr3gBVsn2bSm1l89bx60khdExrfSylvzMQ4QCPcc/tEqFfHdE
   5FRlAFyN0IBuqdcBiDYHmJ5ZkYBkiZ357K8clwpXf15TfLcSkB7paXdBJ
   fdGEfQ0sGTDrDBlXPFfY1ER3Eza8zMyp+7E0AKz365kYQSWIo17C8Pl4q
   7zyz6wxFMmcaLezPQED81kkoY05M2DomDZqMFOt47K5QjGfmnmF3Qrxbw
   BUL9ZtDPSSpMoLnoJDjxeia7c0x9uuDte93d2gh32Awpo7dw/dLWP4XuK
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10810"; a="377811120"
X-IronPort-AV: E=Sophos;i="6.01,194,1684825200"; 
   d="scan'208";a="377811120"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2023 20:41:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10810"; a="826561945"
X-IronPort-AV: E=Sophos;i="6.01,194,1684825200"; 
   d="scan'208";a="826561945"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.6.77]) ([10.93.6.77])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2023 20:41:48 -0700
Message-ID: <cf7c7ab6-0907-2eea-bf9c-0811f8ec6c59@intel.com>
Date:   Wed, 23 Aug 2023 11:41:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.14.0
Subject: Re: [PATCH] kvm: x86: emulate MSR_PLATFORM_INFO msr bits
Content-Language: en-US
To:     Hao Xiang <hao.xiang@linux.alibaba.com>, kvm@vger.kernel.org
Cc:     shannon.zhao@linux.alibaba.com, pbonzini@redhat.com,
        seanjc@google.com, linux-kernel@vger.kernel.org
References: <1692588151-33716-1-git-send-email-hao.xiang@linux.alibaba.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <1692588151-33716-1-git-send-email-hao.xiang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/21/2023 11:22 AM, Hao Xiang wrote:
> For intel platform, The BzyMhz field of Turbostat shows zero
> due to the missing of part msr bits of MSR_PLATFORM_INFO.
> 
> Acquire necessary msr bits, and expose following msr info to guest,
> to make sure guest can get correct turbo frequency info.
>
> MSR_PLATFORM_INFO bits
> bit 15:8, Maximum Non-Turbo Ratio (MAX_NON_TURBO_LIM_RATIO)
> bit 47:40, Maximum Efficiency Ratio (MAX_EFFICIENCY_RATIO)

I'm curious. How are they related to turbo frequency info?

bits 15:8, tell the Non-turbo frequency and bits 47:40 tells the min 
frequency.

> Signed-off-by: Hao Xiang <hao.xiang@linux.alibaba.com>
> ---
>   arch/x86/include/asm/msr-index.h |  4 ++++
>   arch/x86/kvm/x86.c               | 25 ++++++++++++++++++++++++-
>   2 files changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index 1d11135..1c8a276 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -68,6 +68,10 @@
>   #define MSR_PLATFORM_INFO		0x000000ce
>   #define MSR_PLATFORM_INFO_CPUID_FAULT_BIT	31
>   #define MSR_PLATFORM_INFO_CPUID_FAULT		BIT_ULL(MSR_PLATFORM_INFO_CPUID_FAULT_BIT)
> +/* MSR_PLATFORM_INFO bit 15:8, Maximum Non-Turbo Ratio (MAX_NON_TURBO_LIM_RATIO) */
> +#define MSR_PLATFORM_INFO_MAX_NON_TURBO_LIM_RATIO	0x00000000ff00
> +/* MSR_PLATFORM_INFO bit 47:40, Maximum Efficiency Ratio (MAX_EFFICIENCY_RATIO) */
> +#define MSR_PLATFORM_INFO_MAX_EFFICIENCY_RATIO		0xff0000000000

They are mask not the value, please name them with _MASK suffix.

>   
>   #define MSR_IA32_UMWAIT_CONTROL			0xe1
>   #define MSR_IA32_UMWAIT_CONTROL_C02_DISABLE	BIT(0)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c381770..621c3e1 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1679,6 +1679,29 @@ static u64 kvm_get_arch_capabilities(void)
>   	return data;
>   }
>   
> +
> +static u64 kvm_get_msr_platform_info(void)
> +{
> +	u64 msr_platform_info = 0;
> +
> +	rdmsrl_safe(MSR_PLATFORM_INFO, &msr_platform_info);
> +	/*
> +	 * MSR_PLATFORM_INFO bits:
> +	 * bit 15:8, Maximum Non-Turbo Ratio (MAX_NON_TURBO_LIM_RATIO)
> +	 * bit 31, CPUID Faulting Enabled (CPUID_FAULTING_EN)
> +	 * bit 47:40, Maximum Efficiency Ratio (MAX_EFFICIENCY_RATIO)
> +	 *
> +	 * Emulate part msr bits, expose above msr info to guest,
> +	 * to make sure guest can get correct turbo frequency info.
> +	 */
> +
> +	msr_platform_info &= (MSR_PLATFORM_INFO_MAX_NON_TURBO_RATIO |
> +			MSR_PLATFORM_INFO_MAX_EFFICIENCY_RATIO);
> +	msr_platform_info |= MSR_PLATFORM_INFO_CPUID_FAULT;
> +
> +	return msr_platform_info;
> +}
> +
>   static int kvm_get_msr_feature(struct kvm_msr_entry *msr)
>   {
>   	switch (msr->index) {
> @@ -11919,7 +11942,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>   		goto free_guest_fpu;
>   
>   	vcpu->arch.arch_capabilities = kvm_get_arch_capabilities();
> -	vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
> +	vcpu->arch.msr_platform_info = kvm_get_msr_platform_info();
>   	kvm_xen_init_vcpu(vcpu);
>   	kvm_vcpu_mtrr_init(vcpu);
>   	vcpu_load(vcpu);

