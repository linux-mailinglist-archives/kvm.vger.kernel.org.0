Return-Path: <kvm+bounces-16775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B27718BD8F9
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 03:35:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 670AE28399C
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 01:35:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91C3A4A15;
	Tue,  7 May 2024 01:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KPY8ssQ8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7641876
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 01:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715045697; cv=none; b=kQdSuAv2MSI2WJy0Ybl89wweIp+wkNC9RtnKvNo61i+tbbH0CtAR0Q5efOIfSohGxM4ygB1h9oLjqomGxUoDLm85fnZ6S2atmqgHWvvccIYHhOo6bnvXqA/cNTbEio5vo9aIMzxnR3+oE6INnxchgnyxZqr3sHVfmG+g3x7emfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715045697; c=relaxed/simple;
	bh=nflotAw23OF8DzsvPikj7Zp6lbojRMt3XmZ/DkGkNJg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LGF2JPbtzmioNhpRcjP6ZJc6Yh5xkzVq3SxcNSt+iSWanZjczAeue/kzNlQunxFhggmQNm7bCgm2+5lWUnaoOL4brypd0k+qS4/TBFghDb+5zb3CesN98CdGuApEq+nYwKMh/XesMs7LepATOdNzHJg0acjulbARRLKa+Fc5ofo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KPY8ssQ8; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61beaa137acso47988857b3.1
        for <kvm@vger.kernel.org>; Mon, 06 May 2024 18:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715045695; x=1715650495; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VvGkjH9SPvsjHvBH/WrCy4dSbt+wcqHhkwU5LfzuS0Q=;
        b=KPY8ssQ8w5cp4ybcGORn6eJGseLb4POUHAkDqjpmZqIIXnqhAnNGrHx6PN9oGcz7+Q
         rVwY8Gl++OY8cq395XSlzSbqXOS6O4EhWqncMtQqhF5seyBLYjzDOo5N1Y2BqiVEvSu4
         qVx+3jMDNpigUE69jZnSHy8TiJjnxJiVisZ5tmivWC/r7azKt0dgQeW0oPKLlzlLizgN
         2/qw5AowBJo+LyS53mVN0TBf1G+I4syo5pBmifiQrcT/BlHORI22bzEXv+9VOR3UY9um
         2M1NEcmNzByKVm3sTwRQfahuGpEncHwtls96j36waw0fMJ0ZrwKZ5Qcpk4zTJXN6a9JW
         9SXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715045695; x=1715650495;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VvGkjH9SPvsjHvBH/WrCy4dSbt+wcqHhkwU5LfzuS0Q=;
        b=etSjUcj7BCrmbxS88tbOlrpRLFjRaPGBjYS8aHPEfs5Q1bYmO88n9bDgRaXfuCe2Lw
         NKExgoM+DAGX9q3N+wiaieNQnI6qpNjoRKJywUiKLGoxy/qa1vmPElHnFZQtUV2aiX0l
         2ffsIixTyVfP2J9uLjeeQuYFyJBzgZt5K6F4nfImsiblUbxEPspFCaVIQIVfOmhtbh7P
         Xm0x2eKQ1I5oGhbSoJdLxfAdxTBqrBvucOEs1z/pF6/uYuwwtjqnJLq+ZqWt8qWrq4x0
         cJJPi6VSTlX7YF3lfrq7hZAztQLcH6QiS/aEPWhZmPptZhgVkolyKPINi72VVET/yDYN
         qoAQ==
X-Forwarded-Encrypted: i=1; AJvYcCUA+baSeYI2s6VjLpCoAKg2Pb4ptR6mrGT5XeBQ8ShhJwr9JwJmYDgoalIzjV5Sv+BjL1aexWxiM8Z7BxcAOylfIzWo
X-Gm-Message-State: AOJu0YyZfIDVaRenGaQ6R79foKxtLOKmE58SfHlhm5PEn6at1M4ofgBC
	m6X4/qjbQz7kxoiumVjKXN2cGYCCTBF8HQg7Z23hKRaVK2PzdI8jRPGImU+lsudYIKoC7KUQmSW
	Cnw==
