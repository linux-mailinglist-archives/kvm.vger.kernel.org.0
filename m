Return-Path: <kvm+bounces-64076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 75802C77BAA
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 08:43:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id CE42929CC9
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 07:43:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EDC933B6D8;
	Fri, 21 Nov 2025 07:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OCp8Vjg5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304E8339B4D;
	Fri, 21 Nov 2025 07:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763710929; cv=none; b=u3jLKwWlKIUDqsiiQr672vfIiteEprNxmFtPeJXcQMHquCUyTpC7SHT5Sj2tX7UIgwP9ufdlWZvRjsofByKthMrdICh/t/txqQ/kZQz/DjqizFU60j1NeWRKoBsmzpIzinANSX3vTKlrxRrturLRrxRIIlBFs2rel6CODhnl0us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763710929; c=relaxed/simple;
	bh=O/owrQ7LTAA9ZbRZu64BC64XoYmRo+uhZTzeo+Ew2jc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VqfAKVNQn6zUXKv+zTzr13JkffqvcsCDPWxFbaAtUgdesYHo+4ZvhD0vS+JfUmuofXGA42X3IU43gJVv7vhV5lwKvGac2txH/SvRZIGk8pi+usr4d+IdRilpUTVjBrzHf2iG3Ve7hm7JM038HxwUBwfxawpk7tCOyUQQ8Ep2BHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OCp8Vjg5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F4DC4CEF1;
	Fri, 21 Nov 2025 07:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763710928;
	bh=O/owrQ7LTAA9ZbRZu64BC64XoYmRo+uhZTzeo+Ew2jc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OCp8Vjg5oImfKWfN4GXv7kmUMrNS5krBORtVRTmwcB4DOZvoX+/g/t4vr9ZWu6UJl
	 1Vj7sFNlUll1T9YUQc4xpzO6PKziNve8YmQzv8+oTDniJ8ihFor/4t6HDeETH7XPnh
	 0qzUx+skWQwrxymzZd4yqSdRZyo5Qm9O91YykG/j5f61W+s9sbvi1j4nNmvR6DSrSr
	 IkeXOC0kXEpJjmiSHsc4BSNizwXT4L6AL6eRN87ViuHkHSr6r++BESWVogPdAjx1dI
	 qCWxiIBByOU5w/PZ6VKwrk97r6+SckIe4Pi/3ecdSozDC1fXrYtDiogYDbOS5uXIBj
	 XbOkJYPROPYqA==
Date: Fri, 21 Nov 2025 09:42:03 +0200
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
Subject: Re: [PATCH v9 10/11] vfio/pci: Add dma-buf export support for MMIO
 regions
Message-ID: <20251121074203.GX18335@unreal>
References: <20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.com>
 <20251120-dmabuf-vfio-v9-10-d7f71607f371@nvidia.com>
 <20251120170413.050ccbb5.alex@shazbot.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120170413.050ccbb5.alex@shazbot.org>

On Thu, Nov 20, 2025 at 05:04:13PM -0700, Alex Williamson wrote:
> On Thu, 20 Nov 2025 11:28:29 +0200
> Leon Romanovsky <leon@kernel.org> wrote:
> > diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> > index 142b84b3f225..51a3bcc26f8b 100644
> > --- a/drivers/vfio/pci/vfio_pci_core.c
> > +++ b/drivers/vfio/pci/vfio_pci_core.c
> ...
> > @@ -2487,8 +2500,11 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
> >  
> >  err_undo:
> >  	list_for_each_entry_from_reverse(vdev, &dev_set->device_list,
> > -					 vdev.dev_set_list)
> > +					 vdev.dev_set_list) {
> > +		if (__vfio_pci_memory_enabled(vdev))
> > +			vfio_pci_dma_buf_move(vdev, false);
> >  		up_write(&vdev->memory_lock);
> > +	}
> 
> I ran into a bug here.  In the hot reset path we can have dev_sets
> where one or more devices are not opened by the user.  The vconfig
> buffer for the device is established on open.  However:
> 
> bool __vfio_pci_memory_enabled(struct vfio_pci_core_device *vdev)
> {
>         struct pci_dev *pdev = vdev->pdev;
>         u16 cmd = le16_to_cpu(*(__le16 *)&vdev->vconfig[PCI_COMMAND]);
> 	...
> 
> Leads to a NULL pointer dereference.
> 
> I think the most straightforward fix is simply to test the open_count
> on the vfio_device, which is also protected by the dev_set->lock that
> we already hold here:
> 
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -2501,7 +2501,7 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>  err_undo:
>         list_for_each_entry_from_reverse(vdev, &dev_set->device_list,
>                                          vdev.dev_set_list) {
> -               if (__vfio_pci_memory_enabled(vdev))
> +               if (vdev->vdev.open_count && __vfio_pci_memory_enabled(vdev))
>                         vfio_pci_dma_buf_move(vdev, false);
>                 up_write(&vdev->memory_lock);
>         }
> 
> Any other suggestions?  This should be the only reset path with this
> nuance of affecting non-opened devices.  Thanks,

It seems right to me.

Thanks

> 
> Alex

