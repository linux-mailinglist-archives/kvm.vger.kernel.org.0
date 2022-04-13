Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32A9E50014D
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 23:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232614AbiDMVpc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 17:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232473AbiDMVpb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 17:45:31 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E435738BDB
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 14:43:08 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id l127so1407070pfl.6
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 14:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RNkb+Oz3fazVqY2YiyD/9DFwcBXuYmOA0gGrRMvalDM=;
        b=HkTIU0JG4LDuTnA3bgfA8NvKFHvyzU1rJt7UcW5fR5WC1rTXY+xVvmCUfcNN3wZlIR
         1csW2Ttr6MR3Jbcu7FPnUxwsncmOguFxKEVZCZnvsR+fxryqWyu1XcEbqx2eCljPHyEj
         JIPm72GsnBaHOTSMd2DhCq8PLhcTBStFsPiNUZEtWkoh10TKgPjBMMOPivQuj2OhsIKg
         qlWMQ9R6Fb1FDTAXdXceRoveGf01fvms2aIk9KXO0HULl+BSafNZan6w/4pZANu4GIuS
         upNiZthvk73a/xo/RyAXhj9U9juH3Tp6FdHDLGjDCy5N0hhjA1u3l4Ohh0R+iboNIX8J
         QpVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RNkb+Oz3fazVqY2YiyD/9DFwcBXuYmOA0gGrRMvalDM=;
        b=j27f4OWotN/Us6OGY8GFwCUIajc7ZYnJKoS5+G9bRudftxMk5os1NPlmIQ9GeqZLnT
         +9LG5p9B1Lt6T6lfY/zps8wXsEBqtV0PfKnZB2/QpyoY8c8SFvlVgiI3UJqRdOWy1+it
         SSLcNHFRx+g1kkqu9sKmfm9Mx0M1H4WjkPvftFE4/4luhD1wNHo3POY5FXSXxSeQUamg
         skvLA82htQfWmne2waHrqnaTgHRUawCCFWsE/Wimh5we9gES1IWyHn293gZxKuG/ydNg
         HC5n782MD7uRG3emMCd/jpeEIvBoF3kYh9v+Xu0f8i4QdV0WMV3SlKS0Yn0lhODPJkiw
         WVOw==
X-Gm-Message-State: AOAM533/IoAh7T8DYGnEWfjt7M67W9CK8F2ziMZMJHHiEnV3c/riiUUt
        SKsKYQ028ciAMcrsDs6HWiaBnQ==
X-Google-Smtp-Source: ABdhPJz3759MNqht0yGbqAq5Kwbautm4cXXROrqa3tKvLnE/Oug6IsZUYDHzoO4rNy+k5OaKzAoZdA==
X-Received: by 2002:a65:5582:0:b0:39d:7611:c318 with SMTP id j2-20020a655582000000b0039d7611c318mr11506875pgs.213.1649886188203;
        Wed, 13 Apr 2022 14:43:08 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id e126-20020a621e84000000b0050567191161sm26520pfe.210.2022.04.13.14.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 14:43:07 -0700 (PDT)
Date:   Wed, 13 Apr 2022 21:43:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 3/5] KVM: X86: Boost vCPU which is in critical section
Message-ID: <YldD56m2nEUPLwx1@google.com>
References: <1648800605-18074-1-git-send-email-wanpengli@tencent.com>
 <1648800605-18074-4-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1648800605-18074-4-git-send-email-wanpengli@tencent.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+tglx and PeterZ

On Fri, Apr 01, 2022, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> The missing semantic gap that occurs when a guest OS is preempted 
> when executing its own critical section, this leads to degradation 
> of application scalability. We try to bridge this semantic gap in 
> some ways, by passing guest preempt_count to the host and checking 
> guest irq disable state, the hypervisor now knows whether guest 
> OSes are running in the critical section, the hypervisor yield-on-spin 
> heuristics can be more smart this time to boost the vCPU candidate 
> who is in the critical section to mitigate this preemption problem, 
> in addition, it is more likely to be a potential lock holder.
> 
> Testing on 96 HT 2 socket Xeon CLX server, with 96 vCPUs VM 100GB RAM,
> one VM running benchmark, the other(none-2) VMs running cpu-bound 
> workloads, There is no performance regression for other benchmarks 
> like Unixbench etc.

...

> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/x86.c       | 22 ++++++++++++++++++++++
>  include/linux/kvm_host.h |  1 +
>  virt/kvm/kvm_main.c      |  7 +++++++
>  3 files changed, 30 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9aa05f79b743..b613cd2b822a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10377,6 +10377,28 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
>  	return r;
>  }
>  
> +static bool kvm_vcpu_is_preemptible(struct kvm_vcpu *vcpu)
> +{
> +	int count;
> +
> +	if (!vcpu->arch.pv_pc.preempt_count_enabled)
> +		return false;
> +
> +	if (!kvm_read_guest_cached(vcpu->kvm, &vcpu->arch.pv_pc.preempt_count_cache,
> +	    &count, sizeof(int)))
> +		return !(count & ~PREEMPT_NEED_RESCHED);

As I pointed out in v1[*], this makes PREEMPT_NEED_RESCHED and really the entire
__preempt_count to some extent, KVM guest/host ABI.  That needs acks from sched
folks, and if they're ok with it, needs to be formalized somewhere in kvm_para.h,
not buried in the KVM host code.

[*] https://lore.kernel.org/all/YkOfJeXm8MiMOEyh@google.com

> +
> +	return false;
> +}
> +
