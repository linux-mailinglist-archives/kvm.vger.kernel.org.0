Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A262739358
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 01:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbjFUX54 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 19:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbjFUX5L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 19:57:11 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F1C268C;
        Wed, 21 Jun 2023 16:56:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CbBS6Lixh5nIfZDdspesuU9ejdwEfggKKGnEMyfdJh7FHzUnnNT0MdsCnDtQCj7Xb3+/MDOPVLxi7cBXG8FmYqTp3mPiXDdeFmpYeuGNhceTj255EWbo8rIal3ylhFI6Uu/v9Pa6t0wLf90CW0TTGCAbaFPgDYnbZz1iy3GBl+itqTaZz1jyLGwGsAsFmFXEJmbGmHdH2lmVTiBnCbgT0+ID7a3ppsdWm+pRcH9Clv1llDGEyMd/SQIcC5lipiiBpzhQh3xyWIm8G4v3KpfswQTJutWM99XbF63rfCALIWCCHQc7B1mT0nBYXR85AytFqa1mSCT22CsaIiF2mbge4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wdQMrgOTXfgV72RZpei832Z4XyMWSKHyjQtp0oqj+xw=;
 b=kvKOLLQWIAFMIA1HtQ13vnJZycphsT9z4YA8CMqj8BTImFFMNY75r7JIE7l9YNMZ0odQlMp/sNozuNDBmL1GiSWpaQqTxHHAElq1+GoByCL1huTLCtQl23YevT+vTaGirVmqzu9XR5zfmzANPorrc867t9bzl0WmflJQwH0xqtQ0E77NLUADkSPsR3xsERXxKKyVjVl4cFo250+DZFOz7M0xouHu21Ko8VHGqxfpNqRdTq+VH+sKh+ILnOfw/lhWcFTF1zinxmC5mUDYpPG4fZTZkZUDnXQib323LKSI0jVKMUfLOGnhvs6w9QrsJxhIWMmxv9iKS0gZcF0KFRW4zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wdQMrgOTXfgV72RZpei832Z4XyMWSKHyjQtp0oqj+xw=;
 b=xMSY3TlT8x+PCtElLwfpEl1IA2FANM2Iq39x614KaemLdE1W6BtFyfedJfhi9ty16NJdO503bq9FJLWmH7y5ws5wXrO5Sej9QYNvIKnhA832eQwfZZF1IfvUgPObyfm4rwZ5CXxfqrpN+Bs67GteesmOkpcN+kQWvTRXeg4oX7I=
