Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30BD356BC9
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 14:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236844AbhDGMJs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 08:09:48 -0400
Received: from mail-dm3nam07on2060.outbound.protection.outlook.com ([40.107.95.60]:17536
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235093AbhDGMJl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 08:09:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UIYaZhq/6W20fnA0qgYD15oAdmA9t4TInEEqG9+V1ACyUwTfl0K5pCZY2cQWaNj/lLQ5UFCXHz+AoSDnztjfAn5cf4C/qV3WPi1rPhykkuWO6ylvUbQd2Vh4gT3jSOKkLTgzyd40H8wqY2NPYU2QJVzdU+1ySacH1QYX3c5tzWlFIRhdW0Qii5bCR6X1HMMPDgb8WqJf5yLLhwCq07WXIGP8qNqZSldh/p6F00fAnOFD/aZVZvPcO0/Po9FYVz+ed9LT93ASCB/hb0J6LYSpK8pOBtNAsSB0SiWPrANIUr+fypMmapMv5NhZQoDpxLzzrmcXAtqKHvLVpXoht040PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a0EBD+tNxua7zQadLmEJYcvQW9eBq9/zvN7Jf2FQjKQ=;
 b=IrAYkSeAoVwjkIQA3M2OTi3ny/yudbZCUFeYxvUtbZSHvYi9jdaLjT29HxxNWnH+tfjCtpd7cDYAEJYXWliXkDcJVWvLInW3iUx7b//94+FTbzpEoAHpgWdccnC9FID9GjeviNMDLKE0wMLNBuWF7zLJZ9V6C9ranCXArxmQ6ge5IXan++9RyJTq8ojuGcT/nFkFNpV44fPnE8EC7AhBf+QJfoGSn7LRcaLXMYdMMV9R+qucKc4NClukdB7Nk7C3yHDxHNGe6fNlEU9dZK0lLTGTwKsXIQeLgzFzfdEadqF1LuW4oADjJ+kOxKnIO70HUHcygeery/rvDoAwj52o9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=lists.linux-foundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a0EBD+tNxua7zQadLmEJYcvQW9eBq9/zvN7Jf2FQjKQ=;
 b=pStg1+X4mArKwrbBfC67ocfHWzBRMKlcu12+Ty1WYcPBLgI7x57+EtmzXHw+yQsVcVWb02Sai/+4YIKrE8Fz1ltq1+omaekXiVTa0/tEXiDddUTzk3h0OCS7ag+lfLMjloo6n+sFgv5k6nJ8SBOHzZyVmfwB4knujNXOfGDjiJByvhTbhVTKW8C5IQPIFHUIl6qmB0A7V6yuEsniGnSibKD+WHzmVcjCet2hj9kh41CdQNGBUFoTfzD7hnJDkkmGbkOWDS8xABrAUnsXvssIB13N9pUWXpig5SYooGriw1oELEJPVcZ6ZLA7KZG0S2ZbpD6W+lQnQubyTRQVN33NaA==
Received: from DM5PR06CA0081.namprd06.prod.outlook.com (2603:10b6:3:4::19) by
 BYAPR12MB4696.namprd12.prod.outlook.com (2603:10b6:a03:9d::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.28; Wed, 7 Apr 2021 12:09:30 +0000
Received: from DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:4:cafe::78) by DM5PR06CA0081.outlook.office365.com
 (2603:10b6:3:4::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend
 Transport; Wed, 7 Apr 2021 12:09:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=pass action=none
 header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 DM6NAM11FT004.mail.protection.outlook.com (10.13.172.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Wed, 7 Apr 2021 12:09:29 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 7 Apr
 2021 12:09:29 +0000
Received: from r-nvmx02.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 7 Apr 2021 12:09:27 +0000
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
To:     <mst@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <jasowang@redhat.com>
CC:     <oren@nvidia.com>, <nitzanc@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>
Subject: [PATCH 2/3] virito_pci: add timeout to reset device operation
Date:   Wed, 7 Apr 2021 12:09:23 +0000
Message-ID: <20210407120924.133294-2-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20210407120924.133294-1-mgurtovoy@nvidia.com>
References: <20210407120924.133294-1-mgurtovoy@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a461cc55-12a7-4fe6-e035-08d8f9bdff4a
X-MS-TrafficTypeDiagnostic: BYAPR12MB4696:
X-Microsoft-Antispam-PRVS: <BYAPR12MB4696AE1413ABD7B9F4D77BEFDE759@BYAPR12MB4696.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0IQ7vUdJzmkK5SCq9PFASTKGxUQRjdF/MLzWvow4nmQ/pt5IOyDCr+J7IUmhZT86MTyJSP+yq2VJh5JXAM+jJquPfBTdRiUCohyclPA9eldWOXxsvU1NkVnffrvLzRLmGhp6P13lrwPKmXCsubzkJyZum7JLWbVCFV2k4/mQllD6mg0A5dpyEbr5h+DL+f18W5PdKbSkX/G7ro5BbuxtatwXsA0gATftJbFcNfhGOAwxUcZ7TGTnIkylZALMFW5agNb+AJ//yBpUQ+MDu9bjmHM4par0YnXLbC9M2tUoJIwd/Fslbj3ZC4FFtDtTdZ5hsngVw6K1T8qW9gri54K6mz1mS7f4LyOggRs9Fl8Dmh8xJZZjp2npeYVGlhoR1Y6UY/Tu0vY0C8u4BQkPCM3ot7L6Z0lH6V7xpovirtbEA/+BZsolAD9/DKw1ZkEEixTMzKuQ5kF3tO/HAcc+6YG+RM3PkRpTXMUux2+x+UVZhDCOVGcUEJaie7l3VCdG+4DgwJ4Urvbg1jZ5SKT3kXjBMsS7uzinNCQm/pR+pcwP/3SNXK3saPfB8FlGdBjPOsgH8cASIoRMo+/o0MLPdTEf3RHkbF2CQZpbVrJyJzNX2JV/2N6IruzAWyG2brVmYtmLf/zGaonE46vYWo3nFqxdHU9vt5SvCKrJGxcHodfoD+8=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(376002)(39860400002)(36840700001)(46966006)(70206006)(5660300002)(2906002)(8676002)(8936002)(47076005)(82310400003)(86362001)(336012)(26005)(6666004)(1076003)(186003)(70586007)(4326008)(110136005)(478600001)(54906003)(36906005)(356005)(316002)(83380400001)(426003)(82740400003)(107886003)(2616005)(7636003)(36756003)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 12:09:29.9098
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a461cc55-12a7-4fe6-e035-08d8f9bdff4a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4696
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to the spec after writing 0 to device_status, the driver MUST
wait for a read of device_status to return 0 before reinitializing the
device. In case we have a device that won't return 0, the reset
operation will loop forever and cause the host/vm to stuck. Set timeout
for 3 minutes before giving up on the device.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/virtio/virtio_pci_modern.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index cc3412a96a17..dcee616e8d21 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -162,6 +162,7 @@ static int vp_reset(struct virtio_device *vdev)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 	struct virtio_pci_modern_device *mdev = &vp_dev->mdev;
+	unsigned long timeout = jiffies + msecs_to_jiffies(180000);
 
 	/* 0 status means a reset. */
 	vp_modern_set_status(mdev, 0);
@@ -169,9 +170,16 @@ static int vp_reset(struct virtio_device *vdev)
 	 * device_status to return 0 before reinitializing the device.
 	 * This will flush out the status write, and flush in device writes,
 	 * including MSI-X interrupts, if any.
+	 * Set a timeout before giving up on the device.
 	 */
-	while (vp_modern_get_status(mdev))
+	while (vp_modern_get_status(mdev)) {
+		if (time_after(jiffies, timeout)) {
+			dev_err(&vdev->dev, "virtio: device not ready. "
+				"Aborting. Try again later\n");
+			return -EAGAIN;
+		}
 		msleep(1);
+	}
 	/* Flush pending VQ/configuration callbacks. */
 	vp_synchronize_vectors(vdev);
 	return 0;
-- 
2.25.4

