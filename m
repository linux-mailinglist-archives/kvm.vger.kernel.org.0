Return-Path: <kvm+bounces-56714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D2A83B42C9E
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 00:12:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E0C731BC6464
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 22:13:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D82D34DCD5;
	Wed,  3 Sep 2025 22:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="as7EE88Q"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2060.outbound.protection.outlook.com [40.107.243.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818443054EA
	for <kvm@vger.kernel.org>; Wed,  3 Sep 2025 22:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756937512; cv=fail; b=S7loqUJeexSL2Z626PRFAsUUjjRR8d/8DjbhMYZkzQvv1XtXPZ47lFAGZ4g6XOVMhR8EmVhRfW+JL4S3Pau49YaytqAkBcroyl0fZDyJHs3wYAxdmV+/vrG/yrp9brwQtKrl2s0WRLjQSyzJW+B1Y0uLRWM21qAEfOnhOF42BZo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756937512; c=relaxed/simple;
	bh=elST+9db2XcOK068oQjot1w0Pj0c8gttWCn6ljSIzXo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PcjsdZP0U7qAN7pSWqJsnAo0DtBXpJoYf0ky+vLfhINvZ9agM1mlUIXfqYX6oKoNGoh6WtkxImb2Y9DwsH2R8Ctx8JVgnGXYAHCbq55G6A10KZy2jfI3lAMYIyM9liPy6BXJZf5qZQ/BDCcf0rw7Ti7q/kc9ydBzegWJYRAFcVY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=as7EE88Q; arc=fail smtp.client-ip=40.107.243.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EWbDfuhlvyoLzAGQzEfWnUzSHmXjLHQEPNL2S2GwREOMvVJkVQLkfcHG8Kv+alqoNmEXJ5MDR/33UeB5SCbs+HJtRivuKlf0iGE4ydRlxua1ZdT2Zxtn2GhXiAh95zTzhgQY5neaN+GT0m0y28YZPD2/keo2kHCyXpDio2MpcsZPJ5/EscCNIysr7N2gVyALCVOyR9yzEw4nFEpeHrORj/jQVhABa/L+xykwAmOsc9ELy/9wRLWw2DlH+xgY4udI48oCIOAVvLqaqL6Sm6AdGlDx+pIkLvUPTxznmEqZwMW4N/3aB24eUmrNDIq3TMivstAVk2k1WHnBklGbeSZbaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mSP5xnK5ITEA5opFnOdcKerUD6I6n+rUUn/BLFrTdcw=;
 b=tZkUPNlz7hV5EGG0HSt+wO9W5SZtqucuAgW0nImn8hnOQ+n/z7k1qpMOyJkE8GDYAfuhhHg+Em7eT9oklZSxyZFCB90Hw8uP9LYnfQ/ixxduaZ1B8E7N4PF62ntIQKlJ8EsuEQko5sG2ocnrnD8WqngDcTxhj6z4pZGXsLqRBein9bb9qESjkyzxaVsyPevhGbjjNMlqdKMKTtRrGj0gIpZPnMHHSAtlnUAGGAGwdDn6pGXy6Z9LkMu4fB7500v/8B2pIy+l0dqeThziCYv3mamaoDGJHf+4pHndMMu78PJXPleE156ACAf0xX9kRdh1Ag3nfQgXWwGhxDoxCcaKmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mSP5xnK5ITEA5opFnOdcKerUD6I6n+rUUn/BLFrTdcw=;
 b=as7EE88QXl5d5Kn8Gp+ia9qVfyCPXvReT/w5Y1spjY/A4k3QwPOtsl3XNWdOFgantUz0nsR2k8D1u/4cSQhSHE6FHonixImlYoXev9CsgAvtSytyWmEgzJA0c4NpLt6BiP5uIVDBIuTGJ2zpv4QZby/P5Ss7X0tTZmjHKin+AqoT+ljqZGf/8s9YOhO3x1qVb0pJdLt0ZQBsd7KFQbsbhc2e7xBNzpZl5NmHJux7lnYskFuTdiS4BmaIji9GtCiX1X6x3UH4Q8ippWvsuuvf/dNRgqOTpEAP6fEOEUXs7inl1z+4feDNejia45XM7VZaLT/c7yEV2lQtT84Az2nlMg==
Received: from CH0PR08CA0007.namprd08.prod.outlook.com (2603:10b6:610:33::12)
 by LV2PR12MB5967.namprd12.prod.outlook.com (2603:10b6:408:170::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Wed, 3 Sep
 2025 22:11:34 +0000
Received: from CH3PEPF00000010.namprd04.prod.outlook.com
 (2603:10b6:610:33:cafe::a) by CH0PR08CA0007.outlook.office365.com
 (2603:10b6:610:33::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.17 via Frontend Transport; Wed,
 3 Sep 2025 22:11:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH3PEPF00000010.mail.protection.outlook.com (10.167.244.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Wed, 3 Sep 2025 22:11:34 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 15:11:20 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 15:11:20 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Wed, 3 Sep 2025 15:11:19 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <dakr@kernel.org>,
	<acurrid@nvidia.com>, <cjia@nvidia.com>, <smitra@nvidia.com>,
	<ankita@nvidia.com>, <aniketa@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC v2 11/14] vfio/nvidia-vgpu: introduce NVIDIA vGPU VFIO variant driver
Date: Wed, 3 Sep 2025 15:11:08 -0700
Message-ID: <20250903221111.3866249-12-zhiw@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250903221111.3866249-1-zhiw@nvidia.com>
References: <20250903221111.3866249-1-zhiw@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000010:EE_|LV2PR12MB5967:EE_
X-MS-Office365-Filtering-Correlation-Id: a944ba96-c337-44b7-8dd5-08ddeb36d852
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cldJSUFtc3BTSFd4WkpZVjYyOWtCamxhbDJjOG9PN2ZOczQ0dkF3QzJVRUYx?=
 =?utf-8?B?ZmFzS2Qycnh4TG9xTXNhUGtSNFE2VXVJLzE1cjhEb0ZnVVQ0Mko2VGVCUUxt?=
 =?utf-8?B?OUZrUk5ROGd4dmpjUzIrdXJLVDlHUExiTXZXT2pvbzhDdTUwS3hrdm9pKzEy?=
 =?utf-8?B?N280c1ZjMjlWZW53eS8raTZCdURoVGNmUGFudDhYb0VqQ1dPWTdTcnF5dEpI?=
 =?utf-8?B?cVQ0ZTJVNEczZzB4YUNGNjRnL0sxdFhhdmFEcVVFaS93NnVUL2JOWDhiaVkr?=
 =?utf-8?B?MzhhdmpHRTl1N3pPd3dOZm5WcUgwWXlXcHo4L1c3L3l2VXlUYnY1L0tiM1NC?=
 =?utf-8?B?RCtZZmp3cWtJenFtNkFmZVo1dzNaYkdqa296SXBXcEE0UG9wbXQ1TGlUMjBS?=
 =?utf-8?B?SEoxS2xZWmVzK0VsMWM5dlRmaDViSjZVWjdKSHJ4UnM0cm5YODhVanlHQkhC?=
 =?utf-8?B?MlJKMDZReVgyQU9aZUNWbkllNENSTmRJNWJZMmNwRkFKeHplc0ZoWmJ0T2Zy?=
 =?utf-8?B?bXoxeFVETHJRZzVubWZSNCtqbmR6a0FraXAvVlpwU2xsL3RXVDcxODVnV2kz?=
 =?utf-8?B?alFqT1BHZkVpc0VWNm5sTE9LTmxNakxUTU9JOWVaY1VlSXNWZHhBbkhGd21n?=
 =?utf-8?B?RmNSaXV3VzFqVnc1Y1Jldk02YjZ2Q2JHL3NFTjEzZndHYVFEZm0vQlJQVVow?=
 =?utf-8?B?Ujh6MXFZdkVPYlBWdG1ucUZYUEl4VDBZY2NLUldkSEF6RWpQaEhXV3RLNitV?=
 =?utf-8?B?T0prN0Y5cmovY3BUeGpZWFhMWmRPcDZXcjhXaWE4M3NOZ2lENk1KN3hMWWo2?=
 =?utf-8?B?ZWg3UlgrVlgwSVpaeC9QRnh6a2pFa016MzQvK2JRUUdmckNhODVyWFlBb1lN?=
 =?utf-8?B?cXJPZWU3cGpJSDV2RTV5NkxOR2xIMFNLZC9PZHpsb1hCbDIwVjlmbXRSQ0ZX?=
 =?utf-8?B?MHV0aHpkSER6a2l6cVZjQ3g1b3R6ODRFUTlpR1ROclBGQWpHcFdFMURlWnNX?=
 =?utf-8?B?bU1YOUZXSnRVRGtOakhNOFovS09vQWRKb1ZJUnlpU0twU3N2VjFvVXBsKzFw?=
 =?utf-8?B?ZS93blIxRWZzZUE2aFQvS0kyRGFDYnFnTVNlUktsUkI3Z3Z4UndOUmNoa2dq?=
 =?utf-8?B?RHVXQTdnK1BESkEvTDZCSFIwNExrSDlBMTNESVJuRzF2bzFJWWhXckJKMjNm?=
 =?utf-8?B?L3BNZ25kRTZCWTN1Z0ZOY2UzNFI0b0xJR09RUEs4UDVTdWl4T1pLTWZrdXBx?=
 =?utf-8?B?L0lDODZ6cjkrbDhVMXJ0dWwxSUpqcklmUXo1YkFrcnprcGtOaTdURlU2Zll6?=
 =?utf-8?B?VE9vRk1MTG5PVHN0ZDRuc1MxUHJvbVFPUE1TczkyL2MrUmJqWnZBOEdjdHYx?=
 =?utf-8?B?SG1xN1ZwTlVHd1kyVm9XdmQ2ZVFIYUorMW1hRUtyVXhaSGZvRitEdTVEc3Uw?=
 =?utf-8?B?SnpOc281YzRZWlVuMXd1THhyVFJGRHJQaUtmTHVvVkxnYjJSU0tWcWNGK0R4?=
 =?utf-8?B?MzVsSU96VnovYjZiUGNRa1d2VlNxOVF2enR3KzEzSnlzN1lpRUJZS1ZCajNP?=
 =?utf-8?B?eHR2TUlkeFprOXNuRFNzZzd3MUVFWnppRmw2VzErSHQ3RnhCRHltQ2RzeG5W?=
 =?utf-8?B?Y0N5TlRTVDloaWlpQUZPQnNobkQ5TDd5Si9jYXVDbDlLb3J4ekFKbjV6aFNQ?=
 =?utf-8?B?T0pZdkxVdVRZRE1nRFJHdFI4MHZYV1F5SVhPQ21XVTZPZ2JCMXRIQ2lRbGR1?=
 =?utf-8?B?MnVNTjFhRW0vcWNVR1VETGpPZ3h2Z3RpbnZ4ZXJaNmYyVEFUejRIRXY1MGRu?=
 =?utf-8?B?QndXSFNsZmRzMktUd1BnMUU1Smx3bUdGTVIzK3UrTnlBeFdDM2ViT1BWUURm?=
 =?utf-8?B?L0l2QmFWVDBTaE5Jb2Q5bkNEdWQ5TTJnZDFFUTMvTGE2eW1jSml2czV5bk5O?=
 =?utf-8?B?Z015cE9GUmhaWmFsQ0p1L0JJR3k4RzdwTk4zaTk0WDFqOTFvMmdtbzNiU09N?=
 =?utf-8?B?eXVyejdvYjRIQXdqNnh1RzlMRDUybmlTUmVKZkpEeXByeHBaWE1WZ1Q1QWgy?=
 =?utf-8?Q?MF6A7c?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 22:11:34.4845
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a944ba96-c337-44b7-8dd5-08ddeb36d852
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000010.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5967

A VFIO variant driver module is designed to extend the capabilities of
the existing VFIO (Virtual Function I/O), offering device management
interfaces to the userspace and advanced feature support.

For the userspace to use the NVIDIA vGPU, a new vGPU VFIO variant driver
is introduced to provide vGPU management, like selecting/creating vGPU
instance, support advance features like live migration.

Introduce the NVIDIA vGPU VFIO variant driver to support vGPU lifecycle
management UABI and the future advancd features.

Cc: Aniket Agashe <aniketa@nvidia.com>
Cc: Ankit Agrawal <ankita@nvidia.com>
Signed-off-by: Zhi Wang <zhiw@nvidia.com>
---
 .../ABI/stable/sysfs-driver-nvidia-vgpu       |  11 +
 drivers/vfio/pci/nvidia-vgpu/Makefile         |   3 +-
 drivers/vfio/pci/nvidia-vgpu/debug.h          |  10 +
 drivers/vfio/pci/nvidia-vgpu/vfio.h           |  49 ++
 drivers/vfio/pci/nvidia-vgpu/vfio_access.c    | 313 ++++++++
 drivers/vfio/pci/nvidia-vgpu/vfio_main.c      | 688 ++++++++++++++++++
 drivers/vfio/pci/nvidia-vgpu/vfio_sysfs.c     | 209 ++++++
 drivers/vfio/pci/nvidia-vgpu/vgpu.c           |  53 +-
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c       |  68 +-
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h       |  29 +
 10 files changed, 1427 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-driver-nvidia-vgpu
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/vfio.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/vfio_access.c
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/vfio_main.c
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/vfio_sysfs.c

diff --git a/Documentation/ABI/stable/sysfs-driver-nvidia-vgpu b/Documentation/ABI/stable/sysfs-driver-nvidia-vgpu
new file mode 100644
index 000000000000..1fc3ac8e234d
--- /dev/null
+++ b/Documentation/ABI/stable/sysfs-driver-nvidia-vgpu
@@ -0,0 +1,11 @@
+What:           /sys/devices/pciXXXX:XX/0000:XX:XX.X/nvidia/creatable_vgpu_types
+Date:		June 2, 2025
+KernelVersion:	6.17
+Contact:	kvm@vger.kernel.org
+Description:	Query the creatble vGPU types on a virtual function.
+
+What:           /sys/devices/pciXXXX:XX/0000:XX:XX.X/nvidia/current_vgpu_type
+Date:		June 2, 2025
+KernelVersion:	6.17
+Contact:	kvm@vger.kernel.org
+Description:	Set the vGPU type for the virtual function.
diff --git a/drivers/vfio/pci/nvidia-vgpu/Makefile b/drivers/vfio/pci/nvidia-vgpu/Makefile
index 91e57c65ca27..2aba9b4868aa 100644
--- a/drivers/vfio/pci/nvidia-vgpu/Makefile
+++ b/drivers/vfio/pci/nvidia-vgpu/Makefile
@@ -2,4 +2,5 @@
 subdir-ccflags-y += -I$(src)/include
 
 obj-$(CONFIG_NVIDIA_VGPU_VFIO_PCI) += nvidia_vgpu_vfio_pci.o
-nvidia_vgpu_vfio_pci-y := vgpu_mgr.o vgpu.o metadata.o metadata_vgpu_type.o rpc.o
+nvidia_vgpu_vfio_pci-y := vgpu_mgr.o vgpu.o metadata.o metadata_vgpu_type.o rpc.o \
+			  vfio_main.o vfio_access.o vfio_sysfs.o
diff --git a/drivers/vfio/pci/nvidia-vgpu/debug.h b/drivers/vfio/pci/nvidia-vgpu/debug.h
index db9288752384..05cb2ea13543 100644
--- a/drivers/vfio/pci/nvidia-vgpu/debug.h
+++ b/drivers/vfio/pci/nvidia-vgpu/debug.h
@@ -22,4 +22,14 @@
 	pci_err(__v->pdev, "nvidia-vgpu %d: "f, __v->info.id, ##a); \
 })
 
+#define nvdev_debug(n, f, a...) ({ \
+	typeof(n) __n = (n); \
+	pci_dbg(__n->core_dev.pdev, "nvidia-vgpu-vfio: "f, ##a); \
+})
+
+#define nvdev_error(n, f, a...) ({ \
+	typeof(n) __n = (n); \
+	pci_err(__n->core_dev.pdev, "nvidia-vgpu-vfio: "f, ##a); \
+})
+
 #endif
