Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07F1A416845
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 00:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243529AbhIWXAy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 19:00:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44887 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243492AbhIWXAy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Sep 2021 19:00:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632437961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a42FLpW3w7VlgcPSnoHrZ4uruBRiGMhumnipHx2m+yY=;
        b=U6MHdgV2Wmy+CDDyUiNSThckbNTuw5LBPYmOAZaLAPNh5r1eCQc4xATZoAFqToen/bNnCH
        wQg5JZLLT0i8gVRSoXMRH31k2VFAouPgNYSByyc0PixzDVeyTItJaXxAgEt+1uUO0FuJS4
        +IsYhsKCEqrQIx31r8cR8Uob84xsw94=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-119-5jHwq_4iM4GFadOFx5YKng-1; Thu, 23 Sep 2021 18:59:20 -0400
X-MC-Unique: 5jHwq_4iM4GFadOFx5YKng-1
Received: by mail-ot1-f72.google.com with SMTP id t26-20020a9d749a000000b00547047a5594so4733789otk.0
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 15:59:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a42FLpW3w7VlgcPSnoHrZ4uruBRiGMhumnipHx2m+yY=;
        b=HnbEwZr55cjKxGBJvxQ5iz52cw9X7wPK6nFaPsZjoGUq+1au6Fsdcs0cRGVzjMDwP8
         FD1I/1LL3Ql1kwXwom2wiNU3Ll9OZ5NZRV7RXteH0gCGvPDsE4WL8DwykNZT+If1buCq
         NR68d3AA0p23aiYe0nQuSFLqbJUsf57zNUebipkr5Kp2VjCyFdU7OmBvPpMcgM9UOYKG
         zRcdcJOdpS2jNHVmu9HmRcicmWb6LnWYxGmYgTZqLuC0HLdeRt+8+ztgLDndGMnCgvrn
         +S9nik3A4m9ALynLzvhYS0x/CiutdYIgZnPL2pm7TpbO+as9uNd+HJNoJ3pK1jB1O5eA
         2mcA==
X-Gm-Message-State: AOAM531xMv6n2HBQtBD7bu/KuxC0ZIMD0uStePRXRovs20iAbHx1OiHb
        89wS7cNqRo9YApv1BINCoBV0adGa44hWllOk+z3UnR5VLl4f/uvItqGIwDkcH9IP02rXzacnUK+
        BRfW7WX7z+edt
X-Received: by 2002:aca:4b8d:: with SMTP id y135mr5586026oia.177.1632437959564;
        Thu, 23 Sep 2021 15:59:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxIS3a8H8nerzWkEpg+he6nkahrFSk45e2vXaHMitWigESPURdfcdtbre1rP1Niikyt4xhYFw==
X-Received: by 2002:aca:4b8d:: with SMTP id y135mr5586008oia.177.1632437959372;
        Thu, 23 Sep 2021 15:59:19 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id w184sm1694673oie.35.2021.09.23.15.59.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 15:59:19 -0700 (PDT)
Date:   Thu, 23 Sep 2021 16:59:17 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Terrence Xu <terrence.xu@intel.com>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH 02/14] vfio: factor out a vfio_iommu_driver_allowed
 helper
Message-ID: <20210923165917.33383150.alex.williamson@redhat.com>
In-Reply-To: <20210913071606.2966-3-hch@lst.de>
References: <20210913071606.2966-1-hch@lst.de>
        <20210913071606.2966-3-hch@lst.de>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 13 Sep 2021 09:15:54 +0200
Christoph Hellwig <hch@lst.de> wrote:

> Factor out a little helper to make the checks for the noiommu driver less
> ugly.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>  drivers/vfio/vfio.c | 37 +++++++++++++++++++++----------------
>  1 file changed, 21 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index b39da9b90c95bc..faf8e0d637bb94 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
...
> @@ -999,8 +1014,8 @@ void vfio_unregister_group_dev(struct vfio_device *device)
>  		wait_event(group->container_q, !group->container);
>  
>  #ifdef CONFIG_VFIO_NOIOMMU
> -	if (iommu_group_get_iommudata(group) == &noiommu)
> -		iommu_group_remove_device(dev);
> +	if (iommu_group_get_iommudata(group->iommu_group) == &noiommu)
> +		iommu_group_remove_device(device->dev);
>  #endif
>  	/* Matches the get in vfio_register_group_dev() */
>  	vfio_group_put(group);

This is a build fix to the previous patch in the series, it should be
rolled in there.  Thanks,

Alex

