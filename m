Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56AB7745A6A
	for <lists+kvm@lfdr.de>; Mon,  3 Jul 2023 12:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbjGCKhQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jul 2023 06:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbjGCKhN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jul 2023 06:37:13 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B5EDBC7
        for <kvm@vger.kernel.org>; Mon,  3 Jul 2023 03:37:11 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CDE442F4;
        Mon,  3 Jul 2023 03:37:53 -0700 (PDT)
Received: from [10.57.28.201] (unknown [10.57.28.201])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 32D513F762;
        Mon,  3 Jul 2023 03:37:09 -0700 (PDT)
Message-ID: <a5f35eab-656e-76e6-3e08-d1605d1a0573@arm.com>
Date:   Mon, 3 Jul 2023 11:36:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: KVM CPU hotplug notifier triggers BUG_ON on arm64
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     isaku.yamahata@intel.com, seanjc@google.com, pbonzini@redhat.com,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>
References: <aeab7562-2d39-e78e-93b1-4711f8cc3fa5@arm.com>
 <ZKBlhJwl9YD5FHvs@linux.dev> <867crhxr9l.wl-maz@kernel.org>
From:   Kristina Martsenko <kristina.martsenko@arm.com>
In-Reply-To: <867crhxr9l.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/2023 10:45, Marc Zyngier wrote:
> On Sat, 01 Jul 2023 18:42:28 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
>>
>> Hi Kristina,
>>
>> Thanks for the bug report.
>>
>> On Sat, Jul 01, 2023 at 01:50:52PM +0100, Kristina Martsenko wrote:
>>> Hi,
>>>
>>> When I try to online a CPU on arm64 while a KVM guest is running, I hit a
>>> BUG_ON(preemptible()) (as well as a WARN_ON). See below for the full log.
>>>
>>> This is on kvmarm/next, but seems to have been broken since 6.3. Bisecting it
>>> points at commit:
>>>
>>>   0bf50497f03b ("KVM: Drop kvm_count_lock and instead protect kvm_usage_count with kvm_lock")
>>
>> Makes sense. We were using a spinlock before, which implictly disables
>> preemption.
>>
>> Well, one way to hack around the problem would be to just cram
>> preempt_{disable,enable}() into kvm_arch_hardware_disable(), but that's
>> kinda gross in the context of cpuhp which isn't migratable in the first
>> place. Let me have a look...
> 
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
> 
> Thanks,
> 
> 	M.
> 
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

This fixes the issue for me.

Tested-by: Kristina Martsenko <kristina.martsenko@arm.com>

Thanks,
Kristina

