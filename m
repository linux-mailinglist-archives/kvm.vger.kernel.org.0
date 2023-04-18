Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28F976E5D0E
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 11:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbjDRJLK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 05:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbjDRJLC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 05:11:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0EDC4216
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 02:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681809010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qPLTBWziW54XeikbDl+0QUpnupwILDaS5ozbTyxV5Ec=;
        b=MweQ2K7V6PscW0QRL9/4CCNG15Ld72lol9xg4GoPmfuOeFxSRq+5hvXS775CwdhBIfCnBi
        eqtAA081l4ZJJEGybLSJ+/h6ezZ6by2HI6+3w7MLCTDfqnFm8AWFziWOG+/okTwpPP0G6B
        7xVVKGD7FiVQEn7uwmbattgculX7c7M=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-79-iYaHXOiAMauGdkhEH-Ywxw-1; Tue, 18 Apr 2023 05:10:09 -0400
X-MC-Unique: iYaHXOiAMauGdkhEH-Ywxw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f170a1fbe7so9904205e9.2
        for <kvm@vger.kernel.org>; Tue, 18 Apr 2023 02:10:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681809008; x=1684401008;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qPLTBWziW54XeikbDl+0QUpnupwILDaS5ozbTyxV5Ec=;
        b=HnIH0jjGhgWdtVZUkygX3zMR4T7m/cY6BPThehGpyslq8LNJa7c5wmUg3KbQW+5FTO
         ECcMN9Ul7JFjes6QdcfwfMbo4z9M8NaLWQT6+i6jAauJBPOpWdmfNjsEddgXf3/LrC6n
         e2rZvZ/8+g4C115r3tUpSP48I0qTCKfDHwFX2DBOef8K7tulRw4n92wijwu1eBHYiat3
         6HSDQy03g9qUD48yOlVgwIxciUkZKoGLmd7aJS0tdnQXpW0GEpiErYMpC05QoJtM5BvJ
         CR0UNU1sM6dHE4Oa5J0dX2E6CAh4R81j2UGoiYIfUwSCcUeBCUWq90yZPUGMvLdGLCvu
         BuuA==
X-Gm-Message-State: AAQBX9eRzQGQQLkLvCAG04XBb7WS2pF1E2mRKtRAtl6cTQFmFb4RZNTl
        gvVkPUcYZVwlFebjyg+VllZ7wrj3AzskQ98jXRqe5DvbpVTwyLUb1qLIl4Zlc45FIYG6puW4ELf
        FjeV2OvnKxRgv
X-Received: by 2002:adf:efd0:0:b0:2fb:a3e:7cb0 with SMTP id i16-20020adfefd0000000b002fb0a3e7cb0mr1412662wrp.10.1681809008275;
        Tue, 18 Apr 2023 02:10:08 -0700 (PDT)
X-Google-Smtp-Source: AKy350Y591UUv+uvg/KcIQng72+DOj5dcz7mSRlPB7N77Z7/Ew1OowyC7+ph90pes+Y6Fhy5y0I/qA==
X-Received: by 2002:adf:efd0:0:b0:2fb:a3e:7cb0 with SMTP id i16-20020adfefd0000000b002fb0a3e7cb0mr1412631wrp.10.1681809007822;
        Tue, 18 Apr 2023 02:10:07 -0700 (PDT)
Received: from ?IPV6:2003:cb:c715:3f00:7545:deb6:f2f4:27ef? (p200300cbc7153f007545deb6f2f427ef.dip0.t-ipconnect.de. [2003:cb:c715:3f00:7545:deb6:f2f4:27ef])
        by smtp.gmail.com with ESMTPSA id m4-20020a05600c4f4400b003f0ae957fcesm12432177wmq.42.2023.04.18.02.10.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 02:10:07 -0700 (PDT)
Message-ID: <9efef45f-e9f4-18d1-0120-f0fc0961761c@redhat.com>
Date:   Tue, 18 Apr 2023 11:10:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Chao Peng <chao.p.peng@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        dhildenb@redhat.com, Quentin Perret <qperret@google.com>,
        tabba@google.com, Michael Roth <michael.roth@amd.com>,
        wei.w.wang@intel.com, Mike Rapoport <rppt@kernel.org>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221202061347.1070246-1-chao.p.peng@linux.intel.com>
 <ZD1oevE8iHsi66T2@google.com>
 <658018f9-581c-7786-795a-85227c712be0@redhat.com>
 <ZD12htq6dWg0tg2e@google.com>
 <1ed06a62-05a1-ebe6-7ac4-5b35ba272d13@redhat.com>
 <ZD2bBB00eKP6F8kz@google.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: Rename restrictedmem => guardedmem? (was: Re: [PATCH v10 0/9]
 KVM: mm: fd-based approach for supporting KVM)
