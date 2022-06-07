Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D394953F59E
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 07:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236375AbiFGFon (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 01:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233252AbiFGFom (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 01:44:42 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5092BA57B;
        Mon,  6 Jun 2022 22:44:41 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id B899068BEB; Tue,  7 Jun 2022 07:44:37 +0200 (CEST)
Date:   Tue, 7 Jun 2022 07:44:37 +0200
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
Subject: Re: [PATCH 2/2] vfio: Replace the iommu notifier with a device list
Message-ID: <20220607054437.GB8508@lst.de>
References: <0-v1-896844109f36+a-vfio_unmap_notif_jgg@nvidia.com> <2-v1-896844109f36+a-vfio_unmap_notif_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2-v1-896844109f36+a-vfio_unmap_notif_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 06, 2022 at 09:34:36PM -0300, Jason Gunthorpe wrote:
> +			if (!list_empty(&iommu->device_list)) {
> +				mutex_lock(&iommu->device_list_lock);
> +				mutex_unlock(&iommu->lock);
> +
> +				list_for_each_entry(device,
> +						    &iommu->device_list,
> +						    iommu_entry)
> +					device->ops->dma_unmap(
> +						device, dma->iova, dma->size);
> +
> +				mutex_unlock(&iommu->device_list_lock);
> +				mutex_lock(&iommu->lock);
> +			}

I wonder if factoring this into a little helper instead of the
very deep indentation might be a bit better for readability.

> +static void vfio_iommu_type1_register_device(void *iommu_data,
> +					     struct vfio_device *vdev)
>  {
>  	struct vfio_iommu *iommu = iommu_data;
>  
> +	if (!vdev->ops->dma_unmap)
> +		return;
>  
> +	mutex_lock(&iommu->lock);
> +	mutex_lock(&iommu->device_list_lock);
> +	list_add(&vdev->iommu_entry, &iommu->device_list);
> +	mutex_unlock(&iommu->device_list_lock);
> +	mutex_unlock(&iommu->lock);

Why do we need both iommu->lock and the device_list_lock everywhere?
Maybe explain the locking scheme somewhere so that people don't have
to guess, because it seems to me that just using iommu->lock would
be enough right now.
