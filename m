Return-Path: <kvm+bounces-59326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B4E44BB13AD
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 18:15:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31ED84C3C82
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 16:15:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8DB12857C7;
	Wed,  1 Oct 2025 16:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HPDwwCZ4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192162749CF
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 16:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759335336; cv=none; b=Ye++EZuR0H6AxbQiUcdKTME00vjefIl4ht+P5L2ahH7m/6/v90yQWOElefpXRA1Qj3vDy6PGRhlIuJMOQaOeWd3ZWlQlrCbAKuddAWAGIezDvIB22tg1XkhhY3R5DzdiSo2VvKG+euxT7eHIrCPA3LttrSvgC++XDVtUywBVK4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759335336; c=relaxed/simple;
	bh=LkT3cQyzUP8PrJPHTEYebA8l9D+znF7mvx2yHe3Bzk8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TrelERpfY6Fzjt1jh0D1WBPPJpof2p02Nw3GSEyhiD5ziYTz+9TMt9vgK/gBvWGxPv1P1nj6CxhPQgskSMg1e/fJq3CKpxLMwR+ll/6rufnQn4ft0jaxp2botIM7vrlnszRyGALQLnVloUMEAxoPp+Z1ik1tv8yfr0A/pwZJuBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HPDwwCZ4; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-28bd8b3fa67so35780725ad.2
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 09:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759335334; x=1759940134; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iAee651rAQS/C/Qwa2CpN1beksC4sJ/ZDg6HvycKd2g=;
        b=HPDwwCZ48RnPdUCFdD+U/gwiKLtzqTPWvyI/UECO+BYP6IC3TcjUGC046GBIlYnwp5
         nNbFpIfeQwIn3vH+stuaVdHnwWoD1cDoUzhYmJSoa9cubkdHuJ58UFvmG496xJP7qSWX
         0JplsjYQecVcL0MIvweLS5I2E8z8rtR3EbGPaJczo4eIzc93QPHJ14KBvfug+iwFJQbi
         fwMcZU6n6S52ObQo3CJZe3a27I7JxKPmlu2cX81MczyAUjn7WB90fZp0O1lfNv5GMb8x
         lndmEAH3zrGi+VA1XdRKqVrVa28ZrUYxMhXU7eHc/tlPzhabU7/O7T4Xt58vXJqQKIFF
         LfoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759335334; x=1759940134;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iAee651rAQS/C/Qwa2CpN1beksC4sJ/ZDg6HvycKd2g=;
        b=INW3GbDOI5LDB5K2xMAx30lNbEn33wxJGmIz+Wb3nv67rm+fpUvfbSVlog5JCd/ALB
         m85jTWxG70CldClkca1BsGEf+gzcVz/jSvoZ2pQsLasG7tylEOvPw1sobgUF4pL0hoOY
         j8qmDYzdcBGxYQsP0B9jyoB8frl6HFMexgoSyWXMCz/YIeJ9iIISXbCMCZP+SvSIak7y
         v6MPeYeyrkc98dXNXRjvvlwZ2G75TD5YK531pT/AB6CvPoWj0LiWoqcWSEL5dzo7nt34
         g5AFL/JoawRLlyx/lTmC1g6qzEZk3GKnnG95FeAV4W7S/OtfUxalv776bF8xQMZHLXSN
         F59g==
X-Forwarded-Encrypted: i=1; AJvYcCX7yMbnLMmpPdUE8lI1ASC9OM1LZ/jZazF2j6Z2zNttp6NGUA5tOZfRPtMKVCsadLMN7nU=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywm711unLxPm1YVwgr+YvPQv+tgNFQruOQOQE94a0qr2czw33zc
	uGQTbNvosmSaYvyNDSTI2gFXZei4VbJqyJL8eh8TGVw5khpzXQSsPLmezobg0wZ3z5u9pXKUzoE
	GazAp4A==
X-Google-Smtp-Source: AGHT+IFT9qvjDww9U012OeW5sqCPQWLNIV0YHoXictQooBDBzTabAydQhDyqW9+2yml0/Q14YFKLLVp8/eY=
X-Received: from pjbgd14.prod.google.com ([2002:a17:90b:fce:b0:32b:8b8d:c2ba])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2384:b0:264:befb:829c
 with SMTP id d9443c01a7336-28e7f2a11eamr47188085ad.9.1759335334236; Wed, 01
 Oct 2025 09:15:34 -0700 (PDT)
