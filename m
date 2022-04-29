Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 447DD514FB7
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 17:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232880AbiD2Plo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 11:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378623AbiD2Plk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 11:41:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 117A0D64EF
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 08:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651246701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e3GYcpOojaqfVy2K7vrzPLMAfbwyhOtRZmNsdxKjVOA=;
        b=Z3r/XcTkBSvpw/kn/R0GvRK79xhmgjKl0QHRKc0HdQmMANFJ4VLczTOpZza8JEI5/2jDdo
        NPEP30iAl2coWf9pdAuIwc3fmtMZO8RXX1KD0QMGf8467PFH14ud6vnuBbel4gtnAOCw0v
        JkhOgogD02wSyJ65CW8m/CDZLYomepY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-670-c2QPZGnrPqu6PV81z1Vt6g-1; Fri, 29 Apr 2022 11:38:19 -0400
X-MC-Unique: c2QPZGnrPqu6PV81z1Vt6g-1
Received: by mail-ed1-f71.google.com with SMTP id ee56-20020a056402293800b00425b0f5b9c6so4689280edb.9
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 08:38:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=e3GYcpOojaqfVy2K7vrzPLMAfbwyhOtRZmNsdxKjVOA=;
        b=qoOLbdFTZ911mH/ul4hQ/kg3N7ohV9Xm5F+kqP4VwcRK0wcR3zieJGkecV6puzFg2v
         NJ8qWl0z8tcuwcWpFjYieMjP2FA5lAZ7NuFaExfCjt5UQk19OtKbqkam8iSSfqCIciwq
         dZKEur81TqxmDG9z3HBQNG3OdvetqpujLPS1hWJENela/KyTeQ80XbxVBTcVg5lqQBpy
         wID3wPICejpoRepKUAZMKV6Aq2yk+NUtS5CeHbdwg+6r8NsbxRrYkucicdTy9w7UvwIT
         CT2Rj4A9wYvpI/6hFOaNP2GrRiqe7T8J8EZrDdUphrThPUHcLbhWhaqqwkM2v+4n22/L
         msSQ==
X-Gm-Message-State: AOAM531jWp4tVEcCFD16LWqAffU1f+waA2Tjqq88ndWugBu/6ORNKFcI
        iBHI19z6p+03gtKvOAtR7waSsgrHmosp6Mt/93Q54WwJmK8eIS3fwj9KVAgfqZfYqoieNdveu5c
        0euPNZjpxBrws
X-Received: by 2002:a17:907:98cf:b0:6f3:9901:bc0c with SMTP id kd15-20020a17090798cf00b006f39901bc0cmr23127466ejc.315.1651246698340;
        Fri, 29 Apr 2022 08:38:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyLR3xV5xpFYGWw5Pcst42tVEU4k8S2SinV33HC8H1oNUJT5vVQOADZfzCSBssj0PbwVnmH0g==
X-Received: by 2002:a17:907:98cf:b0:6f3:9901:bc0c with SMTP id kd15-20020a17090798cf00b006f39901bc0cmr23127445ejc.315.1651246698103;
        Fri, 29 Apr 2022 08:38:18 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id de29-20020a1709069bdd00b006f3ef214e38sm726978ejc.158.2022.04.29.08.38.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Apr 2022 08:38:17 -0700 (PDT)
