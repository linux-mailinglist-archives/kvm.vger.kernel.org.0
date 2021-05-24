Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65DF338F1B5
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 18:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbhEXQpU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 12:45:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27283 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233221AbhEXQpO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 12:45:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621874624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vcth5UsWgCfWbdFHz62Z3n8fsQh6ne5LntM4pOozgOA=;
        b=U3yyhoXEfB8sIlGEwJ43uIZC4wwfIIslHjU50mnNxhrK6AkZZQ8g8Rkc8pPI9sQdSwaEbR
        BMwIfZyXQUIfC4RErPphcaDVDF9YVwqdS8RynGUM46YmETHj/WISpepAvX3ojLD7eSI2H2
        gAs7LkzUzz2VW51W5KYxFCd0tv/gdJE=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-2wZW42UENViSBNTrH1qEbw-1; Mon, 24 May 2021 12:43:43 -0400
X-MC-Unique: 2wZW42UENViSBNTrH1qEbw-1
Received: by mail-ed1-f69.google.com with SMTP id u14-20020a05640207ceb029038d4bfbf3a6so12313797edy.9
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 09:43:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vcth5UsWgCfWbdFHz62Z3n8fsQh6ne5LntM4pOozgOA=;
        b=eMAklpRyOWj34kFR3i6G214oF2sNRNw5+gKFga8VLXvKV0H5siPugNr1w+zvmoCOw9
         6URRNGQZh3WsDh/6eRwlFRfT5WiVDcX9Iupf0Jehob72gX9/m/pq3tEuDSX/dln1jfva
         RjyoZp3vvye+tp/BFkVoLsvLmCvvqZRqjlMfZZAgvt1kV2hINbK0fE2/QQwpX9FAT9qM
         ZcoZQUr7ucDJirX0ZJMUqO6oeDh+tvsDD7SlHjgTadvVREBW1F68cPL+iu7haZWLKKxD
         5HPfAaUu9acSOk0kv2F6AngKuCfKOE4wag9c7CTh0SSUduXJU95QlKMG1aCDRmPXilXF
         OStA==
X-Gm-Message-State: AOAM5301b8okNyOV9nZnQ9lt6ys8RuK5jPJdVTGE8CxVcCIoKKUpA7sK
        20fmxGgCZgmrjwjVBCOY/7+eQRZ5GH+KTNXj30Tu3ODXAy8mvEzFkYi+O7zH76TwGAM6W6GSE3k
        SaV7yItb1oV8T
X-Received: by 2002:a17:906:8690:: with SMTP id g16mr24334877ejx.315.1621874621705;
        Mon, 24 May 2021 09:43:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxEyVxSlXRjC/u737IyTMWWEOyWsQ5h3ibesNGEzKJ2cPqfc3HmVspL6+VB3N/KvPukfzS2KA==
X-Received: by 2002:a17:906:8690:: with SMTP id g16mr24334859ejx.315.1621874621473;
        Mon, 24 May 2021 09:43:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id v24sm9481269eds.19.2021.05.24.09.43.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 09:43:40 -0700 (PDT)
Subject: Re: [PATCH 02/12] KVM: x86: Wake up a vCPU when
 kvm_check_nested_events fails
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Oliver Upton <oupton@google.com>
References: <20210520230339.267445-1-jmattson@google.com>
 <20210520230339.267445-3-jmattson@google.com>
 <10d51d46-8b60-e147-c590-62a68f26f616@redhat.com>
 <CALMp9eQ0LQoesyRYA+PN=nzjLDVXjpNw6OxgupmL8vOgWqjiMA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e2ed4a75-e7d2-e391-0a19-5977bf087cdf@redhat.com>
Date:   Mon, 24 May 2021 18:43:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CALMp9eQ0LQoesyRYA+PN=nzjLDVXjpNw6OxgupmL8vOgWqjiMA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/05/21 18:39, Jim Mattson wrote:
> Without this patch, the accompanying selftest never wakes up from HLT
> in L2. If you can get the selftest to work without this patch, feel
> free to drop it.

Ok, that's a pretty good reason.  I'll try to debug it.

Paolo

> On Mon, May 24, 2021 at 8:43 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 21/05/21 01:03, Jim Mattson wrote:
>>> At present, there are two reasons why kvm_check_nested_events may
>>> return a non-zero value:
>>>
>>> 1) we just emulated a shutdown VM-exit from L2 to L1.
>>> 2) we need to perform an immediate VM-exit from vmcs02.
>>>
>>> In either case, transition the vCPU to "running."
>>>
>>> Signed-off-by: Jim Mattson <jmattson@google.com>
>>> Reviewed-by: Oliver Upton <oupton@google.com>
>>> ---
>>>    arch/x86/kvm/x86.c | 4 ++--
>>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index d517460db413..d3fea8ea3628 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -9468,8 +9468,8 @@ static inline int vcpu_block(struct kvm *kvm, struct kvm_vcpu *vcpu)
>>>
>>>    static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
>>>    {
>>> -     if (is_guest_mode(vcpu))
>>> -             kvm_check_nested_events(vcpu);
>>> +     if (is_guest_mode(vcpu) && kvm_check_nested_events(vcpu))
>>> +             return true;
>>
>> That doesn't make the vCPU running.  You still need to go through
>> vcpu_block, which would properly update the vCPU's mp_state.
>>
>> What is this patch fixing?
>>
>> Paolo
>>
>>>        return (vcpu->arch.mp_state == KVM_MP_STATE_RUNNABLE &&
>>>                !vcpu->arch.apf.halted);
>>>
>>
> 

