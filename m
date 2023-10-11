Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 739497C60C8
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 01:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376600AbjJKXBl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 19:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376524AbjJKXBf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 19:01:35 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2081.outbound.protection.outlook.com [40.107.94.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBFBA9;
        Wed, 11 Oct 2023 16:01:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jxoFiwV3QjqF+C8cD4UKUKnY6gzwDvofHdXjZBsLuUCTByarJYdLFhEaF3R5wqJCEDGi0OpxVlQa7L+vH4M/IAXIfNnFeY6dXvdDs9AdI8QgWjcCq8P6TrQBauzjzVuamtXBs56d2PfdpgQ1U1Ra3+9uMChXmzCJAuzmBILRBepM50iLwRqHtcfMu4bRQDD/Z5KJhZiW6nAKDlYyM7JoJl93zEdDC76lHQDAO8Yz9uA3mNZW7hl7G8WaqVF98j+cDS29cazkSd+xu4NfBT3MY7ac6ozjaPaQw7tNVIcgj2yykvYCiEa9MvJOLmA63sSlhtfmWFpPhne51ZdmxkyMZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/lV4lyDxKEyVexv4om1bfCyS3zqujBEjXmB9A1ox1lQ=;
 b=cAzRzQ+qPUjMn42Op7Ak4wzJtWO0KQPOV0EhPoEIZ+HDvfxNYECxaDWQthyL/jXf8km65uSN3YeF9ZMBPAv/gotl+94MGCj3RgUPUAGHKv98YMLKx8qYZTF//ZdavxmW1sPD00O8NUJPXWknHvgyL4VvgQgpHo+8V+YD2ExMUCCVLjlx+kMzLkkqoCcu2vbsojxqX0+/V6HrgblrP4V5LC1tqZWJRs9u75bSGJYh41LH+4XB6BEu81/zArfkPYoQN/HSjsQsHssHhkJLVgJ2zYwHFQ+oszspoYCkVCnmNlKLrDjnHblt2gT9tE/f8+KfMj2eE401X5KNYVry9LxaTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/lV4lyDxKEyVexv4om1bfCyS3zqujBEjXmB9A1ox1lQ=;
 b=K7aLhVjk17MNJGKHsYGacIpe7i9xOV51kJNwi8+FHu3iWFWuJvmTJen+v+ijk666JD4iCW1bKwXniDgL0TBIzgNJbMgbwCKOB1j7lB6a3oNYsjAXAxXoZOmKKz1SDWZc/h6yxGHo9TK1eB6EBJ2jO39obJsMVLQkY51CQ7yN2l8=
Received: from CY5PR15CA0147.namprd15.prod.outlook.com (2603:10b6:930:67::16)
 by MW6PR12MB8865.namprd12.prod.outlook.com (2603:10b6:303:23b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Wed, 11 Oct
 2023 23:01:32 +0000
Received: from CY4PEPF0000EDD4.namprd03.prod.outlook.com
 (2603:10b6:930:67:cafe::ed) by CY5PR15CA0147.outlook.office365.com
 (2603:10b6:930:67::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.27 via Frontend
 Transport; Wed, 11 Oct 2023 23:01:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EDD4.mail.protection.outlook.com (10.167.241.208) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Wed, 11 Oct 2023 23:01:31 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 11 Oct
 2023 18:01:30 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <jgg@ziepe.ca>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <alex.williamson@redhat.com>, <dan.carpenter@linaro.org>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <brett.creeley@amd.com>, <shannon.nelson@amd.com>
Subject: [PATCH v2 vfio 2/3] pds/vfio: Fix mutex lock->magic != lock warning
Date:   Wed, 11 Oct 2023 16:01:14 -0700
Message-ID: <20231011230115.35719-3-brett.creeley@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD4:EE_|MW6PR12MB8865:EE_
X-MS-Office365-Filtering-Correlation-Id: d59c567b-0b2c-4863-f610-08dbcaae0280
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +h0ozZcY2FQTxbMXUy0v3UwYVCyj8QrkXp/PEJyJBqfK7TkFXcz86AwwrPhEY4y4wZ2obS/9hry2HHX8eac7/8mi5bwD04yd94jIIXdke8yVvv9bHzrQAMbhh7yeDr1mSjRdgSwhEtIaUc2foZGhA5sEiQkkjkovqC6GeJdeuJ0PSUADzMZgvq4gvmmOh+qZxXEHCoAn4TZ3e0QQYIAXj6dz9LWHhHIWSGv/KrdLhKTOUBIGOKqK7GKooCAerIJxvGBsY1eW+L5EcmcIogoAvaOG5CY1iBcwC9/Cc0mFCsGmQg9zYa42JmUGdnULq/Jt59Oc1LtwwtUg2PYAWRArGAQumyqEwylVSIbH/NJbcjPwnfJopZepKKtCDEFtoGpdOrnjMYpVvvE7Skwr6kKGfhg6j6QAeVQdX18SHd4xMX7zQDRWoyo6U/qNybzP+Dpq4TnETFD1gmh8f2TougKutaAj7sTLjKnXtTIj96XirbGh3WwJECW/rNay6f8cN+GEK2UdvAtDLw9JI/bBNxq5JqYYGVFp8yZOcr5TProBRo+my0CRSdfxCW1WQ7C3Vf9KIR9htK332dt5tEO/ZtKdf2ZrRTV5hfrmPI2JBGb9Hy/EtEbynOJg0vRaWpG+xECunv8e+sMFSneHrWS5Y+CbVXn5Q+u18BcOkFETbZ7xHgosHofeAPrPEkST+mJZfJVY61GJXSOPR8byAZh99WxaXlAgtK0KhUoiSlAhrjEHr4F92RELfHWoLD9m/lcXLNJysIU50Vg+1T7qXozr2dp1RA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(376002)(136003)(39860400002)(230922051799003)(82310400011)(451199024)(1800799009)(64100799003)(186009)(36840700001)(40470700004)(46966006)(4326008)(8936002)(2906002)(8676002)(40460700003)(356005)(26005)(336012)(426003)(2616005)(1076003)(5660300002)(81166007)(478600001)(16526019)(44832011)(40480700001)(82740400003)(70586007)(110136005)(36756003)(70206006)(54906003)(316002)(86362001)(47076005)(6666004)(36860700001)(41300700001)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2023 23:01:31.7089
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d59c567b-0b2c-4863-f610-08dbcaae0280
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000EDD4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8865
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following BUG was found when running on a kernel with
CONFIG_DEBUG_MUTEXES=y set:

DEBUG_LOCKS_WARN_ON(lock->magic != lock)
RIP: 0010:mutex_trylock+0x10d/0x120
Call Trace:
 <TASK>
 ? __warn+0x85/0x140
 ? mutex_trylock+0x10d/0x120
 ? report_bug+0xfc/0x1e0
 ? handle_bug+0x3f/0x70
 ? exc_invalid_op+0x17/0x70
 ? asm_exc_invalid_op+0x1a/0x20
 ? mutex_trylock+0x10d/0x120
 ? mutex_trylock+0x10d/0x120
 pds_vfio_reset+0x3a/0x60 [pds_vfio_pci]
 pci_reset_function+0x4b/0x70
 reset_store+0x5b/0xa0
 kernfs_fop_write_iter+0x137/0x1d0
 vfs_write+0x2de/0x410
 ksys_write+0x5d/0xd0
 do_syscall_64+0x3b/0x90
 entry_SYSCALL_64_after_hwframe+0x6e/0xd8

As shown, lock->magic != lock. This is because
mutex_init(&pds_vfio->state_mutex) is called in the VFIO open path. So,
if a reset is initiated before the VFIO device is opened the mutex will
have never been initialized. Fix this by calling
mutex_init(&pds_vfio->state_mutex) in the VFIO init path.

Also, don't destroy the mutex on close because the device may
be re-opened, which would cause mutex to be uninitialized. Fix this by
implementing a driver specific vfio_device_ops.release callback that
destroys the mutex before calling vfio_pci_core_release_dev().

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/pds/vfio_dev.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
index c351f588fa13..306b1c25f016 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -155,6 +155,7 @@ static int pds_vfio_init_device(struct vfio_device *vdev)
 
 	pds_vfio->vf_id = vf_id;
 
+	mutex_init(&pds_vfio->state_mutex);
 	spin_lock_init(&pds_vfio->reset_lock);
 
 	vdev->migration_flags = VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P;
@@ -170,6 +171,16 @@ static int pds_vfio_init_device(struct vfio_device *vdev)
 	return 0;
 }
 
+static void pds_vfio_release_device(struct vfio_device *vdev)
+{
+	struct pds_vfio_pci_device *pds_vfio =
+		container_of(vdev, struct pds_vfio_pci_device,
+			     vfio_coredev.vdev);
+
+	mutex_destroy(&pds_vfio->state_mutex);
+	vfio_pci_core_release_dev(vdev);
+}
+
 static int pds_vfio_open_device(struct vfio_device *vdev)
 {
 	struct pds_vfio_pci_device *pds_vfio =
@@ -181,7 +192,6 @@ static int pds_vfio_open_device(struct vfio_device *vdev)
 	if (err)
 		return err;
 
-	mutex_init(&pds_vfio->state_mutex);
 	pds_vfio->state = VFIO_DEVICE_STATE_RUNNING;
 	pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_RUNNING;
 
@@ -201,14 +211,13 @@ static void pds_vfio_close_device(struct vfio_device *vdev)
 	pds_vfio_put_save_file(pds_vfio);
 	pds_vfio_dirty_disable(pds_vfio, true);
 	mutex_unlock(&pds_vfio->state_mutex);
-	mutex_destroy(&pds_vfio->state_mutex);
 	vfio_pci_core_close_device(vdev);
 }
 
 static const struct vfio_device_ops pds_vfio_ops = {
 	.name = "pds-vfio",
 	.init = pds_vfio_init_device,
-	.release = vfio_pci_core_release_dev,
+	.release = pds_vfio_release_device,
 	.open_device = pds_vfio_open_device,
 	.close_device = pds_vfio_close_device,
 	.ioctl = vfio_pci_core_ioctl,
-- 
2.17.1

