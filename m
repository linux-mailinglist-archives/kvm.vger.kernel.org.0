Return-Path: <kvm+bounces-22334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6F8493D7E8
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 20:01:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 499F6284014
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 18:01:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B89E617C7CD;
	Fri, 26 Jul 2024 18:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aNo5DesT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5032D315BA
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 18:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722016879; cv=none; b=o0gKhoQOuaghjyilB5Ya0CGL03aaaZcOHNl/KeeKzcJzbeayNOt7VvRCjocsh1voSaldSia22vKLsUPDNOfNaZgCnNY1psK6sX6KOYEb+J/1QyKWKFpzYoD0wPqz4eJJC3rSfYxKyGyhCUuffWqvkonnKjFLQ6tU7F3pabKZ4Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722016879; c=relaxed/simple;
	bh=++DxW5Wfy4Au2YwoonxUGa/QZStbNf04powXqCjkLB4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n794p3Nx0kPXACwGd0V3CjAc5Bq8Y/1QZFVXfZ/OdVgYGTTbnpul/gCFF8vR0M9vNIZHGD4VdfD5RyNhvm4MzP9DVI631IdgNTrM+99pjoFeav6AvzGzHmHBegOHi5R5VQSerSQxL88BvBDDHtSelIi6esfJWG221mEKAEtniwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aNo5DesT; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-44fe76fa0b8so30161cf.0
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 11:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722016877; x=1722621677; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ak1Eq7jso4JmTyHIqI1fIZotXdd9vAxGDBL2VPHZ8pA=;
        b=aNo5DesTtraCdB6mCP+Y8T73nI/pC9KEJrKUdVyrY4nxsoZnR8iQOhdxswVXQ87bnB
         916/UlhRYLQBZPz6XuoG0GBrldNeSIwa5IJ4CyCzfzOtvXk+/QsXH/PVocFpYk9EBiO2
         wUTCzCzUrvIxjcwEMQNWZA8sOE6dzkx+MVHq31YxkWHDFzioHozHF6D1PhZsjMWxGxB8
         Dt7lSt1GEHnwZ7DRUTsK8KvnW15PdN6WKc6ZLp9AoHtLOuz6tA3FwQd+Li1V69FjHwYM
         vs9KBrqXI470zHGpDbv0fB3JkOjbilXlrI9cFy7dSSqDVG5Q+pcL4WkLtdSH/t3OIsQ4
         BIsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722016877; x=1722621677;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ak1Eq7jso4JmTyHIqI1fIZotXdd9vAxGDBL2VPHZ8pA=;
        b=C0LRdZVLuBMlGw/hqTG2BCAnl3GQEefVZawcYVftVb2hxZiWAUht68hSsTUEiEikW2
         CHU0BOAkuEwcjVd39JMsQFThggjub3EclY35kXp91y+zOSBUmMpeWZaI6Nvh7i1DMjC/
         H6dPaauipO5PSV003sB+4v6/Wr8AVpVvBs+DdwuxlYNalHMF8REEdR3TZHnuD7Biq6h5
         J65OUkSyEQ8EtuUtXVFpE4cxjN3Y0p3xKyyfPaJJIvhDIA/4GlJgtXFlVn/t/Z9sjNPf
         15FPTls6AR1JBJeQTXjhLJl0CGo0+Ln22lexJp2mglae4VfniX7LD1LMOw1rLAnWlMOR
         LJ7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWwvBGDYt/xEawY7NinlLLV3ZbpWrKNGE54BxRyE9+KVtdAh8NTAFytAuUemDu0yhzojf5CODpW9wkHfXTYbmaS5kuU
X-Gm-Message-State: AOJu0YxrYN7A3qsFnonzz+t4WZQC+1vF+5ha+YsmBbXBv95vtcfpofe+
	hswWs0ppc78xwP4dAY+CzI/5SWdNthZumzeXBvsMbhAsb9XnKM9R32BZmFDpGyKsOpEtvpvoTFM
	t/pku1RlDtgEVhAKsdXEhaGEcnUDUtjoSERdO
X-Google-Smtp-Source: AGHT+IFoF6m2085HiMb1LFmRXf1gcgoAKZulVWf1wtb1p+oifUVM7pdIPy5Ujlb1n6sjQ/UwCgADvSFgnKg+ILC9gFY=
X-Received: by 2002:a05:622a:42:b0:447:e3e3:77c1 with SMTP id
 d75a77b69052e-44ff3e151f5mr4242721cf.29.1722016877026; Fri, 26 Jul 2024
 11:01:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com>
 <20240710234222.2333120-15-jthoughton@google.com> <4e5c2904-f628-4391-853e-37b7f0e132e8@amazon.com>
