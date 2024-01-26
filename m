Return-Path: <kvm+bounces-7192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 475FB83E19B
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 19:33:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D1E21C21C0D
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 18:33:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6AFE219FF;
	Fri, 26 Jan 2024 18:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="S4M7amaV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2078.outbound.protection.outlook.com [40.107.220.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E291B954;
	Fri, 26 Jan 2024 18:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706293965; cv=fail; b=GqVzFaoc6gxOoFKuuYWPXI9zkWxHmnoPUTzH5n7j38YICjQhoU39KvNnPFj0KqFYWbQzOy3OA+uDHTaezgcVOj/O2WJuLsGzAt9w+ykUoOs+evjY1VGWhYa0mCDwFVkyHZVCU5/BKmOn1H2hYEVYgNPTNWdQ0/N8sXeYgZYy3/g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706293965; c=relaxed/simple;
	bh=GS9uSbkAt/iZhu516Yz/CF5vnAdEfBPEAqxujiz6TiE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=smflH77QcWE2k3qT3z44svsXq+2bsC5xgt1VxGoVqdGSTiKZOexUp0THDkuUCRLi7t7AnzCgn4ldWsxah0Pm5rnNqhO2j9exHfD7V99lGIvvQRS/BofmspxSt99hyfkncYHIuFdNvIl+5VWMwdKCFcZMk1crbiNrNQ21gJlxt+0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=S4M7amaV; arc=fail smtp.client-ip=40.107.220.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NK07r1y+8kxYAf6zk9AEZuIh7NHbDC5+8JFkR7cQia8gt5S/jOUVABRsvVYEiJEnZO1TB0ll/ZrA2Te6kpPOuP0Pfh498e9MPBdb4oaEf6cjB9Xo5HW7hoBkE8Um41TkFBKdJdZyzb60IJeRHJ4KBjE1sbGiq0rtdqEjFv56pceVtLSj4nZwdqJidlOg06VqipDF2yegQ3jb5s2KplGmhEWLS0sG9DtEQBVBAbGrbh/dTAouzmFMaXPdu0P5u27WdNtKRN5gKudylVv6GnLLZ/F+qyxVPtDBukBzoLkW00NkFuYiV3BMrxjFLSdZDbBDVsMk2OQVdLsehkJUFjnjhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ZbczJBMnZ9c9mEl9MipQOqRBEdG3TLfWRnznnpdsXM=;
 b=LqFPLgsy5E/U1iLdDcET+t6AjGhlYrzSDWqUxJD7AHv9dKaICqYwrhGDc7ijXwJEKnKsJZVBtvpIVuTfcuYfHw8T/cVN6wdy6wbfZhLFzODOR6IMbYx9v/sM1d+4wpAqIB/JC0AFyVS5YvjEB4HKF98BcYvx24BVq6aosZdRfti9xQsCS4WUfO9O6c69T23u+KnIwX6dV2ceDYkzAOv/MzBZg+4fM4lQvhQgK+Hl8es8+x5RY/ZCyt8/vAvNrIB5Z1D/VPdrz1/BNtU8u8L+LAdkgSrHlnja55K8sZM0zL5aiIa8x97MCgtzWbAes74lef+LdKe9245906mKfE/7IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ZbczJBMnZ9c9mEl9MipQOqRBEdG3TLfWRnznnpdsXM=;
 b=S4M7amaVS5FhzX05uZWfri/UiWnUE/AS6i9zmHsYOjB1JPRjvi1KECyPcilHgH6Frl6zbeZ+XwHOKwqGTGJEnEwBjggQS/Fnd7RQ6ywRCsCOkrdRYmvRUnw7qnehB6GvnYZDrI6lGcxupC/eRsC8Q2r+1F9feBL3fi3eX6hCLSo=
