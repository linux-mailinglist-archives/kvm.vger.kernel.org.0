Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A68843B0EEC
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 22:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhFVUlr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 16:41:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32131 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229629AbhFVUlq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 16:41:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624394370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g0MrG4+ll2NdZhlnJFDRRtUXoxi3BC214us5+iugMf4=;
        b=dMMgFNCcdG2ph1OghqEpEDx2g4DW/xiZPpbvDZ2ZJMUsLG5pmtBQegvNFHPD2+V695v8+8
        xROkFRFViQdmJBagF+n2iOj4SiA3Odb6cy81gLdqmB4ZOzxg/yqDiY7qE0qBGxhCnLQ1Te
        JSkfj/rShXk38366OunRmFPhuztO4mA=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-PtRI2fJRNY6Txnatx4CzcQ-1; Tue, 22 Jun 2021 16:39:28 -0400
X-MC-Unique: PtRI2fJRNY6Txnatx4CzcQ-1
Received: by mail-oi1-f200.google.com with SMTP id r3-20020aca44030000b02902241b7398a8so368624oia.19
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 13:39:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g0MrG4+ll2NdZhlnJFDRRtUXoxi3BC214us5+iugMf4=;
        b=Qs7zsLCKafxXHGIJIuRdDSTNliOIgDbfdGzvotV2O8S3D3Q0eismrt7JmAS/SsB392
         Sh62s77hSKbDqjUMMXwWkqm4QgkHUS77HNxEnNhjlevzQXrH03+wqGeHVS2rT0eXPQPf
         4JdNtN1mjkfaeH6+FRgvfpopPaWg2zqj6sfhvV8kRsX60uzWXUS16m5BoQTdAwnoxZjv
         eWWz/zWpbf1cpiq/WHpg+lIW/h18ydPvw25yD8lYMq4pv9TftZejFft5Xet706cUCSDW
         ZiDEIntSB4DxcY5reJM8FUsL/K5mqY2Nr+MossboprDq4H9ZO8AOPsWtkk0SqxLHsDY4
         S/vw==
X-Gm-Message-State: AOAM531K4CLIWQ7w+WcJDxFsnZMwS2vjrPQHBl7vpjeGHc0+sxX1dJ2a
        B2NbytA5qTN+ORR5H2Boc6QIzdqRSAIC3y37zdSmdVTvkvR2cY5pPpfG+hQSlQPwnSnApxZvQkC
        FCl76yaE+nNwI
X-Received: by 2002:a05:6808:2012:: with SMTP id q18mr505145oiw.1.1624394368055;
        Tue, 22 Jun 2021 13:39:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyEtvh0TeVS8XIjLHgIJPcpwXe8Uxkzd568eyguTJwkGZ5onD2K6d+EchimlC6NR2wEOkVRIg==
X-Received: by 2002:a05:6808:2012:: with SMTP id q18mr505135oiw.1.1624394367873;
        Tue, 22 Jun 2021 13:39:27 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id f63sm115130otb.36.2021.06.22.13.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 13:39:27 -0700 (PDT)
Date:   Tue, 22 Jun 2021 14:39:26 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Colin King <colin.king@canonical.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kvm@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] vfio/mdpy: Fix memory leak of object
 mdev_state->vconfig
Message-ID: <20210622143926.7880e698.alex.williamson@redhat.com>
In-Reply-To: <20210622185824.GU1096940@ziepe.ca>
References: <20210622183710.28954-1-colin.king@canonical.com>
        <20210622185824.GU1096940@ziepe.ca>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 22 Jun 2021 15:58:24 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Tue, Jun 22, 2021 at 07:37:10PM +0100, Colin King wrote:
> > From: Colin Ian King <colin.king@canonical.com>
> > 
> > In the case where the call to vfio_register_group_dev fails the error
> > return path kfree's mdev_state but not mdev_state->vconfig. Fix this
> > by kfree'ing mdev_state->vconfig before returning.
> > 
> > Addresses-Coverity: ("Resource leak")
> > Fixes: 437e41368c01 ("vfio/mdpy: Convert to use vfio_register_group_dev()")
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> >  samples/vfio-mdev/mdpy.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
> > index 7e9c9df0f05b..393c9df6f6a0 100644
> > +++ b/samples/vfio-mdev/mdpy.c
> > @@ -261,6 +261,7 @@ static int mdpy_probe(struct mdev_device *mdev)
> >  
> >  	ret = vfio_register_group_dev(&mdev_state->vdev);
> >  	if (ret) {
> > +		kfree(mdev_state->vconfig);
> >  		kfree(mdev_state);
> >  		return ret;
> >  	}  
> 
> Thanks Colin, looks right
> 
> Alex, this is in your hch-mdev-direct-v4 branch can you squash or
> whatever?
> 
> Though if we are touching this I prefer the below:

Discrete fix above as a follow-up patch and later add the below as an
exit path cleanup, if you'd like to post it separately, seems like the
way to go to me.  Thanks,

Alex

> diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
> index 7e9c9df0f05bac..868a0e7fa90e98 100644
> --- a/samples/vfio-mdev/mdpy.c
> +++ b/samples/vfio-mdev/mdpy.c
> @@ -235,17 +235,16 @@ static int mdpy_probe(struct mdev_device *mdev)
>  
>  	mdev_state->vconfig = kzalloc(MDPY_CONFIG_SPACE_SIZE, GFP_KERNEL);
>  	if (mdev_state->vconfig == NULL) {
> -		kfree(mdev_state);
> -		return -ENOMEM;
> +		ret = -ENOMEM;
> +		goto err_state;
>  	}
>  
>  	fbsize = roundup_pow_of_two(type->width * type->height * type->bytepp);
>  
>  	mdev_state->memblk = vmalloc_user(fbsize);
>  	if (!mdev_state->memblk) {
> -		kfree(mdev_state->vconfig);
> -		kfree(mdev_state);
> -		return -ENOMEM;
> +		ret = -ENOMEM;
> +		goto err_vconfig;
>  	}
>  	dev_info(dev, "%s: %s (%dx%d)\n", __func__, type->name, type->width,
>  		 type->height);
> @@ -260,12 +259,17 @@ static int mdpy_probe(struct mdev_device *mdev)
>  	mdpy_count++;
>  
>  	ret = vfio_register_group_dev(&mdev_state->vdev);
> -	if (ret) {
> -		kfree(mdev_state);
> -		return ret;
> -	}
> +	if (ret)
> +		goto err_vconfig;
> +
>  	dev_set_drvdata(&mdev->dev, mdev_state);
>  	return 0;
> +
> +err_vconfig:
> +	kfree(mdev_state->vconfig);
> +err_state:
> +	kfree(mdev_state);
> +	return ret;
>  }
>  
>  static void mdpy_remove(struct mdev_device *mdev)
> 

