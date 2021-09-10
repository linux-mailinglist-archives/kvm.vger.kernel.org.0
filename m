Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63EEE406AB1
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 13:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232755AbhIJL3z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 07:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbhIJL3y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Sep 2021 07:29:54 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAEF0C061574;
        Fri, 10 Sep 2021 04:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2++cV2JnD7bTzi6VmrHK6QfUgKwltk9kOD+RazPcbpI=; b=G+7U57r85k3HFkWNdyCUgCPZff
        xACimE5/41OczRjPb2gKBZjjTxk9N9aK2P6IKvNp4U4XOvSwsSm36QV7OctJjQ8h6W3Osg9UxweXn
        drM6Eg7ri97z748cZyHbGUYt5gdf8IB0yB6scDU62uwrfcUwi7iY6r2YKzEfBZ3bE4cLq6h8rpQ9r
        XOc2oMZYGs1U/YheK8FAesU6aEU+bIiymmYNuk6mqs5s8dLdyK6cYkfpTDsigNxrhO2xvEwrZNOjg
        HhOsNnbYdNxq9Xjqc58OADY+kGXWBPKvvhkeZd3+LFNChshprVSB6r9lbTrw6F/nYWsOuraQC+XDC
        xo3IJS+g==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mOegX-00Ax1W-UQ; Fri, 10 Sep 2021 11:27:23 +0000
Date:   Fri, 10 Sep 2021 12:27:09 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
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
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 1/9] vfio/ccw: Use functions for alloc/free of the
 vfio_ccw_private
Message-ID: <YTtBDbVsRveVE3i9@infradead.org>
References: <0-v2-7d3a384024cf+2060-ccw_mdev_jgg@nvidia.com>
 <1-v2-7d3a384024cf+2060-ccw_mdev_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1-v2-7d3a384024cf+2060-ccw_mdev_jgg@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 09, 2021 at 04:38:41PM -0300, Jason Gunthorpe wrote:
> +
> +	private = kzalloc(sizeof(*private), GFP_KERNEL | GFP_DMA);
> +	if (!private)
> +		return ERR_PTR(-ENOMEM);

Nit: there is no need to add GFP_KERNEL when using GFP_DMA.

Also a question to the s390 maintainers: why do we need 31-bit
addressability for the main private data structure?
