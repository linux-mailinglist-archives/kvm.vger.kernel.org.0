Return-Path: <kvm+bounces-22204-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A0DD93B87B
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 23:23:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D7231C2367A
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 21:23:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71ADC13C683;
	Wed, 24 Jul 2024 21:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MmAWIouE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E52113BAE4
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 21:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721856183; cv=none; b=ci3Zt+8vxXn70qa6eiTFS+bwlCOVDFqqkDhxd+nZI/hSo4r5KbinKfEVxF2mSJ6KHWMHnJ+Wrk6ulu71xvt4Lbq6jTwt8+5Ps06afLwIeZkYcFKyH56qE8p7xps5zXj9KGR9PTZ0YwQudzzqOhF3ya+wxxTuD+l0VnrH9PUZ/IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721856183; c=relaxed/simple;
	bh=TsXUqYEDqb/fzue3QY6iQjFm19jnTzmKLEUUDlnmWx0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XajEIeQ45TpqY2Ov64efUX4pI/6ZYSlN71koWRMTPaplgm+Tr0HcuGFgsu09mnMlvD+Q6AyUdQmS4Ob46wIrlHjIdpq1esjkXqGOLyKfJC9RhM1MtyPmQUbTRkQFi23UtBz8QjXcMtHrUrPcdgJYBdiVzaXoWyMhog5W/W6NybE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MmAWIouE; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1fc4aff530dso64345ad.0
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 14:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721856181; x=1722460981; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rl74AGq79ouu4umLKYzLUjukT/ydoAFghx4WCTnHxM4=;
        b=MmAWIouE+LDHqrgg3QExG+QNgAoU8THaHbM54UaMs5mvJdJY5hXIzVW1pgkEBzApar
         7b9v+F6vXQY3lvIvdWYrFZcETFnUN0OoqY+P94Qq3H7NPIyZyZQXtfMmfm5FN4wNH/Iw
         m9FwlhtvChmqyH4ZjvWZrY9hj2WTC8mzSVWN54VMIkXJ1bJCRSAStrqHwpdYYgyYZ7tP
         u2HtJSoY8TD9CV5vZ8ssXHcRoZHNnGjboKgoJC3eWFFy+MFx4g1t00gjHGGE4kZ05/Mz
         PirgHOboeYnw6xnb4vQEg71OJVMPLSamJ1tLmGI+dqoAenG5oNE1sbFbd2zahUSsIxXz
         iyfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721856181; x=1722460981;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rl74AGq79ouu4umLKYzLUjukT/ydoAFghx4WCTnHxM4=;
        b=xPQIOoaFu1rGgSELWaikkEtVZME2lEUmS+jY1kJmGdDcwlqIiWOtQp3oKYwqQ/gbW+
         ZczwwpsqPW73zPw7lqlHlCAY9OMsYWADpqPpo+aWYeXb+law9CxL56osDnU1ygajZRCy
         HjqjJ19bxY7nuWUbzA/0hyIGW+hnDl04zCHn16o3NeqD8MM1na6Ck4MUAcQLs1rH34ta
         xiakmS89OLvVxuEK/pJgpDmlEFXUG3vwYNXnW50SeAMsMaBK2yhbeo3rBWcG+VJB/TUK
         NCqv8l+k5yElhiUHI3kY6n7rEWgPBrMeaSsg6ljacJmFl7UpqSQv3mLgU6iQqOsV7XN8
         3MAw==
X-Forwarded-Encrypted: i=1; AJvYcCU48QRegduQNvo4ucviq85I/4gxnFpSflMbYyBZXuJQtyeodD4YFM1Nvroe5YiRW6gA9tFaMNFxVrYN7/98r2Ai3chh
X-Gm-Message-State: AOJu0YyzDHRlIWZV+zjokPVYWjetJoMmyWOKyNeEL6X7axM0yfHrerux
	0XOATMw6Obtu/BVOysf/VsWzUOquWAw7mlyNsPNSTQcFRi485d4MrqSPFYGnwCdfXFoMHicxBl4
	CNeibdo7/cgRw23JrFSoWwWAmGcjFUnRIT1u2
