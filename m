Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56AC42A69F5
	for <lists+kvm@lfdr.de>; Wed,  4 Nov 2020 17:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730977AbgKDQiE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Nov 2020 11:38:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbgKDQiD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Nov 2020 11:38:03 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9BEC0613D3;
        Wed,  4 Nov 2020 08:38:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=P/u2TF3oLcMxz3Wi4ZjMGw/7l9riNiufmGsS03PjdnQ=; b=SV1Q76qAq9NL10KuDO3HZIh5WZ
        ClhIDefsooYFvHzjdhyQlCy9uItacSE1no5LkH6CKQOlG0JPtJkofYxYBVmV3/EAsMU57Sql/OUjX
        bpyh7r2hT25LOULftRoPVyNR2Igi6nQuSLOh9HsyBN7SnRQnrweWZCutflGNkGXX66o/u5H2OUs0M
        /yofyKH41v8BQHxDWZIFSwAvzCNAK3gcCmPxt0vpaQslcyMtSPggjNGmQwbctMK4XiwL2xqdcwH2E
        tSfjmYIaJ9rEKCn/PPkUDoAnSmBE45GYCNSCNSISFljHATk9bDrm/JvO+TyzT4v5yh2DC9jFxBWN8
        5VZgiqlA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kaLnL-0004eR-0B; Wed, 04 Nov 2020 16:37:59 +0000
Date:   Wed, 4 Nov 2020 16:37:58 +0000
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
Message-ID: <20201104163758.GA17425@infradead.org>
References: <446b2d5b-a1a1-a408-f884-f17a04b72c18@nvidia.com>
 <CAKMK7uGDW2f0oOvwgryCHxQFHyh3Tsk6ENsMGmtZ-EnH57tMSA@mail.gmail.com>
 <1f7cf690-35e2-c56f-6d3f-94400633edd2@nvidia.com>
 <CAKMK7uFYDSqnNp_xpohzCEidw_iLufNSoX4v55sNZj-nwTckSg@mail.gmail.com>
 <7f29a42a-c408-525d-90b7-ef3c12b5826c@nvidia.com>
 <CAKMK7uEw701AWXNJbRNM8Z+FkyUB5FbWegmSzyWPy9cG4W7OLA@mail.gmail.com>
 <20201104140023.GQ36674@ziepe.ca>
 <CAKMK7uH69hsFjYUkjg1aTh5f=q_3eswMSS5feFs6+ovz586+0A@mail.gmail.com>
 <20201104162125.GA13007@infradead.org>
 <CAKMK7uH=0+3FSR4LxP7bJUB4BsCcnCzfK2=D+2Am9QNmfZEmfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uH=0+3FSR4LxP7bJUB4BsCcnCzfK2=D+2Am9QNmfZEmfw@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 04, 2020 at 05:26:58PM +0100, Daniel Vetter wrote:
> What we're discussing is whether gup_fast and pup_fast also obey this,
> or fall over and can give you the struct page that's backing the
> dma_mmap_* memory. Since the _fast variant doesn't check for
> vma->vm_flags, and afaict that's the only thing which closes this gap.
> And like you restate, that would be a bit a problem. So where's that
> check which Jason&me aren't spotting?

remap_pte_range uses pte_mkspecial to set up the PTEs, and gup_pte_range
errors out on pte_special.  Of course this only works for the
CONFIG_ARCH_HAS_PTE_SPECIAL case, for other architectures we do have
a real problem.
