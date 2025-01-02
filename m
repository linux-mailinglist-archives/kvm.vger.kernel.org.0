Return-Path: <kvm+bounces-34495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 480809FFD2A
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 18:54:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4321E188221B
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 17:54:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16A5A187346;
	Thu,  2 Jan 2025 17:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cVZZ0PVh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38652181334
	for <kvm@vger.kernel.org>; Thu,  2 Jan 2025 17:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735840430; cv=none; b=P1rUOI4ZU117DmihhDQDdPSD7v4AJGdEJJVojDzCuSI4V4FdAhkL6HPJ3/30vnShya2jPgEX35Kd52l9bDB7BWrKW3xSZshbIXSbbKt0iSjOztp4tZoHUI7Z9zGg5vYBIgw0OLuNGkoTa8LX1gYwzwnAH9/t/F4wJwf0/FaVNWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735840430; c=relaxed/simple;
	bh=bSRQ7F+OzBNbwdJoupKAXEUmasyou+jIoSijm1UfY2w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EsR7cMbrq1xm/CHJygJDOS9qm2E2t4qH+PtdVZvTlmOm/MowVE5peHC4hEPdnGFsG+rvUcg0Yuqjj1Cc/R19khF7/nLrQgYtQsvjqBwQLgryo1MZAOXSBxOVGq7KuXfFmjYVW1SfPcsSNXbJ/ROYtlPtWoTt/L4kPsMAwsgBE9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cVZZ0PVh; arc=none smtp.client-ip=209.85.219.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f177.google.com with SMTP id 3f1490d57ef6-e3fd6cd9ef7so15278887276.1
        for <kvm@vger.kernel.org>; Thu, 02 Jan 2025 09:53:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1735840427; x=1736445227; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vr8r//vN2Czec+tejyZLABnIxiih+moPq7M5hQENusQ=;
        b=cVZZ0PVhcS0cH9nnu2/W+4xtUfECOhcdCQ7dzG/O2srLoIyqDwNa53D0tvMF6MENoB
         y8CErPN/zR2aONKSUvAvOnod2hh9QcaVdRez1GA3OLj2EE63hK4DVqFcmLhQYeUfEftL
         KJ7CLGCqD9qR6gwwKuq24ZrjrSfUoE2S8MbJJFVcoSbJviAiu8r3yc+hYHhcGr5Zi9hO
         DyDWWBS3VSZgxuiqChTZ033QoWyyRJG+BiUBRIyPouwQKd98/NeEAtSTdhaYcRp7JIpp
         k1t72Yh5t/WkktFXj01SXpakAqvcLt7THlXfmxlwU0wCH7XvQipeQLvttpiBVAHXv08+
         dtkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735840427; x=1736445227;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vr8r//vN2Czec+tejyZLABnIxiih+moPq7M5hQENusQ=;
        b=PqvQc4NQmfsUq6XEvedXy2pv2z51WrOg17a7XfReENLNUVJsKvpbxIa9EODHWSZsl2
         F96XYqPaxwYAkmtpOX2meAwHn6UncgLfFIUJaf8OtW3M0JZ0IzCWWCqAdhRtO+UK0IJM
         CWjdh48BEqmWiB5rBtIDLslhhvSZQIpyQrPeVTPISFBB4UAcV9t8fiseXMKdTC34XuQN
         2QJfGn783gjtI1p+uPZAn4s/fCuZnPavydHwF88vn88sTsKehrZkKUBPHwJEFQh9zhud
         dFMfWrhOuTpcqbmIB67Taq8TL7lYZxBTXr6PXR95i1Q1jeOxMH3sSXs25zdHh1Of5na2
         OM5Q==
X-Forwarded-Encrypted: i=1; AJvYcCXmV7RKKZYWMOVJX4DZbANR7syGwrrvlPlrEFB66HJo0K8cjg1GeibiyP8O3WvO4NStGcM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMgSaA8Fefm+unWEwuIzljRxfaiEL5i5HblRR4SvmgUpg8wkg5
	z8H0mbD+A0wbpQGAb7Fv54HqhFXCXS66TvIDhAqlxCT6KUkjvqIpqyfAXoi07Ubc3ICt+RM6qwt
	htyYJe7eQyMkpqmEQNWZy/1VSrug0lMuRnzMF
X-Gm-Gg: ASbGncut05wBXwfFf7VhBd+45saWl3rJ59UIEug3pAueD47d+QIKFShZ5Vk9cAumDLo
	4cOLpW5hCEG5dxwqIIYg1+qjHgtH0cthUQ1fgOQ==
X-Google-Smtp-Source: AGHT+IGk7bu0mC922JwLX9wsU00L7s3HiJmMdoo9Mzmq87IWKCchv+EYdPQCyAedtINMva3EGggnhenJUHAMWLgAmoc=
X-Received: by 2002:a05:690c:620c:b0:6ea:88d4:fd4f with SMTP id
 00721157ae682-6f3f7f07081mr293349917b3.18.1735840426897; Thu, 02 Jan 2025
 09:53:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241204191349.1730936-1-jthoughton@google.com> <Z2simHWeYbww90OZ@x1n>
