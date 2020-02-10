Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2336B1583E1
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 20:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727613AbgBJTpG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 14:45:06 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:35697 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727003AbgBJTpF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Feb 2020 14:45:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581363904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CB7ogxanCwTl3KhojwycpYzXdMiK9Zrb4b+oeBFh5K4=;
        b=MHc6QfLEH5oHgQILt5BcTPWe2EP0dzCrB2z8v1Q3ChifN7N6sCCrUWpV3IGZ8TIkLs13mr
        6eHhVpdhCjzW/P0YSCbETqPgKukkGKXp21QvOB/zXoMvrPXVb8fhhVKLJdL1HTlOH4GaAW
        AE2kT2aYdxTkSROVOa5e4f/7fkAtRYw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-34-4L9-IKF6O4SPIY1jAdRc0Q-1; Mon, 10 Feb 2020 14:44:59 -0500
X-MC-Unique: 4L9-IKF6O4SPIY1jAdRc0Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B8FEA107ACC5;
        Mon, 10 Feb 2020 19:44:56 +0000 (UTC)
Received: from w520.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA0F019C70;
        Mon, 10 Feb 2020 19:44:54 +0000 (UTC)
Date:   Mon, 10 Feb 2020 12:44:54 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Zhengxiao.zx@Alibaba-inc.com" <Zhengxiao.zx@Alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v12 Kernel 4/7] vfio iommu: Implementation of ioctl to
 for dirty pages tracking.
Message-ID: <20200210124454.12e0419a@w520.home>
In-Reply-To: <20200210094954.GA4530@joy-OptiPlex-7040>
References: <1581104554-10704-1-git-send-email-kwankhede@nvidia.com>
        <1581104554-10704-5-git-send-email-kwankhede@nvidia.com>
        <20200210094954.GA4530@joy-OptiPlex-7040>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 10 Feb 2020 04:49:54 -0500
Yan Zhao <yan.y.zhao@intel.com> wrote:

> On Sat, Feb 08, 2020 at 03:42:31AM +0800, Kirti Wankhede wrote:
> > VFIO_IOMMU_DIRTY_PAGES ioctl performs three operations:
> > - Start pinned and unpinned pages tracking while migration is active
> > - Stop pinned and unpinned dirty pages tracking. This is also used to
> >   stop dirty pages tracking if migration failed or cancelled.
> > - Get dirty pages bitmap. This ioctl returns bitmap of dirty pages, its
> >   user space application responsibility to copy content of dirty pages
> >   from source to destination during migration.
> > 
> > To prevent DoS attack, memory for bitmap is allocated per vfio_dma
> > structure. Bitmap size is calculated considering smallest supported page
> > size. Bitmap is allocated when dirty logging is enabled for those
> > vfio_dmas whose vpfn list is not empty or whole range is mapped, in
> > case of pass-through device.
> > 
> > There could be multiple option as to when bitmap should be populated:
> > * Polulate bitmap for already pinned pages when bitmap is allocated for
> >   a vfio_dma with the smallest supported page size. Updates bitmap from
> >   page pinning and unpinning functions. When user application queries
> >   bitmap, check if requested page size is same as page size used to
> >   populated bitmap. If it is equal, copy bitmap. But if not equal,
> >   re-populated bitmap according to requested page size and then copy to
> >   user.
> >   Pros: Bitmap gets populated on the fly after dirty tracking has
> >         started.
> >   Cons: If requested page size is different than smallest supported
> >         page size, then bitmap has to be re-populated again, with
> >         additional overhead of allocating bitmap memory again for
> >         re-population of bitmap.
> > 
> > * Populate bitmap when bitmap is queried by user application.
> >   Pros: Bitmap is populated with requested page size. This eliminates
> >         the need to re-populate bitmap if requested page size is
> >         different than smallest supported pages size.
> >   Cons: There is one time processing time, when bitmap is queried.
> > 
> > I prefer later option with simple logic and to eliminate over-head of
> > bitmap repopulation in case of differnt page sizes. Later option is
> > implemented in this patch.
> > 
> > Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> > Reviewed-by: Neo Jia <cjia@nvidia.com>
> > ---
> >  drivers/vfio/vfio_iommu_type1.c | 299 ++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 287 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index d386461e5d11..df358dc1c85b 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
[snip]
> > @@ -830,6 +924,113 @@ static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
> >  	return bitmap;
> >  }
> >  
> > +static int vfio_iova_dirty_bitmap(struct vfio_iommu *iommu, dma_addr_t iova,
> > +				  size_t size, uint64_t pgsize,
> > +				  unsigned char __user *bitmap)
> > +{
> > +	struct vfio_dma *dma;
> > +	dma_addr_t i = iova, iova_limit;
> > +	unsigned int bsize, nbits = 0, l = 0;
> > +	unsigned long pgshift = __ffs(pgsize);
> > +
> > +	while ((dma = vfio_find_dma(iommu, i, pgsize))) {
> > +		int ret, j;
> > +		unsigned int npages = 0, shift = 0;
> > +		unsigned char temp = 0;
> > +
> > +		/* mark all pages dirty if all pages are pinned and mapped. */
> > +		if (dma->iommu_mapped) {
> > +			iova_limit = min(dma->iova + dma->size, iova + size);
> > +			npages = iova_limit/pgsize;
> > +			bitmap_set(dma->bitmap, 0, npages);  
> for pass-through devices, it's not good to always return all pinned pages as
> dirty. could it also call vfio_pin_pages to track dirty pages? or any
> other interface provided to do that?

See patch 7/7.  Thanks,

Alex

