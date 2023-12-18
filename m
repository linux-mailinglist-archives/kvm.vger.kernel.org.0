Return-Path: <kvm+bounces-4694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3111F81684C
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 09:39:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 567CA1C22446
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 08:39:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 623EB125CE;
	Mon, 18 Dec 2023 08:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QOTqUffl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2087.outbound.protection.outlook.com [40.107.244.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FED6125B0
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 08:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=alWTpd4xNLRmZxFYuzKxk24RoN6rIPzSvKUUj4yvECFVg8i1xsaizt2/8DMLtpSOQsZYjnUHxxPJBlZOButBMgTNTbQPmbH5CIvXxY9+N+HXo+j5/bbRFTH8ibnfP0IxVqNcWCXfRPkmIeuFxeXFcfgibcgAR9auRSy5IR1c7fzNNuCuLI/AS6WpQRn7P4BDC3QOPOUT+x4zr6YThT+uDrfrFIfdPGBfOL9wQoWVcWsJ3sxmRBn3z3VFW+X4RKostPyxE9BmUq6BussOflpMBSLaGiHrOfp59TCpZiY9bFc128OuO9x2VXg4hAZ9pdfHDlUkUH3JTnVGJPOOvjirfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A++3yuKKQheNoq/8ne69fmALtWgjNee3wpBIrcBt4lA=;
 b=HwKb8CojysbGVcOR1y6HGneY5Sk2WUo1nwqV+8lcM+FaREU2B1QgIh1ohmyVUJCpmWMdJWUdkI3bXYtnIrh/WWcyo/C3RjIyZ8Eu5pCsgKpKzhrp3GocjHB/C9nSunABEQLCbMoAj+GgJP0Ob2NnLTHTJTjMe7SY3gHEPQP5k84YoB0Hbq0N7rD9XEFssftQJ/rDZGlEmPfM03jd9S/ZRJ5NykOvtXVLNht5C0mps4qAt4exT8f7F2E3bkBnL2iLZ3gQUMA2GQxQid+1p4WrAEvhMRxkfwENv4fk6X6deN8glQXJF7o9tI1wwnnrtt8zegQx/hYDkS5ybAwkiwv9nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A++3yuKKQheNoq/8ne69fmALtWgjNee3wpBIrcBt4lA=;
 b=QOTqUffl6egXxRiJmC3ZssJOBb/tyzd/EUkewCUCYHsvTRBT1wTz5mjWgkKVeIcGTzJvDY6zDgAFkwoUOPLUCIwPxc1nVe5Hyvj/tLhAa1jRtgyOnFpI5ADbk96tgMkb1N15H5y5wTTXgZ5IYkbnCBfajNhAaC2+y9IZfekU3dO04W1TQk61atbd4YLSbZRu1Dqp4Ff1LBvgnYiJRav7iyg2e6Nw/mh1pD7Ed0AHb+89mGTB1FzWDoc5n0PJgK1WARpHzGckTZf4K1Uk0b1PKKwYqJcuGdCMqBqBzaH7zIyAbG17pL/1LxXKkEYQQjwYh4B7p211K3hzeVF2zovb6A==
Received: from MN2PR01CA0013.prod.exchangelabs.com (2603:10b6:208:10c::26) by
 CY8PR12MB8266.namprd12.prod.outlook.com (2603:10b6:930:79::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7091.37; Mon, 18 Dec 2023 08:39:14 +0000
Received: from BL6PEPF0001AB78.namprd02.prod.outlook.com
 (2603:10b6:208:10c:cafe::dd) by MN2PR01CA0013.outlook.office365.com
 (2603:10b6:208:10c::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.36 via Frontend
 Transport; Mon, 18 Dec 2023 08:39:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB78.mail.protection.outlook.com (10.167.242.171) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7113.14 via Frontend Transport; Mon, 18 Dec 2023 08:39:13 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 18 Dec
 2023 00:38:59 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 18 Dec
 2023 00:38:57 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.41 via Frontend Transport; Mon, 18 Dec
 2023 00:38:53 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH V9 vfio 7/9] vfio/pci: Expose vfio_pci_core_setup_barmap()
Date: Mon, 18 Dec 2023 10:37:53 +0200
Message-ID: <20231218083755.96281-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20231218083755.96281-1-yishaih@nvidia.com>
References: <20231218083755.96281-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB78:EE_|CY8PR12MB8266:EE_
X-MS-Office365-Filtering-Correlation-Id: cbb60fd4-48ce-4bf2-163f-08dbffa4d03a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	MeXLy33B2S4skMDPt4biLJYejZO7o2LHeQTZBEnORGvevKF6iWGMDhaSN5TDCWhZ9TY+6/f0gTkkgyRbVSRtQEIsnOvzZr9Y4TxgnR2z+PNk5u+CoQ8COTsaKqh4Dkqc7ZzQ+AJmhF/jwFTlqC/iv3OnAQA0JfPnC4MRCmHN5gxsuJtoGgFrkFDzetoqBQo7OTL9+jpuGgqKd9thQkGX3HFx2oLgPOkaHT89Umh/lk0RzwghPhZXgY7m00NGyB/nCn1iVu0mkyod63cqwmR86ysYYZvR1a1p6uoOY2kdlHkWMrTNscat9awAmP9lLaRH41OziZIlS7VSIsMTxiyC/Pv7xfmVBWm1JrEcXJF2pk4D9BVMUZtZvXbe9Ufnfggwc/0CSqeGnLzGTIQKiNuCowXwz4TbaBrcGpK0UxeUrt2eOin92dlJo/d1wVZfA+j/1wkFRzkMluNqfYl9jhq5a2VMG9evP97BUGsonUDUD5MQ+xgtYXbFl2Dgl5uxlJNXJAPtwyAzmbjbh1E3qNT2exYjJN62O27OQfjQntdT/LLkLEUu6tRd0KvN3AK1JKapEuI+K1rmFZJW9nLN8IzE+N/5ufHfQqQEF7aHSnfvEsWhsRYpglbQkjMcdAgjUmlmdoKwyrj9ZOyLjfdF9PIsD6GKR/DDRCgutMhGCJhuiLswdFVaTeOdeUKRu4LvAuIInOXRRd5iA+RK2tFqiGD+o18REjgWRSEyRO8LKejU6EigdE0Afy4+Z6nilLetvgnNmc5h9bT6/QMpxHvM+SiD4g==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(376002)(396003)(136003)(346002)(230922051799003)(82310400011)(1800799012)(186009)(451199024)(64100799003)(36840700001)(46966006)(40470700004)(83380400001)(107886003)(70206006)(6636002)(110136005)(478600001)(54906003)(2616005)(316002)(1076003)(40480700001)(26005)(70586007)(336012)(426003)(4326008)(47076005)(8676002)(8936002)(7696005)(40460700003)(36860700001)(5660300002)(2906002)(86362001)(7636003)(356005)(82740400003)(36756003)(41300700001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2023 08:39:13.4212
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cbb60fd4-48ce-4bf2-163f-08dbffa4d03a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB78.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8266

Expose vfio_pci_core_setup_barmap() to be used by drivers.

This will let drivers to mmap a BAR and re-use it from both vfio and the
driver when it's applicable.

This API will be used in the next patches by the vfio/virtio coming
driver.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
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


