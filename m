Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF213F6ED7
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 07:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbhHYFfU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 01:35:20 -0400
Received: from verein.lst.de ([213.95.11.211]:54764 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhHYFfQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 01:35:16 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4D69468AFE; Wed, 25 Aug 2021 07:34:28 +0200 (CEST)
Date:   Wed, 25 Aug 2021 07:34:27 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 11/14] vfio: clean up the check for mediated device in
 vfio_iommu_type1
Message-ID: <20210825053427.GC26806@lst.de>
References: <20210824144649.1488190-1-hch@lst.de> <20210824144649.1488190-12-hch@lst.de> <20210825002850.GR543798@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825002850.GR543798@ziepe.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 24, 2021 at 09:28:50PM -0300, Jason Gunthorpe wrote:
> On Tue, Aug 24, 2021 at 04:46:46PM +0200, Christoph Hellwig wrote:
> > Pass the group flags to ->attach_group and remove the messy check for
> > the bus type.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  drivers/vfio/vfio.c                 | 11 +++++------
> >  drivers/vfio/vfio.h                 |  7 ++++++-
> >  drivers/vfio/vfio_iommu_spapr_tce.c |  2 +-
> >  drivers/vfio/vfio_iommu_type1.c     | 19 ++-----------------
> >  4 files changed, 14 insertions(+), 25 deletions(-)
> 
> Every caller is doing group->iommu_group, maybe change the signature
> to
> 
>  (*attach_group)(struct vfio_iommu *iommu, struct vfio_iommu_group *group)
>  
> ?

s/vfio_iommu/vfio_container/, but yes.  I actually have a series that
does this (also for a few other methods), but this requires exposing
vfio_container and vfio_iommu_group outside of vfio.c.  Given that this
series is big enough I decided to skip it for now, but that plus a few
other changes will eventually simplify the group lookups in
vfio_iommu_type1.c.
