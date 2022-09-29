Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 329535EEFF9
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 10:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234845AbiI2IFb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 04:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235305AbiI2IFU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 04:05:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD797C1D8
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 01:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664438714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=clPh9P7Maxyg1DAiLiLTsJ2kfx56jWJBPFldkz4w37w=;
        b=DsWVZ4jTR7cu6a6RfIVauIPNDsC/RAsQt2LrjepbZ5zvepIR91D4403oRVIv+4Zn/Cl+xy
        IO1vhTeh+LuVF67VgjktBDOPg5cqj+qhlnllHC2aAsqITSJIA3wGv3ed/49c5UrDv8ABKD
        xdqighpYViQLp9O6zti2wqk9mQszDZM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-144-Ow8mJF4TNQClKANGeiwFlw-1; Thu, 29 Sep 2022 04:05:13 -0400
X-MC-Unique: Ow8mJF4TNQClKANGeiwFlw-1
Received: by mail-wr1-f70.google.com with SMTP id r22-20020adfa156000000b0022cc3018fbaso214016wrr.2
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 01:05:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=clPh9P7Maxyg1DAiLiLTsJ2kfx56jWJBPFldkz4w37w=;
        b=sCt7YyxXmHcCNf3Pn50x286s2NcH2n9AKHvuMXVFd5s51L+WAWrFemgs7n+HNLOzT/
         wMnd7klhafNbAXRzeVCwyySySk8Hyq+7SDTV58Bl7ASlsG6Ibk3hYC8JVFaAwhlnEq4L
         E7Z7RBeZyNjv71dKrFb8rd7EqRqnhx8K8XgQXTjwx4XKCtLc5N0tCbtUmUUzyLAwuhzE
         IsclPq2bZGkMh6vG7niQqiUqPojQd8kRO61xKoi8OBkB42iXCGXuWZpUBl3TJpruNvNP
         +dhHZapPWOrN1RSt3UKhqqykJ8kR1pKLPRMwQ4doFyJijIzMKsth1VMjuX6L4ovj18Ji
         WdvA==
X-Gm-Message-State: ACrzQf3PUlaCQq3adg6SD6zOFI7bP4m49DaG4+/NyTPvSyTUywxO2Wl8
        O0TauvRbinBfeRONSJpEbZ3u39zxzZKCHrj5IG9qomJPnbeEn7uIyAzdcNoVdd7SCwakUF5xfCf
        R8xryBcWlnLtA
X-Received: by 2002:a7b:ce95:0:b0:3b4:5de8:2f34 with SMTP id q21-20020a7bce95000000b003b45de82f34mr9736569wmj.194.1664438711999;
        Thu, 29 Sep 2022 01:05:11 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM40Vtcy62anYz/pf8HH93t5hS0h/G7wm7kLqahAaU398Q4NFFhvjnjsfbFFwfaE7rMbD11t9w==
X-Received: by 2002:a7b:ce95:0:b0:3b4:5de8:2f34 with SMTP id q21-20020a7bce95000000b003b45de82f34mr9736485wmj.194.1664438710758;
        Thu, 29 Sep 2022 01:05:10 -0700 (PDT)
Received: from [192.168.149.123] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id w10-20020a05600c474a00b003b4ac05a8a4sm4879479wmo.27.2022.09.29.01.05.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 01:05:10 -0700 (PDT)
Message-ID: <637e7ef3-e204-52fc-a4ff-1f0df5227a3e@redhat.com>
Date:   Thu, 29 Sep 2022 10:05:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH 0/9] kvm: implement atomic memslot updates
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
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
References: <55d7f0bd-ace1-506b-ea5b-105a86290114@redhat.com>
 <f753391e-7bdc-bada-856a-87344e75bd74@redhat.com>
 <111a46c1-7082-62e3-4f3a-860a95cd560a@redhat.com>
 <14d5b8f2-7cb6-ce24-c7a7-32aa9117c953@redhat.com>
 <YzIZhn47brWBfQah@google.com>
 <3b04db9d-0177-7e6e-a54c-a28ada8b1d36@redhat.com>
 <YzMdjSkKaJ8HyWXh@google.com>
 <dd6db8c9-80b1-b6c5-29b8-5eced48f1303@redhat.com>
 <YzRvMZDoukMbeaxR@google.com>
 <8534dfe4-bc71-2c14-b268-e610a3111d14@redhat.com>
 <YzSxhHzgNKHL3Cvm@google.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <YzSxhHzgNKHL3Cvm@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 28/09/2022 um 22:41 schrieb Sean Christopherson:
