Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46D0F37F751
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 14:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233212AbhEMMCN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 May 2021 08:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233061AbhEMMCK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 May 2021 08:02:10 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB9BC061574
        for <kvm@vger.kernel.org>; Thu, 13 May 2021 05:01:01 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id o27so25154363qkj.9
        for <kvm@vger.kernel.org>; Thu, 13 May 2021 05:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NJihL2Xw2lHhkxSxjm+gjn8CDqqOTmpq6YLn31gRVlo=;
        b=M8TgruUqCLhDzSxpaZE6ZcHOf7qpdfRsiP60D15PaB+xgLxnWTKx++sLGfwnuEY7cK
         uTYSf6cnwrBxnDipK3mbByMUjNzCtv1L/Oc0MBJlorr4NuoxvcGkikJ5BmLG8fbvE38K
         cwW6Vm2DWhlAD6Eowz2NJT8cl5tk+WTOTtU+xd01yaVbd5ckZ576ptV9N5Xs3i+gxPAw
         2lJz5jv2tvdGhWn/ak1dF0461aZaFpTVHnvAOx9H2sx1wXa9fA05Uxpg9Bwu5ECS9aek
         C6gecVqVy/zLo76dzPwDBYJVfNzm4wyZXebHd+I7rH6wm0Ah7oP8HeQv9jNhbqP1eekf
         KNGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NJihL2Xw2lHhkxSxjm+gjn8CDqqOTmpq6YLn31gRVlo=;
        b=HqlS4h25kf0FI9J1uS0iFSsev5OWvdBfGhCIZb9KCibtpxNsj15LqsqnPXAi6HSNbr
         Yo4wBcc9g/HUgj6FVz4s5HwLqdQ1ij1cunkeGMExd8CIOQWb7SPwR09jGZAKTzpXZIMR
         XFuccbhbavW//lZ8UnFD4gV3PV/Pyw2/Fg486RZ8GQ7HGAnnCPE40cBI/HlMF3I7n7Kh
         iJN3pOeButB7zHjnqdevDwZ7ZPNgHH7JwYlU0XJDbDqY5qHjyYtOPbNutc0ROW+8mqy/
         xrJm8WhRCU3++hy1cDJgzmrStPurjpJdZEfBN3lSz5iXo0u5G2A6VzuMui/LAxpAckqO
         yJ+Q==
X-Gm-Message-State: AOAM530vVN3N8SmW91l4BkcTlphGY59hdmJFcJsXyaWTa9R8/wTTd4cZ
        z3MIRfNR5JmbbqnGzN7vO6tFag==
X-Google-Smtp-Source: ABdhPJwdEODv0dV1RGQbKjSCOgnSJl/y5fEW7JnLEVOJ+y3Rq/nxRWKcs8mWpepP6QF3X0y4yh8XwQ==
X-Received: by 2002:a37:a301:: with SMTP id m1mr38481585qke.491.1620907260254;
        Thu, 13 May 2021 05:01:00 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-113-94.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.113.94])
        by smtp.gmail.com with ESMTPSA id b188sm2207623qkc.11.2021.05.13.05.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 05:00:59 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1lhA1S-006ntk-K6; Thu, 13 May 2021 09:00:58 -0300
Date:   Thu, 13 May 2021 09:00:58 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>, Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/6] vfio: remove the unused mdev iommu hook
Message-ID: <20210513120058.GG1096940@ziepe.ca>
References: <20210510065405.2334771-1-hch@lst.de>
 <20210510065405.2334771-4-hch@lst.de>
 <20210510155454.GA1096940@ziepe.ca>
 <MWHPR11MB1886E02BF7DE371E9665AA328C519@MWHPR11MB1886.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886E02BF7DE371E9665AA328C519@MWHPR11MB1886.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 13, 2021 at 03:28:52AM +0000, Tian, Kevin wrote:

> Are you specially concerned about this iommu_device hack which 
> directly connects mdev_device to iommu layer or the entire removed
> logic including the aux domain concept? For the former we are now 
> following up the referred thread to find a clean way. But for the latter 
> we feel it's still necessary regardless of how iommu interface is redesigned 
> to support device connection from the upper level driver. The reason is 
> that with mdev or subdevice one physical device could be attached to 
> multiple domains now. there could be a primary domain with DOMAIN_
> DMA type for DMA_API use by parent driver itself, and multiple auxiliary 
> domains with DOMAIN_UNMANAGED types for subdevices assigned to 
> different VMs.

Why do we need more domains than just the physical domain for the
parent? How does auxdomain appear in /dev/ioasid?

I never understood what this dead code was supposed to be used for.

Jason
