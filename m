Return-Path: <kvm+bounces-50912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 98CD9AEA923
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 23:59:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E078A168781
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 21:59:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B535D2609CD;
	Thu, 26 Jun 2025 21:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oHTITVD7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665142CCC0
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 21:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750975147; cv=none; b=cnr5ZBeZMV0rn9nfA4Gw6DWqbQrcVxCdTuJouVzzprtVN4SDdlKWxsdJhHJt7vQEiDvLXp6XjON5VeC54NdcdMNXdwjhwtj7PPCuUFzPPTVKbJCMjXGZZA5ShUjYNxlxeZqs8esnWdm7xQP2Q84bMdRsK3ukn4dGPii5+CGkQso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750975147; c=relaxed/simple;
	bh=obQmm89sHJZlTdA6a3q+yZdq1d5rrXE2Jz29qLtJn3E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C7xTQQRL7FTt4+zYT6X2QYFCdOBHUzq4AsKyqN9Rz9RdOU2QGNL0m4ku5fV3CN7VnclQFnx1IKqZnY++Sbzy+RMgPnVhYLZLUd9MQ+o3lLE83gtn5IUkpNzwPT/J7akgLDSA+fFbKOSNZCYLlwZEJYNAgzPgiA7CnpCN533eIn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oHTITVD7; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3df371e1d29so34205ab.0
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 14:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750975145; x=1751579945; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=13jMxa+tWKfbidw+MIbY7IsOcYdrPlSsoL40EvqAfc4=;
        b=oHTITVD7kRDt8u0fKPgZEC39KjmGHverZcW9KMGgkOf+NAL0uA6jtS5QS1V/cQqjHg
         HA8TXcArrk+0pqr5QvExggr/hmUhVEzzjZA4fBFbRHpHJX+hY0k1ZjQoecogdWUYKXpw
         /qMF2+XQttCG5ae1uO37QLE1Dt56Lbpzf5olssmXRbgG6yyuE74RaolKKqJguMkCnLtD
         qSPxnx0aRAMaYrqF4TFKN48V+Yg8tfbUgZLE3r+3abk2S3RSFofbpPUptQUJ+jlcXMHO
         ZVdlWwAIcjHaPstMC7Q9M1hrzM+D8dBpCSMKhHXfNPUeSIwOSrEI1hP3MeRZUX+xq246
         2Log==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750975145; x=1751579945;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=13jMxa+tWKfbidw+MIbY7IsOcYdrPlSsoL40EvqAfc4=;
        b=EngvBUdGnmQQjJYTvU5yloqdTBwvCcznxjBs/eyxy9iBbIbppDL272GGhSQO/3tH0X
         LGzw6UnaClcj14TLTN9VIU0QtRKLPVTyViNTvBzdrkPNGIvIrkkun3xPzlAqL15apbM9
         IEjtPsaKmtFTook+SjX8WIm74ehdhOr8Mq5mWYpWoB7YkeFz3JUOSS94OnCLAKS+4J6Y
         FZF7628bX0wtJJgTD8B6faAx8Xcb/5sSboIM4wzZ1U7WX5Y9sphE+1Bp8pMsLrN3x3RB
         SfdBp8Mwg2PSId3a9MRGsgS9g0EjhI5vz6yuabWFZLn1lPX/Fc1DDcD1XQT6Ziu4GBYG
         HA3w==
X-Forwarded-Encrypted: i=1; AJvYcCWU2pn1xfTnHDjmpvFUGM288tRwsCQo5gnECVR1dPwvdDoNpQPvInWrCjEG0ppM+6pQLvU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMP/gLZwV7Lxwo6zFWcy5cWdFULHuLAlo8fF47W4JFibNGYnBQ
	kErfoTBL2vfVteQ80mnhsKES7lQO1B4eDDeQUNsx7mKgf9Q5iEraGrbQ7LmTXXFF7eSTyUn9cxA
	qRF2E1TbwzT+85yRrwS7dtqOidIy7ZxELm2Mie1pz
X-Gm-Gg: ASbGncveLp4dWIGwDArqgqzcGScqjJGN2bG2RugCeocJ/GPLS/O0nw1KAZNezObg51T
	nusRdH2eknI9Mu6eM2/RlVPcyy3qnmrYBSeBGBg+afFNjHWfd4vTxNWdL62AjltkPtHghg9g9Hk
	JHbuTnKDIijCw9861pix3g/29EWh1h+v/vrvt6uqsVl5A=
