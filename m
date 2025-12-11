Return-Path: <kvm+bounces-65729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FB48CB4F47
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 08:06:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6BE4130146D7
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 07:06:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A38752C2349;
	Thu, 11 Dec 2025 07:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DSBp21Ee"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010045.outbound.protection.outlook.com [40.93.198.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24FA42C0F65;
	Thu, 11 Dec 2025 07:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765436782; cv=fail; b=tW1bOg9o2mFBojOCP9m3mB7TBzqFKKGJtfv2H2BiZ2OK2c0qgy3XXDCJnBO6vdMPlnJYZ7X/Y7rGjXkP8i2l+zE4aIpoe/HAvGcIaxan3i4Ocr9h0BfLAI5YrSAtqIiJM8v6GBhclXrZfpWGSyySnrQOClGW0TCwYvieRQwqMXQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765436782; c=relaxed/simple;
	bh=pYs5A9/O2FGo3QYON8GLOYGtyxWvTQ3wm/hOpEtTB0w=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nwRVP17PkU6a4P2+bIAgnc60XR6V0lFQKyQIux5FjjPQ/jEi7fjlX38l//iM97ZYft7YlXeRWiQZTk1xpEzTi1VPTA/gEbnqFr8SCg8yqPMczOSD2yrmTT7vOBuH8bLMsdnkCLX/o5hPDNd5fmJqHDzUgJusWBF667M/5xDNMHc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DSBp21Ee; arc=fail smtp.client-ip=40.93.198.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GcP20RItxdpU7kQOMmFhFiwILkTVsd3PID3qZ0h5RHKVG/8OIQPeusGIhewx4ApHlH79Z0S9o7RfShYTbiLl/6WrJo5SQp5py6i7VKCwrrQgUIOCGJlPLv5qIJpKPLeKDcZb8nMMwYgoyuyRgweut0YsEOAGuxjbomRgpqCNiRoZ+W0YbvpPSHlgqDwSCty3mDyzndCien8qhO9r5+P8Lnz2nSS3T3MDv5lRhbUr0SmEXET7PtkZTArlsmMrPJUqZCSlnuzHjCF2hAktMS3KeUeONJu2iQFMBtWa8V2qBTuKS3u3MTbYWwc0MXwQi3virpv8V8gUK1X0rSSNKf/qjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VcpIYQljam0KpUK5PJB/DYZ6loIWWWVAOjUa3+ZRMt8=;
 b=LdgVux4457L6MYvQULhPzb/B8bwWOPFM86HgAxZicjosvl7RY+3XFqTrdMiEPIMoPPPsANeVq5EzZusL/UBoPFclLwJHQOPZPi02sbakVY+PoO26c2v4E4i/1aPxIb+cNtKWUFJNCYPgUFaaP/P7LiCSY1reD9jhQ/SW8At8I2DWme0FzhQ/BlzKNN3sHtG+nNSoRbIkpL7YsARqxGp/pHCI7d87VdCqZxrfLcETRHo7g5XU4xwV/KCLk44gqamNgXCB/ukABUYwY53nQs6N5Mg9oGHYxBu5bPkNpJHw3AV5KfdDBTt6j7fssqHUDAhgZA/OVxbuX/zUbwelHnwzzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VcpIYQljam0KpUK5PJB/DYZ6loIWWWVAOjUa3+ZRMt8=;
 b=DSBp21EeTH2bQWAb0KePwdn5T4dnuFfVaYYruR9Y+wh7CTDgJ8HBo8H6JpCRv/S/vq/0G78aM893dcw4+2HcI4Uphnc87Cswmg6gSRIHzMiyqX619hVjCX7jPXE+2dCdjN/yOkzjG+uAAbYmY7m/embawqcC/gLYpDPldmAfpwKUzy4afnpmYL+iDMB8ZNtk5qRVMcLbdLZ57w1yUXIUGVYHAS346qghv9i1fR3PqePfdv2wAruXxc6uAzlfCloOWiE1Ry/KLwIbqyMumrMmdIPGEpyJUGwl8LdYkXTbUGPUK+ofF3mhtAtI92KuKDX2WAFCdEtKjKgehH0IwBC+Hw==
