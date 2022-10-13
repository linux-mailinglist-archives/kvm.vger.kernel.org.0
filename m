Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29C935FD822
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 13:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbiJMLMZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 07:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiJMLMT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 07:12:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A8911E454
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 04:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665659537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j29ngQCSFDZIffbvLhxq5+79cMSaVQV90U1dHeLGPXo=;
        b=Hkv4JVjvIM+UwZelyNL1ngYDhR1BcvB7bLI9pFRFTpDQmn+Ca9MdvVjX3/eKIimy9HAwxz
        qK5dQAGFg3mIh5UTUc4ay+2g6Q81p/HBa+1boPLoB7CMYR6JJJePARp5anoUlxxnkbAOZU
        +l7mHLyqzZexwn16R0W+MgaO/x6lH38=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-661-z6AmQOLmNdWWfdQEUgvIOA-1; Thu, 13 Oct 2022 07:12:16 -0400
X-MC-Unique: z6AmQOLmNdWWfdQEUgvIOA-1
Received: by mail-wr1-f69.google.com with SMTP id u20-20020adfc654000000b0022cc05e9119so413352wrg.16
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 04:12:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j29ngQCSFDZIffbvLhxq5+79cMSaVQV90U1dHeLGPXo=;
        b=CQ2KA8tezXb1CXpUFHMHmOztRFw+7XtLTcweXwjEnWZBd5oxCK/iSuH24fzoEYeBDX
         8e+Xez480EuPiYHnM75DtDV9MMSve8/dVFZsDck7+WjTuQUhxJV+jL5Krt+6/CI1LYhF
         WAgT6L0xYO86+myU9W+ZsvivWl9W0yl0ORtb17GzZnlLHcDNWdiqa+G45uEIXsijfEeN
         Ep4qxOnaFLsJuEgfFybkbBBGSaDgpQywklBQQWuQ6wVQPcOqu0iLPuJyuFKsgKRP18XW
         bFDv3j13LJ+DGfIYr1Nlq2JMPd66cDhf4EiwI5PqACGZiiPWnKlhmJ2J8fLgrEfP/jf4
         AxpQ==
X-Gm-Message-State: ACrzQf3GJMDJecvVlTRNU8t4ExzAQlmXcuVaXxOQe0F9oLZkWEmasyUn
        EoLasj0VZKD4AJX6TMjcwhTfceFPJo7sDB+MyPAdFmDIJuDQ2KyHAjzzeLcS1fqpDHS+mSJyuMz
        4hyuUPuG2ioym
X-Received: by 2002:a5d:456b:0:b0:230:9e5b:c64c with SMTP id a11-20020a5d456b000000b002309e5bc64cmr12453713wrc.211.1665659535078;
        Thu, 13 Oct 2022 04:12:15 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7TMnkAJEZK04ydHgvaR+DRC62l8THeSaACAhcd9VIxam120HTXjq9N2q/IRUv5oiirD/Diog==
X-Received: by 2002:a5d:456b:0:b0:230:9e5b:c64c with SMTP id a11-20020a5d456b000000b002309e5bc64cmr12453690wrc.211.1665659534756;
        Thu, 13 Oct 2022 04:12:14 -0700 (PDT)
Received: from [192.168.149.123] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id t1-20020adff041000000b0022ac38fb20asm1780424wro.111.2022.10.13.04.12.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Oct 2022 04:12:13 -0700 (PDT)
Message-ID: <12ac9bf1-bcd6-d684-d265-1ad524b99feb@redhat.com>
Date:   Thu, 13 Oct 2022 13:12:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH 0/9] kvm: implement atomic memslot updates
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
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
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <a412085f-9391-8a4c-916c-513c800c35b1@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 13/10/2022 um 10:44 schrieb David Hildenbrand:
> On 13.10.22 09:43, Emanuele Giuseppe Esposito wrote:
>>
>>
>> Am 29/09/2022 um 23:39 schrieb Sean Christopherson:
>>> If we really want to provide a better experience for userspace, why
>>> not provide
>>> more primitives to address those specific use cases?  E.g. fix KVM's
>>> historic wart
>>> of disallowing toggling of KVM_MEM_READONLY, and then add one or more
>>> ioctls to:
>>>
>>>    - Merge 2+ memory regions that are contiguous in GPA and HVA
>>>    - Split a memory region into 2+ memory regions
>>>    - Truncate a memory region
>>>    - Grow a memory region
>>
>> I looked again at the code and specifically the use case that triggers
>> the crash in bugzilla. I *think* (correct me if I am wrong), that the
>> only operation that QEMU performs right now is "grow/shrink".
> 
> I remember that there were BUG reports where we'd actually split and run
> into that problem. Just don't have them at hand. I think they happened
> during early boot when the OS re-configured some PCI thingies.

If you could point me where this is happening, it would be nice. So far
I could not find or see any split/merge operation.

