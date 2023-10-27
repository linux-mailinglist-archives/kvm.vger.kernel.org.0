Return-Path: <kvm+bounces-5-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 226927DA39B
	for <lists+kvm@lfdr.de>; Sat, 28 Oct 2023 00:37:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD1312824EF
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 22:37:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EACDF4122B;
	Fri, 27 Oct 2023 22:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NrtiiY0U"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FAE405EB
	for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 22:37:23 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2072.outbound.protection.outlook.com [40.107.220.72])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 212D1D5A;
	Fri, 27 Oct 2023 15:37:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gfa3StTcB0wllZcxF0RTWea1a1jlTOYuMINAlLKSM8CXkxDvfhtnYfDqwusJQi8MZryzRPhioFaf2o0bytR7hEpSStOrh2wMhqCeV7+TmouzvcAXJT6t8t2fhMsOas2Jnuqikrgctky+Yp87g5acFubRudeosH3xubRORRdBSr4TCZ0soeVZXaX01syUZx5q4y1QonfA20fZyhw0uZk1ZQC+JecR4Emv3lBNiTacyzkgaHQo/1g1Ys3K/qD9yWtXPZtkMkioSkZHezwr2DVT1JREQv6SnyAg/Yhdf8WNWti8L19WkjL8Kd0vgJgwAP4YX4dJV6ST+zyinCtL/e1qWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EN71fTh2dXtXpXyjwz92agvLN/VbKrupxTEAZxyx2/s=;
 b=Ptrheumnrgle6/nC6t373GxGr9mV68eSxzNoBjYI6UWhIUYGU3XiU49tdbbtms/hL3XBuxVKM3heIf9sMEQeYc12yNq8j3RtwTTJnTpvFMeP23jyqz0oS96hQAH2CYd5Cg0ej/JmMmIZ2dFVsErqtpamBrSRRsfx7DoNjYaGaPLR1HqSeFWZEfvT3FQII0ibAtcMho4G7V8boyI6YAXv+zRnpdNJvzpRSGRTnb/j8VSV3sXyCgjW06/ExC4ewuG0A2z+hS1qLbRCsYgfryvxterINKbbOTcqRiycTq8SeQDGImKQ3e+1gIJN+EmXpQLNqkL6lJtfwre5u2+8hH9Mzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EN71fTh2dXtXpXyjwz92agvLN/VbKrupxTEAZxyx2/s=;
 b=NrtiiY0Ub04ofHORadL0S1MgRwDCjTW5rZyc+U0erY+S/nX3S0KTQyOX3ZzXz9Dw8BOFdKKOtNAf4oUgXR2tqMVRJ41mebdUnCCW8jJ4Al1Aq6p2BJLAV2jiEypNKqP3A4dxYYr6GHOEDH88RrplJNvJdZKjfvP4FKhkvbyLiiA=
