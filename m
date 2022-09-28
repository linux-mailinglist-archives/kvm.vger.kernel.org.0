Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 194995EE1FA
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 18:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbiI1QiJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 12:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbiI1QiH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 12:38:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CFEB6D18
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 09:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664383086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KfA3AE1gLjSHcUh55RKqlSmKAY8wUZMHb6XyxojjA7M=;
        b=NNYa6SYRFa6Vz3bSM+a1IZ1zCK7gYWLpkG+qPjHlejg+ET4BC8SdXbMjSNLQL4fJ6zzfE9
        oCOQILba5DGb1DRCXFNjItoGVPUTvjpQGTjfrkm962KJYKGUbfuPcBv52QKHBxHaL2s+4U
        AUJPTmRdBMv4ZFKfo0zAcIQgMJFhMj4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-443-GKJGChoVNwWOVAJJfV-P0A-1; Wed, 28 Sep 2022 12:38:04 -0400
X-MC-Unique: GKJGChoVNwWOVAJJfV-P0A-1
Received: by mail-ed1-f71.google.com with SMTP id b17-20020a056402351100b00453b19d9bd0so10603340edd.4
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 09:38:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=KfA3AE1gLjSHcUh55RKqlSmKAY8wUZMHb6XyxojjA7M=;
        b=hcYlyhwlAWBWj/l7ajeXCCguh5E+sU/Nrrtp946CFOtpmHIU1PGeIuqDfyU6g+nUM0
         L/8wiH/461NOBXdVZgCG3JbT6ZryutaDG6j5VtPSAhzrtNlVG3C8gdE4EfiEV2R8yN4+
         HyY8gkDo3GLRIN2PgfhB1nQ8gZ844/fwDQf+NXQAyMBibPCuGxkCIrfX7ZBxBlnPKKTn
         1+9nPL0Yc+s5AZB064NpbI2icP/OmGVfyqIrE9HrH8TbCI5TwyLyqSkaBdddawcELPGQ
         i/T8VI/kE2hcOVSialJF8MS3BLWYKESqT77pf8EpaQ+GOamQ+O/0DE4n7qYG8qTFmZ02
         bd9g==
X-Gm-Message-State: ACrzQf3CCUMCkt/wuoeW/1LGFSwskvoAgLK5sWLVeI0vUYP1dg6wAs4+
        vFs5QVlJkj0NafpXwBsWt1v+5tHWLpZlW/THAql2A6bwylmkXhUVwqU7CTLJN/xwzWYLpD0RS3g
        AGbQHo5bLSHID
X-Received: by 2002:a17:907:8693:b0:783:a776:ce86 with SMTP id qa19-20020a170907869300b00783a776ce86mr12834967ejc.243.1664383083449;
        Wed, 28 Sep 2022 09:38:03 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7spf7rZI5JZmQqO2z0gdul9SCLQxL0tiDgUirwLau5dTewaGrfOYjH4OE4cXcCdnHHB0dSHA==
X-Received: by 2002:a17:907:8693:b0:783:a776:ce86 with SMTP id qa19-20020a170907869300b00783a776ce86mr12834945ejc.243.1664383083180;
        Wed, 28 Sep 2022 09:38:03 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:2f4b:62da:3159:e077? ([2001:b07:6468:f312:2f4b:62da:3159:e077])
        by smtp.googlemail.com with ESMTPSA id m5-20020a1709062ac500b00773dbdd8205sm2596968eje.168.2022.09.28.09.38.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 09:38:02 -0700 (PDT)
Message-ID: <8534dfe4-bc71-2c14-b268-e610a3111d14@redhat.com>
Date:   Wed, 28 Sep 2022 18:38:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
References: <37b3162e-7b3a-919f-80e2-f96eca7d4b4c@redhat.com>
 <dfcbdf1d-b078-ec6c-7706-6af578f79ec2@redhat.com>
 <55d7f0bd-ace1-506b-ea5b-105a86290114@redhat.com>
 <f753391e-7bdc-bada-856a-87344e75bd74@redhat.com>
 <111a46c1-7082-62e3-4f3a-860a95cd560a@redhat.com>
 <14d5b8f2-7cb6-ce24-c7a7-32aa9117c953@redhat.com>
 <YzIZhn47brWBfQah@google.com>
 <3b04db9d-0177-7e6e-a54c-a28ada8b1d36@redhat.com>
 <YzMdjSkKaJ8HyWXh@google.com>
 <dd6db8c9-80b1-b6c5-29b8-5eced48f1303@redhat.com>
 <YzRvMZDoukMbeaxR@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 0/9] kvm: implement atomic memslot updates
