Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3638E417A00
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 19:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344701AbhIXRu2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 13:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343935AbhIXRu1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 13:50:27 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37188C061571
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 10:48:54 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id f130so28910463qke.6
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 10:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yoEgOEHGEfKDPPB50DM9Q3Ht4ndinHKWIXanXTejSuM=;
        b=ZTwbzaLo9ESWXi2KsjQmX5+btl0GuHKmULyhje0thd0GiJAZcxUjdIhHZ+ahAKNJFz
         EbBepDcYycb0aRDoBaHYrtTO3L7fyEAYAag6C14+oJdaAu6UAplOBKEEYEVGpLQjro3Q
         NaRdVk6iGyb1gSQm51Z+BQOBGbaZE8XTUXbB/Z3budv4eczrjy6FO4m0DpXOv2jEpe+J
         MpNUOSIBPYnykeYuMOva/KH0QFuxrLuSxLJvVPD7HjVCJ3Ni5i3flWj+nZbuouMj2znv
         piFvdjfr9l2uVofPGlmkK+9dU/d7XLCChvp7iqVWeez6b4XPynH/XAV+rgKwqDycK58K
         OFAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yoEgOEHGEfKDPPB50DM9Q3Ht4ndinHKWIXanXTejSuM=;
        b=YxgCnjdpidt6TL8nQ6jT+3OYfshTdiplNzDZQuwpT+RdZMP2qkXM/tnOpJUwtIXpWB
         jZJ5vI5CQ4BsHNdH6+nkedy+cOFKhNUJqi5vmgEztgIC3tgL9IeEYYAgPGkLOHyRLOqJ
         i3F7D65f9cWBSByQQNkwEm8Jsrl2xbE6JIA0foI2VnjR8kXib1Yygibdmf5dsQ6uHlJu
         YMuFwzLpXoVnhHIoNtCtEbiGChT/eM3JMbCmOrNXrOIyXeDyrcBCQZ+hq4HBhnKPDrum
         Ijyls4gnOPt2R9L89D3hXSTFdqXvBPk+0BGoOAvRr92sVsVdLOK/uOCupivUfK9kE6Dz
         p+kw==
X-Gm-Message-State: AOAM532+E+mcmwvNL6VejCissFBIUvpV7+OmWmOl6SpoWio3ErjRMLaK
        b9Q0h/+1p118aM463n0bGqPr7g==
X-Google-Smtp-Source: ABdhPJz6QpqSWau+vaijaHsn7z+Hvc/Gm9sZZYU/ZA9TLvhi9KIWmLagix73WKn9aG0bPRI9zittVQ==
X-Received: by 2002:a37:88a:: with SMTP id 132mr11655424qki.151.1632505733448;
        Fri, 24 Sep 2021 10:48:53 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id q5sm963643qkl.64.2021.09.24.10.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 10:48:52 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mTpJc-005FPz-AF; Fri, 24 Sep 2021 14:48:52 -0300
Date:   Fri, 24 Sep 2021 14:48:52 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Terrence Xu <terrence.xu@intel.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 13/15] vfio/iommu_type1: initialize pgsize_bitmap in
 ->open
Message-ID: <20210924174852.GZ3544071@ziepe.ca>
References: <20210924155705.4258-1-hch@lst.de>
 <20210924155705.4258-14-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210924155705.4258-14-hch@lst.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 24, 2021 at 05:57:03PM +0200, Christoph Hellwig wrote:
> Ensure pgsize_bitmap is always valid by initializing it to ULONG_MAX
> in vfio_iommu_type1_open and remove the now pointless update for
> the external domain case in vfio_iommu_type1_attach_group, which was
> just setting pgsize_bitmap to ULONG_MAX when only external domains
> were attached.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>  drivers/vfio/vfio_iommu_type1.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index a48e9f597cb213..2c698e1a29a1d8 100644
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -2196,7 +2196,6 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  		if (!iommu->external_domain) {
>  			INIT_LIST_HEAD(&domain->group_list);
>  			iommu->external_domain = domain;
> -			vfio_update_pgsize_bitmap(iommu);
>  		} else {
>  			kfree(domain);
>  		}
> @@ -2582,6 +2581,7 @@ static void *vfio_iommu_type1_open(unsigned long arg)
>  	mutex_init(&iommu->lock);
>  	BLOCKING_INIT_NOTIFIER_HEAD(&iommu->notifier);
>  	init_waitqueue_head(&iommu->vaddr_wait);
> +	iommu->pgsize_bitmap = ULONG_MAX;

I wonder if this needs the PAGE_MASK/SIZE stuff?

   iommu->pgsize_bitmap = ULONG_MASK & PAGE_MASK;

?

vfio_update_pgsize_bitmap() goes to some trouble to avoid setting bits
below the CPU page size here

Jason
