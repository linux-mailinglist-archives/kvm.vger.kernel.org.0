Return-Path: <kvm+bounces-14776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D468C8A6E12
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 16:25:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8254E280355
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 14:25:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5158B12DD9B;
	Tue, 16 Apr 2024 14:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oO9vjs9w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150BB12C534
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 14:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713277345; cv=none; b=pMqCc4sUfsjmAeflDa1Dh4CKRO1fVVjWUAu/AEyBn6w7lH8EYE7M2712/+LN9EyDKKeoOYSq9d/y7zkolVKmsb1kg5v2iq5VGJG1Za+kgnS0EBLcJm5p1RwdoCiRS5vJU/cacguprYjdv1F7j6OSOL2TjczwenjioHExhgSHRRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713277345; c=relaxed/simple;
	bh=3cqRkxuAoAdclD1Decn0UctEiqoo56MnyyAqYSNaqFw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f34ycglHuAWvLg1C3kzATR9p7wBNgQBXexgqvvjRVSTagz6OBOP66/Z3omVm46BzNA/uDESKjUlS6kt+44CSR8o2El77vN6XXyKPmBqlvBHxcdMAOOLKMjyJ7A+8W4e8cDdkABpuFqW69Tqntq6Y6gQrzaJExDLIccqXp0JGN/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oO9vjs9w; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-615073c8dfbso91320127b3.1
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 07:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713277343; x=1713882143; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k/UOLwv0XSJq/Zhcb8vmfEVms5jwTpIC8eJyCuIIgTE=;
        b=oO9vjs9wCmVH9V9uCoCEqLXzHit5KgzVDCfu7up/n99ulaYVnflm7QsrnrVyma77eA
         tY+gWJLsZy99sU8zahN5Rwb2Sw4Y6jnLUnrEuHjaPDYPzXgZrWDYZz0vOn7tLVDHMPJn
         7IO4VCJiIoWc6hf1zaLQcNVRaGOVvjKzhSFIirH+rI1nEp6NVrYc9QoNOhH6Q/53NSNB
         /OqH6VG0WAwBPmY4v2aGdylUhM5B0Ga+XqZbJr3ngKrRKoSk988OOYYedZQvxQ0F9JD/
         huRLATtJAqkBrVU26rLPG3eqJO7o6jQ/vFPtypZ7dUY7s5BJmUlkeiiip7bXOD11HP1y
         bEVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713277343; x=1713882143;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=k/UOLwv0XSJq/Zhcb8vmfEVms5jwTpIC8eJyCuIIgTE=;
        b=bt9415wQjCqq/G+vDpgLx3MuBHcwWAH5MCl9aUvgUHWtUcb1hYIB9nNqFnV0FqP4r2
         +tSa1hlxmzD7E3maTuA0blLzvVqmXx/70VJ68Hv6DspqHZBuJB5x3RjAY+TCBTz+nIqE
         E8e6sLp+BArmx0wqQ9n/Kz9WKSacp4NxcfnAjnntCPdx31jRHgfhBVeie/TBkX5Pycvv
         tC4uDoTxO9WJrvbvsknquNEXjLBLvgkYUqNEY/L1Ui1K7yKsoeY3lx3HUZTIqSdsapRa
         bV1Eny+EUif515pkivORbDxlhbJmFEtoy7yNNEyQp9JSpZoQHKsCdcI6Q4xKY108Y9ZD
         g5YQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4dH4T159y1kptPIAKPLYFU3jbS1lt4z6zbT4Ol8Uk2zE1Q/vEPTuSdeapvtl7urzhDPelBW4UIL0dzPmve4lFvFtc
X-Gm-Message-State: AOJu0YwxHzXqKCGkmzL8OsGoWc5ds4PJSlHoRfuizmbbF8pmxC4wJBQv
	L5TL6kOmXHYUgXMWYwUjhjBOLOYyqkpXC+xtA4L7mJzMVfOhXklhkwfBuIqojy78QOH7oqPfTCe
	0nA==
X-Google-Smtp-Source: AGHT+IH4L7bxzfAmLvXgK5qDnsanL4f0HebJHtDqLccexofjsXMGDPYacotzowqfEWUaTjnLoM96cIwRCHA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:d17:b0:611:2c40:e8d0 with SMTP id
 cn23-20020a05690c0d1700b006112c40e8d0mr3236216ywb.3.1713277343237; Tue, 16
 Apr 2024 07:22:23 -0700 (PDT)
