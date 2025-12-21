Return-Path: <kvm+bounces-66460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 19B46CD3D5C
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 10:12:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CCCAE30094B3
	for <lists+kvm@lfdr.de>; Sun, 21 Dec 2025 09:12:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59AB721CC4F;
	Sun, 21 Dec 2025 09:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u194GqCt"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB082773CB;
	Sun, 21 Dec 2025 09:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766308321; cv=none; b=dFhnukRHHvu+Ai+/IuxD/coixjvHN1rZ09RYTpYtbF5iun52u1O3B89Oqt2IgDPjaNVFLygBtiU2vq/mdgVucV4UfGkoNSGc2dUkbQ9wZMFSAfARK/y0J4LqKhRB+cbNJ7NGDLfR05Bk+dsPTxKYrW/uREunXFsiMawB7PzrawQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766308321; c=relaxed/simple;
	bh=w4Q/AwdSQbx5fH+/eAOuT3Pq5WmWbR1QvwU43aGlk5s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HGsvg6UjaXyJlkt/+fu46dT23E7f9UmjjDWjnkvByarlWYv2EdM3zkgHks1Vyg0mNTQ8F7zsTG+epeee2fUoeQCRZ/El4/wPpepu3v3QpdOpCH2egzNgBHdJZAm4s7YvTihlsUev1t1PyVnyA7f9XDA8mIk7Zf4r9Og2VfzmIr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u194GqCt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6CDC19423;
	Sun, 21 Dec 2025 09:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766308319;
	bh=w4Q/AwdSQbx5fH+/eAOuT3Pq5WmWbR1QvwU43aGlk5s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u194GqCtos9i7JOLGAYf7G7qSPcCC4ktN8TmqznloUV1PiSGewkOdeEjTfoKKG6IU
	 6lAk4G9zQWq1BxdMZn9ZnPWXN+LKHjtbgN9A6oE6IQFC1FcRHZ6b5kQWGN7ZEvwIbO
	 Xp4Y/wQP45BmRRnKng42u5X65heg99ZM6tLizMTiis8CsvjVVafbNTEOVxAiSQWcJ0
	 6tthXzPHKOUqAGjeE/MG0NnEO4NFji2TJdTWMJOH6jBNZvysIsKxiPji3PEmISLemv
	 rbW+K+Fi6gB8r8mbEAdqVymzpEkM+2hzUwNo+riVtAeJ22nEGDUmdTVXF3CZsKivhc
	 oWOXBCWogwryA==
Date: Sun, 21 Dec 2025 11:11:54 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Xiong Weimin <15927021679@163.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Thomas Monjalon <thomas@monjalon.net>,
	David Marchand <david.marchand@redhat.com>,
	Luca Boccassi <bluca@debian.org>,
	Kevin Traynor <ktraynor@redhat.com>,
	Christian Ehrhardt <christian.ehrhardt@canonical.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xueming Li <xuemingl@nvidia.com>,
	Maxime Coquelin <maxime.coquelin@redhat.com>,
	Chenbo Xia <chenbox@nvidia.com>,
	Bruce Richardson <bruce.richardson@intel.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	xiongweimin <xiongweimin@kylinos.cn>
Subject: Re: [PATCH 01/10] drivers/infiniband/hw/virtio: Initial driver for
 virtio RDMA devices
Message-ID: <20251221091154.GE13030@unreal>
References: <20251218091050.55047-1-15927021679@163.com>
 <20251218091050.55047-2-15927021679@163.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218091050.55047-2-15927021679@163.com>

