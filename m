Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1090D63C945
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 21:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236188AbiK2UaD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 15:30:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236091AbiK2U34 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 15:29:56 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2062.outbound.protection.outlook.com [40.107.212.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2468564556
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 12:29:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BqtI8IMXyTdcqSUYPfgzi3IZBiihbUf3vNCJpmV77thmpoccQF8R35vGJk8u1unWzawYwwgy/bjK+fKMmrqUrBd1EbIto6rAXHOsB4nVauNv0HvxDqodltdd0sF285lnW61zomyNxFwV1MAQQQQtsbqAcZhTbLgRx+NhDHX2CEIO7QO0an302T2cwYopYecrcjifpshnSZGb+I6oTWhYkZZfL2Sa7OODttg3mOZErPgWFFXwBNhg7kgPMagxkBJmc+QecadjuyxQ6QulunKDOk1+3obbe42Wc4csVbGZA6Mi5YI8Fv6gG1rJ9R6bwzpSEpHuk+KC0WEAJM5dZGLqww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qeWU+mOCv29KOLJWr+5ma2/yEByU5j+/Ja5FKjinp1o=;
 b=mFvC5nruen0D0Cgweon/XxaqRrJOPeLkOMJRHP0g2ZzHrMI7Zd0oy5J02gU8ls5EPQrHpLywSQjTvCZj/6AveUvs9nzNJ+R9loU2apcIbkjeM1YFup1blsrP+v74VMDsVA186++BeVKtl7OEIiYbhjOrVXyGikW6elnXLAPgeYoszLOd6F3cFKhbZrOFVvi+PYUMslrrxTcD/GksMSNgSM4zWh6WsqrGM3GvsbdjUCJ5LrEL+6BObtfE4D/ncrwqVfLDeJH8ZgpZcxn2fImFXgMsH6ej5Xd9K+5aAtPfxzjKAEVooLDfcgjo0hewbrOS3A+d5Q6oxDZv/LC7V/0s3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qeWU+mOCv29KOLJWr+5ma2/yEByU5j+/Ja5FKjinp1o=;
 b=ZC+nQUEw7fP8lxshk0MRVJY6KlDHhVftD1vsOKi0hXOKd9k8h5a6sHJFHy2hFGpwKwgbjl2n8omM1Ve6BtUxqX14dM+t09zc+Hio4yBPS83KzH+HcyAYPpGISjAHoiI79Mar1NK3VkzgKvkZaJyacJbEZCOA24GEDBl6U37zcK0suLL2ZyDQZ/MutNweInP+JM6vlDJxOPeMK/t7NX5MfYeh5ydkGTmeQdXN4CzN5D8f2yrhAO+2oOopc1Fw4H6pV3FSwzbvBx524cTAJ1KvxjDWSWtma7WG9eE2b8EOCi6BUqKYnBocA6jMM/Dh/dLv8578WNvOT6bQ/8fNZARNKQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY5PR12MB6059.namprd12.prod.outlook.com (2603:10b6:930:2c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 20:29:47 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 20:29:47 +0000
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
Subject: [PATCH v6 11/19] iommufd: IOCTLs for the io_pagetable
Date:   Tue, 29 Nov 2022 16:29:34 -0400
Message-Id: <11-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::7) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY5PR12MB6059:EE_
X-MS-Office365-Filtering-Correlation-Id: e1643abc-bcff-47ee-01da-08dad24873dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: amQSxgWaQmCXWEsnRKEHLK2F1EXfBenR4Y49S1T3gWPfM7qPDGP5FdwrdTyPoMJ2N80LR6Jj8MCPdJ8woFTms4EMA5NgL8OaOQ94+DsxJ/TxqX6GL4Rsuh+DgZCNdKZwQGJ7VTMAxj3ixXPANNETm7gWOeLp/apoeuwmQ7ytw5wa6uPdCuHZXj0dF4bHrwaDu8rlc1Pp0unfY2lASNTF/16gp3bhqrKpGAvCyuGFKJAjI2jmsl6PoLtEsk78dbba5jkh1eV4ZnbgTXH5SYwwO19xcjW17mnAc3FbW6GP+oq8pRRETql8pfk88vnw6cDDC0PV4+cBiUI/qvyxzNVd4r7xnokqfHbukvCWH1QIr83xpTkX689D27M57ZkX0RmcxytJ7Jj3p2UA59Q6BKj9I7Y0lsv7X4PmCZoUPZZbEXjU/Ryx6wlVNOFRfvDnfp4EkG/EhpPl2ta+AxSR6pV5HYov1DA5dlbqp191YqBkpylLG/ZetqszvCIMkh5N0ZE2NTpHBYsSlDChW4gZmjRR8N83g27bCDjINUPdK1Nup/o9JCbOupnqoleR4Os9xn9nDDp8vb1Lg+N+IaMLc9QILH4lo33nlSJZEw+dIVSDyvyBw0628jdQuhRyF8SVlHKAWGEaLOTIxq6PAXTBwfzgVyeUpJD31uFRINgLeiKYlnEM/UIdH+XSe57hulyW+6pJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(451199015)(109986013)(36756003)(86362001)(54906003)(6486002)(316002)(478600001)(2906002)(30864003)(66476007)(66556008)(66946007)(4326008)(8936002)(7416002)(41300700001)(8676002)(5660300002)(83380400001)(38100700002)(26005)(6506007)(6666004)(6512007)(186003)(2616005)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CSiRR2s8e1jCzattyVujWHcW51ZaSFOoQASq5D7pK6EwmUCwMSOZj8s9PhEC?=
 =?us-ascii?Q?eD8cwDzfXPwhSPLB6E8IUTvCgTeFmSyf2WzVwL+ntiBsFoZdmyAm6CSWdc8C?=
 =?us-ascii?Q?WHEfuxznpfKGAARzBaKkOhbVHq6QbdZ4RlpGtpvKBYQT5QnE+JWemVLsK55d?=
 =?us-ascii?Q?Q3oaA1dryDjVQSxm9ObGhLzMIbqG3RgGweQB3c0hqviZtDof/upJnj8sRmlV?=
 =?us-ascii?Q?gIlHsHsFQaATq7SsmUzl6VEnDjq6fJXlGQ38azwEIbeOLLL2+qmw4T2K6D10?=
 =?us-ascii?Q?ioYMF4v8NfNiINcC7YO5R9AXPI9jJS7pk8zQpkQyaIVVa8AOGcmB9Rw28TJb?=
 =?us-ascii?Q?CPYJ3tx2GyQlfJvqVjJSnKIvRQjz/EuLWGibo+pXi57iWokYV+e0+zA95fW9?=
 =?us-ascii?Q?++W8917rnjEYobCLuOfoHa9tMd3dVLDFQvznluTx1U/Al60vfwB/zJLj8kWn?=
 =?us-ascii?Q?Fd8I9cPGi/5nXlHm4LwHx5w5ddpXvg3Nah1Y4e9nwtNOwL+vg56gPogrtAOK?=
 =?us-ascii?Q?PqOtR8OJX0EF80zzBXdW/TWSb1eoN8RZjH/TdwOELSCiRmkeBVMRL4+CjxNV?=
 =?us-ascii?Q?Buim4D78t5HGQ5+MNa9TALCwdnnxCMzK5KsSmzVwFk5/+ikURo72k9Wc/xPI?=
 =?us-ascii?Q?IR2rHR1reXY1kb0VcpvPVCapfbJz7Lq1Dn87XQiFumiyiND4tetupCRu6MWf?=
 =?us-ascii?Q?eWC/X4rUpktansHteIo4zuGT6yWr6iK3XqUpepkGCjjNxdddMOpKU8WjJNCX?=
 =?us-ascii?Q?Q8c56xBvFMfIuqf1La9tNmneh4pAX6xWRlfGe25O4bmw0Y+UE9dJZStRtNBM?=
 =?us-ascii?Q?jjoXzxnIlihJf8PvkpkM1LnQdnrEK1MbN8yQnXtxXO+zSzG/ZLhou7gBDcsh?=
 =?us-ascii?Q?IjXURkPa5WPhIzIm/QZIrjve6wTJ/pcB2pqW5h2TcUIlhJznw+qT1QFZMx5/?=
 =?us-ascii?Q?kaTBJ6757hfr5lGzrWFDNkLz19CBeycGM/KEStxB2OelOXtc7hilBt7GAg1w?=
 =?us-ascii?Q?emLi8sWhjC8tQev8DEnJy+7KtMRcvCflweTntzs/lCMOyGuOa0l3F7gJZZdy?=
 =?us-ascii?Q?YOf+CSu1A4R+vU5hADAu6rMGm+ThOtHyTmftAczekBwvfsKCa6CLbfRWIMAX?=
 =?us-ascii?Q?YbnUOL5kmGlwf1Mq/ingsFSmscbwlgf1hE2N6bA0N+9GKjuAlJWFaMKen9kZ?=
 =?us-ascii?Q?nJ7OZmYfAXiR9e3TYlQm64BJQFrMQs8Ckr7ke99mn/kUKTs5b0XWggA3cMxz?=
 =?us-ascii?Q?4O96VaBbNXsxRLK0o+cD+O+rPO7487R2bEbqcC2FJNBuLsDL3sjo2fOLIcE9?=
 =?us-ascii?Q?TthANdb4gLrYGYm18/ZHVzIDrFFko/WpgLl3C+PhHBUqUz8VviJ9n0FjcezA?=
 =?us-ascii?Q?+GbspoyHmgjF03z+CtbL6XIHLr2A+11My8Cz2hi9MKfAMbrEgzuLRP4vww0T?=
 =?us-ascii?Q?NpMfO0GQzojF79s0R9xtPWP4tbOJGthiEtqw2P0/SduqqL+hiQCh/Ka83XLA?=
 =?us-ascii?Q?ML05stJadO9D8kbKI6dxIrA99YIADS+5xQcRmxwI56gxS/6haLARw62mM2l7?=
 =?us-ascii?Q?BX7uu+Fe2jPvHz5d7Are1RBvkC8vhZbxlqRrSjP1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1643abc-bcff-47ee-01da-08dad24873dc
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 20:29:45.4454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QEruPlkYD+j8kBnrrjdf9H/LJrfvSG0YKzcbf2C0D8oKxOl4E/N0FqVjvj8vGyNo
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

Connect the IOAS to its IOCTL interface. This exposes most of the
functionality in the io_pagetable to userspace.

This is intended to be the core of the generic interface that IOMMUFD will
provide. Every IOMMU driver should be able to implement an iommu_domain
that is compatible with this generic mechanism.

It is also designed to be easy to use for simple non virtual machine
monitor users, like DPDK:
 - Universal simple support for all IOMMUs (no PPC special path)
 - An IOVA allocator that considers the aperture and the allowed/reserved
   ranges
 - io_pagetable allows any number of iommu_domains to be connected to the
   IOAS
 - Automatic allocation and re-use of iommu_domains

Along with room in the design to add non-generic features to cater to
specific HW functionality.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Lixiao Yang <lixiao.yang@intel.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/iommufd/Makefile          |   1 +
 drivers/iommu/iommufd/ioas.c            | 392 ++++++++++++++++++++++++
 drivers/iommu/iommufd/iommufd_private.h |  33 ++
 drivers/iommu/iommufd/main.c            |  48 +++
 include/uapi/linux/iommufd.h            | 256 +++++++++++++++-
 5 files changed, 729 insertions(+), 1 deletion(-)
 create mode 100644 drivers/iommu/iommufd/ioas.c

diff --git a/drivers/iommu/iommufd/Makefile b/drivers/iommu/iommufd/Makefile
index b66a8c47ff55ec..2b4f36f1b72f9d 100644
--- a/drivers/iommu/iommufd/Makefile
+++ b/drivers/iommu/iommufd/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 iommufd-y := \
 	io_pagetable.o \
+	ioas.o \
 	main.o \
 	pages.o
 
diff --git a/drivers/iommu/iommufd/ioas.c b/drivers/iommu/iommufd/ioas.c
new file mode 100644
index 00000000000000..6ff97dafc89134
--- /dev/null
+++ b/drivers/iommu/iommufd/ioas.c
@@ -0,0 +1,392 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES
+ */
+#include <linux/interval_tree.h>
+#include <linux/iommufd.h>
+#include <linux/iommu.h>
+#include <uapi/linux/iommufd.h>
+
+#include "io_pagetable.h"
+
+void iommufd_ioas_destroy(struct iommufd_object *obj)
+{
+	struct iommufd_ioas *ioas = container_of(obj, struct iommufd_ioas, obj);
+	int rc;
+
+	rc = iopt_unmap_all(&ioas->iopt, NULL);
+	WARN_ON(rc && rc != -ENOENT);
+	iopt_destroy_table(&ioas->iopt);
+}
+
+struct iommufd_ioas *iommufd_ioas_alloc(struct iommufd_ctx *ictx)
+{
+	struct iommufd_ioas *ioas;
+
+	ioas = iommufd_object_alloc(ictx, ioas, IOMMUFD_OBJ_IOAS);
+	if (IS_ERR(ioas))
+		return ioas;
+
+	iopt_init_table(&ioas->iopt);
+	return ioas;
+}
+
+int iommufd_ioas_alloc_ioctl(struct iommufd_ucmd *ucmd)
+{
+	struct iommu_ioas_alloc *cmd = ucmd->cmd;
+	struct iommufd_ioas *ioas;
+	int rc;
+
+	if (cmd->flags)
+		return -EOPNOTSUPP;
+
+	ioas = iommufd_ioas_alloc(ucmd->ictx);
+	if (IS_ERR(ioas))
+		return PTR_ERR(ioas);
+
+	cmd->out_ioas_id = ioas->obj.id;
+	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
+	if (rc)
+		goto out_table;
+	iommufd_object_finalize(ucmd->ictx, &ioas->obj);
+	return 0;
+
+out_table:
+	iommufd_object_abort_and_destroy(ucmd->ictx, &ioas->obj);
+	return rc;
+}
+
+int iommufd_ioas_iova_ranges(struct iommufd_ucmd *ucmd)
+{
+	struct iommu_iova_range __user *ranges;
+	struct iommu_ioas_iova_ranges *cmd = ucmd->cmd;
+	struct iommufd_ioas *ioas;
+	struct interval_tree_span_iter span;
+	u32 max_iovas;
+	int rc;
+
+	if (cmd->__reserved)
+		return -EOPNOTSUPP;
+
+	ioas = iommufd_get_ioas(ucmd, cmd->ioas_id);
+	if (IS_ERR(ioas))
+		return PTR_ERR(ioas);
+
+	down_read(&ioas->iopt.iova_rwsem);
+	max_iovas = cmd->num_iovas;
+	ranges = u64_to_user_ptr(cmd->allowed_iovas);
+	cmd->num_iovas = 0;
+	cmd->out_iova_alignment = ioas->iopt.iova_alignment;
+	interval_tree_for_each_span(&span, &ioas->iopt.reserved_itree, 0,
+				    ULONG_MAX) {
+		if (!span.is_hole)
+			continue;
+		if (cmd->num_iovas < max_iovas) {
+			struct iommu_iova_range elm = {
+				.start = span.start_hole,
+				.last = span.last_hole,
+			};
+
+			if (copy_to_user(&ranges[cmd->num_iovas], &elm,
+					 sizeof(elm))) {
+				rc = -EFAULT;
+				goto out_put;
+			}
+		}
+		cmd->num_iovas++;
+	}
+	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
+	if (rc)
+		goto out_put;
+	if (cmd->num_iovas > max_iovas)
+		rc = -EMSGSIZE;
+out_put:
+	up_read(&ioas->iopt.iova_rwsem);
+	iommufd_put_object(&ioas->obj);
+	return rc;
+}
+
+static int iommufd_ioas_load_iovas(struct rb_root_cached *itree,
+				   struct iommu_iova_range __user *ranges,
+				   u32 num)
+{
+	u32 i;
+
+	for (i = 0; i != num; i++) {
+		struct iommu_iova_range range;
+		struct iopt_allowed *allowed;
+
+		if (copy_from_user(&range, ranges + i, sizeof(range)))
+			return -EFAULT;
+
+		if (range.start >= range.last)
+			return -EINVAL;
+
+		if (interval_tree_iter_first(itree, range.start, range.last))
+			return -EINVAL;
+
+		allowed = kzalloc(sizeof(*allowed), GFP_KERNEL_ACCOUNT);
+		if (!allowed)
+			return -ENOMEM;
+		allowed->node.start = range.start;
+		allowed->node.last = range.last;
+
+		interval_tree_insert(&allowed->node, itree);
+	}
+	return 0;
+}
+
+int iommufd_ioas_allow_iovas(struct iommufd_ucmd *ucmd)
+{
+	struct iommu_ioas_allow_iovas *cmd = ucmd->cmd;
+	struct rb_root_cached allowed_iova = RB_ROOT_CACHED;
+	struct interval_tree_node *node;
+	struct iommufd_ioas *ioas;
+	struct io_pagetable *iopt;
+	int rc = 0;
+
+	if (cmd->__reserved)
+		return -EOPNOTSUPP;
+
+	ioas = iommufd_get_ioas(ucmd, cmd->ioas_id);
+	if (IS_ERR(ioas))
+		return PTR_ERR(ioas);
+	iopt = &ioas->iopt;
+
+	rc = iommufd_ioas_load_iovas(&allowed_iova,
+				     u64_to_user_ptr(cmd->allowed_iovas),
+				     cmd->num_iovas);
+	if (rc)
+		goto out_free;
+
+	/*
+	 * We want the allowed tree update to be atomic, so we have to keep the
+	 * original nodes around, and keep track of the new nodes as we allocate
+	 * memory for them. The simplest solution is to have a new/old tree and
+	 * then swap new for old. On success we free the old tree, on failure we
+	 * free the new tree.
+	 */
+	rc = iopt_set_allow_iova(iopt, &allowed_iova);
+out_free:
+	while ((node = interval_tree_iter_first(&allowed_iova, 0, ULONG_MAX))) {
+		interval_tree_remove(node, &allowed_iova);
+		kfree(container_of(node, struct iopt_allowed, node));
+	}
+	iommufd_put_object(&ioas->obj);
+	return rc;
+}
+
+static int conv_iommu_prot(u32 map_flags)
+{
+	/*
+	 * We provide no manual cache coherency ioctls to userspace and most
+	 * architectures make the CPU ops for cache flushing privileged.
+	 * Therefore we require the underlying IOMMU to support CPU coherent
+	 * operation. Support for IOMMU_CACHE is enforced by the
+	 * IOMMU_CAP_CACHE_COHERENCY test during bind.
+	 */
+	int iommu_prot = IOMMU_CACHE;
+
+	if (map_flags & IOMMU_IOAS_MAP_WRITEABLE)
+		iommu_prot |= IOMMU_WRITE;
+	if (map_flags & IOMMU_IOAS_MAP_READABLE)
+		iommu_prot |= IOMMU_READ;
+	return iommu_prot;
+}
+
+int iommufd_ioas_map(struct iommufd_ucmd *ucmd)
+{
+	struct iommu_ioas_map *cmd = ucmd->cmd;
+	unsigned long iova = cmd->iova;
+	struct iommufd_ioas *ioas;
+	unsigned int flags = 0;
+	int rc;
+
+	if ((cmd->flags &
+	     ~(IOMMU_IOAS_MAP_FIXED_IOVA | IOMMU_IOAS_MAP_WRITEABLE |
+	       IOMMU_IOAS_MAP_READABLE)) ||
+	    cmd->__reserved)
+		return -EOPNOTSUPP;
+	if (cmd->iova >= ULONG_MAX || cmd->length >= ULONG_MAX)
+		return -EOVERFLOW;
+
+	ioas = iommufd_get_ioas(ucmd, cmd->ioas_id);
+	if (IS_ERR(ioas))
+		return PTR_ERR(ioas);
+
+	if (!(cmd->flags & IOMMU_IOAS_MAP_FIXED_IOVA))
+		flags = IOPT_ALLOC_IOVA;
+	rc = iopt_map_user_pages(ucmd->ictx, &ioas->iopt, &iova,
+				 u64_to_user_ptr(cmd->user_va), cmd->length,
+				 conv_iommu_prot(cmd->flags), flags);
+	if (rc)
+		goto out_put;
+
+	cmd->iova = iova;
+	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
+out_put:
+	iommufd_put_object(&ioas->obj);
+	return rc;
+}
+
+int iommufd_ioas_copy(struct iommufd_ucmd *ucmd)
+{
+	struct iommu_ioas_copy *cmd = ucmd->cmd;
+	struct iommufd_ioas *src_ioas;
+	struct iommufd_ioas *dst_ioas;
+	unsigned int flags = 0;
+	LIST_HEAD(pages_list);
+	unsigned long iova;
+	int rc;
+
+	if ((cmd->flags &
+	     ~(IOMMU_IOAS_MAP_FIXED_IOVA | IOMMU_IOAS_MAP_WRITEABLE |
+	       IOMMU_IOAS_MAP_READABLE)))
+		return -EOPNOTSUPP;
+	if (cmd->length >= ULONG_MAX || cmd->src_iova >= ULONG_MAX ||
+	    cmd->dst_iova >= ULONG_MAX)
+		return -EOVERFLOW;
+
+	src_ioas = iommufd_get_ioas(ucmd, cmd->src_ioas_id);
+	if (IS_ERR(src_ioas))
+		return PTR_ERR(src_ioas);
+	rc = iopt_get_pages(&src_ioas->iopt, cmd->src_iova, cmd->length,
+			    &pages_list);
+	iommufd_put_object(&src_ioas->obj);
+	if (rc)
+		return rc;
+
+	dst_ioas = iommufd_get_ioas(ucmd, cmd->dst_ioas_id);
+	if (IS_ERR(dst_ioas)) {
+		rc = PTR_ERR(dst_ioas);
+		goto out_pages;
+	}
+
+	if (!(cmd->flags & IOMMU_IOAS_MAP_FIXED_IOVA))
+		flags = IOPT_ALLOC_IOVA;
+	iova = cmd->dst_iova;
+	rc = iopt_map_pages(&dst_ioas->iopt, &pages_list, cmd->length, &iova,
+			    conv_iommu_prot(cmd->flags), flags);
+	if (rc)
+		goto out_put_dst;
+
+	cmd->dst_iova = iova;
+	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
+out_put_dst:
+	iommufd_put_object(&dst_ioas->obj);
+out_pages:
+	iopt_free_pages_list(&pages_list);
+	return rc;
+}
+
+int iommufd_ioas_unmap(struct iommufd_ucmd *ucmd)
+{
+	struct iommu_ioas_unmap *cmd = ucmd->cmd;
+	struct iommufd_ioas *ioas;
+	unsigned long unmapped = 0;
+	int rc;
+
+	ioas = iommufd_get_ioas(ucmd, cmd->ioas_id);
+	if (IS_ERR(ioas))
+		return PTR_ERR(ioas);
+
+	if (cmd->iova == 0 && cmd->length == U64_MAX) {
+		rc = iopt_unmap_all(&ioas->iopt, &unmapped);
+		if (rc)
+			goto out_put;
+	} else {
+		if (cmd->iova >= ULONG_MAX || cmd->length >= ULONG_MAX) {
+			rc = -EOVERFLOW;
+			goto out_put;
+		}
+		rc = iopt_unmap_iova(&ioas->iopt, cmd->iova, cmd->length,
+				     &unmapped);
+		if (rc)
+			goto out_put;
+	}
+
+	cmd->length = unmapped;
+	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
+
+out_put:
+	iommufd_put_object(&ioas->obj);
+	return rc;
+}
+
+int iommufd_option_rlimit_mode(struct iommu_option *cmd,
+			       struct iommufd_ctx *ictx)
+{
+	if (cmd->object_id)
+		return -EOPNOTSUPP;
+
+	if (cmd->op == IOMMU_OPTION_OP_GET) {
+		cmd->val64 = ictx->account_mode == IOPT_PAGES_ACCOUNT_MM;
+		return 0;
+	}
+	if (cmd->op == IOMMU_OPTION_OP_SET) {
+		int rc = 0;
+
+		if (!capable(CAP_SYS_RESOURCE))
+			return -EPERM;
+
+		xa_lock(&ictx->objects);
+		if (!xa_empty(&ictx->objects)) {
+			rc = -EBUSY;
+		} else {
+			if (cmd->val64 == 0)
+				ictx->account_mode = IOPT_PAGES_ACCOUNT_USER;
+			else if (cmd->val64 == 1)
+				ictx->account_mode = IOPT_PAGES_ACCOUNT_MM;
+			else
+				rc = -EINVAL;
+		}
+		xa_unlock(&ictx->objects);
+
+		return rc;
+	}
+	return -EOPNOTSUPP;
+}
+
+static int iommufd_ioas_option_huge_pages(struct iommu_option *cmd,
+					  struct iommufd_ioas *ioas)
+{
+	if (cmd->op == IOMMU_OPTION_OP_GET) {
+		cmd->val64 = !ioas->iopt.disable_large_pages;
+		return 0;
+	}
+	if (cmd->op == IOMMU_OPTION_OP_SET) {
+		if (cmd->val64 == 0)
+			return iopt_disable_large_pages(&ioas->iopt);
+		if (cmd->val64 == 1) {
+			iopt_enable_large_pages(&ioas->iopt);
+			return 0;
+		}
+		return -EINVAL;
+	}
+	return -EOPNOTSUPP;
+}
+
+int iommufd_ioas_option(struct iommufd_ucmd *ucmd)
+{
+	struct iommu_option *cmd = ucmd->cmd;
+	struct iommufd_ioas *ioas;
+	int rc = 0;
+
+	if (cmd->__reserved)
+		return -EOPNOTSUPP;
+
+	ioas = iommufd_get_ioas(ucmd, cmd->object_id);
+	if (IS_ERR(ioas))
+		return PTR_ERR(ioas);
+
+	switch (cmd->option_id) {
+	case IOMMU_OPTION_HUGE_PAGES:
+		rc = iommufd_ioas_option_huge_pages(cmd, ioas);
+		break;
+	default:
+		rc = -EOPNOTSUPP;
+	}
+
+	iommufd_put_object(&ioas->obj);
+	return rc;
+}
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index f7ab6c6edafd13..1a13c54a8def86 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -11,6 +11,7 @@
 
 struct iommu_domain;
 struct iommu_group;
+struct iommu_option;
 
 struct iommufd_ctx {
 	struct file *file;
@@ -102,6 +103,7 @@ static inline int iommufd_ucmd_respond(struct iommufd_ucmd *ucmd,
 enum iommufd_object_type {
 	IOMMUFD_OBJ_NONE,
 	IOMMUFD_OBJ_ANY = IOMMUFD_OBJ_NONE,
+	IOMMUFD_OBJ_IOAS,
 };
 
 /* Base struct for all objects with a userspace ID handle. */
@@ -174,6 +176,37 @@ struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
 			     type),                                            \
 		     typeof(*(ptr)), obj)
 
+/*
+ * The IO Address Space (IOAS) pagetable is a virtual page table backed by the
+ * io_pagetable object. It is a user controlled mapping of IOVA -> PFNs. The
+ * mapping is copied into all of the associated domains and made available to
+ * in-kernel users.
+ */
+struct iommufd_ioas {
+	struct iommufd_object obj;
+	struct io_pagetable iopt;
+};
+
+static inline struct iommufd_ioas *iommufd_get_ioas(struct iommufd_ucmd *ucmd,
+						    u32 id)
+{
+	return container_of(iommufd_get_object(ucmd->ictx, id,
+					       IOMMUFD_OBJ_IOAS),
+			    struct iommufd_ioas, obj);
+}
+
+struct iommufd_ioas *iommufd_ioas_alloc(struct iommufd_ctx *ictx);
+int iommufd_ioas_alloc_ioctl(struct iommufd_ucmd *ucmd);
+void iommufd_ioas_destroy(struct iommufd_object *obj);
+int iommufd_ioas_iova_ranges(struct iommufd_ucmd *ucmd);
+int iommufd_ioas_allow_iovas(struct iommufd_ucmd *ucmd);
+int iommufd_ioas_map(struct iommufd_ucmd *ucmd);
+int iommufd_ioas_copy(struct iommufd_ucmd *ucmd);
+int iommufd_ioas_unmap(struct iommufd_ucmd *ucmd);
+int iommufd_ioas_option(struct iommufd_ucmd *ucmd);
+int iommufd_option_rlimit_mode(struct iommu_option *cmd,
+			       struct iommufd_ctx *ictx);
+
 struct iommufd_access {
 	unsigned long iova_alignment;
 	u32 iopt_access_list_id;
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index dfbc68b97506d0..1c0a1f499378db 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -204,8 +204,39 @@ static int iommufd_fops_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+static int iommufd_option(struct iommufd_ucmd *ucmd)
+{
+	struct iommu_option *cmd = ucmd->cmd;
+	int rc;
+
+	if (cmd->__reserved)
+		return -EOPNOTSUPP;
+
+	switch (cmd->option_id) {
+	case IOMMU_OPTION_RLIMIT_MODE:
+		rc = iommufd_option_rlimit_mode(cmd, ucmd->ictx);
+		break;
+	case IOMMU_OPTION_HUGE_PAGES:
+		rc = iommufd_ioas_option(ucmd);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+	if (rc)
+		return rc;
+	if (copy_to_user(&((struct iommu_option __user *)ucmd->ubuffer)->val64,
+			 &cmd->val64, sizeof(cmd->val64)))
+		return -EFAULT;
+	return 0;
+}
+
 union ucmd_buffer {
 	struct iommu_destroy destroy;
+	struct iommu_ioas_alloc alloc;
+	struct iommu_ioas_allow_iovas allow_iovas;
+	struct iommu_ioas_iova_ranges iova_ranges;
+	struct iommu_ioas_map map;
+	struct iommu_ioas_unmap unmap;
 };
 
 struct iommufd_ioctl_op {
@@ -226,6 +257,20 @@ struct iommufd_ioctl_op {
 	}
 static const struct iommufd_ioctl_op iommufd_ioctl_ops[] = {
 	IOCTL_OP(IOMMU_DESTROY, iommufd_destroy, struct iommu_destroy, id),
+	IOCTL_OP(IOMMU_IOAS_ALLOC, iommufd_ioas_alloc_ioctl,
+		 struct iommu_ioas_alloc, out_ioas_id),
+	IOCTL_OP(IOMMU_IOAS_ALLOW_IOVAS, iommufd_ioas_allow_iovas,
+		 struct iommu_ioas_allow_iovas, allowed_iovas),
+	IOCTL_OP(IOMMU_IOAS_COPY, iommufd_ioas_copy, struct iommu_ioas_copy,
+		 src_iova),
+	IOCTL_OP(IOMMU_IOAS_IOVA_RANGES, iommufd_ioas_iova_ranges,
+		 struct iommu_ioas_iova_ranges, out_iova_alignment),
+	IOCTL_OP(IOMMU_IOAS_MAP, iommufd_ioas_map, struct iommu_ioas_map,
+		 iova),
+	IOCTL_OP(IOMMU_IOAS_UNMAP, iommufd_ioas_unmap, struct iommu_ioas_unmap,
+		 length),
+	IOCTL_OP(IOMMU_OPTION, iommufd_option, struct iommu_option,
+		 val64),
 };
 
 static long iommufd_fops_ioctl(struct file *filp, unsigned int cmd,
@@ -312,6 +357,9 @@ void iommufd_ctx_put(struct iommufd_ctx *ictx)
 EXPORT_SYMBOL_NS_GPL(iommufd_ctx_put, IOMMUFD);
 
 static const struct iommufd_object_ops iommufd_object_ops[] = {
+	[IOMMUFD_OBJ_IOAS] = {
+		.destroy = iommufd_ioas_destroy,
+	},
 };
 
 static struct miscdevice iommu_misc_dev = {
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 37de92f0534b86..855aa984b632d3 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -37,12 +37,19 @@
 enum {
 	IOMMUFD_CMD_BASE = 0x80,
 	IOMMUFD_CMD_DESTROY = IOMMUFD_CMD_BASE,
+	IOMMUFD_CMD_IOAS_ALLOC,
+	IOMMUFD_CMD_IOAS_ALLOW_IOVAS,
+	IOMMUFD_CMD_IOAS_COPY,
+	IOMMUFD_CMD_IOAS_IOVA_RANGES,
+	IOMMUFD_CMD_IOAS_MAP,
+	IOMMUFD_CMD_IOAS_UNMAP,
+	IOMMUFD_CMD_OPTION,
 };
 
 /**
  * struct iommu_destroy - ioctl(IOMMU_DESTROY)
  * @size: sizeof(struct iommu_destroy)
- * @id: iommufd object ID to destroy. Can by any destroyable object type.
+ * @id: iommufd object ID to destroy. Can be any destroyable object type.
  *
  * Destroy any object held within iommufd.
  */
@@ -52,4 +59,251 @@ struct iommu_destroy {
 };
 #define IOMMU_DESTROY _IO(IOMMUFD_TYPE, IOMMUFD_CMD_DESTROY)
 
+/**
+ * struct iommu_ioas_alloc - ioctl(IOMMU_IOAS_ALLOC)
+ * @size: sizeof(struct iommu_ioas_alloc)
+ * @flags: Must be 0
+ * @out_ioas_id: Output IOAS ID for the allocated object
+ *
+ * Allocate an IO Address Space (IOAS) which holds an IO Virtual Address (IOVA)
+ * to memory mapping.
+ */
+struct iommu_ioas_alloc {
+	__u32 size;
+	__u32 flags;
+	__u32 out_ioas_id;
+};
+#define IOMMU_IOAS_ALLOC _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_ALLOC)
+
+/**
+ * struct iommu_iova_range - ioctl(IOMMU_IOVA_RANGE)
+ * @start: First IOVA
+ * @last: Inclusive last IOVA
+ *
+ * An interval in IOVA space.
+ */
+struct iommu_iova_range {
+	__aligned_u64 start;
+	__aligned_u64 last;
+};
+
+/**
+ * struct iommu_ioas_iova_ranges - ioctl(IOMMU_IOAS_IOVA_RANGES)
+ * @size: sizeof(struct iommu_ioas_iova_ranges)
+ * @ioas_id: IOAS ID to read ranges from
+ * @num_iovas: Input/Output total number of ranges in the IOAS
+ * @__reserved: Must be 0
+ * @allowed_iovas: Pointer to the output array of struct iommu_iova_range
+ * @out_iova_alignment: Minimum alignment required for mapping IOVA
+ *
+ * Query an IOAS for ranges of allowed IOVAs. Mapping IOVA outside these ranges
+ * is not allowed. num_iovas will be set to the total number of iovas and
+ * the allowed_iovas[] will be filled in as space permits.
+ *
+ * The allowed ranges are dependent on the HW path the DMA operation takes, and
+ * can change during the lifetime of the IOAS. A fresh empty IOAS will have a
+ * full range, and each attached device will narrow the ranges based on that
+ * device's HW restrictions. Detaching a device can widen the ranges. Userspace
+ * should query ranges after every attach/detach to know what IOVAs are valid
+ * for mapping.
+ *
+ * On input num_iovas is the length of the allowed_iovas array. On output it is
+ * the total number of iovas filled in. The ioctl will return -EMSGSIZE and set
+ * num_iovas to the required value if num_iovas is too small. In this case the
+ * caller should allocate a larger output array and re-issue the ioctl.
+ *
+ * out_iova_alignment returns the minimum IOVA alignment that can be given
+ * to IOMMU_IOAS_MAP/COPY. IOVA's must satisfy:
+ *   starting_iova % out_iova_alignment == 0
+ *   (starting_iova + length) % out_iova_alignment == 0
+ * out_iova_alignment can be 1 indicating any IOVA is allowed. It cannot
+ * be higher than the system PAGE_SIZE.
+ */
+struct iommu_ioas_iova_ranges {
+	__u32 size;
+	__u32 ioas_id;
+	__u32 num_iovas;
+	__u32 __reserved;
+	__aligned_u64 allowed_iovas;
+	__aligned_u64 out_iova_alignment;
+};
+#define IOMMU_IOAS_IOVA_RANGES _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_IOVA_RANGES)
+
+/**
+ * struct iommu_ioas_allow_iovas - ioctl(IOMMU_IOAS_ALLOW_IOVAS)
+ * @size: sizeof(struct iommu_ioas_allow_iovas)
+ * @ioas_id: IOAS ID to allow IOVAs from
+ * @num_iovas: Input/Output total number of ranges in the IOAS
+ * @__reserved: Must be 0
+ * @allowed_iovas: Pointer to array of struct iommu_iova_range
+ *
+ * Ensure a range of IOVAs are always available for allocation. If this call
+ * succeeds then IOMMU_IOAS_IOVA_RANGES will never return a list of IOVA ranges
+ * that are narrower than the ranges provided here. This call will fail if
+ * IOMMU_IOAS_IOVA_RANGES is currently narrower than the given ranges.
+ *
+ * When an IOAS is first created the IOVA_RANGES will be maximally sized, and as
+ * devices are attached the IOVA will narrow based on the device restrictions.
+ * When an allowed range is specified any narrowing will be refused, ie device
+ * attachment can fail if the device requires limiting within the allowed range.
+ *
+ * Automatic IOVA allocation is also impacted by this call. MAP will only
+ * allocate within the allowed IOVAs if they are present.
+ *
+ * This call replaces the entire allowed list with the given list.
+ */
+struct iommu_ioas_allow_iovas {
+	__u32 size;
+	__u32 ioas_id;
+	__u32 num_iovas;
+	__u32 __reserved;
+	__aligned_u64 allowed_iovas;
+};
+#define IOMMU_IOAS_ALLOW_IOVAS _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_ALLOW_IOVAS)
+
+/**
+ * enum iommufd_ioas_map_flags - Flags for map and copy
+ * @IOMMU_IOAS_MAP_FIXED_IOVA: If clear the kernel will compute an appropriate
+ *                             IOVA to place the mapping at
+ * @IOMMU_IOAS_MAP_WRITEABLE: DMA is allowed to write to this mapping
+ * @IOMMU_IOAS_MAP_READABLE: DMA is allowed to read from this mapping
+ */
+enum iommufd_ioas_map_flags {
+	IOMMU_IOAS_MAP_FIXED_IOVA = 1 << 0,
+	IOMMU_IOAS_MAP_WRITEABLE = 1 << 1,
+	IOMMU_IOAS_MAP_READABLE = 1 << 2,
+};
+
+/**
+ * struct iommu_ioas_map - ioctl(IOMMU_IOAS_MAP)
+ * @size: sizeof(struct iommu_ioas_map)
+ * @flags: Combination of enum iommufd_ioas_map_flags
+ * @ioas_id: IOAS ID to change the mapping of
+ * @__reserved: Must be 0
+ * @user_va: Userspace pointer to start mapping from
+ * @length: Number of bytes to map
+ * @iova: IOVA the mapping was placed at. If IOMMU_IOAS_MAP_FIXED_IOVA is set
+ *        then this must be provided as input.
+ *
+ * Set an IOVA mapping from a user pointer. If FIXED_IOVA is specified then the
+ * mapping will be established at iova, otherwise a suitable location based on
+ * the reserved and allowed lists will be automatically selected and returned in
+ * iova.
+ *
+ * If IOMMU_IOAS_MAP_FIXED_IOVA is specified then the iova range must currently
+ * be unused, existing IOVA cannot be replaced.
+ */
+struct iommu_ioas_map {
+	__u32 size;
+	__u32 flags;
+	__u32 ioas_id;
+	__u32 __reserved;
+	__aligned_u64 user_va;
+	__aligned_u64 length;
+	__aligned_u64 iova;
+};
+#define IOMMU_IOAS_MAP _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_MAP)
+
+/**
+ * struct iommu_ioas_copy - ioctl(IOMMU_IOAS_COPY)
+ * @size: sizeof(struct iommu_ioas_copy)
+ * @flags: Combination of enum iommufd_ioas_map_flags
+ * @dst_ioas_id: IOAS ID to change the mapping of
+ * @src_ioas_id: IOAS ID to copy from
+ * @length: Number of bytes to copy and map
+ * @dst_iova: IOVA the mapping was placed at. If IOMMU_IOAS_MAP_FIXED_IOVA is
+ *            set then this must be provided as input.
+ * @src_iova: IOVA to start the copy
+ *
+ * Copy an already existing mapping from src_ioas_id and establish it in
+ * dst_ioas_id. The src iova/length must exactly match a range used with
+ * IOMMU_IOAS_MAP.
+ *
+ * This may be used to efficiently clone a subset of an IOAS to another, or as a
+ * kind of 'cache' to speed up mapping. Copy has an efficiency advantage over
+ * establishing equivalent new mappings, as internal resources are shared, and
+ * the kernel will pin the user memory only once.
+ */
+struct iommu_ioas_copy {
+	__u32 size;
+	__u32 flags;
+	__u32 dst_ioas_id;
+	__u32 src_ioas_id;
+	__aligned_u64 length;
+	__aligned_u64 dst_iova;
+	__aligned_u64 src_iova;
+};
+#define IOMMU_IOAS_COPY _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_COPY)
+
+/**
+ * struct iommu_ioas_unmap - ioctl(IOMMU_IOAS_UNMAP)
+ * @size: sizeof(struct iommu_ioas_unmap)
+ * @ioas_id: IOAS ID to change the mapping of
+ * @iova: IOVA to start the unmapping at
+ * @length: Number of bytes to unmap, and return back the bytes unmapped
+ *
+ * Unmap an IOVA range. The iova/length must be a superset of a previously
+ * mapped range used with IOMMU_IOAS_MAP or IOMMU_IOAS_COPY. Splitting or
+ * truncating ranges is not allowed. The values 0 to U64_MAX will unmap
+ * everything.
+ */
+struct iommu_ioas_unmap {
+	__u32 size;
+	__u32 ioas_id;
+	__aligned_u64 iova;
+	__aligned_u64 length;
+};
+#define IOMMU_IOAS_UNMAP _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_UNMAP)
+
+/**
+ * enum iommufd_option - ioctl(IOMMU_OPTION_RLIMIT_MODE) and
+ *                       ioctl(IOMMU_OPTION_HUGE_PAGES)
+ * @IOMMU_OPTION_RLIMIT_MODE:
+ *    Change how RLIMIT_MEMLOCK accounting works. The caller must have privilege
+ *    to invoke this. Value 0 (default) is user based accouting, 1 uses process
+ *    based accounting. Global option, object_id must be 0
+ * @IOMMU_OPTION_HUGE_PAGES:
+ *    Value 1 (default) allows contiguous pages to be combined when generating
+ *    iommu mappings. Value 0 disables combining, everything is mapped to
+ *    PAGE_SIZE. This can be useful for benchmarking.  This is a per-IOAS
+ *    option, the object_id must be the IOAS ID.
+ */
+enum iommufd_option {
+	IOMMU_OPTION_RLIMIT_MODE = 0,
+	IOMMU_OPTION_HUGE_PAGES = 1,
+};
+
+/**
+ * enum iommufd_option_ops - ioctl(IOMMU_OPTION_OP_SET) and
+ *                           ioctl(IOMMU_OPTION_OP_GET)
+ * @IOMMU_OPTION_OP_SET: Set the option's value
+ * @IOMMU_OPTION_OP_GET: Get the option's value
+ */
+enum iommufd_option_ops {
+	IOMMU_OPTION_OP_SET = 0,
+	IOMMU_OPTION_OP_GET = 1,
+};
+
+/**
+ * struct iommu_option - iommu option multiplexer
+ * @size: sizeof(struct iommu_option)
+ * @option_id: One of enum iommufd_option
+ * @op: One of enum iommufd_option_ops
+ * @__reserved: Must be 0
+ * @object_id: ID of the object if required
+ * @val64: Option value to set or value returned on get
+ *
+ * Change a simple option value. This multiplexor allows controlling options
+ * on objects. IOMMU_OPTION_OP_SET will load an option and IOMMU_OPTION_OP_GET
+ * will return the current value.
+ */
+struct iommu_option {
+	__u32 size;
+	__u32 option_id;
+	__u16 op;
+	__u16 __reserved;
+	__u32 object_id;
+	__aligned_u64 val64;
+};
+#define IOMMU_OPTION _IO(IOMMUFD_TYPE, IOMMUFD_CMD_OPTION)
 #endif
-- 
2.38.1

