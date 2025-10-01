Return-Path: <kvm+bounces-59374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 556E2BB1F4C
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 00:14:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D2C2919C3F1F
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 22:14:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 595262D9ED0;
	Wed,  1 Oct 2025 22:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZRhXDU1k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35A935977
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 22:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759356837; cv=none; b=SVBIUUZH7wb00fhjuc4BSywYbXoWmi7fCqLLe9yLmvfczPjiRx7xt6RJIPNcLChVAHKIA6muTZqVGP7CELJ77SON3m8qCzVjtfrlXQLKJDMfOGjDNRTnNpY4a40I5TZqvYmu+4cYnXxmMb5MZLTIdA1Jx6yIDAR0oMlGTQS9DN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759356837; c=relaxed/simple;
	bh=H0OAOdmyR1ZoRO95yFgAROXm6VgYaxEMWEP38o3+ZTQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jKbz7q0JMZL2fTUBiCZCENonVzIeACQyqwpXYsYQAjkv31j3x+YyS1M4GTTYFivyvpdx2SFGGAcSoGFE+6yankE4U7n5ptr6K4tEOvXF6X4o/uGoGSNiO8WJTnRRnU1dSZd/MqE0Gv3/BMULn+pVIRHnuGrglRneyAURDgBDq1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZRhXDU1k; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2731ff54949so36665ad.1
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 15:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759356835; x=1759961635; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mv+VHJbI5XgvwzaFFCg9rehwr5b6AGY449O1Y14oPG4=;
        b=ZRhXDU1kYeKFPamB6ABCHeH0pYqOENS3eiDagypaE+OXvcjnxBp8o1ehSxR8sYZNTe
         crjk7zdAL9CUf9S4lXJua+2p32AHC3CTEgmvFYQurfDNl1QfWcPEnCGrzKul6Sday7Kp
         vG1OBBvvN7uA3DHtrskSzH9sLa9KkqI3ySZui6oASB3h0LU1j7bYyABXh0KPlzmWy3Tp
         5Nzqnh4roPt3YU2VNj9pBy0z+hE01A55pGlATSEvnyfrDcv7YBhAZtBCqDobKxLpkOQO
         f7X5yVp4hNYie/jG4i487qUg0vpGfXoacJ/HHlObFWtKryqC1cwqwB8fH1WhR3Oh8FAP
         CoGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759356835; x=1759961635;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mv+VHJbI5XgvwzaFFCg9rehwr5b6AGY449O1Y14oPG4=;
        b=LDoGmY9xnZuF4GVewkV7/6Wr7Aj2YI78jMiJi2faxum7F6aCbNvObuoUQ0i6l/bUWY
         w3t1p7up+0JZflKP0wNL3nqB5feXFmtCZRMieFBh89IChAIzQLqorOKKOeEY1F96wEg7
         jJaVK0oCHxEHENYLKhoyVGnPNs7Bp9p0PmpCBWKB/fozUT7fFgLNNTp8Zzx8NtkPZEPx
         WLuE6X4BC5JK3tgXDfPrWmaiKg2D5ZVeVo3oxqWpzlcXd9WTzfkHMk6P8siQifk+zvz+
         T8qVrDqqImUmSGDEbhNIXKOIfr5WnrWaKhz0gMsho5dCN1774s2OrDY6jQswubYw1bV5
         A5hA==
X-Forwarded-Encrypted: i=1; AJvYcCUNAWLQ1Bkzi0l9lO9pad6Ld6gt6CeHg68ylJEcH+qqIgP4hk7gACu/44+nOoNbmGvrZ5Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRb5W+KsrH3+74p6Wl5ZWbaHLMNRTk+601F8cBcLi7lWzEXM0Y
	BW+oNU7N/2L9QXX54nwHBzls9ms7O2Nu0NLM5qtyRxrQ/KWJmLbjE2Q94TYsL0Y+lrmE24F855q
	g4caB0+Jm4OCOibyHmvwNX39iSLzF1RLgDzLgty5Z
X-Gm-Gg: ASbGncvIS6UxS5mU9iZKwnTwNDYLZC4y3mj25yu0GA7UfZfjnRE0NV+lYFu+cjf9CJI
	dk7rvp40Cw+xgSgd06ZsBapnoTXcRLp6wWpq7QS7Rh6IaESFSahdBEr1rB/LrsrbZ5gi3NOJ8VT
	iHppIFIWGYqXJ9QVZMSxGSk03De81Fgi1FDFVup3k73Y7paf98SOcao+iE3NCTlEJ+47hRBBz0o
	KT947EAIEml4Jwubq1hgEcJnxseMXQIPT8pNchaqXeYTHsW0GCcSzn/6mU640zg6uhvOAJ/rqz/
	yDI=
