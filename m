Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF193E5629
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 11:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238533AbhHJJCg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 05:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233487AbhHJJCg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 05:02:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2EEC0613D3;
        Tue, 10 Aug 2021 02:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LWjSXu3ag5kZHehwObZvJyOfxlECQy71l/VsOzHy64g=; b=lOdtPS3Id1gpdVmol+wdQrsfGl
        SAoE3F7nLroPIqyU6puNVVRcRPlGlVqdktfpysA+cvpw6zCX1PfpaRKEyBWeNKYk3kMkANpYVEj61
        McYSW5DrtE3/0XRQ89rF8ztTVBTdzXOcmdGG0sBPpHxrd4QzZGwyIKUZxgXz/acY++d2EdtnI2PYl
        +szib6uDRbZrGseaPx9JIuF030P2yPuWYxaz+rvxMmRyA750KvXSp0+PxZXPk3CIsxM4MYDZyEI3w
        GIE1C9E+VF0zYCComF0DruSrZevTAnAybSR2uJsG3rfr/g5XFebc0AZ5N+tvw/I2tLkSfvX2Y/mF0
        N0iL6mXQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mDNcL-00BvAw-0p; Tue, 10 Aug 2021 09:00:27 +0000
Date:   Tue, 10 Aug 2021 10:00:13 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        peterx@redhat.com
Subject: Re: [PATCH 4/7] vfio,vfio-pci: Add vma to pfn callback
Message-ID: <YRJAHYh5j6Ni6JCl@infradead.org>
References: <162818167535.1511194.6614962507750594786.stgit@omen>
 <162818326742.1511194.1366505678218237973.stgit@omen>
 <20210806010146.GE1672295@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806010146.GE1672295@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 05, 2021 at 10:01:46PM -0300, Jason Gunthorpe wrote:
> On Thu, Aug 05, 2021 at 11:07:47AM -0600, Alex Williamson wrote:
> > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > index 1e4fc69fee7d..42ca93be152a 100644
> > +++ b/drivers/vfio/vfio.c
> > @@ -875,6 +875,22 @@ struct vfio_device *vfio_device_get_from_dev(struct device *dev)
> >  }
> >  EXPORT_SYMBOL_GPL(vfio_device_get_from_dev);
> >  
> > +static const struct file_operations vfio_device_fops;
> > +
> > +int vfio_device_vma_to_pfn(struct vfio_device *device,
> > +			   struct vm_area_struct *vma, unsigned long *pfn)
> 
> A comment here describing the locking conditions the caller must meet
> would be a good addition.. It looks like this can only work under the
> i_mmap_lock and the returned pfn can only be taken outside that lock
> if it is placed in a VMA
> 
> Maybe this is not a great API then? Should it be 'populate vma' and
> call io_remap_pfn_range under the op?

Yes, I think that would be a better API.
