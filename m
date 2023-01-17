Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61E33670E8D
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 01:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjARAY2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 19:24:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbjARAYD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 19:24:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39FEC2312D
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 15:38:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673998696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TCBdlBJNdmbwC3QjgMYxTqXDEbjetxbmhE0qTYgBydc=;
        b=Q2pG1gijKz5BBTF17Wi0fW6HNqpmdVd1AmYRgSgej9BvXWiua+LNDBnZXTHcIcYcvbM9Y4
        O49LBh/Lqe9Q/ZjEs1xSGCWFk2KvYVpm/cLvKXQANK/qD/Rxn/mO1c7nmIP8B3HZBAlhsI
        LIWYo3VG+iyPFglMjlIHHAmFs4A1oLc=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-292-TG3LIPZlNsq9iOug2YKr1g-1; Tue, 17 Jan 2023 18:38:14 -0500
X-MC-Unique: TG3LIPZlNsq9iOug2YKr1g-1
Received: by mail-io1-f70.google.com with SMTP id b21-20020a5d8d95000000b006fa39fbb94eso20210909ioj.17
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 15:38:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TCBdlBJNdmbwC3QjgMYxTqXDEbjetxbmhE0qTYgBydc=;
        b=Z1J0O6tFKsRRColLpewpJDqS6fiIMvorJ2N1lsWn/tXLjHSXIbwZnPlRrhSY2FxnMe
         prjdwDDMHHy0ptPSbVYaaqCAxMzEOHTgH3LN6un2AMot6ESLZfDpCt6DhrWcRCCPOMIo
         d01ISACQos89PhJlEucgav2gq9TfaMuZsSPDckZteeYr1pYV4O1Bt4vPWKDzlL8PNFLH
         fGQwyy8F2P40eNSFOPDZQXda8xjNZW1y9N8rlvgV0K3t5xq8XSBs8vtytmzWv/HVIHU4
         5DbzKUEfZd0IqncUiU1036mry4R7zyuDFsAKGiivX593aXtWHFM2sxzms5PW5bfIiWaj
         7Pyg==
X-Gm-Message-State: AFqh2koXr23842Zkst5D5zCHol/NHrDe1SowpUuDZ1FGywyUQ9eMQRXM
        WXArWNFyx865ng53fizHXMhYkLVDGN9wh5nAdn1nNpwhiogwbOXQZ2uL0WnIyNipQ+e34HBUrA8
        3a6+DLLoEyj7o
X-Received: by 2002:a05:6e02:be5:b0:30f:1cc:d14b with SMTP id d5-20020a056e020be500b0030f01ccd14bmr4264398ilu.0.1673998694179;
        Tue, 17 Jan 2023 15:38:14 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv3MvNN/zHAZtBEsEXvR7KudEBMPCye4G8ZAL2tcAMHzzjVqjvnc6sIW/Zo4LZHQnAfuaYWfw==
X-Received: by 2002:a05:6e02:be5:b0:30f:1cc:d14b with SMTP id d5-20020a056e020be500b0030f01ccd14bmr4264385ilu.0.1673998693915;
        Tue, 17 Jan 2023 15:38:13 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id h18-20020a02cd32000000b003a2d93487easm2961179jaq.38.2023.01.17.15.38.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 15:38:13 -0800 (PST)
Date:   Tue, 17 Jan 2023 16:38:11 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <diana.craciun@oss.nxp.com>, <eric.auger@redhat.com>,
        <maorg@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH V1 vfio 0/6] Move to use cgroups for userspace
 persistent allocations
Message-ID: <20230117163811.591b4d6f.alex.williamson@redhat.com>
In-Reply-To: <20230108154427.32609-1-yishaih@nvidia.com>
References: <20230108154427.32609-1-yishaih@nvidia.com>
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

On Sun, 8 Jan 2023 17:44:21 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> This series changes the vfio and its sub drivers to use
> GFP_KERNEL_ACCOUNT for userspace persistent allocations.
> 
> The GFP_KERNEL_ACCOUNT option lets the memory allocator know that this
> is untrusted allocation triggered from userspace and should be a subject
> of kmem accountingis, and as such it is controlled by the cgroup
> mechanism. [1]
> 
> As part of this change, we allow loading in mlx5 driver larger images
> than 512 MB by dropping the arbitrary hard-coded value that we have
> today and move to use the max device loading value which is for now 4GB.
> 
> In addition, the first patch from the series fixes a UBSAN note in mlx5
> that was reported once the kernel was compiled with this option.
> 
> [1] https://www.kernel.org/doc/html/latest/core-api/memory-allocation.html
> 
> Changes from V0: https://www.spinics.net/lists/kvm/msg299508.html
> Patch #2 - Fix MAX_LOAD_SIZE to use BIT_ULL instead of BIT as was
>            reported by the krobot test.
> 
> Yishai
> 
> Jason Gunthorpe (1):
>   vfio: Use GFP_KERNEL_ACCOUNT for userspace persistent allocations
> 
> Yishai Hadas (5):
>   vfio/mlx5: Fix UBSAN note
>   vfio/mlx5: Allow loading of larger images than 512 MB
>   vfio/hisi: Use GFP_KERNEL_ACCOUNT for userspace persistent allocations
>   vfio/fsl-mc: Use GFP_KERNEL_ACCOUNT for userspace persistent
>     allocations
>   vfio/platform: Use GFP_KERNEL_ACCOUNT for userspace persistent
>     allocations
> 
>  drivers/vfio/container.c                      |  2 +-
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c             |  2 +-
>  drivers/vfio/fsl-mc/vfio_fsl_mc_intr.c        |  4 ++--
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |  4 ++--
>  drivers/vfio/pci/mlx5/cmd.c                   | 17 +++++++++--------
>  drivers/vfio/pci/mlx5/main.c                  | 19 ++++++++++---------
>  drivers/vfio/pci/vfio_pci_config.c            |  6 +++---
>  drivers/vfio/pci/vfio_pci_core.c              |  7 ++++---
>  drivers/vfio/pci/vfio_pci_igd.c               |  2 +-
>  drivers/vfio/pci/vfio_pci_intrs.c             | 10 ++++++----
>  drivers/vfio/pci/vfio_pci_rdwr.c              |  2 +-
>  drivers/vfio/platform/vfio_platform_common.c  |  2 +-
>  drivers/vfio/platform/vfio_platform_irq.c     |  8 ++++----
>  drivers/vfio/virqfd.c                         |  2 +-
>  14 files changed, 46 insertions(+), 41 deletions(-)

The type1 IOMMU backend is notably absent here among the core files, any
reason?  Potentially this removes the dma_avail issue as a means to
prevent userspace from creating an arbitrarily large number of DMA
mappings, right?  For compatibility, this might mean setting the DMA
entry limit to an excessive number instead as some use cases can
already hit the U16_MAX limit now.

Are there any compatibility issues we should expect with this change to
accounting otherwise?

Also a nit, the commit logs have a persistent typo throughout
"accountingis".  I can fix on commit or if we decide on a respin please
fix.  Thanks,

Alex

