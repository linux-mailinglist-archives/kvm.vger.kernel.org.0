Return-Path: <kvm+bounces-66464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F413CD5363
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 09:58:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E7F1A3042FD2
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 08:54:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6A0930CD84;
	Mon, 22 Dec 2025 08:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="eToltyea"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D681EB19B
	for <kvm@vger.kernel.org>; Mon, 22 Dec 2025 08:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766393691; cv=none; b=rwTjFES8+gwpdKxvjBEC1lQDaCttYtTEfhGCRdXkLGz4QnJ8eaNVCnlg9OkT88knYQO57bEGOPfBhcYMWuCFFCmN97OsK7WvIeDkAcUo9rjJkpUAVwz2No+bq3w6YByM8TAZ7zZnUGHgi741EFdJXhNWhG5sEoueyOBQf7Jl69U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766393691; c=relaxed/simple;
	bh=2en1iZ7nN85PhDSwBoJp4wLNTQ3dBiwgQXBspEYRkmc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mvoa/qZImEFH/zkMTzelNUeupupeFViY4xd2nRbXOitXu3yw5X8YjrVbuKMLGZ+L+oHbrp1TWW0WkOnqS9gpIBkcGfyDCfct6nTciZ26dhTSEwbFcJmSjVObjUaI7gMzL1KlT/zv0+RToJgYezez2jetXyjpHlpZLo8ShpjR3Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=eToltyea; arc=none smtp.client-ip=209.85.217.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-5eae7bb8018so1409709137.2
        for <kvm@vger.kernel.org>; Mon, 22 Dec 2025 00:54:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1766393688; x=1766998488; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DjjAwkMD2imy40IRBrToPSHKCp6ZXBS0wOi95O1acFk=;
        b=eToltyeaUOi6KPnYPG0jT0qPugOomvJiKAB4tMuP4inZbfDw96eIorYgPKUnrp2RjS
         fAnvGI/1794iritLf68mpHfPgmkqwEuHWgTH7Zm4+c9msbTRXCuAyHel4kd55MpXNJJV
         1I6SANyUo++djhx2k7VVYsATmOOv+qT4aQuefGjzDLk/yrYsOJ1nuNBNcMNEtSLWfDZn
         /iwVss+rxV/RxBKg6ruhlh639OFKZ6LledNGoptvgFzXrEShJJl6QVjLcWii7nVqkXcA
         WsMnrcTJdCgUsWKxDYR2JGHxEc6CoBkPd5483xlYhK/+h+Kd+xGxypdGjsnXwdgKO5+P
         0uCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766393688; x=1766998488;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DjjAwkMD2imy40IRBrToPSHKCp6ZXBS0wOi95O1acFk=;
        b=a2DbskkdZpysmnceqITNPptXbaKHISkDHsUEKBET1qZUn2US4pTtUQV4qnqnHL7B1z
         HBh7JurX4EgUN2ABw0zdvvw6BaUgatdQxx+NtvJjgHXBSUjKM8nkpybnKNJ0xGny4oQa
         FDktZSHD7xv7P2MACaBJ78UF7+JU+tdWpQa+88aCS0FW67WkfFUrDB46vCG1EHTgh4RS
         QsJiqDuLqiEVT/5jnyCD90r9Q/9dEN/LA2nvR0E8e92v4D6pkSnSXCcv8dQkNvq3Zjxv
         cVehzisLTwvOvOQtIKVWmR2Pg+k5V3LbmrDOeSHe2wFADpy3I70pjLbcmdfDgy9k/eJT
         yryg==
X-Forwarded-Encrypted: i=1; AJvYcCW7Jo7/4YAgJEQVZZvz8RlvR+R62DtQD1XcrICbvQSjSGOq7S3O87enbIhRMDyswac8HUw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwY6m7F3h4YtRx/XXyGaLjCDkH2bFE9LUuj7jCGP6Hpj8MWffdH
	jOPTQRXW5LZEpRv1oGt9X/O+savFQ3KB2jZV9UI4xvPQAFTljOyFBJZ1juut6p033LidlQvhgFX
	HnEiN0nzQ6DyV04iCybJe2i2dEENRBBnjXjqG03k6rKP7a+fFyHZKCD4=
