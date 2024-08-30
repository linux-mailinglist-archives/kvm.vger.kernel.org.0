Return-Path: <kvm+bounces-25497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49F60965FC2
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 12:59:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02A642834C8
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 10:59:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A786192D82;
	Fri, 30 Aug 2024 10:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lxShZy/y"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2066.outbound.protection.outlook.com [40.107.243.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA8018FDB3;
	Fri, 30 Aug 2024 10:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725015552; cv=fail; b=J3/97DSVAENQB7y6HUWRS5K8uyMWCrao4yfnR+1ho7K6YeT3FqOD1RhS4iWNrHUTkxBX1GzU73hOTf3o8f4mL1R7kp0kYBJkzsrEJHdVXlT3NTqglCdoxhfH5IyzmEN1/iBEwC7n8wAV+KGZfBz1nmXnGxabNffQ1qKW4ImWHXk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725015552; c=relaxed/simple;
	bh=tn4s4tBiYpj0n42TJGgEmRompR6wwKhbIOTQtGI/ciY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=spXJiQ2FZq47VQt78mB9puQfF++3aMx/GMOw3UTKuR1ff5WBuKCXUy5KvnzLEUOnsZdLdqjpfMzI+9F747ye9qpcxgdpPc4cXiDBP8P0MVhqqm0OLjkqO7pNwyU3rfiCLrXHWgFnawcrJfD3Yua7M596mWf0C4sn9+0FewgdN2U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lxShZy/y; arc=fail smtp.client-ip=40.107.243.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mi0yTSCQduFN1UHeoASwb8MFwqD+wwMQUEmV2OvUQZMGIDRA1UaGlsMzC4QrUMWHNmxbTxAoEQYVcxaXuhZaANS6BCZTPFO+mgvFpb7zP+nFLnlsjYCpb8vi+m6VJ5u0Q382d5gTR4LwSvJvvID3lKKD5nspOJlvUB2R93VSrlm1FFoqGbfX9PiK+YU2P91+zrCBpZPq1aFTRXM2Ag/WzXAZTdycW0EnT69snyKw53fGVnIRaTida0vN1pyd/3kHeFmOoEaMiUY687jGJE0r4xXdp/MXDkekefTjJ1XRnisc0WrNnHlHfvPm5oMaoJCjUolHI2hr45t7KbeyQXQbIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=egFs1+3kyUNJg/u17qwVCGzVrA02WuTse/J9FhA3Kvo=;
 b=oUINRjOKIg9LPp6gtBfUhhqJR1tq57G7xDlKssgoBYrnIS70K8xJUD+Ayp/Ef8NH2W7nzIoZlMQWUonoypL4wZb3XndVuCzAEno2oPKI0wuV7RMSS7wreAJp34KZ+Yf7JNXGeRnmClvdqqiqokVQamrlzx4sxK4Y4+NBtMoLZyIXQLel+rVCfu4upg1nNoz0f/cI5rMUw2UKPV9uAefBM6FXfNJtlQ1bOA70/4x36/EPkW5V+EZT1ZzfFpPTvDKl0lhE7eLign+hL9nZbNFM23rm7AGmWYj6U8UsELTC3J3BjRYgZIPRggRP1GdXDP4ejuaNPzM/ebBao8kMaYUOJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=egFs1+3kyUNJg/u17qwVCGzVrA02WuTse/J9FhA3Kvo=;
 b=lxShZy/yy81WK6G82WZV5/ywz640uqL1J2UAbaSSs0Ywdrq8TDIUASyWoramnx32DhwI5c8TsNjLtdv8dyqH2GlWOMV+jYnPWYqKEWkv/NSuK33EiBjNvyEG0PXLY5x6tXIsV4s2s787bwghc5fQtXbtmZ+73TRCzmL3GyFq0NDh/hmGLhWoGr3qa3+bK+Jf0KWI+TOfe+vpeaqKJrfomhr0MUICrLGuvME//hHYeg8FVJ82J6hXg9N86978MQEm+o8wYmqfrQxLZIdqahqqXLypbBUqyH3W4qQcX1riQsJqkbWaysudRDwbeOX6qddzd/OHDN6SIIcYOImSHQ/NAg==