X-Google-Smtp-Source: AGHT+IG9E1JtTvidP583R53j5bBTJPbJF1srG8AqCiJj0EtVLzMHTEtGEhQTJ8NId4KrB33ezdvuuQDjkAxtUmnw9jA=
X-Received: by 2002:a17:903:904:b0:269:63ea:6d3f with SMTP id
 d9443c01a7336-28e8dbd1da2mr2095205ad.8.1759356834777; Wed, 01 Oct 2025
 15:13:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+EHjTzdX8+MbsYOHAJn6Gkayfei-jE6Q_5HfZhnfwnMijmucw@mail.gmail.com>
 <diqz7bxh386h.fsf@google.com> <a4976f04-959d-48ae-9815-d192365bdcc6@linux.dev>
 <d2fa49af-112b-4de9-8c03-5f38618b1e57@redhat.com> <diqz4isl351g.fsf@google.com>
 <aNq6Hz8U0BtjlgQn@google.com> <aNshILzpjAS-bUL5@google.com>
 <CAGtprH_JgWfr2wPGpJg_mY5Sxf6E0dp5r-_4aVLi96To2pugXA@mail.gmail.com>
 <aN1TgRpde5hq_FPn@google.com> <CAGtprH-0B+cDARbK-xPGfx4sva+F1akbkX1gXts2VHaqyDWdzA@mail.gmail.com>
 <aN1h4XTfRsJ8dhVJ@google.com>
In-Reply-To: <aN1h4XTfRsJ8dhVJ@google.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Wed, 1 Oct 2025 15:13:42 -0700
X-Gm-Features: AS18NWAgSpisLEAI2LvYegyGzVLyI5bmHv7KNkJ2hmFok9NUYzPEeQdcIwsVpNQ
Message-ID: <CAGtprH-5NWVVyEM63ou4XjG4JmF2VYNakoFkwFwNR1AnJmiDpA@mail.gmail.com>
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

On Wed, Oct 1, 2025 at 10:16=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, Oct 01, 2025, Vishal Annapurve wrote:
> > On Wed, Oct 1, 2025 at 9:15=E2=80=AFAM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > >
> > > On Wed, Oct 01, 2025, Vishal Annapurve wrote:
> > > > On Mon, Sep 29, 2025 at 5:15=E2=80=AFPM Sean Christopherson <seanjc=
@google.com> wrote:
> > > > >
> > > > > Oh!  This got me looking at kvm_arch_supports_gmem_mmap() and thu=
s
> > > > > KVM_CAP_GUEST_MEMFD_MMAP.  Two things:
> > > > >
> > > > >  1. We should change KVM_CAP_GUEST_MEMFD_MMAP into KVM_CAP_GUEST_=
MEMFD_FLAGS so
> > > > >     that we don't need to add a capability every time a new flag =
comes along,
> > > > >     and so that userspace can gather all flags in a single ioctl.=
  If gmem ever
> > > > >     supports more than 32 flags, we'll need KVM_CAP_GUEST_MEMFD_F=
LAGS2, but
> > > > >     that's a non-issue relatively speaking.
> > > > >
> > > >
> > > > Guest_memfd capabilities don't necessarily translate into flags, so=
 ideally:
> > > > 1) There should be two caps, KVM_CAP_GUEST_MEMFD_FLAGS and
> > > > KVM_CAP_GUEST_MEMFD_CAPS.
> > >
> > > I'm not saying we can't have another GUEST_MEMFD capability or three,=
 all I'm
> > > saying is that for enumerating what flags can be passed to KVM_CREATE=
_GUEST_MEMFD,
> > > KVM_CAP_GUEST_MEMFD_FLAGS is a better fit than a one-off KVM_CAP_GUES=
T_MEMFD_MMAP.
> >
> > Ah, ok. Then do you envision the guest_memfd caps to still be separate
> > KVM caps per guest_memfd feature?
>
> Yes?  No?  It depends on the feature and the actual implementation.  E.g.
> KVM_CAP_IRQCHIP enumerates support for a whole pile of ioctls.

I think I am confused. Is the proposal here as follows?
* Use KVM_CAP_GUEST_MEMFD_FLAGS for features that map to guest_memfd
creation flags.
* Use KVM caps for guest_memfd features that don't map to any flags.

I think in general it would be better to have a KVM cap for each
feature irrespective of the flags as the feature may also need
additional UAPIs like IOCTLs.

I fail to see the benefits of KVM_CAP_GUEST_MEMFD_FLAGS over
KVM_CAP_GUEST_MEMFD_MMAP:
1) It limits the possible values to 32 even though we could pass 64 flags t=
o
the original ioctl.
2) Userspace has to anyways assume the semantics of each bit position.
3) Userspace still has to check for caps for features that carry extra
UAPI baggage.

KVM_CAP_GUEST_MEMFD_MMAP allows userspace to assume that mmap is
supported and userspace can just pass in the mmap flag that it anyways
has to assume.

