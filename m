Return-Path: <kvm+bounces-24361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D01EC9544FE
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 11:02:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7B3F81F241E5
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 09:02:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99CEA13AA41;
	Fri, 16 Aug 2024 09:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tQrktY0l"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2077.outbound.protection.outlook.com [40.107.223.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA9313AD3F;
	Fri, 16 Aug 2024 09:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723798949; cv=fail; b=LcfESdFkgFmAXSto30NXXvJ03cEPD+04ILeRZl5lAp3wD9lkC24bDy4W6pjzHndQ686TBDYSBOx4AOIHpROtGDUHUyI6HLSFcJI6SnJDVy14qMZ1mDIevgTuwXHNQyVGElDJvw6KUtr6BK1bLnIjdk8DyaYpAcksJ/0recZpI1Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723798949; c=relaxed/simple;
	bh=O3hrw2uqZVO+Ng3Wmb3L1/ANuso2egFzTs5hCPezlKI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oAA9APDQob7gKOuGexh+4E7BObFm3gOfIj/beweeMa7Zt0e6D9OTNJWtCtqLEmO6TZs+wmTz6Wa/ZzFjzhKYzgnMa4be0zzeZg/dqOzIRPKOCj2Nd9i0+ZsYWgEklxX+BP6MCHrAGu0AyDiQMMB1Fht4PCI+TESQ+ZRkDJ7Aqm0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tQrktY0l; arc=fail smtp.client-ip=40.107.223.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AhmUrYsXOKwrRujKjPFvMmIqtQ5YS7Q5gskAsdJvPsPE1iy7Mep0ekqYEUWBDD9ADd9arV8tNExs9I9bfW/3BfbjkVEYRX0FHD8s5Dq/OfhVjgI6IzxeamaLGh3tAJ7Hnz/OqytCDPfJuRU9ElaR263vhMJ0MQDx3c0bdYlR0U1Rv2TAXqisEAgyxcBunhDa3TiARll8KpuHupertDq9THHWXFwh0vdOh+RK5WVCEPN/NWyDGu/hdUI5353WnNmOwrzgZKy0XkgyYtsC/nRJoINj94HIiZ4TqI0nRi328XOa7MOqRf0wQiyWctmJ6ql7mMoklu4sgvQbA/s5zKd6mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fGU4NNPPZIHw3djCcMjA06hE2NvtAYJGu9zwZShkqUw=;
 b=wOPbbqU+VM1p8IBXOEsYpJ8jYOgM6mU/ptW2xvvh44fc4kTF8P+NfgmzNMdWjD9kl/+4nZGjSX+F2xXNcZM1mE6KyX1sFB6ShuPX+E3RlAFC0HdTr7Um6KGhjSzHnMx/1kROowJAjME5knhp2cM5h1eJf7LuEApKofNnCchFYUdd1CF2Mk8c+1Z0TLlkL5JcTasqewd5KaUKx9H6tPa2nH9WLm4swPnNrbhkd4CU5+ebwQ55uAxu3kqpXIOiMpI5PLkKNkdTskkLY6D43207Fdi+uGFfyVsssPkoIVUmczMWkEZAdAML+osX7s7JTQ+gAHF1k4GccWGQ2W9IbYI3Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fGU4NNPPZIHw3djCcMjA06hE2NvtAYJGu9zwZShkqUw=;
 b=tQrktY0l+kGOvQI/xx+rmQEcXeQMWcMa0OjDCJoRUl+N6CD3cBlDvUmiX6EHDXHIND161J7cbTtfjpwgFKq7pqrappWhazesOJ15rWuEPYNKFzL60tz1ljGu+j33b9QPEPgVt8RE7xSo60B+qxOY6zzRyx7zBwiAX/wUzoce1achH42Io208wCrwfeYTM1izsdFNHz9UHSrVt0tSuqPN1R24n8Cose9UylRzxj6hPL7ZWzHWE77XTM8FwtA/eLwtD7TDtR8XQotgtlJ1V51Cwzvohfca8rB9zotPQ1oEDmfueRLIqOBOOYSYuu21S7IPdELpnvCEA99zcwv7p+xqcA==
