Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C08665EFC98
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 20:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234999AbiI2SCX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 14:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235232AbiI2SCR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 14:02:17 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732C310B58B
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 11:02:15 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1odxrJ-0007PM-Vd; Thu, 29 Sep 2022 20:02:06 +0200
Message-ID: <34febefd-c50c-f13a-ec57-4b82adb2225b@maciej.szmigiero.name>
Date:   Thu, 29 Sep 2022 20:02:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Content-Language: en-US, pl-PL
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, qemu-devel@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>
References: <8474c6ca63bbbf85ac7721732a7bbdb033f7aa50.1664378882.git.maciej.szmigiero@oracle.com>
 <0e1eef64-b157-c87d-ef54-3b5a8bae9aad@redhat.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH v2] hyperv: fix SynIC SINT assertion failure on guest
 reset
In-Reply-To: <0e1eef64-b157-c87d-ef54-3b5a8bae9aad@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29.09.2022 19:13, Paolo Bonzini wrote:
> On 9/28/22 18:17, Maciej S. Szmigiero wrote:
>> From: "Maciej S. Szmigiero"<maciej.szmigiero@oracle.com>
>>
>> Resetting a guest that has Hyper-V VMBus support enabled triggers a QEMU
>> assertion failure:
>> hw/hyperv/hyperv.c:131: synic_reset: Assertion `QLIST_EMPTY(&synic->sint_routes)' failed.
>>
>> This happens both on normal guest reboot or when using "system_reset" HMP
>> command.
>>
>> The failing assertion was introduced by commit 64ddecc88bcf ("hyperv: SControl is optional to enable SynIc")
>> to catch dangling SINT routes on SynIC reset.
>>
>> The root cause of this problem is that the SynIC itself is reset before
>> devices using SINT routes have chance to clean up these routes.
>>
>> Since there seems to be no existing mechanism to force reset callbacks (or
>> methods) to be executed in specific order let's use a similar method that
>> is already used to reset another interrupt controller (APIC) after devices
>> have been reset - by invoking the SynIC reset from the machine reset
>> handler via a new x86_cpu_after_reset() function co-located with
>> the existing x86_cpu_reset() in target/i386/cpu.c.
>>
>> Fixes: 64ddecc88bcf ("hyperv: SControl is optional to enable SynIc") # exposed the bug
>> Signed-off-by: Maciej S. Szmigiero<maciej.szmigiero@oracle.com>
> 
> Thanks, looks good.
> 
> hw/i386/microvm.c has to be adjusted too,

You're right, I was misled by the fact that VMBus is only available on
pc or q35, but obviously kvm_arch_after_reset_vcpu() has (or will have)
other side effects, too.

> what do you think of this:
> diff --git a/hw/i386/microvm.c b/hw/i386/microvm.c
> index dc929727dc..64eb6374ad 100644
> --- a/hw/i386/microvm.c
> +++ b/hw/i386/microvm.c
> @@ -485,9 +485,7 @@ static void microvm_machine_reset(MachineState *machine)
>       CPU_FOREACH(cs) {
>           cpu = X86_CPU(cs);
> 
> -        if (cpu->apic_state) {
> -            device_legacy_reset(cpu->apic_state);
> -        }
> +        x86_cpu_after_reset(cpu);
>       }
>   }
> 
> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
> index 655439fe62..15a854b149 100644
> --- a/hw/i386/pc.c
> +++ b/hw/i386/pc.c
> @@ -1863,10 +1863,6 @@ static void pc_machine_reset(MachineState *machine)
>           cpu = X86_CPU(cs);
> 
>           x86_cpu_after_reset(cpu);
> -
> -        if (cpu->apic_state) {
> -            device_legacy_reset(cpu->apic_state);
> -        }
>       }
>   }
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 27ee8c1ced..349bd5d048 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -6042,6 +6042,10 @@ void x86_cpu_after_reset(X86CPU *cpu)
>       if (kvm_enabled()) {
>           kvm_arch_after_reset_vcpu(cpu);
>       }
> +
> +    if (cpu->apic_state) {
> +        device_legacy_reset(cpu->apic_state);
> +    }
>   #endif
>   }
> 

Definitely makes sense, will prepare a v3 tomorrow.

Thanks,
Maciej



