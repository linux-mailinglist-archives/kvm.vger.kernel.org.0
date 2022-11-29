Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63A4163C943
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 21:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236152AbiK2UaQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 15:30:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236339AbiK2UaB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 15:30:01 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2081.outbound.protection.outlook.com [40.107.212.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8BCE654C5
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 12:29:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cxj4qzeVsDOyTNjFam6x1IxJ1ioP/hOzZ3Meoc+LXmTCxdp2ypygB1uLWUhCCTeBZp7GBsPPZNHZYOC3tAWhcCGin7yagIXf5DpqEk1LwlbAmSeHVb95UmA4zVduiUtYsASdeDPBg+FClVFpZwqSk3KkioT/GlOsviojXKtVFPaMcGP2TNIYMCFn1upPfhTvtnHABVEZdZAhvwoQu2AUSwcfryOydnVzhUcJx5b8zD09SRH/DKbYm2/T9SKYje5blBjljnpbFO8jIMReIrK2JLG+08wVak8wKqEGtV8V/P4tfSUeHmss4oGfshK6WuIYDj5zLErLT4az2ZHzEZ0G4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rMH7PvM34Pi2CLKEPoGj9UVurzvi+AgdQeqau4NKmFE=;
 b=V3IHGrMZaeIUd9ZED2fAGRloEYvXMThkH3+wtnJdJZ4H7rQfgi1PHPBn1S9+uxCXqdDNrsB4pkcf+Qi7STkykxXJqANVQIYEvHmEDO+XlpypUqwFG/b9da3uqzrs+c3T0/AtuLKBUPVM5ccvsBEBlaNsqj1R20vqtn4QOI1kk4WNwc0evNKBa8+2wnyk+GotvF/p6HuzjDYMwz2fHvVdJVOGVSjbce9gHeB3loYAfrUvtsqYtCP6elNvkF6pshhs6diaAh1GhxKV6UHx+bE9mxx54lr/xOvHz0WyMahnrPXGcynLff9k2CuwczTRlMM6NAXv4cM+P91RcfGxAs6P6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rMH7PvM34Pi2CLKEPoGj9UVurzvi+AgdQeqau4NKmFE=;
 b=lrGMeu2IEWdTfoRpr/ogqk9xbIWqNfj6UwaQeVGa1WGAHf7Th7rDXhi8y0pcyyIQ1oU4hjsO7hV1/ftQm3hazztzQAgEt4ZOGSESSYCaTzbJVqZGSY0zK4luy+n9RQcVdSCwA5FtZMQz35n2BItqm+fMmY7wVgx3X8FEpQOA9w+Lg6W/IltAWs1GYo6wVPkBppUmnIffiSTzA3hicrBTypIgvlbPLnxcpTv2yz6irI97UARg/B17msww1sriA7Ua1NJ0qKyunLReToP7uh7WkY0xHDqNL8n7mhlcU6A5Q1g6COOE5VSKFj4NYV6eYJdmDX6GXtfWdqoXdg+TiULqhQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY5PR12MB6059.namprd12.prod.outlook.com (2603:10b6:930:2c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 20:29:53 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 20:29:53 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Anthony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH v6 12/19] iommufd: Add a HW pagetable object
Date:   Tue, 29 Nov 2022 16:29:35 -0400
Message-Id: <12-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0007.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::12) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY5PR12MB6059:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cd6b51a-7daa-4555-7791-08dad2487589
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TDp20JJIU5bVT0PVlEtKaaiDLvZwTHa65+Aa6VHr9v3E+gDpRtKOtgEyBminLc2LnvV1jPGTbxWJVtPCXnXzM+c5jAqMhQ5zln/MoJF1LeEwqf7Sbq1Jtt0oSmCVaA8lkLTIhVbplL4F9j/E99T/M6mOOHkfSmyfyBoCFeKun1XeQ3RZxNKiz2ag1frKyhqdJJ9UHwpQ7RJRyj2BoSbQ8SN852kW3Xw9EKZGyIMH3DoCp5Eb676EEQqM0eKGGuYvVAfEF8dOU/510ca5JWfMjGKn2S6Wv6UOSlxFxh/5RxOiInc0MgW8JFh51vkpPclm9Ot5wO2poEeb4OfH6WuLH3yiuK4nSzBtuGJMhy38RRGsxdnx4lRxqlnpJJ9YK+ktiXo/lUsP5K0rwDGy1WBxc49xVMXdZvfVE8AFW9Zci5L9klUDDXUc9THUiyul6LQPpTeaZ8p/1PJFA8Mz0xBSxlHCnrb+Bx7KUYddMOkwyqNNiWl1tLXgxZOm8YsE6NA1Tk4yzvdHw4WllQR01FAE+qpn96lTSQvZxuO/4+j678Ix31/nEthPqaG9dR+NOgdlPFAW8pvuwYFFHd1/PSfLZbbse4C438Qu6ccDR2ACGfinILJ+fU5Czv0u36aJI83ef1JGlE8SjIkCO2+e+JmgvRHaO4aCjiMTARvWCX0vOXnXQTu75JHWESBClHzLORyh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(451199015)(109986013)(36756003)(86362001)(54906003)(6486002)(316002)(478600001)(2906002)(66476007)(66556008)(66946007)(4326008)(8936002)(7416002)(41300700001)(8676002)(5660300002)(83380400001)(38100700002)(26005)(6506007)(6666004)(6512007)(186003)(2616005)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fpaBG3iztK2wwxcIx3wEHhPfCW5pP5nBKbKV1cC+ub+33ixZvY52TzH8gone?=
 =?us-ascii?Q?ODdg3rwqRde8L/JQJd1NwXgfYOH7xKxBXfrG2v0hdzMU8S9ji3OHSmxLxeUD?=
 =?us-ascii?Q?dyJezYfRdmB4umWdB4h3fGynTDsHybEuMFrPXCAbFMW2eL3jdjjl2megK89i?=
 =?us-ascii?Q?YD++Lkvsx5A6Z/s0LtLchBCWCG46ECJT15YQ/cozam6In3Jr0vrqbE5qSx9V?=
 =?us-ascii?Q?IVSWhg/R6eYKB+s7Ph148QwpMuXTYRpnZtAbsUTV6FTKPw8zcDlvty+zcH7i?=
 =?us-ascii?Q?GGPz7DiZM38jlu+OSBHIYPFIVJnQAUKFm3OmNHKUdNL+CcJVhCCTfsbGpZJ2?=
 =?us-ascii?Q?+nhn6uYz16TGjEhacxL/WEsytVj9e6h8uwUb8CXbDbBABKmqYPL1Rt1y5Lpb?=
 =?us-ascii?Q?khZb2Z86GiDb74pcSik4V2xEJBaiP4xNu0WuH4QEZF7r8AI+hD3jEm8/YZUC?=
 =?us-ascii?Q?qULSBgp/WsJzvllvDC5kBKs8fMbi7yDxY3HIpmgargVJK+dQEKN//0chBYML?=
 =?us-ascii?Q?42OlDcO0i6Y3N7UghbpIDugXHn8yVUPtld/O+LKAIMdncS8fWnmVD4tBSQ/I?=
 =?us-ascii?Q?CGfUV42DzmGjUHsihYcSwHAX6FxSEGfZVBlUhBJREnQOry13URD8fMXvbz1a?=
 =?us-ascii?Q?FaAoFGjtXAeujXPAOALCeakYTSgJHxjeaW/y+LdUEV+gwyLa2CU2NumCsARi?=
 =?us-ascii?Q?/2IBvIX1VnPKTgNIvfVmiPwM+wzvHCXPieijYtnXzaF2NW2f/HHPyA3bb5cF?=
 =?us-ascii?Q?F4k2pHpJVROla7CJA5F0LZ36LoSTcDSk9SSRkO++Isr4nkwiM2tJro1Oz/At?=
 =?us-ascii?Q?TX/9VcGB84JrSlvBCGHMvgcns6gpZGGp8Uv7SrJVHnYXYcJ80GNBVMtD9w3K?=
 =?us-ascii?Q?AWQ/zWfg3rDcZbP+nd1JnysN5JAqQkbeyRfK0nrRFq3W5NVkFQKHPLcMd4Xg?=
 =?us-ascii?Q?NXKMr217HnAkAzogHluCJpsInAQnJVIatoblBDhC5eZ23/ss5e36SyYzHfmm?=
 =?us-ascii?Q?/YeYMqWBHAEDPRwJ4Xtg6l7Y48uFet+U0NeT9aN8y2GJLOirDZwkqUGqswbk?=
 =?us-ascii?Q?rxrNGgwD+Ok7nj24KwiEygXr9MGb3fwWbMLIfoLVAsbFmUiZ3E3ldwfxDXng?=
 =?us-ascii?Q?0//GadnXt6TDGqFY06LO9eA2j9+789ayAauXwRlQmpFM8bOOpIx1OQ47mRMx?=
 =?us-ascii?Q?1Hm3o1pQtpNKyJ+3r9+M/oKv4d/wJ5QtFy7ORdYGqRX/hCrLNZk7hiX6lYO0?=
 =?us-ascii?Q?v1UqA2WeyhgMVOcctJJPtTi3ca7nUBywFhSPEWg4oYNMiLdWrul9dmSlzkan?=
 =?us-ascii?Q?/n1u/nkm2W5IOguqtK9PFeKoKpnrvInLpNNmh1Wwv1IROPd48S+skpgpmI+o?=
 =?us-ascii?Q?FXFU2wE7b2IhHFsVMt3FgOEAkqUv9oo4ZCKvZeYS7kc0fg45Nx/iHsGryOwk?=
 =?us-ascii?Q?TB1GbQSVYtf7OCNUQVC/bMoSVRgZYdcM8R1nNXXelBUkH2LojveIl/5wgBFC?=
 =?us-ascii?Q?0UU55HtXaMPSgTNlkrc21xLuMLw7gSBJ+R4BWOxEbkYFavkUMyXmgR3vy8MH?=
 =?us-ascii?Q?yrpSJPVTGr+flp74d8Fau1OtoELxVI+wk2gX2s1x?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cd6b51a-7daa-4555-7791-08dad2487589
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 20:29:48.1361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9cO8GZkWm72bZVeEKv57/vehVPC08ii3RWuU/YUaYtK8o7PVYw20f6oNqI3VXGic
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6059
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The hw_pagetable object exposes the internal struct iommu_domain's to
userspace. An iommu_domain is required when any DMA device attaches to an
IOAS to control the io page table through the iommu driver.

