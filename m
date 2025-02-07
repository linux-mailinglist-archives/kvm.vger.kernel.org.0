Return-Path: <kvm+bounces-37546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BE098A2B802
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 02:39:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E1BC918893A0
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 01:40:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F3D314EC46;
	Fri,  7 Feb 2025 01:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="Iu+x4E0F"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC04E139CFA
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 01:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738892358; cv=none; b=hh4fDe9b+ig0PlnhMphIvPUnyd/CRZBpflIWvAbRa4INpGJLXNz/hBtesQN5GDGObhgZBX05oHQ4EW3ySTLTM7XuS24S/Lpes+Ms3z4Mp6nwJ5bEZ1KB535Ted+Xn41hEEWHUcra6pwrrGfjYukKDTCY1i/SBFXz6PErKZzPUfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738892358; c=relaxed/simple;
	bh=m//XKS5v/N/PRan3Tui0rOlJ9s5x+n9T9DtCy6T0H9M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pb804ur/PP5xXO2zlppCPZzF5n38Smq7rHYmVhZcAtuaj552DSa433chuStw8Kq5lQRgypkZ9+sfo2ZVtE4Y3ME8PQ/C5rVpIYsRNHcDWAXba1TAMQ67/1yNBpnhwMEYAoZqG/1cPSoL2082lE5DA8UZs9lW/EDClZ2vNOHFjK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=Iu+x4E0F; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 2FD6E3F85C
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 01:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1738892355;
	bh=fNB47AZskNaVXFROFOsVtdHZC/VEBES+Tul1gkugFo8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=Iu+x4E0FwagEckJNRoj06sxQW/XgpQl7FeNQlci/uKUlv3VGYtwVNuy/Hc5Lsj1rk
	 GsWlIjQlnjjevMmC5VkeKvq6MsWaS9Nhdtsz4R1/cZsmvK4nJiBhhJw3IFJRYeodWa
	 3RcMdP2dRVhYVZaDyHw4fIM8bugqTC7MmA98Y7TsYftVUXXeVVAurOHB/RdNm0nSZE
	 x97kIh+KIWNHCxx8HbbGyd0oFQxfBmIjLR4SaGHpL2rO4SGrUA9h13aPar+Gy+nL1o
	 QJwH6pL/mZWDdAxxMHeiB0uOvpg277q7LvocKjkGAyVJ9tw0r1kbdgNG0sPGsD4QXn
	 uN5tm129EZDrQ==
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5dd7f6844c3so1176310a12.0
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2025 17:39:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738892352; x=1739497152;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fNB47AZskNaVXFROFOsVtdHZC/VEBES+Tul1gkugFo8=;
        b=o/OZ9KVfEH89bxC9AgalQOda8kXCcudX+pWXJbiPEo96cCj0kelTgKwbCKqeglLQU5
         GZzGaSexn7XYp5g38ZY8jJ02Ald7mgvTwogFDmNglPXarSqKIJC8Tf+dajiVTqH9dOvU
         liYVn63Uu1AirAP+qsT5irKramd1BWkyWvMXTHV7Z85kiOZIN1/artdPp6NZRdwnhXa9
         iq8c6w37d+rW8DWPJIeMaoohvGmluzKLdjiUTdT5/i/eunheqzmtNqTkgEPKRYFFd7/D
         9D+t+oZBFcPsL0VPKEVrg+QJQs3/DgNXPJr0RRdigH7cz3peuZgAWn59E5iQhl5DiuJ7
         863Q==
X-Gm-Message-State: AOJu0YycPe+lKOtPswa2wrHxrDKgtDQP+ywBNYVg+r0RPWyaPwCCyqgy
	OqOxp/3ZpAKoPsbAimiE08w/tHMOVuAniofL5qMfpMGc+udQmIwrRjCdEtVSMTdP6jbWwFGYXHj
	q6T3jvZ2xHDOqD2T/g10DwUSJgtj4sfQD6pXJTxvEOSvK95BdxJI4ocfqXGBvxAXn5hOfJetXJq
	LcdMxwOEGZscYT2WPkYXdrAt17PKciJbC7uOIJ/CvEUplyxpUr
X-Gm-Gg: ASbGnctiW4QEAvuWomGA1g2HZAvGUZx4JEqJphJa+8XEs3L0DmbBOzmLu4wxU16xbOY
	1C1ps528OsAelLJ+57uDBrWBzYKxgU9X9Ot95aU3B0+Vl4mYH1Ferk+8Efyt7
X-Received: by 2002:a05:6402:1ecf:b0:5dc:1395:1d3a with SMTP id 4fb4d7f45d1cf-5de45040136mr1224811a12.1.1738892352093;
        Thu, 06 Feb 2025 17:39:12 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF/hfeNzW0PLF4wIrEEYadVAd/ZpRfylvoon43qb7nTnRX2cUuBVjBJ/j4A/WtVm/FBP3qMLamc0NsqBBkMXCE=
