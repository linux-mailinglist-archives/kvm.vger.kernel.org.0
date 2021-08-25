Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 045D03F6C91
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 02:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236318AbhHYAZw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 20:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236084AbhHYAZu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 20:25:50 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3588BC061757
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 17:25:06 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id e14so25295680qkg.3
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 17:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MY8I2mTPkke5gbeq2dgr19GP2LFyEyp/nnwxVE8HGWU=;
        b=GcEj/W445dhjXAzQI/pIL+Q4DwstaECKPGDmE/5t6GR9YH4IfTEOS5DPWQrz7WK1ys
         Q5uPC4eIy/XWTfPA3QY3WctSBG+ICqkQdnkDEdvg7bBwRIlpRiiJ7bgAOsDlHdu7r5gb
         vhLU13hbi40+XFDb3d6E6qoFDLaNeJjOPxVvtJUqeLxo1NtA07gI/+uOARY1pOz/GG9O
         RvOQmoCg2lI/5PI/rLhdSef6iIvnJTVGRquMh7zIh6ymsft2Wpgz2FjqRiAVeIvpCfRD
         8gPhGERQQKVjslYAZkDubRNpENOjzesFmgxmgeYDQCwmY6F1FRi7YVqRa55jtu+W5dVd
         Haxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MY8I2mTPkke5gbeq2dgr19GP2LFyEyp/nnwxVE8HGWU=;
        b=siEZzAKLcgdRdL8LlIEYB3CNvHBQrDxxTcyoOMvocGjPP3jyZzZj4h3erb5cDYG+06
         LQZsyNzAVQGwSers2KvnG8GsGPKxDG9b7MoydINMIzRrfFQQyoQHp0swnUiDjKlveO8v
         W36/pKpSNLZ+zjgDKlQJ8TVfGaHl+BkeBiVwaGs1Sg9XZXRq1cNoRpK36TsJ17wbVcVB
         0RBZizfRg4N7/rhoQeV6j850prgPB5FI0uCwJZqWPLNi4lFnOVwPDc6iv57pDFU4K+lV
         ML7AoE9PNc/wmB/KeyFAcEb002/rU4rd77iVoxpNImUiY0figmDzdrvtX/N0j7Qdezcj
         c3MQ==
X-Gm-Message-State: AOAM531mcA6+wdKx0D7Cd/PltcCpXMsci2tag3pwkkh1Xev+HzHDpJgj
        9Drq5WM1/64Yhx7ic20lSc0cbw==
X-Google-Smtp-Source: ABdhPJxFsFxm+jTW+wJBKvyy/8xMdwRYNWGtZ9SpXkxtkchhaqLzgwW4T8RaBjRxHo+Q+5M6wfvZhQ==
X-Received: by 2002:a37:a56:: with SMTP id 83mr29188797qkk.22.1629851105441;
        Tue, 24 Aug 2021 17:25:05 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id i67sm12054142qkd.90.2021.08.24.17.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 17:25:05 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mIgj2-004j6C-7k; Tue, 24 Aug 2021 21:25:04 -0300
Date:   Tue, 24 Aug 2021 21:25:04 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 09/14] vfio: move the vfio_iommu_driver_ops interface out
 of <linux/vfio.h>
Message-ID: <20210825002504.GP543798@ziepe.ca>
References: <20210824144649.1488190-1-hch@lst.de>
 <20210824144649.1488190-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824144649.1488190-10-hch@lst.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 24, 2021 at 04:46:44PM +0200, Christoph Hellwig wrote:
> Create a new private drivers/vfio/vfio.h header for the interface between
> the VFIO core and the iommu drivers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/vfio/vfio.c                 |  1 +
>  drivers/vfio/vfio.h                 | 47 +++++++++++++++++++++++++++++
>  drivers/vfio/vfio_iommu_spapr_tce.c |  1 +
>  drivers/vfio/vfio_iommu_type1.c     |  1 +
>  include/linux/vfio.h                | 44 ---------------------------
>  5 files changed, 50 insertions(+), 44 deletions(-)
>  create mode 100644 drivers/vfio/vfio.h

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
