Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82B356EDA5E
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 04:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbjDYC5Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 22:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjDYC5P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 22:57:15 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF362FF;
        Mon, 24 Apr 2023 19:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682391433; x=1713927433;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=f7aWVlKkS9eXHxSu9F17gNO6tfeA+1r20ZI93R5Qt84=;
  b=ergmpUznI/jY1a2KS/M/Of8tnXfZ6rIBtVHMzfmf36LVQdYFr9t8reTS
   8p3cZa0jFxO9Q5wMCvXNBeFDRSuiDS5J4sS1ifJgRFeFHkT7S+mDbYiTB
   ZIuZNfalOfUPPcE4qKiGIPdrgAYyvPnL+GCmZz0lXPhuzMcQYtV+0YTw5
   ASIBlrjChKZUe1/YHseLnmwgE1FqfIDhm8y172/+xxPIB6D6bORPiK+wh
   fIQFgOArPlDYh5j5cNXnRGtW2rmsPd+IeFmHylGz7vBuuICrDRts3CWi+
   GZamY8TiD/lJvZ1wtgG5hrScRq7+fEOaQsRCbYphgwawOJQXXaRlp5KdB
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="345387524"
X-IronPort-AV: E=Sophos;i="5.99,224,1677571200"; 
   d="scan'208";a="345387524"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 19:57:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="757933698"
X-IronPort-AV: E=Sophos;i="5.99,224,1677571200"; 
   d="scan'208";a="757933698"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.34]) ([10.238.10.34])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 19:57:10 -0700
Message-ID: <bfb65678-7d47-6ff2-fbfc-0b07a0018cec@linux.intel.com>
Date:   Tue, 25 Apr 2023 10:57:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 6/6] KVM: x86: Set KVM LASS based on hardware capability
To:     Zeng Guang <guang.zeng@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Gao Chao <chao.gao@intel.com>
References: <20230420133724.11398-1-guang.zeng@intel.com>
 <20230420133724.11398-7-guang.zeng@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230420133724.11398-7-guang.zeng@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/20/2023 9:37 PM, Zeng Guang wrote:
> Host kernel may clear LASS capability in boot_cpu_data.x86_capability
Is there some option to do it?

> besides explicitly using clearcpuid parameter. That will cause guest
> not being able to manage LASS independently. So set KVM LASS directly
> based on hardware capability to eliminate the dependency.
>
> Add new helper functions to facilitate getting result of CPUID sub-leaf.
>
> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> ---
>   arch/x86/include/asm/cpuid.h | 36 ++++++++++++++++++++++++++++++++++++
>   arch/x86/kvm/cpuid.c         |  4 ++++
>   2 files changed, 40 insertions(+)
>
> diff --git a/arch/x86/include/asm/cpuid.h b/arch/x86/include/asm/cpuid.h
> index 9bee3e7bf973..a25dd00b7c0a 100644
> --- a/arch/x86/include/asm/cpuid.h
> +++ b/arch/x86/include/asm/cpuid.h
> @@ -127,6 +127,42 @@ static inline unsigned int cpuid_edx(unsigned int op)
>   	return edx;
>   }
>   
> +static inline unsigned int cpuid_count_eax(unsigned int op, int count)
> +{
> +	unsigned int eax, ebx, ecx, edx;
> +
> +	cpuid_count(op, count, &eax, &ebx, &ecx, &edx);
> +
> +	return eax;
> +}
> +
> +static inline unsigned int cpuid_count_ebx(unsigned int op, int count)
> +{
> +	unsigned int eax, ebx, ecx, edx;
> +
> +	cpuid_count(op, count, &eax, &ebx, &ecx, &edx);
> +
> +	return ebx;
> +}
> +
> +static inline unsigned int cpuid_count_ecx(unsigned int op, int count)
> +{
> +	unsigned int eax, ebx, ecx, edx;
> +
> +	cpuid_count(op, count, &eax, &ebx, &ecx, &edx);
> +
> +	return ecx;
> +}
> +
> +static inline unsigned int cpuid_count_edx(unsigned int op, int count)
> +{
> +	unsigned int eax, ebx, ecx, edx;
> +
> +	cpuid_count(op, count, &eax, &ebx, &ecx, &edx);
> +
> +	return edx;
> +}
> +
>   static __always_inline bool cpuid_function_is_indexed(u32 function)
>   {
>   	switch (function) {
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 5facb8037140..e99b99ebe1fe 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -667,6 +667,10 @@ void kvm_set_cpu_caps(void)
>   		F(AMX_FP16) | F(AVX_IFMA)
>   	);
>   
> +	/* Set LASS based on hardware capability */
> +	if (cpuid_count_eax(7, 1) & F(LASS))
> +		kvm_cpu_cap_set(X86_FEATURE_LASS);
> +
>   	kvm_cpu_cap_init_kvm_defined(CPUID_7_1_EDX,
>   		F(AVX_VNNI_INT8) | F(AVX_NE_CONVERT) | F(PREFETCHITI)
>   	);

