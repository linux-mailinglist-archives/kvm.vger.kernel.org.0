Return-Path: <kvm+bounces-56703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EE07EB42C91
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 00:11:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A935D3A76AD
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 22:11:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20C732EE260;
	Wed,  3 Sep 2025 22:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pYPxrr6c"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2067.outbound.protection.outlook.com [40.107.102.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB8E2ECE82
	for <kvm@vger.kernel.org>; Wed,  3 Sep 2025 22:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756937498; cv=fail; b=ST9JZrLVGYRqPT3jC7al582md2Vu/5bAFxCpJR4SoUBu8AsWVEVBii4KTB5sW5RKtUaJZz3bHU3v1oZaVAWmj0LFpW67bjKhqczgIrp/vYl7m3oOScXugu7qQ1PUyMtMdOobQLpssN7yRIpROSQsCAkrLBZLNDWj91D/VQeeZX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756937498; c=relaxed/simple;
	bh=rpuO7XF5K2jqF3T0e/wrRiBw6tVjIoqbnjGxc8FVGtg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sYLVRLIdl9amk0d5BsIwdJLjWpWfzC/PBwwtfba8qqm4QZ8PMa1e7uTiz3AzlozJzMGgV/bF3Kf9uQTqBgxEH1GmXLIf0Yv06GG7Ra7LWiCF/E4rBVkWUG5Dx02dKsStf0sVo2TBefaN6XUyarxUEghedaFgxp5wzYupQlV5ZMU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pYPxrr6c; arc=fail smtp.client-ip=40.107.102.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ah0DxaUKYFwIS7hiUJLQ65eAtl1y7yoYXasDhj+hmvYg5QHWJAaiABgci60pltxWvS18Zonk91eVvbiL2Xwf2EhDlWwarfDejaGIvhXNqgHd0qTLkD5sNvyvaUG3wa36n4RNoemj6kxHJXgUNKZrTAral8zaxJ4CUwE+HD1fRutO9pj0fNAHjBXVl73IePUe+UY7AmFYIw8jHNf+rhl3HEAoZ5T3W+htedKxHYIuF/+i4aIVmLynqyKkXISiQuwLM5gRe/vYX/FuneyiSHTNLUFxz85yWUtIsnU+2SX71Saenz7SJvbzPTZaGvj82fiLQSd3R4Qu9fSuC6oxthqgFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y9NhoISqjsYAs1lQ6H1UE6jfaN2f70OC/ZDj4d9dzs4=;
 b=Ziltp2rqjQkWMZNun871pec/ga/eFtQwwGxb3rN8uTYsUTyUigc1J+RbaDCBKNXk4iJDj88zMWZ8NBUdIYuB+0E2qgocw94DCBVMTp/7Lf8z5r5N8Itqp2nPGibQBs2Lt6nU/wpt7RDSPctO+jf9wTHxs/qQQ8MhQ6SuonZurx10h1VDdqqv5Cybw7maFxfrBOHH/p/rPFHZy6jqgsk8EjK+KER+GaEq6YKnSTeh2yMnoUkZ0UD8egpM3d3q3PBH3MS/VEF7K66tTsyUzfXMYICuoeArnWgTaV53e4iSPqaGBfeRZV9+J6z6X2lxunCDimwWV4AzQOURMpvSB7e3Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y9NhoISqjsYAs1lQ6H1UE6jfaN2f70OC/ZDj4d9dzs4=;
 b=pYPxrr6c3Ep1w6O4eKo+FebehO3QNK9HthxHH1vvSAdWxPZq8iNzE+4bk3cHGGREZFBnRT53CQHb5M/vCu4KmvRuQC3raFd6x4IFl8oXAJzZDjJob8E5PsLFLs10FGbyD5Z2gC7lVsbU+iO9FEapiT8WN1PotYWnV2NMgWggpCYobLcDTt2k/Vz9RRC48J/0RiEqIJVVsL2Pfc/XQ227CsQH6m29fSwPM6kk2H/tCW5kN0i+j3cTaPeR7tVW4gLJyK6YnI3wg9bPFLPcfQmp22GXml+5ekNtekkdlvzy5rffEGdwU5MVMS34u7VCW2HWG4+DzXpxFTDrlHhgVy7O5A==
