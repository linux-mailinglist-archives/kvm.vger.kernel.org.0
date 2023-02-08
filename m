Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E88768EEBA
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 13:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbjBHMRg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 07:17:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbjBHMRf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 07:17:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A60C4238
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 04:16:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675858604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rjMSi9ok1TzHSDU3w1PUUtKMgZdBUc/PnFmrcylWMYk=;
        b=KlkuZW6RhOdKFBjinnEPhFgicj410BCsjLmi+eGEwia8fLYfZFxmvq5+DSS/BIZkJ4fiCG
        ccEKi8rIszNOr7TOF0po7Uw8kredEb5NHgvc/YQhLoWT4PohyQ71vHP104d06qh8tYjFB4
        jAdJuQxp79flS4z2uRGbNR5DT6ogz80=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-362-UYzzlXRvPgeDGnkjOOmedg-1; Wed, 08 Feb 2023 07:16:43 -0500
X-MC-Unique: UYzzlXRvPgeDGnkjOOmedg-1
Received: by mail-qv1-f71.google.com with SMTP id jo26-20020a056214501a00b0053aa15f61d4so9578929qvb.7
        for <kvm@vger.kernel.org>; Wed, 08 Feb 2023 04:16:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rjMSi9ok1TzHSDU3w1PUUtKMgZdBUc/PnFmrcylWMYk=;
        b=Y9rLQnSgQ2VLe82tKv+WJbekh9R0/PbJNiKytbN1VR+XW+77duDchYfwIc3Xk2Nlqq
         04uVXDVzX5wQ9x+NCAUImFS3XGS9bZagEFXj7M0n5rMWwJJBY6ONwsr/gKcJ8eT+cJos
         EZSOuYJDQCyqlOFPyb7t+q9/RtdMWloRTdXdjsEG8u3efl+GKnIDs34W8EW/4XXUvlij
         0yGQzsWyXtx+HkzUOmOnSH95zH4Iirp5u1dHjU0Qj1c770lciSMUokQF1q9rqsXvac7h
         p55TNhUvpWKEkZwido6fIQzSsi8SClwpJX5Q3URpUfs3nCiZsmXbbrqnI2M0Q4o9UYti
         Nq9w==
X-Gm-Message-State: AO0yUKXKHnsAo24wJrQ2xWOKebDstq7ui7oOuVG/wTROJr38ExnSH7FS
        anqPcOfHN0ctU0x6McKCznkpZ71yAZHcAp8Aazky5L63Pxaap16yaagzFCzchZhNklZaNsDf40o
        M4Nh7xS+i8DEU
X-Received: by 2002:a05:6214:2348:b0:56b:ef8e:18ec with SMTP id hu8-20020a056214234800b0056bef8e18ecmr12324932qvb.12.1675858603322;
        Wed, 08 Feb 2023 04:16:43 -0800 (PST)
X-Google-Smtp-Source: AK7set9NZULWqTl2Mcke9STbzAhWv2Gmx/BViB8dl8z0WU3BjxNZZ22NA4XHXc1de+u8uoed8iFu9Q==
X-Received: by 2002:a05:6214:2348:b0:56b:ef8e:18ec with SMTP id hu8-20020a056214234800b0056bef8e18ecmr12324890qvb.12.1675858603023;
        Wed, 08 Feb 2023 04:16:43 -0800 (PST)
Received: from [192.168.0.2] (ip-109-43-177-253.web.vodafone.de. [109.43.177.253])
        by smtp.gmail.com with ESMTPSA id 22-20020ac85616000000b003b630456b8fsm11264751qtr.89.2023.02.08.04.16.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Feb 2023 04:16:42 -0800 (PST)
Message-ID: <ac8073a3-868f-a923-4cb8-fda4785e7484@redhat.com>
Date:   Wed, 8 Feb 2023 13:16:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     Steven Price <steven.price@arm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linuxppc-dev@lists.ozlabs.org, Eric Auger <eric.auger@redhat.com>
References: <20230203094230.266952-1-thuth@redhat.com>
 <20230203094230.266952-7-thuth@redhat.com>
 <c6e605fe-f251-d8b6-64ed-bd1e17e79512@redhat.com>
 <7b32d58b-846f-b8d7-165b-9f505e5f00f0@redhat.com>
 <d0b3a1e7-0864-f169-cdea-60ad95951b3f@redhat.com> <87zg9oleyb.fsf@redhat.com>
 <ce11001e-dbe5-8694-71a5-841f4d614456@arm.com>
