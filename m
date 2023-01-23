Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77BE2678688
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 20:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbjAWTiL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 14:38:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbjAWTiK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 14:38:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4C127D72
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 11:37:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674502643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U3waa7Vh+F3v4Sw9OdVRy/Ysk0VROOPMdvyuuB1wY94=;
        b=Ffjy6Jy/rKQxf0p9iUNuMOCSDbrr8wNss+0jmOhzNgs05UaWGBGznCEZ9Ktx8bRmlcTaNY
        IReP1GfjHQE/clVxBRMps7HrEvdpVM1BBL8C7eCPOl7GcYYOkdX3Y+moebWius5MgFnsIJ
        Xypw6YzRPmz7swzdQmL+n5+UNhHUewQ=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-20-ZZyNklRLPk6kmmIOwoSEXQ-1; Mon, 23 Jan 2023 14:37:21 -0500
X-MC-Unique: ZZyNklRLPk6kmmIOwoSEXQ-1
Received: by mail-io1-f71.google.com with SMTP id y22-20020a5d94d6000000b007076e06ba3dso7630756ior.20
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 11:37:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U3waa7Vh+F3v4Sw9OdVRy/Ysk0VROOPMdvyuuB1wY94=;
        b=fj9I3utyjjGnzvyVjvW5UizssFq1hc9JYmKGgYrXnQoKUlYlvbA7k4/v1BaMyx9MSC
         fJWxSxMQ/QOALts6uCMgGVL11oSVyD0rJGb9qJ6ouH38Yo5WBrRxMdRi0MHm+K0GpLjm
         DX4iDqwQ6HgnFvUzZNiYrxT9wd0AQOFo0S94/BjrqjDbvNKtNYyYU9EjEx5oma8mdFX5
         VqZaJQc1N/dB3WYIzGWgsJHRkwtrLVsKE3bxxpiygb0u4DaOR0/FIALst7wdjq7tT1bv
         aTtpWFgCEgXYgJZQITrdYC6Kw/pMYs/GMfm6/Ne4btRsJ9vpDIfwKkDJmyZs+aHQDbQL
         dc1w==
X-Gm-Message-State: AFqh2kosrQu+A2p3Y5+cfd/pmxCWXFmZLwhvu9QUJU66t2IN6QgsSm9+
        7z9INUXXpSBiZ+B5FFEVA1gPpoAZDeMbGQFspf7pYK8fRZMo3RsXI3mXpwEL7fBc4kBgB+Q3wfi
        eMW5Q8TRspcZN
X-Received: by 2002:a6b:e812:0:b0:704:c53c:87e1 with SMTP id f18-20020a6be812000000b00704c53c87e1mr19626890ioh.19.1674502641188;
        Mon, 23 Jan 2023 11:37:21 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvlHPcLruMSlZ46j7dIYhdYjmfLX++yyUXL53K95uB7smD1R7fbFefFew3pItw9QDm9fSngrA==
X-Received: by 2002:a6b:e812:0:b0:704:c53c:87e1 with SMTP id f18-20020a6be812000000b00704c53c87e1mr19626884ioh.19.1674502640945;
        Mon, 23 Jan 2023 11:37:20 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id v26-20020a056602059a00b00704c3128817sm7121378iox.43.2023.01.23.11.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 11:37:20 -0800 (PST)
Date:   Mon, 23 Jan 2023 12:36:58 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Angus Chen <angus.chen@jaguarmicro.com>
Cc:     eric.auger@redhat.com, cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: platform: No need to check res again
Message-ID: <20230123123658.2748e6fc.alex.williamson@redhat.com>
In-Reply-To: <20230107034721.2127-1-angus.chen@jaguarmicro.com>
References: <20230107034721.2127-1-angus.chen@jaguarmicro.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat,  7 Jan 2023 11:47:20 +0800
Angus Chen <angus.chen@jaguarmicro.com> wrote:

> In function vfio_platform_regions_init(),we did check res implied
> by using while loop,
> so no need to check whether res be null or not again.
> 
> No functional change intended.
> 
> Signed-off-by: Angus Chen <angus.chen@jaguarmicro.com>
> ---
>  drivers/vfio/platform/vfio_platform_common.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
> index 1a0a238ffa35..a9ad3f4d2613 100644
> --- a/drivers/vfio/platform/vfio_platform_common.c
> +++ b/drivers/vfio/platform/vfio_platform_common.c
> @@ -150,9 +150,6 @@ static int vfio_platform_regions_init(struct vfio_platform_device *vdev)
>  		struct resource *res =
>  			vdev->get_resource(vdev, i);
>  
> -		if (!res)
> -			goto err;
> -
>  		vdev->regions[i].addr = res->start;
>  		vdev->regions[i].size = resource_size(res);
>  		vdev->regions[i].flags = 0;

Applied to vfio next branch for v6.3.  Thanks,

Alex

