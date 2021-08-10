Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE963E5A85
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 14:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241005AbhHJM5L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 08:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237734AbhHJM5J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 08:57:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAA32C0613D3;
        Tue, 10 Aug 2021 05:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5xXVhemuKO9PB7xet9GYCusT0JhdoHtmk7yZ9MlgjsA=; b=T9Pq6HiHO2eGXiXU/rruKoAgnH
        ZccJwXam6hSvP5msWz1/meKVk9Qqqo21zp/o3ZINkWutqGZ3e/Ar6X4U+BVQybv6XisgC3ow6m2VC
        W21FvSRO8lbSuEAV/Vs5YLuu6XUTndV/oQZDJYlpaPVMzqB7FoRiuMVpDslbDhGL6wL4xU6das6yb
        rJn+F8gWfAz/icar+buwTckcidNFScAQDRr7Zv7xgLf52Y/AEa0UnwmLj3zpJgo+GYtZrxI1DVF/K
        qEyJXr5uFQZzgr1ivii4bwu/eeC5SybzFV1307mhSe1hjGSyFVfI5DQH7FitTyEAtoHkx98tiJJZS
        aKVL3ojw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mDRHY-00C7oL-Jm; Tue, 10 Aug 2021 12:55:14 +0000
Date:   Tue, 10 Aug 2021 13:55:00 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        peterx@redhat.com
Subject: Re: [PATCH 3/7] vfio/pci: Use vfio_device_unmap_mapping_range()
Message-ID: <YRJ3JD7gyi11x5Hw@infradead.org>
References: <162818167535.1511194.6614962507750594786.stgit@omen>
 <162818325518.1511194.1243290800645603609.stgit@omen>
 <20210806010418.GF1672295@nvidia.com>
 <20210806141745.1d8c3e0a.alex.williamson@redhat.com>
 <YRI9+7CCSq++pYfM@infradead.org>
 <20210810115722.GA5158@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810115722.GA5158@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 10, 2021 at 08:57:22AM -0300, Jason Gunthorpe wrote:
> I'm not sure there is a real performance win to chase here? Doesn't
> this only protect mmap against reset? The mmap isn't performance
> sensitive, right?
> 
> If this really needs extra optimization adding a rwsem to the devset
> and using that across the whole set would surely be sufficient.

Every mmio read or write takes memory_lock.
