Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9F874DD35
	for <lists+kvm@lfdr.de>; Mon, 10 Jul 2023 20:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbjGJSUP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 14:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjGJSUN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 14:20:13 -0400
Received: from out-51.mta0.migadu.com (out-51.mta0.migadu.com [91.218.175.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05252137
        for <kvm@vger.kernel.org>; Mon, 10 Jul 2023 11:20:11 -0700 (PDT)
Date:   Mon, 10 Jul 2023 18:20:03 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689013210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wNcS4LcXjclyiMnp2lcR18guJknTcpMsuoMft6tKMEA=;
        b=RU4KVaAw3Efkc7dyApbjO+sTH6Da8PxYZGerahiVixKa+H69hg5zx88ni2oDstRBqIRuL9
        HbEvG5Cpb/4FJagudsdHmOlaCzXxowVs5trw7H3Ud049AhvT+baF+FxrtNnirqHb6HuPcB
        7CcHiWHHJ40HYDPS1HAcg/k2k7oaxwo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, isaku.yamahata@intel.com,
        pbonzini@redhat.com,
        Kristina Martsenko <kristina.martsenko@arm.com>,
        stable@vger.kernek.org
Subject: Re: [PATCH] KVM: arm64: Disable preemption in
 kvm_arch_hardware_enable()
Message-ID: <ZKxL09AW1s2uL28x@linux.dev>
References: <20230703163548.1498943-1-maz@kernel.org>
 <ZKxIGOAcQbknIcBL@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZKxIGOAcQbknIcBL@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 10, 2023 at 11:04:08AM -0700, Sean Christopherson wrote:
> On Mon, Jul 03, 2023, Marc Zyngier wrote:
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index aaeae1145359..a28c4ffe4932 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -1894,8 +1894,17 @@ static void _kvm_arch_hardware_enable(void *discard)
> >  
> >  int kvm_arch_hardware_enable(void)
> >  {
> > -	int was_enabled = __this_cpu_read(kvm_arm_hardware_enabled);
> > +	int was_enabled;
> >  
> > +	/*
> > +	 * Most calls to this function are made with migration
> > +	 * disabled, but not with preemption disabled. The former is
> > +	 * enough to ensure correctness, but most of the helpers
> > +	 * expect the later and will throw a tantrum otherwise.
> > +	 */
> > +	preempt_disable();
> > +
> > +	was_enabled = __this_cpu_read(kvm_arm_hardware_enabled);
> 
> IMO, this_cpu_has_cap() is at fault.

Who ever said otherwise?

> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 7d7128c65161..b862477de2ce 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -3193,7 +3193,9 @@ static void __init setup_boot_cpu_capabilities(void)
>  
>  bool this_cpu_has_cap(unsigned int n)
>  {
> -       if (!WARN_ON(preemptible()) && n < ARM64_NCAPS) {
> +       __this_cpu_preempt_check("has_cap");
> +
> +       if (n < ARM64_NCAPS) {

This is likely sufficient, but to Marc's point we have !preemptible()
checks littered about, it just so happens that this_cpu_has_cap() is the
first to get called. We need to make sure there aren't any other checks
that'd break under hotplug.

While I'd normally like to see the 'right' fix fully fleshed out for
something like this, the bug is ugly enough where I'd rather take a hack
for the time being.

-- 
Thanks,
Oliver
