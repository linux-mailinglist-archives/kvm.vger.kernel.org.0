Return-Path: <kvm+bounces-6147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 603B882C2DA
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 16:36:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F2B571F21F42
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 15:36:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D72EC6EB5A;
	Fri, 12 Jan 2024 15:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iHBbkl7k"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A719E32C7F
	for <kvm@vger.kernel.org>; Fri, 12 Jan 2024 15:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705073761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EJcU6u6PnHNcgJkHl1PZufsrGB2VSkf8RmxbXziQJ6Y=;
	b=iHBbkl7kcZbE7E/mGhc/mJ3w0SFsHUMR5siP2NR/YUsF1N+jbq70SsizsM5pJgjAOvyZLP
	3pIzM0EJMsXGaj7UPilaLhitWf18lNZHFA2ro5Q2uKO0ztHpaim/WsEjZ3nWcDvlTGF7bD
	bqiiqVwjUVfAnuSgpw4cftwerLvN8Bg=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-511-rj8aOMdkPueKSLaYEZV1UA-1; Fri, 12 Jan 2024 10:35:58 -0500
X-MC-Unique: rj8aOMdkPueKSLaYEZV1UA-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7bf2d40b243so4523339f.2
        for <kvm@vger.kernel.org>; Fri, 12 Jan 2024 07:35:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705073751; x=1705678551;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EJcU6u6PnHNcgJkHl1PZufsrGB2VSkf8RmxbXziQJ6Y=;
        b=UzapSTPrAlwweNTJaRPSiTWonspYGnr0DBrJAvdVgMKoyd2pvsEDxquMbEFzYVTiSE
         qGlXGW2ksxoHwrSX3E7MuyGn3m2qHmhkDJzt9XVXcNRE6iUiFsAKSnTcDCc+K9lOhcPv
         1mZCRJh7cVGVVlBQwVruJHAK05sn17OYsbtHlo21PLmwkg0bspYZaMCHMOjr71IBs0ut
         kX+93Fwus4tL02pQQCyjTyNTguJzGwkRtrGv1QIyLsUdHRyjwgfQM/SX19XF/4aIbG44
         TWjGxW3/+2RCa0h4khOk3jOSDQ2SrAwq10QxKEO29LSz4ZIK+FQCFEGBJBSlz3slbIXH
         8J3g==
X-Gm-Message-State: AOJu0YymQZmoEP2SpjHpXkD4of9Uw1JJPNHAh8NClCePDZDQJ7b7nYeE
	1IedGBkQgvhFj95lBH3diCq48IDZqdSgUcPOG11rQO6llR+0RK5jAlOO0wVM193nCEBnmr9Ltld
	gsbpI+VOhHf+RWg9txLG8
X-Received: by 2002:a5e:8907:0:b0:7bc:329d:574 with SMTP id k7-20020a5e8907000000b007bc329d0574mr1757905ioj.29.1705073751139;
        Fri, 12 Jan 2024 07:35:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH12+vRux/vNmWFM6SsHmzUZ4nASmziP9IsU2T7grZR4Z0cAS5UOjd9JwhXgrlR5g/WT+y6xw==
X-Received: by 2002:a5e:8907:0:b0:7bc:329d:574 with SMTP id k7-20020a5e8907000000b007bc329d0574mr1757898ioj.29.1705073750929;
        Fri, 12 Jan 2024 07:35:50 -0800 (PST)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id s20-20020a6bdc14000000b007bc4b12d5ddsm861328ioc.3.2024.01.12.07.35.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jan 2024 07:35:50 -0800 (PST)
Date: Fri, 12 Jan 2024 08:35:49 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Kunwu Chan <chentao@kylinos.cn>
Cc: diana.craciun@oss.nxp.com, eric.auger@redhat.com,
 Bharat.Bhushan@nxp.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio/fsl-mc: Remove unnecessary free in
 vfio_set_trigger
Message-ID: <20240112083549.04db8f8a.alex.williamson@redhat.com>
In-Reply-To: <20240112072128.141954-1-chentao@kylinos.cn>
References: <20240112072128.141954-1-chentao@kylinos.cn>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 12 Jan 2024 15:21:28 +0800
Kunwu Chan <chentao@kylinos.cn> wrote:

> 'irq->name' is initialed by kasprintf, so there is no need
> to free it before initializing.

This is just as bogus as the vfio-platform version.  Thanks,

Alex
 
> Fixes: cc0ee20bd969 ("vfio/fsl-mc: trigger an interrupt via eventfd")
> Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
> ---
>  drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
> index d62fbfff20b8..31f0716e7ab3 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c
> @@ -69,7 +69,6 @@ static int vfio_set_trigger(struct vfio_fsl_mc_device *vdev,
>  	hwirq = vdev->mc_dev->irqs[index]->virq;
>  	if (irq->trigger) {
>  		free_irq(hwirq, irq);
> -		kfree(irq->name);
>  		eventfd_ctx_put(irq->trigger);
>  		irq->trigger = NULL;
>  	}


