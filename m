Return-Path: <kvm+bounces-66433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F058CD2B6F
	for <lists+kvm@lfdr.de>; Sat, 20 Dec 2025 10:03:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4A312300BE7D
	for <lists+kvm@lfdr.de>; Sat, 20 Dec 2025 09:03:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9617C2D8370;
	Sat, 20 Dec 2025 09:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="KJBnVS3f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F802F0C76
	for <kvm@vger.kernel.org>; Sat, 20 Dec 2025 09:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766221408; cv=none; b=Avo34zzR5TRBfBnPqf/Ja4HnMrJ3v/02WkYNYuHS74nNfWpRl6W8yiMBovp9AlEXmtnYUQ/CZETRv08IV0dKXy3F+/NVvBJoODtG0Cq224Ya5Sy56DdC0kmMUR3pYYZ+tMsON+Kfv3K3eiaH4DV57cVPk1rJL8PjuVjzo+HEnIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766221408; c=relaxed/simple;
	bh=t2h8aaGu0FtdHCN7ssAmxhJJO8lQYFUEz3w4ZDEi5aU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OeBc4m4eqq1I7adOdDoLqgmr4Qoaq+TX4smhiHYxmd8seRR7dyUTbBpnAOKTqinoXnS8cQCZJi2DR12eQoXp9Up/7EsS3mvXlaoxeHciMW42oDVNm6SqZIcLECN5PuhqbADNTBrbgXf5wZrtuiaSYCFtU5ctwYV7d9ntYIRcXWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=KJBnVS3f; arc=none smtp.client-ip=209.85.217.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-5dd6fbe50c0so773982137.2
        for <kvm@vger.kernel.org>; Sat, 20 Dec 2025 01:03:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1766221405; x=1766826205; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Va3aH01h9VzCu+jjyIlDqz4JQd4jmsrCBD/p8egZk2U=;
        b=KJBnVS3f8Yjc2z9nV1B5zPd1YQMYq/m1ZsX0pXxXBUk2YXDJAmW24PT97HHRjoJGYI
         PKhYeQYBadYyCNNfKWJwfWNHwHYpHnQnlCIgHNTmzfGKcq0PcAxnOxJD6OcFOexofwa+
         wj/Cw5tYQ4XZvd2YpmEwzlC6nJJTmYBQjMeCrwsOBzJk7UgcbqLDAjxFphSXq/U7OOQx
         jHOFDW7CZqZAH5+iCnrXEw7FKffKwVnoBftl2jzFTbJo70APIhbFLp+u6VvMRRF/L9IQ
         JZAWotvaEsn2f2v0aTYr6WJi9vO9E24fUarqx7SjNC7s/QAay8nlGKGjKDeQhMvJdjbz
         FHeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766221405; x=1766826205;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Va3aH01h9VzCu+jjyIlDqz4JQd4jmsrCBD/p8egZk2U=;
        b=RGCqXTBxViLAXKwk4mTUFkrxeDWfGtTxMb42Yu1xJOryDqbC503KbfwEuAg1JIfxPy
         J7lmYANpSo9ngJZwbezrssRIu6BN5ccbsAlqNdnlB2nnuJ88zINz7e1daPPSIV1m9dj2
         4KcYgv0v10NAwCs544VQ7spgOLtKzZ6lnfgNpdJmUsOPJnNseiO9x3S2EaTpFDzSQH8Y
         2aU3KjHsRPQGpAqx0h6ZB5IaS/wvdsxWM7axHLHTpnreia5sE7CNaXe3zviOAPbjD6om
         5RxVzR/iyO+HJ7JbbLCDEPH/U1TtzUpGRCSahjLVB4QGATz1bcKKFbLxvrtyelHZIXel
         g2pA==
X-Gm-Message-State: AOJu0YydWOdYxqZ3Qon1RwjLjfcVSQmnxmeJ3OGaNZQgPASgTpKlytVR
	5sWst3sqTPMGEaim0WMWGfZdnNoYQMINRVHZcjjwY5saW4qQ5p05dBsKuE5b04A6ywSfwQOFsuz
	tH9wbMaM7GeDPkBYG5SptcLq6Yb3iC/S3lnLLDlYaJ554uo0VNSAhjEw=
X-Gm-Gg: AY/fxX6bWz+M0FcGnf2b9ObISll2UkdP7wefzUlJmkB1f8a4EQCVc5MXhqOt71vr/cE
	DPE9J6i1z+sQvHi2TfECg2YAPBkUYi0CBDt8Rw0PeD3SXNuE5aXCa0nBcCPQt1GPcTnG/eVAANW
	mNUeTSRwY+TNQypJFB232rNqe6cUSl/eGBCxPI/S94PqZTlR/7OtN3S8Z75dUAvKDTisAcaxmMf
	Evm5vTq0FGnvc7Y7he+oIO6FYmz01i5PO864TAbvy9CeRilXJoM6pcVj3iwll+u8D8Z6+TWspXN
	Ew==
X-Google-Smtp-Source: AGHT+IHjJZyxgMociIgVi8Vl7x9+mX3PDgDpt1PBc1PqiaU7VPQpkPAVPp74stlra4EpXF34ykw4FyuuatuGTMhzLEo=
X-Received: by 2002:a05:6102:2b90:b0:5db:f352:afc0 with SMTP id
 ada2fe7eead31-5eb1a616c83mr1883567137.2.1766221404637; Sat, 20 Dec 2025
 01:03:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251220085550.42647-1-luxu.kernel@bytedance.com>
