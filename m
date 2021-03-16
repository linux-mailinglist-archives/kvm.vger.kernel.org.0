Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A427333D820
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 16:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237470AbhCPPto (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 11:49:44 -0400
Received: from casper.infradead.org ([90.155.50.34]:39234 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237453AbhCPPtX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 11:49:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nZWmZIikdIqUXKBumu57DbQjqCe7A1JBHSVghyYvFqQ=; b=dIrVhYw7bPP4ttWa7NL3R27MKa
        KyUD/H24QkdGcP9DuFv5nwIFtZqYGR6Ul0TltL3rD4JAouZuBCZ6lF5wkjxsV2rZVRQRZbpH4s7kI
        txtpJcRtrWpvFaJORU344KyNSyVvuzIVIDWMxlwXp7JdDiEIiX2p5RwEB2hwX2vvvlepE7KH4gnWH
        A5ZG0tnV4LVhQwnbQQBN1JuJglXk4e60N6FtZpxvjC93P35IwNo55p581YCbtRIIqEcIStoRO0Yoc
        lNkNkCjSg3BYK0cDWCItnKyPgKofzXiE4e3VJXF9Km+YyE0MbOvCeENKEqzIupAqH8Lh5nFMA/0h0
        P237phhQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lMBtF-000FyW-8d; Tue, 16 Mar 2021 15:45:53 +0000
Date:   Tue, 16 Mar 2021 15:45:49 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Tomasz Figa <tfiga@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        J??r??me Glisse <jglisse@redhat.com>, Jan Kara <jack@suse.cz>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Laurent Dufour <ldufour@linux.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH 2/3] media/videobuf1|2: Mark follow_pfn usage as unsafe
Message-ID: <20210316154549.GA60450@infradead.org>
References: <20210316153303.3216674-1-daniel.vetter@ffwll.ch>
 <20210316153303.3216674-3-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316153303.3216674-3-daniel.vetter@ffwll.ch>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 16, 2021 at 04:33:02PM +0100, Daniel Vetter wrote:
> The media model assumes that buffers are all preallocated, so that
> when a media pipeline is running we never miss a deadline because the
> buffers aren't allocated or available.
> 
> This means we cannot fix the v4l follow_pfn usage through
> mmu_notifier, without breaking how this all works. The only real fix
> is to deprecate userptr support for VM_IO | VM_PFNMAP mappings and
> tell everyone to cut over to dma-buf memory sharing for zerocopy.
> 
> userptr for normal memory will keep working as-is, this only affects
> the zerocopy userptr usage enabled in 50ac952d2263 ("[media]
> videobuf2-dma-sg: Support io userptr operations on io memory").

Maybe I'm missing something, but wasn't the conclusion last time that
this hackish early device to device copy support can just go away?