diff --git a/drivers/vfio/pci/nvidia-vgpu/vfio.h b/drivers/vfio/pci/nvidia-vgpu/vfio.h
new file mode 100644
index 000000000000..4c9bf9c80f5c
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/vfio.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright © 2025 NVIDIA Corporation
+ */
+
+#ifndef _NVIDIA_VGPU_VFIO_H__
+#define _NVIDIA_VGPU_VFIO_H__
+
+#include <linux/vfio_pci_core.h>
+
+#include "vgpu_mgr.h"
+
+#define PCI_CONFIG_SPACE_LENGTH 4096
+
+#define CAP_LIST_NEXT_PTR_MSIX 0x7c
+#define MSIX_CAP_SIZE   0xc
+
+struct nvidia_vgpu_vfio {
+	struct vfio_pci_core_device core_dev;
+	u8 vconfig[PCI_CONFIG_SPACE_LENGTH];
+	void __iomem *bar0_map;
+
+	struct nvidia_vgpu_mgr *vgpu_mgr;
+	struct nvidia_vgpu_type *vgpu_type;
+
+	/* lock to protect vgpu pointer and following members */
+	struct mutex vfio_vgpu_lock;
+	struct nvidia_vgpu *vgpu;
+	bool vdev_is_opened;
+	bool driver_is_unbound;
+	struct pid *task_pid;
+	struct completion vdev_closing_completion;
+
+	struct nvidia_vgpu_event_listener pf_driver_event_listener;
+};
+
+static inline struct nvidia_vgpu_vfio *core_dev_to_nvdev(struct vfio_pci_core_device *core_dev)
+{
+	return container_of(core_dev, struct nvidia_vgpu_vfio, core_dev);
+}
+
+void nvidia_vgpu_vfio_setup_config(struct nvidia_vgpu_vfio *nvdev);
+ssize_t nvidia_vgpu_vfio_access(struct nvidia_vgpu_vfio *nvdev, char __user *buf, size_t count,
+				loff_t ppos, bool iswrite);
+
+int nvidia_vgpu_vfio_setup_sysfs(struct nvidia_vgpu_vfio *nvdev);
+void nvidia_vgpu_vfio_clean_sysfs(struct nvidia_vgpu_vfio *nvdev);
+
+#endif /* _NVIDIA_VGPU_VFIO_H__ */
diff --git a/drivers/vfio/pci/nvidia-vgpu/vfio_access.c b/drivers/vfio/pci/nvidia-vgpu/vfio_access.c
new file mode 100644
index 000000000000..4a72575264ba
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/vfio_access.c
@@ -0,0 +1,313 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright © 2025 NVIDIA Corporation
+ */
+
+#include <linux/string.h>
+#include <linux/pci.h>
+#include <linux/pci_regs.h>
+
+#include "vfio.h"
+
+#define vconfig_set8(offset, v) \
+	(*(u8 *)(nvdev->vconfig + (offset)) = v)
+
+#define vconfig_set16(offset, v) \
+	(*(u16 *)(nvdev->vconfig + (offset)) = v)
+
+#define vconfig_set32(offset, v) \
+	(*(u32 *)(nvdev->vconfig + (offset)) = v)
+
+void nvidia_vgpu_vfio_setup_config(struct nvidia_vgpu_vfio *nvdev)
+{
+	struct nvidia_vgpu_type *vgpu_type;
+	u8 val8;
+
+	lockdep_assert_held(&nvdev->vfio_vgpu_lock);
+
+	if (WARN_ON(!nvdev->vgpu_type))
+		return;
+
+	vgpu_type = nvdev->vgpu_type;
+
+	memset(nvdev->vconfig, 0, sizeof(nvdev->vconfig));
+
+	/* Header type 0 (normal devices) */
+	vconfig_set16(PCI_VENDOR_ID, PCI_VENDOR_ID_NVIDIA);
+	vconfig_set16(PCI_DEVICE_ID, FIELD_GET(GENMASK(31, 16), vgpu_type->vdev_id));
+	vconfig_set16(PCI_COMMAND, 0x0000);
+	vconfig_set16(PCI_STATUS, 0x0010);
+
+	pci_read_config_byte(nvdev->core_dev.pdev, PCI_CLASS_REVISION, &val8);
+	vconfig_set8(PCI_CLASS_REVISION, val8);
+
+	vconfig_set8(PCI_CLASS_PROG, 0); /* VGA-compatible */
+	vconfig_set8(PCI_CLASS_DEVICE, 0); /* VGA controller */
+	vconfig_set8(PCI_CLASS_DEVICE + 1, 3); /* Display controller */
+
+	/* BAR0: 32-bit */
+	vconfig_set32(PCI_BASE_ADDRESS_0, 0x00000000);
+	/* BAR1: 64-bit, prefetchable */
+	vconfig_set32(PCI_BASE_ADDRESS_1, 0x0000000c);
+	/* BAR2: 64-bit, prefetchable */
+	vconfig_set32(PCI_BASE_ADDRESS_3, 0x0000000c);
+	/* Disable BAR3: I/O */
+	vconfig_set32(PCI_BASE_ADDRESS_5, 0x00000000);
+
+	vconfig_set16(PCI_SUBSYSTEM_VENDOR_ID, PCI_VENDOR_ID_NVIDIA);
+	vconfig_set16(PCI_SUBSYSTEM_ID, FIELD_GET(GENMASK(15, 0),
+		      nvdev->vgpu->info.vgpu_type->vdev_id));
+
+	vconfig_set8(PCI_CAPABILITY_LIST, CAP_LIST_NEXT_PTR_MSIX);
+	vconfig_set8(CAP_LIST_NEXT_PTR_MSIX + 1, 0);
+
+	/* INTx disabled */
+	vconfig_set8(0x3d, 0);
+}
+
+#define PCI_CONFIG_READ(pdev, off, buf, size) \
+	do { \
+		switch (size) { \
+		case 4: pci_read_config_dword((pdev), (off), (u32 *)(buf)); break; \
+		case 2: pci_read_config_word((pdev), (off), (u16 *)(buf)); break; \
+		case 1: pci_read_config_byte((pdev), (off), (u8 *)(buf));  break; \
+		} \
+	} while (0)
+
+#define PCI_CONFIG_WRITE(pdev, off, buf, size) \
+	do { \
+		switch (size) { \
+		case 4: pci_write_config_dword((pdev), (off), *(u32 *)(buf)); break; \
+		case 2: pci_write_config_word((pdev), (off), *(u16 *)(buf)); break; \
+		case 1: pci_write_config_byte((pdev), (off), *(u8 *)(buf));  break; \
+		} \
+	} while (0)
+
+#define MMIO_READ(map, off, buf, size) \
+	do { \
+		switch (size) { \
+		case 4: { u32 val = ioread32((map) + (off)); memcpy((buf), &val, 4); break; } \
+		case 2: { u16 val = ioread16((map) + (off)); memcpy((buf), &val, 2); break; } \
+		case 1: { u8  val = ioread8((map) + (off)); memcpy((buf), &val, 1); break; } \
+		} \
+	} while (0)
+
+#define MMIO_WRITE(map, off, buf, size) \
+	do { \
+		switch (size) { \
+		case 4: iowrite32(*(u32 *)(buf), (map) + (off)); break; \
+		case 2: iowrite16(*(u16 *)(buf), (map) + (off)); break; \
+		case 1: iowrite8 (*(u8  *)(buf), (map) + (off)); break; \
+		} \
+	} while (0)
+
+static ssize_t bar0_rw(struct nvidia_vgpu_vfio *nvdev, char *buf, size_t count, loff_t ppos,
+		       bool iswrite)
+{
+	struct pci_dev *pdev = nvdev->core_dev.pdev;
+	int index = VFIO_PCI_OFFSET_TO_INDEX(ppos);
+	loff_t offset = ppos;
+	void __iomem *map;
+	int ret;
+
+	if (WARN_ON(index != VFIO_PCI_BAR0_REGION_INDEX))
+		return -EINVAL;
+
+	offset &= VFIO_PCI_OFFSET_MASK;
+
+	if (!nvdev->bar0_map) {
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
+	} else {
+		map = nvdev->bar0_map;
+	}
+
+	if (iswrite)
+		MMIO_WRITE(map, offset, buf, count);
+	else
+		MMIO_READ(map, offset, buf, count);
+
+	return count;
+}
+
+/* Generate mask for 32-bit or 64-bit PCI BAR address range */
+#define GEN_BARMASK(size)        ((u32)((~(size) + 1) & ~0xFUL))
+#define GEN_BARMASK_HI(size)     ((u32)(((~(size) + 1) & ~0xFULL) >> 32))
+
+static u32 emulate_pci_base_reg_write(struct nvidia_vgpu_vfio *nvdev, loff_t offset, u32 cfg_addr)
+{
+	struct pci_dev *pdev = nvdev->core_dev.pdev;
+	struct nvidia_vgpu_type *vgpu_type = nvdev->vgpu->info.vgpu_type;
+	u32 bar_mask;
+
+	switch (offset) {
+	case PCI_BASE_ADDRESS_0:
+		bar_mask = GEN_BARMASK(pci_resource_len(pdev, VFIO_PCI_BAR0_REGION_INDEX));
+		cfg_addr = (cfg_addr & bar_mask) | (nvdev->vconfig[offset] & 0xFUL);
+		break;
+
+	case PCI_BASE_ADDRESS_1:
+		bar_mask = GEN_BARMASK(vgpu_type->bar1_length * SZ_1M);
+		cfg_addr = (cfg_addr & bar_mask) | (nvdev->vconfig[offset] & 0xFUL);
+		break;
+
+	case PCI_BASE_ADDRESS_2:
+		bar_mask = GEN_BARMASK_HI(vgpu_type->bar1_length * SZ_1M);
+		cfg_addr &= bar_mask;
+		break;
+
+	case PCI_BASE_ADDRESS_3:
+		bar_mask = GEN_BARMASK(pci_resource_len(pdev, VFIO_PCI_BAR3_REGION_INDEX));
+		cfg_addr = (cfg_addr & bar_mask) | (nvdev->vconfig[offset] & 0xFUL);
+		break;
+
+	case PCI_BASE_ADDRESS_4:
+		bar_mask = GEN_BARMASK_HI(pci_resource_len(pdev, VFIO_PCI_BAR3_REGION_INDEX));
+		cfg_addr &= bar_mask;
+		break;
+
+	default:
+		WARN_ONCE(1, "Unsupported PCI BAR offset: %llx\n", offset);
+		return 0;
+	}
+
+	return cfg_addr;
+}
+
+static void handle_pci_config_read(struct nvidia_vgpu_vfio *nvdev, char *buf,
+				   size_t count, loff_t offset)
+{
+	struct pci_dev *pdev = nvdev->core_dev.pdev;
+	u32 val = 0;
+
+	memcpy(buf, (u8 *)&nvdev->vconfig[offset], count);
+
+	switch (offset) {
+	case PCI_COMMAND:
+		PCI_CONFIG_READ(pdev, offset, (char *)&val, count);
+
+		switch (count) {
+		case 4:
+			val = (u32)(val & 0xFFFF0000) | (val &
+					(PCI_COMMAND_PARITY | PCI_COMMAND_SERR));
+			break;
+		case 2:
+			val = (val & (PCI_COMMAND_PARITY | PCI_COMMAND_SERR));
+			break;
+		default:
+			WARN_ONCE(1, "Not supported access len\n");
+			break;
+		}
+		break;
+	case PCI_STATUS:
+		PCI_CONFIG_READ(pdev, offset, (char *)&val, count);
+		break;
+	default:
+		break;
+	}
+	*(u32 *)buf = *(u32 *)buf | val;
+}
+
+static void handle_pci_config_write(struct nvidia_vgpu_vfio *nvdev, char *buf,
+				    size_t count, loff_t offset)
+{
+	struct pci_dev *pdev = nvdev->core_dev.pdev;
+	u32 val = 0;
+	u32 cfg_addr;
+
+	switch (offset) {
+	case PCI_VENDOR_ID:
+	case PCI_DEVICE_ID:
+	case PCI_CAPABILITY_LIST:
+		break;
+
+	case PCI_STATUS:
+		PCI_CONFIG_WRITE(pdev, offset, buf, count);
+		break;
+	case PCI_COMMAND:
+		if (count == 4) {
+			val = (u32)((*(u32 *)buf & 0xFFFF0000) >> 16);
+			PCI_CONFIG_WRITE(pdev, PCI_STATUS, (char *)&val, 2);
+
+			val = (u32)(*(u32 *)buf & 0x0000FFFF);
+			*(u32 *)buf = val;
+		}
+
+		memcpy((u8 *)&nvdev->vconfig[offset], buf, count);
+		break;
+	case PCI_BASE_ADDRESS_0:
+	case PCI_BASE_ADDRESS_1:
+	case PCI_BASE_ADDRESS_2:
+	case PCI_BASE_ADDRESS_3:
+	case PCI_BASE_ADDRESS_4:
+		cfg_addr = *(u32 *)buf;
+		cfg_addr = emulate_pci_base_reg_write(nvdev, offset, cfg_addr);
+		*(u32 *)&nvdev->vconfig[offset] = cfg_addr;
+		break;
+	default:
+		break;
+	}
+}
+
+static ssize_t pci_config_rw(struct nvidia_vgpu_vfio *nvdev, char *buf, size_t count,
+			     loff_t ppos, bool iswrite)
+{
+	struct pci_dev *pdev = nvdev->core_dev.pdev;
+	int index = VFIO_PCI_OFFSET_TO_INDEX(ppos);
+	loff_t offset = ppos;
+
+	if (WARN_ON(index != VFIO_PCI_CONFIG_REGION_INDEX))
+		return -EINVAL;
+
+	offset &= VFIO_PCI_OFFSET_MASK;
+
+	if (offset >= CAP_LIST_NEXT_PTR_MSIX &&
+	    offset < CAP_LIST_NEXT_PTR_MSIX + MSIX_CAP_SIZE) {
+		if (!iswrite)
+			PCI_CONFIG_READ(pdev, offset, buf, count);
+		else
+			PCI_CONFIG_WRITE(pdev, offset, buf, count);
+		return count;
+	}
+
+	if (!iswrite)
+		handle_pci_config_read(nvdev, buf, count, offset);
+	else
+		handle_pci_config_write(nvdev, buf, count, offset);
+
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
index 000000000000..b557062a4ac2
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/vfio_main.c
@@ -0,0 +1,688 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright © 2025 NVIDIA Corporation
+ */
+
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <linux/vfio_pci_core.h>
+#include <linux/types.h>
+
+#include "debug.h"
+#include "vfio.h"
+
+static inline struct vfio_pci_core_device *vdev_to_core_dev(struct vfio_device *vdev)
+{
+	return container_of(vdev, struct vfio_pci_core_device, vdev);
+}
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
+	struct nvidia_vgpu_type *type = nvdev->vgpu_type;
+	struct nvidia_vgpu *vgpu;
+	int ret;
+
+	if (WARN_ON(!type || !nvdev->task_pid))
+		return -ENODEV;
+
+	vgpu = kzalloc(sizeof(*vgpu), GFP_KERNEL);
+	if (!vgpu)
+		return -ENOMEM;
+
+	vgpu->info.id = pci_iov_vf_id(pdev);
+	vgpu->info.dbdf = (0 << 16) | pci_dev_id(pdev);
+	vgpu->info.gfid = pdev_to_gfid(pdev);
+	vgpu->info.vgpu_type = type;
+	vgpu->info.vm_pid = pid_nr(nvdev->task_pid);
+
+	vgpu->vgpu_mgr = vgpu_mgr;
+	vgpu->pdev = pdev;
+
+	ret = nvidia_vgpu_mgr_create_vgpu(vgpu);
+	if (ret) {
+		kfree(vgpu);
+		return ret;
+	}
+
+	nvdev->vgpu = vgpu;
+	return 0;
+}
+
+static inline bool pdev_is_present(struct pci_dev *pdev)
+{
+	struct pci_dev *physfn = (pdev->is_virtfn) ? pdev->physfn : pdev;
+
+	if (pdev->is_virtfn)
+		return (pci_device_is_present(physfn) &&
+				pdev->error_state != pci_channel_io_perm_failure);
+	else
+		return pci_device_is_present(physfn);
+}
+
+/* Wait till 1000 ms for HW that returns CRS completion status */
+#define MIN_FLR_WAIT_TIME 100
+#define MAX_FLR_WAIT_TIME 1000
+
+static int do_vf_flr(struct vfio_device *vdev)
+{
+	struct vfio_pci_core_device *core_dev = vdev_to_core_dev(vdev);
+	struct nvidia_vgpu_vfio *nvdev = core_dev_to_nvdev(core_dev);
+	struct pci_dev *pdev = core_dev->pdev;
+	u32 data, elapsed_time = 0;
+
+	if (!pdev->is_virtfn)
+		return 0;
+
+	if (!pdev_is_present(pdev))
+		return -ENOTTY;
+
+	pcie_capability_read_dword(pdev, PCI_EXP_DEVCAP, &data);
+	if (!(data & PCI_EXP_DEVCAP_FLR)) {
+		nvdev_error(nvdev, "FLR capability not present on the VF.\n");
+		return -EINVAL;
+	}
+
+	device_lock(&pdev->dev);
+	pci_set_power_state(pdev, PCI_D0);
+	pci_save_state(pdev);
+
+	if (!pci_wait_for_pending_transaction(pdev))
+		nvdev_error(nvdev, "Timed out waiting for transaction pending to go to 0.\n");
+
+	pcie_capability_set_word(pdev, PCI_EXP_DEVCTL, PCI_EXP_DEVCTL_BCR_FLR);
+
+	/*
+	 * If CRS-SV is supported and enabled, then the root-port returns '0001h'
+	 * for a PCI config read of the 16-byte vendor_id field. This indicates CRS
+	 * completion status.
+	 *
+	 * If CRS-SV is not supported/enabled, then the root-port will generally
+	 * synthesise ~0 data for any PCI config read.
+	 */
+	do {
+		msleep(MIN_FLR_WAIT_TIME);
+		elapsed_time += MIN_FLR_WAIT_TIME;
+
+		pci_read_config_dword(pdev, PCI_VENDOR_ID, &data);
+	} while (((data & 0xffff) == 0x0001) && (elapsed_time < MAX_FLR_WAIT_TIME));
+
+	if (elapsed_time < MAX_FLR_WAIT_TIME) {
+		/*
+		 * Device is back from the CRS-SV, continue checking
+		 * if device is ready by reading PCI_COMMAND.
+		 */
+		do {
+			pci_read_config_dword(pdev, PCI_COMMAND, &data);
+			if (data != ~0)
+				goto flr_done;
+
+			msleep(MIN_FLR_WAIT_TIME);
+			elapsed_time += MIN_FLR_WAIT_TIME;
+		} while (elapsed_time < MAX_FLR_WAIT_TIME);
+
+		nvdev_error(nvdev, "FLR failed non-CRS case, waited for %d ms\n", elapsed_time);
+	} else {
+		nvdev_error(nvdev, "FLR failed CRS case, waited for %d ms\n", elapsed_time);
+	}
+
+	/* Device is not usable. */
+	xchg(&pdev->error_state, pci_channel_io_perm_failure);
+	device_unlock(&pdev->dev);
+	return -ENOTTY;
+
+flr_done:
+	pci_restore_state(pdev);
+	device_unlock(&pdev->dev);
+
+	return 0;
+}
+
+static int nvidia_vgpu_vfio_open_device(struct vfio_device *vdev)
+{
+	struct vfio_pci_core_device *core_dev = vdev_to_core_dev(vdev);
+	struct nvidia_vgpu_vfio *nvdev = core_dev_to_nvdev(core_dev);
+	struct pci_dev *pdev = core_dev->pdev;
+	u64 pf_dma_mask;
+	int ret;
+
+	nvdev_debug(nvdev, "open device\n");
+
+	mutex_lock(&nvdev->vfio_vgpu_lock);
+	if (!nvdev->vgpu_type) {
+		nvdev_error(nvdev, "a vGPU type must be chosen before opening VFIO device\n");
+		ret = -ENODEV;
+		goto err_unlock;
+	}
+
+	if (nvdev->driver_is_unbound) {
+		nvdev_error(nvdev, "the driver has been torn down because PF driver is unbound "
+				   "or the admin is disabling the VF\n");
+		ret = -ENODEV;
+		goto err_unlock;
+	}
+
+	if (nvdev->vdev_is_opened) {
+		ret = -EBUSY;
+		goto err_unlock;
+	}
+
+	ret = pci_enable_device(pdev);
+	if (ret)
+		goto err_unlock;
+
+	pci_set_master(pdev);
+
+	pf_dma_mask = dma_get_mask(&pdev->physfn->dev);
+	dma_set_mask(&pdev->dev, pf_dma_mask);
+	dma_set_coherent_mask(&pdev->dev, pf_dma_mask);
+
+	ret = do_vf_flr(vdev);
+	if (ret)
+		goto err_reset_function;
+
+	nvdev->task_pid = get_task_pid(current, PIDTYPE_PID);
+
+	ret = create_vgpu(nvdev);
+	if (ret)
+		goto err_create_vgpu;
+
+	ret = nvidia_vgpu_mgr_set_bme(nvdev->vgpu, true);
+	if (ret)
+		goto err_enable_bme;
+
+	nvidia_vgpu_vfio_setup_config(nvdev);
+
+	nvdev->vdev_is_opened = true;
+	reinit_completion(&nvdev->vdev_closing_completion);
+
+	nvdev_debug(nvdev, "VFIO device is opened, client pid: %u\n", pid_nr(nvdev->task_pid));
+
+	mutex_unlock(&nvdev->vfio_vgpu_lock);
+	return 0;
+
+err_enable_bme:
+	destroy_vgpu(nvdev);
+err_create_vgpu:
+	put_pid(nvdev->task_pid);
+err_reset_function:
+	pci_clear_master(pdev);
+	pci_disable_device(pdev);
+err_unlock:
+	mutex_unlock(&nvdev->vfio_vgpu_lock);
+	return ret;
+}
+
+static void nvidia_vgpu_vfio_close_device(struct vfio_device *vdev)
+{
+	struct vfio_pci_core_device *core_dev = vdev_to_core_dev(vdev);
+	struct nvidia_vgpu_vfio *nvdev = core_dev_to_nvdev(core_dev);
+	struct pci_dev *pdev = core_dev->pdev;
+
+	nvdev_debug(nvdev, "VFIO device is closing, client pid: %u\n", pid_nr(nvdev->task_pid));
+
+	mutex_lock(&nvdev->vfio_vgpu_lock);
+
+	if (nvdev->bar0_map) {
+		iounmap(nvdev->bar0_map);
+		pci_release_selected_regions(pdev, 1 << 0);
+		nvdev->bar0_map = NULL;
+	}
+
+	destroy_vgpu(nvdev);
+
+	put_pid(nvdev->task_pid);
+	nvdev->task_pid = NULL;
+
+	pci_clear_master(pdev);
+	pci_disable_device(pdev);
+
+	nvdev->vdev_is_opened = false;
+	complete(&nvdev->vdev_closing_completion);
+
+	mutex_unlock(&nvdev->vfio_vgpu_lock);
+
+	nvdev_debug(nvdev, "VFIO device is closed\n");
+}
+
+static int get_region_info(struct vfio_pci_core_device *core_dev, unsigned long arg)
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
+	case VFIO_PCI_BAR0_REGION_INDEX ... VFIO_PCI_BAR4_REGION_INDEX:
+		info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
+		info.size = pci_resource_len(pdev, info.index);
+
+		if (info.index == VFIO_PCI_BAR1_REGION_INDEX)
+			info.size = nvdev->vgpu->info.vgpu_type->bar1_length * SZ_1M;
+
+		if (!info.size) {
+			info.flags = 0;
+			break;
+		}
+		info.flags = VFIO_REGION_INFO_FLAG_READ |
+			VFIO_REGION_INFO_FLAG_WRITE |
+			VFIO_REGION_INFO_FLAG_MMAP;
+		break;
+	case VFIO_PCI_BAR5_REGION_INDEX:
+	case VFIO_PCI_ROM_REGION_INDEX:
+	case VFIO_PCI_VGA_REGION_INDEX:
+		info.size = 0;
+		break;
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
+static long nvidia_vgpu_vfio_ioctl(struct vfio_device *vdev, unsigned int cmd, unsigned long arg)
+{
+	struct vfio_pci_core_device *core_dev = vdev_to_core_dev(vdev);
+	struct nvidia_vgpu_vfio *nvdev = core_dev_to_nvdev(core_dev);
+	int ret = 0;
+
+	if (WARN_ON(!nvdev->vgpu || !nvdev->vdev_is_opened))
+		return -ENODEV;
+
+	switch (cmd) {
+	case VFIO_DEVICE_GET_REGION_INFO:
+		ret = get_region_info(core_dev, arg);
+		break;
+	case VFIO_DEVICE_GET_PCI_HOT_RESET_INFO:
+	case VFIO_DEVICE_PCI_HOT_RESET:
+		break;
+	case VFIO_DEVICE_RESET:
+		ret = nvidia_vgpu_mgr_reset_vgpu(nvdev->vgpu);
+		break;
+	default:
+		ret = vfio_pci_core_ioctl(vdev, cmd, arg);
+		break;
+	}
+	return ret;
+}
+
+static ssize_t nvidia_vgpu_vfio_read(struct vfio_device *vdev, char __user *buf, size_t count,
+				     loff_t *ppos)
+{
+	struct vfio_pci_core_device *core_dev = vdev_to_core_dev(vdev);
+	struct nvidia_vgpu_vfio *nvdev = core_dev_to_nvdev(core_dev);
+	u64 val;
+	size_t done = 0;
+	int ret = 0, size;
+
+	if (WARN_ON(!nvdev->vgpu || !nvdev->vdev_is_opened))
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
+	if (WARN_ON(!nvdev->vgpu || !nvdev->vdev_is_opened))
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
+	if (WARN_ON(!nvdev->vgpu || !nvdev->vdev_is_opened))
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
+	if ((req_start + req_len > phys_len) || phys_len == 0)
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
+static void clean_nvdev_unbound(struct nvidia_vgpu_vfio *nvdev)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = nvdev->vgpu_mgr;
+
+	/* driver unbound path is called from the event chain. */
+	lockdep_assert_held(&vgpu_mgr->pf_driver_event_chain.lock);
+	list_del_init(&nvdev->pf_driver_event_listener.list);
+
+	nvidia_vgpu_vfio_clean_sysfs(nvdev);
+
+	nvidia_vgpu_mgr_release(nvdev->vgpu_mgr);
+	nvdev->vgpu_mgr = NULL;
+	nvdev->vgpu_type = NULL;
+}
+
+static void handle_driver_unbound(struct nvidia_vgpu_vfio *nvdev)
+{
+	struct task_struct *task;
+
+	mutex_lock(&nvdev->vfio_vgpu_lock);
+
+	if (nvdev->driver_is_unbound) {
+		mutex_unlock(&nvdev->vfio_vgpu_lock);
+		return;
+	}
+
+	nvdev->driver_is_unbound = true;
+
+	if (nvdev->vdev_is_opened) {
+		task = get_pid_task(nvdev->task_pid, PIDTYPE_PID);
+		if (!task) {
+			mutex_unlock(&nvdev->vfio_vgpu_lock);
+			return;
+		}
+
+		nvdev_debug(nvdev, "Killing client pid: %u\n", pid_nr(nvdev->task_pid));
+
+		send_sig(SIGTERM, task, 1);
+		put_task_struct(task);
+
+		mutex_unlock(&nvdev->vfio_vgpu_lock);
+
+		wait_for_completion(&nvdev->vdev_closing_completion);
+	} else {
+		mutex_unlock(&nvdev->vfio_vgpu_lock);
+	}
+
+	clean_nvdev_unbound(nvdev);
+}
+
+static int handle_pf_driver_event(struct nvidia_vgpu_event_listener *self, unsigned int event,
+				  void *p)
+{
+	struct nvidia_vgpu_vfio *nvdev = container_of(self, struct nvidia_vgpu_vfio,
+			pf_driver_event_listener);
+	struct pci_dev *pdev = nvdev->core_dev.pdev;
+
+	switch (event) {
+	case NVIDIA_VGPU_PF_DRIVER_EVENT_DRIVER_UNBIND:
+		nvdev_debug(nvdev, "handle PF event driver unbind\n");
+
+		handle_driver_unbound(nvdev);
+		break;
+	case NVIDIA_VGPU_PF_DRIVER_EVENT_SRIOV_CONFIGURE:
+		int num_vfs = *(int *)p;
+
+		nvdev_debug(nvdev, "handle PF event SRIOV configure\n");
+
+		if (!num_vfs) {
+			handle_driver_unbound(nvdev);
+		} else {
+			/* convert num_vfs to max VF ID */
+			num_vfs--;
+			if (pci_iov_vf_id(pdev) > num_vfs)
+				handle_driver_unbound(nvdev);
+		}
+		break;
+	}
+	return 0;
+}
+
+static void register_pf_driver_event_listener(struct nvidia_vgpu_vfio *nvdev)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = nvdev->vgpu_mgr;
+
+	nvdev->pf_driver_event_listener.func = handle_pf_driver_event;
+	INIT_LIST_HEAD(&nvdev->pf_driver_event_listener.list);
+
+	nvidia_vgpu_event_register_listener(&vgpu_mgr->pf_driver_event_chain,
+					    &nvdev->pf_driver_event_listener);
+}
+
+static void unregister_pf_driver_event_listener(struct nvidia_vgpu_vfio *nvdev)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = nvdev->vgpu_mgr;
+
+	nvidia_vgpu_event_unregister_listener(&vgpu_mgr->pf_driver_event_chain,
+					      &nvdev->pf_driver_event_listener);
+}
+
+static void clean_nvdev(struct nvidia_vgpu_vfio *nvdev)
+{
+	if (nvdev->driver_is_unbound)
+		return;
+
+	unregister_pf_driver_event_listener(nvdev);
+	nvidia_vgpu_vfio_clean_sysfs(nvdev);
+
+	nvidia_vgpu_mgr_release(nvdev->vgpu_mgr);
+	nvdev->vgpu_mgr = NULL;
+	nvdev->vgpu_type = NULL;
+}
+
+static int setup_nvdev(void *priv, void *data)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = priv;
+	struct nvidia_vgpu_vfio *nvdev = data;
+	int ret;
+
+	mutex_init(&nvdev->vfio_vgpu_lock);
+	init_completion(&nvdev->vdev_closing_completion);
+
+	nvdev->vgpu_mgr = vgpu_mgr;
+
+	ret = nvidia_vgpu_vfio_setup_sysfs(nvdev);
+	if (ret)
+		return ret;
+
+	register_pf_driver_event_listener(nvdev);
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
+	ret = nvidia_vgpu_mgr_setup(pdev, setup_nvdev, nvdev);
+	if (ret)
+		goto err_setup_vgpu_mgr;
+
+	dev_set_drvdata(&pdev->dev, &nvdev->core_dev);
+
+	ret = vfio_pci_core_register_device(&nvdev->core_dev);
+	if (ret)
+		goto err_register_core_device;
+
+	return 0;
+
+err_register_core_device:
+	clean_nvdev(nvdev);
+err_setup_vgpu_mgr:
+	vfio_put_device(&nvdev->core_dev.vdev);
+	pci_err(pdev, "VF probe failed with ret: %d\n", ret);
+	return ret;
+}
+
+static void nvidia_vgpu_vfio_remove(struct pci_dev *pdev)
+{
+	struct vfio_pci_core_device *core_dev = dev_get_drvdata(&pdev->dev);
+	struct nvidia_vgpu_vfio *nvdev = core_dev_to_nvdev(core_dev);
+
+	WARN_ON(nvdev->vgpu || nvdev->vdev_is_opened);
+
+	vfio_pci_core_unregister_device(core_dev);
+	clean_nvdev(nvdev);
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
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Vinay Kabra <vkabra@nvidia.com>");
+MODULE_AUTHOR("Kirti Wankhede <kwankhede@nvidia.com>");
+MODULE_AUTHOR("Zhi Wang <zhiw@nvidia.com>");
+MODULE_DESCRIPTION("NVIDIA vGPU VFIO Variant Driver - User Level driver for NVIDIA vGPU");
diff --git a/drivers/vfio/pci/nvidia-vgpu/vfio_sysfs.c b/drivers/vfio/pci/nvidia-vgpu/vfio_sysfs.c
new file mode 100644
index 000000000000..271b330f15b1
--- /dev/null
+++ b/drivers/vfio/pci/nvidia-vgpu/vfio_sysfs.c
@@ -0,0 +1,209 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright © 2025 NVIDIA Corporation
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
+static struct nvidia_vgpu_type *find_vgpu_type(struct nvidia_vgpu_vfio *nvdev, u64 type_id)
+{
+	struct nvidia_vgpu_type *vgpu_type;
+	unsigned int i;
+
+	for (i = 0; i < nvdev->vgpu_mgr->num_vgpu_types; i++) {
+		vgpu_type = nvdev->vgpu_mgr->vgpu_types + i;
+		if (vgpu_type->vgpu_type == type_id)
+			return vgpu_type;
+	}
+	return NULL;
+}
+
+static ssize_t creatable_homogeneous_vgpu_types_show(struct nvidia_vgpu_vfio *nvdev, char *buf)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = nvdev->vgpu_mgr;
+	ssize_t ret = 0;
+	u64 i;
+
+	mutex_lock(&vgpu_mgr->curr_vgpu_type_lock);
+	/* No vGPU has been created. */
+	if (!vgpu_mgr->curr_vgpu_type) {
+		ret += sprintf(buf, "ID    : vGPU Name\n");
+
+		for (i = 0; i < vgpu_mgr->num_vgpu_types; i++) {
+			struct nvidia_vgpu_type *type = vgpu_mgr->vgpu_types + i;
+
+			ret += sprintf(buf + ret, "%-5d : %s\n", type->vgpu_type,
+				       type->vgpu_type_name);
+		}
+	} else {
+		struct nvidia_vgpu_type *type = vgpu_mgr->curr_vgpu_type;
+
+		/* There has been created vGPU(s). */
+		if (vgpu_mgr->num_instances < type->max_instance)
+			ret = sprintf(buf + ret, "%-5d : %s\n", type->vgpu_type,
+				      type->vgpu_type_name);
+	}
+	mutex_unlock(&vgpu_mgr->curr_vgpu_type_lock);
+	return ret;
+}
+
+static int create_homogeneous_instance(struct nvidia_vgpu_vfio *nvdev,
+				       struct nvidia_vgpu_type *type)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = nvdev->vgpu_mgr;
+	int ret = 0;
+
+	mutex_lock(&vgpu_mgr->curr_vgpu_type_lock);
+	if (!vgpu_mgr->curr_vgpu_type) {
+		vgpu_mgr->curr_vgpu_type = type;
+		vgpu_mgr->num_instances++;
+		nvdev->vgpu_type = type;
+	} else {
+		if (type != vgpu_mgr->curr_vgpu_type) {
+			ret = -EINVAL;
+		} else if (vgpu_mgr->num_instances >= vgpu_mgr->curr_vgpu_type->max_instance) {
+			ret = -ENOSPC;
+		} else {
+			vgpu_mgr->num_instances++;
+			nvdev->vgpu_type = type;
+		}
+	}
+	mutex_unlock(&vgpu_mgr->curr_vgpu_type_lock);
+	return ret;
+}
+
+static void destroy_homogeneous_instance(struct nvidia_vgpu_vfio *nvdev)
+{
+	struct nvidia_vgpu_mgr *vgpu_mgr = nvdev->vgpu_mgr;
+
+	if (!nvdev->vgpu_type)
+		return;
+
+	mutex_lock(&vgpu_mgr->curr_vgpu_type_lock);
+	if (vgpu_mgr->curr_vgpu_type) {
+		if (!--vgpu_mgr->num_instances)
+			vgpu_mgr->curr_vgpu_type = NULL;
+	}
+	nvdev->vgpu_type = NULL;
+	mutex_unlock(&vgpu_mgr->curr_vgpu_type_lock);
+}
+
+static ssize_t creatable_vgpu_types_show(struct device *dev, struct device_attribute *attr,
+					 char *buf)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct vfio_pci_core_device *core_dev = pci_get_drvdata(pdev);
+	struct nvidia_vgpu_vfio *nvdev = core_dev_to_nvdev(core_dev);
+	ssize_t ret;
+
+	mutex_lock(&nvdev->vfio_vgpu_lock);
+	if (nvdev->vgpu_type) {
+		mutex_unlock(&nvdev->vfio_vgpu_lock);
+		return 0;
+	}
+
+	ret = creatable_homogeneous_vgpu_types_show(nvdev, buf);
+	mutex_unlock(&nvdev->vfio_vgpu_lock);
+	return ret;
+}
+
+static DEVICE_ATTR_RO(creatable_vgpu_types);
+
+static ssize_t current_vgpu_type_store(struct device *dev, struct device_attribute *attr,
+				       const char *buf, size_t count)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct vfio_pci_core_device *core_dev = pci_get_drvdata(pdev);
+	struct nvidia_vgpu_vfio *nvdev = core_dev_to_nvdev(core_dev);
+	struct nvidia_vgpu_type *type;
+	unsigned long vgpu_type_id = ~0;
+	int ret = 0;
+
+	ret = kstrtoul(buf, 10, &vgpu_type_id);
+	if (ret)
+		return ret;
+
+	mutex_lock(&nvdev->vfio_vgpu_lock);
+
+	if (nvdev->vdev_is_opened) {
+		mutex_unlock(&nvdev->vfio_vgpu_lock);
+		return -EBUSY;
+	}
+
+	if (vgpu_type_id) {
+		type = find_vgpu_type(nvdev, vgpu_type_id);
+		if (!type) {
+			ret = -ENODEV;
+			goto out_unlock;
+		}
+		ret = create_homogeneous_instance(nvdev, type);
+	} else {
+		destroy_homogeneous_instance(nvdev);
+	}
+
+out_unlock:
+	mutex_unlock(&nvdev->vfio_vgpu_lock);
+	return ret ? ret : count;
+}
+
+static ssize_t current_vgpu_type_show(struct device *dev, struct device_attribute *attr,
+				      char *buf)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct vfio_pci_core_device *core_dev = pci_get_drvdata(pdev);
+	struct nvidia_vgpu_vfio *nvdev = core_dev_to_nvdev(core_dev);
+	unsigned long type_id;
+
+	mutex_lock(&nvdev->vfio_vgpu_lock);
+
+	type_id = nvdev->vgpu_type ? nvdev->vgpu_type->vgpu_type : 0;
+
+	mutex_unlock(&nvdev->vfio_vgpu_lock);
+
+	return sprintf(buf, "%lu\n", type_id);
+}
+
+static DEVICE_ATTR_RW(current_vgpu_type);
+
+static struct attribute *vf_dev_attrs[] = {
+	&dev_attr_creatable_vgpu_types.attr,
+	&dev_attr_current_vgpu_type.attr,
+	NULL,
+};
+
+static const struct attribute_group vf_dev_group = {
+	.name  = "nvidia",
+	.attrs = vf_dev_attrs,
+};
+
+const struct attribute_group *vf_dev_groups[] = {
+	&vf_dev_group,
+	NULL,
+};
+
+int nvidia_vgpu_vfio_setup_sysfs(struct nvidia_vgpu_vfio *nvdev)
+{
+	struct pci_dev *pdev = nvdev->core_dev.pdev;
+
+	if (WARN_ON(!pdev))
+		return -EINVAL;
+
+	return sysfs_create_groups(&pdev->dev.kobj, vf_dev_groups);
+}
+
+void nvidia_vgpu_vfio_clean_sysfs(struct nvidia_vgpu_vfio *nvdev)
+{
+	struct pci_dev *pdev = nvdev->core_dev.pdev;
+
+	if (WARN_ON(!pdev))
+		return;
+
+	sysfs_remove_groups(&pdev->dev.kobj, vf_dev_groups);
+}
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu.c b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
index 9e8ea77bbcc5..72083d300b8a 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu.c
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu.c
@@ -9,6 +9,7 @@
 #include "vgpu_mgr.h"
 
 #include <nvrm/bootload.h>