X-Gm-Gg: AY/fxX60/7Va03FkQMqL5ZtXw8YlVHQSQ+SAGQYavehew+UYw+zU+uB0LTMnMl/Ni7H
	sDPpfNI5gtvmvzMhZ2NGEFPkdLSiK0szBF0r1v7Kdt7/1ZvYWMycXFLCR+trGmQkTBhWEZ4CcxI
	lVPnz7z1dwdSUOUlY4fwht1TIHGAt75LdlxtxLhaA2YfqZujYjZAKHRB9v3RVu4EJJ9YyHuMmhz
	bL8xbfY8YqXR93JVD1q9BdaLMDVh4KyKxzWC1rX2XTALs0vfVJSOpn1ZtcOFZjA82tFv/uz+5Oi
X-Google-Smtp-Source: AGHT+IECxbABLBViJLOC0p0+OMMWXiOeS29bWYNP2/R8n3SXGrBWEHPNKMJxAXasPiTotTezNxqtzCtN15d2YuAd2zY=
X-Received: by 2002:a05:6102:c07:b0:5db:f573:a2c with SMTP id
 ada2fe7eead31-5eb1a67d804mr2923800137.13.1766393687811; Mon, 22 Dec 2025
 00:54:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251220163713.34040-1-luxu.kernel@bytedance.com> <CAAhSdy1rHO407BwLtP-s5J1fJtcp2GfvvhtEEpnN2AOn79s8qg@mail.gmail.com>
In-Reply-To: <CAAhSdy1rHO407BwLtP-s5J1fJtcp2GfvvhtEEpnN2AOn79s8qg@mail.gmail.com>
From: Xu Lu <luxu.kernel@bytedance.com>
Date: Mon, 22 Dec 2025 16:54:37 +0800
X-Gm-Features: AQt7F2pkcAOiOlwtxXEG4A39Cprf60Uga7ZPIQ4UoNfpOFWLK7KONbylokDEJEs
Message-ID: <CAPYmKFuNB_iKGtXN815WZvZ5zz8-=NcaLrL0uqS9U4snVZPaTA@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v3] irqchip/riscv-imsic: Adjust the number
 of available guest irq files
To: Anup Patel <anup@brainfault.org>
Cc: atish.patra@linux.dev, pjw@kernel.org, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, alex@ghiti.fr, tglx@linutronix.de, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Roger that!

On Mon, Dec 22, 2025 at 1:04=E2=80=AFPM Anup Patel <anup@brainfault.org> wr=
ote:
>
> On Sat, Dec 20, 2025 at 10:07=E2=80=AFPM Xu Lu <luxu.kernel@bytedance.com=
> wrote:
> >
> > During initialization, kernel maps the MMIO resources of IMSIC, which i=
s
> > parsed from ACPI or DTS and may not strictly contains all guest
> > interrupt files. Page fault happens when KVM wrongly allocates an
> > unmapped guest interrupt file and writes it.
>
> The motivation is not clear from the above text and needs to improve.
>
> How about the following ?
>
> Currently, KVM assumes the minimum of implemented HGEIE bits and
> "BIT(gc->guest_index_bits) - 1" as the number of guest files available
> across all CPUs. This will not work only when CPUs have different number
> of guest files because KVM may incorrectly allocate a guest file on a CPU
> with fewer guest files.
>
> >
> > Thus, during initialization, we calculate the number of available guest
>
> s/Thus, during initialization/To address the above/
>
> > interrupt files according to MMIO resources and constrain the number of
> > guest interrupt files that can be allocated by KVM.
> >
> > Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
> > ---
> >  arch/riscv/kvm/aia.c                    | 2 +-
> >  drivers/irqchip/irq-riscv-imsic-state.c | 7 ++++++-
> >  include/linux/irqchip/riscv-imsic.h     | 3 +++
> >  3 files changed, 10 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
> > index dad3181856600..cac3c2b51d724 100644
> > --- a/arch/riscv/kvm/aia.c
> > +++ b/arch/riscv/kvm/aia.c
> > @@ -630,7 +630,7 @@ int kvm_riscv_aia_init(void)
> >          */
> >         if (gc)
> >                 kvm_riscv_aia_nr_hgei =3D min((ulong)kvm_riscv_aia_nr_h=
gei,
> > -                                           BIT(gc->guest_index_bits) -=
 1);
