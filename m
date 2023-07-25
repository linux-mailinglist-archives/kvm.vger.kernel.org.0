Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC8476249E
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 23:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbjGYVl3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 17:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231410AbjGYVl1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 17:41:27 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2052.outbound.protection.outlook.com [40.107.243.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF2E1FD2;
        Tue, 25 Jul 2023 14:41:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nIo1GjyqHLRKuScjBFKt6v7MwJ43KotcDm26NoG2yo8Xz3IH/PuwnI0JfSlQIufta1dvzqsPwU7URl/sOPlHS7rMXFJe8zBxuA00/LzfRh+Ay0A2ONY2uf+/f54MyxwtJ3rPFEgWU7Jjh9EyU9g80lIvRRYAlivhqpuDwPrTYOJsohwijO7p3cMPN8DbFFr76vTT/NDXMwo+a4L1nnH1Dv0j1WZnB5aS2/OURJW400mn/fAgXpbMh2k1TrohJBZVY4nU1f7HCiYel6CXwlU0hVH5G7vfoVQzE4qe2Nw0ZKTnfrwlwja2/7o3O3rNHfw1aPPS5T5tk6+XV9gw6xD2yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dqtgEyeO2rBetSTr0zmizgwpLZULoX5T1YwkI9VZW0o=;
 b=K6G4ogqE5VeEMuVxQ3gjDew9iOqZ4R6KgFOqKdGtbhiI0Tq3MiJiek5Vrmy37xD7xaJ5HVZca3bWwJbNW55RQx66P5d8z1wlbXEVoDLGf5uD8gfPbK59/gU4TWkABXWdr/zgKtxWSI3VhQQcQGbgnTOrIfmIwL9BhIhya1g4e3FMy5I15GrBdb1arXfV+wsihp+c0ffBk7CXtyWS6X58ep9nUPQTDiqVrGZJ8zSocmd9RKw6pLsTLyZsGSo86FZf9ilAKAu3WqKnoDPAikLcBkNYOdWJqGC4L9mww2eDkVE3Q5CF4isg4Pf89X4rfWegZE7SthnoZXmJcocYtsLraw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dqtgEyeO2rBetSTr0zmizgwpLZULoX5T1YwkI9VZW0o=;
 b=xS9ej/HNNhp7qIImCL35GJyPTXOfHFQZvWtvZAe3DaFMu+pLMPee3Aco0njpui21eGhsKZ9bYTSSKCwkHpL0q7AFiU8qX3oNTULlLBd3Rqi9DnmebLrPHDpFmPIbkC1Nn1eXCCM7CUx/xfQ1CNsZIxbBexcmmjfD1TAQQ8o6J6Y=
Received: from BN9PR03CA0800.namprd03.prod.outlook.com (2603:10b6:408:13f::25)
 by CH3PR12MB8076.namprd12.prod.outlook.com (2603:10b6:610:127::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Tue, 25 Jul
 2023 21:41:23 +0000
Received: from BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13f:cafe::7b) by BN9PR03CA0800.outlook.office365.com
 (2603:10b6:408:13f::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33 via Frontend
 Transport; Tue, 25 Jul 2023 21:41:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT046.mail.protection.outlook.com (10.13.177.127) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6631.22 via Frontend Transport; Tue, 25 Jul 2023 21:41:22 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Tue, 25 Jul
 2023 16:41:00 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <simon.horman@corigine.com>, <brett.creeley@amd.com>,
        <shannon.nelson@amd.com>
Subject: [PATCH v13 vfio 6/7] vfio/pds: Add support for firmware recovery
Date:   Tue, 25 Jul 2023 14:40:24 -0700
Message-ID: <20230725214025.9288-7-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230725214025.9288-1-brett.creeley@amd.com>
References: <20230725214025.9288-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT046:EE_|CH3PR12MB8076:EE_
X-MS-Office365-Filtering-Correlation-Id: 994074c7-9e61-4da3-b0f2-08db8d57e406
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d29vYXMvIVtri7198vCKVjx8qOw7YGYAnvFu8k+SQTWy1+QK+Q6iIDQNez3gZJBbfXlzaFQZSXoyAYJYNIkiQS2INMwQo9cBS7AFYSX5e70Kz2G8L+71jBNhnp+VP6/oMYh+q4ZULayutnskNgF3Q03wkhljbqwAMhRyI5f+1XfuscXnjN6CDo5Eh4eZioC6sgakurMLjF2YwoUJJdfUxCY+8zM9vMZZoVfXfJJSmD20rrcH6KyaQopkGe+N8+owZVKgh82N0IbVcHsmmZ8KSjuoEfgvCZpv32/w+ErUWL3lNmHfDfirtrrsSMJtRgWnMrybSwewTslP5IrZtzVXCCbwZvKyEpYzUw3d3Vm2tZ+u7OYmbsgMlFENv+NBoE7nIMV5+IEFLWcvWZnPQNOpKUqiwhmc6TyDc2t+q7G8g3NQlr3CRslhy13fM/IGUjqCbWCMa6RhPMgIfisSAhy+1A3xMeb5TdiFAyeigNFfAq9xyTUq462Pju6Bspp/cQDHqtg0oDYP2fsx7lfMWNzitgkl8RfCmEz0Lj78SZTRtoLFQeAlKorDO3NDa2XBXjsZoYcJI6xfn7dMr+lGc+YZpd6onCgpDG/k1F7CHzfE+zX89s4P2bscdHI5jhptRHCSuoeFRk7w42SwgV9bd/AKNOMr4y1N0DDVzyAl33EuKSJidA26Fx4FdMnPcjiV4Rv7KNnlN5ldwoY+14EPV+IdVCFmIPL/sfICurrHSGOAK3MskaQ6gxHWycnWUdy6ClWEjqpAxXUPhC2+vZAOZqJ2JA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(136003)(39860400002)(376002)(451199021)(82310400008)(36840700001)(40470700004)(46966006)(81166007)(82740400003)(356005)(16526019)(336012)(186003)(47076005)(1076003)(83380400001)(2906002)(426003)(2616005)(26005)(36756003)(36860700001)(44832011)(8676002)(8936002)(41300700001)(5660300002)(40460700003)(86362001)(110136005)(478600001)(70206006)(6666004)(70586007)(316002)(4326008)(54906003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2023 21:41:22.9903
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 994074c7-9e61-4da3-b0f2-08db8d57e406
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8076
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's possible that the device firmware crashes and is able to recover
due to some configuration and/or other issue. If a live migration
is in progress while the firmware crashes, the live migration will
fail. However, the VF PCI device should still be functional post
crash recovery and subsequent migrations should go through as
expected.

When the pds_core device notices that firmware crashes it sends an
event to all its client drivers. When the pds_vfio driver receives
this event while migration is in progress it will request a deferred
reset on the next migration state transition. This state transition
will report failure as well as any subsequent state transition
requests from the VMM/VFIO. Based on uapi/vfio.h the only way out of
VFIO_DEVICE_STATE_ERROR is by issuing VFIO_DEVICE_RESET. Once this
reset is done, the migration state will be reset to
VFIO_DEVICE_STATE_RUNNING and migration can be performed.

If the event is received while no migration is in progress (i.e.
the VM is in normal operating mode), then no actions are taken
and the migration state remains VFIO_DEVICE_STATE_RUNNING.

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/pds/pci_drv.c  | 114 ++++++++++++++++++++++++++++++++
 drivers/vfio/pci/pds/vfio_dev.c |  17 ++++-
 drivers/vfio/pci/pds/vfio_dev.h |   2 +
 3 files changed, 131 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_drv.c
index c1739edd261a..a03b7d5a3e60 100644
--- a/drivers/vfio/pci/pds/pci_drv.c
+++ b/drivers/vfio/pci/pds/pci_drv.c
@@ -19,6 +19,113 @@
 #define PDS_VFIO_DRV_DESCRIPTION	"AMD/Pensando VFIO Device Driver"
 #define PCI_VENDOR_ID_PENSANDO		0x1dd8
 
+static void pds_vfio_recovery(struct pds_vfio_pci_device *pds_vfio)
+{
+	bool deferred_reset_needed = false;
+
+	/*
+	 * Documentation states that the kernel migration driver must not
+	 * generate asynchronous device state transitions outside of
+	 * manipulation by the user or the VFIO_DEVICE_RESET ioctl.
+	 *
+	 * Since recovery is an asynchronous event received from the device,
+	 * initiate a deferred reset. Issue a deferred reset in the following
+	 * situations:
+	 *   1. Migration is in progress, which will cause the next step of
+	 *	the migration to fail.
+	 *   2. If the device is in a state that will be set to
+	 *	VFIO_DEVICE_STATE_RUNNING on the next action (i.e. VM is
+	 *	shutdown and device is in VFIO_DEVICE_STATE_STOP).
+	 */
+	mutex_lock(&pds_vfio->state_mutex);
+	if ((pds_vfio->state != VFIO_DEVICE_STATE_RUNNING &&
+	     pds_vfio->state != VFIO_DEVICE_STATE_ERROR) ||
+	    (pds_vfio->state == VFIO_DEVICE_STATE_RUNNING &&
+	     pds_vfio_dirty_is_enabled(pds_vfio)))
+		deferred_reset_needed = true;
+	mutex_unlock(&pds_vfio->state_mutex);
+
+	/*
+	 * On the next user initiated state transition, the device will
+	 * transition to the VFIO_DEVICE_STATE_ERROR. At this point it's the user's
+	 * responsibility to reset the device.
+	 *
+	 * If a VFIO_DEVICE_RESET is requested post recovery and before the next
+	 * state transition, then the deferred reset state will be set to
+	 * VFIO_DEVICE_STATE_RUNNING.
+	 */
+	if (deferred_reset_needed) {
+		spin_lock(&pds_vfio->reset_lock);
+		pds_vfio->deferred_reset = true;
+		pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_ERROR;
+		spin_unlock(&pds_vfio->reset_lock);
+	}
+}
+
+static int pds_vfio_pci_notify_handler(struct notifier_block *nb,
+				       unsigned long ecode, void *data)
+{
+	struct pds_vfio_pci_device *pds_vfio =
+		container_of(nb, struct pds_vfio_pci_device, nb);
+	struct device *dev = pds_vfio_to_dev(pds_vfio);
+	union pds_core_notifyq_comp *event = data;
+
+	dev_dbg(dev, "%s: event code %lu\n", __func__, ecode);
+
+	/*
+	 * We don't need to do anything for RESET state==0 as there is no notify
+	 * or feedback mechanism available, and it is possible that we won't
+	 * even see a state==0 event since the pds_core recovery is pending.
+	 *
+	 * Any requests from VFIO while state==0 will fail, which will return
+	 * error and may cause migration to fail.
+	 */
+	if (ecode == PDS_EVENT_RESET) {
+		dev_info(dev, "%s: PDS_EVENT_RESET event received, state==%d\n",
+			 __func__, event->reset.state);
+		/*
+		 * pds_core device finished recovery and sent us the
+		 * notification (state == 1) to allow us to recover
+		 */
+		if (event->reset.state == 1)
+			pds_vfio_recovery(pds_vfio);
+	}
+
+	return 0;
+}
+
+static int
+pds_vfio_pci_register_event_handler(struct pds_vfio_pci_device *pds_vfio)
+{
+	struct device *dev = pds_vfio_to_dev(pds_vfio);
+	struct notifier_block *nb = &pds_vfio->nb;
+	int err;
+
+	if (!nb->notifier_call) {
+		nb->notifier_call = pds_vfio_pci_notify_handler;
+		err = pdsc_register_notify(nb);
+		if (err) {
+			nb->notifier_call = NULL;
+			dev_err(dev,
+				"failed to register pds event handler: %pe\n",
+				ERR_PTR(err));
+			return -EINVAL;
+		}
+		dev_dbg(dev, "pds event handler registered\n");
+	}
+
+	return 0;
+}
+
+static void
+pds_vfio_pci_unregister_event_handler(struct pds_vfio_pci_device *pds_vfio)
+{
+	if (pds_vfio->nb.notifier_call) {
+		pdsc_unregister_notify(&pds_vfio->nb);
+		pds_vfio->nb.notifier_call = NULL;
+	}
+}
+
 static int pds_vfio_pci_probe(struct pci_dev *pdev,
 			      const struct pci_device_id *id)
 {
@@ -48,8 +155,14 @@ static int pds_vfio_pci_probe(struct pci_dev *pdev,
 		goto out_unregister_coredev;
 	}
 
+	err = pds_vfio_pci_register_event_handler(pds_vfio);
+	if (err)
+		goto out_unregister_client;
+
 	return 0;
 
+out_unregister_client:
+	pds_vfio_unregister_client_cmd(pds_vfio);
 out_unregister_coredev:
 	vfio_pci_core_unregister_device(&pds_vfio->vfio_coredev);
 out_put_vdev:
@@ -61,6 +174,7 @@ static void pds_vfio_pci_remove(struct pci_dev *pdev)
 {
 	struct pds_vfio_pci_device *pds_vfio = pds_vfio_pci_drvdata(pdev);
 
+	pds_vfio_pci_unregister_event_handler(pds_vfio);
 	pds_vfio_unregister_client_cmd(pds_vfio);
 	vfio_pci_core_unregister_device(&pds_vfio->vfio_coredev);
 	vfio_put_device(&pds_vfio->vfio_coredev.vdev);
diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
index 9e6a96b5db62..b46174f5eb09 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -33,11 +33,12 @@ void pds_vfio_state_mutex_unlock(struct pds_vfio_pci_device *pds_vfio)
 	if (pds_vfio->deferred_reset) {
 		pds_vfio->deferred_reset = false;
 		if (pds_vfio->state == VFIO_DEVICE_STATE_ERROR) {
-			pds_vfio->state = VFIO_DEVICE_STATE_RUNNING;
 			pds_vfio_put_restore_file(pds_vfio);
 			pds_vfio_put_save_file(pds_vfio);
 			pds_vfio_dirty_disable(pds_vfio, false);
 		}
+		pds_vfio->state = pds_vfio->deferred_reset_state;
+		pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_RUNNING;
 		spin_unlock(&pds_vfio->reset_lock);
 		goto again;
 	}
@@ -49,6 +50,7 @@ void pds_vfio_reset(struct pds_vfio_pci_device *pds_vfio)
 {
 	spin_lock(&pds_vfio->reset_lock);
 	pds_vfio->deferred_reset = true;
+	pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_RUNNING;
 	if (!mutex_trylock(&pds_vfio->state_mutex)) {
 		spin_unlock(&pds_vfio->reset_lock);
 		return;
@@ -67,7 +69,14 @@ pds_vfio_set_device_state(struct vfio_device *vdev,
 	struct file *res = NULL;
 
 	mutex_lock(&pds_vfio->state_mutex);
-	while (new_state != pds_vfio->state) {
+	/*
+	 * only way to transition out of VFIO_DEVICE_STATE_ERROR is via
+	 * VFIO_DEVICE_RESET, so prevent the state machine from running since
+	 * vfio_mig_get_next_state() will throw a WARN_ON() when transitioning
+	 * from VFIO_DEVICE_STATE_ERROR to any other state
+	 */
+	while (pds_vfio->state != VFIO_DEVICE_STATE_ERROR &&
+	       new_state != pds_vfio->state) {
 		enum vfio_device_mig_state next_state;
 
 		int err = vfio_mig_get_next_state(vdev, pds_vfio->state,
@@ -89,6 +98,9 @@ pds_vfio_set_device_state(struct vfio_device *vdev,
 		}
 	}
 	pds_vfio_state_mutex_unlock(pds_vfio);
+	/* still waiting on a deferred_reset */
+	if (pds_vfio->state == VFIO_DEVICE_STATE_ERROR)
+		res = ERR_PTR(-EIO);
 
 	return res;
 }
@@ -169,6 +181,7 @@ static int pds_vfio_open_device(struct vfio_device *vdev)
 
 	mutex_init(&pds_vfio->state_mutex);
 	pds_vfio->state = VFIO_DEVICE_STATE_RUNNING;
+	pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_RUNNING;
 
 	vfio_pci_core_finish_enable(&pds_vfio->vfio_coredev);
 
diff --git a/drivers/vfio/pci/pds/vfio_dev.h b/drivers/vfio/pci/pds/vfio_dev.h
index 8109fe101694..30a7d22f48eb 100644
--- a/drivers/vfio/pci/pds/vfio_dev.h
+++ b/drivers/vfio/pci/pds/vfio_dev.h
@@ -23,6 +23,8 @@ struct pds_vfio_pci_device {
 	enum vfio_device_mig_state state;
 	spinlock_t reset_lock; /* protect reset_done flow */
 	u8 deferred_reset;
+	enum vfio_device_mig_state deferred_reset_state;
+	struct notifier_block nb;
 
 	int vf_id;
 	u16 client_id;
-- 
2.17.1