+#include <nvrm/vgpu.h>
 
 static void unregister_vgpu(struct nvidia_vgpu *vgpu)
 {
@@ -361,7 +362,7 @@ int nvidia_vgpu_mgr_create_vgpu(struct nvidia_vgpu *vgpu)
 	struct nvidia_vgpu_info *info = &vgpu->info;
 	int ret;
 
-	if (WARN_ON(!info->gfid || !info->dbdf || !info->vgpu_type))
+	if (WARN_ON(!info->gfid || !info->dbdf || !info->vgpu_type || !info->vm_pid))
 		return -EINVAL;
 
 	if (WARN_ON(!vgpu->vgpu_mgr || !vgpu->pdev))
@@ -372,8 +373,8 @@ int nvidia_vgpu_mgr_create_vgpu(struct nvidia_vgpu *vgpu)
 
 	vgpu->info = *info;
 
-	vgpu_debug(vgpu, "create vgpu %s on vgpu_mgr %px\n",
-		   info->vgpu_type->vgpu_type_name, vgpu->vgpu_mgr);
+	vgpu_debug(vgpu, "create vgpu %s on vgpu_mgr %px vm pid %u\n",
+		   info->vgpu_type->vgpu_type_name, vgpu->vgpu_mgr, info->vm_pid);
 
 	ret = register_vgpu(vgpu);
 	if (ret)
@@ -427,3 +428,49 @@ int nvidia_vgpu_mgr_create_vgpu(struct nvidia_vgpu *vgpu)
 	return ret;
 }
 EXPORT_SYMBOL_GPL(nvidia_vgpu_mgr_create_vgpu);
