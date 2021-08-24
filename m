Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2476A3F618D
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 17:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238347AbhHXPZX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 11:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238337AbhHXPZW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 11:25:22 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E56B7C061764
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 08:24:37 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id y11so18682167pfl.13
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 08:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dOpXg+FJdBLWI5rzPlpee9Thq8Rl+rTtOGkPC38d/eM=;
        b=JeIic1euaNtoLKNq9Q2VWjbFLkdZFTk39npgl9ehainLBb57csCZPGQnFvb8pOYRlY
         SdtJJN6+MbbojDL4x0iduT7RFArHpVi6EPsEJ2JWQ9IdgmYPP+rCtQma07PZk6OpRoEw
         3LQSiQJlRijueWh/uB7/CSX/ousA0s9uTsqzOq6mEVlNw11OHU/xzZqTYgeN6bPc2SQv
         Tyh97N6Z3hy0YNpcckKClrX2zX7jMAEBtyujYVM0bf2Ylz528MqHKSbhdhY5R4K1KuD6
         mu6txVs2KD7trtXyKliX6MGsbP+TnGqMr+Or6YrnvKIyD6/oDBwJzgyzgSMAY71xe9Fi
         2LWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dOpXg+FJdBLWI5rzPlpee9Thq8Rl+rTtOGkPC38d/eM=;
        b=HJ5+FdprGqBh/MHSKDeBYR+Tk5m/n/tTmAKYJtFgf82jRVngn8DkXnOgEj8TQc5zBK
         ntdgP5CHNbqojRXblm1sE2/Q66VZslhQfWvHp8Je4mLZZ1VZhQSQ0aqRS4d4YfVj+1JG
         Qb5xMkPhZN3tNuHcOR2tm/zbgqT6nc2s/Lby7D5AilGAAQlQJsuUx0KdEh1PtZ9OALA6
         MjxnL5fUxoIoQDfoLFKAsGXTrUItcRHeQoqAF4NS8raSs/8u+/psPfxOZnwSx2p8WWiL
         DNg1z/X0D9VODM3sDGzAXn0XGZKpR98c1AU0fktfpbkJHeyEJLD3+u7enq7Hv6YE3SbL
         txuw==
X-Gm-Message-State: AOAM5332YWsZO3yKLcZGLUFfjdbQ1w/URtgP9gOxUNVDRwQYvII63Elb
        +YoOpvVsyWAJLFRA1HbqhgbugA==
X-Google-Smtp-Source: ABdhPJzRLPy8KIFVr1u2JWlVmZFkhe9C3VHpJlsLA0fV++hreJjotD//9FSKzU53CDs5iITtPa44MA==
X-Received: by 2002:a63:480b:: with SMTP id v11mr37586366pga.413.1629818677254;
        Tue, 24 Aug 2021 08:24:37 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b7sm18844657pfl.195.2021.08.24.08.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 08:24:36 -0700 (PDT)
Date:   Tue, 24 Aug 2021 15:24:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] KVM: VMX: Use cached vmx->pt_desc.addr_range
Message-ID: <YSUPKmtP6Dcl1yio@google.com>
References: <20210824110743.531127-1-xiaoyao.li@intel.com>
 <20210824110743.531127-3-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824110743.531127-3-xiaoyao.li@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 24, 2021, Xiaoyao Li wrote:
> The number of guest's valid PT ADDR MSRs is cached in

Can you do s/cached/precomputed in the shortlog and changelog?  Explanation below.

> vmx->pt_desc.addr_range. Use it instead of calculating it again.
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e0a9460e4dab..7ed96c460661 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2202,8 +2202,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		if (!pt_can_write_msr(vmx))
>  			return 1;
>  		index = msr_info->index - MSR_IA32_RTIT_ADDR0_A;
> -		if (index >= 2 * intel_pt_validate_cap(vmx->pt_desc.caps,
> -						       PT_CAP_num_address_ranges))
> +		if (index >= 2 * vmx->pt_desc.addr_range)

Ugh, "validate" is a lie, a better name would be intel_pt_get_cap() or so.  There
is no validation, the helper is simply extracting the requested cap from the
passed in array of capabilities.

That matters in this case because the number of address ranges exposed to the
guest is not bounded by the number of address ranges present in hardware, i.e.
it's not "validated".  And that matters because KVM uses vmx->pt_desc.addr_range
to pass through the ADDRn_{A,B} MSRs when tracing enabled.  In other words,
userspace can expose MSRs to the guest that do not exist.

The bug shouldn't be a security issue, so long as Intel CPUs are bug free and
aren't doing silly things with MSR indexes.  The number of possible address ranges
is encoded in three bits, thus the theoretical max is 8 ranges.  So userspace can't
get access to arbitrary MSRs, just ADDR0_A -> ADDR7_B.

And since KVM would be modifying the "validated" value, it's more than just a
cache, hence the request to use "precomputed".

Finally, vmx_get_msr() should use the precomputed value as well.

P.S. If you want to introduce a bit of churn, s/addr_range/nr_addr_ranges would
     be a welcome change as well.

>  			return 1;
>  		if (is_noncanonical_address(data, vcpu))
>  			return 1;
> -- 
> 2.27.0
> 
