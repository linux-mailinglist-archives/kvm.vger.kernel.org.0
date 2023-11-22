Return-Path: <kvm+bounces-2331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C1F27F50D2
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 20:37:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD5681C209F2
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 19:37:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC4665C902;
	Wed, 22 Nov 2023 19:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1wy3sRJR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2065.outbound.protection.outlook.com [40.107.212.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44571D72;
	Wed, 22 Nov 2023 11:37:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MeM37m/z5zgFGfGDmAqpyokYZENfJcHCVbwRN/D+fWwD57qFVNHY9lkyTIEAFIfRHUwweJkBDHsN1lO69ieBjpwge0mvASz5OgKG7RTvj8j7o1oDh0NJhjXgs39oMfGYeI2GG0JNLAwMe/Ue5oMiL2NE0WzB+F6BxKw8TaVNSC8JqbdwSuWv6Dvz5vKJRzXRzmBRa8vnVljijxY1vsFXCFiGbUqQgTwPy7997VbfcnPqHxZ3e30OK5HBnTLYDW8lxrpPTXFcDX5KeqFAEY/apG7VHMo4WD1q45Xznnsm5fhhkIpv4aKG8eKSI8+BOSfTNTkbERyvciRzgSgBt/0gpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=INO2GNW01En2yUeBMP6tNMjlCNPfa/LvvS0Zyo3Sg8k=;
 b=OPyl97fZY0Mh03Z2nYis7R+Eq+fg3nihznq6BAYzW58ctkNp32S85h9HxHmLRDFsRkYV/3I9baLieb81tBc3LRQPH9IVAPVz3aG6lhtiEbYE1eHN642GUATylPLtCMo0gxSVMT+GkdKAmT8lqcMrAPSnIyU28RATONgmD+CD2wPdGeGym4ipqOb+9m6794kvy1pbrxJMSSAKmPxKLzL6FjFAGhVQCkVMVMXHoD24TpMi+ThLkWZAPayrioOSr4LLFKcRYLWV2dGdsRUfOaogrK4Byewr+yLtdC7anLz4oG0KCSRnrZ8WJjrtEKlTLYW0bQOgctpCp1n2aE926kHARQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=INO2GNW01En2yUeBMP6tNMjlCNPfa/LvvS0Zyo3Sg8k=;
 b=1wy3sRJRRSxOjKy8U8+ZHgLoX9+VpdKxnTnv2KQg6vIwVo6aJXEcjl02R7Kzx/1DHH0plmQosxtSLHKKj1TmAz2v0/W03ztbcmGR8m0x2N8c3hjBV6kXilcUkEHdSbQa8Ef2be9n4SKRUGqt+IoPLRytb/R25/3dgEzxplTaTC8=
Received: from BY5PR16CA0017.namprd16.prod.outlook.com (2603:10b6:a03:1a0::30)
 by PH0PR12MB5646.namprd12.prod.outlook.com (2603:10b6:510:143::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.18; Wed, 22 Nov
 2023 19:37:03 +0000
Received: from MWH0EPF000989EC.namprd02.prod.outlook.com
 (2603:10b6:a03:1a0:cafe::44) by BY5PR16CA0017.outlook.office365.com
 (2603:10b6:a03:1a0::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.18 via Frontend
 Transport; Wed, 22 Nov 2023 19:37:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000989EC.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7025.12 via Frontend Transport; Wed, 22 Nov 2023 19:37:02 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Wed, 22 Nov
 2023 13:36:59 -0600
From: Brett Creeley <brett.creeley@amd.com>
To: <jgg@ziepe.ca>, <yishaih@nvidia.com>, <liulongfang@huawei.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <shannon.nelson@amd.com>, <brett.creeley@amd.com>
Subject: [PATCH vfio 2/2] hisi_acc_vfio_pci: Destroy the [state|reset]_mutex on release
Date: Wed, 22 Nov 2023 11:36:34 -0800
Message-ID: <20231122193634.27250-3-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231122193634.27250-1-brett.creeley@amd.com>
References: <20231122193634.27250-1-brett.creeley@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000989EC:EE_|PH0PR12MB5646:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a09736e-e3fb-42d3-7e8b-08dbeb926722
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	WOAzRlxF74Fqub/mXTHax65w51/FlF4927Ssj8f0Sg86ZLiGgIZ6Yql4OpkABYEq8B8jzt45uWwMlWOjW4cpn80Z28tD3Srpm2lpUfg1NGGYKZsnMEsYjN2eFhj3oTe2swSkq5Ulz07/XhrWep038fBEEQsMpRx4PHytkeQdT/3/DFbxO/g7W+GAYhMhq1QZQ0UedmyS0tXOd6qyzKgyzlkpZOBtQicHoUAx5VUm0DjildPeRPAWbHLkmoikZR7p7WP4d0hAaYVwY/l3BIQrgFouvVCJCE/z7T30rFX5YExg6APQKrEOPtrPgwH+68w9bnp3AB+XkDGePnL9mxh9Zjh37aJw71WvfysdFH0JvH+yd6xn89+X7bPAtNhzdqd0LJ0+VZamWTSSv3c3RzfR76+gDMklWyREwwTS+sR7jb1I81mtnlo2BTUgNsS6Fh7KRXupLLJ9hJwbZaE/R9p2+eIX/IJqjvvJlm239dFHJgKhpdkAtgTy5mMlopLpjC7A7sXuUrrjJ7YEiiPhBJoVcwx44BycBprca1lmMhyKdHbsRafU0bSDmwNDm8bMnbmrxPTursWO0SDxmpdK2t+NYrDJh8sP3TQbCGpJ9WFt99UtwuAc4mOjveYvEEUmhCuDilw4xK/Pg2ybeBXvNOJkyuXts8d5S9Kkh2o1zb8pQfsLm2gxyTTf31HKIeVABH5mnJcwtvkYMPqqFYCnglzntZ54izTrs9zXSHM2Zy7ThPS+nlKGTGgCtCFgz2TizTTBdDdr1I2Uro3pmqw73tHsPQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(346002)(376002)(39860400002)(230922051799003)(1800799012)(82310400011)(64100799003)(451199024)(186009)(46966006)(40470700004)(36840700001)(40480700001)(40460700003)(82740400003)(26005)(426003)(336012)(6666004)(478600001)(16526019)(1076003)(2616005)(36860700001)(316002)(83380400001)(54906003)(70586007)(70206006)(110136005)(8676002)(8936002)(44832011)(4326008)(2906002)(5660300002)(86362001)(36756003)(41300700001)(47076005)(356005)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2023 19:37:02.9561
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a09736e-e3fb-42d3-7e8b-08dbeb926722
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989EC.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5646

The [state|reset]_mutex are initialized in vfio init, but
never destroyed. This isn't required as mutex_destroy()
doesn't do anything unless lock debugging is enabled.
However, for completeness, fix it by implementing a
driver specific release function.

No fixes tag is added as it doesn't seem worthwhile
for such a trivial and debug only change.

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 2c049b8de4b4..dc1e376e1b8a 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1358,10 +1358,20 @@ static int hisi_acc_vfio_pci_migrn_init_dev(struct vfio_device *core_vdev)
 	return vfio_pci_core_init_dev(core_vdev);
 }
 
+static void hisi_acc_vfio_pci_migrn_release_dev(struct vfio_device *core_vdev)
+{
+	struct hisi_acc_vf_core_device *hisi_acc_vdev = container_of(core_vdev,
+			struct hisi_acc_vf_core_device, core_device.vdev);
+
+	mutex_destroy(&hisi_acc_vdev->reset_mutex);
+	mutex_destroy(&hisi_acc_vdev->state_mutex);
+	vfio_pci_core_release_dev(core_vdev);
+}
+
 static const struct vfio_device_ops hisi_acc_vfio_pci_migrn_ops = {
 	.name = "hisi-acc-vfio-pci-migration",
 	.init = hisi_acc_vfio_pci_migrn_init_dev,
-	.release = vfio_pci_core_release_dev,
+	.release = hisi_acc_vfio_pci_migrn_release_dev,
 	.open_device = hisi_acc_vfio_pci_open_device,
 	.close_device = hisi_acc_vfio_pci_close_device,
 	.ioctl = hisi_acc_vfio_pci_ioctl,
-- 
2.17.1


