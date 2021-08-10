Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 308063E566E
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 11:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236771AbhHJJNA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 05:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbhHJJM7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 05:12:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8452FC0613D3;
        Tue, 10 Aug 2021 02:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=H3zzJaXcELoe7fwHmHVQFbyT9HpObLcWomqOooPjNsk=; b=NtrCnvhh9LR4naycFbzgkj3XFS
        jV56VjiVsPy2S3YV/1LdXXzZRKKXfQZfTPMBzilWd2hL43c/3wfSKWdj8sP3C195sneeIM6tG8ODl
        ibuNY8VntRlgm5qa5oCSHftrOtstNRzOpM47ACyBLWyXwHuo6AXye856kzngkRo82YtelqfPnDKGy
        xJlvLeKMJruRSsFhqPmQzRQL2jP5QDgViRwfEga6/fdRW1V7Sy3jLLGMVXiLk5p4ZzzbbYBLvAdGP
        pXVomXDLVzXbt1GUe3YKjDOdNebtqOTHAd4m6LmbQuS9eHVZTDu/1dmFTFFDuqhW2gZO9py/sIt1Q
        gx+LxoQg==;
Received: from [2001:4bb8:184:6215:a004:cea2:5ea9:6eca] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mDNna-00BvyP-8T; Tue, 10 Aug 2021 09:11:58 +0000
Date:   Tue, 10 Aug 2021 11:11:49 +0200
From:   Christoph Hellwig <hch@infradead.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, peterx@redhat.com
Subject: Re: [PATCH 7/7] vfio/pci: Remove map-on-fault behavior
Message-ID: <YRJC1buKp67kGemh@infradead.org>
References: <162818167535.1511194.6614962507750594786.stgit@omen>
 <162818330190.1511194.10498114924408843888.stgit@omen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162818330190.1511194.10498114924408843888.stgit@omen>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 05, 2021 at 11:08:21AM -0600, Alex Williamson wrote:
> +void vfio_pci_test_and_up_write_memory_lock(struct vfio_pci_device *vdev)
> +{
> +	if (vdev->zapped_bars && __vfio_pci_memory_enabled(vdev)) {
> +		WARN_ON(vfio_device_io_remap_mapping_range(&vdev->vdev,
> +			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_BAR0_REGION_INDEX),
> +			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_ROM_REGION_INDEX) -
> +			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_BAR0_REGION_INDEX)));
> +		vdev->zapped_bars = false;

Doing actual work inside a WARN_ON is pretty nasty.  Also the non-ONCE
version here will lead to massive log splatter if it actually hits.

I'd prefer something like:

	loff_t start = VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_BAR0_REGION_INDEX);
	loff_t end = VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_ROM_REGION_INDEX);

	if (vdev->zapped_bars && __vfio_pci_memory_enabled(vdev)) {
		if (!vfio_device_io_remap_mapping_range(&vdev->vdev, start,
				end - start))
			vdev->zapped_bars = false;
		WARN_ON_ONCE(vdev->zapped_bars);

>  	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> -	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);

What is the story with this appearing earlier and disappearing here
again?

> +extern void vfio_pci_test_and_up_write_memory_lock(struct vfio_pci_device
> +						   *vdev);

No need for the extern.