> 
>>
>> So *if* we want to go this way, we could start with a simple grow/shrink
>> API.
>>
>> Even though we need to consider that this could bring additional
>> complexity in QEMU. Currently, DELETE+CREATE (grow/shrink) is not
>> performed one after the other (in my innocent fantasy I was expecting to
>> find 2 subsequent ioctls in the code), but in QEMU's
>> address_space_set_flatview(), which seems to first remove all regions
>> and then add them when changing flatviews.
>>
>> address_space_update_topology_pass(as, old_view2, new_view,
>> adding=false);
>> address_space_update_topology_pass(as, old_view2, new_view, adding=true);
>>
>> I don't think we can change this, as other listeners also rely on such
>> ordering, but we can still batch all callback requests like I currently
>> do and process them in kvm_commit(), figuring there which operation is
>> which.
>>
>> In other words, we would have something like:
>>
>> region_del() --> DELETE memslot X -> add it to the queue of operations
>> region_del() --> DELETE memslot Y -> add it to the queue of operations
>> region_add() --> CREATE memslot X (size doubled) -> add it to the queue
>> of operations
>> region_add() --> CREATE memslot Y (size halved) -> add it to the queue
>> of operations
>> ...
>> commit() --> scan QUEUE and figure what to do -> GROW X (+size), SHRINK
>> Y (-size) -> issue 2 ioctls, GROW and SHRINK.
> 
> I communicated resizes (region_resize()) to the notifier in patch #3 of
> https://lore.kernel.org/qemu-devel/20200312161217.3590-1-david@redhat.com/
> 
> You could use that independently of the remainder. It should be less
> controversial ;)
> 
> But I think it only tackles part of the more generic problem (split/merge).

Yes, very useful! Using that patch we would have a single place where to
issue grow/shrink ioctls. I don't think we need to inhibit ioctls, since
the operation will be atomic (this time in the true meaning, since we
don't need INVALIDATE.

> 
>>
>>> That would probably require more KVM code overall, but each operation
>>> would be more
>>> tightly bounded and thus simpler to define.  And I think more precise
>>> APIs would
>>> provide other benefits, e.g. growing a region wouldn't require first
>>> deleting the
>>> current region, and so could avoid zapping SPTEs and destroying
>>> metadata.  Merge,
>>> split, and truncate would have similar benefits, though they might be
>>> more
>>> difficult to realize in practice.
>>
>> So essentially grow would not require INVALIDATE. Makes sense, but would
>> it work also with shrink? I guess so, as the memslot is still present
>> (but shrinked) right?
>>
>> Paolo, would you be ok with this smaller API? Probably just starting
>> with grow and shrink first.
>>
>> I am not against any of the two approaches:
>> - my approach has the disadvantage that the list could be arbitrarily
>> long, and it is difficult to rollback the intermediate changes if
>> something breaks during the request processing (but could be simplified
>> by making kvm exit or crash).
>>
>> - Sean approach could potentially provide more burden to the userspace,
>> as we need to figure which operation is which. Also from my
>> understanding split and merge won't be really straightforward to
>> implement, especially in userspace.
>>
>> David, any concern from userspace prospective on this "CISC" approach?
> 
> In contrast to resizes in QEMU that only affect a single memory
> region/slot, splitting/merging is harder to factor out and communicate
> to a notifier. As an alternative, we could handle it in the commit stage
> in the notifier itself, similar to what my prototype does, and figure
> out what needs to be done in there and how to call the proper KVM
> interface (and which interface to call).
> 
> With virtio-mem (in the future) we might see merges of 2 slots into a
> single one, by closing a gap in-between them. In "theory" we could
> combine some updates into a single transaction. But it won't be 100s ...
> 
> I think I'd prefer an API that doesn't require excessive ad-hoc
> extensions later once something in QEMU changes.
> 
> 
> I think in essence, all we care about is performing atomic changes that
> *have to be atomic*, because something we add during a transaction
> overlaps with something we remove during a transaction. Not necessarily
> all updates in a transaction!
> 
> My prototype essentially detects that scenario, but doesn't call new KVM
> interfaces to deal with these.

With "prototype" I assume you mean the patch linked above
(region_resize), not the userspace-only proposal you sent initially right?

> 
> I assume once we take that into consideration, we can mostly assume that
> any such atomic updates (only of the regions that really have to be part
> of an atomic update) won't involve more than a handful of memory
> regions. We could add a sane KVM API limit.
> 
> And if we run into that API limit in QEMU, we can print a warning and do
> it non-atomically.
> 
If we implement single operations (split/merge/grow/shrink), we don't
even need that limit. Except for merge, maybe.

Ok, if it'ok for you all I can try to use David patch and implement some
simple grow/shrink. Then we need to figure where and when exactly QEMU
performs split and merge operations, and maybe implement something
similar to what you did in your proposal?

Thank you,
Emanuele