In-Reply-To: <4e5c2904-f628-4391-853e-37b7f0e132e8@amazon.com>
From: James Houghton <jthoughton@google.com>
Date: Fri, 26 Jul 2024 11:00:40 -0700
Message-ID: <CADrL8HUn-A+k-+A8WvreKtvxW-b9zZvgAGMkkaR7gCLsPr3XPg@mail.gmail.com>
Subject: Re: [RFC PATCH 14/18] KVM: Add asynchronous userfaults, KVM_READ_USERFAULT
To: kalyazin@amazon.com
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Peter Xu <peterx@redhat.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	David Matlack <dmatlack@google.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, roypat@amazon.co.uk, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 26, 2024 at 9:50=E2=80=AFAM Nikita Kalyazin <kalyazin@amazon.co=
m> wrote:
>
> Hi James,
>
> On 11/07/2024 00:42, James Houghton wrote:
> > It is possible that KVM wants to access a userfault-enabled GFN in a
> > path where it is difficult to return out to userspace with the fault
> > information. For these cases, add a mechanism for KVM to wait for a GFN
> > to not be userfault-enabled.
> In this patch series, an asynchronous notification mechanism is used
> only in cases "where it is difficult to return out to userspace with the
> fault information". However, we (AWS) have a use case where we would
> like to be notified asynchronously about _all_ faults. Firecracker can
> restore a VM from a memory snapshot where the guest memory is supplied
> via a Userfaultfd by a process separate from the VMM itself [1]. While
> it looks technically possible for the VMM process to handle exits via
> forwarding the faults to the other process, that would require building
> a complex userspace protocol on top and likely introduce extra latency
> on the critical path.
> This also implies that a KVM API
> (KVM_READ_USERFAULT) is not suitable, because KVM checks that the ioctls
> are performed specifically by the VMM process [2]:
>         if (kvm->mm !=3D current->mm || kvm->vm_dead)
>                 return -EIO;

If it would be useful, we could absolutely have a flag to have all
faults go through the asynchronous mechanism. :) It's meant to just be
an optimization. For me, it is a necessary optimization.

Userfaultfd doesn't scale particularly well: we have to grab two locks
to work with the wait_queues. You could create several userfaultfds,
but the underlying issue is still there. KVM Userfault, if it uses a
wait_queue for the async fault mechanism, will have the same
bottleneck. Anish and I worked on making userfaults more scalable for
KVM[1], and we ended up with a scheme very similar to what we have in
this KVM Userfault series.

My use case already requires using a reasonably complex API for
interacting with a separate userland process for fetching memory, and
it's really fast. I've never tried to hook userfaultfd into this other
process, but I'm quite certain that [1] + this process's interface
scale better than userfaultfd does. Perhaps userfaultfd, for
not-so-scaled-up cases, could be *slightly* faster, but I mostly care
about what happens when we scale to hundreds of vCPUs.

[1]: https://lore.kernel.org/kvm/20240215235405.368539-1-amoorthy@google.co=
m/

>
>  > The implementation of this mechanism is certain to change before KVM
>  > Userfault could possibly be merged.
> How do you envision resolving faults in userspace? Copying the page in
> (provided that userspace mapping of guest_memfd is supported [3]) and
> clearing the KVM_MEMORY_ATTRIBUTE_USERFAULT alone do not look
> sufficient to resolve the fault because an attempt to copy the page
> directly in userspace will trigger a fault on its own

This is not true for KVM Userfault, at least for right now. Userspace
accesses to guest memory will not trigger KVM Userfaults. (I know this
name is terrible -- regular old userfaultfd() userfaults will indeed
get triggered, provided you've set things up properly.)

KVM Userfault is merely meant to catch KVM's own accesses to guest
memory (including vCPU accesses). For non-guest_memfd memslots,
userspace can totally just write through the VMA it has made (KVM
Userfault *cannot*, by virtue of being completely divorced from mm,
intercept this access). For guest_memfd, userspace could write to
guest memory through a VMA if that's where guest_memfd is headed, but
perhaps it will rely on exact details of how userspace is meant to
populate guest_memfd memory.

You're totally right that, in essence, we will need some kind of
non-faulting way to interact with guest memory. With traditional
memslots and VMAs, we have that already; guest_memfd memslots and
VMAs, I think we will have that eventually.

> and may lead to a
> deadlock in the case where the original fault was caused by the VMM. An
> interface similar to UFFDIO_COPY is needed that would allocate a page,
> copy the content in and update page tables.

In case it's interesting or useful at all, we actually use
UFFDIO_CONTINUE for our live migration use case. We mmap() memory
twice -- one of them we register with userfaultfd and also give to
KVM. The other one we use to install memory -- our non-faulting view
of guest memory!

>
> [1] Firecracker snapshot restore via UserfaultFD:
> https://github.com/firecracker-microvm/firecracker/blob/main/docs/snapsho=
tting/handling-page-faults-on-snapshot-resume.md
> [2] KVM ioctl check for the address space:
> https://elixir.bootlin.com/linux/v6.10.1/source/virt/kvm/kvm_main.c#L5083
> [3] mmap() of guest_memfd:
> https://lore.kernel.org/kvm/489d1494-626c-40d9-89ec-4afc4cd0624b@redhat.c=
om/T/#mc944a6fdcd20a35f654c2be99f9c91a117c1bed4
>
> Thanks,
> Nikita

Thanks for the feedback!

