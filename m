Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBD713F07D8
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 17:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239832AbhHRPRx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 11:17:53 -0400
Received: from mail-bn8nam12on2057.outbound.protection.outlook.com ([40.107.237.57]:52161
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239967AbhHRPRw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 11:17:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aquGjUq+vYIkmPpK8ymX/OrG5IkpHuoOg9j1JeXzc/SapBLtZJzFbfLCKgUPJfm5FrXRNCk0W3vxLL/c/8hcYCBghaqBk9/zCARFSFKOlEbHVTFlv9YSUZJEdX/eTJ6kcRJgGNIrmOD8Q+zsTu5/098tgIFO0N7fbtztDth1FL2cdOSWVUoTWH8AEhZKIBSA0pXApim2h7B+rZKZRuc2zQKBD+ZXP027NPADTPoiITm6pEPKyYY+KRRzJYuFnjVcRQ59kBkyah57rehMMRt/PBa20aYaqI7+Rnuit87bQRWJIQ4j98Y3uIM5LmN1HrD/Jvo1v5/4iEzIXXGFC0NF3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kcj1CQb/KLuR/tiUaiRmpla1vhAM4j6iSk5Oq1trwDE=;
 b=HanR/rMaijuBpKE/VvtVUL9BL2wH8nSKuSQA4gQlSk5NMfnlJBpqUJoyQF3wHHCBxUE2lPi62mVO8ElOEzL5pGSfOKdVYuS9u3G2oei+h1MU3XHBuesNG8lbtLLv26WEBPFLhnrLA1zIrT5eMmf8LdRK2IcqVT3TLf53od+WDWAqjGbhVI4S2EADLNCKGgo6clIo5tjmPUpcR+ev2E88m+UyP2F9tsLe6zcQMtn9ppnqegIg2t9tU37/6zNpyiSM85HF6r+SWc/8DmYbdEoWKwFBIli/TIzXjbaSIHEhcFcLcA0YR7dmSRWpA6xBh/LvcBiCwzjwlhBhRSVnqT7U8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kcj1CQb/KLuR/tiUaiRmpla1vhAM4j6iSk5Oq1trwDE=;
 b=pb99QoES4r6Io4zBvTpeQBDZKdc5RHyuZEkXzBRLwb1YCBgblDE+V5BGXccoCkZkXZHHo9nO8xM1r3+MzmjPcJ0Rkx+Qjlij/bYUESNxkZkUcd4XoxdSqn/NUEIzV01s4QZLdjt9KvRKV0Y4Az4eWmGqdK1MCLsJzw+VI+0zoMo/lteq09+xskyAwd1sOK/yPedYolfiosGtRv1tadsobctsVg8NmjZ6q7oDiurSn6RnFNbIPpEMDX6+y2+6jVZHxaUaohxNLagcupyrLI1pA3ZAVpw48v8KdZZJnBaRslvH+Z20rVgQMXqfDHjuV4GxvCbBVAiEYDAKagd8IAf8Jg==
Received: from BN9PR03CA0581.namprd03.prod.outlook.com (2603:10b6:408:10d::16)
 by DM6PR12MB4531.namprd12.prod.outlook.com (2603:10b6:5:2a4::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Wed, 18 Aug
 2021 15:17:16 +0000
Received: from BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10d:cafe::db) by BN9PR03CA0581.outlook.office365.com
 (2603:10b6:408:10d::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Wed, 18 Aug 2021 15:17:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 BN8NAM11FT052.mail.protection.outlook.com (10.13.177.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 15:17:15 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 18 Aug
 2021 15:17:15 +0000
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 18 Aug 2021 15:17:11 +0000
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <bhelgaas@google.com>, <corbet@lwn.net>,
        <alex.williamson@redhat.com>, <diana.craciun@oss.nxp.com>,
        <kwankhede@nvidia.com>, <eric.auger@redhat.com>,
        <masahiroy@kernel.org>, <michal.lkml@markovi.net>
CC:     <linux-pci@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>, <mgurtovoy@nvidia.com>,
        <jgg@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <leonro@nvidia.com>
Subject: [PATCH V2 07/12] vfio/pci: Move igd initialization to vfio_pci.c
Date:   Wed, 18 Aug 2021 18:16:01 +0300
Message-ID: <20210818151606.202815-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210818151606.202815-1-yishaih@nvidia.com>
References: <20210818151606.202815-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 267751e5-d081-484d-7a97-08d9625b433e
X-MS-TrafficTypeDiagnostic: DM6PR12MB4531:
X-Microsoft-Antispam-PRVS: <DM6PR12MB45319FBCD85BE6D86E873A3BC3FF9@DM6PR12MB4531.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lCxqSWWWBjwsce4AIRzOmw5izIUOlJJxGB9oXzAOwyQLHZsNRKFT5qjupcCqD7cPx38+3YYWEz7qlkzK3oThhWFAg4/t4E5s85J/fkr5DjMDezNUnoU3diWAJxWlXWahpjrxgbzY0dB5lToJBD4IhZA9K2LLLasHT6j+6undCZ/M7if2HWwsN2N713LF5T7MsMJ31DkKZR1+V+munmmCIsz4ZTb3xhXMnPjTaPjIdogB69+iDhz51hlLi64sA7KU9rN9Rv2+NFvuQ8vbIBbXzuGN2rl1ZJpKPTHrVPlOcz/mI1n5NBanh5NLp37QJc1z8boEehC7sFqF1W2M0/kGBr/pxs/TknZTGWP+Z3Th6J2rb9nrL8I0pvu+zNISPT2bFf+6SRZEcDBSzmYlxICviqHpAk1v24nBgdAkyzTg63BriW6/CbNKG/fFohbL2PKSaHDboGBO37MOxmT6UdNtn81yWEoWp/zmZOhQbapat5nTi/bJopl2WxAcUajqLYLvsIp+qz3T9Xy5AFhU3Nx55ICxG1fLamQIf8yTCdAESdNw6u6V4WHdnpFyoqplY3TNOpa0621wTzl/7GHE97QUH1SNA6QfeSdtzTjkdZh+UQaXn8g1k5e7v4KmCJWPV5vsInf9kICothxDupMHF9MAZC5bB8Nj/McsWVK/+Vd7tgCCTo9+nI7I8vUN9Lgz/PPFo7nr3p07JF8/3EC/crWWJ3C9e1oWIo7b1N1d9sDBaKQ=
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(83380400001)(316002)(86362001)(54906003)(26005)(36906005)(6666004)(110136005)(36756003)(508600001)(186003)(70586007)(82310400003)(7416002)(4326008)(5660300002)(36860700001)(336012)(107886003)(7696005)(2616005)(426003)(7636003)(47076005)(8936002)(2906002)(356005)(8676002)(1076003)(70206006)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 15:17:15.7680
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 267751e5-d081-484d-7a97-08d9625b433e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4531
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

igd is related to the vfio_pci pci_driver implementation, move it out of
vfio_pci_core.c.

This is preparation for splitting vfio_pci.ko into 2 drivers.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/vfio_pci.c      | 29 +++++++++++++++++++++++-
 drivers/vfio/pci/vfio_pci_core.c | 39 ++++----------------------------
 drivers/vfio/pci/vfio_pci_core.h |  9 +++++++-
 3 files changed, 41 insertions(+), 36 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 15474ebadd98..121a7296ac63 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -82,9 +82,36 @@ static bool vfio_pci_is_denylisted(struct pci_dev *pdev)
 	return true;
 }
 
+static int vfio_pci_open_device(struct vfio_device *core_vdev)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	struct pci_dev *pdev = vdev->pdev;
+	int ret;
+
+	ret = vfio_pci_core_enable(vdev);
+	if (ret)
+		return ret;
+
+	if (vfio_pci_is_vga(pdev) &&
+	    pdev->vendor == PCI_VENDOR_ID_INTEL &&
+	    IS_ENABLED(CONFIG_VFIO_PCI_IGD)) {
+		ret = vfio_pci_igd_init(vdev);
+		if (ret && ret != -ENODEV) {
+			pci_warn(pdev, "Failed to setup Intel IGD regions\n");
+			vfio_pci_core_disable(vdev);
+			return ret;
+		}
+	}
+
+	vfio_pci_core_finish_enable(vdev);
+
+	return 0;
+}
+
 static const struct vfio_device_ops vfio_pci_ops = {
 	.name		= "vfio-pci",
-	.open_device	= vfio_pci_core_open_device,
+	.open_device	= vfio_pci_open_device,
 	.close_device	= vfio_pci_core_close_device,
 	.ioctl		= vfio_pci_core_ioctl,
 	.read		= vfio_pci_core_read,
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 0d938544e5db..5ed2490d4f39 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -91,11 +91,6 @@ static unsigned int vfio_pci_set_vga_decode(void *opaque, bool single_vga)
 	return decodes;
 }
 
-static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
-{
-	return (pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA;
-}
-
 static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
 {
 	struct resource *res;
@@ -166,7 +161,6 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
 
 struct vfio_pci_group_info;
 static bool vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
-static void vfio_pci_disable(struct vfio_pci_core_device *vdev);
 static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 				      struct vfio_pci_group_info *groups);
 
@@ -252,7 +246,7 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
 	return ret;
 }
 
-static int vfio_pci_enable(struct vfio_pci_core_device *vdev)
+int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	int ret;
@@ -321,26 +315,11 @@ static int vfio_pci_enable(struct vfio_pci_core_device *vdev)
 	if (!vfio_vga_disabled() && vfio_pci_is_vga(pdev))
 		vdev->has_vga = true;
 
-	if (vfio_pci_is_vga(pdev) &&
-	    pdev->vendor == PCI_VENDOR_ID_INTEL &&
-	    IS_ENABLED(CONFIG_VFIO_PCI_IGD)) {
-		ret = vfio_pci_igd_init(vdev);
-		if (ret && ret != -ENODEV) {
-			pci_warn(pdev, "Failed to setup Intel IGD regions\n");
-			goto disable_exit;
-		}
-	}
-
-	vfio_pci_probe_mmaps(vdev);
 
 	return 0;
-
-disable_exit:
-	vfio_pci_disable(vdev);
-	return ret;
 }
 
