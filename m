Return-Path: <kvm+bounces-58342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CE93EB8E5CA
	for <lists+kvm@lfdr.de>; Sun, 21 Sep 2025 23:00:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD19E189A57A
	for <lists+kvm@lfdr.de>; Sun, 21 Sep 2025 21:00:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD82E299952;
	Sun, 21 Sep 2025 20:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gi7E5twF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CC82951A7
	for <kvm@vger.kernel.org>; Sun, 21 Sep 2025 20:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758488384; cv=none; b=qbG+OgDM9nlrB2+woTWhjgIErs4I6GjUd2r6fzZIXt5chIReyfYxa683873etmn90WEf8UvPjMPrIuAYdnXwkCfkXUw9FX6jUOxwUMkTVKRTwFJpBMsM3MZ7/uJm7E8bZc6Ffe+CSYjTIQz74/kayQ0yfwVUdVEqFXe0uTrTB90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758488384; c=relaxed/simple;
	bh=i7pW9HwRwP2c7GQu7cmSv4/uxHxGCvk/Ta/jaDGnmYQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kuSD7Z7P5R21SKDDr1bRNN75ezMXdbclk7V4VSQNg9wDRoYXYEF/du7GXnyRRj9XbS228xZFPffAq3pD3i0Bwddld4HDhRxXnH2Qum4PWieP0sYYbGdRk3GIFtvuNknoXFrya8XZ3435b7TFdbUz7FIBQWQawb/XjtVz+MGXhCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gi7E5twF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758488381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cccTVUHrijNSX4z+x7tgOWrfdy/5n+8UzzmA9bxQJ4s=;
	b=Gi7E5twFr0IBWN+VLty9bS+FiEinGc+stbf+XFEgJv8RJnKf/U3rWf4XUCr/nqtad3Oer/
	17H1XDvFoG8YCH/dhJvt97pAJjIcahPHtvFHoVYedyJEy1aDNMoKWWy5HIrVH//CFm+1o/
	TdLlYHfDLtNBwh8CZ59EiTd9S9SEcwY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-449-bLoho5KrMFGeogJiHtSMkg-1; Sun, 21 Sep 2025 16:59:37 -0400
X-MC-Unique: bLoho5KrMFGeogJiHtSMkg-1
X-Mimecast-MFC-AGG-ID: bLoho5KrMFGeogJiHtSMkg_1758488376
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45df9e11fc6so22285895e9.3
        for <kvm@vger.kernel.org>; Sun, 21 Sep 2025 13:59:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758488376; x=1759093176;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cccTVUHrijNSX4z+x7tgOWrfdy/5n+8UzzmA9bxQJ4s=;
        b=lWGxseVNLv4RJ9okWznwKSHvtqDrdn5NN1KUn9S/G+S9XsTo1M8DJwgDaH+LG/b6Z1
         Fc6VoIzoiHxC3ajjxS1KkbuihumJBFMsxmbMUs/GlPpT2ytChlRPa0vxPWTMFvYOn2LT
         7mLEcsFlbVW682Rl/rWaCDjeq+0brlKtEHPGu55L3UWjTKvcpSiEj5umsC/TKydgjgj9
         xHoTFQWv+F+RUK0FHxDvKwwM+xYWu/fDffB8aSPYAbsNMipY5FcoWjXp7Z3HEuXuFA2n
         npxQTJTUEGqYFVeDpm2PDh9fz0ILDFQw4TBkub7SzI9VeCAm92VhJLdX2m/0KXHCFpoI
         HKiw==
X-Forwarded-Encrypted: i=1; AJvYcCWzgFTPePKW4prlbKb1Ezw4i4bOEWW6PnjpULGQ2h03XiuNuRxuVz5NooQ1dmxdkam9EYA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwO0jVmZRWFER7Sv5+mUbighZDcpruqgj1V8giq5aMX7IWNWPB7
	LMHyHPDDVKHt2WoB+fgDFHGCMalZBwx72Tebr9zYV4RnRdpD0A+WZQInfa9cc38JLN9Lxt/issI
	CpNOr0HnMEFM6lYZcrFCHXftjevHz3HQKX6Smb3EH2pXIGoM3KhCpTA==
