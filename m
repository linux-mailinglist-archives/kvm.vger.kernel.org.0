Return-Path: <kvm+bounces-37189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 618ABA26889
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 01:27:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C253188646B
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 00:27:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F3E81BC3C;
	Tue,  4 Feb 2025 00:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SXGqsRl8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143EFC147
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 00:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738628826; cv=none; b=ciQmsY4KEJvV2gx5UJ61Nwf09urvenCnU2yPH+4FGNxOwSE41rck8VnWGCn6+qx7PGAIK+KBWdV9mM6PZgj+yEmsFf1p/U4yQfGvcd5pLr5OicWGwR5snf0eFXJIsyiHxi4Q94Ny0bBFAdbWZWrnezYeiOZYkwPhxch1JvbP7CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738628826; c=relaxed/simple;
	bh=IWgXWYJkPqw2Z1CpE5EEkhO9acbN8gpS038KseSXZ0I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dG/p4qaXV4NfyesjLjP/vcy51glA0KIbvbP0duCVuhq0+XZ+oze4Y1pA3DLhXTAKS//epu5eWQtlTpX45ZRC//pcwlIPaw7X+t50m508wnhpn9RqFmlDnaiiwSWIwje3TM7ePBj8EJJVP4y3gBvqWoQrZl9yVkgwJrcbQorpekU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SXGqsRl8; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f2a9f056a8so9604831a91.2
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2025 16:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738628824; x=1739233624; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=es4uFH1mdi2syRGIaz78R91wgaiNDTNWCmVjzV+dqhk=;
        b=SXGqsRl8eAlByRoaTL19P7dgqtHvHc4cb1pZIyQaCIO+zkK7Ep4vk+qI1Cx13o2xjk
         +EBE8MZqtO6GoGJqszOibuuK/OanfsZqG1Yj0AWtff/hxxW9PNzX90tCMYDEJDJ6uLg8
         CKeSyPDdQEtpdx9M/EVlVZ2u6j//spxx+BLjUEwEnFpdOe0IOMq/cCra9ia+DhEU0EMM
         ZGdvu++s40zrZS0WYEZXCkmSz+kSvkusID311DVBz0WbsiL2O6bfSBPLS6jawKnO4jrp
         G4q0nLDm8c7trMgEDYoO5esIcj6QqnMApSsOIH3FCAxwmREcrH77CyeDf2aybMbFVXW1
         uV8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738628824; x=1739233624;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=es4uFH1mdi2syRGIaz78R91wgaiNDTNWCmVjzV+dqhk=;
        b=t6MfOg0Hi9yvBoYEusvg05g/sTuQmZc2OLXpQzVFnyu+dIZVL5K/rC7V/ruvuYBm5r
         hv3GrdKKQOz0E/6omx/bYeoqfyN4pPiFgGlgRHgSGuo+piDsn5bNUiLLoIEi+sNNpAGg
         fKHHO5LIWY+rFVeUPAveJi6Xm2qymaHH43f/jp9YLQ2UxUh+MKWlfpx7pRAxnvKsIArz
         MoUPFi1OJAVMK3NpJPiXv1dY87pexWyAqE6yqzLPMqUv+DtcSWEpFwBrZR4vD4DqV67O
         AzqSr0JIgWzKZnIjv4UA89OpPX27g653L6KcCPV07r+XqrcqSZweZvmTlkjGd5ZzY7mP
         a4tg==
X-Gm-Message-State: AOJu0Ywha/kRETqk0ms7auKo0b+OqpNgBzQVLeuvPXsg0fjiNLPDu91T
	g/UMrVUEe1kVWiS1jYQSzoSjXUZhBWsupEI7m2juktkdPEVhUCtO7H78CVyZZwnHCuHCPATSsEV
	vWQ==
