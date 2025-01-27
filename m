Return-Path: <kvm+bounces-36680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 581E5A1DCF0
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 20:52:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A550E3A49F5
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 19:52:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3BEB194091;
	Mon, 27 Jan 2025 19:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yBn3Kn10"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E37376C61
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 19:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738007530; cv=none; b=O/km2VsPjHPFniuqbWqCNQSQ0cgwF/fTRKEYXSF5A5P2njdRoXf2HB6P/qJQmioA90SkHsFHrOr38shsEHbyVJImcw4m7UqttBD1rMutaj/PqIcqzPsQQEmRRBbRbTkqUGmNJmGdjss1lAq7fi/JGuraESjK+IH2khdsSJvPHcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738007530; c=relaxed/simple;
	bh=a0rRa/Xi6fG27BbvPi4G8bMytlbfNYsHybsWRvAFw5Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dZjMl4RHVtgRWdfLlEd98ZcFsLK0t6Tb2COcCy+8PNv9ZLHwTcbXE7yjhLCaKTXdSsLMeXTHJP7kNBhKakp0SIb0FI6H/CMn7PIZpVfaQJ3C7YItPi8Ywqrr5ESwWnMMoA1FRJeoLqUUac9Vms3RmjVbyuU5eWGScbd0L0gTFUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yBn3Kn10; arc=none smtp.client-ip=209.85.219.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-e5447fae695so8478665276.2
        for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 11:52:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738007527; x=1738612327; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LK4aWPmP9DVwU8SlS3tITSPQ6Ls8tU6gs2fN3Ih5+X0=;
        b=yBn3Kn10DIQRNKXHncAepgoyH2tvLKWIlu9VpugPORd6+6e9AeXYos7dxvS0//+9ri
         G26UOacNQ6viW4pqtdXM/HDTktGQMjmOQyYjyuMT+l5CASPrfQARIjObBeI0n/eFo8W/
         3HVNhsREon4d9w4lcKwwiuf1Q8FibaEV8X8cmlEWekMd50BXWOaK2ldut8yJh6U5R4Tq
         sHWQM8vyZMRuQE+I5IkUcU12iFrjrRBb2u90+HCACdCrLVHYVqEeRFV2PtQIK11KL0xr
         VehLSCkdv3sfgZymzVemGze4PFBBFM4tUjDP+WKa75ow+93UkmvRDR0DDUChdFyhQdCW
         8U1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738007527; x=1738612327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LK4aWPmP9DVwU8SlS3tITSPQ6Ls8tU6gs2fN3Ih5+X0=;
        b=nAu0EqiLJqoKJV9C/tTszFlkgAUug7k8Mbhwoz1BaDCAcEAzD5BntOpEkYkJORxSQ4
         Qp9v2cM6AsDCQByWle+t79FMfMF+LUryXtxuw25mWbEDIwU99b/exFfvIlq7GjGFKqVw
         u9PZJqlBHUvx77qQBcalpjbOy7ZmrHnzb5jPdCOZZU98i256rADVwrIdRfdvfCZxU4jR
         1TE/0QnHGEvUOuAdZIo84OgHfgrLfzn65Gu4XcPL9Nlk+t7IF5NOOP4UpqPnqdr8voGe
         9BZcVm8SVfGV1WYR+yOLhufs4r0nwG2iRQKQjkhazzho88uDNFIe5OJDqfCor9OmtSa+
         zdxQ==
X-Forwarded-Encrypted: i=1; AJvYcCXzmJS3aYEu+3HVbkyDDy12/72d02CkxhbOqxeiGg4PGSoCQrwud7DvEoQR85o/oBFy0vs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhLTSYQ3SxyGl+QLuaLRaB5jZKp7WpLCaO+O4MCKFhtWSDqtsP
	v19gLkjwCmtqJ0Au3t3lJjZdTSvujw31WIsN3YZLlRGDwa9H8193HYyGi/cbT7yxi9g7hI5tEBs
	Bjh6tCo6KlCbQBdpw8JqNYApIurqwigXjHeg3
X-Gm-Gg: ASbGnctqmxQB0xctjcmXs1C6X9VpB8j8P4ge5AxKJ5kg8YoLYmoWFbgGC4UOLA99oJ3
	uURlON42yLIJtDXS1VnlL5ioPie5XN3eXtvzNA4Cx+h82EP4FcjGOXnLsT+xiCQLK2KfIbMuPak
	F3j1oM0lSBuhTrsivq
