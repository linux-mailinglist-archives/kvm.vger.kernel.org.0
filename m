Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9166577ED93
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 01:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347079AbjHPXC0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 19:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244027AbjHPXB7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 19:01:59 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424B013E;
        Wed, 16 Aug 2023 16:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692226918; x=1723762918;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TMzGRFLgT3Kss0iJpHe4umk12YimF2amLXVvMJrJwTo=;
  b=bFj+wKD5v/EfG8edKF+ncAzieFIrBTS5pB0OCgWCEvD8w2NmAmfjWQuQ
   /XPPcf97VdP7B3oCLLh9ei6uwoyDO2jceCIDKh/VNXEN0w1A/TlW4Q1lZ
   gL7mA3+GXNdjfyrPaDL5GtNSoS5mFWzjcZ0NKcjFuYJEfhcxTwdcxEYUj
   i8++bOWXxw+2zTvXashsYEaWCGI+ZP52rBNPrz7U7HOhIAajfmCW6WJlE
   S6SlrEo9jxJIs0zGrSM8/DW0UJlWZSyljbp77zJVcXE0SB74G7SAShVE8
   4DF4qQLna3gYs+nRK6h6i43VIsxDLvX1EUAMsPGGaQnO8YxWsr8bPeikX
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="375427297"
X-IronPort-AV: E=Sophos;i="6.01,178,1684825200"; 
   d="scan'208";a="375427297"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2023 16:01:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="727915204"
X-IronPort-AV: E=Sophos;i="6.01,178,1684825200"; 
   d="scan'208";a="727915204"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga007.jf.intel.com with ESMTP; 16 Aug 2023 16:01:55 -0700
Date:   Thu, 17 Aug 2023 07:01:54 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeng Guang <guang.zeng@intel.com>,
        Yuan Yao <yuan.yao@intel.com>
Subject: Re: [PATCH v3 01/15] KVM: x86: Add a framework for enabling
 KVM-governed x86 features
Message-ID: <20230816230154.5peod5pw3unv6h62@yy-desk-7060>
References: <20230815203653.519297-1-seanjc@google.com>
 <20230815203653.519297-2-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230815203653.519297-2-seanjc@google.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 15, 2023 at 01:36:39PM -0700, Sean Christopherson wrote:
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

Reviewed-by: Yuan Yao <yuan.yao@intel.com>

> ---
>  arch/x86/include/asm/kvm_host.h  | 19 +++++++++++++
>  arch/x86/kvm/cpuid.c             |  4 +++
>  arch/x86/kvm/cpuid.h             | 46 ++++++++++++++++++++++++++++++++
>  arch/x86/kvm/governed_features.h |  9 +++++++
>  4 files changed, 78 insertions(+)
>  create mode 100644 arch/x86/kvm/governed_features.h
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 19d64f019240..60d430b4650f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -831,6 +831,25 @@ struct kvm_vcpu_arch {
>  	struct kvm_cpuid_entry2 *cpuid_entries;
>  	struct kvm_hypervisor_cpuid kvm_cpuid;
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
>  	u64 reserved_gpa_bits;
>  	int maxphyaddr;
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 5a88affb2e1a..4ba43ae008cb 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -313,6 +313,10 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	struct kvm_lapic *apic = vcpu->arch.apic;
>  	struct kvm_cpuid_entry2 *best;
>
> +	BUILD_BUG_ON(KVM_NR_GOVERNED_FEATURES > KVM_MAX_NR_GOVERNED_FEATURES);
> +	bitmap_zero(vcpu->arch.governed_features.enabled,
> +		    KVM_MAX_NR_GOVERNED_FEATURES);
> +
>  	best = kvm_find_cpuid_entry(vcpu, 1);
>  	if (best && apic) {
>  		if (cpuid_entry_has(best, X86_FEATURE_TSC_DEADLINE_TIMER))
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index b1658c0de847..284fa4704553 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -232,4 +232,50 @@ static __always_inline bool guest_pv_has(struct kvm_vcpu *vcpu,
>  	return vcpu->arch.pv_cpuid.features & (1u << kvm_feature);
>  }
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
>  #endif
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
> --
> 2.41.0.694.ge786442a9b-goog
>