For compatibility with VFIO the hw_pagetable is automatically created when
a DMA device is attached to the IOAS. If a compatible iommu_domain already
exists then the hw_pagetable associated with it is used for the
attachment.

In the initial series there is no iommufd uAPI for the hw_pagetable
object. The next patch provides driver facing APIs for IO page table
attachment that allows drivers to accept either an IOAS or a hw_pagetable
ID and for the driver to return the hw_pagetable ID that was auto-selected
from an IOAS. The expectation is the driver will provide uAPI through its
own FD for attaching its device to iommufd. This allows userspace to learn
the mapping of devices to iommu_domains and to override the automatic
attachment.

The future HW specific interface will allow userspace to create
hw_pagetable objects using iommu_domains with IOMMU driver specific
parameters. This infrastructure will allow linking those domains to IOAS's
and devices.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Lixiao Yang <lixiao.yang@intel.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/Makefile          |  1 +
 drivers/iommu/iommufd/hw_pagetable.c    | 57 +++++++++++++++++++++++++
 drivers/iommu/iommufd/ioas.c            |  3 ++
 drivers/iommu/iommufd/iommufd_private.h | 33 ++++++++++++++
 drivers/iommu/iommufd/main.c            |  3 ++
 5 files changed, 97 insertions(+)
 create mode 100644 drivers/iommu/iommufd/hw_pagetable.c

