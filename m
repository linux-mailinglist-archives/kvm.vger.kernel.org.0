Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BD13E5633
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 11:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238568AbhHJJFH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 05:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236131AbhHJJFG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 05:05:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93194C0613D3;
        Tue, 10 Aug 2021 02:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pGywPtlb02K2MUVV2HEHzmAKnpUiArQRaAog4riS5J8=; b=iTHsqIAAqpgflDVlby2h8YiZ7U
        p/kAUBc7LEUTLIAHOW8BDox9+/2R4fl317sf1Qn/IbGXZxlun78eSuTeP1GsBozx432gsmWC6AYaT
        thI66A9wRdUiIWz+P3/MPi+MxRboOmRIlsjZn067uC1Qx9sNRGhdsWDUinDbgCYJifYtk9Rz8LOtE
        2aqNzPNf9jmtEm2IYeIc5a4GD3KD38/LkvWDf2SZpmTaq5b3NlA7YUgQRJ0yrYw+YDjs3UUQoFyNr
        jE9/FzHb1LIvlQyGDg+1sxdymZFC4BQ0eMv+zWj6AqrFhcGnCnE/Uq3OWFd+TbujwI6vg4F5qixsW
        FUnBi1Ww==;
Received: from [2001:4bb8:184:6215:a004:cea2:5ea9:6eca] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mDNg4-00BvMQ-HA; Tue, 10 Aug 2021 09:04:19 +0000
Date:   Tue, 10 Aug 2021 11:04:03 +0200
From:   Christoph Hellwig <hch@infradead.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, jgg@nvidia.com,
        peterx@redhat.com
Subject: Re: [PATCH 6/7] vfio: Add vfio_device_io_remap_mapping_range()
Message-ID: <YRJBA0A7vIF6PKMB@infradead.org>
References: <162818167535.1511194.6614962507750594786.stgit@omen>
 <162818329235.1511194.15804833796430403640.stgit@omen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162818329235.1511194.15804833796430403640.stgit@omen>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +int vfio_device_io_remap_mapping_range(struct vfio_device *device,
> +				       loff_t start, loff_t len)
> +{
> +	struct address_space *mapping = device->inode->i_mapping;
> +	int ret = 0;
> +
> +	i_mmap_lock_write(mapping);
> +	if (mapping_mapped(mapping)) {
> +		struct rb_root_cached *root = &mapping->i_mmap;
> +		pgoff_t pgstart = start >> PAGE_SHIFT;
> +		pgoff_t pgend = (start + len - 1) >> PAGE_SHIFT;
> +		struct vm_area_struct *vma;
> +
> +		vma_interval_tree_foreach(vma, root, pgstart, pgend) {

There is no need for the mapping_mapped check here,
vma_interval_tree_foreach will the right thing for an empty tree.
That also allows to move a few more instructions out of the lock.

> +			/*
> +			 * Force NOFS memory allocation context to avoid
> +			 * deadlock while we hold i_mmap_rwsem.
> +			 */
> +			flags = memalloc_nofs_save();

Please move this out of the loop.

> +extern int vfio_device_io_remap_mapping_range(struct vfio_device *device,
> +					      loff_t start, loff_t len);

No need for the extern.
