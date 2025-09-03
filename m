Return-Path: <kvm+bounces-56701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA050B42C8F
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 00:11:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F2933A7368
	for <lists+kvm@lfdr.de>; Wed,  3 Sep 2025 22:11:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EA3C2ECD21;
	Wed,  3 Sep 2025 22:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="o9FWF+WA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2040.outbound.protection.outlook.com [40.107.237.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D192EBDF9
	for <kvm@vger.kernel.org>; Wed,  3 Sep 2025 22:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756937495; cv=fail; b=l+HL+LgFSxKIMLlPu2IQBa+VzYzeD5z+tY0ikGafchEIw2WDokuuCD9Mf4f9e3AEJWbgk+nkZTNSgnMrJypU6Ib0tLaWaaK1COVRR+Kl1626sPqjUXebNeUrzgKkm/lqS1Sri9fToxMXpYDtI9ud15LhWpDIuhw6FtYQEVZm2dE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756937495; c=relaxed/simple;
	bh=22/pR/6HfwuR/bKiIpB3gDcdY32mFZfd7nsfdW1NvRw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Gu/zpKZGsLIrNqfVXRXB1e4Q2h5m5B+DlrD/Eb8XpkJOOp472dIuOfl45ZiNcDNgkCNULW328SXQvoj8S65piNOebRIkp9skql79KwFTa7Se1nxF7Lc0kUqCwWbo5dBE8ArbY0P3krQLrax30c/jWEuntXG5fn3n1b12yFt5GEo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=o9FWF+WA; arc=fail smtp.client-ip=40.107.237.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J3+xRPrcoS+ma0+WqoUs1Rh4vLkn+ZcgSPZXPQDsz5f7TOzzpqZAQ43zia1wKNaytzex+/zS1NGlAln6cIEQFMZwdRIR9c1vdOocR0Xq1vFGVp2PCeEa59tuPO4gjhiH7L4irnQnJwz4lMa8hERh0010xt3tjBFGBy4Nbmxiq0K7TkAS839dQu3IZJM0APikp11MtXD9Y5I0kT59xPwMVWhu6QpAdmp3RZV5G9w71PCbgbW4/BhMa6xRhxTr/gh4doEi5h5S2nSso3KpASkPncu8lgIZdKP1vF2UhzpIsamcgVyW1TS+ixawe1VR2c/5hDyH6ER0j7vRNH5/1Re6tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TWB8H+DGpRqKIqqFDwtjNT8pxfgsdU7yLF0VpOXFQ74=;
 b=IL+teH1Kakyv4yk5dqvke/Or+Oz4JnM0a8ldxGALdP56cLZAbopwe1V4Ma6235TprQU6oTTHfqJJns4ZYlMTjeDDhVVHB1kPuxdGsC6R+BB9w9KP72V2zW393qcBXgBFFh/DFJUzF8m0ncWolJbAtvwF8gcLW07iLOo//42OYe0WJpn4BEBp4Pwc8omaWKXBuzaTU+S1W/Og3bV6AGq5V9eghKqrbPhs9tw+yobsLUodsKyK5wIlkpixwat4rrseoUUJgwwAY6JNsUbkUaYyTOBEKu0NecsfuJFKBIZ/EyyeilElZkMM4Qe4ZQSRTjb5ml83NGDU15mO/w7nM/tddQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TWB8H+DGpRqKIqqFDwtjNT8pxfgsdU7yLF0VpOXFQ74=;
 b=o9FWF+WAx+U42W0CPEsg+dE7RCbccTPOUS8bDXV9tmPdcSna0NyN/78WdxU+R5SdOsfbmXmBkUTZFLDa871ceCBOkQmLd6kixgcnnwlYjqtpgTsoZVstbSf5YCHmz4+e41KzpdMZoLNpQ004lxm9WK7X9pvgpkleBAHIUy0giT+voWY7mRsQPBtzXN5IbdVRyjDia8Sqv4JXqvQUTatSz/M10gB1r2A0j/mYp5fB9ZPMBCrdtsn78FETsYoCPGYpljotCUElh6aTGdzPRM2wWxQeE+UpzSmfrME8c2M5Vm/CXDkJrudKx7LtSnGMcM8VV+H/23h0/EOCNxVux7rpcg==
