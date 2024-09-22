Return-Path: <kvm+bounces-27246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 70DC497E1A0
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 14:50:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D8B521F2127F
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 12:50:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D17B33E1;
	Sun, 22 Sep 2024 12:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="h7qM+Go1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2086.outbound.protection.outlook.com [40.107.243.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84EA728F1
	for <kvm@vger.kernel.org>; Sun, 22 Sep 2024 12:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727009437; cv=fail; b=gX6BMrc7U8uNfogIhPjDYAAGBVDIX1ZphyZ7wSOv29pRwF1nkpFleJi6s0V6Zr+7/6OPhMTCCzaTYqvEaCtQOEKBgLfgUadxTXOFLEFwnGu4ZR9IjKFG3wnQ1HnKElhJg1qqso3ACKXzdnqWxtp/hAAJBF+yUO6JeQRvKTtrmT4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727009437; c=relaxed/simple;
	bh=pmFx2X/IcBHZeL9xzBjey5gCrUe46pAfLj730wmYEh8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NikwyS44IyNyB7U5h5oD8HYNUqOIFRGBFmPrhoUOJXyb0nraLMaUwyRNFv8ys6fM9Zokm0Jqkr6DCPHNkfgYntvBVfID1O1GgXIAfkLXMIP4T7+br0RzC4fW4SEKjqVllWUrAOZWEYlCZaDnmIaOm1DiX6rgb+oi1NDCClLW3FI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=h7qM+Go1; arc=fail smtp.client-ip=40.107.243.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vgee7yE7pvxnLb+M2qmngQTgWJzrbTE8f5XrqJFn5eepCkg+G7pb2VcjbiP6WhOWKnDv0C7QXtcZyxfsIn3gjE4Gkq3g8pv2lpjBwxIE4zz3/H1ZY6Gn/lI0YnrvPXsSbnwMvHUx0pmBsxDKUVRkxYHSM7PH7/CWScp6kGUVdJ8poY1Z0KAOjdz+ivX8QfBCNxz47G8a+hrLK3xD8f5ww70r9P0iCeY36wtGXqoYrugUgBE9AxmY/f8crHjXADLKR0YkC+25y5ur9mivGYOLsThpxGt55+2f39kFx0KXVbGYb8Th4Uio/lqgh3LNWybUi12PhG67Q/NQ8SA0wNHoQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VM85rHyFio4KP2ItRCfRp+6Z89SWuqsy/uI1NuI+Tm0=;
 b=qrTZ5zSnMj1YMShdlgqvloGtxLNFtCQhZsgBGuhHxrlMW/gKOzE1msIfnTvUz+6yjivN9eQErieNK2PwVNTdrLsbVg38pVxqlZod5ZqVsnzYKH7wXW4jOQ5yH+KtCoErb0kvNsiSYnieF3YSpa63vppqZ7j/q9abAb7ud7blaYxbNc1VVnic5u9zEwatBcAhMWUReD6XWmj5sCpO5dvV2M2Z7N35qgCd7zIkUcI6CXoq2MUYkOwxAbNBQKYoAgu1r9ZUa23YLBdKMPDASxu+GPSoJDHYTfMIAQVgvk/fiR7pT27d4OeFA9S1XrZOQywnW3VVDGB3xqKeVOxPgBT/8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VM85rHyFio4KP2ItRCfRp+6Z89SWuqsy/uI1NuI+Tm0=;
 b=h7qM+Go1fy01VpmZUVnkJinDxWIHzeOjQ3vPgiPqc/Uv4qe6fpPuPa6vObBIuiMtUY2UvI1YL1rtYShA49SiupptpFpDbbjQaAFeXDfsip9+QzkORQUUHCfWvy3iEbYVVWZS0LpA6Y1oQwEjPZkyjyRN46Ws8XP7p+u76+NeNDq8G2sp1kaLbr7zNIC2HmEuek+EYWfcwVxh5WysTajlOHhBjTypEQvXmgeVW+HMdiPBRnof7gwWC63URC2fVcuJ/epmdK4G40vhEeEEB0thb3841IeZolGsWYzYAeUtjkAHprnwaWUtDKtI2N+WvbPzPAd97PVQx4RiUBK7mqmrtg==
