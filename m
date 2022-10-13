Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3055FDC94
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 16:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiJMOpx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 10:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiJMOpv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 10:45:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D48DAC79
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 07:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665672349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fYg2T4Tv3y3GE7pPGW8Div/cGP/cncvXqm22I6O4VCM=;
        b=LgUC9o2MPYGdRF+HZ69aCQ4vH/QeUBFf5lPG9G3PVwVDI+WsyoMR+6vnHbl8ZferIGxcZW
        GOlOOnfyau1+mG2Eun2LsqE2kjSi+osjAVLhUSD8aLcpesGEh4sLXsNiHCPyHeyIS+PoDX
        XTVt85dGO6dDwQUowvyEU/yo1diaBfU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-631-4AereVX1Mom1jMBWzzcaAQ-1; Thu, 13 Oct 2022 10:45:47 -0400
X-MC-Unique: 4AereVX1Mom1jMBWzzcaAQ-1
Received: by mail-wm1-f69.google.com with SMTP id l15-20020a05600c4f0f00b003b4bec80edbso1284419wmq.9
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 07:45:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fYg2T4Tv3y3GE7pPGW8Div/cGP/cncvXqm22I6O4VCM=;
        b=TX05s7Ol+OAdq6I+A6fUVh5L0lozICOHdkgfnYkRXMX0rk28WaqHWC5WyY8mDsg5D1
         S3QGP3hWyTVX3HssUfEh3QV7Z5t4Gaf2HyvL5Sr4uKEH9T6yEQfwRKaOsITBqY9blk5g
         miOsMF89YxBzEDyEopO6kw424t8DUvb16f2SvmuM0WMJT2YY079HBh2CRehtGVCFdX3/
         IVZO3N1tai9vy+5ZBlKJlTDpEVBlyItQCxabNc3db+rRECx3sfu4NDxk7RBRqg5A86QS
         qpagZwuP020Yq3HPWXNIdo1LofKvsp8fSiyh9d9phd31/XY6yOqn3CrA4I/WPGMBkzxY
         1uMQ==
X-Gm-Message-State: ACrzQf2X5+H+cZcLCHA9IoVV3xZ7qUxOfQNVWGlkqIMGllUsoHZf/0Hn
        OeQEZXRA6w2t2+bDHeFxmy/BfhyLZyrfEB2jWBYigTvyxWHuhINsASp+xu89yY1CjqzK7S6fYfd
        93tXU7AViHJvI
X-Received: by 2002:a5d:6e08:0:b0:22e:4116:b8e8 with SMTP id h8-20020a5d6e08000000b0022e4116b8e8mr249763wrz.60.1665672346644;
        Thu, 13 Oct 2022 07:45:46 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM72qvXvcqbQ8gvW0u+C/u0JsQnFWYcBn3wR2t0IlIicGtAK/h/+r172+nOO+le+Og79MLoedQ==
X-Received: by 2002:a5d:6e08:0:b0:22e:4116:b8e8 with SMTP id h8-20020a5d6e08000000b0022e4116b8e8mr249729wrz.60.1665672346220;
        Thu, 13 Oct 2022 07:45:46 -0700 (PDT)
Received: from ?IPV6:2003:cb:c706:9d00:a34c:e448:d59b:831? (p200300cbc7069d00a34ce448d59b0831.dip0.t-ipconnect.de. [2003:cb:c706:9d00:a34c:e448:d59b:831])
        by smtp.gmail.com with ESMTPSA id ay2-20020a5d6f02000000b002206203ed3dsm2188304wrb.29.2022.10.13.07.45.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Oct 2022 07:45:45 -0700 (PDT)
Message-ID: <1a7ab30b-7f25-b56e-f670-28632cc0bafc@redhat.com>
Date:   Thu, 13 Oct 2022 16:45:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [RFC PATCH 0/9] kvm: implement atomic memslot updates
Content-Language: en-US
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
References: <111a46c1-7082-62e3-4f3a-860a95cd560a@redhat.com>
 <14d5b8f2-7cb6-ce24-c7a7-32aa9117c953@redhat.com>
 <YzIZhn47brWBfQah@google.com>
 <3b04db9d-0177-7e6e-a54c-a28ada8b1d36@redhat.com>
 <YzMdjSkKaJ8HyWXh@google.com>
 <dd6db8c9-80b1-b6c5-29b8-5eced48f1303@redhat.com>
 <YzRvMZDoukMbeaxR@google.com>
 <8534dfe4-bc71-2c14-b268-e610a3111d14@redhat.com>
 <YzSxhHzgNKHL3Cvm@google.com>
 <d8d2bd39-cbb3-010d-266a-4e967765a382@redhat.com>
 <YzYQe2Lc+l2KpLBl@google.com>
 <261aff0b-874e-0644-e0c8-97e0a9bfbe04@redhat.com>
 <a412085f-9391-8a4c-916c-513c800c35b1@redhat.com>
 <12ac9bf1-bcd6-d684-d265-1ad524b99feb@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <12ac9bf1-bcd6-d684-d265-1ad524b99feb@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>> I remember that there were BUG reports where we'd actually split and run
