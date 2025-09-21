Return-Path: <kvm+bounces-58345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4387B8E6A3
	for <lists+kvm@lfdr.de>; Sun, 21 Sep 2025 23:41:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 43ED217CA3C
	for <lists+kvm@lfdr.de>; Sun, 21 Sep 2025 21:41:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 595E72D0C8A;
	Sun, 21 Sep 2025 21:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HfImf5VB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E836828D82A
	for <kvm@vger.kernel.org>; Sun, 21 Sep 2025 21:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758490874; cv=none; b=bIUpHgnJrnWdRNy6T5d4kldH9DtiGIw+3jDM2orIwQcizAH9olg5YLoNGwx7MfupaTP+lwCK8klOn5+beVevtQlzFMJVhRJIc8CQtuYnlM7vwMLiVIJBRdD526RPn3FT0kUKpzcRLrZ+SOwJAEZQElv65nN3GNO0+DXnFhe3U+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758490874; c=relaxed/simple;
	bh=2eRQFz6lTYzuVrxi3sraTdoTI5Gov5pFUQwZMiCSUHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gU/aiaMIwJ2k5eViFFucG7p6dad9TQjU/+SKkx/t+943qlJZ+BCJ3TRzYhtGscIe7Nzd/MTRy55De82HumVzfh3U20G5pH9YAvT3gd6jsF+Px+/CyTUONFdT12UuFKUgWUJNJ4zeGoxpvxMerf0AzyrWuxvci471X/EfJuLtDfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HfImf5VB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758490872;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8KqMplkScTYjn/2difwf3vbnDC8sEidYGpK87XWS4RY=;
	b=HfImf5VB/DRnYarMxOBuBVrZ8mvFKQBxaEPvXy9umsr7DrFEPpkrmN1V1ZnARDp6Lvd1Rb
	O923KH2dtz/mt6pWOV9qoPSUHU29ECiGAOuFzhqvNcPXJN5uK3ye5kEl6uhRVhbYNIt4s6
	d7iLN43gMTUyLzsGfI7DY8Y9kmCIUk4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-127-PJS8oJzFPWejjLk9frJbRw-1; Sun, 21 Sep 2025 17:41:10 -0400
X-MC-Unique: PJS8oJzFPWejjLk9frJbRw-1
X-Mimecast-MFC-AGG-ID: PJS8oJzFPWejjLk9frJbRw_1758490869
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46c84b3b27bso5051015e9.2
        for <kvm@vger.kernel.org>; Sun, 21 Sep 2025 14:41:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758490869; x=1759095669;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8KqMplkScTYjn/2difwf3vbnDC8sEidYGpK87XWS4RY=;
        b=X5OJfuOC+ctk00ijrHaT1i0W4vuInI7pNG2tAoKRi5RU/mGMgQ/KYv5aJ+1fg8HeHK
         +eCm8q8t6ClXflCySwPUjduAgJ/NdW8iqt4Rq8qo50H543oCbVwnZModkvuwRa8tbz7O
         9HiTlvnLz8S6F6Vksi4ULlS3wj/cm3F+QwNYtEYYNWpuhZ8S9uYDoeIXuJJysbQi8yX9
         V3DGPJ4bGc7/OajAN2gdpbQYgAeLlqzcVYxafSN8Il2tKSrS+vl2k2r6SDlaDeA1+oND
         mo9w7XhVbYBZnQaQj1X9MqGwdi7vQ3goROVCC5kYC8d/nEbSjut7YMlaE2SavdsZKLNh
         IhQQ==
X-Forwarded-Encrypted: i=1; AJvYcCU7M70ZWIaq9FI9Tf2GMoxMz2/KXPyXts1Sq+Phg9mwidhYRKqSIYrLHxyNaNDMjh/JeIs=@vger.kernel.org
X-Gm-Message-State: AOJu0YztoQGrP8jw9WdGtUl0X5T64JEu+ys1ce0/5yvJjRNHfj/4S7V7
	ApVasTjlXJzG5eF4PS5Hx2QZsF5Vwo/9g1gqzMxK20JlNKKILHcQtFkwOfQMJfimLdv/g771kcR
	cYdEpSQ4kxDgEKqXvn24fnZYeSaSMikRjJO+SIjUZTNFqbypAPOpMXg==
