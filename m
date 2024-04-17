Return-Path: <kvm+bounces-14990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AF11E8A8893
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 18:13:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3ACD11F259C5
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 16:13:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF54915B567;
	Wed, 17 Apr 2024 16:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G6+lPSUl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1D9148FF0
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 16:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713370292; cv=none; b=aV7A9J7bK7TDmVwFoh4xxwpyiwpUITOAVrhnXEgaRVKSTjGS6RMXLlC5TTOAhuWAheM9TR9eMLe3y7FzD9NpuaFyBu9gLdapCpr3FjNdLgjb56lvGjd2QrhoHrG2Tg0dOrEbwWUq7pBA5+20TRF5KPjo6EJTaFd1KC89FD/0ip0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713370292; c=relaxed/simple;
	bh=Xv58JPBMkvjqeTUuWpAmGROcJfdavCAx5eUeGZ+QKbs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OEE3z9yddCqDDAU0JVW3SeBiv7gVTsaOrtsUvbZL0uCayWdzTW59yzeSWMHbjDQqIpgZ5qZD0/Snp+Qzsrm+yZ4EwcB9ay2oeYhslmtHdnGPJY64KUVTOMfBXu8JrEssX0SaD3VatfeeWRhcWKJHqwllBHsQkq48S+6DNdQgJV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G6+lPSUl; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61ab7fc5651so58097287b3.2
        for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 09:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713370290; x=1713975090; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6K92tAN08KHDtbc83C/Gfrb2VXY13bOFkYmFFlvk/bM=;
        b=G6+lPSUl0S9c7EatAnRCShOiab1KZyn4G/1xJF+e3+rHSOvoErmQWRZzI0VD6i1ydr
         WpoL/8ctCbjr47xY1z+QnArVSkNe/GMHBm44xqxsMdvHx0dkSgcjapyyYFhh+KI6DQBb
         e6RdwhS+DBa66HYNlm0gOrPhWte14pZ0H4SD4LuuAD3DQ8pN1HQsdt+e9t6YZhZI+HB4
         OWoFIg0y16KU9BE7tEwr0PKGk++8VknDGz1nDFCG75ijBCrTzhZrixloN8tMq+6PWILX
         H7iNywKGW37QsO4bO++j92pheRrd4i2rgGBb9bKLiQkiWTWaIbbEYIZ5kJ1BvoUPDOHS
         NjAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713370290; x=1713975090;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6K92tAN08KHDtbc83C/Gfrb2VXY13bOFkYmFFlvk/bM=;
        b=oWJ295uTucoJOr/2+W1oTCay9MM8kfthLkj+6OyiEicR5WgQG403DN+zDArSSRUdCU
         w/7osTKdfgPJJ3zBgO34ZTrl4TyEXTnSgjCzHi87U3bNPmqBaUw5WBOYt7K/b3FJ38OA
         yxt01AbLjA7Yhyk36wMJyJTfTygJ2IhS60TFK0vqgIIzwT7rC/6CaeWLbI+RZZ7m9jqx
         A8TYqjbiKw+/PyJsd9QtaU1+4DJ2n5ZUlJtP5dWbx1RQpIncPKD5SNkYXAsJtumeDHCK
         C0j5rsxCvHZbDAxkiXRepxbtZ4n3kl7jV/9vko9jdB/dK3G+25fbmwYPS7tMYMvQvnB4
         RysA==
X-Forwarded-Encrypted: i=1; AJvYcCUtTGwv/5wtCowB986b9bAE3yFG8i+p0z9SLefadx3T6u0GJe4u3kDULiMV7yBN/ahyZ2C6DKqJX9qTVrf419F9ifuE
X-Gm-Message-State: AOJu0YxSPUWvNRJ7Ti1gYxrs7KqsZ4EZYEPgLDliycpWsuhSRLkYSUsF
	McrAnkzRtLQUg2NkRrrhLQV/w40nzodgDjmt7Y7jP/ZfuxR9a+a5Fc7KM43pR+OHQrubBMxmXt/
	PTg==
X-Google-Smtp-Source: AGHT+IHHi4gPgfR9HpFmvtb4m3ZR/Jd0g2m2zqQWUWOwbR8uDRfBGUR7GOF/YtaHwXsoAud3JyBTo7Ik95k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:528b:0:b0:61a:d437:fab with SMTP id
 g133-20020a81528b000000b0061ad4370fabmr652276ywb.0.1713370289823; Wed, 17 Apr
 2024 09:11:29 -0700 (PDT)
Date: Wed, 17 Apr 2024 09:11:28 -0700
In-Reply-To: <adb07a02b3923eeb49f425d38509b340f4837e17.camel@cyberus-technology.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240416123558.212040-1-julian.stecklina@cyberus-technology.de>
 <Zh6MmgOqvFPuWzD9@google.com> <ecb314c53c76bc6d2233a8b4d783a15297198ef8.camel@cyberus-technology.de>
 <Zh6WlOB8CS-By3DQ@google.com> <c2ca06e2d8d7ef66800f012953b8ea4be0147c92.camel@cyberus-technology.de>
 <Zh6-e9hy7U6DD2QM@google.com> <adb07a02b3923eeb49f425d38509b340f4837e17.camel@cyberus-technology.de>
Message-ID: <Zh_0sJPPoHKce5Ky@google.com>
Subject: Re: [PATCH 1/2] KVM: nVMX: fix CR4_READ_SHADOW when L0 updates CR4
 during a signal
From: Sean Christopherson <seanjc@google.com>
To: Thomas Prescher <thomas.prescher@cyberus-technology.de>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "x86@kernel.org" <x86@kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>, 
	Julian Stecklina <julian.stecklina@cyberus-technology.de>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 17, 2024, Thomas Prescher wrote:
