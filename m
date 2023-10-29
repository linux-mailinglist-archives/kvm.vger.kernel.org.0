Return-Path: <kvm+bounces-19-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4B2F7DAD17
	for <lists+kvm@lfdr.de>; Sun, 29 Oct 2023 17:00:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D1B4E1C20902
	for <lists+kvm@lfdr.de>; Sun, 29 Oct 2023 16:00:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3C53D306;
	Sun, 29 Oct 2023 16:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hh2/0Gdu"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE643D2EC
	for <kvm@vger.kernel.org>; Sun, 29 Oct 2023 16:00:36 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA56C94
	for <kvm@vger.kernel.org>; Sun, 29 Oct 2023 09:00:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IAvVJqQOMJGn+FXDBHvHA+r6Yer/L06IpjbvwG0x6YWFl0bYPvvQlN5OKd48v3IRDSBq4oFX85NNR67rDIuq7EmfH2ba67buIyU4DKtIF0ImsdsJ9uSKLnG9bRwz8s5a2q0x1EuZLvQGLnhXnUtRq7m52kHS3/umqfQ2dqvweOZAWTqUlGe4ZvcAKoltqhW2z+ezx9DvXT3eVwS3Jo8jmmqXBw27K1tPMXOtUcYUtZy2kZpDcq0B7WL/3QaWrNM4isV0Tfdd+zod2o6rh/8x9odU9hcSPZ+/upUapCUTDHRKuF/qRSz0pPW7NZhdEz67mQ3iF170qO7kuchmDft8jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZK8oVP00vpc6UQUa3hMRt2UjQkZntth7M63FfSSA9Po=;
 b=JVEQCH/lEDie8z46snkksnkY7Ba8HqpyKp+5Wezl7+kJYGDeIiRuVwY9IcYzrQ6LOkoIr7RHNAibYEevIc8UIdgkogVo0zeGJp0U2PiHqMD88gHjvA/56DqWq6Wjaw2JBbPytSo2bEeap1oSSmCbRTYfywTp4Y85RbGbZA07gw3O4TVIMf6pANA1MqAD8++9as4UcMaETzfcNJ7lRVlCXQ/cyTjdA6N0YV9DWPkjs0K8AqxW7t8rzWij+VPGHQaNvN5By9kN9TPRFC5jmztzFLLi2BZvUqEnTnaE5bdxza8OE2vDJF7ZFrrztMZfQx6NpjH0ilRlRpVGlCB53UE/7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZK8oVP00vpc6UQUa3hMRt2UjQkZntth7M63FfSSA9Po=;
 b=hh2/0GduWmoJRG75/x9UDCjkOYMjPfX6ts12NgbYPvQHKhRkE69Xn96mXvBVrOzjjJY8XcusFFjNUHNezmWyVEDLxjaPjGpfKj7ERSrIwIZhAJEQ4myUppI3nzbiA5YjXUZl4U+2ZEn6D1noVi6USmO5jiofHIf4EBlLOXrugd5riZ1rrsucdI+Hp7gQr7pFIETXu0rrbmXeIYshfmfNRtXTyZ8DjG6f756Rx95U1KZUYX4mITO0N+6C+HAlboV1ELDxVkpa0MPjGz/lnzBz3DcfoG7pjkE2uyKaXaspbpeQIEvJswMivYhU+9+aLxUD3IFMdePH4N6YbUAwtK/y7w==
Received: from MN2PR05CA0016.namprd05.prod.outlook.com (2603:10b6:208:c0::29)
 by DS0PR12MB7608.namprd12.prod.outlook.com (2603:10b6:8:13b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.27; Sun, 29 Oct
 2023 16:00:33 +0000
Received: from BL6PEPF0001AB4D.namprd04.prod.outlook.com
 (2603:10b6:208:c0:cafe::2e) by MN2PR05CA0016.outlook.office365.com
 (2603:10b6:208:c0::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.14 via Frontend
 Transport; Sun, 29 Oct 2023 16:00:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL6PEPF0001AB4D.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.15 via Frontend Transport; Sun, 29 Oct 2023 16:00:33 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sun, 29 Oct
 2023 09:00:16 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Sun, 29 Oct 2023 09:00:16 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.41 via Frontend
 Transport; Sun, 29 Oct 2023 09:00:13 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V2 vfio 1/9] virtio: Define feature bit for administration virtqueue
Date: Sun, 29 Oct 2023 17:59:44 +0200
Message-ID: <20231029155952.67686-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231029155952.67686-1-yishaih@nvidia.com>
References: <20231029155952.67686-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4D:EE_|DS0PR12MB7608:EE_
X-MS-Office365-Filtering-Correlation-Id: b0481a8f-355f-4df8-e677-08dbd8982ed9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	21GOhv1b/ruBF1plqOUuViSzqTdU1Fk4v8iecK/PrkfCm1CJWcVs1d76WnWnPyoUoR+o0jV6PIfmPYuyNeordhLU9czv+A01IMVwJYtugmWCnqnNCAU0vwzgW+raFsfVYF0LfY/dCoxiVXOjqzJVHWo2YdRUtl/gWKI+Uqr/QXvF1Z+vPn0j9hkDfCKj+g8xOeMTX2WApC1B1CW3/amA/lawB2aPVGz0Tp/oXHBMgMaR9UEujExZlxEIZyr+VnNl51uYLmTt4E6Ut1aEGeCPsSafCG9+XrMwsTP/DYw6umfEspxZiW8fLpInyL39LwsRodA0J2ABeRW+oVSpmK1IZKXc1/OU7DqGZ17SGLnwi1RvFqp7EyLZpa8fYtZNLlj3CfMeJzJXg5+ljKSsMUWwyshwG0dbbYXI7PkJ6Q03opZuFWqzSN2Vg0onWKgwm5OGWZIg9YE7ZsUcQtxFpj0ZNs9T0HysVX48IqoNGSi2W1XLd26Mfk9EtTKabGAvojL2dv/6cBO231FK+8eYQPDN6Ns1eWfvRQz8mYrDy6uCV+7eoYmmatNS3YWs7QFBpk32yLofP9achOqbmhCW/YdhCv+VtOGB+wgpdCsCnno0jgCy3ZJiYiOuNzPrDiQh3I6sZVir1ZoK+nxo1AyTRrFt1YGnJ+aBodyaI5O/9cm0zq/ChhSSENm6iBx9/C0weIZ6lg0cJdCPsiGAkK/lYGEwtKYM0moRCJy9lYCWMRC/9yYzRd4rgGQv8mm7tYxdfVwU7tgtsrwHGinm/i2h3cItfg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(136003)(396003)(39860400002)(230922051799003)(64100799003)(1800799009)(82310400011)(186009)(451199024)(40470700004)(46966006)(36840700001)(478600001)(7696005)(6666004)(70206006)(70586007)(110136005)(336012)(426003)(26005)(107886003)(1076003)(2616005)(41300700001)(2906002)(4326008)(8676002)(8936002)(316002)(6636002)(54906003)(5660300002)(86362001)(36756003)(36860700001)(83380400001)(47076005)(82740400003)(356005)(7636003)(40460700003)(40480700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2023 16:00:33.3842
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b0481a8f-355f-4df8-e677-08dbd8982ed9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4D.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7608

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
index 2c712c654165..09d694968b14 100644
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
@@ -109,4 +109,10 @@
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