diff --git a/drivers/iommu/iommufd/Makefile b/drivers/iommu/iommufd/Makefile
index 2b4f36f1b72f9d..e13e971aa28c60 100644
--- a/drivers/iommu/iommufd/Makefile
+++ b/drivers/iommu/iommufd/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 iommufd-y := \
+	hw_pagetable.o \
 	io_pagetable.o \
 	ioas.o \
 	main.o \
diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
new file mode 100644
index 00000000000000..43d473989a0667
--- /dev/null
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -0,0 +1,57 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES
+ */
+#include <linux/iommu.h>
+
+#include "iommufd_private.h"
+
+void iommufd_hw_pagetable_destroy(struct iommufd_object *obj)
+{
+	struct iommufd_hw_pagetable *hwpt =
+		container_of(obj, struct iommufd_hw_pagetable, obj);
+
+	WARN_ON(!list_empty(&hwpt->devices));
+
+	iommu_domain_free(hwpt->domain);
+	refcount_dec(&hwpt->ioas->obj.users);
+	mutex_destroy(&hwpt->devices_lock);
+}
+
+/**
+ * iommufd_hw_pagetable_alloc() - Get an iommu_domain for a device
+ * @ictx: iommufd context
+ * @ioas: IOAS to associate the domain with
+ * @dev: Device to get an iommu_domain for
+ *
+ * Allocate a new iommu_domain and return it as a hw_pagetable.
+ */
+struct iommufd_hw_pagetable *
+iommufd_hw_pagetable_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
+			   struct device *dev)
+{
+	struct iommufd_hw_pagetable *hwpt;
+	int rc;
+
+	hwpt = iommufd_object_alloc(ictx, hwpt, IOMMUFD_OBJ_HW_PAGETABLE);
+	if (IS_ERR(hwpt))
+		return hwpt;
+
+	hwpt->domain = iommu_domain_alloc(dev->bus);
+	if (!hwpt->domain) {
+		rc = -ENOMEM;
+		goto out_abort;
+	}
+
+	INIT_LIST_HEAD(&hwpt->devices);
+	INIT_LIST_HEAD(&hwpt->hwpt_item);
+	mutex_init(&hwpt->devices_lock);
+	/* Pairs with iommufd_hw_pagetable_destroy() */
+	refcount_inc(&ioas->obj.users);
+	hwpt->ioas = ioas;
+	return hwpt;
+
+out_abort:
+	iommufd_object_abort(ictx, &hwpt->obj);
+	return ERR_PTR(rc);
+}
diff --git a/drivers/iommu/iommufd/ioas.c b/drivers/iommu/iommufd/ioas.c
index 6ff97dafc89134..302779b33bd4a5 100644
--- a/drivers/iommu/iommufd/ioas.c
+++ b/drivers/iommu/iommufd/ioas.c
@@ -17,6 +17,7 @@ void iommufd_ioas_destroy(struct iommufd_object *obj)
 	rc = iopt_unmap_all(&ioas->iopt, NULL);
 	WARN_ON(rc && rc != -ENOENT);
 	iopt_destroy_table(&ioas->iopt);
