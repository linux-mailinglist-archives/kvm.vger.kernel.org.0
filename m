Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 972D4263374
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 19:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731080AbgIIREO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 13:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730551AbgIIREK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Sep 2020 13:04:10 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13401C061573;
        Wed,  9 Sep 2020 10:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LfHxT4ZNG1X4ZvN2dtQwo2pwpei3uAvCD6OoC4DuCCA=; b=PTtQzQukf2s/Vju2X06eMGOIWP
        yiKhMDLhWzkhhzXfGg5yOClIpORVoMG0/fj6/fpwo52WI1xZPN5qKbPPCsMiNn0HPycb4loydQe7S
        I6WrDdx271lhA3YooKU3xJDSgsMCZyHvpo86ehdFhVeKuyESTJNrwTEiRPQOwJfafit1oD5PsZCgx
        MFxdeLOJPKdwBNxs+qH9oG9W3ybCDan9eMHA3eGFa0liIqhXormAofOtqmu5+vGxHN3/rPBfYcXRs
        ys5s3+t08k47reP+/evgeFtoXj55NgSu/kMDsPjPinUWRrwZmVzZwdHRTCZ2HLoSovpn8vQAS2/pI
        +qSPo5CQ==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kG3Vq-0007vP-FL; Wed, 09 Sep 2020 17:04:03 +0000
Date:   Wed, 9 Sep 2020 18:04:02 +0100
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
Message-ID: <20200909170402.GJ6583@casper.infradead.org>
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
>  (1) a FOLL_HUGEPAGE flag for the pin_user_pages API family that returns
>      a single struct page for any kind of huge page, which would also
>      benefit all kinds of other users rather than adding these kinds of
>      hacks to vfio.
>  (2) add a bvec version of the API that returns a variable size
>      "extent"
> 
> I had started on (2) a while ago, and here is branch with my code (which
> is broken and fails test, but might be a start):
> 
> http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/gup-bvec
> 
> But for now I wonder if (1) is the better start, which could still be
> reused to (2) later.

(1) doesn't work.  Suppose you have a 16kB MAP_PRIVATE of a file which happens
to have a THP in the page cache.  When you write a byte, that base page gets
copied and your bvec for that 16kB needs to look something like:

{ page A, offset 0, length 4096 },
{ page B, offset 0, length 4096 },
{ page A, offset 8192, length 8192 },

You can come up with other scenarios, like partial mappings of THPs with
an adjacent VMA of a different THP, but I think we just need to make
(2) work.
