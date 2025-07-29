Return-Path: <kvm+bounces-53648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DD5CB151BA
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 18:56:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C0443A1C71
	for <lists+kvm@lfdr.de>; Tue, 29 Jul 2025 16:56:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2CFF298CB7;
	Tue, 29 Jul 2025 16:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ltwG4CV4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493E234CF5
	for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 16:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753808186; cv=none; b=KWxth1hwP+iXCFcX4UsJKvf6+s9O0TotSHzIMHXRMGvwrdZx67YkuXisj1rY3il8zNes4UtXzFL9QZKXvmkjPAQH3+zDFothWwkL4zuWQ28p/7yCpYX1p4nCm8tgC/1mgJMOFK1aMXOHTF8KShG0haMzisShg9RQ2rKvNQMnF0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753808186; c=relaxed/simple;
	bh=kON6HUGmUgYLxRRJ0S8Z3HHLshtp9BfTE/UxoH0kH1s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H8llpgFtf5aQQz2fDJzArSemMo1ctVOufPJ/ldeviI/qjOE/j/Q2srPCd1FAR/eAtcW2vlQDokjbLiCmp8ByPmLreQ7uqZrFYXRSpfWGYHSn6YQeHdCk/62EQp2dGCj6xJMMrESO+d5Z/S7nRS5maweUlBDZiKlVJNvSy1Q6aYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ltwG4CV4; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4ab3ad4c61fso18921cf.0
        for <kvm@vger.kernel.org>; Tue, 29 Jul 2025 09:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753808184; x=1754412984; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1/uIe95x5lZqYdBnQQKG7OEQU1TEeF9VXSEERIroTJo=;
        b=ltwG4CV4REFf5s6g4nXD46D74/avWCGXU6B3Kbe9vEjCdwi+dENRWhkuS7bXP4mJX6
         g977X8ueRO8JLUDe2sxZWacp2aEs5Gs1JdSWrCicuaoHhgp5n65H/jhOSq6Qr9qt3mya
         CU8CrcFUQyJSyPhC6/7HDUMsn/OeBjXOzoxaEoi/D7Lc89KO+5b8ivFdEL+tph1DOVxN
         /Yy9eFXP0QgeClh0mGcpwsYqSFyop1+Z0SA2QPcKRUlfOhzQNgDn/e8RqBDD6e5EJ2JE
         rXUC/053YjAGAqylQeS0FKv/TOYZAdkxeTIoILaZ1MnW9sgQFxqqy9AdP+alFokNHWXv
         BIgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753808184; x=1754412984;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1/uIe95x5lZqYdBnQQKG7OEQU1TEeF9VXSEERIroTJo=;
        b=v2aGSDWiLUxW6wCL/f4RLyItKf00s/GRvZtqvZYuwsMZndXK2sTpzHdQ741PdIaPMf
         5As6Fb73jrV0ikykkHpQHXDQX5ggaipNE90dKnYTLswkJQfVMx17nbGP+iXEm6v3wnbl
         GsqeSNG3+tITWvLtDd35AI/WOOYt7D1KXBdZE/8UJaSubwakL3QyNhug6YC2bUdnif0P
         +4Ek5nZPjn7hH/iraLEkH/ZbdNhXEINQ+k51L0CuH6/TYPKXaNcgSGtE52remG/s9KDM
         CDuL8bCkipi0VdUhvbPjIu6lH7u/uerdm+TUHl86IzdtMrmYtGKh3pp4vrKjvZbiLT7r
         V62w==
X-Forwarded-Encrypted: i=1; AJvYcCUlTkY7b3I9IXPg3zICYcRiNCpc2hX0LrQXcR3H37Oa1VgRfppMNmn24upGHGiQPUPJNIw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxoVLAxu24LZ+VBBO3qZQEIjfdwb//FYmMf/3wCtiauOJ+tTwwR
	tWFU5tWe9wDF/Fbn1/g2HAt2Q79WopNRjcnM8cFf+DK5HgLkj3F36SOEfkyJs2/sMLe+gISVxU2
	ui08DUC2iZPtqCCJ7pg6HrK8Qbvn6N4dBVTK6ZVXf
X-Gm-Gg: ASbGncuEwElUAa7YX2zPS/Icxi9qjyTKHwiMfYBwOOkK6BHD0LbjVryvXJOWqyY2PJ6
	CLqn724f8B+qNrCcoeKtr9Aytjr5Cn17OlTHNnt2fy4Sw4WWNQ9s/uZopjjCSYFFh1fZG/pHMHc
	aElsptCzktqtxA05T5eJUTCr08OCWzXocWonE3m0LOx940ofDOWql/3IHJ/3tXuXccNJufg4In6
	M2c6ZQ=
