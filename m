Return-Path: <kvm+bounces-51002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E276AEBAE5
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 17:01:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 249003BEAF3
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 15:00:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87EEA2E88A2;
	Fri, 27 Jun 2025 15:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aP75DBx6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14EDA1C6FE8
	for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 15:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751036466; cv=none; b=RzmgZJZModsrNhqOr9eEXvis4p6+/PSojA+yT0e3RSNmtwzWPdcnqckT2+L1bLvcMt5+uHGYhwCzyP2+bXzr6HkD2DpJPr60E1hvqpCbFElmjJZmrDY93KMzTUW9uGyHSAxy0dC2mqTksgZMQoQhyQL8ME1hL4/95a0BncVjZGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751036466; c=relaxed/simple;
	bh=6ujoqmRO5RyKRytqvKPKVslFAEvxQPuN+1xFG8o9Fcg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k6whmkcO8t1JmIp/5xI8wuOhR+VRSuKXau0bPc0gx+JQQ9l1LyWCvqVKpWA9ZkPzWXLxQaaYMCunoV5ZYCXRmQgp4Hde2fRAj/3EHOZIZgTZYTR8QPFj0lfy/oTNybSaTDW/JLTIvQY1qTPni0tKjxwIfTSrp4m0JKIsCC756Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aP75DBx6; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b2c37558eccso1771754a12.1
        for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 08:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751036464; x=1751641264; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aRAl9wI634BPGjcu8H/zKu0rYl19B+V87gNfnSSPISY=;
        b=aP75DBx6uydP/g5OUyDAxiuKR5CZq8yJkqF3MlqZQOWuYN1E4ijuZEsZj4FW5f0fsq
         zqod/u/9O98wwwPPA21zmSyHB1MCJ93yBwxIw6pRGMjp7R/5APnw/XSI44j0ENR8Y+aK
         mumYmIfIYXkBxh8LAIVm8q+GkU11ocMd9YExCH3uF6ru7Zlz70TybPmamWZFPn+wQCSB
         xDhFdfbbIwdD6Ues9ir82Mnbl3ZcD8twNiD+D0PM7q7UdvX3HS4AM1fBYsLNpJLeXXuF
         VyjscDKcA8HQE4/AmggITnK/NA7+ZUAI/gwauApjymi6+G73Dto3IMSde79RqwXmyRbT
         YEDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751036464; x=1751641264;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aRAl9wI634BPGjcu8H/zKu0rYl19B+V87gNfnSSPISY=;
        b=uzdo6h2j6igh2UEtEsX/FyDCkb1ar3mVYtKI0mAYdLNngTt5l/vqmEQXjGodNOtfOf
         4pgV2iRnL61GapsNJ9mT/123SGf2GUguKqxet+HoqJgBb4t1oIxzHjrDOxeAc5CxYfQz
         0q66JSrO9Nte44VQqNWWQCsUkd/LIaDzL/YkFMCT3Cnf3iZCtfpLUCeXHfbvRIXqpQCz
         JU2xsyIA4jT0NdVd//6Y+ub/cv/LoRxiqAECdT0NFrQ3mYyOQflwrdYKvg7EFKKw3svA
         u8ymdmD9gLYNfPBFvYvQkhkO39M7Zumtm3PPINPU6QKv9JlSIZv+UPh47kdKixYEqz0/
         K/mw==
X-Gm-Message-State: AOJu0YzFh5gWR0ul9vn4I0ZWYEC5DO0mOwvRF/1pfTata0YpKX7v/9eV
	5n3mXSw4Gxgv14xENRK7d7M0XKNuco/mGeJuD65Wf9o0qhqGkAiveqqWp1+Vopw8w29MwJZxJsi
	Rn2Kb5DbzC4tNCK6jM6pRpVlHyg==
X-Google-Smtp-Source: AGHT+IGurS1FeZxjPsUkkgX6nLcb9gWPD1RB81LRFHPYYM11l8SKTEFiNYBAYv1ewEvWIoDgL2ZOZLZLlNTHAJWkEw==
X-Received: from pjbnb6.prod.google.com ([2002:a17:90b:35c6:b0:311:8076:14f1])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2c90:b0:312:ec3b:82c0 with SMTP id 98e67ed59e1d1-318c9314d79mr4816447a91.29.1751036464315;
 Fri, 27 Jun 2025 08:01:04 -0700 (PDT)
Date: Fri, 27 Jun 2025 08:01:02 -0700
In-Reply-To: <diqz1pr8lndp.fsf@ackerleytng-ctop.c.googlers.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com> <20250611133330.1514028-11-tabba@google.com>
 <aEyhHgwQXW4zbx-k@google.com> <diqz1pr8lndp.fsf@ackerleytng-ctop.c.googlers.com>
Message-ID: <diqza55tjkk1.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v12 10/18] KVM: x86/mmu: Handle guest page faults for
 guest_memfd with shared memory
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
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
Content-Type: text/plain; charset="UTF-8"

