Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0F9529EB1
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 12:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245569AbiEQKDB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 06:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244799AbiEQKCs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 06:02:48 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1615F53;
        Tue, 17 May 2022 03:02:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LI+Z3nLuzwUTBl35IRUId/q3CLSTmNhlhxyBHZMrPcnmbY2aeCpogFO7fdI9rxMJU2WrcaNAlDYeKPV6jtUq05okmbGDw3j0RVoQ2CafEEmngXYLU/iMRt0d3bGIBGHDVrFp81e6ilotZyJFOYHvxllVF4wWI6Ceytk+gvLB92AXMCUpF06nd4yNteBlH/o3wAwTnbK5wTFpCiiiZM02g38R/pi3oZ96yE6G7uJPDFSrx7vE8rQCoGbZcOja5i4XTS1+1j0ySe2LU4oY5cG9rKSMDdwmGyqGaHQypA87DoJBTWanGMUNbX2gY+QAcfLZPgfuc2SWlReRfnEyEc6ybw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sSKtSlcRiVZebQuVJ8RbTzpvApWwBXW65adVqf5/JdI=;
 b=Psed6ZWME5DPS2Bi4TlBIbRe8i40Ad7NCdI/bn3y2cdJ+ZeT1smRPEpeL5w2jxg1jLLm36BxNvFIWw58tAQjA6oleVJTWNjaW+m4Ktv0vlAme58mvk5zgdMTdXxlT8sMiyoseewlPf/WakdZL0Codx7mF6Mm3dJbeeiGaXmiiB7exyrPulQw2hnH2upFoOrYccMkUAgZK25cLOhkYMV2kt89K6qWdq9qmAUoteuwtAb6sj9y6IGXGxnxWVWUjEbneXB7EAmNIzQMSQEo9bmzo9VPN92btYTLxQlGqaWJ10TN1pqJ6O6w0YsCCZX3zECK52It5mAvrfj/mLSdvMrxTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sSKtSlcRiVZebQuVJ8RbTzpvApWwBXW65adVqf5/JdI=;
 b=AfAcgrfBOaxu+dH9gXhVOzGkDjl9iQdFW6ENaoarXIPNi3k3jMv30fZ03NeRYaiv4qJzFV1YLcDsuZIkU6lRlGkaM7pm0NmmYCMFwBB35nb4oegtzDu4pxyzymypIUx9t59CHSP/4F+RQWmoWlKKpB8tFv021iw844m/gFClFyyDTtjdvGk8+WqKsvBBZzul1CwJldGeM9mlCOwgnLlzzjPns5Flm39i12pYnTP5ECv+lFLrHVyyc55TIlzVUWTivVGKxiBNBgNDht1Gg0ABP5qyt9Bw62qACeM9Q01mgsErashXr6DzDnmZU5+usTsGT5bpHIdsY1Kxu8huz3zpZw==
