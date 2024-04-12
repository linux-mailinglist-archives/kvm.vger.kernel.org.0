Return-Path: <kvm+bounces-14529-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E02EE8A3062
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 16:21:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A329B287025
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 14:21:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C024986258;
	Fri, 12 Apr 2024 14:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cORVpr7V"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701C885939
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 14:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712931660; cv=none; b=kCtW34/CTcfQ4NuoRCBm77Cfi8AwgBp76ipPC5DEOgIWZSA3ExqNE7DrA2K+YVzHVQNKiNpZeZ+HR9tJuFxyprksv6xktcxtf1wLIOboWWHRvb+fb0hxLGiljhgb/Xdn+HcBTbF+TD91h/GBkD5G04t6Sw7NlOHsIUen2T4TkWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712931660; c=relaxed/simple;
	bh=UP+cGmNiYoAwGW8m8W6yr/q48Hsj4d5EwX9JW9HfKBw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hKqWoixo5Zo03a2f2zrXvtessRleNavS8GNQe/rCfrYsE1Qe3LX4+V+2XqnFMoc1EqnR9VQFZZvLhzYUi8wWN/ZomNGtD/Ka9UI6J8blU/S9NMhQXWDbGZNzK3bEszYTwor5TJHBfVl64EBut1xKW31cHgQVpNLnGQb4iKv0uGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cORVpr7V; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712931657;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qgw0vEZxafA068CWQUUNtsQrgIh5CdevYV3sXi6m8+Q=;
	b=cORVpr7VYzrcPSSyVnIHQoa4M9WyR7GpwyTbpiykR8fzDaSf5lo9WHTkrcMTdYlgvqwa3N
	mhJyA7evgFxZr1j4G73aUQWsTExl6F47ywyXqobSiT9BciN2wc6y+RZjwY+udEmKsR7418
	CJSn2Hx0XeE7+RPkVhXV8WXRn/5fnD4=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-nkYzyN3tMcGNNe-OKhsyHQ-1; Fri, 12 Apr 2024 10:20:55 -0400
X-MC-Unique: nkYzyN3tMcGNNe-OKhsyHQ-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-36a20206746so10854515ab.3
        for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 07:20:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712931655; x=1713536455;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Qgw0vEZxafA068CWQUUNtsQrgIh5CdevYV3sXi6m8+Q=;
        b=Nt6WsqPNtoHJWVIWIIHiuQq8xpGZtKqOXna3HRChG9VTRfl4So+YYE+plJO5E4OeVv
         jNY+zo0WHD52zOqUvUPMLPEpeKrjcTFWENq7PLCzH6RO602IA8X9LGC9aOdJuWf82Yfz
         Cfcmpja6sEvb5jWEVIlYNCl4Q0obKhdNnkLE/RAvePENv9UM2Oe1CaaKm2BR634YCXCs
         vsR6GjAmi8Cu+eGxrvPVlOUo0tXFrEKrR0NwdaNFI2oOrpv69N/j19V0t/bUVsHGMEwY
         SKe8TQp+mBNwYHr7srnWCRR8efCpvCyClpUUIErgYRA6b3ZkdvBMQ4AfIaBBnX3B6zjD
         91nw==
X-Forwarded-Encrypted: i=1; AJvYcCUbmdcbavkQ+vnkaFZZ1g03IfU7JA4ztuQol2GhgU3Ee8CPDI444s0i+3hZBuv9gl/6glUKo43uPlaZfhGoL42iBWK4
X-Gm-Message-State: AOJu0Yzc9n27JunUOoKtbrkHjYeilUb7nSaKGm2T/Tg+OztNn8VJcLL/
	hrKDbwRtNaj4UjJc1vTxhO+pNPAXolpyScj+MDpx7jb8vTwHKKa4Aj31XqTZeLH4TsFfuZQR3+i
	xw7tfZO8QetmSYivSdlHawh+IkrqstjiYhkJn9kWB6bLM4DDK/w==
X-Received: by 2002:a05:6e02:1b05:b0:36a:15bb:608c with SMTP id i5-20020a056e021b0500b0036a15bb608cmr3096345ilv.28.1712931655020;
        Fri, 12 Apr 2024 07:20:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4qm2aJCy42jLqJ2UrSQkuMIunPpATTlPV/ijXzsxxU6bggEIQyJkHYotnp6ZEyuowvnaGdg==
X-Received: by 2002:a05:6e02:1b05:b0:36a:15bb:608c with SMTP id i5-20020a056e021b0500b0036a15bb608cmr3096329ilv.28.1712931654707;
        Fri, 12 Apr 2024 07:20:54 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id r12-20020a92ce8c000000b00368706996b8sm1000820ilo.38.2024.04.12.07.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Apr 2024 07:20:54 -0700 (PDT)
Date: Fri, 12 Apr 2024 08:20:51 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: JianChunfu <chunfu.jian@shingroup.cn>
Cc: cohuck@redhat.com, linux-kernel@vger.kernel.org, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: Re: [PATCH] vfio: change the description of
 VFIO_IOMMU_SPAPR_REGISTER_MEMORY
Message-ID: <20240412082051.0f9959e3.alex.williamson@redhat.com>
In-Reply-To: <20240412085333.1286724-1-chunfu.jian@shingroup.cn>
References: <20240412085333.1286724-1-chunfu.jian@shingroup.cn>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 12 Apr 2024 16:53:33 +0800
JianChunfu <chunfu.jian@shingroup.cn> wrote:

> The type1 ioctl(VFIO_IOMMU_MAP_DMA/VFIO_IOMMU_UNMAP_DMA) won't be called
> in SPAPR machine, which is replaced by VFIO_IOMMU_SPAPR_TCE_CREATE/
> VFIO_IOMMU_SPAPR_TCE_REMOVE, so change the description.

This does not match my understanding of SPAPR which is that memory is
registered for use by MAP_DMA/UNMAP_DMA calls, _CREATE and _REMOVE are
used for managing DMA window apertures.  Thanks,

Alex


> Signed-off-by: JianChunfu <chunfu.jian@shingroup.cn>
> ---
>  include/uapi/linux/vfio.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 2b68e6cdf..30efc8af4 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -1764,7 +1764,7 @@ struct vfio_eeh_pe_op {
>   *
>   * Registers user space memory where DMA is allowed. It pins
>   * user pages and does the locked memory accounting so
> - * subsequent VFIO_IOMMU_MAP_DMA/VFIO_IOMMU_UNMAP_DMA calls
> + * subsequent VFIO_IOMMU_SPAPR_TCE_CREATE/VFIO_IOMMU_SPAPR_TCE_REMOVE calls
>   * get faster.
>   */
>  struct vfio_iommu_spapr_register_memory {


