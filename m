Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19B6177B08E
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 06:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233111AbjHNEop (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 00:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232615AbjHNEoU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 00:44:20 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E58127;
        Sun, 13 Aug 2023 21:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691988259; x=1723524259;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HT9OJ2srTSbizIuh43L9Q8VOVY+V7eOwiHomdrN/r7A=;
  b=CcO2MDnWWqL38Dz+MEu7LyydQRC+WvDGCf7H21LinWlclN/0nTvENuNk
   Pwf4vnN9pRttyvIJTaEjw3pepIHrgGJzJkgrKyvceUrNHbpyDaRz7n6Tq
   IFrnFGyqaB6a28k6QAwJ82raS8knIW06N/PrSIHOpua3HtpIx9G9MB4yK
   ocaYh10JL/6Ax0bl/WX/QN1pS10AXQ5k26G0IcPBzYzPJtUH68X5Ezyms
   forY4FqDcFF4zgTu+QHH3hZnI6VRlDghrPttkBXB7zqZD+R6fRFTo5rqm
   UjyZpvhaYDr+knEOZI8NrC9HNtP7sAGv7mvftDQ/Ik3Dion0A0zGJNosW
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10801"; a="438293261"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="438293261"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2023 21:44:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10801"; a="736408851"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="736408851"
Received: from zengguan-mobl1.ccr.corp.intel.com (HELO [10.255.29.128]) ([10.255.29.128])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2023 21:44:10 -0700
Message-ID: <82ba1020-bfbe-dcab-1d8c-961f30c7bf12@intel.com>
Date:   Mon, 14 Aug 2023 12:43:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2 07/21] KVM: x86: Add a framework for enabling
 KVM-governed x86 features
To:     "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20230729011608.1065019-1-seanjc@google.com>
 <20230729011608.1065019-8-seanjc@google.com>
Content-Language: en-US
From:   Zeng Guang <guang.zeng@intel.com>
In-Reply-To: <20230729011608.1065019-8-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/29/2023 9:15 AM, Sean Christopherson wrote:
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
> index dad9331c5270..007fa8bfd634 100644
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
> index 7f4d13383cf2..ef826568c222 100644
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
> index b1658c0de847..3000fbe97678 100644
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
> +static __always_inline int kvm_is_governed_feature(unsigned int x86_feature)
> +{
> +	return kvm_governed_feature_index(x86_feature) >= 0;
> +}
> +

I think it proper to return a bool, not "int" instead.