In-Reply-To: <20251220085550.42647-1-luxu.kernel@bytedance.com>
From: Xu Lu <luxu.kernel@bytedance.com>
Date: Sat, 20 Dec 2025 17:03:13 +0800
X-Gm-Features: AQt7F2rCaGj3uJSbiOnLM5ag5bh3MR_s2uiS2WHTIUVUbqlnbSA-wtGJO6lSIig
Message-ID: <CAPYmKFvE3ZnsbTFYHe8T2tkF10G08dnEQ5KEdied_6wGjztv7A@mail.gmail.com>
Subject: Re: [PATCH] irqchip/riscv-imsic: Adjust vs irq files num according to
 MMIO resources
To: anup@brainfault.org, atish.patra@linux.dev, pjw@kernel.org, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, tglx@linutronix.de
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 20, 2025 at 4:56=E2=80=AFPM Xu Lu <luxu.kernel@bytedance.com> w=
rote:
>
> During initialization, kernel maps the MMIO resources of IMSIC, which is
> parsed from ACPI or DTS and may not strictly contains all guest
> interrupt files. Page fault happens when KVM wrongly allocates an
> unmapped guest interrupt file and writes it.
>
> Thus, during initialization, we calculate the number of available guest
> interrupt files according to MMIO resources and constrain the number of
> guest interrupt files that can be allocated by KVM.
>
> Signed-off-by: Xu Lu <luxu.kernel@bytedance.com>
> ---
>  arch/riscv/kvm/aia.c                    | 2 +-
>  drivers/irqchip/irq-riscv-imsic-state.c | 7 ++++++-
>  include/linux/irqchip/riscv-imsic.h     | 3 +++
>  3 files changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
> index dad3181856600..7b1f6adcf22d6 100644
> --- a/arch/riscv/kvm/aia.c
> +++ b/arch/riscv/kvm/aia.c
> @@ -630,7 +630,7 @@ int kvm_riscv_aia_init(void)
>          */
>         if (gc)
>                 kvm_riscv_aia_nr_hgei =3D min((ulong)kvm_riscv_aia_nr_hge=
i,
> -                                           BIT(gc->guest_index_bits) - 1=
);
> +                                           BIT(gc->nr_guest_files) - 1);

Typo here. I will resend this patch.

>         else
>                 kvm_riscv_aia_nr_hgei =3D 0;
>
> diff --git a/drivers/irqchip/irq-riscv-imsic-state.c b/drivers/irqchip/ir=
q-riscv-imsic-state.c
> index dc95ad856d80a..1e982ce024a47 100644
> --- a/drivers/irqchip/irq-riscv-imsic-state.c
> +++ b/drivers/irqchip/irq-riscv-imsic-state.c
> @@ -794,7 +794,7 @@ static int __init imsic_parse_fwnode(struct fwnode_ha=
ndle *fwnode,
>
>  int __init imsic_setup_state(struct fwnode_handle *fwnode, void *opaque)
>  {
> -       u32 i, j, index, nr_parent_irqs, nr_mmios, nr_handlers =3D 0;
> +       u32 i, j, index, nr_parent_irqs, nr_mmios, nr_guest_files, nr_han=
dlers =3D 0;
>         struct imsic_global_config *global;
>         struct imsic_local_config *local;
>         void __iomem **mmios_va =3D NULL;
> @@ -888,6 +888,7 @@ int __init imsic_setup_state(struct fwnode_handle *fw=
node, void *opaque)
>         }
>
>         /* Configure handlers for target CPUs */
> +       global->nr_guest_files =3D BIT(global->guest_index_bits) - 1;
>         for (i =3D 0; i < nr_parent_irqs; i++) {
>                 rc =3D imsic_get_parent_hartid(fwnode, i, &hartid);
>                 if (rc) {
> @@ -928,6 +929,10 @@ int __init imsic_setup_state(struct fwnode_handle *f=
wnode, void *opaque)
>                 local->msi_pa =3D mmios[index].start + reloff;
>                 local->msi_va =3D mmios_va[index] + reloff;
>
> +               nr_guest_files =3D (resource_size(&mmios[index]) - reloff=
) / IMSIC_MMIO_PAGE_SZ - 1;
> +               global->nr_guest_files =3D global->nr_guest_files > nr_gu=
est_files ? nr_guest_files :
> +                                        global->nr_guest_files;
> +
>                 nr_handlers++;
>         }
>
> diff --git a/include/linux/irqchip/riscv-imsic.h b/include/linux/irqchip/=
riscv-imsic.h
> index 7494952c55187..43aed52385008 100644
> --- a/include/linux/irqchip/riscv-imsic.h
> +++ b/include/linux/irqchip/riscv-imsic.h
> @@ -69,6 +69,9 @@ struct imsic_global_config {
>         /* Number of guest interrupt identities */
>         u32                                     nr_guest_ids;
>
> +       /* Number of guest interrupt files per core */
> +       u32                                     nr_guest_files;
> +
>         /* Per-CPU IMSIC addresses */
>         struct imsic_local_config __percpu      *local;
>  };
> --
> 2.20.1
>

