Return-Path: <kvm+bounces-11077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 289DF872AD9
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 00:13:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6A1EBB25115
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 23:13:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59FB312D218;
	Tue,  5 Mar 2024 23:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NGO/QtB+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B34A3FB9B
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 23:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709680400; cv=none; b=Edw70zVWXdidbwBzB6l3HQXH3SMXRDNfSiMfyZ1tz/G2uuEOay3/R6bWK1uTKAYSuct5APUT0LmIT42PsJpu16FY9hY2PDS05HzfbMpKC+oYAx/NcF9faGLZKGgCpg9sbSrf2bn/DbqPjwQHKG6R647KWyc/uQzxCv7pmDjfeFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709680400; c=relaxed/simple;
	bh=aImrfmtDfx3FB/+qZwZjEHYe3YJ1fvdeSDAyqMnwGaI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ur+Va+b8HpiAlAtUXYFzJ+3YDOkGCeJCuEXJHKeZNmxgerCp51cnUn1zldxZFr3vt1y4bFbVNFFNyc9MUCPwGLlaN/Ngh6Cqp6YOdw50DX9aF5dDHV2aSGKZdc60D/CQLvqU1xMjglTO0RrxD0hNEAsN2i/2Tzqf5wFVNj0ntjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NGO/QtB+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709680398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q3dItyKuCBaDibB5NYXvGt5MwYld+3u7JGZxS0mkDfk=;
	b=NGO/QtB+uBIM6IBqd3UDqnMy19oVk+MBWyvg8n4ZpLTomZLV/tsjeJEfZLr2ynmsr24N7B
	Gd+hor+jiESxXvH4HJkiVUNoKeIaf82JJiOcdE0f/NmZB42eyPITwNeazpuvtAyerJaD2K
	8cRM7rVsNlb0wpWBzA4PnlbrP7HMslc=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-RhPbkQvrMwiIQv-plTHDbA-1; Tue, 05 Mar 2024 18:13:16 -0500
X-MC-Unique: RhPbkQvrMwiIQv-plTHDbA-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7c83a903014so369997239f.2
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 15:13:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709680396; x=1710285196;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q3dItyKuCBaDibB5NYXvGt5MwYld+3u7JGZxS0mkDfk=;
        b=tMXYnlAlpWzbFnneH/8uMXM5nqdemW5IvC5Br0uEhxYkI6iNP6LFEoi4/baAw3r5w+
         orekqhT3XsYxz4zDvA7EZCDDfvkSGiLYIcEG5dNsXwkJLWpFTj1G5gydjr7NjdOHyC85
         bJ+d/WGoakwRAOe5U7aCVhkNrKFZL8tImxRZc1ti4oorF4CFKynQTEenEpf3NbBef4Lj
         JSgNtqMZvb1bM6GJqLLVeYAZSA1guV5e/1Bz3bJ+stfF+pFO7zd2LG/lanciWOFM3XQ3
         mCul4Z4FzX9FxCFjPSXN5IisLhuBLHQAw3y3rFLna/pYyU4pBcEQLc28sq2d4RQa8Bsz
         hR0g==
X-Forwarded-Encrypted: i=1; AJvYcCXdqj+B0axm26kikI2vtz1lzZ/GngmS8cy79rrgQ6A5LPbFVIfMxQN9W858QyI7jaOsomMNuI+zMnq8Vx+NUw9D8iMs
X-Gm-Message-State: AOJu0YxJf799pATH9lVKiO561SjkVj/IqlkcEFZTuWv8PQtW64IKKG55
	SpDQL2Xj9O9ENKlfbrJf9qCJEMzNeYFrHiq4aC+Ji9e2C7tw0K0Gk61cRMqD0DOhW6Zpijiz6Q+
	b6vNQ6sxp2RPi0hpWf4nOAmmWOaVDjOTH5FGMiAy5W4GMBz7Byw==
X-Received: by 2002:a05:6602:1b19:b0:7c8:3efb:27ed with SMTP id dk25-20020a0566021b1900b007c83efb27edmr11120788iob.5.1709680396238;
        Tue, 05 Mar 2024 15:13:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH37srbEnhilsYXZBiPUY4gv8GvCH6dccJsVm5NQe0om0obInCAFz9Q4eLaVKORUBVGtoL1eg==
X-Received: by 2002:a05:6602:1b19:b0:7c8:3efb:27ed with SMTP id dk25-20020a0566021b1900b007c83efb27edmr11120775iob.5.1709680395954;
        Tue, 05 Mar 2024 15:13:15 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id c26-20020a02c9da000000b00474b48a629csm3084467jap.46.2024.03.05.15.13.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Mar 2024 15:13:15 -0800 (PST)
Date: Tue, 5 Mar 2024 16:13:01 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Antonios Motakis <a.motakis@virtualopensystems.com>, Eric Auger
 <eric.auger@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: amba: Rename pl330_ids[] to vfio_amba_ids[]
Message-ID: <20240305161301.573b0a41.alex.williamson@redhat.com>
In-Reply-To: <1d1b873b59b208547439225aee1f24d6f2512a1f.1708945194.git.geert+renesas@glider.be>
References: <1d1b873b59b208547439225aee1f24d6f2512a1f.1708945194.git.geert+renesas@glider.be>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 26 Feb 2024 12:09:26 +0100
Geert Uytterhoeven <geert+renesas@glider.be> wrote:

> Obviously drivers/vfio/platform/vfio_amba.c started its life as a
> simplified copy of drivers/dma/pl330.c, but not all variable names were
> updated.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  drivers/vfio/platform/vfio_amba.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/platform/vfio_amba.c b/drivers/vfio/platform/vfio_amba.c
> index 6464b3939ebcfb53..485c6f9161a91be0 100644
> --- a/drivers/vfio/platform/vfio_amba.c
> +++ b/drivers/vfio/platform/vfio_amba.c
> @@ -122,16 +122,16 @@ static const struct vfio_device_ops vfio_amba_ops = {
>  	.detach_ioas	= vfio_iommufd_physical_detach_ioas,
>  };
>  
> -static const struct amba_id pl330_ids[] = {
> +static const struct amba_id vfio_amba_ids[] = {
>  	{ 0, 0 },
>  };
>  
> -MODULE_DEVICE_TABLE(amba, pl330_ids);
> +MODULE_DEVICE_TABLE(amba, vfio_amba_ids);
>  
>  static struct amba_driver vfio_amba_driver = {
>  	.probe = vfio_amba_probe,
>  	.remove = vfio_amba_remove,
> -	.id_table = pl330_ids,
> +	.id_table = vfio_amba_ids,
>  	.drv = {
>  		.name = "vfio-amba",
>  		.owner = THIS_MODULE,

Applied to vfio next branch for v6.9.  Thanks,

Alex


