Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAEE2A6956
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 17:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730073AbgKDQVc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 11:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbgKDQVc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Nov 2020 11:21:32 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9CABC0613D3;
        Wed,  4 Nov 2020 08:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NKY4RDSn0UBs859d6dPsXhdr5/nXdulWdtU5Y3NVcbE=; b=ccwuKEZCoNEkv5u0gTSIw+pJX8
        GT6KMUMxyruFGsU7wlJvS/WPodwWNZqxvg+84Sboy0HwzpX9tkhxGvs0ukVEtonnVLGNX4L+TsETw
        7wuJuhvHfNsH9gQBWUEUvbbQ3Bw6e1qlG+jFDR2zV7Za/E0HImdeRZfq6Fe4uoWI5lrvLJjJ/Jvzr
        OgDGamj+LKQhBKh7CRWXw5xX/dvW98Gp+/kCmP0kdExERxfGBUdU6nkdmgK9PO8HpE4QF/uYJ6vJ3
        ENmjBaeTVq7dnmKi4EfK3YgMruDfg6F4931eIXPJFu0VNYNegZZLGLRKqVb/QVl7tSb/r4511e6Kb
        DtZTsKjA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kaLXJ-0003Vy-2U; Wed, 04 Nov 2020 16:21:25 +0000
Date:   Wed, 4 Nov 2020 16:21:25 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
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
Message-ID: <20201104162125.GA13007@infradead.org>
References: <20201030100815.2269-1-daniel.vetter@ffwll.ch>
 <20201030100815.2269-6-daniel.vetter@ffwll.ch>
 <446b2d5b-a1a1-a408-f884-f17a04b72c18@nvidia.com>
 <CAKMK7uGDW2f0oOvwgryCHxQFHyh3Tsk6ENsMGmtZ-EnH57tMSA@mail.gmail.com>
 <1f7cf690-35e2-c56f-6d3f-94400633edd2@nvidia.com>
 <CAKMK7uFYDSqnNp_xpohzCEidw_iLufNSoX4v55sNZj-nwTckSg@mail.gmail.com>
 <7f29a42a-c408-525d-90b7-ef3c12b5826c@nvidia.com>
 <CAKMK7uEw701AWXNJbRNM8Z+FkyUB5FbWegmSzyWPy9cG4W7OLA@mail.gmail.com>
 <20201104140023.GQ36674@ziepe.ca>
 <CAKMK7uH69hsFjYUkjg1aTh5f=q_3eswMSS5feFs6+ovz586+0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uH69hsFjYUkjg1aTh5f=q_3eswMSS5feFs6+ovz586+0A@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 04, 2020 at 04:54:19PM +0100, Daniel Vetter wrote:
> I don't really have a box here, but dma_mmap_attrs() and friends to
> mmap dma_alloc_coherent memory is set up as VM_IO | VM_PFNMAP (it's
> actually enforced since underneath it uses remap_pfn_range), and
> usually (except if it's pre-cma carveout) that's just normal struct
> page backed memory. Sometimes from a cma region (so will be caught by
> the cma page check), but if you have an iommu to make it
> device-contiguous, that's not needed.

dma_mmap_* memory may or may not be page backed, but it absolutely
must not be resolved by get_user_pages and friends as it is special.
So yes, not being able to get a struct page back from such an mmap is
a feature.
