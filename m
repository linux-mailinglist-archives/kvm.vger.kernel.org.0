Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0F14B9FFF
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 13:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240377AbiBQMWY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 07:22:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240374AbiBQMWW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 07:22:22 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2067.outbound.protection.outlook.com [40.107.223.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CCFE1EA724;
        Thu, 17 Feb 2022 04:22:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QUIx4mEj+7rSklPwiE8ZWy0XirOHL8ma48izi1NsbSMjzFnnOipI3hj/OEHBLfnP+lCA1nVOsxBZXGzpagyh/5C/S+XR+IZODKMGXEJANpsTk13xCw8iQ+4W0K0UNYIduPVZtZtDvdBu+SCEVymvfA/aagEHG4xhW2w6e16ZL91wE5TvrTSvS8nMop+1BI/o4zQ118qHNioy43N6Ru7aQ7vGN+PqOViCLxaXFcp/y8qAB4L1vA/lZOKSzAkNcqnRrNTHmhV4zDdOJOGYoOZECLt9XpT5M6tU1dnf3ydfD/TZ6t5UBxmxNzEUYGBa4bpI58SOWgsSpkilBgq0dqrHdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ERhehIB3cNgBaHKklKaQG1N7YTEFVQwy1uO7Otqsqbo=;
 b=RZqfFCA8czfYCwIMQjZ7FIhaH0KFlwRg1MpEorNbfFnbBo1Ic1/3zaVHt4/4aC20GE967peGjVgyRp95FUT1Zq605mqklOBTwQlm3f+O4Oydkk9MmiixNoaIOS5pfPlFDxErlZJtukeCF4l5OdpqZ3A7MawDFv5ZTl3FRCtVoRV9G9fEYNss0fui8EtmNUx11BOhr01Uv7SH7bq7iUj028FATUEB4aoq4ve1Ow45nhEvJSoWzy0HgfSuNiGpzSID9iMM1UQzEGmzuvcZqXKU3kvmyTclpec0rYzLLbOgB933PdIInPd3JR1Vv4JtT1lEc/oXOGPd7aCy7HFR6GB2aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ERhehIB3cNgBaHKklKaQG1N7YTEFVQwy1uO7Otqsqbo=;
 b=k9/cr0yF+m1INvFt6HlMdZsYK7RFXF2l6wYFAaF2b8mzp9z7LUyoOhZxhT9wC3KM05OjPchfYKDzTez9EA1eWjR9CUvRsvqPCEYYCMd93K3VGNkDWM9b5K1aXsexIvPYn8oizZt310NZ8XiyPH3S+a6n/tH8HzWOOua9JwYYVn5FrFnWWpUMxsT57e5KH5diePr6Nezwg3rJaC9JvQKQK76ZAJHvho4nwZFVMEU+CarKgUCFk6KMhI2jXVnGpP2VSHj0IkBwTNkpkkBgZYtOSnObzpeQqXMqMUN+GqBRz+RMXXV5GleBQquE0/sSwfq904WDoSa8eM1QRVOjTysgIQ==
Received: from BN9P221CA0028.NAMP221.PROD.OUTLOOK.COM (2603:10b6:408:10a::10)
 by BN6PR1201MB2514.namprd12.prod.outlook.com (2603:10b6:404:b0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 17 Feb
 2022 12:22:06 +0000
Received: from BN8NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10a:cafe::54) by BN9P221CA0028.outlook.office365.com
 (2603:10b6:408:10a::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16 via Frontend
 Transport; Thu, 17 Feb 2022 12:22:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT053.mail.protection.outlook.com (10.13.177.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Thu, 17 Feb 2022 12:22:05 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 17 Feb
 2022 12:21:30 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 17 Feb 2022
 04:21:29 -0800
Received: from nvidia-Inspiron-15-7510.nvidia.com (10.127.8.9) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.9 via
 Frontend Transport; Thu, 17 Feb 2022 04:21:25 -0800
From:   Abhishek Sahu <abhsahu@nvidia.com>
To:     <kvm@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
CC:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        <linux-kernel@vger.kernel.org>, Abhishek Sahu <abhsahu@nvidia.com>
Subject: [PATCH v3 1/2] vfio/pci: fix memory leak during D3hot to D0 transition
Date:   Thu, 17 Feb 2022 17:51:06 +0530
Message-ID: <20220217122107.22434-2-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220217122107.22434-1-abhsahu@nvidia.com>
References: <20220217122107.22434-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0e62a61-7716-489a-f068-08d9f2101bfe
X-MS-TrafficTypeDiagnostic: BN6PR1201MB2514:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB2514184C5DA0715A0796E548CC369@BN6PR1201MB2514.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mrTtcXEkszThE+JmcV0fQj/4imNhjmFHgBRO5l/5z3z8Ft53/1HGxN3yXSeIvUSv55FKKP43LBo7OS+icQ02epOg6WbXrrEmfGt/YF7rmw7bNThBzj4JHFiJvIdE9czr76g4/Uf3RuEmEv86v3ITJoGySgcw75tX3GQV3vQt9PhEmYwxSDUWvY8KMRUUFdgo3HbKtHhnpNWc129ICuVd2XnC1s1Vzcv0xWXetLgPaQeASxZCixJrDQUz9d7f+ZqLc1ttwIHESaBzz4oE7O02vg9TIDvqNx0gxp1Jw0DEYFPhz5X211f5id9IWwZTJor0GBtpT6g0g6h0PrqpTLxQKakmQsEjvNTQ9kZtN2f+N3oZakKEmObg5VWkoJ3Gl9mBuuoHZ2q7jsyI4LQTGi1tGD+Pa1wLbqwX+LY3ut2XUcCtvqCa6T6FPOTSC0stIVBBj+EqfYzBbjXodYm7VmRTXxGuL/uy7XonK9XQxb31hRoXzwW34EYKv/3DOaqd7NUZqyqSFSBE+CheCsF9z0o8Ks2LRLgtZqs7KQJNYZfAfKn2xWXtpXRONbnbnwAls95U8pbWjKTxCOndshUJ4TeDuTM50WFXs5jQm3gKOHfhmv75amDvzE+Vzl8w3Rzm6o0qO3uenXhTxt3Ovb0Fc+kubfHdfdV1PImAJC/dwAnjVUywDrZhxb0owoesH0dZBfdEMYYs/rtldLSzv3NJbivS9ndRH9tILsKMBd3T6ttkrW0=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(8936002)(4326008)(47076005)(2906002)(36860700001)(110136005)(40460700003)(54906003)(5660300002)(8676002)(508600001)(70586007)(36756003)(6666004)(316002)(70206006)(1076003)(2616005)(26005)(186003)(107886003)(356005)(426003)(86362001)(83380400001)(81166007)(7696005)(336012)(82310400004)(32563001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 12:22:05.0851
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b0e62a61-7716-489a-f068-08d9f2101bfe
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB2514
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If 'vfio_pci_core_device::needs_pm_restore' is set (PCI device does
not have No_Soft_Reset bit set in its PMCSR config register), then
the current PCI state will be saved locally in
'vfio_pci_core_device::pm_save' during D0->D3hot transition and same
will be restored back during D3hot->D0 transition.
For saving the PCI state locally, pci_store_saved_state() is being
used and the pci_load_and_free_saved_state() will free the allocated
memory.

But for reset related IOCTLs, vfio driver calls PCI reset-related
API's which will internally change the PCI power state back to D0. So,
when the guest resumes, then it will get the current state as D0 and it
will skip the call to vfio_pci_set_power_state() for changing the
power state to D0 explicitly. In this case, the memory pointed by
'pm_save' will never be freed. In a malicious sequence, the state changing
to D3hot followed by VFIO_DEVICE_RESET/VFIO_DEVICE_PCI_HOT_RESET can be
run in a loop and it can cause an OOM situation.

This patch frees the earlier allocated memory first before overwriting
'pm_save' to prevent the mentioned memory leak.

Fixes: 51ef3a004b1e ("vfio/pci: Restore device state on PM transition")
Signed-off-by: Abhishek Sahu <abhsahu@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index f948e6cd2993..87b288affc13 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -228,6 +228,19 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
 	if (!ret) {
 		/* D3 might be unsupported via quirk, skip unless in D3 */
 		if (needs_save && pdev->current_state >= PCI_D3hot) {
+			/*
+			 * The current PCI state will be saved locally in
+			 * 'pm_save' during the D3hot transition. When the
+			 * device state is changed to D0 again with the current
+			 * function, then pci_store_saved_state() will restore
+			 * the state and will free the memory pointed by
+			 * 'pm_save'. There are few cases where the PCI power
+			 * state can be changed to D0 without the involvement
+			 * of the driver. For these cases, free the earlier
+			 * allocated memory first before overwriting 'pm_save'
+			 * to prevent the memory leak.
+			 */
+			kfree(vdev->pm_save);
 			vdev->pm_save = pci_store_saved_state(pdev);
 		} else if (needs_restore) {
 			pci_load_and_free_saved_state(pdev, &vdev->pm_save);
-- 
2.17.1

