Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5EC3B8701
	for <lists+kvm@lfdr.de>; Wed, 30 Jun 2021 18:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbhF3Q1S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Jun 2021 12:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhF3Q1R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Jun 2021 12:27:17 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A74C061756
        for <kvm@vger.kernel.org>; Wed, 30 Jun 2021 09:24:47 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id g21so2900677pfc.11
        for <kvm@vger.kernel.org>; Wed, 30 Jun 2021 09:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NEgaAVlRv/kfATVMW8tdrcMV3dsr5ebYEvYObjpj/Ps=;
        b=YE1Bqo8dZew53/JB9Yj72wQ9tdponDFKnwFhZ0RR8l9kTau1b2+dHLBV3WvZ4Mt6Yc
         x7PouKresVaf0AAPWLQCydxrcJ+rFFpSk8Mjlihe9wjhVVmm/IM/fbRGEJYkA+5iHTu2
         eemyP76/FDcCyC6QurTIJNW2wum1OUg0V3wKLs9ZAIhqF5Nuz7Y1P/BZEYge2A06BYFR
         ebew5sfvk4bJovo9CFmGx4ca9IWlvwPwv279FIXK6GNzadjhh80jSkn8rSv5DoeIcMJg
         gdWyQtDQa2P66bSVtjBlH8+nbjmoKpzXSWjQCGAARlIHRqDbQ2GOrHJbnmgUJJWwAE6W
         pnPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NEgaAVlRv/kfATVMW8tdrcMV3dsr5ebYEvYObjpj/Ps=;
        b=Q/JMiV49hQoaAtyBsf5bPLou2zj+tcs11W0/wRk15nX1gRJRP695xEEaoF9F/deF6f
         nLfp3xipWMjmE9djsp88kkg4VWACM6yeARFtmst87EzuMF/8VC62f7YiVcQblhYtIWM2
         A5h/6KNTxs8Y6QvcZv8JVe9vHmXEDyAMn8qsdKkxsNRAxe3qLIr9px1+D5EubdceWAtz
         fRBjYLKFkXJaD1h7xeGzAs7ekMG2Ow1O5WZQ55WBJAq/v1oTMSbyCE1zEl1anaGa5jMc
         BX+BSTlVHEiyeBklncJXjYRRZS3X54oa0fmdX1k1OQ5Rj/bOrqxJZ/7G6+IRfdZua7Lf
         4iQA==
X-Gm-Message-State: AOAM531ORyowqGIkLp5/ze4ooB6kFI3IMShciJbVGGkKAnKeWurvMiR7
        w2IvpkZhTJfcF0QhNcsMWEILvw==
X-Google-Smtp-Source: ABdhPJxhSGyzbFJbub9CkAFlP+g1KUsCVDm9IZH5PfpbfFko8cVpsBcz1vOv4++aPnAFrLTuWW9qtg==
X-Received: by 2002:aa7:8884:0:b029:307:4e14:14c9 with SMTP id z4-20020aa788840000b02903074e1414c9mr36872000pfe.62.1625070286439;
        Wed, 30 Jun 2021 09:24:46 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id z15sm24291333pgu.71.2021.06.30.09.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 09:24:45 -0700 (PDT)
Date:   Wed, 30 Jun 2021 16:24:41 +0000
From:   David Matlack <dmatlack@google.com>
To:     Venkatesh Srinivas <venkateshs@chromium.org>
Cc:     kvm@vger.kernel.org, jmattson@google.com, seanjc@google.com,
        elver@google.com, dvyukov@google.com
Subject: Re: [PATCH] KVM: kvm_vcpu_kick: Do not read potentially-stale
 vcpu->cpu
Message-ID: <YNyayUOiDDZ9V3Ex@google.com>
References: <20210630031037.584190-1-venkateshs@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630031037.584190-1-venkateshs@chromium.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 29, 2021 at 08:10:37PM -0700, Venkatesh Srinivas wrote:
> vcpu->cpu contains the last cpu a vcpu run/is running on;
> kvm_vcpu_kick is used to 'kick' a guest vcpu by sending an IPI
> to the last CPU; vcpu->cpu is updated on sched_in when a vcpu
> moves to a new CPU, so it possible for the vcpu->cpu field to
> be stale.
> 
> kvm_vcpu_kick also read vcpu->cpu early with a plain read,
> while vcpu->cpu could be concurrently written. This caused
> a data race, found by kcsan:
> 
> write to 0xffff8880274e8460 of 4 bytes by task 30718 on cpu 0:
>  kvm_arch_vcpu_load arch/x86/kvm/x86.c:4018
>  kvm_sched_in virt/kvm/kvm_main.c:4864
> 
> vs
>  kvm_vcpu_kick virt/kvm/kvm_main.c:2909
>  kvm_arch_async_page_present_queued arch/x86/kvm/x86.c:11287
>  async_pf_execute virt/kvm/async_pf.c:79
>  ...
> 
> Use a READ_ONCE to atomically read vcpu->cpu and avoid the
> data race.
> 
> Found by kcsan & syzbot.
> 
> Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  virt/kvm/kvm_main.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 46fb042837d2..0525f42afb7d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3058,16 +3058,18 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_wake_up);
>   */
>  void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
>  {
> -	int me;
> -	int cpu = vcpu->cpu;
> +	int me, cpu;
>  
>  	if (kvm_vcpu_wake_up(vcpu))
>  		return;
>  
>  	me = get_cpu();
> -	if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
> -		if (kvm_arch_vcpu_should_kick(vcpu))
> +	if (kvm_arch_vcpu_should_kick(vcpu)) {
> +		cpu = READ_ONCE(vcpu->cpu);
> +		WARN_ON_ONCE(cpu == me);

nit: A comment here may be useful to explain the interaction with
kvm_arch_vcpu_should_kick(). Took me a minute to understand why you
added the warning.

> +		if ((unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
>  			smp_send_reschedule(cpu);
> +	}
>  	put_cpu();
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_kick);
> -- 
> 2.30.2
> 
