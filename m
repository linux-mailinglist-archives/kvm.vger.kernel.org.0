Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 382A73F752B
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 14:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240880AbhHYMgK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 08:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240564AbhHYMgK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 08:36:10 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE21C061757
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 05:35:24 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id f22so17140084qkm.5
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 05:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/yscRSEIDvdm5rn6ygNKjbv8KaB47GNeKmxu+T1nxJg=;
        b=H1BKJvl+rMCOJt1PSz7XJ9MhMmDQ659JOS5/o0Zepd7Rd0ijq+IcmRPZFy9+fvHmQU
         2D0kD78UOCKJC6Ql8A37M4dsC0PAxs+7qAYCKdP/3Ez4Nlst7vvlvfrWnMH5tiJ+u0vQ
         75pe9zjc2AiDFj63zEsPqKtD/1ktWrPThP7V1Ib09zvCmFAvvbpLah7a0h2soeqtuWam
         L0WHF9vT70+buOlJvBMeShLvkhR2r3ua18TaKQhnf7R87JYqYt26eTf0fqnE5R69Rum4
         TdU10wyy5RzrJL/AWsK4xtPWN9Ep34IGcPiYRYud97i7gqcIPX3UcEQYI2UnEM1m058R
         EKsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/yscRSEIDvdm5rn6ygNKjbv8KaB47GNeKmxu+T1nxJg=;
        b=PY+8xCPujJuhbcpQDYFNB7O0r/W9JOoBFszXxA3u1Q/s3jfDBO7Z+hanOTLvCmoB/M
         e1L7eaXgyg37uhmuexb41Xe6ln1/DWlpHl1/1iBdWsgE8i/BMH4XfArbpUgUyZrC+I5v
         Pb1ZsZhWR4F9+NjKYMIe0U8TPqDuPmJNNs2sSVN0xtQMn1V521wU1SGjruKTb1O7J3Jb
         TOzU4G8kVCuXFNuwPQtz+IuT/zE+8otrP2EdT7OmJ0E4rHxx0/ZnVbtbQu8PqfpmkakN
         IQ4mr7FNH3N9T8M6MEXhxmtqrYTOPmHAEB9sfdsiMM7oqlCbFMXwZVxc2gZE7WYbZXhc
         mHIw==
X-Gm-Message-State: AOAM533UKRk6NEO6YnljNNIOameL1+ulIx957rfmVj8cVqsG1kqbeWT1
        Mk6M3d9JCWJZ7g3Q5c7oQ09yDw==
X-Google-Smtp-Source: ABdhPJz7oFpZbQZfaf483nQExWtM/t+Sup4K1MuBvZ50GKh5QtrLKpOBuH8l6EqnPBn2gUG/sg4/4w==
X-Received: by 2002:a05:620a:2408:: with SMTP id d8mr30627482qkn.148.1629894923882;
        Wed, 25 Aug 2021 05:35:23 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id f7sm12833793qko.52.2021.08.25.05.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 05:35:23 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mIs7m-004snX-UJ; Wed, 25 Aug 2021 09:35:22 -0300
Date:   Wed, 25 Aug 2021 09:35:22 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 11/14] vfio: clean up the check for mediated device in
 vfio_iommu_type1
Message-ID: <20210825123522.GX543798@ziepe.ca>
References: <20210824144649.1488190-1-hch@lst.de>
 <20210824144649.1488190-12-hch@lst.de>
 <20210825002850.GR543798@ziepe.ca>
 <20210825053427.GC26806@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825053427.GC26806@lst.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 25, 2021 at 07:34:27AM +0200, Christoph Hellwig wrote:
> On Tue, Aug 24, 2021 at 09:28:50PM -0300, Jason Gunthorpe wrote:
> > On Tue, Aug 24, 2021 at 04:46:46PM +0200, Christoph Hellwig wrote:
> > > Pass the group flags to ->attach_group and remove the messy check for
> > > the bus type.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > >  drivers/vfio/vfio.c                 | 11 +++++------
> > >  drivers/vfio/vfio.h                 |  7 ++++++-
> > >  drivers/vfio/vfio_iommu_spapr_tce.c |  2 +-
> > >  drivers/vfio/vfio_iommu_type1.c     | 19 ++-----------------
> > >  4 files changed, 14 insertions(+), 25 deletions(-)
> > 
> > Every caller is doing group->iommu_group, maybe change the signature
> > to
> > 
> >  (*attach_group)(struct vfio_iommu *iommu, struct vfio_iommu_group *group)
> >  
> > ?
> 
> s/vfio_iommu/vfio_container/, but yes.  I actually have a series that
> does this (also for a few other methods), but this requires exposing
> vfio_container and vfio_iommu_group outside of vfio.c.  Given that this
> series is big enough I decided to skip it for now, but that plus a few
> other changes will eventually simplify the group lookups in
> vfio_iommu_type1.c.

Fair enough

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
