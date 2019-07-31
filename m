Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E66D7C162
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 14:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387643AbfGaMcK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 08:32:10 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54030 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387639AbfGaMcK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 08:32:10 -0400
Received: by mail-wm1-f67.google.com with SMTP id x15so60652480wmj.3
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 05:32:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=piBqViNj5aiB48a8+E54EeLVhMXIbc+xWJcJdyIBVRU=;
        b=f8WXT5aY5wZdRpik55tMo4sDrc37aLh+UbITyfWNEiCXAwtfUoQ6bRdzqmXreqSQRL
         F10/RTsnkK2bE5COCi/kVmCZaanG9r01vlDydnYFU9HQ6YzwoJPJi68oyCOlBbFYN4jD
         GQ/s9ztPDnUxx8jv+bDsZ2squfIMJX+mD8Irq9gkn+ZdtL89dxoOW1n4r4j75dOAcZo3
         RC3yd+J2FOh/M8fjFkA7e+V5/NNgfzKoq6j63OEIb78gIVkK7eFmNr/0/F8EvQulBz7t
         eLEPdopQffXGnJiBSwCwqcgjU6/lANWiQKsWjGOhfGlAzuIxvIPC8InKOWF3MnZ1Xf/D
         18QQ==
X-Gm-Message-State: APjAAAWpTjq2hsEKLZCTTR4OcS4J7um4nMtne/pFcYX+Z1Fd9411fex1
        C4wZWq5aZbctWNA2C19nBZxnHA==
X-Google-Smtp-Source: APXvYqxDwbqMowdTxUGOO/zJ1b5eZ6/+R1PBgjWPGyp7OZCh+kRuXlsNV/ubjRsD+DSZFNBVLs9Lcw==
X-Received: by 2002:a1c:988a:: with SMTP id a132mr108312390wme.165.1564576328381;
        Wed, 31 Jul 2019 05:32:08 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:91e7:65e:d8cd:fdb3? ([2001:b07:6468:f312:91e7:65e:d8cd:fdb3])
        by smtp.gmail.com with ESMTPSA id b8sm62042864wrr.43.2019.07.31.05.32.07
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 05:32:07 -0700 (PDT)
Subject: Re: [Qemu-devel] [PATCH 3/3] i386/kvm: initialize struct at full
 before ioctl call
To:     Christophe de Dinechin <dinechin@redhat.com>, qemu-devel@nongnu.org
Cc:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        Andrey Shinkevich <andrey.shinkevich@virtuozzo.com>,
        qemu-block@nongnu.org, vsementsov@virtuozzo.com, berto@igalia.com,
        ehabkost@redhat.com, kvm@vger.kernel.org, mtosatti@redhat.com,
        mdroth@linux.vnet.ibm.com, armbru@redhat.com, den@openvz.org,
        rth@twiddle.net
References: <1564502498-805893-1-git-send-email-andrey.shinkevich@virtuozzo.com>
 <1564502498-805893-4-git-send-email-andrey.shinkevich@virtuozzo.com>
 <7a78ef04-4120-20d9-d5f4-6572c5676344@redhat.com>
 <dc9c2e70-c2a6-838e-f191-1c2787e244f5@de.ibm.com> <m136imo9ps.fsf@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <038487b3-0b39-0695-7ef7-ede1b3143ad1@redhat.com>