X-Google-Smtp-Source: AGHT+IFNdxgahCQiv15s0GgKKKnB3Q47sv17kOuvrJPJmSn1sl8ljrEH2g0dROo8PIVveUhDsI/UMaJudtOFGctc00Q=
X-Received: by 2002:a17:902:e751:b0:1fb:172a:f3d4 with SMTP id
 d9443c01a7336-1fed4fb7f52mr974955ad.8.1721856181230; Wed, 24 Jul 2024
 14:23:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240625235554.2576349-1-jmattson@google.com> <CALMp9eSTsGaAcEKkJ+=vWD4aHC3e_iOA8nnwWhGQdfBj_nj3-A@mail.gmail.com>
 <323bf4cc39f3e4dd3b95e0e25de35a7c0c2e9d2d.camel@redhat.com>
 <CALMp9eRmL_7xdK11dsC-yapd29d+6121tWu7sdLnTmHiEEBsdA@mail.gmail.com> <ZqFYIPw5XSmsdF_K@google.com>
In-Reply-To: <ZqFYIPw5XSmsdF_K@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Wed, 24 Jul 2024 14:22:49 -0700
Message-ID: <CALMp9eQspMVnkuhkVCjsGoY7C-9W2--MPYN5LZWM1Zfv7QMrpQ@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: x86: Complain about an attempt to change the APIC
 base address
To: Sean Christopherson <seanjc@google.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 24, 2024 at 12:38=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Wed, Jul 24, 2024, Jim Mattson wrote:
> > On Wed, Jul 24, 2024 at 11:13=E2=80=AFAM Maxim Levitsky <mlevitsk@redha=
t.com> wrote:
> > > What if we introduce a new KVM capability, say CAP_DISABLE_UNSUPPORTE=
D_FEATURES,
> > > and when enabled, outright crash the guest when it attempts things li=
ke
> > > changing APIC base, APIC IDs, and other unsupported things like that?
> > >
> > > Then we can make qemu set it by default, and if users have to use an
> > > unsupported feature, they could always add a qemu flag that will disa=
ble
> > > this capability.
> >
> > Alternatively, why not devise a way to inform userspace that the guest
> > has exercised an unsupported feature? Unless you're a hobbyist working =
on
> > your desktop, kernel messages are a *terrible* mechanism for communicat=
ing
> > with the end user.
>
> A per-vCPU/VM stat would suffice in most cases, e.g. similar to the propo=
sed
> auto-EOI stat[*].  But I honestly don't see the point for APIC base reloc=
ation
> and changing x2APIC IDs.  We _know_ these things don't work.  Having a fl=
ag might
> save a bit of triage when debugging a guest issue, but I fail to see what=
 userspace
> would do with the information outside of a debug scenario.

I would argue that insider knowledge about what does and doesn't work
isn't particularly helpful to the end user.

A non-standard flag isn't particularly helpful either. Nor is a kernel
log message. Perhaps these solutions are fine for hobbyists, but they
are not useful in an enterprise environment

If a guest OS tries to change the APIC base address, and KVM silently
ignores it, the guest is unlikely to get very far. Imagine what would
happen if the guest tried to change GS_BASE, and KVM silently ignored
it.

Maybe KVM should return KVM_INTERNAL_ERROR_EMULATION if the guest
attempts to relocate the APIC base--even without a new "pedantic"
flag. What is the point in trying to continue without relocation?

> And for APIC base relocation, userspace already has the ability to detect=
 this
> unuspported behavior.  Trap writes to MSR_IA32_APICBASE via MSR filtering=
, then
> reflect the value back into KVM.  Performance would suck, but writes to
> MSR_IA32_APICBASE should be very rare, especially if the host forces x2AP=
IC via
> guest firmware.

This "unsupported behavior" should at least be documented somewhere.

> As for changing x2APIC IDs, that is the architectural behavior on Intel. =
 If a
> kernel is trying to change x2APIC IDs, it's going to have a bad day regar=
dless.
>
> So I guess the question is, what motivated this patch?

I don't recall, but I now withdraw the patch. We really should do better.

BTW, there is a KUT that supposedly verifies that APIC base relocation
works. See KUT commit b6bdb3f6ab6 ("apic: Add test case for relocation
and writing reserved bits"). That's the test that Nadav Amit refers to
in the commit message for commit db324fe6f20b ("KVM: x86: Warn on APIC
base relocation").

