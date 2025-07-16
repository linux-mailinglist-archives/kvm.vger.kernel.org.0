Return-Path: <kvm+bounces-52659-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 14999B07EBD
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 22:21:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 59B841C26951
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 20:21:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5126F2BEFE5;
	Wed, 16 Jul 2025 20:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fjquPn/a"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1D529CB49
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 20:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752697270; cv=none; b=NnD5VO8nKLCLZG42eTU74oAhNztJbht483Uq5mTGyTvjwQSeW/ca3WyukBeMsBcuYvduWb9Tg4hA4oSAMO5FUe4/ItLLEFrw0M2zJ3D7ChekXTTRKKDuJaS55pxRXGu1s2HykZZyyrYIY1ls1TTUWvfmxJHc/E5PADNY0h0KMMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752697270; c=relaxed/simple;
	bh=t88KmbHyB44bbJ+m9XJjRdiwTs2vrpjOGUTpqW6GDSQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e0k+SU2GLudSV6bN6x0hCThQ+wrRBu+qaD5/fJYXkuj9jnlEK7K+3ao3pljqNBRj+lZXc1i3G12YCOAub5Re43KdQRJHFIicRZyOh88Sbq9Aus+aQec/U2BfmWA6nLJXRDdr8Tkar02+JIsfipNDSOxazJgUyKO4jFfY+2NeODU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fjquPn/a; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752697267;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+KRyfEizDervzB9URwnxaW4EOZooRbX81eT+I8qjpbU=;
	b=fjquPn/ajNyxtiDK2JfU9vD/wSXCM032xaBIACC7dMfdQQ8CEax6Nwa4QweNWuC4yB8IHZ
	DCiaK8fzxZxL16d/yLur2lL+JMzbcygDPqnrDNLxKblDX/nJk0+5LzZHiFlosYQioYHb01
	PIzC79z4gn0hxB0VMQLuGkQmodeicbg=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-425-aczwf0tFOJOkaxVXv8BZLA-1; Wed, 16 Jul 2025 16:21:05 -0400
X-MC-Unique: aczwf0tFOJOkaxVXv8BZLA-1
X-Mimecast-MFC-AGG-ID: aczwf0tFOJOkaxVXv8BZLA_1752697265
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-87a17c254bfso5473739f.2
        for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 13:21:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752697264; x=1753302064;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+KRyfEizDervzB9URwnxaW4EOZooRbX81eT+I8qjpbU=;
        b=rXi3ztSNeaeU73vQDjzUg2/W2eIUboK747/02It9Av1L7BjUzFg8gfxcrMMqZGHPnH
         T1wwn15QlQzMrmFUFYdH6EQ/et8eZGDJ0xV6Gos751hWcU3se/uTtYrKPD6KeTauTzzC
         mAVmbOYuxI0Lyi66VL5CZYQ0BaOV73Bbe8o2JiqmqnyotogN5bH5ZKe+/NVs/yUGsCqP
         AjRJp+YxEIQ7m34SosuSdaE/NsLaalR1oALukRrpVuRNljwALz3x/WR/r6nJNEICoKd6
         kye/rWyXWcbunjzsdvJrGTFCMjYlcWf/2+HlLsoJa89o8v3e2yBx1SfbmpioCwMkXi7s
         0KnA==
X-Forwarded-Encrypted: i=1; AJvYcCVB72f5YQCo1lkej1T9CFSHSKCgC3rNepfXYt53MT+sxe1TKxGuL6pcCNb4xvYk/b4EA3Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywk7Y6yZ+ZyirogzDSXD/OUuXKiaCgyG2vVUoCw4wh+2jBlB30p
	nCvpvqIAimSvH1WLNImNroQcwWTbvQnetRj9D4YPuC6eC3cSLOilv8Fg72Le6o7oVUEx+fiMZ5A
	Jh3H/GqZ7/9ECu3InX3rgW5paO69thjPB9GaIZcGB04X2qd7mVhUovEX2nnKEPA==
X-Gm-Gg: ASbGncsMyokgR1yXuJlSk5q+aqyJ2ZwfQIoW5z2VPXPQw6SfVf3O0cAN0mvYTGNwCy4
	kYJKCM8+ROB9wplYGS0QWIZ4jRQ45Y6PHViewinlyyWKjrrshZ1el+cXeGMPbT9Cv8hPT/y+hC0
	Z0JPcnEW0DTLQMz4k+jPqxII0KwsWVsFIg2ku4IoyMOxag34KfOv88uHaoRlY/Ik6+Ujs1gnabE
	dg3RgAynVX+5Gn1ZWXnmHlnbHMKYPlXl77CNeuN/h+CxbnZzH9QqgB1UuofgSi82+E8OP7HLttb
	x/by6y7XH3ES/PXmj8mW9+XsT4fB4Mxwawlo0xoxIMQ=
