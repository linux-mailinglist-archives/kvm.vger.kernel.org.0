Return-Path: <kvm+bounces-67917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 82C71D17046
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 08:30:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1EFB030124C3
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 07:30:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6745630EF82;
	Tue, 13 Jan 2026 07:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qdj9iDRW";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hu3xkvuf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B8419CD0A
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 07:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768289422; cv=none; b=FMfHGPaQ1mTMpan9XRSMVSkH8Ch8wfE/Yu2WKi7enm+HCtQuoQpxfm2i/5DzjfblJ5wnwPIDB3m2iDmB7zBJGGRGqajyvny/gvYD4QYfb+ZzJyXMsYDggvCXDPr7SSa8hAq4AnzEZRh8UwtO6Tf4QEv5+6jt6dh2z41OXGl2qGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768289422; c=relaxed/simple;
	bh=s0jNNTCFNE3uPdMhFoPhUG0485jwxbZ2R+RoOksHx5c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SPuUArX1My86NbrNsf7jDO9ivFHHTMMslj/8ByDNFUeknB1s0OCUQtZ7+FVtj1stcYIi3R8af6stGAR54zeDS6RLkTBrjBL7gAhEJySPip13WAmGZkyUq1T/DTQrXLMLwwGkRRgMxVNuNipR3ahlfXUFdWhBW6L1g0BQt24sEi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qdj9iDRW; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hu3xkvuf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768289420;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wiNF2ZRVVEZ6E26LXjvC+Q546JUw1TsWOthVS73LBBw=;
	b=Qdj9iDRW/aKsBw8HNwtOi6AwCXw7WHpqkg+dBNikh8wWHRipd8vpixoovry3WS0zGmwDvj
	Y2Wc4uTIYAs336Y/BcxdV0Y2jn6FWHE56Aj3zcPNAne0RT7nMFXndEFB7abfwlOAWwYVjS
	Nj5EpbTlZJpT2ZopF6IfD1ZDMpxrUJo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-576-1DQYlYzZMHCgJmktHmvRyA-1; Tue, 13 Jan 2026 02:30:18 -0500
X-MC-Unique: 1DQYlYzZMHCgJmktHmvRyA-1
X-Mimecast-MFC-AGG-ID: 1DQYlYzZMHCgJmktHmvRyA_1768289418
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-47d3c9b8c56so75265425e9.0
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 23:30:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768289417; x=1768894217; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wiNF2ZRVVEZ6E26LXjvC+Q546JUw1TsWOthVS73LBBw=;
        b=Hu3xkvufn78FZdBEEX1IdPZFwyD/nIXq0pMZ26krCPKgxE8HfsF6nuo93gESERcw86
         EbzrF3vJFCncxk6NALu9WHyZjhs0GNKZHIJ4DmX0KC9vOOyRFiM14uavu7qIx02uKe1a
         rwQBHg59EjNzFqSRoszN2h9tndEht8pO2YXYoHYQRhxZxp7C3/7tTfcR/NluQPTaL0py
         j/ybjS6O1kUqo27rufyygKHMKTtnAU9eUJ54rq4sTqiz+bAePCurm6X5sU7GIdoHAPdg
         pVCMfgDKELhnLVNWwhzsQqX0dWlhjm1gdQtPsCcV8S9zpXvIbq+T7S72bGpTml53IT31
         wPwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768289417; x=1768894217;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wiNF2ZRVVEZ6E26LXjvC+Q546JUw1TsWOthVS73LBBw=;
        b=i2Lqk/YjcNwxx4v1vNdbLv9vCl1rrh7sOrQTmkfeOvJe8bmG1KtWrJ7h+ujSedJp9G
         xrvrzSGbG6/DktIhrAtfeqju03jjohfZt8/GhCAVFLUYz7K9c9MltGMU36sPYuk3+r5i
         gWOM9SlJTfiS7R78Pj2kh8bTaU8AljTdkA/BCBhKbhinHDJp4eyX5sL63s7c/Dtb7jb0
         MOWiWmPCdlLaGm+HRigPmh/IQ2xgiAHgYjSL+lbw9P8pVrWFTqjVuGp0+LH6E6oBJAin
         2WsIn/3Vpak81OGlfCipesCwECOc8rbWmJdH4m14Mf7mIvX28Us3uI8MtmU64P3v2CTm
         edvQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQGmqskSu7opbqoxnDiBsyI+nwR2Us0AE64XfLj/EfKShVGknLc/V+iM/2+cZ6afAkvWQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUwWBiDMPxpwesy+29QaYqZXF7QuyKO5w5eoDQjRI9Zr+itSIu
	a+IkRS3GD3zfXFNflXb8d5UDEbVp9CiH7smiuzEXhJ6CUT41NvDA9HSXfba8E87zc01Tv4/Aqag
	/0K5wWR0vgsM/5RYj8sp7+drzOEnaEB4O3hZQ/8GeCgDlkhtWfZZJzQ==