Received: from BYAPR02CA0040.namprd02.prod.outlook.com (2603:10b6:a03:54::17)
 by SJ0PR12MB5611.namprd12.prod.outlook.com (2603:10b6:a03:426::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.25; Sun, 22 Sep
 2024 12:50:28 +0000
Received: from CO1PEPF000075F4.namprd03.prod.outlook.com
 (2603:10b6:a03:54:cafe::59) by BYAPR02CA0040.outlook.office365.com
 (2603:10b6:a03:54::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.29 via Frontend
 Transport; Sun, 22 Sep 2024 12:50:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1PEPF000075F4.mail.protection.outlook.com (10.167.249.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Sun, 22 Sep 2024 12:50:28 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 22 Sep
 2024 05:50:19 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Sun, 22 Sep 2024 05:50:18 -0700
Received: from inno-linux.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Sun, 22 Sep 2024 05:50:18 -0700
From: Zhi Wang <zhiw@nvidia.com>
To: <kvm@vger.kernel.org>, <nouveau@lists.freedesktop.org>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <acurrid@nvidia.com>,
	<cjia@nvidia.com>, <smitra@nvidia.com>, <ankita@nvidia.com>,
	<aniketa@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <zhiwang@kernel.org>
Subject: [RFC 00/29] Introduce NVIDIA GPU Virtualization (vGPU) Support
Date: Sun, 22 Sep 2024 05:49:22 -0700
Message-ID: <20240922124951.1946072-1-zhiw@nvidia.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F4:EE_|SJ0PR12MB5611:EE_
X-MS-Office365-Filtering-Correlation-Id: c440f067-2a4b-4cae-eea6-08dcdb05229b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OW9kMnBZK0xLQklOMFlBUmprVW5obGhUUnl5L0lZdXArK3cxMThWL3dqeG5L?=
 =?utf-8?B?clJ2cWlLTVl3bFl2TUNTVDdzelM1WGw0SmhIQ2tva0NrNzlmSCtmc0ZJQ3hO?=
 =?utf-8?B?S2M2a2o4bU1SOHVNWmh3WU0wSVRZQlRuS21DeUNVQzFRV3RFZktyV2JHR1pZ?=
 =?utf-8?B?L3M4bVYrVVFvaTAybE5abzBldndxVWVCVkU4SFhFanlJYWV4TEhkS1hSeTNq?=
 =?utf-8?B?SXNvWmU2TklkVjNWeXhteUhCZ0tSV2syd29QSlN3ZGVpWUVrNEZhem1UcEdJ?=
 =?utf-8?B?c0tSVkdTYnpVWHc5c2RFSXNNcXIrN1c4c2dmdE1haDJZam1PdmFLR0ZtTElO?=
 =?utf-8?B?cHpJUXZhbGtuUjJQeW16NnhrM0NCV0lVWGNRbE9HVkJha05FckVUbmdnY3Zv?=
 =?utf-8?B?YjhscGJPeWZiT0NaUjU3WnNWcWZiNFprak5hVkZTZW9wMXV0ZUNYYkZMM0VK?=
 =?utf-8?B?ZHpzTEtmVzNUQ2ROYmNvMGd2K0VTRTZubWJkVVRtSFFHQ2ZvRkU2N3BPclR5?=
 =?utf-8?B?T2N4THR4UzZmbmtEUmxxc2lWL1NmTFJzdzhzRWhMQ05mdWZlUmlLZmxoYXVt?=
 =?utf-8?B?VlltQVphT3hxY2hHMmdhWnlrK3JScHhSdHVkZHNmVnVLYVZSL1BxdC9NaDBY?=
 =?utf-8?B?bGZ0OWZ1L2ZnY3VQV3UzajhiWkJ4dFpPRnozTlpRbDYzY2YwYUpZNVVjMGtF?=
 =?utf-8?B?MmtOVHJhS0c0UlJ6OHJ0cDVQSzI5ZFVSMUdQeHQvMUpyNm90cDc1amZzRXJL?=
 =?utf-8?B?SWM1djdZOXlRNlhHMm1Sd2RJMVdUSUxnM0U4ajRBNlVIS3NJWTBscEJmUklG?=
 =?utf-8?B?djZhTXVGQ0ZQMDI0VzY3U1RmcHBLc0FhelZMYU83YjF6eGdHTmRJNTg1V2ls?=
 =?utf-8?B?UjQ5eUZVVTEwcnZ5NDZSYVMzRTNpcUFNd1lFVU9QQjdyK2ZqV1F2aGY3ODJH?=
 =?utf-8?B?T1YrNWpCQ0RkQ255QXIxS3ZkN0o0OHVaYjBOV0thRGVZRGZVRDVVL1hQU3R6?=
 =?utf-8?B?WjEycTJJaDNsMDBpdGZVZW5mWkNRUXRoK3hYalZOYk5DSUgzUlZhU04vNkdT?=
 =?utf-8?B?TjBmY1dDSDRjU2xEOUtISE15QjJNbHBJSXQxTTYzYzQxbmNJYk5ZL1d6UFdU?=
 =?utf-8?B?OHJDVlNwREVIK2lLZ2E2MGtWVm5qTnZMVlllL25kK1MwcHhuaWl2TFlPcG1n?=
 =?utf-8?B?eWp0ajF6ajRSUy9KbmxKTW16MUF0cDVPZjhvZFM4Rk9DblUwaXZFKzRPTEJG?=
 =?utf-8?B?bjcxVWxoNVpicytiQXpsVVhtUy8yT05yQWlUUVBkbUJpUDA0eThjQTZkdWZK?=
 =?utf-8?B?VmZQVVYydkwyZ1p5VVhQZW9ONkc4Z3g0ZlhqN2VEUGIvU3ZpNGxkc3ExK1hv?=
 =?utf-8?B?SWJwZHM5alYySWxZVGJJeUZEOXBYQUg3a2g5cVNGdUhIRlNzWVlmM2ZPc1NC?=
 =?utf-8?B?UStrVEJsdTM0OEdKME9VSUhUSjljUzk4eEVLTG1OQytPYVJuYVBtWDhVb0dB?=
 =?utf-8?B?UjlTMzI2NXRGODJHNmJ6NHJHTzBHSVpPOHNwVXh2QWkvWmViWHZOL1F1Vlor?=
 =?utf-8?B?T1dkVjJybmd0djk2MXVRZitWZzB2L2hRUkRLYjdBbGluNlNvUFZucWwvL2o0?=
 =?utf-8?B?SU5yQ29lQ2VDTG80bVJKeG02VzdodXlEaTlTdXBXa2E1ZkhFMWJaTUpnSXhm?=
 =?utf-8?B?Ujg2ZWk1cFlSZHVXZ0F0Ti9BaEI0d1FmNGpYbzd1eE4zOVhia05JMmR1RXVM?=
 =?utf-8?B?NUpzalZkNVc0KzNzSnRxUEJaTHdueE5Bcm5WcENzSnR6eHVod2JUYXBwdUdR?=
 =?utf-8?B?cHJyN1NsOXJzdnhtT1N1OEFydjFLODJ3ZElVdzVxUllSV0JwdlR2Y1p0QXpm?=
 =?utf-8?B?MFRZTEZiZjJJWVFLQVNXSFI0c2JTejcwZWRTSm12MThuVTg0RFN1K282R0pU?=
 =?utf-8?Q?m3lse/KdxhilCt5UDQ+K05eqOQLsmee/?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2024 12:50:28.0950
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c440f067-2a4b-4cae-eea6-08dcdb05229b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5611

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
The vGPU’s framebuffer is allocated out of the physical GPU’s framebuffer
at the time the vGPU is created, and the vGPU retains exclusive use of
that framebuffer until it is destroyed.

The number of physical GPUs that a board has depends on the board. Each
physical GPU can support several different types of virtual GPU (vGPU).
vGPU types have a fixed amount of frame buffer, number of supported
display heads, and maximum resolutions. They are grouped into different
series according to the different classes of workload for which they are
optimized. Each series is identified by the last letter of the vGPU type
name.

NVIDIA vGPU supports Windows and Linux guest VM operating systems. The
supported vGPU types depend on the guest VM OS.

2. Proposal for upstream
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
| +-----------------------+ | +------------------------+  +---------------------------------+|  |
| |  Core Driver vGPU     | | |                        |  |                                 ||  |
| |       Support        <--->|                       <---->                                ||  |
| +-----------------------+ | | NVIDIA vGPU Manager    |  | NVIDIA vGPU VFIO Variant Driver ||  |
| |    NVIDIA GPU Core    | | |                        |  |                                 ||  |
| |        Driver         | | +------------------------+  +---------------------------------+|  |
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

The supported GPU generations will be Ada which come with the supported
GPU architecture. Each vGPU is backed by a PCI virtual function.

The NVIDIA vGPU VFIO module together with VFIO sits on VFs, provides
extended management and features, e.g. selecting the vGPU types, support
live migration and driver warm update.

Like other devices that VFIO supports, VFIO provides the standard
userspace APIs for device lifecycle management and advance feature
support.

The NVIDIA vGPU manager provides necessary support to the NVIDIA vGPU VFIO
variant driver to create/destroy vGPUs, query available vGPU types, select
the vGPU type, etc.

On the other side, NVIDIA vGPU manager talks to the NVIDIA GPU core driver,
which provide necessary support to reach the HW functions.

2.2 Requirements to the NVIDIA GPU core driver
----------------------------------------------

The primary use case of CSP and enterprise is a standalone minimal
drivers of vGPU manager and other necessary components.

NVIDIA vGPU manager talks to the NVIDIA GPU core driver, which provide
necessary support to:

- Load the GSP firmware, boot the GSP, provide commnication channel.
- Manage the shared/partitioned HW resources. E.g. reserving FB memory,
  channels for the vGPU mananger to create vGPUs.
- Exception handling. E.g. delivering the GSP events to vGPU manager.
- Host event dispatch. E.g. suspend/resume.
- Enumerations of HW configuration.

The NVIDIA GPU core driver, which sits on the PCI device interface of
NVIDIA GPU, provides support to both DRM driver and the vGPU manager.

In this RFC, the split nouveau GPU driver[3] is used as an example to
demostrate the requirements of vGPU manager to the core driver. The
nouveau driver is split into nouveau (the DRM driver) and nvkm (the core
driver).

3 Try the RFC patches
-----------------------

The RFC supports to create one VM to test the simple GPU workload.

- Host kernel: https://github.com/zhiwang-nvidia/linux/tree/zhi/vgpu-mgr-rfc
- Guest driver package: NVIDIA-Linux-x86_64-535.154.05.run [4]

  Install guest driver:
  # export GRID_BUILD=1
  # ./NVIDIA-Linux-x86_64-535.154.05.run

- Tested platforms: L40.
- Tested guest OS: Ubutnu 24.04 LTS.
- Supported experience: Linux rich desktop experience with simple 3D
  workload, e.g. glmark2

4 Demo
------

A demo video can be found at: https://youtu.be/YwgIvvk-V94

[1] https://www.nvidia.com/en-us/data-center/virtual-solutions/
[2] https://docs.nvidia.com/vgpu/17.0/grid-vgpu-user-guide/index.html#architecture-grid-vgpu
[3] https://lore.kernel.org/dri-devel/20240613170211.88779-1-bskeggs@nvidia.com/T/
[4] https://us.download.nvidia.com/XFree86/Linux-x86_64/535.154.05/NVIDIA-Linux-x86_64-535.154.05.run

Zhi Wang (29):
  nvkm/vgpu: introduce NVIDIA vGPU support prelude
  nvkm/vgpu: attach to nvkm as a nvkm client
  nvkm/vgpu: reserve a larger GSP heap when NVIDIA vGPU is enabled
  nvkm/vgpu: set the VF partition count when NVIDIA vGPU is enabled
  nvkm/vgpu: populate GSP_VF_INFO when NVIDIA vGPU is enabled
  nvkm/vgpu: set RMSetSriovMode when NVIDIA vGPU is enabled
  nvkm/gsp: add a notify handler for GSP event
    GPUACCT_PERFMON_UTIL_SAMPLES
  nvkm/vgpu: get the size VMMU segment from GSP firmware
  nvkm/vgpu: introduce the reserved channel allocator
  nvkm/vgpu: introduce interfaces for NVIDIA vGPU VFIO module
  nvkm/vgpu: introduce GSP RM client alloc and free for vGPU
  nvkm/vgpu: introduce GSP RM control interface for vGPU
  nvkm: move chid.h to nvkm/engine.
  nvkm/vgpu: introduce channel allocation for vGPU
  nvkm/vgpu: introduce FB memory allocation for vGPU
  nvkm/vgpu: introduce BAR1 map routines for vGPUs
  nvkm/vgpu: introduce engine bitmap for vGPU
  nvkm/vgpu: introduce pci_driver.sriov_configure() in nvkm
  vfio/vgpu_mgr: introdcue vGPU lifecycle management prelude
  vfio/vgpu_mgr: allocate GSP RM client for NVIDIA vGPU manager
  vfio/vgpu_mgr: introduce vGPU type uploading
  vfio/vgpu_mgr: allocate vGPU FB memory when creating vGPUs
  vfio/vgpu_mgr: allocate vGPU channels when creating vGPUs
  vfio/vgpu_mgr: allocate mgmt heap when creating vGPUs
  vfio/vgpu_mgr: map mgmt heap when creating a vGPU
  vfio/vgpu_mgr: allocate GSP RM client when creating vGPUs
  vfio/vgpu_mgr: bootload the new vGPU
  vfio/vgpu_mgr: introduce vGPU host RPC channel
  vfio/vgpu_mgr: introduce NVIDIA vGPU VFIO variant driver

 .../drm/nouveau/include/nvkm/core/device.h    |   3 +
 .../drm/nouveau/include/nvkm/engine/chid.h    |  29 +
 .../gpu/drm/nouveau/include/nvkm/subdev/gsp.h |   1 +
 .../nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h  |  45 ++
 .../nvidia/inc/ctrl/ctrl2080/ctrl2080gpu.h    |  12 +
 drivers/gpu/drm/nouveau/nvkm/Kbuild           |   1 +
 drivers/gpu/drm/nouveau/nvkm/device/pci.c     |  33 +-
 .../gpu/drm/nouveau/nvkm/engine/fifo/chid.c   |  49 +-
 .../gpu/drm/nouveau/nvkm/engine/fifo/chid.h   |  26 +-
 .../gpu/drm/nouveau/nvkm/engine/fifo/r535.c   |   3 +
 .../gpu/drm/nouveau/nvkm/subdev/gsp/r535.c    |  14 +-
 drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/Kbuild  |   3 +
 drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vfio.c  | 302 +++++++++++
 .../gpu/drm/nouveau/nvkm/vgpu_mgr/vgpu_mgr.c  | 234 ++++++++
 drivers/vfio/pci/Kconfig                      |   2 +
 drivers/vfio/pci/Makefile                     |   2 +
 drivers/vfio/pci/nvidia-vgpu/Kconfig          |  13 +
 drivers/vfio/pci/nvidia-vgpu/Makefile         |   8 +
 drivers/vfio/pci/nvidia-vgpu/debug.h          |  18 +
 .../nvidia/inc/ctrl/ctrl0000/ctrl0000system.h |  30 +
 .../nvidia/inc/ctrl/ctrl2080/ctrl2080gpu.h    |  33 ++
 .../ctrl/ctrl2080/ctrl2080vgpumgrinternal.h   | 152 ++++++
 .../common/sdk/nvidia/inc/ctrl/ctrla081.h     | 109 ++++
 .../nvrm/common/sdk/nvidia/inc/dev_vgpu_gsp.h | 213 ++++++++
 .../common/sdk/nvidia/inc/nv_vgpu_types.h     |  51 ++
 .../common/sdk/vmioplugin/inc/vmioplugin.h    |  26 +
 .../pci/nvidia-vgpu/include/nvrm/nvtypes.h    |  24 +
 drivers/vfio/pci/nvidia-vgpu/nvkm.h           |  94 ++++
 drivers/vfio/pci/nvidia-vgpu/rpc.c            | 242 +++++++++
 drivers/vfio/pci/nvidia-vgpu/vfio.h           |  43 ++
 drivers/vfio/pci/nvidia-vgpu/vfio_access.c    | 297 ++++++++++
 drivers/vfio/pci/nvidia-vgpu/vfio_main.c      | 511 ++++++++++++++++++
 drivers/vfio/pci/nvidia-vgpu/vgpu.c           | 352 ++++++++++++
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c       | 144 +++++
 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h       |  89 +++
 drivers/vfio/pci/nvidia-vgpu/vgpu_types.c     | 466 ++++++++++++++++
 include/drm/nvkm_vgpu_mgr_vfio.h              |  61 +++
 37 files changed, 3702 insertions(+), 33 deletions(-)
 create mode 100644 drivers/gpu/drm/nouveau/include/nvkm/engine/chid.h
 create mode 100644 drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h
 create mode 100644 drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/Kbuild
 create mode 100644 drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vfio.c
 create mode 100644 drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vgpu_mgr.c
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/Kconfig
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/Makefile
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/debug.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/nvidia/inc/ctrl/ctrl0000/ctrl0000system.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/nvidia/inc/ctrl/ctrl2080/ctrl2080gpu.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/nvidia/inc/ctrl/ctrl2080/ctrl2080vgpumgrinternal.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/nvidia/inc/ctrl/ctrla081.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/nvidia/inc/dev_vgpu_gsp.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/nvidia/inc/nv_vgpu_types.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/vmioplugin/inc/vmioplugin.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/include/nvrm/nvtypes.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/nvkm.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/rpc.c
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/vfio.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/vfio_access.c
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/vfio_main.c
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/vgpu.c
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h
 create mode 100644 drivers/vfio/pci/nvidia-vgpu/vgpu_types.c
 create mode 100644 include/drm/nvkm_vgpu_mgr_vfio.h

-- 
2.34.1


