Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B913A33717A
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 12:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbhCKLgF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 06:36:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232681AbhCKLfg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 06:35:36 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5793C061574;
        Thu, 11 Mar 2021 03:35:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=j0CoZewAw1TWkgGt0IV+Hpz2wChVlsz2EUkJ3HV24OE=; b=hI6WA+ji+j9Im7phV8IwxUv4uJ
        xoyAiuk/0KuLxS6r/F4vwgWpEybLL0xxQvzL1oDYT1Jidi79KwKr21DlDgIhS602scoN+6/VNeE5E
        NmoVlh6HYL3o8sC1y2H5W95izTjPYitLXctZG42VkTLvTsnpFz0LaCKa61a1LVwE+ZEOi8+qzI7/6
        r3+BpqOzxtBWBgx9e+Tva6Ip/dO5tTNHrkmVtL6r2nCfVt0IQgeo8UOP1cZM2zlSDOSkG9fVh2gZv
        4aXp6vtQNnvR3r4/1XEquXCbE5XPTuGrXUrbe3Jjs7G0aoheBS0uaS7apAChXiPKg3e1KUt8LfK4C
        FTS/2Y7g==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lKJbA-007Fqd-27; Thu, 11 Mar 2021 11:35:24 +0000
Date:   Thu, 11 Mar 2021 11:35:24 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Peter Xu <peterx@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        prime.zeng@hisilicon.com, cohuck@redhat.com
Subject: Re: [PATCH] vfio/pci: Handle concurrent vma faults
Message-ID: <20210311113524.GA1726872@infradead.org>
References: <161539852724.8302.17137130175894127401.stgit@gimli.home>
 <20210310181446.GZ2356281@nvidia.com>
 <20210310113406.6f029fcf@omen.home.shazbot.org>
 <20210310184011.GA2356281@nvidia.com>
 <20210310200607.GG6530@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310200607.GG6530@xz-x1>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 10, 2021 at 03:06:07PM -0500, Peter Xu wrote:
> On Wed, Mar 10, 2021 at 02:40:11PM -0400, Jason Gunthorpe wrote:
> > On Wed, Mar 10, 2021 at 11:34:06AM -0700, Alex Williamson wrote:
> > 
> > > > I think after the address_space changes this should try to stick with
> > > > a normal io_rmap_pfn_range() done outside the fault handler.
> > > 
> > > I assume you're suggesting calling io_remap_pfn_range() when device
> > > memory is enabled,
> > 
> > Yes, I think I saw Peter thinking along these lines too
> > 
> > Then fault just always causes SIGBUS if it gets called

I feel much more comfortable having the io_remap_pfn_range in place.

> 
> Indeed that looks better than looping in the fault().
> 
> But I don't know whether it'll be easy to move io_remap_pfn_range() to device
> memory enablement.  If it's a two-step thing, we can fix the BUG_ON and vma
> duplication issue first, then the full rework can be done in the bigger series
> as what be chosen as the last approach.

What kind of problems do you envision?  It seems pretty simple to do,
at least when combined with the unmap_mapping_range patch.
