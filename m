Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C9D2F2890
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 07:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391015AbhALGv1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 01:51:27 -0500
Received: from foss.arm.com ([217.140.110.172]:40738 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389829AbhALGv0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 01:51:26 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 38ADB13A1
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 22:50:41 -0800 (PST)
Received: from mail-pl1-f180.google.com (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 265853FA50
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 22:50:41 -0800 (PST)
Received: by mail-pl1-f180.google.com with SMTP id x18so890925pln.6
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 22:50:41 -0800 (PST)
X-Gm-Message-State: AOAM533nXKEb2dqoKkCXfT5GjYVlxGKcad4JObryTmn41mAkalrDXZHj
        uzaYeUhADPa2zy64mRSKQXzmWV0j+lvHnDx0tuQ=
X-Google-Smtp-Source: ABdhPJxkM7Gy++KOxgg+Vg4KylRwV8QFQOGVeqrZZyEU2DDcq/JYCbjcYhWtGT34jkE/Co1DvCz6R7vLIIXujaJ2Oe4=
X-Received: by 2002:a17:902:ee0b:b029:dc:1aa4:1123 with SMTP id
 z11-20020a170902ee0bb02900dc1aa41123mr3819896plb.18.1610434240490; Mon, 11
 Jan 2021 22:50:40 -0800 (PST)
MIME-Version: 1.0
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com> <1599734733-6431-3-git-send-email-yi.l.liu@intel.com>
In-Reply-To: <1599734733-6431-3-git-send-email-yi.l.liu@intel.com>
From:   Vivek Gautam <vivek.gautam@arm.com>
Date:   Tue, 12 Jan 2021 12:20:29 +0530
X-Gmail-Original-Message-ID: <CAFp+6iFob_fy1cTgcEv0FOXBo70AEf3Z1UvXgPep62XXnLG9Gw@mail.gmail.com>
Message-ID: <CAFp+6iFob_fy1cTgcEv0FOXBo70AEf3Z1UvXgPep62XXnLG9Gw@mail.gmail.com>
Subject: Re: [PATCH v7 02/16] iommu/smmu: Report empty domain nesting info
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        kevin.tian@intel.com, ashok.raj@intel.com, kvm@vger.kernel.org,
        stefanha@gmail.com, jun.j.tian@intel.com,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <iommu@lists.linux-foundation.org>,
        yi.y.sun@intel.com, Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>, jasowang@redhat.com,
        hao.wu@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,


On Thu, Sep 10, 2020 at 4:13 PM Liu Yi L <yi.l.liu@intel.com> wrote:
>
> This patch is added as instead of returning a boolean for DOMAIN_ATTR_NESTING,
> iommu_domain_get_attr() should return an iommu_nesting_info handle. For
> now, return an empty nesting info struct for now as true nesting is not
> yet supported by the SMMUs.
>
> Cc: Will Deacon <will@kernel.org>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Suggested-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> ---
> v5 -> v6:
> *) add review-by from Eric Auger.
>
> v4 -> v5:
> *) address comments from Eric Auger.
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 29 +++++++++++++++++++++++++++--
>  drivers/iommu/arm/arm-smmu/arm-smmu.c       | 29 +++++++++++++++++++++++++++--
>  2 files changed, 54 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 7196207..016e2e5 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -3019,6 +3019,32 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
>         return group;
>  }
>
> +static int arm_smmu_domain_nesting_info(struct arm_smmu_domain *smmu_domain,
> +                                       void *data)
> +{
> +       struct iommu_nesting_info *info = (struct iommu_nesting_info *)data;
> +       unsigned int size;
> +
> +       if (!info || smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
> +               return -ENODEV;
> +
> +       size = sizeof(struct iommu_nesting_info);
> +
> +       /*
> +        * if provided buffer size is smaller than expected, should
> +        * return 0 and also the expected buffer size to caller.
> +        */
> +       if (info->argsz < size) {
> +               info->argsz = size;
> +               return 0;
> +       }
> +
> +       /* report an empty iommu_nesting_info for now */
> +       memset(info, 0x0, size);
> +       info->argsz = size;
> +       return 0;
> +}
> +
>  static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
>                                     enum iommu_attr attr, void *data)
>  {
> @@ -3028,8 +3054,7 @@ static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
>         case IOMMU_DOMAIN_UNMANAGED:
>                 switch (attr) {
>                 case DOMAIN_ATTR_NESTING:
> -                       *(int *)data = (smmu_domain->stage == ARM_SMMU_DOMAIN_NESTED);
> -                       return 0;
> +                       return arm_smmu_domain_nesting_info(smmu_domain, data);

Thanks for the patch.
This would unnecessarily overflow 'data' for any caller that's expecting only
an int data. Dump from one such issue that I was seeing when testing
this change along with local kvmtool changes is pasted below [1].

I could get around with the issue by adding another (iommu_attr) -
DOMAIN_ATTR_NESTING_INFO that returns (iommu_nesting_info).

Thanks & regards
Vivek

[1]--------------
[  811.756516] vfio-pci 0000:08:00.1: vfio_ecap_init: hiding ecap 0x1b@0x108
[  811.756516] Kernel panic - not syncing: stack-protector: Kernel
stack is corrupted in: vfio_pci_open+0x644/0x648
[  811.756516] CPU: 0 PID: 175 Comm: lkvm-cleanup-ne Not tainted
5.10.0-rc5-00096-gf015061e14cf #43
[  811.756516] Call trace:
[  811.756516]  dump_backtrace+0x0/0x1b0
[  811.756516]  show_stack+0x18/0x68
[  811.756516]  dump_stack+0xd8/0x134
[  811.756516]  panic+0x174/0x33c
[  811.756516]  __stack_chk_fail+0x3c/0x40
[  811.756516]  vfio_pci_open+0x644/0x648
[  811.756516]  vfio_group_fops_unl_ioctl+0x4bc/0x648
[  811.756516]  0x0
[  811.756516] SMP: stopping secondary CPUs
[  811.756597] Kernel Offset: disabled
[  811.756597] CPU features: 0x0040006,6a00aa38
[  811.756602] Memory Limit: none
[  811.768497] ---[ end Kernel panic - not syncing: stack-protector:
Kernel stack is corrupted in: vfio_pci_open+0x644/0x648 ]
-------------