X-Received: by 2002:a05:6e02:4408:10b0:3de:2102:f1dc with SMTP id e9e14a558f8ab-3e282306bfcmr7967305ab.1.1752697264411;
        Wed, 16 Jul 2025 13:21:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEyWD5jsgxIGv5H+miLBNx2eMzeqFCQfVYPaY0j+ulJJHdS7tIZYNZrZSZdkdlShI617odZGw==
X-Received: by 2002:a05:6e02:4408:10b0:3de:2102:f1dc with SMTP id e9e14a558f8ab-3e282306bfcmr7967225ab.1.1752697263897;
        Wed, 16 Jul 2025 13:21:03 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e24611ce92sm45232005ab.6.2025.07.16.13.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jul 2025 13:21:03 -0700 (PDT)
Date: Wed, 16 Jul 2025 14:21:02 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: lizhe.67@bytedance.com
Cc: akpm@linux-foundation.org, david@redhat.com, jgg@ziepe.ca,
 peterx@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v4 0/5] vfio/type1: optimize vfio_pin_pages_remote() and
 vfio_unpin_pages_remote()
Message-ID: <20250716142102.1db0ec85.alex.williamson@redhat.com>
In-Reply-To: <20250710085355.54208-1-lizhe.67@bytedance.com>
References: <20250710085355.54208-1-lizhe.67@bytedance.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 10 Jul 2025 16:53:50 +0800
lizhe.67@bytedance.com wrote:

> From: Li Zhe <lizhe.67@bytedance.com>
> 
> This patchset is an integration of the two previous patchsets[1][2].
> 
> When vfio_pin_pages_remote() is called with a range of addresses that
> includes large folios, the function currently performs individual
> statistics counting operations for each page. This can lead to significant
> performance overheads, especially when dealing with large ranges of pages.
> 
> The function vfio_unpin_pages_remote() has a similar issue, where executing
> put_pfn() for each pfn brings considerable consumption.
> 
> This patchset primarily optimizes the performance of the relevant functions
> by batching the less efficient operations mentioned before.
> 
> The first two patch optimizes the performance of the function
> vfio_pin_pages_remote(), while the remaining patches optimize the
> performance of the function vfio_unpin_pages_remote().
> 
> The performance test results, based on v6.16-rc4, for completing the 16G
> VFIO MAP/UNMAP DMA, obtained through unit test[3] with slight
> modifications[4], are as follows.
> 
> Base(6.16-rc4):
> ./vfio-pci-mem-dma-map 0000:03:00.0 16
> ------- AVERAGE (MADV_HUGEPAGE) --------
> VFIO MAP DMA in 0.047 s (340.2 GB/s)
> VFIO UNMAP DMA in 0.135 s (118.6 GB/s)
> ------- AVERAGE (MAP_POPULATE) --------
> VFIO MAP DMA in 0.280 s (57.2 GB/s)
> VFIO UNMAP DMA in 0.312 s (51.3 GB/s)
> ------- AVERAGE (HUGETLBFS) --------
> VFIO MAP DMA in 0.052 s (310.5 GB/s)
> VFIO UNMAP DMA in 0.136 s (117.3 GB/s)
> 
> With this patchset:
> ------- AVERAGE (MADV_HUGEPAGE) --------
> VFIO MAP DMA in 0.027 s (600.7 GB/s)
> VFIO UNMAP DMA in 0.045 s (357.0 GB/s)
> ------- AVERAGE (MAP_POPULATE) --------
> VFIO MAP DMA in 0.261 s (61.4 GB/s)
> VFIO UNMAP DMA in 0.288 s (55.6 GB/s)
> ------- AVERAGE (HUGETLBFS) --------
> VFIO MAP DMA in 0.031 s (516.4 GB/s)
> VFIO UNMAP DMA in 0.045 s (353.9 GB/s)
> 
> For large folio, we achieve an over 40% performance improvement for VFIO
> MAP DMA and an over 66% performance improvement for VFIO DMA UNMAP. For
> small folios, the performance test results show a slight improvement with
> the performance before optimization.
> 
> [1]: https://lore.kernel.org/all/20250529064947.38433-1-lizhe.67@bytedance.com/
> [2]: https://lore.kernel.org/all/20250620032344.13382-1-lizhe.67@bytedance.com/#t
> [3]: https://github.com/awilliam/tests/blob/vfio-pci-mem-dma-map/vfio-pci-mem-dma-map.c
> [4]: https://lore.kernel.org/all/20250610031013.98556-1-lizhe.67@bytedance.com/
> 
> Li Zhe (5):
>   mm: introduce num_pages_contiguous()
>   vfio/type1: optimize vfio_pin_pages_remote()
>   vfio/type1: batch vfio_find_vpfn() in function
>     vfio_unpin_pages_remote()
>   vfio/type1: introduce a new member has_rsvd for struct vfio_dma
>   vfio/type1: optimize vfio_unpin_pages_remote()
> 
>  drivers/vfio/vfio_iommu_type1.c | 111 ++++++++++++++++++++++++++------
>  include/linux/mm.h              |  23 +++++++
>  2 files changed, 113 insertions(+), 21 deletions(-)

Applied to vfio next branch for v6.17.  Thanks,

Alex