+
+/**
+ * nvidia_vgpu_mgr_reset_vgpu - reset a vGPU instance
+ * @vgpu: the vGPU instance going to be reset.
+ *
+ * Returns: 0 on success, others on failure.
+ */
+int nvidia_vgpu_mgr_reset_vgpu(struct nvidia_vgpu *vgpu)
+{
+	int ret;
+
+	ret = nvidia_vgpu_rpc_call(vgpu, NV_VGPU_CPU_RPC_MSG_RESET, NULL, 0);
+	if (ret) {
+		vgpu_error(vgpu, "fail to reset vgpu ret %d\n", ret);
+		return ret;
+	}
+
+	vgpu_debug(vgpu, "reset done\n");
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nvidia_vgpu_mgr_reset_vgpu);
+
+static int update_bme_state(struct nvidia_vgpu *vgpu, bool enable)
+{
+	NV_VGPU_CPU_RPC_DATA_UPDATE_BME_STATE params = {0};
+
+	params.enable = enable;
+
+	return nvidia_vgpu_rpc_call(vgpu, NV_VGPU_CPU_RPC_MSG_UPDATE_BME_STATE,
+				    &params, sizeof(params));
+}
+
+/**
+ * nvidia_vgpu_set_bme - handle BME sequence
+ * @vgpu: the vGPU instance
+ * @enable: BME enable/disable
+ *
+ * Returns: 0 on success, others on failure.
+ */
+int nvidia_vgpu_mgr_set_bme(struct nvidia_vgpu *vgpu, bool enable)
+{
+	vgpu_debug(vgpu, "set bme, enable %d\n", enable);
+
+	return update_bme_state(vgpu, enable);
+}
+EXPORT_SYMBOL_GPL(nvidia_vgpu_mgr_set_bme);
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
index 6f53bd7ca940..e502a37468e3 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
@@ -103,10 +103,32 @@ static struct nvidia_vgpu_mgr *alloc_vgpu_mgr(struct nvidia_vgpu_mgr_handle *han
 	mutex_init(&vgpu_mgr->vgpu_list_lock);
 	INIT_LIST_HEAD(&vgpu_mgr->vgpu_list_head);
 	atomic_set(&vgpu_mgr->num_vgpus, 0);
+	mutex_init(&vgpu_mgr->curr_vgpu_type_lock);
+	nvidia_vgpu_event_init_chain(&vgpu_mgr->pf_driver_event_chain);
 
 	return vgpu_mgr;
 }
 
