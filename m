Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C266F3F2918
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 11:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236737AbhHTJ2Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 05:28:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29691 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235321AbhHTJ2Y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Aug 2021 05:28:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629451666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/u+8okw9NC3TUEzgwTlSaEbJlbpO/sr31TcVmCIG3eM=;
        b=DBHx2SlI27WlW9ojjfoOSM6wjAYkCL+Tu/so9T7tu/IqAXpYn4N+t4HojW6N+vEYNR9n0Z
        KdCda0WKDC1V6DmU5qJxGEKafDnbIMs/KzXpsdU2WNQjfASwKrfWidtbr8ZMhPP94AqdAo
        Pm3GCT5FC7HISpupfkcxi46BQtJ80Io=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-dQQqQHerM9eP6iYI_1MIkg-1; Fri, 20 Aug 2021 05:27:45 -0400
X-MC-Unique: dQQqQHerM9eP6iYI_1MIkg-1
Received: by mail-wm1-f69.google.com with SMTP id z18-20020a1c7e120000b02902e69f6fa2e0so1738478wmc.9
        for <kvm@vger.kernel.org>; Fri, 20 Aug 2021 02:27:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=/u+8okw9NC3TUEzgwTlSaEbJlbpO/sr31TcVmCIG3eM=;
        b=IT4m26Be8dySwtK0KKuH25hyT36wxg2Qo1mBkSOiS3x1f6PgEwB4rzQX1Eh/uwUR9C
         pHOVycv4lh3F1SidDHcBcIjVpyQj7kvoIqT31GN314JjiGU5qG0EW6Pn3Iry10Luo9yJ
         aeCXthoTfArXj643Fsnw6pbOndiHyUJbbHTqOj9MYnk1UENqsd4OErLXBHpjnc2qR0L1
         f5xeynqeStRghkmaTg7yaERQrCZSX7ExOqMohNRof6jBxxlqPvD8EOKNuJgISllMVm1I
         bWdWdXsOFyZUYfgfV6XlZUmOyzBfVSaxXLr93gx0+IC8jmz1cKXoRRGiWMVRbHf+R6Jy
         kKRA==
X-Gm-Message-State: AOAM533M0O7ZuIivs5eg4t9TPiFIAzqR3x65ZKHVKFduJ5Niol+5Y3yn
        k8dXY0HEXYgER55vg8Og+IO/npgJI1n0xFr54WW4Oyqr7IwdqzzsqCyJqj2/7nTdra9o7JUBgVc
        DWhd/iD1EwQXr
X-Received: by 2002:a7b:c7c3:: with SMTP id z3mr2877115wmk.96.1629451664153;
        Fri, 20 Aug 2021 02:27:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwrv/MO6I4VJiNFhu/exeX4GinBGO52T7kneA302ioQqlyE7/IysNBUL0jrYV0CaHBwzkxm4w==
X-Received: by 2002:a7b:c7c3:: with SMTP id z3mr2877101wmk.96.1629451663998;
        Fri, 20 Aug 2021 02:27:43 -0700 (PDT)
Received: from ?IPv6:2003:d8:2f0a:7f00:fad7:3bc9:69d:31f? (p200300d82f0a7f00fad73bc9069d031f.dip0.t-ipconnect.de. [2003:d8:2f0a:7f00:fad7:3bc9:69d:31f])
        by smtp.gmail.com with ESMTPSA id c7sm4478795wmq.13.2021.08.20.02.27.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Aug 2021 02:27:43 -0700 (PDT)
Subject: Re: [PATCH v4 06/13] KVM: Move WARN on invalid memslot index to
 update_memslots()
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <cover.1628871411.git.maciej.szmigiero@oracle.com>
 <8db0f1d1901768b5de1417caa425e62d1118e5e8.1628871413.git.maciej.szmigiero@oracle.com>
 <957c6b3d-9621-a5a5-418c-f61f87a32ee0@redhat.com>
 <fa71d652-8b7f-e0d7-5617-8958e3e78f6e@maciej.szmigiero.name>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <633bf50b-5de4-1e76-736c-067d10bf92b3@redhat.com>
Date:   Fri, 20 Aug 2021 11:27:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <fa71d652-8b7f-e0d7-5617-8958e3e78f6e@maciej.szmigiero.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18.08.21 23:43, Maciej S. Szmigiero wrote:
> On 18.08.2021 16:35, David Hildenbrand wrote:
>> On 13.08.21 21:33, Maciej S. Szmigiero wrote:
>>> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
>>>
>>> Since kvm_memslot_move_forward() can theoretically return a negative
>>> memslot index even when kvm_memslot_move_backward() returned a positive one
>>> (and so did not WARN) let's just move the warning to the common code.
>>>
>>> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>>> ---
>>>    virt/kvm/kvm_main.c | 6 ++++--
>>>    1 file changed, 4 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>>> index 03ef42d2e421..7000efff1425 100644
>>> --- a/virt/kvm/kvm_main.c
>>> +++ b/virt/kvm/kvm_main.c
>>> @@ -1293,8 +1293,7 @@ static inline int kvm_memslot_move_backward(struct kvm_memslots *slots,
>>>        struct kvm_memory_slot *mslots = slots->memslots;
>>>        int i;
>>> -    if (WARN_ON_ONCE(slots->id_to_index[memslot->id] == -1) ||
>>> -        WARN_ON_ONCE(!slots->used_slots))
>>> +    if (slots->id_to_index[memslot->id] == -1 || !slots->used_slots)
>>>            return -1;
>>>        /*
>>> @@ -1398,6 +1397,9 @@ static void update_memslots(struct kvm_memslots *slots,
>>>                i = kvm_memslot_move_backward(slots, memslot);
>>>            i = kvm_memslot_move_forward(slots, memslot, i);
>>> +        if (WARN_ON_ONCE(i < 0))
>>> +            return;
>>> +
>>>            /*
>>>             * Copy the memslot to its new position in memslots and update
>>>             * its index accordingly.
>>>
>>
>>
>> Note that WARN_ON_* is frowned upon, because it can result in crashes with panic_on_warn enabled, which is what some distributions do enable.
>>
>> We tend to work around that by using pr_warn()/pr_warn_once(), avoiding eventually crashing the system when there is a way to continue.
>>
> 
> This patch uses WARN_ON_ONCE because:
> 1) It was used in the old code and the patch merely moves the check
> from kvm_memslot_move_backward() to its caller,
> 
> 2) This chunk of code is wholly replaced by patch 11 from this series
> anyway ("Keep memslots in tree-based structures instead of array-based ones").

Okay, that makes sense then, thanks!

-- 
Thanks,

David / dhildenb

