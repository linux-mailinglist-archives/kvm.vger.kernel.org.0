Return-Path: <kvm+bounces-51078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 09466AED6B1
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 10:08:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F503166A0B
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 08:08:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFD55238D49;
	Mon, 30 Jun 2025 08:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CrFo9yIV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404451F237A
	for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 08:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751270883; cv=none; b=hm5nnSjNdRRN9ytIJBaeCP+aWdaIuAzdCiQ1xLmsJgzpg5iWqVDFWpDfuyf8fQoT/u9j7381uMCO3z1iPZFj11XQ92B+S+SZmpwog8aUaX/C4LMOw3Eo3yB3b2OJS5WKCWiIf9ueyzD8iSdfz875EjWLb8w0FajGqxtF4IPzSb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751270883; c=relaxed/simple;
	bh=0PgIaOQG6u3KOrgNFaZXzQa3bUV78WX2rDWBVVuBqLo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YVctAiNV4s5IyGRWtq+CZ+LtNH2C/cT0TxAm0WEAe1mEr3uTeoywL1RbMKrTvwC9Vl53DYfj7zQLKaMt6s4s+QW/U0pCt2mfl3VQqSLwXKxeA8e7QFGWNAUsv4v0ofTtseNyG6ehcqEdGpRPLMLtSRGRt0p9oymfd1HYgyEcCg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CrFo9yIV; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4a58197794eso358531cf.1
        for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 01:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751270881; x=1751875681; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mi/OKB+QroqPI8Z8OCA75lN3eu0FgzMHtdVq7qnuW3M=;
        b=CrFo9yIVRG3y8Q+LuLhE8amv9GDpEqCgVej9Bs0YBjw1yXXChrTamX87gFEqoIUk9f
         or7iOwaElVhnd/sgdG176Dkk0QSP0wLHqAfXel+NdJO6Z7T+VdfK1z9NGsG1pOdskicB
         fve402r/6z2ElsBGkbeqsWcaKadrmggBaVt++Rq1aS0z74j85HR2S4fpvJ8KO4Y9OTtM
         aYCm08UH6RfL8qqFVZhqI0wFTIZZLQ9vTyM5EKu2zEdL6pjI9prhbKogDYuCdCyEoCem
         wJ0OOlbw4FyIuIl32+WfvwXzNaDfPiVJgCiiB/314UkiWUBIezB3k/cyHjZ2YbbYsobw
         FOyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751270881; x=1751875681;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mi/OKB+QroqPI8Z8OCA75lN3eu0FgzMHtdVq7qnuW3M=;
        b=jmxAntwlYF7FbrItMyMUgoqugWjY+7Ds2rzrd251VjTABddXaxwbqcUDA9Duf9LRG0
         RSvxxMJxKWIu5iWOWdYAmk9qZsUu4boLpu7H0PFYqijkX8clnR1tNn8Jl27vDfivDfyI
         vXtHDrt8yGplD0FnHjXzgIs+OodXLajKoojHYqlWL/wSWOXF0/KySzH5epmBEm+PRQ5T
         Ae4WyKt+EauDebmaEC6oKPKRg0za7qGJfD4SE7p6mALPufrj6IwqgJYQaq///2gjQrtm
         r2ZFotOv41ESfCuvZLlJTjKxIQLnfxR+6zpUp/EQdnGYHd15FzuRfKdB2IKOZbKbH+gj
         FCVg==
X-Forwarded-Encrypted: i=1; AJvYcCX33+D0rxPL5rNJciKHMdl3WrW4/llVhg2KjOFLFKfbeOYZ1kFPd4HtulK2azLAWZy5MRk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyq2UsWo+DHzSMc8tJYBqEZvD6QdflxtDuvx3XgnksgHBCz5MCC
	71A22n/mSUEN1ST3xVn+s1essrVxXVGmEz1DeD5In8H2+RtvsBRuEewK8DvrQfHpQqWbumrjg+1
	njMt0EHYqUG4r9XcdeTOJ2V/FsCxOd/bgBpdwhP+r
