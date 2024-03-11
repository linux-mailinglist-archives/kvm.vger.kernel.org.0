Return-Path: <kvm+bounces-11507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 66138877B65
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 08:38:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E4C5B1F218BD
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 07:38:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9551010942;
	Mon, 11 Mar 2024 07:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="divTIuJJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC9E10782
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 07:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710142698; cv=none; b=bgoMYF5GZ3+JdZ6hOimK4uKCRh4V/mKyP0zuDtUwsvaiMPu+6mZ8zmgDFHMMtWyJvrEjwvTXLmFn2HAGguapS1BJE3DiltO1Qe6qDlwcwI03a67XdqQX9SJbCkXpGBjNEtO+3cXjvB/L6Zm6KB8O49ARTRPAgXwRZL2rBCNyK4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710142698; c=relaxed/simple;
	bh=TV2e/MmpgcuMkOm5Bd6slhmonWa2Puj6DcuIkBw3Pkg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PabTB4rciwX7u3D/fAUaAAGS4swJXexjbJcCTlay7MKgVOkSyTUrCTbZy1DIYmiP7Z1ZhxeF8gqqnecdlLChR9m8i3O+OBh0KZhiLuLhQ59JQoKfiQkgMXmLT01uaQC9ooRmpQOJ+eVhhMjmigBHU2cqEyvzu7bcseZeIIASdiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=divTIuJJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710142696;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZCx90yh96uJ9OtGCQ2JkgITu3TLMa4xU/HP5RQFSgdE=;
	b=divTIuJJxgFlGqKudPd26fZD4OsLXFhh/3gp/W6ZZtYU0CgbNqAXNrJYsp2p6xl6HN+opw
	/3RK65AF93E5M5LtzLvn6xpJEvSU0OGQcRkN606yWtT8AAYB0zZs50P9q37KmY25IbOIRS
	MieQWf3yKyjHl6JIrFwQy7OfNX7RsH8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-43-D5IJNwFdMK2TBdxSS2NJeg-1; Mon, 11 Mar 2024 03:38:14 -0400
X-MC-Unique: D5IJNwFdMK2TBdxSS2NJeg-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-33e8adeffe6so633313f8f.2
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 00:38:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710142693; x=1710747493;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZCx90yh96uJ9OtGCQ2JkgITu3TLMa4xU/HP5RQFSgdE=;
        b=vY3RtqGufBd9bq/AFjgi3kgnyb9yQndhTk5s1vQ/dVgOVNaUqEhvKJborHNoPQcvnS
         AjZ3vB2PhtVy3Ph0ODVG2AtQlV3K3bYL3gTsVjphtBXVX4hD2Ol//X0nVNUqaeWbZS4V
         x0OFV9krcdeD2hkHWF9pMYbAhMRcwVyxZYhSj7BmWQW3JFX4XlnzUoPQvzcfV9MypHDl
         7zqRiNhxYxAk2tjZDMzafGBlifUUx/D7QFuOCZebppxj4B+xPXslVjIgitbiMpG+GWuM
         RmvOaeKOkGpiMqawoEbD5FzUZWSb1koGA5XUb1gPE5GXcUjs6tQh7lbwALqaSZxAled1
         /boQ==
X-Gm-Message-State: AOJu0YzxGCctb8fJL1oVy1J7aDjuySATm5rCPI9V+b0O0hQSfha57M2R
	/1NzcXNC1ThuVKh19GWlt8QYwTgvlULA/w1KbL5k/Dk7/mSh+UjOI/ZYjJWhxwChdwUgoEvEN75
	uvo72/Vjbx7F0direJiX75hfij4oWxcqmSucznRGevFvw8Tq40A==
X-Received: by 2002:a5d:56d2:0:b0:33e:745a:88f5 with SMTP id m18-20020a5d56d2000000b0033e745a88f5mr3362663wrw.57.1710142693482;
        Mon, 11 Mar 2024 00:38:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHxnIVVoGGIdaMTxZ9ZZcgl//7B2CfcM+PI4GY4we8IWP+ixOfzGGZfeyZH4XM1aMrWKaAohg==
X-Received: by 2002:a5d:56d2:0:b0:33e:745a:88f5 with SMTP id m18-20020a5d56d2000000b0033e745a88f5mr3362651wrw.57.1710142693185;
        Mon, 11 Mar 2024 00:38:13 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id q18-20020adf9dd2000000b0033e90e98886sm3032651wre.71.2024.03.11.00.38.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Mar 2024 00:38:12 -0700 (PDT)
Message-ID: <a1ea42a7-6670-486e-b75f-b8133efae9bb@redhat.com>
Date: Mon, 11 Mar 2024 08:38:11 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH] vfio/platform: Convert to platform remove callback
 returning void
Content-Language: en-US
To: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
 Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, kernel@pengutronix.de
References: <79d3df42fe5b359a05b8061631e72e5ed249b234.1709886922.git.u.kleine-koenig@pengutronix.de>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <79d3df42fe5b359a05b8061631e72e5ed249b234.1709886922.git.u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

On 3/8/24 09:51, Uwe Kleine-König wrote:
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is ignored (apart
> from emitting a warning) and this typically results in resource leaks.
>
> To improve here there is a quest to make the remove callback return
> void. In the first step of this quest all drivers are converted to
> .remove_new(), which already returns void. Eventually after all drivers
> are converted, .remove_new() will be renamed to .remove().
>
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  drivers/vfio/platform/vfio_platform.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
> index 8cf22fa65baa..42d1462c5e19 100644
> --- a/drivers/vfio/platform/vfio_platform.c
> +++ b/drivers/vfio/platform/vfio_platform.c
> @@ -85,14 +85,13 @@ static void vfio_platform_release_dev(struct vfio_device *core_vdev)
>  	vfio_platform_release_common(vdev);
>  }
>  
> -static int vfio_platform_remove(struct platform_device *pdev)
> +static void vfio_platform_remove(struct platform_device *pdev)
>  {
>  	struct vfio_platform_device *vdev = dev_get_drvdata(&pdev->dev);
>  
>  	vfio_unregister_group_dev(&vdev->vdev);
>  	pm_runtime_disable(vdev->device);
>  	vfio_put_device(&vdev->vdev);
> -	return 0;
>  }
>  
>  static const struct vfio_device_ops vfio_platform_ops = {
> @@ -113,7 +112,7 @@ static const struct vfio_device_ops vfio_platform_ops = {
>  
>  static struct platform_driver vfio_platform_driver = {
>  	.probe		= vfio_platform_probe,
> -	.remove		= vfio_platform_remove,
> +	.remove_new	= vfio_platform_remove,
>  	.driver	= {
>  		.name	= "vfio-platform",
>  	},
>
> base-commit: 8ffc8b1bbd505e27e2c8439d326b6059c906c9dd