In-Reply-To: <YzRvMZDoukMbeaxR@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/28/22 17:58, Sean Christopherson wrote:
> On Wed, Sep 28, 2022, Paolo Bonzini wrote:
>> On 9/27/22 17:58, Sean Christopherson wrote:
>>> I'm pretty sure this patch will Just Work for QEMU, because QEMU simply resumes
>>> the vCPU if mmio.len==0.  It's a bit of a hack, but I don't think it violates KVM's
>>> ABI in any way, and it can even become "official" behavior since KVM x86 doesn't
>>> otherwise exit with mmio.len==0.
>>
>> I think this patch is not a good idea for two reasons:
>>
>> 1) we don't know how userspace behaves if mmio.len is zero.  It is of course
>> reasonable to do nothing, but an assertion failure is also a valid behavior
> 
> Except that KVM currently does neither.  If the fetch happens at CPL>0 and/or in
> L2, KVM injects #UD.  That's flat out architecturally invalid.  If it's a sticking
> point, the mmio.len==0 hack can be avoided by defining a new exit reason.

I agree that doing this at CPL>0 or in L2 is invalid and makes little 
sense (because either way the invalid address cannot be reached without 
help from the supervisor or L1's page tables).

>> 2) more important, there is no way to distinguish a failure due to the guest
>> going in the weeds (and then KVM_EXIT_INTERNAL_ERROR is fine) from one due
>> to the KVM_SET_USER_MEMORY_REGION race condition.  So this will cause a
>> guest that correctly caused an internal error to loop forever.
> 
> Userspace has the GPA and absolutely should be able to detect if the MMIO may have
> been due to its memslot manipulation versus the guest jumping into the weeds.
> 
>> While the former could be handled in a "wait and see" manner, the latter in
>> particular is part of the KVM_RUN contract.  Of course it is possible for a
>> guest to just loop forever, but in general all of KVM, QEMU and upper
>> userspace layers want a crashed guest to be detected and stopped forever.
>>
>> Yes, QEMU could loop only if memslot updates are in progress, but honestly
>> all the alternatives I have seen to atomic memslot updates are really
>> *awful*.  David's patches even invent a new kind of mutex for which I have
>> absolutely no idea what kind of deadlocks one should worry about and why
>> they should not exist; QEMU's locking is already pretty crappy, it's
>> certainly not on my wishlist to make it worse!
>>
>> This is clearly a deficiency in the KVM kernel API, and (thanks to SRCU) the
>> kernel is the only place where you can have a *good* fix.  It should have
>> been fixed years ago.
> 
> I don't disagree that the memslots API is lacking, but IMO that is somewhat
> orthogonal to fixing KVM x86's "code fetch to MMIO" mess.  Such a massive new API
> should be viewed and prioritized as a new feature, not as a bug fix, e.g. I'd
> like to have the luxury of being able to explore ideas beyond "let userspace
> batch memslot updates", and I really don't want to feel pressured to get this
> code reviewed and merge.

I absolutely agree that this is not a bugfix.  Most new features for KVM 
can be seen as bug fixes if you squint hard enough, but they're still 
features.

> E.g. why do a batch update and not provide KVM_SET_ALL_USER_MEMORY_REGIONS to
> do wholesale replacement?  That seems like it would be vastly simpler to handle
> on KVM's end.  Or maybe there's a solution in the opposite direction, e.g. an
> API that allows 1->N or N->1 conversions but not arbitrary batching.

Wholesale replacement was my first idea when I looked at the issue, I 
think at the end of 2020.  I never got to a full implementation, but my 
impression was that allocating/deallocating dirty bitmaps, rmaps etc. 
would make it any easier than arbitrary batch updates.

> And just because QEMU's locking is "already pretty crappy", that's not a good
> reason to drag KVM down into the mud.  E.g. taking a lock and conditionally
> releasing it...  I get that this is an RFC, but IMO anything that requires such
> shenanigans simply isn't acceptable.
> 
>    /*
>     * Takes kvm->slots_arch_lock, and releases it only if
>     * invalid_slot allocation, kvm_prepare_memory_region failed
>     * or batch->is_move_delete is true.
>     */
>    static int kvm_prepare_memslot(struct kvm *kvm,
> 			         struct kvm_internal_memory_region_list *batch)
> 

No objection about that. :)

Paolo

