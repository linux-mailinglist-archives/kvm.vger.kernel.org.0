Return-Path: <kvm+bounces-30573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 822D69BC109
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 23:39:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 43351282B19
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 22:39:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EDF41FCF52;
	Mon,  4 Nov 2024 22:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KzFjQNJj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA77A1FC3
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 22:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730759946; cv=none; b=RMpKYu986H0JesBS4wxJ6VTtbfP8rfo3dBhUHDgUriOExZJo9u++SYiEeKx4apzoqvKq7USdA6E9Ir4jlCEHl1vDzUQRojExZZ4f1E9pRnwPjbQ1SaXgeEGsLCIMP/ruzkG/P+F46NPNyl2xUWSaiE9QkV6TxJpe0EOh+zo1UsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730759946; c=relaxed/simple;
	bh=KQpebessL0w56JuneEj1nI4OPn4BckrMvlp/syNP1Xs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=P3edXlOkJTmONWlsue2kln05RZzBDyrMyYkL/RhfQE+EUpR6+Mhm35eBAArvqGZS/5fk2r+XrLDnYkwrhpy8GZG+6SsQ39k2giAo14VbT6skrhrgbacOLx1oUVBWH/5q4F6SSN55u1C3wKtp2d5t9K8+hUfjF59uZJvycrjAWYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KzFjQNJj; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e28fc60660dso7128594276.0
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2024 14:39:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730759944; x=1731364744; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T69HLYj59y3td73w3JKR9zxGkviOqcR+FOKEEFNBpcg=;
        b=KzFjQNJjGtbPTpdtnb5HqhWCeUAUN0yKLIB91U6z/GlKzDDIUFjgBNF5yHwSDlSNvj
         ihtQEOaMOrPcvd2ZdeoPVgDHD6uFJlzn8QHRGym89abFtjvOwBVaxEBKVvMmmCvv52FF
         90OkoB3ekBNCuS4gMs2wi4BDPup3XRUm5SwI6ogrtcVqlqQeX/zSL13mq6CgbE8EWYKh
         UsB0q2MCpu40CxyfnZ5fGGjO1yRfgWLxWoDpKUeS1qdjkiITAJonHQgKWRR1Sn8ou90A
         zY970LUR+TRZJlrqTJIuaGJZTM5ahZCQ4Lf4ICpfSQATJ8lOwqhey6fxlRsf/h7TyHM4
         7d7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730759944; x=1731364744;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=T69HLYj59y3td73w3JKR9zxGkviOqcR+FOKEEFNBpcg=;
        b=DFgO2jbLD+1Bf9uCccOwhTVAKTCf+n5Qyb1F1HLoePvV/WcrpgpaoRhO6WJkJHTz9m
         Nad+EwqGt4MhqIHRhHcLlkinTLnxSr98EKws4da7NVqe/WLuySZbgJXxjLIvEnd/pUy+
         i/39Mmk3jSJOlcSAJ4nSvbpBdfHCkm8S53/QlJ2SVVeik8oIpJoMUZNJ3ERRlEyzmqvX
         eBFMIXUgRrmi0opX4SBIcVyzgd8svfuGJUVSryQt/FKcTVfSMOVTReUZu9SJjFtfqi/n
         FpFp7X0oyLxj8ar7qhjCdVlTUU0QQUHWaNBaeCoWO15YZRFPeWo4HakUH5I/BA5QAkke
         VOQA==
X-Forwarded-Encrypted: i=1; AJvYcCWmOl6MLGIrzZcQBBwGWpBxiatEHrF2vnolUza5B5iDhAYMgk8z9UlKa80572OzQjDgFrY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0kZDp5fa+fIpCuPDynypTc+Klh/NPU4KbPg5RS+O4mGMJwC6g
	Y2q30gPiB8V4wTIbwxn1R5aWqlrD4dIC+weZ2j9QmAJj3fzDVD0K8b+nMPBaBx74+21R8CPsI8h
	/0Q==
X-Google-Smtp-Source: AGHT+IEIqOsuuS4StvVwck7nK3ma/UJ6VuIMMeM9hCsiVxbG8JA7nIsuMqdDQas6hknbx1QW/MPEuAK6u+s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:aace:0:b0:e28:f35b:c719 with SMTP id
 3f1490d57ef6-e3087bd6066mr67907276.6.1730759943796; Mon, 04 Nov 2024 14:39:03
 -0800 (PST)
