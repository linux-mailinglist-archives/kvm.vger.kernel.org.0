Return-Path: <kvm+bounces-2324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB7087F5089
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 20:26:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC2D71C20B39
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 19:26:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BF965E0CD;
	Wed, 22 Nov 2023 19:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ha1ugSPw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBBB01A4;
	Wed, 22 Nov 2023 11:26:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C+Ir5W4fQbCFqxgtVKbIMu8nseYHIUgb1qXmcz+acZKbKcigrPAGJiXBxhrcIMtT9qKVb9UAY1EqbwrhOVTtducnKLo2XWXfhHjKm+8d2iU7kDIoSlMs6qTY/vmNQBv3S88lsSIOa7TO2Gde5Iv9C6UwvN3ZFnes46ti7lBz3NQr340u74C7ZJDyK8P1id6wdJAhCRF3lKAHRcyJIP4w13NctCyOcb5EfdH0sLFvzy/0lFdcc0TMSo+365nwl0VQlwnVH9HmuLLVa/EEEbHC0v9+FVd5UfW2C5jc9wQOm/VVwYDahQ2MfpP1Gy/8/Wlzbq4vUT0unUzi5zOxifuSVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P+/5zfckPy9IkNwM59iDyCWLt9CoqKhZnbooleexsCs=;
 b=mLXHK85hIJzxdRmwqlB2fjgA7JMz4bkjRYipj6b46IceyeYQRWZtgjo8a2DscbGxfnJAJkBRKkgXYGv6Dh3h1g19S9DreYh52ka0yhzB6RkH9Dw3amnxIZJdwtnxhadobFrNoR5CM2Zx/7eYgT302wk7kPR63Hk79AkSuk011A8OKfNrF9M8q9V+gN0QWa/BwG586dS2in9wELKGdBHX0TFp1IQy3VjP7MbUPu+iMk/+8laWylAT4YZsgajUgurXVQaYGLP9n6tAApZDVufZ1dh5Mt/u3NzmNjQ0+4h+v+8Rykv/AYjS0LWTn6ZgaAeBT/elaq+ZHkpOmtI4tk7Img==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P+/5zfckPy9IkNwM59iDyCWLt9CoqKhZnbooleexsCs=;
 b=ha1ugSPw63v8+99/QuOv72tMbIN9ut8JAn9oCAQMJDzy0vXLPbYJWZzUBSWwTqz/MjqayIFbB6GOfPi+gKvmVwpFQ7en1A9jv+ut9Z9hlT/PcuAnhKqBl3LugtBQVSjj3kTk1w4vG9uufPjzV8b41RHTOFbHLDAEv7Cp7XB4/+c=
