Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E488077EEFC
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 04:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347620AbjHQCMN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 22:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347671AbjHQCMB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 22:12:01 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB12270C;
        Wed, 16 Aug 2023 19:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692238320; x=1723774320;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wS3wknMSKBXUyq95XuRJ6F/EyBmJv4PgB9BUm1Gb3L8=;
  b=FO/VG4M57OXaSzrtMCKF84X8PCnUrt+CJGJd9b9+15FHJ2EiG+sZ11T2
   hkpdY9OddXcqS6fSih2VLp4if9hu2G+j9B6IhqXaJB/Q39kw8EZnk52cs
   l5SuvdqsVBn/BdPmbDE0WAEwFkQMkMVlObmFVdUQh1et2RoABfl7bIK3l
   1MdTAEj98nGWvf0iMCRjl/RQ3xz2W7xNy14wQC+j04//mvFj8lBltchsM
   7/It1pTayS2NNegiQTMcSghkQRXOh94a1a6Gj5qQMbyO1+TvktiijTjLq
   Dk8VuxXGV7t/ZIyvyi2+pa4AKQQQuh4X++T7YWA0eCbGtU62X7Qr79FLv
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="376428073"
X-IronPort-AV: E=Sophos;i="6.01,178,1684825200"; 
   d="scan'208";a="376428073"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2023 19:12:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="848713585"
X-IronPort-AV: E=Sophos;i="6.01,178,1684825200"; 
   d="scan'208";a="848713585"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.52]) ([10.238.10.52])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2023 19:11:58 -0700
Message-ID: <f2031d6c-4aab-e225-d1a3-e96970f8fbfb@linux.intel.com>
Date:   Thu, 17 Aug 2023 10:11:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v3 01/15] KVM: x86: Add a framework for enabling
 KVM-governed x86 features
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Zeng Guang <guang.zeng@intel.com>,
        Yuan Yao <yuan.yao@intel.com>
References: <20230815203653.519297-1-seanjc@google.com>
 <20230815203653.519297-2-seanjc@google.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230815203653.519297-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>


