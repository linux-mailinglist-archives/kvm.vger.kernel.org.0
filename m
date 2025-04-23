Return-Path: <kvm+bounces-43976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CADB1A9944B
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 18:11:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A6069C207B
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 16:03:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D28B29B78D;
	Wed, 23 Apr 2025 15:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tcgbARPV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39959283C94
	for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 15:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745423675; cv=none; b=BMpRuc8tfosG/eWQR/UNWjqwrQL4/e1uZ0s5GQss6NCh4QY8YQBAZaPvO0/7ZkPiympci4NS+Mwm9J5hQQ7/9oOlPRxJ7Ug0Xtweei9KntZH5FHZGZ35JrPkk9t3MkNxpDdlQCcKlWkg/eMt25t8mawdG4blio2PN3SguKMCeJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745423675; c=relaxed/simple;
	bh=f+VP0NPD5jNHuEDDOfpUYceTIOhV/Rt5Z0A8AQ2izAo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IABPOaqaDhgyaxLL+sLSfEdTA573Kw5b8BokjdUHWFfDezp7VK6e/oNVjR7inrC84bSDqtSPNUknaAkjMC2r/bKruqNi+YkOszNtjZyOo63ghpx7BRtO+tFMs5HUS2/bqXMR8TcZNzh/0ONB3vu1xacXL++2Dg7dErwpcUKjycc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tcgbARPV; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-736c0306242so7870197b3a.1
        for <kvm@vger.kernel.org>; Wed, 23 Apr 2025 08:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745423673; x=1746028473; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+mc9z1PuhiHedW9jAFmuOWVP2itkaushPzad2KkMGss=;
        b=tcgbARPV4iIx1laSSqByM2aBqqgD7tGIFwsCtV5uoSThPqy/beP5J98Lc7exPc9bZR
         eS2YIYL4VaIPZiROGcm9X46QR7jqLu22MbBF9Av34WZGoN+rjxd3qGi5BXYG6dQ1+ida
         YcJ9ZPYfyj+sE0fEtjutAiitkw4J+BBlFS524bQ8W+6QmL6SY3/nep944rKHIehkb+M4
         YQjXpqZpxVWccTwKkRTGxIqI7TtlJPpLxkHiJg71gF40eZRZTlMnfgC1nYPXKCAspvpB
         FqG0DPPRaWsq/GdAhUGGxYHc5SENVK+KZB7xekra+afp0hx/O0t2TMPM12DRQSACQ1B+
         FzEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745423673; x=1746028473;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+mc9z1PuhiHedW9jAFmuOWVP2itkaushPzad2KkMGss=;
        b=L031ujr7x8ew4uLCwZm3U8YKDZdH2UL9TpISElglbUSlTKpwdzM4lEUCQs7gxZNW4h
         SMlN+CooaKka72ObUzDTBbk74BlIJVsJA3xilLJuxwCiSMWR53AAcviROWtftEe/HZIU
         k7+XwC99Eot8MEAz2V259ZCU5hfk++jUhByIQ2FYLTaAhTFIQCvZZ1PpaiV1tfmvtNVQ
         w231L1kX1Sj/z1B3yQIS3jpQDDb/rMWK9D9wVzSZTBpCOtkgMY6ONRwMM/xSUJHzvYKt
         zdioJ2SDDkxQwzEcGyPXudeKE9miwDHqbFEYlUKX9k/PHnvzBbymLryRNkUh4IRtN+o+
         GM+g==
X-Forwarded-Encrypted: i=1; AJvYcCWJ+AhdmFWjKuIsyqyUREW9LHwYbfKlMapCVV0DYsOE9eYvjLBIq32fDb89BrLdctDs1+A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWrY1liKmS8vvXLqtW3JeLXUR4+ORGUOW4bhgECVczbpwyb9BJ
	nc8j4ATJOUJ/Ne/e+KVRKG+JmSjaL9DvIQCmiLnXmo/HT6jrlEVQEuJvqUHZLVlwT4q19ToZlq+
	tww==
