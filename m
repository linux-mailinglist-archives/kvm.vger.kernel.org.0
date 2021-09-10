Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41CB1407278
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 22:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233384AbhIJU0r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 16:26:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46451 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233397AbhIJU0q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Sep 2021 16:26:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631305535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=43k0//Ex2cYDlTEbrRHwYvccCOHqUEbEWZ9s5rg8S24=;
        b=SdjHtmrpIreBKu4aaZgJcCZSd1ynNGJ8vRVqadDJfMxHtzxM6BC57uVBkftfqvAT4rUIAp
        yj2So4+bj2Z+4aW+TFQ7aSGaGrW/DZlFRMYmFkTP10AzNHUlRTt44srRaxQ9JXluw6iwu1
        r8Q9qONu5FijySKfjyXInaQjjekEPc0=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-492-rCNsDR91O3mGqMKqaNgPbw-1; Fri, 10 Sep 2021 16:25:33 -0400
X-MC-Unique: rCNsDR91O3mGqMKqaNgPbw-1
Received: by mail-oi1-f198.google.com with SMTP id 20-20020aca2814000000b002690d9b60aaso2405282oix.0
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 13:25:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=43k0//Ex2cYDlTEbrRHwYvccCOHqUEbEWZ9s5rg8S24=;
        b=cOxGiVi5Mn9c6LL6FK90K+Nonod59vfLLw60WEyraIDgT4OMgYR2OFmcj8xC2FrFP+
         ypY1PhxwlBsbVcTo7M8mQ3eYV9u5P0tV33qrMmKRXgJstmdONEMWLsJvB8AZlER5JHYM
         TwGA3oYQj6z14Hkb5JUWffTLGy/6ryMOFgXhNY59VPaJFkkGuE0bujfiwe7uW7UkY/Xi
         GPOYjVdvfdIgF7RHpkhEIYqY8xS95weYk3MkqArkoG06r2gdX4pT/ZkypoO9V+SePbmU
         Zz0PoADC+OvPj0DsexL3Brl20rFhCALy4u4gEwdyJPNI7W82yQNwuublVZ2HM80v7YpC
         HFdA==
X-Gm-Message-State: AOAM532Ygxeww70dNCgc7jzkSy7Lqh1SrohobgJGSKSOuXoHpWw/DsBd
        M87A/CigW84AFBnrdo9hOKInGYtg4ZA+XbJaLPxY2WWCO0a8wTgN3Xcm9Ca8LVtALATG9ifF4m3
        Ihe2VewCB+VHq
X-Received: by 2002:a05:6830:18c7:: with SMTP id v7mr6324382ote.126.1631305533204;
        Fri, 10 Sep 2021 13:25:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYrFnBjgHbgw4oFL2xGmKazRhOApYuH6K1Sj3HlCQm6wWY57BvwLdhxibj8FSVdeN7/KJt5g==
X-Received: by 2002:a05:6830:18c7:: with SMTP id v7mr6324353ote.126.1631305532962;
        Fri, 10 Sep 2021 13:25:32 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id 33sm1446635otx.19.2021.09.10.13.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 13:25:32 -0700 (PDT)
Date:   Fri, 10 Sep 2021 14:25:31 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Christoph Hellwig <hch@lst.de>, kvm@vger.kernel.org
Subject: Re: [PATCH] vfio/ap_ops: Add missed vfio_uninit_group_dev()
Message-ID: <20210910142531.2e18e73a.alex.williamson@redhat.com>
In-Reply-To: <0-v1-3a05c6000668+2ce62-ap_uninit_jgg@nvidia.com>
References: <0-v1-3a05c6000668+2ce62-ap_uninit_jgg@nvidia.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  9 Sep 2021 14:24:00 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Without this call an xarray entry is leaked when the vfio_ap device is
> unprobed. It was missed when the below patch was rebased across the
> dev_set patch.
> 
> Fixes: eb0feefd4c02 ("vfio/ap_ops: Convert to use vfio_register_group_dev()")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 2347808fa3e427..54bb0c22e8020e 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -360,6 +360,7 @@ static int vfio_ap_mdev_probe(struct mdev_device *mdev)
>  	mutex_lock(&matrix_dev->lock);
>  	list_del(&matrix_mdev->node);
>  	mutex_unlock(&matrix_dev->lock);
> +	vfio_uninit_group_dev(&matrix_mdev->vdev);
>  	kfree(matrix_mdev);
>  err_dec_available:
>  	atomic_inc(&matrix_dev->available_instances);
> @@ -375,8 +376,8 @@ static void vfio_ap_mdev_remove(struct mdev_device *mdev)


Not sure if you're editing patches by hand, but your line counts above
don't match the chunk below, should be ,6..,7 as the previous chunk.
It's malformed as is.  Thanks,

Alex

>  	mutex_lock(&matrix_dev->lock);
>  	vfio_ap_mdev_reset_queues(matrix_mdev);
>  	list_del(&matrix_mdev->node);
> +	vfio_uninit_group_dev(&matrix_mdev->vdev);
>  	kfree(matrix_mdev);
>  	atomic_inc(&matrix_dev->available_instances);
>  	mutex_unlock(&matrix_dev->lock);
> 

