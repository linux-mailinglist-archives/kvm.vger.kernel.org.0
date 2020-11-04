Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE7602A6A08
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 17:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731124AbgKDQlW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 11:41:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730971AbgKDQlV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Nov 2020 11:41:21 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2FC6C0613D3;
        Wed,  4 Nov 2020 08:41:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=N+PdC8aIRIGAg2FR28I1P/4kBIo6jnmN4QhPRmCU08A=; b=Y1htN0aBJKelZ9PF10bOpkfzNm
        AbdmBX7uwg/dy8j86ohk0c2kPpXPZzG0w5faSlS/dCeaixKVHRJuLcLLQ7dQcHXbInbLBAAwWbgY2
        0+jbViIJWH+PzBiBQWi2s9Jrmk/I8R62cvYgsYWRhrqxOhT5cze01WusTw+gBleoPF6GUkV4wguSf
        GN2jz0PJcmRTFJ9I/UNw0GwSXF3aEF7PE7twMLwlKVN5jr+K8DmA/zIiIGLLHLjPRHUvfri1ifWkQ
        lhzs6zF6PkoS5rz5oqYfTnpenyuB+ufAq0MXJl0XWojaqOVac3o65QNUxwOqel58DO/Tkmn/n4Rzl
        T1oYFK8w==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kaLqZ-0004uc-8m; Wed, 04 Nov 2020 16:41:19 +0000
Date:   Wed, 4 Nov 2020 16:41:19 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        J??r??me Glisse <jglisse@redhat.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Pawel Osciak <pawel@osciak.com>,
        KVM list <kvm@vger.kernel.org>,
        John Hubbard <jhubbard@nvidia.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Linux MM <linux-mm@kvack.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>
Subject: Re: [PATCH v5 05/15] mm/frame-vector: Use FOLL_LONGTERM
Message-ID: <20201104164119.GA18218@infradead.org>
References: <CAKMK7uGDW2f0oOvwgryCHxQFHyh3Tsk6ENsMGmtZ-EnH57tMSA@mail.gmail.com>
 <1f7cf690-35e2-c56f-6d3f-94400633edd2@nvidia.com>
 <CAKMK7uFYDSqnNp_xpohzCEidw_iLufNSoX4v55sNZj-nwTckSg@mail.gmail.com>
 <7f29a42a-c408-525d-90b7-ef3c12b5826c@nvidia.com>
 <CAKMK7uEw701AWXNJbRNM8Z+FkyUB5FbWegmSzyWPy9cG4W7OLA@mail.gmail.com>
 <20201104140023.GQ36674@ziepe.ca>
 <CAKMK7uH69hsFjYUkjg1aTh5f=q_3eswMSS5feFs6+ovz586+0A@mail.gmail.com>
 <20201104162125.GA13007@infradead.org>
 <CAKMK7uH=0+3FSR4LxP7bJUB4BsCcnCzfK2=D+2Am9QNmfZEmfw@mail.gmail.com>
 <20201104163758.GA17425@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104163758.GA17425@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 04, 2020 at 04:37:58PM +0000, Christoph Hellwig wrote:
> On Wed, Nov 04, 2020 at 05:26:58PM +0100, Daniel Vetter wrote:
> > What we're discussing is whether gup_fast and pup_fast also obey this,
> > or fall over and can give you the struct page that's backing the
> > dma_mmap_* memory. Since the _fast variant doesn't check for
> > vma->vm_flags, and afaict that's the only thing which closes this gap.
> > And like you restate, that would be a bit a problem. So where's that
> > check which Jason&me aren't spotting?
> 
> remap_pte_range uses pte_mkspecial to set up the PTEs, and gup_pte_range
> errors out on pte_special.  Of course this only works for the
> CONFIG_ARCH_HAS_PTE_SPECIAL case, for other architectures we do have
> a real problem.

Except that we don't really support pte-level gup-fast without
CONFIG_ARCH_HAS_PTE_SPECIAL, and in fact all architectures selecting
HAVE_FAST_GUP also select ARCH_HAS_PTE_SPECIAL, so we should be fine.
