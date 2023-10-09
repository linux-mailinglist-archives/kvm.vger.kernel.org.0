Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA027BD983
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 13:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346240AbjJILYw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 07:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346246AbjJILYt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 07:24:49 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2080.outbound.protection.outlook.com [40.107.243.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC1AAB;
        Mon,  9 Oct 2023 04:24:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l4yeGg4qYqD8O/AKU+sGm7x1dyuipCFNJ49wARZLSPjtXX9OiQt0qqwvZc6Vpjcyoq9TdQUUVVUafZ8YgZxqDyG9uD1AAs3dw7F6P2NRFOa/OlAfufNeRdrzTLaYlsXEQEEpWuDDaMNrB/1IKaP5nDO69SMR74+hdbsvVqXfwasG/bJTep7tCigjrON2sbUk459eT6lKNPJA2f2YkYl5t8NZiIzmUS5YrngIqcCRfury7ILd8ZskX7Xhpjk1y7Zkp8ggkD1hknNOgL4O5PMkriailm/AWBLa7zf2aQSKaBHqKGCzKK/7w6gZ26iXWR+28ZVnR0q5ofARJP/shDWnxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ILKog4btT16IMu9HXAHH95fAm+8LcOyK/4mzDrViAvI=;
 b=OQhHJ9NMa6c/EoNeWnfmWH8rPp+/eDyCXqwxWvvREgiZvydui0H+CjuM0jBN1l5aF2mUtbrBb+4Sq+u5Xnk6iql1DQuoOJj1pw4DK7xP8eaEAJKV8y1+1zqIS/6DYxYXaFC6y3XFgvkKqO5rC1vDjAXv9UuxKaszCjpXOJH+RlgIDkXXLOeA57jL0KF/CUZaIqZ+RaJMdiULw0SzGv1BfxUZ+9w2/j8yIVN4v9m9gbYnaDKBLKmsOSJdDcWl2TvASCHOMnwUHanvvmiZG5F/erZpYFPZwJ3wYrPww7Eu5q6ReCqkKPCpiWUgu0p78BK+uGFBIegtVYjJHRIcR24MZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ILKog4btT16IMu9HXAHH95fAm+8LcOyK/4mzDrViAvI=;
 b=DhvWI/tQWbkP3fImzS6bOL36R4Sjx2D8iib+JYroxzKMhFGQ8tOnN4mGc3OCj5jEFkxNnYw6lZO0p+akAghgiXA/oPNK4Bc0+7OV3NsMpo9jFSwOz2EPD0T9gssFQqSUJZH5By0CKpfMygn1V4NwIFBLlQNmiRTo8yyfAJUuaCmTAJd4aF5tNuDaDR4+15w5df3SnFJbPuodcuGCIMF3GosrTTpwdhejva883gaJ343QEtJ6Ld6I3jLSIgJS4d0DW6sPmjyQwT/h1stR/4OkX/e97HaCmmQeAPyR11V8XU5/f3dg7QACBlR+5HKn87zXmCaHqrfbaPk0g9obYhqLyA==
Received: from BLAPR03CA0090.namprd03.prod.outlook.com (2603:10b6:208:329::35)
 by CY8PR12MB7682.namprd12.prod.outlook.com (2603:10b6:930:85::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.37; Mon, 9 Oct
 2023 11:24:45 +0000
Received: from MN1PEPF0000ECDB.namprd02.prod.outlook.com
 (2603:10b6:208:329:cafe::1) by BLAPR03CA0090.outlook.office365.com
 (2603:10b6:208:329::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.37 via Frontend
 Transport; Mon, 9 Oct 2023 11:24:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MN1PEPF0000ECDB.mail.protection.outlook.com (10.167.242.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.18 via Frontend Transport; Mon, 9 Oct 2023 11:24:45 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 9 Oct 2023
 04:24:29 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 9 Oct 2023
 04:24:28 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Mon, 9 Oct 2023 04:24:25 -0700
From:   Dragos Tatulea <dtatulea@nvidia.com>
To:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Eugenio Perez Martin <eperezma@redhat.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        <virtualization@lists.linux-foundation.org>
CC:     Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v3 03/16] vhost-vdpa: introduce descriptor group backend feature
Date:   Mon, 9 Oct 2023 14:23:48 +0300
Message-ID: <20231009112401.1060447-4-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231009112401.1060447-1-dtatulea@nvidia.com>
References: <20231009112401.1060447-1-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECDB:EE_|CY8PR12MB7682:EE_
X-MS-Office365-Filtering-Correlation-Id: d719a82a-0216-4627-de84-08dbc8ba571e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: merPLwWS2lIyOWsQFsjoG0hzTrqwl6RsyKGioZa9EJLgrRYcxG2wF3NcmbB1AMIKV8NU6PJYlN1lVsO1SgU0+vMNrJfuYodnZcIUFCEyw7/Ne6piprvC/6BSAnpWGKAXzt6z5igKYOTfeIie2/L+V57B6WWz5c3Tvia/4s//9Gc8DHJYgaFOdEYKRfLmK8ZCzWnYwYx0A9PGvHc1ugCGp3y/LT2vJlpKhV6B2QNrBNUHNUblMjktCStZKCphqlY96QseKWZkj3B7Sw/KL1NcfOygZMGhxNvGb8BuMuINQujS4AsGLG5yIKrhpIXZSivNlvvBhlOJgEK/GXivyFpHcyYIAT2MZgDNGuTxqejuep5+uWndERCtLRyLjhhHk+pAtglCScfNTkGL2gQfVnEPQuaDQVsclriZ38aKqef2DwxbHhL05Fr0uQ0j4SsEldaK+gkVLLs/1oZWldtbGPKTdzna6ok+aRtwNY4/hxjxQIZF4KHPsJsvTy4100Bi7NnC8eLw6f87MBZRG04yia6aq/QK8OMHQUqFVUdH7zxRVqSEEm/2wNTzyDaBAYK1ctPOv4Outi61wbZsibEGSeG4pLRzx7EBImGTH4r+x7CRGv028Xa6wAwZTOLyivWP4/aluUtZBlUlHyLE5EBsBhrEsHP4sBX3bp4AS1Y8qH9DHOp6h9BUr1Mq4oe7NsnlRmPet0b/BYvxKJd0vVGXX8MI/NJUf4w8P2vK6RfYP9Yi2IQzsUC3iqEbB355wgr9czC9
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(39860400002)(346002)(376002)(396003)(230922051799003)(451199024)(82310400011)(64100799003)(1800799009)(186009)(36840700001)(46966006)(40470700004)(40480700001)(40460700003)(1076003)(83380400001)(2616005)(336012)(426003)(26005)(66574015)(47076005)(316002)(36860700001)(110136005)(54906003)(70206006)(70586007)(8936002)(8676002)(4326008)(5660300002)(41300700001)(6666004)(2906002)(478600001)(82740400003)(36756003)(356005)(86362001)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2023 11:24:45.2139
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d719a82a-0216-4627-de84-08dbc8ba571e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: MN1PEPF0000ECDB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7682
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

