Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1383334D5F9
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 19:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbhC2RYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 13:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbhC2RYT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Mar 2021 13:24:19 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C73FCC061574
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 10:24:18 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id w8so6327717pjf.4
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 10:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Wf9x3HLqPxwy2O1wO6ZLVU0gKKbwy1eYEE1BGqyRZtw=;
        b=U8VUbVHxwk5wkvt0N39mmhptoRyMWFRSCPYWQaHup9FjnFVv8jYGWaw/65S3pFU/sx
         L/Z17aX2HZFmz1ocATNNLpGZqKj5fDP6qd8MBPsg67TvFGHRWliQuYXyW8CEk10/3uiq
         gr3N1vx0tjpDvCrVTc+7veklv+SCd4wiKsCrQiUx2eL5ExuJJjosN5kV/PlTowjfAgcR
         vnrOhOxwOActaPxhArUT3J3DlSaNPUrArVHrwZ5OYhl7JkhKSRyjN9aiNzAu8sa3Hx28
         nETPqsHTfXFLue0yP+3IiicvPE3TTeFR1Rkeb++MzabuoLG4q+XsjUhk+L3+2+P9Hk4r
         fFDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Wf9x3HLqPxwy2O1wO6ZLVU0gKKbwy1eYEE1BGqyRZtw=;
        b=bvwH+44q4RX5V2ncH+Kf8sLDFsf0ZU+uo0cFs4kFHyQaryRDbLUaDAzc1VY0uLLIvX
         pfxsYx+YRLqAsFhKhMkYMh6g2djbiSk8ec/ZBGhX4jeqgPOWBBiywL5xjsfwghSNgR88
         mBb3jliBmbXbhfMhiLSW5/EZn/ca+p3vuATizrBeJZ6pGiQ3c2bjloCvjhigLXnmZbNs
         6A4d/5prIJXJ5Vrz6ICBnYQnZRnZ+y/Bj6y0Rd1mojoQsF0LNOp0yGm41JS/50G+AuBY
         TuH5Pme2bXIxWI8Ig0WLDEOG9esbY91tCwS5cZEbfPPhFKoPTKll5+1VDVLD6GXTqcBg
         533Q==
X-Gm-Message-State: AOAM532iGRpsZG+jOf8ZxiVpJk6piC9Eywx+ANoztrSoXG/y3qsofcJA
        WP32IqQJ0/jMHEF5eoFypI/xNw==
X-Google-Smtp-Source: ABdhPJwA/wrXMzmFnW3S1NfRbfSevSkN/abGI4crcuvLu1gFsmGqqkr+FB6dPlBW+DHTtcbEU0nvqA==
X-Received: by 2002:a17:90b:284:: with SMTP id az4mr211065pjb.12.1617038658097;
        Mon, 29 Mar 2021 10:24:18 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id w15sm17439291pfn.84.2021.03.29.10.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 10:24:17 -0700 (PDT)
Date:   Mon, 29 Mar 2021 17:24:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v2 1/2] KVM: x86: hyper-v: Properly divide maybe-negative
 'hv_clock->system_time' in compute_tsc_page_parameters()
Message-ID: <YGINPcQxyco2WueO@google.com>
References: <20210329114800.164066-1-vkuznets@redhat.com>
 <20210329114800.164066-2-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329114800.164066-2-vkuznets@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 29, 2021, Vitaly Kuznetsov wrote:
> When guest time is reset with KVM_SET_CLOCK(0), it is possible for
> hv_clock->system_time to become a small negative number. This happens
> because in KVM_SET_CLOCK handling we set kvm->arch.kvmclock_offset based
> on get_kvmclock_ns(kvm) but when KVM_REQ_CLOCK_UPDATE is handled,
> kvm_guest_time_update() does
> 
> hv_clock.system_time = ka->master_kernel_ns + v->kvm->arch.kvmclock_offset;
> 
> And 'master_kernel_ns' represents the last time when masterclock
> got updated, it can precede KVM_SET_CLOCK() call. Normally, this is not a
> problem, the difference is very small, e.g. I'm observing
> hv_clock.system_time = -70 ns. The issue comes from the fact that
> 'hv_clock.system_time' is stored as unsigned and 'system_time / 100' in
> compute_tsc_page_parameters() becomes a very big number.
> 
> Use div_s64() to get the proper result when dividing maybe-negative
> 'hv_clock.system_time' by 100.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/hyperv.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index f98370a39936..0529b892f634 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1070,10 +1070,13 @@ static bool compute_tsc_page_parameters(struct pvclock_vcpu_time_info *hv_clock,
>  				hv_clock->tsc_to_system_mul,
>  				100);
>  
> -	tsc_ref->tsc_offset = hv_clock->system_time;
> -	do_div(tsc_ref->tsc_offset, 100);
> -	tsc_ref->tsc_offset -=
> +	/*
> +	 * Note: 'hv_clock->system_time' despite being 'u64' can hold a negative
> +	 * value here, thus div_s64().
> +	 */

Will anything break if hv_clock.system_time is made a s64?

> +	tsc_ref->tsc_offset = div_s64(hv_clock->system_time, 100) -
>  		mul_u64_u64_shr(hv_clock->tsc_timestamp, tsc_ref->tsc_scale, 64);
> +
>  	return true;
>  }
>  
> -- 
> 2.30.2
> 
