Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76AD23F3370
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 20:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236957AbhHTSXL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 14:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238332AbhHTSWM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 14:22:12 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18015C061796
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 11:20:04 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id r2so9983099pgl.10
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 11:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7SZugGzB7TR5VySNRS6URQGS59lwA9fcmlILv63kGBI=;
        b=F2sCL7Rdz7cBJh1bIoZuISN531PwqNvV60A41LaDK6LuAjncmOsT+ZEcOF4vSAGdPF
         w7YN9k5YmenYEIr4YmfmXKK8BzD0k3ep2OCocmgqxztIi6DsPafSy9TU+rmOPnuZIj/k
         KKqVnayZ+fO+DdfZuhuPzHXoYPI62uLWyff03ffEtUssSGGsfHYcqZJj1XxU81dDCr9u
         Z5KHmn8MB0mmQX9dK499+Aho41frvlT3ciUaP/pbDwRdbcUrtChBL196NCPKbHP7Qkkv
         ez6e7Mezw6lc27isSzrqnNECAICsKO+kQFLNQFFKlc/rkKusO46M9g7eVToqSujOuawE
         r4/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7SZugGzB7TR5VySNRS6URQGS59lwA9fcmlILv63kGBI=;
        b=YwE9irWmKwfb0JmKkHxa2Mhyhl8md5Esmv0K2V/et/Ev8et7qXmFG7h1zEYm9vMWvk
         iBKMrBkw9GvPgMlPtUZ2eRgWRH6sxpTnbBWyi2wMNidS6N4fdhj+tvjeclOQjFX1spbG
         eNtVW7uTDQqMxxCphJCv86CkxT0+1tpDnEP4jZIIEdD18IJ3UfRmXstnPLibu63wmQZV
         U61p/XF7nzs/FBYv0mgoj/0JQ64TcEQ1jzBtQ3oMi+Opqnn+wmKu+FnU4qbhGmMGyfoD
         ztzLlfcSsqh9FMEwBJNeURsYKM3UHWOr0AOsGMYqYbrmDMnB8Dfx8fFdTh+Vvrdtd7q6
         KeLg==
X-Gm-Message-State: AOAM530AXhoaM+jWssEs5aduYcHNVrT1zGG72DQNnXU0HlLoo/9HJCCs
        gEsIgt27ML4IV6e4sVfQCYaQlA==
X-Google-Smtp-Source: ABdhPJycG83cw8pIVOLQr7I38xcrmgGbkeCfFPDyWi+cjyIOcIXevzh4HKk/09eVVUnJ94/R1W8bBw==
X-Received: by 2002:a62:584:0:b029:32e:3b57:a1c6 with SMTP id 126-20020a6205840000b029032e3b57a1c6mr20677481pff.13.1629483603324;
        Fri, 20 Aug 2021 11:20:03 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z1sm8387256pfg.18.2021.08.20.11.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 11:20:02 -0700 (PDT)
