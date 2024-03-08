Return-Path: <kvm+bounces-11389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDE8A876AB0
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 19:22:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 725602850D9
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 18:22:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D30E75A7A9;
	Fri,  8 Mar 2024 18:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="M+05VoZV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2074.outbound.protection.outlook.com [40.107.244.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177DB58AAF;
	Fri,  8 Mar 2024 18:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709922142; cv=fail; b=qKfWl7Kgl1EusDcD/fgljbl+offosKxTsKl/dMTgKdaDlecCCP3BX5NST7/o7DKNSlqwAeUO+OCCQ5pYNCpjdpXXGsgLJrnkgwNw6y5PfsxKV+/CEi6R1vTbrw5xEf1VT/J5r24VreS8cigl8rn3k3j5bWQaH9uSlimohN2Rt7Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709922142; c=relaxed/simple;
	bh=Dp1ps4p2a6PxNVR7CKWL0j5ddt+eUww46+EbW8+7ZKk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bJ5oCO1l4wnhycMol+8n7TVNl1D6Z9/e4mIxMZz2y1XmF4cJaDzKM04jz6q79P3wkzqdsrbtjuE/CsbW8zh3bbiwiXtOBAuqNl8aY++oVnlgwQkBnK7AW84RnqSJq8BN39R/ZbnoRTWo1+ND0SnpGX1NXzO63hlm3RWu0sxPxmI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=M+05VoZV; arc=fail smtp.client-ip=40.107.244.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T47zlnizwY2f0Akhj/QLLBNBsnviv6J2CkWyHyT1y6DQ/iHcWKQYDyAXM0b7YULmMnCPdW85KPsOEZOaSYJ0oyGxYjoYtFbMhg/l3lOgEzUIwS0MEoHV/E+z194nlYgFdjrPv42jzuMDZDVz+HbKAdfwmYRh//FM+qSQgGWCZw4jQTTydxakGqpyv8YpDw2/Rcj6lgRzdR+xF3AwTH9l1JI6hUg8AYAR70OSoMupYLGa9xMcDN5tFl59z5XCTPaw829C2fwJRk5XKZbHjKVowpnTDGBE/FeSwHbdjL2+nt+GWFf/XJxSsi55tUrp0UE/ydeVggHVy1dMgNeRH0PSmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ul4K1dyakV31IACSAHTXgLY2Pt0CAw6yDHWzXlWBiBc=;
 b=YoBlprOu7WsAr75lFi0YkATvz/JLWICObUEd7VPeUvJpvWIf19TVQg0xxeQohdGHV+e6t63+9etFWSpckkUaTBQvB+gubCBlJeQPXk7Kj6gkaDXifCXMUvgslWOcQVATVAXWmrKQu7WZeOe3i1IKUV2mcED8kGgo0TErTxT8PCCr++wtP/DR/8cyJI4W9Qu80JGQJE2uxjg/SqgtEjRJyZXUl4c0VHqbDTXq2pciBSu5ChrqKyE2exueibuMzb77LSjVgCs3cGb+Irq24OQsZQ5DD3sjgBduH9X6+3BUcmTWDtokSXgtYJCG4nYoSrd2P6z+4A2dGjgxpqt0D7W9AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ul4K1dyakV31IACSAHTXgLY2Pt0CAw6yDHWzXlWBiBc=;
 b=M+05VoZVRpofllx9T64HCQXOX/IcdJ9NPlBMkJQz414FIS0ZhJvTqlZOg1eqhzfQyRqWTw5zGSGgyjFjTrddpV2d/Q4h4U0Il1DrbJy9hAjUZis1XVbfqxWRAsLGCpOQncZPbJ+5nyDZcbq/esfrgan3UJHn0pCGoH2Zxy5ANAs=
