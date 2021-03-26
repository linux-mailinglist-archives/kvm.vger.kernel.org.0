Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF6734AD31
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 18:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbhCZROh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 13:14:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21836 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230196AbhCZROL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Mar 2021 13:14:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616778850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JUgswkTFP3CXKJJVd2lPXOooodWvB5w2ER2TbZnPTCQ=;
        b=dlZbgFkJeBTxnqrqPcJTD0LmDCfQOLDel6edXXNY5NvM2kSsbBHV/jjOtUrKILQHxWGmG7
        voJn7yqh1LtychmG/JLdZBMsAiqdkxbzszSbRrp7tHZkES3Hgmkqqwn6QxHTRBQEJBsiYh
        kHZm5AhkqTD3MtuwFNzfVBellAmL4ks=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-cMSf6nUDPciEvrGQAPpIbg-1; Fri, 26 Mar 2021 13:14:08 -0400
X-MC-Unique: cMSf6nUDPciEvrGQAPpIbg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D7BCB1084D9D;
        Fri, 26 Mar 2021 17:14:06 +0000 (UTC)
Received: from [10.10.110.35] (unknown [10.10.110.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF46C19727;
        Fri, 26 Mar 2021 17:14:03 +0000 (UTC)
Subject: Re: [PATCH] x86/kvmclock: Stop kvmclocks for hibernate restore
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210311132847.224406-1-lszubowi@redhat.com>
 <87sg4t7vqy.fsf@vitty.brq.redhat.com>
 <5048babd-a40b-5a95-9dee-ab13367de6cb@redhat.com>
 <87mtuqchdu.fsf@vitty.brq.redhat.com> <87h7kyccpu.fsf@vitty.brq.redhat.com>
 <87eeg2cbm8.fsf@vitty.brq.redhat.com>
From:   Lenny Szubowicz <lszubowi@redhat.com>
Message-ID: <6bde62aa-2c57-13bb-0380-93462a51f9cf@redhat.com>
Date:   Fri, 26 Mar 2021 13:14:03 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <87eeg2cbm8.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/26/21 9:01 AM, Vitaly Kuznetsov wrote:
> Vitaly Kuznetsov <vkuznets@redhat.com> writes:
> 
> ..
> 
>> (this is with your v2 included). There's nothing about CPU0 for
>> e.g. async PF + timestamps are really interesting. Seems we have issues
>> to fix) I'm playing with it right now.
> 
> What if we do the following (instead of your patch):
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 78bb0fae3982..c32392d6329d 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -26,6 +26,7 @@
>   #include <linux/kprobes.h>
>   #include <linux/nmi.h>
>   #include <linux/swait.h>
> +#include <linux/syscore_ops.h>
>   #include <asm/timer.h>
>   #include <asm/cpu.h>
>   #include <asm/traps.h>
> @@ -598,17 +599,21 @@ static void kvm_guest_cpu_offline(void)
>   
>   static int kvm_cpu_online(unsigned int cpu)
>   {
> -	local_irq_disable();
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
>   	kvm_guest_cpu_init();
> -	local_irq_enable();
> +	local_irq_restore(flags);
>   	return 0;
>   }
>   
>   static int kvm_cpu_down_prepare(unsigned int cpu)
>   {
> -	local_irq_disable();
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
>   	kvm_guest_cpu_offline();
> -	local_irq_enable();
> +	local_irq_restore(flags);
>   	return 0;
>   }
>   #endif
> @@ -639,6 +644,23 @@ static void kvm_flush_tlb_others(const struct cpumask *cpumask,
>   	native_flush_tlb_others(flushmask, info);
>   }
>   
> +static int kvm_suspend(void)
> +{
> +	kvm_guest_cpu_offline();
> +
> +	return 0;
> +}
> +
> +static void kvm_resume(void)
> +{
> +	kvm_cpu_online(raw_smp_processor_id());
> +}
> +
> +static struct syscore_ops kvm_syscore_ops = {
> +	.suspend	= kvm_suspend,
> +	.resume		= kvm_resume,
> +};
> +
>   static void __init kvm_guest_init(void)
>   {
>   	int i;
> @@ -681,6 +703,8 @@ static void __init kvm_guest_init(void)
>   	kvm_guest_cpu_init();
>   #endif
>   
> +	register_syscore_ops(&kvm_syscore_ops);
> +
>   	/*
>   	 * Hard lockup detection is enabled by default. Disable it, as guests
>   	 * can get false positives too easily, for example if the host is
> 

Yes, I do like using register_syscore_ops for this. I will base my V3 on this. -Lenny.

