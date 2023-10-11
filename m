Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 497427C60CF
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 01:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376620AbjJKXBr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 19:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376558AbjJKXBj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 19:01:39 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5444A9;
        Wed, 11 Oct 2023 16:01:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LpB2p9JEvmiCADDVJ4nRAve4vcWXfCfHK63YV5rqJet8Gyra4KlmeuFnvisCoKQOt+ZJ1SoIHQ9KGFAoHakCZk5wcSbOHcd71COsC2co8ZyRu+JBEirHXZlUvSOD52+hhiPJnvcmeHB2UiRZNrWloS44uiipMCmuPFX4SaweJuPV93nhqD2iBvldf7gswh/yEVG7+F2xuQDsmu5ofGvv/Yz73/opS7xt9EaN0dQ5P829x2QgqgkrFSag3aLvb9F8NeMeXOCCr2IXvFyEIvhEuwVHyZ3eKMO/7S4hqHcGNIeD2O4jk3mX19ueyU0y+qYOZNWilVZ+oZcSxsIiAfpEjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0sEdZtOgpDIhG7UGxS07MqFGSIENgdo5lxNiz2tjrT8=;
 b=ijq20lZLsrvehxlIVFkMcU+hJk/dpHM/9/hqq6VPRtTadwxj52z9ORUR8+O9KOfWzlz0F9PXYIXsfuNvLxomwJ8UVFSjbArnO/UxSIwvx7FYpKOaA7x6RklZqFwflxOMTn8O23ylYfRadIX54WaiBMahvsrR56+fQB9K49LgU1L8MNxBDC0ejk58Kgr8jx1KNNWsGX5f83K9W4d0CyZ9K4cvFF6kZV6J9VyAMA5G9QwoFIpc43/sOQpUwU2wqSDBWVcfnheJkITjCeifJZfG9MWssdiQq/r5ECj6IZw3KMNzPxwKGIkd54UEM4MRrmUu9wqiM1a7JlVSf/neii3CxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0sEdZtOgpDIhG7UGxS07MqFGSIENgdo5lxNiz2tjrT8=;
 b=EVsVQk3kNN64gXprlwR8iUEJLL5EmgwQlbHPaE7XFazEHMkcht1ZqzpitsF6tQmikXsc6FecS+1R9zI8kT4Bi+Dyc3XaL4Cu2cMMs4kGcyXLQnKVy9mYrpaNxCaaFzo0xKSOCsdMBM+VZz8NMaha7vzW3ujEr6evkcBdkD6qrm8=