Message-ID: <8a2c5f8c-503c-b4f0-75e7-039533c9852d@redhat.com>
Date:   Fri, 29 Apr 2022 17:38:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v3] KVM: SEV: Mark nested locking of vcpu->lock
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>
Cc:     John Sperbeck <jsperbeck@google.com>,
        kvm list <kvm@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <20220407195908.633003-1-pgonda@google.com>
 <CAFNjLiXC0AdOw5f8Ovu47D==ex7F0=WN_Ocirymz4xL=mWvC5A@mail.gmail.com>
 <CAMkAt6r-Mc_YN-gVHuCpTj4E1EmcvyYpP9jhtHo5HRHnoNJAdA@mail.gmail.com>
 <CAMkAt6r+OMPWCbV_svUyGWa0qMzjj2UEG29G6P7jb6uH6yko2w@mail.gmail.com>
 <62e9ece1-5d71-f803-3f65-2755160cf1d1@redhat.com>
 <CAMkAt6q6YLBfo2RceduSXTafckEehawhD4K4hUEuB4ZNqe2kKg@mail.gmail.com>
 <4c0edc90-36a1-4f4c-1923-4b20e7bdbb4c@redhat.com>
 <CAMkAt6oL5qi7z-eh4z7z8WBhpc=Ow6WtcJA5bDi6-aGMnz135A@mail.gmail.com>
 <CAMkAt6rmDrZfN5DbNOTsKFV57PwEnK2zxgBTCbEPeE206+5v5w@mail.gmail.com>
 <0d282be4-d612-374d-84ba-067994321bab@redhat.com>
 <CAMkAt6ragq4OmnX+n628Yd5pn51qFv4qV20upGR6tTvyYw3U5A@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAMkAt6ragq4OmnX+n628Yd5pn51qFv4qV20upGR6tTvyYw3U5A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 17:35, Peter Gonda wrote:
> On Thu, Apr 28, 2022 at 5:59 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 4/28/22 23:28, Peter Gonda wrote:
>>>
>>> So when actually trying this out I noticed that we are releasing the
>>> current vcpu iterator but really we haven't actually taken that lock
>>> yet. So we'd need to maintain a prev_* pointer and release that one.
>>
>> Not entirely true because all vcpu->mutex.dep_maps will be for the same
>> lock.  The dep_map is essentially a fancy string, in this case
>> "&vcpu->mutex".
>>
>> See the definition of mutex_init:
>>
>> #define mutex_init(mutex)                                              \
>> do {                                                                   \
>>           static struct lock_class_key __key;                            \
>>                                                                          \
>>           __mutex_init((mutex), #mutex, &__key);                         \
>> } while (0)
>>
>> and the dep_map field is initialized with
>>
>>           lockdep_init_map_wait(&lock->dep_map, name, key, 0, LD_WAIT_SLEEP);
>>
>> (i.e. all vcpu->mutexes share the same name and key because they have a
>> single mutex_init-ialization site).  Lockdep is as crude in theory as it
>> is effective in practice!
>>
>>>
>>>            bool acquired = false;
>>>            kvm_for_each_vcpu(...) {
>>>                    if (!acquired) {
>>>                       if (mutex_lock_killable_nested(&vcpu->mutex, role)
>>>                           goto out_unlock;
>>>                       acquired = true;
>>>                    } else {
>>>                       if (mutex_lock_killable(&vcpu->mutex, role)
>>>                           goto out_unlock;
>>
>> This will cause a lockdep splat because it uses subclass 0.  All the
>> *_nested functions is allow you to specify a subclass other than zero.
> 
> OK got it. I now have this to lock:
> 
>           kvm_for_each_vcpu (i, vcpu, kvm) {
>                    if (prev_vcpu != NULL) {
>                            mutex_release(&prev_vcpu->mutex.dep_map, _THIS_IP_);
>                            prev_vcpu = NULL;
>                    }
> 
>                    if (mutex_lock_killable_nested(&vcpu->mutex, role))
>                            goto out_unlock;
>                    prev_vcpu = vcpu;
>            }
> 
> But I've noticed the unlocking is in the wrong order since we are
> using kvm_for_each_vcpu() I think we need a kvm_for_each_vcpu_rev() or
> something. Which maybe a bit for work:
> https://elixir.bootlin.com/linux/latest/source/lib/xarray.c#L1119.

No, you don't need any of this.  You can rely on there being only one 
depmap, otherwise you wouldn't need the mock releases and acquires at 
all.  Also the unlocking order does not matter for deadlocks, only the 
locking order does.  You're overdoing it. :)

Paolo

