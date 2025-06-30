Return-Path: <kvm+bounces-51113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DBD20AEE7EE
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 22:03:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 148A617D867
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 20:03:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05360222584;
	Mon, 30 Jun 2025 20:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="er1SX11T"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF2D21CC48
	for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 20:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751313803; cv=none; b=JI5LvFSghisdeOuRaWJGQLpyyj1fU6/c0SIBO3h1+96hbhklnT8odvbxO8oUE+vvMzixb+SfKVI7suNFIUKkh74uRKHHacUQxI4Fezh55KrBohAlxO2qQeHlDddnpQAxZkMGtDhAwNB0STBJ2vEcfPUU0/fvo6SeHoutpCSVh6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751313803; c=relaxed/simple;
	bh=mJJca1UpAXd+OKA3GelW6E+aEbzwJ9jP6ww/czyB0QQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vmj2HxM8z6K9vcx7VscTBfjG5BnXE2+jhbVCLhu58iaUYC4EuMIuGW/4ohreSRIZpMGgkBYx43O6lkIF4OrjYvIu4VMAQ7QMl1usiwDeqbgJut6fRpK7iN8U+KlR/uCI7BNAyCVYL0lUJIR83rz5Vi9tVsZJupSI9WNJ9EUoKSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=er1SX11T; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751313800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0hu9yh42WohK7mI4Sf4ggRfCpQs4HP7pq5UzW8H06yY=;
	b=er1SX11T7C1dHGtoUxZJc9xuI/J1fBduRcxFQLq52vBtPD0hTGlwnDKWZ5CJbXDlFsZCth
	fo4wQ/XBH7cTWjdRwomdpQLov+DugXrAlZZdGCsYs7mMTPUcsa3naT1oeMpsJ8MAf28kw7
	fA1lSHqhU7Xx6tgevx+SZe5sRCFDlpo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-600-s_Rj6aeYPyKsAnzjtmp1Bg-1; Mon, 30 Jun 2025 16:03:17 -0400
X-MC-Unique: s_Rj6aeYPyKsAnzjtmp1Bg-1
X-Mimecast-MFC-AGG-ID: s_Rj6aeYPyKsAnzjtmp1Bg_1751313796
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4530ec2c87cso16260315e9.0
        for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 13:03:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751313796; x=1751918596;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0hu9yh42WohK7mI4Sf4ggRfCpQs4HP7pq5UzW8H06yY=;
        b=ucHA2klH0FaoMcYgYXTli1x0cz3n6phWQ7plo7FbO1KzAKxcA7M/zpJl73Cg1ElL/4
         W6Fsij09C1Y7RwWLkwrB5lK0am9FpWTfUWs1j3Dl0sR9RXJgQLs0v58tjsDpzks1zo1t
         e6w6d3ANQV0vzbsQjEMdfAAO2iuUz1LIpF8BuaVVIZgsfll8EiWfgWOBVA+9KFRoyp2l
         Sh8QMPjc8nYePHDjN2vOG8whQT0SP6BtunW4auKN4Pno11ljPjP3xUo1FAFJaxvjyX2H
         FrOvez4Z8gNzYcmkIVNyBe00EbFZIU2OeORpVTNQEN1wSQndtOaNF/Vi/ZKtky8vj5PX
         cQQg==
X-Forwarded-Encrypted: i=1; AJvYcCV4D/4vNj8wIOQq4NTy/uPQrni9lOGAVjGXZJ9QgqN7frrGeRqa/n9ifhumnWqDrRtzjXI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4+OzFrv4Y7s+QE1LGmGsvpHKuu8+QF93ntgeW3WIkl+eO13kF
	5kr7anwyuuxXkglYXkK2YSeP5mReike/thSWMePSMILWrprWfKarPW4zZXljQLZhuArRQUzzbIu
	DXYNhQXs7jgbCT60IVc57ruUcT952HSFechTK7/fJ9hNTRmQ0de94kQ==