Received: from BN9PR03CA0228.namprd03.prod.outlook.com (2603:10b6:408:f8::23)
 by MN2PR12MB4565.namprd12.prod.outlook.com (2603:10b6:208:26b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Tue, 17 May
 2022 10:02:45 +0000
Received: from BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f8:cafe::47) by BN9PR03CA0228.outlook.office365.com
 (2603:10b6:408:f8::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14 via Frontend
 Transport; Tue, 17 May 2022 10:02:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT040.mail.protection.outlook.com (10.13.177.166) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5250.13 via Frontend Transport; Tue, 17 May 2022 10:02:45 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Tue, 17 May 2022 10:02:44 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 17 May 2022 03:02:44 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Tue, 17 May 2022 03:02:39 -0700
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
Subject: [PATCH v4 2/4] vfio/pci: Change the PF power state to D0 before enabling VFs
Date:   Tue, 17 May 2022 15:32:17 +0530
Message-ID: <20220517100219.15146-3-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220517100219.15146-1-abhsahu@nvidia.com>
References: <20220517100219.15146-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9bae0ea0-88b5-4b94-35de-08da37ec6414
X-MS-TrafficTypeDiagnostic: MN2PR12MB4565:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4565F93D5620E156A1EE5B6ECCCE9@MN2PR12MB4565.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 38rjHNhaaYgzQwYaUu6flh0gnaHygsaJkPBAFUSNmqVDi7Q8ML9YWZEPDfahZE6Vr1Pe0Hro70sFboDCsscyca5hRoVJhy83oqhWxSdO/0vxVo4HsSGVGX/0kcIc+rPqLQ8CR3tl2GLM7s8gvmWXdP7sTcn9iZqmQpXX6CkMHrr7XplwSmviNq8bldStaIbVYvphr/OXe/DMpi3xby8W8g+XYfPagSLM8n8C755g9fRmMwndJd1dEm0BgxMmNWzqF9WCbArQM+YtSgLYw5xuj/shtGpronRywveBA1n5G/DmMyaz8VaFwWGh7jXgFcc8M51ZYKTTXr9GxZDwMT4hFgv1I8k3fYaRt5+W6I5NdDUdwrSMKkvWgsUvmRnH2BaAyBakJrHMfpW8mBeg8uOh8s92Ho5cT+9TddOrmvcebGtbCOmMT4cQulJirKJGb+7QEyifCeOF39BDhRXddeZKG3z647pFeKzlYNVxGlX7zj+1SEPEkJv9iZ3Jm8g18NlUV8wMMsv+dHDrcDRFt+rTN4PaNycxrezPtl5NVyW/E8YTQ1+IidBK11JCJW1VK9dOmY/4CT64jDwU51G7pp1ynarTV8Oo0fYsJRLkBI6CSx3vpQ3DBGxN2aX2lwLiuuH6qhUvZzdWkpLckAt653ezzxrNa2iVVUsGNh3NkDQIXQjxB27BsmdTIYPSLzidW4Kv6lYgPVxOVOvXZb6MaMlH8Q==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(36756003)(81166007)(8936002)(316002)(1076003)(2616005)(82310400005)(107886003)(26005)(2906002)(356005)(7696005)(6666004)(7416002)(110136005)(5660300002)(83380400001)(54906003)(86362001)(70586007)(36860700001)(336012)(47076005)(426003)(70206006)(40460700003)(4326008)(186003)(508600001)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 10:02:45.5483
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bae0ea0-88b5-4b94-35de-08da37ec6414
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4565
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to [PCIe v5 9.6.2] for PF Device Power Management States

 "The PF's power management state (D-state) has global impact on its
  associated VFs. If a VF does not implement the Power Management
  Capability, then it behaves as if it is in an equivalent
  power state of its associated PF.

  If a VF implements the Power Management Capability, the Device behavior
  is undefined if the PF is placed in a lower power state than the VF.
  Software should avoid this situation by placing all VFs in lower power
  state before lowering their associated PF's power state."

From the vfio driver side, user can enable SR-IOV when the PF is in D3hot
state. If VF does not implement the Power Management Capability, then
the VF will be actually in D3hot state and then the VF BAR access will
fail. If VF implements the Power Management Capability, then VF will
assume that its current power state is D0 when the PF is D3hot and
in this case, the behavior is undefined.

To support PF power management, we need to create power management
dependency between PF and its VF's. The runtime power management support
may help with this where power management dependencies are supported
through device links. But till we have such support in place, we can
disallow the PF to go into low power state, if PF has VF enabled.
There can be a case, where user first enables the VF's and then
disables the VF's. If there is no user of PF, then the PF can put into
D3hot state again. But with this patch, the PF will still be in D0
state after disabling VF's since detecting this case inside
vfio_pci_core_sriov_configure() requires access to
struct vfio_device::open_count along with its locks. But the subsequent
patches related to runtime PM will handle this case since runtime PM
maintains its own usage count.

Also, vfio_pci_core_sriov_configure() can be called at any time
(with and without vfio pci device user), so the power state change
needs to be protected with the required locks.

Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index b9f222ca48cf..4fe9a4efc751 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -217,6 +217,10 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
 	bool needs_restore = false, needs_save = false;
 	int ret;
 
+	/* Prevent changing power state for PFs with VFs enabled */
+	if (pci_num_vf(pdev) && state > PCI_D0)
+		return -EBUSY;
+
 	if (vdev->needs_pm_restore) {
 		if (pdev->current_state < PCI_D3hot && state >= PCI_D3hot) {
 			pci_save_state(pdev);
@@ -1960,6 +1964,13 @@ int vfio_pci_core_sriov_configure(struct vfio_pci_core_device *vdev,
 		}
 		list_add_tail(&vdev->sriov_pfs_item, &vfio_pci_sriov_pfs);
 		mutex_unlock(&vfio_pci_sriov_pfs_mutex);
+
+		/*
+		 * The PF power state should always be higher than the VF power
+		 * state. If PF is in the low power state, then change the
+		 * power state to D0 first before enabling SR-IOV.
+		 */
+		vfio_pci_lock_and_set_power_state(vdev, PCI_D0);
 		ret = pci_enable_sriov(pdev, nr_virtfn);
 		if (ret)
 			goto out_del;
-- 
2.17.1

