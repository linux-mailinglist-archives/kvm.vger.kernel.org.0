Return-Path: <kvm+bounces-25782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A3DFB96A6E0
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 20:48:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60A4E282C51
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 18:48:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68EA71922CC;
	Tue,  3 Sep 2024 18:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UL9pufq6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1C11922DA
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 18:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725389287; cv=none; b=cjpNWvHuQ83vjCB4Z+I0dk5UrL1NpEq/OGtKcwbaCPhXQp/doS6ioMuNcsIJHfzYAuBlNX0a4LHoim1u7euq8eusE1ifMwxq9LLWcxmgywrCGQPBLl/zwGielCJno8GnPM+AvHq1PgTW9ONWWXT1gQt3F8WLiwXbbZLmbw0XXYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725389287; c=relaxed/simple;
	bh=YI2bQcXG9NgH1ZFBiftSMMsTCgMWk7VLSi/u23at9Dw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J5PhKpY9e2LtMicxxjvq6a0zCaqraIrPZF3gBWg2SL3dx2da0WLp/TD6MI3+ym2N3JYAz2xVzdQTvjC0dh3oW3LtHXxq5ney1DLPOocPzoAzIUodecDzeS/LrE7rVzB3IiRaV/q7RO54juD0ccsP11EH6LgKPDmfYkM+whJGh2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UL9pufq6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725389285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c2RmyvnjV8rKO6oVNfzDCMG6+LeqjzDtoD+paS+m1uw=;
	b=UL9pufq65SBp2QkNDi0gFjpvF1XPeRsLk3yAr0XXd7CfiXw5eQUSJiOW4DFM4fNHdg3g2N
	MgD00CHB+yEx5Kk+Rulm/CQY2XdycHu1NGDjX6VhGqXSrU+G8HAJww7g7926AO4SbMECEY
	m24zZwKa66GcfFbRteOnmoFG14Xq7nw=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-54-fu1A_Ti5Mq-vAeokOrChRg-1; Tue, 03 Sep 2024 14:48:03 -0400
X-MC-Unique: fu1A_Ti5Mq-vAeokOrChRg-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-82a1c54b7c0so101903539f.2
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2024 11:48:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725389283; x=1725994083;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c2RmyvnjV8rKO6oVNfzDCMG6+LeqjzDtoD+paS+m1uw=;
        b=AP4R2F/AO9kGjnuzBOVSfHLVeZh1o/B97x/R+ftsieJMx9uNGZP10g3TJHv0awnoK6
         lNSs0uXSHc/6hHCXYZx9z5kAo56scC48Unsre3Z3ZK/3iHKwKM1CrPXsatvaJrft3ALj
         DhzSl1O+gGhSMxEvoL33c6sMs8aMxdP/gKQpXcfe5x0bLW1jGt+qpMn6HlKBlKQl0q6Q
         Qo6gGASE9jsEElDKnR+437tfaVbf7hTWMhu7jh3qY50MnCNzJte8LZ9d0T0QKO1aljLv
         y8w0pIrHIRS6tKOcWkwu/Xh85v5T9FV2oCiNdHrynSdo37OuzioLTIP5Si3nBC+snPNc
         20dw==
X-Forwarded-Encrypted: i=1; AJvYcCUJtJaIYoTMjX0aZceRqq5Wo5uHYmU0lHKTvGhf0WqNNOJ+D+9bIIoJp7eJe/PgEG5N11U=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdqWud8d0JnXVBUUdDSdAZ09TiMbP1ZgtdWzprx4a9QeDOBenB
	QiKSEqMhWK7KTSGG85SsAxVELrx2D9TXXAA2nrmsaYlCE8kuLkSRpeK8nS3yapGb5La57Fz2VV8
	7hFAuBNcTNFx2GnsjVWSfTEhsMBba5L962chSB75HnhDm41r+2Q==
X-Received: by 2002:a05:6e02:985:b0:39f:584a:e917 with SMTP id e9e14a558f8ab-39f584af589mr60878635ab.0.1725389283119;
        Tue, 03 Sep 2024 11:48:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHaflX8Uu00PTu9XfW9cFII58J8btalwYeWJjdgX9Nt/CN4mkQGBbLItUiCH6iZkYA7R2zZWg==
X-Received: by 2002:a05:6e02:985:b0:39f:584a:e917 with SMTP id e9e14a558f8ab-39f584af589mr60878535ab.0.1725389282790;
        Tue, 03 Sep 2024 11:48:02 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ced2de78b9sm2801041173.67.2024.09.03.11.48.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 11:48:02 -0700 (PDT)
Date: Tue, 3 Sep 2024 12:48:01 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Zhang Zekun <zhangzekun11@huawei.com>
Cc: <kwankhede@nvidia.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH] vfio: mdev: Remove unused function declarations
Message-ID: <20240903124801.1c2980fb.alex.williamson@redhat.com>
In-Reply-To: <20240812120823.10968-1-zhangzekun11@huawei.com>
References: <20240812120823.10968-1-zhangzekun11@huawei.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 12 Aug 2024 20:08:23 +0800
Zhang Zekun <zhangzekun11@huawei.com> wrote:

> The definition of mdev_bus_register() and mdev_bus_unregister() have been
> removed since commit 6c7f98b334a3 ("vfio/mdev: Remove vfio_mdev.c"). So,
> let's remove the unused declarations.
> 
> Signed-off-by: Zhang Zekun <zhangzekun11@huawei.com>
> ---
>  drivers/vfio/mdev/mdev_private.h | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
> index 63a1316b08b7..5f61acd0fe42 100644
> --- a/drivers/vfio/mdev/mdev_private.h
> +++ b/drivers/vfio/mdev/mdev_private.h
> @@ -10,9 +10,6 @@
>  #ifndef MDEV_PRIVATE_H
>  #define MDEV_PRIVATE_H
>  
> -int  mdev_bus_register(void);
> -void mdev_bus_unregister(void);
> -
>  extern const struct bus_type mdev_bus_type;
>  extern const struct attribute_group *mdev_device_groups[];
>  

Applied to vfio next branch for v6.12.  Thanks!

Alex