Date:   Fri, 20 Aug 2021 18:19:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: Optimize kvm_make_vcpus_request_mask() a bit
Message-ID: <YR/yTDZR29AhKw6M@google.com>
References: <20210820124354.582222-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210820124354.582222-1-vkuznets@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 20, 2021, Vitaly Kuznetsov wrote:
> Iterating over set bits in 'vcpu_bitmap' should be faster than going
> through all vCPUs, especially when just a few bits are set.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  virt/kvm/kvm_main.c | 49 +++++++++++++++++++++++++++++----------------
>  1 file changed, 32 insertions(+), 17 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 3e67c93ca403..0f873c5ed538 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -257,34 +257,49 @@ static inline bool kvm_kick_many_cpus(const struct cpumask *cpus, bool wait)
>  	return true;
>  }
>  
> +static void kvm_make_vcpu_request(struct kvm *kvm, struct kvm_vcpu *vcpu,
> +				  unsigned int req, cpumask_var_t tmp)
> +{
> +	int cpu = vcpu->cpu;

This reminds me, syzbot found a data race a while back[*] in kvm_vcpu_kick()
related to reading vcpu->cpu.  That race is benign, but legitimate.  I believe
this code has a similar race, and I'm not as confident that it's benign.

If the target vCPU changes vcpu->cpu after it's read by this code, then the IPI
can sent to the wrong pCPU, e.g. this pCPU gets waylaid by an IRQ and the target
vCPU is migrated to a new pCPU.

The TL;DR is that the race is benign because the target vCPU is still guaranteed
to see the request before entering the guest, even if the IPI goes to the wrong
pCPU.  I believe the same holds true for KVM_REQUEST_WAIT, e.g. if the lockless
shadow PTE walk gets migrated to a new pCPU just before setting vcpu->mode to
READING_SHADOW_PAGE_TABLES, this code can use a stale "cpu" for __cpumask_set_cpu().
The race is benign because the vCPU would have to enter READING_SHADOW_PAGE_TABLES
_after_ the SPTE modifications were made, as vcpu->cpu can't change while the vCPU
is reading SPTEs.  The same logic holds true for the case where the vCPU is migrated
after the call to __cpumask_set_cpu(); the goal is to wait for the vCPU to return to
OUTSIDE_GUEST_MODE, which is guaranteed if the vCPU is migrated even if this path
doesn't wait for an ack from the _new_ pCPU.

I'll send patches to fix the races later today, maybe they can be folded into
v2?  Even though the races are benign, I think they're worth fixing, if only to
provide an opportunity to document why it's ok to send IPIs to the wrong pCPU.

[*] On an upstream kernel, but I don't think the bug report was posted to LKML.

> +
> +	kvm_make_request(req, vcpu);
> +
> +	if (!(req & KVM_REQUEST_NO_WAKEUP) && kvm_vcpu_wake_up(vcpu))
> +		return;
> +
> +	if (tmp != NULL && cpu != -1 && cpu != raw_smp_processor_id() &&

For large VMs, might be worth keeping get_cpu() in the caller in passing in @me?

> +	    kvm_request_needs_ipi(vcpu, req))
> +		__cpumask_set_cpu(cpu, tmp);
> +}
> +
>  bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
>  				 struct kvm_vcpu *except,
>  				 unsigned long *vcpu_bitmap, cpumask_var_t tmp)
>  {
> -	int i, cpu, me;
> +	int i;
>  	struct kvm_vcpu *vcpu;
>  	bool called;
>  
> -	me = get_cpu();
> -
> -	kvm_for_each_vcpu(i, vcpu, kvm) {
> -		if ((vcpu_bitmap && !test_bit(i, vcpu_bitmap)) ||
> -		    vcpu == except)
> -			continue;
> -
> -		kvm_make_request(req, vcpu);
> -		cpu = vcpu->cpu;
> -
> -		if (!(req & KVM_REQUEST_NO_WAKEUP) && kvm_vcpu_wake_up(vcpu))
> -			continue;
> +	preempt_disable();
>  
> -		if (tmp != NULL && cpu != -1 && cpu != me &&
> -		    kvm_request_needs_ipi(vcpu, req))
> -			__cpumask_set_cpu(cpu, tmp);
> +	if (likely(vcpu_bitmap)) {

I don't think this is actually "likely".  kvm_make_all_cpus_request() is by far
the most common caller and does not pass in a vcpu_bitmap.  Practically speaking
I highly don't the code organization will matter, but from a documentation
perspective it's wrong.

> +		for_each_set_bit(i, vcpu_bitmap, KVM_MAX_VCPUS) {
> +			vcpu = kvm_get_vcpu(kvm, i);
> +			if (!vcpu || vcpu == except)
> +				continue;
> +			kvm_make_vcpu_request(kvm, vcpu, req, tmp);
> +		}
> +	} else {
> +		kvm_for_each_vcpu(i, vcpu, kvm) {
> +			if (vcpu == except)
> +				continue;
> +			kvm_make_vcpu_request(kvm, vcpu, req, tmp);
> +		}
>  	}
>  
>  	called = kvm_kick_many_cpus(tmp, !!(req & KVM_REQUEST_WAIT));
> -	put_cpu();
> +
> +	preempt_enable();
>  
>  	return called;
>  }
> -- 
> 2.31.1
> 