>> into that problem. Just don't have them at hand. I think they happened
>> during early boot when the OS re-configured some PCI thingies.
> 
> If you could point me where this is happening, it would be nice. So far
> I could not find or see any split/merge operation.

I remember some bugzilla, but it might be hard to find. Essentially, it 
happened that early during boot that it wasn't really a problem so far 
(single CPU running that triggers it IIRC).

But I might be messing up some details.

>>
>>>
>>>> That would probably require more KVM code overall, but each operation
>>>> would be more
>>>> tightly bounded and thus simpler to define.  And I think more precise
>>>> APIs would
>>>> provide other benefits, e.g. growing a region wouldn't require first
>>>> deleting the
>>>> current region, and so could avoid zapping SPTEs and destroying
>>>> metadata.  Merge,
>>>> split, and truncate would have similar benefits, though they might be
>>>> more
>>>> difficult to realize in practice.
>>>
>>> So essentially grow would not require INVALIDATE. Makes sense, but would
>>> it work also with shrink? I guess so, as the memslot is still present
>>> (but shrinked) right?
>>>
>>> Paolo, would you be ok with this smaller API? Probably just starting
>>> with grow and shrink first.
>>>
>>> I am not against any of the two approaches:
>>> - my approach has the disadvantage that the list could be arbitrarily
>>> long, and it is difficult to rollback the intermediate changes if
>>> something breaks during the request processing (but could be simplified
>>> by making kvm exit or crash).
>>>
>>> - Sean approach could potentially provide more burden to the userspace,
>>> as we need to figure which operation is which. Also from my
>>> understanding split and merge won't be really straightforward to
>>> implement, especially in userspace.
>>>
>>> David, any concern from userspace prospective on this "CISC" approach?
>>
>> In contrast to resizes in QEMU that only affect a single memory
>> region/slot, splitting/merging is harder to factor out and communicate
>> to a notifier. As an alternative, we could handle it in the commit stage
>> in the notifier itself, similar to what my prototype does, and figure
>> out what needs to be done in there and how to call the proper KVM
>> interface (and which interface to call).
>>
>> With virtio-mem (in the future) we might see merges of 2 slots into a
>> single one, by closing a gap in-between them. In "theory" we could
>> combine some updates into a single transaction. But it won't be 100s ...
>>
>> I think I'd prefer an API that doesn't require excessive ad-hoc
>> extensions later once something in QEMU changes.
>>
>>
>> I think in essence, all we care about is performing atomic changes that
>> *have to be atomic*, because something we add during a transaction
>> overlaps with something we remove during a transaction. Not necessarily
>> all updates in a transaction!
>>
>> My prototype essentially detects that scenario, but doesn't call new KVM
>> interfaces to deal with these.
> 
> With "prototype" I assume you mean the patch linked above
> (region_resize), not the userspace-only proposal you sent initially right?

I meant from the userspace-only proposal the part where we collect all 
add/remove callabcks in a list, and in the commit stage try to detect if 
there is an overlap. That way we could isolate the memblocks that really 
only need an atomic operation. Anything that doesn't overlap can just go 
via the old interface.

Not saying that it wins a beauty price, but we wouldn't have to adjust 
QEMU core even more to teach it these special cases (but maybe we should 
and other notifiers might benefit from that in the long term).

> 
>>
>> I assume once we take that into consideration, we can mostly assume that
>> any such atomic updates (only of the regions that really have to be part
>> of an atomic update) won't involve more than a handful of memory
>> regions. We could add a sane KVM API limit.
>>
>> And if we run into that API limit in QEMU, we can print a warning and do
>> it non-atomically.
>>
> If we implement single operations (split/merge/grow/shrink), we don't
> even need that limit. Except for merge, maybe.

Right, in theory you could have multiple splits/merges in a single 
commit that all interact.

Like cutting out 8 pieces out of an existing larger memblock.

> 
> Ok, if it'ok for you all I can try to use David patch and implement some
> simple grow/shrink. Then we need to figure where and when exactly QEMU
> performs split and merge operations, and maybe implement something
> similar to what you did in your proposal?

Looking at grow/shrink first is certainly not a waste of time.

-- 
Thanks,

David / dhildenb

