Return-Path: <kvm+bounces-55619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3027B34471
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 16:46:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2AA553B729C
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 14:42:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 808A72F28F2;
	Mon, 25 Aug 2025 14:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UVbKGTSc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA892853E9
	for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 14:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756132924; cv=none; b=acUhmZFUL/YlFrJLbdq+kOQ/ybqKZHYDG+OcWfsLyLET7rM0fApTBkrl/F40oPnQ2xqZmViDlH6fReJ+wp/iSC935u5Q16FEekKV/xzXmY5Cr73b0jh1gbAgkivefPgRJi8b/Y0i2Q0sah3L91SsoRPNaJShCDpk63d1PpLEuv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756132924; c=relaxed/simple;
	bh=dY2BC24LcOwPmwCFWjqjdFx0LB0w2liGu7oqHI05kJA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZMykKjuXwkizdsE2gSSm8whbno+ElpRbi7RysyDeqmM11MkbEaqXqjrL1uD5VrADWncftJQxKmI1FXFWxyzjBRpB214XRQlfBYZyEhvbUKIP13KTjApmyMDRBXXv8VnGBmkkCAYbroS+c5bP+WjJWKik7IGrycSVvr+B/ZCYOA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UVbKGTSc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756132922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sLqi3ZQ4Qq7GjJJBZEDnBdmpcriLiuWuU+N614GqayQ=;
	b=UVbKGTScUWZvcUUCZs6H30l4Xg1iHlPUZjegqb4h63uQYlfK2wO8vXNu31QXDQ2OrVPoix
	yzStpGRalsUHFQBKOAxHF8/yQ/eEofPVQ3IB1KeWNLSbmaTXgU0ZSZbAaD8+Y6pAIQqN8t
	g9siTbUGMoAOwRlKVPQhO/W0xPGcAi4=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-157-Kw2hjxlEPA-SuFsMqUKzHA-1; Mon, 25 Aug 2025 10:42:00 -0400
X-MC-Unique: Kw2hjxlEPA-SuFsMqUKzHA-1
X-Mimecast-MFC-AGG-ID: Kw2hjxlEPA-SuFsMqUKzHA_1756132920
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3ed9124f2c5so1008485ab.2
        for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 07:42:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756132919; x=1756737719;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sLqi3ZQ4Qq7GjJJBZEDnBdmpcriLiuWuU+N614GqayQ=;
        b=xVSjD2r9D3rH4LNUPcQjhticy5MoE2/2vB7sd5TmgMzL9P8DsPdiNJakZR1OB6co53
         as6kw3X6lvK1G7cTN8q2exRhVgLn7yyKhU6wjxZF7WsayTFCiHWI4Y87pYKPkGfjMmC0
         NeeDQI8DOnTA4A6YC9S6R/O1R9NVUoqvJEX/F/xrb5pUyojYLr3cR7+taXQzxgruSNTc
         L3dauKn81mULVD0ObthL6HcT0ppP8L1llfPuG80X5Esl8Z18TvCq9wHkKAj4QsJAgPPA
         inJlhnwBEavWVQ1uT9gymgP2oA4U+eg7lvR5JurmVq/63sgJd5l201b2iuO0dCPAciQM
         /K2A==
X-Forwarded-Encrypted: i=1; AJvYcCVhv4RQ++wAVHdimBNdDL31bagSXL+SXeLtFMeNt8eAmb7pniUe7M5mmWujvXVBEWbiE1I=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTu8Z55vgoI1uLFDWshke98trvcBYxBbX3+3WR8En90P8qwhE1
	3JiL7q0vJ18BmdsxJCfDnnfZw1OOrHPQDg1wRelIV9nIp9/jBLKr7Z7QodqYwQBt02SweR+Reht
	KnpLVrgUdJsDzT/V0vD1GM3921C5Go6A6a/vreMT0+TJ7q2c2+F+LDw==
X-Gm-Gg: ASbGncvrvwGJC4yEXP3ivkAQJ0y3ouwFkvSdcUoaaTEHIRXykAKVMXKQ1hH1/8LzBUz
	e5HQhDvYEkIuYQ1vb1sk/3s45OrQfMqNFFamB3l9FMS9HHYxhzlsiRYLkQVpM4sZb9mVEvP4LQn
	bbH3zw0B+ZmL+OK/580kqrG3yBLHggYsULHUme+8FCgtX7OPACm9POqVkSXnpK6OfTrXm9fQq1P
	64dBAJgYBD1yqJGvzdKYt/bCJ8jVlMAl8oRAvx1PS0iT0jv4jpxqd1WXiQBYHbO58BXzSUH1RY0
	5vPlC0BbHcMvQDwQ2KVZSW1eEm9Ft1meTboIwn/M9SU=