Received: from MW4PR04CA0259.namprd04.prod.outlook.com (2603:10b6:303:88::24)
 by DM4PR12MB6376.namprd12.prod.outlook.com (2603:10b6:8:a0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.26; Fri, 26 Jan
 2024 18:32:39 +0000
Received: from CO1PEPF000044F7.namprd21.prod.outlook.com
 (2603:10b6:303:88:cafe::33) by MW4PR04CA0259.outlook.office365.com
 (2603:10b6:303:88::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27 via Frontend
 Transport; Fri, 26 Jan 2024 18:32:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F7.mail.protection.outlook.com (10.167.241.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7228.0 via Frontend Transport; Fri, 26 Jan 2024 18:32:39 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Fri, 26 Jan
 2024 12:32:37 -0600
From: Brett Creeley <brett.creeley@amd.com>
To: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<alex.williamson@redhat.com>, <kevin.tian@intel.com>,
	<shameerali.kolothum.thodi@huawei.com>, <yishaih@nvidia.com>, <jgg@ziepe.ca>
CC: <shannon.nelson@amd.com>, <brett.creeley@amd.com>
Subject: [PATCH vfio] vfio/pds: Rework and simplify reset flows
Date: Fri, 26 Jan 2024 10:32:25 -0800
Message-ID: <20240126183225.19193-1-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F7:EE_|DM4PR12MB6376:EE_
X-MS-Office365-Filtering-Correlation-Id: 06df1288-3fa5-4740-265b-08dc1e9d2cf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	gjOFFkwuMIpYd2++s6fw552Uy6gDFLWj4/tHIrVsPn63qb2BZhiaOGgWBlYxyMZTC9NTMQYeNIeGKttD3/ueGMpJyGXEho8jLQN+cU9MuVGSXCSVLVzg0QjCCJFnKBHAyfRd6OQJ92NjLpvdHPNojcY3Exh17/pF4CLhm5R1/pe+0SlfFnZxkDnZW2Dohl6Dc1lRV4tCYdksUHq9IiB89CVnKEaJNbtEE0v03RBd/Jfa5O7QsImd76WQAmuBdKXM6PNXSL/HpHH32KLvYM/txTJOh6YDJgHXUR7pSAksPo+3ROcZ4Xz63AoZqZKt1dEFmAnkQNYRWxMNxQ8izfcGl3PRwrooSThmCGfjxUK0z9JQwFSZKemIT9cFd1+795D4NGzI3mg1tRoEm6VJm99+feEabaRZmZXDDBGtkAoucCE+0ZS1mV97k6APEC4ymXo1EkA8TnXaR8m/cmW5DAqxoWQfTvfs8CSq+/9BhVgw7nAp9LtaTjAgjdG1diRtKFJ/0B5qPpe6SzW41hnCOer3pcw4XQB5f9vt5rsGmUXz/6iECu/dl5fRVl/lxexf7EbnZ7j6YTc84y81MObO5+H559IIn+BHgBbcGUAOjW+YGVBHXnW7PCt4dh7FsXFeJmlRJWWfdMYMPlHtHTH+giXNnFDW9VXnZaPp+nQO5iCPT7x7qDq+x4tFoTSeZNlAymVPf629ONEqD/2oLxLReW+sqGQvG5JNdDRwY92sqRpkWZuW5ylKhNlNX35qJc+RO3b3xG8jk1yhYdjGnIa1/VydsA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(136003)(376002)(346002)(396003)(230922051799003)(451199024)(1800799012)(186009)(82310400011)(64100799003)(40470700004)(46966006)(36840700001)(83380400001)(47076005)(16526019)(1076003)(2616005)(426003)(336012)(26005)(82740400003)(8676002)(4326008)(8936002)(5660300002)(44832011)(41300700001)(2906002)(478600001)(6666004)(54906003)(316002)(70206006)(70586007)(110136005)(36860700001)(36756003)(86362001)(81166007)(356005)(40460700003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 18:32:39.1389
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 06df1288-3fa5-4740-265b-08dc1e9d2cf6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F7.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6376

The current logic for handling resets based on
whether they were initiated from the DSC or
host/VMM is slightly confusing and incorrect.
The incorrect behavior can cause the VF device
to be unusable on the destination on failed
migrations due to incompatible configurations.
Fix this by setting the state back to
VFIO_DEVICE_STATE_RUNNING when an FLR is
triggered, so the VF device is put back in
an "initial" pre-configured state after failures.

Also, while here clean-up the reset logic to
make the source of the reset more obvious.

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/pds/pci_drv.c  |  2 +-
 drivers/vfio/pci/pds/vfio_dev.c | 14 +++++++-------
 drivers/vfio/pci/pds/vfio_dev.h |  7 ++++++-
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_drv.c
index a34dda516629..4ac3da7abd32 100644
--- a/drivers/vfio/pci/pds/pci_drv.c
+++ b/drivers/vfio/pci/pds/pci_drv.c
@@ -57,7 +57,7 @@ static void pds_vfio_recovery(struct pds_vfio_pci_device *pds_vfio)
 	if (deferred_reset_needed) {
 		mutex_lock(&pds_vfio->reset_mutex);
 		pds_vfio->deferred_reset = true;
-		pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_ERROR;
+		pds_vfio->deferred_reset_type = PDS_VFIO_DEVICE_RESET;
 		mutex_unlock(&pds_vfio->reset_mutex);
 	}
 }
diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
index 4c351c59d05a..3357690344c4 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -32,13 +32,14 @@ void pds_vfio_state_mutex_unlock(struct pds_vfio_pci_device *pds_vfio)
 	mutex_lock(&pds_vfio->reset_mutex);
 	if (pds_vfio->deferred_reset) {
 		pds_vfio->deferred_reset = false;
-		if (pds_vfio->state == VFIO_DEVICE_STATE_ERROR) {
-			pds_vfio_put_restore_file(pds_vfio);
-			pds_vfio_put_save_file(pds_vfio);
+		pds_vfio_put_restore_file(pds_vfio);
+		pds_vfio_put_save_file(pds_vfio);
+		if (pds_vfio->deferred_reset_type == PDS_VFIO_HOST_RESET) {
+			pds_vfio->state = VFIO_DEVICE_STATE_RUNNING;
+		} else {
 			pds_vfio_dirty_disable(pds_vfio, false);
+			pds_vfio->state = VFIO_DEVICE_STATE_ERROR;
 		}
-		pds_vfio->state = pds_vfio->deferred_reset_state;
-		pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_RUNNING;
 		mutex_unlock(&pds_vfio->reset_mutex);
 		goto again;
 	}
@@ -50,7 +51,7 @@ void pds_vfio_reset(struct pds_vfio_pci_device *pds_vfio)
 {
 	mutex_lock(&pds_vfio->reset_mutex);
 	pds_vfio->deferred_reset = true;
-	pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_RUNNING;
+	pds_vfio->deferred_reset_type = PDS_VFIO_HOST_RESET;
 	if (!mutex_trylock(&pds_vfio->state_mutex)) {
 		mutex_unlock(&pds_vfio->reset_mutex);
 		return;
@@ -194,7 +195,6 @@ static int pds_vfio_open_device(struct vfio_device *vdev)
 		return err;
 
 	pds_vfio->state = VFIO_DEVICE_STATE_RUNNING;
-	pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_RUNNING;
 
 	vfio_pci_core_finish_enable(&pds_vfio->vfio_coredev);
 
diff --git a/drivers/vfio/pci/pds/vfio_dev.h b/drivers/vfio/pci/pds/vfio_dev.h
index e7b01080a1ec..19547fd8e956 100644
--- a/drivers/vfio/pci/pds/vfio_dev.h
+++ b/drivers/vfio/pci/pds/vfio_dev.h
@@ -10,6 +10,11 @@
 #include "dirty.h"
 #include "lm.h"
 
+enum pds_vfio_reset_type {
+	PDS_VFIO_HOST_RESET = 0,
+	PDS_VFIO_DEVICE_RESET = 1,
+};
+
 struct pds_vfio_pci_device {
 	struct vfio_pci_core_device vfio_coredev;
 
@@ -20,7 +25,7 @@ struct pds_vfio_pci_device {
 	enum vfio_device_mig_state state;
 	struct mutex reset_mutex; /* protect reset_done flow */
 	u8 deferred_reset;
-	enum vfio_device_mig_state deferred_reset_state;
+	enum pds_vfio_reset_type deferred_reset_type;
 	struct notifier_block nb;
 
 	int vf_id;
-- 
2.17.1