Received: from BLAPR03CA0169.namprd03.prod.outlook.com (2603:10b6:208:32f::21)
 by SA0PR12MB4544.namprd12.prod.outlook.com (2603:10b6:806:70::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.19; Fri, 27 Oct
 2023 22:37:15 +0000
Received: from BL6PEPF0001AB4E.namprd04.prod.outlook.com
 (2603:10b6:208:32f:cafe::7f) by BLAPR03CA0169.outlook.office365.com
 (2603:10b6:208:32f::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.22 via Frontend
 Transport; Fri, 27 Oct 2023 22:37:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB4E.mail.protection.outlook.com (10.167.242.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6933.15 via Frontend Transport; Fri, 27 Oct 2023 22:37:14 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.32; Fri, 27 Oct
 2023 17:37:11 -0500
From: Brett Creeley <brett.creeley@amd.com>
To: <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<alex.williamson@redhat.com>, <dan.carpenter@linaro.org>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<brett.creeley@amd.com>, <shannon.nelson@amd.com>
Subject: [PATCH v3 vfio 3/3] pds/vfio: Fix possible sleep while in atomic context
Date: Fri, 27 Oct 2023 15:36:51 -0700
Message-ID: <20231027223651.36047-4-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231027223651.36047-1-brett.creeley@amd.com>
References: <20231027223651.36047-1-brett.creeley@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4E:EE_|SA0PR12MB4544:EE_
X-MS-Office365-Filtering-Correlation-Id: 077bb8db-83f4-4e1d-8f4a-08dbd73d44b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	vRaASS9oNSz46FSUPAU0HtJA91OXOyNix1JJDJSG7lryMhpGqZdwDma78ko8H1rcRJZyVjxprS1iI/SNp1zrsk1agOrkAroQVVpetNLr8dtVuQ/nzZIOkwnQNcQD/a4vdpGtGLBammUIQCVOLb2dsg2Hjc/Idiu55V/c7HqW1mZ9OL43lW5eafxnPtC8quONmf0YaJeYSD5ScvVOqFR0TIkwTsa5lQZtdubJA1W7X9Hczx6L7Up/++gxNN3CsnsR7N6P3UuBVlxV8iqvZEu7ATVPTWyk74UDNpJQJA43UjESe6hXPEtuAkBAdOKjstiU2awmQ52HiABtvhN8+JlusDLyLD4Gmyrnqj2yr0pXjCXFVo0JPSVv+kIYblyfNR2SOMLsIvuCnyjlYTu4t+4ccBFBkEoLg1hIZms2drkWSG+u+zMPYQhuj4nE9I4FsyBWh+LSGRPARXKXRrJ14xzD6JH8iSpkHcar4HDp3sZ9mkB73p8FdMYOasNgJEEnqsvebP227JbLOytzLosVr/NhmezLGGy8KMdr9cM25kfJZfcBG+M+F1YW+7lVvUmK64FhrneqrwA4Ie1Jb1UVgvKvngNCadtFs0fJgXppl3LxSaADfo564xnVweKFP1IsiZxUoF1/lFe1P8j4jvUfBYGjVjMBkG871n858bjj0aLER8EoA2SdrmE+tz1mc2wQ9vI4GH4mYt39ts3dbtI7m3BOcwVKuN6XArzpSSR4ahlqs7EsfjwPoJg9p22uxpF3/+cU
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(136003)(346002)(376002)(230922051799003)(186009)(64100799003)(1800799009)(451199024)(82310400011)(40470700004)(46966006)(36840700001)(40480700001)(5660300002)(356005)(6666004)(44832011)(41300700001)(40460700003)(26005)(16526019)(1076003)(83380400001)(336012)(426003)(36756003)(2616005)(81166007)(47076005)(82740400003)(36860700001)(2906002)(86362001)(966005)(478600001)(110136005)(70586007)(316002)(70206006)(54906003)(4326008)(8936002)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2023 22:37:14.8052
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 077bb8db-83f4-4e1d-8f4a-08dbd73d44b1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4544

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

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/kvm/1f9bc27b-3de9-4891-9687-ba2820c1b390@moroto.mountain/
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/pds/pci_drv.c  |  4 ++--
 drivers/vfio/pci/pds/vfio_dev.c | 15 ++++++++-------
 drivers/vfio/pci/pds/vfio_dev.h |  2 +-
 3 files changed, 11 insertions(+), 10 deletions(-)

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
index 306b1c25f016..4c351c59d05a 100644
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
 
@@ -156,7 +156,7 @@ static int pds_vfio_init_device(struct vfio_device *vdev)
 	pds_vfio->vf_id = vf_id;
 
 	mutex_init(&pds_vfio->state_mutex);
-	spin_lock_init(&pds_vfio->reset_lock);
+	mutex_init(&pds_vfio->reset_mutex);
 
 	vdev->migration_flags = VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P;
 	vdev->mig_ops = &pds_vfio_lm_ops;
@@ -178,6 +178,7 @@ static void pds_vfio_release_device(struct vfio_device *vdev)
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


