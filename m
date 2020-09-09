Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5E9262977
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 10:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730082AbgIIIBl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 04:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727820AbgIIIBj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Sep 2020 04:01:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4E0C061573;
        Wed,  9 Sep 2020 01:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=h/s4AqYAVQDYIXG3Quzt4FuppGSCR6zLJa5OOsyHiFU=; b=v9QVN+eawzJkpdxGL8CneCQwJS
        VFd5Th/McBJ7QHsPpLIrhdwQtPI2jDu389eQqTScyd1q18tC50OOHr1nS8D/ojg/XkONVn7Oprs3n
        BEW6qMCI64DgfRPaplGOf/z6gHw49uPX/I0cl+GSk2R6tp/hs9s0WjOCYmGsZa9e/hvX3VRN3Qk4z
        GdhimEfxt4kQ/yRvmAb2y/ZwaKBBmnSyOhmgASg/mM+/CJnX2bvnEZCEJZiR8oZl8j/vGR8LwWqFl
        yoXUmV0fG0o6wMyXPmlj3/Bk0StbjU+M9i+g4voNHslymF/YL0V7KQwH/PmBxT0wvOJ6CWtumGHcG
        hkbTNrJQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kFv2Y-0002p5-LE; Wed, 09 Sep 2020 08:01:16 +0000
Date:   Wed, 9 Sep 2020 09:01:14 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Ming Mao <maoming.maoming@huawei.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, alex.williamson@redhat.com,
        akpm@linux-foundation.org, cohuck@redhat.com,
        jianjay.zhou@huawei.com, weidong.huang@huawei.com,
        peterx@redhat.com, aarcange@redhat.com, wangyunjian@huawei.com,
        willy@infradead.org, jhubbard@nvidia.com
Subject: Re: [PATCH V4 1/2] vfio dma_map/unmap: optimized for hugetlbfs pages
Message-ID: <20200909080114.GA8321@infradead.org>
References: <20200908133204.1338-1-maoming.maoming@huawei.com>
 <20200908133204.1338-2-maoming.maoming@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908133204.1338-2-maoming.maoming@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I really don't think this approach is any good.  You workaround
a deficiency in the pin_user_pages API in one particular caller for
one particular use case.

I think you'd rather want either:

 (1) a FOLL_HUGEPAGE flag for the pin_user_pages API family that returns
     a single struct page for any kind of huge page, which would also
     benefit all kinds of other users rather than adding these kinds of
     hacks to vfio.
 (2) add a bvec version of the API that returns a variable size
     "extent"

I had started on (2) a while ago, and here is branch with my code (which
is broken and fails test, but might be a start):

http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/gup-bvec

But for now I wonder if (1) is the better start, which could still be
reused to (2) later.