X-Received: by 2002:a05:6e02:1567:b0:3ec:9c32:6471 with SMTP id e9e14a558f8ab-3ec9c32673bmr18816595ab.2.1756132919661;
        Mon, 25 Aug 2025 07:41:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGW4Lgvz6FbySIAPwtm0U1Tae7UuaIE2esfeq7WZJykcdIyv6UETbtw/iCgysaF9obPTYn/Gg==
X-Received: by 2002:a05:6e02:1567:b0:3ec:9c32:6471 with SMTP id e9e14a558f8ab-3ec9c32673bmr18816275ab.2.1756132919255;
        Mon, 25 Aug 2025 07:41:59 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ec67d6ffdasm22921535ab.25.2025.08.25.07.41.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 07:41:58 -0700 (PDT)
Date: Mon, 25 Aug 2025 08:41:55 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Nipun Gupta <nipun.gupta@amd.com>
Cc: <arnd@arndb.de>, <gregkh@linuxfoundation.org>, <nikhil.agarwal@amd.com>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <llvm@lists.linux.dev>, <oe-kbuild-all@lists.linux.dev>,
 <robin.murphy@arm.com>, <krzk@kernel.org>, <tglx@linutronix.de>,
 <maz@kernel.org>, <linux@weissschuh.net>, <chenqiuji666@gmail.com>,
 <peterz@infradead.org>, <robh@kernel.org>, <abhijit.gangurde@amd.com>,
 <nathan@kernel.org>, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v3 2/2] vfio/cdx: update driver to build without
 CONFIG_GENERIC_MSI_IRQ
Message-ID: <20250825084155.10088e2a.alex.williamson@redhat.com>
In-Reply-To: <20250825043122.2126859-2-nipun.gupta@amd.com>
References: <20250825043122.2126859-1-nipun.gupta@amd.com>
	<20250825043122.2126859-2-nipun.gupta@amd.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 25 Aug 2025 10:01:22 +0530
Nipun Gupta <nipun.gupta@amd.com> wrote:

> Define dummy MSI related APIs in VFIO CDX driver to build the
> driver without enabling CONFIG_GENERIC_MSI_IRQ flag.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202508070308.opy5dIFX-lkp@intel.com/
> Reviewed-by: Nikhil Agarwal <nikhil.agarwal@amd.com>
> Signed-off-by: Nipun Gupta <nipun.gupta@amd.com>
> ---
> 
> Changes v1->v2:
> - fix linking intr.c file in Makefile
> Changes v2->v3:
> - return error from vfio_cdx_set_irqs_ioctl() when CONFIG_GENERIC_MSI_IRQ
>   is disabled
> 
>  drivers/vfio/cdx/Makefile  |  6 +++++-
>  drivers/vfio/cdx/private.h | 14 ++++++++++++++
>  2 files changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/cdx/Makefile b/drivers/vfio/cdx/Makefile
> index df92b320122a..dadbef2419ea 100644
> --- a/drivers/vfio/cdx/Makefile
> +++ b/drivers/vfio/cdx/Makefile
> @@ -5,4 +5,8 @@
>  
>  obj-$(CONFIG_VFIO_CDX) += vfio-cdx.o
>  
> -vfio-cdx-objs := main.o intr.o
> +vfio-cdx-objs := main.o
> +
> +ifdef CONFIG_GENERIC_MSI_IRQ
> +vfio-cdx-objs += intr.o
> +endif
> diff --git a/drivers/vfio/cdx/private.h b/drivers/vfio/cdx/private.h
> index dc56729b3114..5343eb61bec4 100644
> --- a/drivers/vfio/cdx/private.h
> +++ b/drivers/vfio/cdx/private.h
> @@ -38,11 +38,25 @@ struct vfio_cdx_device {
>  	u8			config_msi;
>  };
>  
> +#ifdef CONFIG_GENERIC_MSI_IRQ
>  int vfio_cdx_set_irqs_ioctl(struct vfio_cdx_device *vdev,
>  			    u32 flags, unsigned int index,
>  			    unsigned int start, unsigned int count,
>  			    void *data);
>  
>  void vfio_cdx_irqs_cleanup(struct vfio_cdx_device *vdev);
> +#else
> +static int vfio_cdx_set_irqs_ioctl(struct vfio_cdx_device *vdev,
> +				   u32 flags, unsigned int index,
> +				   unsigned int start, unsigned int count,
> +				   void *data)
> +{
> +	return -ENODEV;

With the fix to patch 1/, the device info ioctl should be returning
that there are no irqs available, so this should use the same errno as
any other case of the user trying to set an out-of-bounds irq, -EINVAL.

With that change

Reviewed-by: Alex Williamson <alex.williamson@redhat.com>

> +}
> +
> +static void vfio_cdx_irqs_cleanup(struct vfio_cdx_device *vdev)
> +{
> +}
> +#endif
>  
>  #endif /* VFIO_CDX_PRIVATE_H */


