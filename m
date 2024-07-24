Return-Path: <kvm+bounces-22202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 51D4D93B7A4
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 21:38:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 748851C23A1B
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 19:38:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C9DA16D4D1;
	Wed, 24 Jul 2024 19:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CB1I/kn6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098FD15F3EF
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 19:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721849892; cv=none; b=MJEZ25GVfEXmHQ2GvHvALuYO7aJ8A+O7mRC0NSA29/oEoPjPtz2fnGBotmf8QWrnMGlv+iXqCnZPZ4SxLEr5JCvrHs90J4VgEFNxzeoh1zEJkRkeULS/emPDy4kU9KJsjy+U+oau7mWxfZWicFWuNSoqdOmBSEll/mzvXuI7Fic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721849892; c=relaxed/simple;
	bh=RJOvHWelQY9cIKaVt5Iud9Bu8yI7sjGQyQ75y9g6tw4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QYeXvtXQFgJPgNMNbK6Efl9iAlgVuHS0L+9sE2eQOG8YHUhryJLXXJ2jupqMzyf2Y2Aypmt+eObe4kSyoRRmZvsxEVrW9IoEVJcr7rb3+tqz9V8LrtdYFWsGvVfLY9nTt1thSqstJTGS6Hh9Rw6JM8/AcjXbOlX7ZXi/NVOv6vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CB1I/kn6; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-70d1469f5e1so127770b3a.3
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 12:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721849890; x=1722454690; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5potetzhu9wFuzJwIL+Yt0OPvXdCT+UVoCguJgABgBg=;
        b=CB1I/kn6VLFfg89ebmFjhjlBCQgA16Qdihd8+wEu8Avb5jsTT4QHWmu6ei7wOMOyGB
         MZhYDf/q5kV5h960cHmq/hnO7FHNcAaLmGhgSqLeLSTNag/aYQbdGKEhnNiJdXZ/QYp/
         eO45186OljXQ4oLFJtn3dHzWB4bK/Q5nOBFSzzD8tmtAooXm6P4fEUy63c0v8FV0fnLt
         8KVqpot6W3+0q80moFjBA8ZzM1KYOOdraEn4kWGBLNLKjj23hnr2TnhwnKlKuI8MS0KX
         SSobhZUblA+mca2yNr05wJdAOr8Vsk+WNm+6iXb87E/6OU5DgWUC+B8SKP4xAkd+geTU
         5q4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721849890; x=1722454690;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5potetzhu9wFuzJwIL+Yt0OPvXdCT+UVoCguJgABgBg=;
        b=oZKTpM6sQWFtvngTSc56hAw5Ma8rnCyD93KCf8c81oajDE5lHV0o2H41TruvJEoYvw
         QAD4oxxHi8pMQyxpHjfinzzWlGVtscIxIODpgpL65g/5FvaIYRPqtjoBUG7q7cVxSwxr
         tyd6gSkS93p8roF4ge7dUC7uc0N9BjyRRI9GdsK6LUFPJUUM9bsOuUSkWAMnJovLMJoE
         thPpT4U/7c4mQLRrxio4yHW7oqzr+9o1J52sEcmHtQI+mjbwWrxjfJXmd29AGQ/V435v
         Loaf38m1ahLcSB6rX0TqzIE66ZlE4EGMSdFNvbkYtcYpVAw6qkOYns/hB3y0LRu+Y65J
         RR6w==
X-Forwarded-Encrypted: i=1; AJvYcCV8RJSTrSn1D1rwShlk38HcAghF10R+XaheJk09SJsq9gZmDnA1KpS0d08qaZKQ+P6oYHj5NGZRkMSjjxnZIHpRN1vA
X-Gm-Message-State: AOJu0YwnnXRI11oTnl7FgYw4YcI+Oz4u7VXPrg5lV6QXIhCOrozQkvQ7
	agfYodJVAJwZ5YzM/NlwpxB7WP8U5K9kkTV3tvbeFd0Kif0QWiU537NEkXp12vwne0WmqdxXlmy
	+tw==
X-Google-Smtp-Source: AGHT+IESK7KaVYMQ4RaTF51q0htGa56PjhjdyyjqRWStB/EjpLyabV8vxIqkTO9/iJzlj7bBH/2h7tQcsLs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:859a:b0:70d:2f48:58d7 with SMTP id
 d2e1a72fcca58-70eaaadd3e6mr15958b3a.6.1721849889995; Wed, 24 Jul 2024
 12:38:09 -0700 (PDT)
Date: Wed, 24 Jul 2024 12:38:08 -0700
In-Reply-To: <CALMp9eRmL_7xdK11dsC-yapd29d+6121tWu7sdLnTmHiEEBsdA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240625235554.2576349-1-jmattson@google.com> <CALMp9eSTsGaAcEKkJ+=vWD4aHC3e_iOA8nnwWhGQdfBj_nj3-A@mail.gmail.com>
 <323bf4cc39f3e4dd3b95e0e25de35a7c0c2e9d2d.camel@redhat.com> <CALMp9eRmL_7xdK11dsC-yapd29d+6121tWu7sdLnTmHiEEBsdA@mail.gmail.com>
Message-ID: <ZqFYIPw5XSmsdF_K@google.com>
Subject: Re: [PATCH v2] KVM: x86: Complain about an attempt to change the APIC
 base address
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 24, 2024, Jim Mattson wrote:
> On Wed, Jul 24, 2024 at 11:13=E2=80=AFAM Maxim Levitsky <mlevitsk@redhat.=
com> wrote:
> > What if we introduce a new KVM capability, say CAP_DISABLE_UNSUPPORTED_=
FEATURES,
> > and when enabled, outright crash the guest when it attempts things like
> > changing APIC base, APIC IDs, and other unsupported things like that?
> >
> > Then we can make qemu set it by default, and if users have to use an
> > unsupported feature, they could always add a qemu flag that will disabl=
e
> > this capability.
>=20
> Alternatively, why not devise a way to inform userspace that the guest
> has exercised an unsupported feature? Unless you're a hobbyist working on
> your desktop, kernel messages are a *terrible* mechanism for communicatin=
g
> with the end user.

A per-vCPU/VM stat would suffice in most cases, e.g. similar to the propose=
d
auto-EOI stat[*].  But I honestly don't see the point for APIC base relocat=
ion
and changing x2APIC IDs.  We _know_ these things don't work.  Having a flag=
 might
save a bit of triage when debugging a guest issue, but I fail to see what u=
serspace
would do with the information outside of a debug scenario.

And for APIC base relocation, userspace already has the ability to detect t=
his
unuspported behavior.  Trap writes to MSR_IA32_APICBASE via MSR filtering, =
then
reflect the value back into KVM.  Performance would suck, but writes to
MSR_IA32_APICBASE should be very rare, especially if the host forces x2APIC=
 via
guest firmware.

As for changing x2APIC IDs, that is the architectural behavior on Intel.  I=
f a
kernel is trying to change x2APIC IDs, it's going to have a bad day regardl=
ess.

So I guess the question is, what motivated this patch?

