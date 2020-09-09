Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E8A2633E7
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 19:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730650AbgIIRMJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 13:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730287AbgIIPcg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Sep 2020 11:32:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1CDCC06123A;
        Wed,  9 Sep 2020 08:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MVAeHe5FDtxLkhCRtWl5/1qAQHWmRELNofFvInrKy68=; b=BztXimA7lzcj8i0a7Hfb2iCsRV
        8Jbc1EgSgRrX823PDBzAnIPcQVx1llIRGOg31njOV1ZiixejTgKPCIhqyh0B3oBbBpMbZyUaKkipa
        d4wtX8Tb7QBsK4SVuh/xnFcyvlxnCr+IByHYj0nmLwfWMfGltfZbuzMnMWoJeOLvLdSKJ+UMBXkA0
        AYMCECsJvVfCxvGEGhvsd0I849jKePnGGTbkI4Rwm/zWQNSCbCnBDFhthuvRhbgd4wdm8mwYwkLpO
        SyGu2Y7hhxmqb35g1sqzEm9EVWr3ddpLrMPlUOkGm4u0F1TiB2CThO7OMYC3vv78PrfGZDG1i91d4
        tR/q5t7w==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kG1a3-0007u9-24; Wed, 09 Sep 2020 15:00:15 +0000
Date:   Wed, 9 Sep 2020 16:00:15 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        Ming Mao <maoming.maoming@huawei.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, alex.williamson@redhat.com,
        akpm@linux-foundation.org, cohuck@redhat.com,
        jianjay.zhou@huawei.com, weidong.huang@huawei.com,
        peterx@redhat.com, aarcange@redhat.com, wangyunjian@huawei.com,
        jhubbard@nvidia.com
Subject: Re: [PATCH V4 1/2] vfio dma_map/unmap: optimized for hugetlbfs pages
Message-ID: <20200909150015.GI6583@casper.infradead.org>
References: <20200908133204.1338-1-maoming.maoming@huawei.com>
 <20200908133204.1338-2-maoming.maoming@huawei.com>
 <20200909080114.GA8321@infradead.org>
 <20200909130518.GE87483@ziepe.ca>
 <20200909142941.GA23553@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909142941.GA23553@infradead.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 09, 2020 at 03:29:41PM +0100, Christoph Hellwig wrote:
> On Wed, Sep 09, 2020 at 10:05:18AM -0300, Jason Gunthorpe wrote:
> > How to use? The VMAs can have mixed page sizes so the caller would
> > have to somehow switch and call twice? Not sure this is faster.
> 
> We can find out the page size based on the page.  Right now it is
> rather cumbersome, but one of willys pending series has a nicer helper
> for that.

Actually already merged.  There's page_size() which went into 5.4, and
is the one you'd want to use (also page_shift() and compound_nr()).
The thp_* equivalents (merged in 5.9) compile away to nothing if you
don't have CONFIG_TRANSPARENT_HUGEPAGE enabled, but since there are
many ways of getting a compound page mapped into userspace, page_size()
is the helper to use for VFIO.

