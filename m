Return-Path: <kvm+bounces-4-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EFE917DA39A
	for <lists+kvm@lfdr.de>; Sat, 28 Oct 2023 00:37:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 56243B216FF
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 22:37:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A42D4120B;
	Fri, 27 Oct 2023 22:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Tpsoeg3m"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA278405D9
	for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 22:37:21 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2045.outbound.protection.outlook.com [40.107.93.45])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C9D11B5;
	Fri, 27 Oct 2023 15:37:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BAtC45ITxTF7EqSpUhsenO6ikFMntxXMGbAbRXxpPHD7Z7KY5XPsKARD73YcWJlfOU7L5GhqQwjUxM/9UJr+PR1kCQuZOSliURDE2JrNPKzebfoXyDUWhSvCSukEYfepLc9HoBA5pNa5pJ78jZHGTg3pl/7Mrjm8j2qgPatPijAq40Z7gg7EHfWVkyZLaPjlxjdplz+SChMrq7Igg/TtZPV6M/7auGXCADbTsmWZ7O5jvOW/bf7D7Fotn5TSYyjnkn4nNhsr9QQkj5Yn30puYTVm9JD9IBNghgEgfjqre2ePGynoy7RrqiYZKLBoAKVA6Hwb5ugwxP2pWAGFpZrtmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/lV4lyDxKEyVexv4om1bfCyS3zqujBEjXmB9A1ox1lQ=;
 b=lJU4O0Xppcz3eKQz457nOsQJb0T6lxBbwdaxs0wRGdcAg/eCuPXVcuVvqc94qKfKMnFOnxeu8bLF3BD9hqDG8inkofzBi3Ufl4tZO1cnu3WJm5JO8/QrYn5lZ6aNoJjUgZVgfTaf3WzeXT5n4hIkgVPoQMX1kksnuQnpHGmRWIeZIpcbzjdpftmSj094CgrWbWL03okhfnJEE1B+QXM1VogVimmeOVgoQc7jVFXcPsU9OErkLanI6jkBmvN5jsqo6tXQ12JeEIOxA9iyNinxA4hSwe9PxYWgMyLxjpda6S8TtltWvje4y5gicZKCyQs4llXAOYNIWWmo+Lg/RpC3VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/lV4lyDxKEyVexv4om1bfCyS3zqujBEjXmB9A1ox1lQ=;
 b=Tpsoeg3mQwdRiq2WfCIsWLLQZvUFWajKtcWdoG1/OsFK50NIpmdL/DbKaDTWAWI3+w6N8Ylv2tPuUWYDTc6kwvYZ1hvVQSETDYu7JEQs2p9R2urRm3NvIcPE3uUACSyivDdlIl2Hjs47k1AqgM4NyswE4UveDcjxvkw5JDB+w7w=
Received: from BLAPR03CA0178.namprd03.prod.outlook.com (2603:10b6:208:32f::32)
 by SJ2PR12MB8112.namprd12.prod.outlook.com (2603:10b6:a03:4f8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Fri, 27 Oct
 2023 22:37:14 +0000
Received: from BL6PEPF0001AB4E.namprd04.prod.outlook.com
 (2603:10b6:208:32f:cafe::72) by BLAPR03CA0178.outlook.office365.com
 (2603:10b6:208:32f::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.24 via Frontend
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
 2023 17:37:09 -0500
From: Brett Creeley <brett.creeley@amd.com>
To: <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<alex.williamson@redhat.com>, <dan.carpenter@linaro.org>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<brett.creeley@amd.com>, <shannon.nelson@amd.com>
Subject: [PATCH v3 vfio 2/3] pds/vfio: Fix mutex lock->magic != lock warning
Date: Fri, 27 Oct 2023 15:36:50 -0700
Message-ID: <20231027223651.36047-3-brett.creeley@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4E:EE_|SJ2PR12MB8112:EE_
X-MS-Office365-Filtering-Correlation-Id: 39fc8e2c-2b7b-4663-57f2-08dbd73d4459
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	sW5sKWSikGHczdFrkCAAudL0XqJ3p/yT2YAhKf2KcTES+7FTw0zxDjmpgCD8S7rRPtk6dC41BIpFKERNrpFpS7tux438szso2qJ4Cvxf7O5t8htyrLcTAc6iXvVRbOmZGFXRL3T131yM76tdpxnjcmJA4ecEgunZ/N8yeZ06zdD45qeeqbDblmJGeVfkqK9L33DpInF712hDuX4kO9FvRu3Vm8WSC4I6Mg8NT09k8tuycNEaaHdDBdI/rETFGIZBkCsLazgJWSl5i3wUuF4LXJGSoYXFER9MfJmVfq+tqh35RcSFun6rNVa80u05+vq05ad+8/98i5FZuJ9cOpvyi1CC58Zbg7BEhC6Tu7OnFHBzQ0CG+Ce+nDQmF8vL/XT6hV68rcJnJUvgSgEeWpsPv67O7f0xHT38JzPWUPzzzoadWzWKPDQ4+CxDSLMDJGE0ZwRaU3pCzcc48x3KOfENmS4dFQA7bUdO9qIUirMH2qxpuNRHngaY4w8DzMHQqZQeOruMBWCZw5GFYusynR46hrU4MiYKK36GBvRG9jCgbAZdOMF0qrYLMMozNgvBmik9k9w6Un0P9ZyyyuEYBfE9aXIvq1hfpILpkZTgsz/qJptxGFuZJxZk2x/OXbzdP5qd7/7vKCijDZD7iBiM0u6g3atqA6al57NCV6VDsAwDCuAaduKLraZkYXQiPpqLDmQdoxi+bUnQ7xZWuy8YXw8AtMAVl/Ngkgfr+GP0jO07kOigxAsNQKFwkcPGQ0haM9xgl2uYYzJQE6/83ZNH6vgUJA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(39860400002)(136003)(346002)(230922051799003)(186009)(64100799003)(1800799009)(82310400011)(451199024)(36840700001)(40470700004)(46966006)(41300700001)(86362001)(44832011)(2906002)(54906003)(110136005)(70586007)(81166007)(316002)(6666004)(356005)(1076003)(478600001)(70206006)(426003)(47076005)(82740400003)(83380400001)(40480700001)(336012)(36756003)(40460700003)(5660300002)(36860700001)(2616005)(4326008)(8676002)(8936002)(16526019)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2023 22:37:14.2271
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39fc8e2c-2b7b-4663-57f2-08dbd73d4459
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8112

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