X-Gm-Gg: ASbGncu3weSyIFg+dP82esHJ1G2CtlcZa33Jw3a1dTtzmxOXGumfLT4so6BIQHVbzRe
	gf23CjA3WW96B1fassxzFmLKtt3eHCWw86nx+/aiB7qYH7zMzX5FV/E7F8SjNqRumNVGZLR6Adv
	thpEEiUZ00kTTx6Rxyr2CABH75NbBH5RMLjX5fXzAMA5rCWyKZidRhYHC0rcSMM4jAS7TpI1ct
X-Google-Smtp-Source: AGHT+IFQ+H4ctfiCA8/zL6DD6zbPcIGQ0L/p+jZyxVns9qRr/+12U+JsgC2TXDqtvwf6SRug7NRYv389tASYM/vG9wA=
X-Received: by 2002:ac8:5e08:0:b0:4a7:6ad9:39b4 with SMTP id
 d75a77b69052e-4a808ffbdf0mr5418201cf.25.1751270880560; Mon, 30 Jun 2025
 01:08:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com> <20250611133330.1514028-11-tabba@google.com>
 <aEyhHgwQXW4zbx-k@google.com> <diqz1pr8lndp.fsf@ackerleytng-ctop.c.googlers.com>
 <diqza55tjkk1.fsf@ackerleytng-ctop.c.googlers.com>
In-Reply-To: <diqza55tjkk1.fsf@ackerleytng-ctop.c.googlers.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 30 Jun 2025 09:07:23 +0100
X-Gm-Features: Ac12FXx4RLRI7Sn1sliQ6WnveLDaQPnxVwQ-ObC_x8hHp0fzJtRLgEA_BEf2o30
Message-ID: <CA+EHjTxECJ3=ywbAPvpdA1-pm=stXWqU75mgG1epWaXiUr0raw@mail.gmail.com>
Subject: Re: [PATCH v12 10/18] KVM: x86/mmu: Handle guest page faults for
 guest_memfd with shared memory
To: Ackerley Tng <ackerleytng@google.com>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ackerley,