> On Wed, Sep 28, 2022, Paolo Bonzini wrote:
>> On 9/28/22 17:58, Sean Christopherson wrote:
>>> I don't disagree that the memslots API is lacking, but IMO that is somewhat
>>> orthogonal to fixing KVM x86's "code fetch to MMIO" mess.  Such a massive new API
>>> should be viewed and prioritized as a new feature, not as a bug fix, e.g. I'd
>>> like to have the luxury of being able to explore ideas beyond "let userspace
>>> batch memslot updates", and I really don't want to feel pressured to get this
>>> code reviewed and merge.
>>
>> I absolutely agree that this is not a bugfix.  Most new features for KVM can
>> be seen as bug fixes if you squint hard enough, but they're still features.
> 
> I guess I'm complaining that there isn't sufficient justification for this new
> feature.  The cover letter provides a bug that would be fixed by having batched
> updates, but as above, that's really due to deficiencies in a different KVM ABI.
> 
> Beyond that, there's no explanation of why this exact API is necessary, i.e. there
> are no requirements given.
> 
>   - Why can't this be solved in userspace?

Because this would provide the "feature" only to QEMU, leaving each
other hypervisor to implement its own.

In addition (maybe you already answered this question but I couldn't
find an answer in the email thread), does it make sense to stop all
vcpus for a couple of memslot update? What if we have 100 cpus?

> 
>   - Is performance a concern?  I.e. are updates that need to be batched going to
>     be high frequency operations?

Currently they are limited to run only at boot. In an unmodified
KVM/QEMU build, however, I count 86 memslot updates done at boot with

./qemu-system-x86_64 --overcommit cpu-pm=on --smp $v --accel kvm
--display none

> 
>   - What operations does userspace truly need?  E.g. if the only use case is to
>     split/truncate/hole punch an existing memslot, can KVM instead provide a
>     memslot flag and exit reason that allows kicking vCPUs to userspace if the
>     memslot is accessed?  E.g. KVM_MEM_DISABLED that acts like an invalid memslot,
>     but KVM exists with a dedicated exit reason instead of generating MMIO semantics.

Could be an alternative solution I guess?
> 
>   - What precisely needs to be atomic?  If updates only need to be "atomic" for
>     an address space, does the API allowing mixing non-SMM and SMM memslots?

Does QEMU pass a list of mixed non-SMM and SMM memslots?
Btw, is there a separate list for SMM memslots in KVM?
If not, and are all thrown together, then for simplicity we make all
updates atomic.

> 
>   - When is KVM required to invalidate and flush?  E.g. if a memslot is deleted
>     and recreated with a different HVA, how does KVM ensure that there are no
>     outstanding references to the old HVA without introducing non-determinstic
>     behavior.  The current API works by forcing userspace to fully delete the
>     memslot, i.e. KVM can ensure all references are gone in all TLBs before
>     allowing userspace to create new, conflicting entries.  I don't see how this
>     can work with batched updates.  The update needs to be "atomic", i.e. vCPUs
>     must never see an invalid/deleted memslot, but if the memslot is writable,
>     how does KVM prevent some writes from hitting the old HVA and some from hitting
>     the new HVA without a quiescent period?

Sorry this might be my fault in providing definitions, even though I
think I made plenty of examples. Delete/move operations are not really
"atomic" in the sense that the slot disappears immediately.

The slot(s) is/are first "atomically" invalidated, allowing the guest to
retry the page fault and preparing for the cleanup you mention above,
and then are "atomically" deleted.
The behavior is the same, just instead of doing
invalidate memslot X
swap()
delete memslot X
swap()
invalidate memslot Y
swap()
delete memslot Y
swap()
...

I would do:

invalidate
invalidate
invalidate
swap()
delete
delete
delete
swap()
> 
>   - If a memslot is truncated while dirty logging is enabled, what happens to
>     the bitmap?  Is it preserved?  Dropped?

Can you explain what you mean with "truncated memslot"?
Regarding the bitmap, currently QEMU should (probably wrongly) update it
before even committing the changes to KVM. But I remember upstream
someone pointed that this could be solved later.

> 
> Again, I completely agree that the current memslots API is far from perfect, but
> I'm not convinced that simply extending the existing API to batch updates is the
> best solution from a KVM perspective.
> 
>>> E.g. why do a batch update and not provide KVM_SET_ALL_USER_MEMORY_REGIONS to
>>> do wholesale replacement?  That seems like it would be vastly simpler to handle
>>> on KVM's end.  Or maybe there's a solution in the opposite direction, e.g. an
>>> API that allows 1->N or N->1 conversions but not arbitrary batching.
>>
>> Wholesale replacement was my first idea when I looked at the issue, I think
>> at the end of 2020.  I never got to a full implementation, but my impression
>> was that allocating/deallocating dirty bitmaps, rmaps etc. would make it any
>> easier than arbitrary batch updates.
> 
> It's not obvious to me that the memslot metadata is going to be easy to handle
> regardless of what we do.  E.g. I'm pretty sure that batching updates will "corrupt"
> the dirty bitmap if a hole is punched in a memslot that's being dirty logged.
> 

Could you provide an example?
I mean I am not an expert but to me it looks like I preserved the same
old functionalities both here and in QEMU. I just batched and delayed
some operations, which in this case should cause no harm.

Thank you,
Emanuele

