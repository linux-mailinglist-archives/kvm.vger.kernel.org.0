Return-Path: <kvm+bounces-37544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B934A2B7FC
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 02:39:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4F1D3A7EB8
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 01:39:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D416154433;
	Fri,  7 Feb 2025 01:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="M6Nz4UNC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857D414AD0D
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 01:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738892340; cv=none; b=i44G06N5+CHuDtqFs84mpzQTBiVlO1jK5MWJPKbcY0DyINvTAneJW5zy/GCuehMXPMiRCrGPZrFbriyzhOyim6JPJilfWoIxY0R1i7MpRygQbIPhRpFlvLAT0FuczVheQgdCynUWbHXkuckQkvRsbLjfBOKrGG/bv4H4lwe7oUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738892340; c=relaxed/simple;
	bh=fq0UOf8SC26+4AoQXWdgvBUDsE1IMj5rr0hPP/cvLsQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=blQ18IOAwQWXhHtTwxW/jiEhOb8l+/DPW8wABo540I4c6BoqeE25A0l+a3k1mHiFXAVC7/5wJEPSn7THw8/4UDdT9zxh1ugfSmDtzpy00N3d4PV3ZlIwVRV74srGd2CncP4rSLWYUKncco2JJfJJZFYnpVxNdAuvymf1ZdjGwrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=M6Nz4UNC; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 67B673F875
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 01:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1738892331;
	bh=K5qES+GVlG20K2dlEEcD5iEfH1x66KXnOUC+BS4kH/k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=M6Nz4UNC2+WD7kSizzzAu25I/z+a/TiEWn5GR0mvS86IVhkPYRJDyr4mxNdqzJMCW
	 pvCcDtWNfx2hEpEyp1XCp27RJkYGF4Y0Ohlq/vAnH2wiGVj5C6/OCH1JrAf0JKINNf
	 fw5a01M4CwsFrMBhdxReIT0KV7vUirLqCxpcXvFG1bNPeHppDYRTJHVL0miBGTAoO3
	 n6FA7pqDuhXXuuXhheCMdvek4CNXEmZGGFUOkvPGoFS22deDy9r81pkvZ1FTJ8k7AC
	 HdRrwisSH3FgsvLxlUV6W9pXsO7UIY5e5pK2HGeBZ2TlvbQeFytR8x9hTJj5X6MRGz
	 4w3V+hQ4kbaag==
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-aa67855b3deso170812466b.1
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2025 17:38:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738892331; x=1739497131;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K5qES+GVlG20K2dlEEcD5iEfH1x66KXnOUC+BS4kH/k=;
        b=kuEwSuMDf9DU/YVqL/b0P7oQgXKDevQTUz0bIi3fM/rDaPAKeb1SPUveuYyYMW/Vys
         53tbJ699HRerf5Tp9B2/n7TemUb3jhwwii7l6y4tF81JW6o4dqvbaIwHKCZf2HFc47gG
         nQY4HL9VR+w8z54oNloHpZrnSAbupJMy5K94O56molOBZiypm9QVBdUHglUuYCjPa7ZW
         /Wk9CfocsqGblfKk00qrsLTW6Ex0fOWYQpA9osLga9kbYDycdTi/nWfXXjbfJDtqnGI/
         AvV+lkCJ009V+RR8C91cefRBjdkQ5SuwFjh0pd34Q0D+tTaPeIeKEmvm88OdnPvuhXJ/
         4A+g==
X-Gm-Message-State: AOJu0YwLOhyz3fjWJPbj/pTJholDQkDglRnXRVPjByPC8Qzuyv6dHtac
	mkf5jYAGhwuBS4m78KhbKAHgAszYZxiGiglGnbk5yIE9SKVSjD99ciMyinlSat04jWVFb5Ug0SM
	/OIz2qt57TfwGXTctj7kdRjki9Zo9PHe7Uygy2hX/1AzBVbT/AmFRU9cvsTThlqbMu726rcHXxB
	3D0eANMn0NxouZkXswYi+iPK88YSC5Vr6jJ7Dpwh44
X-Gm-Gg: ASbGncviO5Mflkp0yQQ8+kLtsGp/6UCuMPvppydXSiWt0cTDhLR7xeR3Ch6CztzqQzk
	ayINm6x9kHpEY2SFdFGPXSX8KE1Bz4pRDMxyU/i7W/VnUWpfZl/uReho/Ts13
