Return-Path: <kvm+bounces-2767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0ED8F7FD9AC
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 15:38:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B99F72831DB
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 14:38:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E25BD315AB;
	Wed, 29 Nov 2023 14:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qGXJ42hj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2044.outbound.protection.outlook.com [40.107.101.44])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A247BD63
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 06:38:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HN4upzQ6acjBWaqPoWQrA/IOUjqAp13c2+UgDyDAc/KQGTsyxtWU8cuAI23eSCfuIwICzqyqzhj5ps6DSMKAODHkd3YDz7bqQiIt7ZAvOqZ0KCRBi2Zchlr6AOYQ9adN1XgdU5fxfKcniqd5K+cIPmsmy/Su2iu8ltdMgL2dyDTjbuH+rtmIF9Dm6CJASzpZWgMHJjKO6IvDuzJohFuXunf7vGCyOwN4kL8vSQOL9NCF9+gbv+a2onFYxou+USC5Q2hcn2XNibVoyQ0Csuqf4nGO1vm13E2R/6bR79KeeFrMfHk6b7fclbIkWctQM8iF/Te4xMtaWftqOM/BCsSrEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V8j42m/JacpVfupRxJj45AISF8yax+aXsjalqid2po0=;
 b=YCYxcGDwYzG/PsWcO6yAEOK/TIqQSRTo67IW35zujTrNzAM4jZeROuHNYryqqrmX72C5DiDIE2SJR12zUYXno87zxo3DCGX54RK7Sl1EEyh7MZE04+9aOCznDryG9MXrDi4JlJbRAH2oL+ZP2fsLlLXMcZNkJX6M2LeU7dKeR260vpUpzYZwIUDP3UHIeP+Xom5jMcQVOjYgBbU0S9wVvAeZxCEuJ4gGzyryfNWsC+r5NCDYeokigBDURBHLB11FeQgDwNkE73WKtjlHPRAV9GbWJ0zlYo6C0OVfDlhHErKYQrw+zSg5XvZg1dCEKRbiiYxYfIIZRT0IiJfrB3wBvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V8j42m/JacpVfupRxJj45AISF8yax+aXsjalqid2po0=;
 b=qGXJ42hjIolXvDBOVyRCcQLqizhi1vUjcXkM5e2Pa5GTEF40oD9s8LPsMUmskmnehfTtVEswmKCxGhWHviAfyF/8LLYyuppFPBmoi4mg8q1xh8dBg3bwsp2D4LWpYKn/27aP9ZR9iRVCff6NCg78QWzB+qXPSSdjOzaraDjw9wNob8f/06yyZqh5GRtRku76gUi9Il0Cxj3Fwwie4SUTOkfaRvyHAK4aoHnOqLBPdDF9m8waZr0+C7mWgZ0C/SHmGVFQHIPmyD5SVg/4grAEDl5jTyBpFZlUfya8tRMn8iMF0B8LBd8udF2mT694QhxoiEAt6CSFg3Q9kWO/Rhw83Q==
