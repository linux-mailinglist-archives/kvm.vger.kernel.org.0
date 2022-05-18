Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D70EF52B879
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 13:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235404AbiERLQi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 07:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235372AbiERLQh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 07:16:37 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2070.outbound.protection.outlook.com [40.107.236.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0256466CA4;
        Wed, 18 May 2022 04:16:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DlUKKe4ppBGEXRdFYs+dgfALdhkpZDEdQOzB4pKShX6wHTsbUMgqZ2i7bTGr91Pm+jAqbOAZv1BRmR975K4YrAIcIGjOWWJb3nl8tYnVQpMV6Ey089RUGs4SbkKkg5cma2xBj8jHB7sb+aV67DGyX+n64DfQvoZEsV17ADyWwbZWVVJDTDeRabsEIFJEiXqjMXCNuOU8RE/KO2zZB7pah357jgt1XJBW9a8TCD+1qYmKhsPwnCuQsHtaMwixB37I6Fl2FBvbU2c9dtFvrbIlqCiCayRpDolPWkUuNYn1Wj4XU5ki1aFY4tU7NmTC1r+anoSxuMkNMSBhuzvmfCZ2Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zu2B41LaYkojggHM8c3io4sogUWsky60hLpgONN/rWQ=;
 b=jSTrNvDft68OOT04ev1u/xCLwolscS70xC8y/st7JRUoMsXfA0LtRp6WnRk86aSZN9V4/fKX7FWCNjX+pPRO8COUB+xrFc9WJUDgpJO/Gut8RzCbZ4B+7C20OqhRNfLC9BCMzqalfvv+w6X3evSOXpKBTQy1c+pMyluUtkwd3QcvsGitdYoOQvH9gTfnuTT9aa5KMUAOUAoBgRacqcUg94dlywgx1WLKFTM8h53sPFiS6XhpszMjUs3XAPIrfeHeAwUNIvp9uk1N6pWGs8hSUNN0qCrTxmhLUuSbkhwXkthUbJer1MRvD47zHyiwZJeqfN8s7+Oqin0JrN0WP54esQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zu2B41LaYkojggHM8c3io4sogUWsky60hLpgONN/rWQ=;
 b=A7GQm9RyDI5rdWwGNNXmBZZCxr8ptGsIEasgceWeaVJW1T2dBf/YJygVQFw0Z/mmhBLM5a2W5G1zuBa/QOTRNc8WhjxfZShUxxKcawh4O/w2PWKpy8PrqOSehwhRCjdRVttkctIxfkhgNtz/fSVOJknN882S7CSFdhi/Uv3y8cPOI370LGgWzblnhZSfI0tH8fTIeaip+Q+LkLa9dRkwfJRV9CPEGLi7d5wNr+aWe0qnsdXcq1u8ZRRXJGqRtQ1kgmyYZ63+HeufPA2Z1wdSmhqSRd8KZ9LBR7PenVoXJwqjzNrIaTTLBFHvK3JyE1YGCBeu6LHn9EDvxQYsWEKNfg==
Received: from MW4PR03CA0316.namprd03.prod.outlook.com (2603:10b6:303:dd::21)
 by MN0PR12MB6199.namprd12.prod.outlook.com (2603:10b6:208:3c4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Wed, 18 May
 2022 11:16:27 +0000
Received: from CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dd:cafe::e) by MW4PR03CA0316.outlook.office365.com
 (2603:10b6:303:dd::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13 via Frontend
 Transport; Wed, 18 May 2022 11:16:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT029.mail.protection.outlook.com (10.13.174.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5273.14 via Frontend Transport; Wed, 18 May 2022 11:16:26 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 18 May
 2022 11:16:26 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 18 May
 2022 04:16:25 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Wed, 18 May 2022 04:16:20 -0700
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
Subject: [PATCH v5 1/4] vfio/pci: Invalidate mmaps and block the access in D3hot power state
Date:   Wed, 18 May 2022 16:46:09 +0530
Message-ID: <20220518111612.16985-2-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220518111612.16985-1-abhsahu@nvidia.com>
References: <20220518111612.16985-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 928219ec-31b7-4b41-c687-08da38bfd983
X-MS-TrafficTypeDiagnostic: MN0PR12MB6199:EE_
X-Microsoft-Antispam-PRVS: <MN0PR12MB6199F38C1E5ECD58032A0700CCD19@MN0PR12MB6199.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vwKwusKU8bDPgvQxqibU2eg38+fTTlcC04DDQjYfyUIsiQJU1FPIaMfMiP1IpLaskcrBpoTcgAgkyUynU9bcEni3B6NelFJnt1bkEg+/hXpwyqhldKZnCPIpoHrGMNIJo/AyL9gthxFovB9dYy1AYFkWTLqXOSZPsUa+Ao2cF9t+13YK6j5oczpUCzxRHK3jk7m1l3Gw+ALxpyhe/IRJv30c7bCNJyMRGWBfRWgLDQwlP2tQWGFa7fVA7+Yo9BNkqsX2hXqSKPsudfDdgj0pht9MEPRu7cE8QJ7A8tvBwtDtKXeP3n8yaEOlzKdd4CKSPPrv94Uiepdb7wdSEHZgKpnJL4sgzOyCWJVrijVovXGcazQhvRUlPERrXQYEqBlKZsuX5SXcYPjg8L2NfcFYepHuzqj6i85RBr7dVhb0AJkBjb7hb4mDP94HXYM5lXR96WgI+Q3635jHb1oE77ZKGgdbrFUmllx72CSnxMrYBoYPLN8kroN7s3gZHUuPH/liuukN+oAVuYZu+jtPWfk6vCbiQAaHiKkC6oxsRRXqhYNT2QJrrHouqWsL29pIUiNEDk3e7uQn9+OmNkd0pkOxs7AKjrzhWc59cYuUR4gud16e+huEW7AuhD40jES7LqZKA6gu37kOISJ+7UPLd01j7tZFFgrniGobx56LY0uULDaUbMNJDF18cSeToHyj1Hh0D48kOQz9bGW3JNcTGSqTIJEL0oGxoGEb4mb9SwzZCTI=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(1076003)(107886003)(2616005)(82310400005)(83380400001)(70586007)(508600001)(8936002)(40460700003)(7416002)(356005)(2906002)(4326008)(36860700001)(8676002)(26005)(336012)(426003)(186003)(70206006)(81166007)(86362001)(54906003)(316002)(110136005)(36756003)(47076005)(6666004)(7696005)(5660300002)(32563001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 11:16:26.4453
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 928219ec-31b7-4b41-c687-08da38bfd983
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6199
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to [PCIe v5 5.3.1.4.1] for D3hot state

 "Configuration and Message requests are the only TLPs accepted by a
  Function in the D3Hot state. All other received Requests must be
  handled as Unsupported Requests, and all received Completions may
  optionally be handled as Unexpected Completions."

Currently, if the vfio PCI device has been put into D3hot state and if
user makes non-config related read/write request in D3hot state, these
requests will be forwarded to the host and this access may cause
issues on a few systems.

This patch leverages the memory-disable support added in commit
'abafbc551fdd ("vfio-pci: Invalidate mmaps and block MMIO access on
disabled memory")' to generate page fault on mmap access and
return error for the direct read/write. If the device is D3hot state,
then the error will be returned for MMIO access. The IO access generally
does not make the system unresponsive so the IO access can still happen
in D3hot state. The default value should be returned in this case
without bringing down the complete system.

Also, the power related structure fields need to be protected so
we can use the same 'memory_lock' to protect these fields also.
This protection is mainly needed when user changes the PCI
power state by writing into PCI_PM_CTRL register.
vfio_lock_and_set_power_state() wrapper function will take the
required locks and then it will invoke the vfio_pci_set_power_state().

Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_config.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 6e58b4bf7a60..ea7d2306ba9d 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -402,11 +402,14 @@ bool __vfio_pci_memory_enabled(struct vfio_pci_core_device *vdev)
 	u16 cmd = le16_to_cpu(*(__le16 *)&vdev->vconfig[PCI_COMMAND]);
 
 	/*
+	 * Memory region cannot be accessed if device power state is D3.
+	 *
 	 * SR-IOV VF memory enable is handled by the MSE bit in the
 	 * PF SR-IOV capability, there's therefore no need to trigger
 	 * faults based on the virtual value.
 	 */
-	return pdev->no_command_memory || (cmd & PCI_COMMAND_MEMORY);
+	return pdev->current_state < PCI_D3hot &&
+	       (pdev->no_command_memory || (cmd & PCI_COMMAND_MEMORY));
 }
 
 /*
@@ -692,6 +695,22 @@ static int __init init_pci_cap_basic_perm(struct perm_bits *perm)
 	return 0;
 }
 
+/*
+ * It takes all the required locks to protect the access of power related
+ * variables and then invokes vfio_pci_set_power_state().
+ */
+static void vfio_lock_and_set_power_state(struct vfio_pci_core_device *vdev,
+					  pci_power_t state)
+{
+	if (state >= PCI_D3hot)
+		vfio_pci_zap_and_down_write_memory_lock(vdev);
+	else
+		down_write(&vdev->memory_lock);
+
+	vfio_pci_set_power_state(vdev, state);
+	up_write(&vdev->memory_lock);
+}
+
 static int vfio_pm_config_write(struct vfio_pci_core_device *vdev, int pos,
 				int count, struct perm_bits *perm,
 				int offset, __le32 val)
@@ -718,7 +737,7 @@ static int vfio_pm_config_write(struct vfio_pci_core_device *vdev, int pos,
 			break;
 		}
 
-		vfio_pci_set_power_state(vdev, state);
+		vfio_lock_and_set_power_state(vdev, state);
 	}
 
 	return count;
-- 
2.17.1

