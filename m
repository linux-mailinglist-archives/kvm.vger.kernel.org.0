Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 739636A7B72
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 07:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbjCBGlS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 01:41:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjCBGlS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 01:41:18 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10AC139CD3
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 22:41:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677739277; x=1709275277;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+nDXjt3bFIiwiA6NEADz/in1GqA8mtha7A8WhyQxdl8=;
  b=LHEOlniDfh2HpTkQPZjDqvWg1Waju32tFOt0FoWXJIt4qGOuRTIaPZrH
   wbFNWMEVrZpNYrvedv/FHKBPpr33Rfj47gv6rFsepNuwIGPbaW65YUR9k
   uF3fkCBOZ4Gz6OF2umUInJxdU2xwI6803pFyV4XhHtWTCeAOKkitxgxKL
   g2bXfMxrN/3+RUgCBxZoFYOpREfkXaywIUHGyhiNXKM/0O01PVNaxLlRS
   DZGbtKQYNqS90y6lNSCm7Me7dOsmj7wFK1hdy6vKmJbnT7I+M9v6dhqHC
   cczJOlZ52lgj/19YHV/ldxFAeodO7O3T9FUKpO4/oCRcjuiSvT5A2YuMV
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="334663835"
X-IronPort-AV: E=Sophos;i="5.98,226,1673942400"; 
   d="scan'208";a="334663835"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 22:41:16 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="798713223"
X-IronPort-AV: E=Sophos;i="5.98,226,1673942400"; 
   d="scan'208";a="798713223"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.8.132]) ([10.238.8.132])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 22:41:15 -0800
Message-ID: <79b1563b-71e3-3a3d-0812-76cca32fc7b3@linux.intel.com>
Date:   Thu, 2 Mar 2023 14:41:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v5 4/5] KVM: x86: emulation: Apply LAM mask when emulating
 data access in 64-bit mode
To:     Robert Hoo <robert.hu@linux.intel.com>, seanjc@google.com,
        pbonzini@redhat.com, chao.gao@intel.com
Cc:     kvm@vger.kernel.org
References: <20230227084547.404871-1-robert.hu@linux.intel.com>
 <20230227084547.404871-5-robert.hu@linux.intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230227084547.404871-5-robert.hu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/27/2023 4:45 PM, Robert Hoo wrote:
> Emulate HW LAM masking when doing data access under 64-bit mode.
>
> kvm_lam_untag_addr() implements this: per CR4/CR3 LAM bits configuration,
> firstly check the linear addr conforms LAM canonical, i.e. the highest
> address bit matches bit 63. Then mask out meta data per LAM configuration.
> If failed in above process, emulate #GP to guest.
>
> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> ---
>   arch/x86/kvm/emulate.c | 13 ++++++++
>   arch/x86/kvm/x86.h     | 70 ++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 83 insertions(+)
>
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 5cc3efa0e21c..77bd13f40711 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -700,6 +700,19 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
>   	*max_size = 0;
>   	switch (mode) {
>   	case X86EMUL_MODE_PROT64:
> +		/* LAM applies only on data access */
> +		if (!fetch && guest_cpuid_has(ctxt->vcpu, X86_FEATURE_LAM)) {
> +			enum lam_type type;
> +
> +			type = kvm_vcpu_lam_type(la, ctxt->vcpu);
> +			if (type == LAM_ILLEGAL) {
> +				*linear = la;
> +				goto bad;
> +			} else {
> +				la = kvm_lam_untag_addr(la, type);
> +			}
> +		}
> +

__linearize is not the only path the modified LAM canonical check 
needed, also some vmexits path should be taken care of, like VMX, SGX 
ENCLS.

Also the instruction INVLPG, INVPCID should have some special handling 
since LAM is not applied to the memory operand of the two instruction 
according to the LAM spec.


>   		*linear = la;
>   		va_bits = ctxt_virt_addr_bits(ctxt);
>   		if (!__is_canonical_address(la, va_bits))
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 6b6bfddc84e0..d992e5220602 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -201,6 +201,76 @@ static inline bool is_noncanonical_address(u64 la, struct kvm_vcpu *vcpu)
>   	return !__is_canonical_address(la, vcpu_virt_addr_bits(vcpu));
>   }
>   
> +enum lam_type {
> +	LAM_ILLEGAL = -1,
> +	LAM_U57,
> +	LAM_U48,
> +	LAM_S57,
> +	LAM_S48,
> +	LAM_NONE
> +};
> +
> +#ifdef CONFIG_X86_64
> +/*
> + * LAM Canonical Rule:
> + * LAM_U/S48 -- bit 63 == bit 47
> + * LAM_U/S57 -- bit 63 == bit 56

The modified LAM canonical check for LAM_U57 + 4-level paging is: bit 
63, bit 56:47 should be all 0s.


> + */
> +static inline bool lam_canonical(u64 addr, int effect_width)
> +{
> +	return (addr >> 63) == ((addr >> effect_width) & BIT(0));
> +}
> +
> +static inline enum lam_type kvm_vcpu_lam_type(u64 addr, struct kvm_vcpu *vcpu)
> +{
> +	WARN_ON_ONCE(!is_64_bit_mode(vcpu));
> +
> +	if (addr >> 63 == 0) {
> +		if (kvm_read_cr3(vcpu) & X86_CR3_LAM_U57)
> +			return lam_canonical(addr, 56) ?  LAM_U57 : LAM_ILLEGAL;
> +		else if (kvm_read_cr3(vcpu) & X86_CR3_LAM_U48)
> +			return lam_canonical(addr, 47) ?  LAM_U48 : LAM_ILLEGAL;
> +	} else if (kvm_read_cr4_bits(vcpu, X86_CR4_LAM_SUP)) {
> +		if (kvm_read_cr4_bits(vcpu, X86_CR4_LA57))
> +			return lam_canonical(addr, 56) ?  LAM_S57 : LAM_ILLEGAL;
> +		else
> +			return lam_canonical(addr, 47) ?  LAM_S48 : LAM_ILLEGAL;
> +	}
> +
> +	return LAM_NONE;
> +}
> +
> +/* untag addr for guest, according to vCPU's LAM config */
> +static inline u64 kvm_lam_untag_addr(u64 addr, enum lam_type type)
> +{
> +	switch (type) {
> +	case LAM_U57:
> +	case LAM_S57:
> +		addr = __canonical_address(addr, 57);
> +		break;
> +	case LAM_U48:
> +	case LAM_S48:
> +		addr = __canonical_address(addr, 48);
> +		break;
> +	case LAM_NONE:
> +	default:
> +		break;
> +	}
> +
> +	return addr;
> +}
> +#else
> +static inline enum lam_type kvm_vcpu_lam_type(u64 addr, struct kvm_vcpu *vcpu)
> +{
> +	return LAM_NONE;
> +}
> +
> +static inline u64 kvm_lam_untag_addr(u64 addr, enum lam_type type)
> +{
> +	return addr;
> +}
> +#endif
> +
>   static inline void vcpu_cache_mmio_info(struct kvm_vcpu *vcpu,
>   					gva_t gva, gfn_t gfn, unsigned access)
>   {
