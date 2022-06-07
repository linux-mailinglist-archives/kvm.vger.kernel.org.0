Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B508C53F596
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 07:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiFGFkD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 01:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbiFGFkB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 01:40:01 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B5FC6FA0F;
        Mon,  6 Jun 2022 22:40:00 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4704568AFE; Tue,  7 Jun 2022 07:39:56 +0200 (CEST)
Date:   Tue, 7 Jun 2022 07:39:55 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org,
        Eric Farman <farman@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] vfio: Replace the DMA unmapping notifier with a
 callback
Message-ID: <20220607053955.GA8508@lst.de>
References: <0-v1-896844109f36+a-vfio_unmap_notif_jgg@nvidia.com> <1-v1-896844109f36+a-vfio_unmap_notif_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1-v1-896844109f36+a-vfio_unmap_notif_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 06, 2022 at 09:34:35PM -0300, Jason Gunthorpe wrote:
> +static void intel_vgpu_dma_unmap(struct vfio_device *vfio_dev, u64 iova,
> +				 u64 length)
>  {
> +	struct intel_vgpu *vgpu = vfio_dev_to_vgpu(vfio_dev);
> +	struct gvt_dma *entry;
> +	u64 iov_pfn, end_iov_pfn;
>  
> +	iov_pfn = iova >> PAGE_SHIFT;
> +	end_iov_pfn = iov_pfn + length / PAGE_SIZE;

I'd just initialize these at declaration time.  The mix between
shifting and division here is also kind weird, but we probably
shouldn't change too much from the original version.

> +	/* Vendor drivers MUST unpin pages in response to an invalidation. */

s/Vendor//g

>  /**
> + * vfio_ap_mdev_dma_unmap - Notifier that IOVA has been unmapped
> + * @vdev: The VFIO device
> + * @unmap: IOVA range unmapped
>   *
> + * Unpin the guest IOVA (the NIB guest address we pinned before).
>   */

kerneldoc comments for method instances are a bit silly..

> +static int vfio_iommu_notifier(struct notifier_block *nb, unsigned long action,
> +			       void *data)
> +{
> +	struct vfio_device *vfio_device =
> +		container_of(nb, struct vfio_device, iommu_nb);
> +	struct vfio_iommu_type1_dma_unmap *unmap = data;

Using the iommu type 1 UAPI structure in the core vfio code for a
subset of its field is kinda weird.  But we can fix this later.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