On 8/16/2023 4:36 AM, Sean Christopherson wrote:
> Introduce yet another X86_FEATURE flag framework to manage and cache KVM
> governed features (for lack of a better name).  "Governed" in this case
> means that KVM has some level of involvement and/or vested interest in
> whether or not an X86_FEATURE can be used by the guest.  The intent of the
> framework is twofold: to simplify caching of guest CPUID flags that KVM
> needs to frequently query, and to add clarity to such caching, e.g. it
> isn't immediately obvious that SVM's bundle of flags for "optional nested
> SVM features" track whether or not a flag is exposed to L1.
>
> Begrudgingly define KVM_MAX_NR_GOVERNED_FEATURES for the size of the
> bitmap to avoid exposing governed_features.h in arch/x86/include/asm/, but
> add a FIXME to call out that it can and should be cleaned up once
> "struct kvm_vcpu_arch" is no longer expose to the kernel at large.
>
> Cc: Zeng Guang <guang.zeng@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h  | 19 +++++++++++++
>   arch/x86/kvm/cpuid.c             |  4 +++
>   arch/x86/kvm/cpuid.h             | 46 ++++++++++++++++++++++++++++++++
>   arch/x86/kvm/governed_features.h |  9 +++++++
>   4 files changed, 78 insertions(+)
>   create mode 100644 arch/x86/kvm/governed_features.h
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 19d64f019240..60d430b4650f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -831,6 +831,25 @@ struct kvm_vcpu_arch {
>   	struct kvm_cpuid_entry2 *cpuid_entries;
>   	struct kvm_hypervisor_cpuid kvm_cpuid;
>   
> +	/*
> +	 * FIXME: Drop this macro and use KVM_NR_GOVERNED_FEATURES directly
> +	 * when "struct kvm_vcpu_arch" is no longer defined in an
> +	 * arch/x86/include/asm header.  The max is mostly arbitrary, i.e.
> +	 * can be increased as necessary.
> +	 */
> +#define KVM_MAX_NR_GOVERNED_FEATURES BITS_PER_LONG
> +
> +	/*
> +	 * Track whether or not the guest is allowed to use features that are
> +	 * governed by KVM, where "governed" means KVM needs to manage state
> +	 * and/or explicitly enable the feature in hardware.  Typically, but
> +	 * not always, governed features can be used by the guest if and only
> +	 * if both KVM and userspace want to expose the feature to the guest.
> +	 */
> +	struct {
> +		DECLARE_BITMAP(enabled, KVM_MAX_NR_GOVERNED_FEATURES);
> +	} governed_features;
> +
>   	u64 reserved_gpa_bits;
>   	int maxphyaddr;
>   
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 5a88affb2e1a..4ba43ae008cb 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -313,6 +313,10 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   	struct kvm_lapic *apic = vcpu->arch.apic;
>   	struct kvm_cpuid_entry2 *best;
>   
> +	BUILD_BUG_ON(KVM_NR_GOVERNED_FEATURES > KVM_MAX_NR_GOVERNED_FEATURES);
> +	bitmap_zero(vcpu->arch.governed_features.enabled,
> +		    KVM_MAX_NR_GOVERNED_FEATURES);
> +
>   	best = kvm_find_cpuid_entry(vcpu, 1);
>   	if (best && apic) {
>   		if (cpuid_entry_has(best, X86_FEATURE_TSC_DEADLINE_TIMER))
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index b1658c0de847..284fa4704553 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -232,4 +232,50 @@ static __always_inline bool guest_pv_has(struct kvm_vcpu *vcpu,
>   	return vcpu->arch.pv_cpuid.features & (1u << kvm_feature);
>   }
>   
> +enum kvm_governed_features {
> +#define KVM_GOVERNED_FEATURE(x) KVM_GOVERNED_##x,
> +#include "governed_features.h"
> +	KVM_NR_GOVERNED_FEATURES
> +};
> +
> +static __always_inline int kvm_governed_feature_index(unsigned int x86_feature)
> +{
> +	switch (x86_feature) {
> +#define KVM_GOVERNED_FEATURE(x) case x: return KVM_GOVERNED_##x;
> +#include "governed_features.h"
> +	default:
> +		return -1;
> +	}
> +}
> +
> +static __always_inline bool kvm_is_governed_feature(unsigned int x86_feature)
> +{
> +	return kvm_governed_feature_index(x86_feature) >= 0;
> +}
> +
> +static __always_inline void kvm_governed_feature_set(struct kvm_vcpu *vcpu,
> +						     unsigned int x86_feature)
> +{
> +	BUILD_BUG_ON(!kvm_is_governed_feature(x86_feature));
> +
> +	__set_bit(kvm_governed_feature_index(x86_feature),
> +		  vcpu->arch.governed_features.enabled);
> +}
> +
> +static __always_inline void kvm_governed_feature_check_and_set(struct kvm_vcpu *vcpu,
> +							       unsigned int x86_feature)
> +{
> +	if (kvm_cpu_cap_has(x86_feature) && guest_cpuid_has(vcpu, x86_feature))
> +		kvm_governed_feature_set(vcpu, x86_feature);
> +}
> +
> +static __always_inline bool guest_can_use(struct kvm_vcpu *vcpu,
> +					  unsigned int x86_feature)
> +{
> +	BUILD_BUG_ON(!kvm_is_governed_feature(x86_feature));
> +
> +	return test_bit(kvm_governed_feature_index(x86_feature),
> +			vcpu->arch.governed_features.enabled);
> +}
> +
>   #endif
> diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
> new file mode 100644
> index 000000000000..40ce8e6608cd
> --- /dev/null
> +++ b/arch/x86/kvm/governed_features.h
> @@ -0,0 +1,9 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#if !defined(KVM_GOVERNED_FEATURE) || defined(KVM_GOVERNED_X86_FEATURE)
> +BUILD_BUG()
> +#endif
> +
> +#define KVM_GOVERNED_X86_FEATURE(x) KVM_GOVERNED_FEATURE(X86_FEATURE_##x)
> +
> +#undef KVM_GOVERNED_X86_FEATURE
> +#undef KVM_GOVERNED_FEATURE