X-Gm-Gg: ASbGncuhFmktck88ADv3AUSSH19NHJgzGh1V5cVXOukA2SiiNWWa4JaQ0IBQ0QISKLV
	jY9K6O9sG/hxu3sYhcHqL0qiwou+wr+h1CDOch2snR27Ddg0I35fUJpA2E8oIBTCBCLyE+93J3Y
	fY+gveP7tsQ+jsmN02Dd2la3xDTfS+SRAUKBLP4QW5T+6D+MW9QjIZ5wlPWT6xAOwxouFMAXXnV
	K4ETU++3zpnHbRVBu1OiqPAwcUZfS/Gyqz13ueyqn3HXuLaQMYnyaWtvkgEoebrDQoYQp5r1CCW
	/II5MyzdvsnHYslwY7KIoUTpzEfv2lCP5rQ=
X-Received: by 2002:a05:600c:4fc3:b0:45d:ddc6:74a9 with SMTP id 5b1f17b1804b1-467eed8f915mr93974065e9.12.1758490869188;
        Sun, 21 Sep 2025 14:41:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHE3ONLO0TqDIpbwZ8tdp1Uhm0ZVS1N782aV32rBmMI81RJxSBnbtQKfoquKrW3T2JV+taGEw==
X-Received: by 2002:a05:600c:4fc3:b0:45d:ddc6:74a9 with SMTP id 5b1f17b1804b1-467eed8f915mr93973945e9.12.1758490868782;
        Sun, 21 Sep 2025 14:41:08 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73ea:f900:52ee:df2b:4811:77e0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4613d42bee6sm221283755e9.15.2025.09.21.14.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Sep 2025 14:41:08 -0700 (PDT)
Date: Sun, 21 Sep 2025 17:41:05 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: zhangjiao2 <zhangjiao2@cmss.chinamobile.com>
Cc: jasowang@redhat.com, eperezma@redhat.com, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost: vringh: Modify the return value check
Message-ID: <20250921174041-mutt-send-email-mst@kernel.org>
References: <20250910091739.2999-1-zhangjiao2@cmss.chinamobile.com>
 <20250921165746-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250921165746-mutt-send-email-mst@kernel.org>

On Sun, Sep 21, 2025 at 04:59:36PM -0400, Michael S. Tsirkin wrote:
> On Wed, Sep 10, 2025 at 05:17:38PM +0800, zhangjiao2 wrote:
> > From: zhang jiao <zhangjiao2@cmss.chinamobile.com>
> > 
> > The return value of copy_from_iter and copy_to_iter can't be negative,
> > check whether the copied lengths are equal.
> > 
> > Signed-off-by: zhang jiao <zhangjiao2@cmss.chinamobile.com>
> 
> Well I don't see a fix for copy_to_iter here.
> 
> 
>                 ret = copy_to_iter(src, translated, &iter);
>                 if (ret < 0)
>                         return ret;
> 

to clarify, pls send an additional patch to copy that one.

> 
> 
> 
> > ---
> >  drivers/vhost/vringh.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> > index 9f27c3f6091b..0c8a17cbb22e 100644
> > --- a/drivers/vhost/vringh.c
> > +++ b/drivers/vhost/vringh.c
> > @@ -1115,6 +1115,7 @@ static inline int copy_from_iotlb(const struct vringh *vrh, void *dst,
> >  		struct iov_iter iter;
> >  		u64 translated;
> >  		int ret;
> > +		size_t size;
> >  
> >  		ret = iotlb_translate(vrh, (u64)(uintptr_t)src,
> >  				      len - total_translated, &translated,
> > @@ -1132,9 +1133,9 @@ static inline int copy_from_iotlb(const struct vringh *vrh, void *dst,
> >  				      translated);
> >  		}
> >  
> > -		ret = copy_from_iter(dst, translated, &iter);
> > -		if (ret < 0)
> > -			return ret;
> > +		size = copy_from_iter(dst, translated, &iter);
> > +		if (size != translated)
> > +			return -EFAULT;
> >  
> >  		src += translated;
> >  		dst += translated;
> > -- 
> > 2.33.0
> > 
> > 


