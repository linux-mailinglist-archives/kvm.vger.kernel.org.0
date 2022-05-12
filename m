Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 749B55254A2
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 20:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357579AbiELSVq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 14:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357571AbiELSVn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 14:21:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A34D151E7B
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 11:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652379699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NY2dFITe8xOArMokMh0BHxX/SWGAk526LJpYH78ykCU=;
        b=WW8ap/1nQS3xOpmGs/kmYv5OXSc7W441DdVeaan0ZBnqfzblzfFvM3UbzOCcJtTC4pYpF0
        9mf+h+CcsSL3ibFDI5//UngzB2L93xxbpk0I+flK2wVXPhJUD8hPKtaogcpLhTHdkVyM03
        9MfwvwIQTddyLlprUCuMJnbM3spxF/0=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-259-x0o23yZQMkWfbGI7MxbGfA-1; Thu, 12 May 2022 14:21:38 -0400
X-MC-Unique: x0o23yZQMkWfbGI7MxbGfA-1
Received: by mail-il1-f198.google.com with SMTP id k15-20020a92c24f000000b002d0ee4f5d79so949669ilo.9
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 11:21:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=NY2dFITe8xOArMokMh0BHxX/SWGAk526LJpYH78ykCU=;
        b=OeQw7/pBQtrIKpYUeNLqcV8EtyFbgmQvjUdgCKt5l3RGSu/EiDFvZdg/nLQjZni0KN
         rnwwyrJwNDtcsY1YV/WQjw+BppgOn7Z/8mNjvYcmUxYuRyrpI5gZ+vq28A15fM5WMXVI
         e6jn4F+nHeYICL2Fkfo5Mm1ZXPLiI1Ft6Df1NjBtbfeDvIE0RK6+8e6Wm/FdDFm3mnpF
         jT/KfE/gq5RaYCpmEMU4MHFZh0aHFVJ6O70Vj6nDJo7pjbkJ001QBP1e8/132PXB9uke
         EbksPi0PD5LBAkAPsp1jGuNwR0/C6sxOtQpFLY4cJuEt5IwM1rFL9uArnCxd6We9utDA
         m9Uw==
X-Gm-Message-State: AOAM533uDxDIVLs9hcpDjiQy4xng5SRq+SffVGdYBAujwKpnVQ+6FiEy
        YgSv83CH3o+IP/CliceOdLvwwIz+67Y9Kb4a9U72bH3JFYoXmxRZiy28R1Dx19/gLfYLjx6QiWr
        +EDvBwTHOnfqx
X-Received: by 2002:a05:6e02:1d03:b0:2cd:fde3:1a52 with SMTP id i3-20020a056e021d0300b002cdfde31a52mr673749ila.35.1652379697625;
        Thu, 12 May 2022 11:21:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwheHjEvjdWehUJ4Dby4ptoLZ967fptvtUum2hDR2z8KvGG/ZNoixuc9lEnPdLDTpQmf1/Osw==
X-Received: by 2002:a05:6e02:1d03:b0:2cd:fde3:1a52 with SMTP id i3-20020a056e021d0300b002cdfde31a52mr673737ila.35.1652379697432;
        Thu, 12 May 2022 11:21:37 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id x11-20020a92dc4b000000b002cde6e35300sm32768ilq.74.2022.05.12.11.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 11:21:37 -0700 (PDT)
Date:   Thu, 12 May 2022 12:21:26 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH v4 0/2] Remove vfio_device_get_from_dev()
Message-ID: <20220512122126.3c2ae5e9.alex.williamson@redhat.com>
In-Reply-To: <0-v4-c841817a0349+8f-vfio_get_from_dev_jgg@nvidia.com>
References: <0-v4-c841817a0349+8f-vfio_get_from_dev_jgg@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  5 May 2022 20:21:38 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Use drvdata instead of searching to find the struct vfio_device for the
> pci_driver callbacks.
> 
> This applies on top of the gvt series and at least rc3 - there are no
> conflicts with the mdev vfio_group series, or the iommu series.
> 
> v4:
>  - Put back missing rebase hunk for vfio_group_get_from_dev()
>  - Move the WARN_ON to vfio_pci_core_register_device() and move the
>    dev_set_drvdata() to match
> v3: https://lore.kernel.org/r/0-v3-4adf6c1b8e7c+170-vfio_get_from_dev_jgg@nvidia.com
>  - Directly access the drvdata from vfio_pci_core by making drvdata always
>    point to the core struct. This will help later patches adding PM
>    callbacks as well.
> v2: https://lore.kernel.org/r/0-v2-0f36bcf6ec1e+64d-vfio_get_from_dev_jgg@nvidia.com
>  - Rebase on the vfio_mdev_no_group branch
>  - Delete vfio_group_get_from_dev() as well due to the rebase
> v1: https://lore.kernel.org/r/0-v1-7f2292e6b2ba+44839-vfio_get_from_dev_jgg@nvidia.com
> 
> Jason Gunthorpe (2):
>   vfio/pci: Have all VFIO PCI drivers store the vfio_pci_core_device in
>     drvdata
>   vfio/pci: Remove vfio_device_get_from_dev()
> 
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 15 +++++--
>  drivers/vfio/pci/mlx5/main.c                  | 15 +++++--
>  drivers/vfio/pci/vfio_pci.c                   |  6 ++-
>  drivers/vfio/pci/vfio_pci_core.c              | 36 +++++-----------
>  drivers/vfio/vfio.c                           | 41 +------------------
>  include/linux/vfio.h                          |  2 -
>  include/linux/vfio_pci_core.h                 |  3 +-
>  7 files changed, 39 insertions(+), 79 deletions(-)

Applied to vfio next branch for v5.19.  Thanks,

Alex