X-Received: by 2002:a05:6402:1ecf:b0:5dc:1395:1d3a with SMTP id
 4fb4d7f45d1cf-5de45040136mr1224796a12.1.1738892351707; Thu, 06 Feb 2025
 17:39:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250205231728.2527186-1-alex.williamson@redhat.com> <20250205231728.2527186-6-alex.williamson@redhat.com>
In-Reply-To: <20250205231728.2527186-6-alex.williamson@redhat.com>
From: Mitchell Augustin <mitchell.augustin@canonical.com>
Date: Thu, 6 Feb 2025 19:39:00 -0600
X-Gm-Features: AWEUYZm-8N3C_RogZQE-LMB_5GAV_JU3d6aW2EE3P7c5fBbLXqIJWAR7Ls5C54k
Message-ID: <CAHTA-ub+_txMHOG1YmtnPRnwSgU0eLrN6kjA5u4b+cJ=ja2L7Q@mail.gmail.com>
Subject: Re: [PATCH 5/5] vfio/type1: Use mapping page mask for pfnmaps
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterx@redhat.com, 
	clg@redhat.com, akpm@linux-foundation.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

LGTM and completely eliminates guest VM PCI initialization slowdowns
on H100 and A100.
Also not seeing any obvious regressions on my side.

Reported-by: "Mitchell Augustin" <mitchell.augustin@canonical.com>
Reviewed-by: "Mitchell Augustin" <mitchell.augustin@canonical.com>
Tested-by: "Mitchell Augustin" <mitchell.augustin@canonical.com>


On Wed, Feb 5, 2025 at 5:18=E2=80=AFPM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> vfio-pci supports huge_fault for PCI MMIO BARs and will insert pud and
> pmd mappings for well aligned mappings.  follow_pfnmap_start() walks the
> page table and therefore knows the page mask of the level where the
> address is found and returns this through follow_pfnmap_args.pgmask.
> Subsequent pfns from this address until the end of the mapping page are
> necessarily consecutive.  Use this information to retrieve a range of
> pfnmap pfns in a single pass.
>
> With optimal mappings and alignment on systems with 1GB pud and 4KB
> page size, this reduces iterations for DMA mapping PCI BARs by a
> factor of 256K.  In real world testing, the overhead of iterating
> pfns for a VM DMA mapping a 32GB PCI BAR is reduced from ~1s to
> sub-millisecond overhead.
>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 24 +++++++++++++++++-------
>  1 file changed, 17 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_ty=
pe1.c
> index 939920454da7..6f3e8d981311 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -520,7 +520,7 @@ static void vfio_batch_fini(struct vfio_batch *batch)
>
>  static int follow_fault_pfn(struct vm_area_struct *vma, struct mm_struct=
 *mm,
>                             unsigned long vaddr, unsigned long *pfn,
> -                           bool write_fault)
> +                           unsigned long *pgmask, bool write_fault)
>  {
>         struct follow_pfnmap_args args =3D { .vma =3D vma, .address =3D v=
addr };
>         int ret;
> @@ -544,10 +544,12 @@ static int follow_fault_pfn(struct vm_area_struct *=
vma, struct mm_struct *mm,
>                         return ret;
>         }
>
> -       if (write_fault && !args.writable)
> +       if (write_fault && !args.writable) {
>                 ret =3D -EFAULT;
> -       else
> +       } else {
>                 *pfn =3D args.pfn;
> +               *pgmask =3D args.pgmask;
> +       }
>
>         follow_pfnmap_end(&args);
>         return ret;
> @@ -590,15 +592,23 @@ static int vaddr_get_pfns(struct mm_struct *mm, uns=
igned long vaddr,
>         vma =3D vma_lookup(mm, vaddr);
>
>         if (vma && vma->vm_flags & VM_PFNMAP) {
> -               ret =3D follow_fault_pfn(vma, mm, vaddr, pfn, prot & IOMM=
U_WRITE);
> +               unsigned long pgmask;
> +
> +               ret =3D follow_fault_pfn(vma, mm, vaddr, pfn, &pgmask,
> +                                      prot & IOMMU_WRITE);
>                 if (ret =3D=3D -EAGAIN)
>                         goto retry;
>
>                 if (!ret) {
> -                       if (is_invalid_reserved_pfn(*pfn))
> -                               ret =3D 1;
> -                       else
> +                       if (is_invalid_reserved_pfn(*pfn)) {
> +                               unsigned long epfn;
> +
> +                               epfn =3D (((*pfn << PAGE_SHIFT) + ~pgmask=
 + 1)
> +                                       & pgmask) >> PAGE_SHIFT;
> +                               ret =3D min_t(int, npages, epfn - *pfn);
> +                       } else {
>                                 ret =3D -EFAULT;
> +                       }
>                 }
>         }
>  done:
> --
> 2.47.1
>


--
Mitchell Augustin
Software Engineer - Ubuntu Partner Engineering

