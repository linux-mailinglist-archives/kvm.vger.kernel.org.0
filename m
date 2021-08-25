Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBA33F7500
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 14:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240715AbhHYMWc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 08:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240593AbhHYMWb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 08:22:31 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56279C061757
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 05:21:46 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id g11so19605796qtk.5
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 05:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WAz3siWMAeX+sT+8/4g01n9e1gFGKv6rZrHD5W5FCKA=;
        b=RuMOFqyfWmRRZbrFH7vvZJBL+w+JonfG6Wl3dCD25bunONFW9Uv6ihsSuvapVU80hT
         XNDeuJGc5niMs+GScBEpN3ZIvRAlZuALYXYEbIYk3+K+8h89P8L/TsBTUKbHoWvGToWR
         tcs8LZwjrThbFa3VMIPxxd/PhWrNe/JpHPc0XH5o1EbtGfeyU2hngFwkwHl6VIKIuULZ
         yBtzYmYYeSg+N6OUOT1Ie3ms+H1lorxWXwMiTimeRfaa0ZUONs5NLspD7NhWXltzeld1
         mqPy3E0jyrU0Bgi7ngX7nJKvstGIMa++6JJZVFbVwufpztYHkBaSFF0Q4tPBvap5f54i
         NV+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WAz3siWMAeX+sT+8/4g01n9e1gFGKv6rZrHD5W5FCKA=;
        b=OR6hwjxojHyBG/JmfbNjsDPIR5kdZd/AiFJRxiNUjuRF0hEOoVKR7uHoUpr10e9edl
         7Q12/R0/z9CVwaLmyif1PMjF1HGWnGKDQCaPPzsUSkZPeoxVkUbkP7ZDh6lKwX56tpkg
         6nqr+SzyBCX+T9oJHzq7cFLuhHjnSNF54hLG7WH0S0N30mPQjwx99Mn5P0HVN4vTK/3c
         yNdNZqUoIZnXKfI/r7jmDc63G0Bup+Hv4XgRpX4PZN+B5sbuMFvqSaOFZHw2NJh4xbbn
         7U2B6BjRUMYfXQqr42D5I9/W7jAYg0RSwguSbWeS+2WT1AjD9SlkSra9q6FYTjTZwEO5
         4brg==
X-Gm-Message-State: AOAM533DDDHs6OJETsxb6kb/ZzqdhE5iXaiBuTf3pRUg63OqPxhwgcUV
        lzCgT/2hqKVXGtt84d5ZBG75Nw==
X-Google-Smtp-Source: ABdhPJy1q4yNxoJnAcXokyACqmDNMgShSOl5WJwZRsuNTLnvM6qZmrIQNWRuzgqcnX/m1hmVOadZ8w==
X-Received: by 2002:a05:622a:100e:: with SMTP id d14mr3231043qte.350.1629894105523;
        Wed, 25 Aug 2021 05:21:45 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id y124sm12774640qke.70.2021.08.25.05.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 05:21:45 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mIrua-004sb0-5S; Wed, 25 Aug 2021 09:21:44 -0300
Date:   Wed, 25 Aug 2021 09:21:44 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 07/14] vfio: simplify iommu group allocation for mediated
 devices
Message-ID: <20210825122144.GV543798@ziepe.ca>
References: <20210824144649.1488190-1-hch@lst.de>
 <20210824144649.1488190-8-hch@lst.de>
 <20210825001916.GN543798@ziepe.ca>
 <20210825053237.GB26806@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825053237.GB26806@lst.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 25, 2021 at 07:32:37AM +0200, Christoph Hellwig wrote:
> On Tue, Aug 24, 2021 at 09:19:16PM -0300, Jason Gunthorpe wrote:
> > The mechanism looks fine, but I think the core code is much clearer if
> > the name is not 'mediated' but 'sw_iommu' or something that implies
> > the group is running with a software page table. mediated has become
> > so overloaded in this code.
> 
> I thought that was sort of the definition of mediated - there needs to
> ben entify that "mediates" access so that a user of this interface
> can't trigger undmediated DMA to arbitrary addresses.  My other choice
> that I used for a while was "virtual".  sw_iommu sounds a little clumsy.

vfio mediated is really some toolbox of different features that a
driver can use to build what it wants.

For instance Intel is looking at this concept of a mediated device
that uses PASID for the IOMMU. It would have a real IOMMU, use real
IOMMU page tables and in this language it would create some PASID
group, not a "sw_iommu" group.

This feature is about creating a device that is not connected to a HW
IO page table (at least by the VFIO iommu code) but the IO page table
is held in software and accessed by the VFIO driver through the pin
API.

virtual_iommu is somewhat overloaded with the idea of a vIOMMU created
by qemu and stuffed into a guest..

"domainless" might work but I also find it confusing that the iommu
code uses the word domain to refer to a HW IO page table :\

Maybe "sw io page table" ?

Jason
