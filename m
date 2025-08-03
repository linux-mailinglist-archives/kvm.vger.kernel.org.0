Return-Path: <kvm+bounces-53879-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 692A1B1918D
	for <lists+kvm@lfdr.de>; Sun,  3 Aug 2025 04:49:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 839C3174542
	for <lists+kvm@lfdr.de>; Sun,  3 Aug 2025 02:49:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1917191F92;
	Sun,  3 Aug 2025 02:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RGvl2xG1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062.outbound.protection.outlook.com [40.107.92.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A29717A2EB
	for <kvm@vger.kernel.org>; Sun,  3 Aug 2025 02:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754189328; cv=fail; b=gS/aA76WPo2C0qmApodXYqYwT2BLxUxT9+AtEzJ0e31NVh/03S68fvvnAmca85vqE06vxJ8SjbeV2cWdYwMbkIFCWYaprgWTnIb/nJeQm2edItdBRLKu0BG/RsXI4My6y/YHfifBsOnlvU5gdUyoWXdlNPiJFcd3fuVSWr6IBn8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754189328; c=relaxed/simple;
	bh=KYQW74MFWzsbEfZJucEPmXqm9cwVwhyd1jmcMCOCw1A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QlBZ1XwbK4MC0XWsscyw7b+N9AwKVVCgZ+vCpM02/qjIgBlf6/z/dP1KuOEbD12PyK/1NPhcjvEagJYtHz+dC132guyIb0lB6sSIminxErRFYimnDfiz/VXHuUX1QuV9+ZAkz9K5KKqaVubtkmjbujhaP0zA6PxCtpH1+1YLz1s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RGvl2xG1; arc=fail smtp.client-ip=40.107.92.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WNkY0CtbUhKTFLtK2Y4HDBCNbJX/JMEoxorRuY0t3NvsA0sd/bv6x3shWzIfwIfEQ1H+gdr4eiKTxduBK+QR8oEYO6U+goeoXfYz/6x9FLFAmtlFyDHByGLFURuwN8JLIHi1NG2Jly1KcAya4+TD9o1gw+kjUobtW5XNcDs1kvEOiC46oMFxdaFGFKuJ5YhrX/kGPIf50Z/CHXZkOD84s85iGkGfpvNhx25FEdIYLv6C/XsVXJ9yah7FBqcFpGvomipnHd0RngCMXjLGXeyagxn9igvrK8OcrzoTLnlgYXC2o1AbHNreUfUhVDlwdUzU+4A6M5K2E5godMWxfRG+5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RGgbZBLUvxRffjmcP2m4nKopQI7bawORaPHwbPpjOf8=;
 b=qDV4P+FZy8g0DLhMht/IsHmLFnLODgmvNnMtRecBTFsvgD2HlOHxR3ilmZunYH6BmuGrY6Ahbb4iO1sN7W57NP2A0ALadLWeS6BEXA++foIL8TOW325uUVnlx/XMGfJQ8Xxh0T8ovWltIsLZjR7LwGpeL+Jfhr5NTVaeXXJ56VI9HP0lx+SxNLKt+UgYj4MUSETQ66ypjgwsaRtcn1k3k+QcXU7qfZOgZbYQT34Y0vg4ds9de1qbkG5OwVydnSRPGZkN1MxFslBbQmdI7oMGAN7F+d9tEEx8YgygUxkCh3qLwQYNwCrtEhrVpra5M7cN6fAetZbjsgwBI9ENtvxO9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RGgbZBLUvxRffjmcP2m4nKopQI7bawORaPHwbPpjOf8=;
 b=RGvl2xG1UocberebHzLpBkdg4AyYjehOag9m8Tjivuh+nPfDbTyMme34RZlAtEObWc3xokUuXu4VvvVo/Dbfih446u+lBmbup3IG9tldFXhjd/QhFgZvaOnBP51poXuMW6AmyvXEcEizJjnM1TH/UtTzzoDWgM8qauWiSR41gjmPluRbbydod+Mlw9oyIaaaiBKjZ6B59rD6u7DEroigwTuQzWJdMiFRHnamqewulmmczR7DV3L2gYYXK6CIfTb16GanI0ZEd6CBx5wlMIV2dsIqdBlrNgHNRG5wx3JSuWQVgI8TheurDyjGA1R0VXeU8bYz0k6wM6zWhO0wN3BiKA==
Received: from CH0PR07CA0030.namprd07.prod.outlook.com (2603:10b6:610:32::35)
 by LV2PR12MB5942.namprd12.prod.outlook.com (2603:10b6:408:171::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.16; Sun, 3 Aug
 2025 02:48:37 +0000
Received: from CH2PEPF00000141.namprd02.prod.outlook.com
 (2603:10b6:610:32:cafe::36) by CH0PR07CA0030.outlook.office365.com
 (2603:10b6:610:32::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.18 via Frontend Transport; Sun,
 3 Aug 2025 02:48:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF00000141.mail.protection.outlook.com (10.167.244.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.8 via Frontend Transport; Sun, 3 Aug 2025 02:48:36 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sat, 2 Aug
 2025 19:48:10 -0700
Received: from dev.nvidia.com (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sat, 2 Aug
 2025 19:47:58 -0700
From: Chaitanya Kulkarni <kch@nvidia.com>
To: <kbusch@kernel.org>, <axboe@fb.com>, <hch@lst.de>, <sagi@grimberg.me>,
	<alex.williamson@redhat.com>, <cohuck@redhat.com>, <jgg@ziepe.ca>,
	<yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
	<kevin.tian@intel.com>, <mjrosato@linux.ibm.com>, <mgurtovoy@nvidia.com>
CC: <linux-nvme@lists.infradead.org>, <kvm@vger.kernel.org>,
	<Konrad.wilk@oracle.com>, <martin.petersen@oracle.com>,
	<jmeneghi@redhat.com>, <arnd@arndb.de>, <schnelle@linux.ibm.com>,
	<bhelgaas@google.com>, <joao.m.martins@oracle.com>, Chaitanya Kulkarni
	<kch@nvidia.com>, Lei Rao <lei.rao@intel.com>
Subject: [RFC PATCH 4/4] vfio-nvme: implement TP4159 live migration cmds
Date: Sat, 2 Aug 2025 19:47:05 -0700
Message-ID: <20250803024705.10256-5-kch@nvidia.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20250803024705.10256-1-kch@nvidia.com>
References: <20250803024705.10256-1-kch@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000141:EE_|LV2PR12MB5942:EE_
X-MS-Office365-Filtering-Correlation-Id: 237ae277-3f94-454c-1339-08ddd2383eb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aGlQU3IzRU5kUUlFRHhZL1ZHZ0NJTlhRelV2T3dBcjd4allGSlozdFpTVFpI?=
 =?utf-8?B?TkVvdWdDVE0xanphN2JaQXhwY1JNOENRTmVGdm9Dc1NhVFJkMitoam1LRFZD?=
 =?utf-8?B?OXltOUVnZC9Sc3JMOGVTSGsxS1huSDhHSld4NUZtQUdFUDB2VXhORk1ESlF6?=
 =?utf-8?B?RUl1UVUzdkFDQnV6YUR0Z3k1VnVFbHE1OHJPMzlHaE1JUHI5cVJpcnhRZ1Nz?=
 =?utf-8?B?aGRLVGptOGFvQmphcUNQV2E2cWVhQVpRL3FjTkcrL2ZrTUp0SWpVSXlpZDZn?=
 =?utf-8?B?cnRmaWNJOWZJMTBsMmpvUm5tQXBzdGpQSzQ3YkRUbm9kQTJWTktaMWpWbmNZ?=
 =?utf-8?B?dnlaM1dpTDNDbkhFanVBb2xaV2RNZkx4K0MrOFJnbm5vanBIN00reU1NTitC?=
 =?utf-8?B?UUNRNnRqaCtVeGxKT2JZaVNKeUxXV3NuQ1RGTmVPczkwY2IwaFQ0WW5jLzNy?=
 =?utf-8?B?eFA0a1I2Y1dmajl3WDgyRitNYjhwYlo1WmdWaDhGRWhaclpKM1pkdWtTQVNo?=
 =?utf-8?B?NEJwaHRocEtjbzFpQ1JGbnNyRVNaYnVPTnBaeWkzTWl0WVUzOXBHbzJpY0ZY?=
 =?utf-8?B?YVZQMDA5dGlDeU15V29vdnJCNTk4MWZ0d0hCaXZ3UkZQYXdpS2srY3Q5RTlV?=
 =?utf-8?B?UVlWQmkzbnJWNTYvNkRjMzdROWppcDk3TFRPbG8xL2hWR2JsWjZpejlQaFRE?=
 =?utf-8?B?MnN4djh5YjRIMlZSSmoxVUVBci9FWGsxcUUxa1JlbVR5SVV3cG0zZVkxWVYx?=
 =?utf-8?B?ZnR3T1dJdTM1WGxWVHlyTUxDVFoxUFJraGQ4YTNydklmRVBPNms3cGI1V0dp?=
 =?utf-8?B?K1hsNjA4cm1GSTNsNlJmOUtSZ2lGWUtNUVZDeTI3Z2VVQmp3aDJDSGludnkz?=
 =?utf-8?B?TWZaa05JSlg2RFVrV1VPaS9HMzAyNndWVGQ0blV1QWhvVFJhYjlkVGZ5ZU85?=
 =?utf-8?B?a1lScnR1TTkxWmc1N0k1bE9IWStXNDBnSWIyQ0M2L08rekE1UnFDU0c5b3Rk?=
 =?utf-8?B?QUpkSnd3V1lKR2RkMEsyVmo0SUFHYWdWelFUbUV3UDRDZmtkQkF1Sk44R3Zs?=
 =?utf-8?B?UDJydG5yL0RZNDFNY2J4M3I0OWVsUkV2cW1IZ1hET2pHazNPYlhmT3owck1P?=
 =?utf-8?B?dU1kK0srTVpxR09UQk5ZRmd5T3dWck00UW1QZTVpZ3hsTlF2eVZqRHNmSndi?=
 =?utf-8?B?S3hVZUJ2a2xsYlhvY0dEMjJDK0p3ZldVc05ncGFRNG44R2dkNFI0a1Jpa0RQ?=
 =?utf-8?B?dUJwczhPOHdYUkJaanEzNThEUExXd0svVHR4VEwyYjdVNlpRUGVKNjNnbElU?=
 =?utf-8?B?dExHdFJXMndOcElpcnNIMEwyYktTTmJZaVAxNnVlMTVYMHNhdlJBd0lyUUVO?=
 =?utf-8?B?T3ltNUpsaTdyZktqSEROUlgwcDFiNm1kSE5NaXBIS0NOaVRqcmhteU1iTFRP?=
 =?utf-8?B?OGFoMFc2OWtlSnBUbGZNNWxyNU02Q1pTcCtBaFdmUWVwQXgrYlZBZVRTV3Fw?=
 =?utf-8?B?bEhWN2lOM01YZ29YRFJhK21wUWZTdHovVjNZRSsvL3JJNWQ2UWFVZFdwcytL?=
 =?utf-8?B?TUZCV285dkZNS1lUNG1vdzRLQTYycWE0QnRBM1dxdENsZzdoTzhQTjBRTG1v?=
 =?utf-8?B?Z3B3RHJEbWpsU0hWQjRxWU52WFYyVmhkbW9FZHVwRzhCZk9FdGdwRGRCV3ZY?=
 =?utf-8?B?NFFLeFI1MEFsR3JoRnc3VXFrZ1ZRZnhFaHpBNDQySVdCU1A2S3pnUHRmcEFh?=
 =?utf-8?B?SkJCTFllMlBXWHVkTCthekFHRnBqMnIvYzZvMC9Nb2tPUTZPVEh3OElDOVI4?=
 =?utf-8?B?NXZVZGZLSEtIOFhzamR2bmNjTGNhSjMvWXFNeWc2UlpWQzVWVitGT0RtbTlQ?=
 =?utf-8?B?UXJaa3h5L3UvM3hKV3FYQis4cGVpZEZpeDJwbDMzZWNrVG9EL2ZGb2l2SXB6?=
 =?utf-8?B?R1ltaUZVNTFVTkt3MjBaOWpKMXkwT0JEb3dZTGF1NjYyQ1cvLzVLRUxFeWlE?=
 =?utf-8?B?aEkxTXRiL0V4OVVNYS82Y0F3UmFKQmErdjJvY0tJQWU1SHFlYTB6SW4zRmNl?=
 =?utf-8?B?TTM2NTg2ZXN6OEU2Vjh4L09GT1JPa2NzaHVNZz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2025 02:48:36.6162
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 237ae277-3f94-454c-1339-08ddd2383eb9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000141.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5942

Implements TP4159-based live migration support in vfio-nvme
driver by integrating command execution, controller state handling,
and vfio migration state transitions.

Key features:

- Use nvme_submit_vf_cmd() and nvme_get_ctrl_id() helpers
  in the NVMe core PCI driver for submitting admin commands on VFs.

- Implements Migration Send (opcode 0x43) and Receive (opcode 0x42)
  command handling for suspend, resume, get/set controller state.

  _Remark_:-
  We are currently in the process of defining the state in TP4193, 
  so the current state management code will be replaced with TP4193.
  However, in this patch we include TP4159-compatible state management
  code for the sake of completeness.

- Adds parsing and serialization of controller state including:
  - NVMeCS v0 controller state format (SCS-FIG6, FIG7, FIG8)
  - Supported Controller State Formats (CNS=0x20 response)
  - Migration file abstraction with read/write fileops

- Adds debug decoders to log IOSQ/IOCQ state during migration save

- Allocates anon inodes to handle save and resume file interfaces
  exposed via VFIO migration file descriptors

- Adds vfio migration state machine transitions:
  - RUNNING → STOP: sends suspend command
  - STOP → STOP_COPY: extracts controller state (save)
  - STOP_COPY → STOP: disables file and frees buffer
  - STOP → RESUMING: allocates resume file buffer
  - RESUMING → STOP: loads controller state via set state
  - STOP → RUNNING: resumes controller via resume command

- Hooks vfio_migration_ops into vfio_pci_ops using:
  - `migration_set_state()` and `migration_get_state()`
  - Uses state_mutex + reset_lock for proper concurrency

- Queries Identify Controller (CNS=01h) to check for HMLMS bit
  in OACS field, indicating controller migration capability

- Applies runtime checks for buffer alignment, format support,
  and state size bounds to ensure spec compliance

With this patch, vfio-nvme enables live migration of VF-based
NVMe devices by implementing TP4159 migration command flows
and vfio device state transitions required by QEMU/VMM.

Signed-off-by: Lei Rao <lei.rao@intel.com>
Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/vfio/pci/nvme/Makefile |   3 +
 drivers/vfio/pci/nvme/nvme.c   | 840 +++++++++++++++++++++++++++++++++
 drivers/vfio/pci/nvme/nvme.h   |   3 +
 3 files changed, 846 insertions(+)

diff --git a/drivers/vfio/pci/nvme/Makefile b/drivers/vfio/pci/nvme/Makefile
index 2f4a0ad3d9cf..d434c943436b 100644
--- a/drivers/vfio/pci/nvme/Makefile
+++ b/drivers/vfio/pci/nvme/Makefile
@@ -1,3 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+KBUILD_EXTRA_SYMBOLS := $(srctree)/drivers/nvme/Module.symvers
+
 obj-$(CONFIG_NVME_VFIO_PCI) += nvme-vfio-pci.o
 nvme-vfio-pci-y := nvme.o
diff --git a/drivers/vfio/pci/nvme/nvme.c b/drivers/vfio/pci/nvme/nvme.c
index 08bee3274207..5283d6b606dc 100644
--- a/drivers/vfio/pci/nvme/nvme.c
+++ b/drivers/vfio/pci/nvme/nvme.c
@@ -19,6 +19,8 @@
 
 #include "nvme.h"
 
+#define MAX_MIGRATION_SIZE (256 * 1024)
+
 static void nvmevf_disable_fd(struct nvmevf_migration_file *migf)
 {
 	mutex_lock(&migf->lock);
@@ -71,6 +73,842 @@ static struct nvmevf_pci_core_device *nvmevf_drvdata(struct pci_dev *pdev)
 			    core_device);
 }
 
+/*
+ * Convert byte length to nvme's 0-based num dwords
+ */
+static inline u32 bytes_to_nvme_numd(size_t len)
+{
+	if (len < 4)
+		return 0;
+	return (len >> 2) - 1;
+}
+
+static int nvmevf_cmd_suspend_device(struct nvmevf_pci_core_device *nvmevf_dev)
+{
+	struct pci_dev *dev = nvmevf_dev->core_device.pdev;
+	struct nvme_command c = { };
+	u32 cdw11 = NVME_LM_SUSPEND_TYPE_SUSPEND << 16 | nvme_get_ctrl_id(dev);
+	int ret;
+
+	c.lm.send.opcode = nvme_admin_lm_send;
+	c.lm.send.cdw10 = cpu_to_le32(NVME_LM_SEND_SEL_SUSPEND);
+	c.lm.send.cdw11 = cpu_to_le32(cdw11);
+
+	ret = nvme_submit_vf_cmd(dev, &c, NULL, NULL, 0);
+	if (ret) {
+		dev_warn(&dev->dev,
+			 "Suspend virtual function failed (ret=0x%x)\n",
+			 ret);
+		return ret;
+	}
+
+	dev_dbg(&dev->dev, "Suspend command successful\n");
+	return 0;
+}
+
+static int nvmevf_cmd_resume_device(struct nvmevf_pci_core_device *nvmevf_dev)
+{
+	struct pci_dev *dev = nvmevf_dev->core_device.pdev;
+	struct nvme_command c = { };
+	int ret;
+
+	c.lm.send.opcode = nvme_admin_lm_send;
+	c.lm.send.cdw10 = cpu_to_le32(NVME_LM_SEND_SEL_RESUME);
+	c.lm.send.cdw11 = cpu_to_le32(nvme_get_ctrl_id(dev));
+
+	ret = nvme_submit_vf_cmd(dev, &c, NULL, NULL, 0);
+	if (ret) {
+		dev_warn(&dev->dev,
+			 "Resume virtual function failed (ret=0x%x)\n", ret);
+		return ret;
+	}
+	dev_dbg(&dev->dev, "Resume command successful\n");
+	return 0;
+}
+
+/**
+ * Figure SCSF-FIG1: Supported Controller State Formats Data Structure
+ * nvme_lm_get_ctrl_state_fmts - Query and parse CNS=0x20 format list
+ * @dev:  Controller pci device
+ * @fmt:  Output struct populated with NV, NUUID, and pointers
+ *
+ * Issues Identify CNS=0x20 (Supported Controller State Formats),
+ * allocates a buffer, and parses the result into the provided struct.
+ *
+ * The caller must free fmt->ctrl_state_raw_buf using kfree().
+ *
+ * Returns 0 on success, or a negative errno on failure.
+ */
+static int nvme_lm_id_ctrl_state(struct pci_dev *dev,
+				 struct nvme_lm_ctrl_state_fmts_info *fmt)
+{
+	struct nvme_command c = { };
+	void *buf;
+	int ret;
+	__u8 nv, nuuid;
+	size_t len;
+
+	if (!fmt)
+		return -EINVAL;
+
+	/* Step 1: Read first 2 bytes to get NV and NUUID */
+	buf = kzalloc(2, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	c.identify.opcode = nvme_admin_identify;
+	c.identify.cns = NVME_ID_CNS_LM_CTRL_STATE_FMT;
+	c.identify.nsid = cpu_to_le32(0);
+
+	ret = nvme_submit_vf_cmd(dev, &c, NULL, buf, 2);
+	if (ret)
+		goto out_free;
+
+	nv = ((__u8 *)buf)[0];
+	nuuid = ((__u8 *)buf)[1];
+
+	kfree(buf);
+
+	/*
+	 * Compute total buffer length for the full Identify CNS=0x20 response:
+	 *
+	 * - The first 2 bytes hold the header:
+	 *     * Byte 0: NV     — number of NVMe-defined format versions
+	 *     * Byte 1: NUUID  — number of vendor-specific UUID entries
+	 *
+	 * - Each version entry is 2 bytes (VERSION_ENTRY_SIZE)
+	 * - Each UUID entry is 16 bytes (UUID_ENTRY_SIZE)
+	 *
+	 * Therefore:
+	 *   Total length = 2 + (NV * 2) + (NUUID * 16)
+	 */
+	len = NVME_LM_CTRL_STATE_HDR_SIZE +
+	nv * NVME_LM_VERSION_ENTRY_SIZE + nuuid * NVME_LM_UUID_ENTRY_SIZE;
+
+	buf = kzalloc(len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	memset(&c, 0, sizeof(c));
+	c.identify.opcode = nvme_admin_identify;
+	c.identify.cns = NVME_ID_CNS_LM_CTRL_STATE_FMT;
+	c.identify.nsid = cpu_to_le32(0);
+
+	ret = nvme_submit_vf_cmd(dev, &c, NULL, buf, len);
+	if (ret)
+		goto out_free;
+
+	/* Parse the result in-place */
+	fmt->nv = nv;
+	fmt->nuuid = nuuid;
+	fmt->vers = ((struct nvme_lm_supported_ctrl_state_fmts *)buf)->vers;
+	fmt->uuids = (const void *)(fmt->vers + nv);
+	fmt->ctrl_state_raw_buf = buf;
+	fmt->raw_len = len;
+
+	return 0;
+
+out_free:
+	kfree(buf);
+	return ret;
+}
+
+static int nvme_lm_get_ctrl_state_fmt(struct pci_dev *dev, bool debug,
+				      struct nvme_lm_ctrl_state_fmts_info *fmt)
+{
+	__u8 i;
+	int ret;
+
+	ret = nvme_lm_id_ctrl_state(dev, fmt);
+	if (ret) {
+		pr_err("Failed to get ctrl state formats (ret=%d)\n", ret);
+		return ret;
+	}
+
+	if (debug)
+		pr_info("NV = %u, NUUID = %u\n", fmt->nv, fmt->nuuid);
+
+	if (debug) {
+		for (i = 0; i < fmt->nv; i++) {
+			pr_info("  Format[%d] Version = 0x%04x\n",
+					i, le16_to_cpu(fmt->vers[i]));
+		}
+
+		for (i = 0; i < fmt->nuuid; i++) {
+			char uuid_str[37]; /* 36 chars + null */
+
+			snprintf(uuid_str, sizeof(uuid_str),
+					"%02x%02x%02x%02x-%02x%02x-%02x%02x-"
+					"%02x%02x-%02x%02x%02x%02x%02x%02x",
+					fmt->uuids[i][0], fmt->uuids[i][1],
+					fmt->uuids[i][2], fmt->uuids[i][3],
+					fmt->uuids[i][4], fmt->uuids[i][5],
+					fmt->uuids[i][6], fmt->uuids[i][7],
+					fmt->uuids[i][8], fmt->uuids[i][9],
+					fmt->uuids[i][10], fmt->uuids[i][11],
+					fmt->uuids[i][12], fmt->uuids[i][13],
+					fmt->uuids[i][14], fmt->uuids[i][15]);
+
+			pr_info("  UUID[%d] = %s\n", i, uuid_str);
+		}
+	}
+
+	return ret;
+}
+
+static void nvmevf_init_get_ctrl_state_cmd(struct nvme_command *c, __u16 cntlid,
+					   __u8 csvi, __u8 csuuidi,
+					   __u8 csuidxp, size_t buf_len)
+{
+	c->lm.recv.opcode = nvme_admin_lm_recv;
+	c->lm.recv.sel = NVME_LM_RECV_GET_CTRL_STATE;
+	/*
+	 * MOS fields treated as ctrl state version index, Use NVME V1 state.
+	 */
+	/*
+	 * For upstream read the supported controller state formats using
+	 * identify command with cns value 0x20 and make sure NVME_LM_CSVI
+	 * matches the on of the reported formats for NVMe states.
+	 */
+	c->lm.recv.mos = cpu_to_le16(csvi);
+	/* Target Controller is this a right way to get the controller ID */
+	c->lm.recv.cntlid = cpu_to_le16(cntlid);
+
+	/*
+	 * For upstream read the supported controller state formats using
+	 * identify command with cns value 0x20 and make sure NVME_LM_CSVI
+	 * matches the on of the reported formats for Vender specific states.
+	 */
+	/* adjust the state as per needed by setting the macro values */
+	c->lm.recv.csuuidi = cpu_to_le32(csuuidi);
+	c->lm.recv.csuidxp = cpu_to_le32(csuidxp);
+
+	/*
+	 * Associates the Migration Receive command with the correct migration
+	 * session UUID currently we set to 0. For now asssume that initiaor
+	 * and target has agreed on the UUIDX 0 for all the live migration
+	 * sessions.
+	 */
+	c->lm.recv.uuid_index = cpu_to_le32(0);
+
+	/*
+	 * Assume that data buffer is big enoough to hold the state,
+	 * 0-based dword count.
+	 */
+	c->lm.recv.numd = cpu_to_le32(bytes_to_nvme_numd(buf_len));
+}
+
+#define NVME_LM_MAX_NVMECS	1024
+#define NVME_LM_MAX_VSD		1024
+
+static int nvmevf_get_ctrl_state(struct pci_dev *dev,
+				__u8 csvi, __u8 csuuidi, __u8 csuidxp,
+				struct nvmevf_migration_file *migf,
+				struct nvme_lm_ctrl_state_info *state)
+{
+	struct nvme_command c = { };
+	struct nvme_lm_ctrl_state *hdr;
+	/* Make sure hdr_len is a multiple of 4 */
+	size_t hdr_len = ALIGN(sizeof(*hdr), 4);
+	__u16 id = nvme_get_ctrl_id(dev);
+	void *local_buf;
+	size_t len;
+	int ret;
+
+	/* Step 1: Issue Migration Receive (Select = 0) to get header */
+	local_buf = kzalloc(hdr_len, GFP_KERNEL);
+	if (!local_buf)
+		return -ENOMEM;
+
+	nvmevf_init_get_ctrl_state_cmd(&c, id, csvi, csuuidi, csuidxp, hdr_len);
+	ret = nvme_submit_vf_cmd(dev, &c, NULL, local_buf, hdr_len);
+	if (ret) {
+		dev_warn(&dev->dev,
+			"nvme_admin_lm_recv failed (ret=0x%x)\n", ret);
+		kfree(local_buf);
+		return ret;
+	}
+
+	if (le16_to_cpu(hdr->nvmecss) > NVME_LM_MAX_NVMECS ||
+	    le16_to_cpu(hdr->vss) > NVME_LM_MAX_VSD) {
+		kfree(local_buf);
+		return -EINVAL;
+	}
+
+	hdr = local_buf;
+	len = hdr_len + 4 * (le16_to_cpu(hdr->nvmecss) + le16_to_cpu(hdr->vss));
+
+	kfree(local_buf);
+
+	if (len == hdr_len)
+		dev_warn(&dev->dev, "nvmecss == 0 or vss = 0\n");
+
+	/* Step 2: Allocate full buffer */
+	migf->total_length = len;
+	migf->vf_data = kvzalloc(migf->total_length, GFP_KERNEL);
+	if (!migf->vf_data)
+		return -ENOMEM;
+
+	memset(&c, 0, sizeof(c));
+	nvmevf_init_get_ctrl_state_cmd(&c, id, csvi, csuuidi, csuidxp, len);
+	ret = nvme_submit_vf_cmd(dev, &c, NULL, migf->vf_data, len);
+	if (ret)
+		goto free_big;
+
+	/* Populate state struct */
+	hdr = (struct nvme_lm_ctrl_state *)migf->vf_data;
+	state->raw = hdr;
+	state->total_len = len;
+	state->version = hdr->version;
+	state->csattr = hdr->csattr;
+	state->nvmecss = hdr->nvmecss;
+	state->vss = hdr->vss;
+	state->nvme_cs = hdr->data;
+	state->vsd = hdr->data + le16_to_cpu(hdr->nvmecss) * 4;
+
+	return ret;
+
+free_big:
+	kvfree(migf->vf_data);
+	return ret;
+}
+
+static const struct nvme_lm_nvme_cs_v0_state *
+nvme_lm_parse_nvme_cs_v0_state(const void *data, size_t len, u16 *niosq,
+			       u16 *niocq)
+{
+	const struct nvme_lm_nvme_cs_v0_state *hdr = data;
+	size_t hdr_len = sizeof(*hdr);
+	size_t iosq_sz, iocq_sz, total;
+	u16 sq, cq;
+
+	if (!data || len < hdr_len)
+		return NULL;
+
+	sq = le16_to_cpu(hdr->niosq);
+	cq = le16_to_cpu(hdr->niocq);
+
+	iosq_sz = sq * sizeof(struct nvme_lm_iosq_state);
+	iocq_sz = cq * sizeof(struct nvme_lm_iocq_state);
+	total = hdr_len + iosq_sz + iocq_sz;
+
+	if (len < total)
+		return NULL;
+
+	if (niosq)
+		*niosq = sq;
+	if (niocq)
+		*niocq = cq;
+
+	return hdr;
+}
+
+static void nvme_lm_debug_ctrl_state(struct nvme_lm_ctrl_state_info *state)
+{
+	const struct nvme_lm_nvme_cs_v0_state *cs;
+	const struct nvme_lm_iosq_state *iosq;
+	const struct nvme_lm_iocq_state *iocq;
+	u16 niosq, niocq;
+	int i;
+
+	pr_info("Controller State:\n");
+	pr_info("Version    : 0x%04x\n", le16_to_cpu(state->version));
+	pr_info("CSATTR     : 0x%02x\n", state->csattr);
+	pr_info("NVMECS Len : %u bytes\n", le16_to_cpu(state->nvmecss) * 4);
+	pr_info("VSD Len    : %u bytes\n", le16_to_cpu(state->vss) * 4);
+
+	cs = nvme_lm_parse_nvme_cs_v0_state(state->nvme_cs,
+					    le16_to_cpu(state->nvmecss) * 4,
+					    &niosq, &niocq);
+	if (!cs) {
+		pr_warn("Failed to parse NVMECS\n");
+		return;
+	}
+
+	iosq = cs->iosq;
+	iocq = (const void *)(iosq + niosq);
+
+	for (i = 0; i < niosq; i++) {
+		pr_info("IOSQ[%d]: SIZE=%u QID=%u CQID=%u ATTR=0x%x Head=%u "
+			"Tail=%u\n", i,
+			le16_to_cpu(iosq[i].qsize),
+			le16_to_cpu(iosq[i].qid),
+			le16_to_cpu(iosq[i].cqid),
+			le16_to_cpu(iosq[i].attr),
+			le16_to_cpu(iosq[i].head),
+			le16_to_cpu(iosq[i].tail));
+	}
+
+	for (i = 0; i < niocq; i++) {
+		pr_info("IOCQ[%d]: SIZE=%u QID=%u ATTR=%u Head=%u Tail=%u\n", i,
+			le16_to_cpu(iocq[i].qsize),
+			le16_to_cpu(iocq[i].qid),
+			le16_to_cpu(iocq[i].attr),
+			le16_to_cpu(iocq[i].head),
+			le16_to_cpu(iocq[i].tail));
+	}
+}
+
+#define NVME_LM_CSUUIDI	0
+#define NVME_LM_CSVI	NVME_LM_RECV_CSVI_NVME_V1
+
+static int nvmevf_cmd_get_ctrl_state(struct nvmevf_pci_core_device *nvmevf_dev,
+				     struct nvmevf_migration_file *migf)
+{
+	struct pci_dev *dev = nvmevf_dev->core_device.pdev;
+	struct nvme_lm_ctrl_state_fmts_info fmt = { };
+	struct nvme_lm_ctrl_state_info state = { };
+	__u8 csvi = NVME_LM_CSVI;
+	__u8 csuuidi = NVME_LM_CSUUIDI;
+	__u8 csuidxp = 0;
+	int ret;
+
+	/*
+	 * Read the supported controller state formats to make sure they match
+	 * csvi value specified in vfio-nvme without this check we'd not know
+	 * which controller state format we are working with.
+	 */
+	ret = nvme_lm_get_ctrl_state_fmt(dev, true, &fmt);
+	if (ret)
+		return ret;
+	/*
+	 * Number of versions NV cannot be less than controller state version
+	 * index we are using, it's an error. Please note that CSVI is
+	 * a configurable value user can define this macro at the compile time
+	 * to select the required NVMe controller state version index from
+	 * Supported Controller State Formats Data Structure.
+	 */
+	if (fmt.nv < csvi) {
+		dev_warn(&dev->dev,
+			 "required ctrl state format not found\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = nvmevf_get_ctrl_state(dev, csvi, csuuidi, csuidxp, migf, &state);
+	if (ret)
+		goto out;
+
+	if (le16_to_cpu(state.version) != csvi) {
+		dev_warn(&dev->dev,
+			 "Unexpected controller state version: 0x%04x\n",
+			 le16_to_cpu(state.version));
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/*
+	 * Now that we have received the controller state decode the state
+	 * properly for debugging purpose
+	 */
+
+	nvme_lm_debug_ctrl_state(&state);
+
+	dev_info(&dev->dev, "Get controller state successful\n");
+
+out:
+	kfree(fmt.ctrl_state_raw_buf);
+	return ret;
+}
+
+static int nvmevf_cmd_set_ctrl_state(struct nvmevf_pci_core_device *nvmevf_dev,
+				     struct nvmevf_migration_file *migf)
+{
+	struct pci_dev *dev = nvmevf_dev->core_device.pdev;
+	struct nvme_command c = { };
+	u32 sel = NVME_LM_SEND_SEL_SET_CTRL_STATE;
+	/* assume that data buffer is big enough to hold state in one cmd */
+	u32 mos = NVME_LM_SEQIND_ONLY;
+	u32 cntlid = nvme_get_ctrl_id(dev);
+	u32 csvi = NVME_LM_CSVI;
+	u32 csuuidi = NVME_LM_CSUUIDI;
+	int ret;
+
+	c.lm.send.opcode = nvme_admin_lm_send;
+	/* mos = SEQIND = 0b11 (Only) in MOS bits [17:16] */
+	c.lm.send.cdw10 = cpu_to_le32((mos << 16) | sel);
+	/*
+	 * Assume that we are only working on NVMe state and not on vendor
+	 * specific state.
+	 */
+	c.lm.send.cdw11 = cpu_to_le32(csuuidi << 24 | csvi << 16 | cntlid);
+
+	/*
+	 * Associates the Migration Send command with the correct migration
+	 * session UUID currently we set to 0. For now asssume that initiaor
+	 * and target has agreed on the UUIDX 0 for all the live migration
+	 * sessions.
+	 */
+	c.lm.send.cdw14 = cpu_to_le32(0);
+	/*
+	 * Assume that data buffer is big enoough to hold the state,
+	 * 0-based dword count.
+	 */
+	c.lm.send.cdw15 = cpu_to_le32(bytes_to_nvme_numd(migf->total_length));
+
+	ret = nvme_submit_vf_cmd(dev, &c, NULL, migf->vf_data,
+				 migf->total_length);
+	if (ret) {
+		dev_warn(&dev->dev,
+			 "Load the device states failed (ret=0x%x)\n", ret);
+		return ret;
+	}
+
+	dev_info(&dev->dev, "Set controller state successful\n");
+	return 0;
+}
+
+static int nvmevf_release_file(struct inode *inode, struct file *filp)
+{
+	struct nvmevf_migration_file *migf = filp->private_data;
+
+	nvmevf_disable_fd(migf);
+	mutex_destroy(&migf->lock);
+	kfree(migf);
+	return 0;
+}
+
+static ssize_t nvmevf_resume_write(struct file *filp, const char __user *buf,
+				   size_t len, loff_t *pos)
+{
+	struct nvmevf_migration_file *migf = filp->private_data;
+	loff_t requested_length;
+	ssize_t done = 0;
+	int ret;
+
+	if (pos)
+		return -ESPIPE;
+	pos = &filp->f_pos;
+
+	if (*pos < 0 ||
+	    check_add_overflow((loff_t)len, *pos, &requested_length))
+		return -EINVAL;
+
+	if (requested_length > MAX_MIGRATION_SIZE)
+		return -ENOMEM;
+	mutex_lock(&migf->lock);
+	if (migf->disabled) {
+		done = -ENODEV;
+		goto out_unlock;
+	}
+
+	ret = copy_from_user(migf->vf_data + *pos, buf, len);
+	if (ret) {
+		done = -EFAULT;
+		goto out_unlock;
+	}
+	*pos += len;
+	done = len;
+	migf->total_length += len;
+
+out_unlock:
+	mutex_unlock(&migf->lock);
+	return done;
+}
+
+static const struct file_operations nvmevf_resume_fops = {
+	.owner = THIS_MODULE,
+	.write = nvmevf_resume_write,
+	.release = nvmevf_release_file,
+	.llseek = noop_llseek,
+};
+
+static struct nvmevf_migration_file *
+nvmevf_pci_resume_device_data(struct nvmevf_pci_core_device *nvmevf_dev)
+{
+	struct nvmevf_migration_file *migf;
+	int ret;
+
+	migf = kzalloc(sizeof(*migf), GFP_KERNEL);
+	if (!migf)
+		return ERR_PTR(-ENOMEM);
+
+	migf->filp = anon_inode_getfile("nvmevf_mig", &nvmevf_resume_fops, migf,
+					O_WRONLY);
+	if (IS_ERR(migf->filp)) {
+		int err = PTR_ERR(migf->filp);
+
+		kfree(migf);
+		return ERR_PTR(err);
+	}
+	stream_open(migf->filp->f_inode, migf->filp);
+	mutex_init(&migf->lock);
+
+	/* Allocate buffer to load the device states and max states is 256K */
+	migf->vf_data = kvzalloc(MAX_MIGRATION_SIZE, GFP_KERNEL);
+	if (!migf->vf_data) {
+		ret = -ENOMEM;
+		goto out_free;
+	}
+
+	return migf;
+
+out_free:
+	fput(migf->filp);
+	return ERR_PTR(ret);
+}
+
+static ssize_t nvmevf_save_read(struct file *filp, char __user *buf,
+				size_t len, loff_t *pos)
+{
+	struct nvmevf_migration_file *migf = filp->private_data;
+	ssize_t done = 0;
+	int ret;
+
+	if (pos)
+		return -ESPIPE;
+	pos = &filp->f_pos;
+
+	mutex_lock(&migf->lock);
+	if (*pos > migf->total_length) {
+		done = -EINVAL;
+		goto out_unlock;
+	}
+
+	if (migf->disabled) {
+		done = -EINVAL;
+		goto out_unlock;
+	}
+
+	len = min_t(size_t, migf->total_length - *pos, len);
+	if (len) {
+		ret = copy_to_user(buf, migf->vf_data + *pos, len);
+		if (ret) {
+			done = -EFAULT;
+			goto out_unlock;
+		}
+		*pos += len;
+		done = len;
+	}
+
+out_unlock:
+	mutex_unlock(&migf->lock);
+	return done;
+}
+
+static const struct file_operations nvmevf_save_fops = {
+	.owner = THIS_MODULE,
+	.read = nvmevf_save_read,
+	.release = nvmevf_release_file,
+	.llseek = noop_llseek,
+};
+
+static struct nvmevf_migration_file *
+nvmevf_pci_save_device_data(struct nvmevf_pci_core_device *nvmevf_dev)
+{
+	struct nvmevf_migration_file *migf;
+	int ret;
+
+	migf = kzalloc(sizeof(*migf), GFP_KERNEL);
+	if (!migf)
+		return ERR_PTR(-ENOMEM);
+
+	migf->filp = anon_inode_getfile("nvmevf_mig", &nvmevf_save_fops, migf,
+					O_RDONLY);
+	if (IS_ERR(migf->filp)) {
+		int err = PTR_ERR(migf->filp);
+
+		kfree(migf);
+		return ERR_PTR(err);
+	}
+
+	stream_open(migf->filp->f_inode, migf->filp);
+	mutex_init(&migf->lock);
+
+	ret = nvmevf_cmd_get_ctrl_state(nvmevf_dev, migf);
+	if (ret)
+		goto out_free;
+
+	return migf;
+out_free:
+	fput(migf->filp);
+	return ERR_PTR(ret);
+}
+
+static struct file *
+nvmevf_pci_step_device_state_locked(struct nvmevf_pci_core_device *nvmevf_dev,
+				    u32 new)
+{
+	u32 cur = nvmevf_dev->mig_state;
+	int ret;
+
+	if (cur == VFIO_DEVICE_STATE_RUNNING && new == VFIO_DEVICE_STATE_STOP) {
+		ret = nvmevf_cmd_suspend_device(nvmevf_dev);
+		if (ret)
+			return ERR_PTR(ret);
+		return NULL;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_STOP &&
+	    new == VFIO_DEVICE_STATE_STOP_COPY) {
+		struct nvmevf_migration_file *migf;
+
+		migf = nvmevf_pci_save_device_data(nvmevf_dev);
+		if (IS_ERR(migf))
+			return ERR_CAST(migf);
+		get_file(migf->filp);
+		nvmevf_dev->saving_migf = migf;
+		return migf->filp;
+	}
+
+
+	if (cur == VFIO_DEVICE_STATE_STOP_COPY &&
+	    new == VFIO_DEVICE_STATE_STOP) {
+		nvmevf_disable_fds(nvmevf_dev);
+		return NULL;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_STOP &&
+	    new == VFIO_DEVICE_STATE_RESUMING) {
+		struct nvmevf_migration_file *migf;
+
+		migf = nvmevf_pci_resume_device_data(nvmevf_dev);
+		if (IS_ERR(migf))
+			return ERR_CAST(migf);
+		get_file(migf->filp);
+		nvmevf_dev->resuming_migf = migf;
+		return migf->filp;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_RESUMING &&
+	    new == VFIO_DEVICE_STATE_STOP) {
+		ret = nvmevf_cmd_set_ctrl_state(nvmevf_dev,
+						nvmevf_dev->resuming_migf);
+		if (ret)
+			return ERR_PTR(ret);
+		nvmevf_disable_fds(nvmevf_dev);
+		return NULL;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_STOP &&
+	    new == VFIO_DEVICE_STATE_RUNNING) {
+		nvmevf_cmd_resume_device(nvmevf_dev);
+		return NULL;
+	}
+
+	/* vfio_mig_get_next_state() does not use arcs other than the above */
+	WARN_ON(true);
+	return ERR_PTR(-EINVAL);
+}
+
+static struct file *
+nvmevf_pci_set_device_state(struct vfio_device *vdev,
+			    enum vfio_device_mig_state new_state)
+{
+	struct nvmevf_pci_core_device *nvmevf_dev = container_of(vdev,
+			struct nvmevf_pci_core_device, core_device.vdev);
+	enum vfio_device_mig_state next_state;
+	struct file *res = NULL;
+	int ret;
+
+	mutex_lock(&nvmevf_dev->state_mutex);
+	while (new_state != nvmevf_dev->mig_state) {
+		ret = vfio_mig_get_next_state(vdev, nvmevf_dev->mig_state,
+					      new_state, &next_state);
+		if (ret) {
+			res = ERR_PTR(-EINVAL);
+			break;
+		}
+
+		res = nvmevf_pci_step_device_state_locked(nvmevf_dev,
+							  next_state);
+		if (IS_ERR(res))
+			break;
+		nvmevf_dev->mig_state = next_state;
+		if (WARN_ON(res && new_state != nvmevf_dev->mig_state)) {
+			fput(res);
+			res = ERR_PTR(-EINVAL);
+			break;
+		}
+	}
+	nvmevf_state_mutex_unlock(nvmevf_dev);
+	return res;
+}
+
+static int nvmevf_pci_get_device_state(struct vfio_device *vdev,
+				       enum vfio_device_mig_state *curr_state)
+{
+	struct nvmevf_pci_core_device *nvmevf_dev = container_of(
+			vdev, struct nvmevf_pci_core_device, core_device.vdev);
+
+	mutex_lock(&nvmevf_dev->state_mutex);
+	*curr_state = nvmevf_dev->mig_state;
+	nvmevf_state_mutex_unlock(nvmevf_dev);
+	return 0;
+}
+
+static const struct vfio_migration_ops nvmevf_pci_mig_ops = {
+	.migration_set_state = nvmevf_pci_set_device_state,
+	.migration_get_state = nvmevf_pci_get_device_state,
+};
+
+static bool nvmevf_migration_supp(struct pci_dev *pdev)
+{
+	struct nvme_command c = { };
+	u8 lm_supported = false;
+	struct nvme_id_ctrl *id;
+	__u16 oacs;
+	int ret;
+
+	c.identify.opcode = nvme_admin_identify;
+	c.identify.cns = NVME_ID_CNS_CTRL;
+
+	id = kmalloc(sizeof(struct nvme_id_ctrl), GFP_KERNEL);
+	if (!id)
+		return false;
+
+	ret = nvme_submit_vf_cmd(pdev, &c, NULL, id,
+				 sizeof(struct nvme_id_ctrl));
+	if (ret) {
+		dev_warn(&pdev->dev, "Get identify ctrl failed (ret=0x%x)\n",
+			 ret);
+		lm_supported = false;
+		goto out;
+	}
+
+	oacs = le16_to_cpu(id->oacs);
+	lm_supported = oacs & NVME_CTRL_OACS_HMLMS ? true : false;
+out:
+	kfree(id);
+	return lm_supported;
+}
+
+static int nvmevf_migration_init_dev(struct vfio_device *core_vdev)
+{
+	struct nvmevf_pci_core_device *nvmevf_dev;
+	struct pci_dev *pdev;
+	int vf_id;
+	int ret = -1;
+
+	nvmevf_dev = container_of(core_vdev, struct nvmevf_pci_core_device,
+				  core_device.vdev);
+	pdev = to_pci_dev(core_vdev->dev);
+
+	if (!pdev->is_virtfn)
+		return ret;
+
+	/*
+	 * Get the identify controller data structure to check the live
+	 * migration support.
+	 */
+	if (!nvmevf_migration_supp(pdev))
+		return ret;
+
+	nvmevf_dev->migrate_cap = 1;
+
+	vf_id = pci_iov_vf_id(pdev);
+	if (vf_id < 0)
+		return ret;
+	nvmevf_dev->vf_id = vf_id + 1;
+	core_vdev->migration_flags = VFIO_MIGRATION_STOP_COPY;
+
+	mutex_init(&nvmevf_dev->state_mutex);
+	spin_lock_init(&nvmevf_dev->reset_lock);
+	core_vdev->mig_ops = &nvmevf_pci_mig_ops;
+
+	return vfio_pci_core_init_dev(core_vdev);
+}
+
 static int nvmevf_pci_open_device(struct vfio_device *core_vdev)
 {
 	struct nvmevf_pci_core_device *nvmevf_dev;
@@ -109,6 +947,7 @@ static void nvmevf_pci_close_device(struct vfio_device *core_vdev)
 
 static const struct vfio_device_ops nvmevf_pci_ops = {
 	.name = "nvme-vfio-pci",
+	.init = nvmevf_migration_init_dev,
 	.release = vfio_pci_core_release_dev,
 	.open_device = nvmevf_pci_open_device,
 	.close_device = nvmevf_pci_close_device,
@@ -193,4 +1032,5 @@ module_pci_driver(nvmevf_pci_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Chaitanya Kulkarni <kch@nvidia.com>");
+MODULE_AUTHOR("Lei Rao <lei.rao@intel.com>");
 MODULE_DESCRIPTION("NVMe VFIO PCI - VFIO PCI driver with live migration support for NVMe");
diff --git a/drivers/vfio/pci/nvme/nvme.h b/drivers/vfio/pci/nvme/nvme.h
index ee602254679e..80dd75d33762 100644
--- a/drivers/vfio/pci/nvme/nvme.h
+++ b/drivers/vfio/pci/nvme/nvme.h
@@ -33,4 +33,7 @@ struct nvmevf_pci_core_device {
 	struct nvmevf_migration_file *saving_migf;
 };
 
+extern int nvme_submit_vf_cmd(struct pci_dev *dev, struct nvme_command *cmd,
+			size_t *result, void *buffer, unsigned int bufflen);
+extern u16 nvme_get_ctrl_id(struct pci_dev *dev);
 #endif /* NVME_VFIO_PCI_H */
-- 
2.40.0