X-Google-Smtp-Source: AGHT+IEuRRNgC6bmH2Ym7Hdh0kKkoS5NCGgVEW4kTiZkpma4/j2gQOn7KVKqRXFpAim0ldEq7Pn05YmuCaI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1893:b0:de4:67d9:a2c6 with SMTP id
 cj19-20020a056902189300b00de467d9a2c6mr1291648ybb.2.1715045695256; Mon, 06
 May 2024 18:34:55 -0700 (PDT)
Date: Mon, 6 May 2024 18:34:53 -0700
In-Reply-To: <20240506.ohwe7eewu0oB@digikod.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240503131910.307630-1-mic@digikod.net> <20240503131910.307630-4-mic@digikod.net>
 <ZjTuqV-AxQQRWwUW@google.com> <20240506.ohwe7eewu0oB@digikod.net>
Message-ID: <ZjmFPZd5q_hEBdBz@google.com>
Subject: Re: [RFC PATCH v3 3/5] KVM: x86: Add notifications for Heki policy
 configuration and violation
From: Sean Christopherson <seanjc@google.com>
To: "=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?=" <mic@digikod.net>
Cc: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, Alexander Graf <graf@amazon.com>, 
	Angelina Vu <angelinavu@linux.microsoft.com>, 
	Anna Trikalinou <atrikalinou@microsoft.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Forrest Yuan Yu <yuanyu@google.com>, James Gowans <jgowans@amazon.com>, 
	James Morris <jamorris@linux.microsoft.com>, John Andersen <john.s.andersen@intel.com>, 
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>, Marian Rotariu <marian.c.rotariu@gmail.com>, 
	"Mihai =?utf-8?B?RG9uyJt1?=" <mdontu@bitdefender.com>, 
	"=?utf-8?B?TmljdciZb3IgQ8OuyJt1?=" <nicu.citu@icloud.com>, Thara Gopinath <tgopinath@microsoft.com>, 
	Trilok Soni <quic_tsoni@quicinc.com>, Wei Liu <wei.liu@kernel.org>, 
	Will Deacon <will@kernel.org>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	"=?utf-8?Q?=C8=98tefan_=C8=98icleru?=" <ssicleru@bitdefender.com>, dev@lists.cloudhypervisor.org, 
	kvm@vger.kernel.org, linux-hardening@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, qemu-devel@nongnu.org, 
	virtualization@lists.linux-foundation.org, x86@kernel.org, 
	xen-devel@lists.xenproject.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 06, 2024, Micka=C3=ABl Sala=C3=BCn wrote:
> On Fri, May 03, 2024 at 07:03:21AM GMT, Sean Christopherson wrote:
> > > ---
> > >=20
> > > Changes since v1:
> > > * New patch. Making user space aware of Heki properties was requested=
 by
> > >   Sean Christopherson.
> >=20
> > No, I suggested having userspace _control_ the pinning[*], not merely b=
e notified
> > of pinning.
> >=20
> >  : IMO, manipulation of protections, both for memory (this patch) and C=
PU state
> >  : (control registers in the next patch) should come from userspace.  I=
 have no
> >  : objection to KVM providing plumbing if necessary, but I think usersp=
ace needs to
> >  : to have full control over the actual state.
> >  :=20
> >  : One of the things that caused Intel's control register pinning serie=
s to stall
> >  : out was how to handle edge cases like kexec() and reboot.  Deferring=
 to userspace
> >  : means the kernel doesn't need to define policy, e.g. when to unprote=
ct memory,
> >  : and avoids questions like "should userspace be able to overwrite pin=
ned control
> >  : registers".
> >  :=20
> >  : And like the confidential VM use case, keeping userspace in the loop=
 is a big
> >  : beneifit, e.g. the guest can't circumvent protections by coercing us=
erspace into
> >  : writing to protected memory.
> >=20
> > I stand by that suggestion, because I don't see a sane way to handle th=
ings like
> > kexec() and reboot without having a _much_ more sophisticated policy th=
an would
> > ever be acceptable in KVM.
> >=20
> > I think that can be done without KVM having any awareness of CR pinning=
 whatsoever.
> > E.g. userspace just needs to ability to intercept CR writes and inject =
#GPs.  Off
> > the cuff, I suspect the uAPI could look very similar to MSR filtering. =
 E.g. I bet
