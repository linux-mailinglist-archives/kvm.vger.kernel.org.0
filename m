Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0775FD661
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 10:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiJMIo2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 04:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiJMIo0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 04:44:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A72711C6DA
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 01:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665650664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IyWDBHKUbblMFVjGJX3xNcO+P+W27LTkDBMLGMB9wSY=;
        b=DLnSYY2crBeoqYXTwl10uAx0VuDyENu+9ph9anzEqiH03CHhzaRMvJb6niqPbwTXxBxul1
        wwkRuzVU7bvyWwiZNy0ZygqIJ/OPnxdozzjXg56JoCgTof9qUajFOTa5x95M/gczXpgJPE
        KEQO4HGjMZ3XvqjTnjl4cZ1MqE+mb3Y=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-624-DddFXumdOgyLjA6g_K8GWg-1; Thu, 13 Oct 2022 04:44:23 -0400
X-MC-Unique: DddFXumdOgyLjA6g_K8GWg-1
Received: by mail-wm1-f69.google.com with SMTP id n6-20020a7bc5c6000000b003c6bbe5d5cfso2527878wmk.4
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 01:44:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :content-language:references:cc:to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IyWDBHKUbblMFVjGJX3xNcO+P+W27LTkDBMLGMB9wSY=;
        b=N4TFbKMFyPvuD4fnIpuZbGsydJE/hrRSHWPipuae9pQv+7F8D0XJBMG7L9qU46GCZz
         krLH6SkD1g2OU4Ga7hbrplJ3ht5xYyPkCBcLnkVCIS/W9JPiuQt5a+Mgtp36MCdEegz+
         1WRdJpOFd7+Al0ErjQI+r1qxG20OD3Wmkp5AerRMpAy+ZJFjb2hfr7BfhFTF/perUcpg
         ZnJwFKQn9OYLHEgJOMcg7gt9GhzH8e6impdHarZtIfISr3jFsVpAQ8LYpmQ3eYdLOWY3
         GoKw3FGSkgB6h6+Hvx8gs1K2JJSfkIAKedGGFFsn88umGe2A/wu2hDjP85KPS9DtQw/U
         plnw==
X-Gm-Message-State: ACrzQf1nhNIYeI+8DMsrkx7IFuAezhfYyVD/IJQItlWGaj6UKMCooadM
        PTtgadnxYpkR3V69apaEktqJnmk8jMjT1CO25ZfBAG0mzAehAE0Fg0kq7+dfAKVceAvOOLYBcVg
        rNOWHKUZjI2TD
X-Received: by 2002:a5d:4688:0:b0:22e:340d:7108 with SMTP id u8-20020a5d4688000000b0022e340d7108mr20414795wrq.67.1665650662347;
        Thu, 13 Oct 2022 01:44:22 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4PH81FjyZ8EnzcPI9h+llKT7KbsLNUXhe7kPkDaebuoG8789mF4AhQL97y3c0q3JbYWzB67Q==
X-Received: by 2002:a5d:4688:0:b0:22e:340d:7108 with SMTP id u8-20020a5d4688000000b0022e340d7108mr20414771wrq.67.1665650661981;
        Thu, 13 Oct 2022 01:44:21 -0700 (PDT)
Received: from ?IPV6:2003:cb:c706:9d00:a34c:e448:d59b:831? (p200300cbc7069d00a34ce448d59b0831.dip0.t-ipconnect.de. [2003:cb:c706:9d00:a34c:e448:d59b:831])
        by smtp.gmail.com with ESMTPSA id o9-20020a05600c510900b003a540fef440sm4250934wms.1.2022.10.13.01.44.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Oct 2022 01:44:21 -0700 (PDT)
Message-ID: <a412085f-9391-8a4c-916c-513c800c35b1@redhat.com>
Date:   Thu, 13 Oct 2022 10:44:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
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
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [RFC PATCH 0/9] kvm: implement atomic memslot updates
In-Reply-To: <261aff0b-874e-0644-e0c8-97e0a9bfbe04@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13.10.22 09:43, Emanuele Giuseppe Esposito wrote:
> 
> 
> Am 29/09/2022 um 23:39 schrieb Sean Christopherson:
>> If we really want to provide a better experience for userspace, why not provide
>> more primitives to address those specific use cases?  E.g. fix KVM's historic wart
>> of disallowing toggling of KVM_MEM_READONLY, and then add one or more ioctls to:
>>
>>    - Merge 2+ memory regions that are contiguous in GPA and HVA
>>    - Split a memory region into 2+ memory regions
>>    - Truncate a memory region
>>    - Grow a memory region
> 
> I looked again at the code and specifically the use case that triggers
> the crash in bugzilla. I *think* (correct me if I am wrong), that the
> only operation that QEMU performs right now is "grow/shrink".

