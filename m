Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB6447CE42B
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 19:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbjJRRQM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 13:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbjJRRQJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 13:16:09 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D0111D;
        Wed, 18 Oct 2023 10:15:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mj+rARdtwp+7+AS7q0gsnEM7x6jV28yYYxzfxgOqv+3BLduCa3u+1lHjyhG3//I77pp3PF1zEwuKrJaH5i3RVnSk4yzUcC+tyRAfnkr+gDDgKluPEWmhgAQn4z+wRrKiHxBJ98/6RR9XvCaHaqi+o8M7m9SRadoRaB0AO8ZfncMwXrWURxFjRRO9TvlX7JE3dicME6d2AVILB2LvVAXMMkE15BTJ5zOJfAI/qs7MeOGlK+0iNiUNf6pwQ9gqJXyVwkuYqshGljhmhLoE526D08aEIZV6uRvFu1MWRR6CSjTSX8Lbpopvt1m5ov41oeCRfpQaedWf92n9k6kMbBj+0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ILKog4btT16IMu9HXAHH95fAm+8LcOyK/4mzDrViAvI=;
 b=KawsJdcxemMZiWwqT8Qd5a6nUVhd60FhQiJuuNG0bpmmUeJPA5pvEiS1/ZCSNsJ7EpfdJoxAyCWLP+AG9ATLjwF+Xf+AQr8LtUyjmLf+Uu0BCpSHXY09jS5MMLfVWotN7oJX9hoI2Eu4gfoG/25p7x4+4wl1I+26KX5P7iqI6JoKo0mktb1qcp5YlO76zs8KCl8IBsdtr/fXTlRHief6xmQ7xi95uag9wpm2JmHrMYH4eQlCkKJWFUfgUGQS/MxMJ+vUV6d3TpBSY6Lt9H/mm/jh71olwjpHn2/Glypn+MuiRTO0tC2vFuNQdhXG3PqaOiBcm8ql8+H2BF7GxUaHlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ILKog4btT16IMu9HXAHH95fAm+8LcOyK/4mzDrViAvI=;
 b=InGIHWcYhkZD3T9eUB9/N5njheGFShSXpwrFfviZzFtfOzbYH1ReyM1U2Uvk0CUunTOdpTi7/+B0+hLthT2TEBVfST6+ABJuJ4ijHVqhvLbJqFnyDKd6cIh4oLlEDXlMiey4OuVM6sVTAsjzT+AsPpRWfOyY+0FU1+gb2yQStNZDvS79y0PJkm/nAgLHQKbuIThQaiilBj3uZqj/JadXBi74lybKEiQAH/BT9YOQun+YPlKSG4u257FKlaC6Pl143bVLXlsq7taFyjgOYFn5ETxc22vUl2+t8eWdx6/po8ygjYBID4zEt3OqkVEInpuIPFEG3G1LY1L4OZ7/DbkzPQ==
Received: from SJ2PR07CA0002.namprd07.prod.outlook.com (2603:10b6:a03:505::25)
 by DS0PR12MB6413.namprd12.prod.outlook.com (2603:10b6:8:ce::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.21; Wed, 18 Oct
 2023 17:15:57 +0000
Received: from CY4PEPF0000FCC5.namprd03.prod.outlook.com
 (2603:10b6:a03:505:cafe::ac) by SJ2PR07CA0002.outlook.office365.com
 (2603:10b6:a03:505::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.21 via Frontend
 Transport; Wed, 18 Oct 2023 17:15:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000FCC5.mail.protection.outlook.com (10.167.242.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.22 via Frontend Transport; Wed, 18 Oct 2023 17:15:57 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 18 Oct
 2023 10:15:38 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 18 Oct
 2023 10:15:37 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Wed, 18 Oct 2023 10:15:34 -0700
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
Subject: [PATCH vhost v4 03/16] vhost-vdpa: introduce descriptor group backend feature
Date:   Wed, 18 Oct 2023 20:14:42 +0300
Message-ID: <20231018171456.1624030-5-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231018171456.1624030-2-dtatulea@nvidia.com>
References: <20231018171456.1624030-2-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC5:EE_|DS0PR12MB6413:EE_
X-MS-Office365-Filtering-Correlation-Id: 9baee8f1-9f7e-4277-8785-08dbcffde4c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fWm1V7o39YwSWK+uHNaqLyxEh4EbQaw1XmxinJNGTLo6+LeXt6NiT2tWbysJj7CXJEai3glQLlZVF9p+5eetmgoFaAuYm1Adyaowpjs6yta077Pxe6VWJHJgoYQhvcXrF/lfRT6pU/VrxcZtwhebRTQeHGvTuzfLw1aZiAFDQx1SIb99swzCSVrJq+9SFcHJL+KawtqrRFvPd6qvGI27b8ISPcN3XknagZM28Xk3fZH8jQas7opMVCuuAJNFiKDCGr7kqfreKT/G8NV4s0nkt7ik1on0tUZQv1JeHMnvw6+mF29nr7286Ee9HP0bgY6OjovQTbqSuyq54DjP/iyoPtcerqtjjIw6GUEM2aK7pdFWri51YVtYXXvfyq7iFQqboauIY1Y//DMNhGBzofOU3XHaL6ngoEIno0UXqNRXEJ4Bqd3eB07kxL3ZWLnDF26MO9LlZQAidrLc/pnlUWod3A/nE8h4QmhGJOc44qdgznmjSUV2J8wEIAwgrmIDNGGPHn6FWO9oNMVeGifIgdOvfy71gqNj49krBsz8uWhf2IY9R3FBNq9aFiTkni5fh/PniGWfnVlgFm8cQqR4q7Gf8T6gYiEoLSL/ezjqmmwZuipmUaC1j1f8RvNFwMvtk2NSXiZMbs9kTbOGB/XdtfBVjMLlL9fIC99JjvLQtuj6lfBr3kkiKnPJgEel70LcYzYZGQ4+z9Wa3T6BXwOXy8l/iI9EMAyS45KzvaiSKi3Iczq/JWGQqINzJm35xeCku/g+
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(346002)(39860400002)(396003)(230922051799003)(1800799009)(82310400011)(64100799003)(186009)(451199024)(46966006)(40470700004)(36840700001)(5660300002)(66574015)(336012)(426003)(83380400001)(82740400003)(6666004)(356005)(7636003)(1076003)(26005)(2616005)(478600001)(36860700001)(47076005)(54906003)(70586007)(70206006)(110136005)(4326008)(41300700001)(8676002)(40460700003)(316002)(40480700001)(86362001)(2906002)(8936002)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 17:15:57.3214
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9baee8f1-9f7e-4277-8785-08dbcffde4c1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000FCC5.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6413
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

