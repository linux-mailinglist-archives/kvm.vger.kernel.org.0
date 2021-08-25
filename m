Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02693F6C9E
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 02:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236149AbhHYA3h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 20:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbhHYA3h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 20:29:37 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63526C061757
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 17:28:52 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id t4so10915248qkb.9
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 17:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tzS0Kc+C9vlR3sIQcEp3WD3mtmOCk6HGUfpviC79/7s=;
        b=eQEGM5vEfcdvQcArsIXwRSdq4R0KuwK9QbMowefYndKA4uGgSvPCueDJCZKpyGBcbf
         Dp2kJCkSuuBe7vv7E8ofNQjy01vSFobh33FISOjGCqFVxbEtigDJp94E4hKL3/ebVOE9
         aC/O2hCGD5mhRiMHPgjKkla9gHfqH7uPe7E2K9E5vEvA4FtT1DZ0rpPx9kmbTMZloBhG
         jRWsczuR5WcygRYViEx8dn7sH88qcvo7jc0AVZywrGobs9hCUkS8fEZgDaHE0n23DHWX
         ljoSqn7q6wdVjQlyEtJk1ANlm1QaCtc0WEADT89WKjv8MCIBb/zYVMZJcHzHB6t3DPHL
         wB0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tzS0Kc+C9vlR3sIQcEp3WD3mtmOCk6HGUfpviC79/7s=;
        b=fE5ce1LZEW2/uHPl7NFJdVxPNSccAq/+MPBiljfDy59zQ2e86HmuKbI5ak+Ztwpm9G
         GY7Dbh2TPiMEUVdZGrqxQfzOLKpNXAZY24U/OiaYbogNu6lJBCsuyXz5KAKIPKJORy7H
         I1kDEimjCAL//rjKwms30ReVH8xDL+JCN04Jg2PHUrTo4tZSQ5BQmUx4VqyM/TBSpF6C
         xWbes8IUHBie3VSAhrhSGEwux6KUTWsXFdW09bYvTTmZc6qmKAoczAzrgWcSOaXoKWhT
         BhODHsxrc5WSf2qqWuJZ//mC4CDJdxg8vZ23Zm9A8jYZpFj2bRIhfu59lG8qDDzP+ZyF
         yCkg==
X-Gm-Message-State: AOAM532wWgaJtr68HOxuUDR/ShXz3R2fjBJzxibLKIszANtx003TKLDm
        IQmh0MQytw+3/mUok6OluDWi3w==
X-Google-Smtp-Source: ABdhPJw99PZErs/C98Hz2xQoCubxJuyY1G4xYP666w5TpvyhQWlviKnlCfAdmRB9Wb2AtCow+eXYag==
X-Received: by 2002:ae9:e915:: with SMTP id x21mr29407890qkf.183.1629851331641;
        Tue, 24 Aug 2021 17:28:51 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id g13sm3704986qkk.110.2021.08.24.17.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 17:28:51 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mIgmg-004j9n-Jl; Tue, 24 Aug 2021 21:28:50 -0300
Date:   Tue, 24 Aug 2021 21:28:50 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 11/14] vfio: clean up the check for mediated device in
 vfio_iommu_type1
Message-ID: <20210825002850.GR543798@ziepe.ca>
References: <20210824144649.1488190-1-hch@lst.de>
 <20210824144649.1488190-12-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824144649.1488190-12-hch@lst.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 24, 2021 at 04:46:46PM +0200, Christoph Hellwig wrote:
> Pass the group flags to ->attach_group and remove the messy check for
> the bus type.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/vfio/vfio.c                 | 11 +++++------
>  drivers/vfio/vfio.h                 |  7 ++++++-
>  drivers/vfio/vfio_iommu_spapr_tce.c |  2 +-
>  drivers/vfio/vfio_iommu_type1.c     | 19 ++-----------------
>  4 files changed, 14 insertions(+), 25 deletions(-)

Every caller is doing group->iommu_group, maybe change the signature
to

 (*attach_group)(struct vfio_iommu *iommu, struct vfio_iommu_group *group)
 
?

Then the flags don't need to be another arg, just group->flags

Happy to see the symbol_get removed!

Jason
