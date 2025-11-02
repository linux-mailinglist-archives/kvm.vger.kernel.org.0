Return-Path: <kvm+bounces-61768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CA22C29341
	for <lists+kvm@lfdr.de>; Sun, 02 Nov 2025 18:13:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9942E3AC20F
	for <lists+kvm@lfdr.de>; Sun,  2 Nov 2025 17:12:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CB762DC348;
	Sun,  2 Nov 2025 17:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="ARP+t+ms";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="v9KpaIcl"
X-Original-To: kvm@vger.kernel.org
Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60992DC33B;
	Sun,  2 Nov 2025 17:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762103529; cv=none; b=nTZJXdtzgRgNrd6v0NpMiWFiUzg0nEYIk8cTg53CBbCCtUaR1cdwUzzZYMcFjcYtPxZhePMfwrxfRHIRchzopLbddwEZAp1n914NbGjDeJx9I7ui71//tjlR02YI98s01iLkao3wiD8ZXNUVkM62nrl5AipUz6BRFcKQrNceHN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762103529; c=relaxed/simple;
	bh=ZbQWM333eBLyFenzpTOWcC6KjVle4EHg2EZGNEhUtcM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UBrFv4jLuXKYRFzD/x+Eoz/F3mUcpF4zJ2DxqKsb69JodWTIrGiiKRLz/DMsZ0e3zMTtEnKCHYsW0Tn6FVazIktot7+ikluW8xVYlZbH8HIv7vWZIwsFjZgj4IzFq5zerJvn9EXGfBP8SoYalg/EefKAZHxHBGbcKXXTwA0Bq28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=ARP+t+ms; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=v9KpaIcl; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id D3C421400085;
	Sun,  2 Nov 2025 12:12:04 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Sun, 02 Nov 2025 12:12:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1762103524;
	 x=1762189924; bh=a8GBlzVdFLqLDITNMfrx+jlxxxq6gfyNGi3CdsrexZI=; b=
	ARP+t+msJuI/3RJhhtYbBSFdEA7HyYjz67gdLAISlfgMVO+MnsQr8r1xk62dNhbd
	yI1NvYRfUV5jvNQigsXv5hM9shQ9mIGK7qiGfyO8fc5PQcGXpIOuwDEIZ3WwT5q7
	Gyox0q0Fnl1k6VbVxwNvzp/3PszW8Yb1PKA6OTjeFDd2fkXefL0kmJv1l77vIF5i
	YIgLYJgBqufautWfZLVDdNYHKouRVaxeHaRRsVRK+pLviBAK7gJaEXGEB4qNwR+7
	Hezxm8X7xwAKlixuVAWWSJ+8dOvKgWlCg4pqu016RbmhLzs+27VhTRQqLN29OogB
	3wjUYYJOaN6K34W+lgbHyQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1762103524; x=
	1762189924; bh=a8GBlzVdFLqLDITNMfrx+jlxxxq6gfyNGi3CdsrexZI=; b=v
	9KpaIclihxfYlmk593KmiTk5BxS4JIR7bgYvhR0NAwe80xqKE16tUXwNpDkvT269
	OFbT4TjgEiVVOOQDgfAiN06ZXLgRr482uVauwHbvA1UG6HKqcbJGpSpu62nfR9uw
	SZQP7sZg848DbQ/gj6+NF4RZuuTr+gfvhjGuc50FwmUunVlkhCkZ8S0QFToF9eDj
	Q9FsUBEScnBDJGasO2skhA9rIWRksj1tLSmc8bbPrE/V3omRv1tZDAkV/l5A1+pY
	zSXEjUYbPxiJ2N5N7CFusfzpEys4zyVu0WPlXGZHfQx2PC4canHEHDI8LJ045GIC
	moNcBmwwrBiSN+laj4PhQ==
X-ME-Sender: <xms:4pAHaaJvAQn91kmZ_L8EDo9K0hkQkKrMWH_IihatlP3lP5mfCsgZLA>
    <xme:4pAHaVGqzWItmKM9uVjZd7D7s73TPSJT17RH_QAqT7tOT2Lt3yN0HyR1RhuS_DqG1
    Am_YdNX9LPn6NdmN50A5pDf7ybqjSBfU9JLJSS02Nex2t7iHMwkLg>
