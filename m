Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643C53F6C7C
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 02:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235670AbhHYAWb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 20:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbhHYAWa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 20:22:30 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0359C061757
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 17:21:45 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id bk29so19537119qkb.8
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 17:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=X3WO1izL8QwIGub1BXTLkxsxs+ZNAnd9CKCli1HdSVQ=;
        b=INmvdU4dmsf9CfV5+w6ns5DkWhPAgfMxJjtk3OChUp4y/cKPc/8gFEk85JNo4gC4d4
         GgGXOwlv7R4Gw/Vwi93w9HCC1/sfERiH2eLi4VlBI5/MJvBOCWQe7RRIscnqeNkoAx4D
         Szpjjxmu+UGijE4T5bmdMo7FKccH0rq3ywMD92G12tZnhwE7KQL/CHnRyAfHSm2DD6re
         lXi5ufamQpgGvRTPrStBCiQ8QndAmjC5i2snmN0Mxagucc6idJg3HXvnj0qru1k/gvjl
         MB35sHwjc+SVAhpDgA46RD2G/Fd8r4fsselCuUyOTg+/8EA/FKvY6+NxD0J19HFOQDbO
         89Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X3WO1izL8QwIGub1BXTLkxsxs+ZNAnd9CKCli1HdSVQ=;
        b=EnlPUJzJBBGq0FIupachnpJV1zse6DkjUhGGvqxfPYlowWujkGYZ4PRxV5cowFu0oB
         Huls6VeTwU7COsYg9k3H2HrviLl7zXi6tqEgHQ38NXZWDuiocQfX9pnLOiIGRhpEBj1E
         rXgSVqMQ5p/qsasMqSEAlo6C7yJ4tYZUcITJbymDAIXCZ3e2uiB69UlR/EFoaHsDBkuy
         hcEI+odswnEcMKI6vTjESzWw6o3Oh1dvEQcHm502K6GZjViqskdN/LrZvPbTCPWvqqk/
         SycqwPNgJWa4c3vnlXGauubzlQQV5QtDU37Vk3+c3fHcfmueMu3+oPj1kCNDrtrXWq+i
         SQIQ==
X-Gm-Message-State: AOAM531ajXeggZrt8V0rQ/BGkub0u2sKky2uPIfpDLpm4K3y0toDx73d
        FhMQELitX33Rd6FyxTpb7CGPMw==
X-Google-Smtp-Source: ABdhPJynV960DIlmmfdloryH1d25Wo4MUEIrKAQoCGlbU888L/S1AbsmE0/25u0+u6LDe/BhirHq+Q==
X-Received: by 2002:ae9:df07:: with SMTP id t7mr19537016qkf.95.1629850905044;
        Tue, 24 Aug 2021 17:21:45 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id g20sm11700937qki.73.2021.08.24.17.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 17:21:44 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mIgfo-004j2s-2X; Tue, 24 Aug 2021 21:21:44 -0300
Date:   Tue, 24 Aug 2021 21:21:44 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 08/14] vfio: remove unused method from
 vfio_iommu_driver_ops
Message-ID: <20210825002144.GO543798@ziepe.ca>
References: <20210824144649.1488190-1-hch@lst.de>
 <20210824144649.1488190-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824144649.1488190-9-hch@lst.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 24, 2021 at 04:46:43PM +0200, Christoph Hellwig wrote:
> The read, write and mmap methods are never implemented, so remove them.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/vfio/vfio.c  | 50 --------------------------------------------
>  include/linux/vfio.h |  5 -----
>  2 files changed, 55 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
