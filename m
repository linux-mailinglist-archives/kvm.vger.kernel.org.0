Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC89E3F6C3F
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 01:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233422AbhHXXbv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 19:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbhHXXbu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 19:31:50 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D65C061757
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 16:31:06 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id e3so12159572qth.9
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 16:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l/6Q+VNZskkmpCV+CZcRjpUr+q66G0ecgsXvBNs1XHY=;
        b=kemE2xqpT0wvpkH9Kb8vaL9DNTi4KlkrCVegTR1WivlZfLbc/EHnKPXGijEG+8VIyZ
         5rROze6DuhXmIAsuM5oBUuuXZ32fq9+lXM8qmw2YmVbHkloSHD+DZBCp7kn+7ApdEiq/
         epPL7JVJ9r/w7HxMfRzqDmezuPTYXsUvf83RlRWrVSEBh9F6MtyYqqAN4gHaXVNlkVzC
         fbYdjeMheo4MaJ6QRu8rZbxyWUKVyZSSqygQIyXKLDd3mu7GPOLGjmP5PpyMxkjdoeCQ
         wQsO8SJLhfq1jIF/L15coTkHPuxikhBx9ebQ/PjLsXZDx+lV/GmmekIaFJfzFH3JJLPZ
         s1xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l/6Q+VNZskkmpCV+CZcRjpUr+q66G0ecgsXvBNs1XHY=;
        b=StDJNW+wQSajF4rFZKBKK2PMxUoDnVZEYh51VM8jbd7QLGe7TxlIb3YiiFcfvRm0/S
         e/Jm8+jIlMSLwpAJT9Kcg6aVphUUr81z7zstiFZahXLGrmI3KJ5b440i4EcwfQGXIVv4
         mHgomHfpRaPYkNdAwXg6VqACiOkGR+0/bFDecRCvsqUG7Au6HmkEEoddaFyH99PBcNrd
         J/gYUIgLt9XJZ65kM28KYFIg3QtlDBPdseJocHLAHTdexY0gRQSEG4cgKyUwyY/KRHsM
         GRT38/QE6C0EQe9UtYRQCK6LTWPi1yzRPJXImTQwh2k1ch6JKWLb9kvZunPOf9pCYP44
         9qQQ==
X-Gm-Message-State: AOAM531xZUQgIbEzLlK30YWg9EX6JhVDG66ORImY4TxMsAewRB1q0U5F
        MrFgwzS0JE0KfdnaT9hTn5mZ1g==
X-Google-Smtp-Source: ABdhPJw1ZRL4sdvbSM2qpLfqWSsihqnqdgoQD686dGos870VeqcXrNFEZxqYumiFM/CfdFDGfuH1Bw==
X-Received: by 2002:ac8:ec4:: with SMTP id w4mr37887659qti.30.1629847865330;
        Tue, 24 Aug 2021 16:31:05 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id r18sm9170227qtm.96.2021.08.24.16.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 16:31:04 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mIfsl-004iJv-UR; Tue, 24 Aug 2021 20:31:03 -0300
Date:   Tue, 24 Aug 2021 20:31:03 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 03/14] vfio: remove the iommudata check in
 vfio_noiommu_attach_group
Message-ID: <20210824233103.GJ543798@ziepe.ca>
References: <20210824144649.1488190-1-hch@lst.de>
 <20210824144649.1488190-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824144649.1488190-4-hch@lst.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 24, 2021 at 04:46:38PM +0200, Christoph Hellwig wrote:
> vfio_noiommu_attach_group has two callers:
> 
>  1) __vfio_container_attach_groups is called by vfio_ioctl_set_iommu,
>     which just called vfio_iommu_driver_allowed
>  2) vfio_group_set_container requires already checks ->noiommu on the
>     vfio_group, which is propagated from the iommudata in
>     vfio_create_group
> 
> so this check is entirely superflous and can be removed.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/vfio/vfio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
