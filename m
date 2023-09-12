Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3853079D197
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 15:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235476AbjILNCk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 09:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235436AbjILNC0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 09:02:26 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2453D10E0;
        Tue, 12 Sep 2023 06:02:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZKzit3GV868d3L5xHUpyvRKA3XHAHHVEDj6GZgw1vlprvqTO5qEkiWVDDeDLwwazPP7DA6OHOUPLzr0FlK1b+N7sLfWs3nivzp6OOQNO+9PCV6VfqK9dsLAZe9bKlTN7e3BtCShYkY+n+ZmDgR4YC9FctgnCLmUCif7J8/WMI5hmQLpd5NwZYxbYHJsvAGZcPmfSiu7tIiXFV/iEZIDMAW/zccqAeOA8ZiK5joIWWODJmE0m0fS2zHS8wUqTr4KSAJiKjr2cX28Gki4jJF6Dx2S/k4tRiS0zt/pitwv2MzGxrOw1V08u4fxFzpBoiEWi+smACyzihwskZIvfsuLD0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ILKog4btT16IMu9HXAHH95fAm+8LcOyK/4mzDrViAvI=;
 b=FleG3wx/Hqgb86ACdcsr/cljM2/X2HGjcVrO1UupUio6gLiD4lZg0go7/UA3pmHO7VrKqeSaMU2yFkMBrizad72BY6pSdC9wngBuWo7+w4v1OKophAsPkhObp1NoSwaCuDn2x/91usBmMDnBvBic23P9IWqAnTL0/AzLyTvjxlAWuSfsV2JKB7zYESMvGekdPz5khV8bgq/I5Si7hxe8+8GSBrNyp5RKGzJJdjeBYJW/Kq7WLX/uTyGNqQRAgFtKtLox8w7fUVoGUIkUVcmXOh9B1HgfCGH81iI0Vy1N7jGjiCEAirsQI0E+kUKH72d34lh/R32ZHDfG1fri4YFL2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ILKog4btT16IMu9HXAHH95fAm+8LcOyK/4mzDrViAvI=;
 b=MhbQ1sNYZxh/ME+pdyMeYEU0h0FZrrgphuNEKNH5Co9ESFoYRvO65HheYucgxgqvmnDbnJya0onJj5qnhujQtp1eOuwdxAKgsiwq7V1ypyrj30BPSW9uorqgj6ZONgzuZfZiti6B8vHFTbOj6fHbu1i6fS/uor9Nvg0E/O0ucqTEyH7xxDL2VnSfvrWz5A+1NlTcvUaqUt1HB0pj7xZpBHMMgvjEz1108yGyW9XdlCDJZeUCjh/XsWcyr0q0j6cJkCwUva1rk+Yce2+zeARt8SQVYJV5IiSs02iFJ0mAoFcsmmtFmWSrp9UN0/HQtYNoqC4XGszEz3NK3msD05EIAQ==
