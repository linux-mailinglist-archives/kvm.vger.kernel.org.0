Return-Path: <kvm+bounces-26172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E664A9725FF
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 01:58:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 43DC4B21C6A
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 23:58:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E00518EFC6;
	Mon,  9 Sep 2024 23:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IelwXWkc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A44C18E36E
	for <kvm@vger.kernel.org>; Mon,  9 Sep 2024 23:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725926303; cv=none; b=J9ccemw0yrx5Gv7eWBPwiUUDwEjjtXOUWiq+v5yy0O12ipyynYGrM1vBCXRMc3W+4ufRVpvpGhekwjx4scUJesQWrNEth6R3C+jorRCe4n2/yZ4fR8aNaNlqt+IZ787nuasp49ooOYp0m9sxIHskAz9er6wEgIlSZRLMPbYkn2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725926303; c=relaxed/simple;
	bh=rAsj1s9qFPmjkLnE5bAbBBMOVdQ/Nm2tIAGLMo0JMxc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aQihw1Nz6PtP78xsq1j+Il+98kbggLF6JBhc0ZRJsiyfzFLPQN0hMqixn4zJbjOC92rtWaUuClzxJOeuE6byTMnJvB4RWoqr6WMNW6Dk3Q+Vdieuf2UDmNGQhugQJ1IiGJnzrcxP2IOQ/Q8huQcI0zKHyS07EvSaH5rVuDIFdpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IelwXWkc; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e1cf5a262a1so13037759276.0
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2024 16:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725926301; x=1726531101; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vf3/RT96m5N9OrQpcP8mMpidT2hLWI0xZKMNo+VkJCE=;
        b=IelwXWkcLJeVgFbGCljKex6S8lLmbi3vFalhBrnRq+2/dN13MNMq9aVrnMNPCYFB2S
         TSsGhL98AsL+W9nbeeuUm1T6LGQuWLmvFNZVjF9u7SDRKmCUtGCl/tfG23opDgjA28/e
         U8Mk+7lnJ5ELZNgcPXRsJ+498ZmUtXr8BbISJNU0zXA9x1DVQUu1RgD9D2wPiZYwgsf1
         oMkKjTT57yeR9OKI2PdYkV5GR2CyDRUOC86IUJwE/oL6vO9IWDXi8fdc0s+shXYx9eXx
         K7nzeuCuNSXbTFr//EfrqT1esevVrer16dwlaer3bh0dxiflUD/iKsQVegQfPu2NfQQZ
         HCPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725926301; x=1726531101;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Vf3/RT96m5N9OrQpcP8mMpidT2hLWI0xZKMNo+VkJCE=;
        b=XY8D3NZExXNEWTnapVW2+DCBavDf41jp6vHOl00xVtRGJB+woAszTcIZyBnrQ7Ufzt
         TZZFuwDauiMyc7zJCT+Vaq+499kz6c3J++iySid88+ESjbLunxVvJrYo72vV7deLqKvp
         HmK/CPLX+v6wIUrv2RgfNEgx6ush0Cov3DEWX8ekySW2G7PkF13wXpDbtPDZxzQEXuZX
         8gY8oSED2obNxGr6p/UAWW7miMUwf5pEGx3YjxblwUJYexGV4Fj1mLRZq0sMlU+/GOVX
         UT7hzHtNLAI0qZR3bd3b9j+dgydRg+wJXP5HrO1sQo9JTlxsY0oRD7lcBssiF9kFMlbS
         /eBw==
X-Forwarded-Encrypted: i=1; AJvYcCX1cR1XsxaC4R2MUQ+P5Qsh5qZtBvYsZsIb30qkYcrHI0J+przwsZyBov6Ru9pIqWwRilI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtWs3Hkx1AO0COCwdDrqLT/dsiumBh8s02rAPA7XgeSW1upEU3
	HVVtYgLexAHvJSIEMrbPpUi/jiDeQst3L+0LQsjX+wjFYavYEBMsifubJDxUOxYgiA9hqqPuJOE
	MEA==
