Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D58D650DC82
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 11:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236481AbiDYJaA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 05:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236157AbiDYJ3n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 05:29:43 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2051.outbound.protection.outlook.com [40.107.93.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CBE5598;
        Mon, 25 Apr 2022 02:26:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yy61qtG2mOEMJ/2Kmx8vB5JAroBLvasgEXFx4q/3aggnnClq9fYtCH8zTb6yIJe85lDNI0ojUbPfh7OhTJf1yDlVkY299U9aWqK+cJLTOw5gNWaBcqUThrPSzQUnn70BrvTLGCbNyEoPcDO+SkqSUqRpWLl/b8M94FxpJbXXjtIOucleBzZ5NcOoPjcM4YRMCoWcoNFtMMXpwhsYs/ozvL4dUpyz+inDPJFKN6pdB0yu4hVVFq3zRH8d3L8Qccl1IHw+2osbe5uEoUjDuZnbj5ee0U6661Qoq6dDKCJvh4ii2+JQhPzGiQSG2qbR8CzeQcmEKzAJZzGaKgibM87PgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=20z38avv+TCJBK9Sxmqv6x4OqJYrcs1zev8HzqLXm74=;
 b=nTOBbopBUsSj5uDvCngAFM5KD807ASMZRfMgKUXuIFQlLXyXnRXHYUY3xkAOJTZCpZY/taYvmAwPQqI3QZ7KWXTRw616mJt3y9M06XcSBx/W1jr0J2LqcdEnMUuEAd+ghkCr5q+/kBJUxkkmaCG8BKeXqO5e1GStbxaT3lngqnC/d1nWjO1wGpyGrw9H/QLrz8fTCLIoqKLmAGMjq5EWjy35V29dNLhRCBq0McKikfF3pmu+3k0PrLmFlk03uYVI/4AEM+Xuic5n9a7BaROsw4tyjyH4+AHcMWsiGJpPTPsuBIjqv0NiaRHhY7Vra35nlpJ7UVvYtGvILl89a5HPzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=20z38avv+TCJBK9Sxmqv6x4OqJYrcs1zev8HzqLXm74=;
 b=d+DghNvxhF3Gq/RXgMiGLiJAhhIClUFcQLFuZ4xMCej5/GvS8HzRW3cWAYkuErpknUkBh7ZEfRtuA9rSoqlXjvvfT1c5hkzJ6RNGQAB6ZpRqi0WvNdKNgUUdQqEWmzPvU+6HCPjcsXdHZOKMiK4MBAFN1jSP4ZX3xWB3nJSLEUrDRfcLNMQqNJa8aF7CU5RKTbzaWYmgUnO4kkZ6C7hJAmJhntU/xDnLfpEdtWE2tZNAIFwIKi6wA1DoZqBVSsVnk5qiFqf+hwL5AQ1t++PkQPVbOIdROqRsjaoyBpWGVBiE0WGJm5Dp+rlXSUxHY5oKasMsCUE+XEC/R0DrnHNYAw==
Received: from BN9PR03CA0099.namprd03.prod.outlook.com (2603:10b6:408:fd::14)
 by BL1PR12MB5175.namprd12.prod.outlook.com (2603:10b6:208:318::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Mon, 25 Apr
 2022 09:26:34 +0000
Received: from BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fd:cafe::63) by BN9PR03CA0099.outlook.office365.com
 (2603:10b6:408:fd::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14 via Frontend
 Transport; Mon, 25 Apr 2022 09:26:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT065.mail.protection.outlook.com (10.13.177.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5186.14 via Frontend Transport; Mon, 25 Apr 2022 09:26:34 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 25 Apr
 2022 09:26:33 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 25 Apr
 2022 02:26:32 -0700
Received: from nvidia-abhsahu-1.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Mon, 25 Apr 2022 02:26:27 -0700
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
Subject: [PATCH v3 1/8] vfio/pci: Invalidate mmaps and block the access in D3hot power state
Date:   Mon, 25 Apr 2022 14:56:08 +0530
Message-ID: <20220425092615.10133-2-abhsahu@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220425092615.10133-1-abhsahu@nvidia.com>
References: <20220425092615.10133-1-abhsahu@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b1b99f1-8199-4337-3f73-08da269db0e6
X-MS-TrafficTypeDiagnostic: BL1PR12MB5175:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB5175A0817E998387E74E1DCDCCF89@BL1PR12MB5175.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l5foAfFxfPS7SkxRM/SZMbnAsmec9TuyQ9TPMNsiGVIiTfzKdKyAs6Hz+Wg8Pz43HlBA+OBCH4J5e63bUlTauNXmE2D+nXRtTv3UsVhOnugf3xO72rsNf0z159zd3f7qFVhM7zdK3fLCUz7hE96TOTz202L8ynKCAY/NeQgni0xmBSud/yx1b9ZvVMn6Yn72kdJ8MsXEWPIN2HMMLDxBJI/ordAQ+NvxqrMAKHCkbAkkSS2owYT+iPJiISOQsBazIgunmeSmM/juAlBNqsrpAeo+UKYlV+G5/ES7fmn5up+0ZjoChZgkjoen8THxEEbnAnFuC+izMfrdTTwsaAtP52qS37PImDywwdPc7IuLJYUMAkhbNThCjMrOVJQpu39BjmCzNvrncQgpmtD2w9+jdx3W9MOrF9s4yIDUBtzPFr+1VRFLXdomVQHxny94yuaHIahbDSq3GFsTd/2PF0XK4Kt/l8ed2jXH8EWfZ0oxhbu/GU7c1L68Zx2bIo15J7jl6AKVGDaKoxkBH4wOhwMZ81bgV/tzHVjYDlvL2JaMJUBo2s4RktneLpBF3vj8SUSlABpg9rsVLAAcaAd0vFnuHv2UAc6UBnauTFFw+EE5q0WsUQDXZ7twB4QU8tswQCDFsDvt4xdIOuId9sbf2fP7qBVeiWqsk1FAPIUpJBNWNSb4O4r/Qbhflru8v3Zp7MOQ1/GwDlnYxfBGb8ruzTa0FdkLUhoWnMCa165vsvVKI7c=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(186003)(426003)(508600001)(1076003)(336012)(356005)(8936002)(316002)(8676002)(36756003)(70206006)(4326008)(5660300002)(70586007)(36860700001)(82310400005)(7416002)(107886003)(2616005)(86362001)(47076005)(81166007)(40460700003)(2906002)(26005)(7696005)(6666004)(54906003)(110136005)(83380400001)(32563001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2022 09:26:34.4072
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b1b99f1-8199-4337-3f73-08da269db0e6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5175
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
 drivers/vfio/pci/vfio_pci_config.c | 19 ++++++++++++++++++-
 drivers/vfio/pci/vfio_pci_core.c   |  4 +++-
 drivers/vfio/pci/vfio_pci_rdwr.c   |  6 ++++--
 include/linux/vfio_pci_core.h      |  1 +
 4 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 6e58b4bf7a60..dd557edae6e1 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -692,6 +692,23 @@ static int __init init_pci_cap_basic_perm(struct perm_bits *perm)
 	return 0;
 }
 
+/*
+ * It takes all the required locks to protect the access of power related
+ * variables and then invokes vfio_pci_set_power_state().
+ */
+static void
+vfio_lock_and_set_power_state(struct vfio_pci_core_device *vdev,
+			      pci_power_t state)
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
@@ -718,7 +735,7 @@ static int vfio_pm_config_write(struct vfio_pci_core_device *vdev, int pos,
 			break;
 		}
 
-		vfio_pci_set_power_state(vdev, state);
+		vfio_lock_and_set_power_state(vdev, state);
 	}
 
 	return count;
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 06b6f3594a13..f3dfb033e1c4 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -230,6 +230,8 @@ int vfio_pci_set_power_state(struct vfio_pci_core_device *vdev, pci_power_t stat
 	ret = pci_set_power_state(pdev, state);
 
 	if (!ret) {
+		vdev->power_state_d3 = (pdev->current_state >= PCI_D3hot);
+
 		/* D3 might be unsupported via quirk, skip unless in D3 */
 		if (needs_save && pdev->current_state >= PCI_D3hot) {
 			/*
@@ -1398,7 +1400,7 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
 	mutex_lock(&vdev->vma_lock);
 	down_read(&vdev->memory_lock);
 
-	if (!__vfio_pci_memory_enabled(vdev)) {
+	if (!__vfio_pci_memory_enabled(vdev) || vdev->power_state_d3) {
 		ret = VM_FAULT_SIGBUS;
 		goto up_out;
 	}
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 82ac1569deb0..fac6bb40a4ce 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -43,7 +43,8 @@ static int vfio_pci_iowrite##size(struct vfio_pci_core_device *vdev,		\
 {									\
 	if (test_mem) {							\
 		down_read(&vdev->memory_lock);				\
-		if (!__vfio_pci_memory_enabled(vdev)) {			\
+		if (!__vfio_pci_memory_enabled(vdev) ||			\
+		    vdev->power_state_d3) {				\
 			up_read(&vdev->memory_lock);			\
 			return -EIO;					\
 		}							\
@@ -70,7 +71,8 @@ static int vfio_pci_ioread##size(struct vfio_pci_core_device *vdev,		\
 {									\
 	if (test_mem) {							\
 		down_read(&vdev->memory_lock);				\
-		if (!__vfio_pci_memory_enabled(vdev)) {			\
+		if (!__vfio_pci_memory_enabled(vdev) ||			\
+		    vdev->power_state_d3) {				\
 			up_read(&vdev->memory_lock);			\
 			return -EIO;					\
 		}							\
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 48f2dd3c568c..505b2a74a479 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -124,6 +124,7 @@ struct vfio_pci_core_device {
 	bool			needs_reset;
 	bool			nointx;
 	bool			needs_pm_restore;
+	bool			power_state_d3;
 	struct pci_saved_state	*pci_saved_state;
 	struct pci_saved_state	*pm_save;
 	int			ioeventfds_nr;
-- 
2.17.1

