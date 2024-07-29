Return-Path: <kvm+bounces-22529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D51CC940028
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 23:10:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A876282A70
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 21:10:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF1BC18D4D9;
	Mon, 29 Jul 2024 21:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VEr7NrRs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D651418D4B3
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 21:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722287397; cv=none; b=tZv6P6xelgQT0+RBNpcClWOaBZb2Axp6uVKxJS3b6pKZGfvfzQPZInaC8xFlQEE+mdqBkytag8VRPDuqBxYQAD7uq4/N1AhNpKYHtHZhsjmSJYNxkk/isxJt1leb8xleUUX90O1Vb0fIVW8RTU58Juf8aAk8tUsZPkwHnhjH2zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722287397; c=relaxed/simple;
	bh=l/jmLN9wh7y6hiwhziGF0si+0OQpoR8dOJKGXREieFc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OUeM0Wi/vOH1jCHWLWlntyjebrvCXsUCbm1KjNz0DLp8EFn7gSmHp99GtMZ2buEZEa0AY+dZfSQ4bmWv9lkn8qDKqUQaAs28K06pRWLgROQuNMganYTvFg2rYOM3g66JE0cEA29LrDzQLq72xxlSQuSe9hkeZ9bn7omxnhkwaHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VEr7NrRs; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-44fdc70e695so116651cf.0
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 14:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722287394; x=1722892194; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vd9gll+orW32fugSM5J5pVRsHANIRCA7KL3dKmjyXcw=;
        b=VEr7NrRs2DF7md4or3Y/iBDF8PMC2AIv7epVJTgTyzHadMAl5SgKmiim1VzuBzTTqC
         NeQoTMYFdeHWTLco6KB2JYSHsbQnuCwSyu2tIomWZ/7DmtP0d9IrHeokDhMrNckdJUq+
         FULhnxLyuIo3vRLfH15+v61vP8ClxD3bPKTDeP+kjf6ZMamQx9qoVkOZVI+NZKejIaYk
         QtDkzJSJfQUFjwpzDbFFHHa7BIV/LmQ/dttpk1K7bEo3MAk7GB4NgK0EhAN7Tmzx7omN
         REGIdShTIDHLCCcjUtRPufstfs8LIn6984HpEx7bki8zZLNKAPEQg6LbjIwIZ9pZEkwP
         C1yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722287394; x=1722892194;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vd9gll+orW32fugSM5J5pVRsHANIRCA7KL3dKmjyXcw=;
        b=fW3Fo1//YK8uj0ibRXt2+90n3XQlDjeTbDMzdK3f2afGcM+qMb271hIADuEWUdfqKk
         y7ziE7FoIq8iHOkHa35fgDgvJ9OE+EPI8tRlbaUzRGTPgDvC51SMDjUUveQ6MjHEYxdK
         eW7fFIVX/By74E22SN2fmt1adu9so6yY8jT2B4WoPwQAyf9iizjbbRKKkyDciI7hj5Er
         OmlIazKCBh55Ic9hNYKoZSTMJ04CPjNKdi4y+YSEZzU91g8lYgGqtWvDlUURHCH4eGvN
         13sfXLVQQdjyyPwP2QLktNyHFZtlVNH2RyfLhfxZwfQKYr6G1uB6XK/4iDuTlx9OFdH1
         Dx3Q==
X-Forwarded-Encrypted: i=1; AJvYcCXjdmmHEMV3cszN/lfb9/J0yu/+oJiv4+b7G0YLbYtvGe3VroBo14tCKQEXBXtksf76p9054xHpNs/ao/FBd1H6OOvh
X-Gm-Message-State: AOJu0YyTyMMPR67p2RZk5W3dv9ZOwmEza8SQymrF4ZXlpyfC7DVqcdft
	xdQcQvsjnt7kxojMD6jhk2uLSrTQdX0U355OV7yzXHtsYNGKUPtuHmKeLgdyk8mfGmSA2yWV5nc
	LsjWJRth3LZDhvtwELSXZnWNI77nmlJVE6jbt