X-Google-Smtp-Source: AGHT+IG8U03UpiLYKbtFizbKfv9yB5x8yYCq7RDDBBmKtZwiOn8gG/X4U3tVssvjQCIruMENSE23SwYyH5DXYbZYSsw=
X-Received: by 2002:a05:622a:1884:b0:4a9:e34a:58a1 with SMTP id
 d75a77b69052e-4aecf9d1b90mr4112341cf.21.1753808183683; Tue, 29 Jul 2025
 09:56:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250728223710.129440-1-rananta@google.com> <aIjcmquPNOdE5l4K@linux.dev>
In-Reply-To: <aIjcmquPNOdE5l4K@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 29 Jul 2025 09:56:12 -0700
X-Gm-Features: Ac12FXzGVONWVZtJXMRcendx58YZR793CWu4R9YnCYvWGKAJQzZFsbX55XCdkxs
Message-ID: <CAJHc60xPKgVn96azWhP1NbfKioEZj68APQPf=zKRMuHB7-goqA@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Set/unset vGIC v4 forwarding if direct IRQs
 are supported
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 29, 2025 at 7:37=E2=80=AFAM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hi Raghu,
>
> Thanks for reporting this so quickly :)
>
> On Mon, Jul 28, 2025 at 10:37:10PM +0000, Raghavendra Rao Ananta wrote:
> > diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v=
4.c
> > index e7e284d47a77..873a190bcff7 100644
> > --- a/arch/arm64/kvm/vgic/vgic-v4.c
> > +++ b/arch/arm64/kvm/vgic/vgic-v4.c
> > @@ -433,7 +433,7 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int=
 virq,
> >       unsigned long flags;
> >       int ret =3D 0;
> >
> > -     if (!vgic_supports_direct_msis(kvm))
> > +     if (!vgic_supports_direct_irqs(kvm))
> >               return 0;
> >
> >       /*
> > @@ -533,7 +533,7 @@ int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, i=
nt host_irq)
> >       unsigned long flags;
> >       int ret =3D 0;
> >
> > -     if (!vgic_supports_direct_msis(kvm))
> > +     if (!vgic_supports_direct_irqs(kvm))
> >               return 0;
>
> I'm not sure this is what we want, since a precondition of actually
> doing vLPI injection is the guest having an ITS. Could you try the
> following?
>
> Thanks,
> Oliver
>
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgi=
c-mmio-v3.c
> index a3ef185209e9..70d50c77e5dc 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> @@ -50,6 +50,14 @@ bool vgic_has_its(struct kvm *kvm)
>
>  bool vgic_supports_direct_msis(struct kvm *kvm)
>  {
> +       /*
> +        * Deliberately conflate vLPI and vSGI support on GICv4.1 hardwar=
e,
> +        * indirectly allowing userspace to control whether or not vPEs a=
re
> +        * allocated for the VM.
> +        */
> +       if (system_supports_direct_sgis() && !vgic_supports_direct_sgis(k=
vm))
> +               return false;
> +
>         return kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm);
>  }
>
> diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
> index 1384a04c0784..de1c1d3261c3 100644
> --- a/arch/arm64/kvm/vgic/vgic.h
> +++ b/arch/arm64/kvm/vgic/vgic.h
> @@ -396,15 +396,7 @@ bool vgic_supports_direct_sgis(struct kvm *kvm);
>
>  static inline bool vgic_supports_direct_irqs(struct kvm *kvm)
>  {
> -       /*
> -        * Deliberately conflate vLPI and vSGI support on GICv4.1 hardwar=
e,
> -        * indirectly allowing userspace to control whether or not vPEs a=
re
> -        * allocated for the VM.
> -        */
> -       if (system_supports_direct_sgis())
> -               return vgic_supports_direct_sgis(kvm);
> -
> -       return vgic_supports_direct_msis(kvm);
> +       return vgic_supports_direct_msis(kvm) || vgic_supports_direct_sgi=
s(kvm);
>  }
>
>  int vgic_v4_init(struct kvm *kvm);

Yes, the diff seems fine (tested as well). Would you be pushing a v2
or do you want me to (on your behalf)?

Thank you.
Raghavendra