X-Gm-Gg: ASbGncsk4veTSmuUG5ZaNU2u6q8q4EQmDLoyGKv1M3Dedt148B8uwUbrOr8ciQx0aQF
	tVVbOCWTyxWuL06SXBK/48xBCv/LT62jNPvUYi7YyyknydOAlx7mDdcWtIlBJhJH5b8rqescGRP
	bA6OrVfNVwUMUiq7STmbYx402ZU+WQomc2q9hmKd8yCIh506HZswHdImBTY1iY2XhwVpaRHf12P
	l9zl4eMnPP1J32NzEkHqcHY8l83+DNfrlK7qboadtk7ISqfe1Qqoz91zjhHZxW1+KxjUfH2gR0T
	X6FdysqAfDG27JS17fuZrBdeeIji/5ukwuE=
X-Received: by 2002:a05:600c:3b20:b0:45f:2805:91df with SMTP id 5b1f17b1804b1-467efb044f0mr75179825e9.20.1758488376290;
        Sun, 21 Sep 2025 13:59:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH+9gyh4b7Pe6vwSysrkjuIQgt/cb1zE0T12QzGBFLzTc0cFE1MvWmSWaHwMUzYdnnxQL7Ozw==
X-Received: by 2002:a05:600c:3b20:b0:45f:2805:91df with SMTP id 5b1f17b1804b1-467efb044f0mr75179775e9.20.1758488375860;
        Sun, 21 Sep 2025 13:59:35 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73ea:f900:52ee:df2b:4811:77e0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3fa9e584309sm3897012f8f.49.2025.09.21.13.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Sep 2025 13:59:34 -0700 (PDT)
Date: Sun, 21 Sep 2025 16:59:31 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: zhangjiao2 <zhangjiao2@cmss.chinamobile.com>
Cc: jasowang@redhat.com, eperezma@redhat.com, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost: vringh: Modify the return value check
Message-ID: <20250921165746-mutt-send-email-mst@kernel.org>
References: <20250910091739.2999-1-zhangjiao2@cmss.chinamobile.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250910091739.2999-1-zhangjiao2@cmss.chinamobile.com>

On Wed, Sep 10, 2025 at 05:17:38PM +0800, zhangjiao2 wrote:
> From: zhang jiao <zhangjiao2@cmss.chinamobile.com>
> 
> The return value of copy_from_iter and copy_to_iter can't be negative,
> check whether the copied lengths are equal.
> 
> Signed-off-by: zhang jiao <zhangjiao2@cmss.chinamobile.com>

Well I don't see a fix for copy_to_iter here.


                ret = copy_to_iter(src, translated, &iter);
                if (ret < 0)
                        return ret;





> ---
>  drivers/vhost/vringh.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index 9f27c3f6091b..0c8a17cbb22e 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -1115,6 +1115,7 @@ static inline int copy_from_iotlb(const struct vringh *vrh, void *dst,
>  		struct iov_iter iter;
>  		u64 translated;
>  		int ret;
> +		size_t size;
>  
>  		ret = iotlb_translate(vrh, (u64)(uintptr_t)src,
>  				      len - total_translated, &translated,
> @@ -1132,9 +1133,9 @@ static inline int copy_from_iotlb(const struct vringh *vrh, void *dst,
>  				      translated);
>  		}
>  
> -		ret = copy_from_iter(dst, translated, &iter);
> -		if (ret < 0)
> -			return ret;
> +		size = copy_from_iter(dst, translated, &iter);
> +		if (size != translated)
> +			return -EFAULT;
>  
>  		src += translated;
>  		dst += translated;
> -- 
> 2.33.0
> 
> 