X-Gm-Gg: AY/fxX4ggC247D8IuAimT06hgTfliJX9Qnckv6PD+/+DnLTX/QjqXykv8F/rlv7t2z3
	r/HDAYKRjFew+4eIV34sSZAfKiPR/fHlG5Mmx2NRALotX+/WgEbJunIFj5oZFvSIH22LEvzTfC5
	2y1m+S+zc8t9yxyti6MaIj+u4hifnIRgFb0g50mNbdQNiJbOamljTXuZGuA/A3lpRNBEYrbCy0R
	z8jNz/X5y3ezB5avefDirQbyP4+RgbLM6gU8TagR0AIeuvIVtL2voKLygr/kL8okVjTHyLJX0Uv
	x3S5ZVG/sFNW8CHZM8MZv41FwDIHYSaibq9DF7hAcefnISLo9h8tGY32M7ZBGFU3RauheO8HJxC
	JdizPCRhrHlQMjBmQuCu8rHWbdFHEUS4=
X-Received: by 2002:a05:600c:c3cd:20b0:477:af07:dd21 with SMTP id 5b1f17b1804b1-47d8a17124bmr147932005e9.25.1768289417460;
        Mon, 12 Jan 2026 23:30:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEZ7vVe0350H0JVYXQsiMlO2kPVRC9RBhfa40QZOD1BpNkmOPxCYFtpzNzUhbsBf042icJ1Ug==
X-Received: by 2002:a05:600c:c3cd:20b0:477:af07:dd21 with SMTP id 5b1f17b1804b1-47d8a17124bmr147931635e9.25.1768289417019;
        Mon, 12 Jan 2026 23:30:17 -0800 (PST)
Received: from redhat.com (IGLD-80-230-35-22.inter.net.il. [80.230.35.22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7f6ef868sm387228755e9.11.2026.01.12.23.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 23:30:16 -0800 (PST)
Date: Tue, 13 Jan 2026 02:30:13 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Kommula Shiva Shankar <kshankar@marvell.com>
Cc: jasowang@redhat.com, virtualization@lists.linux.dev,
	eperezma@redhat.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
	jerinj@marvell.com, ndabilpuram@marvell.com, schalla@marvell.com,
	dtatulea@nvidia.com, jgg@nvidia.com
Subject: Re: [PATCH] vhost: fix caching attributes of MMIO regions by setting
 them explicitly
Message-ID: <20260113022538-mutt-send-email-mst@kernel.org>
References: <20260102065703.656255-1-kshankar@marvell.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260102065703.656255-1-kshankar@marvell.com>

On Fri, Jan 02, 2026 at 12:27:03PM +0530, Kommula Shiva Shankar wrote:
> Explicitly set non-cached caching attributes for MMIO regions.
> Default write-back mode can cause CPU to cache device memory,
> causing invalid reads and unpredictable behavior.
> 
> Invalid read and write issues were observed on ARM64 when mapping the
> notification area to userspace via mmap.

device memory in question is the VQ kick, yes?
So if it is cached, the kick can get delayed, but how
is this causing "invalid read and write issues"?
What is read/written exactly?

> 
> Signed-off-by: Kommula Shiva Shankar <kshankar@marvell.com>
> Acked-by: Jason Wang <jasowang@redhat.com>

I also worry a bit about regressing on other hardware.
Cc nvidia guys.


> ---
> Originally sent to net-next, now redirected to vhost tree
> per Jason Wang's suggestion. 
> 
>  drivers/vhost/vdpa.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 05a481e4c385..b0179e8567ab 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -1527,6 +1527,7 @@ static int vhost_vdpa_mmap(struct file *file, struct vm_area_struct *vma)
>  	if (vma->vm_end - vma->vm_start != notify.size)
>  		return -ENOTSUPP;
>  
> +	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>  	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
>  	vma->vm_ops = &vhost_vdpa_vm_ops;
>  	return 0;
> -- 
> 2.48.1


