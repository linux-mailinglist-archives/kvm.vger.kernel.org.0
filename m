Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B35269E5A9
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 18:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234777AbjBURNW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 12:13:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234586AbjBURNU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 12:13:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89245C658
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 09:12:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676999556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=edLx7W3/VFCMaXQVPtkyXo91gMty4IjMAMHHKfDppU4=;
        b=HCR1QPWgoNwUKZXN3KV8rNOmfMTtpmeEUFju+AV87P+cADPu3ZEY54RmW+DKttDJYiWRGk
        9EH6103D2nhr4N5FEo86u2waTH74mt3SbLnGkMVUYWDGMFRvdinxucQVpK97VTeK2luCuG
        GBtdzmxvT1Zkl866J85L5T2Px+Ha3xI=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-441-y6YymkNpOrCeGj-kYyD8nA-1; Tue, 21 Feb 2023 12:12:21 -0500
X-MC-Unique: y6YymkNpOrCeGj-kYyD8nA-1
Received: by mail-qt1-f199.google.com with SMTP id g10-20020ac8070a000000b003b849aa2cd6so2014701qth.15
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 09:12:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=edLx7W3/VFCMaXQVPtkyXo91gMty4IjMAMHHKfDppU4=;
        b=bI7NQUegUO12lePpD/5HKnjiOt952nOBGqrk/MgNzx8Ny3eXpRr9vOWAWLQM8wYmQb
         c8A/wRzX6/2wHRxo2aB6xOm0zJa6MmG8s48+96IEL/XdyZJtVRMy9DvaELvVD6XlIYf6
         16rvFzZtlFXyeNKZ+GFpZdcxHMiyphic7qBprlZpshkesGu7qX2aagcwa9t7c7/o1V5I
         QHRNePiEeqmrL9FEIX9WESkaIIemSB7U7vWWoLUSSE73k0L0hoWOMXg/1V1+Ow5FM2bP
         Zsv0PDgP00FAkRR5eRkAJLUr0gZjCrRxAp7OKzrXlTtkobHBDN61D1HXlQFxnxYQDhBo
         UpaQ==
X-Gm-Message-State: AO0yUKW6xyaNTCJNKm9r4TW6jArZJFuanVyJRhgmbY1eAXRcbVUdwCNQ
        kDZCOZE6DVwNrc7GWfOqNmS/PYUp9ZtVaDk/lgzlkMg0H3m1KeqmvjzWJEnq3v5cxr6FarLvVNu
        8W7iuqe9/6plA
X-Received: by 2002:ac8:5945:0:b0:3b9:bc8c:c1f6 with SMTP id 5-20020ac85945000000b003b9bc8cc1f6mr9658899qtz.1.1676999534948;
        Tue, 21 Feb 2023 09:12:14 -0800 (PST)
X-Google-Smtp-Source: AK7set9r3Ttk9u6duwnXzToceWkAcPYXSIBUmyDX7UOiz82jmIX7qjrlNzg7U1AV9gE7opO/I3yjig==
X-Received: by 2002:ac8:5945:0:b0:3b9:bc8c:c1f6 with SMTP id 5-20020ac85945000000b003b9bc8cc1f6mr9658857qtz.1.1676999534609;
        Tue, 21 Feb 2023 09:12:14 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id cf7-20020a05622a400700b003bfa52112f9sm856400qtb.4.2023.02.21.09.12.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 09:12:14 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 01/12] KVM: x86: Add a framework for enabling
 KVM-governed x86 features
In-Reply-To: <20230217231022.816138-2-seanjc@google.com>
References: <20230217231022.816138-1-seanjc@google.com>
 <20230217231022.816138-2-seanjc@google.com>
Date:   Tue, 21 Feb 2023 18:12:11 +0100
Message-ID: <87zg973puc.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Introduce yet another X86_FEATURE flag framework to manage and cache KVM
> governed features (for lack of a better term).  "Governed" in this case
> means that KVM has some level of involvement and/or vested interest in
> whether or not an X86_FEATURE can be used by the guest.  The intent of the
> framework is twofold: to simplify caching of guest CPUID flags that KVM
> needs to frequently query, and to add clarity to such caching, e.g. it
> isn't immediately obvious that SVM's bundle of flags for "optional nested]

Nit: unneeded ']'

> SVM features" track whether or not a flag is exposed to L1.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h  | 11 +++++++
>  arch/x86/kvm/cpuid.c             |  2 ++
>  arch/x86/kvm/cpuid.h             | 51 ++++++++++++++++++++++++++++++++
>  arch/x86/kvm/governed_features.h |  9 ++++++
>  4 files changed, 73 insertions(+)
>  create mode 100644 arch/x86/kvm/governed_features.h
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 792a6037047a..cd660de02f7b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -835,6 +835,17 @@ struct kvm_vcpu_arch {
>  	struct kvm_cpuid_entry2 *cpuid_entries;
>  	struct kvm_hypervisor_cpuid kvm_cpuid;
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
> +	} governed_features;
> +
>  	u64 reserved_gpa_bits;
>  	int maxphyaddr;
>  
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 8f8edeaf8177..013fdc27fc8f 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -335,6 +335,8 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  	struct kvm_lapic *apic = vcpu->arch.apic;
>  	struct kvm_cpuid_entry2 *best;
>  
> +	vcpu->arch.governed_features.enabled = 0;
> +
>  	best = kvm_find_cpuid_entry(vcpu, 1);
>  	if (best && apic) {
>  		if (cpuid_entry_has(best, X86_FEATURE_TSC_DEADLINE_TIMER))
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index b1658c0de847..f61a2106ba90 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -232,4 +232,55 @@ static __always_inline bool guest_pv_has(struct kvm_vcpu *vcpu,
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
> +static __always_inline int kvm_is_governed_feature(unsigned int x86_feature)
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

-- 
Vitaly