Received: from CY5PR15CA0141.namprd15.prod.outlook.com (2603:10b6:930:67::6)
 by SJ0PR12MB6831.namprd12.prod.outlook.com (2603:10b6:a03:47d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.36; Wed, 11 Oct
 2023 23:01:34 +0000
Received: from CY4PEPF0000EDD4.namprd03.prod.outlook.com
 (2603:10b6:930:67:cafe::ed) by CY5PR15CA0141.outlook.office365.com
 (2603:10b6:930:67::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38 via Frontend
 Transport; Wed, 11 Oct 2023 23:01:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EDD4.mail.protection.outlook.com (10.167.241.208) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Wed, 11 Oct 2023 23:01:34 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 11 Oct
 2023 18:01:32 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <jgg@ziepe.ca>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <alex.williamson@redhat.com>, <dan.carpenter@linaro.org>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <brett.creeley@amd.com>, <shannon.nelson@amd.com>
Subject: [PATCH v2 vfio 3/3] pds/vfio: Fix possible sleep while in atomic context
Date:   Wed, 11 Oct 2023 16:01:15 -0700
Message-ID: <20231011230115.35719-4-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231011230115.35719-1-brett.creeley@amd.com>
References: <20231011230115.35719-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD4:EE_|SJ0PR12MB6831:EE_
X-MS-Office365-Filtering-Correlation-Id: ba32ae97-7624-4a19-934f-08dbcaae0443
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 52mkIW8+L1MAgU9YOmKp5eTTHGwgcHyd6/YSPcIKR0lJ6gf91wg4oUGLuhgzmch9tZXKqsS4Sg4UWTnLXDlwAVUIO4sTl4uTEJdFSoaWW9qU4PR8P88iLJbQaFQM/CXlYiFgk/Cnty0mR35j59z3FrH2EBpNHwO87NkttUjqhSeKhbYfgYC3NbVN3sJLmjELRHIgbiT36cU61jdeJzg27+JndkpzGYsSUyaWsy97oy/VXHcx70ys4Sxgl2UF/CBK3CHSbZ65i11Ih5NcSzbItOiu2k8Rpr/HPCwzpDhkN9D9KsZlQMuHqvU79a0O0DKtW0NMzrFZm5xsTsl+vB0qkVBSNNeAvu0bmDIqriQdFaYBxuP9wGJ26EESIARl6B2zsRArM8iPnb89/0Eh3wdMsoV1DW2XItAhGe9NKuqpIhQEJ2va7VHmaJA6ucU6GIy5rculVj8NqDEl6vafQDCK4i/C8dopSZIcyejDCfpifuCq2G1mJkPFyF4SVboch485CuDQCmXspnp0JKCsi6ZIEpKHlJyXDbcXIYgws026bTJ7oMJsgTR7dbdTXADwztjAgIk2CATzcJgz/8oMiO3fRIAHopR48anXUl3Qaj/UrHnKC/aKU7Cw6eKjki5vHnDreRPzysnqUAdd+5j5nb02pAHIDvnGeFZ3ltcnNyVvssK4tiAOmyio9KezbEt3l7y0+OwR/9I+2WMrh+o1epouEunuE8GZc6/juPzJscbJfTRvWZlX6qCIeZlCVYm5rnaduAX66NC5M0btgxTFV/j8QA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(346002)(136003)(376002)(396003)(230922051799003)(451199024)(64100799003)(186009)(82310400011)(1800799009)(40470700004)(36840700001)(46966006)(40480700001)(478600001)(2906002)(47076005)(2616005)(336012)(1076003)(40460700003)(426003)(16526019)(83380400001)(36860700001)(26005)(110136005)(70206006)(316002)(54906003)(70586007)(4326008)(5660300002)(8676002)(966005)(6666004)(41300700001)(44832011)(8936002)(82740400003)(36756003)(356005)(81166007)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2023 23:01:34.6621
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ba32ae97-7624-4a19-934f-08dbcaae0443
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000EDD4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6831
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

Fix this by using a local state variable to represent the current
vfio device state and update all the next state values. Then
release the spin_unlock(&pds_vfio->reset_lock) before checking if
the current vfio device state is VFIO_DEVICE_STATE_ERROR. Then
calling pds_vfio_put_restore_file() and pds_vfio_put_save_file() are
no longer being done while holding the reset_lock.

The only possible concerns are other threads that may call
pds_vfio_put_restore_file(), pds_vfio_put_save_file(), and/or
pds_vfio_dirty_disable(). However, those paths are already protected
by the state mutex_lock(), which is held in this context.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/kvm/1f9bc27b-3de9-4891-9687-ba2820c1b390@moroto.mountain/
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/pds/vfio_dev.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
index 306b1c25f016..cf7f639ba0ec 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -31,15 +31,17 @@ void pds_vfio_state_mutex_unlock(struct pds_vfio_pci_device *pds_vfio)
 again:
 	spin_lock(&pds_vfio->reset_lock);
 	if (pds_vfio->deferred_reset) {
+		enum vfio_device_mig_state current_state = pds_vfio->state;
+
 		pds_vfio->deferred_reset = false;
-		if (pds_vfio->state == VFIO_DEVICE_STATE_ERROR) {
+		pds_vfio->state = pds_vfio->deferred_reset_state;
+		pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_RUNNING;
+		spin_unlock(&pds_vfio->reset_lock);
+		if (current_state == VFIO_DEVICE_STATE_ERROR) {
 			pds_vfio_put_restore_file(pds_vfio);
 			pds_vfio_put_save_file(pds_vfio);
 			pds_vfio_dirty_disable(pds_vfio, false);
 		}
-		pds_vfio->state = pds_vfio->deferred_reset_state;
-		pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_RUNNING;
-		spin_unlock(&pds_vfio->reset_lock);
 		goto again;
 	}
 	mutex_unlock(&pds_vfio->state_mutex);
-- 
2.17.1