+static int call_chain(struct nvidia_vgpu_event_chain *chain, unsigned int event, void *data)
+{
+	struct nvidia_vgpu_event_listener *l;
+	struct list_head *pos, *temp;
+	int ret = 0;
+
+	mutex_lock(&chain->lock);
+
+	list_for_each_safe(pos, temp, &chain->head) {
+		l = container_of(pos, struct nvidia_vgpu_event_listener, list);
+		ret = l->func(l, event, data);
+		if (ret)
+			goto out_unlock;
+	}
+
+out_unlock:
+	mutex_unlock(&chain->lock);
+	return ret;
+}
+
 static const char *pf_events_string[NVIDIA_VGPU_PF_EVENT_MAX] = {
 	[NVIDIA_VGPU_PF_DRIVER_EVENT_SRIOV_CONFIGURE] = "SRIOV configure",
 	[NVIDIA_VGPU_PF_DRIVER_EVENT_DRIVER_UNBIND] = "driver unbind",
@@ -115,14 +137,20 @@ static const char *pf_events_string[NVIDIA_VGPU_PF_EVENT_MAX] = {
 static int pf_event_notify_fn(void *priv, unsigned int event, void *data)
 {
 	struct nvidia_vgpu_mgr *vgpu_mgr = priv;
+	int ret = 0;
 
 	if (WARN_ON(event >= NVIDIA_VGPU_PF_EVENT_MAX))
 		return -EINVAL;
 
 	vgpu_mgr_debug(vgpu_mgr, "handle PF event %s\n", pf_events_string[event]);
 
-	/* more to come. */
-	return 0;
+	switch (event) {
+	case NVIDIA_VGPU_PF_DRIVER_EVENT_START...NVIDIA_VGPU_PF_DRIVER_EVENT_END:
+		ret = call_chain(&vgpu_mgr->pf_driver_event_chain, event, data);
+		break;
+	}
+
+	return ret;
 }
 
 static void attach_vgpu_mgr(struct nvidia_vgpu_mgr *vgpu_mgr,
@@ -378,3 +406,39 @@ int nvidia_vgpu_mgr_setup(struct pci_dev *dev, int (*init_vfio_fn)(void *priv, v
 	return nvidia_vgpu_mgr_attach_handle(&handle, &attach_handle_data);
 }
 EXPORT_SYMBOL(nvidia_vgpu_mgr_setup);
+
+/**
+ * nvidia_vgpu_event_init_chain - initialize an event chain
+ * @chain: the even chain.
+ */
+void nvidia_vgpu_event_init_chain(struct nvidia_vgpu_event_chain *chain)
+{
+	mutex_init(&chain->lock);
+	INIT_LIST_HEAD(&chain->head);
+}
+
+/**
+ * nvidia_vgpu_event_register_listener - register an event listener
+ * @chain: the event chain.
+ * @l: the listener.
+ */
+void nvidia_vgpu_event_register_listener(struct nvidia_vgpu_event_chain *chain,
+					 struct nvidia_vgpu_event_listener *l)
+{
+	mutex_lock(&chain->lock);
+	list_add_tail(&l->list, &chain->head);
+	mutex_unlock(&chain->lock);
+}
+
+/**
+ * nvidia_vgpu_event_unregister_listener - unregister an event listener
+ * @chain: the event chain.
+ * @l: the listener.
+ */
+void nvidia_vgpu_event_unregister_listener(struct nvidia_vgpu_event_chain *chain,
+					   struct nvidia_vgpu_event_listener *l)
+{
+	mutex_lock(&chain->lock);
+	list_del_init(&l->list);
+	mutex_unlock(&chain->lock);
+}
diff --git a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
index fe475f8b2882..dc782f825f2b 100644
--- a/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
+++ b/drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
@@ -101,6 +101,17 @@ struct nvidia_vgpu {
 	struct nvidia_vgpu_rpc rpc;
 };
 
+struct nvidia_vgpu_event_listener {
+	int (*func)(struct nvidia_vgpu_event_listener *self, unsigned int event, void *data);
+	struct list_head list;
+};
+
+struct nvidia_vgpu_event_chain {
+	/* lock for PF event listener list */
+	struct mutex lock;
+	struct list_head head;
+};
+
 /**
  * struct nvidia_vgpu_mgr - the vGPU manager
  *
@@ -125,6 +136,10 @@ struct nvidia_vgpu {
  * @num_vgpu_types: number of installed vGPU types
  * @use_alloc_bitmap: use chid allocator for the PF driver doesn't support chid allocation
  * @chid_alloc_bitmap: chid allocator bitmap
+ * @curr_vgpu_lock: lock to protect curr_vgpu_type
+ * @curr_vgpu_type: type of current created vgpu in homogeneous mode
+ * @num_instances: number of created vGPU with curr_vgpu_type in homogeneous mode
+ * @pf_driver_event_chain: PF driver event chain
  * @pdev: the PCI device pointer
  * @bar0_vaddr: the virtual address of BAR0
  */
@@ -163,6 +178,13 @@ struct nvidia_vgpu_mgr {
 	bool use_chid_alloc_bitmap;
 	void *chid_alloc_bitmap;
 
+	/* lock for current vGPU type */
+	struct mutex curr_vgpu_type_lock;
+	struct nvidia_vgpu_type *curr_vgpu_type;
+	unsigned int num_instances;
+
+	struct nvidia_vgpu_event_chain pf_driver_event_chain;
+
 	struct pci_dev *pdev;
 	void __iomem *bar0_vaddr;
 };
@@ -173,14 +195,21 @@ struct nvidia_vgpu_mgr {
 int nvidia_vgpu_mgr_setup(struct pci_dev *dev, int (*init_vfio_fn)(void *priv, void *data),
 			  void *init_vfio_fn_data);
 void nvidia_vgpu_mgr_release(struct nvidia_vgpu_mgr *vgpu_mgr);
+void nvidia_vgpu_event_init_chain(struct nvidia_vgpu_event_chain *chain);
+void nvidia_vgpu_event_register_listener(struct nvidia_vgpu_event_chain *chain,
+					 struct nvidia_vgpu_event_listener *l);
+void nvidia_vgpu_event_unregister_listener(struct nvidia_vgpu_event_chain *chain,
+					   struct nvidia_vgpu_event_listener *l);
 
 int nvidia_vgpu_mgr_destroy_vgpu(struct nvidia_vgpu *vgpu);
 int nvidia_vgpu_mgr_create_vgpu(struct nvidia_vgpu *vgpu);
+int nvidia_vgpu_mgr_reset_vgpu(struct nvidia_vgpu *vgpu);
 int nvidia_vgpu_mgr_setup_metadata(struct nvidia_vgpu_mgr *vgpu_mgr);
 void nvidia_vgpu_mgr_clean_metadata(struct nvidia_vgpu_mgr *vgpu_mgr);
 int nvidia_vgpu_rpc_call(struct nvidia_vgpu *vgpu, u32 msg_type,
 			 void *data, u64 size);
 void nvidia_vgpu_clean_rpc(struct nvidia_vgpu *vgpu);
 int nvidia_vgpu_setup_rpc(struct nvidia_vgpu *vgpu);
+int nvidia_vgpu_mgr_set_bme(struct nvidia_vgpu *vgpu, bool enable);
 
 #endif
-- 
2.34.1


