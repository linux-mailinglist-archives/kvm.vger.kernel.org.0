Return-Path: <kvm+bounces-72743-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EI5sO0yOqGmzvgAAu9opvQ
	(envelope-from <kvm+bounces-72743-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 20:55:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C4B8207478
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 20:55:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 899E0304706C
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 19:55:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0C8F3DFC66;
	Wed,  4 Mar 2026 19:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RJxCfF9q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24D337189D
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 19:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772654148; cv=none; b=Ji7qD+F+oK5KTAJy/9untSwaPewVj1STAz5RgQQKAkr5bDqspu5p8lXaLbExlTTHoZjJQHbJO5inBNsFbICzza4XzTJZMMS2NUddM5obUASNhlcyRxmebYJhce4/IXsS4DtJSqKuKXzxIxn4zOx+1GRIPzgYutkOxAwMmqXG8E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772654148; c=relaxed/simple;
	bh=Gd9tyCTj2s7vSc2TwkwqjW1IW4A5Tzi7AvehUe9JJDA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=q7sFf+kOOsTB2oXU5FAKLWMy8s/AGrIixQdmjNASJ+yMUsTamyvZjswrWH3nivOOB/3vdk1Hzfnm511fwXHoECE0s1tKLQvZgW09pDqXvk6zw3dcHp//4h53DRjNMHreaXiPowTGUlHxO5wIJwDoqRLrVIZH8NFx+tBwo8PO7Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RJxCfF9q; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ae502a1dd9so47719085ad.3
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 11:55:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772654146; x=1773258946; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ld1CTX+5EMV5KR4I3tiAgS8iHnH1Pp/Xz4A9bG3MbFM=;
        b=RJxCfF9qsAQPzUCpGjIuzHiL9qG5QfNNoD4J5mSsFe9T2KM+wMnPHVZZx3H3IjLC7i
         LjAKZMtho8Fn6czQ0i8WvnUtfwekRa8y83tAuhoPtFxYC/doRU89BMJSmrlpJ1JvLYLB
         CaxS960wx4hbS7voKfUVfCUXQXGDemUmdE3hGHRG1acFIkwHT2oefj5iWwaiq9Rgp1L6
         Q8K9ybR5JcswIUakfprsbkJKoFRZ8EQvbw/lpHPG01j7qJy+P/+Yfw9KtqTS8U7VMuzn
         uOByhpmKi1tdGosg/te9Kx/coiW4+dX4l299N4JfuM7/f05zNu/k8mxi6kye950gBXLP
         Eyqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772654146; x=1773258946;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ld1CTX+5EMV5KR4I3tiAgS8iHnH1Pp/Xz4A9bG3MbFM=;
        b=PFvnfWxmO8QAuG78dV16MqT1tjo+rZw5XLvp4Seh2UxEP5bJcMkKgtpYM66boJ9aYN
         VLixz/vzc4ZuAgsMxDwOt8moXoBwc8MxrhV6hwNyyylbRiwwvf9Za6LD/VpzdPXnjmyC
         hD4KdlzNEXlpbQ3x5dO2kXySPbgmYV0PWMIE7rqdyWOPpD2mSgzTgQHfu6qEJoSZhAZJ
         kWOzuefySd4WaS/Xr6lS3/KgfTPC84PqvakTkzp1iPupKx/nLQMfV38iFo4IuUQkN/kR
         +Go3N8z0UxAhYRjsc0vWcSRGnI/vgGL4PCkgZcz1XwS+VvBMrFIrVVzBaLRNTFdQUARN
         PToA==
X-Forwarded-Encrypted: i=1; AJvYcCVCnpG/JGECDDaNGeEq7+ZZpvep5D7wGwgOUtC7HTkq2h7Xtqq7fCi+3o9xvEI7mm1O+OU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxH2mQVUyJo282QbQsFYeGpWejqBxVtsyk98DQd5A4A4ahPKeRQ
	8R4sHQcH/An3FIFV/wcHCPtsLewhhXHLcV8JJFbKR8rXfI44TOz4kQrC7P9wLcj/eWLShl+JpD1
	s1zVvrg==
X-Received: from plot6.prod.google.com ([2002:a17:902:8c86:b0:2aa:d604:fb13])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f645:b0:2ae:4445:f397
 with SMTP id d9443c01a7336-2ae6a9fd7ebmr31834575ad.16.1772654146212; Wed, 04
 Mar 2026 11:55:46 -0800 (PST)
Date: Wed, 4 Mar 2026 11:55:44 -0800
In-Reply-To: <CAO9r8zP+tdUtDwxzDVKbtCk7Ui5y=Zw_aZ+ptL4-H6-R5vXWTQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260224005500.1471972-1-jmattson@google.com> <20260224005500.1471972-9-jmattson@google.com>
 <aahn2ZfDAJTj-Afn@google.com> <CALMp9eR7gKWp8M2Q8Q7vA5hGx5bc12KCh1NZMK33A1dpiKNt+Q@mail.gmail.com>
 <aaiD0k-BE4RZJPfv@google.com> <CAO9r8zP+tdUtDwxzDVKbtCk7Ui5y=Zw_aZ+ptL4-H6-R5vXWTQ@mail.gmail.com>
Message-ID: <aaiOQKHoSrpPNR9b@google.com>
Subject: Re: [PATCH v5 08/10] KVM: x86: nSVM: Save/restore gPAT with KVM_{GET,SET}_NESTED_STATE
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9C4B8207478
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72743-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[14];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Wed, Mar 04, 2026, Yosry Ahmed wrote:
> On Wed, Mar 4, 2026 at 11:11=E2=80=AFAM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Wed, Mar 04, 2026, Jim Mattson wrote:
> > > On Wed, Mar 4, 2026 at 9:11=E2=80=AFAM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > > > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > > > index 991ee4c03363..099bf8ac10ee 100644
> > > > --- a/arch/x86/kvm/svm/nested.c
> > > > +++ b/arch/x86/kvm/svm/nested.c
> > > > @@ -1848,7 +1848,7 @@ static int svm_get_nested_state(struct kvm_vc=
pu *vcpu,
> > > >         if (is_guest_mode(vcpu)) {
> > > >                 kvm_state.hdr.svm.vmcb_pa =3D svm->nested.vmcb12_gp=
a;
> > > >                 if (nested_npt_enabled(svm)) {
> > > > -                       kvm_state.hdr.svm.flags |=3D KVM_STATE_SVM_=
VALID_GPAT;
> > > > +                       kvm_state->flags |=3D KVM_STATE_NESTED_GPAT=
_VALID;
> > > >                         kvm_state.hdr.svm.gpat =3D svm->vmcb->save.=
g_pat;
> > > >                 }
> > > >                 kvm_state.size +=3D KVM_STATE_NESTED_SVM_VMCB_SIZE;
> > > > @@ -1914,7 +1914,8 @@ static int svm_set_nested_state(struct kvm_vc=
pu *vcpu,
> > > >
> > > >         if (kvm_state->flags & ~(KVM_STATE_NESTED_GUEST_MODE |
> > > >                                  KVM_STATE_NESTED_RUN_PENDING |
> > > > -                                KVM_STATE_NESTED_GIF_SET))
> > > > +                                KVM_STATE_NESTED_GIF_SET |
> > > > +                                KVM_STATE_NESTED_GPAT_VALID))
> > > >                 return -EINVAL;
> > >
> > > Unless I'm missing something, this breaks forward compatibility
> > > completely. An older kernel will refuse to accept a nested state blob
> > > with GPAT_VALID set.
> >
> > Argh, so we've painted ourselves into an impossible situation by restri=
cting the
> > set of valid flags.  I.e. VMX's omission of checks on unknown flags is =
a feature,
> > not a bug.
> >
> > Chatted with Jim offlist, and he pointed out that KVM's standard way to=
 deal with
> > this is to make setting the flag opt-in, e.g. KVM_CAP_X86_TRIPLE_FAULT_=
EVENT and
> > KVM_CAP_EXCEPTION_PAYLOAD.
> >
> > As much as I want to retroactively change KVM's documentation to state =
doing
> > KVM_SET_NESTED_STATE with data that didn't come from KVM_GET_NESTED_STA=
TE is
> > unsupported, that feels too restrictive and could really bite us in the=
 future.
> > And it doesn't help if there's already userspace that's putting garbage=
 into the
> > header.
> >
> > So yeah, I don't see a better option than adding yet another capability=
.
> >
> > Can you send a new version based on `kvm-x86 next`?  (give me ~hour to =
drop these
> > and push).  This has snowballed beyond what I'm comfortable doing as fi=
xup. :-(
>=20
> Will the current patches still be reachable through
> kvm-x86-next-2026.03.03? I imagine Jim will want to pull those and
> change them directly as they have all your fixups (rather than
> reconstructing them).

Oh, yeah!  I was actually going to self-respond with that suggestion, then =
squirrel!

