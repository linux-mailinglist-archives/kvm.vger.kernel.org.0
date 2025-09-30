Return-Path: <kvm+bounces-59094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 99B4EBABD47
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 09:31:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F6B31C4C8A
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 07:31:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F279E2BE7AF;
	Tue, 30 Sep 2025 07:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F87Yad04"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018BDBA3D;
	Tue, 30 Sep 2025 07:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759217459; cv=none; b=YzmVcfk5H6gflqZSsQ8VRyMK7ZkWCy76UzvWinNT3TPtz1bXM0mFe/XsmQ9waHqHJczaN3G//O5IQ1rERe8AVz3f/1P+MWMI/H6DnEA42DevUymal1SvucB3Vf1PyYNHSR9Tcms07m0wdxx9I60gJvBU0McP81aN3mWPEH56D9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759217459; c=relaxed/simple;
	bh=JQzf0lGVVh7uBp1GGrgRG3aOLt81vd3Z1vJ+MdzJaUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=liNKTLWhH+ox50z3sjtdGyXBna/TH27JIFAgnxdKw9PE1vjJSM5hvUshtkDLgVyO87J3mA7ofW6OH+hxgShUePjTJ8tP24cVxOtoJQYUjmHxQ9KCderE8mFCabyr9cULVsPuMnVo+nNKCu6jJ3E4xKJXUoThfdHMb1RG4cfS1Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F87Yad04; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71C8C113D0;
	Tue, 30 Sep 2025 07:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759217458;
	bh=JQzf0lGVVh7uBp1GGrgRG3aOLt81vd3Z1vJ+MdzJaUg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F87Yad04oYGKqR0yrv700Kdv7cMA7yYANQZWxSzZfBGzhhGL/AY0n38vF/CbS1+uS
	 xoHf7BEDW8mOIaQN7Wk/lwIKl4Yr4ZCcSIRmUMKAIta02I34naQImlmh2K8ES0+J0J
	 37JGfcZ5Fcjrg+XvYNzoB1zs1jcuvaeDiG8rOpUd6KE1U67TY/2JY6hYEFcEF+3s0j
	 KRocY0sJEKrIBIPmUsJmcRcbzwrkU9tKLg/YjlOL+FaI0JgPnlof0Me1fLbHLHzT1r
	 DpZwl2Lrtc0E2Q7+85ZBPdg92JKatMeAQHBu3PCoTknvQScfYkwgCaBKVjyqnL/Fk+
	 VbrIksbpXUNYQ==
Date: Tue, 30 Sep 2025 10:30:53 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v4 08/10] vfio/pci: Enable peer-to-peer DMA transactions
 by default
Message-ID: <20250930073053.GE324804@unreal>
References: <cover.1759070796.git.leon@kernel.org>
 <ac8c6ccd792e79f9424217d4bca23edd249916ca.1759070796.git.leon@kernel.org>
 <20250929151745.439be1ec.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250929151745.439be1ec.alex.williamson@redhat.com>

On Mon, Sep 29, 2025 at 03:17:45PM -0600, Alex Williamson wrote:
> On Sun, 28 Sep 2025 17:50:18 +0300
> Leon Romanovsky <leon@kernel.org> wrote:
> 
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Make sure that all VFIO PCI devices have peer-to-peer capabilities
> > enables, so we would be able to export their MMIO memory through DMABUF,
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_core.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> > index 7dcf5439dedc..608af135308e 100644
> > --- a/drivers/vfio/pci/vfio_pci_core.c
> > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > @@ -28,6 +28,9 @@
> >  #include <linux/nospec.h>
> >  #include <linux/sched/mm.h>
> >  #include <linux/iommufd.h>
> > +#ifdef CONFIG_VFIO_PCI_DMABUF
> > +#include <linux/pci-p2pdma.h>
> > +#endif
> >  #if IS_ENABLED(CONFIG_EEH)
> >  #include <asm/eeh.h>
> >  #endif
> > @@ -2085,6 +2088,7 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
> >  {
> >  	struct vfio_pci_core_device *vdev =
> >  		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> > +	int __maybe_unused ret;
> >  
> >  	vdev->pdev = to_pci_dev(core_vdev->dev);
> >  	vdev->irq_type = VFIO_PCI_NUM_IRQS;
> > @@ -2094,6 +2098,11 @@ int vfio_pci_core_init_dev(struct vfio_device *core_vdev)
> >  	INIT_LIST_HEAD(&vdev->dummy_resources_list);
> >  	INIT_LIST_HEAD(&vdev->ioeventfds_list);
> >  	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
> > +#ifdef CONFIG_VFIO_PCI_DMABUF
> > +	ret = pcim_p2pdma_init(vdev->pdev);
> > +	if (ret)
> > +		return ret;
> > +#endif
> >  	init_rwsem(&vdev->memory_lock);
> >  	xa_init(&vdev->ctx);
> >  
> 
> What breaks if we don't test the return value and remove all the
> #ifdefs?  The feature call should fail if we don't have a provider but
> that seems more robust than failing to register the device.  Thanks,

pcim_p2pdma_init() fails if memory allocation fails, which is worth to check.
Such failure will most likely cause to non-working vfio-pci module anyway,
as failure in pcim_p2pdma_init() will trigger OOM. It is better to fail early
and help for the system to recover from OOM, instead of delaying to the
next failure while trying to load vfio-pci.

CONFIG_VFIO_PCI_DMABUF is mostly for next line "INIT_LIST_HEAD(&vdev->dmabufs);"
from the following patch. Because that pcim_p2pdma_init() and dmabufs list are
coupled, I put CONFIG_VFIO_PCI_DMABUF on both of them.

Thanks

> 
> Alex
> 
> 

