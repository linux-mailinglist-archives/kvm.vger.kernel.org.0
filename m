Return-Path: <kvm+bounces-72740-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YDK+HeSDqGmgvQAAu9opvQ
	(envelope-from <kvm+bounces-72740-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 20:11:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id A178D206F2A
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 20:11:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 9AD5830074F1
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 19:11:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7BD33DEAE1;
	Wed,  4 Mar 2026 19:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nCWwHQJU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560A83DA5A4
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 19:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772651479; cv=none; b=i0taABVrf+WPEzfQ1w0XRfaKJrHu0tWxW3mFGtHGGmw8O37RLfAYF5Cic4fCv/B01cx05LamBHrHYs4Yk6fk8E+VH/sT1ux//b3k8kFW9l/M+x6A4Fy263Npc5g9t9We4zrKTKwUpeOsS3CZ20OX8Xdcy5sEQ7UlRKPUSy5TUKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772651479; c=relaxed/simple;
	bh=dRdL2NEwVuHOVBc3bIuWCDPU1wF737rdFjwwockVEVo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bHf8UWEHtn46Hk2e+/IgiI0+mKB2NtoEuVsKbg2F/z3m8H9MgnOt3Jc3CSM8Z7ZdBv15RJJoCS4gVqzY/lx0TrnCK5SnAognOJEAOX9RPhiTB9qjbzn/9fusLv4/XDwCcQHZpsRQfJ7V7ux1Rh2WmHNP2dlZPkGei/qi5Q7LImI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nCWwHQJU; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2adef9d486bso63955225ad.2
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 11:11:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772651476; x=1773256276; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q9OtHjmtJSBf+k0JgdOZ0/RBQj404Jf3L0+cEK8R2TI=;
        b=nCWwHQJUjRE6jQLOq9GFTzmMyUzekx/2f9EN4E1w6/QGurn6/tE0uE08liEXT65LNs
         3YE8SlFy4S5E/vtP6TjetPtrqDe5Xsc8jQLDzjDbDL4+UkFIRsNzCl+m0oeczXDGi6EZ
         fzR3792m5HNL8Y2BnV5LECe9LVHqsNY6Yy0wt7Bw07cJm+9GORWRPTMtRNYFNExRf2ch
         9Q4Tbp4EOHvqiLDrSjXoCazUVT/ZTiD05UyydkC2IEJwPfDLjvgRARKL05V9XAFt+xJ8
         UxCBoc6SJ2koITEbngAK8jtokUYYxR+DIyIhtRd0yDVtF+krcMCMJ5GgirAN7sZraNrc
         xOXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772651476; x=1773256276;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=q9OtHjmtJSBf+k0JgdOZ0/RBQj404Jf3L0+cEK8R2TI=;
        b=W6Xz9nTasmbCQYSgtql2GspDzRNjmGPsyKKK6+28hchl9oZ+UnQF7VpB1+ZVMPFs65
         XMFQsuuC4dkD+DkYLXG2zRqS4zFj3+6gmvNvcIRrWCQulsPrcLXKnLwLkbEJ7FpetMHX
         +XX4cR8f2nnJ7IlffNoPQm35DY7cFKP+chHtEPH9AH2yJ4G+6oZELzL5hQ3TRq53M7Nn
         wIlWYM8ydG0YzC2IG7wa2zDl8TXEu9+hYbbOnRz1gEkFafk6wSMTWQ7r4APKOCUcQNvP
         xEVLjYcJ41+WnDZpbj8D/QrCGVfQ3PhebfLH7NhCJSVS84ckDlH3FJ7XHED2RoN5oEkK
         0Zlg==
X-Forwarded-Encrypted: i=1; AJvYcCUYLNlFUs3vgXy+kUjHr8P3FJdC88e05V+UND9zJZXccsP+Xpi4JfSoKwWnP7DpXx8yfTo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0HN70pRV+NQLjZvtj+gRFo1XQBLYC7+z8K9eVum4WknoSdE+W
	68hZF52u8QLmSntipRyXag93Yri0yhs10PoqZE6FDJ64pRb3Eirl/dkcgZ3I5ybvjaCwtjLF/c8
	RWEswUQ==
X-Received: from plim9.prod.google.com ([2002:a17:903:3b49:b0:2a0:e956:8aed])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e790:b0:2ae:6457:309a
 with SMTP id d9443c01a7336-2ae6aaf3d37mr28999085ad.37.1772651476339; Wed, 04
 Mar 2026 11:11:16 -0800 (PST)
Date: Wed, 4 Mar 2026 11:11:14 -0800
In-Reply-To: <CALMp9eR7gKWp8M2Q8Q7vA5hGx5bc12KCh1NZMK33A1dpiKNt+Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260224005500.1471972-1-jmattson@google.com> <20260224005500.1471972-9-jmattson@google.com>
 <aahn2ZfDAJTj-Afn@google.com> <CALMp9eR7gKWp8M2Q8Q7vA5hGx5bc12KCh1NZMK33A1dpiKNt+Q@mail.gmail.com>
Message-ID: <aaiD0k-BE4RZJPfv@google.com>
Subject: Re: [PATCH v5 08/10] KVM: x86: nSVM: Save/restore gPAT with KVM_{GET,SET}_NESTED_STATE
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A178D206F2A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72740-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[14];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Wed, Mar 04, 2026, Jim Mattson wrote:
> On Wed, Mar 4, 2026 at 9:11=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index 991ee4c03363..099bf8ac10ee 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -1848,7 +1848,7 @@ static int svm_get_nested_state(struct kvm_vcpu *=
vcpu,
> >         if (is_guest_mode(vcpu)) {
> >                 kvm_state.hdr.svm.vmcb_pa =3D svm->nested.vmcb12_gpa;
> >                 if (nested_npt_enabled(svm)) {
> > -                       kvm_state.hdr.svm.flags |=3D KVM_STATE_SVM_VALI=
D_GPAT;
> > +                       kvm_state->flags |=3D KVM_STATE_NESTED_GPAT_VAL=
ID;
> >                         kvm_state.hdr.svm.gpat =3D svm->vmcb->save.g_pa=
t;
> >                 }
> >                 kvm_state.size +=3D KVM_STATE_NESTED_SVM_VMCB_SIZE;
> > @@ -1914,7 +1914,8 @@ static int svm_set_nested_state(struct kvm_vcpu *=
vcpu,
> >
> >         if (kvm_state->flags & ~(KVM_STATE_NESTED_GUEST_MODE |
> >                                  KVM_STATE_NESTED_RUN_PENDING |
> > -                                KVM_STATE_NESTED_GIF_SET))
> > +                                KVM_STATE_NESTED_GIF_SET |
> > +                                KVM_STATE_NESTED_GPAT_VALID))
> >                 return -EINVAL;
>=20
> Unless I'm missing something, this breaks forward compatibility
> completely. An older kernel will refuse to accept a nested state blob
> with GPAT_VALID set.

Argh, so we've painted ourselves into an impossible situation by restrictin=
g the
set of valid flags.  I.e. VMX's omission of checks on unknown flags is a fe=
ature,
not a bug.

Chatted with Jim offlist, and he pointed out that KVM's standard way to dea=
l with
this is to make setting the flag opt-in, e.g. KVM_CAP_X86_TRIPLE_FAULT_EVEN=
T and
KVM_CAP_EXCEPTION_PAYLOAD.

As much as I want to retroactively change KVM's documentation to state doin=
g
KVM_SET_NESTED_STATE with data that didn't come from KVM_GET_NESTED_STATE i=
s
unsupported, that feels too restrictive and could really bite us in the fut=
ure.
And it doesn't help if there's already userspace that's putting garbage int=
o the
header.

So yeah, I don't see a better option than adding yet another capability.

Can you send a new version based on `kvm-x86 next`?  (give me ~hour to drop=
 these
and push).  This has snowballed beyond what I'm comfortable doing as fixup.=
 :-(

