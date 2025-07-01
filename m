Return-Path: <kvm+bounces-51194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B25CAEFBF4
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 16:19:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 826944E348C
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 14:17:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFF24278744;
	Tue,  1 Jul 2025 14:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dSG5lM2q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E90D278142
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 14:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751379341; cv=none; b=rH0OaAiGZP6fPqlJC68nMjSer5Q7PLfs+tDqm8050Or1+7ifgKO7cJebfQRXvSoYpJ+XB/DY7AKPMb9AeMT8PFfjlfl4+28DEglATvBJNMi9TqvtnZl/4rXcT4Dax2Bv2N7xKk5bKNvn2NxQiIxAZr7SZ6iN2EtISCLpqHkI4yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751379341; c=relaxed/simple;
	bh=XJLGkDNXJ0JuowlKxlL3yp6HD/pyiftaQrvTUuD/YuI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lXjJxuT2Buq0UGDSgiN8jD5GYkay9haCuL/26h4RtI4BSKyeu4fDrY4Ar2m33Np8b9B/kU+55ajv4yf4RVLdtbX6XOn23/yz6QljNggFD7bfkObAQnZGm+U/wWfz4qE3N6SWc7V+97r2gJAK1e+barpKXDfFtEoRShKl+UPxYJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dSG5lM2q; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-74ad608d60aso3115962b3a.1
        for <kvm@vger.kernel.org>; Tue, 01 Jul 2025 07:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751379339; x=1751984139; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vN/E7b0UOrsRNuPjjIBnTzqCIHznXhChVkNuGJXxsvs=;
        b=dSG5lM2q22ZwI3uChtl4flqtyTHCga9W74qy8nXfcbtTVZbr8nXa1VKaQIDAR0bVuW
         jZaeCOH3KqBT3n26Yq5jw8Rx3OMC4CB3OMfSlHh9iPnvInT2Ma6/qG8kM0E5l/5LAaUg
         pRIcVrz4DTFSeq26hYHALRYH77MY1cmY9gWi+doD9aYnV6NgHcoxhjr7MGVGUKfAjk/m
         yQ9qQ09Fy3ebHlWNGnzMWTUXwPFAmC+v0SiGojuAwwSPDZLXyOiQ2GbHNkmnOHFBgsRO
         RSiHtKUdfLhnDOYEPYczLPmcBVIV16+6P997lINIxQTXmgnlan2O62s5oMztsdL2xBB2
         CYgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751379339; x=1751984139;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vN/E7b0UOrsRNuPjjIBnTzqCIHznXhChVkNuGJXxsvs=;
        b=NxdnXOkTI4raarwgX6GhgB0w7BI2dONFTbYtCPRE34f0LElMvwF/FMbeZq7lELDOnm
         f1qCK2Zp7jMobD05uXP9v8A4wCLdgGcR8qOxqburGd4ASPH6yoVEusSqAtLcm9HBBRQK
         suiOfymupgGwNTqS+EIMncSWFdy8jgcmVzB0pCMgC8OSLr5NtqGmyuGsgNcCdkWNZPvz
         DVNR+rBBJUNIUizdETADyd3kbwYSeoM9Z+mzI1FdK6iogIq4BW1/tir4mo0p4UbuWnct
         Y3Xlb38ESmPgpGcsibnvIA4R64Go12DE1QPAtRZcNO5ePsxIQk3dHXlVUZWTdDwezzF5
         OVVw==
X-Forwarded-Encrypted: i=1; AJvYcCX1hw9NQMJRYSQC2yb0RCZx66a6Tq9Ra5WJWur61+xuIMnIdVC7u5YS3o5TMcfcP7NpNdo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmwTOhCWNQGL6hpUE9TEBHdWU2gGGCcIyhfouOvnYfCkh+nBO6
	Ue1oSgxylZK5Hv8ZjLKym1crOi/8ZhAgECMoehBnNFTPc67O2qptbYdSGdKXrLx01spflDEvoSh
	4igIDKVD1C33B+xl923PEksEGaQ==
X-Google-Smtp-Source: AGHT+IHMZR3wYB8ZZyCxXUTx1Jnjhbyg4vqWu+KzoOjmhZ9RCI6olxi5Hqf3ckApc0g71m/KsrOJSiWFthrldVVzeg==
X-Received: from pfbhb2.prod.google.com ([2002:a05:6a00:8582:b0:748:f16c:14c5])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:c90:b0:742:4545:2d2b with SMTP id d2e1a72fcca58-74af6e39a7dmr24529506b3a.3.1751379338442;
 Tue, 01 Jul 2025 07:15:38 -0700 (PDT)
