Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBA54DDFE3
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 18:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239618AbiCRR3E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 13:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239613AbiCRR3D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 13:29:03 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2069.outbound.protection.outlook.com [40.107.93.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457581D7639
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 10:27:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LQKMn3LtbU5ZZt4fNWV+ypu/zVmBue/B4lK2kiG3ryeqLaquE0/mcuefh0Y5DRcUa5BYYSNzfFzUtnCv/zjbutC5qtuMkDwg84ZDQNvgi8+M2qGaivSLN9zFOBf7HBiCSA3G2lp6/qDEJjEQSYKfYVGN5u4M1LTtZMe1Hrdjwrig5gugmEeiHp6aJr9zmTX69I6GlzE6Y+IleQ315KMRn/HwuW89To2BpxQcsmBvOd4cBHe4yEiQyJeiVOAeamviZ1rCEt2SND/aPlu3NsAXlYzKm8co3K9IUdAUQNCKXMpyTiDIeiLPo8HQ4YC4xFylrTcgu5tb5AaNXqJZ9zkdCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kl3oW+m+h9EJa06pHjX4r3zG7IMLKOhWXlkSdgoi/Dk=;
 b=CCjjrb41LZZdoEPDpC3t6l3EIKNbxGO4oS/8B0FsWQ2XFh5AA7LNmGSKlMLHySiU2XMHUDAYhnH76XtKo6ZjbvLpFaN6H9wWbK7YyZ6So+WvRMuPrpA3f9wOUcPFT7VQgcyv8O1ldCSePttjPM/4TyQbfgPvj0c92e4MZxur7YFkzD7PnZjKXhFmnL+HDcERe5+zrup1H9dcH/bCOiv12ozboHTEaFLSNEi0e4LFmWd0XtDXSjXKw1/EJ0sov+VK9eu9zujFPY4uGOcop2IsSh2zsIuH+yA8vG38afCSUZgpz0kWQ4IaXhEQPsQbuHUcnq3/iOI9HErRIS/Dg9vwrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kl3oW+m+h9EJa06pHjX4r3zG7IMLKOhWXlkSdgoi/Dk=;
 b=MBHMvIqoVl2RbB7jJCoeFeZqdnyMv5jq/ueXUyPMdFQkOoJYUhF29LAEgJvm7wOFyHE3KN3L0+Y/tzFQ8L5RMtz/cpz8Y3BYtb1RTyMXl9HjpIhvJXKUruSEWq1H67g3dGAkwBe01B0feZmo7uBpwdExS1D6NUBNZaID4bnYrk4AzvzLpqJxFXEmfENTX68QxWuSOajqlJZLzfxRFi6Nhw9mal6XeVT5cc1nN8ZfmVXxklI2neTrJXdoR+CAWIx1YSZsG3Dp25QEcNOqatVVF5hNmLUyxrJ3Id3hxi3wgWOgXlsGMo+NJ7AZKELimMm02OwE5daeDF2Wfgcq7Qt4rQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB3951.namprd12.prod.outlook.com (2603:10b6:208:16b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Fri, 18 Mar
 2022 17:27:40 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%5]) with mapi id 15.20.5081.018; Fri, 18 Mar 2022
 17:27:40 +0000
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
Subject: [PATCH RFC 08/12] iommufd: IOCTLs for the io_pagetable
Date:   Fri, 18 Mar 2022 14:27:33 -0300
Message-Id: <8-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
In-Reply-To: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0231.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::26) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 116c5bc0-798b-4400-1d8d-08da090499cc
X-MS-TrafficTypeDiagnostic: MN2PR12MB3951:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB395105AE6B8BE3D539B16A52C2139@MN2PR12MB3951.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: di4c1uMfPPNuoBzfzFBaNupNcV9AtpxNrY2tmtdp5fv+zciT9qoPcrMuSziuRAgFRnRVgxu1al+MoRp9s1qmL6PxmJdshLpsbjMOKs2BWLlUM7omiBoDq0UH6rmXAQY9VhQJk+BXY9aL5vIrFzwmFNT9wlAU2BE1Pv+FwZ0Dy/x4XUV56ygDxgIgusDlgsAtl8CKM0aUJtIq2heOpmLS76G49bRl3n/gZ3sb8Iv0RRK6YxWZ3xDVVjQc0RGceNeZYmI9hIyK1Ex7yi3rLTcMK7cGjUzIMpYm/nfCu2kuhEDtd0HKaJdvbZ4xPaI5hZ7QxYtC10tIG/Oiz9b5x7FBxeSlrqfTQEPjX/bQEtf5lQLDQl0JN6dhq81ymBre+NmMaK4Cq+BsweI3GI02w6YSoQXDnkrSi74TCmC4DSLBNciecRKndsDbbgr+cSab72ld/sJB0rh27RzzG1XJLuWHEX6hipTp95u2DXNVJ+cSN+tuakmztgS9Mn/SzU7xQISD3Lwui2Tk/NEH/jlxdFEQnp8pqNiaKl7w4vqMDJW8BIB4B5oLyrqlmJEIVe4WGYiDsK94NEH2hj2XhkqalREkurl5Gzzttyw2mkCI5zp1qGer++p116zOqfrdYHwJ88ak4+e87SLRILZLx026ouxlHVWFse99EuZOkXrW6dIvGLuvUeFJNfGc9csmPq9ujThbgEwtFl+MYTlgItf8JI9rgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(30864003)(83380400001)(7416002)(4326008)(2906002)(86362001)(508600001)(8676002)(6512007)(6506007)(6666004)(5660300002)(8936002)(109986005)(66946007)(26005)(66476007)(186003)(316002)(66556008)(2616005)(36756003)(38100700002)(6486002)(54906003)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IjkwVXGRiAkpW1HVlzRyUJLi46gmIk1TVDjwkLfOshXCMASxwUHjn0jvH0Zd?=
 =?us-ascii?Q?Owp6owfSCXa+BI+U7TR4Yy7yE/bglcgNwc65FNvyRyld+K+5turakPjkxlhk?=
 =?us-ascii?Q?q5xu497s9PgFlibSh9AVBnhX7k49gKD5fYUha4eaC28Gbf0gqKH94GcyTMuS?=
 =?us-ascii?Q?CuBiWI7nWfmUYY82bZ7WGl8Xc3ZYBYX87DkS+NT0YX9HBgcUtaCDZa4HT0ZJ?=
 =?us-ascii?Q?AWTECiXc1slMlljCXPAQusZ7JpPaMyncyKAz6bN+YqpURW0TKYcveOH8he0U?=
 =?us-ascii?Q?Ad3KqrezOZHHEbqpoC/6341chRFoQWsTo63sFtpPfZYKqi5ZKQrUpG7W3Abu?=
 =?us-ascii?Q?Dn5LbNRs0SzdrREyue71M2QDPM9wkJDzD72gzFEPznXfOjQr7lnYN+/A3Vx1?=
 =?us-ascii?Q?rTegcQiZPcRTJiUE5ETEIWVbLfWEDXGp+X3o5YLJPsr7nDk7aJBkmdBr3UBx?=
 =?us-ascii?Q?P8UzJCueeAvE0L6O27YVs2Dn5V3f1W72tu2I05KzTln/uXGdPbBJm/J7G9NU?=
 =?us-ascii?Q?h2LoZqIaw/lgDMAjA2BeqKjSjmgEocSArNiaR0ijufUQ1nGzBYcSDUDYKhGa?=
 =?us-ascii?Q?cnICqH8I3Ryr0p68EyNETkYbPZxKkkZoDBhxAHqZYpOJeiutgtV3jeRjxCxy?=
 =?us-ascii?Q?T2bnIf7GzbRIHZoVPHjdXvQa3D3AF9UNXnFQpL/2VNhLN09zHGiPsldLwLsb?=
 =?us-ascii?Q?fA5qzgoZJ96uF0vXYl8yXJUAMdnZIoh1uAQxIMU9VpC8inwei8gEwLGfzoTY?=
 =?us-ascii?Q?Ndb16ouRFQr3Jk5/DWbLYMkFzE7o93Z2WKTSRNKde3w+uEwcMCglaweSfv0Z?=
 =?us-ascii?Q?1/LirajbsVS3y6uK16BHHdcFI/fvUlGoHmy1lOqNVOXXKHefY+4suJHKbpUA?=
 =?us-ascii?Q?113daSxNZab3lMgU+pPZ8n3Y6XYSTp7EnSgutqHdwG8IcTERxUstOD65rQH8?=
 =?us-ascii?Q?wNmp4oYOizFIBKjLmafLQ2IXsME3iFeQJz+mJIRTIRFD66B3ifRpBsAJEBBY?=
 =?us-ascii?Q?6jGJdPbxvi4U2Jh261jCaOrYgn9KUzBdCj3wT60IaIqmlIf49zDkrsVZn3JJ?=
 =?us-ascii?Q?bsN1ALj4jgSkd6ah4G+JSvjre4dph5YTwTV+77Ghx/ovmJSxB4Rj0/38GxE9?=
 =?us-ascii?Q?XQD6At4ceriDWQH+qRACT8T30GbIzonDfpp1alTcLvK7XbgwkIf1aG+MlylV?=
 =?us-ascii?Q?rcT71AKfkbX7ebSnQb208e7oZYKs2UHQ3QYb8tkjGMXPp3OXZ+vTeB0DTgEi?=
 =?us-ascii?Q?6M0f4xI+l4nQXuyhF/83+gR4sXetmO9CtOU+NFxJ4G0mjg2X3Pkn/W1PIPKK?=
 =?us-ascii?Q?TRKGUWLeGkJh+dHUR5z5tWMpBIWeXX6PFihK4nmQVCsBY54whQI829HbQhm9?=
 =?us-ascii?Q?4jKJ4MQwUvE/+2hecusTmZXj3raWBrWTlMkk/CWxFetMmhFM49avHVSEg5kZ?=
 =?us-ascii?Q?2WRMBsSqNAVfZPMqyj3brjDyyI9gausx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 116c5bc0-798b-4400-1d8d-08da090499cc
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 17:27:39.2875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tKWGqoPIJcJpznKAaNtZpnhnY8SLplfvMKvJg1f4pTQmZ2LmIBumyO6ha963udBS
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

