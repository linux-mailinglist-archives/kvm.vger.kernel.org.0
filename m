Return-Path: <kvm+bounces-59327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A2E1BB140B
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 18:31:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 941913B50F6
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 16:31:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1D1128640E;
	Wed,  1 Oct 2025 16:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IFJQFGqK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465AB239E8B
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 16:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759336289; cv=none; b=JIb0ZSslyO8T/pMIci+v1fQBW+/No8LOYjZ1Z8tpTqnr+gVgSzcrB90Hu36v++yStHzzrSmqn+wAYd3ot1TiEC5kgY5DUD+pqYb1wAcoZLyedk8lh8dixJNOdX4ZGKrCAF5WsyZE0dQ7/VUsLMSAr7lQzYC54NceR7plfeQ2T7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759336289; c=relaxed/simple;
	bh=RP1vqmC3zoQ6sRRSEzky7NdKDsBOuulx9J4Zw7a3DaA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jdTUzFxqhtE+zKuV6WcrfLmMQyTjaEKrEQQX23c5pmp5678TeU+oCWmJuE5xrGEN4aJz5GIYd/wZ49OVSPyj2Dbgus1IsLTxeYEzzYV4MT2jvg/dOg2aGXS7v/+71zm4RMQ6EMhsVwOoLUfuQG/VsC5sHck0Q9rfF/SzcXafBZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IFJQFGqK; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2731ff54949so185955ad.1
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 09:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759336287; x=1759941087; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XdG7GxF5fqvjfIsAubrCH24e3CucQVnX0feF4WXkz4k=;
        b=IFJQFGqKAqkXCqbt3xOVw6Y1qEe3baqizs2/h97o56kXCY9uUexUWr9JLsO4zIIyB0
         vX8bdUJvfPe1uisvIc7sgPyqCDxoEAJvi+JCX7bTlquAw4Qn3Fon/EkpAt+/qzdgMrpn
         /O4EVop/isArhA7dppex+1UhMWbJZB8aHPy6hpg5XgaqtJNbsXpo5Lr2+rQbvReyMjoi
         YePt/VzDJHxyDneKFzfO2xgnr58EHrw5kcpTUaCZm0O9xc8LjfZlekCZv3TgNXDh+0fP
         NbRvFziqSh+tjF1E2TDXZzKESI93WPCqKnKkO5tDvhRLkyN0kKr/CVuoxZji/2JYW66r
         hgOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759336287; x=1759941087;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XdG7GxF5fqvjfIsAubrCH24e3CucQVnX0feF4WXkz4k=;
        b=MZdDZO5U/qqVbXhKbmYEQqN46OnAKKHnxrm36KVgCE9YWEVCm/JsbgoS/GzXbn/77n
         uBDIR2ClLY7ShJl+7M9uCqvPgD18rXopy/2EA2PSEv5dc3/63V8z+l9smWQgeOGQasBs
         UyLIVTeAPAOUE8tJOxhyWnaJkqHyu1YT4cgj53oHWVXfoJGQ4ZYxBeHWZV0djeg948HK
         5e6rmqfba/Ft8H5ykHyAX2vXFEBhU7c+F/UhQbqfmsl7PNQRp2x4TyvnAz/lA1T+7JjT
         qFLg9FtTimcwZtO88e+5sI8FxBB4jRm4nqvh2H/U/ooQ++AoeB1mdElG3PRfwTdYBpia
         KePA==
X-Forwarded-Encrypted: i=1; AJvYcCVUqPPGhN4pZn6cD+6I5QMuAqNAOgiVmQaCFLpamO93eiGzOwS+4nmvk2mMArmTdAJ1e/U=@vger.kernel.org
X-Gm-Message-State: AOJu0YypxQF2gB7b3Bq3fplpvht2nYUh2ivRgIp1Gw2VjNeageAXdXTQ
	mItbSZrDCRS+1Wn0ft38R+yRZYzpPMCAuFFVkeustwSLefoJjFhDetEog7yZzoO+6s5Q3xe+g9d
	QnyBFPCtfLKIj0FMMo1oL1+uqq8v9GDtN/Kxi6+Nv
X-Gm-Gg: ASbGncubRz4nJhYL/1/z9lRzQQP2M+2058DuzeupiBMVdmzuBltbgKJPOqiXZreXniI
	hvaZTEo13BhQqBmaVtwMPawmhv8OGJ/PSqONd1Z6PomLK9VYqMKdZACF3K901cMj43vXy6KYbmE
	UvaYjIgPu0TvMXycJa0Xpa6rSJNjqxtTVnnK/I7ingYtcts4TJ3IxiUHFiZ+VV/uBS3MZ+ZewoA
	Ax5NRk2WRw5leVi+iAG2QzU2LPcFKjVohjmh0iaVB6ERsmK9cPcFG8Kfr01RPPBXEWjXXk=
X-Google-Smtp-Source: AGHT+IH0ExYqIBIG65vPcoT3DiNCO/ffAaeFUTJey4ev21imvkdenToERs6JxgJGYCVymJAxVxO6o81Q1Km8Zl9XVl4=
X-Received: by 2002:a17:902:f70d:b0:268:cc5:5e44 with SMTP id
 d9443c01a7336-28e8003e0b6mr5289075ad.6.1759336287136; Wed, 01 Oct 2025
 09:31:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250926163114.2626257-1-seanjc@google.com> <20250926163114.2626257-2-seanjc@google.com>
 <CA+EHjTzdX8+MbsYOHAJn6Gkayfei-jE6Q_5HfZhnfwnMijmucw@mail.gmail.com>
 <diqz7bxh386h.fsf@google.com> <a4976f04-959d-48ae-9815-d192365bdcc6@linux.dev>
 <d2fa49af-112b-4de9-8c03-5f38618b1e57@redhat.com> <diqz4isl351g.fsf@google.com>
 <aNq6Hz8U0BtjlgQn@google.com> <aNshILzpjAS-bUL5@google.com>
 <CAGtprH_JgWfr2wPGpJg_mY5Sxf6E0dp5r-_4aVLi96To2pugXA@mail.gmail.com> <aN1TgRpde5hq_FPn@google.com>
