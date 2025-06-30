Return-Path: <kvm+bounces-51101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 77FB1AEE15E
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 16:48:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A171C1BC12AD
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 14:46:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0160328D827;
	Mon, 30 Jun 2025 14:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uJz4Uok9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D87228C037
	for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 14:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751294664; cv=none; b=bBeRkWRS68FhPgQf3x0BtbTSgJAONPdNioRDMzZE6TRzyc6o0Ir+GBYkPxZuvX0eYKQtp/rGf6pYOctPFItjpVCZACxNNAy3qzXUGiubtgwnfTCF3yzTnQxjFnoP6Sdb1z7UK6BJH6p0M4+ahOahzi7hDupJnUsKzxIpN7Gu660=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751294664; c=relaxed/simple;
	bh=Cpd21zH982h2AGMdmVSF+i8x16jkxQRASXJ7Tm/3Uxs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RXeA0Pcm0HYTvXY77yaCO8wgaldR08zy17Zk6FMtY+7mbSrGA1xpBdWP/DrxFkatbgcZcteqMSApW3FjYf1i2ljZFeeoOmcshd0kIrQhpxdBIa6DOA4FoXSKlS2cydKvrZPAP7gJyQBX6K9VIW+7SEjpcTKPh1uiAXRTz3p6Cek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uJz4Uok9; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7377139d8b1so1726593b3a.0
        for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 07:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751294662; x=1751899462; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WDNBu9w19s+kAcSrRe9w5bRPZMQtJhhAx+mG+VBvNKk=;
        b=uJz4Uok9Mttsx8ypH8TQMpxQ+lGXa//kM2e8MgCgGwHBJOLnLi9bdNtdr7lf0z5IUU
         K88uKfl7yVfso9PNuxMcrxRZ9630SyJh2Si7mq1JSlqyTw2Q9yEILnnYtndwmrExskuP
         gBtY2swpCD3EQm6DYI0KX37tNVqpxlNPzoO92hsoVlU8eCjEQr5G6jSR/54xARcPr5Ah
         2YaZ851CCrPM2eNSA5RA/CsdL2msr6yjPGzhS0vULJshYNpFxG9vEkNCQIFeiJMfGDHX
         KfH10HU7tyb3hMbfkv+MLIDPBsx/CEN7sRG9ce6LJC5mFm6TRhI2/bbIAy88QzBIwafj
         2D3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751294662; x=1751899462;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WDNBu9w19s+kAcSrRe9w5bRPZMQtJhhAx+mG+VBvNKk=;
        b=uFs3TjVf9bP+2v/3kku2Uo5zrzHQ+bZcfIAVSZdrJ7LWJtsyLDNO9XXMKN0Kxy/eLA
         FwT2+bMb8oXQmdp1gQbyHZ6AAigyQlhrUbomaBeflP958Q1+r2bBROEf1Akn0RD0jXQc
         dk/4wYvBeLSQM9D3Wt2FkUKFn+A5shlXxGSdYk+f5WSjGJ+PY2MFOisub4J02QlXmM3+
         lpef63E6hhbuQeG+cs1zVELP+R5rPPGHWOC433ovMLFEzndX1xyd8p5b7eWLGXgNx+no
         BvQlWPgqy1ZdztvUEqFmBoLgjdgptCxRKI99oCz6TH8KLyAdF7ZJdv+OdQLEVdP25aNl
         prpQ==
X-Forwarded-Encrypted: i=1; AJvYcCV10LeoVku/2eChEek+rzALqzDunPv3jAUF4+n0R75xPQkKDXQrJyo6vF+1Dk0WBzOFUfs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyjrs0KcwQ9kaxIkxXEFGgVG2zvlITeVQIqb7+kfimTk19GWJsG
	QcPcZcZ79iQRHa/n4suuW/7frjOt8dKBlJNV/hqaEQz9qBPjPGUIUbtseOfYgIWqaJn0t5p5LJk
	Rj31UvD2TIq5ys1M9tpKgomw9nA==
X-Google-Smtp-Source: AGHT+IFunOp0qoSe6XZoJHonOUytaiBByj0BZgN04binEVTRRYUnTm4vU2sNBIU0+S9DVAea3Y9BNG9BxDYxIWzIkQ==
X-Received: from pghp6.prod.google.com ([2002:a63:fe06:0:b0:b34:c533:cd4e])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:4683:b0:220:245d:a30b with SMTP id adf61e73a8af0-220a17e9d75mr20279198637.38.1751294661741;
 Mon, 30 Jun 2025 07:44:21 -0700 (PDT)
