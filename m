Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F61A4677E6
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 14:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244486AbhLCNRm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 08:17:42 -0500
Received: from mail-mw2nam08on2072.outbound.protection.outlook.com ([40.107.101.72]:55392
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230163AbhLCNRl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Dec 2021 08:17:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XWh1djKf34QRFTbCupQYFdEhGtMu1PZH4eeln2BG/pkdgADXUvVFTvozuQDj2MGH5k35aYjGkkgndPx6T7HXglpreDVRGgOhs7ePbNvT/AcAuhGRohTxSdb/Wn14Tqc1+2geFFJ4MAC8Wz7aSdt32KtJzYY+HlRSqqN8aRJAAmttEpd+Rh6BqMJD+0/XCQzKvZnd8CjRNaXvZkmWS7Vl9vwOonvj7Skw+Mx3NJo02N/qFPRYFyIOla28w0uYaWXIpq1q/7C8tO6z0d9E/kZ+GCW3QFU4vMDApUDR320N+9FqwUwmZkbakfTUH36p3/XGuzUgpO//Ovf0pPsK/v7z0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FO1RqEH9Cc5O+Lu0dTVm7cL7iqaGbp281AUkg4zCTaM=;
 b=im1QSKqxequT4Yw6c0L7QS6iOWeDcfcL6pwxGrJZmeQoSC3wyz5282AMdaEa2sMzSBBztbqve3zAORfguYik224Pirx91fajMBlv/rOrS5mWAvuQPAi03pt/O5WwKALWQ346Lye4kH7EeThhBmV1JuWBJ6DKiu2SnMVJ2CIPr4cpMrZQPRp4oksMg0e1EOn/CoQFqKCp9vUVQ14AB2cH+QFmZRT//+FJevImVWiPYWyFVMGu5bIkOZY+icU/QfePtqSUvg3u6/pEO4b0QWrrt1GtMv67WeqEKzJGzhx/UuDOZzQs24KY5TewBBnIuZgvtJ7+mrnRfz8Mm1DVQQogHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FO1RqEH9Cc5O+Lu0dTVm7cL7iqaGbp281AUkg4zCTaM=;
 b=n1famI68ltP2Fr5xKKUnjcIe/rKOldpJ+PQcG/UNLqyVUPnGtG3wl9mKpbe/31C2pmPB3htyVlhqpnZx9kht8/xqGqCH+RocYQdfmDNFKMJYNQK1DCOEexwl6HcfXPWE0u6+cqSHjpmi7uFqqVpq/CgBfAfEvUhTjkKZFsZhzHvpC/Fdt0k/C6KZsXfnie++BYJyRljNAFO9NXFhyd+GlA/inZtWrvVrH5czmZnYqiGoA7cQgXA71vQPk+GtxwSRUe2+0OqXgvT6mIIVX35x2naokMSlz/xKz0AKxWxkock+A5zAbKQ1LvBb2tYqTnQtk3BKlKo5hgyl05BomLRZqA==
Received: from SJ0PR12MB5438.namprd12.prod.outlook.com (2603:10b6:a03:3ba::23)
 by SJ0PR12MB5423.namprd12.prod.outlook.com (2603:10b6:a03:301::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Fri, 3 Dec
 2021 13:14:10 +0000
Received: from BN6PR11CA0061.namprd11.prod.outlook.com (2603:10b6:404:f7::23)
 by SJ0PR12MB5438.namprd12.prod.outlook.com (2603:10b6:a03:3ba::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Fri, 3 Dec
 2021 13:14:09 +0000
Received: from BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:f7:cafe::f4) by BN6PR11CA0061.outlook.office365.com
 (2603:10b6:404:f7::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24 via Frontend
 Transport; Fri, 3 Dec 2021 13:14:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT012.mail.protection.outlook.com (10.13.177.55) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Fri, 3 Dec 2021 13:14:08 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 3 Dec
 2021 13:13:51 +0000
Received: from [10.41.21.79] (172.20.187.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Fri, 3 Dec 2021
 05:13:43 -0800
Subject: Re: [RFC v16 0/9] SMMUv3 Nested Stage Setup (IOMMU part)
To:     Eric Auger <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
        <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <joro@8bytes.org>, <will@kernel.org>, <robin.murphy@arm.com>,
        <jean-philippe@linaro.org>, <zhukeqian1@huawei.com>
CC:     <alex.williamson@redhat.com>, <jacob.jun.pan@linux.intel.com>,
        <yi.l.liu@intel.com>, <kevin.tian@intel.com>,
        <ashok.raj@intel.com>, <maz@kernel.org>,
        <peter.maydell@linaro.org>, <vivek.gautam@arm.com>,
        <shameerali.kolothum.thodi@huawei.com>, <wangxingang5@huawei.com>,
        <jiangkunkun@huawei.com>, <yuzenghui@huawei.com>,
        <nicoleotsuka@gmail.com>, <chenxiang66@hisilicon.com>,
        <nicolinc@nvidia.com>, <vdumpa@nvidia.com>,
        <zhangfei.gao@linaro.org>, <zhangfei.gao@gmail.com>,
        <lushenming@huawei.com>, <vsethi@nvidia.com>,
        Sachin Nikam <Snikam@nvidia.com>,
        Sumit Gupta <sumitg@nvidia.com>,
        Pritesh Raithatha <praithatha@nvidia.com>
References: <20211027104428.1059740-1-eric.auger@redhat.com>
From:   Sumit Gupta <sumitg@nvidia.com>
Message-ID: <4921cd06-065d-951d-d396-ee9843882c40@nvidia.com>
Date:   Fri, 3 Dec 2021 18:43:40 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211027104428.1059740-1-eric.auger@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 251edf06-843c-40b0-634a-08d9b65eca94
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5438:|SJ0PR12MB5423:
X-Microsoft-Antispam-PRVS: <SJ0PR12MB543849E99A265D439137EDC4B96A9@SJ0PR12MB5438.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NXROclllbmlya2xDMjA3SEVvVkpSRkE2cnRoWVZ4bktBU1lvdGdNSXkwNGkz?=
 =?utf-8?B?V1VHUlpOUStNc0F6ZVcraFdpeTZHWGRDcVdSODkwS1AvTGRkbkFEUEsxclE3?=
 =?utf-8?B?Q0c1UFpsdUJtZDdqSXQ5Y2NPVEZQcGtnUUhCT0szdldTNWdCeG91bGg5Ukt3?=
 =?utf-8?B?U0hSalF5dmI1bGdJNjZNMlgwbU5BYUNIb3M2SkYzU3Vwek5qQ1lia055NmhC?=
 =?utf-8?B?SHBvZHY0cjhYbkVtZUJQREo4cDVXcVBPdFREM0EwTFRGN1RPL1Z4ZWV1eFlL?=
 =?utf-8?B?OFpNZjB6ZEFFMjFrakRvQlp6SG9mZTF3ZTFZUEZvTTF3RW1jWmoramtyTDVH?=
 =?utf-8?B?K1l1YUpFSVh2enlIcnRlZG5KY1Y4cTB1QmZURVM2bys4MjhaNFQyOXFmTW9m?=
 =?utf-8?B?eGlkcDQxUCtvNzAwaUh5VGpvN05Ecm9PaDRYOGdSZFV5WmFucHpMRk96bm9y?=
 =?utf-8?B?d0NKTmJueXZ3ZlA5N3g1WGhHSGFOcDdkS09wVFNMNFlvQzNWejdDQWVxc3lZ?=
 =?utf-8?B?b0FnZ2dBSHVKelk4dHUrYXBPV1FCell2RFg2TGlDN01NSE1iVDJ1aXZKOS9i?=
 =?utf-8?B?d2R1UnlscWxrUUhmM0UvQnArTkxXWVgzNHJ5U0tOM0pFUkhwczU4N1dGRXUx?=
 =?utf-8?B?UXNNNFB5K1ZkdGRqN3BhdzlIRzE0NkRHRlp1d2RnSlMySmUzcDNBUU9SL1ZM?=
 =?utf-8?B?OGpYRTVVc2xoTzBONE1WMFE0TEwwNVo5MFBDbUZRVFpMU2dZVnB5YXpoUkFh?=
 =?utf-8?B?RDl5cEFwbkdQbnhpc09iZk1VQTh4c0MzZlZyV2ZZTGVnY1Q2K3pOb1BnbHZK?=
 =?utf-8?B?RmluNXBYdGMrM29JMk9QSlRFNjdLbCtuVTIvL2tCWVR3cUJIekdJbHpZSGRy?=
 =?utf-8?B?aVBwR3BEb1ZvM0htQXZVU3VkOXZORURmSTFXRjB3QlZ2ZDlyWktQZTBUTHlI?=
 =?utf-8?B?RS9tNDQvdFhqa2FqQjgwazlGR01jUUl4R2RsQ1dpcWhnS0dnQ2k4bkR3UWVE?=
 =?utf-8?B?bGdCQ3lTZjd5Z2Z4R1RDQVFJeHQ0WDJxcW5mM0RkUTJuQVZ4TUFTU3ZrcnlI?=
 =?utf-8?B?RFlmM1VoS2xmR2ZLNEd1ZWxMdnJ3RUVtRjNUQzRpVzl6T0M1UlFZbjNlTEll?=
 =?utf-8?B?SElJbFl6MFlTOGg2aVZxNG9Zdit5anV0ek1yd2ZOYWk4ZVZ5R2RoT3V6L3hH?=
 =?utf-8?B?WWpXM2l4bXNzejFZbHZ1NW5Uc1FDcTRHKzZ1N0Z1QVhmR0dGZEc4blB5RmN0?=
 =?utf-8?B?Y05DaXhGTnRPRWZuMmRJejhubVEzUDhRYWFtbGFOam0vMXZkOHRXMzRUMEE1?=
 =?utf-8?Q?JQ/EhYgxd+jqw=3D?=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(2906002)(966005)(83380400001)(70586007)(31686004)(316002)(7636003)(426003)(16526019)(2616005)(107886003)(8936002)(921005)(54906003)(16576012)(4326008)(36860700001)(356005)(186003)(5660300002)(47076005)(31696002)(82310400004)(7416002)(110136005)(70206006)(36756003)(86362001)(40460700001)(508600001)(336012)(8676002)(26005)(43740500002)(83996005)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 13:14:08.9820
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 251edf06-843c-40b0-634a-08d9b65eca94
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5423
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

> This series brings the IOMMU part of HW nested paging support
> in the SMMUv3.
>
> The SMMUv3 driver is adapted to support 2 nested stages.
>
> The IOMMU API is extended to convey the guest stage 1
> configuration and the hook is implemented in the SMMUv3 driver.
>
> This allows the guest to own the stage 1 tables and context
> descriptors (so-called PASID table) while the host owns the
> stage 2 tables and main configuration structures (STE).
>
> This work mainly is provided for test purpose as the upper
> layer integration is under rework and bound to be based on
> /dev/iommu instead of VFIO tunneling. In this version we also get
> rid of the MSI BINDING ioctl, assuming the guest enforces
> flat mapping of host IOVAs used to bind physical MSI doorbells.
> In the current QEMU integration this is achieved by exposing
> RMRs to the guest, using Shameer's series [1]. This approach
> is RFC as the IORT spec is not really meant to do that
> (single mapping flag limitation).
>
> Best Regards
>
> Eric
>
> This series (Host) can be found at:
> https://github.com/eauger/linux/tree/v5.15-rc7-nested-v16
> This includes a rebased VFIO integration (although not meant
> to be upstreamed)
>
> Guest kernel branch can be found at:
> https://github.com/eauger/linux/tree/shameer_rmrr_v7
> featuring [1]
>
> QEMU integration (still based on VFIO and exposing RMRs)
> can be found at:
> https://github.com/eauger/qemu/tree/v6.1.0-rmr-v2-nested_smmuv3_v10
> (use iommu=nested-smmuv3 ARM virt option)
>
> Guest dependency:
> [1] [PATCH v7 0/9] ACPI/IORT: Support for IORT RMR node
>
> History:
>
> v15 -> v16:
> - guest RIL must support RIL
> - additional checks in the cache invalidation hook
> - removal of the MSI BINDING ioctl (tentative replacement
>    by RMRs)
>
>
> Eric Auger (9):
>    iommu: Introduce attach/detach_pasid_table API
>    iommu: Introduce iommu_get_nesting
>    iommu/smmuv3: Allow s1 and s2 configs to coexist
>    iommu/smmuv3: Get prepared for nested stage support
>    iommu/smmuv3: Implement attach/detach_pasid_table
>    iommu/smmuv3: Allow stage 1 invalidation with unmanaged ASIDs
>    iommu/smmuv3: Implement cache_invalidate
>    iommu/smmuv3: report additional recoverable faults
>    iommu/smmuv3: Disallow nested mode in presence of HW MSI regions
Hi Eric,

I validated the reworked test patches in v16 from the given
branches with Kernel v5.15 & Qemu v6.2. Verified them with
NVMe PCI device assigned to Guest VM.
Sorry, forgot to update earlier.

Tested-by: Sumit Gupta <sumitg@nvidia.com>

Thanks,
Sumit Gupta

