Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F02374604D
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 18:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbjGCQCb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 12:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbjGCQCa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 12:02:30 -0400
Received: from out-31.mta1.migadu.com (out-31.mta1.migadu.com [IPv6:2001:41d0:203:375::1f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 358B21B5
        for <kvm@vger.kernel.org>; Mon,  3 Jul 2023 09:02:28 -0700 (PDT)
Date:   Mon, 3 Jul 2023 09:02:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1688400146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t/q11Yw81bm/OQ8HuX8KouOM2Sbe1q7F70O7dTD8tWk=;
        b=n0UBZalHMSH9Zt+sjj5oFszZ60fJ5A1RcL5+NKTaXxXKRJvKI2yn43eca4vpIAnmQFew4Z
        Su7HoAzWXjeyP0A6GCAQPmVTRdclx0pdGkcaFFcuD2LCtjjPyRZoK8nEJmitu1jp3LZHeU
        GkDalD/fnx3kZNp18qPreh54joSHz5A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Kristina Martsenko <kristina.martsenko@arm.com>,
        isaku.yamahata@intel.com, seanjc@google.com, pbonzini@redhat.com,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>
Subject: Re: KVM CPU hotplug notifier triggers BUG_ON on arm64
Message-ID: <ZKLxFveKKvoQs5RV@thinky-boi>
References: <aeab7562-2d39-e78e-93b1-4711f8cc3fa5@arm.com>
 <ZKBlhJwl9YD5FHvs@linux.dev>
 <867crhxr9l.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <867crhxr9l.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Marc,

On Mon, Jul 03, 2023 at 10:45:26AM +0100, Marc Zyngier wrote:
> On Sat, 01 Jul 2023 18:42:28 +0100, Oliver Upton <oliver.upton@linux.dev> wrote:
> > Well, one way to hack around the problem would be to just cram
> > preempt_{disable,enable}() into kvm_arch_hardware_disable(), but that's
> > kinda gross in the context of cpuhp which isn't migratable in the first
> > place. Let me have a look...

Heh, I should've mentioned I'm on holiday until Thursday.

> An alternative would be to replace the preemptible() checks with a one
> that looks at the migration state, but I'm not sure that's much better
> (it certainly looks more costly).
> 
> There is also the fact that most of our per-CPU accessors are already
> using preemption disabling, and this code has a bunch of them. So I'm
> not sure there is a lot to be gained from not disabling preemption
> upfront.
> 
> Anyway, as I was able to reproduce the issue under NV, I tested the
> hack below. If anything, I expect it to be a reasonable fix for
> 6.3/6.4, and until we come up with a better approach.

Yeah, I'm fine with a hack like this. Do you want to send this out as a
patch?

--
Thanks,
Oliver

> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index aaeae1145359..a28c4ffe4932 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1894,8 +1894,17 @@ static void _kvm_arch_hardware_enable(void *discard)
>  
>  int kvm_arch_hardware_enable(void)
>  {
> -	int was_enabled = __this_cpu_read(kvm_arm_hardware_enabled);
> +	int was_enabled;
>  
> +	/*
> +	 * Most calls to this function are made with migration
> +	 * disabled, but not with preemption disabled. The former is
> +	 * enough to ensure correctness, but most of the helpers
> +	 * expect the later and will throw a tantrum otherwise.
> +	 */
> +	preempt_disable();
> +
> +	was_enabled = __this_cpu_read(kvm_arm_hardware_enabled);
>  	_kvm_arch_hardware_enable(NULL);
>  
>  	if (!was_enabled) {
> @@ -1903,6 +1912,8 @@ int kvm_arch_hardware_enable(void)
>  		kvm_timer_cpu_up();
>  	}
>  
> +	preempt_enable();
> +
>  	return 0;
>  }
>  
> 
> 
> 
> -- 
> Without deviation from the norm, progress is not possible.