X-Google-Smtp-Source: AGHT+IGQHKStZ3MEEEQ/Kd6Qzm+5KxNi5CSKkbEtHmszfppqGtBVtmmhHdX9JBQ5Iyi0YUu+PkLA8a0r10U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:641:b0:e0b:af9b:fb94 with SMTP id
 3f1490d57ef6-e1d7a225025mr11049276.6.1725926300985; Mon, 09 Sep 2024 16:58:20
 -0700 (PDT)
Date: Mon, 9 Sep 2024 16:58:19 -0700
In-Reply-To: <72ef77d580d2f16f0b04cbb03235109f5bde48dd.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
 <20240904030751.117579-10-rick.p.edgecombe@intel.com> <6449047b-2783-46e1-b2a9-2043d192824c@redhat.com>
 <b012360b4d14c0389bcb77fc8e9e5d739c6cc93d.camel@intel.com>
 <Zt9kmVe1nkjVjoEg@google.com> <Zt9nWjPXBC8r0Xw-@google.com> <72ef77d580d2f16f0b04cbb03235109f5bde48dd.camel@intel.com>
Message-ID: <Zt-LmzUSyljHGcMO@google.com>
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with
 operand SEPT
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yuan Yao <yuan.yao@intel.com>, 
	Kai Huang <kai.huang@intel.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	Yan Y Zhao <yan.y.zhao@intel.com>, "dmatlack@google.com" <dmatlack@google.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "nik.borisov@suse.com" <nik.borisov@suse.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 09, 2024, Rick P Edgecombe wrote:
> On Mon, 2024-09-09 at 14:23 -0700, Sean Christopherson wrote:
> > > In general, I am _very_ opposed to blindly retrying an SEPT SEAMCALL,
> > > ever.=C2=A0 For its operations, I'm pretty sure the only sane approac=
h is for
> > > KVM to ensure there will be no contention.=C2=A0 And if the TDX modul=
e's
> > > single-step protection spuriously kicks in, KVM exits to userspace.=
=C2=A0 If
> > > the TDX module can't/doesn't/won't communicate that it's mitigating
> > > single-step, e.g. so that KVM can forward the information to userspac=
e,
> > > then that's a TDX module problem to solve.
> > >=20
> > > > Per the docs, in general the VMM is supposed to retry SEAMCALLs tha=
t
> > > > return TDX_OPERAND_BUSY.
> > >=20
> > > IMO, that's terrible advice.=C2=A0 SGX has similar behavior, where th=
e xucode
> > > "module" signals #GP if there's a conflict.=C2=A0 #GP is obviously fa=
r, far
> > > worse as it lacks the precision that would help software understand
> > > exactly what went wrong, but I think one of the better decisions we m=
ade
> > > with the SGX driver was to have a "zero tolerance" policy where the
> > > driver would _never_ retry due to a potential resource conflict, i.e.
> > > that any conflict in the module would be treated as a kernel bug.
>=20
> Thanks for the analysis. The direction seems reasonable to me for this lo=
ck in
> particular. We need to do some analysis on how much the existing mmu_lock=
 can
> protects us.=20

I would operate under the assumption that it provides SEPT no meaningful pr=
otection.
I think I would even go so far as to say that it is a _requirement_ that mm=
u_lock
does NOT provide the ordering required by SEPT, because I do not want to ta=
ke on
any risk (due to SEPT constraints) that would limit KVM's ability to do thi=
ngs
while holding mmu_lock for read.

> Maybe sprinkle some asserts for documentation purposes.

Not sure I understand, assert on what?

> For the general case of TDX_OPERAND_BUSY, there might be one wrinkle. The=
 guest
> side operations can take the locks too. From "Base Architecture Specifica=
tion":
> "
> Host-Side (SEAMCALL) Operation
> ------------------------------
> The host VMM is expected to retry host-side operations that fail with a
> TDX_OPERAND_BUSY status. The host priority mechanism helps guarantee that=
 at
