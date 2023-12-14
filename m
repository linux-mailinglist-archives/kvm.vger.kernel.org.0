Return-Path: <kvm+bounces-4478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 58E30813049
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 13:39:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1425F2831E1
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 12:39:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2F154C3A4;
	Thu, 14 Dec 2023 12:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="giWuE538"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2053.outbound.protection.outlook.com [40.107.244.53])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B48A3
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 04:38:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SoZnwnlC7q+9FdTlGSSm9pdmzSrUEKKVkcRlY2S4Nkqme1Yp8sWIR/NNYag/E9MQpvLc24ET1wIjhtr+K40XBdNCCoBpckXX+2uKXPDork1P3gtrOaSdNeVi3rwGD4OhhYjDDx1QFRNALon5uJBb7W4Bc7l74RT+0Zt/1acEwaL3DIIeBdIEIHwiDoVUEIS2gB8CKZqrRybn59TDFztQRuj4T7V/p5QFNm88/lnyqoNZ4ArD988ISAT7i9QRxBJfWQNXkA+LA4U/MD000HJs/TfKwGAu3iktnCb5ADaKPdjCL2V7mOXb1voLljEpnb/8/g59KoD/TgI/O6MtmiY4PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ixQtpvTNaYyDToUTw43Dlrc0d/yTizWm3gUpC5jls0=;
 b=MF7VpTz5uUSS+Vf7H3BnQ9V4JHapCb6gkClyS18SDU5QrCCeCBT01mM6gPUjhbq/9TzLrHRknf05nI/7a4v53n9MH1lwRUxkvwgPu7wdpCqudRM5rN0ixzIuatWvCRWY603iUmho7hPBBqMQQutgihOF+bkJUgT6Wt1/g/t1IfIBovHmuSuN9DMB0s86xny4KWB5RPUx+wE+ZF4qKGlywDOIAj/jpNBNCsKkLX1XUVR7ilJbfo4+W56vUrMgTRlut+o3aOD0IzHqiA+RK7ij3OxIcT3i7kpcoOTkapwyKy7AblmLUtPq6HdK5xcbGX9Of3hauBpeSUNtolJlM5CyAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ixQtpvTNaYyDToUTw43Dlrc0d/yTizWm3gUpC5jls0=;
 b=giWuE538Xmp6lO5yu3J5JGH+/JUiZj7cHXUWuyE9+yG9CvUIN36FmwDdDp1Fsh4nb78Qy21hKCzPaqODvPvNoulF3I+NmEc6qUWDdutYiMMSoFnqUEV/BD1mBCgvJ+ru4J8U29EhGEUiE00OeYDNgHmzv07el7pjr9Soj+s4gV974HjDOuMgXpc8HAsZl/wMwhQRmAnCntIMV+OufZ61Lv/gcRpCL1dWfVEk7BXfGgIZL8lMvN5TVumpV8xEduqxc/Se1oe++4+l7qtCgphBY7FUW+x47ZlsK4VmEU06eGLdWXE+GYys7ZB2iEhbJckWwhXE16EmKqIoWWku26y8Ig==
Received: from BY5PR20CA0001.namprd20.prod.outlook.com (2603:10b6:a03:1f4::14)
 by MN2PR12MB4046.namprd12.prod.outlook.com (2603:10b6:208:1da::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.28; Thu, 14 Dec
 2023 12:38:53 +0000
Received: from DS3PEPF000099D5.namprd04.prod.outlook.com
 (2603:10b6:a03:1f4:cafe::a1) by BY5PR20CA0001.outlook.office365.com
 (2603:10b6:a03:1f4::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.26 via Frontend
 Transport; Thu, 14 Dec 2023 12:38:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF000099D5.mail.protection.outlook.com (10.167.17.6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7091.26 via Frontend Transport; Thu, 14 Dec 2023 12:38:53 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 14 Dec
 2023 04:38:34 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 14 Dec
 2023 04:38:33 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Thu, 14 Dec
 2023 04:38:30 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V8 vfio 1/9] virtio: Define feature bit for administration virtqueue
Date: Thu, 14 Dec 2023 14:38:00 +0200
Message-ID: <20231214123808.76664-2-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231214123808.76664-1-yishaih@nvidia.com>
References: <20231214123808.76664-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D5:EE_|MN2PR12MB4046:EE_
X-MS-Office365-Filtering-Correlation-Id: e00abcd9-1199-41f7-ff20-08dbfca1a183
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	XIR81xPc18pyXRHCHBKh/AMWdwuk78OOqGBEFuHu/aRCyOZat6wGt0pP0sdEk8kAd/sBSvYSVjpxyOSusV3cp/ig3AaZeDZQEz7h//ZiBhnPIQdwh97AbesymgUO1B8GDTO38aJY6RKUHTeFcUXQIdC8UMuIHJUXGbg+in5UtwU+gfXiMK3Xam+j9mm1JJtXZL4qqa2/sOUws1VjmKaW/vfPOKU8w+7eBpANqjgxoD6laECX9nJ9DnVxWOGcxKGkjSE0LxKk7GeoOII0KDIUGoUvl0naZ6XWPxbZdnGHE3P3CbOM6Gom2c+KO6suTOyPYZk4auaTTxofW1AAK2qFbzcuYv+z1LzbIrPTsjjgu7uxDnqWPaKX4RTy9h4LLWrxkyxtBCl3TpOLCtJE11J7G1N5p6RSJC7UzMvWc3YjX4wJ4j7Tuuo4PNfUmdkpnT+oSU4ln53UCIF2PgNoalk6K5ms8Mu/mEnib1TZcvEk+dOWzCkbF7wo12hkx1j8HRgM4gpd0NViEtKgcmrs1zrZmLGwRxqNS8rcd8o7/0KyFyyUuEpuVEtL1X1OcOk3Dw6XAdwyFPKd8haQGzqbZLK8VshFQChFDZ/cmC/bZSnSD/qn5i/l1nKZTrIW5jqCxQLWl6zM5avFNEFlmbjz9qMCwtm5AYAhRVcJvVEVaDWU/L/iBc9TJKgFRYevnTinVrRHpq0rQKqeeCFQa5ttBSOs4kZskBnDCJOW/dgZtDRz1QxH3SBdyrlzR2rDetmNVEI3TvCfGw7wz3scpyg7aQQ+NQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(136003)(396003)(39860400002)(376002)(230922051799003)(186009)(64100799003)(451199024)(82310400011)(1800799012)(40470700004)(36840700001)(46966006)(82740400003)(40460700003)(83380400001)(426003)(36860700001)(2616005)(107886003)(7636003)(1076003)(336012)(26005)(8676002)(8936002)(4326008)(110136005)(316002)(2906002)(47076005)(5660300002)(478600001)(6666004)(7696005)(6636002)(54906003)(70206006)(70586007)(41300700001)(356005)(36756003)(86362001)(40480700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2023 12:38:53.1367
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e00abcd9-1199-41f7-ff20-08dbfca1a183
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4046

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


