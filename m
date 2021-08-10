Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3555C3E55F4
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 10:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238311AbhHJIwU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 04:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238301AbhHJIwT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 04:52:19 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A55AC0613D3;
        Tue, 10 Aug 2021 01:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5HFVU4zKvq7KOn2kbFJ3SlnKg42hr+xQZyP+w5iBMjs=; b=Pri6jt6Ntz8OhzO1q8kXc8wB4L
        NXgTPuNxkc4hPjCIQwUZeQjTZpQWGnLiEyhxYGL4To+pCTHiSupbU+UDbtdDcwgQCvK3VkulEbR92
        cemTTqGqYHFLK8WfnnuoqLi1UNW37APPfY4dgiyFUueSS/HHm8MWCWMGBl1e6FUbFsvPM5BjSkJ4+
        lXYDb5E5P9qNOuj0OIC6aCvG3qugYeUDODRNNvU1VQQQexSbIOLaZTOKv4Ejl/8QrYRyPojvlmzXe
        qpQWpvHKAMAXrC/xl0wcgZOQiow1HEBJwJxz4BuGC5212oDSWrwgc18Ci39e+Z0w586dHaJQWsVZK
        gP3OTwZQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mDNTX-00Bukr-Pu; Tue, 10 Aug 2021 08:51:23 +0000
Date:   Tue, 10 Aug 2021 09:51:07 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, peterx@redhat.com
Subject: Re: [PATCH 3/7] vfio/pci: Use vfio_device_unmap_mapping_range()
Message-ID: <YRI9+7CCSq++pYfM@infradead.org>
References: <162818167535.1511194.6614962507750594786.stgit@omen>
 <162818325518.1511194.1243290800645603609.stgit@omen>
 <20210806010418.GF1672295@nvidia.com>
 <20210806141745.1d8c3e0a.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806141745.1d8c3e0a.alex.williamson@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 06, 2021 at 02:17:45PM -0600, Alex Williamson wrote:
> > Now that this is simplified so much, I wonder if we can drop the
> > memory_lock and just use the dev_set->lock?
> > 
> > That avoids the whole down_write_trylock thing and makes it much more
> > understandable?
> 
> Hmm, that would make this case a lot easier, but using a mutex,
> potentially shared across multiple devices, taken on every non-mmap
> read/write doesn't really feel like a good trade-off when we're
> currently using a per device rwsem to retain concurrency here.  Thanks,

Using a per-set percpu_rw_semaphore might be a good plan here.  Probably
makes sense to do that incrementally after this change, though.
