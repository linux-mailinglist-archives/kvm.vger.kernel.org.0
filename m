Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 586CC7859D9
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 15:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236213AbjHWN4P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 09:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233771AbjHWN4O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 09:56:14 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC3BCEC;
        Wed, 23 Aug 2023 06:56:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M9aTrGMDgfGRMAXHs/Fp5mu3KhSF2m36y86k5by56JYwb69/yrsyOXTX6EYSh12TiQWhcwWsD8YI15XbBG4QeFUrpbdL/GlVHbXrVfj1ucmtj2TqDeFoudZt7HOs6VfS5u3yWwUVj+tP6J+D3sLAbG2LIw6sMOKpK4CVpsjcezbonDN1Uzm2RAqknYankhunAxSgLLIq4k0nqW2ky/1xOGrXfia34JlylY6Ci3ocfE2SRysWiSW5AcpL1hQEd5GSTaoOrxyOLQuoWJuSBQTStJvk36NI9i34c9O3pSeFqXqHQaNM8TtAXldXJaJxV7F61CcOjUv/oeJ1o05wV5IgGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ktrlRcXYPnzoJfGS3wOWZbSFnLk7WBI+t6y/dtXM1A=;
 b=XPxbi00aLgPYUJffNzQxgj47WaFs12Lt6opqyRr4WDl2TQz5MNPWzCjZKicfilwekKdCh2gaSQ1Jsb24F1H246OsxPKeZNpKfWBmIQV8PMm1PrWX3i8DnoLF6sA2lRW/LUkuWlD0RoIvZjf7pciRFX5fndONXczT0UpT3U5bpWnxoACa6xxwvjZoIlPdqlwN9m5bTCxxFyUXJKfN/wGf00XIPLBX8W4j/LLvFC0buTZjvMRE1tXs7esrUHXNFFgRz4+pr4StkillxBnqV6WglAaupVGQIBi4U2beNwK8pVOKERbBLiSj3+tVsI6q4y/aMUVDvXBiq083DL48AboreQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ktrlRcXYPnzoJfGS3wOWZbSFnLk7WBI+t6y/dtXM1A=;
 b=loi1jVWupcsd28IS0+SdhcLhz9AssvL+5kE/lLN3NAR4kYftmTaBr2IacipJZ7neXKE2eyZaCYQm0NCTDoxstZNhAbEZCdJghG1oNw+Qh45Bzps4eLF1sT3UBrcKSmRiZUXoSCzfkiEPRL3qiSQhPlC8H3i2WZtQ5I0GQHPWT7qX2GoCtNSEHwmy7Jqlfb/A4EtzYqoEF+9KsjdwPA0wj5ywmm94Z5pVSs0o9j4pX9GH0LaPppzbqL3D/BQhCPZ1s5UvuZ4ip3Hx3OF8Pwd/wsIBUm7tJwHvtfsyifPEzx55psdO/D50MJQ7wUXBiqhjtsdNk8bCUa0WJNEjvACZmA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA3PR12MB9092.namprd12.prod.outlook.com (2603:10b6:806:37f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.25; Wed, 23 Aug
 2023 13:56:09 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6699.020; Wed, 23 Aug 2023
 13:56:09 +0000
Date:   Wed, 23 Aug 2023 10:56:07 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     ankita@nvidia.com
Cc:     alex.williamson@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
        targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
        apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Message-ID: <ZOYP92q1mDQgwnc9@nvidia.com>
References: <20230822202303.19661-1-ankita@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230822202303.19661-1-ankita@nvidia.com>
X-ClientProxiedBy: SJ0PR03CA0186.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::11) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA3PR12MB9092:EE_
X-MS-Office365-Filtering-Correlation-Id: 72e89f99-7edd-4daa-3150-08dba3e0b441
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bOe7t1h/vrLMfMbkmgdTN4cPm7ZyYccsD21wh6WbEfSYUF9GkrcCls09Rrg84Tbq1FyDroiTclH1koiB61Bsd7RAXQhiEo7eGDU+pTpL45iDALhgQB6/cdfpXA71tIL4iIERotS6b/Q50hfau0IRoNjWgCpViBV7NLwdDHh8yfrYNNJrz1G20+k85MkLsR7F0MzEzcCR4ZEVOsFBPZ/k22c5mK3k2nk6kPYVA3BH31NYqKWW9uuZy8gN70SvTeehYBS60672Go2ndw9vYGzzrSDmG6+u+kaZMny6qgmpBHt8adnzzOg88YOyG+ud47mQe3nkolB2vnEtASrHaRsFdLj1GKkZbfTdLOe04NRpATp2QfDHZ26U4pkjLgDUgbL10wunDehwxcNaRrj6GGPizc2JvCtJcN1PfyUAiWchS5oM2Jgy10eEq8DPYDkPZmZJXNjy1Nd1eoDqYrZjE5q3TEK1bEK4ziT4fvNWXsexU7vTfU+WT8IT+fXapgmp4GD0L4SPAPTrk2MSiiUZgm2auzJrKk3i9ky+vjG/wMfyldgNI/S8KQsJBpMgPruANVVV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(136003)(39860400002)(396003)(366004)(1800799009)(186009)(451199024)(6506007)(6486002)(2616005)(6512007)(86362001)(66556008)(4326008)(5660300002)(2906002)(38100700002)(66946007)(8676002)(8936002)(36756003)(34206002)(6636002)(41300700001)(66476007)(316002)(37006003)(478600001)(83380400001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YrLMD7c6zldoKwLVf8VLSQEYtsYsFsS2mEFqXoJF0NUwAfyy0GwkPm14zlkg?=
 =?us-ascii?Q?qPLN14QZaBmASQrCnLAPzQ2UuuAfl8CesUhmhQLdmLrH+nKR6HSf5nnSkrEC?=
 =?us-ascii?Q?1xfH42bW2ThPlzIKs5NPQVdWTkh/JeWklS/if9kZaAZBb7ZPFnDlVl/BWIRB?=
 =?us-ascii?Q?SoUWgOt6EBaN2fpm5TnNrt3/4mqjlzSZ7MKrXmz47ZO/7hTMQKz9pWtUKyqm?=
 =?us-ascii?Q?Gx4WY+B0Kh0em3uIME9mFl/Go4rmcZf5OHBoXWKj0fpNCCRUUyOU+AiqTMdk?=
 =?us-ascii?Q?F/G+b0TNhlX0RFdfk66ZKeao6YGlsEtODVqSi3CC8bSwjgcAgEBbYTxMiWYq?=
 =?us-ascii?Q?07t2fz5f4ELofEYjjnAi5D14Q9n669rrZcRijLN33W42at+J3a9RTVjijCt1?=
 =?us-ascii?Q?TjPQL/XW+puOqw6wXNk7nYAnjiKjjDcqp3Zh1MMYhNw2FEp2Rok6Njzw/oyJ?=
 =?us-ascii?Q?LuMpjh9TlFM6R4cnErYozmzjBC87JaXqoOEEQ9xby6Iz1zH0ABl7izJnpEEu?=
 =?us-ascii?Q?fMR5xNgyKFCjzLH16GmssBJRlSl8RGQ1Eo6HJkJkqw1Yp2A7LYoXMGpuDuIU?=
 =?us-ascii?Q?wd4aHeM7Cp5XeJdNqOWUzeZ5BcSjgXXjt6o6MI0xrJa7zm82dc25DbL8ZOCe?=
 =?us-ascii?Q?7ql3yDs8hO7Ijg8jwGsaFJpKLQ1yVlkSt8AtjDGQT1VvCOhfmjd9OzuiCLtd?=
 =?us-ascii?Q?zCk8r2r7kmKKR0Ppe9fxDDX8lMmSGBXtBq+8IYYSzFG/I9PbjJy5RYRRKSo0?=
 =?us-ascii?Q?QyOtc9xal5BnzhwCIukg35ZAWt+Gp+eJsTXwCkIchetdiyUcqIVuYY+534t2?=
 =?us-ascii?Q?E/FtDjUW6VzWOpIUNV9CEUVp3vk9FdyulvZeo39McDGifhiVYx10JfPHxdyP?=
 =?us-ascii?Q?IzKxxTk6DhWgJPVEMIQc6ayHOoIhFZPJaemHhYcXadoCx2xnuPsVLzdJAfOJ?=
 =?us-ascii?Q?rM/xdP3UC0w9193m1KZYep0SgVYMUhACmR9lZVB5V08r50Kma0Nfi+pUexCT?=
 =?us-ascii?Q?cvyzbqybZKuGV1qgo9yxGSmC0FSBiaOT2S5/WELs1i65B0ffKDLQvZNB23MZ?=
 =?us-ascii?Q?uHm1Js5rbQOd8yUhwEg+YR9MPerJz/yMKp7Ok95+bc1wyhHGYqtGd+gVDR0f?=
 =?us-ascii?Q?h8zceqg63oewehhWrQaaUNpgg9uUyAaQj4fzucQ7of20zI76RLwWYn/XWjBm?=
 =?us-ascii?Q?vHQewmBO+5NoXt8hKzzhD028TpHvy3H8Ko2V+mKE4nES9Qfp0GHQiBAPmVZu?=
 =?us-ascii?Q?J7azfIptm+q1lz6DzC5cZeu83yA2q5lZdLjvZ7Y7PUI+LgVGlcW6K6NWk55Z?=
 =?us-ascii?Q?Xe1pduWyQIzr4v30afSyYUnU7vRtn6X5M4HNf+FjIbrBTbHoRNdFBTVU1MRi?=
 =?us-ascii?Q?IkObGYqP9WmS/BNQ5Qo/2OjLgCSDzswBxO/Z2MxDcVQ0HxwZhcO/qRW5x9kd?=
 =?us-ascii?Q?BDB7UYvifxw7pbGMYD80Ea+LHg4HoZET3GDtXsJiAW8YoVDJ2uNA5MFLzbx/?=
 =?us-ascii?Q?53mLRwNRUVy4C+iUICcoddo13BNc/Dz8fwLSvfLFdAFkRFa+zq2KruDtP+o8?=
 =?us-ascii?Q?1Z/ur/XQB64IwaPknhi42Pm8hUw1vaJ5/F7vi21r?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72e89f99-7edd-4daa-3150-08dba3e0b441
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2023 13:56:09.6789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D+SH9Xd+jx/6y4G4V39k0vcBNVZ1axWS86JXaKFPuShwBfrooPtBFq5ac+UbqbFj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9092
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 22, 2023 at 01:23:03PM -0700, ankita@nvidia.com wrote:

> @@ -0,0 +1,444 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved
> + */
> +
> +#include <linux/pci.h>
> +#include <linux/vfio_pci_core.h>
> +#include <linux/vfio.h>
> +
> +struct nvgrace_gpu_vfio_pci_core_device {
> +	struct vfio_pci_core_device core_device;
> +	u64 hpa;
> +	u64 mem_length;
> +	void *opregion;
> +};

opregion is some word that has meaning for the intel drivers, use
something else please.

'hpa' has no business being in a VFIO driver.

phys_addr_t memphys
size_t memlength
void __iomem *memmap;

> +static long nvgrace_gpu_vfio_pci_ioctl(struct vfio_device *core_vdev,
> +					unsigned int cmd, unsigned long arg)
> +{
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
> +		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
> +
> +	unsigned long minsz = offsetofend(struct vfio_region_info, offset);
> +	struct vfio_region_info info;
> +
> +	if (cmd == VFIO_DEVICE_GET_REGION_INFO) {

This block is long enough to put in its own function and remove a
level of indenting

> +/*
> + * Read count bytes from the device memory at an offset. The actual device
> + * memory size (available) may not be a power-of-2. So the driver fakes
> + * the size to a power-of-2 (reported) when exposing to a user space driver.
> + *
> + * Read request beyond the actual device size is filled with ~1, while
> + * those beyond the actual reported size is skipped.
> + *
> + * A read from a reported+ offset is considered error conditions and
> + * returned with an -EINVAL. Overflow conditions are also handled.
> + */
> +ssize_t nvgrace_gpu_read_mem(void __user *buf, size_t count, loff_t *ppos,
> +			      const void *addr, size_t available, size_t reported)
> +{
> +	u64 offset = *ppos & VFIO_PCI_OFFSET_MASK;
> +	u64 end;
> +	size_t read_count, i;
> +	u8 val = 0xFF;
> +
> +	if (offset >= reported)
> +		return -EINVAL;
> +
> +	if (check_add_overflow(offset, count, &end))
> +		return -EOVERFLOW;
> +
> +	/* Clip short the read request beyond reported BAR size */
> +	if (end >= reported)
> +		count = reported - offset;
> +
> +	/*
> +	 * Determine how many bytes to be actually read from the device memory.
> +	 * Do not read from the offset beyond available size.
> +	 */
> +	if (offset >= available)
> +		read_count = 0;
> +	else
> +		read_count = min(count, available - (size_t)offset);
> +
> +	/*
> +	 * Handle read on the BAR2 region. Map to the target device memory
> +	 * physical address and copy to the request read buffer.
> +	 */
> +	if (copy_to_user(buf, (u8 *)addr + offset, read_count))
> +		return -EFAULT;
> +
> +	/*
> +	 * Only the device memory present on the hardware is mapped, which may
> +	 * not be power-of-2 aligned. A read to the BAR2 region implies an
> +	 * access outside the available device memory on the hardware. Fill
> +	 * such read request with ~1.
> +	 */
> +	for (i = 0; i < count - read_count; i++)
> +		if (copy_to_user(buf + read_count + i, &val, 1))
> +			return -EFAULT;

Use put_user()

> +static ssize_t nvgrace_gpu_vfio_pci_write(struct vfio_device *core_vdev,
> +					   const char __user *buf, size_t count, loff_t *ppos)
> +{
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	struct nvgrace_gpu_vfio_pci_core_device *nvdev = container_of(
> +		core_vdev, struct nvgrace_gpu_vfio_pci_core_device, core_device.vdev);
> +
> +	if (index == VFIO_PCI_BAR2_REGION_INDEX) {
> +		if (!nvdev->opregion) {
> +			nvdev->opregion = memremap(nvdev->hpa, nvdev->mem_length, MEMREMAP_WB);
> +			if (!nvdev->opregion)
> +				return -ENOMEM;
> +		}

Needs some kind of locking on opregion

> +static int
> +nvgrace_gpu_vfio_pci_fetch_memory_property(struct pci_dev *pdev,
> +					    struct nvgrace_gpu_vfio_pci_core_device *nvdev)
> +{
> +	int ret;
> +
> +	/*
> +	 * The memory information is present in the system ACPI tables as DSD
> +	 * properties nvidia,gpu-mem-base-pa and nvidia,gpu-mem-size.
> +	 */
> +	ret = device_property_read_u64(&pdev->dev, "nvidia,gpu-mem-base-pa",
> +				       &(nvdev->hpa));
> +	if (ret)
> +		return ret;

Technically you need to check that the read_u64 doesn't overflow
phys_addr_t

> +	ret = device_property_read_u64(&pdev->dev, "nvidia,gpu-mem-size",
> +				       &(nvdev->mem_length));
> +	return ret;

And that mem_length doesn't overflow size_t

Jason