Ackerley Tng <ackerleytng@google.com> writes:

> [...]

>>> +/*
>>> + * Returns true if the given gfn's private/shared status (in the CoCo sense) is
>>> + * private.
>>> + *
>>> + * A return value of false indicates that the gfn is explicitly or implicitly
>>> + * shared (i.e., non-CoCo VMs).
>>> + */
>>>  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
>>>  {
>>> -	return IS_ENABLED(CONFIG_KVM_GMEM) &&
>>> -	       kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
>>> +	struct kvm_memory_slot *slot;
>>> +
>>> +	if (!IS_ENABLED(CONFIG_KVM_GMEM))
>>> +		return false;
>>> +
>>> +	slot = gfn_to_memslot(kvm, gfn);
>>> +	if (kvm_slot_has_gmem(slot) && kvm_gmem_memslot_supports_shared(slot)) {
>>> +		/*
>>> +		 * Without in-place conversion support, if a guest_memfd memslot
>>> +		 * supports shared memory, then all the slot's memory is
>>> +		 * considered not private, i.e., implicitly shared.
>>> +		 */
>>> +		return false;
>>
>> Why!?!?  Just make sure KVM_MEMORY_ATTRIBUTE_PRIVATE is mutually exclusive with
>> mappable guest_memfd.  You need to do that no matter what. 
>
> Thanks, I agree that setting KVM_MEMORY_ATTRIBUTE_PRIVATE should be
> disallowed for gfn ranges whose slot is guest_memfd-only. Missed that
> out. Where do people think we should check the mutual exclusivity?
>
> In kvm_supported_mem_attributes() I'm thiking that we should still allow
> the use of KVM_MEMORY_ATTRIBUTE_PRIVATE for other non-guest_memfd-only
> gfn ranges. Or do people think we should just disallow
> KVM_MEMORY_ATTRIBUTE_PRIVATE for the entire VM as long as one memslot is
> a guest_memfd-only memslot?
>
> If we check mutually exclusivity when handling
> kvm_vm_set_memory_attributes(), as long as part of the range where
> KVM_MEMORY_ATTRIBUTE_PRIVATE is requested to be set intersects a range
> whose slot is guest_memfd-only, the ioctl will return EINVAL.
>

At yesterday's (2025-06-26) guest_memfd upstream call discussion,

* Fuad brought up a possible use case where within the *same* VM, we
  want to allow both memslots that supports and does not support mmap in
  guest_memfd.
* Shivank suggested a concrete use case for this: the user wants a
  guest_memfd memslot that supports mmap just so userspace addresses can
  be used as references for specifying memory policy.
* Sean then added on that allowing both types of guest_memfd memslots
  (support and not supporting mmap) will allow the user to have a second
  layer of protection and ensure that for some memslots, the user
  expects never to be able to mmap from the memslot.

I agree it will be useful to allow both guest_memfd memslots that
support and do not support mmap in a single VM.

I think I found an issue with flags, which is that GUEST_MEMFD_FLAG_MMAP
should not imply that the guest_memfd will provide memory for all guest
faults within the memslot's gfn range (KVM_MEMSLOT_GMEM_ONLY).

For the use case Shivank raised, if the user wants a guest_memfd memslot
that supports mmap just so userspace addresses can be used as references
for specifying memory policy for legacy Coco VMs where shared memory
should still come from other sources, GUEST_MEMFD_FLAG_MMAP will be set,
but KVM can't fault shared memory from guest_memfd. Hence,
GUEST_MEMFD_FLAG_MMAP should not imply KVM_MEMSLOT_GMEM_ONLY.

Thinking forward, if we want guest_memfd to provide (no-mmap) protection
even for non-CoCo VMs (such that perhaps initial VM image is populated
and then VM memory should never be mmap-ed at all), we will want
guest_memfd to be the source of memory even if GUEST_MEMFD_FLAG_MMAP is
not set.

I propose that we should have a single VM-level flag to solve this (in
line with Sean's guideline that we should just move towards what we want
and not support non-existent use cases): something like
KVM_CAP_PREFER_GMEM.

If KVM_CAP_PREFER_GMEM_MEMORY is set,

* memory for any gfn range in a guest_memfd memslot will be requested
  from guest_memfd
* any privacy status queries will also be directed to guest_memfd
* KVM_MEMORY_ATTRIBUTE_PRIVATE will not be a valid attribute

KVM_CAP_PREFER_GMEM_MEMORY will be orthogonal with no validation on
GUEST_MEMFD_FLAG_MMAP, which should just purely guard mmap support in
guest_memfd.

Here's a table that I set up [1]. I believe the proposed
KVM_CAP_PREFER_GMEM_MEMORY (column 7) lines up with requirements
(columns 1 to 4) correctly.

[1] https://lpc.events/event/18/contributions/1764/attachments/1409/3710/guest_memfd%20use%20cases%20vs%20guest_memfd%20flags%20and%20privacy%20tracking.pdf

> [...]


