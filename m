Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C259450548
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 14:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234952AbhKONX5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 08:23:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231816AbhKONXa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 08:23:30 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665F6C061570;
        Mon, 15 Nov 2021 05:20:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Bu7e9ybFrYh6YTEgv80th636KP7aBwp9xQAbowAq/9s=; b=sb/7SKjX4arvamWu6kujZ05Kc/
        L76KKWIP2vu7KEnuWKrmcZft4WsAJOJXx63D264Cn9iL6S9P6Yf4XXdHxl1qD9RwOPE2wHmjvtc6R
        Xy8l3hWjjUZ705xERSTgq6zioSlayuImvoPCtTsXE+rnie9T6nU1jyfGH38K6yzjnvgQziKG1Q41k
        SJy/Z+Q9RbW2otqKZ+JChGE/cNHa+0IZYMOn+s3BNsn4Nph9foreVafwcRFJMknt1Z+b/dGYZX//M
        FgKMLLpebwl9C9yaahjF0F0uJYfJpX5QZxUDhrkDSTROq5R4c/ouW3s3V7he7IEjT6g4EfT+lRqVK
        +IyJNfJg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmbuE-00Fe2J-0O; Mon, 15 Nov 2021 13:20:18 +0000
Date:   Mon, 15 Nov 2021 05:20:17 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Ashok Raj <ashok.raj@intel.com>, kvm@vger.kernel.org,
        rafael@kernel.org, linux-pci@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH 02/11] driver core: Set DMA ownership during driver
 bind/unbind
Message-ID: <YZJekd9tdz8cLAz+@infradead.org>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
 <20211115020552.2378167-3-baolu.lu@linux.intel.com>
 <YZIFPv7BpsTibxE/@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZIFPv7BpsTibxE/@kroah.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 15, 2021 at 07:59:10AM +0100, Greg Kroah-Hartman wrote:
> This feels wrong to be doing it in the driver core, why doesn't the bus
> that cares about this handle it instead?
> 
> You just caused all drivers in the kernel today to set and release this
> ownership, as none set this flag.  Shouldn't it be the other way around?
> 
> And again, why not in the bus that cares?
> 
> You only have problems with 1 driver out of thousands, this feels wrong
> to abuse the driver core this way for just that one.

This isn't really a bus thingy, but related to the IOMMU subsystem.
That being said as pointed out in my previous reply I'd expect this
to go along with other IOMMU setup.
