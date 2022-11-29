Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70CF863C948
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 21:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236170AbiK2Ual (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 15:30:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236430AbiK2UaS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 15:30:18 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2062.outbound.protection.outlook.com [40.107.212.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E15D66C8D
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 12:30:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jekMcfn79JdZIz7Au+OiHeIVa1vDdzojJk6TcGRhPfGdzEgv/f/qajW2X+yWdoeKO0V3r2d873kyj0l0QoLrg++UCDNTAxHZdfRocgGjDQV7XwHxRdQ1Y49307cgFLE+khX8Zcfl6XgC45WEyY4KCowlOSXJmFZ0NL5491nqgDGDV/wVmj4iQPXFMJ2g5uDAgUHvrTqQxxUJQA4Ot2MwxiaaAb9eI6rAFUNTr5QEB6wpxeI2sXbGSYVadvKnXbJgi3ZAwWfJjaLNiCT0Il3js8U9+yd1Od3TfdatRGpmHwaBqZ3aOftXD40xvmbwIL6dAlvUCP9q2xK7/vzAeG6Vlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JnWvWo8RM2RDxQdYCTUAwZqF1u8+3CQ576Wks8XZr/4=;
 b=GkvQQ/QjCg4xPqgA8yGGS20sNsYmiN0kBXY21q0N36ucTbRztfH1txtKzSXv2Du9s2QxrjQceu6PgLXpgKOCIm73nwoDoZRsK+NaIx+p/S9KCZY4sg3VZ/94PUWxkklZ606MSiMaxQ6toZK8QY4ogg9vFPbbiLaoQGkZYzqDL/wGwwb1TIR5g15Nyhvn+D9MAkdfIO+pb5sKZWVpee+qHNHWfROrdQmKMXtj7/YULJ0iHYGoivoCIprcqDd7BC+wDC/JKm/EIMkwNiDtfwXiy3ns7JvQLpRZHnasYlVrAJT8oGLWiN8WV1TvulGc6oi+f8j8GvDJObUe7sP1haZ27Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JnWvWo8RM2RDxQdYCTUAwZqF1u8+3CQ576Wks8XZr/4=;
 b=g/d8JmZLAGYlVdBYzW6cMJ20EyzRP4w74TgQxh9coiP6OJ3XxdlOYn9MDyvwvHb13kmSNsUqVmbKe1NwVS4r6iLok2hdFDjcyAFWbOyfiIZtJQRpH5U9sOh94IYquPZxIpKS5+z1s8312jxxr6cPHRumzWY97EEQQJ4B74YGiqABRZwhHKgSa2wyc4WfFqmFeXivkVA+c3buAiHmZLYdL8lXjsE1zqzjaSXrmSJhYxo7mAyziRTQoD8WO9FznBi0+QHgOQ8AmCv+KTzVjKSMKM/A5q3OjMbn3yGza2jB4LCDPoIrVCx/94JkwpszGD1o43pRb4TIFlGJSrHuKLepBA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY5PR12MB6059.namprd12.prod.outlook.com (2603:10b6:930:2c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 20:29:55 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 20:29:55 +0000
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
Subject: [PATCH v6 06/19] iommufd: File descriptor, context, kconfig and makefiles
Date:   Tue, 29 Nov 2022 16:29:29 -0400
Message-Id: <6-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0021.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::26) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY5PR12MB6059:EE_
X-MS-Office365-Filtering-Correlation-Id: e0f753f8-d9e1-4882-7472-08dad248779f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OHolJYr7MssmFoXgqVKn9RrR/MrIxr3gMZnVsYIn8YHOA3BdPJcpyXWJb6DosIbRgizwV81ES47VVopR+9QwVW656Lylvq1GOTSarQpHRwBDbiw+NNmKBuKpLAWRZls8euzbai/6OngiOTw1z3GSEKNm+97Sj0MqDRruSGWb/JQY8KBLQd/uOVwRR+otdIACIv59RPxnFhyxNQ+2dj79kadz3x5tsaaSinwQlYHXaOfyIsxDqIMmwHxua8+UgbbfIHLkHJO3FUeW010LGIWoQWiwF+rW7scHF3QPcWJrfJ2vOETwmcyf110Zw9d9/2sGzyS4DQeio3rzlYnvhIBQytH+7rgj4gmjUMT3EBh6PHyB5sjRrdYLy4j4ib1sG1UuhAwjd1o8iZ11TMtBNmVexkEprfEXUR0xMvpsupggBiioEZmLG3Z0SBqQidBbpfw80vtWmy4kbnYoB/EJCTUoi15uCnUv3yNqevgPB7cbsfRkJwY3tOgkYGsotitHbaEiFAAgD4GLBmlnyW4bc2KLCKuJOdOX5sV0sVqipS6nlx0sh2AoP17i5efU6H6LVCzA+51sH2OYsLImbR5KARDFyYaIzAvuCXmu7/bXaGG3vDBH4ivrW8W9z1EKUk0NpGzvzRlcQm+U7vjek3e1XgFXqK7jn+umcNrnR9NZm9JiOnLYUjkvoWVdS8EFLihH91h66g4vUGd2BULVUKqStvlU5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(451199015)(109986013)(36756003)(86362001)(54906003)(6486002)(316002)(478600001)(2906002)(30864003)(66476007)(66556008)(66946007)(4326008)(8936002)(7416002)(41300700001)(8676002)(5660300002)(83380400001)(38100700002)(26005)(6506007)(6666004)(6512007)(186003)(2616005)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yEukyzOSTCdCGIlUl6QN6ViAZ3wv53M77YzEm/5jyGwdTXwiRmot/AwVQTia?=
 =?us-ascii?Q?wR0GTg9HKxtMY+OW70MLlLJFRr6Owrm4z69lx/WTTCgaZfUu+pKtBzuv0GEG?=
 =?us-ascii?Q?UcSDVclGHoJeDN0glI2cSDNIEFIBMhYeP5omLLYxoqQHn4EkHvr/zL3OalIh?=
 =?us-ascii?Q?GqdrOIJsO1waczDbjwtaX//iGiB9QbmJelbRpBks5HSfGbFXdYwSd8u/sXPr?=
 =?us-ascii?Q?PvKXB58WgHbcnfFRIwthBAxDYtoiAwVz2ULTycFqI2qGGIT6XPiUv3kjlLzC?=
 =?us-ascii?Q?5prVx4bQJ51LhXHWOiWNlvlvu9JMx0su70S584EG0CYJ9Lpibv5WHfFpa5BR?=
 =?us-ascii?Q?pGxADbDvf/EyWLnGWs/XmfGvU6IPY0jwU2Vy56kMmZyVHffHQVQarwCvT/Ac?=
 =?us-ascii?Q?6HFmHpyt51OAiDLZOw47jhIUBRiskpCtpWwHTqEuAWG8xfGG4e5T5gXjs00v?=
 =?us-ascii?Q?pptuzqRlReoMn8nvH+O8rk6bhfpnzfP9TtAkHmTIBZLzXl8dPAAsLvhZ3wpU?=
 =?us-ascii?Q?OR5VCPO3bhpaWTL+FAsS/L4HHHMffNJ4p4TwNPH730WMhfswOFOJ9sFJA42B?=
 =?us-ascii?Q?vQ63sO+4c27e+QzMejPXF+he3n4scSUG75aebTVpKrqK6WN8t+QFLZF5Ts84?=
 =?us-ascii?Q?I+izxguTAx0ac56q0BYqkG+stHDtWNOP1l4mtJBUGm6aVA8AidReUPGA4M+s?=
 =?us-ascii?Q?wAxnm8jgONZxaTMMbUAAVd4Pjo8gcvhk0sPm5lz4vD/4M7gg3+4UYOGocf7T?=
 =?us-ascii?Q?JsmrcIikmKM0DFuA4OrHU5oEma+INM1EE2Meo4aasEguf2ipFRs21+tsTaJ8?=
 =?us-ascii?Q?poXmCnpnZz+XY7hvL+CSqaPwMaw2pOcSknTe6ecKjhzGQOtn5mNH2afYYDf3?=
 =?us-ascii?Q?gtgA9sfN5si0YgRZV2Fax9HRRm/tsA9gl2Y093o+9yQgJB6gQw+8W2i3ZxYJ?=
 =?us-ascii?Q?HtQJX9RaMIUsSigQWFEQHeS/l0Bd/vkX2A2sSh8uaCKziX8iOp889WOQG+Ph?=
 =?us-ascii?Q?2+bKVldZwt+FM36snZ9A0Foc5oU6Z4/lfRwCGeJlQqaLya1rJAtst20oofH7?=
 =?us-ascii?Q?k0WC5EhQLI4nFzbs+fflB/CIVg8x4o6A+blAf278fvZxOPF63zDw7VmYIUfx?=
 =?us-ascii?Q?v5RBvn0D+4ApYaLoP2nghNgGyQ9KXvh8pgkzudb0XxdvSDc+2q0PU5shCCnO?=
 =?us-ascii?Q?OFSk7X4LOFhQ1xIKHZ+EAR7dOFYxlqswoVCHzRkpJAkHLoeaBFDm1J+Yj6hK?=
 =?us-ascii?Q?ibD1lv1TqY74pA336UCoLV+f45ZKPOm+EWAAJRzyK59XyrJt/Wf/0bjimufU?=
 =?us-ascii?Q?EgL9fP7/x6kmzwA3RBo5sjpD6TmOvePWkUtZpgg1S868OVRh2QeTylfdufQu?=
 =?us-ascii?Q?eaSstdfXyaxys71+A5Mr7gqc4X6LLoR6PbCYppWVpaQoFLx00FmYyOvfqlLS?=
 =?us-ascii?Q?pxYtB9LOwEspYypWmjFFlf6DeRi5b+IUtF9WSzLpKHATUkNTkdQLVMCxydhJ?=
 =?us-ascii?Q?TFRjZ3sSdFAoZyK3az2WBgyqsb92+I35/1i1InAbgE0nvpDimi+VgXHUFWjs?=
 =?us-ascii?Q?eD1e1oxuuiuQpiNeKVynmNjLvkYKyckieDQ3alXd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0f753f8-d9e1-4882-7472-08dad248779f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 20:29:51.8868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 334uGQH14U4aip4hUj2S1O1ANUYroCeBMAPDjdGj0JaWpxIHXlLI06pvfCLcCOr2
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

This is the basic infrastructure of a new miscdevice to hold the iommufd
IOCTL API.

It provides:
 - A miscdevice to create file descriptors to run the IOCTL interface over

 - A table based ioctl dispatch and centralized extendable pre-validation
   step

 - An xarray mapping userspace ID's to kernel objects. The design has
   multiple inter-related objects held within in a single IOMMUFD fd

 - A simple usage count to build a graph of object relations and protect
   against hostile userspace racing ioctls

The only IOCTL provided in this patch is the generic 'destroy any object
by handle' operation.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Lixiao Yang <lixiao.yang@intel.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../userspace-api/ioctl/ioctl-number.rst      |   1 +
 MAINTAINERS                                   |  12 +
 drivers/iommu/Kconfig                         |   1 +
 drivers/iommu/Makefile                        |   2 +-
 drivers/iommu/iommufd/Kconfig                 |  12 +
 drivers/iommu/iommufd/Makefile                |   5 +
 drivers/iommu/iommufd/iommufd_private.h       | 109 ++++++
 drivers/iommu/iommufd/main.c                  | 344 ++++++++++++++++++
 include/linux/iommufd.h                       |  31 ++
 include/uapi/linux/iommufd.h                  |  55 +++
 10 files changed, 571 insertions(+), 1 deletion(-)
 create mode 100644 drivers/iommu/iommufd/Kconfig
 create mode 100644 drivers/iommu/iommufd/Makefile
 create mode 100644 drivers/iommu/iommufd/iommufd_private.h
 create mode 100644 drivers/iommu/iommufd/main.c
 create mode 100644 include/linux/iommufd.h
 create mode 100644 include/uapi/linux/iommufd.h

diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
index 5f81e2a24a5c04..eb045fc495a4e3 100644
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
index 379945f82a6438..c0a93779731d7e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10717,6 +10717,18 @@ F:	drivers/iommu/dma-iommu.h
 F:	drivers/iommu/iova.c
 F:	include/linux/iova.h
 
+IOMMUFD
+M:	Jason Gunthorpe <jgg@nvidia.com>
+M:	Kevin Tian <kevin.tian@intel.com>
+L:	iommu@lists.linux.dev
+S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git
+F:	Documentation/userspace-api/iommufd.rst
+F:	drivers/iommu/iommufd/
+F:	include/linux/iommufd.h
+F:	include/uapi/linux/iommufd.h
+F:	tools/testing/selftests/iommu/
+
 IOMMU SUBSYSTEM
 M:	Joerg Roedel <joro@8bytes.org>
 M:	Will Deacon <will@kernel.org>
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index dc5f7a156ff5ec..319966cde5cf6c 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -188,6 +188,7 @@ config MSM_IOMMU
 
 source "drivers/iommu/amd/Kconfig"
 source "drivers/iommu/intel/Kconfig"
+source "drivers/iommu/iommufd/Kconfig"
 
 config IRQ_REMAP
 	bool "Support for Interrupt Remapping"
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 7fbf6a3376620e..f461d065138564 100644
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
index 00000000000000..164812084a675b
--- /dev/null
+++ b/drivers/iommu/iommufd/Kconfig
@@ -0,0 +1,12 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config IOMMUFD
+	tristate "IOMMU Userspace API"
+	select INTERVAL_TREE
+	select INTERVAL_TREE_SPAN_ITER
+	select IOMMU_API
+	default n
+	help
+	  Provides /dev/iommu, the user API to control the IOMMU subsystem as
+	  it relates to managing IO page tables that point at user space memory.
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
index 00000000000000..bb720bc113178d
--- /dev/null
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -0,0 +1,109 @@
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
+	struct file *file;
+	struct xarray objects;
+};
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
+enum iommufd_object_type {
+	IOMMUFD_OBJ_NONE,
+	IOMMUFD_OBJ_ANY = IOMMUFD_OBJ_NONE,
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
+
+/**
+ * iommufd_ref_to_users() - Switch from destroy_rwsem to users refcount
+ *        protection
+ * @obj - Object to release
+ *
+ * Objects have two refcount protections (destroy_rwsem and the refcount_t
+ * users). Holding either of these will prevent the object from being destroyed.
+ *
+ * Depending on the use case, one protection or the other is appropriate.  In
+ * most cases references are being protected by the destroy_rwsem. This allows
+ * orderly destruction of the object because iommufd_object_destroy_user() will
+ * wait for it to become unlocked. However, as a rwsem, it cannot be held across
+ * a system call return. So cases that have longer term needs must switch
+ * to the weaker users refcount_t.
+ *
+ * With users protection iommufd_object_destroy_user() will return false,
+ * refusing to destroy the object, causing -EBUSY to userspace.
+ */
+static inline void iommufd_ref_to_users(struct iommufd_object *obj)
+{
+	up_read(&obj->destroy_rwsem);
+	/* iommufd_lock_obj() obtains users as well */
+}
+void iommufd_object_abort(struct iommufd_ctx *ictx, struct iommufd_object *obj);
+void iommufd_object_abort_and_destroy(struct iommufd_ctx *ictx,
+				      struct iommufd_object *obj);
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
index 00000000000000..dfbc68b97506d0
--- /dev/null
+++ b/drivers/iommu/iommufd/main.c
@@ -0,0 +1,344 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2021 Intel Corporation
+ * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES
+ *
+ * iommufd provides control over the IOMMU HW objects created by IOMMU kernel
+ * drivers. IOMMU HW objects revolve around IO page tables that map incoming DMA
+ * addresses (IOVA) to CPU addresses.
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
+#include <linux/iommufd.h>
+
+#include "iommufd_private.h"
+
+struct iommufd_object_ops {
+	void (*destroy)(struct iommufd_object *obj);
+};
+static const struct iommufd_object_ops iommufd_object_ops[];
+
+struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
+					     size_t size,
+					     enum iommufd_object_type type)
+{
+	struct iommufd_object *obj;
+	int rc;
+
+	obj = kzalloc(size, GFP_KERNEL_ACCOUNT);
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
+		      xa_limit_32b, GFP_KERNEL_ACCOUNT);
+	if (rc)
+		goto out_free;
+	return obj;
+out_free:
+	kfree(obj);
+	return ERR_PTR(rc);
+}
+
+/*
+ * Allow concurrent access to the object.
+ *
+ * Once another thread can see the object pointer it can prevent object
+ * destruction. Expect for special kernel-only objects there is no in-kernel way
+ * to reliably destroy a single object. Thus all APIs that are creating objects
+ * must use iommufd_object_abort() to handle their errors and only call
+ * iommufd_object_finalize() once object creation cannot fail.
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
+/*
+ * Abort an object that has been fully initialized and needs destroy, but has
+ * not been finalized.
+ */
+void iommufd_object_abort_and_destroy(struct iommufd_ctx *ictx,
+				      struct iommufd_object *obj)
+{
+	iommufd_object_ops[obj->type].destroy(obj);
+	iommufd_object_abort(ictx, obj);
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
+	up_write(&obj->destroy_rwsem);
+
+	iommufd_object_ops[obj->type].destroy(obj);
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
+	iommufd_ref_to_users(obj);
+	/* See iommufd_ref_to_users() */
+	if (!iommufd_object_destroy_user(ucmd->ictx, obj))
+		return -EBUSY;
+	return 0;
+}
+
+static int iommufd_fops_open(struct inode *inode, struct file *filp)
+{
+	struct iommufd_ctx *ictx;
+
+	ictx = kzalloc(sizeof(*ictx), GFP_KERNEL_ACCOUNT);
+	if (!ictx)
+		return -ENOMEM;
+
+	xa_init_flags(&ictx->objects, XA_FLAGS_ALLOC1 | XA_FLAGS_ACCOUNT);
+	ictx->file = filp;
+	filp->private_data = ictx;
+	return 0;
+}
+
+static int iommufd_fops_release(struct inode *inode, struct file *filp)
+{
+	struct iommufd_ctx *ictx = filp->private_data;
+	struct iommufd_object *obj;
+
+	/*
+	 * The objects in the xarray form a graph of "users" counts, and we have
+	 * to destroy them in a depth first manner. Leaf objects will reduce the
+	 * users count of interior objects when they are destroyed.
+	 *
+	 * Repeatedly destroying all the "1 users" leaf objects will progress
+	 * until the entire list is destroyed. If this can't progress then there
+	 * is some bug related to object refcounting.
+	 */
+	while (!xa_empty(&ictx->objects)) {
+		unsigned int destroyed = 0;
+		unsigned long index;
+
+		xa_for_each(&ictx->objects, index, obj) {
+			if (!refcount_dec_if_one(&obj->users))
+				continue;
+			destroyed++;
+			xa_erase(&ictx->objects, index);
+			iommufd_object_ops[obj->type].destroy(obj);
+			kfree(obj);
+		}
+		/* Bug related to users refcount */
+		if (WARN_ON(!destroyed))
+			break;
+	}
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
+static const struct iommufd_ioctl_op iommufd_ioctl_ops[] = {
+	IOCTL_OP(IOMMU_DESTROY, iommufd_destroy, struct iommu_destroy, id),
+};
+
+static long iommufd_fops_ioctl(struct file *filp, unsigned int cmd,
+			       unsigned long arg)
+{
+	const struct iommufd_ioctl_op *op;
+	struct iommufd_ucmd ucmd = {};
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
+		return -EINVAL;
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
+ * iommufd_ctx_get - Get a context reference
+ * @ictx: Context to get
+ *
+ * The caller must already hold a valid reference to ictx.
+ */
+void iommufd_ctx_get(struct iommufd_ctx *ictx)
+{
+	get_file(ictx->file);
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_ctx_get, IOMMUFD);
+
+/**
+ * iommufd_ctx_from_file - Acquires a reference to the iommufd context
+ * @file: File to obtain the reference from
+ *
+ * Returns a pointer to the iommufd_ctx, otherwise ERR_PTR. The struct file
+ * remains owned by the caller and the caller must still do fput. On success
+ * the caller is responsible to call iommufd_ctx_put().
+ */
+struct iommufd_ctx *iommufd_ctx_from_file(struct file *file)
+{
+	struct iommufd_ctx *ictx;
+
+	if (file->f_op != &iommufd_fops)
+		return ERR_PTR(-EBADFD);
+	ictx = file->private_data;
+	iommufd_ctx_get(ictx);
+	return ictx;
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_ctx_from_file, IOMMUFD);
+
+/**
+ * iommufd_ctx_put - Put back a reference
+ * @ictx: Context to put back
+ */
+void iommufd_ctx_put(struct iommufd_ctx *ictx)
+{
+	fput(ictx->file);
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_ctx_put, IOMMUFD);
+
+static const struct iommufd_object_ops iommufd_object_ops[] = {
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
+	if (ret)
+		return ret;
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
+MODULE_LICENSE("GPL");
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
new file mode 100644
index 00000000000000..d1817472c27373
--- /dev/null
+++ b/include/linux/iommufd.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2021 Intel Corporation
+ * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES
+ */
+#ifndef __LINUX_IOMMUFD_H
+#define __LINUX_IOMMUFD_H
+
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+
+struct iommufd_ctx;
+struct file;
+
+void iommufd_ctx_get(struct iommufd_ctx *ictx);
+
+#if IS_ENABLED(CONFIG_IOMMUFD)
+struct iommufd_ctx *iommufd_ctx_from_file(struct file *file);
+void iommufd_ctx_put(struct iommufd_ctx *ictx);
+#else /* !CONFIG_IOMMUFD */
+static inline struct iommufd_ctx *iommufd_ctx_from_file(struct file *file)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+static inline void iommufd_ctx_put(struct iommufd_ctx *ictx)
+{
+}
+#endif /* CONFIG_IOMMUFD */
+#endif
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
new file mode 100644
index 00000000000000..37de92f0534b86
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
+ * The ioctl interface follows a general format to allow for extensibility. Each
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
+ *  - EOVERFLOW: Mathematics overflowed.
+ *
+ * As well as additional errnos, within specific ioctls.
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
2.38.1

