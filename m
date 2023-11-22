Return-Path: <kvm+bounces-2325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E5417F508B
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 20:26:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8D542813BD
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 19:26:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 071075E0C2;
	Wed, 22 Nov 2023 19:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oR3lbTYB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2080.outbound.protection.outlook.com [40.107.95.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170581BD;
	Wed, 22 Nov 2023 11:26:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fz4e9QYnjIR8kXhp9O8f9arvWg0dxoJv62g6bT5HgJCqs9Wy0H1jYq4Xg3TNPNOxwyxPYJSgI8Z5qK2vW8/pEAeb8rlrIhLrw2fi7qe6XgW4oE1PMU5psrDjy4UqffXuFs1yAHumlHb8BbaidakwRCrr8lEgeEKLMgOPs2GCElAE2op1G4acnIIFhcpQaNMi6L9N3uug3AW3le759D710ICN4pfdZqjJY4Oy+TWlOZyZK4ZuIbv/nJNLwCMCI5kSqRhR4cpv8ByJ+i7yWa0hD72RWWWjawK3bakdPUyECkZ9welGAojG0YFQ251Kiw8CDmUR0fPR2lJITm3FhhucCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x+POrHr8Ptzol7KDt+CLjOPxLwvrOnmwo/dWZrXzkNo=;
 b=CafXSpYDH8WAEg593x21IKXHtspZnvC7mHJX82nTW2P3KU9RSciDv64XC2WZzXNYL/li6me0MyTChzm7BB3EB+bqD103jhvn0NL9m6wPtm+TDISxQCEkidhmwAHyoZoNygXh04htWWcs19BWpKl32KFrDvAtgTgVgFSKQ7Jk9xOmxo+dufG4BNI/mgV3Y9RIGwb344H44Sl9jrroA8CPwamjOzPf9KYCjf9G1kl88uZdCL5gE6sxFY7Y1J6sjeF9KnRMMk5R7ZdO2shjdPob5gbup982bCDUeDhdCZl04bRcgbiTwkRiXS00s5VDmmVCdCKT9Kww+sGyrjcaAWlqpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x+POrHr8Ptzol7KDt+CLjOPxLwvrOnmwo/dWZrXzkNo=;
 b=oR3lbTYBjErMKekVDO4QCin/+CajjkcpN+9mHqRRne7bNTIeGhJHC0dZ1jrWYTQ4RO6FrNgUySNjUaBfjjcPNuo9Ew/EY/i/eTV8W/Ff+jdJVPrwYO55x6USfjf7abMaBWkol6azHwsr6CurXX8cihNy30XB+/N+spE4p2NhjtM=
Received: from MW4PR04CA0213.namprd04.prod.outlook.com (2603:10b6:303:87::8)
 by IA1PR12MB6626.namprd12.prod.outlook.com (2603:10b6:208:3a2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.19; Wed, 22 Nov
 2023 19:26:29 +0000
Received: from CO1PEPF000044FA.namprd21.prod.outlook.com
 (2603:10b6:303:87:cafe::6c) by MW4PR04CA0213.outlook.office365.com
 (2603:10b6:303:87::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.18 via Frontend
 Transport; Wed, 22 Nov 2023 19:26:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044FA.mail.protection.outlook.com (10.167.241.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7046.3 via Frontend Transport; Wed, 22 Nov 2023 19:26:28 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Wed, 22 Nov
 2023 13:26:26 -0600
From: Brett Creeley <brett.creeley@amd.com>
To: <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <shannon.nelson@amd.com>, <brett.creeley@amd.com>
Subject: [PATCH v4 vfio 2/2] vfio/pds: Fix possible sleep while in atomic context
Date: Wed, 22 Nov 2023 11:25:32 -0800
Message-ID: <20231122192532.25791-3-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231122192532.25791-1-brett.creeley@amd.com>
References: <20231122192532.25791-1-brett.creeley@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044FA:EE_|IA1PR12MB6626:EE_
X-MS-Office365-Filtering-Correlation-Id: ecb28c72-0732-4691-f2f1-08dbeb90ed3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	MgxYT26qG6ehhX+LECMxBPAcDG6VDutkVFFQyKZ+hkKdfDacCmhPU3PeRKkOqk9xFIJ96g2IAoUXb2tGfmVS9V5fI2vH+w1zT36LbbanvRoxiLDrE9ZA1sZBt2hhCaY7oWJMSlowVymF/gMy8pMPwUhYjTscFEJR2nsrL5vG8L2bDF6FNgiyHBjcPCkk49vRmoAj0hkkfZgRWZPDIgBh3kB4z7JfdaSY9FSv2fgsLX31r8AgXZ1QHac7uHLcek/M125FTqnys2nBhw1sKZAzZA6zjZzrTU/jIxJYwvEorT/Ae58ilI+2dCU2FVgpBYBEZzqwBKRoco6Mv7VfMEfSj2dFE2k9FZ2eKRIe/5d+KeFPwhSZLOD/dK7Y08liyELaK0PKfzdm0TkBvAT+zJiNWOaHf3/zHDeLf+yyBWHK9TkNJXAAaute04489aJ1QG9BvAZ/DVhBk7DLfliBXleX9KY/tKQYgSMcifhOOQ/9MQf5UwOvowvjqNSAvsT5EtDX72WXHdBj4UbK60f/HKa7FIGBqGRq4ztV5UmCl1eMHcfLOY0Cn5Pt/17Ptbxfe4QveLOwcVyIuQSzYOvR0IG8lJLQvsaZhRJJMu2b++bjI44AI0dtn2FNFjnIr1/U34T1uN0hXDo46htHdBJD28qzaynuFXyV8bK2Iz0NK6VmlVdsbDiimDsW7Sdu7p+PGyIcCvd0ck2FHsw3w7QWFuzPZgwYI8g6U/N+ENRhku4WXsQ=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(136003)(346002)(39860400002)(230922051799003)(64100799003)(451199024)(1800799012)(82310400011)(186009)(40470700004)(46966006)(36840700001)(2616005)(426003)(336012)(16526019)(1076003)(26005)(36860700001)(356005)(81166007)(36756003)(86362001)(82740400003)(83380400001)(40460700003)(47076005)(54906003)(316002)(4326008)(8676002)(8936002)(70586007)(70206006)(110136005)(41300700001)(44832011)(5660300002)(2906002)(6666004)(40480700001)(966005)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2023 19:26:28.9219
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ecb28c72-0732-4691-f2f1-08dbeb90ed3a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044FA.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6626

The driver could possibly sleep while in atomic context resulting
in the following call trace while CONFIG_DEBUG_ATOMIC_SLEEP=y is
set:

BUG: sleeping function called from invalid context at kernel/locking/mutex.c:283
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 2817, name: bash
preempt_count: 1, expected: 0
RCU nest depth: 0, expected: 0
Call Trace:
 <TASK>
 dump_stack_lvl+0x36/0x50
 __might_resched+0x123/0x170
 mutex_lock+0x1e/0x50
 pds_vfio_put_lm_file+0x1e/0xa0 [pds_vfio_pci]
 pds_vfio_put_save_file+0x19/0x30 [pds_vfio_pci]
 pds_vfio_state_mutex_unlock+0x2e/0x80 [pds_vfio_pci]
 pci_reset_function+0x4b/0x70
 reset_store+0x5b/0xa0
 kernfs_fop_write_iter+0x137/0x1d0
 vfs_write+0x2de/0x410
 ksys_write+0x5d/0xd0
 do_syscall_64+0x3b/0x90
 entry_SYSCALL_64_after_hwframe+0x6e/0xd8

This can happen if pds_vfio_put_restore_file() and/or
pds_vfio_put_save_file() grab the mutex_lock(&lm_file->lock)
while the spin_lock(&pds_vfio->reset_lock) is held, which can
happen during while calling pds_vfio_state_mutex_unlock().

Fix this by changing the reset_lock to reset_mutex so there are no such
conerns. Also, make sure to destroy the reset_mutex in the driver specific
VFIO device release function.

This also fixes a spinlock bad magic BUG that was caused
by not calling spinlock_init() on the reset_lock. Since, the lock is
being changed to a mutex, make sure to call mutex_init() on it.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/kvm/1f9bc27b-3de9-4891-9687-ba2820c1b390@moroto.mountain/
Fixes: bb500dbe2ac6 ("vfio/pds: Add VFIO live migration support")
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/pds/pci_drv.c  |  4 ++--
 drivers/vfio/pci/pds/vfio_dev.c | 14 ++++++++------
 drivers/vfio/pci/pds/vfio_dev.h |  2 +-
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_drv.c
index ab4b5958e413..caffa1a2cf59 100644
--- a/drivers/vfio/pci/pds/pci_drv.c
+++ b/drivers/vfio/pci/pds/pci_drv.c
@@ -55,10 +55,10 @@ static void pds_vfio_recovery(struct pds_vfio_pci_device *pds_vfio)
 	 * VFIO_DEVICE_STATE_RUNNING.
 	 */
 	if (deferred_reset_needed) {
-		spin_lock(&pds_vfio->reset_lock);
+		mutex_lock(&pds_vfio->reset_mutex);
 		pds_vfio->deferred_reset = true;
 		pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_ERROR;
-		spin_unlock(&pds_vfio->reset_lock);
+		mutex_unlock(&pds_vfio->reset_mutex);
 	}
 }
 
diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
index 8c9fb87b13e1..4c351c59d05a 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -29,7 +29,7 @@ struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev)
 void pds_vfio_state_mutex_unlock(struct pds_vfio_pci_device *pds_vfio)
 {
 again:
-	spin_lock(&pds_vfio->reset_lock);
+	mutex_lock(&pds_vfio->reset_mutex);
 	if (pds_vfio->deferred_reset) {
 		pds_vfio->deferred_reset = false;
 		if (pds_vfio->state == VFIO_DEVICE_STATE_ERROR) {
@@ -39,23 +39,23 @@ void pds_vfio_state_mutex_unlock(struct pds_vfio_pci_device *pds_vfio)
 		}
 		pds_vfio->state = pds_vfio->deferred_reset_state;
 		pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_RUNNING;
-		spin_unlock(&pds_vfio->reset_lock);
+		mutex_unlock(&pds_vfio->reset_mutex);
 		goto again;
 	}
 	mutex_unlock(&pds_vfio->state_mutex);
-	spin_unlock(&pds_vfio->reset_lock);
+	mutex_unlock(&pds_vfio->reset_mutex);
 }
 
 void pds_vfio_reset(struct pds_vfio_pci_device *pds_vfio)
 {
-	spin_lock(&pds_vfio->reset_lock);
+	mutex_lock(&pds_vfio->reset_mutex);
 	pds_vfio->deferred_reset = true;
 	pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_RUNNING;
 	if (!mutex_trylock(&pds_vfio->state_mutex)) {
-		spin_unlock(&pds_vfio->reset_lock);
+		mutex_unlock(&pds_vfio->reset_mutex);
 		return;
 	}
-	spin_unlock(&pds_vfio->reset_lock);
+	mutex_unlock(&pds_vfio->reset_mutex);
 	pds_vfio_state_mutex_unlock(pds_vfio);
 }
 
@@ -156,6 +156,7 @@ static int pds_vfio_init_device(struct vfio_device *vdev)
 	pds_vfio->vf_id = vf_id;
 
 	mutex_init(&pds_vfio->state_mutex);
+	mutex_init(&pds_vfio->reset_mutex);
 
 	vdev->migration_flags = VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P;
 	vdev->mig_ops = &pds_vfio_lm_ops;
@@ -177,6 +178,7 @@ static void pds_vfio_release_device(struct vfio_device *vdev)
 			     vfio_coredev.vdev);
 
 	mutex_destroy(&pds_vfio->state_mutex);
+	mutex_destroy(&pds_vfio->reset_mutex);
 	vfio_pci_core_release_dev(vdev);
 }
 
diff --git a/drivers/vfio/pci/pds/vfio_dev.h b/drivers/vfio/pci/pds/vfio_dev.h
index b8f2d667608f..e7b01080a1ec 100644
--- a/drivers/vfio/pci/pds/vfio_dev.h
+++ b/drivers/vfio/pci/pds/vfio_dev.h
@@ -18,7 +18,7 @@ struct pds_vfio_pci_device {
 	struct pds_vfio_dirty dirty;
 	struct mutex state_mutex; /* protect migration state */
 	enum vfio_device_mig_state state;
-	spinlock_t reset_lock; /* protect reset_done flow */
+	struct mutex reset_mutex; /* protect reset_done flow */
 	u8 deferred_reset;
 	enum vfio_device_mig_state deferred_reset_state;
 	struct notifier_block nb;
-- 
2.17.1


