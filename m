Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B173193104
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 20:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbgCYTVS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 15:21:18 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59996 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727279AbgCYTVS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Mar 2020 15:21:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=i0aSODGDHRNy2upX8GEkL1qz+zwZHv5JQ2G0VIhBDDc=; b=OVF+Z1JpRrjRW2pVegCTeyYHmw
        diZ4PqN4jTwa8cvADdFgt3jWVffdZXBqeHGsfxrpBB0iI0dBgymzV2KetEvPtpe2WeForhSqo+FUC
        l4Zwoo6K2toQGZjUG1dMpPx7oaKNayoKf9afvxnc7PG9Z1Lku/aIv1xS4u4+jJXjU5wmfv4xbfMTO
        xNsktHMsei50OPdiSKogIDnTrEuje8giox4qDqyoxiduen9pJ2ojMj0g7cmU2Q5zLpDuqx5I6cYdF
        2s3gkDy8j0MyRntcJKjjBiEEDx4dP4J7Hp0As1KYJgopkj0EVBj9mJSodeEINS1rRAFVkf+2c45Kv
        31zWmroQ==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jHBaI-0006OL-Nz; Wed, 25 Mar 2020 19:21:02 +0000
Subject: Re: [PATCH] KVM: x86: Fix BUILD_BUG() in __cpuid_entry_get_reg() w/
 CONFIG_UBSAN=y
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200325191259.23559-1-sean.j.christopherson@intel.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <6be637a8-77d3-3fda-238c-2e992307745f@infradead.org>
Date:   Wed, 25 Mar 2020 12:21:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200325191259.23559-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/25/20 12:12 PM, Sean Christopherson wrote:
> Take the target reg in __cpuid_entry_get_reg() instead of a pointer to a
> struct cpuid_reg.  When building with -fsanitize=alignment (enabled by
> CONFIG_UBSAN=y), some versions of gcc get tripped up on the pointer and
> trigger the BUILD_BUG().
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Fixes: d8577a4c238f8 ("KVM: x86: Do host CPUID at load time to mask KVM cpu caps")
> Fixes: 4c61534aaae2a ("KVM: x86: Introduce cpuid_entry_{get,has}() accessors")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

LGTM. Thanks.

Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

> ---
>  arch/x86/kvm/cpuid.c | 2 +-
>  arch/x86/kvm/cpuid.h | 8 ++++----
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 08280d8a2ac9..16d3ae432420 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -269,7 +269,7 @@ static __always_inline void kvm_cpu_cap_mask(enum cpuid_leafs leaf, u32 mask)
>  	cpuid_count(cpuid.function, cpuid.index,
>  		    &entry.eax, &entry.ebx, &entry.ecx, &entry.edx);
>  
> -	kvm_cpu_caps[leaf] &= *__cpuid_entry_get_reg(&entry, &cpuid);
> +	kvm_cpu_caps[leaf] &= *__cpuid_entry_get_reg(&entry, cpuid.reg);
>  }
>  
>  void kvm_set_cpu_caps(void)
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index 23b4cd1ad986..63a70f6a3df3 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -99,9 +99,9 @@ static __always_inline struct cpuid_reg x86_feature_cpuid(unsigned int x86_featu
>  }
>  
>  static __always_inline u32 *__cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry,
> -						  const struct cpuid_reg *cpuid)
> +						  u32 reg)
>  {
> -	switch (cpuid->reg) {
> +	switch (reg) {
>  	case CPUID_EAX:
>  		return &entry->eax;
>  	case CPUID_EBX:
> @@ -121,7 +121,7 @@ static __always_inline u32 *cpuid_entry_get_reg(struct kvm_cpuid_entry2 *entry,
>  {
>  	const struct cpuid_reg cpuid = x86_feature_cpuid(x86_feature);
>  
> -	return __cpuid_entry_get_reg(entry, &cpuid);
> +	return __cpuid_entry_get_reg(entry, cpuid.reg);
>  }
>  
>  static __always_inline u32 cpuid_entry_get(struct kvm_cpuid_entry2 *entry,
> @@ -189,7 +189,7 @@ static __always_inline u32 *guest_cpuid_get_register(struct kvm_vcpu *vcpu,
>  	if (!entry)
>  		return NULL;
>  
> -	return __cpuid_entry_get_reg(entry, &cpuid);
> +	return __cpuid_entry_get_reg(entry, cpuid.reg);
>  }
>  
>  static __always_inline bool guest_cpuid_has(struct kvm_vcpu *vcpu,
> 


-- 
~Randy