In-Reply-To: <ZD2bBB00eKP6F8kz@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17.04.23 21:16, Sean Christopherson wrote:
> On Mon, Apr 17, 2023, David Hildenbrand wrote:
>> On 17.04.23 18:40, Sean Christopherson wrote:
>>> On Mon, Apr 17, 2023, David Hildenbrand wrote:
>>>> On 17.04.23 17:40, Sean Christopherson wrote:
>>>>> I want to start referring to the code/patches by its syscall/implementation name
>>>>> instead of "UPM", as "UPM" is (a) very KVM centric, (b) refers to the broader effort
>>>>> and not just the non-KVM code, and (c) will likely be confusing for future reviewers
>>>>> since there's nothing in the code that mentions "UPM" in any way.
>>>>>
>>>>> But typing out restrictedmem is quite tedious, and git grep shows that "rmem" is
>>>>> already used to refer to "reserved memory".
>>>>>
>>>>> Renaming the syscall to "guardedmem"...
>>>>
>>>> restrictedmem, guardedmem, ... all fairly "suboptimal" if you'd ask me ...
>>>
>>> I'm definitely open to other suggestions, but I suspect it's going to be difficult
>>> to be more precise than something like "guarded".
>>
>> Guardedmem is just as bad as restrictedmem IMHO, sorry.
>>
>>
>> Restricted: what's restricted? how does the restriction manifest? secretmem
>> also has it's restrictions/limitations (pinning), why does that one not fall
>> under the same category?
>>
>> Make a stranger guess what "restrictedmem" is and I can guarantee that it
>> has nothing to do with the concept we're introducing here.
>>
>>
>> Guarded: what's guarded? From whom? For which purpose? How does the
>> "guarding" manifest?
> 
> I completely agree that "guarded" lacks precision, but as above, I've pretty much
> given up hope of being super precise.  I actually like "restricted", I just don't
> like that I can't shorten the name.
> 
> Hmm, maybe that won't be a huge problem in practice.  I can't say I've ever heard
> any use "rmem" in verbale or written communication, it's primarily just "rmem" in
> code that we can't use, and I don't mind having to use restrictedmem for the namespace.
> So maybe we can use "rmem", just not in code?
> 
> Or, we could pretend we're pirates and call it arrrmem!, which is definitely going
> to be how I refer to it in my internal dialogue if we keep "restricted" :-)

:)

> 
>> Again, make a stranger guess what "guardedmem" is and I can guarantee that
>> it has nothing to do with the concept we're introducing here.
>>
>> If, at all, the guess might be "guarded storage" [1] on s390x, which, of
>> course, has nothing to do with the concept here.
> 
> Oof, and guarded storage is even documented in Documentation/virt/kvm/api.rst.
> 
>> (storage on s390x is just the dinosaur slang for memory)
>>
>>
>> Often, if we fail to find a good name, the concept is either unclear or not
>> well defined.
>>
>> So what are the characteristics we want to generalize under that new name?
>> We want to have an fd, that
>>
>> (a) cannot be mapped into user space (mmap)
>> (b) cannot be accessed using ordinary system calls (read/write)
>> (c) can still be managed like other fds (fallocate, future NUMA
>>      policies?)
>> (d) can be consumed by some special entities that are allowed to
>>      read/write/map.
>>
>> So the fd content is inaccessible using the ordinary POSIX syscalls. It's
>> only accessible by special entities (e.g., KVM).
>>
>> Most probably I am forgetting something. But maybe that will help to find a
>> more expressive name. Maybe :)
> 
> Hidden/Concealed/etc - Too close to secretmem, suffers the "hidden from whom" problem,
> and depending on the use case, the memory may not actually be concealed from the
> user that controls the VMM.
> 
> Restricted - "rmem" collides with "reserved memory" in code.
> 
> Guarded - Conflicts with s390's "guarded storage", has the "from whom" problem.
> 
> Inaccessible - Many of the same problems as "hidden".
> 
> Unmappable - Doesn't cover things like read/write, and is wrong in the sense that
> the memory is still mappable, just not via mmap().
> 
> Secured - I'm not getting anywhere near this one :-)

The think about "secretmem" that I kind-of like (a little) is that it 
explains what it's used for: storing secrets. We don't call it 
"unmapped" memory because we unmap it from the directmap or "unpinnable" 
memory or "inaccessible" memory ... or even "restricted" because it has 
restrictions ... how the secrets are protected is kind of an 
implementation detail.

So instead of describing *why*/*how* restrictedmem is the weird kid 
(restricted/guarded/hidden/restricted/inaccessible/ ...), maybe rather 
describe what it's used for?

I know, I know, "there are other use cases where it will be used outside 
of VM context". I really don't care. "memfd_vm" / "vm_mem" would be sooo 
(feel free to add some more o's here) much easier to get. It's a special 
fd to be used to back VM memory. Depending on the VM type 
(encrypted/protected/whatever), restrictions might apply (not able to 
mmap, not able to read/write ...). For example, there really is no need 
to disallow mmap/read/write when using that memory to back a simple VM 
where all we want to do is avoid user-space page tables.

-- 
Thanks,

David / dhildenb