X-Google-Smtp-Source: AGHT+IG4n9eXR6ybxAnU6jeGEqP805pU5TFety3i32Qs18spNvUZbfl9LuAAyndcMq2oM87xXeAluTvADa8FCP+vEQU=
X-Received: by 2002:a05:6e02:17cc:b0:3df:28c7:1571 with SMTP id
 e9e14a558f8ab-3df4c0397b4mr455725ab.5.1750975145147; Thu, 26 Jun 2025
 14:59:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250626180424.632628-1-aaronlewis@google.com>
 <20250626132659.62178b7d.alex.williamson@redhat.com> <20250626205608.GO167785@nvidia.com>
In-Reply-To: <20250626205608.GO167785@nvidia.com>
From: Aaron Lewis <aaronlewis@google.com>
Date: Thu, 26 Jun 2025 14:58:54 -0700
X-Gm-Features: Ac12FXwjDBJ-oqWF1VQAEvTL442XCFFD_RX_fSkEu4kj8r1RE2sKytrGv8ejzkM
Message-ID: <CAAAPnDHa249E381EYjaJUna4N_EsY2AiBcqMEtcuy-raJxgpXw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] vfio: selftests: Add VFIO selftest to demontrate
 a latency issue
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, bhelgaas@google.com, dmatlack@google.com, 
	vipinsh@google.com, kvm@vger.kernel.org, seanjc@google.com, 
	jrhilke@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 26, 2025 at 1:56=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Thu, Jun 26, 2025 at 01:26:59PM -0600, Alex Williamson wrote:
> > On Thu, 26 Jun 2025 18:04:21 +0000
> > Aaron Lewis <aaronlewis@google.com> wrote:
> >
> > > This series is being sent as an RFC to help brainstorm the best way t=
o
> > > fix a latency issue it uncovers.
> > >
> > > The crux of the issue is that when initializing multiple VFs from the
> > > same PF the devices are reset serially rather than in parallel
> > > regardless if they are initialized from different threads.  That happ=
ens
> > > because a shared lock is acquired when vfio_df_ioctl_bind_iommufd() i=
s
> > > called, then a FLR (function level reset) is done which takes 100ms t=
o
> > > complete.  That in combination with trying to initialize many devices=
 at
> > > the same time results in a lot of wasted time.
> > >
> > > While the PCI spec does specify that a FLR requires 100ms to ensure i=
t
> > > has time to complete, I don't see anything indicating that other VFs
> > > can't be reset at the same time.
> > >
> > > A couple of ideas on how to approach a fix are:
> > >
> > >   1. See if the lock preventing the second thread from making forward
> > >   progress can be sharded to only include the VF it protects.
> >
> > I think we're talking about the dev_set mutex here, right?  I think thi=
s
> > is just an oversight.  The original lock that dev_set replaced was
> > devised to manage the set of devices affected by the same bus or slot
> > reset.  I believe we've held the same semantics though and VFs just
> > happen to fall through to the default of a bus-based dev_set.
> > Obviously we cannot do a bus or slot reset of a VF, we only have FLR,
> > and it especially doesn't make sense that VFs on the same "bus" from
> > different PFs share this mutex.
>
> It certainly could be.. But I am feeling a bit wary and would want to
> check this carefully. We ended up using the devset for more things -
> need to check where everything ended up.
>
> Off hand I don't recall any reason why the VF should be part of the
> dev set..
>
> > diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_p=
ci_core.c
> > index 6328c3a05bcd..261a6dc5a5fc 100644
> > --- a/drivers/vfio/pci/vfio_pci_core.c
> > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > @@ -2149,7 +2149,7 @@ int vfio_pci_core_register_device(struct vfio_pci=
_core_device *vdev)
> >               return -EBUSY;
> >       }
> >
> > -     if (pci_is_root_bus(pdev->bus)) {
> > +     if (pci_is_root_bus(pdev->bus) || pdev->is_virtfn) {

That fixes the issue.  I applied this patch and reran the test and
both threads finish in ~100ms now!  We are now getting fully
parallelized resets!

[0x7fd12afc0700] '0000:17:0c.2' initialized in 102.3ms.
[0x7fd12b7c1700] '0000:17:0c.1' initialized in 102.4ms.

> >               ret =3D vfio_assign_device_set(&vdev->vdev, vdev);
> >       } else if (!pci_probe_reset_slot(pdev->slot)) {
> >               ret =3D vfio_assign_device_set(&vdev->vdev, pdev->slot);
> >
> > Does that allow fully parallelized resets?
>
> I forget all the details but if we are sure the reset of a VF is only
> the VF then that does seem like the right direction
>
> Jason

Alex, would you like me to include your patch in this series so we
have the fix and test together, or would you prefer to propose the fix
yourself?  Either way works for me.

