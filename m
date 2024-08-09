Return-Path: <kvm+bounces-23739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C01294D55C
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:24:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 51DF91C20DEB
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 17:24:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1955E61FD8;
	Fri,  9 Aug 2024 17:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qwv4A3nl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5EAA14F70
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 17:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723224243; cv=none; b=bvNYFh62w65FJpSwLlcXtOscaFpE46aZ3bnld15k8Pn3sd6LLys5ZhhiHRzn5Ilr07VjDb9OLiUgNk+ZU3yVogm78MHqc/6pLDzSU+hPEA0LOrp9Nck/UavoLstfZdXt2Q0gspgiJjsQpw+P2G0mzWgbr2LHlm88BdE8gZ+qaTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723224243; c=relaxed/simple;
	bh=U79tLyON/wgpPV2sORNRCWw4Qth2wqbqkWm0MKGXRQI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mcfsrIfbLh/qY3lZEi5nsrcyTm63N6UVZfIhP5uLkB87STZ+pofsaA9ovx5XhxrR2sjFZPZkNsuHjRDSezxdoRejUBvw5Qpd8tge6iaanF8tum24kIDuiob5+/Mc0p4/+ck+kp2wID6c2MD9/8wsYfciSAv5zOvl5JcTIBH9ZGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qwv4A3nl; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-36bb2047bf4so1486160f8f.2
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 10:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723224239; x=1723829039; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4QdjlOHuBnkWT9u/9CGI9uaBMM/Qi29TBnTB7AP5Y7M=;
        b=qwv4A3nlUQvK0itivuk/DGYak6pyIzD/uhRLfoqU1RBLYzF2k6bha39TYNijg1d0OJ
         6EjK4amSE0Ey3w260FAC7ZJYBGSfmUuokEmbXUY6VaJQYCd5O1NAwfAuz6Hi1QaYi828
         obj5tkVWuhTo84yUQkxCXPkEUyp5/mKVKwZ8S+zZR8HYa++E/sdIYvJ/YLsi/c6fOM7X
         b1SG2EqMX3zKcrUlrt1W0RQRxSkVqRicxS6FaIzC6qV+jjyDLLCaEfkjLcaZ0ih/ro/f
         3DpDQqYki4OIIe5/PBaCqGgeMB7wtDa+SYN4+8TsF1e3VdOSqnTdH2i7erO/GMdT33u2
         bamA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723224239; x=1723829039;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4QdjlOHuBnkWT9u/9CGI9uaBMM/Qi29TBnTB7AP5Y7M=;
        b=A0kuuYnQnNZUQ5ZYPJRGfCqZukgwSrll1bUfScx0dy8fKStj29F3arAdM7CpI7gFHd
         nsPBVjXSv01dr3JVLSUQ3d/JANnVmPJEKlABP/wQpa3g/CZ90b/sF5EHQiU3skcxhnz8
         1Hjf6VAZqhX/YdeQhqPPmVPQqNlrk2Y6PQ86PelOiHqcMWlGPZVqN5lQjsWcbQXl9Igf
         2wuLDBy3rm+1eD75anvHkJ9WQ0SATe8beTdsLFkeTVTVExTa+knHPttJXChiB8v5Mfx9
         o9W19qgC7NTpODrYg7cGA7ottPjK8IlFV3CW6AgQf1DLp+YJ60U4+Kml3ykMSTKmAUT3
         kmgA==
X-Forwarded-Encrypted: i=1; AJvYcCXs3lrPSrlVYX09n12KitVX43npCqZlZO9R37Vd8II4r+Di4XkdaU6vFNIMkrya5AtCgF7om9V/ArlOL0XhReK3/fKt
X-Gm-Message-State: AOJu0YybbGqxhOa9ov2g9pEQCNBdO9q/3+UrNRGGKFgIfUjPRMdtqbkB
	uadtcL/tl5zvcaJaY6GHo3NvYxqWR4vfdKArjBFRgDGkarG/mELp6L+Qq6PsYlS5Y7F4HmGpuTZ
	P2e5JpsfqXzLQ6ruCrmsx+WU5TgcGbdhHv41Q
