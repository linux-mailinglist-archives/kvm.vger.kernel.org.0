Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB2615D4E6
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 10:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgBNJor (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 04:44:47 -0500
Received: from mga05.intel.com ([192.55.52.43]:21000 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728479AbgBNJoq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 04:44:46 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Feb 2020 01:44:46 -0800
X-IronPort-AV: E=Sophos;i="5.70,440,1574150400"; 
   d="scan'208";a="227543457"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.30.123]) ([10.255.30.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 14 Feb 2020 01:44:43 -0800
Subject: Re: [PATCH 26/61] KVM: x86: Introduce cpuid_entry_{get,has}()
 accessors
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <20200201185218.24473-27-sean.j.christopherson@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <1f918bcf-d36d-f759-5796-2acb2a514888@intel.com>
Date:   Fri, 14 Feb 2020 17:44:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200201185218.24473-27-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/2/2020 2:51 AM, Sean Christopherson wrote:
> Introduce accessors to retrieve feature bits from CPUID entries and use
> the new accessors where applicable.  Using the accessors eliminates the
> need to manually specify the register to be queried at no extra cost
> (binary output is identical) and will allow adding runtime consistency
> checks on the function and index in a future patch.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>   arch/x86/kvm/cpuid.c |  9 +++++----
>   arch/x86/kvm/cpuid.h | 46 +++++++++++++++++++++++++++++++++++---------
>   2 files changed, 42 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index e3026fe638aa..3316963dad3d 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -68,7 +68,7 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
>   		best->edx |= F(APIC);
>   
>   	if (apic) {
> -		if (best->ecx & F(TSC_DEADLINE_TIMER))
> +		if (cpuid_entry_has(best, X86_FEATURE_TSC_DEADLINE_TIMER))
>   			apic->lapic_timer.timer_mode_mask = 3 << 17;
>   		else
>   			apic->lapic_timer.timer_mode_mask = 1 << 17;
> @@ -96,7 +96,8 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
>   	}
>   
>   	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
> -	if (best && (best->eax & (F(XSAVES) | F(XSAVEC))))
> +	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
> +		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
>   		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
>   
>   	/*
> @@ -155,7 +156,7 @@ static void cpuid_fix_nx_cap(struct kvm_vcpu *vcpu)
>   			break;
>   		}
>   	}
> -	if (entry && (entry->edx & F(NX)) && !is_efer_nx()) {
> +	if (entry && cpuid_entry_has(entry, X86_FEATURE_NX) && !is_efer_nx()) {
>   		entry->edx &= ~F(NX);
>   		printk(KERN_INFO "kvm: guest NX capability removed\n");
>   	}
> @@ -387,7 +388,7 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
>   		entry->ebx |= F(TSC_ADJUST);
>   
>   		entry->ecx &= kvm_cpuid_7_0_ecx_x86_features;
> -		f_la57 = entry->ecx & F(LA57);
> +		f_la57 = cpuid_entry_get(entry, X86_FEATURE_LA57);
>   		cpuid_mask(&entry->ecx, CPUID_7_ECX);
>   		/* Set LA57 based on hardware capability. */
>   		entry->ecx |= f_la57;
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index 72a79bdfed6b..64e96e4086e2 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -95,16 +95,10 @@ static __always_inline struct cpuid_reg x86_feature_cpuid(unsigned x86_feature)
>   	return reverse_cpuid[x86_leaf];
>   }
>   
> -static __always_inline u32 *guest_cpuid_get_register(struct kvm_vcpu *vcpu, unsigned x86_feature)
> +static __always_inline u32 *__cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry,
> +						  const struct cpuid_reg *cpuid)
>   {
> -	struct kvm_cpuid_entry2 *entry;
> -	const struct cpuid_reg cpuid = x86_feature_cpuid(x86_feature);
> -
> -	entry = kvm_find_cpuid_entry(vcpu, cpuid.function, cpuid.index);
> -	if (!entry)
> -		return NULL;
> -
> -	switch (cpuid.reg) {
> +	switch (cpuid->reg) {
>   	case CPUID_EAX:
>   		return &entry->eax;
>   	case CPUID_EBX:
> @@ -119,6 +113,40 @@ static __always_inline u32 *guest_cpuid_get_register(struct kvm_vcpu *vcpu, unsi
>   	}
>   }
>   
> +static __always_inline u32 *cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry,
> +						unsigned x86_feature)
> +{
> +	const struct cpuid_reg cpuid = x86_feature_cpuid(x86_feature);
> +
> +	return __cpuid_entry_get_reg(entry, &cpuid);
> +}
> +
> +static __always_inline u32 cpuid_entry_get(struct kvm_cpuid_entry2 *entry,
> +					   unsigned x86_feature)
> +{
> +	u32 *reg = cpuid_entry_get_reg(entry, x86_feature);
> +
> +	return *reg & __feature_bit(x86_feature);
> +}
> +

This helper function is unnecessary. There is only one user throughout 
this series, i.e., cpuid_entry_has() below.

And I cannot image other possible use case of it.

> +static __always_inline bool cpuid_entry_has(struct kvm_cpuid_entry2 *entry,
> +					    unsigned x86_feature)
> +{
> +	return cpuid_entry_get(entry, x86_feature);
> +}
> +
> +static __always_inline int *guest_cpuid_get_register(struct kvm_vcpu *vcpu, unsigned x86_feature)
                           ^
Should be                 u32
otherwise, previous patch will be unhappy. :)

> +{
> +	struct kvm_cpuid_entry2 *entry;
> +	const struct cpuid_reg cpuid = x86_feature_cpuid(x86_feature);
> +
> +	entry = kvm_find_cpuid_entry(vcpu, cpuid.function, cpuid.index);
> +	if (!entry)
> +		return NULL;
> +
> +	return __cpuid_entry_get_reg(entry, &cpuid);
> +}
> +
>   static __always_inline bool guest_cpuid_has(struct kvm_vcpu *vcpu, unsigned x86_feature)
>   {
>   	u32 *reg;
> 