Received: from CH2PR02CA0029.namprd02.prod.outlook.com (2603:10b6:610:4e::39)
 by CY8PR12MB8066.namprd12.prod.outlook.com (2603:10b6:930:70::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Wed, 3 Sep
 2025 22:11:33 +0000
Received: from CH3PEPF0000000C.namprd04.prod.outlook.com
 (2603:10b6:610:4e:cafe::5d) by CH2PR02CA0029.outlook.office365.com
 (2603:10b6:610:4e::39) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.28 via Frontend Transport; Wed,
 3 Sep 2025 22:11:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH3PEPF0000000C.mail.protection.outlook.com (10.167.244.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Wed, 3 Sep 2025 22:11:32 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 15:11:18 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 15:11:18 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Wed, 3 Sep 2025 15:11:18 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <dakr@kernel.org>,
	<acurrid@nvidia.com>, <cjia@nvidia.com>, <smitra@nvidia.com>,
	<ankita@nvidia.com>, <aniketa@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC v2 08/14] vfio/nvidia-vgpu: allocate GSP RM client when creating vGPUs
Date: Wed, 3 Sep 2025 15:11:05 -0700
Message-ID: <20250903221111.3866249-9-zhiw@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250903221111.3866249-1-zhiw@nvidia.com>
References: <20250903221111.3866249-1-zhiw@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000C:EE_|CY8PR12MB8066:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ca5d1c9-08ac-4bdc-4d40-08ddeb36d749
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?no1mzpugTDw4if/WyZ131fIkfu3h8gogJRfBVGzNdX1R0wYytsS9di1b2p9T?=
 =?us-ascii?Q?WtrgQ5qYgJdoX130PK1dYwYWZSCfxQlCFbTXGZGOTlmJSo12UF225ykG7zkf?=
 =?us-ascii?Q?KV5aZSHAljxPXHmDk73RkX18fhbxADItMtQBkz0sg75JKhF8qjXpg41jUZae?=
 =?us-ascii?Q?YFiwVc5ecCFYWGanYMFhhSB7UaPpwXRHxeD6S8RAK66lttib9xaXqVJWPQmO?=
 =?us-ascii?Q?hpA2XZRZrAqxjjKPtb1PWWlCVbHti9vlxsFFAR6xZfaTvWLaLkEyOYUx6dUO?=
 =?us-ascii?Q?H0HdkGsLHJvtAcKbqbmognRCVVfvzsvjax0jtmBGQcJMHuJ5tcZoX6ypZCwe?=
 =?us-ascii?Q?uEgeWiPXaezW+vXclDtdELTS1ZZBOSD0ETOoN94JZJ6prxlI8Dms9QLxWSic?=
 =?us-ascii?Q?aTF1VCn+lBcC2cf6rJSxvTpbOGf4JMKZCljOu5WhkCrYphBE9PWnhjoxM3r7?=
 =?us-ascii?Q?qRma+pkFclq2vbjhoo8twmcoAbNqC6Z8lRImhTegl1w2rbvc3qa7aVPcOkyv?=
 =?us-ascii?Q?xMB0aYQ4XaUDzaGaL276WU3kNRtLYV/XankblIxFOoe7o76mnQwBKvCoIcsw?=
 =?us-ascii?Q?uPlD8onAGQ4Idfh5JsskdViQEfnWdo5eKduxoChPlTn06V+QGNCL3X6NKxzA?=
 =?us-ascii?Q?HjcNKIM3BskApzwhBBoY/PMLPFhH8nQ23wpGUq3yhkgbRpYRe/c2STxAR6hf?=
 =?us-ascii?Q?6CFz6praDOZOimPoXIdTvKCa1QwGfQY0gNqUT/zYGLmNXKN2JtWm6CZ5Ov+K?=
 =?us-ascii?Q?lg97LSpSSnWIX6euI37oMW8MwEEz92fhNBxSuVx4P1WQJlmQSKuPU4WXFygB?=
 =?us-ascii?Q?lmw7/eg8M96OFmet0i+/KInrBI4GEViNlFx2VnZqH1QQ0/rPEDHdCtpdUoNm?=
 =?us-ascii?Q?rcttjVAfZ8JLhaugHBJNZiiOwgf3Ygc49yP1v0biwdpL+mGaSBDebi3A6+H/?=
 =?us-ascii?Q?mufIDQSvvKXybAfhH4zG4CfFPdXdJ+2PiVKssN0We5KOEZ+Y6WKrFP8rlbWb?=
 =?us-ascii?Q?19AqjCsBxeZKw+PQyBIU86bTUNh3DyTGBVa+C5FyqGPET1noVq1lAcvVJl7S?=
 =?us-ascii?Q?M32cI8dqUho514QE1RT5T+jdzjBv7CKQMpYbjK+in1SXHVXqsa0SKUNINI9Y?=
 =?us-ascii?Q?byBGxu75p442kcP3SuGplE0NvHCa1TRvk6e1W8vSpA86nXIo92uscpGbiZWT?=
 =?us-ascii?Q?QG4FmE2s4/eu9WOO+Ighv3ntc5YR0LGLckJkJaWN4jAiXxB1WIBUCswFwsPp?=
 =?us-ascii?Q?gQ4otrFwHDgIFDKh8TzbjJmmFoR5ZhSTWbum3auQpvqZGXNC/O+LziDEEmuD?=
 =?us-ascii?Q?A0iyttO02M2UiNT61uW0Q1siqGY8h3LU/1bc7+T5kcT1SG041qR/9xOqDC7c?=
 =?us-ascii?Q?wnusNCJmq5Q2oNYbgW/X5d05skFGKeJv5lloStJuc6Zhnv5Tlj7WRXcaslQm?=
 =?us-ascii?Q?8/kcYJl3d+B/r8mvRi5G3zbo6avcD+fBwVnJbbvfijXu9KIrxI69E/fj61nF?=
 =?us-ascii?Q?Cs/dIPs22EIuqPtv1ddvVk/tCmhzCTOEVx69?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 22:11:32.7569
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ca5d1c9-08ac-4bdc-4d40-08ddeb36d749
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8066

A GSP RM client is required when talking to the GSP firmware via GSP RM
controls.

So far, all the vGPU GSP RPCs are sent via the GSP RM client allocated
for vGPU manager and some vGPU GSP RPCs needs a per-vGPU GSP RM client.

Allocate a dedicated GSP RM client for each vGPU.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/vfio/pci/nvidia-vgpu/vgpu.c     | 11 +++++++++++
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h |  2 ++
 2 files changed, 13 insertions(+)

diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu.c b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
index 4c106a9803f6..cf28367ac6a0 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu.c
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
@@ -238,9 +238,12 @@ static int setup_mgmt_heap(struct nvidia_vgpu *vgpu)
  */
 int nvidia_vgpu_mgr_destroy_vgpu(struct nvidia_vgpu *vgpu)
 {
+	struct nvidia_vgpu_mgr *vgpu_mgr = vgpu->vgpu_mgr;
+
 	if (!atomic_cmpxchg(&vgpu->status, 1, 0))
 		return -ENODEV;
 
+	nvidia_vgpu_mgr_free_gsp_client(vgpu_mgr, &vgpu->gsp_client);
 	clean_mgmt_heap(vgpu);
 	clean_fbmem_heap(vgpu);
 	clean_chids(vgpu);
@@ -262,6 +265,7 @@ EXPORT_SYMBOL_GPL(nvidia_vgpu_mgr_destroy_vgpu);
  */
 int nvidia_vgpu_mgr_create_vgpu(struct nvidia_vgpu *vgpu)
 {
+	struct nvidia_vgpu_mgr *vgpu_mgr = vgpu->vgpu_mgr;
 	struct nvidia_vgpu_info *info = &vgpu->info;
 	int ret;
 
@@ -295,12 +299,19 @@ int nvidia_vgpu_mgr_create_vgpu(struct nvidia_vgpu *vgpu)
 	if (ret)
 		goto err_setup_mgmt_heap;
 
+	ret = nvidia_vgpu_mgr_alloc_gsp_client(vgpu_mgr,
+					       &vgpu->gsp_client);
+	if (ret)
+		goto err_alloc_gsp_client;
+
 	atomic_set(&vgpu->status, 1);
 
 	vgpu_debug(vgpu, "created\n");
 
 	return 0;
 
+err_alloc_gsp_client:
+	clean_mgmt_heap(vgpu);
 err_setup_mgmt_heap:
 	clean_fbmem_heap(vgpu);
 err_setup_fbmem_heap:
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
index 9a3af35e5eee..84bafea295a0 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
@@ -66,6 +66,7 @@ struct nvidia_vgpu_mgmt {
  * @vgpu_list: list node to the vGPU list
  * @info: vGPU info
  * @vgpu_mgr: pointer to vGPU manager
+ * @gsp_client: per-vGPU GSP client
  * @chid: vGPU channel IDs
  * @fbmem_heap: allocated FB memory for the vGPU
  * @mgmt: vGPU mgmt heap
@@ -79,6 +80,7 @@ struct nvidia_vgpu {
 
 	struct nvidia_vgpu_info info;
 	struct nvidia_vgpu_mgr *vgpu_mgr;
+	struct nvidia_vgpu_gsp_client gsp_client;
 
 	struct nvidia_vgpu_chid chid;
 	struct nvidia_vgpu_mem *fbmem_heap;
-- 
2.34.1


