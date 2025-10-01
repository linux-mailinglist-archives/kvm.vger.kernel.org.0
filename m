Return-Path: <kvm+bounces-59338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4541DBB1567
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 19:16:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA0FB2A563C
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 17:16:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52D5D2D323D;
	Wed,  1 Oct 2025 17:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TKRrd63P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B242226CF6
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 17:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759338981; cv=none; b=iCXAFPTpnw4yImO1lBhB6hvFQQpJ2T8FOoK/+Uioedk/Q3oOz/+oDbvW5mjk/vNCPiMQabwbY2HMluhZssrYAimynASf1Xy9q2G/7HEVhOkF7zkUFlSflMH+CfsOhx0vjq+ioEj+U5kkJAzfPXTW0/vcPIOyS2kXShzSDGCf8oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759338981; c=relaxed/simple;
	bh=BU0iCG0Wn7FDxsjZpRitcTVVnTYoIX9uyhwNv3w1DQI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iLtsSHM3LUgI7XDkcA1ZWCm7LJIxzYa58Jn/vySa+B3A4fbCFGaKboVxgROKnmcApQ7L8ss0yt3R9+55IrFC3kxoLsLodV6ni+YD3PNyl0V6bTcWzVIaxoRce/OV6GgWUEcUAG+nbNXS9XVijDXxRmJNqwZFWvk8TpRL5sJI8RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TKRrd63P; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b54ad69f143so81360a12.1
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 10:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759338979; x=1759943779; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4ICohWyZWW3dghRAJfnyRv8OgV+aajXymuvEfhCyvZ0=;
        b=TKRrd63PFYhpOJ97KcMHgfOeL8xPTOXkkckAxOnYaXdheXUfcyRbr7LcW4HurFp6/1
         fHjQjmZ43n6XFgjgSTXlQzT9CM8I/EAPb1V6TehN4VJxgSK9pXXvx2r52kNXcaejXccy
         sO/kngakKHqxJqS497wNIW4+F5AmlefQux3nlgZZ/NArbD0HsVRQ8kU/IN7wMVURbinP
         7ZwsBJZZFz8ZK3PB1JBhknh8XjWVDJeCZMblGoaNBFyRuSHmMKuDwEuCxOfhGPdHTS5M
         x9XzkkVfmAQuBjTvRTAzP7gkVKBNNK7i9eCjnbFN35sIhmK6+cVCFfu+N6YCA3fSVXS8
         LigA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759338979; x=1759943779;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4ICohWyZWW3dghRAJfnyRv8OgV+aajXymuvEfhCyvZ0=;
        b=rgxD4ZGM37YbgGFZOgasd3EYfEVeuVwG6a1HHd/nj1SpCVpveBSBqB0Zf68OvTa3Ad
         AYgYpFvTTdjHMC/EkoaaSlM8ggYr3+SUyxfxQgdy2EPY9Kx2mfa8KxsDLkXcsDhF7Gi9
         HxA9ixUC78RLTvuxMrGRyTjZ90OWsaRLXMjddg6fXYj+XpHGxqHlJvy5I3pI5jk2d5P/
         6u4g7yT+5uwSXVgQDR8VEGM9rDpja9/nhS+rv9nMdqNt6pKwFpy3YaUjNewRibuBMp6Q
         iMEQwEcHuPPzwB8DJ10Rpy5WvMgWuEMMHsFOCN9dpEu7zEu5JAXuNq7SaV0rhD6PGtkw
         yGtA==
X-Forwarded-Encrypted: i=1; AJvYcCXrPaJVXNPx3pdztMPL3xGV6rABDiGtLKcQsxxLtnb81Zootb1bXwLnu3Ru/C0fc2aGkiI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8s15o9Dz41R54UAibX4493yn6j0c8bBx3G7MYrgyAjutDt6oC
	IQ/Ygg7dQo7OiaM4x1maiFGlWDrMcbru+OYr0T9XdCKagM5ykDxD1PY6RyWiEoiIfbdaPOvdpAX
	S45L5CA==
X-Google-Smtp-Source: AGHT+IF8XxTPJPnhJV6cEfh65/DuXZ5l5db3pgS80gNyNI0nsre7FBM2PokXsB4xATcgCCV21X0DcrZFodU=
X-Received: from pldm6.prod.google.com ([2002:a17:902:db86:b0:267:e559:12b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:15ce:b0:265:47:a7bd
 with SMTP id d9443c01a7336-28e7f28dfbemr49380785ad.4.1759338979403; Wed, 01
 Oct 2025 10:16:19 -0700 (PDT)
Date: Wed, 1 Oct 2025 10:16:17 -0700
In-Reply-To: <CAGtprH-0B+cDARbK-xPGfx4sva+F1akbkX1gXts2VHaqyDWdzA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CA+EHjTzdX8+MbsYOHAJn6Gkayfei-jE6Q_5HfZhnfwnMijmucw@mail.gmail.com>
 <diqz7bxh386h.fsf@google.com> <a4976f04-959d-48ae-9815-d192365bdcc6@linux.dev>
 <d2fa49af-112b-4de9-8c03-5f38618b1e57@redhat.com> <diqz4isl351g.fsf@google.com>
 <aNq6Hz8U0BtjlgQn@google.com> <aNshILzpjAS-bUL5@google.com>
 <CAGtprH_JgWfr2wPGpJg_mY5Sxf6E0dp5r-_4aVLi96To2pugXA@mail.gmail.com>
 <aN1TgRpde5hq_FPn@google.com> <CAGtprH-0B+cDARbK-xPGfx4sva+F1akbkX1gXts2VHaqyDWdzA@mail.gmail.com>
Message-ID: <aN1h4XTfRsJ8dhVJ@google.com>
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
> On Wed, Oct 1, 2025 at 9:15=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > On Wed, Oct 01, 2025, Vishal Annapurve wrote:
> > > On Mon, Sep 29, 2025 at 5:15=E2=80=AFPM Sean Christopherson <seanjc@g=
oogle.com> wrote:
> > > >
> > > > Oh!  This got me looking at kvm_arch_supports_gmem_mmap() and thus
> > > > KVM_CAP_GUEST_MEMFD_MMAP.  Two things:
> > > >
> > > >  1. We should change KVM_CAP_GUEST_MEMFD_MMAP into KVM_CAP_GUEST_ME=
MFD_FLAGS so
> > > >     that we don't need to add a capability every time a new flag co=
mes along,
> > > >     and so that userspace can gather all flags in a single ioctl.  =
If gmem ever
> > > >     supports more than 32 flags, we'll need KVM_CAP_GUEST_MEMFD_FLA=
GS2, but
> > > >     that's a non-issue relatively speaking.
> > > >
> > >
> > > Guest_memfd capabilities don't necessarily translate into flags, so i=
deally:
> > > 1) There should be two caps, KVM_CAP_GUEST_MEMFD_FLAGS and
> > > KVM_CAP_GUEST_MEMFD_CAPS.
> >
> > I'm not saying we can't have another GUEST_MEMFD capability or three, a=
ll I'm
> > saying is that for enumerating what flags can be passed to KVM_CREATE_G=
UEST_MEMFD,
> > KVM_CAP_GUEST_MEMFD_FLAGS is a better fit than a one-off KVM_CAP_GUEST_=
MEMFD_MMAP.
>=20
> Ah, ok. Then do you envision the guest_memfd caps to still be separate
> KVM caps per guest_memfd feature?

Yes?  No?  It depends on the feature and the actual implementation.  E.g.
KVM_CAP_IRQCHIP enumerates support for a whole pile of ioctls.