X-Google-Smtp-Source: AGHT+IGV1vzsTB3E9qHHAZ2PxwMColOAwLwBW9dzPhmi0xSxisZYI7WVPSVv2jYwNAL5k0yIXCNHSXuqEEMn/3swSXc=
X-Received: by 2002:a05:6000:d04:b0:365:f52f:cd44 with SMTP id
 ffacd0b85a97d-36d61cd2059mr1603070f8f.57.1723224238792; Fri, 09 Aug 2024
 10:23:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240809160909.1023470-1-peterx@redhat.com> <20240809160909.1023470-11-peterx@redhat.com>
In-Reply-To: <20240809160909.1023470-11-peterx@redhat.com>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Fri, 9 Aug 2024 10:23:20 -0700
Message-ID: <CAJHvVciF4riGPQBhyBwNeSWHq8m+7Zag7ewEWgLJk=VsaqKNPQ@mail.gmail.com>
Subject: Re: [PATCH 10/19] KVM: Use follow_pfnmap API
To: Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Oscar Salvador <osalvador@suse.de>, Jason Gunthorpe <jgg@nvidia.com>, 
	linux-arm-kernel@lists.infradead.org, x86@kernel.org, 
	Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@redhat.com>, 
	Alistair Popple <apopple@nvidia.com>, Borislav Petkov <bp@alien8.de>, David Hildenbrand <david@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org, 
	Dave Hansen <dave.hansen@linux.intel.com>, Alex Williamson <alex.williamson@redhat.com>, 
	Yan Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 9, 2024 at 9:09=E2=80=AFAM Peter Xu <peterx@redhat.com> wrote:
>
> Use the new pfnmap API to allow huge MMIO mappings for VMs.  The rest wor=
k
> is done perfectly on the other side (host_pfn_mapping_level()).

I don't think it has to be done in this series, but a future
optimization to consider is having follow_pfnmap just tell the caller
about the mapping level directly. It already found this information as
part of its walk. I think there's a possibility to simplify KVM /
avoid it having to do its own walk again later.

>
>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  virt/kvm/kvm_main.c | 19 +++++++------------
>  1 file changed, 7 insertions(+), 12 deletions(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d0788d0a72cc..9fb1c527a8e1 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2862,13 +2862,11 @@ static int hva_to_pfn_remapped(struct vm_area_str=
uct *vma,
>                                unsigned long addr, bool write_fault,
>                                bool *writable, kvm_pfn_t *p_pfn)
>  {
> +       struct follow_pfnmap_args args =3D { .vma =3D vma, .address =3D a=
ddr };
>         kvm_pfn_t pfn;
> -       pte_t *ptep;
> -       pte_t pte;
> -       spinlock_t *ptl;
>         int r;
>
> -       r =3D follow_pte(vma, addr, &ptep, &ptl);
> +       r =3D follow_pfnmap_start(&args);
>         if (r) {
>                 /*
>                  * get_user_pages fails for VM_IO and VM_PFNMAP vmas and =
does
> @@ -2883,21 +2881,19 @@ static int hva_to_pfn_remapped(struct vm_area_str=
uct *vma,
>                 if (r)
>                         return r;
>
> -               r =3D follow_pte(vma, addr, &ptep, &ptl);
> +               r =3D follow_pfnmap_start(&args);
>                 if (r)
>                         return r;
>         }
>
> -       pte =3D ptep_get(ptep);
> -
> -       if (write_fault && !pte_write(pte)) {
> +       if (write_fault && !args.writable) {
>                 pfn =3D KVM_PFN_ERR_RO_FAULT;
>                 goto out;
>         }
>
>         if (writable)
> -               *writable =3D pte_write(pte);
> -       pfn =3D pte_pfn(pte);
> +               *writable =3D args.writable;
> +       pfn =3D args.pfn;
>
>         /*
>          * Get a reference here because callers of *hva_to_pfn* and
> @@ -2918,9 +2914,8 @@ static int hva_to_pfn_remapped(struct vm_area_struc=
t *vma,
>          */
>         if (!kvm_try_get_pfn(pfn))
>                 r =3D -EFAULT;
> -
>  out:
> -       pte_unmap_unlock(ptep, ptl);
> +       follow_pfnmap_end(&args);
>         *p_pfn =3D pfn;
>
>         return r;
> --
> 2.45.0
>