> On Tue, 2024-04-16 at 11:07 -0700, Sean Christopherson wrote:
> > Hur dur, I forgot that KVM provides a "guest_mode" stat.=C2=A0 Userspac=
e can do
> > KVM_GET_STATS_FD on the vCPU FD to get a file handle to the binary stat=
s,
> > and then you wouldn't need to call back into KVM just to query guest_mo=
de.
> >=20
> > Ah, and I also forgot that we have kvm_run.flags, so adding
> > KVM_RUN_X86_GUEST_MODE would also be trivial (I almost suggested it
> > earlier, but didn't want to add a new field to kvm_run without a very g=
ood
> > reason).
>=20
> Thanks for the pointers. This is really helpful.
>=20
> I tried the "guest_mode" stat as you suggested and it solves the
> immediate issue we have with VirtualBox/KVM.

Note,=20

> What I don't understand is that we do not get the effective CR4 value
> of the L2 guest in kvm_run.s.regs.sregs.cr4.

Because what you're asking for is *not* the effective CR4 value of L2.

E.g. if L1 is using legacy shadowing paging to run L2, L1 is likely going t=
o run
L2 with GUEST_CR0.PG=3D1, GUEST_CR4.PAE=3D1, and GUEST_CR4.PSE=3D0 (though =
PSE is largely
irrelevant), i.e. will either use PAE paging or 64-bit paging to shadow L2.

But L2 itself could be unpaged (CR0.PG=3D0, CR4.PAE=3Dx, CR4.PSE=3Dx), usin=
g 32-bit
paging (CR0.PG=3D1, CR4.PAE=3D0, CR4.PSE=3D0), or using 32-bit paging with =
4MiB hugepages
(CR0.PG=3D1, CR4.PAE=3D0, CR4.PSE=3D1).  In all of those cases, the effecti=
ve CR0 and CR4
values consumed by hardware are CR0.PG=3D1, CR4.PAE=3D1, and CR4.PSE.

Or to convolute things even further, if L0 is running L1 with shadowing pag=
ing,
and L1 is running L2 with shadow paging but doing something weird and using=
 PSE
paging, then it would be possible to end up with:

  vmcs12->guest_cr4:
     .pae =3D 0
     .pse =3D 1

  vmcs12->cr4_read_shadow:
     .pae =3D 0
     .pse =3D 0

  vmcs02->guest_cr4:
     .pae =3D 1
     .pse =3D 0

> Instead, userland sees the contents of Vmcs::GUEST_CR4.=C2=A0Shouldn't th=
is be the
> combination of GUEST_CR4, GUEST_CR4_MASK and CR4_READ_SHADOW, i.e. what L=
2
> actually sees as CR4 value?

Because KVM_{G,S}ET_SREGS (and all other uAPIs in that vein) are defined to=
 operate
on actual vCPU state, and having them do something different if the vCPU is=
 in guest
mode would confusing/odd, and nonsensical to differences between VMX and SV=
M.

SVM doesn't have per-bit CR0/CR4 controls, i.e. CR4 loads and stores need t=
o be
intercepted, and so having KVM_{G,S}ET_SREGS operate on CR4_READ_SHADOW for=
 VMX
would yield different ABI for VMX versus SVM.

Note, what L2 *sees* is not a combination of the above; what L2 sees is pur=
ely
CR4_READ_SHADOW.  The other fields are consulted only if L2 attempts to loa=
d CR4.

> If this is expected, can you please explain the reasoning behind this
> interface decision? For me, it does not make sense that writing back
> the same value we receive at exit time causes a change in what L2 sees
> for CR4.

I doubt there was ever a concious decision, rather it never came up and thu=
s the
code is the result of doing nothing when nested VMX support was added.

That said, KVM's behavior is probably the least awful choice.  The changelo=
g of
the proposed patch is wrong when it says:

  If the signal is meant to be delivered to the L0 VMM, and L0 updates CR4 =
for L1

because the update isn't for L1, it's for the active vCPU state, which is L=
2.

At first glance, skipping the vmcs02.CR4_READ_SHADOW seems to make sense, b=
ut it
would create a bizarre inconsistency as KVM_SET_SREGS would effectively ove=
rride
vmcs12->guest_cr4, but not vmcs12->cr4_read_shadow.  KVM doesn't know the i=
ntent
of userspace, i.e. KVM can't know if userspace wants to change just the eff=
ective
value for CR4, or if userspace wants to change the effective *and* observab=
le
value for CR4.

In your case, where writing CR4 is spurious, preserving the read shadow wor=
ks,
but if there were some use case where userspace actually wanted to change L=
2's
CR4, leaving the read shadow set to vmcs12 would be wrong.

The whole situation is rather nonsensical, because if userspace actually di=
d change
CR4, the changes would be lost on the next nested VM-Exit =3D> VM-Entry.  T=
hat could
be solved by writing to vmcs12, but that creates a headache of its own beca=
use then
userspace changes to L2 become visible to L1, without userspace explicitly =
requesting
that.

Unfortunately, simply disallowing state save/restore when L2 is active does=
n't
work either, because userspace needs to be able to save/restore state that =
_isn't_
context switched by hardware, i.e. isn't in the VMCS or VMCB.

In short, yes, it's goofy and annoying, but there's no great solution and t=
he
issue really does need to be solved/avoided in userspace

> Another question is: when we want to save the VM state during a
> savevm/loadvm cycle, we kick all vCPUs via a singal and save their
> state. If any vCPU runs in L2 at the time of the exit, we somehow need
> to let it continue to run until we get an exit with the L1 state. Is
> there a mechanism to help us here?=20

Hmm, no?  What is it you're trying to do, i.e. why are you doing save/load?=
  If
you really want to save/load _all_ state, the right thing to do is to also =
save
and load nested state.


