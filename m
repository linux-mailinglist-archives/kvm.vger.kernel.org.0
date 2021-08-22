Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A008E3F3FF7
	for <lists+kvm@lfdr.de>; Sun, 22 Aug 2021 16:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbhHVOiK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Aug 2021 10:38:10 -0400
Received: from mail-co1nam11on2047.outbound.protection.outlook.com ([40.107.220.47]:63136
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234275AbhHVOiH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Aug 2021 10:38:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MTXt743x9WxP51qi3QYefoGyvwwX33USqSFj878f08tQHdiXlV50iorWaBpnvsLOwWzbNeoppfdnTLD5TwRXmlv20g2Ztq9SPCmo7ogNWxwRxLdLzBIV+9nZFiGmcRdM9rq4gTlI3ILq1v5bJq2n+2DxiDIs05u4mX6Nfq59GZmDCGspz+PNYbSL++RQ2Udw2F7i2nbX8HGnzSDz2Q8IqZboYkAbfCKK50OmvA1buMu5F2c8qXkDg4PT1l9IEQWKQV6pypCR0kUCAr8UYIjPgdeQrd1NxrXsoInsCF7Fz6kda21PEQge+mgon9jgXiQuSX2zaXC6wGXN++0owae7BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BQCexz9A3AOmXN51nxuZ/OMbV9Qxk1YkmRaoDyAEGCE=;
 b=b3ed89c56HeRly5WUoX37+ytilTHEPqA8zpHnmW2au+5pSQm0lMBZX2vzyYK5W4ea5R+Md/yqKtPm7cSEXkI3uRnZkylA80C8dFqmh0ZE9PY1k6ykzzHvMnV2Cwa8cZe7tzS/9HESvRBNWcK3sj2HPyv4+LQipgwEBe7Hi4Y0C1w6/Y6VBPVIdDFFQ4wp9m4qK0v4V4C2BbFLy8vlfDQsuyXFahIim3iqURw6adTJI/+b45bn9zh217SSv2ckZ6DM8elSyv3IahppHWaBQnl7Qq1zaDj1t5WSTzQ7mlv4sekqTQOV4+5Pau4d/y++RZb9S0UlXBm1yjqBzDIhLjsMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BQCexz9A3AOmXN51nxuZ/OMbV9Qxk1YkmRaoDyAEGCE=;
 b=XvBp3rMzt43vkfpo5spS59d12KfuhSM7NfgF9temsMnlgnrwfgSNW+M4lYJ3JgyZE1GVGaM14HHhAoPa+0qeLrFi9RI55itcCIV5ZMcOuKbEE0Js5s4xUpd4lsddDCdf9zw4uOH+rzn4FQqtY/ohmLsGY1dfgA+G4KfwkI/m0rI86w/a5o66fufoC5dqfCaPZxXcGOjsb8pcLUG9VZSSL3qtrYPROkWiR1kM7FTK7nPkRm0WJYe6oEouEA/pjx3VwDa5L55kXJcT9CCdXv3WDnN2Wml2i+855o2asQ9LK7NxbFhsl4QIP1u+0FIuliu+EJq2+C4MW2D3P73lzafdog==
Received: from BN8PR16CA0028.namprd16.prod.outlook.com (2603:10b6:408:4c::41)
 by BN8PR12MB3473.namprd12.prod.outlook.com (2603:10b6:408:65::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Sun, 22 Aug
 2021 14:37:24 +0000
Received: from BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:4c:cafe::c9) by BN8PR16CA0028.outlook.office365.com
 (2603:10b6:408:4c::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend
 Transport; Sun, 22 Aug 2021 14:37:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 BN8NAM11FT029.mail.protection.outlook.com (10.13.177.68) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4436.19 via Frontend Transport; Sun, 22 Aug 2021 14:37:24 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 22 Aug
 2021 07:37:24 -0700
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 22 Aug 2021 14:37:20 +0000
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
Subject: [PATCH V3 07/13] vfio/pci: Move igd initialization to vfio_pci.c
Date:   Sun, 22 Aug 2021 17:35:56 +0300
Message-ID: <20210822143602.153816-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210822143602.153816-1-yishaih@nvidia.com>
References: <20210822143602.153816-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b687916e-956c-4179-ab4f-08d9657a5bc2
X-MS-TrafficTypeDiagnostic: BN8PR12MB3473:
X-Microsoft-Antispam-PRVS: <BN8PR12MB347305450874C668284F663FC3C39@BN8PR12MB3473.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +cmbBIXpPRq3SU4m4LLbvQWbDh8NZ0qEz01gYh7Au778Xz4Dyc/347pD/ktV+ts1bQYPvxb9ZM+qsY/3Z/QOt8OcPJubRqOKnfQa29tKLwQ6Da4JDUxEKihWlvLmFcLV8Pe0tBiChj49IABrtU2rHLeOaIm+I1/9+TNh5jfCxKnEdEA4VdwIezgkCGXTdGCUT0lEvMjg54LdER4BMLHPCVK3yne/A47halt4yKwQuJvErln2qdd/HDZHrD+9Pmf1SoYF9Dt3oKzzzbRhGQW0uZBIsB7fI+oXibPc85r8GT/oyuLRoo0QnpMgRyRLJWDoPIEL20PfHXwkXEJHKukaApekAoSPLmIYoUiC9PPGsszZGru3KqR92Xqo4YNuUTz+UfD4g54IA5gSThBcQNJ/S6EFbTeWdMrEgf0ekFtBdquIc4QV68R5n6f2xfib+/zzCJJTzIR7w3uB0LlHU/R0rcQ4ZDh2DarvUCtbLychVyinMNe9ZK+Dggl06qzBy8Z80PHyBTr8AYhukDcCo0ETysFzPjZokm6jljcJCDdx3UmkCmegWJbwyZxBW2YR5B0VkVA9yDFE/iAV/qcnDJbEf8rqyGg733CbcHDoExcKj8K+nl2sBF0b6jKQrZmB4LACzU/xGI4qZBVnzt71F4Gpr5FEl0yyr8+uVOqDN77geHAGu0RSMeLNFsOfC0B5ELgi0EJH1/wyCubQ3rUDrIrJxXeuZFIjVE41eWFckMA/Gz8=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(136003)(396003)(46966006)(36840700001)(26005)(36756003)(316002)(86362001)(70206006)(54906003)(186003)(8936002)(5660300002)(356005)(2616005)(82740400003)(426003)(107886003)(7636003)(70586007)(110136005)(2906002)(7416002)(82310400003)(336012)(8676002)(6666004)(36860700001)(47076005)(478600001)(1076003)(4326008)(7696005)(83380400001)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2021 14:37:24.7906
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b687916e-956c-4179-ab4f-08d9657a5bc2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3473
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
index 87d1960d0d61..d4b3a53ee2ed 100644
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