Received: from CH2PR02CA0030.namprd02.prod.outlook.com (2603:10b6:610:4e::40)
 by BN5PR12MB9538.namprd12.prod.outlook.com (2603:10b6:408:2ac::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Wed, 3 Sep
 2025 22:11:29 +0000
Received: from CH3PEPF0000000C.namprd04.prod.outlook.com
 (2603:10b6:610:4e:cafe::b4) by CH2PR02CA0030.outlook.office365.com
 (2603:10b6:610:4e::40) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.28 via Frontend Transport; Wed,
 3 Sep 2025 22:11:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH3PEPF0000000C.mail.protection.outlook.com (10.167.244.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Wed, 3 Sep 2025 22:11:29 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 15:11:13 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 15:11:13 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Wed, 3 Sep 2025 15:11:12 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <dakr@kernel.org>,
	<acurrid@nvidia.com>, <cjia@nvidia.com>, <smitra@nvidia.com>,
	<ankita@nvidia.com>, <aniketa@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC v2 00/14] Introduce NVIDIA GPU Virtualization (vGPU) Support
Date: Wed, 3 Sep 2025 15:10:57 -0700
Message-ID: <20250903221111.3866249-1-zhiw@nvidia.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000C:EE_|BN5PR12MB9538:EE_
X-MS-Office365-Filtering-Correlation-Id: bcb13513-6d36-4bbf-2625-08ddeb36d55b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?826LDxbWnf65yG6l5VH3qbH96iIiqR9Zd0UkGQYJDrb4JUvqpmMqY/w07BXs?=
 =?us-ascii?Q?ShrbkCq1RjGH7N8JO5G+EvoCLgwWTAa7isJPKct4ecWspgJqypaOZSEPa2d2?=
 =?us-ascii?Q?sPkc+pycN5zOXJyHOZngkbvSGt4y6ltuPOU85wmmyrlghxQvKKnWdrYEvwwG?=
 =?us-ascii?Q?d4ql65SzHC8n2ZSC0nFbMVD+FYQBPr7S4huydZ0zJVKngsqG7plDBw2LTp/c?=
 =?us-ascii?Q?avuMVls9fNzHcyiiPxXeQc4qgad0m44aJplkgyTthDrYr5RGINLYuN2cOTGU?=
 =?us-ascii?Q?hPzzCj2/bWMMsImGnwrS9XOJKPjSWOfSHRAXFx+1sWPy2Qt3t7KeXW25rLSP?=
 =?us-ascii?Q?4jlqgAPZLO4jASpviJaoa2WukKMJThaxvUlSZf6bBn2kerLyPOIAzqZArzz2?=
 =?us-ascii?Q?2XoagNvcFhq0+sNEYCf0GKouxSyxuVoweHOW9qd7snXECO9ufS73uInT3GZT?=
 =?us-ascii?Q?YIeMx9Ba+g7p8bFhSZJnVf8GwhYmb1ThKIe6qihCVgyVqrwgP8B6tFDIaPug?=
 =?us-ascii?Q?pWKasNcsfGUPfmcAmtk+OnExkCa4dus940LzN8LqGogv7Y3Pnxl1/9Rv4/U4?=
 =?us-ascii?Q?duxjLdRUDbxulz96FJn2Ln8SJcyBjhzBmVzEPNJ1vs9KHpZA1hxHQPj/eGTO?=
 =?us-ascii?Q?BPQJAQkx5d97fa+jsF0VJDhxv8h+XWOZLcTLMw8vRS6fFSG+XY8/Q+BYnjKa?=
 =?us-ascii?Q?wAOV4s04RtD94DZhgaTD8EEHNmyMNINQKSJKUvLOoGCZZTXboxB0WvWQ79Pb?=
 =?us-ascii?Q?6sTS/JgLM3t3O3vK4pQnhBU/zfBZQqc+w+jkC5yl0KXnDWW3rJg1yIgGTwbS?=
 =?us-ascii?Q?4C/E+tUFG20SqtLuijeMm0nbILMZZX1AfBbYRxmVQ1jy0PLESPxgPsT2MevZ?=
 =?us-ascii?Q?BVK7VQll33tKUWW9HsToiI56DLxblEvTmiK1KI4bz1DSk/m6PQFXluIdRFJl?=
 =?us-ascii?Q?N6SEcOAc4ZrN3S4U1bf5w6vKWf+l4qjG23l9knCD25pbAmQ0ynXh5aJPuX+u?=
 =?us-ascii?Q?LVtaSkmcMbJMjm/7oEBdv38JeM2s2IAHhID2GZww7BhhjZT8VJRz4oDnZMbB?=
 =?us-ascii?Q?Rky1fh/Vxp06Dj6iBCH8gdP8Qs4BFlaCW3PV0wRppnpZu6+5I246wx/Baw2G?=
 =?us-ascii?Q?KbCTckettOipiuZlfxa3JPdcfhWgqHwTPCODO8WeCwPxzqjJDDPmvGnd/aW6?=
 =?us-ascii?Q?s8zkYVfnCqiFpL6D+nURAKSkrVau8ZHAwowj5h9sq5AIp1NWcb1X+BEW69xZ?=
 =?us-ascii?Q?HzP/7uq95LWOZNxYHPr5/ZrBWScY2CbpnYi+BFsWzcyVLG4jDHirunrAQI32?=
 =?us-ascii?Q?w3jc5yvD5MT6yfCFiL5fKMl4PXUUMXP6bfNMKBFeg/tie5aM91hIHj5zml1u?=
 =?us-ascii?Q?xlQNO5osiA7bos6MsIh4lBgFD+Bt8/obgsshPUXDDqWa+M6rRBsvHPgP64Fl?=
 =?us-ascii?Q?AukKXR2VxH6MDgNN244JsTeOlkLl50YnFyRWboUTH4LDOz6qUdKZaWvwrWxy?=
 =?us-ascii?Q?oU3Twqq6Xy0dPnEWWFF4b0nvk5Ye+vhV7DUS9+SuM4mDEnaJdpNT2oH3MQ?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 22:11:29.5291
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bcb13513-6d36-4bbf-2625-08ddeb36d55b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9538

1. Background
=============

NVIDIA vGPU[1] software enables powerful GPU performance for workloads
ranging from graphics-rich virtual workstations to data science and AI,
enabling IT to leverage the management and security benefits of
virtualization as well as the performance of NVIDIA GPUs required for
modern workloads. Installed on a physical GPU in a cloud or enterprise
data center server, NVIDIA vGPU software creates virtual GPUs that can
be shared across multiple virtual machines.

The vGPU architecture[2] can be illustrated as follow:

 +--------------------+    +--------------------+ +--------------------+ +--------------------+ 
 | Hypervisor         |    | Guest VM           | | Guest VM           | | Guest VM           | 
 |                    |    | +----------------+ | | +----------------+ | | +----------------+ | 
 | +----------------+ |    | |Applications... | | | |Applications... | | | |Applications... | | 
 | |  NVIDIA        | |    | +----------------+ | | +----------------+ | | +----------------+ | 
 | |  Virtual GPU   | |    | +----------------+ | | +----------------+ | | +----------------+ | 
 | |  Manager       | |    | |  Guest Driver  | | | |  Guest Driver  | | | |  Guest Driver  | | 
 | +------^---------+ |    | +----------------+ | | +----------------+ | | +----------------+ | 
 |        |           |    +---------^----------+ +----------^---------+ +----------^---------+ 
 |        |           |              |                       |                      |           
 |        |           +--------------+-----------------------+----------------------+---------+ 
 |        |                          |                       |                      |         | 
 |        |                          |                       |                      |         | 
 +--------+--------------------------+-----------------------+----------------------+---------+ 
+---------v--------------------------+-----------------------+----------------------+----------+
| NVIDIA                  +----------v---------+ +-----------v--------+ +-----------v--------+ |
| Physical GPU            |   Virtual GPU      | |   Virtual GPU      | |   Virtual GPU      | |
|                         +--------------------+ +--------------------+ +--------------------+ |
+----------------------------------------------------------------------------------------------+

Each NVIDIA vGPU is analogous to a conventional GPU, having a fixed amount
of GPU framebuffer, and one or more virtual display outputs or "heads".
The vGPU's framebuffer is allocated out of the physical GPU's framebuffer
at the time the vGPU is created, and the vGPU retains exclusive use of
that framebuffer until it is destroyed.

Each physical GPU can support several different types of virtual GPU
(vGPU). vGPU types have a fixed amount of frame buffer, number of
supported display heads, and maximum resolutions. They are grouped into
different series according to the different classes of workload for which
they are optimized. Each series is identified by the last letter of the
vGPU type name.

NVIDIA vGPU supports Windows and Linux guest VM operating systems. The
supported vGPU types depend on the guest VM OS.

2. Proposal For Upstream
========================

2.1 Architecture
----------------

Moving to the upstream, the proposed architecture can be illustrated as followings:

                            +--------------------+ +--------------------+ +--------------------+ 
                            | Linux VM           | | Windows VM         | | Guest VM           | 
                            | +----------------+ | | +----------------+ | | +----------------+ | 
                            | |Applications... | | | |Applications... | | | |Applications... | | 
                            | +----------------+ | | +----------------+ | | +----------------+ | ... 
                            | +----------------+ | | +----------------+ | | +----------------+ | 
                            | |  Guest Driver  | | | |  Guest Driver  | | | |  Guest Driver  | | 
                            | +----------------+ | | +----------------+ | | +----------------+ | 
                            +---------^----------+ +----------^---------+ +----------^---------+ 
                                      |                       |                      |           
                           +--------------------------------------------------------------------+
                           |+--------------------+ +--------------------+ +--------------------+|
                           ||       QEMU         | |       QEMU         | |       QEMU         ||
                           ||                    | |                    | |                    ||
                           |+--------------------+ +--------------------+ +--------------------+|
                           +--------------------------------------------------------------------+
                                      |                       |                      |
+-----------------------------------------------------------------------------------------------+
|                           +----------------------------------------------------------------+  |
|                           |                                VFIO                            |  |
|                           |                                                                |  |
| +-----------------------+ | +-------------------------------------------------------------+|  |
| |                       | | |                                                             ||  |
| |     nova_core        <--->|                                                             ||  |
| +    (core driver)      + | |                      NVIDIA vGPU VFIO Driver                ||  |
| |                       | | |                                                             ||  |
| |                       | | +-------------------------------------------------------------+|  |
| +--------^--------------+ +----------------------------------------------------------------+  |
|          |                          |                       |                      |          |
+-----------------------------------------------------------------------------------------------+
           |                          |                       |                      |           
+----------|--------------------------|-----------------------|----------------------|----------+
|          v               +----------v---------+ +-----------v--------+ +-----------v--------+ |
|  NVIDIA                  |       PCI VF       | |       PCI VF       | |       PCI VF       | |
|  Physical GPU            |                    | |                    | |                    | |
|                          |   (Virtual GPU)    | |   (Virtual GPU)    | |    (Virtual GPU)   | |
|                          +--------------------+ +--------------------+ +--------------------+ |
+-----------------------------------------------------------------------------------------------+

Each virtual GPU (vGPU) instance is implemented atop a PCIe Virtual
Function (VF). The NVIDIA vGPU VFIO driver, in coordination with the
VFIO framework, operates directly on these VFs to enable key
functionalities including vGPU type selection, dynamic instantiation and
destruction of vGPU instances, support for live migration, and warm
update.

Consistent with other VFIO variant drivers, the NVIDIA vGPU VFIO driver
adheres to the standard VFIO userspace interface, facilitating device
lifecycle management and integration with advanced VFIO capabilities.

At the low level, the NVIDIA vGPU VFIO driver interfaces with the core
driver, which provides the necessary abstractions and mechanisms to access
and manipulate the underlying GPU hardware resources.

2.2 Core Driver (nova_core)
---------------------------

The primary deployment model for cloud service providers (CSPs) and
enterprise environments is to have a standalone, minimal driver stack
with the vGPU support and other essential components. Thus, a minimal
core driver is required to support the NVIDIA vGPU VFIO driver.

The core GPU driver provides the foundational infrastructure necessary
to support the following operations:

- Firmware management: Load the GSP (GPU System Processor) firmware,
initiate GSP boot procedures, and establish the communication channel
between the host and the GSP.

- Hardware resource management: Control and partition shared GPU
resources-such as framebuffer memory and hardware channels-used by the
VFIO driver for instantiating and operating vGPUs.

- Exception handling: Relay hardware and firmware-level exception events,
including GSP notifications, to the VFIO driver. E.g. FIFO nonstall.

- Host event coordination: Handle system-wide events such as suspend and
resume, PF driver unbind, etc. ensuring proper synchronization with GPU
subsystems.

- Hardware configuration enumeration: Discover and expose static and
dynamic hardware capabilities required for vGPU orchestration. E.g.
engine bitmap, total FB memory size.

2.3 NVIDIA vGPU VFIO Driver
---------------------------

The NVIDIA vGPU VFIO driver exposes standard VFIO interfaces for userspace
access to vGPUs, while also providing control paths for vGPU creation and
destruction with the help of core driver.

The driver provides an additional sysfs interface for the admin to query
the creatable vGPU types on a VF. Once the vGPU type is selected, the
userspace VMM, e.g. QEMU can manipulate the VF via the standard VFIO
device interfaces. Only homogeneous vGPU has been supported.

As different NVIDIA GPUs support different available vGPU types, a
loadable vGPU metadata file is introduced to host those blobs,
which are the support vGPU types on supported NVIDIA GPUs. It is loaded
together with the VFIO driver. The VFIO driver chooses the usable vGPU
types from it based on the installed NVIDIA GPU in the system.

The driver also exposes an per-vGPU logging interface to collect the GSP
logs for bug report.

2.4 Changes from RFC [3]
-----------------------------

- vGPU is supported since GSP microcode 570.
- Multiple vGPU support with homogeneous scheme.
- CE workload submission for FB memory scrubbing.
- Interface to create/destroy/select vGPUs.
- Loadable vGPU type support via vGPU metadata file.
- Expose per-vGPU GSP log.
- Proper VFIO driver attach/detach flow.
- PF driver event forwarding to support PF driver unbind by admin.

3 Try the patches
-----------------------

- Host kernel: http://github.com/zhiwang-nvidia/linux/tree/zhi/vgpu-rfc-v2
- vGPU metadata file: https://github.com/zhiwang-nvidia/vgpu-tools/blob/metadata/metadata/18.1/vgpu-570.144.bin
  The metadata file needs to be placed at: /lib/firmware/nvidia
- Guest driver package: NVIDIA-Linux-x86_64-570.124.04.run [4]

  Install guest driver:
  # export GRID_BUILD=1
  # ./NVIDIA-Linux-x86_64-570.124.04.run

- Tested platforms: RTX A6000 Ada.
- Tested host OS: RHEL 8.4.
- Tested guest OS: Ubutnu 24.04 LTS, Windows 11.
- Supported experience: Rich desktop experience with simple 3D workload,
  e.g. glmark2, heaven.

- Demo video: running heaven on two -24Q vGPUs on NVIDIA RTX A6000 Ada [5]

[1] https://www.nvidia.com/en-us/data-center/virtual-solutions/
[2] https://docs.nvidia.com/vgpu/17.0/grid-vgpu-user-guide/index.html#architecture-grid-vgpu
[3] https://lore.kernel.org/kvm/20240922161121.000060a0.zhiw@nvidia.com/T/
[4] https://us.download.nvidia.com/XFree86/Linux-x86_64/570.124.04/NVIDIA-Linux-x86_64-570.124.04.run
[5] https://youtu.be/DhW--wVlLfU

Zhi Wang (14):
  vfio/nvidia-vgpu: introduce vGPU lifecycle management prelude
  vfio/nvidia-vgpu: allocate GSP RM client for NVIDIA vGPU manager
  vfio/nvidia-vgpu: introduce vGPU type uploading
  vfio/nvidia-vgpu: allocate vGPU channels when creating vGPUs
  vfio/nvidia-vgpu: allocate vGPU FB memory when creating vGPUs
  vfio/nvidia-vgpu: allocate mgmt heap when creating vGPUs
  vfio/nvidia-vgpu: map mgmt heap when creating a vGPU
  vfio/nvidia-vgpu: allocate GSP RM client when creating vGPUs
  vfio/nvidia-vgpu: bootload the new vGPU
  vfio/nvidia-vgpu: introduce vGPU host RPC channel
  vfio/nvidia-vgpu: introduce NVIDIA vGPU VFIO variant driver
  vfio/nvidia-vgpu: scrub the guest FB memory of a vGPU
  vfio/nvidia-vgpu: introduce vGPU logging
  vfio/nvidia-vgpu: add a kernel doc to introduce NVIDIA vGPU

 .../ABI/stable/sysfs-driver-nvidia-vgpu       |  11 +
 Documentation/gpu/drivers.rst                 |   1 +
 Documentation/gpu/nvidia-vgpu.rst             | 264 +++++++
 drivers/vfio/pci/Kconfig                      |   2 +
 drivers/vfio/pci/Makefile                     |   2 +
 drivers/vfio/pci/nvidia-vgpu/Kconfig          |  15 +
 drivers/vfio/pci/nvidia-vgpu/Makefile         |   6 +
 drivers/vfio/pci/nvidia-vgpu/debug.h          |  35 +
 drivers/vfio/pci/nvidia-vgpu/debugfs.c        |  65 ++
 .../pci/nvidia-vgpu/include/nvrm/bootload.h   |  58 ++
 .../vfio/pci/nvidia-vgpu/include/nvrm/ecc.h   |  45 ++
 .../vfio/pci/nvidia-vgpu/include/nvrm/gsp.h   |  18 +
 .../nvidia-vgpu/include/nvrm/nv_vgpu_types.h  |  34 +
 .../pci/nvidia-vgpu/include/nvrm/nvtypes.h    |  26 +
 .../vfio/pci/nvidia-vgpu/include/nvrm/vgpu.h  | 182 +++++
 .../vfio/pci/nvidia-vgpu/include/nvrm/vmmu.h  |  39 +
 drivers/vfio/pci/nvidia-vgpu/metadata.c       | 319 ++++++++
 drivers/vfio/pci/nvidia-vgpu/metadata.h       |  89 +++
 .../vfio/pci/nvidia-vgpu/metadata_vgpu_type.c | 153 ++++
 drivers/vfio/pci/nvidia-vgpu/pf.h             | 145 ++++
 drivers/vfio/pci/nvidia-vgpu/rpc.c            | 254 ++++++
 drivers/vfio/pci/nvidia-vgpu/vfio.h           |  65 ++
 drivers/vfio/pci/nvidia-vgpu/vfio_access.c    | 313 ++++++++
 drivers/vfio/pci/nvidia-vgpu/vfio_debugfs.c   | 117 +++
 drivers/vfio/pci/nvidia-vgpu/vfio_main.c      | 730 ++++++++++++++++++
 drivers/vfio/pci/nvidia-vgpu/vfio_sysfs.c     | 209 +++++
 drivers/vfio/pci/nvidia-vgpu/vgpu.c           | 690 +++++++++++++++++
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c       | 450 +++++++++++
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h       | 231 ++++++
 29 files changed, 4568 insertions(+)
 create mode 100644 Documentation/ABI/stable/sysfs-driver-nvidia-vgpu
 create mode 100644 Documentation/gpu/nvidia-vgpu.rst
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/Kconfig
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/Makefile
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/debug.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/debugfs.c
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/include/nvrm/bootload.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/include/nvrm/ecc.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/include/nvrm/gsp.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/include/nvrm/nv_vgpu_types.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/include/nvrm/nvtypes.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/include/nvrm/vgpu.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/include/nvrm/vmmu.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/metadata.c
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/metadata.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/metadata_vgpu_type.c
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/pf.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/rpc.c
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/vfio.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/vfio_access.c
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/vfio_debugfs.c
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/vfio_main.c
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/vfio_sysfs.c
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/vgpu.c
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h

-- 
2.34.1