Connect the IOAS to its IOCTL interface. This exposes most of the
functionality in the io_pagetable to userspace.

This is intended to be the core of the generic interface that IOMMUFD will
provide. Every IOMMU driver should be able to implement an iommu_domain
that is compatible with this generic mechanism.

It is also designed to be easy to use for simple non virtual machine
monitor users, like DPDK:
 - Universal simple support for all IOMMUs (no PPC special path)
 - An IOVA allocator that considerds the aperture and the reserved ranges
 - io_pagetable allows any number of iommu_domains to be connected to the
   IOAS

Along with room in the design to add non-generic features to cater to
specific HW functionality.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/Makefile          |   1 +
 drivers/iommu/iommufd/ioas.c            | 248 ++++++++++++++++++++++++
 drivers/iommu/iommufd/iommufd_private.h |  27 +++
 drivers/iommu/iommufd/main.c            |  17 ++
 include/uapi/linux/iommufd.h            | 132 +++++++++++++
 5 files changed, 425 insertions(+)
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
index 00000000000000..c530b2ba74b06b
--- /dev/null
+++ b/drivers/iommu/iommufd/ioas.c
@@ -0,0 +1,248 @@
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
+	rc = iopt_unmap_all(&ioas->iopt);
+	WARN_ON(rc);
+	iopt_destroy_table(&ioas->iopt);
+}
+
+struct iommufd_ioas *iommufd_ioas_alloc(struct iommufd_ctx *ictx)
+{
+	struct iommufd_ioas *ioas;
+	int rc;
+
+	ioas = iommufd_object_alloc(ictx, ioas, IOMMUFD_OBJ_IOAS);
+	if (IS_ERR(ioas))
+		return ioas;
+
+	rc = iopt_init_table(&ioas->iopt);
+	if (rc)
+		goto out_abort;
+	return ioas;
+
+out_abort:
+	iommufd_object_abort(ictx, &ioas->obj);
+	return ERR_PTR(rc);
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
+	iommufd_ioas_destroy(&ioas->obj);
+	return rc;
+}
+
+int iommufd_ioas_iova_ranges(struct iommufd_ucmd *ucmd)
+{
+	struct iommu_ioas_iova_ranges __user *uptr = ucmd->ubuffer;
+	struct iommu_ioas_iova_ranges *cmd = ucmd->cmd;
+	struct iommufd_ioas *ioas;
+	struct interval_tree_span_iter span;
+	u32 max_iovas;
+	int rc;
+
+	if (cmd->__reserved)
+		return -EOPNOTSUPP;
+
+	max_iovas = cmd->size - sizeof(*cmd);
+	if (max_iovas % sizeof(cmd->out_valid_iovas[0]))
+		return -EINVAL;
+	max_iovas /= sizeof(cmd->out_valid_iovas[0]);
+
+	ioas = iommufd_get_ioas(ucmd, cmd->ioas_id);
+	if (IS_ERR(ioas))
+		return PTR_ERR(ioas);
+
+	down_read(&ioas->iopt.iova_rwsem);
+	cmd->out_num_iovas = 0;
+	for (interval_tree_span_iter_first(
+		     &span, &ioas->iopt.reserved_iova_itree, 0, ULONG_MAX);
+	     !interval_tree_span_iter_done(&span);
+	     interval_tree_span_iter_next(&span)) {
+		if (!span.is_hole)
+			continue;
+		if (cmd->out_num_iovas < max_iovas) {
+			rc = put_user((u64)span.start_hole,
+				      &uptr->out_valid_iovas[cmd->out_num_iovas]
+					       .start);
+			if (rc)
+				goto out_put;
+			rc = put_user(
+				(u64)span.last_hole,
+				&uptr->out_valid_iovas[cmd->out_num_iovas].last);
+			if (rc)
+				goto out_put;
+		}
+		cmd->out_num_iovas++;
+	}
+	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
+	if (rc)
+		goto out_put;
+	if (cmd->out_num_iovas > max_iovas)
+		rc = -EMSGSIZE;
+out_put:
+	up_read(&ioas->iopt.iova_rwsem);
+	iommufd_put_object(&ioas->obj);
+	return rc;
+}
+
+static int conv_iommu_prot(u32 map_flags)
+{
+	int iommu_prot;
+
+	/*
+	 * We provide no manual cache coherency ioctls to userspace and most
+	 * architectures make the CPU ops for cache flushing privileged.
+	 * Therefore we require the underlying IOMMU to support CPU coherent
+	 * operation.
+	 */
+	iommu_prot = IOMMU_CACHE;
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
+	struct iommufd_ioas *ioas;
+	unsigned int flags = 0;
+	unsigned long iova;
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
+	iova = cmd->iova;
+	rc = iopt_map_user_pages(&ioas->iopt, &iova,
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
+	struct iopt_pages *pages;
+	unsigned int flags = 0;
+	unsigned long iova;
+	unsigned long start_byte;
+	int rc;
+
+	if ((cmd->flags &
+	     ~(IOMMU_IOAS_MAP_FIXED_IOVA | IOMMU_IOAS_MAP_WRITEABLE |
+	       IOMMU_IOAS_MAP_READABLE)))
+		return -EOPNOTSUPP;
+	if (cmd->length >= ULONG_MAX)
+		return -EOVERFLOW;
+
+	src_ioas = iommufd_get_ioas(ucmd, cmd->src_ioas_id);
+	if (IS_ERR(src_ioas))
+		return PTR_ERR(src_ioas);
+	/* FIXME: copy is not limited to an exact match anymore */
+	pages = iopt_get_pages(&src_ioas->iopt, cmd->src_iova, &start_byte,
+			       cmd->length);
+	iommufd_put_object(&src_ioas->obj);
+	if (IS_ERR(pages))
+		return PTR_ERR(pages);
+
+	dst_ioas = iommufd_get_ioas(ucmd, cmd->dst_ioas_id);
+	if (IS_ERR(dst_ioas)) {
+		iopt_put_pages(pages);
+		return PTR_ERR(dst_ioas);
+	}
+
+	if (!(cmd->flags & IOMMU_IOAS_MAP_FIXED_IOVA))
+		flags = IOPT_ALLOC_IOVA;
+	iova = cmd->dst_iova;
+	rc = iopt_map_pages(&dst_ioas->iopt, pages, &iova, start_byte,
+			    cmd->length, conv_iommu_prot(cmd->flags), flags);
+	if (rc) {
+		iopt_put_pages(pages);
+		goto out_put_dst;
+	}
+
+	cmd->dst_iova = iova;
+	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
+out_put_dst:
+	iommufd_put_object(&dst_ioas->obj);
+	return rc;
+}
+
+int iommufd_ioas_unmap(struct iommufd_ucmd *ucmd)
+{
+	struct iommu_ioas_unmap *cmd = ucmd->cmd;
+	struct iommufd_ioas *ioas;
+	int rc;
+
+	ioas = iommufd_get_ioas(ucmd, cmd->ioas_id);
+	if (IS_ERR(ioas))
+		return PTR_ERR(ioas);
+
+	if (cmd->iova == 0 && cmd->length == U64_MAX) {
+		rc = iopt_unmap_all(&ioas->iopt);
+	} else {
+		if (cmd->iova >= ULONG_MAX || cmd->length >= ULONG_MAX) {
+			rc = -EOVERFLOW;
+			goto out_put;
+		}
+		rc = iopt_unmap_iova(&ioas->iopt, cmd->iova, cmd->length);
+	}
+
+out_put:
+	iommufd_put_object(&ioas->obj);
+	return rc;
+}
diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
index bcf08e61bc87e9..d24c9dac5a82a9 100644
--- a/drivers/iommu/iommufd/iommufd_private.h
+++ b/drivers/iommu/iommufd/iommufd_private.h
@@ -96,6 +96,7 @@ static inline int iommufd_ucmd_respond(struct iommufd_ucmd *ucmd,
 enum iommufd_object_type {
 	IOMMUFD_OBJ_NONE,
 	IOMMUFD_OBJ_ANY = IOMMUFD_OBJ_NONE,
+	IOMMUFD_OBJ_IOAS,
 	IOMMUFD_OBJ_MAX,
 };
 
@@ -147,4 +148,30 @@ struct iommufd_object *_iommufd_object_alloc(struct iommufd_ctx *ictx,
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
+int iommufd_ioas_map(struct iommufd_ucmd *ucmd);
+int iommufd_ioas_copy(struct iommufd_ucmd *ucmd);
+int iommufd_ioas_unmap(struct iommufd_ucmd *ucmd);
 #endif
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index ae8db2f663004f..e506f493b54cfe 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -184,6 +184,10 @@ static int iommufd_fops_release(struct inode *inode, struct file *filp)
 }
 
 union ucmd_buffer {
+	struct iommu_ioas_alloc alloc;
+	struct iommu_ioas_iova_ranges iova_ranges;
+	struct iommu_ioas_map map;
+	struct iommu_ioas_unmap unmap;
 	struct iommu_destroy destroy;
 };
 
@@ -205,6 +209,16 @@ struct iommufd_ioctl_op {
 	}
 static struct iommufd_ioctl_op iommufd_ioctl_ops[] = {
 	IOCTL_OP(IOMMU_DESTROY, iommufd_destroy, struct iommu_destroy, id),
+	IOCTL_OP(IOMMU_IOAS_ALLOC, iommufd_ioas_alloc_ioctl,
+		 struct iommu_ioas_alloc, out_ioas_id),
+	IOCTL_OP(IOMMU_IOAS_COPY, iommufd_ioas_copy, struct iommu_ioas_copy,
+		 src_iova),
+	IOCTL_OP(IOMMU_IOAS_IOVA_RANGES, iommufd_ioas_iova_ranges,
+		 struct iommu_ioas_iova_ranges, __reserved),
+	IOCTL_OP(IOMMU_IOAS_MAP, iommufd_ioas_map, struct iommu_ioas_map,
+		 __reserved),
+	IOCTL_OP(IOMMU_IOAS_UNMAP, iommufd_ioas_unmap, struct iommu_ioas_unmap,
+		 length),
 };
 
 static long iommufd_fops_ioctl(struct file *filp, unsigned int cmd,
@@ -270,6 +284,9 @@ struct iommufd_ctx *iommufd_fget(int fd)
 }
 
 static struct iommufd_object_ops iommufd_object_ops[] = {
+	[IOMMUFD_OBJ_IOAS] = {
+		.destroy = iommufd_ioas_destroy,
+	},
 };
 
 static struct miscdevice iommu_misc_dev = {
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 2f7f76ec6db4cb..ba7b17ec3002e3 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -37,6 +37,11 @@
 enum {
 	IOMMUFD_CMD_BASE = 0x80,
 	IOMMUFD_CMD_DESTROY = IOMMUFD_CMD_BASE,
+	IOMMUFD_CMD_IOAS_ALLOC,
+	IOMMUFD_CMD_IOAS_IOVA_RANGES,
+	IOMMUFD_CMD_IOAS_MAP,
+	IOMMUFD_CMD_IOAS_COPY,
+	IOMMUFD_CMD_IOAS_UNMAP,
 };
 
 /**
@@ -52,4 +57,131 @@ struct iommu_destroy {
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
+ * struct iommu_ioas_iova_ranges - ioctl(IOMMU_IOAS_IOVA_RANGES)
+ * @size: sizeof(struct iommu_ioas_iova_ranges)
+ * @ioas_id: IOAS ID to read ranges from
+ * @out_num_iovas: Output total number of ranges in the IOAS
+ * @__reserved: Must be 0
+ * @out_valid_iovas: Array of valid IOVA ranges. The array length is the smaller
+ *                   of out_num_iovas or the length implied by size.
+ * @out_valid_iovas.start: First IOVA in the allowed range
+ * @out_valid_iovas.last: Inclusive last IOVA in the allowed range
+ *
+ * Query an IOAS for ranges of allowed IOVAs. Operation outside these ranges is
+ * not allowed. out_num_iovas will be set to the total number of iovas
+ * and the out_valid_iovas[] will be filled in as space permits.
+ * size should include the allocated flex array.
+ */
+struct iommu_ioas_iova_ranges {
+	__u32 size;
+	__u32 ioas_id;
+	__u32 out_num_iovas;
+	__u32 __reserved;
+	struct iommu_valid_iovas {
+		__aligned_u64 start;
+		__aligned_u64 last;
+	} out_valid_iovas[];
+};
+#define IOMMU_IOAS_IOVA_RANGES _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_IOVA_RANGES)
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
+ * mapping will be established at iova, otherwise a suitable location will be
+ * automatically selected and returned in iova.
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
+ * @size: sizeof(struct iommu_ioas_copy)
+ * @ioas_id: IOAS ID to change the mapping of
+ * @iova: IOVA to start the unmapping at
+ * @length: Number of bytes to unmap
+ *
+ * Unmap an IOVA range. The iova/length must exactly match a range
+ * used with IOMMU_IOAS_PAGETABLE_MAP, or be the values 0 & U64_MAX.
+ * In the latter case all IOVAs will be unmaped.
+ */
+struct iommu_ioas_unmap {
+	__u32 size;
+	__u32 ioas_id;
+	__aligned_u64 iova;
+	__aligned_u64 length;
+};
+#define IOMMU_IOAS_UNMAP _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_UNMAP)
 #endif
-- 
2.35.1