Date: Mon, 4 Nov 2024 14:39:02 -0800
In-Reply-To: <CAHVum0fYkpU-UAyuqrRx+VGi2BFVSupwMhKQ+Q0hY9+15GSTCg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240823235648.3236880-1-dmatlack@google.com> <20240823235648.3236880-5-dmatlack@google.com>
 <CAHVum0ffQFnu2-uGYCsxQJt4HxmC+dTKP=StzRJgHxajJ7tYoA@mail.gmail.com>
 <Zwa-9mItmmiKeVsd@google.com> <CAHVum0di0z1G7qDfexErzi_f99_T_fTPbZM0s2=TYFCQ8K5pBg@mail.gmail.com>
 <ZyLES2Ai4CC4W-0s@google.com> <CAHVum0fYkpU-UAyuqrRx+VGi2BFVSupwMhKQ+Q0hY9+15GSTCg@mail.gmail.com>
Message-ID: <ZylNBqRnL1lD-T1n@google.com>
Subject: Re: [PATCH v2 4/6] KVM: x86/mmu: Recover TDP MMU huge page mappings
 in-place instead of zapping
From: Sean Christopherson <seanjc@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 01, 2024, Vipin Sharma wrote:
> On Wed, Oct 30, 2024 at 4:42=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Wed, Oct 09, 2024, Vipin Sharma wrote:
> >
> > Coming back to this, I opted to match the behavior of make_small_spte()=
 and do:
> >
> >         KVM_BUG_ON(!is_shadow_present_pte(small_spte) || level =3D=3D P=
G_LEVEL_4K, kvm);
> >
>=20
> Should these be two separate KVM_BUG_ON(), to aid in debugging?

I smushed them together to may make_huge_page_split_spte()'s style, and bec=
ause
practically speaking the assertion will never fail.  And if it does fail, f=
iguring
out what failed wil be quite easy as the two variables being checked are fu=
nction
parameters, i.e. are all but guaranteed to be in RSI and RDX.

> > As explained in commit 3d4415ed75a57, the scenario is meant to be impos=
sible.
> > If the check fails in production, odds are good there's SPTE memory cor=
ruption
> > and we _want_ to kill the VM.
> >
> >     KVM: x86/mmu: Bug the VM if KVM tries to split a !hugepage SPTE
> >
> >     Bug the VM instead of simply warning if KVM tries to split a SPTE t=
hat is
> >     non-present or not-huge.  KVM is guaranteed to end up in a broken s=
tate as
> >     the callers fully expect a valid SPTE, e.g. the shadow MMU will add=
 an
> >     rmap entry, and all MMUs will account the expected small page.  Ret=
urning
> >     '0' is also technically wrong now that SHADOW_NONPRESENT_VALUE exis=
ts,
> >     i.e. would cause KVM to create a potential #VE SPTE.
> >
> >     While it would be possible to have the callers gracefully handle fa=
ilure,
> >     doing so would provide no practical value as the scenario really sh=
ould be
> >     impossible, while the error handling would add a non-trivial amount=
 of
> >     noise.
> >
> > There's also no need to return SHADOW_NONPRESENT_VALUE.  KVM_BUG_ON() e=
nsures
> > all vCPUs are kicked out of the guest, so while the return SPTE may be =
a bit
> > nonsensical, it will never be consumed by hardware.  Theoretically, KVM=
 could
> > wander down a weird path in the future, but again, the most likely scen=
ario is
> > that there was host memory corruption, so potential weird paths are the=
 least of
> > KVM's worries at that point.
> >
> > More importantly, in the _current_ code, returning SHADOW_NONPRESENT_VA=
LUE happens
> > to be benign, but that's 100% due to make_huge_spte() only being used b=
y the TDP
> > MMU.  If the shaduw MMU ever started using make_huge_spte(), returning =
a !present
> > SPTE would be all but guaranteed to cause fatal problems.
>=20
> I think the caller should be given the opportunity to handle a
> failure. In the current code, TDP is able to handle the error
> condition, so penalizing a VM seems wrong. We have gone from a state
> of reduced performance to either very good performance or VM being
> killed.

The context of how the failure can happens matters.  The only way this help=
er can
fail is if there is a blatant bug in the caller, or if there is data corrup=
tion
of some form.  The use of KVM_BUG_ON() is a very clear signal to developers=
 and
readers that the caller _must_ ensure the SPTE is shadow-present SPTE, and =
that
the new SPTE will be a huge SPTE.  Critically, treating bad input as fatal =
to the
VM also allow the caller to assume success.

> If shadow MMU starts using make_huge_spte() and doesn't add logic to
> handle this scenario (killing vm or something else) then that is a
> coding bug of that feature which should be fixed.

No, because allowing make_huge_spte() to fail, even if there is a WARN, add=
s
non-trivial complexity with zero real-world benefit.  At some point, succes=
s must
be assumed/guaranteed.  Forcing a future developer to think about the best =
way to
handle a failure that "can't" happen is a waste of their time.

E.g. as an example where allowing failure is both more absurd and more pain=
ful,
imagine if kvm_mmu_prepare_zap_page() return an error if mmu_lock weren't h=
eld.
Trying to gracefully handle error would be madness, and so it simply assert=
s that
mmu_lock is held.

