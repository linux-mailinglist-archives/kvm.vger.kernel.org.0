Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9404E3D13B9
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 18:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233277AbhGUPhC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 11:37:02 -0400
Received: from mail-bn8nam08on2057.outbound.protection.outlook.com ([40.107.100.57]:59361
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232964AbhGUPhC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 11:37:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k+v1FgH+QYL49nG0WyKD3DpBeGan1Zu6rNA8Tj31YtW5VyNOkfzN6b8/15+8zkZMTuLcNO48PPWwUBItKO/fIvhkwsNCz7PqDfMSSNk7Jwno3ciahqb7bzNN6Ybj1vwBtZT3Uf967wZYjQsaj3DLjZ2LESvvr1GDstCW7wKRD+j+e7Ps27nmKpfZdZuJBKN8XbhmR5bAge7FVZEa8Jd+NF5rxn3gNare0ppZ6bRLRWqhtwm2sfTkO5XeIpBoyVl5ok4slSIUik4KNse9FSVxuLJsdmv9uImRiiYl0epAyPbBr+sht7xuR2Q9s0EbZFzZEOf3oLDQU+77ZcNjfD9+NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gwD54chV8+GQ8z2+BF1Hq1UQ5CezBP0qxVjXdo2rKR0=;
 b=KkYKOiPEWai6hGRiGxsvO/OLsLyTghqdGemkNkWIodL15cRm2/KvHnFo6yWb1m4DQZsgEmFtow6GjDy7gO+GYjdWvLmobPEnHoIUZ1X1crZFPyJB+E0tgo5QpKsKsJpk6D7iJgxUsBvKQp8CEXE7jdsLnW+kopVrHsPIMlZxLr/yjVwxFoqZcfq7EETKFwbF0QWaS9iqqRyKidsVAG2FWamhB3u9j0sDLfk65bO3llZhpAI4KL7P3T6zntZPr9nA8v2r5Ci1G3uYKgV3ks+wIYf1PCWkW0CzuQ3ZgHRG8Phn6qyuBIXKjwejQeG/fnGpbSvUc1AnnqWN1fSIna7zYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gwD54chV8+GQ8z2+BF1Hq1UQ5CezBP0qxVjXdo2rKR0=;
 b=bpF9aQ6b8+of5KEe5JX6wJEU40MmViYHLfjjmnJdwL+wqs00u9uCfVunT6+P+cDl/UIdP2EWszuD90lT2HiwDEfTU0Is4+ayk9lVKeBO+P5N7oWvAXPM8T/1iuShtHx3bujibCN6TvM1XWX8XBwqQlkOL1pjWA0cofqaCjPiziQ07v3wqpApiZGDP6OWsWVscfO/DSn95Cfm2jSLTFnbS1TXt08wGTlqT08mJg3HJyMa4pBQnOD+iDVIxnUC3450amaSfRVmqYXqqziqzKpnbNGyA54Fx8BwHaHrCb9lFFCsWFJSWFkni1prqhjTZVvE/t7T6QNy/22OJeULc71unw==
Received: from BN9PR03CA0960.namprd03.prod.outlook.com (2603:10b6:408:108::35)
 by CH2PR12MB4954.namprd12.prod.outlook.com (2603:10b6:610:63::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Wed, 21 Jul
 2021 16:17:35 +0000
Received: from BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:108:cafe::fc) by BN9PR03CA0960.outlook.office365.com
 (2603:10b6:408:108::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend
 Transport; Wed, 21 Jul 2021 16:17:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT023.mail.protection.outlook.com (10.13.177.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Wed, 21 Jul 2021 16:17:35 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Jul
 2021 16:17:34 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Jul 2021 16:17:30 +0000
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
Subject: [PATCH 03/12] vfio/pci: Rename vfio_pci_device to vfio_pci_core_device
Date:   Wed, 21 Jul 2021 19:16:00 +0300
Message-ID: <20210721161609.68223-4-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20210721161609.68223-1-yishaih@nvidia.com>
References: <20210721161609.68223-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7cad3d36-3fc7-4c41-a465-08d94c630d2e
X-MS-TrafficTypeDiagnostic: CH2PR12MB4954:
X-Microsoft-Antispam-PRVS: <CH2PR12MB4954270547328A4D3B81CA20C3E39@CH2PR12MB4954.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FNDTLU/8J/ySFzngvnEwD9Rc57zl5ZS2UGT/CZ8CFcQtk1dzIAhdus4E1rLlbWixONEqAc01z+ERKziqrG1KuRnFUGFFw/hhKOCEtVRsx4IF4+0S0D+wqS45Eg98UYJMOcTq/1uYFeG4J51fsADrzNdGscCkPwr/bub8PU4ff1xmikfzfXPcWC/SUr2yeKK56v8Jh8PujH4tg2lAcBRHe7LnaWrDTXLFjOSTTCJIt+VdV6AdoY6EYLBdfzNZqfCwSRkDr/wRok6oVVKSr1OQqY9YsH51N3Tw2+A5HEOJycq6YZJq9cRYrDLgE6cd+Tz25wJ+Z170qJ/q48bMM9o+ofn63kGcx2a5fdtxxXPcHqYvWJe01qavoLrW6GEuIUo3XEXCvCpLEbfW2z2s3owvltvOkeRx3fz1D5paNmZnGrQJs/6d957J0JJL0sNoDika6LOwhtkkpvaXLVVETdakgEC3XCg3xgqj/GQI5enjcLR7SjGWdJl470ZcWtCR+/n3yLdGUQ/kKwkg0QijR3ZDWUX1Umc4kw3deaF+1eWg0VfCkHa5PXi0z0szpSQFq9Nj4BvBHUtjaApytwjEVej5p2xWpmQPftRJQ5otL77fV+slQbjNpSjqzHDB3QneLp8a3TO8xxyTqYKFnaKw2ezzgw0e/kslyzGnbSZ+cCGjKzb+4EyuM/TGmfBhQVDjlKR+XmnhynGa7xwm6bpJGtBETly9PKY6+SD8oM99jgIwaRk=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(396003)(376002)(46966006)(36840700001)(5660300002)(36906005)(82740400003)(336012)(7416002)(82310400003)(36860700001)(8936002)(7696005)(107886003)(186003)(356005)(54906003)(2906002)(4326008)(83380400001)(86362001)(26005)(6666004)(316002)(1076003)(110136005)(70206006)(7636003)(426003)(478600001)(70586007)(2616005)(36756003)(8676002)(30864003)(47076005)(2101003)(579004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 16:17:35.4100
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cad3d36-3fc7-4c41-a465-08d94c630d2e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4954
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Max Gurtovoy <mgurtovoy@nvidia.com>

This is a preparation patch for separating the vfio_pci driver to a
subsystem driver and a generic pci driver. This patch doesn't change any
logic.

The new vfio_pci_core_device structure will be the main structure of the
core driver and later on vfio_pci_device structure will be the main
structure of the generic vfio_pci driver.

Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_config.c |  68 ++++++++--------
 drivers/vfio/pci/vfio_pci_core.c   | 123 +++++++++++++++--------------
 drivers/vfio/pci/vfio_pci_core.h   |  52 ++++++------
 drivers/vfio/pci/vfio_pci_igd.c    |  17 ++--
 drivers/vfio/pci/vfio_pci_intrs.c  |  40 +++++-----
 drivers/vfio/pci/vfio_pci_rdwr.c   |  16 ++--
 drivers/vfio/pci/vfio_pci_zdev.c   |   2 +-
 7 files changed, 160 insertions(+), 158 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 0bc269c0b03f..1f034f768a27 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -108,9 +108,9 @@ static const u16 pci_ext_cap_length[PCI_EXT_CAP_ID_MAX + 1] = {
 struct perm_bits {
 	u8	*virt;		/* read/write virtual data, not hw */
 	u8	*write;		/* writeable bits */
-	int	(*readfn)(struct vfio_pci_device *vdev, int pos, int count,
+	int	(*readfn)(struct vfio_pci_core_device *vdev, int pos, int count,
 			  struct perm_bits *perm, int offset, __le32 *val);
-	int	(*writefn)(struct vfio_pci_device *vdev, int pos, int count,
+	int	(*writefn)(struct vfio_pci_core_device *vdev, int pos, int count,
 			   struct perm_bits *perm, int offset, __le32 val);
 };
 
@@ -171,7 +171,7 @@ static int vfio_user_config_write(struct pci_dev *pdev, int offset,
 	return ret;
 }
 
-static int vfio_default_config_read(struct vfio_pci_device *vdev, int pos,
+static int vfio_default_config_read(struct vfio_pci_core_device *vdev, int pos,
 				    int count, struct perm_bits *perm,
 				    int offset, __le32 *val)
 {
@@ -197,7 +197,7 @@ static int vfio_default_config_read(struct vfio_pci_device *vdev, int pos,
 	return count;
 }
 
-static int vfio_default_config_write(struct vfio_pci_device *vdev, int pos,
+static int vfio_default_config_write(struct vfio_pci_core_device *vdev, int pos,
 				     int count, struct perm_bits *perm,
 				     int offset, __le32 val)
 {
@@ -244,7 +244,7 @@ static int vfio_default_config_write(struct vfio_pci_device *vdev, int pos,
 }
 
 /* Allow direct read from hardware, except for capability next pointer */
-static int vfio_direct_config_read(struct vfio_pci_device *vdev, int pos,
+static int vfio_direct_config_read(struct vfio_pci_core_device *vdev, int pos,
 				   int count, struct perm_bits *perm,
 				   int offset, __le32 *val)
 {
@@ -269,7 +269,7 @@ static int vfio_direct_config_read(struct vfio_pci_device *vdev, int pos,
 }
 
 /* Raw access skips any kind of virtualization */
-static int vfio_raw_config_write(struct vfio_pci_device *vdev, int pos,
+static int vfio_raw_config_write(struct vfio_pci_core_device *vdev, int pos,
 				 int count, struct perm_bits *perm,
 				 int offset, __le32 val)
 {
@@ -282,7 +282,7 @@ static int vfio_raw_config_write(struct vfio_pci_device *vdev, int pos,
 	return count;
 }
 
-static int vfio_raw_config_read(struct vfio_pci_device *vdev, int pos,
+static int vfio_raw_config_read(struct vfio_pci_core_device *vdev, int pos,
 				int count, struct perm_bits *perm,
 				int offset, __le32 *val)
 {
@@ -296,7 +296,7 @@ static int vfio_raw_config_read(struct vfio_pci_device *vdev, int pos,
 }
 
 /* Virt access uses only virtualization */
-static int vfio_virt_config_write(struct vfio_pci_device *vdev, int pos,
+static int vfio_virt_config_write(struct vfio_pci_core_device *vdev, int pos,
 				  int count, struct perm_bits *perm,
 				  int offset, __le32 val)
 {
@@ -304,7 +304,7 @@ static int vfio_virt_config_write(struct vfio_pci_device *vdev, int pos,
 	return count;
 }
 
-static int vfio_virt_config_read(struct vfio_pci_device *vdev, int pos,
+static int vfio_virt_config_read(struct vfio_pci_core_device *vdev, int pos,
 				 int count, struct perm_bits *perm,
 				 int offset, __le32 *val)
 {
@@ -396,7 +396,7 @@ static inline void p_setd(struct perm_bits *p, int off, u32 virt, u32 write)
 }
 
 /* Caller should hold memory_lock semaphore */
-bool __vfio_pci_memory_enabled(struct vfio_pci_device *vdev)
+bool __vfio_pci_memory_enabled(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	u16 cmd = le16_to_cpu(*(__le16 *)&vdev->vconfig[PCI_COMMAND]);
@@ -413,7 +413,7 @@ bool __vfio_pci_memory_enabled(struct vfio_pci_device *vdev)
  * Restore the *real* BARs after we detect a FLR or backdoor reset.
  * (backdoor = some device specific technique that we didn't catch)
  */
-static void vfio_bar_restore(struct vfio_pci_device *vdev)
+static void vfio_bar_restore(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	u32 *rbar = vdev->rbar;
@@ -460,7 +460,7 @@ static __le32 vfio_generate_bar_flags(struct pci_dev *pdev, int bar)
  * Pretend we're hardware and tweak the values of the *virtual* PCI BARs
  * to reflect the hardware capabilities.  This implements BAR sizing.
  */
-static void vfio_bar_fixup(struct vfio_pci_device *vdev)
+static void vfio_bar_fixup(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	int i;
@@ -514,7 +514,7 @@ static void vfio_bar_fixup(struct vfio_pci_device *vdev)
 	vdev->bardirty = false;
 }
 
-static int vfio_basic_config_read(struct vfio_pci_device *vdev, int pos,
+static int vfio_basic_config_read(struct vfio_pci_core_device *vdev, int pos,
 				  int count, struct perm_bits *perm,
 				  int offset, __le32 *val)
 {
@@ -536,7 +536,7 @@ static int vfio_basic_config_read(struct vfio_pci_device *vdev, int pos,
 }
 
 /* Test whether BARs match the value we think they should contain */
-static bool vfio_need_bar_restore(struct vfio_pci_device *vdev)
+static bool vfio_need_bar_restore(struct vfio_pci_core_device *vdev)
 {
 	int i = 0, pos = PCI_BASE_ADDRESS_0, ret;
 	u32 bar;
@@ -552,7 +552,7 @@ static bool vfio_need_bar_restore(struct vfio_pci_device *vdev)
 	return false;
 }
 
-static int vfio_basic_config_write(struct vfio_pci_device *vdev, int pos,
+static int vfio_basic_config_write(struct vfio_pci_core_device *vdev, int pos,
 				   int count, struct perm_bits *perm,
 				   int offset, __le32 val)
 {
@@ -692,7 +692,7 @@ static int __init init_pci_cap_basic_perm(struct perm_bits *perm)
 	return 0;
 }
 
-static int vfio_pm_config_write(struct vfio_pci_device *vdev, int pos,
+static int vfio_pm_config_write(struct vfio_pci_core_device *vdev, int pos,
 				int count, struct perm_bits *perm,
 				int offset, __le32 val)
 {
@@ -747,7 +747,7 @@ static int __init init_pci_cap_pm_perm(struct perm_bits *perm)
 	return 0;
 }
 
-static int vfio_vpd_config_write(struct vfio_pci_device *vdev, int pos,
+static int vfio_vpd_config_write(struct vfio_pci_core_device *vdev, int pos,
 				 int count, struct perm_bits *perm,
 				 int offset, __le32 val)
 {
@@ -829,7 +829,7 @@ static int __init init_pci_cap_pcix_perm(struct perm_bits *perm)
 	return 0;
 }
 
-static int vfio_exp_config_write(struct vfio_pci_device *vdev, int pos,
+static int vfio_exp_config_write(struct vfio_pci_core_device *vdev, int pos,
 				 int count, struct perm_bits *perm,
 				 int offset, __le32 val)
 {
@@ -913,7 +913,7 @@ static int __init init_pci_cap_exp_perm(struct perm_bits *perm)
 	return 0;
 }
 
-static int vfio_af_config_write(struct vfio_pci_device *vdev, int pos,
+static int vfio_af_config_write(struct vfio_pci_core_device *vdev, int pos,
 				int count, struct perm_bits *perm,
 				int offset, __le32 val)
 {
@@ -1072,7 +1072,7 @@ int __init vfio_pci_init_perm_bits(void)
 	return ret;
 }
 
-static int vfio_find_cap_start(struct vfio_pci_device *vdev, int pos)
+static int vfio_find_cap_start(struct vfio_pci_core_device *vdev, int pos)
 {
 	u8 cap;
 	int base = (pos >= PCI_CFG_SPACE_SIZE) ? PCI_CFG_SPACE_SIZE :
@@ -1089,7 +1089,7 @@ static int vfio_find_cap_start(struct vfio_pci_device *vdev, int pos)
 	return pos;
 }
 
-static int vfio_msi_config_read(struct vfio_pci_device *vdev, int pos,
+static int vfio_msi_config_read(struct vfio_pci_core_device *vdev, int pos,
 				int count, struct perm_bits *perm,
 				int offset, __le32 *val)
 {
@@ -1109,7 +1109,7 @@ static int vfio_msi_config_read(struct vfio_pci_device *vdev, int pos,
 	return vfio_default_config_read(vdev, pos, count, perm, offset, val);
 }
 
-static int vfio_msi_config_write(struct vfio_pci_device *vdev, int pos,
+static int vfio_msi_config_write(struct vfio_pci_core_device *vdev, int pos,
 				 int count, struct perm_bits *perm,
 				 int offset, __le32 val)
 {
@@ -1189,7 +1189,7 @@ static int init_pci_cap_msi_perm(struct perm_bits *perm, int len, u16 flags)
 }
 
 /* Determine MSI CAP field length; initialize msi_perms on 1st call per vdev */
-static int vfio_msi_cap_len(struct vfio_pci_device *vdev, u8 pos)
+static int vfio_msi_cap_len(struct vfio_pci_core_device *vdev, u8 pos)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	int len, ret;
@@ -1222,7 +1222,7 @@ static int vfio_msi_cap_len(struct vfio_pci_device *vdev, u8 pos)
 }
 
 /* Determine extended capability length for VC (2 & 9) and MFVC */
-static int vfio_vc_cap_len(struct vfio_pci_device *vdev, u16 pos)
+static int vfio_vc_cap_len(struct vfio_pci_core_device *vdev, u16 pos)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	u32 tmp;
@@ -1263,7 +1263,7 @@ static int vfio_vc_cap_len(struct vfio_pci_device *vdev, u16 pos)
 	return len;
 }
 
-static int vfio_cap_len(struct vfio_pci_device *vdev, u8 cap, u8 pos)
+static int vfio_cap_len(struct vfio_pci_core_device *vdev, u8 cap, u8 pos)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	u32 dword;
@@ -1338,7 +1338,7 @@ static int vfio_cap_len(struct vfio_pci_device *vdev, u8 cap, u8 pos)
 	return 0;
 }
 
-static int vfio_ext_cap_len(struct vfio_pci_device *vdev, u16 ecap, u16 epos)
+static int vfio_ext_cap_len(struct vfio_pci_core_device *vdev, u16 ecap, u16 epos)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	u8 byte;
@@ -1412,7 +1412,7 @@ static int vfio_ext_cap_len(struct vfio_pci_device *vdev, u16 ecap, u16 epos)
 	return 0;
 }
 
-static int vfio_fill_vconfig_bytes(struct vfio_pci_device *vdev,
+static int vfio_fill_vconfig_bytes(struct vfio_pci_core_device *vdev,
 				   int offset, int size)
 {
 	struct pci_dev *pdev = vdev->pdev;
@@ -1459,7 +1459,7 @@ static int vfio_fill_vconfig_bytes(struct vfio_pci_device *vdev,
 	return ret;
 }
 
-static int vfio_cap_init(struct vfio_pci_device *vdev)
+static int vfio_cap_init(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	u8 *map = vdev->pci_config_map;
@@ -1549,7 +1549,7 @@ static int vfio_cap_init(struct vfio_pci_device *vdev)
 	return 0;
 }
 
-static int vfio_ecap_init(struct vfio_pci_device *vdev)
+static int vfio_ecap_init(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	u8 *map = vdev->pci_config_map;
@@ -1669,7 +1669,7 @@ static const struct pci_device_id known_bogus_vf_intx_pin[] = {
  * for each area requiring emulated bits, but the array of pointers
  * would be comparable in size (at least for standard config space).
  */
-int vfio_config_init(struct vfio_pci_device *vdev)
+int vfio_config_init(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	u8 *map, *vconfig;
@@ -1773,7 +1773,7 @@ int vfio_config_init(struct vfio_pci_device *vdev)
 	return pcibios_err_to_errno(ret);
 }
 
-void vfio_config_free(struct vfio_pci_device *vdev)
+void vfio_config_free(struct vfio_pci_core_device *vdev)
 {
 	kfree(vdev->vconfig);
 	vdev->vconfig = NULL;
@@ -1790,7 +1790,7 @@ void vfio_config_free(struct vfio_pci_device *vdev)
  * Find the remaining number of bytes in a dword that match the given
  * position.  Stop at either the end of the capability or the dword boundary.
  */
-static size_t vfio_pci_cap_remaining_dword(struct vfio_pci_device *vdev,
+static size_t vfio_pci_cap_remaining_dword(struct vfio_pci_core_device *vdev,
 					   loff_t pos)
 {
 	u8 cap = vdev->pci_config_map[pos];
@@ -1802,7 +1802,7 @@ static size_t vfio_pci_cap_remaining_dword(struct vfio_pci_device *vdev,
 	return i;
 }
 
-static ssize_t vfio_config_do_rw(struct vfio_pci_device *vdev, char __user *buf,
+static ssize_t vfio_config_do_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 				 size_t count, loff_t *ppos, bool iswrite)
 {
 	struct pci_dev *pdev = vdev->pdev;
@@ -1885,7 +1885,7 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_device *vdev, char __user *buf,
 	return ret;
 }
 
-ssize_t vfio_pci_config_rw(struct vfio_pci_device *vdev, char __user *buf,
+ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			   size_t count, loff_t *ppos, bool iswrite)
 {
 	size_t done = 0;
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 51eb96375e98..6f95cd842545 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -121,7 +121,7 @@ static bool vfio_pci_is_denylisted(struct pci_dev *pdev)
  */
 static unsigned int vfio_pci_set_vga_decode(void *opaque, bool single_vga)
 {
-	struct vfio_pci_device *vdev = opaque;
+	struct vfio_pci_core_device *vdev = opaque;
 	struct pci_dev *tmp = NULL, *pdev = vdev->pdev;
 	unsigned char max_busnr;
 	unsigned int decodes;
@@ -155,7 +155,7 @@ static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
 	return (pdev->class >> 8) == PCI_CLASS_DISPLAY_VGA;
 }
 
-static void vfio_pci_probe_mmaps(struct vfio_pci_device *vdev)
+static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
 {
 	struct resource *res;
 	int i;
@@ -224,9 +224,9 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_device *vdev)
 }
 
 struct vfio_pci_group_info;
-static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev);
-static void vfio_pci_disable(struct vfio_pci_device *vdev);
-static int vfio_hot_reset_device_set(struct vfio_pci_device *vdev,
+static void vfio_pci_try_bus_reset(struct vfio_pci_core_device *vdev);
+static void vfio_pci_disable(struct vfio_pci_core_device *vdev);
+static int vfio_hot_reset_device_set(struct vfio_pci_core_device *vdev,
 				     struct vfio_pci_group_info *groups);
 
 /*
@@ -260,7 +260,7 @@ static bool vfio_pci_nointx(struct pci_dev *pdev)
 	return false;
 }
 
-static void vfio_pci_probe_power_state(struct vfio_pci_device *vdev)
+static void vfio_pci_probe_power_state(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	u16 pmcsr;
@@ -280,7 +280,7 @@ static void vfio_pci_probe_power_state(struct vfio_pci_device *vdev)
  * by PM capability emulation and separately from pci_dev internal saved state
  * to avoid it being overwritten and consumed around other resets.
  */
-int vfio_pci_set_power_state(struct vfio_pci_device *vdev, pci_power_t state)
+int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t state)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	bool needs_restore = false, needs_save = false;
@@ -311,7 +311,7 @@ int vfio_pci_set_power_state(struct vfio_pci_device *vdev, pci_power_t state)
 	return ret;
 }
 
-static int vfio_pci_enable(struct vfio_pci_device *vdev)
+static int vfio_pci_enable(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	int ret;
@@ -399,7 +399,7 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
 	return ret;
 }
 
-static void vfio_pci_disable(struct vfio_pci_device *vdev)
+static void vfio_pci_disable(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	struct vfio_pci_dummy_resource *dummy_res, *tmp;
@@ -500,7 +500,7 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
 
 static struct pci_driver vfio_pci_driver;
 
-static struct vfio_pci_device *get_pf_vdev(struct vfio_pci_device *vdev)
+static struct vfio_pci_core_device *get_pf_vdev(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *physfn = pci_physfn(vdev->pdev);
 	struct vfio_device *pf_dev;
@@ -517,12 +517,12 @@ static struct vfio_pci_device *get_pf_vdev(struct vfio_pci_device *vdev)
 		return NULL;
 	}
 
-	return container_of(pf_dev, struct vfio_pci_device, vdev);
+	return container_of(pf_dev, struct vfio_pci_core_device, vdev);
 }
 
-static void vfio_pci_vf_token_user_add(struct vfio_pci_device *vdev, int val)
+static void vfio_pci_vf_token_user_add(struct vfio_pci_core_device *vdev, int val)
 {
-	struct vfio_pci_device *pf_vdev = get_pf_vdev(vdev);
+	struct vfio_pci_core_device *pf_vdev = get_pf_vdev(vdev);
 
 	if (!pf_vdev)
 		return;
@@ -537,8 +537,8 @@ static void vfio_pci_vf_token_user_add(struct vfio_pci_device *vdev, int val)
 
 static void vfio_pci_close_device(struct vfio_device *core_vdev)
 {
-	struct vfio_pci_device *vdev =
-		container_of(core_vdev, struct vfio_pci_device, vdev);
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
 
 	vfio_pci_vf_token_user_add(vdev, -1);
 	vfio_spapr_pci_eeh_release(vdev->pdev);
@@ -558,8 +558,8 @@ static void vfio_pci_close_device(struct vfio_device *core_vdev)
 
 static int vfio_pci_open_device(struct vfio_device *core_vdev)
 {
-	struct vfio_pci_device *vdev =
-		container_of(core_vdev, struct vfio_pci_device, vdev);
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
 	int ret = 0;
 
 	ret = vfio_pci_enable(vdev);
@@ -571,7 +571,7 @@ static int vfio_pci_open_device(struct vfio_device *core_vdev)
 	return 0;
 }
 
-static int vfio_pci_get_irq_count(struct vfio_pci_device *vdev, int irq_type)
+static int vfio_pci_get_irq_count(struct vfio_pci_core_device *vdev, int irq_type)
 {
 	if (irq_type == VFIO_PCI_INTX_IRQ_INDEX) {
 		u8 pin;
@@ -692,7 +692,7 @@ static int vfio_pci_for_each_slot_or_bus(struct pci_dev *pdev,
 	return walk.ret;
 }
 
-static int msix_mmappable_cap(struct vfio_pci_device *vdev,
+static int msix_mmappable_cap(struct vfio_pci_core_device *vdev,
 			      struct vfio_info_cap *caps)
 {
 	struct vfio_info_cap_header header = {
@@ -703,7 +703,7 @@ static int msix_mmappable_cap(struct vfio_pci_device *vdev,
 	return vfio_info_add_capability(caps, &header, sizeof(header));
 }
 
-int vfio_pci_register_dev_region(struct vfio_pci_device *vdev,
+int vfio_pci_register_dev_region(struct vfio_pci_core_device *vdev,
 				 unsigned int type, unsigned int subtype,
 				 const struct vfio_pci_regops *ops,
 				 size_t size, u32 flags, void *data)
@@ -732,8 +732,8 @@ int vfio_pci_register_dev_region(struct vfio_pci_device *vdev,
 static long vfio_pci_ioctl(struct vfio_device *core_vdev,
 			   unsigned int cmd, unsigned long arg)
 {
-	struct vfio_pci_device *vdev =
-		container_of(core_vdev, struct vfio_pci_device, vdev);
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
 	unsigned long minsz;
 
 	if (cmd == VFIO_DEVICE_GET_INFO) {
@@ -1273,7 +1273,7 @@ static long vfio_pci_ioctl(struct vfio_device *core_vdev,
 	return -ENOTTY;
 }
 
-static ssize_t vfio_pci_rw(struct vfio_pci_device *vdev, char __user *buf,
+static ssize_t vfio_pci_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			   size_t count, loff_t *ppos, bool iswrite)
 {
 	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
@@ -1307,8 +1307,8 @@ static ssize_t vfio_pci_rw(struct vfio_pci_device *vdev, char __user *buf,
 static ssize_t vfio_pci_read(struct vfio_device *core_vdev, char __user *buf,
 			     size_t count, loff_t *ppos)
 {
-	struct vfio_pci_device *vdev =
-		container_of(core_vdev, struct vfio_pci_device, vdev);
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
 
 	if (!count)
 		return 0;
@@ -1319,8 +1319,8 @@ static ssize_t vfio_pci_read(struct vfio_device *core_vdev, char __user *buf,
 static ssize_t vfio_pci_write(struct vfio_device *core_vdev, const char __user *buf,
 			      size_t count, loff_t *ppos)
 {
-	struct vfio_pci_device *vdev =
-		container_of(core_vdev, struct vfio_pci_device, vdev);
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
 
 	if (!count)
 		return 0;
@@ -1329,7 +1329,7 @@ static ssize_t vfio_pci_write(struct vfio_device *core_vdev, const char __user *
 }
 
 /* Return 1 on zap and vma_lock acquired, 0 on contention (only with @try) */
-static int vfio_pci_zap_and_vma_lock(struct vfio_pci_device *vdev, bool try)
+static int vfio_pci_zap_and_vma_lock(struct vfio_pci_core_device *vdev, bool try)
 {
 	struct vfio_pci_mmap_vma *mmap_vma, *tmp;
 
@@ -1417,14 +1417,14 @@ static int vfio_pci_zap_and_vma_lock(struct vfio_pci_device *vdev, bool try)
 	}
 }
 
-void vfio_pci_zap_and_down_write_memory_lock(struct vfio_pci_device *vdev)
+void vfio_pci_zap_and_down_write_memory_lock(struct vfio_pci_core_device *vdev)
 {
 	vfio_pci_zap_and_vma_lock(vdev, false);
 	down_write(&vdev->memory_lock);
 	mutex_unlock(&vdev->vma_lock);
 }
 
-u16 vfio_pci_memory_lock_and_enable(struct vfio_pci_device *vdev)
+u16 vfio_pci_memory_lock_and_enable(struct vfio_pci_core_device *vdev)
 {
 	u16 cmd;
 
@@ -1437,14 +1437,14 @@ u16 vfio_pci_memory_lock_and_enable(struct vfio_pci_device *vdev)
 	return cmd;
 }
 
-void vfio_pci_memory_unlock_and_restore(struct vfio_pci_device *vdev, u16 cmd)
+void vfio_pci_memory_unlock_and_restore(struct vfio_pci_core_device *vdev, u16 cmd)
 {
 	pci_write_config_word(vdev->pdev, PCI_COMMAND, cmd);
 	up_write(&vdev->memory_lock);
 }
 
 /* Caller holds vma_lock */
-static int __vfio_pci_add_vma(struct vfio_pci_device *vdev,
+static int __vfio_pci_add_vma(struct vfio_pci_core_device *vdev,
 			      struct vm_area_struct *vma)
 {
 	struct vfio_pci_mmap_vma *mmap_vma;
@@ -1470,7 +1470,7 @@ static void vfio_pci_mmap_open(struct vm_area_struct *vma)
 
 static void vfio_pci_mmap_close(struct vm_area_struct *vma)
 {
-	struct vfio_pci_device *vdev = vma->vm_private_data;
+	struct vfio_pci_core_device *vdev = vma->vm_private_data;
 	struct vfio_pci_mmap_vma *mmap_vma;
 
 	mutex_lock(&vdev->vma_lock);
@@ -1487,7 +1487,7 @@ static void vfio_pci_mmap_close(struct vm_area_struct *vma)
 static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	struct vfio_pci_device *vdev = vma->vm_private_data;
+	struct vfio_pci_core_device *vdev = vma->vm_private_data;
 	struct vfio_pci_mmap_vma *mmap_vma;
 	vm_fault_t ret = VM_FAULT_NOPAGE;
 
@@ -1537,8 +1537,8 @@ static const struct vm_operations_struct vfio_pci_mmap_ops = {
 
 static int vfio_pci_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma)
 {
-	struct vfio_pci_device *vdev =
-		container_of(core_vdev, struct vfio_pci_device, vdev);
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
 	struct pci_dev *pdev = vdev->pdev;
 	unsigned int index;
 	u64 phys_len, req_len, pgoff, req_start;
@@ -1608,8 +1608,8 @@ static int vfio_pci_mmap(struct vfio_device *core_vdev, struct vm_area_struct *v
 
 static void vfio_pci_request(struct vfio_device *core_vdev, unsigned int count)
 {
-	struct vfio_pci_device *vdev =
-		container_of(core_vdev, struct vfio_pci_device, vdev);
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
 	struct pci_dev *pdev = vdev->pdev;
 
 	mutex_lock(&vdev->igate);
@@ -1628,7 +1628,7 @@ static void vfio_pci_request(struct vfio_device *core_vdev, unsigned int count)
 	mutex_unlock(&vdev->igate);
 }
 
-static int vfio_pci_validate_vf_token(struct vfio_pci_device *vdev,
+static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 				      bool vf_token, uuid_t *uuid)
 {
 	/*
@@ -1660,7 +1660,7 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_device *vdev,
 		return 0; /* No VF token provided or required */
 
 	if (vdev->pdev->is_virtfn) {
-		struct vfio_pci_device *pf_vdev = get_pf_vdev(vdev);
+		struct vfio_pci_core_device *pf_vdev = get_pf_vdev(vdev);
 		bool match;
 
 		if (!pf_vdev) {
@@ -1724,8 +1724,8 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_device *vdev,
 
 static int vfio_pci_match(struct vfio_device *core_vdev, char *buf)
 {
-	struct vfio_pci_device *vdev =
-		container_of(core_vdev, struct vfio_pci_device, vdev);
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
 	bool vf_token = false;
 	uuid_t uuid;
 	int ret;
@@ -1787,8 +1787,8 @@ static const struct vfio_device_ops vfio_pci_ops = {
 static int vfio_pci_bus_notifier(struct notifier_block *nb,
 				 unsigned long action, void *data)
 {
-	struct vfio_pci_device *vdev = container_of(nb,
-						    struct vfio_pci_device, nb);
+	struct vfio_pci_core_device *vdev = container_of(nb,
+						    struct vfio_pci_core_device, nb);
 	struct device *dev = data;
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct pci_dev *physfn = pci_physfn(pdev);
@@ -1812,7 +1812,7 @@ static int vfio_pci_bus_notifier(struct notifier_block *nb,
 	return 0;
 }
 
-static int vfio_pci_vf_init(struct vfio_pci_device *vdev)
+static int vfio_pci_vf_init(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	int ret;
@@ -1836,7 +1836,7 @@ static int vfio_pci_vf_init(struct vfio_pci_device *vdev)
 	return 0;
 }
 
-static void vfio_pci_vf_uninit(struct vfio_pci_device *vdev)
+static void vfio_pci_vf_uninit(struct vfio_pci_core_device *vdev)
 {
 	if (!vdev->vf_token)
 		return;
@@ -1847,7 +1847,7 @@ static void vfio_pci_vf_uninit(struct vfio_pci_device *vdev)
 	kfree(vdev->vf_token);
 }
 
-static int vfio_pci_vga_init(struct vfio_pci_device *vdev)
+static int vfio_pci_vga_init(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	int ret;
@@ -1862,7 +1862,7 @@ static int vfio_pci_vga_init(struct vfio_pci_device *vdev)
 	return 0;
 }
 
-static void vfio_pci_vga_uninit(struct vfio_pci_device *vdev)
+static void vfio_pci_vga_uninit(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 
@@ -1876,7 +1876,7 @@ static void vfio_pci_vga_uninit(struct vfio_pci_device *vdev)
 
 static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	struct vfio_pci_device *vdev;
+	struct vfio_pci_core_device *vdev;
 	struct iommu_group *group;
 	int ret;
 
@@ -1974,7 +1974,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 static void vfio_pci_remove(struct pci_dev *pdev)
 {
-	struct vfio_pci_device *vdev = dev_get_drvdata(&pdev->dev);
+	struct vfio_pci_core_device *vdev = dev_get_drvdata(&pdev->dev);
 
 	pci_disable_sriov(pdev);
 
@@ -1998,14 +1998,14 @@ static void vfio_pci_remove(struct pci_dev *pdev)
 static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
 						  pci_channel_state_t state)
 {
-	struct vfio_pci_device *vdev;
+	struct vfio_pci_core_device *vdev;
 	struct vfio_device *device;
 
 	device = vfio_device_get_from_dev(&pdev->dev);
 	if (device == NULL)
 		return PCI_ERS_RESULT_DISCONNECT;
 
-	vdev = container_of(device, struct vfio_pci_device, vdev);
+	vdev = container_of(device, struct vfio_pci_core_device, vdev);
 
 	mutex_lock(&vdev->igate);
 
@@ -2069,7 +2069,7 @@ static int vfio_pci_check_all_devices_bound(struct pci_dev *pdev, void *data)
 	return -EBUSY;
 }
 
-static bool vfio_dev_in_groups(struct vfio_pci_device *vdev,
+static bool vfio_dev_in_groups(struct vfio_pci_core_device *vdev,
 			       struct vfio_pci_group_info *groups)
 {
 	unsigned int i;
@@ -2085,19 +2085,20 @@ static bool vfio_dev_in_groups(struct vfio_pci_device *vdev,
  * therefore we need to zap and hold the vma_lock for each device, and only then
  * get each memory_lock.
  */
-static int vfio_hot_reset_device_set(struct vfio_pci_device *vdev,
+static int vfio_hot_reset_device_set(struct vfio_pci_core_device *vdev,
 				     struct vfio_pci_group_info *groups)
 {
 	struct vfio_device_set *dev_set = vdev->vdev.dev_set;
-	struct vfio_pci_device *cur_mem;
-	struct vfio_pci_device *cur_vma;
-	struct vfio_pci_device *cur;
+	struct vfio_pci_core_device *cur_mem;
+	struct vfio_pci_core_device *cur_vma;
+	struct vfio_pci_core_device *cur;
 	bool is_mem = true;
 	int ret;
 
 	mutex_lock(&dev_set->lock);
 	cur_mem = list_first_entry(&dev_set->device_list,
-				   struct vfio_pci_device, vdev.dev_set_list);
+				   struct vfio_pci_core_device,
+				   vdev.dev_set_list);
 
 	/* All devices in the group to be reset need VFIO devices */
 	if (vfio_pci_for_each_slot_or_bus(
@@ -2170,11 +2171,11 @@ static int vfio_hot_reset_device_set(struct vfio_pci_device *vdev,
  * to be bound to vfio_pci since that's the only way we can be sure they
  * stay put.
  */
-static void vfio_pci_try_bus_reset(struct vfio_pci_device *vdev)
+static void vfio_pci_try_bus_reset(struct vfio_pci_core_device *vdev)
 {
 	struct vfio_device_set *dev_set = vdev->vdev.dev_set;
-	struct vfio_pci_device *to_reset = NULL;
-	struct vfio_pci_device *cur;
+	struct vfio_pci_core_device *to_reset = NULL;
+	struct vfio_pci_core_device *cur;
 	int ret;
 
 	if (pci_probe_reset_slot(vdev->pdev->slot) &&
diff --git a/drivers/vfio/pci/vfio_pci_core.h b/drivers/vfio/pci/vfio_pci_core.h
index ef26e781961d..2ceaa6e4ca25 100644
--- a/drivers/vfio/pci/vfio_pci_core.h
+++ b/drivers/vfio/pci/vfio_pci_core.h
@@ -33,7 +33,7 @@
 
 struct vfio_pci_ioeventfd {
 	struct list_head	next;
-	struct vfio_pci_device	*vdev;
+	struct vfio_pci_core_device	*vdev;
 	struct virqfd		*virqfd;
 	void __iomem		*addr;
 	uint64_t		data;
@@ -52,18 +52,18 @@ struct vfio_pci_irq_ctx {
 	struct irq_bypass_producer	producer;
 };
 
-struct vfio_pci_device;
+struct vfio_pci_core_device;
 struct vfio_pci_region;
 
 struct vfio_pci_regops {
-	ssize_t	(*rw)(struct vfio_pci_device *vdev, char __user *buf,
+	ssize_t (*rw)(struct vfio_pci_core_device *vdev, char __user *buf,
 		      size_t count, loff_t *ppos, bool iswrite);
-	void	(*release)(struct vfio_pci_device *vdev,
+	void	(*release)(struct vfio_pci_core_device *vdev,
 			   struct vfio_pci_region *region);
-	int	(*mmap)(struct vfio_pci_device *vdev,
+	int	(*mmap)(struct vfio_pci_core_device *vdev,
 			struct vfio_pci_region *region,
 			struct vm_area_struct *vma);
-	int	(*add_capability)(struct vfio_pci_device *vdev,
+	int	(*add_capability)(struct vfio_pci_core_device *vdev,
 				  struct vfio_pci_region *region,
 				  struct vfio_info_cap *caps);
 };
@@ -94,7 +94,7 @@ struct vfio_pci_mmap_vma {
 	struct list_head	vma_next;
 };
 
-struct vfio_pci_device {
+struct vfio_pci_core_device {
 	struct vfio_device	vdev;
 	struct pci_dev		*pdev;
 	void __iomem		*barmap[PCI_STD_NUM_BARS];
@@ -144,61 +144,61 @@ struct vfio_pci_device {
 #define is_irq_none(vdev) (!(is_intx(vdev) || is_msi(vdev) || is_msix(vdev)))
 #define irq_is(vdev, type) (vdev->irq_type == type)
 
-extern void vfio_pci_intx_mask(struct vfio_pci_device *vdev);
-extern void vfio_pci_intx_unmask(struct vfio_pci_device *vdev);
+extern void vfio_pci_intx_mask(struct vfio_pci_core_device *vdev);
+extern void vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev);
 
-extern int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev,
+extern int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev,
 				   uint32_t flags, unsigned index,
 				   unsigned start, unsigned count, void *data);
 
-extern ssize_t vfio_pci_config_rw(struct vfio_pci_device *vdev,
+extern ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev,
 				  char __user *buf, size_t count,
 				  loff_t *ppos, bool iswrite);
 
-extern ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
+extern ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			       size_t count, loff_t *ppos, bool iswrite);
 
-extern ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char __user *buf,
+extern ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			       size_t count, loff_t *ppos, bool iswrite);
 
-extern long vfio_pci_ioeventfd(struct vfio_pci_device *vdev, loff_t offset,
+extern long vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
 			       uint64_t data, int count, int fd);
 
 extern int vfio_pci_init_perm_bits(void);
 extern void vfio_pci_uninit_perm_bits(void);
 
-extern int vfio_config_init(struct vfio_pci_device *vdev);
-extern void vfio_config_free(struct vfio_pci_device *vdev);
+extern int vfio_config_init(struct vfio_pci_core_device *vdev);
+extern void vfio_config_free(struct vfio_pci_core_device *vdev);
 
-extern int vfio_pci_register_dev_region(struct vfio_pci_device *vdev,
+extern int vfio_pci_register_dev_region(struct vfio_pci_core_device *vdev,
 					unsigned int type, unsigned int subtype,
 					const struct vfio_pci_regops *ops,
 					size_t size, u32 flags, void *data);
 
-extern int vfio_pci_set_power_state(struct vfio_pci_device *vdev,
+extern int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev,
 				    pci_power_t state);
 
-extern bool __vfio_pci_memory_enabled(struct vfio_pci_device *vdev);
-extern void vfio_pci_zap_and_down_write_memory_lock(struct vfio_pci_device
+extern bool __vfio_pci_memory_enabled(struct vfio_pci_core_device *vdev);
+extern void vfio_pci_zap_and_down_write_memory_lock(struct vfio_pci_core_device
 						    *vdev);
-extern u16 vfio_pci_memory_lock_and_enable(struct vfio_pci_device *vdev);
-extern void vfio_pci_memory_unlock_and_restore(struct vfio_pci_device *vdev,
+extern u16 vfio_pci_memory_lock_and_enable(struct vfio_pci_core_device *vdev);
+extern void vfio_pci_memory_unlock_and_restore(struct vfio_pci_core_device *vdev,
 					       u16 cmd);
 
 #ifdef CONFIG_VFIO_PCI_IGD
-extern int vfio_pci_igd_init(struct vfio_pci_device *vdev);
+extern int vfio_pci_igd_init(struct vfio_pci_core_device *vdev);
 #else
-static inline int vfio_pci_igd_init(struct vfio_pci_device *vdev)
+static inline int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
 {
 	return -ENODEV;
 }
 #endif
 
 #ifdef CONFIG_S390
-extern int vfio_pci_info_zdev_add_caps(struct vfio_pci_device *vdev,
+extern int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 				       struct vfio_info_cap *caps);
 #else
-static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_device *vdev,
+static inline int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 					      struct vfio_info_cap *caps)
 {
 	return -ENODEV;
diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
index d57c409b4033..a324ca7e6b5a 100644
--- a/drivers/vfio/pci/vfio_pci_igd.c
+++ b/drivers/vfio/pci/vfio_pci_igd.c
@@ -25,8 +25,9 @@
 #define OPREGION_RVDS		0x3c2
 #define OPREGION_VERSION	0x16
 
-static ssize_t vfio_pci_igd_rw(struct vfio_pci_device *vdev, char __user *buf,
-			       size_t count, loff_t *ppos, bool iswrite)
+static ssize_t vfio_pci_igd_rw(struct vfio_pci_core_device *vdev,
+			       char __user *buf, size_t count, loff_t *ppos,
+			       bool iswrite)
 {
 	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
 	void *base = vdev->region[i].data;
@@ -45,7 +46,7 @@ static ssize_t vfio_pci_igd_rw(struct vfio_pci_device *vdev, char __user *buf,
 	return count;
 }
 
-static void vfio_pci_igd_release(struct vfio_pci_device *vdev,
+static void vfio_pci_igd_release(struct vfio_pci_core_device *vdev,
 				 struct vfio_pci_region *region)
 {
 	memunmap(region->data);
@@ -56,7 +57,7 @@ static const struct vfio_pci_regops vfio_pci_igd_regops = {
 	.release	= vfio_pci_igd_release,
 };
 
-static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
+static int vfio_pci_igd_opregion_init(struct vfio_pci_core_device *vdev)
 {
 	__le32 *dwordp = (__le32 *)(vdev->vconfig + OPREGION_PCI_ADDR);
 	u32 addr, size;
@@ -160,7 +161,7 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
 	return ret;
 }
 
-static ssize_t vfio_pci_igd_cfg_rw(struct vfio_pci_device *vdev,
+static ssize_t vfio_pci_igd_cfg_rw(struct vfio_pci_core_device *vdev,
 				   char __user *buf, size_t count, loff_t *ppos,
 				   bool iswrite)
 {
@@ -253,7 +254,7 @@ static ssize_t vfio_pci_igd_cfg_rw(struct vfio_pci_device *vdev,
 	return count;
 }
 
-static void vfio_pci_igd_cfg_release(struct vfio_pci_device *vdev,
+static void vfio_pci_igd_cfg_release(struct vfio_pci_core_device *vdev,
 				     struct vfio_pci_region *region)
 {
 	struct pci_dev *pdev = region->data;
@@ -266,7 +267,7 @@ static const struct vfio_pci_regops vfio_pci_igd_cfg_regops = {
 	.release	= vfio_pci_igd_cfg_release,
 };
 
-static int vfio_pci_igd_cfg_init(struct vfio_pci_device *vdev)
+static int vfio_pci_igd_cfg_init(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *host_bridge, *lpc_bridge;
 	int ret;
@@ -314,7 +315,7 @@ static int vfio_pci_igd_cfg_init(struct vfio_pci_device *vdev)
 	return 0;
 }
 
-int vfio_pci_igd_init(struct vfio_pci_device *vdev)
+int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
 {
 	int ret;
 
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index df1e8c8c274c..945ddbdf4d11 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -27,13 +27,13 @@
  */
 static void vfio_send_intx_eventfd(void *opaque, void *unused)
 {
-	struct vfio_pci_device *vdev = opaque;
+	struct vfio_pci_core_device *vdev = opaque;
 
 	if (likely(is_intx(vdev) && !vdev->virq_disabled))
 		eventfd_signal(vdev->ctx[0].trigger, 1);
 }
 
-void vfio_pci_intx_mask(struct vfio_pci_device *vdev)
+void vfio_pci_intx_mask(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	unsigned long flags;
@@ -73,7 +73,7 @@ void vfio_pci_intx_mask(struct vfio_pci_device *vdev)
  */
 static int vfio_pci_intx_unmask_handler(void *opaque, void *unused)
 {
-	struct vfio_pci_device *vdev = opaque;
+	struct vfio_pci_core_device *vdev = opaque;
 	struct pci_dev *pdev = vdev->pdev;
 	unsigned long flags;
 	int ret = 0;
@@ -107,7 +107,7 @@ static int vfio_pci_intx_unmask_handler(void *opaque, void *unused)
 	return ret;
 }
 
-void vfio_pci_intx_unmask(struct vfio_pci_device *vdev)
+void vfio_pci_intx_unmask(struct vfio_pci_core_device *vdev)
 {
 	if (vfio_pci_intx_unmask_handler(vdev, NULL) > 0)
 		vfio_send_intx_eventfd(vdev, NULL);
@@ -115,7 +115,7 @@ void vfio_pci_intx_unmask(struct vfio_pci_device *vdev)
 
 static irqreturn_t vfio_intx_handler(int irq, void *dev_id)
 {
-	struct vfio_pci_device *vdev = dev_id;
+	struct vfio_pci_core_device *vdev = dev_id;
 	unsigned long flags;
 	int ret = IRQ_NONE;
 
@@ -139,7 +139,7 @@ static irqreturn_t vfio_intx_handler(int irq, void *dev_id)
 	return ret;
 }
 
-static int vfio_intx_enable(struct vfio_pci_device *vdev)
+static int vfio_intx_enable(struct vfio_pci_core_device *vdev)
 {
 	if (!is_irq_none(vdev))
 		return -EINVAL;
@@ -168,7 +168,7 @@ static int vfio_intx_enable(struct vfio_pci_device *vdev)
 	return 0;
 }
 
-static int vfio_intx_set_signal(struct vfio_pci_device *vdev, int fd)
+static int vfio_intx_set_signal(struct vfio_pci_core_device *vdev, int fd)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	unsigned long irqflags = IRQF_SHARED;
@@ -223,7 +223,7 @@ static int vfio_intx_set_signal(struct vfio_pci_device *vdev, int fd)
 	return 0;
 }
 
-static void vfio_intx_disable(struct vfio_pci_device *vdev)
+static void vfio_intx_disable(struct vfio_pci_core_device *vdev)
 {
 	vfio_virqfd_disable(&vdev->ctx[0].unmask);
 	vfio_virqfd_disable(&vdev->ctx[0].mask);
@@ -244,7 +244,7 @@ static irqreturn_t vfio_msihandler(int irq, void *arg)
 	return IRQ_HANDLED;
 }
 
-static int vfio_msi_enable(struct vfio_pci_device *vdev, int nvec, bool msix)
+static int vfio_msi_enable(struct vfio_pci_core_device *vdev, int nvec, bool msix)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	unsigned int flag = msix ? PCI_IRQ_MSIX : PCI_IRQ_MSI;
@@ -285,7 +285,7 @@ static int vfio_msi_enable(struct vfio_pci_device *vdev, int nvec, bool msix)
 	return 0;
 }
 
-static int vfio_msi_set_vector_signal(struct vfio_pci_device *vdev,
+static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
 				      int vector, int fd, bool msix)
 {
 	struct pci_dev *pdev = vdev->pdev;
@@ -364,7 +364,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_device *vdev,
 	return 0;
 }
 
-static int vfio_msi_set_block(struct vfio_pci_device *vdev, unsigned start,
+static int vfio_msi_set_block(struct vfio_pci_core_device *vdev, unsigned start,
 			      unsigned count, int32_t *fds, bool msix)
 {
 	int i, j, ret = 0;
@@ -385,7 +385,7 @@ static int vfio_msi_set_block(struct vfio_pci_device *vdev, unsigned start,
 	return ret;
 }
 
-static void vfio_msi_disable(struct vfio_pci_device *vdev, bool msix)
+static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	int i;
@@ -417,7 +417,7 @@ static void vfio_msi_disable(struct vfio_pci_device *vdev, bool msix)
 /*
  * IOCTL support
  */
-static int vfio_pci_set_intx_unmask(struct vfio_pci_device *vdev,
+static int vfio_pci_set_intx_unmask(struct vfio_pci_core_device *vdev,
 				    unsigned index, unsigned start,
 				    unsigned count, uint32_t flags, void *data)
 {
@@ -444,7 +444,7 @@ static int vfio_pci_set_intx_unmask(struct vfio_pci_device *vdev,
 	return 0;
 }
 
-static int vfio_pci_set_intx_mask(struct vfio_pci_device *vdev,
+static int vfio_pci_set_intx_mask(struct vfio_pci_core_device *vdev,
 				  unsigned index, unsigned start,
 				  unsigned count, uint32_t flags, void *data)
 {
@@ -464,7 +464,7 @@ static int vfio_pci_set_intx_mask(struct vfio_pci_device *vdev,
 	return 0;
 }
 
-static int vfio_pci_set_intx_trigger(struct vfio_pci_device *vdev,
+static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
 				     unsigned index, unsigned start,
 				     unsigned count, uint32_t flags, void *data)
 {
@@ -507,7 +507,7 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_device *vdev,
 	return 0;
 }
 
-static int vfio_pci_set_msi_trigger(struct vfio_pci_device *vdev,
+static int vfio_pci_set_msi_trigger(struct vfio_pci_core_device *vdev,
 				    unsigned index, unsigned start,
 				    unsigned count, uint32_t flags, void *data)
 {
@@ -613,7 +613,7 @@ static int vfio_pci_set_ctx_trigger_single(struct eventfd_ctx **ctx,
 	return -EINVAL;
 }
 
-static int vfio_pci_set_err_trigger(struct vfio_pci_device *vdev,
+static int vfio_pci_set_err_trigger(struct vfio_pci_core_device *vdev,
 				    unsigned index, unsigned start,
 				    unsigned count, uint32_t flags, void *data)
 {
@@ -624,7 +624,7 @@ static int vfio_pci_set_err_trigger(struct vfio_pci_device *vdev,
 					       count, flags, data);
 }
 
-static int vfio_pci_set_req_trigger(struct vfio_pci_device *vdev,
+static int vfio_pci_set_req_trigger(struct vfio_pci_core_device *vdev,
 				    unsigned index, unsigned start,
 				    unsigned count, uint32_t flags, void *data)
 {
@@ -635,11 +635,11 @@ static int vfio_pci_set_req_trigger(struct vfio_pci_device *vdev,
 					       count, flags, data);
 }
 
-int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev, uint32_t flags,
+int vfio_pci_set_irqs_ioctl(struct vfio_pci_core_device *vdev, uint32_t flags,
 			    unsigned index, unsigned start, unsigned count,
 			    void *data)
 {
-	int (*func)(struct vfio_pci_device *vdev, unsigned index,
+	int (*func)(struct vfio_pci_core_device *vdev, unsigned index,
 		    unsigned start, unsigned count, uint32_t flags,
 		    void *data) = NULL;
 
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 667e82726e75..8fff4689dd44 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -38,7 +38,7 @@
 #define vfio_iowrite8	iowrite8
 
 #define VFIO_IOWRITE(size) \
-static int vfio_pci_iowrite##size(struct vfio_pci_device *vdev,		\
+static int vfio_pci_iowrite##size(struct vfio_pci_core_device *vdev,		\
 			bool test_mem, u##size val, void __iomem *io)	\
 {									\
 	if (test_mem) {							\
@@ -65,7 +65,7 @@ VFIO_IOWRITE(64)
 #endif
 
 #define VFIO_IOREAD(size) \
-static int vfio_pci_ioread##size(struct vfio_pci_device *vdev,		\
+static int vfio_pci_ioread##size(struct vfio_pci_core_device *vdev,		\
 			bool test_mem, u##size *val, void __iomem *io)	\
 {									\
 	if (test_mem) {							\
@@ -94,7 +94,7 @@ VFIO_IOREAD(32)
  * reads with -1.  This is intended for handling MSI-X vector tables and
  * leftover space for ROM BARs.
  */
-static ssize_t do_io_rw(struct vfio_pci_device *vdev, bool test_mem,
+static ssize_t do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 			void __iomem *io, char __user *buf,
 			loff_t off, size_t count, size_t x_start,
 			size_t x_end, bool iswrite)
@@ -200,7 +200,7 @@ static ssize_t do_io_rw(struct vfio_pci_device *vdev, bool test_mem,
 	return done;
 }
 
-static int vfio_pci_setup_barmap(struct vfio_pci_device *vdev, int bar)
+static int vfio_pci_setup_barmap(struct vfio_pci_core_device *vdev, int bar)
 {
 	struct pci_dev *pdev = vdev->pdev;
 	int ret;
@@ -224,7 +224,7 @@ static int vfio_pci_setup_barmap(struct vfio_pci_device *vdev, int bar)
 	return 0;
 }
 
-ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
+ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			size_t count, loff_t *ppos, bool iswrite)
 {
 	struct pci_dev *pdev = vdev->pdev;
@@ -288,7 +288,7 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_device *vdev, char __user *buf,
 	return done;
 }
 
-ssize_t vfio_pci_vga_rw(struct vfio_pci_device *vdev, char __user *buf,
+ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			       size_t count, loff_t *ppos, bool iswrite)
 {
 	int ret;
@@ -384,7 +384,7 @@ static void vfio_pci_ioeventfd_do_write(struct vfio_pci_ioeventfd *ioeventfd,
 static int vfio_pci_ioeventfd_handler(void *opaque, void *unused)
 {
 	struct vfio_pci_ioeventfd *ioeventfd = opaque;
-	struct vfio_pci_device *vdev = ioeventfd->vdev;
+	struct vfio_pci_core_device *vdev = ioeventfd->vdev;
 
 	if (ioeventfd->test_mem) {
 		if (!down_read_trylock(&vdev->memory_lock))
@@ -410,7 +410,7 @@ static void vfio_pci_ioeventfd_thread(void *opaque, void *unused)
 	vfio_pci_ioeventfd_do_write(ioeventfd, ioeventfd->test_mem);
 }
 
-long vfio_pci_ioeventfd(struct vfio_pci_device *vdev, loff_t offset,
+long vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
 			uint64_t data, int count, int fd)
 {
 	struct pci_dev *pdev = vdev->pdev;
diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
index ecae0c3d95a0..2ffbdc11f089 100644
--- a/drivers/vfio/pci/vfio_pci_zdev.c
+++ b/drivers/vfio/pci/vfio_pci_zdev.c
@@ -114,7 +114,7 @@ static int zpci_pfip_cap(struct zpci_dev *zdev, struct vfio_info_cap *caps)
 /*
  * Add all supported capabilities to the VFIO_DEVICE_GET_INFO capability chain.
  */
-int vfio_pci_info_zdev_add_caps(struct vfio_pci_device *vdev,
+int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 				struct vfio_info_cap *caps)
 {
 	struct zpci_dev *zdev = to_zpci(vdev->pdev);
-- 
2.18.1

