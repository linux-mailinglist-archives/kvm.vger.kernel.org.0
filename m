Return-Path: <kvm+bounces-2327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 604167F5099
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 20:33:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 815871C20A47
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 19:33:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4945F5CD08;
	Wed, 22 Nov 2023 19:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NBcHUG4I"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2075.outbound.protection.outlook.com [40.107.244.75])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052741A4;
	Wed, 22 Nov 2023 11:32:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gZD6F19C1ldYpHCzsQEdQuP4sHJmpnH7eu2U70ByzftUnT4ubkPMswS/LOh8//uBdYHObyJR+fuJZBnjqBD2DuQCELXwL8v0z1TAG9YER4OwqyU9Wjf9lDcqABaniR3FOf2w2OofkW7GgIV2bgUHSyPTCVy2MJ+xf6ES1KF0M1R8RInp8isHVrPzsvqNJ2D01W4IZoaoSIehWmeQ3ISAuQjnc8NtN1J6N5rfrtBOypqjXbcTPozoYc2N1eHwlUQvNrf4LBJ2sOSIN5DBesfivjpcEM5ezZ9ttDjq8FU70SHel/i9L6RD7+RdT4+ZkgdAGYGVYxFKkjXh/ujsuoL5lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7DuhM4Gik8C4Gpzu/tFt4Op3SrlDCB6Fy52QG6z+0OM=;
 b=hKBJiSoxaT8Ebb62ONUStYjTHe0DU6b8Xg4hL1AcZ4rZxHGVK6NYSGtf7Avc4TBJ1i2e7/SKYYCuV5QNCO+x9R5aUjwgDwSgYJgVDyHrmpF+0XYaODjAkgmKWKHR6Clt5MvGP9HOcGzWTYmWvi7tvk/J99nhHLdZS+mgT0SDnfnhR7hWC6m6Gnbiob7P7sU4teNcWEmauaBiomOyp9md/5Enj8PuKg9TtcZpaaSFmHgt4S0n0A9FS81E5RlWaJNoV7gXfjVaLj7ERJKrtbt6rl2lpwquz6J5gdh5gTXDbr0fl0aRRF4pRtKL4qxC5yYakCrLBxHcdNCJ7e/xPTXk0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7DuhM4Gik8C4Gpzu/tFt4Op3SrlDCB6Fy52QG6z+0OM=;
 b=NBcHUG4I8Psn3S9yTwDG4mCQGeWH6M0UjepvCxLvBeqORQxjyr8XwvPOyYNOdnOdyLvoNVkP3BkBhw4qCOchwY3OaKDXy595MDmsgMchKypyhlHf0KajRIk3kAotW65f4DIm+JqJIe8vGbe8q+gd+ySijW925HmerxxMqTcnTng=
Received: from BN9PR03CA0850.namprd03.prod.outlook.com (2603:10b6:408:13d::15)
 by DM4PR12MB8476.namprd12.prod.outlook.com (2603:10b6:8:17e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.18; Wed, 22 Nov
 2023 19:32:45 +0000
Received: from SN1PEPF0002636D.namprd02.prod.outlook.com
 (2603:10b6:408:13d:cafe::88) by BN9PR03CA0850.outlook.office365.com
 (2603:10b6:408:13d::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.18 via Frontend
 Transport; Wed, 22 Nov 2023 19:32:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002636D.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7025.12 via Frontend Transport; Wed, 22 Nov 2023 19:32:45 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Wed, 22 Nov
 2023 13:32:39 -0600
From: Brett Creeley <brett.creeley@amd.com>
To: <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <shannon.nelson@amd.com>, <brett.creeley@amd.com>
Subject: [PATCH vfio 2/2] vfio/mlx5: Destroy the state_mutex on release
Date: Wed, 22 Nov 2023 11:32:03 -0800
Message-ID: <20231122193203.26127-3-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231122193203.26127-1-brett.creeley@amd.com>
References: <20231122193203.26127-1-brett.creeley@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636D:EE_|DM4PR12MB8476:EE_
X-MS-Office365-Filtering-Correlation-Id: ae19381b-b9a3-4e40-7f9d-08dbeb91cd79
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	HT+QIutJrjXPoZBAE0cpsc3hSc5iVtNDNXtMobQOajj1FefPKWMvl6bL8a3Bg6DixVCxK5he9paSbvDLBmVmarN35W7qr6PVHtl02DjViIZXa6yar52EJFp+TESZAjt0j5WsDprCgEu5O1bW5DQHHZknnHCdNh8RQVF3wG/NmFd5FWzE8sRETCGKWgWCvk7Nn3ecIan0McOTKhBlo6EZ8MQOXJ6sq6l9XTjovQmcfUkz2o8mHCq6CIgVro1+my5W3UOrdnRUwLteVffiMo28pgVfJcms1pjIStp+aQTnYaCdngIH128e1P45mdjTvYd2b0pUjOF/jjEfysoaAWdqD0XKJPpyG4pV1rQx0xbjP6T9U5xB+7orAk4YbKtWbXB1FPRHHMVc9SjhkpfX9BPpJL9wmrU4ux8UV38+qIffgGjJyWD2bdYnL4348YQw2s5hsJTojNIT1zzz2l6ybLxUS0IIQbyGthf+MY9aXCZCay23ur6vbwl7jiSqHOrPdkVnrBU5jjONniwQcaBLK4wUNc24kyIqrNpv/XsI93EszDbEKOk83mw5h2xRULLZITlwL0o7NYawQ1IbvoFneyt+BEeznUaFWr892qwhxPwSsA+NresnKUZwy+hylT7u9Bl19GOMyiBh8/9EivsBw31cmSLMqBwio5R4XaYIR3coUo0bwdmuaIRcJbfNQ9ttuU4f6avwxlJMav2/TA/V9v08/JRxoUi17DJgqA6S7PBlExRGwVlQ7+9nzQxLOiHozcnW7JsRWqpLfN0s6S+0R0oL1Q==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(376002)(39860400002)(136003)(396003)(230922051799003)(451199024)(1800799012)(82310400011)(64100799003)(186009)(36840700001)(46966006)(40470700004)(40480700001)(82740400003)(83380400001)(336012)(426003)(1076003)(2616005)(16526019)(26005)(8936002)(8676002)(4326008)(44832011)(36860700001)(47076005)(356005)(81166007)(40460700003)(6666004)(478600001)(316002)(110136005)(54906003)(70586007)(70206006)(41300700001)(36756003)(2906002)(4744005)(86362001)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2023 19:32:45.2509
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae19381b-b9a3-4e40-7f9d-08dbeb91cd79
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8476

The state_mutex is initialized in vfio init, but
never destroyed. This isn't required as mutex_destroy()
doesn't do anything unless lock debugging is enabled.
However, for completeness, fix it.

No fixes tag is added as it doesn't seem worthwhile
for such a trivial and debug only change.

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
---
 drivers/vfio/pci/mlx5/cmd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 5cf68ab2bbd7..4ae5295757b4 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -203,6 +203,7 @@ void mlx5vf_cmd_remove_migratable(struct mlx5vf_pci_core_device *mvdev)
 						&mvdev->nb);
 	destroy_workqueue(mvdev->cb_wq);
 	mutex_destroy(&mvdev->reset_mutex);
+	mutex_destroy(&mvdev->state_mutex);
 }
 
 void mlx5vf_cmd_set_migratable(struct mlx5vf_pci_core_device *mvdev,
-- 
2.17.1