Date:   Wed, 31 Jul 2019 14:32:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <m136imo9ps.fsf@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/07/19 11:05, Christophe de Dinechin wrote:
> 
> Christian Borntraeger writes:
> 
>> On 30.07.19 18:44, Philippe Mathieu-Daudé wrote:
>>> On 7/30/19 6:01 PM, Andrey Shinkevich wrote:
>>>> Not the whole structure is initialized before passing it to the KVM.
>>>> Reduce the number of Valgrind reports.
>>>>
>>>> Signed-off-by: Andrey Shinkevich <andrey.shinkevich@virtuozzo.com>
>>>> ---
>>>>  target/i386/kvm.c | 3 +++
>>>>  1 file changed, 3 insertions(+)
>>>>
>>>> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
>>>> index dbbb137..ed57e31 100644
>>>> --- a/target/i386/kvm.c
>>>> +++ b/target/i386/kvm.c
>>>> @@ -190,6 +190,7 @@ static int kvm_get_tsc(CPUState *cs)
>>>>          return 0;
>>>>      }
>>>>
>>>> +    memset(&msr_data, 0, sizeof(msr_data));
>>>
>>> I wonder the overhead of this one...
>>
>> Cant we use designated initializers like in
>>
>> commit bdfc8480c50a53d91aa9a513d23a84de0d5fbc86
>> Author:     Christian Borntraeger <borntraeger@de.ibm.com>
>> AuthorDate: Thu Oct 30 09:23:41 2014 +0100
>> Commit:     Paolo Bonzini <pbonzini@redhat.com>
>> CommitDate: Mon Dec 15 12:21:01 2014 +0100
>>
>>     valgrind/i386: avoid false positives on KVM_SET_XCRS ioctl
>>
>> and others?
>>
>> This should minimize the impact.
> 
> Oh, when you talked about using designated initializers, I thought you
> were talking about fully initializing the struct, like so:

Yeah, that would be good too.  For now I'm applying Andrey's series though.

Paolo

> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index dbbb13772a..3533870c43 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -180,19 +180,20 @@ static int kvm_get_tsc(CPUState *cs)
>  {
>      X86CPU *cpu = X86_CPU(cs);
>      CPUX86State *env = &cpu->env;
> -    struct {
> -        struct kvm_msrs info;
> -        struct kvm_msr_entry entries[1];
> -    } msr_data;
>      int ret;
> 
>      if (env->tsc_valid) {
>          return 0;
>      }
> 
> -    msr_data.info.nmsrs = 1;
> -    msr_data.entries[0].index = MSR_IA32_TSC;
> -    env->tsc_valid = !runstate_is_running();
> +    struct {
> +        struct kvm_msrs info;
> +        struct kvm_msr_entry entries[1];
> +    } msr_data = {
> +        .info = { .nmsrs =  1 },
> +        .entries = { [0] = { .index = MSR_IA32_TSC } }
> +    };
> +     env->tsc_valid = !runstate_is_running();
> 
>      ret = kvm_vcpu_ioctl(CPU(cpu), KVM_GET_MSRS, &msr_data);
>      if (ret < 0) {
> 
> 
> This gives the compiler maximum opportunities to flag mistakes like
> initializing the same thing twice, and make it easier (read no smart
> optimizations) to initialize in one go. Moving the declaration past the
> 'if' also addresses Philippe's concern.
> 
>>>
>>>>      msr_data.info.nmsrs = 1;
>>>>      msr_data.entries[0].index = MSR_IA32_TSC;
>>>>      env->tsc_valid = !runstate_is_running();
>>>> @@ -1706,6 +1707,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
>>>>
>>>>      if (has_xsave) {
>>>>          env->xsave_buf = qemu_memalign(4096, sizeof(struct kvm_xsave));
>>>> +        memset(env->xsave_buf, 0, sizeof(struct kvm_xsave));
>>>
>>> OK
>>>
>>>>      }
>>>>
>>>>      max_nested_state_len = kvm_max_nested_state_length();
>>>> @@ -3477,6 +3479,7 @@ static int kvm_put_debugregs(X86CPU *cpu)
>>>>          return 0;
>>>>      }
>>>>
>>>> +    memset(&dbgregs, 0, sizeof(dbgregs));
>>>
>>> OK
>>>
>>>>      for (i = 0; i < 4; i++) {
>>>>          dbgregs.db[i] = env->dr[i];
>>>>      }
>>>
>>> We could remove 'dbgregs.flags = 0;'
>>>
>>> Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>>>
> 
> 
> --
> Cheers,
> Christophe de Dinechin (IRC c3d)
> 

