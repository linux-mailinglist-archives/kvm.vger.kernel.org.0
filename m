Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBCDE526844
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 19:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344148AbiEMRYD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 13:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382933AbiEMRX4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 13:23:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 59A711117B
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 10:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652462634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zC7S9O1vJtnGsfcq4SfsqlvYroi1S23VFaVB36OivFQ=;
        b=bUH1ejPoio+kahum1UrcBjz3CEwPFnloNsd4SSJk4J3hCp0jeXm3TPO9GpPUwsuH+81J5q
        1y/ufeoU8lICFDTzC2Xx7UXr8eFXetTzAxkR4fP8bo4Swh/j7vZHNkOD3B+H94JxGElxOP
        hZgQZs8cYTtXfOQfDbt2/bXczFmx8SY=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-LPBT0ygoP-6OWKPbeLThhg-1; Fri, 13 May 2022 13:23:52 -0400
X-MC-Unique: LPBT0ygoP-6OWKPbeLThhg-1
Received: by mail-il1-f197.google.com with SMTP id j30-20020a056e02219e00b002d0ee998fb5so2717174ila.20
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 10:23:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=zC7S9O1vJtnGsfcq4SfsqlvYroi1S23VFaVB36OivFQ=;
        b=TcNLjU6wz8j6lwDf7ObtMd4Tx0aG22k/ZyctjBtSHkyN9aGRlfZ6PELakcH5eM9qIc
         RbDmwQv54zjcjvt1lu4Xjh1nvFWssvS81f6t5jryeo6OKZTqvcfjg8YQmAxoIitfrIZS
         jvGsVFfKpB2JDaRHWeSsT5ETZpkLL+2R1LiJBrc8FzRpDLB63nXYdsgKNuZZwcUbgv6H
         JeoPr5KFJojFBYpU3XmgkexDvv9qoKXYMz6dFpMFAYd9pHyWvS1oVUaXmjnbISxlbZ3Y
         El+7CtkE/w5UEw39BqXnFUyq49rAiIDP/6Tbq/BYtC7g8R9FdOU6Dw0LIJvIiF0UIuKC
         SNGw==
X-Gm-Message-State: AOAM532L8HpeDXD+pPItqkmrN7VX77PrCFI7dp8elKiCWHNdJ6Al1TCD
        jrK6Y5QAIGl6IgZanT2k0h1DKH8Y84bs0ZbMU6aMdR8o8U8DNhpIy3Te7Vm2+Z3IFpb+EuQb1eo
        Mjl5iBNifKLgV
X-Received: by 2002:a05:6638:52e:b0:32a:e022:5a9e with SMTP id j14-20020a056638052e00b0032ae0225a9emr3293182jar.60.1652462631940;
        Fri, 13 May 2022 10:23:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzxj1D8ILZpJ7DI9GiojvlZvwwE98MOJ3D8EslO/y38EpJlB7CUEUP6XEtjPDLEDiqvyzJuvg==
X-Received: by 2002:a05:6638:52e:b0:32a:e022:5a9e with SMTP id j14-20020a056638052e00b0032ae0225a9emr3293108jar.60.1652462630294;
        Fri, 13 May 2022 10:23:50 -0700 (PDT)
Received: from redhat.com ([98.55.18.59])
        by smtp.gmail.com with ESMTPSA id p137-20020a02298f000000b0032b3a781755sm813761jap.25.2022.05.13.10.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 10:23:49 -0700 (PDT)
Date:   Fri, 13 May 2022 11:23:48 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v3 0/8] Remove vfio_group from the struct file facing
 VFIO API
Message-ID: <20220513112348.390d9251.alex.williamson@redhat.com>
In-Reply-To: <0-v3-f7729924a7ea+25e33-vfio_kvm_no_group_jgg@nvidia.com>
References: <0-v3-f7729924a7ea+25e33-vfio_kvm_no_group_jgg@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  4 May 2022 16:14:38 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> This is the other half of removing the vfio_group from the externally
> facing VFIO API.
> 
> VFIO provides an API to manipulate its struct file *'s for use by KVM and
> VFIO PCI. Instead of converting the struct file into a ref counted struct
> vfio_group simply use the struct file as the handle throughout the API.
> 
> Along the way some of the APIs are simplified to be more direct about what
> they are trying to do with an eye to making future iommufd implementations
> for all of them.
> 
> This also simplifies the container_users ref counting by not holding a
> users refcount while KVM holds the group file.
> 
> Removing vfio_group from the external facing API is part of the iommufd
> work to modualize and compartmentalize the VFIO container and group object
> to be entirely internal to VFIO itself.
> 
> This is on github: https://github.com/jgunthorpe/linux/commits/vfio_kvm_no_group
> 
> v3:
>  - Use u64_to_user_ptr() to cast attr->addr to a void __user * to avoid
>    compiler warnings on 32 bit
>  - Rebase on top of
>    https://lore.kernel.org/all/0-v2-0f36bcf6ec1e+64d-vfio_get_from_dev_jgg@nvidia.com/
>  - Update commit messages
> v2: https://lore.kernel.org/r/0-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com
> - s/filp/file/ s/filep/file/
> - Drop patch to allow ppc to be compile tested
> - Keep symbol_get's Christoph has an alternative approach
> v1: https://lore.kernel.org/r/0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com
> 
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Yi Liu <yi.l.liu@intel.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Jason Gunthorpe (8):
>   kvm/vfio: Move KVM_DEV_VFIO_GROUP_* ioctls into functions
>   kvm/vfio: Store the struct file in the kvm_vfio_group
>   vfio: Change vfio_external_user_iommu_id() to vfio_file_iommu_group()
>   vfio: Remove vfio_external_group_match_file()
>   vfio: Change vfio_external_check_extension() to
>     vfio_file_enforced_coherent()
>   vfio: Change vfio_group_set_kvm() to vfio_file_set_kvm()
>   kvm/vfio: Remove vfio_group from kvm
>   vfio/pci: Use the struct file as the handle not the vfio_group
> 
>  drivers/vfio/pci/vfio_pci_core.c |  42 ++--
>  drivers/vfio/vfio.c              | 131 +++++------
>  include/linux/vfio.h             |  15 +-
>  virt/kvm/vfio.c                  | 381 ++++++++++++++-----------------
>  4 files changed, 262 insertions(+), 307 deletions(-)
> 
> 
> base-commit: 0f36bcf6ec1e0c95725cdaf9cf3b0fed6f697494

Applied to vfio next branch for v5.19.  Thanks,

Alex

