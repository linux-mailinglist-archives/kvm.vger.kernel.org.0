Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7CF3FCB51
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 18:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239852AbhHaQQu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 12:16:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48457 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239720AbhHaQQt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Aug 2021 12:16:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630426554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iC/vqrnC8agefEfcK8F2l8XU9S2U0FJkOrhS5FcGFpE=;
        b=C2U3gFFXnWKCpPsxZEuvCgkzD2JjfmADTfOk1D1dKN3bDJtHeSIvz/dj6dyYvCNwQpzd3n
        O9WNgJYT9hTG87SKEIJhFzehGeIQ1+Cyoj2PPMRbnIvI7RPYHH1KKm8R8g8HnGizhSUCXc
        5ABluoVUp8NATVIoQcEi8JHvDTAtvfA=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-136-9dtsnW7XMA2Mrd76BNMcrw-1; Tue, 31 Aug 2021 12:15:52 -0400
X-MC-Unique: 9dtsnW7XMA2Mrd76BNMcrw-1
Received: by mail-io1-f72.google.com with SMTP id g14-20020a6be60e000000b005b62a0c2a41so11150715ioh.2
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 09:15:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=iC/vqrnC8agefEfcK8F2l8XU9S2U0FJkOrhS5FcGFpE=;
        b=gBzK2CKPkRzijB6JvWRsXHNRFHFBYtHIxYV0h8opbiyrgyh4oMxKhWZoOupfX+1xxJ
         OIQJULySKxY9AGxEmJ94uGpVEWMnURk0abjHZVAEgqgEJasfvo9rnkM4n5Tyx7PrpU/I
         EICC65LQeomxeXJCKNZs0RW6bulT+OFWR3DTaFCNWwLshQFCZoiukQiPPwqrAbNiqqfe
         HY8gMQ557dDBdxn4pKGygLy9OAQv80KlLRoHbwCvcFRlrhNJiq4d1h6/a1vfT6jYDy72
         y70bwrbrR3hS/DJ8XwLkYEW4rwAe1AR6IBVvenmDc6y3HCUohPdlL265CqWOcC+R2PlA
         RrYw==
X-Gm-Message-State: AOAM532wBLWinG/4ZWGfiY/jqI6vb4R4elNlHMQ4bPHX1K2hqNQkzDP4
        dBiSIyrgjVaEl/NUlbnjTGyDkeGq9AapVSvyZo/GUSr6Sf84fJZsQqpgWYHktFPGSyL9N/c2FMH
        CeHkfEJ4kRUOl
X-Received: by 2002:a92:1306:: with SMTP id 6mr10977690ilt.183.1630426552024;
        Tue, 31 Aug 2021 09:15:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyU8Gm8fnWRjCaSBCl5W6DLLHCeLpBofrbxoK/jTZqCPsDHAV1I8o6zW03fTiw16wfuaHsuSQ==
X-Received: by 2002:a92:1306:: with SMTP id 6mr10977660ilt.183.1630426551786;
        Tue, 31 Aug 2021 09:15:51 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id u13sm9685406iot.29.2021.08.31.09.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 09:15:51 -0700 (PDT)
Date:   Tue, 31 Aug 2021 10:15:49 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Nicolin Chen <nicolinc@nvidia.com>
Cc:     <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
        <cohuck@redhat.com>, <corbet@lwn.net>, <nicoleotsuka@gmail.com>,
        <vdumpa@nvidia.com>, <thierry.reding@gmail.com>,
        <linux-tegra@vger.kernel.org>, <nwatterson@nvidia.com>,
        <Jonathan.Cameron@huawei.com>, <jean-philippe@linaro.org>,
        <song.bao.hua@hisilicon.com>, <eric.auger@redhat.com>,
        <thunder.leizhen@huawei.com>, <yuzenghui@huawei.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [RFC][PATCH v2 00/13] iommu/arm-smmu-v3: Add NVIDIA
 implementation
Message-ID: <20210831101549.237151fa.alex.williamson@redhat.com>
In-Reply-To: <20210831025923.15812-1-nicolinc@nvidia.com>
References: <20210831025923.15812-1-nicolinc@nvidia.com>
Organization: Red Hat
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 30 Aug 2021 19:59:10 -0700
Nicolin Chen <nicolinc@nvidia.com> wrote:

