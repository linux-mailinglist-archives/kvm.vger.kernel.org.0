Return-Path: <kvm+bounces-52658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02AB3B07EB9
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 22:20:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB5153AC2CF
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 20:20:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E32B2BE043;
	Wed, 16 Jul 2025 20:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S1qPnd74"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12DEDC2D1
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 20:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752697239; cv=none; b=OoYpZVOr/IdpCuxz4y1EAK/h/QHuAHmOlwkaliCfnIdWHo7sHSbhh6aSUybxLotWqtRJSoy98PMYQwde1nwXCYGiEbeHHIRtomgoope7oJVyxjEvqq2nw20u7FVZ2d8+noL05Fqe7g1C6Cx4WujPdoWoa2Te9tqfS2R78D+1t6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752697239; c=relaxed/simple;
	bh=mXtqp7gVbh7UOnOpdjoc9VIV6y3SLqfxSwopG8bMNAo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=caxBCNage4qfAepLeTDby0VB6vctG6PHqbUFsRQ5mdW2roz4Bmt2H7YrTIIz6pWGLFWYyM4QOlsqq0yRaP11yCwZ55biWqwBEsNLn923c6UY8NV+BLBlJwFWkhdT7aR7S+RKd/FIpvj3vV5OYNwvICJOM5V+fd9GLLje47AB/7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S1qPnd74; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752697235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f8+tomaBKqRUmD0o+5SGyJtwby38fqpQFOnf4/E8KGk=;
	b=S1qPnd74Eoibnv2SHunwh9Pqlw6mHgGIXwEjHP79NkMQrdNQp11aRiB6C9sUWqLk6eP+ac
	TkKuRXbp712qkB/+cPXOKzZliYpSky3L1MQKCHLHUglAXFwk1AamfDm4cc5DTeITHgujUw
	QHH1BxDZixsLxl/54sKKzBbq3oNrQ8M=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-311-ezRAW1IcMGCVsZ0vhIcEfA-1; Wed, 16 Jul 2025 16:20:34 -0400
X-MC-Unique: ezRAW1IcMGCVsZ0vhIcEfA-1
X-Mimecast-MFC-AGG-ID: ezRAW1IcMGCVsZ0vhIcEfA_1752697233
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3df57df1eb3so458425ab.2
        for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 13:20:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752697233; x=1753302033;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f8+tomaBKqRUmD0o+5SGyJtwby38fqpQFOnf4/E8KGk=;
        b=go19jZ/yApHlXmrhrW8JeFJ/y0BS5oIcQJZqZEbkapyIKlXwPq+g6Rz5z2SXm2ST7a
         6oe4q20pY0jMmkhvr4UPSedwL6fdlfR0keG9RnmGaO3iG3ct508oNGLve6ZJeAoKoGKA
         MQNt1bR+LvA4rqB1Tlgc4oQ8be5ELHGuLs2+0vrUNYB5AuPTzn5gusEAvVoQCP+s3x6x
         LU30QE1m1onHViAf+vOYF01B0qG98wJ2AJRCK3glt8DA95R4PJHfYnL+7A4TKiPR4tTL
         SKqntb+Dd+UeKtUgcxm/Rx41ECZSJ6y+nSj9120zYg3HSEqWj+O+NOmzYk0fLxIJSl2Z
         jzpQ==
X-Gm-Message-State: AOJu0YxmxKRIPpMgL3GHbAPCg9eogztQY4ZiHNL77yIv39BNapC724CY
	z/58t9e94jVw/kXRAxowLeLdwiszMxjEFHWMaIj8TyN8uaGL1f8AnWEXTZLOGS89TT0zsapvnF9
	1qwE1soEq6mXNybQr/JWssB4Cw82ICwy104Vk9Hqc4PIEp4SGBdhpXw==
