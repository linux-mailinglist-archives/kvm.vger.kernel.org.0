Return-Path: <kvm+bounces-66462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 434CFCD4B50
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 06:04:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 80ACD300E3CC
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 05:03:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C08CD30100D;
	Mon, 22 Dec 2025 05:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="1NBTaHA6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E225B1EB
	for <kvm@vger.kernel.org>; Mon, 22 Dec 2025 05:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766379830; cv=none; b=PIUmk5obwEnQhs9DJXBTYSqqgNoYeI+cqtPmwGF0TqHAxbrghMutVMITPYwWBoskw22G2mrRc1nxQDw9mG2btai1sK49szi+h2d/D6Pm4XFfVdR7zFVZnh6/osTIwMmH+Tfz4Q7cX0/jBpCoRIwVDIICQ0JchyLlHOQ7o2DkjaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766379830; c=relaxed/simple;
	bh=CfKOZWrCu+tbM0bA044/ORJGL/q2pUKA0W1cSlhkxDE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bnE1Cq/Zu6x+eNiq/Iu5J0uDVHPjPxra/2aJSNSAd7DLiYjWVd99/1YYM5KZVALhPM7UYJ4Dt2xtM6bd7B/OGimXCr16mfNWHCD7y5K555d9z6Mf2RxrTtGEy4r3d/hDR0aAxTADgInkvJIzwXjP0mM8xZYJcxRl3Vw4u/N4A2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=1NBTaHA6; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-3fa11ba9ed5so2192301fac.0
        for <kvm@vger.kernel.org>; Sun, 21 Dec 2025 21:03:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1766379827; x=1766984627; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sy9ZgPgnx+KQ7BMNaVsbyPKbe9xDbdHd4prPK2wn3fY=;
        b=1NBTaHA6zCqYxxb3RMGy5N5nj+GWRh9y6G0MOkUVgbMdq5xgzkEqUwiSotADJojD9C
         yY4YagNkqDJRGTCEzM+n0Q6sistyOcwOVhMDY5cXviV/XeClbg2b7Gl3Z2JgyPNK1rgE
         xZr+K2v35sGUsfV/9AitQozsfy1W53E81H4XTV04ibZMy+vRqEGdNLnkNThXiF6ANXAQ
         xW3m3AXUTJrjYhYCaZ0MaAgP0eZsSNPH6ekdJ5wj9QqS2b26KnokijF9XSIv2/CrhlmK
         LWlB24rmiui3peTl+cPMeAHzt4VTHa3fHo8KhaUd269Maj02dnzEbe3iV/wRaNJ0w8Af
         pTJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766379827; x=1766984627;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sy9ZgPgnx+KQ7BMNaVsbyPKbe9xDbdHd4prPK2wn3fY=;
        b=nMfUr0PYIAZpV8g/NEryg4umqjlncnGSO4Wl8ogvVgyPkIzTLLCQweIDfNBlgcAHm9
         llV14XNDSnQnZXtIRZW5nQOu7L5k364pVTWE9JRLzgEjAzXGbaGaVV4q43XJNZkh7lnn
         KQyfJJlVFEzLJYKIyv1LMHrfx5Hs1dxLU504S2DvoR7jMBejMzajl5VQ9B/qRlmp0io9
         VahiL01Hp7XJt16x3mlEWjY+HrorImHQOd2Ygao3zWCaPb+HBOfSnS46oyjecX8n35Ul
         Ar7Gp1tkQ6ce+AUb/+2clioqEM055iZX7259AoKEp5TWghd24WX9GzK5dfOemOgWsdmt
         g5Nw==
X-Forwarded-Encrypted: i=1; AJvYcCVjIbjNB+shS5YwdSA3W+47mvaFhfOaGVFly2sZl8/iS/ngkB1mE0guqwjnjyyjqiEoXy4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWx11dPqibY5pNZ5R+XovHwAsZZTqLC5OvEOkrwP3VFRWEe/TQ
	UzqlNq8B/u2acaJwPcE5og6IDUyqTDlZAPzwCnR+1MvKOT9UwHKaLS65PXymAHpFI8gB2mZUVB1
	JZgDC53g97rq0g8YY42YqKdBr5fRZjK/fUJTgT8ytaw==