> > +                                           gc->nr_guest_files);
> >         else
> >                 kvm_riscv_aia_nr_hgei =3D 0;
> >
> > diff --git a/drivers/irqchip/irq-riscv-imsic-state.c b/drivers/irqchip/=
irq-riscv-imsic-state.c
> > index dc95ad856d80a..1e982ce024a47 100644
> > --- a/drivers/irqchip/irq-riscv-imsic-state.c
> > +++ b/drivers/irqchip/irq-riscv-imsic-state.c
> > @@ -794,7 +794,7 @@ static int __init imsic_parse_fwnode(struct fwnode_=
handle *fwnode,
> >
> >  int __init imsic_setup_state(struct fwnode_handle *fwnode, void *opaqu=
e)
> >  {
> > -       u32 i, j, index, nr_parent_irqs, nr_mmios, nr_handlers =3D 0;
> > +       u32 i, j, index, nr_parent_irqs, nr_mmios, nr_guest_files, nr_h=
andlers =3D 0;
> >         struct imsic_global_config *global;
> >         struct imsic_local_config *local;
> >         void __iomem **mmios_va =3D NULL;
> > @@ -888,6 +888,7 @@ int __init imsic_setup_state(struct fwnode_handle *=
fwnode, void *opaque)
> >         }
> >
> >         /* Configure handlers for target CPUs */
> > +       global->nr_guest_files =3D BIT(global->guest_index_bits) - 1;
> >         for (i =3D 0; i < nr_parent_irqs; i++) {
> >                 rc =3D imsic_get_parent_hartid(fwnode, i, &hartid);
> >                 if (rc) {
> > @@ -928,6 +929,10 @@ int __init imsic_setup_state(struct fwnode_handle =
*fwnode, void *opaque)
> >                 local->msi_pa =3D mmios[index].start + reloff;
> >                 local->msi_va =3D mmios_va[index] + reloff;
> >
>
> Need comments explaining why we are taking the
> minimum number of guest files across CPUs.
>
> > +               nr_guest_files =3D (resource_size(&mmios[index]) - relo=
ff) / IMSIC_MMIO_PAGE_SZ - 1;
> > +               global->nr_guest_files =3D global->nr_guest_files > nr_=
guest_files ? nr_guest_files :
> > +                                        global->nr_guest_files;
>
> global->nr_guest_files =3D min(nr_guest_files, global->nr_guest_files);
>
> > +
> >                 nr_handlers++;
> >         }
> >
> > diff --git a/include/linux/irqchip/riscv-imsic.h b/include/linux/irqchi=
p/riscv-imsic.h
> > index 7494952c55187..43aed52385008 100644
> > --- a/include/linux/irqchip/riscv-imsic.h
> > +++ b/include/linux/irqchip/riscv-imsic.h
> > @@ -69,6 +69,9 @@ struct imsic_global_config {
> >         /* Number of guest interrupt identities */
> >         u32                                     nr_guest_ids;
> >
> > +       /* Number of guest interrupt files per core */
> > +       u32                                     nr_guest_files;
> > +
> >         /* Per-CPU IMSIC addresses */
> >         struct imsic_local_config __percpu      *local;
> >  };
> > --
> > 2.20.1
> >
>
> Regards,
> Anup