X-Google-Smtp-Source: AGHT+IF0i1a80D/prqc2zfk1FT4Lee5WNzvx26+t6wX/cXXG16jZxrhV19KWH4227JdtFStyqn54Wp8Qf8I=
X-Received: from pjbpv10.prod.google.com ([2002:a17:90b:3c8a:b0:2ee:2761:b67a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:270c:b0:2ee:db8a:2a01
 with SMTP id 98e67ed59e1d1-2f83ac8ad56mr33709069a91.30.1738628824249; Mon, 03
 Feb 2025 16:27:04 -0800 (PST)
Date: Mon, 3 Feb 2025 16:27:02 -0800
In-Reply-To: <0102090cd553e42709f43c30d2982b2c713e1a68.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201005048.657470-1-seanjc@google.com> <dbbfa3f1d16a3ab60523f5c21d857e0fcbc65e52.camel@intel.com>
 <Z6EoAAHn4d_FujZa@google.com> <0102090cd553e42709f43c30d2982b2c713e1a68.camel@intel.com>
Message-ID: <Z6Fe1nFWv52rDijx@google.com>
Subject: Re: [PATCH 0/2] x86/kvm: Force legacy PCI hole as WB under SNP/TDX
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "dionnaglaze@google.com" <dionnaglaze@google.com>, 
	Binbin Wu <binbin.wu@intel.com>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, 
	"vkuznets@redhat.com" <vkuznets@redhat.com>, "bp@alien8.de" <bp@alien8.de>, "jgross@suse.com" <jgross@suse.com>, 
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 03, 2025, Rick P Edgecombe wrote:
> On Mon, 2025-02-03 at 12:33 -0800, Sean Christopherson wrote:
> > > Since there is no upstream KVM TDX support yet, why isn't it an optio=
n to
> > > still
> > > revert the EDKII commit too? It was a relatively recent change.
> >=20
> > I'm fine with that route too, but it too is a band-aid.=C2=A0 Relying o=
n the
> > *untrusted*
> > hypervisor to essentially communicate memory maps is not a winning stra=
tegy.=20
> >=20
> > > To me it seems that the normal KVM MTRR support is not ideal, because=
 it is
> > > still lying about what it is doing. For example, in the past there wa=
s an
> > > attempt to use UC to prevent speculative execution accesses to sensit=
ive
> > > data.
> > > The KVM MTRR support only happens to work with existing guests, but n=
ot all
> > > possible MTRR usages.
> > >=20
> > > Since diverging from the architecture creates loose ends like that, w=
e could
> > > instead define some other way for EDKII to communicate the ranges to =
the
> > > kernel.
> > > Like some simple KVM PV MSRs that are for communication only, and not
> >=20
> > Hard "no" to any PV solution.=C2=A0 This isn't KVM specific, and as abo=
ve, bouncing
> > through the hypervisor to communicate information within the guest is a=
sinine,
> > especially for CoCo VMs.
>=20
> Hmm, right.
>=20
> So the other options could be:
>=20
> 1. Some TDX module feature to hold the ranges:
>  - Con: Not shared with AMD
>=20
> 2. Re-use MTRRs for the communication, revert changes in guest and edk2:

Thinking more about how EDK2 is consumed downstream, I think reverting the =
EDK2
changes is necessary regardless of what happens in the kernel.  Or at the l=
east,
somehow communicate to EDK2 users that ingesting those changes is a bad ide=
a
unless the kernel has also been updated.

AFAIK, Bring Your Own Firmware[*] isn't widely adopted, which means that th=
e CSP
is shipping the firmware.  And shipping OVMF/EDK2 with the "ignores MTRRs" =
code
will cause problems for guests without commit 8e690b817e38 ("x86/kvm: Overr=
ide
default caching mode for SEV-SNP and TDX").  Since the host doesn't control=
 the
guest kernel, there's no way to know if deploying those EDK2 changes is saf=
e.
=20
[*] https://kvm-forum.qemu.org/2024/BYOF_-_KVM_Forum_2024_iWTioIP.pdf

>  - Con: Creating more half support, when it's technically not required
>  - Con: Still bouncing through the hypervisor

I assume by "Re-use MTRRs for the communication" you also mean updating the=
 guest
to address the "everything is UC!" flaw, otherwise another con is:

   - Con: Doesn't address the performance issue with TDX guests "using" UC
          memory by default (unless there's yet more enabled).

Presumably that can be accomplished by simply skipping the CR0.CD toggling,=
 and
doing MTRR stuff as nonrmal?

>  - Pro: Design and code is clear
>
> 3. Create some new architectural definition, like a bit that means "MTRRs=
 don't
> actually work:
>  - Con: Takes a long time, need to get agreement
>  - Con: Still bouncing through the hypervisor

Not for KVM guests.  As I laid out in my bug report, it's safe to assume MT=
RRs
don't actually affect the memory type when running under KVM.

FWIW, PAT doesn't "work" on most KVM Intel setups either, because of misgui=
ded
KVM code that resulted in "Ignore Guest PAT" being set in all EPTEs for the
overwhelming majority of guests.  That's not desirable long term because it
prevents the guest from using WC (via PAT) in situations where doing so is =
needed
for performance and/or correctness.

>  - Pro: More pure solution

MTRRs "not working" is a red herring.  The problem isn't that MTRRs don't w=
ork,
it's that the kernel is (somewhat unknowingly) using MTRRs as a crutch to g=
et the
desired memtype for devices.  E.g. for emulated MMIO, MTRRs _can't_ be virt=
ualized,
because there's never a valid mapping, i.e. there is no physical memory and=
 thus
no memtype.  In other words, under KVM guests (and possibly other hyperviso=
rs),
MTRRs end up being nothing more than a communication channel between guest =
firmware
and the kernel.

The gap for CoCo VMs is that using MTRRs is undesirable because they are co=
ntrolled
by the untrusted host.  But that's largely a future problem, unless someone=
 has a
clever way to fix the kernel mess.

> 4. Do this series:
>  - Pro: Looks ok to me
>  - Cons: As explained in the patches, it's a bit hacky.
>  - Cons: Could there be more cases than the legacy PCI hole?
>=20
> I would kind of like to see something like 3, but 2 or 4 seem the only fe=
asible
> ones if we want to resolve this soon.

