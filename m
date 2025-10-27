Return-Path: <kvm+bounces-61233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 52E04C11F28
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 00:14:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B9105189F49F
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 23:14:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B204332D450;
	Mon, 27 Oct 2025 23:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o4thHGD1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B1A32AADC
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 23:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761606817; cv=none; b=b61DUR2RpY/ChSuGduutLKw/QsgVftcpAg1YGinm5TvrCUQss9NlCGYFVG0fECLLE4XUbWWTqUJLMIuyIcs7ktOl+/0iBbvXHTZoXxevjvlbtOLS4U3wexvtl/eIa0UMTkwIFfwvtKhysFH07+/ezdcDvw6DKHkmk4yGJUG8FNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761606817; c=relaxed/simple;
	bh=Mox7WVrx2nsqFbNnAMpCHXjsIB1mhexPun4YkmTSVd8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zqd8aumsNiFObzBSG71NJIp/g8UFSBsOiesNZhsyLIOr5QmU1XaXYS49ppPMl8SnpsQz4qZEQrerAf9OI1CZAZAE5xwuQCmAR6dXhbqyU7no01o60PI83wowoC5T3BMBP1vRV9dxPtOWFG01At4NehabbBqG22wFn3UHciexuyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o4thHGD1; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-592f9400b04so4589365e87.3
        for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 16:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761606814; x=1762211614; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cVb3sBQg3S7kfhJuRLHfxPiQ08+Bc1FaH34bvysQgyo=;
        b=o4thHGD1/OUIjggnndqTnwnlW10eAEpX/HB4h+bHLKvOx8B1TxlHznc4je/pXuHVJb
         KUWtUQR1veipMr2Rmi2ifY0nHaQJE4SOZsgGUYvgroxjQaBNPA4fc8tIJjVWU+P5ydbN
         NMUJ0wQsP36BKbBPsDSPRE7pBO2mpYQgI0W6TZleqsHMtObXMIq70gyxPDxYUJwNLxh8
         XlEkLw2+Qf2apLB06O5B0unQU9dZVLF2iZhswvxbkKJ9L9OijIDYQO/dP7G6zUwDGVKX
         XkCJBuLbYSDWcFoYhBoM28SI/CUXMs1s/NHilUSaIj2p9npeD+I+8mm5i9UUiERiMfDH
         VQCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761606814; x=1762211614;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cVb3sBQg3S7kfhJuRLHfxPiQ08+Bc1FaH34bvysQgyo=;
        b=tkgmLkaNTcvSJoNdOQrORMo62wto2//dYSvgQ6qi4HCFzkttvZ9r8MmWhUfE9PiFBS
         0A69a3ONeJmKi8L0YGMxRKzOnzgQ8W0QNC1lf4+r9M1/6AeFAJ6lFXn4Yq7pVGWZome+
         hD4rF2KQUNEU6weEBFbaxIFwwdYNEry+KhQ33cVpr/9wrnP03ZtU4QwdLB7WT/ekyY7K
         wnSzlquebPLGUqzjwK7W2bHBE6syy5HWntPW9o5Kdf7OHV68+LBPLRRQpfyoCHsB7bBU
         dRGpz2JChixnEPzJtiTDRaP6ECyo4Z1aKsPvpDXi4vd8tX5gTeifAKed/QnfnH+4XGpu
         Cbeg==
X-Forwarded-Encrypted: i=1; AJvYcCV/QJv4KcCHnsAdLujUheSEbKe31M5V949zLbvbu4CECWSOGX6+l3olimswP+HRY9g1GVM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRH51sXDl5Gx3Cfz1rUK8NucU1vq3RW7rLA1naj1w179y4+Z59
	8+B+kQgtGs7CldRVao7+Mne340do9uqFxBueOXb9JwabLAUV6cts1u2xeqeReocdQJ9CePocUtK
	Qzv4s7kxQjdB6UEfen2S+WgDKH3HQuOJ0+oPR3Dqg
