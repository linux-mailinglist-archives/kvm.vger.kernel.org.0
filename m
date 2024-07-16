Return-Path: <kvm+bounces-21729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E62F932EEA
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 19:11:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10E5F1C222C8
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 17:11:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5206919FA94;
	Tue, 16 Jul 2024 17:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0d13dRIA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C120419F48C
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 17:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721149868; cv=none; b=bGXGn5v0UuMScoKwyeWNEB1DBdEXNxprwi/ALlxPm/UqXD/SgzUp+itzBftwkkHHLRT5g/41q5tAJtH8TaYGbFkiqwBWoHlfnxGxAd03gQ383ArDH1/XHxc6lSzM5ZjGdIX/WZ47LlfgbYP4vot/C4KEIBnt2IXpT8fn7k7oIiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721149868; c=relaxed/simple;
	bh=d9Y3PppBIVaDeA7OUV7QSIfz7XlMBytja2woDfy2rK4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LvLzv3R07YVPFF4NP0xyRH46Lbjp0CQ+G0itiSrEmcc1sSm9GhbCvfmgk1cpY4LcHf0aNgq3ztlOhZCCxWKrVFnityIv7pnF9SKh2pwqYT1UnwdtK/jX10TEuN87fVYP5dSj73S7R9atfbWBt91EzjGkWeZcrrTbwiq8Hsj6TxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0d13dRIA; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-44a8b140a1bso18841cf.0
        for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 10:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721149866; x=1721754666; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DV9GhdKZyJ6M+6gQqAdxuqd09DQjKmEarDGs4L0SsCI=;
        b=0d13dRIAB5GTTXQ4R7HHUgEVpJYZdGKUMMbUtQpJgzyU8RQsXfveZc9oW75Ewq9YSL
         IEmfRYqrGMOgwwwPltsqqValwqQu093pHuiXFfFsoaB+CyvKxw+BXcSv8vClj5xftCQ/
         UBvcIRM31f0qCvnI+VRiD90lVs6S31HYav7cqBAqzRb/uC6nx4dY9DDraJqXMjFlHB7r
         ZQgXDb32SxPXo2OtLoG0twic7Xnrvseeev7Xx8zDRIpZVv7PHT+2AVoaniDUyOqPPrRG
         voOn7ts2bzDpplC8xhO+rmLZmsyLdFW+gTBoYKSkjX/It98bYqM2k7XqSQYFX25XEz09
         xR9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721149866; x=1721754666;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DV9GhdKZyJ6M+6gQqAdxuqd09DQjKmEarDGs4L0SsCI=;
        b=vPAvJvKAs5HhyfWRGwn9lU44voHHp5LwmfIOMmHo9a/Y1O+Gz2duOKgk7y8Va/RYfs
         asakktDgYH0/JUnkHya9tA/giGs7ypQJa0WJljIBRJebPjFzbq43nTjGF8ff700pvXi6
         OlFOWQn21W34xn7E2nNOWfhpZ6IeccPTtILXtQf3XpX1+wKkQ+eOyDFqpVS4ZgV0hbq9
         Uto+dte4qVkoB2c8T7yxoufaYIdIn1m7yDe0Y4o5SMftbD6iK3D+qIbIESw5oYm+h3+9
         EnsVN/tyU+IuLxhF8ATMRY8TF4roaCBtIQ0JumJ3kLEPD2I5dqP3htcWTm7Q2r5mqMA8
         kwCQ==
X-Forwarded-Encrypted: i=1; AJvYcCX2EKWHpz1MZVlD83xuxHGZN9LkgIaTyGOyYjYQOfGTbBVRvXzX03PN/DVe+ERXSM/JPM68fBpYxknYvIZjS69MIwX0
X-Gm-Message-State: AOJu0YzFzB99+e53xlwet8IYgriQxxNQxtBDQ06dVwqPKcN0rCUUDqqM
	SubgX7pyJiqZ5SQ1MlI30PW3t4ovWfMGbYxJTnphzf155bt6qnhvuauBf7co3oHLvCYMMYi+yAn
	LsI/3l7m/4qSv66BTK2Ggn77ZpxFZQaykONeq
X-Google-Smtp-Source: AGHT+IFaV9/2Z7WSL/mHSXyBRuqYSsif3Jd7vrRf+CGU9hcp7x64cONNeb1r2bfZCOcTK8Iuat3cjGzcxnXcLyg9ASI=
X-Received: by 2002:a05:622a:2a0f:b0:444:dc9a:8e95 with SMTP id
 d75a77b69052e-44f7b927bc1mr3465511cf.15.1721149865452; Tue, 16 Jul 2024
 10:11:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com> <DS0PR11MB637397059B5DAE2AA7B819BCDCA12@DS0PR11MB6373.namprd11.prod.outlook.com>
