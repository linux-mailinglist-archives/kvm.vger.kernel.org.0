Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0CB2741E62
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 04:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbjF2CkN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 22:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbjF2CkK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 22:40:10 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B13262684;
        Wed, 28 Jun 2023 19:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688006409; x=1719542409;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NBGKY2OQl+ZXznkW7PDekHsVhcGeyx0U1jsDZsZb9fE=;
  b=DJM0ix3YIae/2NjTJ0VM/cBzisa7lO0xcHa+icgAP3AOM/eN2pcm48eW
   D845PweU/ck7YBBaEo/Kb3dRdQXhqPggvVuQlyLtiV3mCk6zQxMEpCUqp
   6u67/YnCSWrR6p31yNQguB9Z9S+rJtyYWAFCNuyvAcIUQ8XhRhNf56zl0
   dbDZb5khUTJp2gpOqp7yHRXsCoq5v+wdYJlW0sr4ENMTF5KfoXOqJ3Y/Z
   7Elj6u+iyOWSuCeNs290wFCX4TY0+EkN/lazz1QdBnBjZdcWvqKLiJf4+
   /i/N9ecTKaMYX9R1teLO4zJIFfpmkuWVKS634lC7A5U0MZGFajRJJTryO
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="351805471"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="351805471"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 19:40:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="841306371"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="841306371"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.93.25.116]) ([10.93.25.116])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 19:40:07 -0700
Message-ID: <9d9e9156-b9d9-86b4-9d20-77305e1e4d63@linux.intel.com>
Date:   Thu, 29 Jun 2023 10:40:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 01/12] KVM: x86: Add a framework for enabling KVM-governed
 x86 features
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230217231022.816138-1-seanjc@google.com>
 <20230217231022.816138-2-seanjc@google.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20230217231022.816138-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/18/2023 7:10 AM, Sean Christopherson wrote:
> Introduce yet another X86_FEATURE flag framework to manage and cache KVM
> governed features (for lack of a better term).  "Governed" in this case
> means that KVM has some level of involvement and/or vested interest in
> whether or not an X86_FEATURE can be used by the guest.  The intent of the
> framework is twofold: to simplify caching of guest CPUID flags that KVM
> needs to frequently query, and to add clarity to such caching, e.g. it
> isn't immediately obvious that SVM's bundle of flags for "optional nested]
spare ]

> SVM features" track whether or not a flag is exposed to L1.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h  | 11 +++++++
>   arch/x86/kvm/cpuid.c             |  2 ++
>   arch/x86/kvm/cpuid.h             | 51 ++++++++++++++++++++++++++++++++
>   arch/x86/kvm/governed_features.h |  9 ++++++
>   4 files changed, 73 insertions(+)
>   create mode 100644 arch/x86/kvm/governed_features.h
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 792a6037047a..cd660de02f7b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -835,6 +835,17 @@ struct kvm_vcpu_arch {
>   	struct kvm_cpuid_entry2 *cpuid_entries;
>   	struct kvm_hypervisor_cpuid kvm_cpuid;
>   
> +	/*
> +	 * Track whether or not the guest is allowed to use features that are
> +	 * governed by KVM, where "governed" means KVM needs to manage state
> +	 * and/or explicitly enable the feature in hardware.  Typically, but
> +	 * not always, governed features can be used by the guest if and only
> +	 * if both KVM and userspace want to expose the feature to the guest.
> +	 */
> +	struct {
> +		u32 enabled;
Although there are some guidances/preconditions of using the framework,
is it possible that u32 will be ran out quickly after people starts to 
use the framework?

Of course, I noticed there is build  bug check on the length, it should 
be OK to increase the length when needed.

> +	} governed_features;
> +
>   	u64 reserved_gpa_bits;
>   	int maxphyaddr;
>   
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 8f8edeaf8177..013fdc27fc8f 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -335,6 +335,8 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   	struct kvm_lapic *apic = vcpu->arch.apic;
>   	struct kvm_cpuid_entry2 *best;
>   
> +	vcpu->arch.governed_features.enabled = 0;
> +
>   	best = kvm_find_cpuid_entry(vcpu, 1);
>   	if (best && apic) {
>   		if (cpuid_entry_has(best, X86_FEATURE_TSC_DEADLINE_TIMER))
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index b1658c0de847..f61a2106ba90 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -232,4 +232,55 @@ static __always_inline bool guest_pv_has(struct kvm_vcpu *vcpu,
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
> +static __always_inline int kvm_is_governed_feature(unsigned int x86_feature)
Is it better to use bool instead of int?

> +{
> +	return kvm_governed_feature_index(x86_feature) >= 0;
> +}
> +
> +static __always_inline u32 kvm_governed_feature_bit(unsigned int x86_feature)
> +{
> +	int index = kvm_governed_feature_index(x86_feature);
> +
> +	BUILD_BUG_ON(index < 0);
> +	return BIT(index);
> +}
> +
> +static __always_inline void kvm_governed_feature_set(struct kvm_vcpu *vcpu,
> +						     unsigned int x86_feature)
> +{
> +	BUILD_BUG_ON(KVM_NR_GOVERNED_FEATURES >
> +		     sizeof(vcpu->arch.governed_features.enabled) * BITS_PER_BYTE);
> +
> +	vcpu->arch.governed_features.enabled |= kvm_governed_feature_bit(x86_feature);
> +}
> +
> +static __always_inline void kvm_governed_feature_check_and_set(struct kvm_vcpu *vcpu,
> +							       unsigned int x86_feature)
> +{
> +	if (guest_cpuid_has(vcpu, x86_feature))
> +		kvm_governed_feature_set(vcpu, x86_feature);
> +}
> +
> +static __always_inline bool guest_can_use(struct kvm_vcpu *vcpu,
> +					  unsigned int x86_feature)
> +{
> +	return vcpu->arch.governed_features.enabled & kvm_governed_feature_bit(x86_feature);
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

