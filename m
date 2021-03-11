Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697C0337BC8
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 19:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbhCKSJ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 13:09:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36987 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230246AbhCKSJV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Mar 2021 13:09:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615486160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h8zks63K83Zwm4iSUnQJFXpUT59hjLhR4rsdPX3mtRY=;
        b=H8RamWY32SweZ3P7wfXuhjapA+eCCLVwrEJPjwqzfyZrZGf9iAW3jY0O1uRnBdRkoCtCBK
        cDlZhM2KJofHKyD8zY0iABcFWHTur0AXHRw0xW4/u1a6/QlpEBM8WC9AoP5S/YQbWFMz/n
        4WLUvRf8JJK1B2jUHy0CwZKrEpkkrIo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-6jQ3YO_NPRqCTfNA-k4ntw-1; Thu, 11 Mar 2021 13:09:19 -0500
X-MC-Unique: 6jQ3YO_NPRqCTfNA-k4ntw-1
Received: by mail-wr1-f70.google.com with SMTP id m9so9895551wrx.6
        for <kvm@vger.kernel.org>; Thu, 11 Mar 2021 10:09:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h8zks63K83Zwm4iSUnQJFXpUT59hjLhR4rsdPX3mtRY=;
        b=kk8jIey8KCtQ7Q6hXhY7AJf9gRe9Kz7LgINfNiAMlhRYlZVxurzWkUu+c0YQtnCSOR
         7BR3xjxARbL2oR3O/qo8mC7OzRc909t5KN9XR7SmdtI8QL7SLa/DPRnYXYcPI/FmpAEg
         bf2QuRu6i3cD9bVNY8uUUrXdEWgr67bLZ4FwSIxhlF4NG50pSOD0TL6UZRUUNP3I7DZ1
         xSPk7fj2SHUmhMNcg/R4f5MJw57fYDrqOWa7D6b2/WiSzt+0oeIB6A8h/dvuUBs3q9Tb
         dNadM01TWgzGSeuRcU1ALl6u/37pFP40r+f3NmardcUxAdaE4bvX3emZPyyuVTWF7qRi
         Crrg==
X-Gm-Message-State: AOAM531RU4E7eLTkkkPSXnYSM2sGjL12ghBJpj4aF48lwNIHbkFwmcG5
        8BeEk7ugfmA1IJylTfV6Ly/FgHtLwrjYCJNHgpxX7ELIvlG2qkWd40kmuKx9vhVcEiTq1dAVsVh
        nrjHIw8w+EQay
X-Received: by 2002:a05:6000:23c:: with SMTP id l28mr10361015wrz.251.1615486158026;
        Thu, 11 Mar 2021 10:09:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwC+D8wJ49nUCKdg/vopP1FBA+HtaI7E32N/m6mCcW58wA8/jSxlDxvl/2rHDQYDIFXWKDUdQ==
X-Received: by 2002:a05:6000:23c:: with SMTP id l28mr10360993wrz.251.1615486157845;
        Thu, 11 Mar 2021 10:09:17 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y18sm5122535wrw.39.2021.03.11.10.09.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 10:09:17 -0800 (PST)
Subject: Re: [PATCH] x86/kvm: Fix broken irq restoration in kvm_wait
To:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <1614057902-23774-1-git-send-email-wanpengli@tencent.com>
 <CANRm+CwX189YE_oi5x-b6Xx4=hpcGCqzLaHjmW6bz_=Fj2N7Mw@mail.gmail.com>
 <YEo9GsUTKQRbd3HF@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ebd33d91-e2e8-c5a2-cd0e-4c505d49ae1d@redhat.com>
