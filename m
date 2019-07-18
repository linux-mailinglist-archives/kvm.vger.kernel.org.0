Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F38456CAF1
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 10:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726972AbfGRIeI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 04:34:08 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50627 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbfGRIeI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 04:34:08 -0400
Received: by mail-wm1-f68.google.com with SMTP id v15so24697474wml.0
        for <kvm@vger.kernel.org>; Thu, 18 Jul 2019 01:34:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oyQnxgvW48MflIIGvDKgphM3U+A4nQhpaY8n8J3JEU8=;
        b=LrEM2k12zapBLuTzpIfK/OSUM7YkM+Fxo4J+TrF1mcc2O/9ET7sLiU7/9EYLfhu30a
         s/3OoY0jhZ8wgFXqpwykmoPFDOb+f1ANlfBr0i1flfmdV3ZilHdsyWylB3FIkAbHHSKw
         k6c2oYRlN4dsmvOi20jMvEAYYi1I4tgzeTCVSKuHZg/SNz9ChVVT53iOBg5FVD+a6Z1M
         NTSIVcE90sHT8RgeBfR9lGcpNU1jDI2NY4LDZ/I/O2CXTDRF7gEAhGa4/FOoJgeNop1N
         6OXVQraK6jdP8ztzQ1d3j+oENCf6omr5cYLlr29iqE9UVXEdlXkyYi2Beh6FQZxL9J/t
         ZePg==
X-Gm-Message-State: APjAAAWo5KFuiDmhDx1QV9HsU59Glh7Y9Zz9O0VmNqxiYuZLBKveJkUx
        boOa6tpzVWZhLhT6LJHc97UJ7Q==
X-Google-Smtp-Source: APXvYqxkdaslaXuIOrStTxZXg88Np8F8FRCcSBEQh5L+2SsEztfofLT+uhyL1VDV8EDLffiZ4NpMUg==
X-Received: by 2002:a1c:44d7:: with SMTP id r206mr42116191wma.164.1563438846134;
        Thu, 18 Jul 2019 01:34:06 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e427:3beb:1110:dda2? ([2001:b07:6468:f312:e427:3beb:1110:dda2])
        by smtp.gmail.com with ESMTPSA id p18sm24776435wrm.16.2019.07.18.01.34.05
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 01:34:05 -0700 (PDT)
Subject: Re: [PATCH RESEND] KVM: Boosting vCPUs that are delivering interrupts
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <1562915730-9490-1-git-send-email-wanpengli@tencent.com>
 <f95fbf72-090f-fb34-3c20-64508979f251@redhat.com>
 <db74a3a8-290e-edff-10ad-f861c60fbf8e@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <e31024e4-f437-becd-a9e3-e1ea8cd2e0c7@redhat.com>
Date:   Thu, 18 Jul 2019 10:34:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <db74a3a8-290e-edff-10ad-f861c60fbf8e@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/07/19 10:15, Christian Borntraeger wrote:
> 
> 
> On 18.07.19 09:59, Paolo Bonzini wrote:
>> On 12/07/19 09:15, Wanpeng Li wrote:
>>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>>> index b4ab59d..2c46705 100644
>>> --- a/virt/kvm/kvm_main.c
>>> +++ b/virt/kvm/kvm_main.c
>>> @@ -2404,8 +2404,10 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
>>>  	int me;
>>>  	int cpu = vcpu->cpu;
>>>  
>>> -	if (kvm_vcpu_wake_up(vcpu))
>>> +	if (kvm_vcpu_wake_up(vcpu)) {
>>> +		vcpu->preempted = true;
>>>  		return;
>>> +	}
>>>  
>>>  	me = get_cpu();
>>>  	if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
>>>
>>
>> Who is resetting vcpu->preempted to false in this case?  This also
>> applies to s390 in fact.
> 
> Isnt that done by the sched_in handler?

I am a bit confused because, if it is done by the sched_in later, I
don't understand why the sched_out handler hasn't set vcpu->preempted
already.

The s390 commit message is not very clear, but it talks about "a former
sleeping cpu" that "gave up the cpu voluntarily".  Does "voluntarily"
that mean it is in kvm_vcpu_block?  But then at least for x86 it would
be after vcpu_load so the preempt notifiers have been registered, and
for s390 too (kvm_arch_vcpu_ioctl_run -> __vcpu_run -> vcpu_post_run ->
kvm_handle_sie_intercept etc.).

Paolo