Received: from SA1P222CA0156.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c3::19)
 by IA1PR12MB8190.namprd12.prod.outlook.com (2603:10b6:208:3f2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.31; Tue, 12 Sep
 2023 13:02:14 +0000
Received: from SA2PEPF000015C8.namprd03.prod.outlook.com
 (2603:10b6:806:3c3:cafe::19) by SA1P222CA0156.outlook.office365.com
 (2603:10b6:806:3c3::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.19 via Frontend
 Transport; Tue, 12 Sep 2023 13:02:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF000015C8.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.16 via Frontend Transport; Tue, 12 Sep 2023 13:02:14 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 12 Sep 2023
 06:01:53 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 12 Sep
 2023 06:01:53 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.37 via
 Frontend Transport; Tue, 12 Sep 2023 06:01:50 -0700
From:   Dragos Tatulea <dtatulea@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
CC:     Dragos Tatulea <dtatulea@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>, <kvm@vger.kernel.org>
Subject: [PATCH 02/16] vhost-vdpa: introduce descriptor group backend feature
Date:   Tue, 12 Sep 2023 16:01:12 +0300
Message-ID: <20230912130132.561193-3-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230912130132.561193-1-dtatulea@nvidia.com>
References: <20230912130132.561193-1-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C8:EE_|IA1PR12MB8190:EE_
X-MS-Office365-Filtering-Correlation-Id: a0339d38-a04f-46dc-5fa9-08dbb3907c63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: imzE884gY0CmPpGIpp/Shmq1GnEFlr2VfNTl2BRbhlWwJHyVv76oKNPVMJFQbJGjaehIORrmkdxQHOSfLsItp5CYbcT6RO/K5mH7QmavyQyHgOF905UZn6LOzqLMw3hUsk14b+MDxbkWk7udPmWM/u4+l0uZ4/caRRAg9GnEXje1IsrGfIvJoMZXu7zZwmhN9rp2evFeynrHThoA8iy0To1TkndERFqJYsVX9hKGPMcoVYf38D0SLpY2gDeasBvegqpHbHlRBiq8LSYg22szdunbEIBCJ8SSeVq9WpGMxXl8JNdFviW+cA9CC72grFSr5uWFKld5FZAa83pB5tQo6dEjrsaqMiXaw4A67bhTpLL8FShHpy5l/8OqrPo9rWZBUkca/0IyiPJzIwu6k+vUveP4q0ZI4/FGbyQnyGH+O0usAb6hUG9GX+UmIKoMZS3OHT4zHSuZlrRoegEtJQxVusZhc2zuJjHhgTcm6jN+Hkfpwc2Daqzoqk6UCSUoNpRlID1SuDwxvkgnPrWpSlhWx8Ve6QfZsePHwqemcHu77rGscgDnB+4nKH/ZGFjpZTwDB4BrFJ5cSecANpkxDkLWU9ZxE8hfV15q022RibXyEEaDyRms+EQR+IUEK5wuelU/1fYYqeDE6Ye1su/f7wTO0NGPy6uOy1zQO2519gSOyOTJs9EOxdXrJOOpr5+QkBzywt74hN9hyWUDquG2XYeDH/3EjrhvyVZ2HjijGWE50VO0w/USKhBP636kDp2IqqPu
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(396003)(39860400002)(346002)(186009)(451199024)(82310400011)(1800799009)(40470700004)(46966006)(36840700001)(40460700003)(426003)(8676002)(2906002)(36756003)(86362001)(82740400003)(356005)(7636003)(5660300002)(40480700001)(4326008)(26005)(36860700001)(1076003)(8936002)(83380400001)(66574015)(47076005)(316002)(41300700001)(6666004)(336012)(2616005)(70586007)(478600001)(70206006)(110136005)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2023 13:02:14.5200
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a0339d38-a04f-46dc-5fa9-08dbb3907c63
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: SA2PEPF000015C8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8190
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Si-Wei Liu <si-wei.liu@oracle.com>

Userspace knows if the device has dedicated descriptor group or not
by checking this feature bit.

It's only exposed if the vdpa driver backend implements the
.get_vq_desc_group() operation callback. Userspace trying to negotiate
this feature when it or the dependent _F_IOTLB_ASID feature hasn't
been exposed will result in an error.

Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vdpa.c             | 17 +++++++++++++++++
 include/uapi/linux/vhost_types.h |  5 +++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 78379ffd2336..2f21798a37ee 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -389,6 +389,14 @@ static bool vhost_vdpa_can_resume(const struct vhost_vdpa *v)
 	return ops->resume;
 }
 
+static bool vhost_vdpa_has_desc_group(const struct vhost_vdpa *v)
+{
+	struct vdpa_device *vdpa = v->vdpa;
+	const struct vdpa_config_ops *ops = vdpa->config;
+
+	return ops->get_vq_desc_group;
+}
+
 static long vhost_vdpa_get_features(struct vhost_vdpa *v, u64 __user *featurep)
 {
 	struct vdpa_device *vdpa = v->vdpa;
@@ -690,6 +698,7 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 		if (copy_from_user(&features, featurep, sizeof(features)))
 			return -EFAULT;
 		if (features & ~(VHOST_VDPA_BACKEND_FEATURES |
+				 BIT_ULL(VHOST_BACKEND_F_DESC_ASID) |
 				 BIT_ULL(VHOST_BACKEND_F_SUSPEND) |
 				 BIT_ULL(VHOST_BACKEND_F_RESUME) |
 				 BIT_ULL(VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK)))
@@ -700,6 +709,12 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 		if ((features & BIT_ULL(VHOST_BACKEND_F_RESUME)) &&
 		     !vhost_vdpa_can_resume(v))
 			return -EOPNOTSUPP;
+		if ((features & BIT_ULL(VHOST_BACKEND_F_DESC_ASID)) &&
+		    !(features & BIT_ULL(VHOST_BACKEND_F_IOTLB_ASID)))
+			return -EINVAL;
+		if ((features & BIT_ULL(VHOST_BACKEND_F_DESC_ASID)) &&
+		     !vhost_vdpa_has_desc_group(v))
+			return -EOPNOTSUPP;
 		vhost_set_backend_features(&v->vdev, features);
 		return 0;
 	}
@@ -753,6 +768,8 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 			features |= BIT_ULL(VHOST_BACKEND_F_SUSPEND);
 		if (vhost_vdpa_can_resume(v))
 			features |= BIT_ULL(VHOST_BACKEND_F_RESUME);
+		if (vhost_vdpa_has_desc_group(v))
+			features |= BIT_ULL(VHOST_BACKEND_F_DESC_ASID);
 		features |= vhost_vdpa_get_backend_features(v);
 		if (copy_to_user(featurep, &features, sizeof(features)))
 			r = -EFAULT;
diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_types.h
index 2d827d22cd99..18ad6ae7ab5c 100644
--- a/include/uapi/linux/vhost_types.h
+++ b/include/uapi/linux/vhost_types.h
@@ -185,5 +185,10 @@ struct vhost_vdpa_iova_range {
  * DRIVER_OK
  */
 #define VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK  0x6
+/* Device may expose the virtqueue's descriptor area, driver area and
+ * device area to a different group for ASID binding than where its
+ * buffers may reside. Requires VHOST_BACKEND_F_IOTLB_ASID.
+ */
+#define VHOST_BACKEND_F_DESC_ASID    0x7
 
 #endif
-- 
2.41.0

