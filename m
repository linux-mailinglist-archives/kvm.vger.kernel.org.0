Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA8737AEE6
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 20:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbhEKS57 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 14:57:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39955 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231864AbhEKS56 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 14:57:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620759410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wFkkbYCZo1giPpX/66sSfgPGZd0thaWCB/6x9tKyjrU=;
        b=Q0hGjiTiGDvCf0Vih60v62y2uheCeg+tU6RaTxcHVNXx/2QiChHMTgVSi7l/P1EKGqv5KT
        AJQLrbyz5itPMrREJf/CsWsQvFZHtXIx+rBh4/vKm1zSbq3VZYEb7TsiLeJWYjLSbTIf4r
        dzJ37u08GkUUH4A/I4tDVrUyv0jrpz0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-hjFoXOP_PlGeNoZ96O23sA-1; Tue, 11 May 2021 14:56:47 -0400
X-MC-Unique: hjFoXOP_PlGeNoZ96O23sA-1
Received: by mail-ed1-f70.google.com with SMTP id bm3-20020a0564020b03b0290387c8b79486so11409317edb.20
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 11:56:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=wFkkbYCZo1giPpX/66sSfgPGZd0thaWCB/6x9tKyjrU=;
        b=E7mXZSq5P7zxdihTS1JP1Iw73TroYAGUHyLL5DW/iGqhwb5WD8qnsBZLQa4ghDept4
         nZ+55q3qSV2K4QU2GWrVTfj1VBXWagEg3cUAmK3iDquor1SQDZ9gMv5cwl6DcK8Dv8Hs
         4L1xbOd+BYDFzpIQScQhfzkLQr4qeDqM2LDb9/qwdXn8rz5oWYw842J0AFnl5k3RKNyf
         ylZ9J5qPiIotEUVKZqk4h3f+eurg1NZxUgy5cKnF1efXNwDTnAKWbx07AJqFeeM2AaCq
         Ns5PXAF417/ngiQAox+Zqu4gCcWqGe2WaR5Ao22ihCzwFoCheSoLeQt2rS51yh/juYrk
         u69g==
X-Gm-Message-State: AOAM530ij0FFldWuI0xNb1BWjdUWFThzV3Y30tzhkVfYXusjUgneLKz7
        Fo5qc59FbgTQQEgDBe5jfvIBKKrHsURIJwfmzT2eQlTgl1CU0H7y6xRnh5+C8v9Ms7wsHXRZZTP
        hXEmBhq954qKq
X-Received: by 2002:a50:cdd1:: with SMTP id h17mr37939620edj.178.1620759405866;
        Tue, 11 May 2021 11:56:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzWXSLE3cFuMP6/lndEcrzy/s8nluFRQk7CGoFU7s22O0Mbr7C1CUvhRVVGWwjzcvm+bTWPxQ==
X-Received: by 2002:a50:cdd1:: with SMTP id h17mr37939599edj.178.1620759405629;
        Tue, 11 May 2021 11:56:45 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c6329.dip0.t-ipconnect.de. [91.12.99.41])
        by smtp.gmail.com with ESMTPSA id pw11sm12232276ejb.88.2021.05.11.11.56.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 May 2021 11:56:45 -0700 (PDT)
Subject: Re: [PATCH v4 2/7] KVM: x86/mmu: Factor out allocating memslot rmap
To:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
References: <20210511171610.170160-1-bgardon@google.com>
 <20210511171610.170160-3-bgardon@google.com> <YJrFOXW3mM3WjGT5@google.com>
 <CANgfPd9ekAidRzAWi-i=7h0pUpoHADSFJdAB5AWAzwm_Uk3dSA@mail.gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <47ba1a62-9035-08c6-22c3-acae9bdd3572@redhat.com>
Date:   Tue, 11 May 2021 20:56:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CANgfPd9ekAidRzAWi-i=7h0pUpoHADSFJdAB5AWAzwm_Uk3dSA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11.05.21 20:17, Ben Gardon wrote:
> On Tue, May 11, 2021 at 10:56 AM Sean Christopherson <seanjc@google.com> wrote:
>>
>> On Tue, May 11, 2021, Ben Gardon wrote:
>>> Small refactor to facilitate allocating rmaps for all memslots at once.
>>>
>>> No functional change expected.
>>>
>>> Signed-off-by: Ben Gardon <bgardon@google.com>
>>> ---
>>>   arch/x86/kvm/x86.c | 39 ++++++++++++++++++++++++++++++---------
>>>   1 file changed, 30 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 1e1f4f31e586..cc0440b5b35d 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -10911,10 +10911,35 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
>>>        kvm_page_track_free_memslot(slot);
>>>   }
>>>
>>> +static int memslot_rmap_alloc(struct kvm_memory_slot *slot,
>>> +                           unsigned long npages)
>>> +{
>>> +     int i;
>>> +
>>> +     for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
>>> +             int lpages;
>>> +             int level = i + 1;
>>> +
>>> +             lpages = gfn_to_index(slot->base_gfn + npages - 1,
>>> +                                   slot->base_gfn, level) + 1;
>>
>> Might as well assign lpages at its declaration, i.e.
>>
>>                  int lpages = gfn_to_index(slot->base_gfn + npages - 1,
>>                                            slot->base_gfn, level) + 1;
> 
> I'll do this if I end up sending out a v5.
> 
>>> +
>>> +             slot->arch.rmap[i] =
>>> +                     kvcalloc(lpages, sizeof(*slot->arch.rmap[i]),
>>> +                              GFP_KERNEL_ACCOUNT);
>>
>> Eh, I don't think avoiding a 3 char overrun is worth splitting across three lines.
>> E.g. this is perfectly readable
>>
>>                  slot->arch.rmap[i] = kvcalloc(lpages, sizeof(*slot->arch.rmap[i]),
>>                                                GFP_KERNEL_ACCOUNT);
>>
>> Alternatively, the rmap size could be captured in a local var, e.g.
>>
>>          const int sz = sizeof(*slot->arch.rmap[0]);
>>
>>          ...
>>
>>                  slot->arch.rmap[i] = kvcalloc(lpages, sz, GFP_KERNEL_ACCOUNT);
> 
> I like this suggestion. Much nicer. Will incorporate if I send a v5.
> 
>>                  if (!slot->arch.rmap[i]) {
>>                          memslot_rmap_free(slot);
>>                          return -ENOMEM;
>>                  }
>>
>>> +             if (!slot->arch.rmap[i]) {
>>> +                     memslot_rmap_free(slot);
>>> +                     return -ENOMEM;
>>
>> Reaaaally getting into nitpicks, what do you think about changing this to a goto
>> with the error handling at the bottom?  Obviously not necessary by any means,
>> but for me it makes it easier to see that all rmaps are freed on failure.  My
>> eyes skipped over that on the first read through.  E.g.
>>
>>                  if (!slot_arch.rmap[i])
>>                          goto err;
>>          }
>>
>>          return 0;
>>
>> err:
>>          memslot_rmap_free(slot);
>>          return -ENOMEM;
>>
> 
> Lol, I had a goto in v3, but David Hildenbrand suggested removing it
> and putting the free in the loop. I think I like it more this way too.

No strong opinion, I tend to stick to 
Documentation/process/coding-style.rst which states

"The goto statement comes in handy when a function exits from multiple 
locations and some common work such as cleanup has to be done."

As we only have a single error exit and no complicated locking, at least 
for me the "goto" makes it unnecessary hard to read.


-- 
Thanks,

David / dhildenb