Date:   Thu, 11 Mar 2021 19:09:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YEo9GsUTKQRbd3HF@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/03/21 16:54, Sean Christopherson wrote:
> On Tue, Feb 23, 2021, Wanpeng Li wrote:
>> On Tue, 23 Feb 2021 at 13:25, Wanpeng Li <kernellwp@gmail.com> wrote:
>>>
>>> From: Wanpeng Li <wanpengli@tencent.com>
>>>
>>> After commit 997acaf6b4b59c (lockdep: report broken irq restoration), the guest
>>> splatting below during boot:
>>>
>>>   raw_local_irq_restore() called with IRQs enabled
>>>   WARNING: CPU: 1 PID: 169 at kernel/locking/irqflag-debug.c:10 warn_bogus_irq_restore+0x26/0x30
>>>   Modules linked in: hid_generic usbhid hid
>>>   CPU: 1 PID: 169 Comm: systemd-udevd Not tainted 5.11.0+ #25
>>>   RIP: 0010:warn_bogus_irq_restore+0x26/0x30
>>>   Call Trace:
>>>    kvm_wait+0x76/0x90
>>>    __pv_queued_spin_lock_slowpath+0x285/0x2e0
>>>    do_raw_spin_lock+0xc9/0xd0
>>>    _raw_spin_lock+0x59/0x70
>>>    lockref_get_not_dead+0xf/0x50
>>>    __legitimize_path+0x31/0x60
>>>    legitimize_root+0x37/0x50
>>>    try_to_unlazy_next+0x7f/0x1d0
>>>    lookup_fast+0xb0/0x170
>>>    path_openat+0x165/0x9b0
>>>    do_filp_open+0x99/0x110
>>>    do_sys_openat2+0x1f1/0x2e0
>>>    do_sys_open+0x5c/0x80
>>>    __x64_sys_open+0x21/0x30
>>>    do_syscall_64+0x32/0x50
>>>    entry_SYSCALL_64_after_hwframe+0x44/0xae
>>>
>>> The irqflags handling in kvm_wait() which ends up doing:
>>>
>>>          local_irq_save(flags);
>>>          safe_halt();
>>>          local_irq_restore(flags);
>>>
>>> which triggered a new consistency checking, we generally expect
>>> local_irq_save() and local_irq_restore() to be pared and sanely
>>> nested, and so local_irq_restore() expects to be called with
>>> irqs disabled.
>>>
>>> This patch fixes it by adding a local_irq_disable() after safe_halt()
>>> to avoid this warning.
>>>
>>> Cc: Mark Rutland <mark.rutland@arm.com>
>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
>>> ---
>>>   arch/x86/kernel/kvm.c | 4 +++-
>>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>>> index 5e78e01..688c84a 100644
>>> --- a/arch/x86/kernel/kvm.c
>>> +++ b/arch/x86/kernel/kvm.c
>>> @@ -853,8 +853,10 @@ static void kvm_wait(u8 *ptr, u8 val)
>>>           */
>>>          if (arch_irqs_disabled_flags(flags))
>>>                  halt();
>>> -       else
>>> +       else {
>>>                  safe_halt();
>>> +               local_irq_disable();
>>> +       }
>>
>> An alternative fix:
>>
>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>> index 5e78e01..7127aef 100644
>> --- a/arch/x86/kernel/kvm.c
>> +++ b/arch/x86/kernel/kvm.c
>> @@ -836,12 +836,13 @@ static void kvm_kick_cpu(int cpu)
>>
>>   static void kvm_wait(u8 *ptr, u8 val)
>>   {
>> -    unsigned long flags;
>> +    bool disabled = irqs_disabled();
>>
>>       if (in_nmi())
>>           return;
>>
>> -    local_irq_save(flags);
>> +    if (!disabled)
>> +        local_irq_disable();
>>
>>       if (READ_ONCE(*ptr) != val)
>>           goto out;
>> @@ -851,13 +852,14 @@ static void kvm_wait(u8 *ptr, u8 val)
>>        * for irq enabled case to avoid hang when lock info is overwritten
>>        * in irq spinlock slowpath and no spurious interrupt occur to save us.
>>        */
>> -    if (arch_irqs_disabled_flags(flags))
>> +    if (disabled)
>>           halt();
>>       else
>>           safe_halt();
>>
>>   out:
>> -    local_irq_restore(flags);
>> +    if (!disabled)
>> +        local_irq_enable();
>>   }
>>
>>   #ifdef CONFIG_X86_32
> 
> A third option would be to split the paths.  In the end, it's only the ptr/val
> line that's shared.
> 
> ---
>   arch/x86/kernel/kvm.c | 23 ++++++++++-------------
>   1 file changed, 10 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index 5e78e01ca3b4..78bb0fae3982 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -836,28 +836,25 @@ static void kvm_kick_cpu(int cpu)
> 
>   static void kvm_wait(u8 *ptr, u8 val)
>   {
> -	unsigned long flags;
> -
>   	if (in_nmi())
>   		return;
> 
> -	local_irq_save(flags);
> -
> -	if (READ_ONCE(*ptr) != val)
> -		goto out;
> -
>   	/*
>   	 * halt until it's our turn and kicked. Note that we do safe halt
>   	 * for irq enabled case to avoid hang when lock info is overwritten
>   	 * in irq spinlock slowpath and no spurious interrupt occur to save us.
>   	 */
> -	if (arch_irqs_disabled_flags(flags))
> -		halt();
> -	else
> -		safe_halt();
> +	if (irqs_disabled()) {
> +		if (READ_ONCE(*ptr) == val)
> +			halt();
> +	} else {
> +		local_irq_disable();
> 
> -out:
> -	local_irq_restore(flags);
> +		if (READ_ONCE(*ptr) == val)
> +			safe_halt();
> +
> +		local_irq_enable();
> +	}
>   }
> 
>   #ifdef CONFIG_X86_32
> --
> 

I'll send this one tomorrow.

Paolo