In-Reply-To: <aN1TgRpde5hq_FPn@google.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Wed, 1 Oct 2025 09:31:14 -0700
X-Gm-Features: AS18NWCwG4Tg7c_g0xW6dmjiFJ7MkHG5Ng3nKWTTgLI8yGDTRQhsFalbbDRtIlI
Message-ID: <CAGtprH-0B+cDARbK-xPGfx4sva+F1akbkX1gXts2VHaqyDWdzA@mail.gmail.com>
Subject: Re: [PATCH 1/6] KVM: guest_memfd: Add DEFAULT_SHARED flag, reject
 user page faults if not set
To: Sean Christopherson <seanjc@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>, David Hildenbrand <david@redhat.com>, 
	Patrick Roy <patrick.roy@linux.dev>, Fuad Tabba <tabba@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Nikita Kalyazin <kalyazin@amazon.co.uk>, shivankg@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 1, 2025 at 9:15=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Wed, Oct 01, 2025, Vishal Annapurve wrote:
> > On Mon, Sep 29, 2025 at 5:15=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > Oh!  This got me looking at kvm_arch_supports_gmem_mmap() and thus
> > > KVM_CAP_GUEST_MEMFD_MMAP.  Two things:
> > >
> > >  1. We should change KVM_CAP_GUEST_MEMFD_MMAP into KVM_CAP_GUEST_MEMF=
D_FLAGS so
> > >     that we don't need to add a capability every time a new flag come=
s along,
> > >     and so that userspace can gather all flags in a single ioctl.  If=
 gmem ever
> > >     supports more than 32 flags, we'll need KVM_CAP_GUEST_MEMFD_FLAGS=
2, but
> > >     that's a non-issue relatively speaking.
> > >
> >
> > Guest_memfd capabilities don't necessarily translate into flags, so ide=
ally:
> > 1) There should be two caps, KVM_CAP_GUEST_MEMFD_FLAGS and
> > KVM_CAP_GUEST_MEMFD_CAPS.
>
> I'm not saying we can't have another GUEST_MEMFD capability or three, all=
 I'm
> saying is that for enumerating what flags can be passed to KVM_CREATE_GUE=
ST_MEMFD,
> KVM_CAP_GUEST_MEMFD_FLAGS is a better fit than a one-off KVM_CAP_GUEST_ME=
MFD_MMAP.

Ah, ok. Then do you envision the guest_memfd caps to still be separate
KVM caps per guest_memfd feature?

>
> > 2) IMO they should both support namespace of 64 values at least from th=
e get go.
>
> It's a limitation of KVM_CHECK_EXTENSION, and all of KVM's plumbing for i=
octls.
> Because KVM still supports 32-bit architectures, direct returns from ioct=
ls are
> forced to fit in 32-bit values to avoid unintentionally creating differen=
t ABI
> for 32-bit vs. 64-bit kernels.
>
> We could add KVM_CHECK_EXTENSION2 or KVM_CHECK_EXTENSION64 or something, =
but I
> honestly don't see the point.  The odds of guest_memfd supporting >32 fla=
gs is
> small, and the odds of that happening in the next ~5 years is basically z=
ero.
> All so that userspace can make one syscall instead of two for a path that=
 isn't
> remotely performance critical.
>
> So while I agree that being able to enumerate 64 flags from the get-go wo=
uld be
> nice to have, it's simply not worth the effort (unless someone has a clev=
er idea).

Ack.

>
> > 3) The reservation scheme for upstream should ideally be LSB's first
> > for the new caps/flags.
>
> We're getting way ahead of ourselves.  Nothing needs KVM_CAP_GUEST_MEMFD_=
CAPS at
> this time, so there's nothing to discuss.
>
> > guest_memfd will achieve multiple features in future, both upstream
> > and in out-of-tree versions to deploy features before they make their
>
> When it comes to upstream uAPI and uABI, out-of-tree kernel code is irrel=
evant.
>
> > way upstream. Generally the scheme followed by out-of-tree versions is
> > to define a custom UAPI that won't conflict with upstream UAPIs in
> > near future. Having a namespace of 32 values gives little space to
> > avoid the conflict, e.g. features like hugetlb support will have to
> > eat up at least 5 bits from the flags [1].
>
> Why on earth would out-of-tree code use KVM_CAP_GUEST_MEMFD_FLAGS?   Prov=
iding

I can imagine a scenario where KVM_CAP_GUEST_MEMFD_FLAGS is upstreamed
and more flags landing in KVM_CAP_GUEST_MEMFD_FLAGS as supported over
time afterwards. out-of-tree code may ingest KVM_CAP_GUEST_MEMFD_FLAGS
in between.

> infrastructure to support an infinite (quite literally) number of out-of-=
tree
> capabilities and sub-ioctls, with practically zero chance of conflict, is=
 not
> difficult.  See internal b/378111418.
>
> But as above, this is not upstream's problem to solve.
>
> > [1] https://elixir.bootlin.com/linux/v6.17/source/include/uapi/asm-gene=
ric/hugetlb_encode.h#L20

