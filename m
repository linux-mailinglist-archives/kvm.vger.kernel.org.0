Return-Path: <kvm+bounces-27274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7107597E1BD
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 14:53:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E308FB214E9
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 12:53:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 200BD58AD0;
	Sun, 22 Sep 2024 12:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GUrlyS4v"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2081.outbound.protection.outlook.com [40.107.96.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B82B7489
	for <kvm@vger.kernel.org>; Sun, 22 Sep 2024 12:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727009471; cv=fail; b=dAUlfhEot1nbfQf2yFjzcM7KjIp3HoxlwbchNMCETXcK2C1vlqevrQYKfulKODbAWjiikGCNqluwHPOEHeuOHCB3a/Ri7mH9rGKEqBzB/JoaytvSYKBpDBibReFEivxTrAq8KMHox0oPjLD0kgTV7fSo6z2DLzwETciVJuSZg/o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727009471; c=relaxed/simple;
	bh=mWAur9sYpWSZbsDXaS3F0dCp4UHonddEFIfCRRlDA94=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SjWkrz411BX8ItIPlwBFq98K+lyqhTVBja0E1bm3H8QN8pMcV/s+rPkon0V5AcFOoqI6+37F/rQG0LpHcalHhOO/DkX14FkhsOvWc6KDc09XSGBBctK20B8VAY1O5wjOsnpeKUaqpdZnIXeBg92U12lsgxP6KLzqbZSflBfe64I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GUrlyS4v; arc=fail smtp.client-ip=40.107.96.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xTo6ImueNYBucZQCFnLHET9JC14YiFjcXsQuiQJDxqz6ZCH1IBbs8DlR5WiWEAXMXRstIN6JL2dxyGVE/YBdsAhIO/HLbSXxiYpppYhKbzHIrrwHwSl2A9q58WG8PxBHZuok4APkGYJpiiA0MJK/clSjLiOl+SeYtkODHSZwDVWTrGYmwiyxLXli9CAUSTojNKkt6bOFpdsXcwzc6CYCKWwwUVJZoO4gtQO6CkjguFLsgkrpm/Jk2pkRZzVvk1W6y9x7eCa8tOSygjO89taoTTGpH7nB7r7vyeiDZBZhMO4eXnHoCF0zDd/XKJP+/63NeniBEA916gGGEdPDyMhOXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2jVCiig4wQkEsHJ2djmxlaLFeWRiIf4rWWQ+EMJrKiQ=;
 b=iEfEfaESq+EsNvfdUfXarx26c/ieii25IkXL/fKBBAXEe39kIU40bOe2YtinMLj1YckCwAE+pxlRxXiXuW51NIym5K9pzq5kR0c8a4ccTe3EEg63Gw8lSXKtWHT9oxsAr7GSnBsj6HejkvHfsCCumjbaTzDdrRPidCub8HZJy/cIdFbCnzJL2hbbO+IUeI6tmrjSd/wx9PJBYo19tCI22h2T+z/W3gPZxVPVRufVAxo0rqqqTdVuvhf5eGKlKCqCAqzKGn0rCs8PxtPv3YSR0ZsEvQr9BjfvaAxjQxVFCfxlA0DtzFSpfrVriX+rHiGhsIYGjVnHDV7morcIKde/wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2jVCiig4wQkEsHJ2djmxlaLFeWRiIf4rWWQ+EMJrKiQ=;
 b=GUrlyS4v/+GXrf7gHEE/ViRCANxvCmR9dQOpT27CuhcC8zDzKaC4NXNVwCnJRh0/jvnz9W9sl2947GuDaADnNtRPy3zf+u1wVjos3J4UYWwbcV6V9yfL/eo0ZJyZQ2ET8nFEkMvpj6+ul0YhpI2Le8xc7fySEb3WizH+JyJCRrDO5AgfmHl3YxeZkV55LvmrNBYZnWM6jEK9D/uJGSfeV0eepZhT4/INN/PjoDBNlPL6V8ss4QC/vu83RJdgwoYE5xzM4rbjd0Ny2gvne3Isu08KKnf4tMD3MGupsbmoI9BVaAzUf0BOCrmJWfjpQUjeu6kI3jZIW58TFlHoZ2MtlQ==
