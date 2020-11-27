Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF6BB2C6938
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 17:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731250AbgK0QPD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Nov 2020 11:15:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35100 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731187AbgK0QPC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Nov 2020 11:15:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606493700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jm1gIlyuAX3rZol0d7N8qn0PguUJ0zEL6cOfUy97yMQ=;
        b=WQch3/+hj0MseiqEihEATwhLkMiF23pfxFlrwjWVILrhLwdkkP6l8upIOwFlJux/TPp3gE
        kZO4TKZ2A7Dnl/S0cXb7GZxwVftglDykPW176AaKcsIYpljvb2iUROXPVzFU6ixpsmQKms
        Xd/8b3WMLucDA6bI/ETJyn4VM8k8PU0=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-j0ImexGJNmCvTUQJRRccRQ-1; Fri, 27 Nov 2020 11:14:59 -0500
X-MC-Unique: j0ImexGJNmCvTUQJRRccRQ-1
Received: by mail-ed1-f71.google.com with SMTP id dj19so2586312edb.13
        for <kvm@vger.kernel.org>; Fri, 27 Nov 2020 08:14:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Jm1gIlyuAX3rZol0d7N8qn0PguUJ0zEL6cOfUy97yMQ=;
        b=EpE21nbk42DcsdyzmQAe+/MqfAQj+Dbd5lhkI4ugP8ESqw7CQEkowqDDzCpFWdAxgA
         0ooXQuU5+UQRd99VgsvbMvgmIbizic/LT8vHfj8cijYB3DwJ0wN+gUyDeg9JQGWQ177v
         ZJJKQkPeH1G2avLZXSQp1Pmxk7+0pQyt34go77+HR2QZciTme+Yd2oavqaBCWxf/Sphj
         2IQKby+00BWnH2tjx5dhOlYQiknV8kpzX1JAs6ReMokPGkCg5Tj7Okmp938c2yC8U4wR
         To81HCOFG35F20IXVyO8dew0V6+6QXnBOxgKE4U5PLRrLC7hP6JWGpklzpiaF4RAMbvd
         IQ+Q==
X-Gm-Message-State: AOAM5323aztcyyh+c57zoGzXoP3UkzRD8/t4+5XaVDKQX9J9U8QJlDy7
        xMGc9INHC8C3dbC7icNiiM6nvjnVC2bf/CfpQzBQ/mYHXyOVHMeO6V70miKEOTOvg73FvNP1srw
        3F8E9w9v9BGzI
X-Received: by 2002:a17:906:6d99:: with SMTP id h25mr798810ejt.281.1606493697759;
        Fri, 27 Nov 2020 08:14:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwP6A2eI8L0+JqFX48XRDmV6t/VfWcZTb2guQrWRoCAueiVWmJh+PP++i3SC5YZuEhhYh7x5w==
X-Received: by 2002:a17:906:6d99:: with SMTP id h25mr798778ejt.281.1606493697499;
        Fri, 27 Nov 2020 08:14:57 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id t22sm5256560edq.64.2020.11.27.08.14.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Nov 2020 08:14:56 -0800 (PST)
Subject: Re: [PATCH] kvm: x86/mmu: Fix get_mmio_spte() on CPUs supporting
 5-level PT
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>
References: <20201126110206.2118959-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e654258d-d579-7ae5-8b36-cec6f93187c8@redhat.com>
Date:   Fri, 27 Nov 2020 17:14:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201126110206.2118959-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/11/20 12:02, Vitaly Kuznetsov wrote:
> Commit 95fb5b0258b7 ("kvm: x86/mmu: Support MMIO in the TDP MMU") caused
> the following WARNING on an Intel Ice Lake CPU:
> 
>   get_mmio_spte: detect reserved bits on spte, addr 0xb80a0, dump hierarchy:
>   ------ spte 0xb80a0 level 5.
>   ------ spte 0xfcd210107 level 4.
>   ------ spte 0x1004c40107 level 3.
>   ------ spte 0x1004c41107 level 2.
>   ------ spte 0x1db00000000b83b6 level 1.
>   WARNING: CPU: 109 PID: 10254 at arch/x86/kvm/mmu/mmu.c:3569 kvm_mmu_page_fault.cold.150+0x54/0x22f [kvm]
> ...
>   Call Trace:
>    ? kvm_io_bus_get_first_dev+0x55/0x110 [kvm]
>    vcpu_enter_guest+0xaa1/0x16a0 [kvm]
>    ? vmx_get_cs_db_l_bits+0x17/0x30 [kvm_intel]
>    ? skip_emulated_instruction+0xaa/0x150 [kvm_intel]
>    kvm_arch_vcpu_ioctl_run+0xca/0x520 [kvm]
> 
> The guest triggering this crashes. Note, this happens with the traditional
> MMU and EPT enabled, not with the newly introduced TDP MMU. Turns out,
> there was a subtle change in the above mentioned commit. Previously,
> walk_shadow_page_get_mmio_spte() was setting 'root' to 'iterator.level'
> which is returned by shadow_walk_init() and this equals to
> 'vcpu->arch.mmu->shadow_root_level'. Now, get_mmio_spte() sets it to
> 'int root = vcpu->arch.mmu->root_level'.
> 
> The difference between 'root_level' and 'shadow_root_level' on CPUs
> supporting 5-level page tables is that in some case we don't want to
> use 5-level, in particular when 'cpuid_maxphyaddr(vcpu) <= 48'
> kvm_mmu_get_tdp_level() returns '4'. In case upper layer is not used,
> the corresponding SPTE will fail '__is_rsvd_bits_set()' check.
> 
> Revert to using 'shadow_root_level'.
> 
> Fixes: 95fb5b0258b7 ("kvm: x86/mmu: Support MMIO in the TDP MMU")
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
> - The usual (for KVM MMU) caveat 'I may be missing everything' applies,
>   please review)
> ---
>   arch/x86/kvm/mmu/mmu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 5bb1939b65d8..7a6ae9e90bd7 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3517,7 +3517,7 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
>   {
>   	u64 sptes[PT64_ROOT_MAX_LEVEL];
>   	struct rsvd_bits_validate *rsvd_check;
> -	int root = vcpu->arch.mmu->root_level;
> +	int root = vcpu->arch.mmu->shadow_root_level;
>   	int leaf;
>   	int level;
>   	bool reserved = false;
> 

Queued, thanks.

Paolo

