Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A63475A206
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 00:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjGSWgF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 18:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbjGSWgD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 18:36:03 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2052.outbound.protection.outlook.com [40.107.223.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845F02115;
        Wed, 19 Jul 2023 15:35:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ANc/04AUrVIHTFyjmZxT5tWR5lIZpIb8TVwU3vKVEer0WnLf9xVv7iPFk7p1YwB1kEFT7/smL4l02VNhUnDAuZbqXalI0qfAkBui/Mts7VuhuelUQHlWI9HHFM3hYyR5+d4EIl5QDCvhx5hC/3j5rq4IiMiMa47yX3UhCMjHilSgjVW8r64vHmrPzp1PvmkI3XvUwJD44d37AHHiuS6LrvXLRDDVnQdIzfpjy9X34jUaqqWCxGRfxJ97BCLd7EMunkj57IVJpZhM4FwEvmckWf0qjQ0bZkqf93P3Aen57Vx2mRMhnZnWdvky04TO8ji+Sic4C0WhuEIzPf928q5XJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uKEoZ7TG/GaAjkg6Y9oOKc+HMAq4NthSj7iXw+tARsE=;
 b=jD4FDBMPB1Am1nqyT6RPjRuN+z6F/HYP0DYFK14Ispv9XFpX7YAfk1MBENkI4tO0B+kKRdlF0Vjwx0HKwvVV6uNi8EPxKILSyUB4pwXGSL+Ugbku5rhVpm368SNVaUV3hpLWy70InwNHzBX4le7r6rmEroRvG6hhew9mFz4O62tvXKmmnI3FU+ty8pySyzakUITqwKOSnzU6k4X/vwdVQI+7GNAyXJ24SxoFsKZ4FF40DgE9hn5tczM/ynPwCLK24/vVktqrOJvYhCCiSF88TRTumGEi2A9FIYjb7+VLYayOSrTA6AB2fLLBO6i3ql8c8BXN93DnaA9Rr/G0na/n/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uKEoZ7TG/GaAjkg6Y9oOKc+HMAq4NthSj7iXw+tARsE=;
 b=az2ciWp8uG+ZEun/OcD00z6NsR1LB1aOzp4UdaON32wz5EX49RbtGHHNB6X8YJpYuA+WMn7+XQ6QS+a8/3bpnJjAYxUkNB/Fw1Ze50aaqgSIGBd/E+r8e7AuFrp3ZpdDETYdPcRxII+F6/gG2I05+76IfQQhpEyKypn4AF3PCng=
Received: from BN0PR08CA0023.namprd08.prod.outlook.com (2603:10b6:408:142::17)
 by PH7PR12MB7113.namprd12.prod.outlook.com (2603:10b6:510:1ec::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.24; Wed, 19 Jul
 2023 22:35:53 +0000
Received: from BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:142:cafe::e1) by BN0PR08CA0023.outlook.office365.com
 (2603:10b6:408:142::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.24 via Frontend
 Transport; Wed, 19 Jul 2023 22:35:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT046.mail.protection.outlook.com (10.13.177.127) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6588.35 via Frontend Transport; Wed, 19 Jul 2023 22:35:52 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 19 Jul
 2023 17:35:51 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <brett.creeley@amd.com>, <shannon.nelson@amd.com>
Subject: [PATCH v12 vfio 6/7] vfio/pds: Add support for firmware recovery
Date:   Wed, 19 Jul 2023 15:35:26 -0700
Message-ID: <20230719223527.12795-7-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230719223527.12795-1-brett.creeley@amd.com>
References: <20230719223527.12795-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT046:EE_|PH7PR12MB7113:EE_
X-MS-Office365-Filtering-Correlation-Id: 135f52c6-8e20-48da-bb2f-08db88a8827d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 41uG6pNMy8+pa0OsaHX1Ff9IavNr91VtYNH37u6xpWYYVNmKQwUlweEiDoVzn50zA5X1yC7Iu/nvdk44DC1GIHon1V1s/OH9l84JWJMzivGYa0wHt+99pXuGyq7CeRD1a4N6jj0qZ06aCczrKY7a1ZNM6cku04xzmwICLBQTUTzc+ck4kLHePrfziA8NSiliDraAPdwbkr5t2Re+Pth/6+4HpX+KKR7lhWirOeLPNdSPk9Yc9ICqTnv9ZUhYOwTnQdWmBQTHan+ECdLNbW+htSt7/umkSQGjuxvOIfuxBPtK5G/ibrIJxCLHfFGEaPVisQyrhL5KFGPJ+0SehqJHrTheIOsOmNdRA0sfJwOGEWgfjFC/A4DywClq3Y6DFovSJ7qzqzxqQ2iXSei/sile+QHCCB8WEVNe0rKfV9iuFUDMnwNhFTVLqq9SWZ58hTMUlVzwkY2Wm2AUNUJS0+0vaXnUAbrFF5/1ceha9Tu/6h0l1iWULAVVbsOf/rmeM0W7o1OVt/QupiRQu3Tycwf20KFb9AG2yPQA7CyEJOW2XagCFU+HUE2SniA+nRdFeN2MYpTIX6PoO3E/NoUJrGOOk+iEy2IQ4hfaD27G86vsFrWFHLroi6KYkaYrlKqkpJl4N3jPmQgBYy/86KtFD3JZPUDXfnGsVeHCWdXeqF7/CkcyAL/8h62w+J3UEV2SMje29CfgvQxKSY+e63BnaZKuz5wveGLJMuDD8OTAXfjUb0mlm5bM3U5eVouHIgF3jck1RH3xV+l1B1Js4ZvtwPofrw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(39860400002)(376002)(346002)(451199021)(82310400008)(46966006)(36840700001)(40470700004)(426003)(2616005)(186003)(16526019)(1076003)(83380400001)(6666004)(47076005)(26005)(36860700001)(478600001)(316002)(54906003)(110136005)(336012)(4326008)(70586007)(70206006)(44832011)(5660300002)(41300700001)(8936002)(8676002)(2906002)(86362001)(36756003)(40460700003)(81166007)(356005)(82740400003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2023 22:35:52.7749
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 135f52c6-8e20-48da-bb2f-08db88a8827d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7113
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
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
index eb832af39545..b38c66bf28a4 100644
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

