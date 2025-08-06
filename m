Return-Path: <kvm+bounces-54196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EAFB6B1CE23
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 22:58:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A69D318C693F
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 20:59:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73CE22206AF;
	Wed,  6 Aug 2025 20:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mjn/KwJD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05FEB1FF7C8
	for <kvm@vger.kernel.org>; Wed,  6 Aug 2025 20:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754513913; cv=none; b=MZoSvo49kLRwtOMCZL2Ksw4FjpXStI/9b9C2D+MJj4yaSQAzKhKWOXpUC4PEpUiVflX59XKPlDSd3dksyNskJScmh/jgDKml2gIH9k4fN5/DVyRTAZXsy9Wo9vNBOcwZ8xobYLPqtowGJj3LnUYvmQghR1ecF1pJIPSXxUunVP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754513913; c=relaxed/simple;
	bh=U1FeQRtLiG+q4sfmdpJ9bCgp5uUUcwrffLKyNe3Rxms=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cuPyF32K0X8YMZbRsh8mUvFV+GfECTrGX+/K/IE5z1oDD7B32wWSa9mBk2KEnHTPgqmQBgNyhCsgWcW3+3rYGorXv8zhVmGWiQdAtkXV9ywG9hyPeHxn/dBpeAaoi+eAy0LV1pG0qLXiJ4YOC8t5Jlw1eDW13Tv1qfApB1GTXCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mjn/KwJD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754513911;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XL3JtSDnypcZCdbt3A90Mr99TpavO/k4/VrpLyiBez8=;
	b=Mjn/KwJDx4NWLHwmUop1Nqv4WAyrfRGGPQ6VLWLppjTzE2fHxEDvXhWKsDEjLYkfuCFLbn
	AjIl1GJZS0YnG13/Xqcrhdvw0jy+6kR8Pn5RnfUDpi25BypfqRn7oCyHUidd0u0p1gFlYn
	ROE/bZzCah4n6hvqXHras3zGrMdDY0Q=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-470-xq1-H0HjPS6JasJe4cAbQA-1; Wed, 06 Aug 2025 16:58:29 -0400
X-MC-Unique: xq1-H0HjPS6JasJe4cAbQA-1
X-Mimecast-MFC-AGG-ID: xq1-H0HjPS6JasJe4cAbQA_1754513909
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3e3fdd9298eso727775ab.3
        for <kvm@vger.kernel.org>; Wed, 06 Aug 2025 13:58:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754513909; x=1755118709;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XL3JtSDnypcZCdbt3A90Mr99TpavO/k4/VrpLyiBez8=;
        b=ntnpreKHnYAerf995ngRT9KyrYgKTjNKaLaAs2BlIWCIw1x9HpjTpSrWz4AFOkxH5h
         Fu8bKcmQ3j4nQK7K9NJBDx4UK23FgfhADyE82rno9Lf9Xgt3a3Nb3jKN2/RORu/oh49V
         oqVftKC4T3Vdd6bpkNk845ZqJBZu6tn6/wDp8Y6ripG1JPfVyjGaFYAKUdW6J/zZF+gi
         U2HYOcaPfeJ6e5/ta2/QDGe9e1CSZN4JhslbCJ/E36ZUp6nPFfLRPqsBj7/7ym2yzFyW
         Hm+gc6h7rNc3P/9NGDA52CKmX6d5OeWozpq3+ySbbU8pISFymfjRQTDhfip1jqnGxYTT
         PDqA==
X-Forwarded-Encrypted: i=1; AJvYcCU0IINihEgKxC4iO/+mXcXKrJ/aUJ+9Xya7fFf4AHb4+XADbMia6Olhyav2NUcxG33jMPw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxP2mk7DUROGQI2wWGTFaNMrH03MvtshpBxIQc45M4GKFRbXiPM
	RWuouXdrcDFjcFEfke7u1Xmz93ldbQD9uNECxcWZoxGQpEoHX24s/9q/v+mOXZhluj/XvHMgdKu
	JAfvksSJBXEhrh8S3mEYEi0YZbSZhlIelnlQ83cl1dGy0fjqDq2oNSw==
X-Gm-Gg: ASbGnctA8eI0M7iWOJKKswIBp21cXZeeBELP2qrLIcW73K1fujhpyqgdRbVVxHr+jlt
	eOyYgaDjWYZPPncqjoZ6MvchBwjvbPoCRPuxG8/YD10z6y/kUigMBggI4ByitEefA3k11m4eA4i
	4HqJ6f2j1D2waUT+p6PLilDoFt8f51f0llgqS4DUM1+EU5JOK6Ew/DnWR8eJ311BGvQi1hCNKJt
	pWliHM/4fnbCSEItas8HJAWBpTH+02FELnqlc/oMCF84PHxTV7ANgH0mEQ+4jULH0SUAu19W3xE
	QY6FSva6+TI1dexiA7wPEpIbsT57rmxldOPpgElI3ss=
