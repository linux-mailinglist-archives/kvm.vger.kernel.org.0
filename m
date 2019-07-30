Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4559A7AF68
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 19:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729883AbfG3RO3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 13:14:29 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46485 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729835AbfG3RO2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 13:14:28 -0400
Received: by mail-wr1-f67.google.com with SMTP id z1so66593940wru.13
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 10:14:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jaUSv3VJf+V+ChRyECDPLwYXei53onF28jWtYlsjjZQ=;
        b=XlgsRlzm3QlzZkdB6FBPusu6lxckMGT0OAHTMnNDj3odVu8RyGZEwK172UJvMuq+CY
         hYvJ5Yilobia7MzytNrUC0dCo2XUNETQLwBGezm48SkhXLF+eqi6MFvvabwSJcRKoSPl
         2dab3X5K4yFX0J8BP7JsotDRDiEmn89TGOZ0XzIPMcERC4bxb0TXy5miUGRwvpCO13b3
         0e8N5qJMlrlOQLSBcrgAt8ucYj4kq8uIAtXpebBYmg8IqMX6k8XYCzZEdbp79KcO57mD
         0R1jNhaZ68dFiWNKUpO3zelyMhYHATU9m61TOKzrr5We8V/IL8lSrr8Dwb1n1bvn7HIi
         KOdg==
X-Gm-Message-State: APjAAAXKNAPrc23z50sSWJ/7NlcSAMZgie/0bcwOsaLERaogrJf3++HB
        KezB/+b/mFkkIC/afNxz5OoYjg==
X-Google-Smtp-Source: APXvYqyw/SCjqRuMPPC/CHN26txaGhj5ZA2OGT6qHfR/E/Xs0s0/5e9orcuDBRjt7xAFlaqJmkfoxQ==
X-Received: by 2002:adf:e444:: with SMTP id t4mr27910270wrm.262.1564506866578;
        Tue, 30 Jul 2019 10:14:26 -0700 (PDT)
Received: from [192.168.43.238] (63.red-95-127-155.staticip.rima-tde.net. [95.127.155.63])
        by smtp.gmail.com with ESMTPSA id c11sm110206849wrq.45.2019.07.30.10.14.24
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 10:14:26 -0700 (PDT)
Subject: Re: [Qemu-devel] [PATCH 3/3] i386/kvm: initialize struct at full
 before ioctl call
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Andrey Shinkevich <andrey.shinkevich@virtuozzo.com>,
        qemu-devel@nongnu.org, qemu-block@nongnu.org
Cc:     vsementsov@virtuozzo.com, berto@igalia.com, ehabkost@redhat.com,
        kvm@vger.kernel.org, mtosatti@redhat.com,
        mdroth@linux.vnet.ibm.com, armbru@redhat.com, den@openvz.org,
        pbonzini@redhat.com, rth@twiddle.net
References: <1564502498-805893-1-git-send-email-andrey.shinkevich@virtuozzo.com>
 <1564502498-805893-4-git-send-email-andrey.shinkevich@virtuozzo.com>
 <7a78ef04-4120-20d9-d5f4-6572c5676344@redhat.com>
 <dc9c2e70-c2a6-838e-f191-1c2787e244f5@de.ibm.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Openpgp: id=89C1E78F601EE86C867495CBA2A3FD6EDEADC0DE;
 url=http://pgp.mit.edu/pks/lookup?op=get&search=0xA2A3FD6EDEADC0DE
Message-ID: <e78f8ce4-3dcf-61b1-1eec-bd28f6ba9b4c@redhat.com>
Date:   Tue, 30 Jul 2019 19:14:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <dc9c2e70-c2a6-838e-f191-1c2787e244f5@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/30/19 7:05 PM, Christian Borntraeger wrote:
> On 30.07.19 18:44, Philippe Mathieu-Daudé wrote:
>> On 7/30/19 6:01 PM, Andrey Shinkevich wrote:
>>> Not the whole structure is initialized before passing it to the KVM.
>>> Reduce the number of Valgrind reports.
>>>
>>> Signed-off-by: Andrey Shinkevich <andrey.shinkevich@virtuozzo.com>
>>> ---
>>>  target/i386/kvm.c | 3 +++
>>>  1 file changed, 3 insertions(+)
>>>
>>> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
>>> index dbbb137..ed57e31 100644
>>> --- a/target/i386/kvm.c
>>> +++ b/target/i386/kvm.c
>>> @@ -190,6 +190,7 @@ static int kvm_get_tsc(CPUState *cs)
>>>          return 0;
>>>      }
>>>  
>>> +    memset(&msr_data, 0, sizeof(msr_data));
>>
>> I wonder the overhead of this one...
> 
> Cant we use designated initializers like in
> 
> commit bdfc8480c50a53d91aa9a513d23a84de0d5fbc86
> Author:     Christian Borntraeger <borntraeger@de.ibm.com>
> AuthorDate: Thu Oct 30 09:23:41 2014 +0100
> Commit:     Paolo Bonzini <pbonzini@redhat.com>
> CommitDate: Mon Dec 15 12:21:01 2014 +0100
> 
>     valgrind/i386: avoid false positives on KVM_SET_XCRS ioctl
> 
> and others?

Is the compiler smart enough to figure out it doesn't need to zeroes in
case env->tsc_valid is true and the function returns?

> 
> This should minimize the impact. 
>>
>>>      msr_data.info.nmsrs = 1;
>>>      msr_data.entries[0].index = MSR_IA32_TSC;
>>>      env->tsc_valid = !runstate_is_running();
>>> @@ -1706,6 +1707,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
>>>  
>>>      if (has_xsave) {
>>>          env->xsave_buf = qemu_memalign(4096, sizeof(struct kvm_xsave));
>>> +        memset(env->xsave_buf, 0, sizeof(struct kvm_xsave));
>>
>> OK
>>
>>>      }
>>>  
>>>      max_nested_state_len = kvm_max_nested_state_length();
>>> @@ -3477,6 +3479,7 @@ static int kvm_put_debugregs(X86CPU *cpu)
>>>          return 0;
>>>      }
>>>  
>>> +    memset(&dbgregs, 0, sizeof(dbgregs));
>>
>> OK
>>
>>>      for (i = 0; i < 4; i++) {
>>>          dbgregs.db[i] = env->dr[i];
>>>      }
>>
>> We could remove 'dbgregs.flags = 0;'
>>
>> Reviewed-by: Philippe Mathieu-Daudé <philmd@redhat.com>
>>
> 