-static void vfio_pci_disable(struct vfio_pci_core_device *vdev)
+void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	struct vfio_pci_dummy_resource *dummy_res, *tmp;
@@ -479,7 +458,7 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 
 	vfio_pci_vf_token_user_add(vdev, -1);
 	vfio_spapr_pci_eeh_release(vdev->pdev);
-	vfio_pci_disable(vdev);
+	vfio_pci_core_disable(vdev);
 
 	mutex_lock(&vdev->igate);
 	if (vdev->err_trigger) {
@@ -493,19 +472,11 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 	mutex_unlock(&vdev->igate);
 }
 
-int vfio_pci_core_open_device(struct vfio_device *core_vdev)
+void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev)
 {
-	struct vfio_pci_core_device *vdev =
-		container_of(core_vdev, struct vfio_pci_core_device, vdev);
-	int ret = 0;
-
-	ret = vfio_pci_enable(vdev);
-	if (ret)
-		return ret;
-
+	vfio_pci_probe_mmaps(vdev);
 	vfio_spapr_pci_eeh_open(vdev->pdev);
 	vfio_pci_vf_token_user_add(vdev, 1);
-	return 0;
 }
 
 static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_type)
diff --git a/drivers/vfio/pci/vfio_pci_core.h b/drivers/vfio/pci/vfio_pci_core.h
index 7dbdd4dda5c0..ffaf544f35db 100644
--- a/drivers/vfio/pci/vfio_pci_core.h
+++ b/drivers/vfio/pci/vfio_pci_core.h
@@ -210,7 +210,6 @@ static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 void vfio_pci_core_cleanup(void);
 int vfio_pci_core_init(void);
 void vfio_pci_core_close_device(struct vfio_device *core_vdev);
-int vfio_pci_core_open_device(struct vfio_device *core_vdev);
 void vfio_pci_core_init_device(struct vfio_pci_core_device *vdev,
 			       struct pci_dev *pdev,
 			       const struct vfio_device_ops *vfio_pci_ops);
@@ -228,5 +227,13 @@ ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *bu
 int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma);
 void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count);
 int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
+int vfio_pci_core_enable(struct vfio_pci_core_device *vdev);
+void vfio_pci_core_disable(struct vfio_pci_core_device *vdev);
+void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
+
+static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
+{
+	return (pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA;
+}
 
 #endif /* VFIO_PCI_CORE_H */
-- 
2.18.1