> most after a limited time (the longest guest-side TDX module flow) there =
will be
> no contention with a guest TD attempting to acquire access to the same re=
source.
>=20
> Lock operations process the HOST_PRIORITY bit as follows:
>    - A SEAMCALL (host-side) function that fails to acquire a lock sets th=
e lock=E2=80=99s
>    HOST_PRIORITY bit and returns a TDX_OPERAND_BUSY status to the host VM=
M. It is
>    the host VMM=E2=80=99s responsibility to re-attempt the SEAMCALL funct=
ion until is
>    succeeds; otherwise, the HOST_PRIORITY bit remains set, preventing the=
 guest TD
>    from acquiring the lock.
>    - A SEAMCALL (host-side) function that succeeds to acquire a lock clea=
rs the
>    lock=E2=80=99s HOST_PRIORITY bit.

*sigh*

> Guest-Side (TDCALL) Operation
> -----------------------------
> A TDCALL (guest-side) function that attempt to acquire a lock fails if
> HOST_PRIORITY is set to 1; a TDX_OPERAND_BUSY status is returned to the g=
uest.
> The guest is expected to retry the operation.
>=20
> Guest-side TDCALL flows that acquire a host priority lock have an upper b=
ound on
> the host-side latency for that lock; once a lock is acquired, the flow ei=
ther
> releases within a fixed upper time bound, or periodically monitor the
> HOST_PRIORITY flag to see if the host is attempting to acquire the lock.
> "
>=20
> So KVM can't fully prevent TDX_OPERAND_BUSY with KVM side locks, because =
it is
> involved in sorting out contention between the guest as well. We need to =
double
> check this, but I *think* this HOST_PRIORITY bit doesn't come into play f=
or the
> functionality we need to exercise for base support.
>=20
> The thing that makes me nervous about retry based solution is the potenti=
al for
> some kind deadlock like pattern. Just to=C2=A0gather your opinion, if the=
re was some
> SEAMCALL contention that couldn't be locked around from KVM, but came wit=
h some
> strong well described guarantees, would a retry loop be hard NAK still?

I don't know.  It would depend on what operations can hit BUSY, and what th=
e
alternatives are.  E.g. if we can narrow down the retry paths to a few sele=
ct
cases where it's (a) expected, (b) unavoidable, and (c) has minimal risk of
deadlock, then maybe that's the least awful option.

What I don't think KVM should do is blindly retry N number of times, becaus=
e
then there are effectively no rules whatsoever.  E.g. if KVM is tearing dow=
n a
VM then KVM should assert on immediate success.  And if KVM is handling a f=
ault
on behalf of a vCPU, then KVM can and should resume the guest and let it re=
try.
Ugh, but that would likely trigger the annoying "zero-step mitigation" crap=
.

What does this actually mean in practice?  What's the threshold, is the VM-=
Enter
error uniquely identifiable, and can KVM rely on HOST_PRIORITY to be set if=
 KVM
runs afoul of the zero-step mitigation?

  After a pre-determined number of such EPT violations occur on the same in=
struction,
  the TDX module starts tracking the GPAs that caused Secure EPT faults and=
 fails
  further host VMM attempts to enter the TD VCPU unless previously faulting=
 private
  GPAs are properly mapped in the Secure EPT.

If HOST_PRIORITY is set, then one idea would be to resume the guest if ther=
e's
SEPT contention on a fault, and then _if_ the zero-step mitigation is trigg=
ered,
kick all vCPUs (via IPI) to ensure that the contended SEPT entry is unlocke=
d and
can't be re-locked by the guest.  That would allow KVM to guarantee forward
progress without an arbitrary retry loop in the TDP MMU.

Similarly, if KVM needs to zap a SPTE and hits BUSY, kick all vCPUs to ensu=
re the
one and only retry is guaranteed to succeed.