Received: from BN0PR07CA0026.namprd07.prod.outlook.com (2603:10b6:408:141::26)
 by SA1PR12MB6946.namprd12.prod.outlook.com (2603:10b6:806:24d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.19; Fri, 16 Aug
 2024 09:02:23 +0000
Received: from BN1PEPF0000468B.namprd05.prod.outlook.com
 (2603:10b6:408:141:cafe::96) by BN0PR07CA0026.outlook.office365.com
 (2603:10b6:408:141::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.22 via Frontend
 Transport; Fri, 16 Aug 2024 09:02:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN1PEPF0000468B.mail.protection.outlook.com (10.167.243.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7849.8 via Frontend Transport; Fri, 16 Aug 2024 09:02:22 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 16 Aug
 2024 02:02:10 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 16 Aug
 2024 02:02:09 -0700
Received: from c-237-113-220-225.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.4 via
 Frontend Transport; Fri, 16 Aug 2024 02:02:06 -0700
From: Dragos Tatulea <dtatulea@nvidia.com>
To: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio Perez Martin <eperezma@redhat.com>,
	<virtualization@lists.linux-foundation.org>
CC: Dragos Tatulea <dtatulea@nvidia.com>, Si-Wei Liu <si-wei.liu@oracle.com>,
	Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Gal Pressman
	<gal@nvidia.com>, Parav Pandit <parav@nvidia.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>
Subject: [PATCH vhost v2 00/10] vdpa/mlx5: Parallelize device suspend/resume
Date: Fri, 16 Aug 2024 12:01:49 +0300
Message-ID: <20240816090159.1967650-1-dtatulea@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468B:EE_|SA1PR12MB6946:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e0f819e-9ae4-4861-950a-08dcbdd2242b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OUZrbFZqUGlML1IwaGZpWEdLNksyd243N1Q0TmZ0NUM3UUdEUjNjU1p4ajVr?=
 =?utf-8?B?L1BZemZEVVVLamg4cGFqSXdodFk0TTc3VU9TalFKYWlwY24ya0hLRk5TS3VO?=
 =?utf-8?B?Z29FckRmczVpdTg0a0hRdHhhbFdobWFjTFRISFFzdEt3YlFhdWhsVSs4bmlG?=
 =?utf-8?B?Vk1IQTZzTitzTmhsWGt3QXVmOUpjSlN5TmFoYjRQYnl5aFVjVEdzVDNiZllN?=
 =?utf-8?B?Z0wyK0xlQWV2MTdaeVRLVjRMdGtrc0YrYzFMdGxVL3VWM3lIZlJuZnJJZE5C?=
 =?utf-8?B?YU5TNm9POTA5ZEtLNENLcXVLdmRzUWJBNU8yQ1loMm5XOTBYN3RMWHFETElU?=
 =?utf-8?B?OG5sb3lubm94TWxvR3NreC9HZC9oNTdpUTQvRkh1QUlMbHM5ZWhicWFwT0Jz?=
 =?utf-8?B?bE9QMSs3MDloTmtIbkpNNTZkZmw2N0hmL1pvWVJTaEY5VmVqL2ZORjFtQ09o?=
 =?utf-8?B?eENudTh6ZlpJY1kwcVdYZnNlSHJ6eWNPMjhteUtJcm1PQ2dvYlN4TVh5L3dK?=
 =?utf-8?B?NUpveFpwQWcwdjRwSXBKNHMxUXJPNHRlbHZhRURiY0RKMlZYWkpKdllPNnpS?=
 =?utf-8?B?amFkTk5PcW5UUTJsQm41MzlaMENza1c2NHdORHpRU3JjNFUwQjdxU3FLOFRq?=
 =?utf-8?B?dGxtVktmczRwandraHlRa09EQkVWVnRPNzIwN01JVW83TGNSTGJ3c1NHaTJl?=
 =?utf-8?B?Z2xYWmVzdTVXVDRZb1JodHNoaUNTODVDUzVrVFoxVGlpejhhTHNxOU9xeEh4?=
 =?utf-8?B?VzNPeFRDQ2lWVTZMU1dyQW9CT2FQbmxjL1RzZVAvSFJTVUVmUTErME52RE1D?=
 =?utf-8?B?NUpNNnZodkovWTllRjRNUDZRblVtT1dTSm1NdDB4V3hmVXlTTm56aHVCWjcy?=
 =?utf-8?B?ZzM4cjZTSnQwbDB3ZVNqd2huZXQ4OEF6OGxyTnFoZmQ0Vm9ReDBZTDhaVVRE?=
 =?utf-8?B?NnZ0aG5qd1Y5YzdXVFV6NGRsbW9xNXIvUHJEWkkvUnc0KzV3eEhmUXBDVXUr?=
 =?utf-8?B?U2E0dC9rbzBxNmcrSjNiSmpHbjM3VVlWVElUMWVBcDRhTTJTdGNMQzNGUGNS?=
 =?utf-8?B?V1dLeGtzbEFzRmtQWTNLZ1hBVVAvakVqaXpLcjB2cDdoTmMzcmRnZnFZMHRU?=
 =?utf-8?B?enlEUlhWUnZ4NU93K2E1cFZVbEF1Y0dnQUl3L0NMbTJFN2ZpajZUZmZHYkVB?=
 =?utf-8?B?dVdiLy83ak05RXk1ZGgzNzgySFQ3MmhPQTUyY0RGZjlhY3pQcjhKTXdiV09X?=
 =?utf-8?B?T045VVVrRmtMSDNzZFRTRmlCQk9WbDZrb2tGenNhTkw4UjJ2dmNHNDhpMHJB?=
 =?utf-8?B?U3NHak52cHJQak1tR1l1K0U2ZlBDL2tESE1VT2d6Vmw5bmdCTTE5a3hJZjdr?=
 =?utf-8?B?UmtIcU1abWw2K1dBOXVWWVVCQXBMV1o4ZlkxMGhIbko2Ylcya1dJbmNWODNj?=
 =?utf-8?B?MDNTZEVzNDQ0NERNdU9wbDBSMkFRcFRtTCtSWHozUVZnNHpQWlNnMFEyUUdp?=
 =?utf-8?B?WHJYOEJtZXZYeVFsb0dicEF5MFZGRk1LZ3V1VEtIMTVURzZzSUIwdWlQRmtv?=
 =?utf-8?B?Wk5TWEtOVUZlMTBEODRrblQrUnBSRzhtVzBzYTkxdFZCL1prR2Fvbjk5YzZa?=
 =?utf-8?B?R2pISjZXb0FCa0dqNmRMd1cwUm0rMzAyWUp6SVhiY0xuODJ2dCtBMG5VeFpH?=
 =?utf-8?B?MTg0RHd1NG94RlV3RkNnQTV1amVVeHEyWWFHMldPQlVBb1FHS21DMUV4Mldx?=
 =?utf-8?B?TXBUaVlUeU1BR2QrdEIzNUs4VzExbHZ0cDArcnhqemJpOGhwa2dCbGxmOTZt?=
 =?utf-8?B?aEdWYmpXMnNFRUcvMlpMdGFNS3ZsYmx6M3hrYlVtOEk1dmhPMXo1UEVDSlBI?=
 =?utf-8?B?RDQ3WTcva2F1ckQ0dm1ZbWtxejd4RmtNUEJiZzJTTzZ3NHBNakt1K0dmeHZt?=
 =?utf-8?Q?/ktaP6514bTl+HSGrztxVIcUP6HRE7n3?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2024 09:02:22.5041
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e0f819e-9ae4-4861-950a-08dcbdd2242b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468B.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6946

This series parallelizes the mlx5_vdpa device suspend and resume
operations through the firmware async API. The purpose is to reduce live
migration downtime.

The series starts with changing the VQ suspend and resume commands
to the async API. After that, the switch is made to issue multiple
commands of the same type in parallel.

Then, the an additional improvement is added: keep the notifiers enabled
during suspend but make it a NOP. Upon resume make sure that the link
state is forwarded. This shaves around 30ms per device constant time.

Finally, use parallel VQ suspend and resume during the CVQ MQ command.

For 1 vDPA device x 32 VQs (16 VQPs), on a large VM (256 GB RAM, 32 CPUs
x 2 threads per core), the improvements are:

+-------------------+--------+--------+-----------+
| operation         | Before | After  | Reduction |
|-------------------+--------+--------+-----------|
| mlx5_vdpa_suspend | 37 ms  | 2.5 ms |     14x   |
| mlx5_vdpa_resume  | 16 ms  | 5 ms   |      3x   |
+-------------------+--------+--------+-----------+

---
v2:
- Changed to parallel VQ suspend/resume during CVQ MQ command.
  Support added in the last 2 patches.
- Made the fw async command more generic and moved it to resources.c.
  Did that because the following series (parallel mkey ops) needs this
  code as well.
  Dropped Acked-by from Eugenio on modified patches.
- Fixed kfree -> kvfree.
- Removed extra newline caught during review.
- As discussed in the v1, the series can be pulled in completely in
  the vhost tree [0]. The mlx5_core patch was reviewed by Tariq who is
  also a maintainer for mlx5_core.

[0] - https://lore.kernel.org/virtualization/6582792d-8db2-4bc0-bf3a-248fe5c8fc56@nvidia.com/T/#maefabb2fde5adfb322d16ca16ae64d540f75b7d2

Dragos Tatulea (10):
  net/mlx5: Support throttled commands from async API
  vdpa/mlx5: Introduce error logging function
  vdpa/mlx5: Introduce async fw command wrapper
  vdpa/mlx5: Use async API for vq query command
  vdpa/mlx5: Use async API for vq modify commands
  vdpa/mlx5: Parallelize device suspend
  vdpa/mlx5: Parallelize device resume
  vdpa/mlx5: Keep notifiers during suspend but ignore
  vdpa/mlx5: Small improvement for change_num_qps()
  vdpa/mlx5: Parallelize VQ suspend/resume for CVQ MQ command

 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |  21 +-
 drivers/vdpa/mlx5/core/mlx5_vdpa.h            |  22 +
 drivers/vdpa/mlx5/core/resources.c            |  73 ++++
 drivers/vdpa/mlx5/net/mlx5_vnet.c             | 396 +++++++++++-------
 4 files changed, 361 insertions(+), 151 deletions(-)

-- 
2.45.1


