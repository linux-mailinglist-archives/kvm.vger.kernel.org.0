Return-Path: <kvm+bounces-31127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 546459C09E1
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 16:17:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AFD69B24D26
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 15:17:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D175212F0E;
	Thu,  7 Nov 2024 15:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="leFFkb5B"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2050.outbound.protection.outlook.com [40.107.236.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA677DA9C;
	Thu,  7 Nov 2024 15:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730992652; cv=fail; b=IbSfEfq2ePPsGCzp8wWM64izKPwFNhsjbakMLTSdgelxdGV51I+yXC5Mw2lmA1eHxNAz8/UpNiwT9BaTqWRHIOt/3kj+Au62PJTCqa7Z0d/gvcBL0uqx+6w5m6dgkbb6bF5YtUppE07kafAmH3inNYf1ui2CF+CMG5V/jcm39TA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730992652; c=relaxed/simple;
	bh=MM8cVFU2EqXLPXWY8HotRO+3m2j8QJWlNZWGUZc1uLU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Hi9DxT8xNkWd4kOCnxUoWrlyZV7ytjYyNtDj7oI2stwfUNrZhuS7nWgdk/VK0R0xXLfP5qgz7ia9DlQl/UKzBd6TFFOmrblogYw5uAp0AyrpijKKSYyDQF+m4mD2r5yUtBTowNVHcuYfo/z5vypsG4KObPp4R8WFYCqC6dLRBYg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=leFFkb5B; arc=fail smtp.client-ip=40.107.236.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yzQG7GuhrbTguKrc+c+zZWHU4dWBUHH6/xdBFCwmyk9rgr7SUWHkR9DIa0ApqLS9VW+4eA2f3E3L2yVqpLzJBz/5o/jumjUjkuSQDM5KLp5ImeDOcNT9l7BbHNnS7tevfPAKeFWvYusJDm1b3j75Q2cdIz6TqP5pPHmEdP5t+I5i8yaYT7ZwnakIanmBPkxZ2ZhYLKZm18kdiELroWAzczU+pGYoruRFzDmcvmszE7R62Cwv8/AwlHCQpwIUXr+u90AxpGhCTyhH+Plec4Rq3JXOeLEr1ByR4iT3XaS/oPlkXZZxBdkXf7PEWHUp44GmEIOgEJMFiX30yGGMsFpsmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0IhWdHmKZZLlhmEt6tpEZkcL9qZ2evldY3i/eGi/GGI=;
 b=bHW1k5feLBgpjkh+LO+hLZMATvB1dIXkmBumJMcrA9rWiGZEwEkm+fOykd6nyYGgoaVKT3zp3ydAPS3B+crVa4TqfyIh7vo7BXVkGZzr8MF9Z1RLaMrG4PYwvYrIGT9bW5Ot3p2m6KoSBJ/fBbRKNtFAPYEiyGNk7l5c3U6xKqphz2szTYvNXI4WNCzDmYOkAL1bUkG4246SP+308+Wct6L6u+J+OS9sBqv8uV4VZ+xXPvvrfn9dzm0d7YN8opIPBsZhMKvT6JZpRZAEXUl7xd3uawAzvs9UeHEXmyeOmFwe+QjrhLVoh9oD04jFrA2IbZeE+ZnGuX1Vaa5zeSuUxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0IhWdHmKZZLlhmEt6tpEZkcL9qZ2evldY3i/eGi/GGI=;
 b=leFFkb5BsaVn6Y1EI89Y7uGCWJvyVEXHSPAjXK6+KThWsZ54WLy1ktXwObOrUqtTG7w9FeWkIjC3VpX/7FC5MrsHEF6mhPXFIwpceayidv2n0roSsu9GSU1LoASIDsUQgGRkwcp4k5tCkq4iwIR+yTbRwCGV/ADlqD7Ib/2uiG0xlwoW2AKcagrT4Tn0yhhZsnX4MLN/DKAP1zC53l4dZNWU1NRd1LOKijJcRSV9sGl7k2CNnSMSM6ZIZlgDigQBFdHAzcMVVK2jeGb1stz38ebeGZA7sCrJo5k52yGyaid90Xn/LCqkLCfnMGzdKY6tSUp1pF/tFGI4Rfx0jl6xcg==
Received: from DM6PR02CA0115.namprd02.prod.outlook.com (2603:10b6:5:1b4::17)
 by DM4PR12MB6038.namprd12.prod.outlook.com (2603:10b6:8:ab::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Thu, 7 Nov
 2024 15:17:24 +0000
Received: from DS1PEPF00017090.namprd03.prod.outlook.com
 (2603:10b6:5:1b4:cafe::bb) by DM6PR02CA0115.outlook.office365.com
 (2603:10b6:5:1b4::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19 via Frontend
 Transport; Thu, 7 Nov 2024 15:17:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF00017090.mail.protection.outlook.com (10.167.17.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Thu, 7 Nov 2024 15:17:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 7 Nov 2024
 07:17:11 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 7 Nov 2024
 07:17:11 -0800
Received: from rsws30.mtr.labs.mlnx (10.127.8.12) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Thu, 7 Nov 2024 07:17:08 -0800
From: Israel Rukshin <israelr@nvidia.com>
To: Max Gurtovoy <mgurtovoy@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Parav Pandit <parav@nvidia.com>, <stefanha@redhat.com>,
	<virtualization@lists.linux.dev>, <mst@redhat.com>, Linux-block
	<linux-block@vger.kernel.org>
CC: Nitzan Carmi <nitzanc@nvidia.com>, <kvm@vger.kernel.org>, Israel Rukshin
	<israelr@nvidia.com>
Subject: [PATCH 0/2] Add Error Recovery support for Virtio PCI devices
Date: Thu, 7 Nov 2024 17:16:58 +0200
Message-ID: <1730992620-201192-1-git-send-email-israelr@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017090:EE_|DM4PR12MB6038:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f2372d5-e695-4de2-6e42-08dcff3f4886
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Z0IvmLO/0Fym11v40JVvTfwjXg22Ti7Cao3i329MvjmW1OLjdsTe+ORqxe25?=
 =?us-ascii?Q?rRSBDTDKoBUa8qXPc8lw7jDytt+nEwy7qccDl3ZTxC5HCkjf7H5BRgxoG1HR?=
 =?us-ascii?Q?H6JeCynS3DeZwxqA6NQoTceBqj3wnrw2j7OVj67UepXY7Lr5R4zOf9pVpEB9?=
 =?us-ascii?Q?skGfr5cvmoqSmS76JkOv/F0ySSFbyYJTGu+N8NWQNgWnKbdrHQkmulVQNuwF?=
 =?us-ascii?Q?u8lFt5OCnKhuask3HwjNKioCoti1zQGZG9PkC4IEDGvsClq/TAz8tEOkci6L?=
 =?us-ascii?Q?Ie4bfkBkcjEdip6pjJgYZsQGptvJMx8TwlQK5gtmElvLURzoqeDVTNqDYzeT?=
 =?us-ascii?Q?abQxAouLPWvfLDzNOL3h52rT6D7PhUfWkaXKewVIVgOAKAbSpxqGsHIxhnaL?=
 =?us-ascii?Q?Yg4L4u80KKWgOt0+xwz4iOVmQVfujR/lCEmNePMtoGjEqZaOQMjzoONKwdCq?=
 =?us-ascii?Q?u6mnRTelUeYjppdgSvh/Vmu0++N5UMHU7GK3///H+9Zjj1GYh7uvqrEJ+Vwn?=
 =?us-ascii?Q?jUlFgQesX2ZsGo8TS+JNzRLVr1svQxYOnEV/xEM2afVVvumUlTq5Nmxcodov?=
 =?us-ascii?Q?l0FPx/Fi9KNv1qCYVSITkbJCCbh6G2ODpGDPssWWMcMplxLTmAmfZfX1Ww3Z?=
 =?us-ascii?Q?Nfp49K3j35bcko5+5pSESWZGisDYRLMaGFJUV8lI/s1wNIqpXc9il+cFne4m?=
 =?us-ascii?Q?9V2mtd2rKFVY5CHprEGaUtEsAfwtCs/OeuCe1R3J5zbueCYh1drs5mhthpAI?=
 =?us-ascii?Q?vQDxx1wi1boGFUNO/vGw0DrN/cmZ82xsXxnC7KMAGhVRQNUanVkNYsggW0H+?=
 =?us-ascii?Q?HmyDq7C/Kfqwi+vpXdvTUe4O/FIFXe/N3kDdifTqQ6HNwHXYgKMXA9WB2FCp?=
 =?us-ascii?Q?SWbtQsheoa5bw4Oq585AH8/mG9aLdcuNiWT8ShSxezV398TJiCI9sp2CtaJ6?=
 =?us-ascii?Q?92My4Ov5HTslozzuBg6gubOUJlgR+j8wOD2kR4Y+mwgOOzrNeoyeevxeI6Ao?=
 =?us-ascii?Q?cqazyXGz28tY8nrNJk7qCS6Z4mSLQVsNVleSc8O9IWpykHQPgCNO0GN2YI39?=
 =?us-ascii?Q?NMoIQao8FfG4FLeLgdueLfpvsXBJbZxWH4eGkqO+i6le2jd9mSB8IATWSdUf?=
 =?us-ascii?Q?Ml6Ko33RqvkyDzIKxv1q2vQbq36w2Tk3ZimfJkhu0iKnAkhu6RBQsPkY4fuK?=
 =?us-ascii?Q?O9alacZ3NJ6EYBv44zCU8AWJZPiGOBfCo2J9dSq3ZscDKHTbvk8jITUHUZLg?=
 =?us-ascii?Q?cmmIXMbVq17MqG2Jh8ftG/aSri+4XrqPR0hFoeDnmIvfiRR6G8OZs1Iz4Mjk?=
 =?us-ascii?Q?QRT3ctEjYludUdP3nNtG3SHD6tAIc+FmTE94WZtsN/ETwBg8dhF/8Jlpv4eV?=
 =?us-ascii?Q?acuocrhwwpIK33+aBCp78p99kC85hd2/PtMruyWMlKMAMTIIoA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 15:17:24.3153
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f2372d5-e695-4de2-6e42-08dcff3f4886
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017090.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6038

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

Israel Rukshin (2):
  virtio_pci: Add support for PCIe Function Level Reset
  virtio_blk: Add support for transport error recovery

 drivers/block/virtio_blk.c         | 28 ++++++++-
 drivers/virtio/virtio.c            | 94 ++++++++++++++++++++++--------
 drivers/virtio/virtio_pci_common.c | 39 +++++++++++++
 include/linux/virtio.h             |  8 +++
 4 files changed, 141 insertions(+), 28 deletions(-)

-- 
2.34.1