Received: from MW4PR04CA0228.namprd04.prod.outlook.com (2603:10b6:303:87::23)
 by CH3PR12MB7715.namprd12.prod.outlook.com (2603:10b6:610:151::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.28; Wed, 22 Nov
 2023 19:26:22 +0000
Received: from CO1PEPF000044F9.namprd21.prod.outlook.com
 (2603:10b6:303:87:cafe::bd) by MW4PR04CA0228.outlook.office365.com
 (2603:10b6:303:87::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.28 via Frontend
 Transport; Wed, 22 Nov 2023 19:26:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F9.mail.protection.outlook.com (10.167.241.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7046.3 via Frontend Transport; Wed, 22 Nov 2023 19:26:21 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Wed, 22 Nov
 2023 13:26:18 -0600
From: Brett Creeley <brett.creeley@amd.com>
To: <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <shannon.nelson@amd.com>, <brett.creeley@amd.com>
Subject: [PATCH v4 vfio 0/2] vfio/pds: Fixes for locking bugs
Date: Wed, 22 Nov 2023 11:25:30 -0800
Message-ID: <20231122192532.25791-1-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F9:EE_|CH3PR12MB7715:EE_
X-MS-Office365-Filtering-Correlation-Id: 87383686-a3e0-481a-765f-08dbeb90e907
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	owbjKJaZtkhI+NS0kMBu7JhCjTjw9uB0ny4H1gWwECwC0S4jzn41QffdqXh1WPO/IYzM2cmLmnFQ+L8CvkTkAYU5aFklsRzNAme1hswcBKnqGub4WwyY/H/tK5eypkxnoxSUvbgYqOMCjsDmtxC30SEgm2CpNQqnE+jcU6PPSO98kszv0cHglyGz+8IJfL9ezpSFuBW/gmEpcI7K26krhXVp0/CL+Zswj56mLhrpv5aIdJXzRe/VcbQUHtk3Riaq6BgXGv3273MOpYPSqmBV3iAH4ISOqkqQKQLzS46p3ioXpKrdSlQny+0lXyN07/nNK9k2rAUegfOR+yE7kPrtXch8LFzL4/zlrUNh8w8VCwn0CvBAytHTqa6UIi16LSrbAvtuZbz0uOtpOet4QVGq/pVIGH1SdZArnXS1N63gCeHZ0sO+wp9Q9j4wx9i2gy0CASuLBoRweMqHZovc18M73lQMOFFlaqk64og8oYGjVDulVmEjuVizMLl2bAFEnwj/CzHIT2Pybm4Mlp71sNP5Bctvs0XozRQH0SlsxKxVCUZnB5CW3nAVuLYLZNE2tgxrCMBEcDzgQfPRrqtz+LjNPWa/rCS8U4a9NsV0nnHK8ijqoYoJZ/SVcCQ1XRaRDH2ow/Ol5U7WgbV4nC/c38ue6V/lrtljLZRRbAltv3TaCqNjkJr8Zcf/aj9kfCgK5Dhd16L5jsvMob9LP/XhN5+vGuWUc4wg60mokROgAZeeqyiYKY4cSohjgyGu4LQvl3xwX8R1j8APikThOMJGKgHZUIb7oG+VjXI+6nmZu3unhWuPRN40UXYIfJay0TuIJwPh
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(136003)(346002)(39860400002)(376002)(230173577357003)(230922051799003)(230273577357003)(1800799012)(64100799003)(186009)(82310400011)(451199024)(40470700004)(46966006)(36840700001)(44832011)(966005)(5660300002)(40480700001)(4326008)(41300700001)(8936002)(8676002)(2906002)(70586007)(54906003)(70206006)(316002)(110136005)(40460700003)(47076005)(86362001)(81166007)(16526019)(478600001)(1076003)(26005)(36860700001)(2616005)(426003)(336012)(6666004)(36756003)(83380400001)(356005)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2023 19:26:21.8893
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 87383686-a3e0-481a-765f-08dbeb90e907
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F9.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7715

This series contains fixes for locking bugs in the recently introduced
pds-vfio-pci driver. There was an initial bug reported by Dan Carpenter
at:

https://lore.kernel.org/kvm/1f9bc27b-3de9-4891-9687-ba2820c1b390@moroto.mountain/

However, more locking bugs were found when looking into the previously
mentioned issue. So, all fixes are included in this series.

v4:
- Drop patch 1/3 since it added a spinlock_init that was later replaced
  by a mutex_init anyway

v3:
https://lore.kernel.org/kvm/20231027223651.36047-1-brett.creeley@amd.com/
- Change reset lock from spinlock to mutex

v2:
https://lore.kernel.org/kvm/20231011230115.35719-1-brett.creeley@amd.com/
- Trim the OOPs in the patch commit messages
- Rework patch 3/3 to only unlock the spinlock once
- Destroy the state_mutex in the driver specific vfio_device_ops.release
  callback

v1:
https://lore.kernel.org/kvm/20230914191540.54946-1-brett.creeley@amd.com/

Brett Creeley (2):
  vfio/pds: Fix mutex lock->magic != lock warning
  vfio/pds: Fix possible sleep while in atomic context

 drivers/vfio/pci/pds/pci_drv.c  |  4 ++--
 drivers/vfio/pci/pds/vfio_dev.c | 30 +++++++++++++++++++++---------
 drivers/vfio/pci/pds/vfio_dev.h |  2 +-
 3 files changed, 24 insertions(+), 12 deletions(-)

-- 
2.17.1


