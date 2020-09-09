Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC4F26339C
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 19:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730381AbgIIRHD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 13:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730401AbgIIPhV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Sep 2020 11:37:21 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158AAC0612F0;
        Wed,  9 Sep 2020 07:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SILNQASTuR+wW0V3/KNTHMKzmXU41qOTdycCKqTyf5s=; b=QV1RNWU26OaZHqUhuB7s6WXObX
        xOIa1bWUz2mrIY0Yfck2v+tJIotfNIkJkMsHN75myEUKgD5U+M3uxkmEMM1igvDfGdE5HwdOSh4o2
        YMRw22QciNTJ3Q3Lhnb6eLXBrBJk+E8HKeG/IT/Og2CWkGL1O77+FvimPtEhRC3ZSoS5m8TXE/cJh
        fYG1XfawyPKwTinfUPB7gdW+CUU6w6dTJRgzMXEsYNKLWRdoRNFa59l61Kts2Z/yx4INNAyljHZ9K
        DGLEQrrdbwA2OBV29fvuXn9VA1Ir5D+xuoBV8NUQD16Py+Kq9sSnkvJYqcYgf82FbsQ9U8FpVssgD
        fnTigTNQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kG16T-0006Gg-RY; Wed, 09 Sep 2020 14:29:41 +0000
Date:   Wed, 9 Sep 2020 15:29:41 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Ming Mao <maoming.maoming@huawei.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, alex.williamson@redhat.com,
        akpm@linux-foundation.org, cohuck@redhat.com,
        jianjay.zhou@huawei.com, weidong.huang@huawei.com,
        peterx@redhat.com, aarcange@redhat.com, wangyunjian@huawei.com,
        willy@infradead.org, jhubbard@nvidia.com
Subject: Re: [PATCH V4 1/2] vfio dma_map/unmap: optimized for hugetlbfs pages
Message-ID: <20200909142941.GA23553@infradead.org>
References: <20200908133204.1338-1-maoming.maoming@huawei.com>
 <20200908133204.1338-2-maoming.maoming@huawei.com>
 <20200909080114.GA8321@infradead.org>
 <20200909130518.GE87483@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909130518.GE87483@ziepe.ca>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 09, 2020 at 10:05:18AM -0300, Jason Gunthorpe wrote:
> How to use? The VMAs can have mixed page sizes so the caller would
> have to somehow switch and call twice? Not sure this is faster.

We can find out the page size based on the page.  Right now it is
rather cumbersome, but one of willys pending series has a nicer helper
for that.

> >  (2) add a bvec version of the API that returns a variable size
> >      "extent"
> 
> This is the best one, I think.. The IOMMU setup can have multiple page
> sizes, so having largest contiguous blocks pre-computed should speed
> that up.
> 
> vfio should be a win to use a sgl rather than a page list?
> 
> Especially if we can also reduce the number of pages pinned by only
> pinning head pages..

Especially for raw use of the iommu API as in vfio we don't even need
the scatterlist now, we can call ->map on each chunk.  For the DMA API
we'd kinda need it, but not for long.

> What about some 'pin_user_page_sgl' as a stepping stone?

I'd rather avoid adding new scatterlist based APIs.
