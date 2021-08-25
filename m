Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7093F6C99
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 02:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236516AbhHYA00 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 20:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234259AbhHYA0Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 20:26:25 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2E94C061757
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 17:25:40 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id g11so18430514qtk.5
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 17:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=G1STUnUh9GpkDW1qjEN+qGthJk/N0+GVDnm/E0GIUyE=;
        b=S8ftITDLIdvVInm+UDtDu8ripR+pTpqQF/gqcMrzy9Rml5trRfdqQj69RKSUHBxZ19
         u+FZYYu1pv4c1lF85dqqvK9XlQX9UnPNUpDKdETssZvl1FWL+SABgZ3K6i/XdAu57VAz
         rTf0IbS3x1y2a/WuHXfjvHsx8iG0XsljXTxOftKyhuUhnarybucNWVi6Sq2Lg9nnWZki
         uu+BUM7Ag+voY+OClkbS5WDIELiTd42gVi98y5YSESMC5M20/Yx8pPeZH6EJ+IaE4pZI
         OwIuIBAdMpYHy9Dz0EKO/LbykBrXw8dKkOY3/SKYpHqqe4KD4i6dbaJILrOJHQmj5PXu
         r+GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=G1STUnUh9GpkDW1qjEN+qGthJk/N0+GVDnm/E0GIUyE=;
        b=A95DO4b04JSHqcv1OY6KbRXH7n7epZWIIvEd9pac/Kp28d46MP1tguFyEJec2vWcuE
         x3yNN5FXDgokiJr5p47cp143Q0WMK09+j5LXL5bSF7kNxSNVyP0hFCtuWolUh3mletwg
         O73W7y6p7zXn1ctc77CEODQXKW1BIf9l/H7h96gY7JiH/aa+UoAanPn/U01cHVIzWUSo
         InAWFHwvKRe2VkWW3vPwdsx6HIU/08rrOkr+TmRNfbBu8b0nSIL/s6vjSx0/zlvc6C79
         hoSfCztwMWinVzDm+QlD6QoBN5H7nrjiqAa/CYgyPpvBy/K8XPKLrZWsdD68f1uFRYQJ
         Ojkw==
X-Gm-Message-State: AOAM5318kJ8CDC7YAdQwH4NDt3Bl3Or7ldqG35MKGk5CbIBb0vABktqS
        RaA12UzKKVLCB/PkZQDSa8gtvg==
X-Google-Smtp-Source: ABdhPJx0cTht7hXmCLeOLGFGDWE8PUrMUnW3tGw1m6FmLFzQq5hG+0yQVDhG8axVjXJbuYcQ4YaXpw==
X-Received: by 2002:a05:622a:1788:: with SMTP id s8mr20779076qtk.59.1629851140188;
        Tue, 24 Aug 2021 17:25:40 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id q14sm11753637qkl.44.2021.08.24.17.25.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 17:25:39 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mIgjb-004j6e-4w; Tue, 24 Aug 2021 21:25:39 -0300
Date:   Tue, 24 Aug 2021 21:25:39 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 10/14] vfio: remove the unused mdev iommu hook
Message-ID: <20210825002539.GQ543798@ziepe.ca>
References: <20210824144649.1488190-1-hch@lst.de>
 <20210824144649.1488190-11-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824144649.1488190-11-hch@lst.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 24, 2021 at 04:46:45PM +0200, Christoph Hellwig wrote:
> The iommu_device field in struct mdev_device has never been used
> since it was added more than 2 years ago.
> 
> This is a manual revert of commit 7bd50f0cd2
> ("vfio/type1: Add domain at(de)taching group helpers").
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 133 +++++++-------------------------
>  include/linux/mdev.h            |  20 -----
>  2 files changed, 26 insertions(+), 127 deletions(-)

Right, this was for the imagined PASID support that looks like it is
going in a different direction..

Jason
