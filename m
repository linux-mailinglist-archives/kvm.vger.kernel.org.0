Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 304DD7BD98A
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 13:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346272AbjJILZA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 07:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346255AbjJILYz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 07:24:55 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2050.outbound.protection.outlook.com [40.107.100.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A503EAF;
        Mon,  9 Oct 2023 04:24:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CQ3d9818wWh6FnD+K5dPjN6pT7FxjlBYRV7dg5tIdMOTPUfrrZ9J+6FEBPuO5wFmber687SlkujE2Iy6Rhc1Erk2FQlLR9aQNgkAzup6+E2jmFF1UFTfNAFaqjvu8c+Qg/MjH15qsZn5YWulEshvBJ+esuhoWDIBjsibNOU95W5/hNsx7dReOJMQnIz8JB9DGdaIz7UNUDBt/uaT3A8XuX2sJHwmq1TLWcxSzrMEniIDcBE4HW4V2l/05NvBwnphxEkG2Lh8A3gXkNS4TKyCH1UvEjAErzC8NMZ4lsfIAbdyyslHfoVfopCQqhBghcnblw9htMhnvH7yMR4XgA4nrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u64U1vHaUjCMSpg15sklK0flAB7mos1z6H94Kmb4gsM=;
 b=DUWc/92fc1tts21LHN663DMS5xT91IzZxqqlDhWinxOmIVf7ZtTsO8QfgJJYM0DIZLgdD8I25F1sYSS4VKGgDk2LuBS8oS8Wxxuo3LJKjUr4rccigA4n3MBYUQHrTWn+cDQ0s2Q5tv0Jkfzmqah1r7ieyToBC+kE1nxfflHvDwL+h2XP+YKh6xtJXXAo56glroRF07seeCKfxuauyBT4gLooTATyZHrys2s5xiv7Bc2xGB6Oh42C8aV7jRSi/g8fo1dhD2XmQVSZvgxZiLJ1uokTIpZu7hZTrDb7aYJsZYUmgJhc48VsXJfSx7kWh62VxvK4Bmk/rYdoG45bz7Ur9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u64U1vHaUjCMSpg15sklK0flAB7mos1z6H94Kmb4gsM=;
 b=VRaxj0VCg55fHht/uxDVi4YZdXiz8W82DybnF3jR3brasAnsy7JhVoxbcHM6pZ+Fd/aOjS0FT+n8ySv17fR35VXm4YZj9VYhdGnT7F6P8f7JXdMnqOa57HBV8UmGTI5ET/qrgL9PTJ2zxtnI/mvLhY4tLY5bMdgEXxBD7R1ri3HdLGjJ01I/vaJfmmo/B88BCRMFhq3s5OuMNKqfKnCIIpjTQHVtjbRabMK9wuQZncPybU7Euj7cEYU6MSP5WuiNb3r1kFQJm4TvJkOAcv3w3ZS60MvXLJ6YLLimi7hcLor9x0vDzo7m49BZIBKbPwbTR2UFZOGVSOI0RyucBiyTwA==
Received: from BLAPR03CA0085.namprd03.prod.outlook.com (2603:10b6:208:329::30)
 by PH7PR12MB8013.namprd12.prod.outlook.com (2603:10b6:510:27c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.30; Mon, 9 Oct
 2023 11:24:50 +0000
Received: from MN1PEPF0000ECDB.namprd02.prod.outlook.com
 (2603:10b6:208:329:cafe::f9) by BLAPR03CA0085.outlook.office365.com
 (2603:10b6:208:329::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.36 via Frontend
 Transport; Mon, 9 Oct 2023 11:24:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MN1PEPF0000ECDB.mail.protection.outlook.com (10.167.242.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6838.18 via Frontend Transport; Mon, 9 Oct 2023 11:24:49 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 9 Oct 2023
 04:24:33 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 9 Oct 2023
 04:24:32 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.41 via
 Frontend Transport; Mon, 9 Oct 2023 04:24:29 -0700
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
Subject: [PATCH vhost v3 04/16] vhost-vdpa: uAPI to get dedicated descriptor group id
Date:   Mon, 9 Oct 2023 14:23:49 +0300
Message-ID: <20231009112401.1060447-5-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231009112401.1060447-1-dtatulea@nvidia.com>
References: <20231009112401.1060447-1-dtatulea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECDB:EE_|PH7PR12MB8013:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e323531-6119-4d64-0a55-08dbc8ba59f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O40x9nFbR6U5s4J/IDnKsbBDIwl2RoVi0ikfU+HWPLZ0E2RoRP0tlNeKvSLfurqaGJVu9WTKPXeUyF6B8PljFqldoCeLkbCi4nW8/Ng3F3PnnyCP6pqwci08mMLtNUi7XmV7InZPni9Lprz4cVLYooQVzuWjs8s+EAki+x/KFfKkodxqMZUJETKKQvLWuQKpO6ZzrN53Nxrll0z75MBGAkG0JOYaJFdsIQNp/DgzYnX1FrDJmZlshe2iNq1ELMUFWQMKrmz7MOixMVyF7bk7lJEPJApyvipJCMv0+PXYLu8wAp+JS+/x1ONDOR9ZuuKcg4dIMda25bm2ge6UDhi0oEolxelVsLzJzQzWTOpWK93fRHMonUNECLAbrVUCt7eV1kZicocR3bUrJvxX3hzskUBkhE/bzFzGxmZp9ULBzmKfl2G9XL+rvtRF5nAaBcav7bdjhrVCyI6qg0nssDM7idCFFEKLduxt3KLeia77c1U8con1WG08jyK0IYil2Z0ynoYJO5zTeS0+M9WQpKa3H9sNCcnSFwLUy1bj1FLRsQ5hJC9G8uSrvoQYtsFCHs+vQ1NBGKHBtMP1ohvJQm7rjHMj+cHjkG1cf05kZIpUhVQk7g2ZqMEy2NDtrRcJ8wN/alI4cR9TRv65nLdf8IcA/3AfI48h/5vKFXpli6zkgwHfFT1wSKP2hQ3Hs8RvbnL7/46EWR3WGKJRnt/WWySW99BuwOJXQZjvBM/H3TCI+SgRMQKaBqDAUDDIzDj1BFkn
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(136003)(346002)(39860400002)(230922051799003)(186009)(82310400011)(1800799009)(451199024)(64100799003)(36840700001)(40470700004)(46966006)(40480700001)(40460700003)(36860700001)(478600001)(47076005)(6666004)(110136005)(8936002)(5660300002)(8676002)(4326008)(41300700001)(70586007)(70206006)(2616005)(54906003)(83380400001)(336012)(426003)(26005)(1076003)(86362001)(316002)(2906002)(7636003)(36756003)(356005)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2023 11:24:49.9794
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e323531-6119-4d64-0a55-08dbc8ba59f6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: MN1PEPF0000ECDB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8013
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

