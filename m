Return-Path: <kvm+bounces-9444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C9538604F5
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 22:38:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF2291F228F7
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 21:38:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EACA12D1EF;
	Thu, 22 Feb 2024 21:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gfz6zbh7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DC712D1F9
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 21:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708637854; cv=none; b=f9XoyPRQCaYdoXcl9DDVJeqqd496Eg9oZawppfF+szvXjjcSexQbPXzALbqYUyDF7XA9mBJPPnBB0O/dnWBoJEMnbny39I9IPq1pR2+NxrPFDLxYUTPYv/L0SGbGKTsmaWOpxsmF58RPObmOPMn4WQnyRs8aNw3LGWe+eWoTM6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708637854; c=relaxed/simple;
	bh=eTl3BaSXL1EOcleF8Llz7TJCP6iZbj2tst9XjTceF1k=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cVuPekQXB6qT1ZDLUBnevvCC+0NEzM48Z6sTmBlLOSLIb1LQtkiWPxyZVXqRgKJPk1HAQrm17CbU/9uoNRPG9lVAks76/f9rfoMP9QxcOf+dpSgRYCZDIPaFcgjtkA7Sd2TWxfJMpEJab+vHLjtUpuy131QGX7i42RcuV0jttJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gfz6zbh7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708637851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YtxCaMm2553SkupuI9XJeFwENX6MIeYRxtADotfCGT4=;
	b=Gfz6zbh70Py68ZEhj92cXfW9cEdkVSRJq6r7ltgu9I37VbtSJxsqWtuLMvcKT4bPKOJLVZ
	nPihZmF/ie1X8Rhib42OJUPsFPuBz6r34zJPmFzWXqHpAzJ+GfiLlXKtqgJY3y6Vf1nbgD
	hi9IezKVK/LMTdyvNK5eElwKkunUkzI=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-75-97B6CCaqNeeYPgM-61gUKA-1; Thu, 22 Feb 2024 16:37:30 -0500
X-MC-Unique: 97B6CCaqNeeYPgM-61gUKA-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7c7943de7b2so13135039f.0
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 13:37:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708637849; x=1709242649;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YtxCaMm2553SkupuI9XJeFwENX6MIeYRxtADotfCGT4=;
        b=bdBAh64mLTOIQCSpFIrtRdGKN+D0DqeRkIB1NOpI4IKeeg1jxVY1cJHrUnWuVgWisU
         AFWU4QBuTSlcUBQE8xUAO5HcPXyYlGEd1Ft7Y2kVus4ZO3LH8AGwry6oMKgqNqntpZA0
         3+jiI1DuhXH9TVnGcOJlloUSqF4Amn/YT6SvzDEHN4+Yl5Hxf9S1wJ7PS61AGGZu6241
         /1uI+UIvDF4ODgq3hiBQOx+4l+EeNBlgqCy55FzaQzkPX6aAjmLAHGUtg8jPdlmR6T1i
         L6pj6Hj//CySemPyP2Aznp2na9tWetIuuyTTB8Zw+e+BCm+QzRduehHj+Y0p3ZqfOOtF
         F1LA==
X-Forwarded-Encrypted: i=1; AJvYcCU4G+bhJWoDQnZiSoztcWs5zzl6319Gtznm8LB1PziubXfQUik5vSAANX/Oi8gOjt9aBWJkbKx3XN1eH/nvZ6ouGCpR
X-Gm-Message-State: AOJu0YxyXjdWMZrwBYTHMjZTtSj7FijX+xuqavy+EtBQo0oiLd97aB6r
	y7HF59yqqHvnPolBH0aXuMilFU3bJEH0u+UbWp6M4MuWKiUAMh52UmgPrIEcHWz6Fdl94iEOffE
	Bx/GeTmTFx82tgaBEyrwDs9c+aNTtsMMaAbpCWjuobGWp/3c9Mw==
X-Received: by 2002:a5e:8a09:0:b0:7c7:4e71:7911 with SMTP id d9-20020a5e8a09000000b007c74e717911mr154284iok.18.1708637849419;
        Thu, 22 Feb 2024 13:37:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGgU0x5ieHj4hzgNeb/0+6xmyweUr+A42rwzQGt3bwPjQRz1SfIuiuqgZPCPDmibh8XqUJ1XQ==
X-Received: by 2002:a5e:8a09:0:b0:7c7:4e71:7911 with SMTP id d9-20020a5e8a09000000b007c74e717911mr154269iok.18.1708637849173;
        Thu, 22 Feb 2024 13:37:29 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id l14-20020a056638220e00b004743021012asm2117827jas.2.2024.02.22.13.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Feb 2024 13:37:27 -0800 (PST)
Date: Thu, 22 Feb 2024 14:37:05 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: "Ricardo B. Marliere" <ricardo@marliere.net>
Cc: Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] vfio: mdev: make mdev_bus_type const
Message-ID: <20240222143705.6cede313.alex.williamson@redhat.com>
In-Reply-To: <20240208-bus_cleanup-vfio-v1-1-ed5da3019949@marliere.net>
References: <20240208-bus_cleanup-vfio-v1-1-ed5da3019949@marliere.net>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 08 Feb 2024 17:02:04 -0300
"Ricardo B. Marliere" <ricardo@marliere.net> wrote:

> Now that the driver core can properly handle constant struct bus_type,
> move the mdev_bus_type variable to be a constant structure as well,
> placing it into read-only memory which can not be modified at runtime.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Ricardo B. Marliere <ricardo@marliere.net>
> ---
>  drivers/vfio/mdev/mdev_driver.c  | 2 +-
>  drivers/vfio/mdev/mdev_private.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/mdev/mdev_driver.c b/drivers/vfio/mdev/mdev_driver.c
> index 7825d83a55f8..b98322966b3e 100644
> --- a/drivers/vfio/mdev/mdev_driver.c
> +++ b/drivers/vfio/mdev/mdev_driver.c
> @@ -40,7 +40,7 @@ static int mdev_match(struct device *dev, struct device_driver *drv)
>  	return 0;
>  }
>  
> -struct bus_type mdev_bus_type = {
> +const struct bus_type mdev_bus_type = {
>  	.name		= "mdev",
>  	.probe		= mdev_probe,
>  	.remove		= mdev_remove,
> diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
> index af457b27f607..63a1316b08b7 100644
> --- a/drivers/vfio/mdev/mdev_private.h
> +++ b/drivers/vfio/mdev/mdev_private.h
> @@ -13,7 +13,7 @@
>  int  mdev_bus_register(void);
>  void mdev_bus_unregister(void);
>  
> -extern struct bus_type mdev_bus_type;
> +extern const struct bus_type mdev_bus_type;
>  extern const struct attribute_group *mdev_device_groups[];
>  
>  #define to_mdev_type_attr(_attr)	\
> 
> ---
> base-commit: 78f70c02bdbccb5e9b0b0c728185d4aeb7044ace
> change-id: 20240208-bus_cleanup-vfio-75a6180b5efe
> 
> Best regards,

Applied to vfio next branch for v6.9.  Thanks,

Alex