Received: from MW4P221CA0026.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::31)
 by BY5PR12MB4195.namprd12.prod.outlook.com (2603:10b6:a03:200::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.25; Sun, 22 Sep
 2024 12:50:59 +0000
Received: from CO1PEPF000075F1.namprd03.prod.outlook.com
 (2603:10b6:303:8b:cafe::f7) by MW4P221CA0026.outlook.office365.com
 (2603:10b6:303:8b::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.25 via Frontend
 Transport; Sun, 22 Sep 2024 12:50:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1PEPF000075F1.mail.protection.outlook.com (10.167.249.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Sun, 22 Sep 2024 12:50:58 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 22 Sep
 2024 05:50:39 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Sun, 22 Sep 2024 05:50:38 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Sun, 22 Sep 2024 05:50:38 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <nouveau@lists.freedesktop.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <acurrid@nvidia.com>,
	<cjia@nvidia.com>, <smitra@nvidia.com>, <ankita@nvidia.com>,
	<aniketa@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <zhiwang@kernel.org>, Vinay Kabra <vkabra@nvidia.com>
Subject: [RFC 29/29] vfio/vgpu_mgr: introduce NVIDIA vGPU VFIO variant driver
Date: Sun, 22 Sep 2024 05:49:51 -0700
Message-ID: <20240922124951.1946072-30-zhiw@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240922124951.1946072-1-zhiw@nvidia.com>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F1:EE_|BY5PR12MB4195:EE_
X-MS-Office365-Filtering-Correlation-Id: 48f60ba1-526d-4e70-c890-08dcdb0534e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MldNM1VuRVVFbjMzSjRFRWpKV25XdUljNkVocnRWQVNGVDdoWGtnWG5JYWpo?=
 =?utf-8?B?SllYWFl3bGFXUkNYMUNqV0lWcTNqNnlVT0FzMDVhZVNnSW44MmMrc3g1cjJ6?=
 =?utf-8?B?ek5NU3VkL2JnWnpQUVI5eGJ1andjZ1o0RmVmWFd1bk1OSnVkOVhuVWdCNFdv?=
 =?utf-8?B?UmkraEJHNVo4RDdUZ3JUdzI1Um5hU29scHFOTWZwT0VnaHlsbS84L2lVODNt?=
 =?utf-8?B?Sk0xRTRMNUxXOWt4dzVkK3FFdjgxR2xIblc5dE01NGxNUlhhMi9ZT0h4aG0v?=
 =?utf-8?B?Zm1zemd5R2w4TkNwL3JYWUZaNnFyYzcvbTE5VncxUGJSaDhoVXpZYnJnRVht?=
 =?utf-8?B?eEZONWUrRU1vRUIzcjk2a2JtNy8wb2RCS0lrWVRxeXdUQUcra1R0ZVI3VWdO?=
 =?utf-8?B?S3lXRVdrU3Z6QzdzR3c5TTFPQlV1K3ptcnh3aVVHRTJFVStjb1NGN0NWdW9B?=
 =?utf-8?B?QXE2TExFckJnZkdpejQxbi9Hb2V5bGdFMW44M01zdndRbXEvV2pVRitvV29C?=
 =?utf-8?B?cDhGYUx5ckdsZU4xcWlsRVhoc1RRRWJ5YkdZczRCeUozU3U3aGpmUEU5MGwz?=
 =?utf-8?B?OVhhTmpUcGxQNHFlL0hmWFpNcmt3NDN4ZXpmUTJJZElxbTFOMnFmS2c5M1JZ?=
 =?utf-8?B?Mm9JT3lzNmM5MzBEYW5tbHNyczZqS2lwZjM5SHFNSTYzWU9YeGhhZmpyUkcx?=
 =?utf-8?B?UkxXVU83dXVuU2VwMFlFajAzVGZVYkJoYWZJTFRzVnN4QkQwaDBuSitpZWNG?=
 =?utf-8?B?d2JCdmx6K0x0RmlMdkpNUldaWlpRazlKR2t1M3lDSFNPNlVGcndqTjIwOXpF?=
 =?utf-8?B?MEoxTGFlK1VFY0NJSzFlc2tVVzBrMmF4N3dGaXFieVkxMGRNMHF6bFIwVUFH?=
 =?utf-8?B?S1d6UzhEclF4WEk5SUNLNEMwNkZuQWpFcEFGS1RZNFZSZFJsdTVMUTV3K2ox?=
 =?utf-8?B?SVJkc2dHdXBNTzJtTW0xRWt2TVRrVmhQbnJ3RTg3WVpDcDQwTnQ2SzlBRnVq?=
 =?utf-8?B?RzNkNlVDU1FZMDJJUkJLSWYxaW5oaGhiSnpTcU1saVp5TWc3bnRaNGRDdDdm?=
 =?utf-8?B?dkhNa1VGYnhiaFBScmZJTmdtSmpiWVlQRTZmQVZuZzFlS0tBY05KWm4wSkdv?=
 =?utf-8?B?Si9NMG9OV2dGSzBYMGI3ZURoZEJRVS9aWXc0ZWNOSXJhT0l3NjNGQmczU3d2?=
 =?utf-8?B?aGJ1cFN1NEdQV2RDN2JPVGQ1a00xdzVHaVkrai9OK29wWFVVaW9mV3ZuVHEr?=
 =?utf-8?B?STQ4UVNuUDRFZzlnL1p0L1JHOEVOYlkreDNEQ0pMSkZFaEU0bDRCTndBKzRD?=
 =?utf-8?B?aC8rQnVHWStkbnhuejhONi9NUGFpTHpDY2xEZXJQL3NzMkREb1N3cnVZTlpj?=
 =?utf-8?B?TGpJeVBkZWFLRWJpTFVVMVM1UGZ5Sld4Nll3YkZhcXpDdEpXOXZvd080eWpH?=
 =?utf-8?B?MndRRjgvdHFqaCtVMTllT2NZRW10UmlVSkF4SnE4OVVjRFNRYnEzRVVvaUdZ?=
 =?utf-8?B?clh6cHpZbkkxS0NscUlTeFZmVStvcEF6N1VXK0tIcWNXYUx0Zm9ueVdldDV5?=
 =?utf-8?B?ZHk3YVV2Vkp4ZVJCc2Q3cWRzV1BNdEtaOEVibDVvSUNjQWRCc3RXY0F0UzBw?=
 =?utf-8?B?dzVKMTdGaGpzOVFxUTgxTWFkazJYVGhPZ0dDVllUK21RV3U1dFFVSGc3VFpK?=
 =?utf-8?B?aEl5QVU1THlTeHRYZDBnV25yU245NWxhY05Db2Myd0g5d2JYT1NHVHIzUDVS?=
 =?utf-8?B?WHlXSVBpeE9CZ0J0cW9nVTdoWGEyR2MwL0JueWNtYUVQQjFLbWtiOHdSYW82?=
 =?utf-8?B?elh4MlJjRkk4ZzJvWlhHaHY2cVRrd3RLL2FIYW1kekd0THFmU3lBZnF5THh0?=
 =?utf-8?Q?USFX6M1hFOr9l?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2024 12:50:58.7714
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 48f60ba1-526d-4e70-c890-08dcdb0534e4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4195

A VFIO variant driver module is designed to extend the capabilities of
the existing VFIO (Virtual Function I/O), offering device management
interfaces to the userspace and advanced feature support.

For the userspace to use the NVIDIA vGPU, a new vGPU VFIO variant driver
is introduced to provide vGPU management, like selecting/creating vGPU
instance, support advance features like live migration.

Introduce the NVIDIA vGPU VFIO variant driver to support vGPU lifecycle
management UABI and the future advancd features.

Cc: Neo Jia <cjia@nvidia.com>
Cc: Surath Mitra <smitra@nvidia.com>
Cc: Kirti Wankhede <kwankhede@nvidia.com>
Cc: Vinay Kabra <vkabra@nvidia.com>
Cc: Ankit Agrawal <ankita@nvidia.com>
Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 drivers/vfio/pci/nvidia-vgpu/Makefile      |   3 +
 drivers/vfio/pci/nvidia-vgpu/vfio.h        |  43 ++
 drivers/vfio/pci/nvidia-vgpu/vfio_access.c | 297 ++++++++++++
 drivers/vfio/pci/nvidia-vgpu/vfio_main.c   | 511 +++++++++++++++++++++
 drivers/vfio/pci/nvidia-vgpu/vgpu.c        |  22 +
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h    |   2 +-
 6 files changed, 877 insertions(+), 1 deletion(-)
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/vfio.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/vfio_access.c
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/vfio_main.c

diff --git a/drivers/vfio/pci/nvidia-vgpu/Makefile b/drivers/vfio/pci/nvidia-vgpu/Makefile
index fade9d49df97..99c47e2f436d 100644
--- a/drivers/vfio/pci/nvidia-vgpu/Makefile
+++ b/drivers/vfio/pci/nvidia-vgpu/Makefile
@@ -3,3 +3,6 @@ ccflags-y += -I$(srctree)/$(src)/include
 
 obj-$(CONFIG_NVIDIA_VGPU_MGR) += nvidia-vgpu-mgr.o
 nvidia-vgpu-mgr-y := vgpu_mgr.o vgpu.o vgpu_types.o rpc.o
+
+obj-$(CONFIG_NVIDIA_VGPU_VFIO_PCI) += nvidia-vgpu-vfio-pci.o
+nvidia-vgpu-vfio-pci-y := vfio_main.o vfio_access.o
diff --git a/drivers/vfio/pci/nvidia-vgpu/vfio.h b/drivers/vfio/pci/nvidia-vgpu/vfio.h
new file mode 100644
index 000000000000..fa6bbf81552d
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/vfio.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/*
+ * Copyright © 2024 NVIDIA Corporation
+ */
+
+#ifndef _NVIDIA_VGPU_VFIO_H__
+#define _NVIDIA_VGPU_VFIO_H__
+
+#include <linux/vfio_pci_core.h>
+
+#include <nvrm/nvtypes.h>
+#include <nvrm/common/sdk/nvidia/inc/ctrl/ctrla081.h>
+#include <nvrm/common/sdk/nvidia/inc/ctrl/ctrl2080/ctrl2080vgpumgrinternal.h>
+
+#include "vgpu_mgr.h"
+
+#define VGPU_CONFIG_PARAMS_MAX_LENGTH 1024
+#define DEVICE_CLASS_LENGTH 5
+#define PCI_CONFIG_SPACE_LENGTH 4096
+
+#define CAP_LIST_NEXT_PTR_MSIX 0x7c
+#define MSIX_CAP_SIZE   0xc
+
+struct nvidia_vgpu_vfio {
+	struct vfio_pci_core_device core_dev;
+	u8 config_space[PCI_CONFIG_SPACE_LENGTH];
+
+	void __iomem *bar0_map;
+
+	u8 **vgpu_types;
+	NVA081_CTRL_VGPU_INFO *curr_vgpu_type;
+	u32 num_vgpu_types;
+
+	struct nvidia_vgpu_mgr *vgpu_mgr;
+	struct nvidia_vgpu *vgpu;
+};
+
+void nvidia_vgpu_vfio_setup_config(struct nvidia_vgpu_vfio *nvdev);
+ssize_t nvidia_vgpu_vfio_access(struct nvidia_vgpu_vfio *nvdev,
+				char __user *buf, size_t count,
+				loff_t ppos, bool iswrite);
+
+#endif /* _NVIDIA_VGPU_VFIO_H__ */
diff --git a/drivers/vfio/pci/nvidia-vgpu/vfio_access.c b/drivers/vfio/pci/nvidia-vgpu/vfio_access.c
new file mode 100644
index 000000000000..320c72a07dbe
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/vfio_access.c
@@ -0,0 +1,297 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/*
+ * Copyright © 2024 NVIDIA Corporation
+ */
+
+#include <linux/string.h>
+#include <linux/pci.h>
+#include <linux/pci_regs.h>
+
+#include "vfio.h"
+
+void nvidia_vgpu_vfio_setup_config(struct nvidia_vgpu_vfio *nvdev)
+{
+	u8 *buffer = NULL;
+
+	memset(nvdev->config_space, 0, sizeof(nvdev->config_space));
+
+	/* Header type 0 (normal devices) */
+	*(u16 *)&nvdev->config_space[PCI_VENDOR_ID] = 0x10de;
+	*(u16 *)&nvdev->config_space[PCI_DEVICE_ID] =
+		FIELD_GET(GENMASK(31, 16), nvdev->curr_vgpu_type->vdevId);
+	*(u16 *)&nvdev->config_space[PCI_COMMAND] = 0x0000;
+	*(u16 *)&nvdev->config_space[PCI_STATUS] = 0x0010;
+
+	buffer = &nvdev->config_space[PCI_CLASS_REVISION];
+	pci_read_config_byte(nvdev->core_dev.pdev, PCI_CLASS_REVISION, buffer);
+
+	nvdev->config_space[PCI_CLASS_PROG] = 0; /* VGA-compatible */
+	nvdev->config_space[PCI_CLASS_DEVICE] = 0; /* VGA controller */
+	nvdev->config_space[PCI_CLASS_DEVICE + 1] = 3; /* display controller */
+
+	/* BAR0: 32-bit */
+	*(u32 *)&nvdev->config_space[PCI_BASE_ADDRESS_0] = 0x00000000;
+	/* BAR1: 64-bit, prefetchable */
+	*(u32 *)&nvdev->config_space[PCI_BASE_ADDRESS_1] = 0x0000000c;
+	/* BAR2: 64-bit, prefetchable */
+	*(u32 *)&nvdev->config_space[PCI_BASE_ADDRESS_3] = 0x0000000c;
+	/* Disable BAR3: I/O */
+	*(u32 *)&nvdev->config_space[PCI_BASE_ADDRESS_5] = 0x00000000;
+
+	*(u16 *)&nvdev->config_space[PCI_SUBSYSTEM_VENDOR_ID] = 0x10de;
+	*(u16 *)&nvdev->config_space[PCI_SUBSYSTEM_ID] =
+		FIELD_GET(GENMASK(15, 0), nvdev->curr_vgpu_type->vdevId);
+
+	nvdev->config_space[PCI_CAPABILITY_LIST] = CAP_LIST_NEXT_PTR_MSIX;
+	nvdev->config_space[CAP_LIST_NEXT_PTR_MSIX + 1] = 0x0;
+
+	/* INTx disabled */
+	nvdev->config_space[0x3d] = 0;
+}
+
+static void read_hw_pci_config(struct pci_dev *pdev, char *buf,
+			       size_t count, loff_t offset)
+{
+	switch (count) {
+	case 4:
+		pci_read_config_dword(pdev, offset, (u32 *)buf);
+		break;
+
+	case 2:
+		pci_read_config_word(pdev, offset, (u16 *)buf);
+		break;
+
+	case 1:
+		pci_read_config_byte(pdev, offset, (u8 *)buf);
+		break;
+	default:
+		WARN_ONCE(1, "Not supported access len\n");
+		break;
+	}
+}
+
+static void write_hw_pci_config(struct pci_dev *pdev, char *buf,
+				size_t count, loff_t offset)
+{
+	switch (count) {
+	case 4:
+		pci_write_config_dword(pdev, offset, *(u32 *)buf);
+		break;
+
+	case 2:
+		pci_write_config_word(pdev, offset, *(u16 *)buf);
+		break;
+
+	case 1:
+		pci_write_config_byte(pdev, offset, *(u8 *)buf);
+		break;
+	default:
+		WARN_ONCE(1, "Not supported access len\n");
+		break;
+	}
+}
+
+static void hw_pci_config_rw(struct pci_dev *pdev, char *buf,
+			     size_t count, loff_t offset,
+			     bool is_write)
+{
+	is_write ? write_hw_pci_config(pdev, buf, count, offset) :
+		   read_hw_pci_config(pdev, buf, count, offset);
+}
+
+static ssize_t bar0_rw(struct nvidia_vgpu_vfio *nvdev, char *buf,
+		       size_t count, loff_t ppos, bool iswrite)
+{
+	struct pci_dev *pdev = nvdev->core_dev.pdev;
+	int index = VFIO_PCI_OFFSET_TO_INDEX(ppos);
+	loff_t offset = ppos;
+	void __iomem *map;
+	u32 val;
+	int ret;
+
+	if (index != VFIO_PCI_BAR0_REGION_INDEX)
+		return -EINVAL;
+
+	offset &= VFIO_PCI_OFFSET_MASK;
+
+	if (nvdev->bar0_map == NULL) {
+		ret = pci_request_selected_regions(pdev, 1 << index, "nvidia-vgpu-vfio");
+		if (ret)
+			return ret;
+
+		if (!(pci_resource_flags(pdev, index) & IORESOURCE_MEM)) {
+			pci_release_selected_regions(pdev, 1 << index);
+			return -EIO;
+		}
+
+		map = ioremap(pci_resource_start(pdev, index), pci_resource_len(pdev, index));
+		if (!map) {
+			pci_err(pdev, "Can't map BAR0 MMIO space\n");
+			pci_release_selected_regions(pdev, 1 << index);
+			return -ENOMEM;
+		}
+		nvdev->bar0_map = map;
+	} else
+		map = nvdev->bar0_map;
+
+	if (!iswrite) {
+		switch (count) {
+		case 4:
+			val = ioread32(map + offset);
+			break;
+		case 2:
+			val = ioread16(map + offset);
+			break;
+		case 1:
+			val = ioread8(map + offset);
+			break;
+		}
+		memcpy(buf, (u8 *)&val, count);
+	} else {
+		switch (count) {
+		case 4:
+			iowrite32(*(u32 *)buf, map + offset);
+			break;
+		case 2:
+			iowrite16(*(u16 *)buf, map + offset);
+			break;
+		case 1:
+			iowrite8(*(u8 *)buf, map + offset);
+			break;
+		}
+	}
+	return count;
+}
+
+static ssize_t pci_config_rw(struct nvidia_vgpu_vfio *nvdev, char *buf,
+			     size_t count, loff_t ppos, bool iswrite)
+{
+	struct pci_dev *pdev = nvdev->core_dev.pdev;
+	int index = VFIO_PCI_OFFSET_TO_INDEX(ppos);
+	loff_t offset = ppos;
+	u32 bar_mask, cfg_addr;
+	u32 val = 0;
+
+	if (index != VFIO_PCI_CONFIG_REGION_INDEX)
+		return -EINVAL;
+
+	offset &= VFIO_PCI_OFFSET_MASK;
+
+	if ((offset >= CAP_LIST_NEXT_PTR_MSIX) && (offset <
+				(CAP_LIST_NEXT_PTR_MSIX + MSIX_CAP_SIZE))) {
+		hw_pci_config_rw(pdev, buf, count, offset, iswrite);
+		return count;
+	}
+
+	if (!iswrite) {
+		memcpy(buf, (u8 *)&nvdev->config_space[offset], count);
+
+		switch (offset) {
+		case PCI_COMMAND:
+			hw_pci_config_rw(pdev, (char *)&val, count, offset, iswrite);
+
+			switch (count) {
+			case 4:
+				val = (u32)(val & 0xFFFF0000) | (val &
+					(PCI_COMMAND_PARITY | PCI_COMMAND_SERR));
+				break;
+			case 2:
+				val = (val & (PCI_COMMAND_PARITY | PCI_COMMAND_SERR));
+				break;
+			default:
+				WARN_ONCE(1, "Not supported access len\n");
+				break;
+			}
+			break;
+		case PCI_STATUS:
+			hw_pci_config_rw(pdev, (char *)&val, count, offset, iswrite);
+			break;
+
+		default:
+			break;
+		}
+		*(u32 *)buf = *(u32 *)buf | val;
+	} else {
+		switch (offset) {
+		case PCI_VENDOR_ID:
+		case PCI_DEVICE_ID:
+		case PCI_CAPABILITY_LIST:
+			break;
+
+		case PCI_STATUS:
+			hw_pci_config_rw(pdev, buf, count, offset, iswrite);
+			break;
+
+		case PCI_COMMAND:
+			if (count == 4) {
+				val = (u32)((*(u32 *)buf & 0xFFFF0000) >> 16);
+				hw_pci_config_rw(pdev, (char *)&val, 2, PCI_STATUS, iswrite);
+
+				val = (u32)(*(u32 *)buf & 0x0000FFFF);
+				*(u32 *)buf = val;
+			}
+
+			memcpy((u8 *)&nvdev->config_space[offset], buf, count);
+			break;
+
+		case PCI_BASE_ADDRESS_0:
+		case PCI_BASE_ADDRESS_1:
+		case PCI_BASE_ADDRESS_2:
+		case PCI_BASE_ADDRESS_3:
+		case PCI_BASE_ADDRESS_4:
+			cfg_addr = *(u32 *)buf;
+
+			switch (offset) {
+			case PCI_BASE_ADDRESS_0:
+				bar_mask = (u32)((~(pci_resource_len(pdev, VFIO_PCI_BAR0_REGION_INDEX)) + 1) & ~0xFul);
+				cfg_addr = (cfg_addr & bar_mask) | (nvdev->config_space[offset] & 0xFul);
+				break;
+			case PCI_BASE_ADDRESS_1:
+				bar_mask = (u32)((~(nvdev->curr_vgpu_type->bar1Length * 1024 * 1024) + 1) & ~0xFul);
+				cfg_addr = (cfg_addr & bar_mask) | (nvdev->config_space[offset] & 0xFul);
+				break;
+
+			case PCI_BASE_ADDRESS_2:
+				bar_mask = (u32)(((~(nvdev->curr_vgpu_type->bar1Length * 1024 * 1024) + 1) & ~0xFul) >> 32);
+				cfg_addr = (cfg_addr & bar_mask);
+				break;
+
+			case PCI_BASE_ADDRESS_3:
+				bar_mask = (u32)((~(pci_resource_len(pdev, VFIO_PCI_BAR3_REGION_INDEX)) + 1) & ~0xFul);
+				cfg_addr = (cfg_addr & bar_mask) | (nvdev->config_space[offset] & 0xFul);
+				break;
+
+			case PCI_BASE_ADDRESS_4:
+				bar_mask = (u32)(((~(pci_resource_len(pdev, VFIO_PCI_BAR3_REGION_INDEX)) + 1) & ~0xFul) >> 32);
+				cfg_addr = (cfg_addr & bar_mask);
+				break;
+			}
+			*(u32 *)&nvdev->config_space[offset] = cfg_addr;
+			break;
+		default:
+			break;
+
+		}
+	}
+	return count;
+}
+
+ssize_t nvidia_vgpu_vfio_access(struct nvidia_vgpu_vfio *nvdev, char *buf,
+				size_t count, loff_t ppos, bool iswrite)
+{
+	int index = VFIO_PCI_OFFSET_TO_INDEX(ppos);
+
+	if (index >= VFIO_PCI_NUM_REGIONS)
+		return -EINVAL;
+
+	switch (index) {
+	case VFIO_PCI_CONFIG_REGION_INDEX:
+		return pci_config_rw(nvdev, buf, count, ppos,
+				     iswrite);
+	case VFIO_PCI_BAR0_REGION_INDEX:
+		return bar0_rw(nvdev, buf, count, ppos, iswrite);
+	default:
+		return -EINVAL;
+	}
+	return count;
+}
diff --git a/drivers/vfio/pci/nvidia-vgpu/vfio_main.c b/drivers/vfio/pci/nvidia-vgpu/vfio_main.c
new file mode 100644
index 000000000000..667ed6fb48f6
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/vfio_main.c
@@ -0,0 +1,511 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/*
+ * Copyright © 2024 NVIDIA Corporation
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <linux/vfio_pci_core.h>
+#include <linux/types.h>
+
+#include "vfio.h"
+
+static int pdev_to_gfid(struct pci_dev *pdev)
+{
+	return pci_iov_vf_id(pdev) + 1;
+}
+
+static int destroy_vgpu(struct nvidia_vgpu_vfio *nvdev)
+{
+	int ret;
+
+	ret = nvidia_vgpu_mgr_destroy_vgpu(nvdev->vgpu);
+	if (ret)
+		return ret;
+
+	kfree(nvdev->vgpu);
+	nvdev->vgpu = NULL;
+	return 0;
+}
+
+static int create_vgpu(struct nvidia_vgpu_vfio *nvdev)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = nvdev->vgpu_mgr;
+	struct pci_dev *pdev = nvdev->core_dev.pdev;
+	struct nvidia_vgpu *vgpu;
+	int ret;
+
+	vgpu = kzalloc(sizeof(*vgpu), GFP_KERNEL);
+	if (!vgpu)
+		return -ENOMEM;
+
+	vgpu->info.id = pci_iov_vf_id(pdev);
+	vgpu->info.dbdf = (0 << 16) | pci_dev_id(pdev);
+	vgpu->info.gfid = pdev_to_gfid(pdev);
+
+	vgpu->vgpu_mgr = vgpu_mgr;
+	vgpu->pdev = pdev;
+
+	ret = nvidia_vgpu_mgr_create_vgpu(vgpu,
+			(u8 *)nvdev->curr_vgpu_type);
+	if (ret) {
+		kfree(vgpu);
+		return ret;
+	}
+
+	pr_err("create_vgpu() called\n");
+	nvdev->vgpu = vgpu;
+	return 0;
+}
+
+static inline struct vfio_pci_core_device *
+vdev_to_core_dev(struct vfio_device *vdev)
+{
+	return container_of(vdev, struct vfio_pci_core_device, vdev);
+}
+
+static inline struct nvidia_vgpu_vfio *
+core_dev_to_nvdev(struct vfio_pci_core_device *core_dev)
+{
+	return container_of(core_dev, struct nvidia_vgpu_vfio, core_dev);
+}
+
+static void detach_vgpu_mgr(struct nvidia_vgpu_vfio *nvdev)
+{
+	nvidia_vgpu_mgr_put(nvdev->vgpu_mgr);
+
+	nvdev->vgpu_mgr = NULL;
+	nvdev->vgpu_types = NULL;
+	nvdev->num_vgpu_types = 0;
+}
+
+static int attach_vgpu_mgr(struct nvidia_vgpu_vfio *nvdev,
+			   struct pci_dev *pdev)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr;
+
+	vgpu_mgr = nvidia_vgpu_mgr_get(pdev);
+	if (IS_ERR(vgpu_mgr))
+		return PTR_ERR(vgpu_mgr);
+
+	nvdev->vgpu_mgr = vgpu_mgr;
+	nvdev->vgpu_types = nvdev->vgpu_mgr->vgpu_types;
+	nvdev->num_vgpu_types = nvdev->vgpu_mgr->num_vgpu_types;
+
+	return 0;
+}
+
+static NVA081_CTRL_VGPU_INFO *
+find_vgpu_type(struct nvidia_vgpu_vfio *nvdev, u32 type_id)
+{
+	NVA081_CTRL_VGPU_INFO *vgpu_type;
+	u32 i;
+
+	for (i = 0; i < nvdev->num_vgpu_types; i++) {
+		vgpu_type = (NVA081_CTRL_VGPU_INFO *)nvdev->vgpu_types[i];
+		if (vgpu_type->vgpuType == type_id)
+			return vgpu_type;
+	}
+
+	return NULL;
+}
+
+static int
+nvidia_vgpu_vfio_open_device(struct vfio_device *vdev)
+{
+	struct vfio_pci_core_device *core_dev = vdev_to_core_dev(vdev);
+	struct nvidia_vgpu_vfio *nvdev = core_dev_to_nvdev(core_dev);
+	struct pci_dev *pdev = core_dev->pdev;
+	u64 pf_dma_mask;
+	int ret;
+
+	if (!nvdev->curr_vgpu_type)
+		return -ENODEV;
+
+	if (!pdev->physfn)
+		return -EINVAL;
+
+	ret = create_vgpu(nvdev);
+	if (ret)
+		return ret;
+
+	ret = pci_enable_device(pdev);
+	if (ret)
+		goto err_enable_device;
+
+	pci_set_master(pdev);
+
+	pf_dma_mask = dma_get_mask(&pdev->physfn->dev);
+	dma_set_mask(&pdev->dev, pf_dma_mask);
+	dma_set_coherent_mask(&pdev->dev, pf_dma_mask);
+
+	ret = pci_try_reset_function(pdev);
+	if (ret)
+		goto err_reset_function;
+
+	ret = nvidia_vgpu_mgr_enable_bme(nvdev->vgpu);
+	if (ret)
+		goto err_enable_bme;
+
+	return 0;
+
+err_enable_bme:
+err_reset_function:
+	pci_clear_master(pdev);
+	pci_disable_device(pdev);
+err_enable_device:
+	destroy_vgpu(nvdev);
+	return ret;
+}
+
+static void
+nvidia_vgpu_vfio_close_device(struct vfio_device *vdev)
+{
+	struct vfio_pci_core_device *core_dev = vdev_to_core_dev(vdev);
+	struct nvidia_vgpu_vfio *nvdev = core_dev_to_nvdev(core_dev);
+	struct pci_dev *pdev = core_dev->pdev;
+
+	WARN_ON(destroy_vgpu(nvdev));
+
+	if (nvdev->bar0_map) {
+		iounmap(nvdev->bar0_map);
+		pci_release_selected_regions(pdev, 1 << 0);
+		nvdev->bar0_map = NULL;
+	}
+
+	pci_clear_master(pdev);
+	pci_disable_device(pdev);
+}
+
+static int
+get_region_info(struct vfio_pci_core_device *core_dev, unsigned long arg)
+{
+	struct nvidia_vgpu_vfio *nvdev = core_dev_to_nvdev(core_dev);
+	struct pci_dev *pdev = core_dev->pdev;
+	struct vfio_region_info info;
+	unsigned long minsz;
+	int ret = 0;
+
+	minsz = offsetofend(struct vfio_region_info, offset);
+	if (copy_from_user(&info, (void __user *)arg, minsz))
+		return -EINVAL;
+
+	if (info.argsz < minsz)
+		return -EINVAL;
+
+	switch (info.index) {
+	case VFIO_PCI_CONFIG_REGION_INDEX:
+		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+		info.size = PCI_CONFIG_SPACE_LENGTH;
+		info.flags = VFIO_REGION_INFO_FLAG_READ |
+			VFIO_REGION_INFO_FLAG_WRITE;
+		break;
+
+	case VFIO_PCI_BAR0_REGION_INDEX ... VFIO_PCI_BAR4_REGION_INDEX:
+		struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
+
+		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+		info.size = pci_resource_len(pdev, info.index);
+
+		if (info.index == VFIO_PCI_BAR1_REGION_INDEX)
+			info.size = nvdev->curr_vgpu_type->bar1Length * 1024 * 1024;
+
+		if (!info.size) {
+			info.flags = 0;
+			break;
+		}
+		info.flags = VFIO_REGION_INFO_FLAG_READ |
+			VFIO_REGION_INFO_FLAG_WRITE |
+			VFIO_REGION_INFO_FLAG_MMAP;
+
+		if (caps.size) {
+			info.flags |= VFIO_REGION_INFO_FLAG_CAPS;
+			if (info.argsz < sizeof(info) + caps.size) {
+				info.argsz = sizeof(info) + caps.size;
+				info.cap_offset = 0;
+			} else {
+				vfio_info_cap_shift(&caps, sizeof(info));
+				if (copy_to_user((void __user *)arg +
+							sizeof(info), caps.buf,
+							caps.size)) {
+					kfree(caps.buf);
+					ret = -EFAULT;
+					break;
+				}
+				info.cap_offset = sizeof(info);
+			}
+			kfree(caps.buf);
+		}
+		break;
+	case VFIO_PCI_BAR5_REGION_INDEX:
+	case VFIO_PCI_ROM_REGION_INDEX:
+	case VFIO_PCI_VGA_REGION_INDEX:
+		info.size = 0;
+		break;
+
+	default:
+		if (info.index >= VFIO_PCI_NUM_REGIONS)
+			ret = -EINVAL;
+		break;
+	}
+
+	if (!ret)
+		ret = copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
+
+	return ret;
+}
+
+static long nvidia_vgpu_vfio_ioctl(struct vfio_device *vdev,
+				   unsigned int cmd,
+				   unsigned long arg)
+{
+	struct vfio_pci_core_device *core_dev = vdev_to_core_dev(vdev);
+	struct nvidia_vgpu_vfio *nvdev = core_dev_to_nvdev(core_dev);
+	int ret = 0;
+
+	if (!nvdev->curr_vgpu_type)
+		return -ENODEV;
+
+	switch (cmd) {
+	case VFIO_DEVICE_GET_REGION_INFO:
+		ret = get_region_info(core_dev, arg);
+		break;
+	case VFIO_DEVICE_GET_PCI_HOT_RESET_INFO:
+	case VFIO_DEVICE_PCI_HOT_RESET:
+	case VFIO_DEVICE_RESET:
+		break;
+
+	default:
+		ret = vfio_pci_core_ioctl(vdev, cmd, arg);
+		break;
+	}
+
+	return ret;
+}
+
+static ssize_t nvidia_vgpu_vfio_read(struct vfio_device *vdev,
+				     char __user *buf, size_t count,
+				     loff_t *ppos)
+{
+	struct vfio_pci_core_device *core_dev = vdev_to_core_dev(vdev);
+	struct nvidia_vgpu_vfio *nvdev = core_dev_to_nvdev(core_dev);
+	u64 val;
+	size_t done = 0;
+	int ret = 0, size;
+
+	if (!nvdev->curr_vgpu_type)
+		return -ENODEV;
+
+	while (count) {
+		if (count >= 4 && !(*ppos % 4))
+			size = 4;
+		else if (count >= 2 && !(*ppos % 2))
+			size = 2;
+		else
+			size = 1;
+
+		ret = nvidia_vgpu_vfio_access(nvdev, (char *)&val, size, *ppos, false);
+
+		if (ret <= 0)
+			return ret;
+
+		if (copy_to_user(buf, &val, size) != 0)
+			return -EFAULT;
+
+		*ppos += size;
+		buf += size;
+		count -= size;
+		done += size;
+	}
+
+	return done;
+}
+
+static ssize_t nvidia_vgpu_vfio_write(struct vfio_device *vdev,
+				      const char __user *buf, size_t count,
+				      loff_t *ppos)
+{
+	struct vfio_pci_core_device *core_dev = vdev_to_core_dev(vdev);
+	struct nvidia_vgpu_vfio *nvdev = core_dev_to_nvdev(core_dev);
+	u64 val;
+	size_t done = 0;
+	int ret = 0, size;
+
+	if (!nvdev->curr_vgpu_type)
+		return -ENODEV;
+
+	while (count) {
+		if (count >= 4 && !(*ppos % 4))
+			size = 4;
+		else if (count >= 2 && !(*ppos % 2))
+			size = 2;
+		else
+			size = 1;
+
+		if (copy_from_user(&val, buf, size) != 0)
+			return -EFAULT;
+
+		ret = nvidia_vgpu_vfio_access(nvdev, (char *)&val, size, *ppos, true);
+
+		if (ret <= 0)
+			return ret;
+
+		*ppos += size;
+		buf += size;
+		count -= size;
+		done += size;
+	}
+
+	return done;
+}
+
+static int nvidia_vgpu_vfio_mmap(struct vfio_device *vdev,
+				 struct vm_area_struct *vma)
+{
+	struct vfio_pci_core_device *core_dev = vdev_to_core_dev(vdev);
+	struct nvidia_vgpu_vfio *nvdev = core_dev_to_nvdev(core_dev);
+	struct pci_dev *pdev = core_dev->pdev;
+	u64 phys_len, req_len, pgoff, req_start;
+	unsigned int index;
+
+	if (!nvdev->curr_vgpu_type)
+		return -ENODEV;
+
+	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
+
+	if (index >= VFIO_PCI_BAR5_REGION_INDEX)
+		return -EINVAL;
+	if (vma->vm_end < vma->vm_start)
+		return -EINVAL;
+	if ((vma->vm_flags & VM_SHARED) == 0)
+		return -EINVAL;
+
+	phys_len = PAGE_ALIGN(pci_resource_len(pdev, index));
+	req_len = vma->vm_end - vma->vm_start;
+	pgoff = vma->vm_pgoff &
+		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
+	req_start = pgoff << PAGE_SHIFT;
+
+	if (req_len == 0)
+		return -EINVAL;
+
+	if ((req_start + req_len > phys_len) || (phys_len == 0))
+		return -EINVAL;
+
+	vma->vm_private_data = vdev;
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	vma->vm_pgoff = (pci_resource_start(pdev, index) >> PAGE_SHIFT) + pgoff;
+	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
+
+	return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff, req_len, vma->vm_page_prot);
+}
+
+static const struct vfio_device_ops nvidia_vgpu_vfio_ops = {
+	.name           = "nvidia-vgpu-vfio-pci",
+	.init		= vfio_pci_core_init_dev,
+	.release	= vfio_pci_core_release_dev,
+	.open_device    = nvidia_vgpu_vfio_open_device,
+	.close_device   = nvidia_vgpu_vfio_close_device,
+	.ioctl          = nvidia_vgpu_vfio_ioctl,
+	.device_feature = vfio_pci_core_ioctl_feature,
+	.read           = nvidia_vgpu_vfio_read,
+	.write          = nvidia_vgpu_vfio_write,
+	.mmap           = nvidia_vgpu_vfio_mmap,
+	.request	= vfio_pci_core_request,
+	.match		= vfio_pci_core_match,
+	.bind_iommufd	= vfio_iommufd_physical_bind,
+	.unbind_iommufd	= vfio_iommufd_physical_unbind,
+	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
+	.detach_ioas	= vfio_iommufd_physical_detach_ioas,
+};
+
+static int setup_vgpu_type(struct nvidia_vgpu_vfio *nvdev)
+{
+	nvdev->curr_vgpu_type = find_vgpu_type(nvdev, 869);
+	if (!nvdev->curr_vgpu_type)
+		return -ENODEV;
+	return 0;
+}
+
+static int nvidia_vgpu_vfio_probe(struct pci_dev *pdev,
+				  const struct pci_device_id *id_table)
+{
+	struct nvidia_vgpu_vfio *nvdev;
+	int ret;
+
+	if (!pdev->is_virtfn)
+		return -EINVAL;
+
+	nvdev = vfio_alloc_device(nvidia_vgpu_vfio, core_dev.vdev,
+				  &pdev->dev, &nvidia_vgpu_vfio_ops);
+	if (IS_ERR(nvdev))
+		return PTR_ERR(nvdev);
+
+	ret = attach_vgpu_mgr(nvdev, pdev);
+	if (ret)
+		goto err_attach_vgpu_mgr;
+
+	ret = setup_vgpu_type(nvdev);
+	if (ret)
+		goto err_setup_vgpu_type;
+
+	nvidia_vgpu_vfio_setup_config(nvdev);
+
+	dev_set_drvdata(&pdev->dev, &nvdev->core_dev);
+
+	ret = vfio_pci_core_register_device(&nvdev->core_dev);
+	if (ret)
+		goto err_setup_vgpu_type;
+
+	return 0;
+
+err_setup_vgpu_type:
+	detach_vgpu_mgr(nvdev);
+
+err_attach_vgpu_mgr:
+	vfio_put_device(&nvdev->core_dev.vdev);
+
+	pci_err(pdev, "VF probe failed with ret: %d\n", ret);
+	return ret;
+}
+
+static void nvidia_vgpu_vfio_remove(struct pci_dev *pdev)
+{
+	struct vfio_pci_core_device *core_dev = dev_get_drvdata(&pdev->dev);
+	struct nvidia_vgpu_vfio *nvdev = core_dev_to_nvdev(core_dev);
+
+	vfio_pci_core_unregister_device(core_dev);
+	detach_vgpu_mgr(nvdev);
+	vfio_put_device(&core_dev->vdev);
+}
+
+struct pci_device_id nvidia_vgpu_vfio_table[] = {
+	{
+		.vendor      = PCI_VENDOR_ID_NVIDIA,
+		.device      = PCI_ANY_ID,
+		.subvendor   = PCI_ANY_ID,
+		.subdevice   = PCI_ANY_ID,
+		.class       = (PCI_CLASS_DISPLAY_3D << 8),
+		.class_mask  = ~0,
+	},
+	{ }
+};
+MODULE_DEVICE_TABLE(pci, nvidia_vgpu_vfio_table);
+
+struct pci_driver nvidia_vgpu_vfio_driver = {
+	.name               = "nvidia-vgpu-vfio",
+	.id_table           = nvidia_vgpu_vfio_table,
+	.probe              = nvidia_vgpu_vfio_probe,
+	.remove             = nvidia_vgpu_vfio_remove,
+	.driver_managed_dma = true,
+};
+
+module_pci_driver(nvidia_vgpu_vfio_driver);
+
+MODULE_LICENSE("Dual MIT/GPL");
+MODULE_AUTHOR("Vinay Kabra <vkabra@nvidia.com>");
+MODULE_AUTHOR("Kirti Wankhede <kwankhede@nvidia.com>");
+MODULE_AUTHOR("Zhi Wang <zhiw@nvidia.com>");
+MODULE_DESCRIPTION("NVIDIA vGPU VFIO Variant Driver - User Level driver for NVIDIA vGPU");
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu.c b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
index 93d27db30a41..003ca116b4a8 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu.c
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
@@ -328,3 +328,25 @@ int nvidia_vgpu_mgr_create_vgpu(struct nvidia_vgpu *vgpu, u8 *vgpu_type)
 	return ret;
 }
 EXPORT_SYMBOL(nvidia_vgpu_mgr_create_vgpu);
+
+static int update_bme_state(struct nvidia_vgpu *vgpu)
+{
+	NV_VGPU_CPU_RPC_DATA_UPDATE_BME_STATE params = {0};
+
+	params.enable = true;
+
+	return nvidia_vgpu_rpc_call(vgpu, NV_VGPU_CPU_RPC_MSG_UPDATE_BME_STATE,
+				    &params, sizeof(params));
+}
+
+/**
+ * nvidia_vgpu_enable_bme - handle BME sequence
+ * @vf: the vGPU instance
+ *
+ * Returns: 0 on success, others on failure.
+ */
+int nvidia_vgpu_mgr_enable_bme(struct nvidia_vgpu *vgpu)
+{
+	return update_bme_state(vgpu);
+}
+EXPORT_SYMBOL(nvidia_vgpu_mgr_enable_bme);
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
index af922d8e539c..2c9e0eebcb99 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
@@ -84,6 +84,6 @@ int nvidia_vgpu_rpc_call(struct nvidia_vgpu *vgpu, u32 msg_type,
 void nvidia_vgpu_clean_rpc(struct nvidia_vgpu *vgpu);
 int nvidia_vgpu_setup_rpc(struct nvidia_vgpu *vgpu);
 
-int nvidia_vgpu_mgr_reset_vgpu(struct nvidia_vgpu *vgpu);
+int nvidia_vgpu_mgr_enable_bme(struct nvidia_vgpu *vgpu);
 
 #endif
-- 
2.34.1


