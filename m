Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA30379329
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 17:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhEJP4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 11:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbhEJP4D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 11:56:03 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BF0C061574
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 08:54:56 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id z1so8586779qvo.4
        for <kvm@vger.kernel.org>; Mon, 10 May 2021 08:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dKnE93StZsqCunlDWqAom0kQB6W55N5BaGWqotQGVUE=;
        b=nuCBcs9/S1aTLECuWcN5h85qoqBaLLtCmy8zbuhR+zPZIMDw77L3oRAU7xMeuDuh42
         1aY3lX4gkaR/KbePkX7G1aB4Tpotsrq6rAP9gAhtcsTRhc0Gr01HHPgz83z/GnxJGBsg
         Bgm+850D+Iu3fWcIhJnyleMndHaJU8eu5R+J7ww9ibnhcQrnYmdXCBCA/riNKAbRtSll
         l1yAaUuiGbs9mNbvE3XsoU7M2UC1x/oM1anr+WkEwv0XXzudrTewGREVjZScvyVEfQdQ
         cELamVl6RymHsUL1VXH8Yvje4DNltTqqC+G2U/5otju6aAnXdj/94+nc1C46u8eQdS8I
         heCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dKnE93StZsqCunlDWqAom0kQB6W55N5BaGWqotQGVUE=;
        b=rdYig8fvxSfAnobjyiZYNIgDi3ZkFiwEoGZb4mZTXikjPqhrXEzbHHCFoeUL0lgrnf
         etOlgbzLSjwK+JPCiUAixtaKOFq2b2IitiBPwl7aDT4YMx1HJsJfJyXRMorxAsbZ6c6/
         v74Lht2+6tFv7K28ImjiwpO7YPjsVfCHHaGCDVfhQCixkHYkkjoVB9GyweXpEf54RYNL
         W/FugOYgoiEWDiQ4QVqwbvnMSC458QSQUZ+mHDBLXUgisEDFvy8lA3RJgdmM8h5oCuxy
         BtNY7u9m7a1AZCOflouARKMHW+AzsVqhIoFiq97EFSyPR7wLwZ4KRgPHS67ytmoqLh5u
         aHbA==
X-Gm-Message-State: AOAM533cRP4weGKismPw6fnZckiGlMcKfSjtMuoARUyI6CcS30lY7lfE
        4fMA+siptN0DM5uyR9E/ahwRmA==
X-Google-Smtp-Source: ABdhPJxmEWE6l8G4ddQYCJA3Ydglf+qOUGmIWRC1Z06kUQgptb6+ijWYRVzLErmdhwjQdbwCc1sh8A==
X-Received: by 2002:a0c:bd8c:: with SMTP id n12mr2852029qvg.29.1620662095910;
        Mon, 10 May 2021 08:54:55 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-113-94.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.113.94])
        by smtp.gmail.com with ESMTPSA id g185sm11814969qkf.62.2021.05.10.08.54.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 08:54:55 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1lg8FC-004bOW-Vr; Mon, 10 May 2021 12:54:55 -0300
Date:   Mon, 10 May 2021 12:54:54 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH 3/6] vfio: remove the unused mdev iommu hook
Message-ID: <20210510155454.GA1096940@ziepe.ca>
References: <20210510065405.2334771-1-hch@lst.de>
 <20210510065405.2334771-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210510065405.2334771-4-hch@lst.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 10, 2021 at 08:54:02AM +0200, Christoph Hellwig wrote:
> The iommu_device field in struct mdev_device has never been used
> since it was added more than 2 years ago.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 132 ++++++--------------------------
>  include/linux/mdev.h            |  20 -----
>  2 files changed, 25 insertions(+), 127 deletions(-)

I asked Intel folks to deal with this a month ago:

https://lore.kernel.org/kvm/20210406200030.GA425310@nvidia.com/

So lets just remove it, it is clearly a bad idea

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