X-Google-Smtp-Source: AGHT+IFF0JdMijavAk7YcongAxzNFbvkz57SJw6PrFO3ko+okA4YHp3aWwtWzGsByAqngMvvx6etjqKrffqxlYsSZYE=
X-Received: by 2002:ac8:7f0f:0:b0:447:e8bd:2fbe with SMTP id
 d75a77b69052e-450364d60a1mr22641cf.1.1722287393428; Mon, 29 Jul 2024 14:09:53
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com>
 <20240710234222.2333120-15-jthoughton@google.com> <4e5c2904-f628-4391-853e-37b7f0e132e8@amazon.com>
 <CADrL8HUn-A+k-+A8WvreKtvxW-b9zZvgAGMkkaR7gCLsPr3XPg@mail.gmail.com> <4cd16922-2373-4894-b888-83a6bb3978e7@amazon.com>
In-Reply-To: <4cd16922-2373-4894-b888-83a6bb3978e7@amazon.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 29 Jul 2024 14:09:16 -0700
Message-ID: <CADrL8HVuvBAMcuoifhjuSBpVOA3Av+_k4e=waD81ajKX4gXPHw@mail.gmail.com>
Subject: Re: [RFC PATCH 14/18] KVM: Add asynchronous userfaults, KVM_READ_USERFAULT
To: kalyazin@amazon.com
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, David Matlack <dmatlack@google.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	roypat@amazon.co.uk, Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 29, 2024 at 10:17=E2=80=AFAM Nikita Kalyazin <kalyazin@amazon.c=
om> wrote:
>
> On 26/07/2024 19:00, James Houghton wrote:
> > If it would be useful, we could absolutely have a flag to have all
> > faults go through the asynchronous mechanism. :) It's meant to just be
> > an optimization. For me, it is a necessary optimization.
> >
> > Userfaultfd doesn't scale particularly well: we have to grab two locks
> > to work with the wait_queues. You could create several userfaultfds,
> > but the underlying issue is still there. KVM Userfault, if it uses a
> > wait_queue for the async fault mechanism, will have the same
> > bottleneck. Anish and I worked on making userfaults more scalable for
> > KVM[1], and we ended up with a scheme very similar to what we have in
> > this KVM Userfault series.
> Yes, I see your motivation. Does this approach support async pagefaults
> [1]? Ie would all the guest processes on the vCPU need to stall until a
> fault is resolved or is there a way to let the vCPU run and only block
> the faulted process?

As implemented, it didn't hook into the async page faults stuff. I
think it's technically possible to do that, but we didn't explore it.

> A more general question is, it looks like Userfaultfd's main purpose was
> to support the postcopy use case [2], yet it fails to do that
> efficiently for large VMs. Would it be ideologically better to try to
> improve Userfaultfd's performance (similar to how it was attempted in
> [3]) or is that something you have already looked into and reached a
> dead end as a part of [4]?