X-ME-Received: <xmr:4pAHae4VRDGyqVonaYTLr6w6DuqmTaw4vZiOzLQ3Heo4t_Q0q99oFoXPKM8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddujeehkedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfgggtgfesthejredttddtvdenucfhrhhomheptehlvgigucgh
    ihhllhhirghmshhonhcuoegrlhgvgiesshhhrgiisghothdrohhrgheqnecuggftrfgrth
    htvghrnhepteetudelgeekieegudegleeuvdffgeehleeivddtfeektdekkeehffehudet
    hffhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hlvgigsehshhgriigsohhtrdhorhhgpdhnsggprhgtphhtthhopeefgedpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtoheplhgvohhnsehkvghrnhgvlhdrohhrghdprhgtphhtth
    hopegshhgvlhhgrggrshesghhoohhglhgvrdgtohhmpdhrtghpthhtoheplhhoghgrnhhg
    seguvghlthgrthgvvgdrtghomhdprhgtphhtthhopegrgigsohgvsehkvghrnhgvlhdrug
    hkpdhrtghpthhtoheprhhosghinhdrmhhurhhphhihsegrrhhmrdgtohhmpdhrtghpthht
    ohepjhhorhhoseeksgihthgvshdrohhrghdprhgtphhtthhopeifihhllheskhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepmhdrshiihihprhhofihskhhisehsrghmshhunhhgrdgt
    ohhmpdhrtghpthhtohepjhhgghesiihivghpvgdrtggr
X-ME-Proxy: <xmx:4pAHacmtyeD6hGjmG5yJylSyTA-HADMGajUjQCdmqT32jDrnaono_w>
    <xmx:4pAHadv8O87-N3u7RBjdpz4I-VpiuG28OEKea_LULbQEWM07iNrZow>
    <xmx:4pAHafSnW8NhnYBcocBvwjMJZJwKp-bH1sWpaSPhMezd7UcEP_aM4A>
    <xmx:4pAHaXEDRYciiigXo_h0MGBa4ZI4FQYqaBv7JF7YPQQn35BVrD5OoA>
    <xmx:5JAHaTjTYS-Qyu0V5EarqGMARTYneth4LDaS1-R29jSNkR8I4POCr7gf>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 2 Nov 2025 12:12:00 -0500 (EST)
Date: Sun, 2 Nov 2025 10:11:58 -0700
From: Alex Williamson <alex@shazbot.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
 Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
 Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Jason Gunthorpe <jgg@ziepe.ca>,
 Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, Sumit Semwal <sumit.semwal@linaro.org>,
 Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Kees Cook <kees@kernel.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <skolothumtho@nvidia.com>,
 Kevin Tian <kevin.tian@intel.com>, Krishnakant Jaju <kjaju@nvidia.com>,
 Matt Ochs <mochs@nvidia.com>, linux-pci@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 iommu@lists.linux.dev, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
 linux-hardening@vger.kernel.org,
 Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: Re: [PATCH v6 10/11] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <20251102101158.6d2c36c6@shazbot.org>
In-Reply-To: <20251102151253.GA50752@unreal>
References: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>
	<20251102-dmabuf-vfio-v6-10-d773cff0db9f@nvidia.com>
	<20251102080137.209aa567@shazbot.org>
	<20251102151253.GA50752@unreal>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 2 Nov 2025 17:12:53 +0200
Leon Romanovsky <leon@kernel.org> wrote:
> On Sun, Nov 02, 2025 at 08:01:37AM -0700, Alex Williamson wrote: 
> > We don't need the separate loop or flag, and adding it breaks the
> > existing reverse list walk.  Thanks,  
> 
> Do you want me to send v7? I have a feeling that v6 is good to be merged.

Let's hold off, if this ends up being the only fixup I can roll it in.
Thanks,

Alex
 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 24204893e221..51a3bcc26f8b 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -2403,7 +2403,6 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>                                       struct iommufd_ctx *iommufd_ctx)
>  {
>         struct vfio_pci_core_device *vdev;
> -       bool restore_revoke = false;
>         struct pci_dev *pdev;
>         int ret;
>  
> @@ -2473,7 +2472,6 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>                 }
>  
>                 vfio_pci_dma_buf_move(vdev, true);
> -               restore_revoke = true;
>                 vfio_pci_zap_bars(vdev);
>         }
>  
> @@ -2501,15 +2499,12 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>                                struct vfio_pci_core_device, vdev.dev_set_list);
>  
>  err_undo:
> -       if (restore_revoke) {
> -               list_for_each_entry(vdev, &dev_set->device_list, vdev.dev_set_list)
> -                       if (__vfio_pci_memory_enabled(vdev))
> -                               vfio_pci_dma_buf_move(vdev, false);
> -       }
> -
>         list_for_each_entry_from_reverse(vdev, &dev_set->device_list,
> -                                        vdev.dev_set_list)
> +                                        vdev.dev_set_list) {
> +               if (__vfio_pci_memory_enabled(vdev))
> +                       vfio_pci_dma_buf_move(vdev, false);
>                 up_write(&vdev->memory_lock);
> +       }
>  
>         list_for_each_entry(vdev, &dev_set->device_list, vdev.dev_set_list)
>                 pm_runtime_put(&vdev->pdev->dev);
> 
> 
> > 
> > Alex
> >   
> 