X-Google-Smtp-Source: AGHT+IG4GLT6iE0oHGAfnmD/3suAMZgcPVUqD9nnLaT40wo2g7fuGzeF591xQL2fx5DpLDmj6FS6j+gUsKzQmPTd7MU=
X-Received: by 2002:a05:690c:6b84:b0:6ef:4cb2:8b4c with SMTP id
 00721157ae682-6f6eb929494mr314700847b3.23.1738007527266; Mon, 27 Jan 2025
 11:52:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105184333.2305744-1-jthoughton@google.com>
 <20241105184333.2305744-3-jthoughton@google.com> <Z4GesYBOCNhoUKJx@google.com>
In-Reply-To: <Z4GesYBOCNhoUKJx@google.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 27 Jan 2025 11:51:31 -0800
X-Gm-Features: AWEUYZng-a03hiIVIQbbBRXixQK6B0JxZzwyJAmr7V9BC8Ts-isswjQU3I5tHOg
Message-ID: <CADrL8HXEPAFmP8aONq6Df7HW_UPXYMAvAO+xYU6nwx1ZHLL0Ew@mail.gmail.com>
Subject: Re: [PATCH v8 02/11] KVM: Add lockless memslot walk to KVM
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 10, 2025 at 2:26=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Nov 05, 2024, James Houghton wrote:
> > Provide flexibility to the architecture to synchronize as optimally as
>
> Similar to my nit on "locking" below, "synchronize" is somewhat misleadin=
g.  There's
> no requirement for architectures to synchronize during aging.  There is a=
ll but
> guaranteed to be some form of "synchronization", e.g. to prevent walking =
freed
> page tables, but the aging itself never synchronizes, and protecting a wa=
lk by
> disabling IRQs (as x86's shadow MMU does in some flows) only "synchronize=
s" in a
> loose sense of the word.
>
> > they can instead of always taking the MMU lock for writing.
> >
> > Architectures that do their own locking must select
> > CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS.
>
> This is backwards and could be misleading, and for the TDP MMU outright w=
rong.
> If some hypothetical architecture took _additional_ locks, then it can do=
 so
> without needing to select CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS.
>
> What you want to say is that architectures that select
> CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS are responsible for ensuring corre=
ctness.
> And it's specifically all about correctness.  Common KVM doesn't care if =
the
> arch does it's own locking, e.g. taking mmu_lock for read, or has some co=
mpletely
> lock-free scheme for aging.
>
> > The immediate application is to allow architectures to implement the
>
> "immediate application" is pretty redundant.  There's really only one rea=
son to
> not take mmu_lock in this path.
>
> > test/clear_young MMU notifiers more cheaply.
>
> IMO, "more cheaply" is vague, and doesn't add much beyond the opening sen=
tence
> about "synchronize as optimally as they can".  I would just delete this l=
ast
> sentence.

Thanks Sean. I've reworded the changelog like this:

    It is possible to correctly do aging without taking the KVM MMU lock;
    this option allows such architectures to do so. Architectures that
    select CONFIG_KVM_MMU_NOTIFIER_AGING_LOCKLESS are responsible for
    ensuring correctness.

>
> > Suggested-by: Yu Zhao <yuzhao@google.com>
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > Reviewed-by: David Matlack <dmatlack@google.com>
> > ---
> > @@ -797,6 +805,8 @@ static int kvm_mmu_notifier_clear_flush_young(struc=
t mmu_notifier *mn,
> >               .flush_on_ret   =3D
> >                       !IS_ENABLED(CONFIG_KVM_ELIDE_TLB_FLUSH_IF_YOUNG),
> >               .may_block      =3D false,
> > +             .lockless       =3D
> > +                     IS_ENABLED(CONFIG_KVM_MMU_NOTIFIER_YOUNG_LOCKLESS=
),
>
>                 .lockess        =3D IS_ENABLED(CONFIG_KVM_MMU_NOTIFIER_YO=
UNG_LOCKLESS),
>
> Random thought, maybe CONFIG_KVM_MMU_NOTIFIER_AGING_LOCKLESS or
> CONFIG_KVM_MMU_NOTIFIER_AGE_LOCKLESS instead of "YOUNG"?

CONFIG_KVM_MMU_NOTIFIER_AGING_LOCKLESS sounds good. Changed.

