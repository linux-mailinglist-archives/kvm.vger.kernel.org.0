Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB4F51DB8E
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 17:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442679AbiEFPMB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 11:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442672AbiEFPL7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 11:11:59 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 804DC6D19F;
        Fri,  6 May 2022 08:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651849696; x=1683385696;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=7VPr9q1olrSldEIlRl6aNjcPzkn3Zixxq/VGbc7SU/c=;
  b=Mr3cFu24pNomoojvQ5QxV9/SNhx746EJyDmEpAZaXEPvsenoczxNIVAa
   7CcomufGIN8Wcmac0Z0pcz6tifvjgDP+3Ues+7xArtsj+q6uaHQYOAQu8
   OJf9q4pBX8rKDrS8CAALFB+IlVlGPAdvxA3dPL80A/AQjlF+TqMqdOZg2
   iZ9Sy9o/1ysSR4Zrr5EQ/CWYYCmv07CItxJ79lg3tFDWJ3MoXaP8VuUUd
   qsYRyC6Gf6NsuDwn5SS3G2rZDDYiuLIT2IcJ/5YGFpgiDp5Vq2c09BWTH
   ZNHk/GxHyqZFayN38K/mIdZ3c/wgB0odCKzPPAUUnU3D0o+OwN5JsV4tv
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="354924253"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="354924253"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 08:08:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="665511425"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga002.fm.intel.com with ESMTP; 06 May 2022 08:08:15 -0700
Received: from [10.252.212.236] (kliang2-MOBL.ccr.corp.intel.com [10.252.212.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id A83675808EF;
        Fri,  6 May 2022 08:08:14 -0700 (PDT)
Message-ID: <7efe455a-2ee8-8a71-f106-25119ac0a3fe@linux.intel.com>
Date:   Fri, 6 May 2022 11:08:13 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v11 13/16] KVM: x86/vmx: Clear Arch LBREn bit before
 inject #DB to guest
Content-Language: en-US
To:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        jmattson@google.com, seanjc@google.com, like.xu.linux@gmail.com,
        vkuznets@redhat.com, wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220506033305.5135-1-weijiang.yang@intel.com>
 <20220506033305.5135-14-weijiang.yang@intel.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <20220506033305.5135-14-weijiang.yang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/5/2022 11:33 PM, Yang Weijiang wrote:
> On a debug breakpoint event (#DB), IA32_LBR_CTL.LBREn is cleared.
> So need to clear the bit manually before inject #DB.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>

Reviewed-by: Kan Liang <kan.liang@linux.intel.com>

> ---
>   arch/x86/kvm/vmx/vmx.c | 27 +++++++++++++++++++++++++++
>   1 file changed, 27 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e6384ef1d115..6d6ee9cf82f5 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1605,6 +1605,27 @@ static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
>   		vmcs_write32(GUEST_ACTIVITY_STATE, GUEST_ACTIVITY_ACTIVE);
>   }
>   
> +static void flip_arch_lbr_ctl(struct kvm_vcpu *vcpu, bool on)
> +{
> +	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> +
> +	if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&
> +	    test_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use) &&
> +	    lbr_desc->event) {
> +		u64 old = vmcs_read64(GUEST_IA32_LBR_CTL);
> +		u64 new;
> +
> +		if (on)
> +			new = old | ARCH_LBR_CTL_LBREN;
> +		else
> +			new = old & ~ARCH_LBR_CTL_LBREN;
> +
> +		if (old != new)
> +			vmcs_write64(GUEST_IA32_LBR_CTL, new);
> +	}
> +}
> +
>   static void vmx_queue_exception(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
> @@ -1640,6 +1661,9 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu)
>   	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr_info);
>   
>   	vmx_clear_hlt(vcpu);
> +
> +	if (nr == DB_VECTOR)
> +		flip_arch_lbr_ctl(vcpu, false);
>   }
>   
>   static void vmx_setup_uret_msr(struct vcpu_vmx *vmx, unsigned int msr,
> @@ -4645,6 +4669,9 @@ static void vmx_inject_nmi(struct kvm_vcpu *vcpu)
>   			INTR_TYPE_NMI_INTR | INTR_INFO_VALID_MASK | NMI_VECTOR);
>   
>   	vmx_clear_hlt(vcpu);
> +
> +	if (vcpu->arch.exception.nr == DB_VECTOR)
> +		flip_arch_lbr_ctl(vcpu, false);
>   }
>   
>   bool vmx_get_nmi_mask(struct kvm_vcpu *vcpu)
