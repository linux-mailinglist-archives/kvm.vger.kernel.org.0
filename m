Return-Path: <kvm+bounces-61767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B4C7C290F2
	for <lists+kvm@lfdr.de>; Sun, 02 Nov 2025 16:13:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id E593E4E642B
	for <lists+kvm@lfdr.de>; Sun,  2 Nov 2025 15:13:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FCC523B609;
	Sun,  2 Nov 2025 15:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CT9wGfoA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECC9EEBB;
	Sun,  2 Nov 2025 15:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762096381; cv=none; b=iHhpzD380uQ1/d97XO0JBfphjM0HqCfgIp8kw8HkMpuePldKmBAgrl++XxolfFNGG5ntj+iBovfa+I9Sqo7K0P7g85XXXy4wcwmnjfetJAefgAO7/xi+Q3MIFiXhkQ07clDNvaZdD9Qi7HasG6piA6b0QgqgRBR7MHPFucAo724=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762096381; c=relaxed/simple;
	bh=tizBF6oQAn/Y3qWcygtT9HOK6tA8tcWjX6+eHwzztHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sKqrUK6jBFB0C3GKdX+bBfl9zxvRMQGYqJTKiXP5mlEoZz+ocrmLu4LxOwRq7tOY9PReF6UnYRVmPMB9P4bgwNsNNYtuWWui0jh4mu2q3d1wzmJScDq6iP5Qf9teQ2YerSs5c6CJxdBc11IHeiIWkHeAAiEACBWIBS14sagvfzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CT9wGfoA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAABBC4CEF7;
	Sun,  2 Nov 2025 15:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762096380;
	bh=tizBF6oQAn/Y3qWcygtT9HOK6tA8tcWjX6+eHwzztHc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CT9wGfoAiCv2vOtEIQkZsX5as/tdAoLN3LndZfBArHXUFA/Zw6aiiZ8s7L1ItFwnS
	 J44TfxOhI/HBSPQzjPfDdOnuTocQGDHYR0rQS/QWk/RFyc2i6YnIcrq0bR37G55zSN
	 cRUJYZHLWZuU9uME66gb8xkP50ARR5vellQ8rh2cps+8y1z5a6FXx1Bm7+UKl4xykw
	 BKzX1CHLdgL5P2L7bHPJvSRCjuzG6pnNETHYekFTtAy6gY2hQ8xQ2LYlmtydkaNOmU
	 IDJqI0JxojL60OTRm80nOQSmOqRXrUZh51uEpe4MhDqcBvu3YYEuSQHoFo9Sv5xLDN
	 7aBCzDPV1VG1g==
Date: Sun, 2 Nov 2025 17:12:53 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex@shazbot.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, iommu@lists.linux.dev,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: Re: [PATCH v6 10/11] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <20251102151253.GA50752@unreal>
References: <20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.com>
 <20251102-dmabuf-vfio-v6-10-d773cff0db9f@nvidia.com>
 <20251102080137.209aa567@shazbot.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251102080137.209aa567@shazbot.org>

On Sun, Nov 02, 2025 at 08:01:37AM -0700, Alex Williamson wrote:
> On Sun,  2 Nov 2025 10:00:58 +0200
> Leon Romanovsky <leon@kernel.org> wrote:
> > @@ -2391,6 +2403,7 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
> >  				      struct iommufd_ctx *iommufd_ctx)
> >  {
> >  	struct vfio_pci_core_device *vdev;
> > +	bool restore_revoke = false;
> >  	struct pci_dev *pdev;
> >  	int ret;
> >  
> > @@ -2459,6 +2472,8 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
> >  			break;
> >  		}
> >  
> > +		vfio_pci_dma_buf_move(vdev, true);
> > +		restore_revoke = true;
> >  		vfio_pci_zap_bars(vdev);
> >  	}
> >  
> > @@ -2486,6 +2501,12 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
> >  			       struct vfio_pci_core_device, vdev.dev_set_list);
> >  
> >  err_undo:
> > +	if (restore_revoke) {
> > +		list_for_each_entry(vdev, &dev_set->device_list, vdev.dev_set_list)
> > +			if (__vfio_pci_memory_enabled(vdev))
> > +				vfio_pci_dma_buf_move(vdev, false);
> > +	}
> > +
> >  	list_for_each_entry_from_reverse(vdev, &dev_set->device_list,
> >  					 vdev.dev_set_list)
> 
> We don't need the separate loop or flag, and adding it breaks the
> existing reverse list walk.  Thanks,

Do you want me to send v7? I have a feeling that v6 is good to be merged.

Thanks

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 24204893e221..51a3bcc26f8b 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -2403,7 +2403,6 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
                                      struct iommufd_ctx *iommufd_ctx)
 {
        struct vfio_pci_core_device *vdev;
-       bool restore_revoke = false;
        struct pci_dev *pdev;
        int ret;
 
@@ -2473,7 +2472,6 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
                }
 
                vfio_pci_dma_buf_move(vdev, true);
-               restore_revoke = true;
                vfio_pci_zap_bars(vdev);
        }
 
@@ -2501,15 +2499,12 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
                               struct vfio_pci_core_device, vdev.dev_set_list);
 
 err_undo:
-       if (restore_revoke) {
-               list_for_each_entry(vdev, &dev_set->device_list, vdev.dev_set_list)
-                       if (__vfio_pci_memory_enabled(vdev))
-                               vfio_pci_dma_buf_move(vdev, false);
-       }
-
        list_for_each_entry_from_reverse(vdev, &dev_set->device_list,
-                                        vdev.dev_set_list)
+                                        vdev.dev_set_list) {
+               if (__vfio_pci_memory_enabled(vdev))
+                       vfio_pci_dma_buf_move(vdev, false);
                up_write(&vdev->memory_lock);
+       }
 
        list_for_each_entry(vdev, &dev_set->device_list, vdev.dev_set_list)
                pm_runtime_put(&vdev->pdev->dev);


> 
> Alex
> 

