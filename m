Return-Path: <kvm+bounces-65920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 43794CBA4C9
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 05:49:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8F28F30E67C5
	for <lists+kvm@lfdr.de>; Sat, 13 Dec 2025 04:47:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2A9E28A72F;
	Sat, 13 Dec 2025 04:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PUgdCyD0"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012037.outbound.protection.outlook.com [40.93.195.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF22D2417F2;
	Sat, 13 Dec 2025 04:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765601249; cv=fail; b=MEn+hBZrln2rhkEZv3RyqVdkcPAYMTBKuTNW8ljVe9ygOWqDFQRqNXE0TiAHRHooztsH0EP2NN8sIl9VW/M0sb0He/ljqno5yWttsQeAfHkOTA32340idNSl3qBj/WQd7nlaDHNGv9A3w/lE0JMHW9y0b1OKzRl3rOlr0D09YBg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765601249; c=relaxed/simple;
	bh=AJgjcP63ISl0KHHqVjj0h9QWCCsCVbwE3I/zAF/uftc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p44FKU0Po8D5S6WJcba3kiHySoF0V1FxpICySaKp5ondkGhWbjO3gcAv5bU0/iMS7VF8M1ZIpnKaJXZcTiHMzFLOtwaUjVkE5J8zPWL+cUs7qr2x3UIkwWMsWq/OjkCaIS8PC3AJCv8tUMA6+r6selzgcoYQcRLUUQ77TMvUhHo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PUgdCyD0; arc=fail smtp.client-ip=40.93.195.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EAwK7+86AXczGG1rs3WR5OVTMBm4ckbTIzp37qAFeJereK2oj3wSp5CvjkmPg5u85Hdt9Kb0LpWX8ob/6PzCtHEzn/0i1DdPZZoUK8U1S+Vp9/OBIzMwYym7dDnspKzgfvf3ihwmENOn8C11kw/n0hGmSRYYZ89tAL0fzo/mIRXEW3wnZtN3SookYoYI/9YaE19uiYYctexgPOQJWsECkYYnFKpcVtDHrCnyZE0WcSC4WALxQsL3nARUBYuB1NYC7IPFdj/5JR7Eb5Itn7m4LqsbxKg369XGd1uzHIFiJCgu6Aizf/ChlOXQn23lM5zUqoTtCS057rJUH9XYLlcWsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FXwRJw/kXuFWvbzfbPcGe2EuO+zSv0mwjKJKiQmd5IE=;
 b=AqTU53gXAMB8EpLbIGlmCSwLAgOgziV0K4TSIs6WJ05hJIkUwTmCCizS4irVvtUXqfylHDhmjxGKvorbOrxA6aynTg8EHHU54cfmHATPKNy2M/+eUGq43u/Q00ZhxT5KIX5ru5V+ra+XSW4YLNYhj5LWq3vMKtpoNw1WL6y3vTONa1zPwq6wpTNs5mhvFjiHYskakHHgJ56A1TQdpoSM9amhEUAVo5xzzV6e1xGtghe/B2DHY7qxv5dTCOfzutor2kvD4To2A000a46UgNDMkJD6pGaZAuqhXmcwMmX8ze2/wiixcCQHPi2aXyjOiDNxZ9oiod7LxM+9N37FQobkLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FXwRJw/kXuFWvbzfbPcGe2EuO+zSv0mwjKJKiQmd5IE=;
 b=PUgdCyD0i/74jiHQHBr/mCdT6q+7/xwCExb/mLgQ4OdSswijwTsK9GZ5ElWCikHfH8JiSMBxYmdYpdMgDWOKe1UX7ZkdiHImcy8EUDa/tH5bbWcw9R4pSQPCvPzi3Fa5FwcG4pASXMl1c711mmN4NNp+71Mb21OcG5+JVCZ64a2xQ08GdFuMmucwv7RK8hlRUWTQ3Sw2pRiIoCKrPzKuDxcOLRZE5l04rJGlnq2nfsJyhEU9mUUFvi81SKTWtkRSlK+cw64F9FoeLqPEVzWrUlEx84YyfhuBlFH/tiez7b5PbTWPou4UzRw4Rxlrr3z7QwkSS8ZDTfVvNnYRp7Y9sQ==
