Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4026D3E562B
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 11:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238542AbhHJJCm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 05:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238539AbhHJJCl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 05:02:41 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D8E5C0613D3;
        Tue, 10 Aug 2021 02:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wFMqs6VrolSh/tL6m07d4K24zqjLVlwVSJnOIKMLhLc=; b=t65FQCAX9WUTJbMASsadUxMyhA
        k/lJ1WFLxLJZRNA6i00+KJQQuIsDW599ja1W+15S2W0Wb/F1BNgYThla6pc96wunTfLk20FSFB0zO
        1W8SuMB1Btrv33vvM2q4ugilsICRCPj7zbRxBxgusGEQKVxPkhJNPxNpwLEV7dx4WVw/9JXOJel4J
        BqB+8RIqpFkMVjj2ocEdrhPrJYYVYPaYJV/EPJwvAT48PFSLNjj5QKoG6sELA3Pr4dP76Yz5cJPYQ
        46nNdXXfatUY9hnQjVau88ANpg1/la9W1mO7jCRv4gqwafJYZVzS7wYFKZsgbgsMDcZl8PWDLZyyz
        QcNLD5tw==;
Received: from [2001:4bb8:184:6215:a004:cea2:5ea9:6eca] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mDNcU-00BvBD-DL; Tue, 10 Aug 2021 09:00:43 +0000
Date:   Tue, 10 Aug 2021 11:00:21 +0200
From:   Christoph Hellwig <hch@infradead.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, peterx@redhat.com
Subject: Re: [PATCH 4/7] vfio,vfio-pci: Add vma to pfn callback
Message-ID: <YRJAJZTMOXfgIfZw@infradead.org>
References: <162818167535.1511194.6614962507750594786.stgit@omen>
 <162818326742.1511194.1366505678218237973.stgit@omen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162818326742.1511194.1366505678218237973.stgit@omen>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>  static int vfio_pci_reflck_attach(struct vfio_pci_device *vdev);
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 1e4fc69fee7d..42ca93be152a 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -875,6 +875,22 @@ struct vfio_device *vfio_device_get_from_dev(struct device *dev)
>  }
>  EXPORT_SYMBOL_GPL(vfio_device_get_from_dev);
>  
> +static const struct file_operations vfio_device_fops;

If we ned a forward declaration here it would be nice to keep it at the top
of the file.  Finding a way to not need it would be even better.

> +
> +int vfio_device_vma_to_pfn(struct vfio_device *device,
> +			   struct vm_area_struct *vma, unsigned long *pfn)
> +{
> +	if (WARN_ON(!vma->vm_file || vma->vm_file->f_op != &vfio_device_fops ||
> +		    vma->vm_file->private_data != device))
> +		return -EINVAL;

WARN_ON_ONCE?

> +
> +	if (unlikely(!device->ops->vma_to_pfn))
> +		return -EPERM;
> +
> +	return device->ops->vma_to_pfn(device, vma, pfn);
> +}
> +EXPORT_SYMBOL_GPL(vfio_device_vma_to_pfn);

This function is only used in vfio.c, so it can be marked static instead of
being exported.
