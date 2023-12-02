Return-Path: <kvm+bounces-3262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C16F9801E77
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 21:26:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7AACE280C66
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 20:26:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C61638835;
	Sat,  2 Dec 2023 20:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WjohETuy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58BEA8
	for <kvm@vger.kernel.org>; Sat,  2 Dec 2023 12:26:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701548773;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iZJKmBTJ+Rbbpx8uaCWzSm8u5JZ8h0qLae0DxmI9+YE=;
	b=WjohETuyYMZohx9UabLQRTp7bYywPzrBF8RvrjA3jXGDJf+elacBtY/gIwQ/XR+ptjyW9j
	SU229D01Ma89V2oVgFcg1XW/aUI5XWYMJELLxmc/lYQFVIwofvW6/l+jEjyiV3IXNYTBnh
	b/jXZlNMZsQEpVet18Iyu+kjHieTxq8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-cNDzxT5WOQKX1BXPJmE4yA-1; Sat, 02 Dec 2023 15:26:11 -0500
X-MC-Unique: cNDzxT5WOQKX1BXPJmE4yA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-332efd3aa1fso2473683f8f.0
        for <kvm@vger.kernel.org>; Sat, 02 Dec 2023 12:26:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701548770; x=1702153570;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iZJKmBTJ+Rbbpx8uaCWzSm8u5JZ8h0qLae0DxmI9+YE=;
        b=rAMdvF3id9QW0p0PrV4qFGF4yLeE9kxs8i5RDb+vMFsABYIFvYAVb3LYC9pVrlUzUV
         qYM1NKO2jLvwINyhA2MJ06rr0YIBO5Ua9yC8/yXvpen7e07cdBuUqQ+rv9WvDGB3rP4g
         r2ErP1tcwiwj75unnuSX4uhZkG/GsTzOhxtpycRqziXL6P+lHNFFzsClp7j1PLxG4C70
         zdNZv6n+RHjdMNNyxYCuP7uZ/zim2hC3xnJVFs/00AjNvgH6STP6i93spCAAE3hK9Kj0
         qcLCN9uGHODFs5aAILCh+q2lvJhevZWJixcvXvFmOpAU59CWcTflecnc+HFw25S/I0k1
         x8gw==
X-Gm-Message-State: AOJu0YxHHeTphiULkogGrPhrkcW8H0auJ4700yjiNGcv/l5EKvk24hiX
	mZkqEFrDp1DnYEtmg0pJ9kXv1rsIyBzTe0aAexz0829amZGGlAo29WVGNqlKWPzib5MiGMR604u
	4SO+/Q/bgBLib
X-Received: by 2002:a5d:5485:0:b0:332:d11d:527c with SMTP id h5-20020a5d5485000000b00332d11d527cmr1940788wrv.8.1701548770112;
        Sat, 02 Dec 2023 12:26:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGWSenljZ8Gq1p+cvw45tJ66/qyTEFm/51Rm7X9PzXUkLubJG54yM5edqJ1p/+3klDKGwcuJA==
X-Received: by 2002:a5d:5485:0:b0:332:d11d:527c with SMTP id h5-20020a5d5485000000b00332d11d527cmr1940784wrv.8.1701548769779;
        Sat, 02 Dec 2023 12:26:09 -0800 (PST)
Received: from redhat.com ([2.55.57.48])
        by smtp.gmail.com with ESMTPSA id e5-20020a5d4e85000000b0033333bee379sm4281524wru.107.2023.12.02.12.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Dec 2023 12:26:08 -0800 (PST)
Date: Sat, 2 Dec 2023 15:26:05 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>,
	Si-Wei Liu <si-wei.liu@oracle.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Gal Pressman <galp@nvidia.com>,
	Parav Pandit <parav@nvidia.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost 0/7] vdpa/mlx5: Add support for resumable vqs
Message-ID: <20231202152523-mutt-send-email-mst@kernel.org>
References: <20231201104857.665737-1-dtatulea@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231201104857.665737-1-dtatulea@nvidia.com>

On Fri, Dec 01, 2023 at 12:48:50PM +0200, Dragos Tatulea wrote:
> Add support for resumable vqs in the driver. This is a firmware feature
> that can be used for the following benefits:
> - Full device .suspend/.resume.
> - .set_map doesn't need to destroy and create new vqs anymore just to
>   update the map. When resumable vqs are supported it is enough to
>   suspend the vqs, set the new maps, and then resume the vqs.
> 
> The first patch exposes the relevant bits in mlx5_ifc.h. That means it
> needs to be applied to the mlx5-vhost tree [0] first.

I didn't get this. Why does this need to go through that tree?
Is there a dependency on some other commit from that tree?

> Once applied
> there, the change has to be pulled from mlx5-vhost into the vhost tree
> and only then the remaining patches can be applied. Same flow as the vq
> descriptor mappings patchset [1].
> 
> To be able to use resumable vqs properly, support for selectively modifying
> vq parameters was needed. This is what the middle part of the series
> consists of.
> 
> [0] https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git/log/?h=mlx5-vhost
> [1] https://lore.kernel.org/virtualization/20231018171456.1624030-2-dtatulea@nvidia.com/
> 
> Dragos Tatulea (7):
>   vdpa/mlx5: Expose resumable vq capability
>   vdpa/mlx5: Split function into locked and unlocked variants
>   vdpa/mlx5: Allow modifying multiple vq fields in one modify command
>   vdpa/mlx5: Introduce per vq and device resume
>   vdpa/mlx5: Mark vq addrs for modification in hw vq
>   vdpa/mlx5: Mark vq state for modification in hw vq
>   vdpa/mlx5: Use vq suspend/resume during .set_map
> 
>  drivers/vdpa/mlx5/core/mr.c        |  31 +++---
>  drivers/vdpa/mlx5/net/mlx5_vnet.c  | 172 +++++++++++++++++++++++++----
>  include/linux/mlx5/mlx5_ifc.h      |   3 +-
>  include/linux/mlx5/mlx5_ifc_vdpa.h |   4 +
>  4 files changed, 174 insertions(+), 36 deletions(-)
> 
> -- 
> 2.42.0


