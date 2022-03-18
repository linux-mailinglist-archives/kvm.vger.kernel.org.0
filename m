Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 684AC4DDFE8
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 18:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239646AbiCRR3O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 13:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239640AbiCRR3N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 13:29:13 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2069.outbound.protection.outlook.com [40.107.93.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2790C393E0
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 10:27:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GMpQe1SSTGq/Q62l6FS4zaLZs6j3GEQd6AzbEepu1m39nBEIgX4gBTaKCke7z6quLs5iAY6ZVfC83LVv7zj9Ord+ivqLQ3zPqlbp8lvWOt1e8DIRJfahlNnTmfOJj/W3QwfmyJYrWDEpsv9VKSMyf+3zd/41/h9fkivhWHUYkBNq6gHP8BdnR3lpLBQO6m6egaaSmVxUo5KsA8t0MXJBPn3QGpc5jOit0b2T3z5hbNH+RGqKH8kSRbyZxAZ6t7E47rnwoG9PWcAWsSD89sDTrC8jpfdF0kr3ENkdRx5wj7u/vvo4ugSjPzBF/8PBUbwz67UljT+vaFarUrVgNu93ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ONv+0KDNreWAYJWs2MpSokXFJsmA3GE+3NAAK8P/NSE=;
 b=HDqimjuQqkQ8HkAzp/0Qm3dcsi2+djcBlQbKELYJuLxPucxxWomox+Q07RUm3SZSFisPHRK3xSSPWiXWtdmkDyLvlVD133bkpTgQ8ybT4QUCYNHjgDXfy7OXK63CHYzFsVPXRizq2jZM6pwKFEfBfAbHupf66BjULsFrFFFIclg+FM6zhpydM4S6jVWiGF8Hi5RVQUtu5cgTz5fgoOwp/tAFm2RQfFVgdjMK4XUl7Ux13hdXuieqqZ1pHf7NLbD5NjFc0LVx8XZSerihCKRNRSxix3nVZqH59Y1SJ858acBhe4F5F0jqLHXx6HJ+VOGSbQlsLs/Hg2CoOmxkftonqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ONv+0KDNreWAYJWs2MpSokXFJsmA3GE+3NAAK8P/NSE=;
 b=reJcZVk6vS7fiQT495EK/mxVdI5vga8ee7tqukDds28L2pH3U8ZtgTDXr6SCPyf3sf8ReTgkfBNQXOFUztxb3H+8QMdn0ww45jOCXKvGiT3CdyAN/N3kgTWcSLD9/YvinpSVqb27xp9ZCA3LPprdKTi814x8RQVgAa4kJpBhV0WtBnUUE8hMPKNDD7qwErVMBa6LxQpJvvsvaJybHTw5s+A/moFTsaJ/LNJApZfSwCcrMSrdHbzY+1hEJsSEa0o5lPWrYYqKfHpIZZOqB2ylYoBz8YzRmevqpcUZWe7hCdVus3TWch3rGBGJK4+UYerCkTDeA2d4A5pUiZhObrzVoA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB3951.namprd12.prod.outlook.com (2603:10b6:208:16b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Fri, 18 Mar
 2022 17:27:45 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%5]) with mapi id 15.20.5081.018; Fri, 18 Mar 2022
 17:27:45 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH RFC 03/12] iommufd: File descriptor, context, kconfig and makefiles
