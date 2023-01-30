Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D82A4681A7E
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 20:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbjA3TaA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 14:30:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237821AbjA3T34 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 14:29:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 007CD4C29
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 11:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675106946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kMw/XElnCxdmLp42oBJRMNFt89bRqi3exLedbUEk6Ms=;
        b=JHrD+xnuKSJqKOLgZds9u2KKHiCgQxjqfeQmjPJ7+YkYIftJH89T4v9kNovMBsomWwkQgA
        nXob09KtJUnY2gO3GTbb2Vix+WARg9g5K+PqLC8nzP/nqAVNFHOaCIdCuQYfhwq626O7sP
        QNqIMK0e5w4lrLRnplXik1wl6QiEPEc=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-530-crW9LsoyNhqgTyaNd2aYmg-1; Mon, 30 Jan 2023 14:29:04 -0500
X-MC-Unique: crW9LsoyNhqgTyaNd2aYmg-1
Received: by mail-il1-f197.google.com with SMTP id s12-20020a056e021a0c00b0030efd0ed890so7884843ild.7
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 11:29:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kMw/XElnCxdmLp42oBJRMNFt89bRqi3exLedbUEk6Ms=;
        b=UIJgadZWXhX/hbaEu2cxgWJjXsQiKyJBfq5aRDz36scPiLrc67tWG0sJsO1rYXFcnL
         OwEguSa6FWVqNqg/ry2YWMZfrLhW6oTAU0nmoOpEij4EoZmIWTsL1n9xZlu10PeNCZkc
         c3ka73CUwLR+VSjSQJW1NWDu7yHpmZzJMad2Me4Dj45l2RJ3MBcIvQ9jfJOjCyLWapoH
         bbA/LEUJs0CPyy2/ttt4QafltmPxR1yokZ8wWTufnw3YZlnzSpjNcTleK3kmMz2VvIsV
         xg3fIfrzLTgLVfSU70RdGGGTt8HQlxmbu8kpqDkceDPjwnhAzpx2rNjQSSNmURTDZsHT
         2Jmg==
X-Gm-Message-State: AO0yUKUUDV4/e7KFYr6rwdpQ+A6gk4BpQk4IjQadZNkoxYP5ugeSDtgb
        VC0MwR7yVuY4vHr4qm2BXwSJfTUflMcg4lI6m9Fls96ubHqfSR1um62Q+c4vGqG0RSQ4oVSEeDR
        QT2NPvTQbhSaE
X-Received: by 2002:a6b:b502:0:b0:71b:4ff1:8b65 with SMTP id e2-20020a6bb502000000b0071b4ff18b65mr3257647iof.20.1675106944053;
        Mon, 30 Jan 2023 11:29:04 -0800 (PST)
X-Google-Smtp-Source: AK7set+JhLwG+4uNghaktgYIvfj5Eaa7V5ujje6ekVHXlMk8M7KoAq74HIqfWN54rhVkCtWE9U8zlw==
X-Received: by 2002:a6b:b502:0:b0:71b:4ff1:8b65 with SMTP id e2-20020a6bb502000000b0071b4ff18b65mr3257635iof.20.1675106943827;
        Mon, 30 Jan 2023 11:29:03 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id s12-20020a5d928c000000b0070b32c4e242sm4468133iom.31.2023.01.30.11.29.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 11:29:03 -0800 (PST)
Date:   Mon, 30 Jan 2023 12:29:01 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v3] vfio: Support VFIO_NOIOMMU with iommufd
Message-ID: <20230130122901.5baff572.alex.williamson@redhat.com>
In-Reply-To: <Y9gMZmvFDOW5LaWv@nvidia.com>
References: <0-v3-480cd64a16f7+1ad0-iommufd_noiommu_jgg@nvidia.com>
        <Y9gMZmvFDOW5LaWv@nvidia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 30 Jan 2023 14:28:54 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Jan 18, 2023 at 01:50:28PM -0400, Jason Gunthorpe wrote:
> > Add a small amount of emulation to vfio_compat to accept the SET_IOMMU to
> > VFIO_NOIOMMU_IOMMU and have vfio just ignore iommufd if it is working on a
> > no-iommu enabled device.
> > 
> > Move the enable_unsafe_noiommu_mode module out of container.c into
> > vfio_main.c so that it is always available even if VFIO_CONTAINER=n.
> > 
> > This passes Alex's mini-test:
> > 
> > https://github.com/awilliam/tests/blob/master/vfio-noiommu-pci-device-open.c
> > 
> > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/iommu/iommufd/Kconfig           |   2 +-
> >  drivers/iommu/iommufd/iommufd_private.h |   2 +
> >  drivers/iommu/iommufd/vfio_compat.c     | 105 +++++++++++++++++++-----
> >  drivers/vfio/Kconfig                    |   2 +-
> >  drivers/vfio/container.c                |   7 --
> >  drivers/vfio/group.c                    |   7 +-
> >  drivers/vfio/iommufd.c                  |  19 ++++-
> >  drivers/vfio/vfio.h                     |   8 +-
> >  drivers/vfio/vfio_main.c                |   7 ++
> >  include/linux/iommufd.h                 |  12 ++-
> >  10 files changed, 136 insertions(+), 35 deletions(-)
> > 
> > v3:
> >  - Missed kdoc
> >  - Incorrect indent
> >  - Consolidate duplicate code into vfio_device_is_noiommu()
> > v2: https://lore.kernel.org/r/0-v2-568c93fef076+5a-iommufd_noiommu_jgg@nvidia.com
> >  - Passes Alex's test
> >  - Fix a spelling error for s/CONFIG_VFIO_NO_IOMMU/CONFIG_VFIO_NOIOMMU/
> >  - Prevent type1 mode from being requested and prevent a compat IOAS from being
> >    auto created with an additional context global trap door flag
> >  - Make it so VFIO_CONTAINER=n still creates the module option and related machinery
> >  - Comment updates
> > v1: https://lore.kernel.org/all/0-v1-5cde901db21d+661fe-iommufd_noiommu_jgg@nvidia.com
> > 
> > Alex, if you are good with this can you ack it and I'll send you a PR. Yi will
> > need to rebase his series on top of it.  
> 
> Alex are we OK?


Sure.

Acked-by: Alex Williamson <alex.williamson@redhat.com>

