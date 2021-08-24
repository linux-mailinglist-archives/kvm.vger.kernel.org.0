Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF5F3F6C4F
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 01:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234218AbhHXXoL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 19:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbhHXXoJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 19:44:09 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD8B3C061757
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 16:43:24 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id g11so18361930qtk.5
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 16:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l4iKy8AdsMkh2tUYA9fH1OSgTMNNzf2itCWkC7it1fY=;
        b=keyF7qq0TiXarQqf6zXLi7//XMXrx4l4paYin+aPleUb3CY6udSMLX/Ewaxrc3/rhU
         Ls8B0jp4eAY9mpcbqU1BssmWhgIMlT4JAhwej4QsH/Skrht9cXZEdsC1m8xYOQ4HY9AQ
         7dLHY0b8ALcNHuHNavRNjbam7oPwOtUT29ZXUK6Dc/RAOKBTRWtWQ3ufZFANg1CG4xmX
         YAmvRRjlBhGtKixJQOaJTdN9OWkSv6iLKkCdXAsk+Oq6+6Rnwqqt5AdZNeUyOy7H3UOB
         nsrVSNASO8FmJ2xHN+F0quagcrLas0aSONFmTjFntlE9G+T0MejliRbtYq9etrt+/L/x
         Jm9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l4iKy8AdsMkh2tUYA9fH1OSgTMNNzf2itCWkC7it1fY=;
        b=bWy4ftBC+CKy+bhgb7juv2RR+uVjCFZEX7hES+htheCw8fFYNIx3bxWvfXMvG+5kbP
         RDi5desM1cjQ9Js787IPtigbhqO+4KVeqvb2jf4fxt0reWiXMSnJ3UDylw+2mR855mC1
         pipYmgm9Y79DRv+wpnLizcdBBnQCXFyxHh36+wuhpz7YsqEWFOxz93G5yUq0q/Kv+gtJ
         kfPwiDjVSWmA7aidKAQJM0ds8XqJFLeVW239SoDEEsE2iUeleJMS/ltXKrNqk6OEGzUy
         XQld9Eh4Qtj22cbOq5DoZ6nWwfdRJxPFD/jjF/IahWBctgDDf7rfoAK/cIFn6k1stxTN
         Onow==
X-Gm-Message-State: AOAM532UN/PrSmFCFFMnOq8Pk+3DjTWX8sWRL43zCh4Kp/XB03ynTLCt
        i/1xFavAvVPjRkKheiY6sCoESA==
X-Google-Smtp-Source: ABdhPJyh8avDPGcXxgOrPr0fontyaf7079cGJvVnUN++x6eNBXzF0FWzPF0Xn3O26ArhT9N8dkHlew==
X-Received: by 2002:ac8:70b:: with SMTP id g11mr37229860qth.387.1629848603624;
        Tue, 24 Aug 2021 16:43:23 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id z6sm11673388qke.24.2021.08.24.16.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 16:43:23 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mIg4g-004iTb-K7; Tue, 24 Aug 2021 20:43:22 -0300
Date:   Tue, 24 Aug 2021 20:43:22 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 05/14] vfio: refactor noiommu group creation
Message-ID: <20210824234322.GL543798@ziepe.ca>
References: <20210824144649.1488190-1-hch@lst.de>
 <20210824144649.1488190-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824144649.1488190-6-hch@lst.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 24, 2021 at 04:46:40PM +0200, Christoph Hellwig wrote:
> Split the actual noiommu group creation from vfio_iommu_group_get into a
> new helper, and open code the rest of vfio_iommu_group_get in its only
> caller.  This creates an antirely separate and clear code path for the
> noiommu group creation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/vfio/vfio.c | 100 +++++++++++++++++++++++---------------------
>  1 file changed, 53 insertions(+), 47 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