Date:   Fri, 18 Mar 2022 14:27:28 -0300
Message-Id: <3-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0031.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::44) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6eec94b0-70df-49d1-57fa-08da09049aea
X-MS-TrafficTypeDiagnostic: MN2PR12MB3951:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3951BA287CA6BA50158100A9C2139@MN2PR12MB3951.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fEt78cwZHPOveK7VbanxSK9HS20IJ4U6xPsLLlrIlrC8/8k5dZI+RsjLsuwpgDS87BrDXX3ast2rd1mV1cTPfQdrV0pkeMvHF5JVLjiqhSXicL2vz19RAzUcXBAOdn2EohJbfGcaGwRupch+XXk3qkn/fuMAMOXS5hofmasQZJBEVLP5A2tSEI/6dJqQrRBhpibKQ8k8mK0H0WaqKWQVi9Vo3nLsj3nrZIU13Tg7pqCSOs144DPNM3PRIyURX0YW8VAR5P/XyvF0eTOBcUsCiCSKCFEg23qWrXvOGFmAvmOu1Cuu+NiQN+agbxU3OJbGAPjSxhKeBrwYnALk6HQAoweE8TodbJe0xZ1tYn3+izh9xyMzQcKJKl+VzyAH+k+Gx+RRLMaTAbUvKjqB7+2fJtnvMOIsSK5KP/OHltF5r9EwWCdL7dzyROlRqK6Q0E15WRMwOEzYp2F/Gz5EjLX5NcWu6lI4sRILF54zv4+6PL0QUDIzK0cxKhntoqZR0niSDB+2mnZTLfhDA5zmrzUQQaB+4ao2RlxXj3+nrN1p8nSg/wekKAzbYVVJYD9z8KLmjHqaCwvh1S6WDQWuJ0cfj+CXVx828N/5MYmVrMT15VmAqqfi4MItssuVcvUfk1izJzRh7V6YcRgwVllhm/aT29YrroOqETndCb4mrg1a7r2/qjq25tYTRWftLF9m6FDqSU03L4hCFvFW2qrbkWbF6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(30864003)(83380400001)(7416002)(4326008)(2906002)(86362001)(508600001)(8676002)(6512007)(6506007)(6666004)(5660300002)(8936002)(109986005)(66946007)(26005)(66476007)(186003)(316002)(66556008)(2616005)(36756003)(38100700002)(6486002)(54906003)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LhbmqTielRnc9g2VgyvRyIZH6g7g7a29nWCM2y5SCkqDe0ol9BIG17A8Dlr8?=
 =?us-ascii?Q?o4HBmEU6rcwIR004CUcdwAkwgxc0a0D0phNG92hQVAndExHlXRdMmqQpq5KR?=
 =?us-ascii?Q?/0d1M63f1iOzq9pn6aDKlFGhvAeNkeXRr+iaLHV5vGnfOG2jDgZ7YXcJ84zK?=
 =?us-ascii?Q?evIKflr5d8g4n1f5wWeyESB56dYzf5Q+60pWoFOt3kJqGuGD+aPULlTvcJqn?=
 =?us-ascii?Q?BPmvsljoVtuwPuFRVaRuw1b+PhvCdnMGex/8OukoblqGrKsE/L8JiA9dPBIV?=
 =?us-ascii?Q?Ug3lLB8uBu4Xacr2nzRzO219C7fzmGWEP9DsMZ45ObJaQA3LG3BD4TgLSDxH?=
 =?us-ascii?Q?hG1xbTzAlskOS8ZhKxaO2PKGfgFQgT/0NW7177mZ66jL4TkhKw2Fks5M5h0h?=
 =?us-ascii?Q?cFiwsPakCs+ZKDfu2/a+p5YFtfmcaYdPYAE8KywP4xPcC5LxbTOQaCVTVuST?=
 =?us-ascii?Q?AJvdL5I2/1j41VdRKJ0WpgKGEL0W6daqV1da574D4iCgPi06UXLeZkPzxIAM?=
 =?us-ascii?Q?4PxhApOXBsWZOh54VmDFdHHyuVPGZ7Yw6hDMR7uv6byRTS1+gveKeqzl8u/+?=
 =?us-ascii?Q?rMf7FU3Xmc2SwYMJHCMwGhfVWvwrXQP67LBlnFFo4+QQgpqBz1jGqoC/s0B/?=
 =?us-ascii?Q?ABhRXqiVqfLYWMTQCD2h+iot/HWyt6IV5BBGSX6dudA1vj+8uFzcD1ndBJZA?=
 =?us-ascii?Q?DCZTwshf/vYGLglw/rMkKjl1aSER0lk4CSGSjUcjBZPlbVSwM+nFtB3bAoas?=
 =?us-ascii?Q?5dTCOMXdIvT91kM5EMsYSawUFsNkY5v2616DW/5PFAlZ0y0ixmCFN0QA67QP?=
 =?us-ascii?Q?MCa2aLmVaIJhhJtMX5L2v50Bfj+PaUn1SUUfpkDx0rq60InOK0GXH4v8QArr?=
 =?us-ascii?Q?MIuy3LyzqQsM52q/PluQsFw+bFtpHxWTgdeBw4kAcDJCWHUN9FaaxKFf+zoi?=
 =?us-ascii?Q?3D2g0v3f51SP4EEpXfB/t2PyVHyeAxdz+0Ct9q+KdXuCTXfD08LobM3xduJn?=
 =?us-ascii?Q?fxA2pfLHwcHq+ruvye+Njj6YLu1iTyFNmENW/8oPj1KeXxIsEmhBZn95FfjP?=
 =?us-ascii?Q?UpKtngbq+tBwUwthdKYNrAl4cb1bFWIGObfdkTi37CM2ReVCevndTrJGlJfA?=
 =?us-ascii?Q?ZzTA2exqvn01gSovOS/h4iKEnlvG+GGXo7JI1qJaHQqXBGFYjdadHejoeMCQ?=
 =?us-ascii?Q?at9MNL70J8QfYzj32xBNPjZzxaZDT9PHZX83JHeqYSrJZeVw6G2N19YC6mgC?=
 =?us-ascii?Q?TD9Mr4GprUQNn+H5GxE6jjkQzSVMFp3ygrzlC6alZKkrqUtPixVkFiep/SBL?=
 =?us-ascii?Q?Df9mjWS7TbmQzSRh9S9ikcg9RfLxC+bYVuNrsYbfuYIkmqZQ7JGs9Y9iIMuM?=
 =?us-ascii?Q?k36lfF6Pv4BSXmsnlRWbvg6gvU/caojH0EX1OoZBJW6NVeo95o3TrqiTSrjZ?=
 =?us-ascii?Q?AXhm8NaWXn3OVV/m1sNinUWEsO3epZ1Q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6eec94b0-70df-49d1-57fa-08da09049aea
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 17:27:41.2258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jQt4b9EFGdJtvKnF9KphbftwQJ9A2wT67DviemQNesaRMxkwfPpjmXr5v8N0y99V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3951
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the basic infrastructure of a new miscdevice to hold the iommufd
IOCTL API.

