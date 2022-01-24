Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF42D49881B
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 19:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245171AbiAXSRt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 13:17:49 -0500
Received: from mail-mw2nam12on2065.outbound.protection.outlook.com ([40.107.244.65]:51048
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245165AbiAXSRs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 13:17:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d8VS6ESPbmx8/CA86J2Wr0o0wB1YMDLnljSpCcTitz1eaGqgMLpsxQEYfPQLoUJ+c4tYcqXfHuVeKBXkLKFX+VHVUhdseeqMpV0xPHVtS4yNye4HNhFsqszLAaqjkdBEaDhqHOQPE7GJbSCl0+d2J9rN43L35GQcuwVGqQER31DdtgJHolwNgKWr0cRpZDe2CA5rVlJxd6YrQaoW5+c2Yg4/nEdO32T90yfVvdexaE8KL6U6QAMN9M+jl8snd/sCS4ur0imm5GTM6+mvpBZtW7F42Q//Ca4kO14WQlpYNTkkyrHi/yAcKaie2qc5E72yWncRr1Ad+wXFW6jaU42PEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nVVC8wO3XipGN4e/nucddVGaDwTmNw9cj+G8smfywpA=;
 b=hwL4AgMUYxLBUV7AWt9VJHnlMD8kXEBB+CrGsWmb7Oo5T9QL6QTTjBOflXt4tPmSgMpqh3zCZhskYA/QlXHz5lZ4RTLSAPncG+P6vWygm218sZEElsKrogrGc4oMTdnFQDAZcNtmYyrq/eVTCJiG83mCWjzIQ11fSrLWhmXOkU3krtaM4dtwuZQtlnaVfhoD/j/FWD1oL2mzfL938IrGaM0SljwK3RdBeIsokZnhYkjfZxUvHARj22RZQlDCCTW5DwVkgbrf1FpLwSwijqWifhT+Rl3r9UPeFTYxjueEcOnLu9cJrZj/KMMEScXkJ5b5oj4JIQC4ASbRnJ7AEohK0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nVVC8wO3XipGN4e/nucddVGaDwTmNw9cj+G8smfywpA=;
 b=m1zLQO6KqxXSKMzskDIYLRchmqNterAmW8jyvrKhhkuxVMM4XtbrEVL5R5VxDZGjYXYBIhhfkCv3ukTT0JbbMvEyeC3NOJqEUecDyXZfl91gOGcbtDk2UIAnl2oK7J5pbUWaHAyWhb7fbWLyJ9Oq5moLrcUQ1F+Q3PSadpwivmT2+eR8N5vMcS9BmI+F/KFUN6LnKJwpsgpEjuL3NTIgQ6j0xmuNDVKNNTpqRolWW3FRsv0k8z64nFnRX3dXvUeUJ31z5elTmF9x6jGu29uLuM19xrddEFqcYhPm2htbzVoHWV1qnJxBh2jlKPXxOB+/VRCDLHnVQjl1AE+KaA1SHw==
Received: from DM5PR21CA0041.namprd21.prod.outlook.com (2603:10b6:3:ed::27) by
 DM5PR12MB1131.namprd12.prod.outlook.com (2603:10b6:3:73::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4909.10; Mon, 24 Jan 2022 18:17:47 +0000
Received: from DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ed:cafe::65) by DM5PR21CA0041.outlook.office365.com
 (2603:10b6:3:ed::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.3 via Frontend
 Transport; Mon, 24 Jan 2022 18:17:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT049.mail.protection.outlook.com (10.13.172.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Mon, 24 Jan 2022 18:17:46 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Mon, 24 Jan 2022 18:17:45 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Mon, 24 Jan 2022 10:17:45 -0800
Received: from nvidia-Inspiron-15-7510.nvidia.com (10.127.8.13) by
 mail.nvidia.com (10.126.190.180) with Microsoft SMTP Server id 15.2.986.9 via
 Frontend Transport; Mon, 24 Jan 2022 10:17:41 -0800
From:   Abhishek Sahu <abhsahu@nvidia.com>
To:     <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
CC:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        <linux-kernel@vger.kernel.org>, Abhishek Sahu <abhsahu@nvidia.com>
Subject: [RFC PATCH v2 2/5] vfio/pci: virtualize PME related registers bits and initialize to zero
Date:   Mon, 24 Jan 2022 23:47:23 +0530
Message-ID: <20220124181726.19174-3-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220124181726.19174-1-abhsahu@nvidia.com>
References: <20220124181726.19174-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92b280e7-315d-49a0-eb60-08d9df65d270
X-MS-TrafficTypeDiagnostic: DM5PR12MB1131:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB11318756B1AE22510321458BCC5E9@DM5PR12MB1131.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jOEu4acTUta+EpLEwJNVcuEH5Bhqo8eqAZahG+lCdTH4o3YfjDT4qMp/CXjK7lj61m/QeQDrhuM1NpKRr/JePziJKlNl9vsCDuNF6EDgrYYRu0O80hODZZjYd2Q30NYF7cUSznxMJu/5MxgxEQGTHK8SwayMSRJHmHX/n3QOyUoerb7gpaZhXHApEElhICwl6Yxjv8S/DqZ3R18v2KCTrmrT7jxdkONDXmCS3cbfg6OsrgUalGMp+ntUak28Dj0aOe2Sd9berfDqy2GpvWjsPgWjuSlci24pCz5BY4hPZ3WZ2DHBJLsHj3qHyC2viEOogE8Y+Onra+o8IkKWY61Fwm0b1K+oja0bGUcdICzi+Q/0g68T7+Blal/xi4NeZvZCzkY/9Wy8RVRQS3WRObelIaaWu5/DStIOZwtedPhNVwmtH22z0cK1Lk7uY4t7EbPHrSylHr2LpZ2jftd3jjRW52i4Rop4WCCpmjd7fQ8nyZl4PtQh0hV/fEzJkUKubgRAF+Yuz45TCqdwEjaz12+z4NM4KpmeIAeQDRBjxzoK3n5uPDWi662FL0fqTl3BGY4yIg+5cwGSAAlSSOC8QTL0I5Dl0m7S3LKUQXnWwylMBLsDfDtBO4DMdeDvHI9D9N6FODIaR03mST1VbhgiPZj5IrmfPJ6UplIRDQHWlQZRp09NB3t2PjDSVU8RSOrPWSU1IQ72zeV2e+N4J286DhLRjpM7LqonJn5lXW5Ops+n6cePJ69FF2cP54mY9LKH3L/ezanHB/lvkZC/v2tK2rMRxpDiJ8PCowNyM5gUslusBtI=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(40470700004)(36840700001)(47076005)(54906003)(1076003)(36756003)(356005)(83380400001)(336012)(40460700003)(82310400004)(316002)(107886003)(6666004)(5660300002)(110136005)(70586007)(70206006)(4326008)(81166007)(36860700001)(426003)(508600001)(86362001)(8936002)(2906002)(2616005)(26005)(7696005)(186003)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2022 18:17:46.2755
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 92b280e7-315d-49a0-eb60-08d9df65d270
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1131
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If any PME event will be generated by PCI, then it will be mostly
handled in the host by the root port PME code. For example, in the case
of PCIe, the PME event will be sent to the root port and then the PME
interrupt will be generated. This will be handled in
drivers/pci/pcie/pme.c at the host side. Inside this, the
pci_check_pme_status() will be called where PME_Status and PME_En bits
will be cleared. So, the guest OS which is using vfio-pci device will
not come to know about this PME event.

To handle these PME events inside guests, we need some framework so
that if any PME events will happen, then it needs to be forwarded to
virtual machine monitor. We can virtualize PME related registers bits
and initialize these bits to zero so vfio-pci device user will assume
that it is not capable of asserting the PME# signal from any power state.

Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_config.c | 33 +++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 6e58b4bf7a60..dd9ed211ba6f 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -738,12 +738,29 @@ static int __init init_pci_cap_pm_perm(struct perm_bits *perm)
 	 */
 	p_setb(perm, PCI_CAP_LIST_NEXT, (u8)ALL_VIRT, NO_WRITE);
 
+	/*
+	 * The guests can't process PME events. If any PME event will be
+	 * generated, then it will be mostly handled in the host and the
+	 * host will clear the PME_STATUS. So virtualize PME_Support bits.
+	 * The vconfig bits will be cleared during device capability
+	 * initialization.
+	 */
+	p_setw(perm, PCI_PM_PMC, PCI_PM_CAP_PME_MASK, NO_WRITE);
+
 	/*
 	 * Power management is defined *per function*, so we can let
 	 * the user change power state, but we trap and initiate the
 	 * change ourselves, so the state bits are read-only.
+	 *
+	 * The guest can't process PME from D3cold so virtualize PME_Status
+	 * and PME_En bits. The vconfig bits will be cleared during device
+	 * capability initialization.
 	 */
-	p_setd(perm, PCI_PM_CTRL, NO_VIRT, ~PCI_PM_CTRL_STATE_MASK);
+	p_setd(perm, PCI_PM_CTRL,
+	       PCI_PM_CTRL_PME_ENABLE | PCI_PM_CTRL_PME_STATUS,
+	       ~(PCI_PM_CTRL_PME_ENABLE | PCI_PM_CTRL_PME_STATUS |
+		 PCI_PM_CTRL_STATE_MASK));
+
 	return 0;
 }
 
@@ -1412,6 +1429,17 @@ static int vfio_ext_cap_len(struct vfio_pci_core_device *vdev, u16 ecap, u16 epo
 	return 0;
 }
 
+static void vfio_update_pm_vconfig_bytes(struct vfio_pci_core_device *vdev,
+					 int offset)
+{
+	__le16 *pmc = (__le16 *)&vdev->vconfig[offset + PCI_PM_PMC];
+	__le16 *ctrl = (__le16 *)&vdev->vconfig[offset + PCI_PM_CTRL];
+
+	/* Clear vconfig PME_Support, PME_Status, and PME_En bits */
+	*pmc &= ~cpu_to_le16(PCI_PM_CAP_PME_MASK);
+	*ctrl &= ~cpu_to_le16(PCI_PM_CTRL_PME_ENABLE | PCI_PM_CTRL_PME_STATUS);
+}
+
 static int vfio_fill_vconfig_bytes(struct vfio_pci_core_device *vdev,
 				   int offset, int size)
 {
@@ -1535,6 +1563,9 @@ static int vfio_cap_init(struct vfio_pci_core_device *vdev)
 		if (ret)
 			return ret;
 
+		if (cap == PCI_CAP_ID_PM)
+			vfio_update_pm_vconfig_bytes(vdev, pos);
+
 		prev = &vdev->vconfig[pos + PCI_CAP_LIST_NEXT];
 		pos = next;
 		caps++;
-- 
2.17.1