X-Gm-Gg: ASbGncv4LTnDKyfHrO+t4MRYP5buFrHVZnLW/kZ5EfLDHf8gtdFu7YKo1nhs0UilIYo
	oXmtvPEj7QuEA6a1Lgs0Pk7o3qVL+0EE4QdywXOlIeV6Hv90xynXWzwsz4YmNwUr+3G1bfLkRCS
	DjazwNrIyGg8fOaq4CBK/kWXLSUZXvrQ+pdTPTZ0L2npHfsmXy+KTjmEwNnvqb2AuDGvok1/7CB
	BAqDsRZz0v4q7aaD4ogcxWGBxlDOLc8GdA4wue53AJCptlNfi3U0HXCXnj0Xm3DA37pqT8=
X-Google-Smtp-Source: AGHT+IGl3ca765JSYQeeeNWnOc4ez61Rh9cYHuTu2Z8wbfu4++aeMX3ejm6+mpCGbnxLweY96XJw4Qd/Jsw/gJioL2Q=
X-Received: by 2002:a05:6512:39ce:b0:585:c51e:e99d with SMTP id
 2adb3069b0e04-5930e98f2bbmr555951e87.3.1761606813913; Mon, 27 Oct 2025
 16:13:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1760368250.git.leon@kernel.org> <72ecaa13864ca346797e342d23a7929562788148.1760368250.git.leon@kernel.org>
In-Reply-To: <72ecaa13864ca346797e342d23a7929562788148.1760368250.git.leon@kernel.org>
From: David Matlack <dmatlack@google.com>
Date: Mon, 27 Oct 2025 16:13:05 -0700
X-Gm-Features: AWmQ_blG76O58dB2_ktM5H7ZDlww5WUOcPernLo2oZm94nuYAfy2S9NihsUA1rg
Message-ID: <CALzav=cj_g8ndvbWdm=dukW+37cDh04k1n7ssFrDG+dN3D+cbw@mail.gmail.com>
Subject: Re: [PATCH v5 9/9] vfio/pci: Add dma-buf export support for MMIO regions
To: Leon Romanovsky <leon@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev, 
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org, 
	linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 13, 2025 at 8:44=E2=80=AFAM Leon Romanovsky <leon@kernel.org> w=
rote:
>
> From: Leon Romanovsky <leonro@nvidia.com>
>
> Add support for exporting PCI device MMIO regions through dma-buf,
> enabling safe sharing of non-struct page memory with controlled
> lifetime management. This allows RDMA and other subsystems to import
> dma-buf FDs and build them into memory regions for PCI P2P operations.

> +/**
> + * Upon VFIO_DEVICE_FEATURE_GET create a dma_buf fd for the
> + * regions selected.
> + *
> + * open_flags are the typical flags passed to open(2), eg O_RDWR, O_CLOE=
XEC,
> + * etc. offset/length specify a slice of the region to create the dmabuf=
 from.
> + * nr_ranges is the total number of (P2P DMA) ranges that comprise the d=
mabuf.
> + *
> + * Return: The fd number on success, -1 and errno is set on failure.
> + */
> +#define VFIO_DEVICE_FEATURE_DMA_BUF 11
> +
> +struct vfio_region_dma_range {
> +       __u64 offset;
> +       __u64 length;
> +};
> +
> +struct vfio_device_feature_dma_buf {
> +       __u32   region_index;
> +       __u32   open_flags;
> +       __u32   flags;
> +       __u32   nr_ranges;
> +       struct vfio_region_dma_range dma_ranges[];
> +};

This uAPI would be a good candidate for a VFIO selftest. You can test
that it returns an error when it's supposed to, and a valid fd when
it's supposed to. And once the iommufd importer side is ready, we can
extend the test and verify that the fd can be mapped into iommufd.

It will probably be challenging to meaningfully exercise device P2P
through a selftest, I haven't thought about how to extend the driver
framework for that yet... But you can at least test that all the
ioctls behave like they should.

