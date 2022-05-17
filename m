Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 111F9529EB6
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 12:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245534AbiEQKDK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 06:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235788AbiEQKCz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 06:02:55 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2045.outbound.protection.outlook.com [40.107.220.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 946D92CDE8;
        Tue, 17 May 2022 03:02:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hczejvaILdNq2XHaTEQrs+0gkCB1uwYN4s7exC9huFeCxzJUQZmvQ8vwnya2aP2j2BeRhuxaXbveUvv0TZziGtQ37uIuymTw7tPtHIclNd9hjcVxUa2YpFBlMlVHDdHd4v9hPP6M8VZobAfZ1Za18v2NbnjZJ+7z/9OmlPmyYY/xiJ7TXSIT5rnYhbffMslykQVHOKauPthiETk5HR92Ejbb5CwcAH5tGpprOvKcQmsuEyZL4CcRG9UDLgQByY1odjk91rDpB/OT2RVR4w/Fo/Zog5guYFiZBqRxe2+nbvUNN3UXNVrEQTIIt6nRnqOOZUAOmEr6H1NGBHaVO+Ytqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wEsiTjKfA1ajR5+VaUZ23yKgsH5hoZBUAK8DtJQDaUU=;
 b=ZReaDHZ0zW3REncdc49MQEflpqUqcyA1LtNBapXckWCBuaphSJatDv1tLwwlkCiuABBI09jevsTsku5L+MuUq97ygmZi17ul6z+kSk3/oSFcE1QGEPmdLWH2DoaFeD6LciIi4AibKuQZVGgy4VKHPa+KbI8JYAt04YQM1pV48GKMgsWMSXMvFm//g1YfxYg6ZTf4DJ2ztiQZfrdVGAnPvLpCdbVmMXsJn+vhyBndinpeRSBj9VGzEBKshGV69IOKRHsVBmlF5Fg+NJQbm97F4DD8immewa+R7OEFMnpOZ1TasMnBOkoiJjiSAQUUqdmIuS/6WnLoX6o49ARWai/dIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wEsiTjKfA1ajR5+VaUZ23yKgsH5hoZBUAK8DtJQDaUU=;
 b=BWaDx01vU6n/+dg8kf0p4J9/hQxbfpPFar9Xqg9mt7GB1j8hw+E27l/m/4vU16H63V6ailcWN++cDj4k8PuM7Q3Q5vMq6bEV0ercCG9gBhVAkJXCp6AvhObqVsKa2Xy9M+6mXZiQ9oRJ+h3Vmk9I6rKrFSmRC4VPX+jTiIZw8PffE61S2cLXnMBahj5b2ZRHLHhxX7xeSuGqRiT8tMgZQ7e1gBduqdUkNlu3jH4e/JEPCc03LGMFOM3z1kilpvOEHSQPYycT4gdoTztUvQWgc9fczR4N7LXs4WNPI3R3dKq5Erf4bN/KxUYuuC/tPbkrc1Og6yvCAg7uPydj3/w5DQ==
Received: from DS7PR05CA0084.namprd05.prod.outlook.com (2603:10b6:8:57::25) by
 BN6PR12MB1332.namprd12.prod.outlook.com (2603:10b6:404:15::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.18; Tue, 17 May 2022 10:02:51 +0000
Received: from DM6NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:57:cafe::3) by DS7PR05CA0084.outlook.office365.com
 (2603:10b6:8:57::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.4 via Frontend
 Transport; Tue, 17 May 2022 10:02:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT063.mail.protection.outlook.com (10.13.172.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Tue, 17 May 2022 10:02:50 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 17 May 2022 10:02:50 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 17 May 2022 03:02:49 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Tue, 17 May 2022 03:02:44 -0700
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
Subject: [PATCH v4 3/4] vfio/pci: Virtualize PME related registers bits and initialize to zero
Date:   Tue, 17 May 2022 15:32:18 +0530
Message-ID: <20220517100219.15146-4-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220517100219.15146-1-abhsahu@nvidia.com>
References: <20220517100219.15146-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3df8610-9912-45b4-aeab-08da37ec673b
X-MS-TrafficTypeDiagnostic: BN6PR12MB1332:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB13326121E6AEBED958BEA73BCCCE9@BN6PR12MB1332.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OHvnvZ/WY9GIyHQLdLs3ifgH8rgVq/XE+DDc+OKXALhzJ1cZUmb/B6AeK4OEeiTQU4Bhl9b+bjn8bi3qPaIJh4YbXTMKIdZiT3+7JhQYdRaFw3O9BK7L8YtnDWJ1X7ditNbbfr/uEVWwojmom5u/rPlL5eyjgo2bf88GcRIteEi69227DIRJqu3OHMwBXM7edLMIh+AhER7JEzJGE7K8iiCProWBSijEH02y/dgmXrYa3SJfX8LXAdMf/kws3yEf60RN6AKMHGMC9CaAbQTw0aK8DPXWako7qHKvgDumxHmTgm/0DgNGqatDJBF/YsAVrsA5rhuvK0I0gQrfldp9oV0Ns3BotX0+nkvdE5kXRfrUDG0pG05eX8WoJ9azeZL1XWeB37EDqwLbaFAMgW/iih3VQmrwpGOo5d4ROBdhyzvUEfn3CQ5qfD+RzfWxpc89Q+YYkdi/F98FnNDnLK0P6Ut8BR43q8aEdV4J1pwJaYECnkcJ9ISxfhzaY7yc5fPdJ+iNF6y1v4sC3xVqk0HaF7wo5WKw4/zMz9bIoBYHgatDZ3Jbv+1m4Vdb+jVh0TC1LI+bSEQDcJ02N4co4vJU/8dgYLanvzXpungbJickaQZdlMhEQIGTicAWsrohQN1WEJ6sqiqFUGgrmhZUDv5QpyvOFfkYO32TX+mewOZFX9D1cAtj48iKtzxG2ZjkgQa9P4WX0RBHPS+7jmjg+5JGAQ==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(316002)(36756003)(36860700001)(2906002)(81166007)(7416002)(7696005)(4326008)(8676002)(6666004)(86362001)(5660300002)(70206006)(356005)(2616005)(1076003)(82310400005)(70586007)(54906003)(186003)(40460700003)(110136005)(8936002)(508600001)(107886003)(83380400001)(26005)(426003)(47076005)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 10:02:50.8870
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c3df8610-9912-45b4-aeab-08da37ec673b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1332
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index d9077627117f..188108d28fcd 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -741,12 +741,29 @@ static int __init init_pci_cap_pm_perm(struct perm_bits *perm)
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
 
@@ -1415,6 +1432,17 @@ static int vfio_ext_cap_len(struct vfio_pci_core_device *vdev, u16 ecap, u16 epo
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
@@ -1538,6 +1566,9 @@ static int vfio_cap_init(struct vfio_pci_core_device *vdev)
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