X-Google-Smtp-Source: AGHT+IHgTggejAFEgcZTd/pUvQPX6XzW17AT6knE+s0SYYVGMUts32i/fFAkytyUefVrtBWGMlB9ZWVuG7o=
X-Received: from pfbem8.prod.google.com ([2002:a05:6a00:3748:b0:739:9e9:feea])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:a81:b0:736:5545:5b84
 with SMTP id d2e1a72fcca58-73dc14536b9mr27349625b3a.3.1745423673477; Wed, 23
 Apr 2025 08:54:33 -0700 (PDT)
Date: Wed, 23 Apr 2025 08:54:31 -0700
In-Reply-To: <CABQX2QNDmXizUDP_sckvfaM9OBTxHSr0ESgJ_=Z_5RiODfOGsg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250422161304.579394-1-zack.rusin@broadcom.com>
 <20250422161304.579394-5-zack.rusin@broadcom.com> <a803c925-b682-490f-8cd9-ca8d4cc599aa@zytor.com>
 <CABQX2QMznYZiVm40Ligq+pFKmEkVpScW+zcKYbPpGgm0=S2Xkg@mail.gmail.com>
 <aAjrOgsooR4RYIJr@google.com> <CABQX2QNDmXizUDP_sckvfaM9OBTxHSr0ESgJ_=Z_5RiODfOGsg@mail.gmail.com>
Message-ID: <aAkNN029DIxYay-j@google.com>
Subject: Re: [PATCH v2 4/5] KVM: x86: Add support for legacy VMware backdoors
 in nested setups
From: Sean Christopherson <seanjc@google.com>
To: Zack Rusin <zack.rusin@broadcom.com>
Cc: Xin Li <xin@zytor.com>, linux-kernel@vger.kernel.org, 
	Doug Covelli <doug.covelli@broadcom.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 23, 2025, Zack Rusin wrote:
> On Wed, Apr 23, 2025 at 9:31=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > Heh, KVM_CAP_EXIT_ON_EMULATION_FAILURE is the odd one out.  Even if tha=
t weren't
> > the case, this is one of the situations where diverging from the existi=
ng code is
> > desirable, because the existing code is garbage.
> >
> > arch/x86/kvm/x86.c:             if (cap->args[0] & ~kvm_caps.supported_=
quirks)
> > arch/x86/kvm/x86.c:             if (cap->args[0] & ~KVM_X2APIC_API_VALI=
D_FLAGS)
> > arch/x86/kvm/x86.c:             if (cap->args[0] & ~kvm_get_allowed_dis=
able_exits())
> > arch/x86/kvm/x86.c:                 (cap->args[0] & ~KVM_X86_DISABLE_EX=
ITS_PAUSE))
> > arch/x86/kvm/x86.c:             if (cap->args[0] & ~KVM_MSR_EXIT_REASON=
_VALID_MASK)
> > arch/x86/kvm/x86.c:             if (cap->args[0] & ~KVM_BUS_LOCK_DETECT=
ION_VALID_MODE)
> > arch/x86/kvm/x86.c:             if (cap->args[0] & ~KVM_EXIT_HYPERCALL_=
VALID_MASK) {
> > arch/x86/kvm/x86.c:             if (cap->args[0] & ~1)
> > arch/x86/kvm/x86.c:             if (!enable_pmu || (cap->args[0] & ~KVM=
_CAP_PMU_VALID_MASK))
> > arch/x86/kvm/x86.c:             if ((u32)cap->args[0] & ~KVM_X86_NOTIFY=
_VMEXIT_VALID_BITS)
> > virt/kvm/kvm_main.c:            if (cap->flags || (cap->args[0] & ~allo=
wed_options))
>=20
> That's because none of those other options are boolean, right? I
> assumed that the options that have valid masks use defines but
> booleans use ~1 because (val & ~1) makes it obvious to the reader that
> the option is in fact a boolean in a way that (val &
> ~KVM_SOME_VALID_BITS) can not.

The entire reason when KVM checks and enforces cap->args[0] is so that KVM =
can
expand the capability's functionality in the future.  Whether or not a capa=
bility
is *currently* a boolean, i.e. only has one supported flag, is completely i=
rrelevant.

KVM has burned itself many times over by not performing checks, e.g. is how=
 we
ended up with things like KVM_CAP_DISABLE_QUIRKS2.

> > > Or are you saying that since I'm already there you'd like to see a
> > > completely separate patch that defines some kind of IS_ZERO_OR_ONE
> > > macro for KVM, use it for KVM_CAP_EXIT_ON_EMULATION_FAILURE and, once
> > > that lands then I can make use of it in this series?
> >
> > Xin is suggesting that you add a macro in arch/x86/include/uapi/asm/kvm=
.h to
> > #define which bits are valid and which bits are reserved.
> >
> > At a glance, you can kill multiple birds with one stone.  Rather than a=
dd three
> > separate capabilities, add one capability and then a variety of flags. =
 E.g.
> >
> > #define KVM_X86_VMWARE_HYPERCALL        _BITUL(0)
> > #define KVM_X86_VMWARE_BACKDOOR         _BITUL(1)
> > #define KVM_X86_VMWARE_NESTED_BACKDOOR  _BITUL(2)
> > #define KVM_X86_VMWARE_VALID_FLAGS      (KVM_X86_VMWARE_HYPERCALL |
> >                                          KVM_X86_VMWARE_BACKDOOR |
> >                                          KVM_X86_VMWARE_NESTED_BACKDOOR=
)
> >
> >         case KVM_CAP_X86_VMWARE_EMULATION:
> >                 r =3D -EINVAL;
> >                 if (cap->args[0] & ~KVM_X86_VMWARE_VALID_FLAGS)
> >                         break;
> >
> >                 mutex_lock(&kvm->lock);
> >                 if (!kvm->created_vcpus) {
> >                         if (cap->args[0] & KVM_X86_VMWARE_HYPERCALL)
> >                                 kvm->arch.vmware.hypercall_enabled =3D =
true;
> >                         if (cap->args[0] & KVM_X86_VMWARE_BACKDOOR)
> >                                 kvm->arch.vmware.backdoor_enabled;
> >                         if (cap->args[0] & KVM_X86_VMWARE_NESTED_BACKDO=
OR)
> >                                 kvm->arch.vmware.nested_backdoor_enable=
d =3D true;
> >                         r =3D 0;
> >                 }
> >                 mutex_unlock(&kvm->lock);
> >                 break;
> >
> > That approach wouldn't let userspace disable previously enabled VMware =
capabilities,
> > but unless there's a use case for doing so, that should be a non-issue.
>=20
> I'd say that if we desperately want to use a single cap for all of
> these then I'd probably prefer a different approach because this would
> make vmware_backdoor_enabled behavior really wacky.

How so?  If kvm.enable_vmware_backdoor is true, then the backdoor is enable=
d
for all VMs, else it's disabled by default but can be enabled on a per-VM b=
asis
by the new capability.

> It's the one that currently can only be set via kernel boot flags, so hav=
ing
> systems where the boot flag is on and disabling it on a per-vm basis make=
s
> sense and breaks with this.

We could go this route, e.g. KVM does something similar for PMU virtualizat=
ion.
But the key difference is that enable_pmu is enabled by default, whereas
enable_vmware_backdoor is disabled by default.  I.e. it makes far more sens=
e for
the capability to let userspace opt-in, as opposed to opt-out.

> I'd probably still write the code to be able to disable/enable all of the=
m
> because it makes sense for vmware_backdoor_enabled.

Again, that's not KVM's default, and it will never be KVM's default.  Unles=
s there
is a concrete use case for disabling features after *userspace* has opted-i=
n,
just make them one-way 0=3D>1 transitions so as to keep KVM's implementatio=
n as
simple as possible.