Received: from CH0PR03CA0051.namprd03.prod.outlook.com (2603:10b6:610:b3::26)
 by IA1PR12MB8405.namprd12.prod.outlook.com (2603:10b6:208:3d8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.24; Fri, 8 Mar
 2024 18:22:17 +0000
Received: from CY4PEPF0000EE39.namprd03.prod.outlook.com
 (2603:10b6:610:b3:cafe::38) by CH0PR03CA0051.outlook.office365.com
 (2603:10b6:610:b3::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.43 via Frontend
 Transport; Fri, 8 Mar 2024 18:22:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE39.mail.protection.outlook.com (10.167.242.13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7386.12 via Frontend Transport; Fri, 8 Mar 2024 18:22:17 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 8 Mar
 2024 12:22:15 -0600
From: Brett Creeley <brett.creeley@amd.com>
To: <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <shannon.nelson@amd.com>, <brett.creeley@amd.com>
Subject: [PATCH vfio 2/2] vfio/pds: Refactor/simplify reset logic
Date: Fri, 8 Mar 2024 10:21:49 -0800
Message-ID: <20240308182149.22036-3-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240308182149.22036-1-brett.creeley@amd.com>
References: <20240308182149.22036-1-brett.creeley@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE39:EE_|IA1PR12MB8405:EE_
X-MS-Office365-Filtering-Correlation-Id: 24335d5b-83e9-4179-260d-08dc3f9cafb1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	JtWkkg9yNWej5/p3olpHm5iMknUsD0+vBNTdlvC6Ta7l9z3vWiseiVkWWqfyE9aYsJEi/mdIeqejaharpMHJodlnkUYSPu3xWD0CnUd4vbaMzA2t8Bd3imWuJCdjpgBmbUmq92dddpy2TNdjGLH9c44Z8VcphyB/4SyTzedjyzq4GBmndqMsvDeqZg+jVnPp5yic9X3vsCFx6vs2Ti7fA9OWxgF4ZmyEbscaFlI/Hv56yqtoEACRsaxf6QHKMiu7es24VNm5jYOGXq9eupICpJvFEnwqEM/So/0d+0Q1n7jTQp31+hqGATuGYxKVuNa3CplOu8p+rXr/t/MZVdf5NsfcMyMvA3mugJF5RGuLp4qKAm9KWQSipeWSoP04es6tlErNIy8/1lAHWghIDJ/2PoEh+FkUyeWXzOt0Q46h3jP0OiJhbinY3W9bly1TjVBRwTW+YpcC2rR0MAZFTSgxUsPh9ZgMGYavTxuzGrjiY486ltwTFMlJijmRitK/FA4WIINHkWGeksuj1m5ZPu05VhrAH9dMeXOQQuDJWOAxmc/ufxMtsxsqbMrI4hWnG+m/MqohaNOcPpTWCoUfmG7kj4MkSPU+jzVa4H5a1woD3IUAC3iu1lcPRNKXKl7fxU0dgcV1yQ5IqgmIbC04pSLnXrt7Sd2lay/velN1GEOJ4nuqMo07amCeGZ6guZ2JGDoBBAJ9udjM/sTI7lcLUGlu01PcnsXInH/v5UlBC9tm6gLcsriNC0JC4wH/Yct+0rcR
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(36860700004)(82310400014)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2024 18:22:17.3588
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 24335d5b-83e9-4179-260d-08dc3f9cafb1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE39.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8405

The current logic for handling resets is more complicated than it needs
to be. The deferred_reset flag is used to indicate a reset is needed
and the deferred_reset_state is the requested, post-reset, state.

Also, the deferred_reset logic was added to vfio migration drivers to
prevent a circular locking dependency with respect to mm_lock and state
mutex. This is mainly because of the copy_to/from_user() functions(which
takes mm_lock) invoked under state mutex.

Remove all of the deferred reset logic and just pass the requested
next state to pds_vfio_reset() so it can be used for VMM and DSC
initiated resets.

This removes the need for pds_vfio_state_mutex_lock(), so remove that
and replace its use with a simple mutex_unlock().

Also, remove the reset_mutex as it's no longer needed since the
state_mutex can be the driver's primary protector.

Suggested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
---
 drivers/vfio/pci/pds/dirty.c    |  6 ++---
 drivers/vfio/pci/pds/pci_drv.c  | 27 ++++----------------
 drivers/vfio/pci/pds/vfio_dev.c | 45 +++++++--------------------------
 drivers/vfio/pci/pds/vfio_dev.h |  8 ++----
 4 files changed, 19 insertions(+), 67 deletions(-)

diff --git a/drivers/vfio/pci/pds/dirty.c b/drivers/vfio/pci/pds/dirty.c
index 8ddf4346fcd5..68e8f006dfdb 100644
--- a/drivers/vfio/pci/pds/dirty.c
+++ b/drivers/vfio/pci/pds/dirty.c
@@ -607,7 +607,7 @@ int pds_vfio_dma_logging_report(struct vfio_device *vdev, unsigned long iova,
 
 	mutex_lock(&pds_vfio->state_mutex);
 	err = pds_vfio_dirty_sync(pds_vfio, dirty, iova, length);
-	pds_vfio_state_mutex_unlock(pds_vfio);
+	mutex_unlock(&pds_vfio->state_mutex);
 
 	return err;
 }
@@ -624,7 +624,7 @@ int pds_vfio_dma_logging_start(struct vfio_device *vdev,
 	mutex_lock(&pds_vfio->state_mutex);
 	pds_vfio_send_host_vf_lm_status_cmd(pds_vfio, PDS_LM_STA_IN_PROGRESS);
 	err = pds_vfio_dirty_enable(pds_vfio, ranges, nnodes, page_size);
-	pds_vfio_state_mutex_unlock(pds_vfio);
+	mutex_unlock(&pds_vfio->state_mutex);
 
 	return err;
 }
@@ -637,7 +637,7 @@ int pds_vfio_dma_logging_stop(struct vfio_device *vdev)
 
 	mutex_lock(&pds_vfio->state_mutex);
 	pds_vfio_dirty_disable(pds_vfio, true);
-	pds_vfio_state_mutex_unlock(pds_vfio);
+	mutex_unlock(&pds_vfio->state_mutex);
 
 	return 0;
 }
diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_drv.c
index a34dda516629..16e93b11ab1b 100644
--- a/drivers/vfio/pci/pds/pci_drv.c
+++ b/drivers/vfio/pci/pds/pci_drv.c
@@ -21,16 +21,13 @@
 
 static void pds_vfio_recovery(struct pds_vfio_pci_device *pds_vfio)
 {
-	bool deferred_reset_needed = false;
-
 	/*
 	 * Documentation states that the kernel migration driver must not
 	 * generate asynchronous device state transitions outside of
 	 * manipulation by the user or the VFIO_DEVICE_RESET ioctl.
 	 *
 	 * Since recovery is an asynchronous event received from the device,
-	 * initiate a deferred reset. Issue a deferred reset in the following
-	 * situations:
+	 * initiate a reset in the following situations:
 	 *   1. Migration is in progress, which will cause the next step of
 	 *	the migration to fail.
 	 *   2. If the device is in a state that will be set to
@@ -42,24 +39,8 @@ static void pds_vfio_recovery(struct pds_vfio_pci_device *pds_vfio)
 	     pds_vfio->state != VFIO_DEVICE_STATE_ERROR) ||
 	    (pds_vfio->state == VFIO_DEVICE_STATE_RUNNING &&
 	     pds_vfio_dirty_is_enabled(pds_vfio)))
-		deferred_reset_needed = true;
+		pds_vfio_reset(pds_vfio, VFIO_DEVICE_STATE_ERROR);
 	mutex_unlock(&pds_vfio->state_mutex);
-
-	/*
-	 * On the next user initiated state transition, the device will
-	 * transition to the VFIO_DEVICE_STATE_ERROR. At this point it's the user's
-	 * responsibility to reset the device.
-	 *
-	 * If a VFIO_DEVICE_RESET is requested post recovery and before the next
-	 * state transition, then the deferred reset state will be set to
-	 * VFIO_DEVICE_STATE_RUNNING.
-	 */
-	if (deferred_reset_needed) {
-		mutex_lock(&pds_vfio->reset_mutex);
-		pds_vfio->deferred_reset = true;
-		pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_ERROR;
-		mutex_unlock(&pds_vfio->reset_mutex);
-	}
 }
 
 static int pds_vfio_pci_notify_handler(struct notifier_block *nb,
@@ -185,7 +166,9 @@ static void pds_vfio_pci_aer_reset_done(struct pci_dev *pdev)
 {
 	struct pds_vfio_pci_device *pds_vfio = pds_vfio_pci_drvdata(pdev);
 
-	pds_vfio_reset(pds_vfio);
+	mutex_lock(&pds_vfio->state_mutex);
+	pds_vfio_reset(pds_vfio, VFIO_DEVICE_STATE_RUNNING);
+	mutex_unlock(&pds_vfio->state_mutex);
 }
 
 static const struct pci_error_handlers pds_vfio_pci_err_handlers = {
diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
index a286ebcc7112..76a80ae7087b 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -26,37 +26,14 @@ struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev)
 			    vfio_coredev);
 }
 
-void pds_vfio_state_mutex_unlock(struct pds_vfio_pci_device *pds_vfio)
+void pds_vfio_reset(struct pds_vfio_pci_device *pds_vfio,
+		    enum vfio_device_mig_state state)
 {
-again:
-	mutex_lock(&pds_vfio->reset_mutex);
-	if (pds_vfio->deferred_reset) {
-		pds_vfio->deferred_reset = false;
-		pds_vfio_put_restore_file(pds_vfio);
-		pds_vfio_put_save_file(pds_vfio);
-		if (pds_vfio->state == VFIO_DEVICE_STATE_ERROR) {
-			pds_vfio_dirty_disable(pds_vfio, false);
-		}
-		pds_vfio->state = pds_vfio->deferred_reset_state;
-		pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_RUNNING;
-		mutex_unlock(&pds_vfio->reset_mutex);
-		goto again;
-	}
-	mutex_unlock(&pds_vfio->state_mutex);
-	mutex_unlock(&pds_vfio->reset_mutex);
-}
-
-void pds_vfio_reset(struct pds_vfio_pci_device *pds_vfio)
-{
-	mutex_lock(&pds_vfio->reset_mutex);
-	pds_vfio->deferred_reset = true;
-	pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_RUNNING;
-	if (!mutex_trylock(&pds_vfio->state_mutex)) {
-		mutex_unlock(&pds_vfio->reset_mutex);
-		return;
-	}
-	mutex_unlock(&pds_vfio->reset_mutex);
-	pds_vfio_state_mutex_unlock(pds_vfio);
+	pds_vfio_put_restore_file(pds_vfio);
+	pds_vfio_put_save_file(pds_vfio);
+	if (state == VFIO_DEVICE_STATE_ERROR)
+		pds_vfio_dirty_disable(pds_vfio, false);
+	pds_vfio->state = state;
 }
 
 static struct file *
@@ -97,8 +74,7 @@ pds_vfio_set_device_state(struct vfio_device *vdev,
 			break;
 		}
 	}