It provides:
 - A miscdevice to create file descriptors to run the IOCTL interface over

 - A table based ioctl dispatch and centralized extendable pre-validation
   step

 - An xarray mapping user ID's to kernel objects. The design has multiple
   inter-related objects held within in a single IOMMUFD fd

 - A simple usage count to build a graph of object relations and protect
   against hostile userspace racing ioctls

The only IOCTL provided in this patch is the generic 'destroy any object
by handle' operation.

Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../userspace-api/ioctl/ioctl-number.rst      |   1 +
 MAINTAINERS                                   |  10 +
 drivers/iommu/Kconfig                         |   1 +
 drivers/iommu/Makefile                        |   2 +-
 drivers/iommu/iommufd/Kconfig                 |  13 +
 drivers/iommu/iommufd/Makefile                |   5 +
 drivers/iommu/iommufd/iommufd_private.h       |  95 ++++++
 drivers/iommu/iommufd/main.c                  | 305 ++++++++++++++++++
 include/uapi/linux/iommufd.h                  |  55 ++++
 9 files changed, 486 insertions(+), 1 deletion(-)
 create mode 100644 drivers/iommu/iommufd/Kconfig
 create mode 100644 drivers/iommu/iommufd/Makefile
 create mode 100644 drivers/iommu/iommufd/iommufd_private.h
 create mode 100644 drivers/iommu/iommufd/main.c
 create mode 100644 include/uapi/linux/iommufd.h

diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
index e6fce2cbd99ed4..4a041dfc61fe95 100644
--- a/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -105,6 +105,7 @@ Code  Seq#    Include File                                           Comments
 '8'   all                                                            SNP8023 advanced NIC card
                                                                      <mailto:mcr@solidum.com>
 ';'   64-7F  linux/vfio.h
+';'   80-FF  linux/iommufd.h
 '='   00-3f  uapi/linux/ptp_clock.h                                  <mailto:richardcochran@gmail.com>
 '@'   00-0F  linux/radeonfb.h                                        conflict!
 '@'   00-0F  drivers/video/aty/aty128fb.c                            conflict!
diff --git a/MAINTAINERS b/MAINTAINERS
index 1ba1e4af2cbc80..23a9c631051ee8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10038,6 +10038,16 @@ L:	linux-mips@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/sgi/ioc3-eth.c
 
+IOMMU FD
+M:	Jason Gunthorpe <jgg@nvidia.com>
+M:	Kevin Tian <kevin.tian@intel.com>
+L:	iommu@lists.linux-foundation.org
+S:	Maintained
+F:	Documentation/userspace-api/iommufd.rst
+F:	drivers/iommu/iommufd/
+F:	include/uapi/linux/iommufd.h
+F:	include/linux/iommufd.h
+
 IOMAP FILESYSTEM LIBRARY
 M:	Christoph Hellwig <hch@infradead.org>
 M:	Darrick J. Wong <djwong@kernel.org>
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 3eb68fa1b8cc02..754d2a9ff64623 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -177,6 +177,7 @@ config MSM_IOMMU
 
 source "drivers/iommu/amd/Kconfig"
 source "drivers/iommu/intel/Kconfig"
+source "drivers/iommu/iommufd/Kconfig"
 
 config IRQ_REMAP
 	bool "Support for Interrupt Remapping"
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index bc7f730edbb0be..6b38d12692b213 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-obj-y += amd/ intel/ arm/
+obj-y += amd/ intel/ arm/ iommufd/
 obj-$(CONFIG_IOMMU_API) += iommu.o
 obj-$(CONFIG_IOMMU_API) += iommu-traces.o
 obj-$(CONFIG_IOMMU_API) += iommu-sysfs.o
diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfig
new file mode 100644
index 00000000000000..fddd453bb0e764
--- /dev/null
+++ b/drivers/iommu/iommufd/Kconfig
@@ -0,0 +1,13 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config IOMMUFD
+	tristate "IOMMU Userspace API"
+	select INTERVAL_TREE
+	select IOMMU_API
+	default n
+	help
+	  Provides /dev/iommu the user API to control the IOMMU subsystem as
+	  it relates to managing IO page tables that point at user space memory.
+
+	  This would commonly be used in combination with VFIO.
+
+	  If you don't know what to do here, say N.
diff --git a/drivers/iommu/iommufd/Makefile b/drivers/iommu/iommufd/Makefile
new file mode 100644
index 00000000000000..a07a8cffe937c6
--- /dev/null
+++ b/drivers/iommu/iommufd/Makefile
@@ -0,0 +1,5 @@
+# SPDX-License-Identifier: GPL-2.0-only
+iommufd-y := \
+	main.o
+
+obj-$(CONFIG_IOMMUFD) += iommufd.o
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
new file mode 100644
index 00000000000000..2d0bba3965be1a
--- /dev/null
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -0,0 +1,95 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES
+ */
+#ifndef __IOMMUFD_PRIVATE_H
+#define __IOMMUFD_PRIVATE_H
+
+#include <linux/rwsem.h>
+#include <linux/xarray.h>
+#include <linux/refcount.h>
+#include <linux/uaccess.h>
+
+struct iommufd_ctx {
+	struct file *filp;
+	struct xarray objects;
+};
+
+struct iommufd_ctx *iommufd_fget(int fd);
+
+struct iommufd_ucmd {
+	struct iommufd_ctx *ictx;
+	void __user *ubuffer;
+	u32 user_size;
+	void *cmd;
+};
+
+/* Copy the response in ucmd->cmd back to userspace. */
+static inline int iommufd_ucmd_respond(struct iommufd_ucmd *ucmd,
+				       size_t cmd_len)
+{
+	if (copy_to_user(ucmd->ubuffer, ucmd->cmd,
+			 min_t(size_t, ucmd->user_size, cmd_len)))
+		return -EFAULT;
+	return 0;
+}
+
+/*
+ * The objects for an acyclic graph through the users refcount. This enum must
+ * be sorted by type depth first so that destruction completes lower objects and
+ * releases the users refcount before reaching higher objects in the graph.
+ */
+enum iommufd_object_type {
+	IOMMUFD_OBJ_NONE,
+	IOMMUFD_OBJ_ANY = IOMMUFD_OBJ_NONE,
+	IOMMUFD_OBJ_MAX,
+};
+
+/* Base struct for all objects with a userspace ID handle. */
+struct iommufd_object {
+	struct rw_semaphore destroy_rwsem;
+	refcount_t users;
+	enum iommufd_object_type type;
+	unsigned int id;
+};
+
+static inline bool iommufd_lock_obj(struct iommufd_object *obj)
+{
+	if (!down_read_trylock(&obj->destroy_rwsem))
+		return false;
+	if (!refcount_inc_not_zero(&obj->users)) {
+		up_read(&obj->destroy_rwsem);
+		return false;
+	}
+	return true;
+}
+
+struct iommufd_object *iommufd_get_object(struct iommufd_ctx *ictx, u32 id,
+					  enum iommufd_object_type type);
+static inline void iommufd_put_object(struct iommufd_object *obj)
+{
+	refcount_dec(&obj->users);
+	up_read(&obj->destroy_rwsem);
+}
+static inline void iommufd_put_object_keep_user(struct iommufd_object *obj)
+{
+	up_read(&obj->destroy_rwsem);
+}
+void iommufd_object_abort(struct iommufd_ctx *ictx, struct iommufd_object *obj);
+void iommufd_object_finalize(struct iommufd_ctx *ictx,
+			     struct iommufd_object *obj);
+bool iommufd_object_destroy_user(struct iommufd_ctx *ictx,
+				 struct iommufd_object *obj);
+struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
+					     size_t size,
+					     enum iommufd_object_type type);
+
+#define iommufd_object_alloc(ictx, ptr, type)                                  \
+	container_of(_iommufd_object_alloc(                                    \
+			     ictx,                                             \
+			     sizeof(*(ptr)) + BUILD_BUG_ON_ZERO(               \
+						      offsetof(typeof(*(ptr)), \
+							       obj) != 0),     \
+			     type),                                            \
+		     typeof(*(ptr)), obj)
+
+#endif
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
new file mode 100644
index 00000000000000..ae8db2f663004f
--- /dev/null
+++ b/drivers/iommu/iommufd/main.c
@@ -0,0 +1,305 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2021 Intel Corporation
+ * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES
+ *
+ * iommfd provides control over the IOMMU HW objects created by IOMMU kernel
+ * drivers. IOMMU HW objects revolve around IO page tables that map incoming DMA
+ * addresses (IOVA) to CPU addresses.
+ *
+ * The API is divided into a general portion that is intended to work with any
+ * kernel IOMMU driver, and a device specific portion that  is intended to be
+ * used with a userspace HW driver paired with the specific kernel driver. This
+ * mechanism allows all the unique functionalities in individual IOMMUs to be
+ * exposed to userspace control.
+ */
+#define pr_fmt(fmt) "iommufd: " fmt
+
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/miscdevice.h>
+#include <linux/mutex.h>
+#include <linux/bug.h>
+#include <uapi/linux/iommufd.h>
+
+#include "iommufd_private.h"
+
+struct iommufd_object_ops {
+	void (*destroy)(struct iommufd_object *obj);
+};
+static struct iommufd_object_ops iommufd_object_ops[];
+
+struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
+					     size_t size,
+					     enum iommufd_object_type type)
+{
+	struct iommufd_object *obj;
+	int rc;
+
+	obj = kzalloc(size, GFP_KERNEL);
+	if (!obj)
+		return ERR_PTR(-ENOMEM);
+	obj->type = type;
+	init_rwsem(&obj->destroy_rwsem);
+	refcount_set(&obj->users, 1);
+
+	/*
+	 * Reserve an ID in the xarray but do not publish the pointer yet since
+	 * the caller hasn't initialized it yet. Once the pointer is published
+	 * in the xarray and visible to other threads we can't reliably destroy
+	 * it anymore, so the caller must complete all errorable operations
+	 * before calling iommufd_object_finalize().
+	 */
+	rc = xa_alloc(&ictx->objects, &obj->id, XA_ZERO_ENTRY,
+		      xa_limit_32b, GFP_KERNEL);
+	if (rc)
+		goto out_free;
+	return obj;
+out_free:
+	kfree(obj);
+	return ERR_PTR(rc);
+}
+
+/*
+ * Allow concurrent access to the object. This should only be done once the
+ * system call that created the object is guaranteed to succeed.
+ */
+void iommufd_object_finalize(struct iommufd_ctx *ictx,
+			     struct iommufd_object *obj)
+{
+	void *old;
+
+	old = xa_store(&ictx->objects, obj->id, obj, GFP_KERNEL);
+	/* obj->id was returned from xa_alloc() so the xa_store() cannot fail */
+	WARN_ON(old);
+}
+
+/* Undo _iommufd_object_alloc() if iommufd_object_finalize() was not called */
+void iommufd_object_abort(struct iommufd_ctx *ictx, struct iommufd_object *obj)
+{
+	void *old;
+
+	old = xa_erase(&ictx->objects, obj->id);
+	WARN_ON(old);
+	kfree(obj);
+}
+
+struct iommufd_object *iommufd_get_object(struct iommufd_ctx *ictx, u32 id,
+					  enum iommufd_object_type type)
+{
+	struct iommufd_object *obj;
+
+	xa_lock(&ictx->objects);
+	obj = xa_load(&ictx->objects, id);
+	if (!obj || (type != IOMMUFD_OBJ_ANY && obj->type != type) ||
+	    !iommufd_lock_obj(obj))
+		obj = ERR_PTR(-ENOENT);
+	xa_unlock(&ictx->objects);
+	return obj;
+}
+
+/*
+ * The caller holds a users refcount and wants to destroy the object. Returns
+ * true if the object was destroyed. In all cases the caller no longer has a
+ * reference on obj.
+ */
+bool iommufd_object_destroy_user(struct iommufd_ctx *ictx,
+				 struct iommufd_object *obj)
+{
+	/*
+	 * The purpose of the destroy_rwsem is to ensure deterministic
+	 * destruction of objects used by external drivers and destroyed by this
+	 * function. Any temporary increment of the refcount must hold the read
+	 * side of this, such as during ioctl execution.
+	 */
+	down_write(&obj->destroy_rwsem);
+	xa_lock(&ictx->objects);
+	refcount_dec(&obj->users);
+	if (!refcount_dec_if_one(&obj->users)) {
+		xa_unlock(&ictx->objects);
+		up_write(&obj->destroy_rwsem);
+		return false;
+	}
+	__xa_erase(&ictx->objects, obj->id);
+	xa_unlock(&ictx->objects);
+
+	iommufd_object_ops[obj->type].destroy(obj);
+	up_write(&obj->destroy_rwsem);
+	kfree(obj);
+	return true;
+}
+
+static int iommufd_destroy(struct iommufd_ucmd *ucmd)
+{
+	struct iommu_destroy *cmd = ucmd->cmd;
+	struct iommufd_object *obj;
+
+	obj = iommufd_get_object(ucmd->ictx, cmd->id, IOMMUFD_OBJ_ANY);
+	if (IS_ERR(obj))
+		return PTR_ERR(obj);
+	iommufd_put_object_keep_user(obj);
+	if (!iommufd_object_destroy_user(ucmd->ictx, obj))
+		return -EBUSY;
+	return 0;
+}
+
+static int iommufd_fops_open(struct inode *inode, struct file *filp)
+{
+	struct iommufd_ctx *ictx;
+
+	ictx = kzalloc(sizeof(*ictx), GFP_KERNEL);
+	if (!ictx)
+		return -ENOMEM;
+
+	xa_init_flags(&ictx->objects, XA_FLAGS_ALLOC1);
+	ictx->filp = filp;
+	filp->private_data = ictx;
+	return 0;
+}
+
+static int iommufd_fops_release(struct inode *inode, struct file *filp)
+{
+	struct iommufd_ctx *ictx = filp->private_data;
+	struct iommufd_object *obj;
+	unsigned long index = 0;
+	int cur = 0;
+
+	/* Destroy the graph from depth first */
+	while (cur < IOMMUFD_OBJ_MAX) {
+		xa_for_each(&ictx->objects, index, obj) {
+			if (obj->type != cur)
+				continue;
+			xa_erase(&ictx->objects, index);
+			if (WARN_ON(!refcount_dec_and_test(&obj->users)))
+				continue;
+			iommufd_object_ops[obj->type].destroy(obj);
+			kfree(obj);
+		}
+		cur++;
+	}
+	WARN_ON(!xa_empty(&ictx->objects));
+	kfree(ictx);
+	return 0;
+}
+
+union ucmd_buffer {
+	struct iommu_destroy destroy;
+};
+
+struct iommufd_ioctl_op {
+	unsigned int size;
+	unsigned int min_size;
+	unsigned int ioctl_num;
+	int (*execute)(struct iommufd_ucmd *ucmd);
+};
+
+#define IOCTL_OP(_ioctl, _fn, _struct, _last)                                  \
+	[_IOC_NR(_ioctl) - IOMMUFD_CMD_BASE] = {                               \
+		.size = sizeof(_struct) +                                      \
+			BUILD_BUG_ON_ZERO(sizeof(union ucmd_buffer) <          \
+					  sizeof(_struct)),                    \
+		.min_size = offsetofend(_struct, _last),                       \
+		.ioctl_num = _ioctl,                                           \
+		.execute = _fn,                                                \
+	}
+static struct iommufd_ioctl_op iommufd_ioctl_ops[] = {
+	IOCTL_OP(IOMMU_DESTROY, iommufd_destroy, struct iommu_destroy, id),
+};
+
+static long iommufd_fops_ioctl(struct file *filp, unsigned int cmd,
+			       unsigned long arg)
+{
+	struct iommufd_ucmd ucmd = {};
+	struct iommufd_ioctl_op *op;
+	union ucmd_buffer buf;
+	unsigned int nr;
+	int ret;
+
+	ucmd.ictx = filp->private_data;
+	ucmd.ubuffer = (void __user *)arg;
+	ret = get_user(ucmd.user_size, (u32 __user *)ucmd.ubuffer);
+	if (ret)
+		return ret;
+
+	nr = _IOC_NR(cmd);
+	if (nr < IOMMUFD_CMD_BASE ||
+	    (nr - IOMMUFD_CMD_BASE) >= ARRAY_SIZE(iommufd_ioctl_ops))
+		return -ENOIOCTLCMD;
+	op = &iommufd_ioctl_ops[nr - IOMMUFD_CMD_BASE];
+	if (op->ioctl_num != cmd)
+		return -ENOIOCTLCMD;
+	if (ucmd.user_size < op->min_size)
+		return -EOPNOTSUPP;
+
+	ucmd.cmd = &buf;
+	ret = copy_struct_from_user(ucmd.cmd, op->size, ucmd.ubuffer,
+				    ucmd.user_size);
+	if (ret)
+		return ret;
+	ret = op->execute(&ucmd);
+	return ret;
+}
+
+static const struct file_operations iommufd_fops = {
+	.owner = THIS_MODULE,
+	.open = iommufd_fops_open,
+	.release = iommufd_fops_release,
+	.unlocked_ioctl = iommufd_fops_ioctl,
+};
+
+/**
+ * iommufd_fget - Acquires a reference to the iommufd file.
+ * @fd: file descriptor
+ *
+ * Returns a pointer to the iommufd_ctx, otherwise NULL;
+ */
+struct iommufd_ctx *iommufd_fget(int fd)
+{
+	struct file *filp;
+
+	filp = fget(fd);
+	if (!filp)
+		return NULL;
+
+	if (filp->f_op != &iommufd_fops) {
+		fput(filp);
+		return NULL;
+	}
+	return filp->private_data;
+}
+
+static struct iommufd_object_ops iommufd_object_ops[] = {
+};
+
+static struct miscdevice iommu_misc_dev = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = "iommu",
+	.fops = &iommufd_fops,
+	.nodename = "iommu",
+	.mode = 0660,
+};
+
+static int __init iommufd_init(void)
+{
+	int ret;
+
+	ret = misc_register(&iommu_misc_dev);
+	if (ret) {
+		pr_err("Failed to register misc device\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static void __exit iommufd_exit(void)
+{
+	misc_deregister(&iommu_misc_dev);
+}
+
+module_init(iommufd_init);
+module_exit(iommufd_exit);
+
+MODULE_DESCRIPTION("I/O Address Space Management for passthrough devices");
+MODULE_LICENSE("GPL v2");
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
new file mode 100644
index 00000000000000..2f7f76ec6db4cb
--- /dev/null
+++ b/include/uapi/linux/iommufd.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/* Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES.
+ */
+#ifndef _UAPI_IOMMUFD_H
+#define _UAPI_IOMMUFD_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+#define IOMMUFD_TYPE (';')
+
+/**
+ * DOC: General ioctl format
+ *
+ * The ioctl mechanims follows a general format to allow for extensibility. Each
+ * ioctl is passed in a structure pointer as the argument providing the size of
+ * the structure in the first u32. The kernel checks that any structure space
+ * beyond what it understands is 0. This allows userspace to use the backward
+ * compatible portion while consistently using the newer, larger, structures.
+ *
+ * ioctls use a standard meaning for common errnos:
+ *
+ *  - ENOTTY: The IOCTL number itself is not supported at all
+ *  - E2BIG: The IOCTL number is supported, but the provided structure has
+ *    non-zero in a part the kernel does not understand.
+ *  - EOPNOTSUPP: The IOCTL number is supported, and the structure is
+ *    understood, however a known field has a value the kernel does not
+ *    understand or support.
+ *  - EINVAL: Everything about the IOCTL was understood, but a field is not
+ *    correct.
+ *  - ENOENT: An ID or IOVA provided does not exist.
+ *  - ENOMEM: Out of memory.
+ *  - EOVERFLOW: Mathematics oveflowed.
+ *
+ * As well as additional errnos. within specific ioctls.
+ */
+enum {
+	IOMMUFD_CMD_BASE = 0x80,
+	IOMMUFD_CMD_DESTROY = IOMMUFD_CMD_BASE,
+};
+
+/**
+ * struct iommu_destroy - ioctl(IOMMU_DESTROY)
+ * @size: sizeof(struct iommu_destroy)
+ * @id: iommufd object ID to destroy. Can by any destroyable object type.
+ *
+ * Destroy any object held within iommufd.
+ */
+struct iommu_destroy {
+	__u32 size;
+	__u32 id;
+};
+#define IOMMU_DESTROY _IO(IOMMUFD_TYPE, IOMMUFD_CMD_DESTROY)
+
+#endif
-- 
2.35.1

