Return-Path: <kvm+bounces-46643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F173BAB7D13
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 07:40:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 924BB1BA6102
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 05:41:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30085286D56;
	Thu, 15 May 2025 05:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="V2oFhZXf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59201B3955
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 05:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747287649; cv=none; b=XGL8SwqVnhBPGjPyms9TrBPaRQQL5fUHb7x3RY16v9yQLA6HM+c6JpWyTMsFTGSUr9pj+jTnsll7oCKGsU9SJEpCKDxp51byJEglnv6WPZGDiOY0a45/9/bmCEskMdhgKTtGft1UIIGjLYgKyb2yw9dmrFliF8Bul9btU/qmwoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747287649; c=relaxed/simple;
	bh=uZ03ovrsaV/oectkcsY8eo0Gp96WfQfn2ObNxL8evqs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SNPVVvEylSxOD8w/8Xem0DszC5W2VuNsREj8Arumw+0Jw1aT4BvMxP7q43metyC7QLeE0g62HVlbvv2dEr8RyeE+TC2w4lIvZWhjPwT2MrEuAzsm2FHlbfu1TzR8h34n1oj0L59W3QyALOdjuKAvtX+dpj9PVPw8HOK5kRfddDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=V2oFhZXf; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3d96d16b369so4656195ab.0
        for <kvm@vger.kernel.org>; Wed, 14 May 2025 22:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1747287647; x=1747892447; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uz1T20yidSVCKk3JyCiwZoMyHHxlzlfZ7sxgHG4h3Ms=;
        b=V2oFhZXfWpFBkA7BrH7qJJ1SdCimKZDQD/cyVfxbtjihKadt+JuwXDgYcBfyeOjo5t
         NAq1s4cVu/s/WGIs3pz1qQhGAgyyESlu/SBE/GHy8BdCV3uYNXhdkyDViZyC0RqrjQSO
         YlvuRxBM6OU7JFyNjSyoHqX7ZhHZHMhfTp+RxtOq92PZUAjakSG6hPFSGKn+kwDyBv8K
         6rPweHBukcdMhWzm1tlyuENXEFoL6dX1KQlY6xD3iG7vFPewTl4qJ8hXMN60FdQtkb4r
         7L8VVzDk7/27WxuhzoiSmyHONHyTUq8P//Xo8uefdbe/x6mM5bhOZeMbeTahMaZ9PFnT
         1uxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747287647; x=1747892447;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uz1T20yidSVCKk3JyCiwZoMyHHxlzlfZ7sxgHG4h3Ms=;
        b=Qpae48Tm1ppdSh8AuymK5WKHq07vv0FmP7OO4pt+3sjgv9LfIdmmgpv5vNrGkZwNQ9
         K5lEHZi7oLroS5jTsi0Lqatgp6XbOC62OPwPeKlQ7Vqup97Hfgo1xZwlrXBkrUt/Ni57
         +IqMM1KL1Z9k+jNi1Ocbd8e09sKx6m3DS2VeQbmYcf0eH6vnXm5vqdFSUP2FT29fz5To
         ygCQOg/XCO+CoKXcPv+qvzPKql8MfvW8/9wxtZYZf41dDwV3pQjA8mjdadk8kwIVSA2a
         6ua/qiylozY53zJDW3EJm3Btx3INMVcTm+AKd/S1p76RNAN5dtEyc5vV58wFZuPEevFO
         sszA==
X-Forwarded-Encrypted: i=1; AJvYcCXN7HLfQpdENEIuPrvoudz9WFTklrLwFYdXZZw2XTVvr1bT/CRRwc58bCbqmPT/QQFDuUM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiF5B39ajeet3L3Pu0Dn8ldR4UqK9qw4Rcjt8bSfdZ1ARFIV7/
	YfItF9wjxkc2BeOsJ8SVWYOW8B3ktcBuZL5NZnxm5Ahr7VP1L1ku+O04jXuAVqrGTKBBhU3NhlW
	malYO6q9eaJ9iSSd4etZTJcLU2+fV+5pKfABjCtnxOATKirSx
