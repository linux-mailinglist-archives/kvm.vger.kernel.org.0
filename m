Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67BC579D18B
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 15:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235369AbjILNCR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 09:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235164AbjILNCP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 09:02:15 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2081.outbound.protection.outlook.com [40.107.220.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9182210D8;
        Tue, 12 Sep 2023 06:02:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n+4IJFeu0+HtV6OBRpD9wydgZ7AfNMalbPltd6ToOsL3kVLVfBE8jfcBqzLLJC5Hyu9yq2QgsqyjaLEmY+wEKNjJ+ciYflhGlOVqWmoZY9iDH1y+MC7xg2Ag1k1GjXFndNlf9oKSW2qZRkhZrL4tq4h0tB2JgccRGWhH5JaGp6xMfkKWih+m5ag43+rV8lOp+xPkD19TKiXeEFnK7KN/ImWNOOvalMFT7/LV8dfaswgtrwvaZXgLr1kLrBNQmPhuKMhMCgwPP2uOMBKmU+UG+PXCy+g17go/uhMiF7/xzEE2OdrFlQCLJLYMaDb0FBuPXyzLCJ3MnspQyT6+vmrnAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u64U1vHaUjCMSpg15sklK0flAB7mos1z6H94Kmb4gsM=;
 b=Ql+TNpsP0SGgRqK0Netrx+uv2B80La0nBGTBTujvhXlU/h/sn+tdjEPeyj8mDK2AUaJ4j8yHBpo/1PwGRWDvbpWe8fRhTKH99ijXlP2ubd02MZD8fM4PRxdUl1jpwZeUc65Z6HgfyTDXOM9Vhvkhx6NNd+S2E8cjEBpEIOsYQoPqlzKSjcrnhaecmtydjpY4RI/TpST8HUAIDUTVDMHH/Yd/LyGjEwSA4QdygsV4z6fJE4PMtVsvfbumD3tX5sjvWs/zJjCnLDs/DEz8pofVuSbYA1nG3z4dA1W/aKCgKHqiSrOaWHg8C1XKZ8Kt60UhPutC5sB43UGy5s6LhQAxYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u64U1vHaUjCMSpg15sklK0flAB7mos1z6H94Kmb4gsM=;
 b=jYbVfvy6fjzQ0PMnG6pApEc3S4H046yPOUSBJnS2XSxw0/gCrSNdH75LSFQ+AGVLvCyBEQEDWoS8bSzb0RI7FwcqRY2jG8ATDSaUlku9DxqSIMXP0n9sO97FJIGYGra1ssCHHUh+fOk0GBQRuq8IIDxEoeOZZprfveBxAu/WrUzxMJEod3lWk5S8RmHWNY/06jcD//wi9tdSK9fTqwB7+29aUAUfVHTSVUu7PkNGQOUrz8CNegQMfAMZ0ThczLKZ0BPmSynpUeSZEzXRY1zdH3ewPiOTdrwzDZmawFw+Dz4q3ubhoBHFhHCnF43un/q+bso05MPFpi/OxwxYYPYUTA==
Received: from DM6PR14CA0060.namprd14.prod.outlook.com (2603:10b6:5:18f::37)
 by IA0PR12MB8375.namprd12.prod.outlook.com (2603:10b6:208:3dd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.33; Tue, 12 Sep
 2023 13:02:08 +0000
Received: from CY4PEPF0000E9D9.namprd05.prod.outlook.com
 (2603:10b6:5:18f:cafe::75) by DM6PR14CA0060.outlook.office365.com
 (2603:10b6:5:18f::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.19 via Frontend
 Transport; Tue, 12 Sep 2023 13:02:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000E9D9.mail.protection.outlook.com (10.167.241.77) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.17 via Frontend Transport; Tue, 12 Sep 2023 13:02:08 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 12 Sep 2023
 06:01:57 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 12 Sep
 2023 06:01:56 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.10) with Microsoft SMTP Server id 15.2.986.37 via
 Frontend Transport; Tue, 12 Sep 2023 06:01:54 -0700
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
Subject: [PATCH 03/16] vhost-vdpa: uAPI to get dedicated descriptor group id
Date:   Tue, 12 Sep 2023 16:01:13 +0300
Message-ID: <20230912130132.561193-4-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230912130132.561193-1-dtatulea@nvidia.com>
References: <20230912130132.561193-1-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D9:EE_|IA0PR12MB8375:EE_
X-MS-Office365-Filtering-Correlation-Id: 50b5d8a3-2eac-433d-ec69-08dbb39078ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gb1HPxQzCWQJFaPXWWVxmwHwnc4AmW4oAqnvxvE6VxG329Du5We0wTgpQJ9ukAVOnSSJTGR8X3yXXU3rk6tEw9l/euIPXQShy0ehp7MzB1LKhPbIBHNQhrs0S0dYFHpqu5PC3ioYj/0jL8IFyEalWzHz9ikEixWUOPbHwP27qF9gC0lVARBMnKE4tLzeqOmBgc1XzxoQSoEVQhTmHWd4tlI29A1gFXiVlFYN7kqKBt75qkDkZBrLDV+n7tJCfBLzxN4zSxCD+/zcJWt2REvA1PENj0IynqW3GfPTcPbSAtJk6LtTHfLK5oRkjGQXLyea7v4gxf0BRfXKn67divfyDb9Tn1LZzj2+SxeeqTaRo7v79saEEUOHg0YNbGNNEdmR4Zjt8Ro4OP5VeHRpJQMaEsH8Vep77pOsHMx6SAAHCJp2CG4oyhKztijDnSPlTE5LjjDPg7CaMW0xbX6wIopVuE3aWVzRrKVAR7D4CheKmElDbL1OkpwFPzeMvNv8VQNRQf6W81oQWbAqiFQQyf0TL1VCUbKz9nYi91trxBw9sEP8PQV4+SIjnMTHHVlRSeZgrC3PwsnkYiO9P7RjxGeqPwtGk6Zozq2tLzld/HNqUhx09Ls+fVkPSbymy9P25foYb2olqBoxWvy/w+mY5oXRTYcbbRYQQo/vys8wfyF140FsbKoPf4kIKq9+ABFF5PmTp9X2BXHs7ejA9nYJMUyiQklRHuiuhqLy+GfjqchB669eUvrDo1v36FAcmA3Te1Eu
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(396003)(39860400002)(346002)(376002)(186009)(451199024)(1800799009)(82310400011)(46966006)(40470700004)(36840700001)(41300700001)(316002)(40480700001)(26005)(336012)(426003)(1076003)(70586007)(8936002)(110136005)(2906002)(70206006)(8676002)(4326008)(54906003)(5660300002)(478600001)(6666004)(40460700003)(36756003)(36860700001)(47076005)(2616005)(83380400001)(86362001)(82740400003)(356005)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2023 13:02:08.2977
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 50b5d8a3-2eac-433d-ec69-08dbb39078ad
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000E9D9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8375
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Si-Wei Liu <si-wei.liu@oracle.com>

With _F_DESC_ASID backend feature, the device can now support the
VHOST_VDPA_GET_VRING_DESC_GROUP ioctl, and it may expose the descriptor
table (including avail and used ring) in a different group than the
buffers it contains. This new uAPI will fetch the group ID of the
descriptor table.

Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vdpa.c       | 10 ++++++++++
 include/uapi/linux/vhost.h |  8 ++++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 2f21798a37ee..851535f57b95 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -613,6 +613,16 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 		else if (copy_to_user(argp, &s, sizeof(s)))
 			return -EFAULT;
 		return 0;
+	case VHOST_VDPA_GET_VRING_DESC_GROUP:
+		if (!vhost_vdpa_has_desc_group(v))
+			return -EOPNOTSUPP;
+		s.index = idx;
+		s.num = ops->get_vq_desc_group(vdpa, idx);
+		if (s.num >= vdpa->ngroups)
+			return -EIO;
+		else if (copy_to_user(argp, &s, sizeof(s)))
+			return -EFAULT;
+		return 0;
 	case VHOST_VDPA_SET_GROUP_ASID:
 		if (copy_from_user(&s, argp, sizeof(s)))
 			return -EFAULT;
diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
index f5c48b61ab62..649560c685f1 100644
--- a/include/uapi/linux/vhost.h
+++ b/include/uapi/linux/vhost.h
@@ -219,4 +219,12 @@
  */
 #define VHOST_VDPA_RESUME		_IO(VHOST_VIRTIO, 0x7E)
 
+/* Get the group for the descriptor table including driver & device areas
+ * of a virtqueue: read index, write group in num.
+ * The virtqueue index is stored in the index field of vhost_vring_state.
+ * The group ID of the descriptor table for this specific virtqueue
+ * is returned via num field of vhost_vring_state.
+ */
+#define VHOST_VDPA_GET_VRING_DESC_GROUP	_IOWR(VHOST_VIRTIO, 0x7F,	\
+					      struct vhost_vring_state)
 #endif
-- 
2.41.0

