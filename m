Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003B23F1B33
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 16:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240400AbhHSOHF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 10:07:05 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:54668 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240278AbhHSOHF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 10:07:05 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1mGig5-0001oq-BZ; Thu, 19 Aug 2021 16:05:53 +0200
To:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20210818114956.7171-1-pmenzel@molgen.mpg.de>
 <f9ba6fec-f764-dae7-e4f9-c532f4672359@maciej.szmigiero.name>
 <YR2Id14e9kagM6u0@google.com>
 <1c5ac4f8-4c39-a969-9ffa-2f527535a4b1@molgen.mpg.de>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH] x86: kvm: Demote level of already loaded message from
 error to info
Message-ID: <36208232-f936-9eed-22cf-88a61b294c7e@maciej.szmigiero.name>
Date:   Thu, 19 Aug 2021 16:05:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <1c5ac4f8-4c39-a969-9ffa-2f527535a4b1@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19.08.2021 08:39, Paul Menzel wrote:
> Am 19.08.21 um 00:23 schrieb Sean Christopherson:
>> On Wed, Aug 18, 2021, Maciej S. Szmigiero wrote:
>>> On 18.08.2021 13:49, Paul Menzel wrote:
>>>> In scripts, running
>>>>
>>>>       modprobe kvm_amd     2>/dev/null
>>>>       modprobe kvm_intel   2>/dev/null
>>>>
>>>> to ensure the modules are loaded causes Linux to log errors.
>>>>
>>>>       $ dmesg --level=err
>>>>       [    0.641747] [Firmware Bug]: TSC_DEADLINE disabled due to Errata; please update microcode to version: 0x3a (or later)
>>>>       [   40.196868] kvm: already loaded the other module
>>>>       [   40.219857] kvm: already loaded the other module
>>>>       [   55.501362] kvm [1177]: vcpu0, guest rIP: 0xffffffff96e5b644 disabled perfctr wrmsr: 0xc2 data 0xffff
>>>>       [   56.397974] kvm [1418]: vcpu0, guest rIP: 0xffffffff81046158 disabled perfctr wrmsr: 0xc1 data 0xabcd
>>>>       [1007981.827781] kvm: already loaded the other module
>>>>       [1008000.394089] kvm: already loaded the other module
>>>>       [1008030.706999] kvm: already loaded the other module
>>>>       [1020396.054470] kvm: already loaded the other module
>>>>       [1020405.614774] kvm: already loaded the other module
>>>>       [1020410.140069] kvm: already loaded the other module
>>>>       [1020704.049231] kvm: already loaded the other module
>>>>
>>>> As one of the two KVM modules is already loaded, KVM is functioning, and
>>>> their is no error condition. Therefore, demote the log message level to
>>>> informational.
>>
>> Hrm, but there is an error condition.  Userspace explicitly requested something
>> and KVM couldn't satisfy the request.
> 
> Yes, that’s the other perspective. ;-) I’d argue, as the Intel/AMD module can’t work on AMD/Intel, the load failure is expected and error. But as “error condition” is not well defined:
> 
>      $ dmesg -h
>      […]
>      Supported log levels (priorities):
>         emerg - system is unusable
>         alert - action must be taken immediately
>          crit - critical conditions
>           err - error conditions
>          warn - warning conditions
>        notice - normal but significant condition
>          info - informational
>         debug - debug-level messages
> 

Why is that script repeatably trying to load kvm_amd and kvm_intel
modules?
I would assume these would be loaded once at system boot time (either
manually or based on their modalias).
If your script absolutely has to load them manually, it could check first
whether /dev/kvm already exists.

>>> Shouldn't this return ENODEV when loading one of these modules instead
>>> as there is no hardware that supports both VMX and SVM?
>>
>> Probably not, as KVM would effectively be speculating, e.g. someone could load an
>> out-of-tree variant of kvm_{intel,amd}.  Maybe instead of switching to ENODEV,
>> reword the comment, make it ratelimited, and shove it down?  That way the message
>> and -EEXIST fires iff the vendor module actually has some chance of being loaded.
>>
>>  From 3528e66bd5107d5ac4f6a6ae50503cf64446866a Mon Sep 17 00:00:00 2001
>> From: Sean Christopherson <seanjc@google.com>
>> Date: Wed, 18 Aug 2021 15:17:43 -0700
>> Subject: [PATCH] KVM: x86: Tweak handling and message when vendor module is
>>   already loaded
>>
>> Reword KVM's error message if a vendor module is already loaded to state
>> exactly that instead of assuming "the other" module is loaded,
> 
> The rewording is definitely an improvement.
> 
>> ratelimit
>> said message to match the other errors, and move the check down below the
>> basic functionality checks so that attempting to load an unsupported
>> module provides the same result regardless of whether or not a supported
>> vendor module is already loaded.
> 
> Maybe add an example, how it would log the error before, and how it’s done now.
> 
>> Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
>> Cc: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
>>   arch/x86/kvm/x86.c | 12 ++++++------
>>   1 file changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index fdc0c18339fb..15bd4bd3c81d 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -8357,12 +8357,6 @@ int kvm_arch_init(void *opaque)
>>       struct kvm_x86_init_ops *ops = opaque;
>>       int r;
>>
>> -    if (kvm_x86_ops.hardware_enable) {
>> -        printk(KERN_ERR "kvm: already loaded the other module\n");
>> -        r = -EEXIST;
>> -        goto out;
>> -    }
>> -
>>       if (!ops->cpu_has_kvm_support()) {
>>           pr_err_ratelimited("kvm: no hardware support\n");
>>           r = -EOPNOTSUPP;
>> @@ -8374,6 +8368,12 @@ int kvm_arch_init(void *opaque)
>>           goto out;
>>       }
>>
>> +    if (kvm_x86_ops.hardware_enable) {
>> +        pr_err_ratelimited("kvm: already loaded a vendor module\n");
>> +        r = -EEXIST;
>> +        goto out;
>> +    }
>> +
>>       /*
>>        * KVM explicitly assumes that the guest has an FPU and
>>        * FXSAVE/FXRSTOR. For example, the KVM_GET_FPU explicitly casts the
>> -- 
>> 2.33.0.rc2.250.ged5fa647cd-goog
> 
> Sounds also good at first sight. No idea, if monitoring scripts in userspace would get confused now.

This definitely looks more informative than the existing message.

It would be even better if it wasn't "kvm: no hardware support" (as this
message is technically incorrect), but something like
"kvm: no VMX hardware support" or "kvm: no SVM hardware support".

> Kind regards,
> 
> Paul

Thanks,
Maciej
