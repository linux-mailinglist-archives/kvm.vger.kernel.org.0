Return-Path: <kvm+bounces-31716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E52979C694E
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 07:32:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9C7141F23C55
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 06:32:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E064C17D896;
	Wed, 13 Nov 2024 06:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DAxu25BC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF182594
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 06:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731479543; cv=none; b=X97Gz68ozVBIk8KnZOCDWBYiBURSHZqA3VKCIm7MaDEDzATrvt/R7YSLnanxEf3JnxYu1U03eBtSy5n2tjRaSGqByoNuOJqhYxD6eC3goNke7FByhiT3P91sDL2d3B7EzwglmQlQHcgQ0ChjDR+17hRhSTNWKj/00U0OHRO7H6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731479543; c=relaxed/simple;
	bh=dfPlndrRvx5LRPZ+CoWGofFBd31blE9k7qzq28w1Fn8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GQ7c6mhwmhba1DBZ1AlKgYcTaST4sRTypg6T5tKOd/LF7OgFZo7yJA0bD5iHMjChZYFHR9a3hKJfHWrn4lDlcTtiWpWZjwIvRku3Hhx6p+XR38L/OOSirM3PYq1t5LkEh+rPy2C09OTTbMG7mVkfUxjkS5+oVoLAQvLPcx00jEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DAxu25BC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731479539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0tpZJUhLYkQvz4/1c+WZKWxrz55qwMuTFTv1urMtlfE=;
	b=DAxu25BC2smBJ0bBnLUMMny9hhJ4K6di8LW5FefnEYjLigrOFQ0yyTcM4wc4/JIcdPe3M1
	pHwFD09BDO/fKRzZgbVeHBaLmLGelgDk7dx0CHRfRB7kCPK7l3qwXS2RJ2mayB3u03dVB4
	WWe/ZaGh31+YGHDoGqsC9Q1zipZB/9U=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-502-kPmWYqbXOyCt-HL_ZIjdKA-1; Wed, 13 Nov 2024 01:32:17 -0500
X-MC-Unique: kPmWYqbXOyCt-HL_ZIjdKA-1
X-Mimecast-MFC-AGG-ID: kPmWYqbXOyCt-HL_ZIjdKA
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-37d5016d21eso3612779f8f.3
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 22:32:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731479536; x=1732084336;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0tpZJUhLYkQvz4/1c+WZKWxrz55qwMuTFTv1urMtlfE=;
        b=nVzL0PIhMaj4F3T0wjt3o2kUWiKxKewSdSzqpeEfLrAr237ADjTjvtugcyyzAx2sAo
         L83G1ueQaxwNaJP0C8LSN8K57rLDn/NHZ+ciZte8rJBqdTQnq5DEPdgKOD9pdEQ+PW6O
         sUCQ2nu4sXLV50oeYYRoC+6fu2qwDZZBq2KXPXg5Bh9is6YB1+Fw5b2hknNAo1JKGBVz
         t37TdV3aBlLpJCDDT0k2zMospaEbrNZaT962jFXSmLTLTSMrMAMevtuwbPGzMQkFwic1
         XUE3qP6qcYG9Q3I8ps8SvTbVHZMLGxlC9Y8MHRz5avHH4VHCrbzd2Z1GJUoHiTdVcxON
         lR3A==
X-Forwarded-Encrypted: i=1; AJvYcCUDp2Zgds2CC3N77LJmLT/3PoQ9rHPMZfKeDjJ2tQq6gK1iL2epfurprOLBoSCtkp21wWM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqA32zKF9lN/wwdVyAdK4MzafDg2cARkYI8bpNx/M2GbwiK2UX
	EYdCTFylccp0dxAX+cAGnZaCBRdSKoqrcXMW75xJuYpEODWTYpNuCdPJSd4cFna3CKOoNJsywZP
	E5zYcCXZG1JJ2s5p+AS+bcdgzlmMnFL/Z67qKjmT3Q+7PmZFFog==
X-Received: by 2002:a05:6000:70d:b0:37d:3e6d:3c2f with SMTP id ffacd0b85a97d-381f1883bc1mr15818763f8f.47.1731479536587;
        Tue, 12 Nov 2024 22:32:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFm7j62RQtg2vMQRf7xE09cRkKXHfFgJ32M3aHTjmYlfby7/gQk3bMsScUdd8LU3HRpv1DW5w==
X-Received: by 2002:a05:6000:70d:b0:37d:3e6d:3c2f with SMTP id ffacd0b85a97d-381f1883bc1mr15818736f8f.47.1731479536229;
        Tue, 12 Nov 2024 22:32:16 -0800 (PST)
Received: from redhat.com ([2a02:14f:17b:c70e:bfc8:d369:451b:c405])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381ed9f8984sm17650303f8f.71.2024.11.12.22.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 22:32:15 -0800 (PST)
Date: Wed, 13 Nov 2024 01:32:10 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: virtualization@lists.linux.dev, Si-Wei Liu <si-wei.liu@oracle.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
	Parav Pandit <parav@nvidia.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost 2/2] vdpa/mlx5: Fix suboptimal range on iotlb
 iteration
Message-ID: <20241113013149-mutt-send-email-mst@kernel.org>
References: <20241021134040.975221-1-dtatulea@nvidia.com>
 <20241021134040.975221-3-dtatulea@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241021134040.975221-3-dtatulea@nvidia.com>

On Mon, Oct 21, 2024 at 04:40:40PM +0300, Dragos Tatulea wrote:
> From: Si-Wei Liu <si-wei.liu@oracle.com>
> 
> The starting iova address to iterate iotlb map entry within a range
> was set to an irrelevant value when passing to the itree_next()
> iterator, although luckily it doesn't affect the outcome of finding
> out the granule of the smallest iotlb map size. Fix the code to make
> it consistent with the following for-loop.
> 
> Fixes: 94abbccdf291 ("vdpa/mlx5: Add shared memory registration code")


But the cover letter says "that's why it does not have a fixes tag".
Confused.

> Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> ---
>  drivers/vdpa/mlx5/core/mr.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
> index 7d0c83b5b071..8455f08f5d40 100644
> --- a/drivers/vdpa/mlx5/core/mr.c
> +++ b/drivers/vdpa/mlx5/core/mr.c
> @@ -368,7 +368,6 @@ static int map_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr
>  	unsigned long lgcd = 0;
>  	int log_entity_size;
>  	unsigned long size;
> -	u64 start = 0;
>  	int err;
>  	struct page *pg;
>  	unsigned int nsg;
> @@ -379,10 +378,9 @@ static int map_direct_mr(struct mlx5_vdpa_dev *mvdev, struct mlx5_vdpa_direct_mr
>  	struct device *dma = mvdev->vdev.dma_dev;
>  
>  	for (map = vhost_iotlb_itree_first(iotlb, mr->start, mr->end - 1);
> -	     map; map = vhost_iotlb_itree_next(map, start, mr->end - 1)) {
> +	     map; map = vhost_iotlb_itree_next(map, mr->start, mr->end - 1)) {
>  		size = maplen(map, mr);
>  		lgcd = gcd(lgcd, size);
> -		start += size;
>  	}
>  	log_entity_size = ilog2(lgcd);
>  
> -- 
> 2.46.1