Date: Tue, 16 Apr 2024 07:22:21 -0700
In-Reply-To: <20240416014931.GW3039520@ls.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1712785629.git.isaku.yamahata@intel.com>
 <2f1de1b7b6512280fae4ac05e77ced80a585971b.1712785629.git.isaku.yamahata@intel.com>
 <116179545fafbf39ed01e1f0f5ac76e0467fc09a.camel@intel.com>
 <Zh2ZTt4tXXg0f0d9@google.com> <20240416014931.GW3039520@ls.amr.corp.intel.com>
Message-ID: <Zh6JndoNGqEhCpCR@google.com>
Subject: Re: [PATCH v2 07/10] KVM: x86: Always populate L1 GPA for KVM_MAP_MEMORY
From: Sean Christopherson <seanjc@google.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Kai Huang <kai.huang@intel.com>, 
	"federico.parola@polito.it" <federico.parola@polito.it>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "dmatlack@google.com" <dmatlack@google.com>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	isaku.yamahata@linux.intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 15, 2024, Isaku Yamahata wrote:
> On Mon, Apr 15, 2024 at 02:17:02PM -0700,
> Sean Christopherson <seanjc@google.com> wrote:
>=20
> > > > - Return error on guest mode or SMM mode:=C2=A0 Without this patch.
> > > > =C2=A0 Pros: No additional patch.
> > > > =C2=A0 Cons: Difficult to use.
> > >=20
> > > Hmm... For the non-TDX use cases this is just an optimization, right?=
 For TDX
> > > there shouldn't be an issue. If so, maybe this last one is not so hor=
rible.
> >=20
> > And the fact there are so variables to control (MAXPHADDR, SMM, and gue=
st_mode)
> > basically invalidates the argument that returning an error makes the io=
ctl() hard
> > to use.  I can imagine it might be hard to squeeze this ioctl() into QE=
MU's
> > existing code, but I don't buy that the ioctl() itself is hard to use.
> >=20
> > Literally the only thing userspace needs to do is set CPUID to implicit=
ly select
> > between 4-level and 5-level paging.  If userspace wants to pre-map memo=
ry during
> > live migration, or when jump-starting the guest with pre-defined state,=
 simply
> > pre-map memory before stuffing guest state.  In and of itself, that doe=
sn't seem
> > difficult, e.g. at a quick glance, QEMU could add a hook somewhere in
> > kvm_vcpu_thread_fn() without too much trouble (though that comes with a=
 huge
> > disclaimer that I only know enough about how QEMU manages vCPUs to be d=
angerous).
> >=20
> > I would describe the overall cons for this patch versus returning an er=
ror
> > differently.  Switching MMU state puts the complexity in the kernel.  R=
eturning
> > an error punts any complexity to userspace.  Specifically, anything tha=
t KVM can
> > do regarding vCPU state to get the right MMU, userspace can do too.
> > =20
> > Add on that silently doing things that effectively ignore guest state u=
sually
> > ends badly, and I don't see a good argument for this patch (or any vari=
ant
> > thereof).
>=20
> Ok, here is a experimental patch on top of the 7/10 to return error.  Is =
this
> a direction? or do we want to invoke KVM page fault handler without any c=
heck?
>=20
> I can see the following options.
>=20
> - Error if vCPU is in SMM mode or guest mode: This patch
>   Defer the decision until the use cases come up.  We can utilize
>   KVM_CAP_MAP_MEMORY and struct kvm_map_memory.flags for future
>   enhancement.
>   Pro: Keep room for future enhancement for unclear use cases to defer
>        the decision.
>   Con: The use space VMM has to check/switch the vCPU mode.
>=20
> - No check of vCPU mode and go on
>   Pro: It works.
>   Con: Unclear how the uAPI should be without concrete use cases.
>=20
> - Always populate with L1 GPA:
>   This is a bad idea.

Not always.  If L1 is using shadow paging, then L1 and L2 GPAs are in the s=
ame
domain from KVM's perspective.

As I said in v1 (I think it was v1), whether or not mapping an L1 GPA is su=
pported
should be a property of the mmu, not an explicit check.  As far as the TDP =
MMU is
concerend, there's nothing special about SMM nor is there anything special =
about
guest_mode, except for the fact that they use different roots than "normal"=
 mode.
But that part Just Works.

And if L1 is using TDP, i.e. KVM is shadowing L1's TDP page tables, and L2 =
is
active, then vcpu->arch.mmu will point at a variation of the shadow MMU, e.=
g.
the PTTYPE_EPT MMU on Intel CPUs.  The shadow MMU won't support pre-mapping=
 GPAs
because it's non-sensical (legacy shadow paging needs a GVA, nested TDP nee=
ds an
L2 GPA), and so the ioctl() fails because mmu->map_gpa or whatever is NULL.

In other words, unless I'm forgetting something, explicit checks for "unsup=
ported"
modes shoud be unnecessary, because

