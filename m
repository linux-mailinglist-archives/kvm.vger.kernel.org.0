Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66739450524
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 14:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbhKONR0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 08:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbhKONRX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 08:17:23 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C74FC061570;
        Mon, 15 Nov 2021 05:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Ijx7ygrsbGB8DaiDlZgsojxI26SKNZNZbgP3dg36cpY=; b=FAnpyplCWUHBo7vCQHkFDFzoub
        WU+vsiZ5NN0CSB47F5895O6ji7tOk+uOsz23e4WjzUjiaJK/50tSPMC6Q72PjCDSA+sGJ8h4HXxZq
        h/eL8/TPwp9a1MIV3OuFuWf5XN9CmcAVg9IlUloz4HYB39yBcZyZhLoDO4B2+upeIF222LRVAXznT
        +rtbzf8Wbyor7puFccsX56b2JYRCR6LsRmIColzUmz7IUfZLtLh+ShIBpS/JsP7uPHBGWD5G/ua3I
        K26+oZiG4YmoxJ9lb0zZt1NkvvqqD0Z+r7iKd3DAEE2zE1zwfcOZB90y9clEeWchSXLpivkQ9wsq4
        IeJ4L3Eg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmboK-00FchT-TG; Mon, 15 Nov 2021 13:14:12 +0000
Date:   Mon, 15 Nov 2021 05:14:12 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>, kvm@vger.kernel.org,
        rafael@kernel.org, linux-pci@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH 01/11] iommu: Add device dma ownership set/release
 interfaces
Message-ID: <YZJdJH4AS+vm0j06@infradead.org>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
 <20211115020552.2378167-2-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115020552.2378167-2-baolu.lu@linux.intel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 15, 2021 at 10:05:42AM +0800, Lu Baolu wrote:
> +enum iommu_dma_owner {
> +	DMA_OWNER_NONE,
> +	DMA_OWNER_KERNEL,
> +	DMA_OWNER_USER,
> +};
> +

> +	enum iommu_dma_owner dma_owner;
> +	refcount_t owner_cnt;
> +	struct file *owner_user_file;

I'd just overload the ownership into owner_user_file,

 NULL			-> no owner
 (struct file *)1UL)	-> kernel
 real pointer		-> user

Which could simplify a lot of the code dealing with the owner.
