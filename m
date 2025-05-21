Return-Path: <kvm+bounces-47312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B5C0ABFDA3
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 22:01:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D22C1BA5F0F
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 20:01:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7C7F28FABB;
	Wed, 21 May 2025 20:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bMpN5NbG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4BA22154A
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 20:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747857642; cv=none; b=VPJGtioPRASBmIkjVYiFHOy8wJTrWQ0Vfk86sulTkrM4/OmFnhf6NU7+ebNfWRTJMEtCToMbRo40SS/Emu+wWzid+HlXSl2vq0LDmE2gV3cax/FSPSh2BgW+x7eJePAyxXFfGQdIc3GhwsBgl21/oB94jldqV6VbSXVCJW44GKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747857642; c=relaxed/simple;
	bh=FLdGAjW0ervgkl6ULHtgn05JK80AMWZ7mlHdaJ48SKs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QdfVcA6zRCQDjZjFQISPfav9b3STLx1taVO9+T6mK3ge0F9QsZ/XJ4YS7mQnK1vYZUoaanwy3l7k9ZAFbeiamKR0+RrTYzTPmhMbr24G9PQFknK9/OmVepojG0ophTbc+G1s9AD4zlSym5BwSHSp03Hiig2xNlhn7ydoKgLp6yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bMpN5NbG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747857639;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YcCgMFV9L/DlaugznX+AK32Fe6PE9U4WUXzCuFd+lzo=;
	b=bMpN5NbG9GKetdnVdZipJrZh6AW+7Jgep9JCuRIZ3qoAH51M1jNHGTNvq7QByN5ARSV65x
	7blMz1YWOOiWi1nyQR5w5r5feLPHew5EtQy/J4luuJz5LHeNvvrXAdpqjD3z7LMjeHzXa8
	Mfp6SwvDLYYLC03iquZ6jxdjp2sE6Ls=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-53-6uib8-ycO72Q_4nuv5Fu3w-1; Wed, 21 May 2025 16:00:37 -0400
X-MC-Unique: 6uib8-ycO72Q_4nuv5Fu3w-1
X-Mimecast-MFC-AGG-ID: 6uib8-ycO72Q_4nuv5Fu3w_1747857637
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-864456fddb1so122008739f.2
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 13:00:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747857637; x=1748462437;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YcCgMFV9L/DlaugznX+AK32Fe6PE9U4WUXzCuFd+lzo=;
        b=tgxrH/riRBFOa9m/ta6UG/zegqY0aYsK68wmmttzbmG+Ta7DjU08QLtTen0AQShhiU
         AYvn/V1lKJ7HOi6fBkwtTw3AIGvez1wSOBoKSfxAW2nClXAKmHhrQeitcph7b1h2qvFU
         vvAwC4z7X3119jha9EvMxNY22am6YK9xVCBg6B8KKYibT0UPy38Fw/uDk+FwMj76meBS
         X8SNl0iDlm1/JLU0iAx+N9/N92w3tIjqAjGFXyw8B3iAW9CjLqppq6nHrQHWqP26YI1b
         TjLhhg8GRNHVCZU9TvSS8bX/+hj28eCLU0deohdFD5uEZj9sZaEKDgAVPb4l+2EL+hh4
         sbLg==
X-Forwarded-Encrypted: i=1; AJvYcCVieOFl0vTvsTSo/CrF9VG6hqy4M5zbWBxAbC1iXiyeja8HFJaPsYirV0YDZxagTSXM1xo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUeuxTKwj7DyEVsNVWJmmISfZU4qt9nBj1GLBYp2AZbI4TdPEo
	UEtDmIn5saAV+uY26vQQeWfAZk3gyfXiLCu26MPbLKuzNRdR/jU/hDK3DX5379M5aEKj6DZnZ4e
	X6czps5+iF4LKWdFGtKU1BudATsV7zZdplqoOGYMyMkJHvvJJ7RpFqg==