X-Received: by 2002:a05:6e02:152e:b0:3e3:d2eb:52db with SMTP id e9e14a558f8ab-3e51b79eae2mr20687245ab.0.1754513909049;
        Wed, 06 Aug 2025 13:58:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEvMHObcGautLtJ7984K/wyyriLvMdPXmyUUT5V0nwJ7vFbNm7fOcxZIXtiLyBYuGHd6raZZQ==
X-Received: by 2002:a05:6e02:152e:b0:3e3:d2eb:52db with SMTP id e9e14a558f8ab-3e51b79eae2mr20686945ab.0.1754513908609;
        Wed, 06 Aug 2025 13:58:28 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50ab01e84desm2049992173.51.2025.08.06.13.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 13:58:27 -0700 (PDT)
Date: Wed, 6 Aug 2025 14:58:25 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Leon Romanovsky <leonro@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>, Bjorn Helgaas
 <bhelgaas@google.com>, Christian =?UTF-8?B?S8O2bmln?=
 <christian.koenig@amd.com>, Christoph Hellwig <hch@lst.de>,
 dri-devel@lists.freedesktop.org, iommu@lists.linux.dev, Jens Axboe
 <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
 linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org, Logan Gunthorpe
 <logang@deltatee.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Robin
 Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v1 01/10] PCI/P2PDMA: Remove redundant bus_offset from
 map state
Message-ID: <20250806145825.2654ee59.alex.williamson@redhat.com>
In-Reply-To: <c9b6237964b9606418af400bb6bec5178fcffff2.1754311439.git.leon@kernel.org>
References: <cover.1754311439.git.leon@kernel.org>
	<c9b6237964b9606418af400bb6bec5178fcffff2.1754311439.git.leon@kernel.org>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon,  4 Aug 2025 16:00:36 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> Remove the bus_off field from pci_p2pdma_map_state since it duplicates
> information already available in the pgmap structure. The bus_offset
> is only used in one location (pci_p2pdma_bus_addr_map) and is always
> identical to pgmap->bus_offset.
>=20
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/pci/p2pdma.c       | 1 -
>  include/linux/pci-p2pdma.h | 3 +--
>  2 files changed, 1 insertion(+), 3 deletions(-)
>=20
> diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
> index da5657a020074..274bb7bcc0bc5 100644
> --- a/drivers/pci/p2pdma.c
> +++ b/drivers/pci/p2pdma.c
> @@ -1009,7 +1009,6 @@ void __pci_p2pdma_update_state(struct pci_p2pdma_ma=
p_state *state,
>  {
>  	state->pgmap =3D page_pgmap(page);
>  	state->map =3D pci_p2pdma_map_type(state->pgmap, dev);
> -	state->bus_off =3D to_p2p_pgmap(state->pgmap)->bus_offset;
>  }
> =20
>  /**
> diff --git a/include/linux/pci-p2pdma.h b/include/linux/pci-p2pdma.h
> index 075c20b161d98..b502fc8b49bf9 100644
> --- a/include/linux/pci-p2pdma.h
> +++ b/include/linux/pci-p2pdma.h
> @@ -146,7 +146,6 @@ enum pci_p2pdma_map_type {
>  struct pci_p2pdma_map_state {
>  	struct dev_pagemap *pgmap;
>  	enum pci_p2pdma_map_type map;
> -	u64 bus_off;
>  };
> =20
>  /* helper for pci_p2pdma_state(), do not use directly */
> @@ -186,7 +185,7 @@ static inline dma_addr_t
>  pci_p2pdma_bus_addr_map(struct pci_p2pdma_map_state *state, phys_addr_t =
paddr)
>  {
>  	WARN_ON_ONCE(state->map !=3D PCI_P2PDMA_MAP_BUS_ADDR);
> -	return paddr + state->bus_off;
> +	return paddr + to_p2p_pgmap(state->pgmap)->bus_offsetf;
>  }
> =20
>  #endif /* _LINUX_PCI_P2P_H */

Looks like you're relying on this bogus code getting resolved in the
next patch...

In file included from kernel/dma/direct.c:16:
./include/linux/pci-p2pdma.h: In function =E2=80=98pci_p2pdma_bus_addr_map=
=E2=80=99:
./include/linux/pci-p2pdma.h:188:24: error: implicit declaration of functio=
n =E2=80=98to_p2p_pgmap=E2=80=99 [-Wimplicit-function-declaration]
  188 |         return paddr + to_p2p_pgmap(state->pgmap)->bus_offsetf;
      |                        ^~~~~~~~~~~~
./include/linux/pci-p2pdma.h:188:50: error: invalid type argument of =E2=80=
=98->=E2=80=99 (have =E2=80=98int=E2=80=99)
  188 |         return paddr + to_p2p_pgmap(state->pgmap)->bus_offsetf;
      |                                                  ^~
./include/linux/pci-p2pdma.h:189:1: error: control reaches end of non-void =
function [-Werror=3Dreturn-type]
  189 | }
      | ^

to_p2p_pgmap() is a static function and struct pci_p2pdma_pagemap
doesn't have a bus_offsetf member.  Thanks,

Alex


