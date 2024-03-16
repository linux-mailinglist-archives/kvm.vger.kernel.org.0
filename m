Return-Path: <kvm+bounces-11960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CD1D587D954
	for <lists+kvm@lfdr.de>; Sat, 16 Mar 2024 09:48:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2532D1F21A40
	for <lists+kvm@lfdr.de>; Sat, 16 Mar 2024 08:48:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A01CF101D5;
	Sat, 16 Mar 2024 08:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DlfiYR7I"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D22D527
	for <kvm@vger.kernel.org>; Sat, 16 Mar 2024 08:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710578913; cv=none; b=XQKcXsOY37kiNMdo0rkrOEh7nIB9gnGMtli3k0P/Tuf3PDJxbsaVSuB8zaW3W+1wBEmp7RR1JakWa1l6fe8CpjY9VF19VXq+mZu2pU58ETmzdOh24khDzp2s2cyQkfWy3ZT7vrXtm0C4g/DtBGOYTXiG23bXz9JNHrdoemHVOJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710578913; c=relaxed/simple;
	bh=0JlhthgrKHV29IVjz2EO44f92zWT1eQJTAcBHY3ySlU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kZiCX93Czw7KzdDV/kH9OHnL3N+HaVxeV2yYYBxckSCQ/RtYeR3OZeEtvQQV/DLSfrKfNvjW+yCSHuG7wHmAf9mCn5XgDR6QM9JGMj8qCuRiFf6J4+fLNHLCqbwW6PfPcasL1sYBJvDx4+uKxHXVr3ny1SM+h+znOsbn7zFF+H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DlfiYR7I; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710578910;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JAx0yq8BORY9e0dLO5aHnSZgcaI3RI+C7Cfvwd3q8TI=;
	b=DlfiYR7ICMgJvgnABH6gisvVRz3gn7m22hRaSVK2fU1js5NVgiU8i8Nl0klwWmCjQgOKMy
	djyJFdiFyokoTVaEeCzK/SzZjkeIagvl7UKQCW1nl3uK2U165vjCjMjNdA83za3pS9wX99
	hlV4TWjYHZZ3u7tEQJtXxcU9l3kqtEQ=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-300-6dmGcTC4NX-hhmOa7rQPog-1; Sat, 16 Mar 2024 04:48:28 -0400
X-MC-Unique: 6dmGcTC4NX-hhmOa7rQPog-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2d498bfaa1bso1391571fa.0
        for <kvm@vger.kernel.org>; Sat, 16 Mar 2024 01:48:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710578907; x=1711183707;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JAx0yq8BORY9e0dLO5aHnSZgcaI3RI+C7Cfvwd3q8TI=;
        b=bT9SFc7wZKA0GrneiqtI0LtdWvI+jc9nAiBaQjD88ZSPcatcvRV2X/3PzkFEHKdWKZ
         GRhX3RVMIxQ2w4nuLFBxE1/E6Czz9r5Wo5TSeABZ0WJRVoKJwNp8iTopl+skgn3mp7cX
         cK2tgjYicnvGyMx796PjlClGHDCI74KKeFY3/R76QVKncLFBPBPM3eG8aM/0wLWG1sRr
         ySTINOghjsFe5drHkiY5mZn2M1OYrgcztAtzrWZaQQ/JWwQV4LNbINrGoqO6v0Jmvm7o
         2jWeN1SmVpTAYeHi0HtB7+9kGHb7ndIBAN22QyyxJNPdsiPy1ZUJDpQTtEp5IyMa7b+W
         oQmQ==
X-Forwarded-Encrypted: i=1; AJvYcCVK89qn/tCDbL0Bnvgg6SRJRHgIc/eZhQPkgl9zHe9O7qvrMxzh7MQ836dVo+3ERJ8ThfKn327eQf8gtK/91PdsbYsT
X-Gm-Message-State: AOJu0Yx4u9Gq+RqoBFOr/qZT2lsY8qtTzGBqktO44GRLEIe9sa09h/Qs
	DsXz9h2jT61HiM6mJKDgNcETg3fgscRZcbZNWlf8oqHAD03nbwUmpvoE/Yh+6pNGZocMTczIwx9
	CnGLs1GRB6c6ewN2/bHab3CJCJAgBUexzVYRamadFv4Sg15SEABZ4qYju64y6fy+QUCHWxZbiak
	WRGazZ4hxWIcaWSG4uyZJHzOjy
X-Received: by 2002:a2e:a792:0:b0:2d3:b502:3ff1 with SMTP id c18-20020a2ea792000000b002d3b5023ff1mr4145965ljf.11.1710578907176;
        Sat, 16 Mar 2024 01:48:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGDJCaU78jy/WvCx6Z35UZXS6G0J2u/HJY/F6+G+vMKF6uUTQdpjGov40899dUzAEqnrRR95Vy0eFoqwYr53OM=
X-Received: by 2002:a2e:a792:0:b0:2d3:b502:3ff1 with SMTP id
 c18-20020a2ea792000000b002d3b5023ff1mr4145955ljf.11.1710578906817; Sat, 16
 Mar 2024 01:48:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240315174939.2530483-1-pbonzini@redhat.com> <CAHk-=whCvkhc8BbFOUf1ddOsgSGgEjwoKv77=HEY1UiVCydGqw@mail.gmail.com>
 <ZfTadCKIL7Ujxw3f@linux.dev> <ZfTepXx_lsriEg5U@linux.dev>
In-Reply-To: <ZfTepXx_lsriEg5U@linux.dev>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 16 Mar 2024 09:48:14 +0100
Message-ID: <CABgObfaLzspX-eMOw3Mn0KgFzYJ1+FhN0d58VNQ088SoXfsvAA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM changes for Linux 6.9 merge window
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Marc Zyngier <maz@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 16, 2024 at 12:50=E2=80=AFAM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> On Fri, Mar 15, 2024 at 04:32:10PM -0700, Oliver Upton wrote:
> > On Fri, Mar 15, 2024 at 03:28:29PM -0700, Linus Torvalds wrote:
> > > The immediate cause of the failure is commit b80b701d5a67 ("KVM:
> > > arm64: Snapshot all non-zero RES0/RES1 sysreg fields for later
> > > checking") but I hope it worked at *some* point. I can't see how.
> >
> > Looks like commit fdd867fe9b32 ("arm64/sysreg: Add register fields for
> > ID_AA64DFR1_EL1") changed the register definition that tripped the
> > BUILD_BUG_ON().
> >
> > But it'd be *wildly* unfair to blame that, the KVM assertions are added
> > out of fear of new register definitions breaking our sysreg emulation.
> >
> > > I would guess / assume that commit cfc680bb04c5 ("arm64: sysreg: Add
> > > layout for ID_AA64MMFR4_EL1") is also involved, but having recoiled i=
n
> > > horror from the awk script, I really can't even begin to guess at wha=
t
> > > is going on.

Linus, were you compiling with allyesconfig so that you got
CONFIG_KVM_ARM64_RES_BITS_PARANOIA on?

> > So unless anyone screams, I say we revert:
> >
> >   99101dda29e3 ("KVM: arm64: Make build-time check of RES0/RES1 bits op=
tional")

Yes, in retrospect it's kinda obvious that, even if it cures default
config, allyesconfig still fails with this change.

>   b80b701d5a67 ("KVM: arm64: Snapshot all non-zero RES0/RES1 sysreg field=
s for later checking")

You can also make CONFIG_KVM_ARM64_RES_BITS_PARANOIA depend on !COMPILE_TES=
T.

Paolo


