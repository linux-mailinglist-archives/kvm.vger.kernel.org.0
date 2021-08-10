Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9C13E5614
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 10:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238471AbhHJI64 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 04:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232978AbhHJI6z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 04:58:55 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17A1C0613D3;
        Tue, 10 Aug 2021 01:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=YfNUq8j0o8x5Ev25xgxcLwcxadhP66TZ8HAtjvpqGXo=; b=DbOQ9I1cInRZCy9Qao/Zvg5JXY
        CCqvUrxaQlyUgHxAvixgBciEUpu5/SMvrbUf3a8ri67hTFWuJhQI65XGuXcnEXhsUwYCJe9o7DfSH
        /BgnS/0bMREH3eGhVNi70o3oMCSw2l5NBed8MKbNxPvL6amwLh+mu1xt0SHoUfgoIk4KRBX8Eo0fI
        QtyI9eNLyWe1t/U4uxa4y6rLj8IJqRHJz5DAR1x5FyTO6HUlML9SpiAtpcrEIYJ8gQLFjVC2Q8D09
        HHSL9KceU0UOGzycz9lJJKZxXGkjbxEPjcYrMOCDM1FBrFchIF1QB+mJPJN2QZN4M2Re18f6C6Bqp
        OsPbNE5Q==;
Received: from [2001:4bb8:184:6215:a004:cea2:5ea9:6eca] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mDNWB-00BuuO-4w; Tue, 10 Aug 2021 08:55:11 +0000
Date:   Tue, 10 Aug 2021 10:53:50 +0200
From:   Christoph Hellwig <hch@infradead.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, peterx@redhat.com
Subject: Re: [PATCH 3/7] vfio/pci: Use vfio_device_unmap_mapping_range()
Message-ID: <YRI+nsVAr3grftB4@infradead.org>
References: <162818167535.1511194.6614962507750594786.stgit@omen>
 <162818325518.1511194.1243290800645603609.stgit@omen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162818325518.1511194.1243290800645603609.stgit@omen>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 05, 2021 at 11:07:35AM -0600, Alex Williamson wrote:
> +static void vfio_pci_zap_bars(struct vfio_pci_device *vdev)
>  {
> +	vfio_device_unmap_mapping_range(&vdev->vdev,
> +			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_BAR0_REGION_INDEX),
> +			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_ROM_REGION_INDEX) -
> +			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_BAR0_REGION_INDEX));

Maybe make this a little more readable by having local variables:

> +static int vfio_pci_bar_vma_to_pfn(struct vm_area_struct *vma,
> +				   unsigned long *pfn)
>  {
> +	struct vfio_pci_device *vdev = vma->vm_private_data;
> +	struct pci_dev *pdev = vdev->pdev;
> +	int index;
> +	u64 pgoff;
>  
> +	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);

Nit: initialization at declaration time would be nice.

>  static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
>  {
>  	struct vm_area_struct *vma = vmf->vma;
>  	struct vfio_pci_device *vdev = vma->vm_private_data;
> +	unsigned long vaddr, pfn;
> +	vm_fault_t ret = VM_FAULT_SIGBUS;
>  
> +	if (vfio_pci_bar_vma_to_pfn(vma, &pfn))
> +		return ret;
>  
> +	down_read(&vdev->memory_lock);
>  
> +	if (__vfio_pci_memory_enabled(vdev)) {
> +		for (vaddr = vma->vm_start;
> +		     vaddr < vma->vm_end; vaddr += PAGE_SIZE, pfn++) {
> +			ret = vmf_insert_pfn(vma, vaddr, pfn);
> +			if (ret != VM_FAULT_NOPAGE) {
> +				zap_vma_ptes(vma, vma->vm_start,
> +					     vaddr - vma->vm_start);
> +				break;
> +			}
> +		}

Unwinding this with a goto for the not enabled case would be a little easier
to read.
