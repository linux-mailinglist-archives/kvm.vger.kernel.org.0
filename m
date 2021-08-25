Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8442F3F7E9F
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 00:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232179AbhHYWdY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 18:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbhHYWdY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 18:33:24 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD77C061757
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 15:32:37 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id t190so1205668qke.7
        for <kvm@vger.kernel.org>; Wed, 25 Aug 2021 15:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MGG/j9fZvH/MpJ191HmeeDX9+0/giSgQeimiAnhel0M=;
        b=Tu9fCWy9jCAvXR4qZ5KVV3aPFVTpJ9O+ZC0QSsLA1vaZACEPU1x6ZeP63xTMF3Wp8m
         miq2fe3m/ZSy0RvKfDwNjEPGrZdmtDksJR9QjTJHpyOi8YomximqehzFc7HA7BY7fgu+
         I6zaYlLc9QT/V0Jqsr5/hoQOJpGD0DOtRCjWRtfPcjgO3F/rbLvW8dYyC5rjxDBxcJyS
         Aq6udP/RGz1aAl8fSX0LThu5GpY5fikiPnIsKCxDPnBoFpogRCZ2jrt31bvJsMA8lD02
         +6Ud3u3cahbS8ZNUZgMjx1BIX3ZIZ+1bO7E8c17AwmXWjNUMSDNfvFoUunN+Wlg3WP/m
         brrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MGG/j9fZvH/MpJ191HmeeDX9+0/giSgQeimiAnhel0M=;
        b=AKAroi9AGnLxfqDaTZHL05GKb2wpFjVMYbFOs/72abpkwPHgRJtM1HmFiLZtmEmJt6
         XwKgRJwrOf124VwsgmNwhn3BqZVnm7pVogLhQaonHKX6qgakPUT4W/k8O3s/in90HARC
         uGmIKXvzg5v41IPXu93gkgPf0se/keKXaSqD2zfkuyRyl0PfkkODOT5mB/jKgb8gVM7v
         rtqtPyv6a9TIxLLI+l5Ed/zQLUfxKqgxCj4qhqJtnfytQ+70VirTQj1wjcrBr0yz/zl1
         lnlmKswmB43iYrtDHWfkcHH+UGxv9XnPPT4xHqSwK14jiD9NF+OspRE+vw0+c5tmr5b9
         7tuA==
X-Gm-Message-State: AOAM5312TZ0uuNIoBEsOnLVbwZuog2rKqzIbgf7AZiZY0S+FVKvYdOG3
        SscFUZVVtsE0ZhBuDrTjZisf0v+pj/NHnw==
X-Google-Smtp-Source: ABdhPJz7OlPTkRT+y+UToTpl5Y1QGL/n6I4zeX9HJMcKclNsiM9/QXnFSKZl44cjxxWhDQWUvkkMHw==
X-Received: by 2002:a37:4141:: with SMTP id o62mr861841qka.380.1629930757039;
        Wed, 25 Aug 2021 15:32:37 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id s10sm1025152qko.134.2021.08.25.15.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 15:32:36 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mJ1Rk-0057Qf-3m; Wed, 25 Aug 2021 19:32:36 -0300
Date:   Wed, 25 Aug 2021 19:32:36 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 10/14] vfio: remove the unused mdev iommu hook
Message-ID: <20210825223236.GC1200268@ziepe.ca>
References: <20210825161916.50393-1-hch@lst.de>
 <20210825161916.50393-11-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825161916.50393-11-hch@lst.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 25, 2021 at 06:19:11PM +0200, Christoph Hellwig wrote:
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

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