Received: from MN2PR22CA0001.namprd22.prod.outlook.com (2603:10b6:208:238::6)
 by BL1PR12MB5899.namprd12.prod.outlook.com (2603:10b6:208:397::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Fri, 30 Aug
 2024 10:59:06 +0000
Received: from CH2PEPF000000A0.namprd02.prod.outlook.com
 (2603:10b6:208:238:cafe::f2) by MN2PR22CA0001.outlook.office365.com
 (2603:10b6:208:238::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28 via Frontend
 Transport; Fri, 30 Aug 2024 10:59:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH2PEPF000000A0.mail.protection.outlook.com (10.167.244.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Fri, 30 Aug 2024 10:59:06 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 30 Aug
 2024 03:58:56 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 30 Aug
 2024 03:58:56 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.1544.4 via
 Frontend Transport; Fri, 30 Aug 2024 03:58:53 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>, Si-Wei Liu
	<si-wei.liu@oracle.com>, <virtualization@lists.linux.dev>, Gal Pressman
	<gal@nvidia.com>
CC: Dragos Tatulea <dtatulea@nvidia.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v2 0/7] vdpa/mlx5: Optimze MKEY operations
Date: Fri, 30 Aug 2024 13:58:31 +0300
Message-ID: <20240830105838.2666587-2-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.45.1
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
X-MS-TrafficTypeDiagnostic: CH2PEPF000000A0:EE_|BL1PR12MB5899:EE_
X-MS-Office365-Filtering-Correlation-Id: 5be214a2-7cb9-4835-38ad-08dcc8e2c4a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K2RSMGxQV1FXRmZkZktwcWJRdVFvaU1ROTUrSUdKeGlzM2cxbUlmNy9QMTdj?=
 =?utf-8?B?QkEzbzIyNnVzc2NOcHJmQ1dORjdZUFhCKyt4d2dkY05QUEprNlFnQmxLR2dZ?=
 =?utf-8?B?WDFVWmdUVXFjQWcwbmlqc0VoQ0gweGhGYWprZi9lQ1I5N1U5YllOemt1a29I?=
 =?utf-8?B?eUt3TFp0QVdyV3R3SnBEUXFEbTlicXF2YVJISCsyVmlibmM5dkNOemJNcE1h?=
 =?utf-8?B?NXU0aWpRbXFXbytoRnNsaENEbm8wVVFtYmFPdDY0WFVZUW5GSm5KQk5YYWdz?=
 =?utf-8?B?ZEE1aG1ZWTdjYm85eFY4MDRhTnkvVGlBcnpCdTZCOWtqanN1WVo5dnBQQkxm?=
 =?utf-8?B?TDhrVmkydFg0YVM0VW1sdHp4bVRPZ21XNFd4T3daU1FsZFA5SzFWenova1Zq?=
 =?utf-8?B?VWp6TzdZZGlJczRGM2duemFSWjZ4V1lSUy9WR212WFdjbFJoOW55Q3BqaGt3?=
 =?utf-8?B?UEhDUi9STFE2eHkwOG1XWjVlS3hJZlRVSjMzVnorbU1zY3VTYmJGTDg2RkV5?=
 =?utf-8?B?c2t6dVg2bDFLR29sT3BiWFZjMGY4eko1cEVPMForK3IwRFRIMzJXSm9nUnBC?=
 =?utf-8?B?bGc0MEpkZUlkdjBBZ3RWcDRlcDdBV2NObWQyWVJjZDNwcjhsemlScDVFRkxN?=
 =?utf-8?B?RlpqbE1lc2VxOFVkTENkbENiVzl2WWlpd3llYzVCbU1kVHYrYk9ka3lXZU9E?=
 =?utf-8?B?UmxXRDZzQy8zMjduc0NzK3ljL0x3M0xPRzl4Unl1Q0UreHNpVWxkMDl4amFh?=
 =?utf-8?B?ODRtdGtRbTlLVzNWUU5OMTdZSitxU3NXWWJDWjd4dFA5TjZlMTdRcnkzb3FL?=
 =?utf-8?B?Y29Nd1UzRlB3cjFGSnVtUjVMbFoyQnVRNjY5L3JhRTBzYW5TNFVIWkg2MU4y?=
 =?utf-8?B?TDVXWHNyZWg0R0FIbldqWWFxSHQwM0dYSkJNMVhmQk1HYlFaaEo4OFpPRUp2?=
 =?utf-8?B?dlYyQzJLZ25ZVHBGUEczUDRqeU5FWG1oTGRRcllpK2lLdnJ0ZnEwMnJZN3hB?=
 =?utf-8?B?TllEWXRzTzlNNTRQaStYYno1SDVIbFV4eEFKcms4TWxXL0xRM2gxMGZaanRp?=
 =?utf-8?B?UkpwbGZZSTFBTlErejZFb29LeEs3azlnN3hwcWh5MmgzZTU2ejEzc1NpUGxC?=
 =?utf-8?B?aE1qa1lFeEp4bUdNT1JsZU1TclRSKzAvYU4zL0hOWlUzRlpvaVVBY0J2Q0Vr?=
 =?utf-8?B?THRZZG8xcmVzdHc2VmE3cC9pampmc0ZCeURzQk0yNHBkNUdnbmYxK1NUUFpq?=
 =?utf-8?B?WGc3cVJwSzNyLzlJcVpBcmxjWXI4N3k0YTRmQXkxOHBZWWhUamtNYnU1SXh4?=
 =?utf-8?B?SE5VaW5laEw0eWJOcGhKd1NIa0NqOTJEai90b0tUdDN5RS9XeHAyRCtkSDJY?=
 =?utf-8?B?VnA0SlJXUU5XV0xjenh6SENrdmxSTjd2SnA0cG1sTjlGZENLS0NRR1pNcDVK?=
 =?utf-8?B?aFVlaTdlZ1U0OTI2SkZVZklETnphNCtld3V4QWZCWGIrYVFsWmZnS084a0lw?=
 =?utf-8?B?ZnA5dzhudTdzcmMzQ3hyL1VBMnNxR1ZHbmdjUzgzUUFqeU5BTHdXQnNLT2tI?=
 =?utf-8?B?d1RwY0Nmc1ZEYTJ6SVFESlFGcHdXZThGd1VTUThxenhKbFBuRER6VnA4bHY5?=
 =?utf-8?B?d0IwaUZuZlFBWnNYY3BiU295b3lYNnJ3T01jazZuNE1DOFpyRWZ0NFRjV3k5?=
 =?utf-8?B?eVpUaGE4cms3RjBWaWFLY3RtTmNRdjk5TCtqUlIydHVFRml5cGhsVmg1bmox?=
 =?utf-8?B?S1l3TWpKeEh5L2xDUDRMVTZ6VEVZekR5dm42WUllYW5sMW9WZ2Npbitublhk?=
 =?utf-8?B?MTdPczUzeDh2NnZ0WFR2TCsrd0htOGRJajBqRGJIVmRWM0phL1hsc1ZTWXFn?=
 =?utf-8?B?MWJwMHlMQ3JmRnBuVnZ3TGdFMGFkSjBHT3hyelE5SklTM05KelNQaHZ5ek5z?=
 =?utf-8?Q?G9J/mdAg31Jp1jFq9GZpchvZK7Inxp80?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 10:59:06.5400
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5be214a2-7cb9-4835-38ad-08dcc8e2c4a3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000000A0.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5899

This series improves the time of .set_map() operations by parallelizing
the MKEY creation and deletion for direct MKEYs. Looking at the top
level MKEY creation/deletion functions, the following improvement can be
seen:

|-------------------+-------------|
| operation         | improvement |
|-------------------+-------------|
| create_user_mr()  | 3-5x        |
| destroy_user_mr() | 8x          |
|-------------------+-------------|

The last part of the series introduces lazy MKEY deletion which
postpones the MKEY deletion to a later point in a workqueue.

As this series and the previous ones were targeting live migration,
we can also observe improvements on this front:

|-------------------+------------------+------------------|
| Stage             | Downtime #1 (ms) | Downtime #2 (ms) |
|-------------------+------------------+------------------|
| Baseline          | 3140             | 3630             |
| Parallel MKEY ops | 1200             | 2000             |
| Deferred deletion | 1014             | 1253             |
|-------------------+------------------+------------------|

Test configuration: 256 GB VM, 32 CPUs x 2 threads per core, 4 x mlx5
vDPA devices x 32 VQs (16 VQPs)

This series must be applied on top of the parallel VQ suspend/resume
series [0].

[0] https://lore.kernel.org/all/20240816090159.1967650-1-dtatulea@nvidia.com/

---
v2:
- Swapped flex array usage for plain zero length array in first patch.
- Updated code to use Scope-Based Cleanup Helpers where appropriate
  (only second patch).
- Added macro define for MTT alignment in first patch.
- Improved commit messages/comments based on review comments.
- Removed extra newlines.
---

Dragos Tatulea (7):
  vdpa/mlx5: Create direct MKEYs in parallel
  vdpa/mlx5: Delete direct MKEYs in parallel
  vdpa/mlx5: Rename function
  vdpa/mlx5: Extract mr members in own resource struct
  vdpa/mlx5: Rename mr_mtx -> lock
  vdpa/mlx5: Introduce init/destroy for MR resources
  vdpa/mlx5: Postpone MR deletion

 drivers/vdpa/mlx5/core/mlx5_vdpa.h |  25 ++-
 drivers/vdpa/mlx5/core/mr.c        | 288 +++++++++++++++++++++++++----
 drivers/vdpa/mlx5/core/resources.c |   3 -
 drivers/vdpa/mlx5/net/mlx5_vnet.c  |  53 +++---
 4 files changed, 296 insertions(+), 73 deletions(-)

-- 
2.45.1