Received: from BN9PR03CA0326.namprd03.prod.outlook.com (2603:10b6:408:112::31)
 by BL1PR12MB5802.namprd12.prod.outlook.com (2603:10b6:208:392::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Sat, 13 Dec
 2025 04:47:21 +0000
Received: from BN1PEPF0000467F.namprd03.prod.outlook.com
 (2603:10b6:408:112:cafe::6a) by BN9PR03CA0326.outlook.office365.com
 (2603:10b6:408:112::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.11 via Frontend Transport; Sat,
 13 Dec 2025 04:47:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN1PEPF0000467F.mail.protection.outlook.com (10.167.243.84) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.4 via Frontend Transport; Sat, 13 Dec 2025 04:47:21 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 12 Dec
 2025 20:47:10 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Fri, 12 Dec 2025 20:47:09 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 12 Dec 2025 20:47:09 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
	<mochs@nvidia.com>, <jgg@ziepe.ca>, <skolothumtho@nvidia.com>,
	<alex@shazbot.org>, <akpm@linux-foundation.org>, <linmiaohe@huawei.com>,
	<nao.horiguchi@gmail.com>
CC: <cjia@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH v2 1/3] mm: fixup pfnmap memory failure handling to use pgoff
Date: Sat, 13 Dec 2025 04:47:06 +0000
Message-ID: <20251213044708.3610-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251213044708.3610-1-ankita@nvidia.com>
References: <20251213044708.3610-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0000467F:EE_|BL1PR12MB5802:EE_
X-MS-Office365-Filtering-Correlation-Id: 3908fa4d-1d36-4d37-376f-08de3a02b3ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kREk4zXAURHQUOqOC3AZTAXlAAAZE1H84CNVjGz6Vdyw4cuRVuBLWsX5T0GS?=
 =?us-ascii?Q?bNQrtjmP8qw3gRQmfwudhp41y8P6ZxbTO3H4IOq2dYY0yZB3HLRanenRZU41?=
 =?us-ascii?Q?e6rvEMYcI6CbXMWh/mQbimdbFSxRBKpHQB/UEbJRUrl9OuM0e0TXY7C5B4y1?=
 =?us-ascii?Q?zY1JPIyrx+KkuTI4eXTTISHVZOSBRCuAp3Mi2w8C67bBdE7LW/rfqThsqKW3?=
 =?us-ascii?Q?4gr1tUUCSXG8HtSsIlV5zwFYkLgstfXjowFWonAstJfZ/E+APjPkXcgtm/Jg?=
 =?us-ascii?Q?/WInhZjvGpHo/K7hBvedLYqPqOh5muBH5Zeq1v7V39F69fHTaewHpLXxVWhH?=
 =?us-ascii?Q?+u4w0xy4Qx8DDibxSt1S6ZomhM2eLOOUKsWd8aKDbbIUXfvIEJjODqz1E4jS?=
 =?us-ascii?Q?LuwZvKld1eTuU4vp6+UFAzKRebg5F21ZaLPdYDxHXljLSDTk+PnhSjAjplF1?=
 =?us-ascii?Q?h32wqWj1VTtQR2UcFdZ1tz3PCR4xRgV7FpAixBJAQ/UEAXo41G7TTaxewHbx?=
 =?us-ascii?Q?lnc9GF45lgjjZdxBwgbBO7dqXqJC2hNs+zo99aaq8pAd06hZ8YGRM+4+eDr1?=
 =?us-ascii?Q?6bfhFQevoOTRF3jld8XOWM9sWKW/xKXOhTuW8DzMw4jCRvVZmcj97wwDHMYF?=
 =?us-ascii?Q?KggWwzMBeIyC0TQMRjgEQEKK53QNNuf58gZGfUplDe1uGDOD1aaOQVqWHeLS?=
 =?us-ascii?Q?lyUrh29D6jse2F+AVx7pm+6Mw0BPQ+4p+803qzWAOQuHJI7Fahhxz5FX5Efs?=
 =?us-ascii?Q?N3IlMyyeMOVpgpqzNypVpn78Nr5Z/C7m7eKuqevi6+xcIVm1ePB7cuPmb2ZZ?=
 =?us-ascii?Q?Jl/bBq0iFtWPNHMc70tBUE+iIZy95bJDP280qP9+ihFhoRAajKXWFcEDHSmX?=
 =?us-ascii?Q?wNEayKmqDobMZXNFlcwumR6FJ6tFL5cLnTKR83pNxBUYlmxS2YnYFBHHKoqF?=
 =?us-ascii?Q?v/jp1rojxzh6tkylpP4url19C11pGiU+ctInz94TFk6pEJiq4c3qXgyZSEgB?=
 =?us-ascii?Q?ihO9JroePAWIhwvD+MDUWGaUT0eyKuNrFh35WmPeZX489Y2o9/XdHb50OUYX?=
 =?us-ascii?Q?6ZZ003kE7Vzo4nLVGQGjmcBgYJcAFC8qT77kak+iiZKqmgL4sbSNS/bX8Pzp?=
 =?us-ascii?Q?RVofg5P1KoFZUMX2/6Oc371jiuzf0fQ1Aib95gaxKYRD2d5QHrIBBqCgZC06?=
 =?us-ascii?Q?wWfd9Lza3RmjRvsAaQZR4eYOPgErV75N4P3F0uX5SjpLUICUktD11YeOx2nd?=
 =?us-ascii?Q?fRH30G9pZZLg8nGJcpM62zAev8hMfHqSViKkO1UGIC0xhEyhkSrGUB/Kl4NC?=
 =?us-ascii?Q?S83vIf9cW89PCF8+z7aaRNR/6jSb2sfYIJxJI6X5l0O9M3in49ojhNens31j?=
 =?us-ascii?Q?Nv922+1C0ApvDAkuQHjX7UpEZQWou2hDIDMuLQasCQE/P2GZ6sXgHqX2Kpa4?=
 =?us-ascii?Q?wk8oUgr/rDENkZvF7hIR5Fiqc7sLUDQ04HPn79UEDER2g8eHgcVjw6cb2GQD?=
 =?us-ascii?Q?tXzhqhT7yvrI20LxjHfRz8bhLqzozrV+Gnvvxvkc4SRR8+0Ti338OU1me+Tf?=
 =?us-ascii?Q?uP8SLJZuQ091nFa0fjXBcNVvVafskkDAQX7bxAqj?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2025 04:47:21.0067
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3908fa4d-1d36-4d37-376f-08de3a02b3ab
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000467F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5802

From: Ankit Agrawal <ankita@nvidia.com>

The memory failure handling implementation for the PFNMAP memory with no
struct pages is faulty. The VA of the mapping is determined based on the
the PFN. It should instead be based on the file mapping offset.

At the occurrence of poison, the memory_failure_pfn is triggered on the
poisoned PFN. Introduce a callback function that allows mm to translate
the PFN to the corresponding file page offset. The kernel module using
the registration API must implement the callback function and provide the
translation. The translated value is then used to determine the VA
information and sending the SIGBUS to the usermode process mapped to
the poisoned PFN.

The callback is also useful for the driver to be notified of the poisoned
PFN, which may then track it.

Fixes: 2ec41967189c ("mm: handle poisoning of pfn without struct pages")

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 include/linux/memory-failure.h |  2 ++
 mm/memory-failure.c            | 29 ++++++++++++++++++-----------
 2 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/include/linux/memory-failure.h b/include/linux/memory-failure.h
index bc326503d2d2..7b5e11cf905f 100644
--- a/include/linux/memory-failure.h
+++ b/include/linux/memory-failure.h
@@ -9,6 +9,8 @@ struct pfn_address_space;
 struct pfn_address_space {
 	struct interval_tree_node node;
 	struct address_space *mapping;
+	int (*pfn_to_vma_pgoff)(struct vm_area_struct *vma,
+				unsigned long pfn, pgoff_t *pgoff);
 };
 
 int register_pfn_address_space(struct pfn_address_space *pfn_space);
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index fbc5a01260c8..c80c2907da33 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2161,6 +2161,9 @@ int register_pfn_address_space(struct pfn_address_space *pfn_space)
 {
 	guard(mutex)(&pfn_space_lock);
 
+	if (!pfn_space->pfn_to_vma_pgoff)
+		return -EINVAL;
+
 	if (interval_tree_iter_first(&pfn_space_itree,
 				     pfn_space->node.start,
 				     pfn_space->node.last))
@@ -2183,10 +2186,10 @@ void unregister_pfn_address_space(struct pfn_address_space *pfn_space)
 }
 EXPORT_SYMBOL_GPL(unregister_pfn_address_space);
 
-static void add_to_kill_pfn(struct task_struct *tsk,
-			    struct vm_area_struct *vma,
-			    struct list_head *to_kill,
-			    unsigned long pfn)
+static void add_to_kill_pgoff(struct task_struct *tsk,
+			      struct vm_area_struct *vma,
+			      struct list_head *to_kill,
+			      pgoff_t pgoff)
 {
 	struct to_kill *tk;
 
@@ -2197,12 +2200,12 @@ static void add_to_kill_pfn(struct task_struct *tsk,
 	}
 
 	/* Check for pgoff not backed by struct page */
-	tk->addr = vma_address(vma, pfn, 1);
+	tk->addr = vma_address(vma, pgoff, 1);
 	tk->size_shift = PAGE_SHIFT;
 
 	if (tk->addr == -EFAULT)
 		pr_info("Unable to find address %lx in %s\n",
-			pfn, tsk->comm);
+			pgoff, tsk->comm);
 
 	get_task_struct(tsk);
 	tk->tsk = tsk;
@@ -2212,11 +2215,12 @@ static void add_to_kill_pfn(struct task_struct *tsk,
 /*
  * Collect processes when the error hit a PFN not backed by struct page.
  */
-static void collect_procs_pfn(struct address_space *mapping,
+static void collect_procs_pfn(struct pfn_address_space *pfn_space,
 			      unsigned long pfn, struct list_head *to_kill)
 {
 	struct vm_area_struct *vma;
 	struct task_struct *tsk;
+	struct address_space *mapping = pfn_space->mapping;
 
 	i_mmap_lock_read(mapping);
 	rcu_read_lock();
@@ -2226,9 +2230,12 @@ static void collect_procs_pfn(struct address_space *mapping,
 		t = task_early_kill(tsk, true);
 		if (!t)
 			continue;
-		vma_interval_tree_foreach(vma, &mapping->i_mmap, pfn, pfn) {
-			if (vma->vm_mm == t->mm)
-				add_to_kill_pfn(t, vma, to_kill, pfn);
+		vma_interval_tree_foreach(vma, &mapping->i_mmap, 0, ULONG_MAX) {
+			pgoff_t pgoff;
+
+			if (vma->vm_mm == t->mm &&
+			    !pfn_space->pfn_to_vma_pgoff(vma, pfn, &pgoff))
+				add_to_kill_pgoff(t, vma, to_kill, pgoff);
 		}
 	}
 	rcu_read_unlock();
@@ -2264,7 +2271,7 @@ static int memory_failure_pfn(unsigned long pfn, int flags)
 			struct pfn_address_space *pfn_space =
 				container_of(node, struct pfn_address_space, node);
 
-			collect_procs_pfn(pfn_space->mapping, pfn, &tokill);
+			collect_procs_pfn(pfn_space, pfn, &tokill);
 
 			mf_handled = true;
 		}
-- 
2.34.1