Date: Tue, 01 Jul 2025 07:15:37 -0700
In-Reply-To: <923b1c02-407a-4689-a047-dd94e885b103@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com> <20250611133330.1514028-11-tabba@google.com>
 <aEyhHgwQXW4zbx-k@google.com> <diqz1pr8lndp.fsf@ackerleytng-ctop.c.googlers.com>
 <diqza55tjkk1.fsf@ackerleytng-ctop.c.googlers.com> <CA+EHjTxECJ3=ywbAPvpdA1-pm=stXWqU75mgG1epWaXiUr0raw@mail.gmail.com>
 <diqzv7odjnln.fsf@ackerleytng-ctop.c.googlers.com> <CA+EHjTwqOwO2zVd4zTYF7w7reTWMNjmCV6XnKux2JtPwYCAoZQ@mail.gmail.com>
 <434ab5a3-fedb-4c9e-8034-8f616b7e5e52@amd.com> <923b1c02-407a-4689-a047-dd94e885b103@redhat.com>
Message-ID: <diqz34bg575i.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v12 10/18] KVM: x86/mmu: Handle guest page faults for
 guest_memfd with shared memory
From: Ackerley Tng <ackerleytng@google.com>
To: David Hildenbrand <david@redhat.com>, Shivank Garg <shivankg@amd.com>, Fuad Tabba <tabba@google.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com, 
	pankaj.gupta@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

David Hildenbrand <david@redhat.com> writes:

> On 30.06.25 21:26, Shivank Garg wrote:
>> On 6/30/2025 8:38 PM, Fuad Tabba wrote:
>>> Hi Ackerley,
>>>
>>> On Mon, 30 Jun 2025 at 15:44, Ackerley Tng <ackerleytng@google.com> wro=
te:
>>>>
>>>> Fuad Tabba <tabba@google.com> writes:
>>>>
>>>>> Hi Ackerley,
>>>>>
>>>>> On Fri, 27 Jun 2025 at 16:01, Ackerley Tng <ackerleytng@google.com> w=
rote:
>>>>>>
>>>>>> Ackerley Tng <ackerleytng@google.com> writes:
>>>>>>
>>>>>>> [...]
>>>>>>
>>>>>>>>> +/*
>>>>>>>>> + * Returns true if the given gfn's private/shared status (in the=
 CoCo sense) is
>>>>>>>>> + * private.
>>>>>>>>> + *
>>>>>>>>> + * A return value of false indicates that the gfn is explicitly =
or implicitly
>>>>>>>>> + * shared (i.e., non-CoCo VMs).
>>>>>>>>> + */
>>>>>>>>>   static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gf=
n)
>>>>>>>>>   {
>>>>>>>>> -   return IS_ENABLED(CONFIG_KVM_GMEM) &&
>>>>>>>>> -          kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRI=
BUTE_PRIVATE;
>>>>>>>>> +   struct kvm_memory_slot *slot;
>>>>>>>>> +
>>>>>>>>> +   if (!IS_ENABLED(CONFIG_KVM_GMEM))
>>>>>>>>> +           return false;
>>>>>>>>> +
>>>>>>>>> +   slot =3D gfn_to_memslot(kvm, gfn);
>>>>>>>>> +   if (kvm_slot_has_gmem(slot) && kvm_gmem_memslot_supports_shar=
ed(slot)) {
>>>>>>>>> +           /*
>>>>>>>>> +            * Without in-place conversion support, if a guest_me=
mfd memslot
>>>>>>>>> +            * supports shared memory, then all the slot's memory=
 is
>>>>>>>>> +            * considered not private, i.e., implicitly shared.
>>>>>>>>> +            */
>>>>>>>>> +           return false;
>>>>>>>>
>>>>>>>> Why!?!?  Just make sure KVM_MEMORY_ATTRIBUTE_PRIVATE is mutually e=
xclusive with
>>>>>>>> mappable guest_memfd.  You need to do that no matter what.
>>>>>>>
>>>>>>> Thanks, I agree that setting KVM_MEMORY_ATTRIBUTE_PRIVATE should be
>>>>>>> disallowed for gfn ranges whose slot is guest_memfd-only. Missed th=
at
>>>>>>> out. Where do people think we should check the mutual exclusivity?
>>>>>>>
>>>>>>> In kvm_supported_mem_attributes() I'm thiking that we should still =
allow
>>>>>>> the use of KVM_MEMORY_ATTRIBUTE_PRIVATE for other non-guest_memfd-o=
nly
>>>>>>> gfn ranges. Or do people think we should just disallow
>>>>>>> KVM_MEMORY_ATTRIBUTE_PRIVATE for the entire VM as long as one memsl=
ot is
>>>>>>> a guest_memfd-only memslot?
>>>>>>>
>>>>>>> If we check mutually exclusivity when handling
>>>>>>> kvm_vm_set_memory_attributes(), as long as part of the range where
>>>>>>> KVM_MEMORY_ATTRIBUTE_PRIVATE is requested to be set intersects a ra=
nge
>>>>>>> whose slot is guest_memfd-only, the ioctl will return EINVAL.
>>>>>>>
>>>>>>
>>>>>> At yesterday's (2025-06-26) guest_memfd upstream call discussion,
>>>>>>
>>>>>> * Fuad brought up a possible use case where within the *same* VM, we
>>>>>>    want to allow both memslots that supports and does not support mm=
ap in
>>>>>>    guest_memfd.
>>>>>> * Shivank suggested a concrete use case for this: the user wants a
>>>>>>    guest_memfd memslot that supports mmap just so userspace addresse=
s can
>>>>>>    be used as references for specifying memory policy.
>>>>>> * Sean then added on that allowing both types of guest_memfd memslot=
s
>>>>>>    (support and not supporting mmap) will allow the user to have a s=
econd
>>>>>>    layer of protection and ensure that for some memslots, the user
>>>>>>    expects never to be able to mmap from the memslot.
>>>>>>
>>>>>> I agree it will be useful to allow both guest_memfd memslots that
>>>>>> support and do not support mmap in a single VM.
>>>>>>
>>>>>> I think I found an issue with flags, which is that GUEST_MEMFD_FLAG_=
MMAP
>>>>>> should not imply that the guest_memfd will provide memory for all gu=
est
>>>>>> faults within the memslot's gfn range (KVM_MEMSLOT_GMEM_ONLY).
>>>>>>
>>>>>> For the use case Shivank raised, if the user wants a guest_memfd mem=
slot
>>>>>> that supports mmap just so userspace addresses can be used as refere=
nces
>>>>>> for specifying memory policy for legacy Coco VMs where shared memory
>>>>>> should still come from other sources, GUEST_MEMFD_FLAG_MMAP will be =
set,
>>>>>> but KVM can't fault shared memory from guest_memfd. Hence,
>>>>>> GUEST_MEMFD_FLAG_MMAP should not imply KVM_MEMSLOT_GMEM_ONLY.
>>>>>>
>>>>>> Thinking forward, if we want guest_memfd to provide (no-mmap) protec=
tion
>>>>>> even for non-CoCo VMs (such that perhaps initial VM image is populat=
ed
>>>>>> and then VM memory should never be mmap-ed at all), we will want
>>>>>> guest_memfd to be the source of memory even if GUEST_MEMFD_FLAG_MMAP=
 is
>>>>>> not set.
>>>>>>
>>>>>> I propose that we should have a single VM-level flag to solve this (=
in
>>>>>> line with Sean's guideline that we should just move towards what we =
want
>>>>>> and not support non-existent use cases): something like
>>>>>> KVM_CAP_PREFER_GMEM.
>>>>>>
>>>>>> If KVM_CAP_PREFER_GMEM_MEMORY is set,
>>>>>>
>>>>>> * memory for any gfn range in a guest_memfd memslot will be requeste=
d
>>>>>>    from guest_memfd
>>>>>> * any privacy status queries will also be directed to guest_memfd
>>>>>> * KVM_MEMORY_ATTRIBUTE_PRIVATE will not be a valid attribute
>>>>>>
>>>>>> KVM_CAP_PREFER_GMEM_MEMORY will be orthogonal with no validation on
>>>>>> GUEST_MEMFD_FLAG_MMAP, which should just purely guard mmap support i=
n
>>>>>> guest_memfd.
>>>>>>
>>>>>> Here's a table that I set up [1]. I believe the proposed
>>>>>> KVM_CAP_PREFER_GMEM_MEMORY (column 7) lines up with requirements
>>>>>> (columns 1 to 4) correctly.
>>>>>>
>>>>>> [1] https://lpc.events/event/18/contributions/1764/attachments/1409/=
3710/guest_memfd%20use%20cases%20vs%20guest_memfd%20flags%20and%20privacy%2=
0tracking.pdf
>>>>>
>>>>> I'm not sure this naming helps. What does "prefer" imply here? If the
>>>>> caller from user space does not prefer, does it mean that they
>>>>> mind/oppose?
>>>>>
>>>>
>>>> Sorry, bad naming.
>>>>
>>>> I used "prefer" because some memslots may not have guest_memfd at
>>>> all. To clarify, a "guest_memfd memslot" is a memslot that has some
>>>> valid guest_memfd fd and offset. The memslot may also have a valid
>>>> userspace_addr configured, either mmap-ed from the same guest_memfd fd
>>>> or from some other backing memory (for legacy CoCo VMs), or NULL for
>>>> userspace_addr.
>>>>
>>>> I meant to have the CAP enable KVM_MEMSLOT_GMEM_ONLY of this patch
>>>> series for all memslots that have some valid guest_memfd fd and offset=
,
>>>> except if we have a VM-level CAP, KVM_MEMSLOT_GMEM_ONLY should be move=
d
>>>> to the VM level.
>>>
>>> Regardless of the name, I feel that this functionality at best does
>>> not belong in this series, and potentially adds more confusion.
>>>
>>> Userspace should be specific about what it wants, and they know what
>>> kind of memslots there are in the VM: userspace creates them. In that
>>> case, userspace can either create a legacy memslot, no need for any of
>>> the new flags, or it can create a guest_memfd memslot, and then use
>>> any new flags to qualify that. Having a flag/capability that means
>>> something for guest_memfd memslots, but effectively keeps the same
>>> behavior for legacy ones seems to add more confusion.
>>>
>>>>> Regarding the use case Shivank mentioned, mmaping for policy, while
>>>>> the use case is a valid one, the raison d'=C3=AAtre of mmap is to map=
 into
>>>>> user space (i.e., fault it in). I would argue that if you opt into
>>>>> mmap, you are doing it to be able to access it.
>>>>
>>>> The above is in conflict with what was discussed on 2025-06-26 IIUC.
>>>>
>>>> Shivank brought up the case of enabling mmap *only* to be able to set
>>>> mempolicy using the VMAs, and Sean (IIUC) later agreed we should allow
>>>> userspace to only enable mmap but still disable faults, so that usersp=
ace
>>>> is given additional protection, such that even if a (compromised)
>>>> userspace does a private-to-shared conversion, userspace is still not
>>>> allowed to fault in the page.
>>>
>>> I don't think there's a conflict :)  What I think is this is outside
>>> of the scope of this series for a few reasons:
>>>
>>> - This is prior to the mempolicy work (and is the base for it)
>>> - If we need to, we can add a flag later to restrict mmap faulting
>>> - Once we get in-place conversion, the mempolicy work could use the
>>> ability to disallow mapping for private memory
>>>
>>> By actually implementing something now, we would be restricting the
>>> mempolicy work, rather than helping it, since we would effectively be
>>> deciding now how that work should proceed. By keeping this the way it
>>> is now, the mempolicy work can explore various alternatives.
>>>
>>> I think we discussed this in the guest_memfd sync of 2025-06-12, and I
>>> think this was roughly our conclusion.
>>>
>>>> Hence, if we want to support mmaping just for policy and continue to
>>>> restrict faulting, then GUEST_MEMFD_FLAG_MMAP should not imply
>>>> KVM_MEMSLOT_GMEM_ONLY.
>>>>
>>>>> To me, that seems like
>>>>> something that merits its own flag, rather than mmap. Also, I recall
>>>>> that we said that later on, with inplace conversion, that won't be
>>>>> even necessary.
>>>>
>>>> On x86, as of now I believe we're going with an ioctl that does *not*
>>>> check what the guest prefers and will go ahead to perform the
>>>> private-to-shared conversion, which will go ahead to update
>>>> shareability.
>>>
>>> Here I think you're making my case that we're dragging more complexity
>>> from future work/series into this series, since now we're going into
>>> the IOCTLs for the conversion series :)
>>>
>>>>> In other words, this would also be trying to solve a
>>>>> problem that we haven't yet encountered and that we have a solution
>>>>> for anyway.
>>>>>
>>>>
>>>> So we don't have a solution for the use case where userspace wants to
>>>> mmap but never fault for userspace's protection from stray
>>>> private-to-shared conversions, unless we decouple GUEST_MEMFD_FLAG_MMA=
P
>>>> and KVM_MEMSLOT_GMEM_ONLY.
>>>>
>>>>> I think that, unless anyone disagrees, is to go ahead with the names
>>>>> we discussed in the last meeting. They seem to be the ones that make
>>>>> the most sense for the upcoming use cases.
>>>>>
>>>>
>>>> We could also discuss if we really want to support the use case where
>>>> userspace wants to mmap but never fault for userspace's protection fro=
m
>>>> stray private-to-shared conversions.
>>>
>>> I would really rather defer that work to when it's needed. It seems
>>> that we should aim to land this series as soon as possible, since it's
>>> the one blocking much of the future work. As far as I can tell,
>>> nothing here precludes introducing the mechanism of supporting the
>>> case where userspace wants to mmap but never fault, once it's needed.
>>> This was I believe what we had agreed on in the sync on 2025-06-26.
>>=20
>> I support this approach.
>
> Agreed. Let's get this in with the changes requested by Sean applied.
>
> How to use GUEST_MEMFD_FLAG_MMAP in combination with a CoCo VM with=20
> legacy mem attributes (-> all memory in guest_memfd private) could be=20
> added later on top, once really required.
>
> As discussed, CoCo VMs that want to support GUEST_MEMFD_FLAG_MMAP will=20
> have to disable legacy mem attributes using a new capability in stage-2.
>

