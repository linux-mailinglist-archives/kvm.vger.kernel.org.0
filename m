Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B4E33ADD7
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 09:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbhCOIqC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 04:46:02 -0400
Received: from verein.lst.de ([213.95.11.211]:52910 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229639AbhCOIpg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 04:45:36 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id B02B468C4E; Mon, 15 Mar 2021 09:45:34 +0100 (CET)
Date:   Mon, 15 Mar 2021 09:45:34 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 07/14] vfio/pci: Move VGA and VF initialization to
 functions
Message-ID: <20210315084534.GC29269@lst.de>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com> <7-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +static int vfio_pci_vf_init(struct vfio_pci_device *vdev)
> +{
> +	struct pci_dev *pdev = vdev->pdev;
> +	int ret;
> +
> +	if (!pdev->is_physfn)
> +		return 0;
> +
> +	vdev->vf_token = kzalloc(sizeof(*vdev->vf_token), GFP_KERNEL);
> +	if (!vdev->vf_token)
> +		return -ENOMEM;

> +static void vfio_pci_vf_uninit(struct vfio_pci_device *vdev)
> +{
> +	if (!vdev->vf_token)
> +		return;

I'd really prefer to keep these checks in the callers, as it makes the
intent of the code much more clear.  Same for the VGA side.

But in general I like these helpers.