X-Gm-Gg: ASbGncsHXmZytJpK/RdTWYRdP2uP5hWPxGikdp0PnQUUxk5vj7UGrn6bFi7P1I/AWga
	qKQN5/4k+7cmUTfxmVJEIhvDVJ5S+TugY7ruaudQPvmy36/aQs3HmMSA7bjQy4JP7ZIQzhQqqGO
	t7fLDaA6hdhSBjIceL2kkHOj8x62e0fsOM/KpRRRfZx+UAD3XiFnqg3BOGzzcaxFkRD/UNfVx8v
	GzTda3oOcoD5WF+fBH/JP1P0EuXfE6x1MI9g9cavxavB7UhVXPkrdgUTjKTWn265oGauRoQDnhK
	/75dxHCqr7Kksys=
X-Received: by 2002:a05:6e02:2592:b0:3d6:cd13:8465 with SMTP id e9e14a558f8ab-3db842976eemr58520285ab.1.1747857636742;
        Wed, 21 May 2025 13:00:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGfbRH8sG+hMDJ4twll4a3+7UTBjij7/0NpcW2K6tYmMF450LaaEk1bRsfCpUPqXNVzkfCvJg==
X-Received: by 2002:a05:6e02:2592:b0:3d6:cd13:8465 with SMTP id e9e14a558f8ab-3db842976eemr58520195ab.1.1747857636370;
        Wed, 21 May 2025 13:00:36 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc4ea690sm2792806173.142.2025.05.21.13.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 May 2025 13:00:35 -0700 (PDT)
Date: Wed, 21 May 2025 14:00:34 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: lirongqing <lirongqing@baidu.com>
Cc: <kwankhede@nvidia.com>, <yan.y.zhao@intel.com>, <cjia@nvidia.com>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfio/type1: fixed rollback in
 vfio_dma_bitmap_alloc_all()
Message-ID: <20250521140034.35648fde.alex.williamson@redhat.com>
In-Reply-To: <20250521034647.2877-1-lirongqing@baidu.com>
References: <20250521034647.2877-1-lirongqing@baidu.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 21 May 2025 11:46:47 +0800
lirongqing <lirongqing@baidu.com> wrote:

> From: Li RongQing <lirongqing@baidu.com>
> 
> The vfio dma bitmap of p should be freed, not n
> 
> Fixes: d6a4c185660c ("vfio iommu: Implementation of ioctl for dirty pages tracking")
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 0ac5607..ba5d91e 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -293,7 +293,7 @@ static int vfio_dma_bitmap_alloc_all(struct vfio_iommu *iommu, size_t pgsize)
>  			struct rb_node *p;
>  
>  			for (p = rb_prev(n); p; p = rb_prev(p)) {
> -				struct vfio_dma *dma = rb_entry(n,
> +				struct vfio_dma *dma = rb_entry(p,
>  							struct vfio_dma, node);
>  
>  				vfio_dma_bitmap_free(dma);

Good find.  The change looks correct to me.  For the benefit of stable
backports, let's venture towards being overly verbose in the subject and
commit log.  My suggestion would be:

    vfio/type1: Fix error unwind in migration dirty bitmap allocation

    When setting up dirty page tracking at the vfio IOMMU backend for
    device migration, if an error is encountered allocating a tracking
    bitmap, the unwind loop fails to free previously allocated tracking
    bitmaps.  This occurs because the wrong loop index is used to
    generate the tracking object.  This results in unintended memory
    usage for the life of the current DMA mappings where bitmaps were
    successfully allocated.

    Use the correct loop index to derive the tracking object for
    freeing during unwind.

This gives us some context relative to when we might encounter this
issue (pretty rare) and the scope of the issue (bound to the lifetime
of the vfio_dma object).  If you approve I can incorporate this to v1
or feel free to send a v2 with these updates.  Thanks,

Alex