I rewatched the guest_memfd meeting on 2025-06-12.  We do want to
support the use case where userspace wants to have mmap (e.g. to set
mempolicy) but does not want to allow faulting into the host.

On 2025-06-12, the conclusion was that the problem will be solved once
guest_memfd supports shareability, and that's because userspace can set
shareability to GUEST, so the memory can't be faulted into the host.

On 2025-06-26, Sean said we want to let userspace have an extra layer of
protection so that memory cannot be faulted in to the host, ever. IOW,
we want to let userspace say that even if there is a stray
private-to-shared conversion, *don't* allow faulting memory into the
host.

The difference is the "extra layer of protection", which should remain
in effect even if there are (stray/unexpected) private-to-shared
conversions to guest_memfd or to KVM. Here's a direct link to the point
in the video where Sean brought this up [1]. I'm really hoping I didn't
misinterpret this!

Let me look ahead a little, since this involves use cases already
brought up though I'm not sure how real they are. I just want to make
sure that in a few patch series' time, we don't end up needing userspace
to use a complex bunch of CAPs and FLAGs.

In this series (mmap support, V12, patch 10/18) [2], to allow
KVM_X86_DEFAULT_VMs to use guest_memfd, I added a `fault_from_gmem()`
helper, which is defined as follows (before the renaming Sean requested):

