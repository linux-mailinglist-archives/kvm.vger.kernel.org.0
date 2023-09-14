Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4EF7A0DE4
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 21:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241255AbjINTOr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 15:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237398AbjINTOq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 15:14:46 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2082.outbound.protection.outlook.com [40.107.220.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2960D213C;
        Thu, 14 Sep 2023 12:14:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TTkFYnRyfsLYa49q0YFhLFo0FN6pVhPBOs4T3Bvw0R15s8nEz2/eAr/KzwGtgUEtKui8VZdG66Uj8dOdMxZFRvbO2CluSyByQdSJWlAYjv9IwLVKx9qmroKspGk4dA32jUUuOD1A0B5LcDRNFg0PNcfs6uT5Jl35c2mX0GuzyfmGkvFJtDcaU+rRTft0WeMAjUcI4Ul8osd3VTQBuq2Ak7TXNuMv6RHJu6HZIqF3NS0u/NDaCYQvyjagBLdwXYmP6OodLe08df0guuftQgjlex77uZVivyFoDsjGB9+gO2rC71C6D8un/G1wpa4JkGJFINX6KTjcIYtMXzqYehMFsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DYWzJKwTnWNKMhTwUC4282dIQkyhbLWvPyqLk3IU39g=;
 b=kSkkcEo+/P8uIc27wAfL+5bn3uCYzPoIIx2UK4bJBRChc+5sxh3osNxTtj7NFppXOJQmP1doi5TioQEX3FwN7M5W7D0s0gVdVOSN3Ce9L18ljxXCa9jYgu3eY1JnApNLMlgH4/t9trV1BxTF6xfA+NSwCcbVh3562eH/ZQPFwJzZJKUEGx/XUXx3VcZGWBgAbdHLSsMwSniNN0roSCcFR2VhTql+1AA5n5DyvZFwl8MzLDASWpggbgkx1m11aTXpiN3kMcgZ9X+8i8H9VB9J91rTiCuhJ8wfXXgfB46+VdJzDbGpyZm0w1p8wvkiH/hJsgb+6wuFz4Xmly+MIbT8aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DYWzJKwTnWNKMhTwUC4282dIQkyhbLWvPyqLk3IU39g=;
 b=XU6XS9C3eX9dQzBTq04Ina2+D6dx+UyZzpbOE6apmu6r9DG7BPIA+tjJpSOEFr4f1DZKrki1ihRYs85f+TDhSPAZgb1Vt+d7LHql9C+etDvPwg/0hEJI8G6QWuuomZWSFQG5AW9RNIepuWKiBhveuDRQ98nAgRfHYKguavuckhk=
Received: from DM6PR02CA0063.namprd02.prod.outlook.com (2603:10b6:5:177::40)
 by DM6PR12MB4861.namprd12.prod.outlook.com (2603:10b6:5:1bd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.20; Thu, 14 Sep
 2023 19:14:39 +0000
Received: from SN1PEPF00026368.namprd02.prod.outlook.com
 (2603:10b6:5:177:cafe::ab) by DM6PR02CA0063.outlook.office365.com
 (2603:10b6:5:177::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.21 via Frontend
 Transport; Thu, 14 Sep 2023 19:14:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00026368.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6792.20 via Frontend Transport; Thu, 14 Sep 2023 19:14:38 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Thu, 14 Sep
 2023 14:14:37 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <alex.williamson@redhat.com>, <jgg@ziepe.ca>,
        <kevin.tian@intel.com>, <reinette.chatre@intel.com>,
        <tglx@linutronix.de>, <kvm@vger.kernel.org>
CC:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH vfio] vfio/pci: remove msi domain on msi disable
Date:   Thu, 14 Sep 2023 12:14:06 -0700
Message-ID: <20230914191406.54656-1-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00026368:EE_|DM6PR12MB4861:EE_
X-MS-Office365-Filtering-Correlation-Id: 781570f6-45e9-4ccc-1ab3-08dbb556d765
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b1dF1rxwmBwl5NO6R2Q88buAyoMUi30q117ZEinKwh7/wNKrpaKi9sw7j/I0p9ItQ7WuFXi47Xr7aMwsQvbvWAQ9qaE8fYDI96G2qKMuyzKFF6MCfBak43ISCJJjdE5EOnVDqIBDRAFPg33vj65QZvTdOb41a/d7beOAQP7ugmRHMa73OCjml7HY97Mn9pQvYmcYkx6KWO5My5hVkcO38NQm0XqZopaXos6ENFUsjYumxDSnRRRIn2fxt6N2Gdpt10pvnZFN0c2A9HYQNbmV10NIX0R2Wbqs/swVqcylakTuPG3PeB9jY6383gm5sjg6K3K8YdKBgK2y+6mCj659eS3L1lwJN1TDBJ3SGfndQPks896jL5aGnZAyShNLcg0PnrWaHKRoy04z/jYzie1CRdqnJbkCf0YSDVyRIa8VShhz1ACm7zjjBkdyIT6hocQrp70ISzF9Ql8pKEz4hXjHwBlby6n6wWL53/gesjDbKsXUEScFG6ONlAZx6jaD+anClvs32KindM3Sid98vR5NFPIxMH36xhc8p+qOJs+XWZtOZiWGzFDLinJFTvxu+PwgJZGCrq+gJHQXlqJQLFniJqjblUlYim2yvdvp/uPjKCJXR2r9rj3IOAdQVm8Kc6QGfoTyi7ApuIO7nbAWxRLkbV6gccOxqB/Kfex1ssRb/I0XZtcddYIt+8gN5Z3PwhIHYz0skB/v6RekzmpGwrYMFU0cI/GI5d/W5ar9YjkdrxNXyhCPo5jTJ22UW+NqfhEW6HO22eYynzEUbN4UJC5/KrplzuCnKQ/ylSEmd6xKMaY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(136003)(39860400002)(376002)(451199024)(82310400011)(1800799009)(186009)(36840700001)(40470700004)(46966006)(86362001)(8936002)(8676002)(81166007)(356005)(82740400003)(44832011)(5660300002)(4326008)(40480700001)(36860700001)(316002)(70586007)(70206006)(110136005)(47076005)(41300700001)(54906003)(40460700003)(2906002)(1076003)(478600001)(6666004)(966005)(336012)(16526019)(26005)(426003)(36756003)(83380400001)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2023 19:14:38.7818
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 781570f6-45e9-4ccc-1ab3-08dbb556d765
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF00026368.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4861
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The new MSI dynamic allocation machinery is great for making the irq
management more flexible.  It includes caching information about the
MSI domain which gets reused on each new open of a VFIO fd.  However,
this causes an issue when the underlying hardware has flexible MSI-x
configurations, as a changed configuration doesn't get seen between
new opens, and is only refreshed between PCI unbind/bind cycles.

In our device we can change the per-VF MSI-x resource allocation
without the need for rebooting or function reset.  For example,

  1. Initial power up and kernel boot:
	# lspci -s 2e:00.1 -vv | grep MSI-X
	        Capabilities: [a0] MSI-X: Enable+ Count=8 Masked-

  2. Device VF configuration change happens with no reset

  3. New MSI-x count value seen:
	# lspci -s 2e:00.1 -vv | grep MSI-X
		Capabilities: [a0] MSI-X: Enable- Count=64 Masked-

This allows for per-VF dynamic reconfiguration of interrupt resources
for the VMs using the VFIO devices supported by our hardware.

The problem comes where the dynamic IRQ management created the MSI
domain when the VFIO device creates the first IRQ in the first ioctl()
VFIO_DEVICE_SET_IRQS request.  The current MSI-x count (hwsize) is read
when setting up the irq vectors under pci_alloc_irq_vectors_affinity(),
and the MSI domain information is set up, which includes the hwsize.

When the VFIO fd is closed, the IRQs are removed, but the MSI domain
information is kept for later use since we're only closing the current
VFIO fd, not unbinding the PCI device connection.  When a new VFIO fd
open happens and a new VFIO_DEVICE_SET_IRQS request comes down, the cycle
starts again, reusing the existing MSI domain with the previous hwsize.
This is fine until this new QEMU instance has read the new larger MSI-x
count from PCI config space (QEMU:vfio_msi_enable()) and tries to create
more IRQs than were available before.  We fail in msi_insert_desc()
because the MSI domain still is set up for the earlier hwsize and has no
room for the n+1 IRQ.

This can be easily fixed by simply adding msi_remove_device_irq_domain()
into vfio_msi_disable() which is called when the VFIO IRQs are removed
either by an ioctl() call from QEMU or from the VFIO fd close.  This forces
the MSI domain to be recreated with the new MSI-x count on the next
VFIO_DEVICE_SET_IRQS request.

Link: https://lore.kernel.org/all/cover.1683740667.git.reinette.chatre@intel.com/
Link: https://lore.kernel.org/r/20221124232325.798556374@linutronix.de
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index cbb4bcbfbf83..f66d5e7e078b 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -538,6 +538,7 @@ static void vfio_msi_disable(struct vfio_pci_core_device *vdev, bool msix)
 	cmd = vfio_pci_memory_lock_and_enable(vdev);
 	pci_free_irq_vectors(pdev);
 	vfio_pci_memory_unlock_and_restore(vdev, cmd);
+	msi_remove_device_irq_domain(&pdev->dev, MSI_DEFAULT_DOMAIN);
 
 	/*
 	 * Both disable paths above use pci_intx_for_msi() to clear DisINTx
-- 
2.17.1