X-Received: by 2002:a17:907:1c19:b0:aae:bac6:6659 with SMTP id a640c23a62f3a-ab789a9d91cmr133616666b.7.1738892330666;
        Thu, 06 Feb 2025 17:38:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEjVNiUjmOiaNcqYPaO2FUWokIWE7nATRPF3nxxGSqUPpK2/TAc9mSHRxKYqh8+gYC48VdvH9/1OBQtfRsA8Qo=
X-Received: by 2002:a17:907:1c19:b0:aae:bac6:6659 with SMTP id
 a640c23a62f3a-ab789a9d91cmr133615566b.7.1738892330311; Thu, 06 Feb 2025
 17:38:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250205231728.2527186-1-alex.williamson@redhat.com> <20250205231728.2527186-4-alex.williamson@redhat.com>
In-Reply-To: <20250205231728.2527186-4-alex.williamson@redhat.com>
From: Mitchell Augustin <mitchell.augustin@canonical.com>
Date: Thu, 6 Feb 2025 19:38:39 -0600
X-Gm-Features: AWEUYZnAW4rUfCHw-7VX9n7-Eip6NUC42iOZv1ZSPAdE6mvG1DWKpYTngjxiGU8
Message-ID: <CAHTA-ua8_LJKbTpM8MkxqwVN7djeij9A3CAYTL+eNAE_5MmG0g@mail.gmail.com>
Subject: Re: [PATCH 3/5] vfio/type1: Use vfio_batch for vaddr_get_pfns()
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterx@redhat.com, 
	clg@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed-by: "Mitchell Augustin" <mitchell.augustin@canonical.com>
Tested-by: "Mitchell Augustin" <mitchell.augustin@canonical.com>