In-Reply-To: <DS0PR11MB637397059B5DAE2AA7B819BCDCA12@DS0PR11MB6373.namprd11.prod.outlook.com>
From: James Houghton <jthoughton@google.com>
Date: Tue, 16 Jul 2024 10:10:27 -0700
Message-ID: <CADrL8HUv+RvazbOyx+NJ1oNd8FdMGd_T61Kjtia1cqJsN=WiOA@mail.gmail.com>
Subject: Re: [RFC PATCH 00/18] KVM: Post-copy live migration for guest_memfd
To: "Wang, Wei W" <wei.w.wang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, David Matlack <dmatlack@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 15, 2024 at 8:28=E2=80=AFAM Wang, Wei W <wei.w.wang@intel.com> =
wrote:
>
> On Thursday, July 11, 2024 7:42 AM, James Houghton wrote:
> > This patch series implements the KVM-based demand paging system that wa=
s
> > first introduced back in November[1] by David Matlack.
> >
> > The working name for this new system is KVM Userfault, but that name is=
 very
> > confusing so it will not be the final name.
> >
> Hi James,
> I had implemented a similar approach for TDX post-copy migration, there a=
re quite
> some differences though. Got some questions about your design below.

Thanks for the feedback!!

>
> > Problem: post-copy with guest_memfd
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > Post-copy live migration makes it possible to migrate VMs from one host=
 to
> > another no matter how fast they are writing to memory while keeping the=
 VM
> > paused for a minimal amount of time. For post-copy to work, we
> > need:
> >  1. to be able to prevent KVM from being able to access particular page=
s
> >     of guest memory until we have populated it  2. for userspace to kno=
w when
> > KVM is trying to access a particular
> >     page.
> >  3. a way to allow the access to proceed.
> >
> > Traditionally, post-copy live migration is implemented using userfaultf=
d, which
> > hooks into the main mm fault path. KVM hits this path when it is doing =
HVA ->
> > PFN translations (with GUP) or when it itself attempts to access guest =
memory.
> > Userfaultfd sends a page fault notification to userspace, and KVM goes =
to sleep.
> >
> > Userfaultfd works well, as it is not specific to KVM; everyone who atte=
mpts to
> > access guest memory will block the same way.
> >
> > However, with guest_memfd, we do not use GUP to translate from GFN to H=
PA
> > (nor is there an intermediate HVA).
> >
> > So userfaultfd in its current form cannot be used to support post-copy =
live
> > migration with guest_memfd-backed VMs.
> >
> > Solution: hook into the gfn -> pfn translation
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > The only way to implement post-copy with a non-KVM-specific userfaultfd=
-like
> > system would be to introduce the concept of a file-userfault[2] to inte=
rcept
> > faults on a guest_memfd.
> >
> > Instead, we take the simpler approach of adding a KVM-specific API, and=
 we
> > hook into the GFN -> HVA or GFN -> PFN translation steps (for tradition=
al
> > memslots and for guest_memfd respectively).
>
>
> Why taking KVM_EXIT_MEMORY_FAULT faults for the traditional shared
> pages (i.e. GFN -> HVA)?
> It seems simpler if we use KVM_EXIT_MEMORY_FAULT for private pages only, =
leaving
> shared pages to go through the existing userfaultfd mechanism:
> - The need for =E2=80=9Casynchronous userfaults,=E2=80=9D introduced by p=
atch 14, could be eliminated.
> - The additional support (e.g., KVM_MEMORY_EXIT_FLAG_USERFAULT) for priva=
te page
>   faults exiting to userspace for postcopy might not be necessary, becaus=
e all pages on the
>   destination side are initially =E2=80=9Cshared,=E2=80=9D and the guest=
=E2=80=99s first access will always cause an
>   exit to userspace for shared->private conversion. So VMM is able to lev=
erage the exit to
>   fetch the page data from the source (VMM can know if a page data has be=
en fetched
>   from the source or not).

You're right that, today, including support for guest-private memory
*only* indeed simplifies things (no async userfaults). I think your
strategy for implementing post-copy would work (so, shared->private
conversion faults for vCPU accesses to private memory, and userfaultfd
for everything else).

I'm not 100% sure what should happen in the case of a non-vCPU access
to should-be-private memory; today it seems like KVM just provides the
shared version of the page, so conventional use of userfaultfd
shouldn't break anything.