+static inline bool fault_from_gmem(struct kvm_page_fault *fault)
+{
+	return fault->is_private || kvm_gmem_memslot_supports_shared(fault->slot)=
;
+}

The above is changeable, of course :). The intention is that if the
fault is private, fault from guest_memfd. If GUEST_MEMFD_FLAG_MMAP is
set (KVM_MEMSLOT_GMEM_ONLY will be set on the memslot), fault from
guest_memfd.

If we defer handling GUEST_MEMFD_FLAG_MMAP in combination with a CoCo VM
with legacy mem attributes to the future, this helper will probably
become

-static inline bool fault_from_gmem(struct kvm_page_fault *fault)
+static inline bool fault_from_gmem(struct kvm *kvm, struct kvm_page_fault =
*fault)
+{
-	return fault->is_private || kvm_gmem_memslot_supports_shared(fault->slot)=
;
+	return fault->is_private || (kvm_gmem_memslot_supports_shared(fault->slot=
) &&
+	                             !kvm_arch_disable_legacy_private_tracking(kv=
m));
+}

And on memslot binding we check

if kvm_arch_disable_legacy_private_tracking(kvm) and not GUEST_MEMFD_FLAG_M=
MAP
	return -EINVAL;

1. Is that what yall meant?

2. Does this kind of not satisfy the "extra layer of protection"
   requirement (if it is a requirement)?

   A legacy CoCo VM using guest_memfd only for private memory (shared
   memory from say, shmem) and needing to set mempolicy would
  =20
   * Set GUEST_MEMFD_FLAG_MMAP
   * Leave KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING defaulted to false
  =20
   but still be able to send conversion ioctls directly to guest_memfd,
   and then be able to fault guest_memfd memory into the host.

3. Now for a use case I've heard of (feel free to tell me this will
   never be supported or "we'll deal with it if it comes"): On a
   non-CoCo VM, we want to use guest_memfd but not use mmap (and the
   initial VM image will be written using write() syscall or something
   else).

   * Set GUEST_MEMFD_FLAG_MMAP to false
   * Leave KVM_CAP_DISABLE_LEGACY_PRIVATE_TRACKING defaulted to false
     (it's a non-CoCo VM, weird to do anything to do with private
     tracking)

   And now we're stuck because fault_from_gmem() will return false all
   the time and we can't use memory from guest_memfd.

[1] https://youtu.be/7b5hgKHoZoY?t=3D1162s
[2] https://lore.kernel.org/all/20250611133330.1514028-11-tabba@google.com/

> --=20
> Cheers,
>
> David / dhildenb