On Wed, Feb 5, 2025 at 5:18=E2=80=AFPM Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> Passing the vfio_batch to vaddr_get_pfns() allows for greater
> distinction between page backed pfns and pfnmaps.  In the case of page
> backed pfns, vfio_batch.size is set to a positive value matching the
> number of pages filled in vfio_batch.pages.  For a pfnmap,
> vfio_batch.size remains zero as vfio_batch.pages are not used.  In both
> cases the return value continues to indicate the number of pfns and the
> provided pfn arg is set to the initial pfn value.
>
> This allows us to shortcut the pfnmap case, which is detected by the
> zero vfio_batch.size.  pfnmaps do not contribute to locked memory
> accounting, therefore we can update counters and continue directly,
> which also enables a future where vaddr_get_pfns() can return a value
> greater than one for consecutive pfnmaps.
>
> NB. Now that we're not guessing whether the initial pfn is page backed
> or pfnmap, we no longer need to special case the put_pfn() and batch
> size reset.  It's safe for vfio_batch_unpin() to handle this case.
>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 62 ++++++++++++++++++---------------
>  1 file changed, 34 insertions(+), 28 deletions(-)
>
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_ty=
pe1.c
> index 2e95f5f4d881..939920454da7 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -555,12 +555,16 @@ static int follow_fault_pfn(struct vm_area_struct *=
vma, struct mm_struct *mm,
>
>  /*
>   * Returns the positive number of pfns successfully obtained or a negati=
ve
> - * error code.
> + * error code.  The initial pfn is stored in the pfn arg.  For page-back=
ed
> + * pfns, the provided batch is also updated to indicate the filled pages=
 and
> + * initial offset.  For VM_PFNMAP pfns, only the returned number of pfns=
 and
> + * returned initial pfn are provided; subsequent pfns are contiguous.
>   */
>  static int vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
>                           long npages, int prot, unsigned long *pfn,
> -                         struct page **pages)
> +                         struct vfio_batch *batch)
>  {
> +       long pin_pages =3D min_t(long, npages, batch->capacity);
>         struct vm_area_struct *vma;
>         unsigned int flags =3D 0;
>         int ret;
> @@ -569,10 +573,12 @@ static int vaddr_get_pfns(struct mm_struct *mm, uns=
igned long vaddr,
>                 flags |=3D FOLL_WRITE;
>
>         mmap_read_lock(mm);
> -       ret =3D pin_user_pages_remote(mm, vaddr, npages, flags | FOLL_LON=
GTERM,
> -                                   pages, NULL);
> +       ret =3D pin_user_pages_remote(mm, vaddr, pin_pages, flags | FOLL_=
LONGTERM,
> +                                   batch->pages, NULL);
>         if (ret > 0) {
> -               *pfn =3D page_to_pfn(pages[0]);
> +               *pfn =3D page_to_pfn(batch->pages[0]);
> +               batch->size =3D ret;
> +               batch->offset =3D 0;
>                 goto done;
>         } else if (!ret) {
>                 ret =3D -EFAULT;
> @@ -628,32 +634,41 @@ static long vfio_pin_pages_remote(struct vfio_dma *=
dma, unsigned long vaddr,
>                 *pfn_base =3D 0;
>         }
>
> +       if (unlikely(disable_hugepages))
> +               npage =3D 1;
> +
>         while (npage) {
>                 if (!batch->size) {
>                         /* Empty batch, so refill it. */
> -                       long req_pages =3D min_t(long, npage, batch->capa=
city);
> -
> -                       ret =3D vaddr_get_pfns(mm, vaddr, req_pages, dma-=
>prot,
> -                                            &pfn, batch->pages);
> +                       ret =3D vaddr_get_pfns(mm, vaddr, npage, dma->pro=
t,
> +                                            &pfn, batch);
>                         if (ret < 0)
>                                 goto unpin_out;
>
> -                       batch->size =3D ret;
> -                       batch->offset =3D 0;
> -
>                         if (!*pfn_base) {
>                                 *pfn_base =3D pfn;
>                                 rsvd =3D is_invalid_reserved_pfn(*pfn_bas=
e);
>                         }
> +
> +                       /* Handle pfnmap */
> +                       if (!batch->size) {
> +                               if (pfn !=3D *pfn_base + pinned || !rsvd)
> +                                       goto out;
> +
> +                               pinned +=3D ret;
> +                               npage -=3D ret;
> +                               vaddr +=3D (PAGE_SIZE * ret);
> +                               iova +=3D (PAGE_SIZE * ret);
> +                               continue;
> +                       }
>                 }
>
>                 /*
> -                * pfn is preset for the first iteration of this inner lo=
op and
> -                * updated at the end to handle a VM_PFNMAP pfn.  In that=
 case,
> -                * batch->pages isn't valid (there's no struct page), so =
allow
> -                * batch->pages to be touched only when there's more than=
 one
> -                * pfn to check, which guarantees the pfns are from a
> -                * !VM_PFNMAP vma.
> +                * pfn is preset for the first iteration of this inner lo=
op due to the
> +                * fact that vaddr_get_pfns() needs to provide the initia=
l pfn for pfnmaps.
> +                * Therefore to reduce redundancy, the next pfn is fetche=
d at the end of
> +                * the loop.  A PageReserved() page could still qualify a=
s page backed and
> +                * rsvd here, and therefore continues to use the batch.
>                  */
>                 while (true) {
>                         if (pfn !=3D *pfn_base + pinned ||
> @@ -688,21 +703,12 @@ static long vfio_pin_pages_remote(struct vfio_dma *=
dma, unsigned long vaddr,
>
>                         pfn =3D page_to_pfn(batch->pages[batch->offset]);
>                 }
> -
> -               if (unlikely(disable_hugepages))
> -                       break;
>         }
>
>  out:
>         ret =3D vfio_lock_acct(dma, lock_acct, false);
>
>  unpin_out:
> -       if (batch->size =3D=3D 1 && !batch->offset) {
> -               /* May be a VM_PFNMAP pfn, which the batch can't remember=
. */
> -               put_pfn(pfn, dma->prot);
> -               batch->size =3D 0;
> -       }
> -
>         if (ret < 0) {
>                 if (pinned && !rsvd) {
>                         for (pfn =3D *pfn_base ; pinned ; pfn++, pinned--=
)
> @@ -750,7 +756,7 @@ static int vfio_pin_page_external(struct vfio_dma *dm=
a, unsigned long vaddr,
>
>         vfio_batch_init_single(&batch);
>
> -       ret =3D vaddr_get_pfns(mm, vaddr, 1, dma->prot, pfn_base, batch.p=
ages);
> +       ret =3D vaddr_get_pfns(mm, vaddr, 1, dma->prot, pfn_base, &batch)=
;
>         if (ret !=3D 1)
>                 goto out;
>
> --
> 2.47.1
>


--
Mitchell Augustin
Software Engineer - Ubuntu Partner Engineering

