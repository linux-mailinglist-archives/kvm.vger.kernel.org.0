Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D72F3F6BE7
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 00:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbhHXWvo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 18:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhHXWvn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 18:51:43 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F19C061757
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 15:50:58 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id y144so25090436qkb.6
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 15:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4NUQrGBdseXd0ScOkj/KcXc+EFBYVq8ZToVfGY/O9WQ=;
        b=SUPs6tNWAHNTHeZ2omgQ+NUSlYqeuTYS/EXCpaG2HWcmRVOQLVsDnbpfhH61yDucTg
         x6CAVCwLhapcGo2synS3FQ43MX1LJ0t9tc5UlKUP6ENkgiE+O0J4L7JJOgSSwYZ3PkAk
         WutRebZl/CxQYyH0oDXQ68nXLqAmTWGHgMP3pmPZ9E0l1qYjRsNtOn4vbS2RKUIbcofy
         tvyUUhvp+HuhXKpGzopU8LOAHpbKPlta6TuNQK0emM2lggINbhvluOu4l4NSOQK5zN/8
         VZ15V2CaJb/XgAiOhFZd4E40cHeeRNLrW067ClwgffCXq342/NHuNOiK3es3qqH+0dRC
         AvMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4NUQrGBdseXd0ScOkj/KcXc+EFBYVq8ZToVfGY/O9WQ=;
        b=rYKWDiqA+gpOyRg97/Ntqcf0bDMQirk5EZpGlhc17U+H98w+C0xuy8HTDNhR225shF
         +7/QPu9CHtgieFBbBZJfwJ5/d+2ZQa+ksSC9Qi/z4TgdG9HNSapcp+1zPUyL2ftEqi2p
         uVd4sow/dkCOdEP0ech+itmD7vI4fRbiUixnV1vdupF02pOodAY/2LiRuD4Jp24IFyP9
         xs1bbSijHqiI34ZA7KZkvkopTY88RX4lF/4tVRMy6z41CSNoWUPjGZe8qvpIfj1gahxg
         e/JowvlHm7YBli+1CKUsnYy719+ibrFvMf8TpV8Mj+69HHD0vARqTPmLUvA7XFh6MUZK
         kgPA==
X-Gm-Message-State: AOAM532fRdVhxmNmaUHYwMFewlAm5JNV604RRhnmxjMdUKtkG8T7wo3d
        a5fImTVicCQHszLLrEvVoyXYPg==
X-Google-Smtp-Source: ABdhPJw/bLrpkznwlpXDgCuTkP64z2Isgr18jKxRg+mIM9YHGy2kIxbYlXVKlcMIdHWjtrpGyiGmvw==
X-Received: by 2002:a37:6255:: with SMTP id w82mr28648699qkb.252.1629845457416;
        Tue, 24 Aug 2021 15:50:57 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id n11sm1606280qkk.17.2021.08.24.15.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 15:50:57 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mIfFw-004c30-8U; Tue, 24 Aug 2021 19:50:56 -0300
Date:   Tue, 24 Aug 2021 19:50:56 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 01/14] vfio: Move vfio_iommu_group_get() to
 vfio_register_group_dev()
Message-ID: <20210824225056.GH543798@ziepe.ca>
References: <20210824144649.1488190-1-hch@lst.de>
 <20210824144649.1488190-2-hch@lst.de>
 <20210824142508.3a72fe4a.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824142508.3a72fe4a.alex.williamson@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 24, 2021 at 02:25:08PM -0600, Alex Williamson wrote:
> > @@ -1988,8 +1979,6 @@ static void vfio_pci_remove(struct pci_dev *pdev)
> >  	vfio_uninit_group_dev(&vdev->vdev);
> >  	vfio_pci_vga_uninit(vdev);
> >  
> > -	vfio_iommu_group_put(pdev->dev.iommu_group, &pdev->dev);
> > -
> >  	if (!disable_idle_d3)
> >  		vfio_pci_set_power_state(vdev, PCI_D0);
> >  
> 
> 
> I think this turns into the patch below on top of Yishai's
> vfio-pci-core series.  Please verify.  If you'd like something
> different, please post an update.  Thanks,

It appears correct to me, thanks

Jason