But eventually guest_memfd itself will support "shared" memory, and
(IIUC) it won't use VMAs, so userfaultfd won't be usable (without
changes anyway). For a non-confidential VM, all memory will be
"shared", so shared->private conversions can't help us there either.
Starting everything as private almost works (so using private->shared
conversions as a notification mechanism), but if the first time KVM
attempts to use a page is not from a vCPU (and is from a place where
we cannot easily return to userspace), the need for "async userfaults"
comes back.

For this use case, it seems cleaner to have a new interface. (And, as
far as I can tell, we would at least need some kind of "async
userfault"-like mechanism.)

Another reason why, today, KVM Userfault is helpful is that
userfaultfd has a couple drawbacks. Userfaultfd migration with
HugeTLB-1G is basically unusable, as HugeTLB pages cannot be mapped at
PAGE_SIZE. Some discussion here[1][2].

Moving the implementation of post-copy to KVM means that, throughout
post-copy, we can avoid changes to the main mm page tables, and we
only need to modify the second stage page tables. This saves the
memory needed to store the extra set of shattered page tables, and we
save the performance overhead of the page table modifications and
accounting that mm does.

There's some more discussion about these points in David's RFC[3].

[1]: https://lore.kernel.org/linux-mm/20230218002819.1486479-1-jthoughton@g=
oogle.com/
[2]: https://lore.kernel.org/linux-mm/ZdcKwK7CXgEsm-Co@x1n/
[3]: https://lore.kernel.org/kvm/CALzav=3Dd23P5uE=3DoYqMpjFohvn0CASMJxXB_XE=
OEi-jtqWcFTDA@mail.gmail.com/

>
> >

> > I have intentionally added support for traditional memslots, as the com=
plexity
> > that it adds is minimal, and it is useful for some VMMs, as it can be u=
sed to
> > fully implement post-copy live migration.
> >
> > Implementation Details
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > Let's break down how KVM implements each of the three core requirements
> > for implementing post-copy as laid out above:
> >
> > --- Preventing access: KVM_MEMORY_ATTRIBUTE_USERFAULT ---
> >
> > The most straightforward way to inform KVM of userfault-enabled pages i=
s to
> > use a new memory attribute, say KVM_MEMORY_ATTRIBUTE_USERFAULT.
> >
> > There is already infrastructure in place for modifying and checking mem=
ory
> > attributes. Using this interface is slightly challenging, as there is n=
o UAPI for
> > setting/clearing particular attributes; we must set the exact attribute=
s we want.
> >
> > The synchronization that is in place for updating memory attributes is =
not
> > suitable for post-copy live migration either, which will require updati=
ng
> > memory attributes (from userfault to no-userfault) very frequently.
> >
> > Another potential interface could be to use something akin to a dirty b=
itmap,
> > where a bitmap describes which pages within a memslot (or VM) should tr=
igger
> > userfaults. This way, it is straightforward to make updates to the user=
fault
> > status of a page cheap.
> >
> > When KVM Userfault is enabled, we need to be careful not to map a userf=
ault
> > page in response to a fault on a non-userfault page. In this RFC, I've =
taken the
> > simplest approach: force new PTEs to be PAGE_SIZE.
> >
> > --- Page fault notifications ---
> >
> > For page faults generated by vCPUs running in guest mode, if the page t=
he
> > vCPU is trying to access is a userfault-enabled page, we use
>
> Why is it necessary to add the per-page control (with uAPIs for VMM to se=
t/clear)?
> Any functional issues if we just have all the page faults exit to userspa=
ce during the
> post-copy period?
> - As also mentioned above, userspace can easily know if a page needs to b=
e
>   fetched from the source or not, so upon a fault exit to userspace, VMM =
can
>   decide to block the faulting vcpu thread or return back to KVM immediat=
ely.
> - If improvement is really needed (would need profiling first) to reduce =
number
>   of exits to userspace, a  KVM internal status (bitmap or xarray) seems =
sufficient.
>   Each page only needs to exit to userspace once for the purpose of fetch=
ing its data
>   from the source in postcopy. It doesn't seem to need userspace to enabl=
e the exit
>   again for the page (via a new uAPI), right?

We don't necessarily need a way to go from no-fault -> fault for a
page, that's right[4]. But we do need a way for KVM to be able to
allow the access to proceed (i.e., go from fault -> no-fault). IOW, if
we get a fault and come out to userspace, we need a way to tell KVM
not to do that again. In the case of shared->private conversions, that
mechanism is toggling the memory attributes for a gfn. For
conventional userfaultfd, that's using UFFDIO_COPY/CONTINUE/POISON.
Maybe I'm misunderstanding your question.

[4]: It is helpful for poison emulation for HugeTLB-backed VMs today,
but this is not important.