> The SMMUv3 devices implemented in the Grace SoC support NVIDIA's custom
> CMDQ-Virtualization (CMDQV) hardware. Like the new ECMDQ feature first
> introduced in the ARM SMMUv3.3 specification, CMDQV adds multiple VCMDQ
> interfaces to supplement the single architected SMMU_CMDQ in an effort
> to reduce contention.
> 
> This series of patches add CMDQV support with its preparational changes:
> 
> * PATCH-1 to PATCH-8 are related to shared VMID feature: they are used
>   first to improve TLB utilization, second to bind a shared VMID with a
>   VCMDQ interface for hardware configuring requirement.

The vfio changes would need to be implemented in alignment with the
/dev/iommu proposals[1].  AIUI, the VMID is essentially binding
multiple containers together for TLB invalidation, which I expect in
the proposal below is largely already taken care of in that a single
iommu-fd can support multiple I/O address spaces and it's largely
expected that a hypervisor would use a single iommu-fd so this explicit
connection by userspace across containers wouldn't be necessary.

We're expecting to talk more about the /dev/iommu approach at Plumbers
in few weeks.  Thanks,

Alex

[1]https://lore.kernel.org/kvm/BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com/

 
> * PATCH-9 and PATCH-10 are to accommodate the NVIDIA implementation with
>   the existing arm-smmu-v3 driver.
> 
> * PATCH-11 borrows the "implementation infrastructure" from the arm-smmu
>   driver so later change can build upon it.
> 
> * PATCH-12 adds an initial NVIDIA implementation related to host feature,
>   and also adds implementation specific ->device_reset() and ->get_cmdq()
>   callback functions.
> 
> * PATCH-13 adds virtualization features using VFIO mdev interface, which
>   allows user space hypervisor to map and get access to one of the VCMDQ
>   interfaces of CMDQV module.
> 
> ( Thinking that reviewers can get a better view of this implementation,
>   I am attaching QEMU changes here for reference purpose:
>       https://github.com/nicolinc/qemu/commits/dev/cmdqv_v6.0.0-rc2
>   The branch has all preparational changes, while I'm still integrating
>   device model and ARM-VIRT changes, and will push them these two days,
>   although they might not be in a good shape of being sent to review yet )
> 
> Above all, I marked RFC for this series, as I feel that we may come up
> some better solution. So please kindly share your reviews and insights.
> 
> Thank you!
> 
> Changelog
> v1->v2:
>  * Added mdev interface support for hypervisor and VMs.
>  * Added preparational changes for mdev interface implementation.
>  * PATCH-12 Changed ->issue_cmdlist() to ->get_cmdq() for a better
>    integration with recently merged ECMDQ-related changes.
> 
> Nate Watterson (3):
>   iommu/arm-smmu-v3: Add implementation infrastructure
>   iommu/arm-smmu-v3: Add support for NVIDIA CMDQ-Virtualization hw
>   iommu/nvidia-smmu-v3: Add mdev interface support
> 
> Nicolin Chen (10):
>   iommu: Add set_nesting_vmid/get_nesting_vmid functions
>   vfio: add VFIO_IOMMU_GET_VMID and VFIO_IOMMU_SET_VMID
>   vfio: Document VMID control for IOMMU Virtualization
>   vfio: add set_vmid and get_vmid for vfio_iommu_type1
>   vfio/type1: Implement set_vmid and get_vmid
>   vfio/type1: Set/get VMID to/from iommu driver
>   iommu/arm-smmu-v3: Add shared VMID support for NESTING
>   iommu/arm-smmu-v3: Add VMID alloc/free helpers
>   iommu/arm-smmu-v3: Pass dev pointer to arm_smmu_detach_dev
>   iommu/arm-smmu-v3: Pass cmdq pointer in arm_smmu_cmdq_issue_cmdlist()
> 
>  Documentation/driver-api/vfio.rst             |   34 +
>  MAINTAINERS                                   |    2 +
>  drivers/iommu/arm/arm-smmu-v3/Makefile        |    2 +-
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-impl.c  |   15 +
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  121 +-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   18 +
>  .../iommu/arm/arm-smmu-v3/nvidia-smmu-v3.c    | 1249 +++++++++++++++++
>  drivers/iommu/iommu.c                         |   20 +
>  drivers/vfio/vfio.c                           |   25 +
>  drivers/vfio/vfio_iommu_type1.c               |   37 +
>  include/linux/iommu.h                         |    5 +
>  include/linux/vfio.h                          |    2 +
>  include/uapi/linux/vfio.h                     |   26 +
>  13 files changed, 1537 insertions(+), 19 deletions(-)
>  create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-impl.c
>  create mode 100644 drivers/iommu/arm/arm-smmu-v3/nvidia-smmu-v3.c
> 

