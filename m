Return-Path: <kvm+bounces-61094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id AD0B1C0A9A5
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 15:22:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C83734EB62A
	for <lists+kvm@lfdr.de>; Sun, 26 Oct 2025 14:20:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 627A427BF99;
	Sun, 26 Oct 2025 14:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="aUj+IRv5"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010023.outbound.protection.outlook.com [52.101.46.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB39D23EA9A;
	Sun, 26 Oct 2025 14:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761488378; cv=fail; b=TpnmkKUIu0iVRup6OHPAU4Z90ob7Od+z/iuSlEaM0QmffJCoVfsyFAEhlx2UnzocFiF3rWeurO1D13IkskvJDLwHUG4yW21ockWXfp3yqoBQPf4z6JFFDo3tyaz/uF4NlVmTGOgUNpRpQ/49JQ8BVOsGQgHQJo7Z6ULFtYxSjlo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761488378; c=relaxed/simple;
	bh=10B6nXMx8iXFQDeFFdQ2xfQHzNGPbf6hVEBMmObmzcI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=At2ApokiwVV69eKnPPGbeuNTGoAaYb1AZIdDH3R5lWiwGUlRsayUnVQGZzI/RNaZX1vpOCjYtP06WoZviG+eQ/CI8K4C8Md0bW7xfkq/vRRSc4foJ1EPXVwaXgQel7Cg+RWjcFKG75NaDDHMkSIRCbIX2hyT1QMPgKdK+WzJ/u0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=aUj+IRv5; arc=fail smtp.client-ip=52.101.46.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hyPDnZLE+w2ztO/ND6UcaRYfu5/NpAdjOXcBBWj6ER7DcsUXFukPzTvOdegGBIjdLz5wPqBc7P0Rev3nP/E41bseYAnMQeltd0gZXMSkLNExn54PoyvUMypR6Fj8YP/7gWt9zfwGFEugTc4dujsyRJviLLxWpQJwEx54bNtf1kEFhypM4kqbslyBaDXQDFLxSWk7srwEXdqgWCOUd9PqUxdOHM8sDXUZwLOi4rxESQBwAvwmCLA8uKTCK8yaE5wg5p0MKlQrz2b+SmP2j52MVZEmIS7aBzkF/IvBXxgUebq1lTNFO/0eOZ037NACCgdYEVnmvacJeIhNtT4AMX+TDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vkkse/YCPhiM7IeSw5aVTcy7msUuRv8QaE1VftLvlMU=;
 b=O9ejhQuo4O92dE8JlLCgMWcyyY7UpOXKe7yMd+fxBhKqIUfUh8W0RcI7WElVwxFD0XKqqG6lwvGNIZyUhyWPbJSYm2Y0gAcuDa/3GQ3l8U6tmfLdJ5id1mhn8MKWzHdZeScZRo8by7rrRxJsH7H02+1UZ3xs4jfX8HcjGW56JMpvcD5vzp3aNyum+qJTK24cRMsq8Ek9nXfXOZWAxrjvrQ1PjM6lt93LPsHHB6y7WxkRFXFVW2dUU+VwFfMBOymX4usO8GE303no8W4aRIW5zgACCK6jPQ/F5debpc/vfy0/W3xzuN5AYrrQzV7j3hhl3sxemtteQwZuGqw0MCE9IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vkkse/YCPhiM7IeSw5aVTcy7msUuRv8QaE1VftLvlMU=;
 b=aUj+IRv5JC4VovFuswLLZ1NBRSwtgVxbUPN5VvNj2bil2LP12qzmhoaiwhV8EKQJgOspCqBdpx0b+rp3acTsy/9/DgkefekX8WGm4NjEU7nWlSj8Rk8D3+kh8XLyKwVCKWc31a2O3v/kG0+y+FN9xo8wm7LDGqWC9MbaACM7b3XwzJW7TajTgye7trz3t7dNAQ4lwLWv9tRIDO/B4RKfCwSfCoFaS5/StQCEgNeXjrsZH8UAj1JvZzmr4R85NhdpOS0afLEzMC4XtdaKFPOojYyxH28pdkcnWAbeJ3cCw+iI0j5SrE6zyX+LW/oW9yOfJE9BqycD/BNAjcdS6fx72g==
Received: from DM6PR05CA0057.namprd05.prod.outlook.com (2603:10b6:5:335::26)
 by DS7PR12MB5790.namprd12.prod.outlook.com (2603:10b6:8:75::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.17; Sun, 26 Oct
 2025 14:19:32 +0000
Received: from DS1PEPF00017097.namprd05.prod.outlook.com
 (2603:10b6:5:335:cafe::fe) by DM6PR05CA0057.outlook.office365.com
 (2603:10b6:5:335::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.5 via Frontend Transport; Sun,
 26 Oct 2025 14:19:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF00017097.mail.protection.outlook.com (10.167.18.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.10 via Frontend Transport; Sun, 26 Oct 2025 14:19:31 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.34; Sun, 26 Oct
 2025 07:19:22 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sun, 26 Oct
 2025 07:19:21 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Sun, 26 Oct 2025 07:19:21 -0700
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <aniketa@nvidia.com>, <vsethi@nvidia.com>,
	<jgg@nvidia.com>, <mochs@nvidia.com>, <skolothumtho@nvidia.com>,
	<linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<tony.luck@intel.com>, <bp@alien8.de>, <rafael@kernel.org>,
	<guohanjun@huawei.com>, <mchehab@kernel.org>, <lenb@kernel.org>,
	<kevin.tian@intel.com>, <alex@shazbot.org>
CC: <cjia@nvidia.com>, <kwankhede@nvidia.com>, <targupta@nvidia.com>,
	<zhiw@nvidia.com>, <dnigam@nvidia.com>, <kjaju@nvidia.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-edac@vger.kernel.org>, <Jonathan.Cameron@huawei.com>,
	<ira.weiny@intel.com>, <Smita.KoralahalliChannabasappa@amd.com>,
	<u.kleine-koenig@baylibre.com>, <peterz@infradead.org>,
	<linux-acpi@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH v4 0/3] mm: Implement ECC handling for pfn with no struct page
Date: Sun, 26 Oct 2025 14:19:16 +0000
Message-ID: <20251026141919.2261-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017097:EE_|DS7PR12MB5790:EE_
X-MS-Office365-Filtering-Correlation-Id: 0267edf0-d235-497a-dccd-08de149aae93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|7416014|376014|921020|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?l116OUSf7suddr5jla/zpE/8wHviigDw+yyU1dbuP5+/GxsXEogXRVR4SLoD?=
 =?us-ascii?Q?EoTqa6eL2SI/93KMgIu2J7lno4KHvSwjiSBLwqvhMDc9tQSERhfUSXvDFdwR?=
 =?us-ascii?Q?uw0/Gaxgv6P8l0OZL4kTtWvuC/RSkrHguuwdzAHy+pzjyHvWMLbWQGiGyfEN?=
 =?us-ascii?Q?SMMDRDoNb9ds5nnZm+ft/GwPUGftyFumDtmBOAB5BrbysuHwXGFlUoGfQnJf?=
 =?us-ascii?Q?VN58FLKVDnrD90vWyyIbBgbIJvPxUOLGlKQtsmuk664MgiYR5G8rbSTWAY7O?=
 =?us-ascii?Q?24z0Uf6aDSuCvn8bUzviWczG+5aDcRhDqCI35FNE2r6jurHktFbmLvdzE+gT?=
 =?us-ascii?Q?ju+OqzYqqiYqivBgCdCMDxJF4BR/bW8gvRLMsALRHUw5iru8PUejQWwBKBxX?=
 =?us-ascii?Q?B1FCeC5ddWw9xLZuSTX/sqZ3o7upj/hJGQRs5OeRigwZ0bU2eAdYT3ciJYvD?=
 =?us-ascii?Q?+AUZLosFGCPrCZeA+wsIGHPZ5OPkZPz5lszOpdWzpuTGkiwg4kFA6oKvHhyi?=
 =?us-ascii?Q?H6kYJZK6qzLhtZaacDGom63DhBEngX8OtIWp8XnkrccFtVmY9wOy6VpKo2qY?=
 =?us-ascii?Q?JFzzGBHo2tu+4Gb4zVyPipJAz2kbwJOVmCekYmhM5Sfwi8u1yHdfI6x83/9D?=
 =?us-ascii?Q?BBAskbQdK3I3jyBT8dSmi/knsULQyZOD4kE5VFNax0TNMpqJQRRNiK3YQ8il?=
 =?us-ascii?Q?ts+hPwuwm7ySukIaFcO9FDG73mdIzAulusfePE2cxIWedOyceTxT2L/K6rsN?=
 =?us-ascii?Q?o5fCDg2AiUCFW2P3Lnuq1+XBsadnH5bddxMY5/gE5TnuSxQ0Gqaob6Ohi1Qs?=
 =?us-ascii?Q?Dnm4KzahcBzYrI2CAgFXusIq2x6PBrhEdvw/GcFTF7M1PFP3vndavXq3Vu1i?=
 =?us-ascii?Q?dWKqQe8u9MoF4xSIf2WB6yeiOtd0z0nP7ZWDVgTS4IIVglGRE92T3P3QBT06?=
 =?us-ascii?Q?R4iMkF084jnLy8j2OYuqAQ3Gw/WwTPPNEgDW4LBa4HWhcCNNDzkh2cKK2+fe?=
 =?us-ascii?Q?joD8tNfTRJYJNHm9djr8n0nyYc9Lhqr+gpueutoOxAz0ASO8OqpH330y64w/?=
 =?us-ascii?Q?cwHvIYl67bf22On6tzXS9avQlGLqOAnR35XAyQNxnxVB9LAFxPYoYtd1NY5l?=
 =?us-ascii?Q?GNV5donqOnkxc/iljA5GF3rqPM1QfL1nubgXDeIbJeiNAmKVfmoQyxxA2Yvg?=
 =?us-ascii?Q?w4iP8At17WvKqAo4qPL2ECjNELEfEDE7fE8d+y9kNUNAcvjRbRZ7lp6OcS/3?=
 =?us-ascii?Q?I1StAdex3fMbTravbAD3qd+q1YwuWPtWb/PSkPT4QTydBftJi0Z+9iwaertq?=
 =?us-ascii?Q?UuuxxBKJqGvao5gaTY5xz/sSzVwVEF8d7W+fWuOiFYSExJvVwu+kuhevV3y0?=
 =?us-ascii?Q?MeujE929RBPkKFD0X8TuvTHABYdKZX3WkQcG0XBhS4StTJT++PBYHhNhBqmR?=
 =?us-ascii?Q?r84ivKOd1M+BhuZu5s9Br60KuMyDNqPxUC6fN+dAPEhU+8t0Re12T27En5JC?=
 =?us-ascii?Q?n2FqjDDA3YarUXPF/nn3FjUd0Ynu19KxP6bo3UE+17BZ+oHYLRz7UWzjYGB1?=
 =?us-ascii?Q?ATCHOxGoUfT7WVclu1CaUtm91eRID4BXpe37Jth2MSJyQThUbbUEE5lIFpof?=
 =?us-ascii?Q?nQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(7416014)(376014)(921020)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2025 14:19:31.9030
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0267edf0-d235-497a-dccd-08de149aae93
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017097.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5790

From: Ankit Agrawal <ankita@nvidia.com>

Poison (or ECC) errors can be very common on a large size cluster.
The kernel MM currently handles ECC errors / poison only on memory page
backed by struct page. The handling is currently missing for the PFNMAP
memory that does not have struct pages. The series adds such support.

Implement a new ECC handling for memory without struct pages. Kernel MM
expose registration APIs to allow modules that are managing the device
to register its device memory region. MM then tracks such regions using
interval tree.

The mechanism is largely similar to that of ECC on pfn with struct pages.
If there is an ECC error on a pfn, all the mapping to it are identified
and a SIGBUS is sent to the user space processes owning those mappings.
Note that there is one primary difference versus the handling of the
poison on struct pages, which is to skip unmapping to the faulty PFN.
This is done to handle the huge PFNMAP support added recently [1] that
enables VM_PFNMAP vmas to map at PMD or PUD level. A poison to a PFN
mapped in such as way would need breaking the PMD/PUD mapping into PTEs
that will get mirrored into the S2. This can greatly increase the cost
of table walks and have a major performance impact.

nvgrace-gpu-vfio-pci module maps the device memory to user VA (Qemu) using
remap_pfn_range without being added to the kernel [2]. These device memory
PFNs are not backed by struct page. So make nvgrace-gpu-vfio-pci module
make use of the mechanism to get poison handling support on the device
memory.

Patch rebased to v6.17-rc7.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---

Link: https://lore.kernel.org/all/20251021102327.199099-1-ankita@nvidia.com/ [v3]

v3 -> v4
- Added guards in memory_failure_pfn, register, unregister function to
simplify code. (Thanks Ira Weiny for suggestion).
- Collected reviewed-by from Shuai Xue (Thanks!) on the mm GHES patch. Also
moved it to the front of the series.
- Added check for interval_tree_iter_first before removing the device
memory region. (Thanks Jiaqi Yan for suggestion)
- If pfn doesn't belong to any address space mapping, returning
MF_IGNORED (Thanks Miaohe Lin for suggestion).
- Updated patch commit to add more details on the perf impact on
HUGE PFNMAP (Thanks Jason Gunthorpe, Tony Luck for suggestion).

v2 -> v3
- Rebased to v6.17-rc7.
- Skipped the unmapping of PFNMAP during reception of poison. Suggested by
Jason Gunthorpe, Jiaqi Yan, Vikram Sethi (Thanks!)
- Updated the check to prevent multiple registration to the same PFN
range using interval_tree_iter_first. Thanks Shameer Kolothum for the
suggestion.
- Removed the callback function in the nvgrace-gpu requiring tracking of
poisoned PFN as it isn't required anymore.
- Introduced seperate collect_procs_pfn function to collect the list of
processes mapping to the poisoned PFN.

v1 -> v2
- Change poisoned page tracking from bitmap to hashtable.
- Addressed miscellaneous comments in v1.

Link: https://lore.kernel.org/all/20240826204353.2228736-1-peterx@redhat.com/ [1]
Link: https://lore.kernel.org/all/20240220115055.23546-1-ankita@nvidia.com/ [2]

Ankit Agrawal (3):
  mm: Change ghes code to allow poison of non-struct pfn
  mm: handle poisoning of pfn without struct pages
  vfio/nvgrace-gpu: register device memory for poison handling

 MAINTAINERS                         |   1 +
 drivers/acpi/apei/ghes.c            |   6 --
 drivers/vfio/pci/nvgrace-gpu/main.c |  45 ++++++++-
 include/linux/memory-failure.h      |  17 ++++
 include/linux/mm.h                  |   1 +
 include/ras/ras_event.h             |   1 +
 mm/Kconfig                          |   1 +
 mm/memory-failure.c                 | 146 +++++++++++++++++++++++++++-
 8 files changed, 210 insertions(+), 8 deletions(-)
 create mode 100644 include/linux/memory-failure.h

-- 
2.34.1


