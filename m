Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3073D13CE
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 18:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbhGUPhU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 11:37:20 -0400
Received: from mail-co1nam11on2061.outbound.protection.outlook.com ([40.107.220.61]:3265
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233381AbhGUPhR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 11:37:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GSdHcNPaYhwikkNnwMu9Lt+vlp9/pB1L9tKTAsW0Q13z18vDJGkIeYpyn/eoDtea8L/nf+ssLNlYCCwgNbIH7CdIWoZjbsKWLeDm4CLqttPD/AtOGYQ40OUhX56JL3CuNUraZKXFJ2jfQJw3njxd96cuce8XiCwRiukEOXcfoYY6eO2yWSrcMzgVUI1bBXhgHfz/SB2iP7iNfTk3T7WGJD5DaJAQ1I3pA4bllGcO0pInZXSStVv+bWBJg71qFQpiRnVXDzod461nYaZ84LDun9OzGpiwHqZWYtyL1kTJbUY8HOwOLT/swx+XblO2goAg3swM40ZdVHiYrxbZhjRACg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=32WLTRKMGrIrLzolYJLnEjsSdSdUTIG0lg+xd/4uBmY=;
 b=Kq84iIOaG0pBQ71qb4l3El/sEzQhAMmiJza2vATh+n9ih5Lz7cwqt62KEL7FXvx971ZKjGEzMF/+iHBFvxYmD+fO5ug4eVdR4CLhNNf757XBVF05cfEJdhlgvHK9kFC6zuc5eUNKDz8vB+TCtP8JQ5uUkCbV0xebg6X+sy5Z5WQl7B9a7ThU8udtpNU0WDwAC6UHts/oL1+itQ+0is6hcA0YL5t0tHQwv/7Urxplakiyx+uD435iolNXBAaEi7UM3QvQBtrr/e5JZZyrp3/BeiMv6RR8Db6F8guyVIqFXm+n0a8j5yckAawQdSQ5mSP4RSF/FWdEdkli5ydv6gyZmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=32WLTRKMGrIrLzolYJLnEjsSdSdUTIG0lg+xd/4uBmY=;
 b=txIx9NgZcKuRDSeBIRRqPYZZ5VKvjN1vGoGOWbAzT2fffugtpau8YgdUV+nNFslPF9ye13EzeY18pfuHHA9N0IjTx6e2fu0THAZEYDb3nCSu4uWJZ30Wqxezg6SmxjgbLWEUicqPO1Va2uKDuJIuF3mQDy+Yuk+Do0rRjFX768r0DjMicdb1BUtJkX09mF7IXSDF9WU0SUHqaVR3AJLrwI73DL+jlR85irJEuilGKx7DrZEPr71SEb5Njrg2ZHZSiVvqOmFLhPYhZGp9rYrsxhuc5MtGR+SzGhAlS3aufOAg9dS2hkJrAI/+Eyg4/1kxk0h1Tcqnu39G7YTi+k1qsQ==
Received: from BN9PR03CA0017.namprd03.prod.outlook.com (2603:10b6:408:fa::22)
 by MWHPR12MB1791.namprd12.prod.outlook.com (2603:10b6:300:113::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24; Wed, 21 Jul
 2021 16:17:52 +0000
Received: from BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fa:cafe::dc) by BN9PR03CA0017.outlook.office365.com
 (2603:10b6:408:fa::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23 via Frontend
 Transport; Wed, 21 Jul 2021 16:17:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT054.mail.protection.outlook.com (10.13.177.102) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Wed, 21 Jul 2021 16:17:52 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Jul
 2021 16:17:52 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Jul 2021 16:17:48 +0000
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
Subject: [PATCH 07/12] vfio/pci: Move igd initialization to vfio_pci.c
Date:   Wed, 21 Jul 2021 19:16:04 +0300
Message-ID: <20210721161609.68223-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210721161609.68223-1-yishaih@nvidia.com>
References: <20210721161609.68223-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a0d470b-93e0-49bb-9da2-08d94c631748
X-MS-TrafficTypeDiagnostic: MWHPR12MB1791:
X-Microsoft-Antispam-PRVS: <MWHPR12MB179174D1C81A3588B2B56C68C3E39@MWHPR12MB1791.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DuvsKjVWlWORjCmbp4K9zY1dlFwQaKDp4gS/4T2GdIqi0LqbiIA+v6cOOzA34N+rLKVlXULXCK8Txr+tgp+sQ9uYNEIeU4Shaip6jqPs8eAc4sWqzt1ycRF0rwr88sGnvdXLuwEPHiAB5grGzxto37iQFwjThZKSwyRdOKQdMT8s17JvkeKbdnj5dExSsn+xTyY/mCP4hZQFxmN89RRXBERWI7Pre0Oiktp+Zn8iZaCuMRQe6LwpAO00MwwpS4LKwbA6Z6ulOprDWBscQOQhNmU5NxWcBx1b76/tMSOROtfFQiOMmWBwiHVYgdXts1ssVqFhCx/pa+0Hi5OEtT/cgVI4k6YiNbyHrP+bN87x2/Ge5HqnKOwIccEx8poIhR7FvaPq7CQun/8PquEZejxqcSvdb8Y7f5EmzQw1WpINmUIDTGuNwwdED+X0/GCzmeMYN6G6D1/Ffz8xEa8FnYf30fKf/gcUWzFWbaXTZL1jxAGvTRaxpCL4ieuN0H59AOXnXDztf3E6MqTaJ4VEEMNOt2a1ouv5c5yFhm+5VvPf2MBdqLPyMwUMs+G6Pl6YxCDIb6iCd/bbfX6s+6MkEqY8ZI86DGh/GQosHq8sBRHLI45YWj3Yp6crAATd9h+/WsglVC2xh744UzAtoRNLCuhUo01di2a84OQbNZMqmohqn0EnE2kiUqIyftT2yT+mxM5iFAChAR4RXqmkq2q1mNzztCyAf51GsoeHU8W2EIL2Kd0=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(376002)(136003)(36840700001)(46966006)(36906005)(316002)(86362001)(47076005)(36860700001)(70586007)(70206006)(82740400003)(478600001)(426003)(336012)(2616005)(7696005)(186003)(26005)(356005)(107886003)(83380400001)(2906002)(110136005)(54906003)(8936002)(6666004)(4326008)(5660300002)(8676002)(7636003)(7416002)(82310400003)(36756003)(1076003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 16:17:52.4064
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a0d470b-93e0-49bb-9da2-08d94c631748
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1791
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

igd is related to the vfio_pci pci_driver implementation, move it out of
vfio_pci_core.c.

This is preparation for splitting vfio_pci.ko into two drivers.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/vfio_pci.c      | 29 +++++++++++++++++++++++-
 drivers/vfio/pci/vfio_pci_core.c | 39 ++++----------------------------
 drivers/vfio/pci/vfio_pci_core.h |  9 +++++++-
 3 files changed, 41 insertions(+), 36 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 4ccfbac0797a..801f66454e70 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -83,9 +83,36 @@ static bool vfio_pci_is_denylisted(struct pci_dev *pdev)
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
index 8323acc5d3b7..811601425798 100644
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
 static void vfio_pci_try_bus_reset(struct vfio_pci_core_device *vdev);
-static void vfio_pci_disable(struct vfio_pci_core_device *vdev);
 static int vfio_hot_reset_device_set(struct vfio_pci_core_device *vdev,
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
@@ -481,7 +460,7 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 
 	vfio_pci_vf_token_user_add(vdev, -1);
 	vfio_spapr_pci_eeh_release(vdev->pdev);
-	vfio_pci_disable(vdev);
+	vfio_pci_core_disable(vdev);
 
 	mutex_lock(&vdev->igate);
 	if (vdev->err_trigger) {
@@ -495,19 +474,11 @@ void vfio_pci_core_close_device(struct vfio_device *core_vdev)
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