Received: from CY5PR15CA0159.namprd15.prod.outlook.com (2603:10b6:930:67::27)
 by DS0PR12MB6559.namprd12.prod.outlook.com (2603:10b6:8:d1::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7046.22; Wed, 29 Nov 2023 14:38:34 +0000
Received: from CY4PEPF0000EDD0.namprd03.prod.outlook.com
 (2603:10b6:930:67:cafe::e8) by CY5PR15CA0159.outlook.office365.com
 (2603:10b6:930:67::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.23 via Frontend
 Transport; Wed, 29 Nov 2023 14:38:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000EDD0.mail.protection.outlook.com (10.167.241.204) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7046.17 via Frontend Transport; Wed, 29 Nov 2023 14:38:33 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 29 Nov
 2023 06:38:31 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Wed, 29 Nov 2023 06:38:30 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.41 via Frontend
 Transport; Wed, 29 Nov 2023 06:38:27 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V4 vfio 1/9] virtio: Define feature bit for administration virtqueue
Date: Wed, 29 Nov 2023 16:37:38 +0200
Message-ID: <20231129143746.6153-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231129143746.6153-1-yishaih@nvidia.com>
References: <20231129143746.6153-1-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD0:EE_|DS0PR12MB6559:EE_
X-MS-Office365-Filtering-Correlation-Id: 33bd8518-2274-4181-37bb-08dbf0e8dd47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/pU2Z8pQI5coyfI37AEfFpuLy3ac7f0eyfC44EWG9/way4e+gVDbwDKuBFbedSdWd8eLt7HX7Iab45wor6/LshdAbsB5WJ9BBrk6JfoOUVwD3m047r6osEHp3FpkERocmeQ+31gD18TvfHePe0afuYnDFTnQug0y3+DDH5x9WEnlxgUUI/ZkAZuDjX/+iXPQzUE7u21BZzuc4v8vAWyMuk2Gv6B4SiV6TVJX4eIfQmFsfwOTzHyR5GWzokc/EI8FWbFksv2rybouyLojTyz8VOUNr3ercEHAPGbl5P0D8FwZdThKNFZQcnFa07xof5bgEyW8iEd6+wFm9QvUTQHn3DoIxs09f5/VYwvcgfpm1JkLj8xD0Z4ank9nzbGeAz7qIPv2Cbk8qEGFs4u2/5IoXVud1ozwH5N8cDx+h6p2qTVkwsEwpOksfLx/BMJ6amA1enGcSqnSGlPe8PeUqVBI59KPJ0c4Z2LC4bG1WezE4lys1vUMkeYzV7xvz/VrRKXQx1e3wwcw1e7c2v9UzDdXOW3AJxiaaCE/tiGxW4uBwJeGKxFR3ynh5EfGcniWJ34z7AEm1C8ZdHz7NrQvujHXhJK3UjjYRZzna7Nj8+dy3HkCznTgVHhjl0b3mTYAjBC/s/PRtNh9r16KYlY4F6msCXYMJrRT0v8pF/pzRVvp9pwZfnF9ZvCcnn2GrlJfiX4RBqg4sjAbn2SJITE2k5zgT20/dJoH7NoJxmDaWT4rjwD3YUpCsdSo95z+yLxddS1fy7cJvfizQImo7YvrYjuXaw==
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(376002)(396003)(136003)(39860400002)(230922051799003)(64100799003)(451199024)(186009)(82310400011)(1800799012)(36840700001)(46966006)(40470700004)(40460700003)(316002)(6636002)(110136005)(70206006)(54906003)(70586007)(7696005)(426003)(36860700001)(36756003)(336012)(6666004)(26005)(2616005)(1076003)(107886003)(478600001)(82740400003)(356005)(7636003)(86362001)(83380400001)(47076005)(40480700001)(5660300002)(2906002)(4326008)(41300700001)(8936002)(8676002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2023 14:38:33.7630
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 33bd8518-2274-4181-37bb-08dbf0e8dd47
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6559

From: Feng Liu <feliu@nvidia.com>

Introduce VIRTIO_F_ADMIN_VQ which is used for administration virtqueue
support.

Signed-off-by: Feng Liu <feliu@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 include/uapi/linux/virtio_config.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virtio_config.h
index 8881aea60f6f..2445f365bce7 100644
--- a/include/uapi/linux/virtio_config.h
+++ b/include/uapi/linux/virtio_config.h
@@ -52,7 +52,7 @@
  * rest are per-device feature bits.
  */
 #define VIRTIO_TRANSPORT_F_START	28
-#define VIRTIO_TRANSPORT_F_END		41
+#define VIRTIO_TRANSPORT_F_END		42
 
 #ifndef VIRTIO_CONFIG_NO_LEGACY
 /* Do we get callbacks when the ring is completely used, even if we've
@@ -114,4 +114,10 @@
  * This feature indicates that the driver can reset a queue individually.
  */
 #define VIRTIO_F_RING_RESET		40
+
+/*
+ * This feature indicates that the device support administration virtqueues.
+ */
+#define VIRTIO_F_ADMIN_VQ		41
+
 #endif /* _UAPI_LINUX_VIRTIO_CONFIG_H */
-- 
2.27.0


