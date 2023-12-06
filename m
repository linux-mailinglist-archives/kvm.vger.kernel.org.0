Return-Path: <kvm+bounces-3678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B7718069F0
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 09:41:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 018FF1F21E32
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 08:41:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FD402E3FB;
	Wed,  6 Dec 2023 08:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tMhFbsGW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2050.outbound.protection.outlook.com [40.107.102.50])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D13D4B
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 00:40:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ggOZOazkCnortoBFf2eyY/FZWVGC5ilQKLj0Y9cpogV8pHIfNPhSsU+DyRk8oL71ickf25LNvsMbduhkwdbTZlZLWm/K8RFe+ErisdOcCTpfBhHRWM0cYMmSU9COP2JARe+GWgj3mCTmu8BNeA2qpEmR3p9S5Xf0OGHpky7AKMM+orV4gLFkEf1w59BSgDY4YWFbRFExju7eoHotyi0JxnMo0X8o2wvSdw+0KJs99/CGWdROb3PWZyT3aQ3ZHkinzZXb/eNn9PWqZRKQzVNPImNwG0gltRdxF2Qn4e8sfDlFMEmjr0fzUMJIf5btJPy96zSxoqYK65gvCByqIOYR/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gkM/aYNKVzdTgTMkS8jEGaII22y9kWtRVNK16DYDStI=;
 b=M0P22907Eh07e1druHpuSrQpP9Tle0tuhHDRkH3DYP/Z19JM3mCffPSmW6mszyv1GzsURMZiVLLnKbB6UuqeYoukK5XOBNCEcY3Rya7ndjCfaSzBlpWQiwcR8FtawikDz3dVpg1kb8FMWuuVo8vIY8pbZhLYPOlaee6S1/W5/2LWxQYMpC7PVFUqmq31zZhWXcUzxrUh6pD1fu251P+PC8LShvwv6/8SMchnd4JX6ZTsW/DM28kNNp/u1s9rvl5yrSI1lfjrf6qkpuRm6S71rWY5XyRd1NwcXWQHRTQ82QBw4boR87fBIKe5E2ap22qyuVRumoMEJGKcjtxnVXaxZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gkM/aYNKVzdTgTMkS8jEGaII22y9kWtRVNK16DYDStI=;
 b=tMhFbsGWzbqqhrddzf+3eDDIm23WeEW5DnEkXUD7W2988op2pckHAWnxhPTjX7bOFTT9bcWKynuEQ4rMc7HLzXtIq0mjTssRr6t6Cgj7w9Mv3Ter4oxGPzaWEB07GjG7pGPXyaG0PWsKeqBKzLfJCh/e3f1ZdfNVX02jR+P6jV9ZR4d0ZNVzLLjy2+0hO9UUc8qk4fnXCH2riCdTrsTfdTO371MTdUsfJ9fDTGg25jUQkzCKSX8BS3ctf6zwjJ8KGTxw83VDVu0k0lTtbQobAgsa+JVHnaduJdi3+MGS6JNfDKZtA8lvXE5PnR3QaLKxa+fxxanvrhwAgnq9OT9Siw==