On Fri, 27 Jun 2025 at 16:01, Ackerley Tng <ackerleytng@google.com> wrote:
>
> Ackerley Tng <ackerleytng@google.com> writes:
>
> > [...]
>
> >>> +/*
> >>> + * Returns true if the given gfn's private/shared status (in the CoC=
o sense) is
> >>> + * private.
> >>> + *
> >>> + * A return value of false indicates that the gfn is explicitly or i=
mplicitly
> >>> + * shared (i.e., non-CoCo VMs).
> >>> + */
> >>>  static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
> >>>  {
> >>> -   return IS_ENABLED(CONFIG_KVM_GMEM) &&
> >>> -          kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE=
_PRIVATE;
> >>> +   struct kvm_memory_slot *slot;
> >>> +
> >>> +   if (!IS_ENABLED(CONFIG_KVM_GMEM))
> >>> +           return false;
> >>> +
> >>> +   slot =3D gfn_to_memslot(kvm, gfn);
> >>> +   if (kvm_slot_has_gmem(slot) && kvm_gmem_memslot_supports_shared(s=
lot)) {
> >>> +           /*
> >>> +            * Without in-place conversion support, if a guest_memfd =
memslot
> >>> +            * supports shared memory, then all the slot's memory is
> >>> +            * considered not private, i.e., implicitly shared.
> >>> +            */
> >>> +           return false;
> >>
> >> Why!?!?  Just make sure KVM_MEMORY_ATTRIBUTE_PRIVATE is mutually exclu=
sive with
> >> mappable guest_memfd.  You need to do that no matter what.
> >
> > Thanks, I agree that setting KVM_MEMORY_ATTRIBUTE_PRIVATE should be
> > disallowed for gfn ranges whose slot is guest_memfd-only. Missed that
> > out. Where do people think we should check the mutual exclusivity?
> >
> > In kvm_supported_mem_attributes() I'm thiking that we should still allo=
w
> > the use of KVM_MEMORY_ATTRIBUTE_PRIVATE for other non-guest_memfd-only
> > gfn ranges. Or do people think we should just disallow
> > KVM_MEMORY_ATTRIBUTE_PRIVATE for the entire VM as long as one memslot i=
s
> > a guest_memfd-only memslot?
> >
> > If we check mutually exclusivity when handling
> > kvm_vm_set_memory_attributes(), as long as part of the range where
> > KVM_MEMORY_ATTRIBUTE_PRIVATE is requested to be set intersects a range
> > whose slot is guest_memfd-only, the ioctl will return EINVAL.
> >
>
> At yesterday's (2025-06-26) guest_memfd upstream call discussion,
>
> * Fuad brought up a possible use case where within the *same* VM, we
>   want to allow both memslots that supports and does not support mmap in
>   guest_memfd.
> * Shivank suggested a concrete use case for this: the user wants a
>   guest_memfd memslot that supports mmap just so userspace addresses can
>   be used as references for specifying memory policy.
> * Sean then added on that allowing both types of guest_memfd memslots
>   (support and not supporting mmap) will allow the user to have a second
>   layer of protection and ensure that for some memslots, the user
>   expects never to be able to mmap from the memslot.
>
> I agree it will be useful to allow both guest_memfd memslots that
> support and do not support mmap in a single VM.
>
> I think I found an issue with flags, which is that GUEST_MEMFD_FLAG_MMAP
> should not imply that the guest_memfd will provide memory for all guest
> faults within the memslot's gfn range (KVM_MEMSLOT_GMEM_ONLY).
>
> For the use case Shivank raised, if the user wants a guest_memfd memslot
> that supports mmap just so userspace addresses can be used as references
> for specifying memory policy for legacy Coco VMs where shared memory
> should still come from other sources, GUEST_MEMFD_FLAG_MMAP will be set,
> but KVM can't fault shared memory from guest_memfd. Hence,
> GUEST_MEMFD_FLAG_MMAP should not imply KVM_MEMSLOT_GMEM_ONLY.
>
> Thinking forward, if we want guest_memfd to provide (no-mmap) protection
> even for non-CoCo VMs (such that perhaps initial VM image is populated
> and then VM memory should never be mmap-ed at all), we will want
> guest_memfd to be the source of memory even if GUEST_MEMFD_FLAG_MMAP is
> not set.
>
> I propose that we should have a single VM-level flag to solve this (in
> line with Sean's guideline that we should just move towards what we want
> and not support non-existent use cases): something like
> KVM_CAP_PREFER_GMEM.
>
> If KVM_CAP_PREFER_GMEM_MEMORY is set,
>
> * memory for any gfn range in a guest_memfd memslot will be requested
>   from guest_memfd
> * any privacy status queries will also be directed to guest_memfd
> * KVM_MEMORY_ATTRIBUTE_PRIVATE will not be a valid attribute
>
> KVM_CAP_PREFER_GMEM_MEMORY will be orthogonal with no validation on
> GUEST_MEMFD_FLAG_MMAP, which should just purely guard mmap support in
> guest_memfd.
>
> Here's a table that I set up [1]. I believe the proposed
> KVM_CAP_PREFER_GMEM_MEMORY (column 7) lines up with requirements
> (columns 1 to 4) correctly.
>
> [1] https://lpc.events/event/18/contributions/1764/attachments/1409/3710/=
guest_memfd%20use%20cases%20vs%20guest_memfd%20flags%20and%20privacy%20trac=
king.pdf

I'm not sure this naming helps. What does "prefer" imply here? If the
caller from user space does not prefer, does it mean that they
mind/oppose?

Regarding the use case Shivank mentioned, mmaping for policy, while
the use case is a valid one, the raison d'=C3=AAtre of mmap is to map into
user space (i.e., fault it in). I would argue that if you opt into
mmap, you are doing it to be able to access it. To me, that seems like
something that merits its own flag, rather than mmap. Also, I recall
that we said that later on, with inplace conversion, that won't be
even necessary. In other words, this would also be trying to solve a
problem that we haven't yet encountered and that we have a solution
for anyway.

I think that, unless anyone disagrees, is to go ahead with the names
we discussed in the last meeting. They seem to be the ones that make
the most sense for the upcoming use cases.

Cheers,
/fuad



> > [...]
>

