Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E09A55C5E9
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241101AbiF0UHq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 16:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241037AbiF0UHn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 16:07:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A2FE31EAC7
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 13:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656360461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ecqp7u4gJaJ1mXBxwxi4FG5ZEdhI/0Q2gMOetVHGIac=;
        b=I6uygNf9NLWyYkiVXyTpjNLUpaz+LuiTCtj6gpREk4VOJPZhL4jERePVIVtS5JnSiI0s4c
        mn1zkfedANnxANVWsHqzUq6idFDGvvxdi6LaDkPekAYSl+E5pskKFxU/lrsLx7NqdpeuvC
        4G7usOLIghLRV3T16cGbig5v+Tx0iHk=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-220-foSkxBG6OVGwgJER6ZIw1w-1; Mon, 27 Jun 2022 16:07:37 -0400
X-MC-Unique: foSkxBG6OVGwgJER6ZIw1w-1
Received: by mail-io1-f70.google.com with SMTP id q75-20020a6b8e4e000000b0067275f1e6c4so6233405iod.14
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 13:07:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Ecqp7u4gJaJ1mXBxwxi4FG5ZEdhI/0Q2gMOetVHGIac=;
        b=OdVK4msgtcnh9HpGQ7DSHRjtOv28tgLZ+nVH00IUgUzNNPGDR+4WXkG88KxMIn7XQJ
         /PnHwMu8cP0cYKreuik+RwdbjuaYsIJ2SUoy0v8Js/nHtYsWf4cutE9lr09Sjj1oYuNq
         vuRhflklrXBh5V4A8opETxg5PUBU1t4RuhZTXLutygaqIsRCFmF0M8hdpNkdodBUgM1l
         4Eqeg8n80OK6nfRNsxEgLd0ci5ADbhfSPbBHEWXyxyPJt5IhIVxXeChpg5ISZusLwy25
         T7GGzrqPFex2lVZeA2SxeacPARw3hcg1avtCpR6G5uNfmxqz8E5ru7F+L1lvQoGB/TS8
         j54A==
X-Gm-Message-State: AJIora/g/68lRlGa+DE8H+jMb2HfxUZr4NqZYPnMTRM2g9o3D+XfIqCc
        mR1reBnkRyRRgqIjaP8TFQq8qm+BkPAp1/AGBm6bjPQkh79Cus5D0/nc5TVpvYU+MYIqAuUNZNu
        stz1B2ubxh2w+
X-Received: by 2002:a05:6638:22c7:b0:333:f684:ccc4 with SMTP id j7-20020a05663822c700b00333f684ccc4mr8853608jat.57.1656360457269;
        Mon, 27 Jun 2022 13:07:37 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sNIPUYijEfnPKfQZWxOpm7YokpOplZ2wBAN4sSDoCyh8jOJGTEHm2vhuygZD7iG02GUVE7+w==
X-Received: by 2002:a05:6638:22c7:b0:333:f684:ccc4 with SMTP id j7-20020a05663822c700b00333f684ccc4mr8853601jat.57.1656360457084;
        Mon, 27 Jun 2022 13:07:37 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id x66-20020a0294c8000000b00339dd803fddsm5190825jah.174.2022.06.27.13.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 13:07:36 -0700 (PDT)
Date:   Mon, 27 Jun 2022 14:07:35 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 8/8] vfio: do not set FMODE_LSEEK flag
Message-ID: <20220627140735.32723d4a.alex.williamson@redhat.com>
In-Reply-To: <20220625110115.39956-9-Jason@zx2c4.com>
References: <20220625110115.39956-1-Jason@zx2c4.com>
        <20220625110115.39956-9-Jason@zx2c4.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 25 Jun 2022 13:01:15 +0200
"Jason A. Donenfeld" <Jason@zx2c4.com> wrote:

> This file does not support llseek, so don't set the flag advertising it.
> 
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>
> Cc: kvm@vger.kernel.org
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  drivers/vfio/vfio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 61e71c1154be..d194dda89542 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1129,7 +1129,7 @@ static struct file *vfio_device_open(struct vfio_device *device)
>  	 * Appears to be missing by lack of need rather than
>  	 * explicitly prevented.  Now there's need.
>  	 */
> -	filep->f_mode |= (FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE);
> +	filep->f_mode |= (FMODE_PREAD | FMODE_PWRITE);
>  
>  	if (device->group->type == VFIO_NO_IOMMU)
>  		dev_warn(device->dev, "vfio-noiommu device opened by user "

Acked-by: Alex Williamson <alex.williamson@redhat.com>