Received: from SA9PR03CA0022.namprd03.prod.outlook.com (2603:10b6:806:20::27)
 by DS0PR12MB8071.namprd12.prod.outlook.com (2603:10b6:8:df::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.25; Wed, 6 Dec 2023 08:40:22 +0000
Received: from SN1PEPF0002BA50.namprd03.prod.outlook.com
 (2603:10b6:806:20:cafe::78) by SA9PR03CA0022.outlook.office365.com
 (2603:10b6:806:20::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34 via Frontend
 Transport; Wed, 6 Dec 2023 08:40:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF0002BA50.mail.protection.outlook.com (10.167.242.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.20 via Frontend Transport; Wed, 6 Dec 2023 08:40:22 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 6 Dec 2023
 00:40:08 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 6 Dec 2023
 00:40:08 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Wed, 6 Dec
 2023 00:40:04 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V6 vfio 7/9] vfio/pci: Expose vfio_pci_core_setup_barmap()
Date: Wed, 6 Dec 2023 10:38:55 +0200
Message-ID: <20231206083857.241946-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231206083857.241946-1-yishaih@nvidia.com>
References: <20231206083857.241946-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA50:EE_|DS0PR12MB8071:EE_
X-MS-Office365-Filtering-Correlation-Id: d553dd24-b515-41bd-2483-08dbf636fc61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+eyP5Wb/rs+yyYftZRBzzcFbDisOYAelQSrMd2eeIPrqziFLztIq61aMiG4OeYL3h+hAHNjsmvir5Pdy9vTac/0jrCQLuaiZwZH4xuXNt7Dp3G4QZSQoxHhU2Oa84pFCd8hvpk5Ouq2CL5/6Uj0CjD2I9zFVHSFldbOaQbXXoNlafAq4/rkrkX8NrBcD1mCi4mK3WOeMzhxztOixEL321JS618jpfTOk0EstRU3cNeT5JiXD9Lc7aQBKm9MiU8MiZeiqPQXH5ES6c7LPDFmye4M4BbC2ciqzDehFdK/DqJdGJEz/cmLgil5e6OwCxP8guDbf+Ycf7pJvJ/BFaJdklFmG5lgwlJ6Ly8ZOe5YbMf6sTVvShyRCepjJI9zoPn68XUOEVLKmwTPcSbCB/gX0FqkYnP0VzYrA94ljayge4xSHuWOZKMmMLj26RvQ5W+8QMt6vGj52fQ/SbskafOHl1hI4RFQQk9KukI+lQ2rsgD56lrs4R5k2wdkODkQD7vyGp1Vq8osRaCTP0deZbXIHmyLdqjoHsoZkRkxo7wQDuPdMLTlk4E077k1jp8PXAE4kkmB5d9QSi/tvKPUJdei1mHaivGZqai/H6TiZieSy2GgFy7gJ+eXGme+Bb/ew+z3gjmIHmcihIcEQ6esfkpYTVtcqGUJThquEOXMFLE8wX50UvQTEr3PD4dikVhsGLz18cNnSooMtCeAtBXKfAhmJ9PmpEFPz2EI2BhUrH5rKTSuO6Flh/0m1e/LIIutO+0kwhCWyn8p2rPzCvKHE6UsehA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(346002)(39860400002)(396003)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(82310400011)(40470700004)(46966006)(36840700001)(40460700003)(356005)(7636003)(36860700001)(47076005)(82740400003)(83380400001)(478600001)(6666004)(7696005)(107886003)(1076003)(40480700001)(26005)(36756003)(2616005)(86362001)(5660300002)(8936002)(8676002)(4326008)(110136005)(2906002)(41300700001)(316002)(70586007)(70206006)(6636002)(54906003)(426003)(336012)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 08:40:22.4542
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d553dd24-b515-41bd-2483-08dbf636fc61
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA50.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8071

Expose vfio_pci_core_setup_barmap() to be used by drivers.

This will let drivers to mmap a BAR and re-use it from both vfio and the
driver when it's applicable.

This API will be used in the next patches by the vfio/virtio coming
driver.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_rdwr.c | 7 ++++---
 include/linux/vfio_pci_core.h    | 1 +
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index e27de61ac9fe..a9887fd6de46 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -200,7 +200,7 @@ static ssize_t do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 	return done;
 }
 
-static int vfio_pci_setup_barmap(struct vfio_pci_core_device *vdev, int bar)
+int vfio_pci_core_setup_barmap(struct vfio_pci_core_device *vdev, int bar)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	int ret;
@@ -223,6 +223,7 @@ static int vfio_pci_setup_barmap(struct vfio_pci_core_device *vdev, int bar)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(vfio_pci_core_setup_barmap);
 
 ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			size_t count, loff_t *ppos, bool iswrite)
@@ -262,7 +263,7 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 		}
 		x_end = end;
 	} else {
-		int ret = vfio_pci_setup_barmap(vdev, bar);
+		int ret = vfio_pci_core_setup_barmap(vdev, bar);
 		if (ret) {
 			done = ret;
 			goto out;
@@ -438,7 +439,7 @@ int vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
 		return -EINVAL;
 #endif
 
-	ret = vfio_pci_setup_barmap(vdev, bar);
+	ret = vfio_pci_core_setup_barmap(vdev, bar);
 	if (ret)
 		return ret;
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 562e8754869d..67ac58e20e1d 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -127,6 +127,7 @@ int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
 int vfio_pci_core_enable(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_disable(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
+int vfio_pci_core_setup_barmap(struct vfio_pci_core_device *vdev, int bar);
 pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
 						pci_channel_state_t state);
 
-- 
2.27.0


