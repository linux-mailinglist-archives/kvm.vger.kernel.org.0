Return-Path: <kvm+bounces-3600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F596805ABC
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 18:07:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4FF7B1C213AA
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 17:07:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBD21692A5;
	Tue,  5 Dec 2023 17:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Wp9IbtM8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1481BD
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 09:07:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VZPFW9TEaSQNON+QYZ+aLlxtDoFdpCtRoZBkE9olXdDyPlEqMZ16rj6YQ1vj2fwfD3iPtrllBw0sWIUqmgF6r2pxBZwVlLP6BtS6Mcj98Cu/MBu0X64jKJejtaQdPcx8SQZJ/h5T/2emI+Sn+ewATEr3URynRUkHvX5W/lWUUdkvtrzKpkcVpKgI285eHngm8IyBffmlTU/5YuCk9CIw06H7jK4fTa5YheMwDreXl0rpPLeWLf5bd4fXTLr5HdPgfRzUYa9VHLz/INMmzSyCgXrQ9dtnplbbyWOYOYgMNlGw8hBlLdZswz03NuI5rdFmylDVRmj/TFuJdO+CtgNCtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ixQtpvTNaYyDToUTw43Dlrc0d/yTizWm3gUpC5jls0=;
 b=PKXdP4e9wCMr8uuruZPEmhEI0IVCVj4kOprvMCLu77FOFqpkZboLwtdXn3B0JbELW7iMghbj8javkIutz7uyV1cNMSjjHdS8u7e+RWx96cnIrZMNJM2nvc6lmQLEJhKvPPpKHkJTJq7ilnJcAjxEIWbr1q4qqgBlrveyMf6wRZT/wNz2+ac3sVPCGrw7Tw1lVqOFXesnQXXHKyFmefd/yFkhVio9PPAYX0humfrQdrAQk0pggTMpPJkzQKasxCRqzz9vsEmvC5VA/awIDn01GvkQ8musMS37h13KUzdTkI3YBcUbxuqx+h5ABtG2uJR6dp3qFu+DTHNSqrHQ8KKewA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ixQtpvTNaYyDToUTw43Dlrc0d/yTizWm3gUpC5jls0=;
 b=Wp9IbtM8xMjAGAaYTJUD/6j03T2vRf6kET8XySwSOK0zWC89CRyCqNIg4EbPcvh76KSXFLp2QbUmBpYgdDB31PamsNk0bvr52PNEZunccBvzEnSNIae0Szf3Z46VCD0yDxmy4XYrzeEI56uBtsWcN5XMnrN+9ZZUcTIBqJ7ladqRHyhDGSzTdk+SLLF2mCQiq4LrV+PX74sWbW2nFqae8J7ECmMJ6G927ktscRERLlmDIMYFs1xwD/Degv/sCo1QOpusPX147Q6DvNGmzE6/DUt/Pai8VNKIiV5s2Zeq9jL905Qwb4P+ISEpvomuXomwBG5ls9pTPvEfxu9qobmqJA==
Received: from MW4PR03CA0025.namprd03.prod.outlook.com (2603:10b6:303:8f::30)
 by CH2PR12MB4326.namprd12.prod.outlook.com (2603:10b6:610:af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 17:07:13 +0000
Received: from CO1PEPF000044F9.namprd21.prod.outlook.com
 (2603:10b6:303:8f:cafe::28) by MW4PR03CA0025.outlook.office365.com
 (2603:10b6:303:8f::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34 via Frontend
 Transport; Tue, 5 Dec 2023 17:07:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000044F9.mail.protection.outlook.com (10.167.241.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7091.2 via Frontend Transport; Tue, 5 Dec 2023 17:07:13 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Dec 2023
 09:06:58 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 5 Dec 2023
 09:06:57 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Tue, 5 Dec
 2023 09:06:54 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V5 vfio 1/9] virtio: Define feature bit for administration virtqueue
Date: Tue, 5 Dec 2023 19:06:15 +0200
Message-ID: <20231205170623.197877-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231205170623.197877-1-yishaih@nvidia.com>
References: <20231205170623.197877-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F9:EE_|CH2PR12MB4326:EE_
X-MS-Office365-Filtering-Correlation-Id: 22cce92b-429d-4f25-ffd4-08dbf5b4a039
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	js7/hRrGTmcM7i4XY0k+vNWIi2gCgsqaQndoQ1sp5VoBJTNpFVwrc3In1gVrCWHhIbSM9rWh90UE/myIQ1rup2KVjy6V3YN7NG59OFFuFh4LhGBi3j7BVemIqI9c60gKAERAl9hcSEQFQV+cyUfDgPfexbHk/9RnNB/ItgiyqYXSmoXX508TwqGhbKRW7dnjY565D8smOnyYFUeS6EMaAB9cuvuEAlrX+J96uU9ivC093o2iE5ZEtiRKJA4wqtYGMWWEqzIgTjFXrAUTLEzPexCp0xiNy+RbkWDFzEThW8v7xehBRysdgKhYUAksUaoreqk14hO5fXrxJivq6tTdt4WAT343hS5NttQ3I5/Kh0xgV4NDKq0Z35p0WkPtiq2nOgcgncW7qcQ4iLB9haTR3lakuEsybo8uo8qObbwCWgfHXTtaaKejFELiVr7DqPzcRy5gGzODVlJsOUlCd0D4tAwqQqHOLoe/vXmz1WvjLi1aZYAKpDEAMmACoNARJ1PjzfTjnCrzSSQTrc/m7E6wKnT774KBb15ZdXC/oIKpHxFzlC9v6WhlzgsTXqrpxrD5wTFyRoYY2auTn+zzBLaoCETcjo/rYYjWzxODhc25WkIrCa5cpd2qgzj+IaSgfVzqccdhQv//hiWfF75KeJda2EWwAAcmsAty3xYL3b44uE2Y+x66GYX0uOQtVOaYKLxiBNiELM95uYg+2rIddzaGY10DgfxhgpOWLVK2MojkATgEYXs2/ZBhZLs6+a4b7ooGL7DsYwTXodPgT6w+OMXo4g==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(136003)(39860400002)(396003)(346002)(230922051799003)(64100799003)(451199024)(186009)(1800799012)(82310400011)(36840700001)(46966006)(40470700004)(40480700001)(40460700003)(478600001)(7696005)(8676002)(1076003)(107886003)(7636003)(47076005)(2616005)(6666004)(26005)(336012)(110136005)(6636002)(426003)(4326008)(54906003)(70206006)(70586007)(83380400001)(8936002)(316002)(36756003)(41300700001)(82740400003)(356005)(5660300002)(86362001)(36860700001)(2906002)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 17:07:13.2724
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 22cce92b-429d-4f25-ffd4-08dbf5b4a039
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F9.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4326

From: Feng Liu <feliu@nvidia.com>

Introduce VIRTIO_F_ADMIN_VQ which is used for administration virtqueue
support.

Signed-off-by: Feng Liu <feliu@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
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