On Thu, Dec 18, 2025 at 05:09:41PM +0800, Xiong Weimin wrote:
> From: xiongweimin <xiongweimin@kylinos.cn>
> 
> This commit introduces a new driver for RDMA over virtio, enabling
> RDMA capabilities in virtualized environments. The driver consists
> of the following main components:
> 
> 1. Driver registration with the virtio subsystem and device discovery.
> 2. Device probe and remove handlers for managing the device lifecycle.
> 3. Initialization of the InfiniBand device attributes by reading the
>    virtio configuration space, including conversion from little-endian
>    to CPU byte order and capability mapping.
> 4. Setup of virtqueues for:
>    - Control commands (no callback)
>    - Completion queues (with callback for CQ events)
>    - Send and receive queues for queue pairs (no callbacks)
> 5. Integration with the network device layer for RoCE support.
> 6. Registration with the InfiniBand core subsystem.
> 7. Comprehensive error handling during initialization and a symmetric
>    teardown process.
> 
> Key features:
> - Support for multiple virtqueues based on device capabilities (max_cq, max_qp)
> - Fast doorbell optimization when notify_offset_multiplier equals PAGE_SIZE
> - Safe resource management with rollback on failure
> 
> Signed-off-by: Xiong Weimin <xiongweimin@kylinos.cn>

<...>

> +/**
> + * vrdma_init_netdev - Attempt to find paired virtio-net device on same PCI slot
> + * @vrdev: The vRDMA device
> + *
> + * WARNING: This is a non-standard hack for development/emulation environments.
> + *          Do not use in production or upstream drivers.

I'm impressed how much AI advanced in code generation. Please recheck
everything that was generated.

> + *
> + * Returns 0 on success, or negative errno.
> + */
> +int vrdma_init_netdev(struct vrdma_dev *vrdev)
> +{
> +    struct pci_dev *pdev_net;
> +    struct virtio_pci_device *vp_dev;
> +    struct virtio_pci_device *vnet_pdev;
> +    void *priv;
> +    struct net_device *netdev;
> +
> +    if (!vrdev || !vrdev->vdev) {
> +        pr_err("%s: invalid vrdev or vdev\n", __func__);
> +        return -EINVAL;
> +    }
> +
> +    vp_dev = to_vp_device(vrdev->vdev);
> +
> +    /* Find the PCI device at function 0 of the same slot */
> +    pdev_net = pci_get_slot(vp_dev->pci_dev->bus,
> +                            PCI_DEVFN(PCI_SLOT(vp_dev->pci_dev->devfn), 0));
> +    if (!pdev_net) {
> +        pr_err("Failed to find PCI device at fn=0 of slot %x\n",
> +               PCI_SLOT(vp_dev->pci_dev->devfn));
> +        return -ENODEV;
> +    }
> +
> +    /* Optional: Validate it's a known virtio-net device */
> +    if (pdev_net->vendor != PCI_VENDOR_ID_REDHAT_QUMRANET ||
> +        pdev_net->device != 0x1041) {
> +        pr_warn("PCI device %04x:%04x is not expected virtio-net (1041) device\n",
> +                pdev_net->vendor, pdev_net->device);
> +        pci_dev_put(pdev_net);
> +        return -ENODEV;
> +    }
> +
> +    /* Get the virtio_pci_device from drvdata */
> +    vnet_pdev = pci_get_drvdata(pdev_net);
> +    if (!vnet_pdev || !vnet_pdev->vdev.priv) {
> +        pr_err("No driver data or priv for virtio-net device\n");
> +        pci_dev_put(pdev_net);
> +        return -ENODEV;
> +    }
> +
> +    priv = vnet_pdev->vdev.priv;
> +	vrdev->netdev = priv - ALIGN(sizeof(struct net_device), NETDEV_ALIGN);
> +    netdev = vrdev->netdev; 
> +
> +    if (!netdev || !netdev->netdev_ops) {
> +        pr_err("Invalid net_device retrieved from virtio-net\n");
> +        pci_dev_put(pdev_net);
> +        return -ENODEV;
> +    }
> +
> +    /* Hold reference so netdev won't disappear */
> +    dev_hold(netdev);
> +
> +    pci_dev_put(pdev_net);  /* Release reference from pci_get_slot */
> +
> +    return 0;
> +}

AI was right here. It is awful hack.

Thanks

