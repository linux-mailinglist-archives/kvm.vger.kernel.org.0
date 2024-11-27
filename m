Return-Path: <kvm+bounces-32554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BED39DA289
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 07:58:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B551166C18
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 06:58:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64715149E0E;
	Wed, 27 Nov 2024 06:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KrGwgalo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2050.outbound.protection.outlook.com [40.107.96.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE92513BAE4;
	Wed, 27 Nov 2024 06:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732690682; cv=fail; b=J9w+90l3uHVua6ljN4KJPRIgQlfiT8szcqUmHAcxYnTXRwnAYc2eF0QXzpFJMQusKLGUJVSNh20vjxt10Cxial6Hv4nfC8F5gxG7cvZMAZeBjhViHP7gB4/E4N+tZZ0K//YGp3OOKwo1uBAz08LF3SX331lbhi5zJ9e0tRtpdYE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732690682; c=relaxed/simple;
	bh=h/x0zBH3knirxknkmi4iQqxmZlYM9Ib7JBNedART4rc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hqtrkUwGzcSHC/e3LyL9T5pfz67nJ7HZoaeRITEcIbGYoW0JmnpG6g+HEAKEUamJubS1tHrIvfwljzhirT91NlZKoNEBddCuW8YiklJJ5nDkv9E0Y16znO/XT6v9hQI+cKsxhzpP8VhCXlFUnUjvRL29Ap/cQ957EQJN291gMrs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KrGwgalo; arc=fail smtp.client-ip=40.107.96.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nV9gno8zWQ67OyMjB0ksBunORG4mM81SKh2rZPcklwa0unItz9ywFQdh1Iv/pTE6RjB393WSiHmnmh8wM6WlDMzWm6obAQR47KuQ7cWui7Dac0QgV4rf2ak9mgv5qxW5gWSt4syMNM2vb4lWn6jhIHZr/wFMLwPmUa1tXXPN0io2ZIw2NlKhwMlG0gafkRGvNV6j6NDpD1Ej5DQI5gPyjHriMYj6sDklqHhv8syYt9FDFCndRNTgMesPYH5T8S/bee83nUOrsPXTSM+wSqRKFdD0YD9bghyhRc3C34xmnCBl64qJGuIyLCaOGVzVnNrORMaWJNv9U05KLMf7Fsc3Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jl3IONCamXUtS7y2nZsgMI0OKErmM6CveO+VJa96eLg=;
 b=RWoE5mjXEGIMLaUWijfOZo32wNQF5ziVr7kE2/MAkTGG1CXzZBEzpXGs0u6R8dhGU4SybjQg9DhNdr6L2njxB0/txqdmA2DdB+0HeK41JrDsI+Y3pyKOntH/VVDWfGmJDhXn4EmPoK1v25TF3bZ7x5UCx319dZXIC228E483tq/SU0mTdItJG7x8p66kuupxk1qow8FSLXN6ezjz27tEr4W3I/rndo4SX8dgGte9OJbf/47PTFNbkhyvNv4uRzdZF/7vubGG6vwIuNiYv0WFdAxz5eQJFlPOg2M6hbm6mNvPulQEmw7k37swlnpEzXk9pQjozKm7yuwycGrAQqezNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jl3IONCamXUtS7y2nZsgMI0OKErmM6CveO+VJa96eLg=;
 b=KrGwgalovUT3Ba7v6wX/gnYl5t7Oe5tsup5kG5dtb9ttLFwdn+YIziydofqxkXAGiwWhAg6pchU/iPR1vZkCG0cRFVhGugsazhkm5ttX+wxZ6uTNEF4gUd2d73nrEhQKmaQuZKL5Fx0LH74i9774quPd/MX6SHepPeyoIHQj4SoVj+HIA0Bs2AnIv2/gczrBF/o5bLA+YXy1KuYuuJ9V0YnwiY/1PQQSIoIXbq7JwHwJzrB+FxoZr6Utvfa+oIbziUZJgPu5k5L/os5rULvr4YrRf8q5/yFP8IOv7YkfTJiGu+/qVy099UBjsvI5EGHtFHHGgKh3iyusbf0jJ3DOCA==
Received: from CH2PR19CA0024.namprd19.prod.outlook.com (2603:10b6:610:4d::34)
 by SA3PR12MB7784.namprd12.prod.outlook.com (2603:10b6:806:317::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.27; Wed, 27 Nov
 2024 06:57:56 +0000
Received: from CH2PEPF0000014A.namprd02.prod.outlook.com
 (2603:10b6:610:4d:cafe::8f) by CH2PR19CA0024.outlook.office365.com
 (2603:10b6:610:4d::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8182.20 via Frontend Transport; Wed,
 27 Nov 2024 06:57:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF0000014A.mail.protection.outlook.com (10.167.244.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8207.12 via Frontend Transport; Wed, 27 Nov 2024 06:57:56 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 26 Nov
 2024 22:57:38 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 26 Nov
 2024 22:57:38 -0800
Received: from rsws30.mtr.labs.mlnx (10.127.8.12) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Tue, 26 Nov 2024 22:57:35 -0800
From: Israel Rukshin <israelr@nvidia.com>
To: Max Gurtovoy <mgurtovoy@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Parav Pandit <parav@nvidia.com>, <stefanha@redhat.com>,
	<virtualization@lists.linux.dev>, <mst@redhat.com>, Linux-block
	<linux-block@vger.kernel.org>
CC: Nitzan Carmi <nitzanc@nvidia.com>, <kvm@vger.kernel.org>, Israel Rukshin
	<israelr@nvidia.com>
Subject: [PATCH v2 0/2] Add Error Recovery support for Virtio PCI devices
Date: Wed, 27 Nov 2024 08:57:30 +0200
Message-ID: <1732690652-3065-1-git-send-email-israelr@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000014A:EE_|SA3PR12MB7784:EE_
X-MS-Office365-Filtering-Correlation-Id: 01f8a800-edb8-4395-81d7-08dd0eb0d25d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?apnjGK4m9cfEHKKq0A2QWWRTn5mWLi5tKrHYWdRcvdNnSpcR7B0eb0H14nm4?=
 =?us-ascii?Q?1QkoxkG1Q6gLkoCCaTcvYgfnWi74ED9I1WEhQjYKnEGW7YCJfAoHJ4oSbfFW?=
 =?us-ascii?Q?RBruWemEtSVlqqwFb8b1YLR4C6eRDgkyEejSN7m3Js9zMLzxRS9aauHVur2B?=
 =?us-ascii?Q?pb+lDs+nUFE1RCJdb7NkYU0Ci4rzkm+LIglkmKFN9L1jh4EvHbKNeO3GMJQi?=
 =?us-ascii?Q?1k0brLVdFFifKQcJF2BveQV+niN9S/yuhtuSU6wZXg/GSJxHO/yNQEnqjO8H?=
 =?us-ascii?Q?KkWhUz4Bb7/v5eIFD7o8KaFv40LuIDXy4eXHBL2Uy+A0dYwC+FbEngdj/y7h?=
 =?us-ascii?Q?R3Elo6W8OH2Vj80rMw840jE9LzRuG5WcGe1I163XP955JMYBOi6h5Rdu7BpD?=
 =?us-ascii?Q?L0AqNxeuoaExMBNq2HGnfyHznvN/ngwKY3bkiUUvm6XjUPXxZUuaqDcJunRv?=
 =?us-ascii?Q?Qbf8UbnAT4mlsx0XoHL8w9zdC5txedFl66EPDorkRJZF5zrsVqguCOTXVdfR?=
 =?us-ascii?Q?F5T9kGsEWdHQs2HV6oZZkgtCfmwZvmyEGrBg8divkTKwOFOSBI3W4K/5bp1F?=
 =?us-ascii?Q?Pma39728rBNjZ/foAZYyiHs224TaF4Erj1/WQcxLdU9PL81rr9THYWMsnMRv?=
 =?us-ascii?Q?G7+mWpZi3K+VM7JzlKc0HokSzeTB7S3dISrPQpkmT0S2QybW1xHfFpLsld/7?=
 =?us-ascii?Q?gZSusNRWyacynV7o5r9CZpMO2MdlSfS6jpZ3axtaRM1jvGru6baCQUINPHjb?=
 =?us-ascii?Q?hJ1tKU7u56EwEh6aeG/J+lU8bv7nXF4ujkd5uegvBcwQTEA3bPEBXG6Bq+aY?=
 =?us-ascii?Q?/nILuARxn1ycQnQuHa7lmeRTsfW7N+AQ5dkLgmqFmkW8XpdHgWF2td6CV3vM?=
 =?us-ascii?Q?Ql9XbCZktqiKm1sPZ01mDPL7AJ53RgifMhCp/rzi632ESETKi1iTBNxIONZ8?=
 =?us-ascii?Q?lOXEPmkmVf2AxgdsPG8S6t3EdV3hprjUor4pSCCx7ZB6cl6ZX6nreOkLue6k?=
 =?us-ascii?Q?RvFWcfB67C/5NEwZoIOat1Vf6ob5m+VnyQW2r3rcF0ViN/2CPPi2w0OWbYNX?=
 =?us-ascii?Q?jvWMtxReNe5fGN2O64HE4eWaI8hdEKMv53jn6wxwiY4n3h1sOq82gXudZEP7?=
 =?us-ascii?Q?CLRGu/Na3C6Jq93TYkLvzZWNNinLDtJSSjXDGxUioCNsDjZjmGa6fQsP/Ij+?=
 =?us-ascii?Q?EbnsZ8O8D3miGfmolddCA4UiEbCqOIySYUptjakqjW6RSzYcL/6xQFVkzmNO?=
 =?us-ascii?Q?J5CBrqF8tfVfrq3kOpcxzKLHiZ0FQosjVGP1/uOLQUQmuMIAzG45KULo2STA?=
 =?us-ascii?Q?Oa9up5xYJSjGjYMQ5APnMWAXBfVQP8X9VlNULpKUl1fleqskEuc0d5Vp0PUu?=
 =?us-ascii?Q?MDJitu6VEownzPDN8sa8+CNRgNuF2GxfddJS3HrJgK0RtomTfcxxFBLCZ7Uz?=
 =?us-ascii?Q?HlALgxS56Wrm7iy7NgHLJh/GOgm/rmCz?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2024 06:57:56.1292
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 01f8a800-edb8-4395-81d7-08dd0eb0d25d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000014A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7784

This patch series introduces an initial PCI Error Recovery support for
Virtio PCI devices, focusing on Function Level Reset (FLR) recovery.
The implementation aligns with the existing PCI error recovery
framework,
which provides a mechanism for coordinating between affected device
drivers and PCI controllers during reset and recovery phases.

By integrating Virtio PCI devices into this framework, we enhance the
system's ability to handle and recover from PCI errors, particularly
those requiring FLR (this patch set). This capability was previously
unavailable for Virtio PCI devices post-probe, and its addition
significantly improves system reliability and resiliency.

The series consists of two main patches:

1. Virtio PCI: implement the necessary infrastructure and callbacks
   in the virtio_pci driver to handle FLR events properly.

2. Virtio Block: Implement proper cleanup and recovery procedures upon
   FLR events.

Changes from v1 to v2:
 - Don't print warning with -EOPNOTSUPP error.

Israel Rukshin (2):
  virtio_pci: Add support for PCIe Function Level Reset
  virtio_blk: Add support for transport error recovery

 drivers/block/virtio_blk.c         | 28 ++++++++-
 drivers/virtio/virtio.c            | 94 ++++++++++++++++++++++--------
 drivers/virtio/virtio_pci_common.c | 41 +++++++++++++
 include/linux/virtio.h             |  8 +++
 4 files changed, 143 insertions(+), 28 deletions(-)

-- 
2.34.1