Date: Wed, 1 Oct 2025 09:15:32 -0700
In-Reply-To: <CAGtprH_JgWfr2wPGpJg_mY5Sxf6E0dp5r-_4aVLi96To2pugXA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250926163114.2626257-1-seanjc@google.com> <20250926163114.2626257-2-seanjc@google.com>
 <CA+EHjTzdX8+MbsYOHAJn6Gkayfei-jE6Q_5HfZhnfwnMijmucw@mail.gmail.com>
 <diqz7bxh386h.fsf@google.com> <a4976f04-959d-48ae-9815-d192365bdcc6@linux.dev>
 <d2fa49af-112b-4de9-8c03-5f38618b1e57@redhat.com> <diqz4isl351g.fsf@google.com>
 <aNq6Hz8U0BtjlgQn@google.com> <aNshILzpjAS-bUL5@google.com> <CAGtprH_JgWfr2wPGpJg_mY5Sxf6E0dp5r-_4aVLi96To2pugXA@mail.gmail.com>
Message-ID: <aN1TgRpde5hq_FPn@google.com>
Subject: Re: [PATCH 1/6] KVM: guest_memfd: Add DEFAULT_SHARED flag, reject
 user page faults if not set
From: Sean Christopherson <seanjc@google.com>
To: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>, David Hildenbrand <david@redhat.com>, 
	Patrick Roy <patrick.roy@linux.dev>, Fuad Tabba <tabba@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Nikita Kalyazin <kalyazin@amazon.co.uk>, shivankg@amd.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 01, 2025, Vishal Annapurve wrote:
> On Mon, Sep 29, 2025 at 5:15=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > Oh!  This got me looking at kvm_arch_supports_gmem_mmap() and thus
> > KVM_CAP_GUEST_MEMFD_MMAP.  Two things:
> >
> >  1. We should change KVM_CAP_GUEST_MEMFD_MMAP into KVM_CAP_GUEST_MEMFD_=
FLAGS so
> >     that we don't need to add a capability every time a new flag comes =
along,
> >     and so that userspace can gather all flags in a single ioctl.  If g=
mem ever
> >     supports more than 32 flags, we'll need KVM_CAP_GUEST_MEMFD_FLAGS2,=
 but
> >     that's a non-issue relatively speaking.
> >
>=20
> Guest_memfd capabilities don't necessarily translate into flags, so ideal=
ly:
> 1) There should be two caps, KVM_CAP_GUEST_MEMFD_FLAGS and
> KVM_CAP_GUEST_MEMFD_CAPS.

I'm not saying we can't have another GUEST_MEMFD capability or three, all I=
'm
saying is that for enumerating what flags can be passed to KVM_CREATE_GUEST=
_MEMFD,
KVM_CAP_GUEST_MEMFD_FLAGS is a better fit than a one-off KVM_CAP_GUEST_MEMF=
D_MMAP.

> 2) IMO they should both support namespace of 64 values at least from the =
get go.

It's a limitation of KVM_CHECK_EXTENSION, and all of KVM's plumbing for ioc=
tls.
Because KVM still supports 32-bit architectures, direct returns from ioctls=
 are
forced to fit in 32-bit values to avoid unintentionally creating different =
ABI
for 32-bit vs. 64-bit kernels.

We could add KVM_CHECK_EXTENSION2 or KVM_CHECK_EXTENSION64 or something, bu=
t I
honestly don't see the point.  The odds of guest_memfd supporting >32 flags=
 is
small, and the odds of that happening in the next ~5 years is basically zer=
o.
All so that userspace can make one syscall instead of two for a path that i=
sn't
remotely performance critical.

So while I agree that being able to enumerate 64 flags from the get-go woul=
d be
nice to have, it's simply not worth the effort (unless someone has a clever=
 idea).

> 3) The reservation scheme for upstream should ideally be LSB's first
> for the new caps/flags.

We're getting way ahead of ourselves.  Nothing needs KVM_CAP_GUEST_MEMFD_CA=
PS at
this time, so there's nothing to discuss.

> guest_memfd will achieve multiple features in future, both upstream
> and in out-of-tree versions to deploy features before they make their

When it comes to upstream uAPI and uABI, out-of-tree kernel code is irrelev=
ant.

> way upstream. Generally the scheme followed by out-of-tree versions is
> to define a custom UAPI that won't conflict with upstream UAPIs in
> near future. Having a namespace of 32 values gives little space to
> avoid the conflict, e.g. features like hugetlb support will have to
> eat up at least 5 bits from the flags [1].

Why on earth would out-of-tree code use KVM_CAP_GUEST_MEMFD_FLAGS?   Provid=
ing
infrastructure to support an infinite (quite literally) number of out-of-tr=
ee
capabilities and sub-ioctls, with practically zero chance of conflict, is n=
ot
difficult.  See internal b/378111418.

But as above, this is not upstream's problem to solve.

> [1] https://elixir.bootlin.com/linux/v6.17/source/include/uapi/asm-generi=
c/hugetlb_encode.h#L20