-	pds_vfio_state_mutex_unlock(pds_vfio);
-	/* still waiting on a deferred_reset */
+	mutex_unlock(&pds_vfio->state_mutex);
 	if (pds_vfio->state == VFIO_DEVICE_STATE_ERROR)
 		res = ERR_PTR(-EIO);
 
@@ -114,7 +90,7 @@ static int pds_vfio_get_device_state(struct vfio_device *vdev,
 
 	mutex_lock(&pds_vfio->state_mutex);
 	*current_state = pds_vfio->state;
-	pds_vfio_state_mutex_unlock(pds_vfio);
+	mutex_unlock(&pds_vfio->state_mutex);
 	return 0;
 }
 
@@ -156,7 +132,6 @@ static int pds_vfio_init_device(struct vfio_device *vdev)
 	pds_vfio->vf_id = vf_id;
 
 	mutex_init(&pds_vfio->state_mutex);
-	mutex_init(&pds_vfio->reset_mutex);
 
 	vdev->migration_flags = VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P;
 	vdev->mig_ops = &pds_vfio_lm_ops;
@@ -178,7 +153,6 @@ static void pds_vfio_release_device(struct vfio_device *vdev)
 			     vfio_coredev.vdev);
 
 	mutex_destroy(&pds_vfio->state_mutex);
