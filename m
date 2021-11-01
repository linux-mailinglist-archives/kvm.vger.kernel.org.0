Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73B384419FA
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 11:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbhKAKgD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 06:36:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44714 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232183AbhKAKf5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Nov 2021 06:35:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635762804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mh/lXvO/DjLUSeyCpSgez/WyU/AXkpH1vth0jy9+/fg=;
        b=JCDS9HOsqqUfqgICCW0+V2rH5YqqW2u0KwtnJbRi5ggUB8SygzGdG6N9FsS4iI3gd8FNiD
        b+DEhbivgiqoVbXpp7qUsFqkOU6Jx5MS6vcQJ6BVf940bboI2MBzjYUlChxZKe8ritp292
        /1pd2pgLHIndacXaeaR02hlDGbvvPQo=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602-JST4sEUhMT6Xilmg3FPA-A-1; Mon, 01 Nov 2021 06:33:21 -0400
X-MC-Unique: JST4sEUhMT6Xilmg3FPA-A-1
Received: by mail-ed1-f71.google.com with SMTP id z1-20020a05640235c100b003e28c89743bso2189647edc.22
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 03:33:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=mh/lXvO/DjLUSeyCpSgez/WyU/AXkpH1vth0jy9+/fg=;
        b=g1/oRaVcGxOwjzF8S/YDgeQpyO4A6dHQStQFOlVGaap1F8v8Z7wYbg/v7GB0dkuDQU
         ezP/cqDVlqSteHkleYS7uZV1eVXzFIUZEnGmqiFvNmVQ616i46VWUAtSOS1nsI8dPXTM
         eZ9B9vDZdHXUTI+WrIUKUhlTJhkyi8YfsZco319PRQ1PftSDwpY38jN7U5N7iDxrVQK5
         csj9nOJ3o85dUHgL7DkEU9vkq/Au28f9Gi7jPEf9P0mZgyN25LsbZQmPH3bsddne9sJP
         0YP4KusKJZC3r0+c1EwoPyN570WEBLQkyR93v5bjuHYS+PvH7zKi8BHwWmlYESD/2kmT
         OTdg==
X-Gm-Message-State: AOAM533ZGOxxB+S9PLViTfpSvUMwr2R/MfHDuF24pibRzeLiekDXfycN
        UNtBmcrZm6bmpluw4eOyqhG7Gl8EPQEB8QlsMgmNBeb3ZNB+8ddD3sJzMLlz/yVADIwxQSnfn3d
        9lBbLGLrqaRN4
X-Received: by 2002:a50:8e05:: with SMTP id 5mr39702751edw.76.1635762800379;
        Mon, 01 Nov 2021 03:33:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw9gnk66lzzUHLALthwE3raOdlZGF410uhbCdfiSGqNONoUSpPMJi4RKxjukoAv0gSOLjBOOg==
X-Received: by 2002:a50:8e05:: with SMTP id 5mr39702727edw.76.1635762800215;
        Mon, 01 Nov 2021 03:33:20 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id q17sm6607866ejp.106.2021.11.01.03.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 03:33:19 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ajay Garg <ajaygargnsit@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 8/8] KVM: x86: Add checks for reserved-to-zero
 Hyper-V hypercall fields
In-Reply-To: <20211030000800.3065132-9-seanjc@google.com>
References: <20211030000800.3065132-1-seanjc@google.com>
 <20211030000800.3065132-9-seanjc@google.com>
Date:   Mon, 01 Nov 2021 11:33:18 +0100
Message-ID: <87v91cjhch.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Add checks for the three fields in Hyper-V's hypercall params that must
> be zero.  Per the TLFS, HV_STATUS_INVALID_HYPERCALL_INPUT is returned if
> "A reserved bit in the specified hypercall input value is non-zero."
>
> Note, the TLFS has an off-by-one bug for the last reserved field, which
> it defines as being bits 64:60.  The same section states "The input field
> 64-bit value called a hypercall input value.", i.e. bit 64 doesn't
> exist.

This version are you looking at? I can't see this issue in 6.0b

>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/hyperv.c             | 5 +++++
>  include/asm-generic/hyperv-tlfs.h | 6 ++++++
>  2 files changed, 11 insertions(+)
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index ad455df850c9..1cdcf3ad5684 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -2228,6 +2228,11 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>  		goto hypercall_complete;
>  	}
>  
> +	if (unlikely(hc.param & HV_HYPERCALL_RSVD_MASK)) {
> +		ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
> +		goto hypercall_complete;
> +	}
> +
>  	if (hc.fast && is_xmm_fast_hypercall(&hc)) {
>  		if (unlikely(hv_vcpu->enforce_cpuid &&
>  			     !(hv_vcpu->cpuid_cache.features_edx &
> diff --git a/include/asm-generic/hyperv-tlfs.h b/include/asm-generic/hyperv-tlfs.h
> index 1ba8e6da4427..92b9ce5882f8 100644
> --- a/include/asm-generic/hyperv-tlfs.h
> +++ b/include/asm-generic/hyperv-tlfs.h
> @@ -183,11 +183,17 @@ enum HV_GENERIC_SET_FORMAT {
>  #define HV_HYPERCALL_FAST_BIT		BIT(16)
>  #define HV_HYPERCALL_VARHEAD_OFFSET	17
>  #define HV_HYPERCALL_VARHEAD_MASK	GENMASK_ULL(26, 17)
> +#define HV_HYPERCALL_RSVD0_MASK		GENMASK_ULL(31, 27)
>  #define HV_HYPERCALL_REP_COMP_OFFSET	32
>  #define HV_HYPERCALL_REP_COMP_1		BIT_ULL(32)
>  #define HV_HYPERCALL_REP_COMP_MASK	GENMASK_ULL(43, 32)
> +#define HV_HYPERCALL_RSVD1_MASK		GENMASK_ULL(47, 44)
>  #define HV_HYPERCALL_REP_START_OFFSET	48
>  #define HV_HYPERCALL_REP_START_MASK	GENMASK_ULL(59, 48)
> +#define HV_HYPERCALL_RSVD2_MASK		GENMASK_ULL(63, 60)
> +#define HV_HYPERCALL_RSVD_MASK		(HV_HYPERCALL_RSVD0_MASK | \
> +					 HV_HYPERCALL_RSVD1_MASK | \
> +					 HV_HYPERCALL_RSVD2_MASK)
>  
>  /* hypercall status code */
>  #define HV_STATUS_SUCCESS			0

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

