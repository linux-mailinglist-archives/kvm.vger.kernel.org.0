Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F58151DBB8
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 17:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442715AbiEFPRM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 11:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347956AbiEFPRK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 11:17:10 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF8E6D1AA;
        Fri,  6 May 2022 08:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651850007; x=1683386007;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=puX4EKZE6D8sSmtW6hKpKI+ksKjdRXgah3n7yK57/TI=;
  b=hm9J9MP235O+qAx6Cby7L2E3M7SDrYYzxOhGV1XVc413wRH5GSLZTHBz
   uasArLZ6sjzfTfjvpDteWPYtKS4ji1kJbyEgDFgdHwHcZpw3qATW6WipR
   LBpJwL2y7OxggjJMfSNupKOb5MkDRz2EwPItk82QMDzaWJ0RkvTcDjWpP
   M6UspvVPB4IHGVCeha2806v1ObEcXjY43RJjhILpjyifaptmhXNW6wcyj
   5dYNkaLDIifGwODKkFLzHRaV8Yg0QUR62/D5aLCP8Rm+dWttoVwDCnaeX
   NG+9CDNFCiWKliXPFu8Dq8P+CnBjXPsWYL4GipmW9QgUjeGCfzb0HFgRT
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="248396223"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="248396223"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 08:13:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="563854822"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga007.jf.intel.com with ESMTP; 06 May 2022 08:13:26 -0700
Received: from [10.252.212.236] (kliang2-MOBL.ccr.corp.intel.com [10.252.212.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 7FF3E58093E;
        Fri,  6 May 2022 08:13:25 -0700 (PDT)
Message-ID: <5189de02-46bd-f315-fadb-4127e4fee412@linux.intel.com>
Date:   Fri, 6 May 2022 11:13:24 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v11 16/16] KVM: x86/cpuid: Advertise Arch LBR feature in
 CPUID
Content-Language: en-US
To:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        jmattson@google.com, seanjc@google.com, like.xu.linux@gmail.com,
        vkuznets@redhat.com, wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220506033305.5135-1-weijiang.yang@intel.com>
 <20220506033305.5135-17-weijiang.yang@intel.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <20220506033305.5135-17-weijiang.yang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/5/2022 11:33 PM, Yang Weijiang wrote:
> Add Arch LBR feature bit in CPU cap-mask to expose the feature.
> Only max LBR depth is supported for guest, and it's consistent
> with host Arch LBR settings.
> 
> Co-developed-by: Like Xu <like.xu@linux.intel.com>
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>

Reviewed-by: Kan Liang <kan.liang@linux.intel.com>

> ---
>   arch/x86/kvm/cpuid.c | 33 ++++++++++++++++++++++++++++++++-
>   1 file changed, 32 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 63870f78ed16..be4eb4e5e1fc 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -102,6 +102,16 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
>   		if (vaddr_bits != 48 && vaddr_bits != 57 && vaddr_bits != 0)
>   			return -EINVAL;
>   	}
> +	best = cpuid_entry2_find(entries, nent, 0x1c, 0);
> +	if (best) {
> +		unsigned int eax, ebx, ecx, edx;
> +
> +		/* Reject user-space CPUID if depth is different from host's.*/
> +		cpuid_count(0x1c, 0, &eax, &ebx, &ecx, &edx);
> +
> +		if ((best->eax & 0xff) != BIT(fls(eax & 0xff) - 1))
> +			return -EINVAL;
> +	}
>   
>   	/*
>   	 * Exposing dynamic xfeatures to the guest requires additional
> @@ -598,7 +608,7 @@ void kvm_set_cpu_caps(void)
>   		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
>   		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
>   		F(SERIALIZE) | F(TSXLDTRK) | F(AVX512_FP16) |
> -		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16)
> +		F(AMX_TILE) | F(AMX_INT8) | F(AMX_BF16) | F(ARCH_LBR)
>   	);
>   
>   	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
> @@ -1044,6 +1054,27 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   				goto out;
>   		}
>   		break;
> +	/* Architectural LBR */
> +	case 0x1c: {
> +		u32 lbr_depth_mask = entry->eax & 0xff;
> +
> +		if (!lbr_depth_mask ||
> +		    !kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR)) {
> +			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
> +			break;
> +		}
> +		/*
> +		 * KVM only exposes the maximum supported depth, which is the
> +		 * fixed value used on the host side.
> +		 * KVM doesn't allow VMM userspace to adjust LBR depth because
> +		 * guest LBR emulation depends on the configuration of host LBR
> +		 * driver.
> +		 */
> +		lbr_depth_mask = BIT((fls(lbr_depth_mask) - 1));
> +		entry->eax &= ~0xff;
> +		entry->eax |= lbr_depth_mask;
> +		break;
> +	}
>   	/* Intel AMX TILE */
>   	case 0x1d:
>   		if (!kvm_cpu_cap_has(X86_FEATURE_AMX_TILE)) {