X-Gm-Gg: ASbGnctSVLIqZFpjdDUhJgXio++o+e22IZDtQOK+017pmnKkGamQk5KnieizOzhoIlL
	PQcurOvNQj5dbyAgr1n0aSectKtrTnS72cecdtLMvhg52/fMLS0Y84VkNcRQ98SBypmr7S8+B2Q
	va/XIsRUY0YVzLODYwNFi8mOLfAOPspig=
X-Google-Smtp-Source: AGHT+IFTDygqebxFrfLhPNX+H4Kgt8uWXhKH50xWzqmnoJDcPg0UVlggjxomSWbuTCti64Fu8NXM5RNuQ470N3l+oyw=
X-Received: by 2002:a05:6e02:1fc6:b0:3d9:39f3:f250 with SMTP id
 e9e14a558f8ab-3db6f794c00mr72097505ab.3.1747287646677; Wed, 14 May 2025
 22:40:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250513-fix_scounteren_vs-v1-1-c1f52af93c79@rivosinc.com>
 <CAAhSdy2LbLwRxuFVtMrrcTTD5NCxVCGLy4o=ZUowxT_9DXGqBA@mail.gmail.com> <CAHBxVyHXJYDWbfY7FAEBB0S0ZG2+ka6KpWpd7+NO9jhApxav5g@mail.gmail.com>
In-Reply-To: <CAHBxVyHXJYDWbfY7FAEBB0S0ZG2+ka6KpWpd7+NO9jhApxav5g@mail.gmail.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 15 May 2025 11:10:34 +0530
X-Gm-Features: AX0GCFvhFxNwn3sOoUM6uFOgfx0BZ3COs0Idy6xZaupJBYExW9VxrohdUkojQQE
Message-ID: <CAAhSdy2DG0y3r8T=AqJ-T7+VaVcVpY0pSRZDptfYwwknshB+zg@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Disable instret/cycle for VU mode by default
To: Atish Kumar Patra <atishp@rivosinc.com>
Cc: Atish Patra <atishp@atishpatra.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2025 at 2:31=E2=80=AFAM Atish Kumar Patra <atishp@rivosinc.=
com> wrote:
>
> On Wed, May 14, 2025 at 3:55=E2=80=AFAM Anup Patel <anup@brainfault.org> =
wrote:
> >
> > On Wed, May 14, 2025 at 12:13=E2=80=AFPM Atish Patra <atishp@rivosinc.c=
om> wrote:
> > >
> > > The KVM virtualizes PMU in RISC-V and disables all counter access exc=
ept
> > > TM bit by default vi hstateen CSR. There is no benefit in enabling CY=
/TM
> > > bits in scounteren for the guest user space as it can't be run withou=
t
> > > hcounteren anyways.
> > >
> > > Allow only TM bit which matches the hcounteren default setting.
> > >
> > > Signed-off-by: Atish Patra <atishp@rivosinc.com>
> > > ---
> > >  arch/riscv/kvm/vcpu.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > > index 60d684c76c58..873593bfe610 100644
> > > --- a/arch/riscv/kvm/vcpu.c
> > > +++ b/arch/riscv/kvm/vcpu.c
> > > @@ -146,8 +146,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> > >         if (kvm_riscv_vcpu_alloc_vector_context(vcpu, cntx))
> > >                 return -ENOMEM;
> > >
> > > -       /* By default, make CY, TM, and IR counters accessible in VU =
mode */
> > > -       reset_csr->scounteren =3D 0x7;
> > > +       /* By default, only TM should be accessible in VU mode */
> > > +       reset_csr->scounteren =3D 0x2;
> >
> > Let's remove this as well because the Linux SBI PMU driver
> > does initialize scounteren correctly.
> >
>
> But other guests may not. I thought time should be a basic one that
> should be allowed by default.
>

There is no specification (SBI or Priv spec) which mandates M-mode
or HS-mode to setup S-mode CSRs. Setting scounteren bits (including
TM bit) has always been a HACK or work-around.

It is better to remove scounteren initialization HACK from KVM RISC-V
before more supervisor software starts depending on it.

Regards,
Anup

