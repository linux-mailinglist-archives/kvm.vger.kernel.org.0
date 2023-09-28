Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1503C7B22D7
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 18:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231827AbjI1Qtx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 12:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbjI1Qtu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 12:49:50 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219881B9;
        Thu, 28 Sep 2023 09:49:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fSbhbXzUlV0ef70enOM6b5s+aIdlAyUei0cCdbpWfWNTsl+zuujZTXh51T+p9elsJpTu9a/tqPJzgHtSzbuGSmR9PJmKbt79FVf8FZ29WqDiWdiChXT8nWVFHhEryUAVvcD1WEQoUAc+FygmutXevcTrXziK3qTgJiIJr30NhxzMV9FsYBM2T8Kh7A3i860M9TlpNxaKIp5ACmEoN3qy81DKIZOQMPIReJIN1SlPpAJ3a9j00TFPzo8zP10rq0D32+JHRjsWmTj4Xcktve/BH1DkkRMiJ2hUn/lFl9WEIRZOi7sqfH9suMDlcoxbCFtjeFur2WQ4cOuVtEOd3x7BIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ILKog4btT16IMu9HXAHH95fAm+8LcOyK/4mzDrViAvI=;
 b=SrxpFqgpFNbAoyQoFI9VNKxnxAFWRoWIkowCN70n4wiXuxYAUULcep0JJ+nXfFdFyVqMe1KWzQRCMNoWew7Ga04BZLQOUbj63G1TtYrNMMwcDbWooLdWhOGF8zR4RX+qL5T1LvLc8sljieR18bTn1x+pZBN2zv0BQbXno8M4AfxiwVnlJMvipasowkFEENNGx36dSKwZXfpTI+b9uq6dihGibFEWzrRIrAYRwJ6PpQtQFPcKGcOap4Q6da6IcoVhtmC/Y+edAlFkMoikPKcZ+Sd0aoTAoyvNA5HUBtGZmb+aUhO5z/AapGFwKdUNJ8dVNiXjvhSOZzacIfiO91lyjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ILKog4btT16IMu9HXAHH95fAm+8LcOyK/4mzDrViAvI=;
 b=R/ssvQl7U7O+rKzpolGLdt7B++/mrp/DYGSWVGZqknhub6e3UFAbS0oVieJJ9dgWsSaxJPY9NO+MHjw4BNiQwTpsUPjx0k3w/0qux6b2IlLWju7/OXV0a58jYd5aHN++JYdZ/XpQ+y0BCDZ1bK0X2nrnZyKDhHOvBDjcYKiz0NTMH/Dg5xFucHOQWGtJpwPjOl2/RkUWEX9XA+qfLPowkC26tVjbiQKekzXql9IPXbmdkCmdFeQ+JooaK0rMAxXt78FyVZW/n1VwmMtlRznQiiZLugQ1z7zygUzVztBqUXQKFhlQhPW63InOC1SciBOHOoyDG/FLbOrzdXjxL4OEIQ==
Received: from MW3PR06CA0007.namprd06.prod.outlook.com (2603:10b6:303:2a::12)
 by SJ0PR12MB6928.namprd12.prod.outlook.com (2603:10b6:a03:47a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.25; Thu, 28 Sep
 2023 16:49:41 +0000
Received: from CO1PEPF000044F8.namprd21.prod.outlook.com
 (2603:10b6:303:2a:cafe::ba) by MW3PR06CA0007.outlook.office365.com
 (2603:10b6:303:2a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.22 via Frontend
 Transport; Thu, 28 Sep 2023 16:49:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1PEPF000044F8.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6863.9 via Frontend Transport; Thu, 28 Sep 2023 16:49:40 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 28 Sep
 2023 09:49:34 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Thu, 28 Sep 2023 09:49:33 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.986.41
 via Frontend Transport; Thu, 28 Sep 2023 09:49:31 -0700
From:   Dragos Tatulea <dtatulea@nvidia.com>
To:     <eperezma@redhat.com>, <gal@nvidia.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
CC:     <virtualization@lists.linux-foundation.org>,
        Si-Wei Liu <si-wei.liu@oracle.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH vhost 03/16] vhost-vdpa: introduce descriptor group backend feature
Date:   Thu, 28 Sep 2023 19:45:14 +0300
Message-ID: <20230928164550.980832-5-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230928164550.980832-2-dtatulea@nvidia.com>
References: <20230928164550.980832-2-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F8:EE_|SJ0PR12MB6928:EE_
X-MS-Office365-Filtering-Correlation-Id: a8cf670a-480e-4e43-b516-08dbc042e8c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S99Teqc4zP9Pv5ViUGNESMcnYVwrrMgtuNN0QU/rransQ+H2Zi/bImHZqwxnMVytCObHpEL4aqVs8Y/5cjWHfmDaemMEECldyghzp3RKIkQA4K7Rt8bC+cpe3grtVULanXFDFNFXoU2xrn0+DS+x9GizH0niV9nbsaSEEFyUpIgVRd8hrshXgWROpdGj2ULEheDe0pwtwH8MRXO2+kGUoHWvzEuskMrXiIuHIsTQldhPQlNfsreifFa2RQSQ+MuccWOUEpWWlLYJTfilIuDdg+aSgrouCVuIcVzkhmT6sC5qnXzfLjHxrYd/xR5ibz2S6DDTFLQUasBkZJizDq7/jcQlCpOFzD0oNxPBMIPyMLtoFhq6t/elqt9Uk1eqZorh6SgbD3wzrIH0TTrfXjZ7K95N2hq14pOTAqSPQtffg7xBV0Ezkpjuxay9Xoni5vKeNnEVI9CrNR1TYeWw9mRDB4fKdbCjWy4rNRNzKYpGzgYNHsvNPE3hPSEseSorK2emgfcaX6QHR9wCR+aW8zYBtlo67N++GR0oWvJZK3BUh3bp/qLFjvnNPX3IJ/UUOxbc1j9fqzJrGyPSSLd/XiWvhluT+NuzjV2FLgEqzmfsFxT/RjuB+z2BIalxkl660gEyYdaQWN0KnzJzM2rhIiHtc8G4uH2ei8f30Wl4gu3omZmzkhiFaAjSoNdb17yc7vBaa1vg8zZTN3XoJePv4OX/9Lv8tzG7g5G1w/CzQlDTCNT3JW+70wmPMA+34GIUAyfE
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(346002)(39860400002)(376002)(230922051799003)(186009)(1800799009)(64100799003)(82310400011)(451199024)(36840700001)(40470700004)(46966006)(40460700003)(2906002)(6666004)(2616005)(1076003)(86362001)(110136005)(478600001)(70586007)(70206006)(54906003)(47076005)(36860700001)(336012)(82740400003)(426003)(66574015)(26005)(356005)(7636003)(83380400001)(36756003)(5660300002)(40480700001)(316002)(4326008)(41300700001)(8676002)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2023 16:49:40.7961
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a8cf670a-480e-4e43-b516-08dbc042e8c8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF000044F8.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6928
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

