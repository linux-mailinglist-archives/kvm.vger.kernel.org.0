Return-Path: <kvm+bounces-10175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35EDC86A485
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 01:33:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0E51284B48
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 00:33:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D4B74C90;
	Wed, 28 Feb 2024 00:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="G17SRz60"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2057.outbound.protection.outlook.com [40.107.244.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14D579E5;
	Wed, 28 Feb 2024 00:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709080355; cv=fail; b=QIZ4KoywndPINjHVOe8+xPPJnTnIvnmj16TkRSfObsAQvjNT2GKI4nPJY+PMrjoWD+A+7feMDMz25IaQJ0McgaOGIyHgms00gJ0YwxS1iOkQcwMExTpAL3UvHd4nDpo7Kx4gAyJrZgXfMo8PGGfIDCFVUbS3mgsLcTW2HKFYM/A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709080355; c=relaxed/simple;
	bh=nZ+eQdgS5SXO1P0UoXwfHFI1Lne+ke6IhtGbHEKYQnM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oAD/6keqDxKxITLacl2EKWiBJCWldUfL3U8Pw4dMbCXLQS5R8dh3oA8fkFT72nHamJ0U8klcIRZGWdhkNQEXKgH6Fp6U0Sij9An3JUBTKCrWm7Izh0YNfG+dY1PhL5JO4U+UzWyjJ6T6bRAKds+1Jt5oWsDW1/hrh7lUC+y4a7g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=G17SRz60; arc=fail smtp.client-ip=40.107.244.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mFcffwQ8UY8ZKgQl/MG8gatgJDFlAVcFWgccRVdwSPIGXfgv29qPJXSmuxli1nN6Iegu77GfFF+qd+1Fj0O266gEcNe/Oawb/3TN3QqvZcaY4fZ4B5fAS0D1eoW7CgLTvLFxsmU9H6UETvL9WGEl6yMwlP/HRCLFITnPC1tiRiksTh848hctNe76H649P26rw79QS471fcP75NyfI9BoVOoECWK5KaeGViHadiTXgdK1MEF2aNw7ynHMKNMYEi7hdYP1vsbl3CvbiV42aJEjDLhdq4gGQMz0cr+ENBrTF76ngfWMI9esnmWjdQP32M2LtnP+UrDCiX28opPVNa3Icw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ws91NiYtg4bM+b9Kg5rN+YdWJ+f7mRFZ+d6ixZOP/rI=;
 b=njHIxZBaybt5tewWugxUvf+x2GGMuIWDdjhTpZl4bzwvVQBee4Y0RRjeELKA45TD9FR4saih1jr4ypdIhEE/vsY4+OmIcUM1+CBDu/8QU9LCku0Dn9C4hmD+U0siocx6ecmoV19jWySBek9D4q0Ge2w0YvUNz+Hj7mSQiSA3ggYRToVExgNVQ2ZaMr7WE+7aASpSh3Z9tLn89YXz0oA+Ljv1GaQ0uF9Q+V7xLYhJT5PF23EPv8ssWT4EP0FiXqB9XYn0krjMX+3qfrSV3KjvtT3xeQWJCMYC6y3eRFklYsaChmH8Q0ft8zwTaXXVzP05rYrm7i6DGTBUvDyVvhs2Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ws91NiYtg4bM+b9Kg5rN+YdWJ+f7mRFZ+d6ixZOP/rI=;
 b=G17SRz60tjGEvVqtay+VTJ4kS1tW2L4g9WBA9ijbJDWRvOTp7UJAkZfuJvuGjyhoTmyD6yrql1lpgyJCzv0A4GXEZkFpRwIMIVs1uif8Q+BrCQdxO30C+T6rXZUSNh0hYWWbYzlfjTcFkKxH2pKvsoipZvUUhjToQ9ObxvPk+2k=
Received: from SJ0PR03CA0031.namprd03.prod.outlook.com (2603:10b6:a03:33e::6)
 by CH3PR12MB9432.namprd12.prod.outlook.com (2603:10b6:610:1c7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.39; Wed, 28 Feb
 2024 00:32:25 +0000
Received: from CO1PEPF000044F1.namprd05.prod.outlook.com
 (2603:10b6:a03:33e:cafe::90) by SJ0PR03CA0031.outlook.office365.com
 (2603:10b6:a03:33e::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.50 via Frontend
 Transport; Wed, 28 Feb 2024 00:32:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F1.mail.protection.outlook.com (10.167.241.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Wed, 28 Feb 2024 00:32:25 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 27 Feb
 2024 18:32:23 -0600
From: Brett Creeley <brett.creeley@amd.com>
To: <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <shannon.nelson@amd.com>, <brett.creeley@amd.com>
Subject: [PATCH v2 vfio 2/2] vfio/pds: Refactor/simplify reset logic
Date: Tue, 27 Feb 2024 16:32:05 -0800
Message-ID: <20240228003205.47311-3-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240228003205.47311-1-brett.creeley@amd.com>
References: <20240228003205.47311-1-brett.creeley@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F1:EE_|CH3PR12MB9432:EE_
X-MS-Office365-Filtering-Correlation-Id: e0c8b115-d7c4-4244-7324-08dc37f4bc5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8X/Gf+OeuLAwFsIQUYFvQMpUP1lWsnGGHp0omQr3TyXNlSD6yWi9y9aUBAEtet+bIV0lAzX5zehtao4Z32i6OGYihyfHpd/PKLR5C/xespIfLwxxEOrEx93C0JkhRw31xy/r8ajRUYbeQtvnteEcGUrbgez803W/5GlNKhTgLhJLK422C9hjMklNC+5dJqbckPsLToDeKHIQibO/60DzlVL2Og+cUI6tQJ28ghNFHXATVNtM5G/qBVZE6FGTXwu1xp5vtTsw3/+QbTpjYK5qyxRariZSNdBR5bxktdthtsadjzEWFSvHbCIxtauc1yjJipj9vBE3U4v2X6UDkVP6mdS8Es1ziFmGXhIYNWKaATANjz7capnjMMaN55ET6PQoM+q2f1H/7GZ0lD5jgUwFAMbdbZxrHjMBzHce7IKOd7hkW+43g0/P+nGqkXwvup/39DLdMx1xzMiCNpkWIxP9forenbGE/C0oHEzcdGUuXl5S7bbN94gIyPLYUAyWusTJDrW/l5Iu8LkSqDdj/0491E9stCE1hlqhEXEMXxrJ9nZTKToQXt+3IunWPaX83gXOk4KHpADJDKasz+dvnxStlkLAA0sBL73H5qPI/BKIg5PeE8XVb5GQCjCg7fmkFmaXI+Gnt6nk6SSCxy+dtgh+7+4HPDWxSE2/IEYx1nGdkaFx6vpNaX1IhzakWoKVs7hrGTDGmxKAu7AvLBzBAf84XVlAg+6z20/F3pwVGoWi9jau4O1peKKNzgp89AN9B7iE
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2024 00:32:25.0125
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e0c8b115-d7c4-4244-7324-08dc37f4bc5f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9432

The current logic for handling resets is more complicated than it needs
to be. The deferred_reset flag is used to indicate a reset is needed
and the deferred_reset_state is the requested, post-reset, state. The
source of the requested reset isn't immediately obvious. Improve
readability by replacing deferred_reset_state with deferred_reset_type,
which can be either PDS_VFIO_DEVICE_RESET (initiated/requested by the
DSC) or PDS_VFIO_HOST_RESET (initiated/requested by the VMM).

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/pds/pci_drv.c  |  2 +-
 drivers/vfio/pci/pds/vfio_dev.c | 10 +++++-----
 drivers/vfio/pci/pds/vfio_dev.h |  7 ++++++-
 3 files changed, 12 insertions(+), 7 deletions(-)

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
index a286ebcc7112..1a791bef5de1 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -34,11 +34,12 @@ void pds_vfio_state_mutex_unlock(struct pds_vfio_pci_device *pds_vfio)
 		pds_vfio->deferred_reset = false;
 		pds_vfio_put_restore_file(pds_vfio);
 		pds_vfio_put_save_file(pds_vfio);
-		if (pds_vfio->state == VFIO_DEVICE_STATE_ERROR) {
+		if (pds_vfio->deferred_reset_type == PDS_VFIO_DEVICE_RESET) {
 			pds_vfio_dirty_disable(pds_vfio, false);
+			pds_vfio->state = VFIO_DEVICE_STATE_ERROR;
+		} else {
+			pds_vfio->state = VFIO_DEVICE_STATE_RUNNING;
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