Received: from CYZPR10CA0008.namprd10.prod.outlook.com (2603:10b6:930:8a::18)
 by PH7PR12MB6812.namprd12.prod.outlook.com (2603:10b6:510:1b6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Wed, 21 Jun
 2023 23:56:07 +0000
Received: from CY4PEPF0000E9CD.namprd03.prod.outlook.com
 (2603:10b6:930:8a:cafe::e4) by CYZPR10CA0008.outlook.office365.com
 (2603:10b6:930:8a::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23 via Frontend
 Transport; Wed, 21 Jun 2023 23:56:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9CD.mail.protection.outlook.com (10.167.241.140) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6521.24 via Frontend Transport; Wed, 21 Jun 2023 23:56:07 +0000
Received: from ruby-95f9host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 21 Jun
 2023 18:56:02 -0500
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     <linux-kernel@vger.kernel.org>, <iommu@lists.linux.dev>,
        <kvm@vger.kernel.org>
CC:     <joro@8bytes.org>, <robin.murphy@arm.com>, <yi.l.liu@intel.com>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <nicolinc@nvidia.com>, <baolu.lu@linux.intel.com>,
        <eric.auger@redhat.com>, <pandoh@google.com>,
        <kumaranand@google.com>, <jon.grimm@amd.com>,
        <santosh.shukla@amd.com>, <vasant.hegde@amd.com>,
        <jay.chen@amd.com>, <joseph.chung@amd.com>,
        "Suravee Suthikulpanit" <suravee.suthikulpanit@amd.com>
Subject: [RFC PATCH 21/21] iommufd: Introduce AMD HW-vIOMMU IOCTL
Date:   Wed, 21 Jun 2023 18:55:08 -0500
Message-ID: <20230621235508.113949-22-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230621235508.113949-1-suravee.suthikulpanit@amd.com>
References: <20230621235508.113949-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9CD:EE_|PH7PR12MB6812:EE_
X-MS-Office365-Filtering-Correlation-Id: 7213e5fa-480b-4a71-3491-08db72b3149b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nemnw003TM6NrfSHZUQqKMi1p4t+51nk25Hw9wpP1bTVSgFs+tw60mNJ7t1yC/DHtGqBG3u4u2x2RlEyKq6LiICdXIwDeFo4mnS917VqMoUOtWQgnWZtq6deHHVVHGwToFd+csr04qhzEJniX0p1X/2RfBNqd78agX9g239KXZdPm0QBZNGcoDfFkG4xt0KEiZqx33KxONggBp3FFEYdNZmCLQP/dpcKwU9EdbtOlh3jntQBA/B98lyQGHIsPdJxsYKVIkSDNZFFxkYLo47R9Q0soOxclr/NZ60aN0kfkPGVgay/9CuUyabShE2iOFgtbaz7o1HWxer9tywaKXu822X/5sJvQKnuTDO4REIUbOztYVrpq9MTLO/jK3f5wiuwpSv7TzcIcyINBfWoUezx2gYcK9BAFiiZxtEabxH0D+jpqxMACHUDPzQB67U3DtK7S2v4ENyPRO7Md4MHTV+QQ7IW+QzJOutSDlphoUlFB0proI2zki8kh4oWYltPINMqucc68xAzlIf/GvX84oGdt3w+YWKTGLuUV8l2e0zRkkC15Fq2YHPIBERhRKJQVjOY7v1A50xfjzITyGaqQWxSGOxTBNzHrDFxtb7E7Q/PinXl3U2hGPfwwQsWagBs363P5M5QNha+SvVIk1XKhgFcGGE84OUIecTu9dM9gwzHzc8+noUi/bFu793nsIQmces72LO7XT7OImYruYE+S/DrXQ4c8btnrTyk/4o0bOBeDcq6Bp+/1lQelrQDYZHhO7tX8pm3Quq0r1DeFF/1ZV5SAQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(39860400002)(376002)(136003)(451199021)(36840700001)(46966006)(40470700004)(7696005)(478600001)(36860700001)(82310400005)(36756003)(47076005)(16526019)(83380400001)(426003)(336012)(2616005)(86362001)(186003)(81166007)(40480700001)(356005)(82740400003)(1076003)(40460700003)(26005)(8936002)(8676002)(41300700001)(7416002)(44832011)(5660300002)(2906002)(110136005)(54906003)(316002)(70586007)(70206006)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2023 23:56:07.2547
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7213e5fa-480b-4a71-3491-08db72b3149b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9CD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6812
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for AMD HW-vIOMMU in the iommufd /dev/iommu devfs.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 drivers/iommu/iommufd/Makefile     |   3 +-
 drivers/iommu/iommufd/amd_viommu.c | 158 +++++++++++++++++++++++++++++
 drivers/iommu/iommufd/main.c       |  17 ++--
 include/linux/amd-viommu.h         |  26 +++++
 include/linux/iommufd.h            |   8 ++
 5 files changed, 203 insertions(+), 9 deletions(-)
 create mode 100644 drivers/iommu/iommufd/amd_viommu.c
 create mode 100644 include/linux/amd-viommu.h

diff --git a/drivers/iommu/iommufd/Makefile b/drivers/iommu/iommufd/Makefile
index 8aeba81800c5..84d771c9cfba 100644
--- a/drivers/iommu/iommufd/Makefile
+++ b/drivers/iommu/iommufd/Makefile
@@ -6,7 +6,8 @@ iommufd-y := \
 	ioas.o \
 	main.o \
 	pages.o \
-	vfio_compat.o
+	vfio_compat.o \
+	amd_viommu.o
 
 iommufd-$(CONFIG_IOMMUFD_TEST) += selftest.o
 
diff --git a/drivers/iommu/iommufd/amd_viommu.c b/drivers/iommu/iommufd/amd_viommu.c
new file mode 100644
index 000000000000..1836e19cb37d
--- /dev/null
+++ b/drivers/iommu/iommufd/amd_viommu.c
@@ -0,0 +1,158 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2023 Advanced Micro Devices, Inc.
+ * Author: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
+ */
+
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/amd-viommu.h>
+#include <uapi/linux/amd_viommu.h>
+#include <linux/iommufd.h>
+
+#include "iommufd_private.h"
+
+union amd_viommu_ucmd_buffer {
+	struct amd_viommu_iommu_info iommu;
+	struct amd_viommu_dev_info dev;
+	struct amd_viommu_dom_info dom;
+	struct amd_viommu_mmio_data mmio;
+	struct amd_viommu_cmdbuf_data cmdbuf;
+};
+
+#define IOCTL_OP(_ioctl, _fn, _struct, _last)                                  \
+	[_IOC_NR(_ioctl) - IOMMUFD_VIOMMU_CMD_BASE] = {                        \
+		.size = sizeof(_struct) +                                      \
+			BUILD_BUG_ON_ZERO(sizeof(union amd_viommu_ucmd_buffer) <          \
+					  sizeof(_struct)),                    \
+		.min_size = offsetofend(_struct, _last),                       \
+		.ioctl_num = _ioctl,                                           \
+		.execute = _fn,                                                \
+	}
+
+int viommu_iommu_init(struct iommufd_ucmd *ucmd)
+{
+	int ret;
+	struct amd_viommu_iommu_info *data = ucmd->cmd;
+
+	ret = amd_viommu_iommu_init(data);
+	if (ret)
+		return ret;
+
+	if (copy_to_user(ucmd->ubuffer, data, sizeof(*data)))
+		ret = -EFAULT;
+	return ret;
+}
+
+int viommu_iommu_destroy(struct iommufd_ucmd *ucmd)
+{
+	struct amd_viommu_iommu_info *data = ucmd->cmd;
+
+	return amd_viommu_iommu_destroy(data);
+}
+
+int viommu_domain_attach(struct iommufd_ucmd *ucmd)
+{
+	struct amd_viommu_dom_info *data = ucmd->cmd;
+
+	return amd_viommu_domain_update(data, true);
+}
+
+int viommu_domain_detach(struct iommufd_ucmd *ucmd)
+{
+	struct amd_viommu_dom_info *data = ucmd->cmd;
+
+	return amd_viommu_domain_update(data, false);
+}
+
+int viommu_device_attach(struct iommufd_ucmd *ucmd)
+{
+	struct amd_viommu_dev_info *data = ucmd->cmd;
+
+	return amd_viommu_device_update(data, true);
+}
+
+int viommu_device_detach(struct iommufd_ucmd *ucmd)
+{
+	struct amd_viommu_dev_info *data = ucmd->cmd;
+
+	return amd_viommu_device_update(data, false);
+}
+
+int viommu_mmio_access(struct iommufd_ucmd *ucmd)
+{
+	int ret;
+	struct amd_viommu_mmio_data *data = ucmd->cmd;
+
+	if (data->is_write) {
+		ret = amd_viommu_guest_mmio_write(data);
+	} else {
+		ret = amd_viommu_guest_mmio_read(data);
+		if (ret)
+			return ret;
+
+		if (copy_to_user(ucmd->ubuffer, data, sizeof(*data)))
+			ret = -EFAULT;
+	}
+	return ret;
+}
+
+int viommu_cmdbuf_update(struct iommufd_ucmd *ucmd)
+{
+	struct amd_viommu_cmdbuf_data *data = ucmd->cmd;
+
+	return amd_viommu_cmdbuf_update(data);
+}
+
+struct iommufd_ioctl_op viommu_ioctl_ops[] = {
+	IOCTL_OP(VIOMMU_IOMMU_INIT, viommu_iommu_init,
+		 struct amd_viommu_iommu_info, gid),
+	IOCTL_OP(VIOMMU_IOMMU_DESTROY, viommu_iommu_destroy,
+		 struct amd_viommu_iommu_info, gid),
+	IOCTL_OP(VIOMMU_DEVICE_ATTACH, viommu_device_attach,
+		 struct amd_viommu_dev_info, queue_id),
+	IOCTL_OP(VIOMMU_DEVICE_DETACH, viommu_device_detach,
+		 struct amd_viommu_dev_info, queue_id),
+	IOCTL_OP(VIOMMU_DOMAIN_ATTACH, viommu_domain_attach,
+		 struct amd_viommu_dom_info, gdom_id),
+	IOCTL_OP(VIOMMU_DOMAIN_DETACH, viommu_domain_detach,
+		 struct amd_viommu_dom_info, gdom_id),
+	IOCTL_OP(VIOMMU_MMIO_ACCESS, viommu_mmio_access,
+		 struct amd_viommu_mmio_data, is_write),
+	IOCTL_OP(VIOMMU_CMDBUF_UPDATE, viommu_cmdbuf_update,
+		 struct amd_viommu_cmdbuf_data, hva),
+};
+
+long iommufd_amd_viommu_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	struct iommufd_ctx *ictx = filp->private_data;
+	struct iommufd_ucmd ucmd = {};
+	struct iommufd_ioctl_op *op;
+	union amd_viommu_ucmd_buffer buf;
+	unsigned int nr;
+	int ret;
+
+	nr = _IOC_NR(cmd);
+	if (nr < IOMMUFD_VIOMMU_CMD_BASE ||
+	    (nr - IOMMUFD_VIOMMU_CMD_BASE) >= ARRAY_SIZE(viommu_ioctl_ops))
+		return -ENOIOCTLCMD;
+
+	ucmd.ictx = ictx;
+	ucmd.ubuffer = (void __user *)arg;
+	ret = get_user(ucmd.user_size, (u32 __user *)ucmd.ubuffer);
+	if (ret)
+		return ret;
+
+	op = &viommu_ioctl_ops[nr - IOMMUFD_VIOMMU_CMD_BASE];
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
+	return op->execute(&ucmd);
+}
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 83f8b8f19bcb..d5c2738a8355 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -17,6 +17,8 @@
 #include <linux/bug.h>
 #include <uapi/linux/iommufd.h>
 #include <linux/iommufd.h>
+#include <uapi/linux/amd_viommu.h>
+#include <linux/amd-viommu.h>
 #include "../iommu-priv.h"
 
 #include "io_pagetable.h"
@@ -442,13 +444,6 @@ union ucmd_buffer {
 	struct iommu_hwpt_arm_smmuv3_invalidate smmuv3;
 };
 
-struct iommufd_ioctl_op {
-	unsigned int size;
-	unsigned int min_size;
-	unsigned int ioctl_num;
-	int (*execute)(struct iommufd_ucmd *ucmd);
-};
-
 #define IOCTL_OP(_ioctl, _fn, _struct, _last)                                  \
 	[_IOC_NR(_ioctl) - IOMMUFD_CMD_BASE] = {                               \
 		.size = sizeof(_struct) +                                      \
@@ -503,8 +498,14 @@ static long iommufd_fops_ioctl(struct file *filp, unsigned int cmd,
 
 	nr = _IOC_NR(cmd);
 	if (nr < IOMMUFD_CMD_BASE ||
-	    (nr - IOMMUFD_CMD_BASE) >= ARRAY_SIZE(iommufd_ioctl_ops))
+	    (nr - IOMMUFD_CMD_BASE) >= ARRAY_SIZE(iommufd_ioctl_ops)) {
+		/* AMD VIOMMU ioctl */
+		if (!iommufd_amd_viommu_ioctl(filp, cmd, arg))
+			return 0;
+
+		/* VFIO ioctl */
 		return iommufd_vfio_ioctl(ictx, cmd, arg);
+	}
 
 	ucmd.ictx = ictx;
 	ucmd.ubuffer = (void __user *)arg;
diff --git a/include/linux/amd-viommu.h b/include/linux/amd-viommu.h
new file mode 100644
index 000000000000..645e25c493c2
--- /dev/null
+++ b/include/linux/amd-viommu.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2022 Advanced Micro Devices, Inc.
+ */
+
+#ifndef _LINUX_AMD_VIOMMU_H
+#define _LINUX_AMD_VIOMMU_H
+
+#include <uapi/linux/amd_viommu.h>
+
+extern long iommufd_amd_viommu_ioctl(struct file *filp,
+				     unsigned int cmd,
+				     unsigned long arg);
+
+extern long iommufd_viommu_ioctl(struct file *filp, unsigned int cmd,
+			  unsigned long arg);
+
+extern int amd_viommu_iommu_init(struct amd_viommu_iommu_info *data);
+extern int amd_viommu_iommu_destroy(struct amd_viommu_iommu_info *data);
+extern int amd_viommu_domain_update(struct amd_viommu_dom_info *data, bool is_set);
+extern int amd_viommu_device_update(struct amd_viommu_dev_info *data, bool is_set);
+extern int amd_viommu_guest_mmio_write(struct amd_viommu_mmio_data *data);
+extern int amd_viommu_guest_mmio_read(struct amd_viommu_mmio_data *data);
+extern int amd_viommu_cmdbuf_update(struct amd_viommu_cmdbuf_data *data);
+
+#endif /* _LINUX_AMD_VIOMMU_H */
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index 9269ce668d9b..91912e044038 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -17,6 +17,14 @@ struct iommufd_ctx;
 struct iommufd_access;
 struct file;
 struct iommu_group;
+struct iommufd_ucmd;
+
+struct iommufd_ioctl_op {
+	unsigned int size;
+	unsigned int min_size;
+	unsigned int ioctl_num;
+	int (*execute)(struct iommufd_ucmd *ucmd);
+};
 
 struct iommufd_device *iommufd_device_bind(struct iommufd_ctx *ictx,
 					   struct device *dev, u32 *id);
-- 
2.34.1