X-Gm-Gg: ASbGncu1H9uCPFsTw07zGzVzAZnvkcU7sfxTh69BaPaISKhzO3YU7fuqYE69SK9ZZaq
	RgeBBPJ9GiI08y9BWQYALJg3geh6VvobRryhp797avOyH+oYZw74Otc6rMyskvIfzswMHRfSsLS
	Pe7/C18bsBHuy6ah4XNPeYPFoD9/WIQOJawe11N9rvXtrtQAXAtp2f2zKD7a2V6tmsTdoaJyv5u
	oqFpaC+xWL5Usm4/MLxNqrTCt0oDP5aaEg623KGn6BuV6iF+FsZgGM03Qgh31iTI9NIWebpv99U
	SkuUTFEGupChNC2r3jJ3H1+09jbSFhLG3NMA2d+wuMg=
X-Received: by 2002:a05:6602:3423:b0:874:1065:e113 with SMTP id ca18e2360f4ac-879c093feebmr157418039f.3.1752697233069;
        Wed, 16 Jul 2025 13:20:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF8vmh0mTjL9hY+CP9L7Voe14ifFhkxZegmPdPuPupOQowi/8t3ndRzwWpfK0IPOEktrMESpg==
X-Received: by 2002:a05:6602:3423:b0:874:1065:e113 with SMTP id ca18e2360f4ac-879c093feebmr157417139f.3.1752697232585;
        Wed, 16 Jul 2025 13:20:32 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-505569cc0absm3200651173.97.2025.07.16.13.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jul 2025 13:20:30 -0700 (PDT)
Date: Wed, 16 Jul 2025 14:20:29 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Artem Sadovnikov <a.sadovnikov@ispras.ru>
Cc: kvm@vger.kernel.org, Yishai Hadas <yishaih@nvidia.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 Kevin Tian <kevin.tian@intel.com>, linux-kernel@vger.kernel.org,
 lvc-project@linuxtesting.org
Subject: Re: [PATCH v2] vfio/mlx5: fix possible overflow in tracking max
 message size
Message-ID: <20250716142029.36ee1475.alex.williamson@redhat.com>
In-Reply-To: <20250701144017.2410-2-a.sadovnikov@ispras.ru>
References: <20250701144017.2410-2-a.sadovnikov@ispras.ru>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  1 Jul 2025 14:40:17 +0000
Artem Sadovnikov <a.sadovnikov@ispras.ru> wrote:

> MLX cap pg_track_log_max_msg_size consists of 5 bits, value of which is
> used as power of 2 for max_msg_size. This can lead to multiplication
> overflow between max_msg_size (u32) and integer constant, and afterwards
> incorrect value is being written to rq_size.
> 
> Fix this issue by extending integer constant to u64 type.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Artem Sadovnikov <a.sadovnikov@ispras.ru>
> ---
> Changes from v1:
> - The constant type was changed instead of variable type.
> - The patch name was accidentally cut and is now fixed.
> - LKML: https://lore.kernel.org/all/20250629095843.13349-1-a.sadovnikov@ispras.ru/
> ---
>  drivers/vfio/pci/mlx5/cmd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
> index 5b919a0b2524..a92b095b90f6 100644
> --- a/drivers/vfio/pci/mlx5/cmd.c
> +++ b/drivers/vfio/pci/mlx5/cmd.c
> @@ -1523,8 +1523,8 @@ int mlx5vf_start_page_tracker(struct vfio_device *vdev,
>  	log_max_msg_size = MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_log_max_msg_size);
>  	max_msg_size = (1ULL << log_max_msg_size);
>  	/* The RQ must hold at least 4 WQEs/messages for successful QP creation */
> -	if (rq_size < 4 * max_msg_size)
> -		rq_size = 4 * max_msg_size;
> +	if (rq_size < 4ULL * max_msg_size)
> +		rq_size = 4ULL * max_msg_size;
>  
>  	memset(tracker, 0, sizeof(*tracker));
>  	tracker->uar = mlx5_get_uars_page(mdev);

Applied to vfio next branch for v6.17.  Thanks,

Alex


