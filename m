Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA3AA75A022
	for <lists+kvm@lfdr.de>; Wed, 19 Jul 2023 22:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbjGSUsW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 16:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjGSUsV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 16:48:21 -0400
Received: from out-2.mta1.migadu.com (out-2.mta1.migadu.com [95.215.58.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0ECB1BF6
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 13:48:19 -0700 (PDT)
Date:   Wed, 19 Jul 2023 20:48:13 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689799697;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ABmm8ziz9w11JK63dBDo/JptwWWVO+Y+GrOZN7APQNo=;
        b=QbYLN3KsKY0UMpUE5N0eq/DOFDyLXqbm3K+hyONSSXH3wZQHs8MT77tS5XJr3QJq+IP5pb
        Z8SO/+JsRWBto74/wxwKIzmZoubj4AVb3sXX621eRLSyhaY4s1H7YaOlFv8SE9oVCYuxed
        J7dOGvyYBSQgQoUZOa6NV5OgRwc0sF4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Reiji Watanabe <reijiw@google.com>, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Fix CPUHP logic for protected KVM
Message-ID: <ZLhMDapXa2djVzf0@linux.dev>
References: <20230719175400.647154-1-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230719175400.647154-1-rananta@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 19, 2023 at 05:54:00PM +0000, Raghavendra Rao Ananta wrote:
> For protected kvm, the CPU hotplug 'down' logic currently brings
> down the timer and vGIC, essentially disabling interrupts. However,
> because of how the 'kvm_arm_hardware_enabled' flag is designed, it
> never re-enables them back on the CPU hotplug 'up' path. Hence,
> clean up the logic to maintain the CPU hotplug up/down symmetry.

Correct me if I am wrong, but this issue exists outside of cpu hotplug,
right? init_subsystems() calls _kvm_arch_hardware_enable() on all cores,
which only sets up the hyp cpu context and not the percpu interrupts.
Similar issue exists for the cpu that calls do_pkvm_init().

I'll also note kvm_arm_hardware_enabled is deceptively vague, as it only
keeps track of whether or not the hyp cpu context has been initialized.
May send a cleanup here in a bit.

Perhaps this for the changelog:

  KVM: arm64: Fix hardware enable/disable flows for pKVM

  When running in protected mode, the hyp stub is disabled after pKVM is
  initialized, meaning the host cannot enable/disable the hyp at
  runtime. As such, kvm_arm_hardware_enabled is always 1 after
  initialization, and kvm_arch_hardware_enable() never enables the vgic
  maintenance irq or timer irqs.

  Unconditionally enable/disable the vgic + timer irqs in the respective
  calls, instead relying on the percpu bookkeeping in the generic code
  to keep track of which cpus have the interrupts unmasked.

> Fixes: 466d27e48d7c ("KVM: arm64: Simplify the CPUHP logic")
> Reported-by: Oliver Upton <oliver.upton@linux.dev>
> Suggested-by: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  arch/arm64/kvm/arm.c | 14 ++++----------
>  1 file changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index c2c14059f6a8..010ebfa69650 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1867,14 +1867,10 @@ static void _kvm_arch_hardware_enable(void *discard)
>  
>  int kvm_arch_hardware_enable(void)
>  {
> -	int was_enabled = __this_cpu_read(kvm_arm_hardware_enabled);
> -
>  	_kvm_arch_hardware_enable(NULL);
>  
> -	if (!was_enabled) {
> -		kvm_vgic_cpu_up();
> -		kvm_timer_cpu_up();
> -	}
> +	kvm_vgic_cpu_up();
> +	kvm_timer_cpu_up();
>  
>  	return 0;
>  }
> @@ -1889,10 +1885,8 @@ static void _kvm_arch_hardware_disable(void *discard)
>  
>  void kvm_arch_hardware_disable(void)
>  {
> -	if (__this_cpu_read(kvm_arm_hardware_enabled)) {
> -		kvm_timer_cpu_down();
> -		kvm_vgic_cpu_down();
> -	}
> +	kvm_timer_cpu_down();
> +	kvm_vgic_cpu_down();
>  
>  	if (!is_protected_kvm_enabled())
>  		_kvm_arch_hardware_disable(NULL);
> -- 
> 2.41.0.487.g6d72f3e995-goog
> 

-- 
Thanks,
Oliver