From:   Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH 6/7] KVM: arm64: Change return type of
 kvm_vm_ioctl_mte_copy_tags() to "int"
In-Reply-To: <ce11001e-dbe5-8694-71a5-841f4d614456@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/02/2023 12.51, Steven Price wrote:
> On 08/02/2023 08:49, Cornelia Huck wrote:
>> On Wed, Feb 08 2023, Gavin Shan <gshan@redhat.com> wrote:
>>
>>> On 2/7/23 9:09 PM, Thomas Huth wrote:
>>>> Oh, drat, I thought I had checked all return statements ... this must have fallen through the cracks, sorry!
>>>>
>>>> Anyway, this is already a problem now: The function is called from kvm_arch_vm_ioctl() (which still returns a long), which in turn is called from kvm_vm_ioctl() in virt/kvm/kvm_main.c. And that functions stores the return value in an "int r" variable. So the upper bits are already lost there.
> 
> Sorry about that, I was caught out by kvm_arch_vm_ioctl() returning long...

That's why I'm trying to fix that return type mess with my series, to avoid 
such problems in the future :-)

>>>> Also, how is this supposed to work from user space? The normal "ioctl()" libc function just returns an "int" ? Is this ioctl already used in a userspace application somewhere? ... at least in QEMU, I didn't spot it yet...
>>>>
>>
>> We will need it in QEMU to implement migration with MTE (the current
>> proposal simply adds a migration blocker when MTE is enabled, as there
>> are various other things that need to be figured out for this to work.)
>> But maybe other VMMs already use it (and have been lucky because they
>> always dealt with shorter lengths?)
>>
>>>
>>> The ioctl command KVM_ARM_MTE_COPY_TAGS was merged recently and not used
>>> by QEMU yet. I think struct kvm_arm_copy_mte_tags::length needs to be
>>> '__u32' instead of '__u64' in order to standardize the return value.
>>> Something like below. Documentation/virt/kvm/api.rst::section-4.130
>>> needs update accordingly.
>>>
>>>      struct kvm_arm_copy_mte_tags {
>>>           __u64 guest_ipa;
>>>           __u32 pad;
>>>           __u32 length;
>>>           void __user *addr;
>>>           __u64 flags;
>>>           __u64 reserved[2];
>>>     };
>>
>> Can we do this in a more compatible way, as we are dealing with an API?
>> Like returning -EINVAL if length is too big?
>>
> 
> I agree the simplest fix for the problem is simply to reject any
> lengths>INT_MAX:
> 
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index cf4c495a4321..94aed7ce85c4 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -1032,6 +1032,13 @@ long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
>   	if (copy_tags->flags & ~KVM_ARM_TAGS_FROM_GUEST)
>   		return -EINVAL;
> 
> +	/*
> +	 * ioctl returns int, so lengths above INT_MAX cannot be
> +	 * represented in the return value
> +	 */
> +	if (length > INT_MAX)
> +		return -EINVAL;
> +
>   	if (length & ~PAGE_MASK || guest_ipa & ~PAGE_MASK)
>   		return -EINVAL;
> 
> This could also be fixed in a useable way by including a new flag which
> returns the length in an output field of the ioctl structure. I'm
> guessing a 2GB limit would be annoying to work around.

I agree that checking for length > INT_MAX is likely the best thing to do 
here right now. I'll add that in v2 of my series.

But actually, this might even be a good thing from another point of view (so 
I'm not sure whether your idea with the flag should really be pursued): The 
code here takes a mutex and then runs a while loop that depends on the 
length - which could cause the lock to be held for a rather long time if 
length is a 64-bit value. Forcing the user space to limit the length here 
could help to avoid taking the lock for too long.

  Thomas

