Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04EA040EA41
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 20:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349759AbhIPSw6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 14:52:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49196 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349702AbhIPSwz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Sep 2021 14:52:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631818294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t0dZXEuvtEjF+iOlGPVVpNuboXtZjlBCWt2sC2E9Ta0=;
        b=iKTjSg/pY1mXJ2R4NvqoHR8JcnJ9PB7r7/Tgnw7snAuXR6HMSFC8ciFg/ik7Pdoe3GMYBe
        OlEOqZ6D66IA6arut7V2UQlA48802suI2p2c1v563CB1fS++ABbWFYVqUxz7pzpz01E9Lk
        COHgnnxitUGNhpVWdE0cpNv82QVRPHA=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-hdTSzg6sN2Kx86zFCNrU7A-1; Thu, 16 Sep 2021 14:51:33 -0400
X-MC-Unique: hdTSzg6sN2Kx86zFCNrU7A-1
Received: by mail-oo1-f72.google.com with SMTP id k1-20020a4a8501000000b0029ac7b9dc82so21186639ooh.17
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:51:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=t0dZXEuvtEjF+iOlGPVVpNuboXtZjlBCWt2sC2E9Ta0=;
        b=6d6GtiH8ASdKAjib6fGDGpPuxLwCiSdbyRba5uzZgQKJm5L2UsxTDoVOzevQLJxLaG
         Joz6RW9G/LJGZVMCG2H5AcEMC3sn1ScFxWbENrF7D9AvqeNfzbs+qJW9GEZkKvZoEugK
         TO3Mej3te+FrFz6emn/oE+ANuAsPUpUZirwJi5McN3fsxGkwOZnYTTqJ/SmilOV9VhiE
         ekNN6vKJBqrwo9AvZnP2sXEGneJaskWtGnGK2l7v5+ECWaetCGlZBPEexGDgTRVLxCij
         TKFnOKEpu0L5OjNZjb4BErbLNW33ypX6FKBkezNUgE7anrDi4tlA93G6JL+y9FkewKFa
         Kv0A==
X-Gm-Message-State: AOAM532xB2bH4izM55u22qXl9nklfzEhLo0Xtua2UGZIpfMopPTN1IB0
        GC4YJ8028vHGiyNEsyQMjNEkzNgX3W6Fa3SHF6+cW/PEYXngBoQGbm/l6XAgu5fiQqp28S81Sdz
        hDgHd/uX88X/y
X-Received: by 2002:aca:6254:: with SMTP id w81mr980159oib.83.1631818292324;
        Thu, 16 Sep 2021 11:51:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwG5lUyD94BxYl3xRntKqwsHjZwEOV6TUGUMKu8At8EeuUfhEszbIKW3Ykbxrnhdgjnid87Eg==
X-Received: by 2002:aca:6254:: with SMTP id w81mr980137oib.83.1631818292043;
        Thu, 16 Sep 2021 11:51:32 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id r20sm891428oot.16.2021.09.16.11.51.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 11:51:31 -0700 (PDT)
Date:   Thu, 16 Sep 2021 12:51:30 -0600
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
Subject: Re: [PATCH v2] vfio/ap_ops: Add missed vfio_uninit_group_dev()
Message-ID: <20210916125130.2db0961e.alex.williamson@redhat.com>
In-Reply-To: <0-v2-25656bbbb814+41-ap_uninit_jgg@nvidia.com>
References: <0-v2-25656bbbb814+41-ap_uninit_jgg@nvidia.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 10 Sep 2021 20:06:30 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Without this call an xarray entry is leaked when the vfio_ap device is
> unprobed. It was missed when the below patch was rebased across the
> dev_set patch.
> 
> Fixes: eb0feefd4c02 ("vfio/ap_ops: Convert to use vfio_register_group_dev()")
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 2 ++
>  1 file changed, 2 insertions(+)

Hi Tony, Halil, Jason (H),

Any acks for this one?  Thanks,

Alex

 
> v2: Fix corrupted diff
> v1: https://lore.kernel.org/all/0-v1-3a05c6000668+2ce62-ap_uninit_jgg@nvidia.com/
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
> @@ -375,6 +376,7 @@ static void vfio_ap_mdev_remove(struct mdev_device *mdev)
>  	mutex_lock(&matrix_dev->lock);
>  	vfio_ap_mdev_reset_queues(matrix_mdev);
>  	list_del(&matrix_mdev->node);
> +	vfio_uninit_group_dev(&matrix_mdev->vdev);
>  	kfree(matrix_mdev);
>  	atomic_inc(&matrix_dev->available_instances);
>  	mutex_unlock(&matrix_dev->lock);
> 
> base-commit: ea870730d83fc13a5fa2bd0e175176d7ac8a400a

