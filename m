Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737CC37314B
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 22:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbhEDUTt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 16:19:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39521 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230217AbhEDUTs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 May 2021 16:19:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620159532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QJf7ER3TDUPpx69gjjjuRZbp8LhbACyEKSP42GGHdNw=;
        b=Huq45OuJwddEpbAzCtZKTeBWSowrF2yvBSYTJQFxKEFrM1g8+dda3S87MBePDaoxWMg3cd
        bQBljwUoNajYHELugxL64RmJifGqYPDzPQPPoazYXwoKmBTFokjKJIFr4g0ZhiZ1vQmDxW
        9W9Bzo17lChxowufouQ1BvuCcQkbRno=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-iokdBH_XOpipJ_8o8ZQKow-1; Tue, 04 May 2021 16:18:50 -0400
X-MC-Unique: iokdBH_XOpipJ_8o8ZQKow-1
Received: by mail-ed1-f72.google.com with SMTP id s20-20020a0564025214b029038752a2d8f3so6967071edd.2
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 13:18:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QJf7ER3TDUPpx69gjjjuRZbp8LhbACyEKSP42GGHdNw=;
        b=fNSTlFYXAeS3ucscQalYt5eia183WFh0BTxzXpz64gVmwjhn82ZjP6Y+RSc4ByFNj5
         SrTc3fpPoNlSbnnH1IDH8wVI3f0Jc4XV9rjV2l/In9IUZHsoVLzfnRjstzX7xTE6f2dD
         uAyEiLs6qK25t0Y+spTj3hPhcpYS/rUV58/PoNqQYGZn0sag/aGdDmb+VwfzTr74joHo
         1hN3Rz0MS0A950IGrknsdKXuP2gCc426OViyAuTzE/osijMwQBMsc1b1+gWCBi5BRFKq
         Ri3E0meZTyCud7p7vbUcDajhGX4QnuPO1ZJsS9k6KG5X/R9pz6My0rUFo60HvUb4TOLl
         9dtQ==
X-Gm-Message-State: AOAM531g6hUj8guxke9LOHQfymEGBoihCLyURNow4bXKyNzxVNoPp/I6
        X519pOgV3uFjWHSkjNKiiVpPm9IYffVTW9LUTiyJ5P0FKe6Cz96RyFrnwkG+C1CEUpWs0V5xlfh
        vAp+yIgyTLXsY
X-Received: by 2002:a17:906:e105:: with SMTP id gj5mr24371332ejb.388.1620159528938;
        Tue, 04 May 2021 13:18:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxPW3cE3OvV+sifWvUG52jfXFijecUpZWkEi4GWpuQsW03z9NVNRFBAl8LL0HoXyCoYIPnvbw==
X-Received: by 2002:a17:906:e105:: with SMTP id gj5mr24371314ejb.388.1620159528740;
        Tue, 04 May 2021 13:18:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id o20sm14995116eds.65.2021.05.04.13.18.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 May 2021 13:18:48 -0700 (PDT)
To:     Ben Gardon <bgardon@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20210429211833.3361994-1-bgardon@google.com>
 <20210429211833.3361994-2-bgardon@google.com>
 <e9090079-2255-5a70-f909-89f6f65c12ed@redhat.com>
 <CANgfPd9O3d9b+WYgo+ke1Jx50=ep_f-ZC1gRqUET6PDsLxW+Gw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 1/7] KVM: x86/mmu: Track if shadow MMU active
Message-ID: <34fe30b6-0d4b-f1e8-9abd-6cb0a0765492@redhat.com>
Date:   Tue, 4 May 2021 22:18:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CANgfPd9O3d9b+WYgo+ke1Jx50=ep_f-ZC1gRqUET6PDsLxW+Gw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/05/21 19:26, Ben Gardon wrote:
> On Mon, May 3, 2021 at 6:42 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 29/04/21 23:18, Ben Gardon wrote:
>>> +void activate_shadow_mmu(struct kvm *kvm)
>>> +{
>>> +     kvm->arch.shadow_mmu_active = true;
>>> +}
>>> +
>>
>> I think there's no lock protecting both the write and the read side.
>> Therefore this should be an smp_store_release, and all checks in
>> patch 2 should be an smp_load_acquire.
> 
> That makes sense.
> 
>>
>> Also, the assignments to slot->arch.rmap in patch 4 (alloc_memslot_rmap)
>> should be an rcu_assign_pointer, while __gfn_to_rmap must be changed like so:
>>
>> +       struct kvm_rmap_head *head;
>> ...
>> -       return &slot->arch.rmap[level - PG_LEVEL_4K][idx];
>> +       head = srcu_dereference(slot->arch.rmap[level - PG_LEVEL_4K], &kvm->srcu,
>> +                                lockdep_is_held(&kvm->slots_arch_lock));
>> +       return &head[idx];
> 
> I'm not sure I fully understand why this becomes necessary after patch
> 4. Isn't it already needed since the memslots are protected by RCU? Or
> is there already a higher level rcu dereference?
> 
> __kvm_memslots already does an srcu dereference, so is there a path
> where we aren't getting the slots from that function where this is
> needed?

There are two point of views:

1) the easier one is just CONFIG_PROVE_RCU debugging: the rmaps need to 
be accessed under RCU because the memslots can disappear as soon as 
kvm->srcu is unlocked.

2) the harder one (though at this point I'm better at figuring out these 
ordering bugs than "traditional" mutex races) is what the happens before 
relation[1] looks like.  Consider what happens if the rmaps are 
allocated by *another thread* after the slots have been fetched.

thread 1		thread 2		thread 3
allocate memslots
rcu_assign_pointer
			slots = srcu_dereference
						allocate rmap
						rcu_assign_pointer
			head = slot->arch.rmap[]

Here, thread 3 is allocating the rmaps in the SRCU-protected 
kvm_memslots; those rmaps that didn't exist at the time thread 1 did the 
rcu_assign_pointer (which synchronizes with thread 2's srcu_dereference 
that retrieves slots), hence they were not covered by the release 
semantics of that rcu_assign_pointer and the "consume" semantics of the 
corresponding srcu_dereference.  Therefore, thread 2 needs another 
srcu_dereference when retrieving them.

Paolo

[1] https://lwn.net/Articles/844224/

> I wouldn't say that the rmaps are protected by RCU in any way that
> separate from the memslots.