X-Gm-Gg: AY/fxX6N5wNH2BAWpzFxh4exMgQ4HH4uNznfk6geGuwE4n+kRrPWfQmUdq7EJ/dmjtI
	6IBgHMW0pRCE8zGiV4OWMg9TXcyrPinpabag7A8X+tjnYkNMXMPEpHpXLbqYDzh4fNfcUrFWlu6
	hy4ZVdCllHBTxjcly8+Tc7f64bbzDdZoyxbtOUkFtiBZA3Ln8l9zAVpJwO8Jz7fcqJc1pr3dSDB
	HeL3liCDduUWhJm45kI68P8iKL7n2cTG1/tMTj2Vg3zxDOW1doM+jfW1b6bKP1751Mc/1d87QfB
	nl/EZQM=
X-Google-Smtp-Source: AGHT+IHKvupHro/hyAQmz/UbSx9bp78T+3p3ZGuqrZrOOXP0J2lbd0Nbq+Z7QXEgflbpCa+jplwI2INuovHvot6H1ks=
X-Received: by 2002:a4a:ddcb:0:b0:659:9a49:8f55 with SMTP id
 006d021491bc7-65d0e99fd3cmr3454670eaf.26.1766379827059; Sun, 21 Dec 2025
 21:03:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251220163713.34040-1-luxu.kernel@bytedance.com>
In-Reply-To: <20251220163713.34040-1-luxu.kernel@bytedance.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 22 Dec 2025 10:33:34 +0530
X-Gm-Features: AQt7F2rHINEGxooKlYvEjJ0KOTniXCDPUi7Tp7Ga57aVoykJu_SMOEsVgSJ7joI
Message-ID: <CAAhSdy1rHO407BwLtP-s5J1fJtcp2GfvvhtEEpnN2AOn79s8qg@mail.gmail.com>
Subject: Re: [PATCH v3] irqchip/riscv-imsic: Adjust the number of available
 guest irq files
To: Xu Lu <luxu.kernel@bytedance.com>
Cc: atish.patra@linux.dev, pjw@kernel.org, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, alex@ghiti.fr, tglx@linutronix.de, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 20, 2025 at 10:07=E2=80=AFPM Xu Lu <luxu.kernel@bytedance.com> =
wrote:
>
> During initialization, kernel maps the MMIO resources of IMSIC, which is
> parsed from ACPI or DTS and may not strictly contains all guest
> interrupt files. Page fault happens when KVM wrongly allocates an
> unmapped guest interrupt file and writes it.

The motivation is not clear from the above text and needs to improve.

How about the following ?

Currently, KVM assumes the minimum of implemented HGEIE bits and
"BIT(gc->guest_index_bits) - 1" as the number of guest files available
across all CPUs. This will not work only when CPUs have different number
of guest files because KVM may incorrectly allocate a guest file on a CPU
with fewer guest files.

>
> Thus, during initialization, we calculate the number of available guest

s/Thus, during initialization/To address the above/

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
> index dad3181856600..cac3c2b51d724 100644
> --- a/arch/riscv/kvm/aia.c
> +++ b/arch/riscv/kvm/aia.c
> @@ -630,7 +630,7 @@ int kvm_riscv_aia_init(void)
>          */
>         if (gc)
>                 kvm_riscv_aia_nr_hgei =3D min((ulong)kvm_riscv_aia_nr_hge=
i,
> -                                           BIT(gc->guest_index_bits) - 1=
);
> +                                           gc->nr_guest_files);
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

Need comments explaining why we are taking the
minimum number of guest files across CPUs.

> +               nr_guest_files =3D (resource_size(&mmios[index]) - reloff=
) / IMSIC_MMIO_PAGE_SZ - 1;
> +               global->nr_guest_files =3D global->nr_guest_files > nr_gu=
est_files ? nr_guest_files :
> +                                        global->nr_guest_files;

global->nr_guest_files =3D min(nr_guest_files, global->nr_guest_files);

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

Regards,
Anup

