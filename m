Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B4B263133
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 18:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730791AbgIIQC1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 12:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730572AbgIIP5f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Sep 2020 11:57:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD524C0617BC;
        Wed,  9 Sep 2020 06:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=BsLnzg0TUWFKkjHB7GFuV9Yd79wQB1MTmZ0FtnYyRyI=; b=GCZKbgAuJ6yV+SQqDvHW+6PyrE
        ab0uViZ1p2LiP11FDscTtRCp12Q3B340D3uZiwWo/XI8BPPVt287/xUcccpauyP/TaEjVOSS17/fm
        V9NJyyTEUONuX65JlwAquxfYIYkCKvFz07SWkSVVqFpQh7feNniyj9G/5CsLr2/Sd9YSVIzq4+UnS
        tVTXUmA6xKojbQLj0CgIhpctFkrSHO0Rc8qmGOUrtqSAQeb06fyDVo7psPozObT2tg0FtAbiwxUWO
        VM2JK2pz+Zknt3xxLEESLaklHGIjuQQPpqI2FCXR81KI7VExiSojqMf2AJvgJNoN5l8yfOrNm4WX5
        eK16QwdQ==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kG0Lw-0003p4-CD; Wed, 09 Sep 2020 13:41:36 +0000
Date:   Wed, 9 Sep 2020 14:41:36 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Ming Mao <maoming.maoming@huawei.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, alex.williamson@redhat.com,
        akpm@linux-foundation.org, cohuck@redhat.com,
        jianjay.zhou@huawei.com, weidong.huang@huawei.com,
        peterx@redhat.com, aarcange@redhat.com, wangyunjian@huawei.com,
        jhubbard@nvidia.com
Subject: Re: [PATCH V4 1/2] vfio dma_map/unmap: optimized for hugetlbfs pages
Message-ID: <20200909134136.GG6583@casper.infradead.org>
References: <20200908133204.1338-1-maoming.maoming@huawei.com>
 <20200908133204.1338-2-maoming.maoming@huawei.com>
 <20200909080114.GA8321@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200909080114.GA8321@infradead.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 09, 2020 at 09:01:14AM +0100, Christoph Hellwig wrote:
> I really don't think this approach is any good.  You workaround
> a deficiency in the pin_user_pages API in one particular caller for
> one particular use case.
> 
> I think you'd rather want either:
> 
>  (1) a FOLL_HUGEPAGE flag for the pin_user_pages API family that returns
>      a single struct page for any kind of huge page, which would also
>      benefit all kinds of other users rather than adding these kinds of
>      hacks to vfio.

This seems to be similar to a flag I added last week to
pagecache_get_page() called FGP_HEAD:

+ * * %FGP_HEAD - If the page is present and a THP, return the head page
+ *   rather than the exact page specified by the index.

I think "return the head page" is probably what we want from what I
understand of this patch.  The caller can figure out the appropriate
bv_offset / bv_len for a bio_vec, if that's what they want to do with it.

http://git.infradead.org/users/willy/pagecache.git/commitdiff/ee88eeeb6b0f35e95ef82b11dfc24dc04c3dcad8 is the exact commit where I added that, but it depends on a number of other patches in this series:
http://git.infradead.org/users/willy/pagecache.git/shortlog

I'm going to send out a subset of patches later today which will include
that one and some others.  I haven't touched the GUP paths at all in
that series, but it's certainly going to make THPs (of various sizes)
much more present in the system.