My end goal with [4] was to take contention out of the vCPU +
userfault path completely (so, if we are taking a lock exclusively, we
are the only one taking it). I came to the conclusion that the way to
do this that made the most sense was Anish's memory fault exits idea.
I think it's possible to make userfaults scale better themselves, but
it's much more challenging than the memory fault exits approach for
KVM (and I don't have a good way to do it in mind).

> [1] https://lore.kernel.org/lkml/4AEFB823.4040607@redhat.com/T/
> [2] https://lwn.net/Articles/636226/
> [3] https://lore.kernel.org/lkml/20230905214235.320571-1-peterx@redhat.co=
m/
> [4]
> https://lore.kernel.org/linux-mm/CADrL8HVDB3u2EOhXHCrAgJNLwHkj2Lka1B_kkNb=
0dNwiWiAN_Q@mail.gmail.com/
>
> > My use case already requires using a reasonably complex API for
> > interacting with a separate userland process for fetching memory, and
> > it's really fast. I've never tried to hook userfaultfd into this other
> > process, but I'm quite certain that [1] + this process's interface
> > scale better than userfaultfd does. Perhaps userfaultfd, for
> > not-so-scaled-up cases, could be *slightly* faster, but I mostly care
> > about what happens when we scale to hundreds of vCPUs.
> >
> > [1]: https://lore.kernel.org/kvm/20240215235405.368539-1-amoorthy@googl=
e.com/
> Do I understand it right that in your setup, when an EPT violation occurs=
,
>   - VMM shares the fault information with the other process via a
> userspace protocol
>   - the process fetches the memory, installs it (?) and notifies VMM
>   - VMM calls KVM run to resume execution
> ?

That's right.

> Would you be ok to share an outline of the API you mentioned?

I can share some information. The source (remote) and target (local)
VMMs register guest memory (shared memory) with this network worker
process. On the target during post-copy, the gfn of a fault is
converted into its corresponding local and remote offsets. The API for
then fetching the memory is basically something like
CopyFromRemote(remote_offset, local_offset, length), and the
communication with the process to handle this command is done just
with shared memory. After memory is copied, the faulting thread does a
UFFDIO_CONTINUE (with MODE_DONTWAKE) to map the page, and then we
KVM_RUN to resume. This will make more sense with the description of
UFFDIO_CONTINUE below.

Let me know if you'd like to know more, though I'm not intimately
familiar with all the details of this network worker process.

> >> How do you envision resolving faults in userspace? Copying the page in
> >> (provided that userspace mapping of guest_memfd is supported [3]) and
> >> clearing the KVM_MEMORY_ATTRIBUTE_USERFAULT alone do not look
> >> sufficient to resolve the fault because an attempt to copy the page
> >> directly in userspace will trigger a fault on its own
> >
> > This is not true for KVM Userfault, at least for right now. Userspace
> > accesses to guest memory will not trigger KVM Userfaults. (I know this
> > name is terrible -- regular old userfaultfd() userfaults will indeed
> > get triggered, provided you've set things up properly.)
> >
> > KVM Userfault is merely meant to catch KVM's own accesses to guest
> > memory (including vCPU accesses). For non-guest_memfd memslots,
> > userspace can totally just write through the VMA it has made (KVM
> > Userfault *cannot*, by virtue of being completely divorced from mm,
> > intercept this access). For guest_memfd, userspace could write to
> > guest memory through a VMA if that's where guest_memfd is headed, but
> > perhaps it will rely on exact details of how userspace is meant to
> > populate guest_memfd memory.
> True, it isn't the case right now. I think I fast-forwarded to a state
> where notifications about VMM-triggered faults to the guest_memfd are
> also sent asynchronously.
>
> > In case it's interesting or useful at all, we actually use
> > UFFDIO_CONTINUE for our live migration use case. We mmap() memory
> > twice -- one of them we register with userfaultfd and also give to
> > KVM. The other one we use to install memory -- our non-faulting view
> > of guest memory!
> That is interesting. You're replacing UFFDIO_COPY (vma1) with a memcpy
> (vma2) + UFFDIO_CONTINUE (vma1), IIUC. Are both mappings created by the
> same process? What benefits does it bring?

The cover letter for the patch series where UFFDIO_CONTINUE was
introduced does a good job at explaining why it's useful for live
migration[5]. But I can summarize it here: when doing pre-copy, we
send many copies of memory to the target. Upon resuming on the target,
we want to get faults on the pages with stale content. It may take a
while to send the final dirty bitmap to the target, and we don't want
to leave the VM paused for that long (i.e., treat everything as
stale). When the dirty bitmap arrives, we want to be able to quickly
(like, without having to copy anything) say "stop getting faults on
these pages, they are in fact clean." Using shared memory (i.e.,
having a page cache) with UFFDIO_CONTINUE (well, really
UFFD_FEATURE_MINOR*) allows us to do this.

It also turns out that it is basically necessary if we want our
network API of choice to be able to directly write into guest memory.

[5]: https://lore.kernel.org/linux-mm/20210225002658.2021807-1-axelrasmusse=
n@google.com/

