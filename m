Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3FAF6573F6
	for <lists+kvm@lfdr.de>; Wed, 28 Dec 2022 09:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232589AbiL1IcY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Dec 2022 03:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232225AbiL1IcW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Dec 2022 03:32:22 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23C4F01A
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 00:32:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672216341; x=1703752341;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=f8ghQkBm9kPwYjUdLdrzmiKewB1SDI+z4rJJ91yL1CI=;
  b=kAFQjarS49YZLH1I2tyy4S+dXlvJqAOwQxS4rBJlytgOsyPKccP7kyLr
   rLTL53JxqVIShDDtnfK3NHfhZWP+r35kCNc1+gNegMzxhHwD8iMVv3DJn
   S0hIMY6rmCOrgBqf6aEjiypz7KDam2+ZHoDOcP4R03dUeI/kj9GGcOQbo
   FuEfHFm7D2t2Lz1E1mM+ZRuA451BoUaJyMaIP7LVqnce6OnB9/UCAtGqA
   g96L49wFZN/XBfS6kLlKAet0dcbcKx+ZhN6SrdHxFh9zh8pKbidVOUeg2
   AKpA1rk+YjaxtG55gXwu38oPrgStnZN636EzF4Wtq8XN10fMjrH4kY8UB
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10573"; a="385256311"
X-IronPort-AV: E=Sophos;i="5.96,280,1665471600"; 
   d="scan'208";a="385256311"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2022 00:32:20 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10573"; a="653266429"
X-IronPort-AV: E=Sophos;i="5.96,280,1665471600"; 
   d="scan'208";a="653266429"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.255.28.140]) ([10.255.28.140])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2022 00:32:18 -0800
Message-ID: <0bcb1c11-145d-0c45-4e46-a4ed9173e3c8@linux.intel.com>
Date:   Wed, 28 Dec 2022 16:32:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 6/9] KVM: x86: Untag LAM bits when applicable
To:     Robert Hoo <robert.hu@linux.intel.com>, pbonzini@redhat.com,
        seanjc@google.com, kirill.shutemov@linux.intel.com,
        kvm@vger.kernel.org
Cc:     Jingqi Liu <jingqi.liu@intel.com>
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
 <20221209044557.1496580-7-robert.hu@linux.intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20221209044557.1496580-7-robert.hu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/9/2022 12:45 PM, Robert Hoo wrote
> +#ifdef CONFIG_X86_64
> +/* untag addr for guest, according to vCPU CR3 and CR4 settings */
> +static inline u64 kvm_untagged_addr(u64 addr, struct kvm_vcpu *vcpu)
> +{
> +	if (addr >> 63 == 0) {
> +		/* User pointers */
> +		if (kvm_read_cr3(vcpu) & X86_CR3_LAM_U57)
> +			addr = get_canonical(addr, 57);

According to the spec, LAM_U57/LAM_SUP also performs a modified 
canonicality check.

Why the check only be done for LAM_U48, but not for LAM_U57 and LAM_SUP 
cases?


> +		else if (kvm_read_cr3(vcpu) & X86_CR3_LAM_U48) {
> +			/*
> +			 * If guest enabled 5-level paging and LAM_U48,
> +			 * bit 47 should be 0, bit 48:56 contains meta data
> +			 * although bit 47:56 are valid 5-level address
> +			 * bits.
> +			 * If LAM_U48 and 4-level paging, bit47 is 0.
> +			 */
> +			WARN_ON(addr & _BITUL(47));
> +			addr = get_canonical(addr, 48);
> +		}
> +	} else if (kvm_read_cr4(vcpu) & X86_CR4_LAM_SUP) { /* Supervisor pointers */
> +		if (kvm_read_cr4(vcpu) & X86_CR4_LA57)
> +			addr = get_canonical(addr, 57);
> +		else
> +			addr = get_canonical(addr, 48);
> +	}
> +
> +	return addr;
> +}
> +#else
> +#define kvm_untagged_addr(addr, vcpu)	(addr)
> +#endif
> +
>   static inline void vcpu_cache_mmio_info(struct kvm_vcpu *vcpu,
>   					gva_t gva, gfn_t gfn, unsigned access)
>   {