+	mutex_destroy(&ioas->mutex);
 }
 
 struct iommufd_ioas *iommufd_ioas_alloc(struct iommufd_ctx *ictx)
@@ -28,6 +29,8 @@ struct iommufd_ioas *iommufd_ioas_alloc(struct iommufd_ctx *ictx)
 		return ioas;
 
 	iopt_init_table(&ioas->iopt);
+	INIT_LIST_HEAD(&ioas->hwpt_list);
+	mutex_init(&ioas->mutex);
 	return ioas;
 }
 
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index 1a13c54a8def86..6b0448702a956d 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -103,6 +103,7 @@ static inline int iommufd_ucmd_respond(struct iommufd_ucmd *ucmd,
 enum iommufd_object_type {
 	IOMMUFD_OBJ_NONE,
 	IOMMUFD_OBJ_ANY = IOMMUFD_OBJ_NONE,
+	IOMMUFD_OBJ_HW_PAGETABLE,
 	IOMMUFD_OBJ_IOAS,
 };
 
@@ -181,10 +182,20 @@ struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
  * io_pagetable object. It is a user controlled mapping of IOVA -> PFNs. The
  * mapping is copied into all of the associated domains and made available to
  * in-kernel users.
+ *
+ * Every iommu_domain that is created is wrapped in a iommufd_hw_pagetable
+ * object. When we go to attach a device to an IOAS we need to get an
+ * iommu_domain and wrapping iommufd_hw_pagetable for it.
+ *
+ * An iommu_domain & iommfd_hw_pagetable will be automatically selected
+ * for a device based on the hwpt_list. If no suitable iommu_domain
+ * is found a new iommu_domain will be created.
  */
 struct iommufd_ioas {
 	struct iommufd_object obj;
 	struct io_pagetable iopt;
+	struct mutex mutex;
+	struct list_head hwpt_list;
 };
 
 static inline struct iommufd_ioas *iommufd_get_ioas(struct iommufd_ucmd *ucmd,
@@ -207,6 +218,28 @@ int iommufd_ioas_option(struct iommufd_ucmd *ucmd);
 int iommufd_option_rlimit_mode(struct iommu_option *cmd,
 			       struct iommufd_ctx *ictx);
 
+/*
+ * A HW pagetable is called an iommu_domain inside the kernel. This user object
+ * allows directly creating and inspecting the domains. Domains that have kernel
+ * owned page tables will be associated with an iommufd_ioas that provides the
+ * IOVA to PFN map.
+ */
+struct iommufd_hw_pagetable {
+	struct iommufd_object obj;
+	struct iommufd_ioas *ioas;
+	struct iommu_domain *domain;
+	bool auto_domain : 1;
+	/* Head at iommufd_ioas::hwpt_list */
+	struct list_head hwpt_item;
+	struct mutex devices_lock;
+	struct list_head devices;
+};
+
+struct iommufd_hw_pagetable *
+iommufd_hw_pagetable_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
+			   struct device *dev);
+void iommufd_hw_pagetable_destroy(struct iommufd_object *obj);
+
 struct iommufd_access {
 	unsigned long iova_alignment;
 	u32 iopt_access_list_id;
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 1c0a1f499378db..ac6580a7b70660 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -360,6 +360,9 @@ static const struct iommufd_object_ops iommufd_object_ops[] = {
 	[IOMMUFD_OBJ_IOAS] = {
 		.destroy = iommufd_ioas_destroy,
 	},
+	[IOMMUFD_OBJ_HW_PAGETABLE] = {
+		.destroy = iommufd_hw_pagetable_destroy,
+	},
 };
 
 static struct miscdevice iommu_misc_dev = {
-- 
2.38.1