Date: Mon, 30 Jun 2025 07:44:20 -0700
In-Reply-To: <CA+EHjTxECJ3=ywbAPvpdA1-pm=stXWqU75mgG1epWaXiUr0raw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com> <20250611133330.1514028-11-tabba@google.com>
 <aEyhHgwQXW4zbx-k@google.com> <diqz1pr8lndp.fsf@ackerleytng-ctop.c.googlers.com>
 <diqza55tjkk1.fsf@ackerleytng-ctop.c.googlers.com> <CA+EHjTxECJ3=ywbAPvpdA1-pm=stXWqU75mgG1epWaXiUr0raw@mail.gmail.com>
Message-ID: <diqzv7odjnln.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v12 10/18] KVM: x86/mmu: Handle guest page faults for
 guest_memfd with shared memory
From: Ackerley Tng <ackerleytng@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Fuad Tabba <tabba@google.com> writes:

> Hi Ackerley,
>
> On Fri, 27 Jun 2025 at 16:01, Ackerley Tng <ackerleytng@google.com> wrote=
:
>>
>> Ackerley Tng <ackerleytng@google.com> writes:
>>
>> > [...]
>>
>> >>> +/*
>> >>> + * Returns true if the given gfn's private/shared status (in the Co=
Co sense) is
>> >>> + * private.
>> >>> + *
>> >>> + * A return value of false indicates that the gfn is explicitly or =
implicitly
>> >>> + * shared (i.e., non-CoCo VMs).
>> >>> + */
>> >>>  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>> >>>  {
>> >>> -   return IS_ENABLED(CONFIG_KVM_GMEM) &&
>> >>> -          kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUT=
E_PRIVATE;
>> >>> +   struct kvm_memory_slot *slot;
>> >>> +
>> >>> +   if (!IS_ENABLED(CONFIG_KVM_GMEM))
>> >>> +           return false;
>> >>> +
>> >>> +   slot =3D gfn_to_memslot(kvm, gfn);
>> >>> +   if (kvm_slot_has_gmem(slot) && kvm_gmem_memslot_supports_shared(=
slot)) {
>> >>> +           /*
>> >>> +            * Without in-place conversion support, if a guest_memfd=
 memslot
>> >>> +            * supports shared memory, then all the slot's memory is
>> >>> +            * considered not private, i.e., implicitly shared.
>> >>> +            */
>> >>> +           return false;
>> >>
>> >> Why!?!?  Just make sure KVM_MEMORY_ATTRIBUTE_PRIVATE is mutually excl=
usive with
>> >> mappable guest_memfd.  You need to do that no matter what.
>> >
>> > Thanks, I agree that setting KVM_MEMORY_ATTRIBUTE_PRIVATE should be
>> > disallowed for gfn ranges whose slot is guest_memfd-only. Missed that
>> > out. Where do people think we should check the mutual exclusivity?
>> >
>> > In kvm_supported_mem_attributes() I'm thiking that we should still all=
ow
>> > the use of KVM_MEMORY_ATTRIBUTE_PRIVATE for other non-guest_memfd-only
>> > gfn ranges. Or do people think we should just disallow
>> > KVM_MEMORY_ATTRIBUTE_PRIVATE for the entire VM as long as one memslot =
is
>> > a guest_memfd-only memslot?
>> >
>> > If we check mutually exclusivity when handling
>> > kvm_vm_set_memory_attributes(), as long as part of the range where
>> > KVM_MEMORY_ATTRIBUTE_PRIVATE is requested to be set intersects a range
>> > whose slot is guest_memfd-only, the ioctl will return EINVAL.
>> >
>>
>> At yesterday's (2025-06-26) guest_memfd upstream call discussion,
>>
>> * Fuad brought up a possible use case where within the *same* VM, we
>>   want to allow both memslots that supports and does not support mmap in
>>   guest_memfd.
>> * Shivank suggested a concrete use case for this: the user wants a
>>   guest_memfd memslot that supports mmap just so userspace addresses can
>>   be used as references for specifying memory policy.
>> * Sean then added on that allowing both types of guest_memfd memslots
>>   (support and not supporting mmap) will allow the user to have a second
>>   layer of protection and ensure that for some memslots, the user
>>   expects never to be able to mmap from the memslot.
>>
>> I agree it will be useful to allow both guest_memfd memslots that
>> support and do not support mmap in a single VM.
>>
>> I think I found an issue with flags, which is that GUEST_MEMFD_FLAG_MMAP
>> should not imply that the guest_memfd will provide memory for all guest
>> faults within the memslot's gfn range (KVM_MEMSLOT_GMEM_ONLY).
>>
>> For the use case Shivank raised, if the user wants a guest_memfd memslot
>> that supports mmap just so userspace addresses can be used as references
>> for specifying memory policy for legacy Coco VMs where shared memory
>> should still come from other sources, GUEST_MEMFD_FLAG_MMAP will be set,
>> but KVM can't fault shared memory from guest_memfd. Hence,
>> GUEST_MEMFD_FLAG_MMAP should not imply KVM_MEMSLOT_GMEM_ONLY.
>>
>> Thinking forward, if we want guest_memfd to provide (no-mmap) protection
>> even for non-CoCo VMs (such that perhaps initial VM image is populated
>> and then VM memory should never be mmap-ed at all), we will want
>> guest_memfd to be the source of memory even if GUEST_MEMFD_FLAG_MMAP is
>> not set.
>>
>> I propose that we should have a single VM-level flag to solve this (in
>> line with Sean's guideline that we should just move towards what we want
>> and not support non-existent use cases): something like
>> KVM_CAP_PREFER_GMEM.
>>
>> If KVM_CAP_PREFER_GMEM_MEMORY is set,
>>
>> * memory for any gfn range in a guest_memfd memslot will be requested
>>   from guest_memfd
>> * any privacy status queries will also be directed to guest_memfd
>> * KVM_MEMORY_ATTRIBUTE_PRIVATE will not be a valid attribute
>>
>> KVM_CAP_PREFER_GMEM_MEMORY will be orthogonal with no validation on
>> GUEST_MEMFD_FLAG_MMAP, which should just purely guard mmap support in
>> guest_memfd.
>>
>> Here's a table that I set up [1]. I believe the proposed
>> KVM_CAP_PREFER_GMEM_MEMORY (column 7) lines up with requirements
>> (columns 1 to 4) correctly.
>>
>> [1] https://lpc.events/event/18/contributions/1764/attachments/1409/3710=
/guest_memfd%20use%20cases%20vs%20guest_memfd%20flags%20and%20privacy%20tra=
cking.pdf
>
> I'm not sure this naming helps. What does "prefer" imply here? If the
> caller from user space does not prefer, does it mean that they
> mind/oppose?
>

Sorry, bad naming.

I used "prefer" because some memslots may not have guest_memfd at
all. To clarify, a "guest_memfd memslot" is a memslot that has some
valid guest_memfd fd and offset. The memslot may also have a valid
userspace_addr configured, either mmap-ed from the same guest_memfd fd
or from some other backing memory (for legacy CoCo VMs), or NULL for
userspace_addr.

I meant to have the CAP enable KVM_MEMSLOT_GMEM_ONLY of this patch
series for all memslots that have some valid guest_memfd fd and offset,
except if we have a VM-level CAP, KVM_MEMSLOT_GMEM_ONLY should be moved
to the VM level.

> Regarding the use case Shivank mentioned, mmaping for policy, while
> the use case is a valid one, the raison d'=C3=AAtre of mmap is to map int=
o
> user space (i.e., fault it in). I would argue that if you opt into
> mmap, you are doing it to be able to access it.

The above is in conflict with what was discussed on 2025-06-26 IIUC.

Shivank brought up the case of enabling mmap *only* to be able to set
mempolicy using the VMAs, and Sean (IIUC) later agreed we should allow
userspace to only enable mmap but still disable faults, so that userspace
is given additional protection, such that even if a (compromised)
userspace does a private-to-shared conversion, userspace is still not
allowed to fault in the page.

Hence, if we want to support mmaping just for policy and continue to
restrict faulting, then GUEST_MEMFD_FLAG_MMAP should not imply
KVM_MEMSLOT_GMEM_ONLY.

> To me, that seems like
> something that merits its own flag, rather than mmap. Also, I recall
> that we said that later on, with inplace conversion, that won't be
> even necessary.

On x86, as of now I believe we're going with an ioctl that does *not*
check what the guest prefers and will go ahead to perform the
private-to-shared conversion, which will go ahead to update
shareability.

> In other words, this would also be trying to solve a
> problem that we haven't yet encountered and that we have a solution
> for anyway.
>

So we don't have a solution for the use case where userspace wants to
mmap but never fault for userspace's protection from stray
private-to-shared conversions, unless we decouple GUEST_MEMFD_FLAG_MMAP
and KVM_MEMSLOT_GMEM_ONLY.

> I think that, unless anyone disagrees, is to go ahead with the names
> we discussed in the last meeting. They seem to be the ones that make
> the most sense for the upcoming use cases.
>

We could also discuss if we really want to support the use case where
userspace wants to mmap but never fault for userspace's protection from
stray private-to-shared conversions.

> Cheers,
> /fuad
>
>
>
>> > [...]
>>