Received: from SJ0PR03CA0199.namprd03.prod.outlook.com (2603:10b6:a03:2ef::24)
 by PH7PR12MB8428.namprd12.prod.outlook.com (2603:10b6:510:243::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Thu, 11 Dec
 2025 07:06:17 +0000
Received: from SJ1PEPF00001CE6.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef:cafe::b0) by SJ0PR03CA0199.outlook.office365.com
 (2603:10b6:a03:2ef::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.15 via Frontend Transport; Thu,
 11 Dec 2025 07:06:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF00001CE6.mail.protection.outlook.com (10.167.242.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Thu, 11 Dec 2025 07:06:17 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 10 Dec
 2025 23:06:05 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 10 Dec
 2025 23:06:04 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 10 Dec 2025 23:06:04 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
	<mochs@nvidia.com>, <jgg@ziepe.ca>, <skolothumtho@nvidia.com>,
	<alex@shazbot.org>, <akpm@linux-foundation.org>, <linmiaohe@huawei.com>,
	<nao.horiguchi@gmail.com>
CC: <cjia@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH v1 0/3] mm: fixup pfnmap memory failure handling
Date: Thu, 11 Dec 2025 07:06:00 +0000
Message-ID: <20251211070603.338701-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE6:EE_|PH7PR12MB8428:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c730aca-f12d-4d94-3242-08de3883c79c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2rBFsXxfJBVFRd4Q3TjWfatMUg5pNxSPArUdDm6SIZipJp06MsRpdC+QwiwF?=
 =?us-ascii?Q?hk7Hm9Jpkvi34Z0xnVtD7HuCNp2wI1DqwtNQCdvf2vmX1QBcWzBjhieblwn9?=
 =?us-ascii?Q?68OZhihfFIoJx9DtyS1KxtOUFMaYhIWiJKVDgp1ZpDfWC3Dk+Cn+K0RfghVz?=
 =?us-ascii?Q?JJrsISDEss9/VFNcfvlbwuJIe8YIK2yNmN3s+0ZZ2kFgyQ1D8QAcrYNUWuOO?=
 =?us-ascii?Q?E7aYT/urT/efhkrQSGvXqrtXJQETOp6sQqDvNLxseINqFAhFxu6C7jvvKr6N?=
 =?us-ascii?Q?XCh1yMmBKKPSBewKnhiioxvKFwxse/AjMImOkmaHQ+UVDEsPaRIER72VsvSt?=
 =?us-ascii?Q?AIJe6jFWQqrGKEIQw86lko86iaMT2uEB5+7E+ACNveOMSRkL72IXC/P8wJTe?=
 =?us-ascii?Q?yl0wQu+DnNgm0r3H7ROMAk9M1afrxreF5lf5DI1d53BkuS9P8YZVVW/308CC?=
 =?us-ascii?Q?/NU6rVPogTT0Dq4Eyk6o/oq0NUuJEIfgDxtN2HiPY3WuuzaWYaKjpg53TMt0?=
 =?us-ascii?Q?jbo5eis/QEJtBSmksSVkd7yWIRs0zjXVml5NoNfy9p7nrvtptr8Bd026mKYB?=
 =?us-ascii?Q?NbQJSPE+baC4YjPf2/F8aXtlDJj/Stp8l1fcdCpzKH0iWwO5vdrts+iutxbI?=
 =?us-ascii?Q?hAIkIFS86ILXIxZeR2FRhzGllT4EHXChM5Ivk3L6nJQpWYLZArPsN5PvACp9?=
 =?us-ascii?Q?AoHK6hSNFWBYYbkQxwdX2F/jwszlqkGPXYkYu39L30iytnah3ily8HJ4wXlV?=
 =?us-ascii?Q?fbk92haROYS7sHjGGExCR+jE5MVc4PNsWqEmjGCP659smjM5/7hRrMD8XDj8?=
 =?us-ascii?Q?DtRI7i6FfL94/IJC3FgzkxvOCTfIbxLrPsxbg9NfcT/jqTHvhX3T48/9CZuy?=
 =?us-ascii?Q?DbIQ9MqALgMqTGtSLKGhKUjzkT2FGFm3j7BiVnUWMA81yr838I9AgN4t2T+u?=
 =?us-ascii?Q?XJvGVGuFRNN0yrT/Jv3KJw9rDBcWwaFelUKlWYppMMkDh5w1Lexi8pMWLUYr?=
 =?us-ascii?Q?WpEc4IPbI1G7U+lmiDFipdKfBlUgc14Lr/mvlZV8kepHqHWhY4aSv3m1blm1?=
 =?us-ascii?Q?EjbSHMJiLn06yjiX+TcosDd/LwkBQwwYis+IFODdMZlz5OEoLrMba6ih2YD3?=
 =?us-ascii?Q?auVD0SxTXGlhfnRIpmQjLmP0c7cAFjvHZ/aXFagjcasHu4bOtswKTwATLIqh?=
 =?us-ascii?Q?8JUqmxMcINrRy6E8+gxNupIJCmzsUX8ap6kvneiZPcrzzo/fwbvbwqViNQb9?=
 =?us-ascii?Q?kMZcNvGZrMzM0c0sWyniqOCOz7D49ercVuIGMy+djtn0xFwDGW65IbLaoyID?=
 =?us-ascii?Q?6staa22i0cT78lDj8Aip0hSd3tzsq1lLa6hRTDVh8qWtofWWSifVF5V5FvyF?=
 =?us-ascii?Q?/H63pZAJBwKFIR18BlBtl0KtW00VuXmcgd4nsO7dAvZ+zkA+pViyRtnYylWf?=
 =?us-ascii?Q?eTMCIVTb0q0/aO4eFhg+KBy0LYMOHF+pkls7TXKy1Cyo6p75vrFx9rIRsITr?=
 =?us-ascii?Q?zqYS/pmWWRqiBIFh8gXTnQB083zN2wmW/pe363gBP/SUEbPuXKZWEhKFZ6Oy?=
 =?us-ascii?Q?W89G965Ac5OPouq29LucP+FSQ4MA8gW3N/mcSSx/?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026)(13003099007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2025 07:06:17.3541
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c730aca-f12d-4d94-3242-08de3883c79c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE6.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8428

From: Ankit Agrawal <ankita@nvidia.com>

It was noticed during 6.19 merge window that the patch series [1] to
introduce memory failure handling for the PFNMAP memory is broken.

The expected behaviour of the series is to allow a driver (such as
nvgrace-gpu) to register its device memory with the mm. The mm would
then handle the poison on that registered memory region.

However, the following issues were identified in the patch series.
1. Faulty use of PFN instead of mapping file page offset to derive
the usermode process VA corresponding to the mapping to PFN.
2. nvgrace-gpu code called the registration at mmap, exposing it
to corruption. This may happen, when multiple mmap were called on the
same BAR. This issue was also noticed by Linus Torvalds who reverted
the patch [2].

This patch series addresses those issues.

Patch 1/3 fixes the first issue by translating PFN to page offset
and using that information to send the SIGBUS to the mapping process.
Patch 2/3 add stubs for CONFIG_MEMORY_FAILURE disabled.
Patch 3/3 is a resend of the reverted change to register the device
memory at the time of open instead of mmap.

Many thanks to Jason Gunthorpe (jgg@nvidia.com) and Alex Williamson
(alex@shazbot.org) for identifying the issue and suggesting the fix.

Link: https://lore.kernel.org/all/20251102184434.2406-1-ankita@nvidia.com/ [1]
Link: https://lore.kernel.org/all/20251102184434.2406-4-ankita@nvidia.com/ [2]

Ankit Agrawal (3):
  mm: fixup pfnmap memory failure handling to use pgoff
  mm: add stubs for PFNMAP memory failure registration functions
  vfio/nvgrace-gpu: register device memory for poison handling

 drivers/vfio/pci/nvgrace-gpu/main.c | 116 +++++++++++++++++++++++++++-
 include/linux/memory-failure.h      |  15 +++-
 mm/memory-failure.c                 |  29 ++++---
 3 files changed, 143 insertions(+), 17 deletions(-)

-- 
2.34.1