In-Reply-To: <Z2simHWeYbww90OZ@x1n>
From: James Houghton <jthoughton@google.com>
Date: Thu, 2 Jan 2025 12:53:11 -0500
Message-ID: <CADrL8HUkP2ti1yWwp=1LwTX2Koit5Pk6LFcOyTpN2b+B3MfKuw@mail.gmail.com>
Subject: Re: [PATCH v1 00/13] KVM: Introduce KVM Userfault
To: Peter Xu <peterx@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Yan Zhao <yan.y.zhao@intel.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Anish Moorthy <amoorthy@google.com>, Peter Gonda <pgonda@google.com>, 
	David Matlack <dmatlack@google.com>, Wei W <wei.w.wang@intel.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 24, 2024 at 4:07=E2=80=AFPM Peter Xu <peterx@redhat.com> wrote:
>
> James,

Hi Peter!

> On Wed, Dec 04, 2024 at 07:13:35PM +0000, James Houghton wrote:
> > This is a continuation of the original KVM Userfault RFC[1] from July.
> > It contains the simplifications we talked about at LPC[2].
> >
> > Please see the RFC[1] for the problem description. In summary,
> > guest_memfd VMs have no mechanism for doing post-copy live migration.
> > KVM Userfault provides such a mechanism. Today there is no upstream
> > mechanism for installing memory into a guest_memfd, but there will
> > be one soon (e.g. [3]).
> >
> > There is a second problem that KVM Userfault solves: userfaultfd-based
> > post-copy doesn't scale very well. KVM Userfault when used with
> > userfaultfd can scale much better in the common case that most post-cop=
y
> > demand fetches are a result of vCPU access violations. This is a
> > continuation of the solution Anish was working on[4]. This aspect of
> > KVM Userfault is important for userfaultfd-based live migration when
> > scaling up to hundreds of vCPUs with ~30us network latency for a
> > PAGE_SIZE demand-fetch.
>
> I think it would be clearer to nail down the goal of the feature.  If it'=
s
> a perf-oriented feature we don't need to mention gmem, but maybe it's not=
.

In my mind, both the gmem aspect and the performance aspect are
important. I don't think one is more important than the other, though
the performance win aspect of this is more immediately useful.

>
> >
> > The implementation in this series is version than the RFC[1]. It adds..=
.
> >  1. a new memslot flag is added: KVM_MEM_USERFAULT,
> >  2. a new parameter, userfault_bitmap, into struct kvm_memory_slot,
> >  3. a new KVM_RUN exit reason: KVM_MEMORY_EXIT_FLAG_USERFAULT,
> >  4. a new KVM capability KVM_CAP_USERFAULT.
> >
> > KVM Userfault does not attempt to catch KVM's own accesses to guest
> > memory. That is left up to userfaultfd.
>
> I assume it means this is an "perf optimization" feature then?  As it
> doesn't work for remote-fault processes like firecracker, or
> remote-emulated processes like QEMU's vhost-user?

For the !gmem case, yes KVM Userfault is not a replacement for
userfaultfd; for post-copy to function properly, we need to catch all
attempted accesses to guest memory (including from things like
vhost-net and KVM itself). It is indeed a performance optimization on
top of userfaultfd.

For setups where userfaultfd reader threads are running in a separate
process from the vCPU threads, yes KVM Userfault will make it so that
guest-mode vCPU faults will have to be initially handled by the vCPU
threads themselves. The fault information can always be forwarded to a
separate process afterwards, and the communication mechanism is
totally up to userspace (so they can optimize for their exact
use-case).

> Even though it could still 100% cover x86_64's setup if it's not as
> complicated as above?  I mean, I assumed above sentence was for archs lik=
e
> ARM that I remember having no-vcpu-context accesses so things like that i=
s
> not covered too.  Perhaps x86_64 is the goal?  If so, would also be good =
to
> mention some details.

(In the !gmem case) It can't replace userfaultfd for any architecture
as long as there are kernel components that want to read or write to
guest memory.

The only real reason to make KVM Userfault try to completely replace
userfaultfd is to make post-copy with 1G pages work, but that requires
(1) userspace to catch their own accesses and (2) non-KVM components
catch their own accesses.

(1) is a pain (IIUC, infeasible for QEMU) and error-prone even if it
can be done, and (2) can essentially never be done upstream.

So I'm not pushing for KVM Userfault to replace userfaultfd; it's not
worth the extra/duplicated complexity. And at LPC, Paolo and Sean
indicated that this direction was indeed wrong. I have another way to
make this work in mind. :)

For the gmem case, userfaultfd cannot be used, so KVM Userfault isn't
replacing it. And as of right now anyway, KVM Userfault *does* provide
a complete post-copy system for gmem.

When gmem pages can be mapped into userspace, for post-copy to remain
functional, userspace-mapped gmem will need userfaultfd integration.
Keep in mind that even after this integration happens, userfaultfd
alone will *not* be a complete post-copy solution, as vCPU faults
won't be resolved via the userspace page tables.