I remember that there were BUG reports where we'd actually split and run 
into that problem. Just don't have them at hand. I think they happened 
during early boot when the OS re-configured some PCI thingies.

> 
> So *if* we want to go this way, we could start with a simple grow/shrink
> API.
> 
> Even though we need to consider that this could bring additional
> complexity in QEMU. Currently, DELETE+CREATE (grow/shrink) is not
> performed one after the other (in my innocent fantasy I was expecting to
> find 2 subsequent ioctls in the code), but in QEMU's
> address_space_set_flatview(), which seems to first remove all regions
> and then add them when changing flatviews.
> 
> address_space_update_topology_pass(as, old_view2, new_view, adding=false);
> address_space_update_topology_pass(as, old_view2, new_view, adding=true);
> 
> I don't think we can change this, as other listeners also rely on such
> ordering, but we can still batch all callback requests like I currently
> do and process them in kvm_commit(), figuring there which operation is
> which.
> 
> In other words, we would have something like:
> 
> region_del() --> DELETE memslot X -> add it to the queue of operations
> region_del() --> DELETE memslot Y -> add it to the queue of operations
> region_add() --> CREATE memslot X (size doubled) -> add it to the queue
> of operations
> region_add() --> CREATE memslot Y (size halved) -> add it to the queue
> of operations
> ...
> commit() --> scan QUEUE and figure what to do -> GROW X (+size), SHRINK
> Y (-size) -> issue 2 ioctls, GROW and SHRINK.

I communicated resizes (region_resize()) to the notifier in patch #3 of 
https://lore.kernel.org/qemu-devel/20200312161217.3590-1-david@redhat.com/

You could use that independently of the remainder. It should be less 
controversial ;)

But I think it only tackles part of the more generic problem (split/merge).

> 
>> That would probably require more KVM code overall, but each operation would be more
>> tightly bounded and thus simpler to define.  And I think more precise APIs would
>> provide other benefits, e.g. growing a region wouldn't require first deleting the
>> current region, and so could avoid zapping SPTEs and destroying metadata.  Merge,
>> split, and truncate would have similar benefits, though they might be more
>> difficult to realize in practice.
> 
> So essentially grow would not require INVALIDATE. Makes sense, but would
> it work also with shrink? I guess so, as the memslot is still present
> (but shrinked) right?
> 
> Paolo, would you be ok with this smaller API? Probably just starting
> with grow and shrink first.
> 
> I am not against any of the two approaches:
> - my approach has the disadvantage that the list could be arbitrarily
> long, and it is difficult to rollback the intermediate changes if
> something breaks during the request processing (but could be simplified
> by making kvm exit or crash).
> 
> - Sean approach could potentially provide more burden to the userspace,
> as we need to figure which operation is which. Also from my
> understanding split and merge won't be really straightforward to
> implement, especially in userspace.
> 
> David, any concern from userspace prospective on this "CISC" approach?

In contrast to resizes in QEMU that only affect a single memory 
region/slot, splitting/merging is harder to factor out and communicate 
to a notifier. As an alternative, we could handle it in the commit stage 
in the notifier itself, similar to what my prototype does, and figure 
out what needs to be done in there and how to call the proper KVM 
interface (and which interface to call).

With virtio-mem (in the future) we might see merges of 2 slots into a 
single one, by closing a gap in-between them. In "theory" we could 
combine some updates into a single transaction. But it won't be 100s ...

I think I'd prefer an API that doesn't require excessive ad-hoc 
extensions later once something in QEMU changes.


I think in essence, all we care about is performing atomic changes that 
*have to be atomic*, because something we add during a transaction 
overlaps with something we remove during a transaction. Not necessarily 
all updates in a transaction!

My prototype essentially detects that scenario, but doesn't call new KVM 
interfaces to deal with these.

I assume once we take that into consideration, we can mostly assume that 
any such atomic updates (only of the regions that really have to be part 
of an atomic update) won't involve more than a handful of memory 
regions. We could add a sane KVM API limit.

And if we run into that API limit in QEMU, we can print a warning and do 
it non-atomically.

-- 
Thanks,

David / dhildenb