X-Gm-Gg: ASbGncvde5vqODqlcBTRECEw9/OD/kJoJLD5OCL/bOzgTnTGDFUQ7PuWP0S4GWhBGeL
	DROAv2y/ztZC+jfQC9z6xdK0ZE4rVBRbyhUqZhRvnWOpCd+AX8RG53ZyyPHoaCQb5aVlJ1r7F6A
	RMhCZVstvknxY7eKmYdM3DH/Sa2zrL3AK/nlTTWqJVQdgV9W6bRNeUbt6P3FPxKPvAnGigicY6E
	maSVsu2N2vc23/brVPMNASRFKPlbCY/n2QfjfqqHTorw/X3ChJGVCcF/Zlnc9lgT3g/uHKMlLKW
	J8S6rJZwm4boN6zB5yS/TbTMFPnViZpfkZ/1EZNpgqxl+GusahPyjV1zFw0F4fPL+j8OrlBtyXj
	v5MmZlwo6rNd/FQ8oBb77BLpJeJpc8r4+KHi4MM9Jbydv74vuGw==
X-Received: by 2002:a05:600c:8b52:b0:453:5c30:a2c2 with SMTP id 5b1f17b1804b1-4539069a242mr123408425e9.8.1751313795739;
        Mon, 30 Jun 2025 13:03:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGnybVwqBu0Z5mba8MCleb7A5qkZUdaglXad5gWKw1rUpqmEJOjp84Tn3Pjrq4ajq9wmLYReg==
X-Received: by 2002:a05:600c:8b52:b0:453:5c30:a2c2 with SMTP id 5b1f17b1804b1-4539069a242mr123408025e9.8.1751313795119;
        Mon, 30 Jun 2025 13:03:15 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f40:b300:53f7:d260:aff4:7256? (p200300d82f40b30053f7d260aff47256.dip0.t-ipconnect.de. [2003:d8:2f40:b300:53f7:d260:aff4:7256])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a892e5b2a7sm11265634f8f.69.2025.06.30.13.03.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jun 2025 13:03:14 -0700 (PDT)
Message-ID: <923b1c02-407a-4689-a047-dd94e885b103@redhat.com>
Date: Mon, 30 Jun 2025 22:03:11 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 10/18] KVM: x86/mmu: Handle guest page faults for
 guest_memfd with shared memory
To: Shivank Garg <shivankg@amd.com>, Fuad Tabba <tabba@google.com>,
 Ackerley Tng <ackerleytng@google.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev,
 pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org,
 willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, vannapurve@google.com,
 mail@maciej.szmigiero.name, michael.roth@amd.com, wei.w.wang@intel.com,
 liam.merwick@oracle.com, isaku.yamahata@gmail.com,
 kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com,
 steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
 quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
 quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
 quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com,
 yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org,
 will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk,
 shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
 jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250611133330.1514028-1-tabba@google.com>
 <20250611133330.1514028-11-tabba@google.com> <aEyhHgwQXW4zbx-k@google.com>
 <diqz1pr8lndp.fsf@ackerleytng-ctop.c.googlers.com>
 <diqza55tjkk1.fsf@ackerleytng-ctop.c.googlers.com>
 <CA+EHjTxECJ3=ywbAPvpdA1-pm=stXWqU75mgG1epWaXiUr0raw@mail.gmail.com>
 <diqzv7odjnln.fsf@ackerleytng-ctop.c.googlers.com>
 <CA+EHjTwqOwO2zVd4zTYF7w7reTWMNjmCV6XnKux2JtPwYCAoZQ@mail.gmail.com>
 <434ab5a3-fedb-4c9e-8034-8f616b7e5e52@amd.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <434ab5a3-fedb-4c9e-8034-8f616b7e5e52@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 30.06.25 21:26, Shivank Garg wrote:
> On 6/30/2025 8:38 PM, Fuad Tabba wrote:
>> Hi Ackerley,
>>
>> On Mon, 30 Jun 2025 at 15:44, Ackerley Tng <ackerleytng@google.com> wrote:
>>>
>>> Fuad Tabba <tabba@google.com> writes:
>>>
>>>> Hi Ackerley,
>>>>
>>>> On Fri, 27 Jun 2025 at 16:01, Ackerley Tng <ackerleytng@google.com> wrote:
>>>>>
>>>>> Ackerley Tng <ackerleytng@google.com> writes:
>>>>>
>>>>>> [...]
>>>>>
>>>>>>>> +/*
>>>>>>>> + * Returns true if the given gfn's private/shared status (in the CoCo sense) is
>>>>>>>> + * private.
>>>>>>>> + *
>>>>>>>> + * A return value of false indicates that the gfn is explicitly or implicitly
>>>>>>>> + * shared (i.e., non-CoCo VMs).
>>>>>>>> + */
>>>>>>>>   static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>>>>>>>>   {
>>>>>>>> -   return IS_ENABLED(CONFIG_KVM_GMEM) &&
>>>>>>>> -          kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
>>>>>>>> +   struct kvm_memory_slot *slot;
>>>>>>>> +
>>>>>>>> +   if (!IS_ENABLED(CONFIG_KVM_GMEM))
>>>>>>>> +           return false;
>>>>>>>> +
>>>>>>>> +   slot = gfn_to_memslot(kvm, gfn);
>>>>>>>> +   if (kvm_slot_has_gmem(slot) && kvm_gmem_memslot_supports_shared(slot)) {
>>>>>>>> +           /*
>>>>>>>> +            * Without in-place conversion support, if a guest_memfd memslot
>>>>>>>> +            * supports shared memory, then all the slot's memory is
>>>>>>>> +            * considered not private, i.e., implicitly shared.
>>>>>>>> +            */
>>>>>>>> +           return false;
>>>>>>>
>>>>>>> Why!?!?  Just make sure KVM_MEMORY_ATTRIBUTE_PRIVATE is mutually exclusive with
>>>>>>> mappable guest_memfd.  You need to do that no matter what.
>>>>>>
>>>>>> Thanks, I agree that setting KVM_MEMORY_ATTRIBUTE_PRIVATE should be
>>>>>> disallowed for gfn ranges whose slot is guest_memfd-only. Missed that
>>>>>> out. Where do people think we should check the mutual exclusivity?
>>>>>>
>>>>>> In kvm_supported_mem_attributes() I'm thiking that we should still allow
>>>>>> the use of KVM_MEMORY_ATTRIBUTE_PRIVATE for other non-guest_memfd-only
>>>>>> gfn ranges. Or do people think we should just disallow
>>>>>> KVM_MEMORY_ATTRIBUTE_PRIVATE for the entire VM as long as one memslot is
>>>>>> a guest_memfd-only memslot?
>>>>>>
>>>>>> If we check mutually exclusivity when handling
>>>>>> kvm_vm_set_memory_attributes(), as long as part of the range where
>>>>>> KVM_MEMORY_ATTRIBUTE_PRIVATE is requested to be set intersects a range
>>>>>> whose slot is guest_memfd-only, the ioctl will return EINVAL.
>>>>>>
>>>>>
>>>>> At yesterday's (2025-06-26) guest_memfd upstream call discussion,
>>>>>
>>>>> * Fuad brought up a possible use case where within the *same* VM, we
>>>>>    want to allow both memslots that supports and does not support mmap in
>>>>>    guest_memfd.
>>>>> * Shivank suggested a concrete use case for this: the user wants a
>>>>>    guest_memfd memslot that supports mmap just so userspace addresses can
>>>>>    be used as references for specifying memory policy.
>>>>> * Sean then added on that allowing both types of guest_memfd memslots
>>>>>    (support and not supporting mmap) will allow the user to have a second
>>>>>    layer of protection and ensure that for some memslots, the user
>>>>>    expects never to be able to mmap from the memslot.
>>>>>
>>>>> I agree it will be useful to allow both guest_memfd memslots that
>>>>> support and do not support mmap in a single VM.
>>>>>
>>>>> I think I found an issue with flags, which is that GUEST_MEMFD_FLAG_MMAP
>>>>> should not imply that the guest_memfd will provide memory for all guest
>>>>> faults within the memslot's gfn range (KVM_MEMSLOT_GMEM_ONLY).
>>>>>
>>>>> For the use case Shivank raised, if the user wants a guest_memfd memslot
>>>>> that supports mmap just so userspace addresses can be used as references
>>>>> for specifying memory policy for legacy Coco VMs where shared memory
>>>>> should still come from other sources, GUEST_MEMFD_FLAG_MMAP will be set,
>>>>> but KVM can't fault shared memory from guest_memfd. Hence,
>>>>> GUEST_MEMFD_FLAG_MMAP should not imply KVM_MEMSLOT_GMEM_ONLY.
>>>>>
>>>>> Thinking forward, if we want guest_memfd to provide (no-mmap) protection
>>>>> even for non-CoCo VMs (such that perhaps initial VM image is populated
>>>>> and then VM memory should never be mmap-ed at all), we will want
>>>>> guest_memfd to be the source of memory even if GUEST_MEMFD_FLAG_MMAP is
>>>>> not set.
>>>>>
>>>>> I propose that we should have a single VM-level flag to solve this (in
>>>>> line with Sean's guideline that we should just move towards what we want
>>>>> and not support non-existent use cases): something like
>>>>> KVM_CAP_PREFER_GMEM.
>>>>>
>>>>> If KVM_CAP_PREFER_GMEM_MEMORY is set,
>>>>>
>>>>> * memory for any gfn range in a guest_memfd memslot will be requested
>>>>>    from guest_memfd
>>>>> * any privacy status queries will also be directed to guest_memfd
>>>>> * KVM_MEMORY_ATTRIBUTE_PRIVATE will not be a valid attribute
>>>>>
>>>>> KVM_CAP_PREFER_GMEM_MEMORY will be orthogonal with no validation on
>>>>> GUEST_MEMFD_FLAG_MMAP, which should just purely guard mmap support in
>>>>> guest_memfd.
>>>>>
>>>>> Here's a table that I set up [1]. I believe the proposed
>>>>> KVM_CAP_PREFER_GMEM_MEMORY (column 7) lines up with requirements
>>>>> (columns 1 to 4) correctly.
>>>>>
>>>>> [1] https://lpc.events/event/18/contributions/1764/attachments/1409/3710/guest_memfd%20use%20cases%20vs%20guest_memfd%20flags%20and%20privacy%20tracking.pdf
>>>>
>>>> I'm not sure this naming helps. What does "prefer" imply here? If the
>>>> caller from user space does not prefer, does it mean that they
>>>> mind/oppose?
>>>>
>>>
>>> Sorry, bad naming.
>>>
>>> I used "prefer" because some memslots may not have guest_memfd at
>>> all. To clarify, a "guest_memfd memslot" is a memslot that has some
>>> valid guest_memfd fd and offset. The memslot may also have a valid
>>> userspace_addr configured, either mmap-ed from the same guest_memfd fd
>>> or from some other backing memory (for legacy CoCo VMs), or NULL for
>>> userspace_addr.
>>>
>>> I meant to have the CAP enable KVM_MEMSLOT_GMEM_ONLY of this patch
>>> series for all memslots that have some valid guest_memfd fd and offset,
>>> except if we have a VM-level CAP, KVM_MEMSLOT_GMEM_ONLY should be moved
>>> to the VM level.
>>
>> Regardless of the name, I feel that this functionality at best does
>> not belong in this series, and potentially adds more confusion.
>>
>> Userspace should be specific about what it wants, and they know what
>> kind of memslots there are in the VM: userspace creates them. In that
>> case, userspace can either create a legacy memslot, no need for any of
>> the new flags, or it can create a guest_memfd memslot, and then use
>> any new flags to qualify that. Having a flag/capability that means
>> something for guest_memfd memslots, but effectively keeps the same
>> behavior for legacy ones seems to add more confusion.
>>
>>>> Regarding the use case Shivank mentioned, mmaping for policy, while
>>>> the use case is a valid one, the raison d'être of mmap is to map into
>>>> user space (i.e., fault it in). I would argue that if you opt into
>>>> mmap, you are doing it to be able to access it.
>>>
>>> The above is in conflict with what was discussed on 2025-06-26 IIUC.
>>>
>>> Shivank brought up the case of enabling mmap *only* to be able to set
>>> mempolicy using the VMAs, and Sean (IIUC) later agreed we should allow
>>> userspace to only enable mmap but still disable faults, so that userspace
>>> is given additional protection, such that even if a (compromised)
>>> userspace does a private-to-shared conversion, userspace is still not
>>> allowed to fault in the page.
>>
>> I don't think there's a conflict :)  What I think is this is outside
>> of the scope of this series for a few reasons:
>>
>> - This is prior to the mempolicy work (and is the base for it)
>> - If we need to, we can add a flag later to restrict mmap faulting
>> - Once we get in-place conversion, the mempolicy work could use the
>> ability to disallow mapping for private memory
>>
>> By actually implementing something now, we would be restricting the
>> mempolicy work, rather than helping it, since we would effectively be
>> deciding now how that work should proceed. By keeping this the way it
>> is now, the mempolicy work can explore various alternatives.
>>
>> I think we discussed this in the guest_memfd sync of 2025-06-12, and I
>> think this was roughly our conclusion.
>>
>>> Hence, if we want to support mmaping just for policy and continue to
>>> restrict faulting, then GUEST_MEMFD_FLAG_MMAP should not imply
>>> KVM_MEMSLOT_GMEM_ONLY.
>>>
>>>> To me, that seems like
>>>> something that merits its own flag, rather than mmap. Also, I recall
>>>> that we said that later on, with inplace conversion, that won't be
>>>> even necessary.
>>>
>>> On x86, as of now I believe we're going with an ioctl that does *not*
>>> check what the guest prefers and will go ahead to perform the
>>> private-to-shared conversion, which will go ahead to update
>>> shareability.
>>
>> Here I think you're making my case that we're dragging more complexity
>> from future work/series into this series, since now we're going into
>> the IOCTLs for the conversion series :)
>>
>>>> In other words, this would also be trying to solve a
>>>> problem that we haven't yet encountered and that we have a solution
>>>> for anyway.
>>>>
>>>
>>> So we don't have a solution for the use case where userspace wants to
>>> mmap but never fault for userspace's protection from stray
>>> private-to-shared conversions, unless we decouple GUEST_MEMFD_FLAG_MMAP
>>> and KVM_MEMSLOT_GMEM_ONLY.
>>>
>>>> I think that, unless anyone disagrees, is to go ahead with the names
>>>> we discussed in the last meeting. They seem to be the ones that make
>>>> the most sense for the upcoming use cases.
>>>>
>>>
>>> We could also discuss if we really want to support the use case where
>>> userspace wants to mmap but never fault for userspace's protection from
>>> stray private-to-shared conversions.
>>
>> I would really rather defer that work to when it's needed. It seems
>> that we should aim to land this series as soon as possible, since it's
>> the one blocking much of the future work. As far as I can tell,
>> nothing here precludes introducing the mechanism of supporting the
>> case where userspace wants to mmap but never fault, once it's needed.
>> This was I believe what we had agreed on in the sync on 2025-06-26.
> 
> I support this approach.

Agreed. Let's get this in with the changes requested by Sean applied.

How to use GUEST_MEMFD_FLAG_MMAP in combination with a CoCo VM with 
legacy mem attributes (-> all memory in guest_memfd private) could be 
added later on top, once really required.

As discussed, CoCo VMs that want to support GUEST_MEMFD_FLAG_MMAP will 
have to disable legacy mem attributes using a new capability in stage-2.

-- 
Cheers,

David / dhildenb