> >
> > When enabling KVM_MEM_USERFAULT for a memslot, the second-stage mapping=
s
> > are zapped, and new faults will check `userfault_bitmap` to see if the
> > fault should exit to userspace.
> >
> > When KVM_MEM_USERFAULT is enabled, only PAGE_SIZE mappings are
> > permitted.
> >
> > When disabling KVM_MEM_USERFAULT, huge mappings will be reconstructed
> > (either eagerly or on-demand; the architecture can decide).
> >
> > KVM Userfault is not compatible with async page faults. Nikita has
> > proposed a new implementation of async page faults that is more
> > userspace-driven that *is* compatible with KVM Userfault[5].
> >
> > Performance
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > The takeaways I have are:
> >
> > 1. For cases where lock contention is not a concern, there is a
> >    discernable win because KVM Userfault saves the trip through the
> >    userfaultfd poll/read/WAKE cycle.
> >
> > 2. Using a single userfaultfd without KVM Userfault gets very slow as
> >    the number of vCPUs increases, and it gets even slower when you add
> >    more reader threads. This is due to contention on the userfaultfd
> >    wait_queue locks. This is the contention that KVM Userfault avoids.
> >    Compare this to the multiple-userfaultfd runs; they are much faster
> >    because the wait_queue locks are sharded perfectly (1 per vCPU).
> >    Perfect sharding is only possible because the vCPUs are configured t=
o
> >    touch only their own chunk of memory.
>
> I'll try to spend some more time after holidays on this perf issue. But
> will still be after the 1g support on !coco gmem if it would work out. As
> the 1g function is still missing in QEMU, so that one has higher priority
> comparing to either perf or downtime (e.g. I'll also need to measure
> whether QEMU will need minor fault, or stick with missing as of now).
>
> Maybe I'll also start to explore a bit on [g]memfd support on userfault,
> I'm not sure whether anyone started working on some generic solution befo=
re
> for CoCo / gmem postcopy - we need to still have a solution for either
> firecrackers or OVS/vhost-user.  I feel like we need that sooner or later=
,
> one way or another.  I think I'll start without minor faults support unti=
l
> justified, and if I'll ever be able to start it at all in a few months ne=
xt
> year..

Yeah we'll need userfaultfd support for !coco gmem when gmem supports
mapping into userspace to support setups that use OVS/vhost-user.

And feel free to start with MISSING or MINOR, I don't mind. Eventually
I'll probably need MINOR support; I'm happy to work on it when the
time comes (I'm waiting for KVM Userfault to get merged and then for
userspace mapping of gmem to get merged).

FWIW, I think userspace mapping of gmem + userfaultfd support for
userspace-mapped gmem + 1G page support for gmem =3D good 1G post-copy
for QEMU (i.e., use gmem instead of hugetlbfs after gmem supports 1G
pages).

Remember the feedback I got from LSFMM a while ago? "don't use
hugetlbfs." gmem seems like the natural replacement.

> Let me know if there's any comment on above thoughts.
>
> I guess this feauture might be useful to QEMU too, but QEMU always needs
> uffd or something similar, then we need to measure and justify this one
> useful in a real QEMU setup.  For example, need to see how the page
> transfer overhead compares with lock contentions when there're, say, 400
> vcpus.  If some speedup on userfault + the transfer overhead is close to
> what we can get with vcpu exits, then QEMU may still stick with a simple
> model.  But not sure.

It would be nice to integrate this into QEMU and see if there's a
measurable win. I'll try to find some time to look into this.

For GCE's userspace, there is a measurable win. Anish posted some
results a while ago here[1].

[1]: https://lore.kernel.org/kvm/CAF7b7mqrLP1VYtwB4i0x5HC1eYen9iMvZbKerCKWr=
CFv7tDg5Q@mail.gmail.com/

> When integrated with this feature, it also means some other overheads at
> least to QEMU.  E.g., trap / resolve page fault needs two ops now (uffd a=
nd
> the bitmap).

I think about it like this: instead of UFFDIO_CONTINUE + implicit wake
(or even UFFDIO_CONTINUE + UFFDIO_WAKE; this is how my userspace does
it actually), it is UFFDIO_CONTINUE (no wake) + bitmap set. So it's
kind of still two "ops" either way... :) and updating the bitmap is
really cheap compared to a userfaultfd wake-up.

(Having two things that describe something like "we should fault on
this page" is a little bit confusing.)

> Meanwhile even if vcpu can get rid of uffd's one big
> spinlock, it may contend again in userspace, either on page resolution or
> on similar queuing.  I think I mentioned it previously but I guess it's
> nontrivial to justify.  In all cases, I trust that you should have better
> judgement on this.  It's just that QEMU can at least behave differently, =
so
> not sure how it'll go there.

The contention that you may run into after you take away the uffd
spinlock depends on what userspace is doing, yeah. For example in GCE,
before the TDP MMU, we ran into KVM MMU lock contention, and then
later we ran into eventfd issues in our network request
submission/completion queues.

>
> Happy holidays. :)

You too!

Thanks for the feedback, Peter! Let me know if I've misunderstood any
of the points you were making.

> Thanks,
>
> --
> Peter Xu
>