-	mutex_destroy(&pds_vfio->reset_mutex);
 	vfio_pci_core_release_dev(vdev);
 }
 
@@ -194,7 +168,6 @@ static int pds_vfio_open_device(struct vfio_device *vdev)
 		return err;
 
 	pds_vfio->state = VFIO_DEVICE_STATE_RUNNING;
-	pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_RUNNING;
 
 	vfio_pci_core_finish_enable(&pds_vfio->vfio_coredev);
 
diff --git a/drivers/vfio/pci/pds/vfio_dev.h b/drivers/vfio/pci/pds/vfio_dev.h
index e7b01080a1ec..803d99d69c73 100644
--- a/drivers/vfio/pci/pds/vfio_dev.h
+++ b/drivers/vfio/pci/pds/vfio_dev.h
@@ -18,20 +18,16 @@ struct pds_vfio_pci_device {
 	struct pds_vfio_dirty dirty;
 	struct mutex state_mutex; /* protect migration state */
 	enum vfio_device_mig_state state;
-	struct mutex reset_mutex; /* protect reset_done flow */
-	u8 deferred_reset;
-	enum vfio_device_mig_state deferred_reset_state;
 	struct notifier_block nb;
 
 	int vf_id;
 	u16 client_id;
 };
 
-void pds_vfio_state_mutex_unlock(struct pds_vfio_pci_device *pds_vfio);
-
 const struct vfio_device_ops *pds_vfio_ops_info(void);
 struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev);
-void pds_vfio_reset(struct pds_vfio_pci_device *pds_vfio);
+void pds_vfio_reset(struct pds_vfio_pci_device *pds_vfio,
+		    enum vfio_device_mig_state state);
 
 struct pci_dev *pds_vfio_to_pci_dev(struct pds_vfio_pci_device *pds_vfio);
 struct device *pds_vfio_to_dev(struct pds_vfio_pci_device *pds_vfio);
-- 
2.17.1