> > userspace could enforce MSR pinning without any new KVM uAPI at all.
> >=20
> > [*] https://lore.kernel.org/all/ZFUyhPuhtMbYdJ76@google.com
>=20
> OK, I had concern about the control not directly coming from the guest,
> especially in the case of pKVM and confidential computing, but I get you

Hardware-based CoCo is completely out of scope, because KVM has zero visibi=
lity
into the guest (well, SNP technically allows trapping CR0/CR4, but KVM real=
ly
shouldn't intercept CR0/CR4 for SNP guests).

And more importantly, _KVM_ doesn't define any policies for CoCo VMs.  KVM =
might
help enforce policies that are defined by hardware/firmware, but KVM doesn'=
t
define any of its own.

If pKVM on x86 comes along, then KVM will likely get in the business of def=
ining
policy, but until that happens, KVM needs to stay firmly out of the picture=
.

> point.  It should indeed be quite similar to the MSR filtering on the
> userspace side, except that we need another interface for the guest to
> request such change (i.e. self-protection).
>=20
> Would it be OK to keep this new KVM_HC_LOCK_CR_UPDATE hypercall but
> forward the request to userspace with a VM exit instead?  That would
> also enable userspace to get the request and directly configure the CR
> pinning with the same VM exit.

No?  Maybe?  I strongly suspect that full support will need a richer set of=
 APIs
than a single hypercall.  E.g. to handle kexec(), suspend+resume, emulated =
SMM,
and so on and so forth.  And that's just for CR pinning.

And hypercalls are hampered by the fact that VMCALL/VMMCALL don't allow for
delegation or restriction, i.e. there's no way for the guest to communicate=
 to
the hypervisor that a less privileged component is allowed to perform some =
action,
nor is there a way for the guest to say some chunk of CPL0 code *isn't* all=
owed
to request transition.  Delegation and restriction all has to be done out-o=
f-band.

It'd probably be more annoying to setup initially, but I think a synthetic =
device
with an MMIO-based interface would be more powerful and flexible in the lon=
g run.
Then userspace can evolve without needing to wait for KVM to catch up.

Actually, potential bad/crazy idea.  Why does the _host_ need to define pol=
icy?
Linux already knows what assets it wants to (un)protect and when.  What's m=
issing
is a way for the guest kernel to effectively deprivilege and re-authenticat=
e
itself as needed.  We've been tossing around the idea of paired VMs+vCPUs t=
o
support VTLs and SEV's VMPLs, what if we usurped/piggybacked those ideas, w=
ith a
bit of pKVM mixed in?

Borrowing VTL terminology, where VTL0 is the least privileged, userspace la=
unches
the VM at VTL0.  At some point, the guest triggers the deprivileging sequen=
ce and
userspace creates VTL1.  Userpace also provides a way for VTL0 restrict acc=
ess to
its memory, e.g. to effectively make the page tables for the kernel's direc=
t map
writable only from VTL1, to make kernel text RO (or XO), etc.  And VTL0 cou=
ld then
also completely remove its access to code that changes CR0/CR4.

It would obviously require a _lot_ more upfront work, e.g. to isolate the k=
ernel
text that modifies CR0/CR4 so that it can be removed from VTL0, but that sh=
ould
be doable with annotations, e.g. tag relevant functions with __magic or wha=
tever,
throw them in a dedicated section, and then free/protect the section(s) at =
the
appropriate time.

KVM would likely need to provide the ability to switch VTLs (or whatever th=
ey get
called), and host userspace would need to provide a decent amount of the ba=
ckend
mechanisms and "core" policies, e.g. to manage VTL0 memory, teardown (turn =
off?)
VTL1 on kexec(), etc.  But everything else could live in the guest kernel i=
tself.
E.g. to have CR pinning play nice with kexec(), toss the relevant kexec() c=
ode into
VTL1.  That way VTL1 can verify the kexec() target and tear itself down bef=
ore
jumping into the new kernel.=20

This is very off the cuff and have-wavy, e.g. I don't have much of an idea =
what
it would take to harden kernel text patching, but keeping the policy in the=
 guest
seems like it'd make everything more tractable than trying to define an ABI
between Linux and a VMM that is rich and flexible enough to support all the
fancy things Linux does (and will do in the future).

Am I crazy?  Or maybe reinventing whatever that McAfee thing was that led t=
o
Intel implementing EPTP switching?

