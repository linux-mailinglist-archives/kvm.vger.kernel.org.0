Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8B652B86E
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 13:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235436AbiERLQq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 07:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235372AbiERLQm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 07:16:42 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2046.outbound.protection.outlook.com [40.107.223.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C34674D3;
        Wed, 18 May 2022 04:16:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mqFQA87EnpQ09LC2vhedVnnDRPkJLmV2hX/U8n/v68EFvGxcmaPSyUER1WFUyk8SrsVCDNSZj8EPGwrbXKNXZ+HQ0hmx9shHGCinCRJxo//5PfbnJhUdQH4cuE/wBHpcV7fL1eBnKB8khBotOKJcVtu9OQA/6rWtmvyfdv8IzpX3Zv/EHXXL1NQ6mk/dDSMWkw4TGHk63b2e1vn6xSCmY/3RWQkt7b9G7Dld4v8Y1HbMpLfZyuLsrZl15ZQrQvp+AbJsOGGJrW9ZzuUMmQLPoWEojuKpBTSRL3OCc1fGzBbW8hHLMZ6zYyEKjSgStmXOVxwLY4QgR58UQG1HYIgceg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=85CCdCZQbNOGVJdgVRczXfrtu86zJq2RH8DcWHSPlo4=;
 b=URW+Co7uVl7iG86IYg8AFM8c2GMf7oc0i1v/PnQ23f1YNX11Xo9aF5nNd8sLCAITnqcUUhsi1oGAb0ti9f35mEbK4eLdrywVjZ4k1MUCv46Y0cavdiY1xv2m26o57/AGiqDgA4PelNATWOrCu1RWX9RC+m2wqmTAC9S0dhJ6ibYlnRIh5M5hwBeMAHEw+M4dbNYAe0Y2BDwHl4Ye7B7lSyvjmS6HCVZWCE+RNm3Pm8Usk3q4OgIR2AF/eY/FUG/fIjJgLyEsIQ/qvRE21ROb9UdKPhSyJWM7TEeD3zeEbJkDJPM1k5IiMTHaDOxCTQDRW6VSmOqgAZcMncWeSG4gMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=85CCdCZQbNOGVJdgVRczXfrtu86zJq2RH8DcWHSPlo4=;
 b=eIxxKV1NkNGGebLmqBYHoIqJK8FapqEUme5vbWOxQhYqaaXG+A6NCbGMzhmQQt+is1fQdGP0yyzJn/g01kO0bUO3iheCo/YC9u/lLk7jtr69EPseBSceeBYJD4pz54uW+DntFlrtImm62eLJOvymwIQ9S7mkmeDMAHHjCWhMl2U4W87dkcBBoWnKRicZmYBV+nSkjuCIRnOqETMCrRTK9DUmrc5jpBiD4u2OmYia+j4H+N9XEFTVNEpIcn7kAPGXb/FZSJAv/ANs+tHWor2TpcXuDwUXzoorWYFBtmrZDScWD9Ee8lFtAnoRLhy/w63nnIDeG93wQOCCpP4nzMnuSg==
Received: from DS7PR03CA0033.namprd03.prod.outlook.com (2603:10b6:5:3b5::8) by
 DM6PR12MB4042.namprd12.prod.outlook.com (2603:10b6:5:215::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5273.14; Wed, 18 May 2022 11:16:38 +0000
Received: from DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b5:cafe::99) by DS7PR03CA0033.outlook.office365.com
 (2603:10b6:5:3b5::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14 via Frontend
 Transport; Wed, 18 May 2022 11:16:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT006.mail.protection.outlook.com (10.13.173.104) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5273.14 via Frontend Transport; Wed, 18 May 2022 11:16:37 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 18 May
 2022 11:16:37 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 18 May
 2022 04:16:36 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Wed, 18 May 2022 04:16:31 -0700
From:   Abhishek Sahu <abhsahu@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>
CC:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Abhishek Sahu <abhsahu@nvidia.com>
Subject: [PATCH v5 3/4] vfio/pci: Virtualize PME related registers bits and initialize to zero
Date:   Wed, 18 May 2022 16:46:11 +0530
Message-ID: <20220518111612.16985-4-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220518111612.16985-1-abhsahu@nvidia.com>
References: <20220518111612.16985-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e893369-4358-4441-460c-08da38bfe051
X-MS-TrafficTypeDiagnostic: DM6PR12MB4042:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB404252360C5809692D71B43ACCD19@DM6PR12MB4042.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 798b5BkDvjRrA+GXKiFmNeH+qD2R47wqJcx8X3yomIbQG0Fji3D4xAftqyilhRlWly528Rp+4/+ZuvhqNzFEafYPwUy+b32YavAohuZ5QUaXDO74CPzL2bX+Eov24LIxuqAenGDZ1P9Z5WGlO7J8JBeBdOkUW4+IqSGP2BsDqn6MBnO6OE4MNNqyVUoUY/uFlYyQpNUZm99wpE/dYyIy7MpmYwXhX0Cd5MOYOMjzS0/NATImHHAiT04PotIXgsZsrFBN7C5EYTOI/gLfwHvzLX9Desdh1kWHmkweUqEUMCts7q3yQawHwbRAgYNODQ5xq7O0zdgCBaiaVFBV9B4DfX+jzceoaVx7CTet4itLgPkxRjxJs61Egsss8oymO6dKXOScv8sw9stafnKBrGeLoYV5OOWToCJgT/8ew+aulHkmmG1gYf5qAISw3M/2iND6gWnBouqhc7JMlXqwsfjm8Ytnm7K6iOulxpHeYpxvI1l1D2AriGGP/j+cNo3pD0dxqTkhxQeRAmka+NfeMqhZH2Uq7gX2yPdhw54mF59232RnZgjmCF2+XdqWxMGevhcbL08ydwKUcLYyGV0rmcQ+cRc2X7WFKh7o9cod1GdEEUaTfK7Y27aesXzXAyHZxIGPKiOHuFH2ZMAJo6KgEsrAiLNiS+AO6IiGbYzepFJ2NjlYcaFLtIv5cmiQgjha5YxgFnK0P4ZW7reh9eSD4zxvPw==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(83380400001)(86362001)(54906003)(70206006)(5660300002)(110136005)(8676002)(7416002)(4326008)(107886003)(40460700003)(508600001)(70586007)(186003)(47076005)(336012)(36860700001)(426003)(2616005)(316002)(1076003)(82310400005)(36756003)(81166007)(356005)(7696005)(2906002)(6666004)(8936002)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 11:16:37.8428
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e893369-4358-4441-460c-08da38bfe051
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4042
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index ea7d2306ba9d..9343f597182d 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -757,12 +757,29 @@ static int __init init_pci_cap_pm_perm(struct perm_bits *perm)
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
 
@@ -1431,6 +1448,17 @@ static int vfio_ext_cap_len(struct vfio_pci_core_device *vdev, u16 ecap, u16 epo
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
@@ -1554,6 +1582,9 @@ static int vfio_cap_init(struct vfio_pci_core_device *vdev)
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

