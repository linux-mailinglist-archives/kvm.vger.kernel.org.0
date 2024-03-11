Return-Path: <kvm+bounces-11591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A2609878960
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 21:22:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C3172820E6
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 20:22:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19AF956759;
	Mon, 11 Mar 2024 20:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iaFZeCiD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D534D9E7
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 20:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710188559; cv=none; b=cVa1gEvhvZGEFC8Emdu7xNI9Khr9g5OImIafrc1g5VOfieuXc5lCMgq+qsWT4PRk+TKKbhWmeYlX05aoHJMjhJxUqIrRmSB1nLznfo4HDfZZGVsYAxtP6gmbHmDejLZuP3fgzWvvBaViRGzf09R0d01bxESpdNLBJEKGf5Q1CPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710188559; c=relaxed/simple;
	bh=PXTxgpZmGzjgaB0iBTNVTwKqIaH2ekPNit+sP1QVzts=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FN0FKHRmRW955IfdreeTZW0g9f9azbN0bidt1SQC4BQs2KRx6OXvRVs+oj+PazxjzrwMepct3G/gxiVgeRvuDTHqo8gmaNnrByYgN5XlCCJa9mZIVnNKwJ1mSLAuWDBEEhwh93tIac8g6kChQeQIqkXkLjqhVtBdIStcGyKgJqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iaFZeCiD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710188556;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LHLvc6j/leEFQxEnepP73T3VF/+cxxFUyaKJE+DM7f4=;
	b=iaFZeCiDgrDduJLl3gPASQVG/nOv1fHRmsGvVfMRUTUMJ5Bi6PaQc+uSqs04rCmIiEle/q
	tX6+P5rzZsMaf5c2/EIgSdMIrKuAl1u4FTQ9fCC4qg6UIS1MZTaMNBHvCdLV2ToRZbAv0D
	hez6gYDF4IbDt+QEKMXAW9mLeDZWc4g=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-216-s1XZekS_MA6dfzI3qef5KA-1; Mon, 11 Mar 2024 16:22:34 -0400
X-MC-Unique: s1XZekS_MA6dfzI3qef5KA-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3663022a5bdso36369845ab.3
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 13:22:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710188554; x=1710793354;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LHLvc6j/leEFQxEnepP73T3VF/+cxxFUyaKJE+DM7f4=;
        b=FoaKhG4bVKzsmCm3nmw+6jQqGyUpnlSmIi2vuJ3fj48fPTbwcWDcfcvohOYHOukifi
         8EZBhAkcv1IGu06DwLgDoUlTLoEdJoFArTLdjLw3MxHM0JmuyC9AvjVU1F1JSHP5S2Zk
         peX4bxFKjph2h1KGj0hXrHtFJ84cQVdUOMGr66hWzWGHdhZO4y32STchLmhggV94FEEP
         o6AC+/JO9fCGMU7P6baTjJnd9FVrJTpjB/YozUhYwDSNzugRXZHrMyH0OkQ8w/agxnK2
         Af+0vnKn8qgBJI6148VTDBsjDsRuFUvYtCe945zJJK54jPKByTr7+U26OW7gtQrz5SJe
         qa5Q==
X-Forwarded-Encrypted: i=1; AJvYcCWZMCGHoP2JvQqfsXEi4GQh6IApIPK+x8OssY5lYVvOpsrMJ5mOMmTPO7p9FRlQI/CmDyNNuXqzsO16FpLfCJDtFnit
X-Gm-Message-State: AOJu0Yz0rnGfUAMCyc47Ha8jhR+WzLFczuf/SPJR3EvSGZLZZcI2YYYC
	qXd+arOr33W0qfSfH4wCdNlDWbVuPjWSvIuc1CAQlLML4tMoXsBLR0/f42ca3xSGd2Ux/p3n3xN
	4gUTbfIp61JBQRpUSdUXMqCQYEsybuxRhq8AP9rrWbmni6AgchQ==
X-Received: by 2002:a05:6e02:15c2:b0:365:1d36:91d7 with SMTP id q2-20020a056e0215c200b003651d3691d7mr1614153ilu.27.1710188554239;
        Mon, 11 Mar 2024 13:22:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+6AYCrYloP6duQvlJoOc/JsANCrde7bA0oTqpiy2USPApJMD7r4MbFHEnlDYUpjN5qdE8zA==
X-Received: by 2002:a05:6e02:15c2:b0:365:1d36:91d7 with SMTP id q2-20020a056e0215c200b003651d3691d7mr1614138ilu.27.1710188553999;
        Mon, 11 Mar 2024 13:22:33 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id m2-20020a92d702000000b003641c81f897sm1920634iln.17.2024.03.11.13.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Mar 2024 13:22:33 -0700 (PDT)
Date: Mon, 11 Mar 2024 14:22:32 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= <u.kleine-koenig@pengutronix.de>
Cc: Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
 kernel@pengutronix.de
Subject: Re: [PATCH] vfio/platform: Convert to platform remove callback
 returning void
Message-ID: <20240311142232.59acd33e.alex.williamson@redhat.com>
In-Reply-To: <79d3df42fe5b359a05b8061631e72e5ed249b234.1709886922.git.u.kleine-koenig@pengutronix.de>
References: <79d3df42fe5b359a05b8061631e72e5ed249b234.1709886922.git.u.kleine-koenig@pengutronix.de>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri,  8 Mar 2024 09:51:19 +0100
Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de> wrote:

> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is ignored (apart
> from emitting a warning) and this typically results in resource leaks.
>=20
> To improve here there is a quest to make the remove callback return
> void. In the first step of this quest all drivers are converted to
> .remove_new(), which already returns void. Eventually after all drivers
> are converted, .remove_new() will be renamed to .remove().
>=20
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
>=20
> Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/vfio/platform/vfio_platform.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Applied to vfio next branch for v6.9.  Thanks,

Alex

>=20
> diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platfor=
m/vfio_platform.c
> index 8cf22fa65baa..42d1462c5e19 100644
> --- a/drivers/vfio/platform/vfio_platform.c
> +++ b/drivers/vfio/platform/vfio_platform.c
> @@ -85,14 +85,13 @@ static void vfio_platform_release_dev(struct vfio_dev=
ice *core_vdev)
>  	vfio_platform_release_common(vdev);
>  }
> =20
> -static int vfio_platform_remove(struct platform_device *pdev)
> +static void vfio_platform_remove(struct platform_device *pdev)
>  {
>  	struct vfio_platform_device *vdev =3D dev_get_drvdata(&pdev->dev);
> =20
>  	vfio_unregister_group_dev(&vdev->vdev);
>  	pm_runtime_disable(vdev->device);
>  	vfio_put_device(&vdev->vdev);
> -	return 0;
>  }
> =20
>  static const struct vfio_device_ops vfio_platform_ops =3D {
> @@ -113,7 +112,7 @@ static const struct vfio_device_ops vfio_platform_ops=
 =3D {
> =20
>  static struct platform_driver vfio_platform_driver =3D {
>  	.probe		=3D vfio_platform_probe,
> -	.remove		=3D vfio_platform_remove,
> +	.remove_new	=3D vfio_platform_remove,
>  	.driver	=3D {
>  		.name	=3D "vfio-platform",
>  	},
>=20
> base-commit: 8ffc8b1bbd505e27e2c8439d326b6059c906c9dd


