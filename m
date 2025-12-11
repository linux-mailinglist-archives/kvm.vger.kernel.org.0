Return-Path: <kvm+bounces-65730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C2501CB4F48
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 08:06:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6FF673016EF9
	for <lists+kvm@lfdr.de>; Thu, 11 Dec 2025 07:06:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EF252C17A1;
	Thu, 11 Dec 2025 07:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OQZcZjeW"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012055.outbound.protection.outlook.com [52.101.48.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0DF2C21C9;
	Thu, 11 Dec 2025 07:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765436787; cv=fail; b=RLEUr8CwNpD7xIOHOADmskK37+VH89o2dtLZ/y6lKJDLBM9QLfxk4MxtE3dbGd+hCKcBMydqU2ln2fMDlM+bYwgBKYMgy6w/9A8+bFVNfjewqdO/ZHyH1hWUB0mgbmiqA14OJIAE/2mXf2RgGYtmzHyt7VQA85/eEC5J16vv80g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765436787; c=relaxed/simple;
	bh=AJgjcP63ISl0KHHqVjj0h9QWCCsCVbwE3I/zAF/uftc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CnuZ5pA/Re4B2BAVit1PUzh0kWZDKhFNJkG/A40W5tcFobNJwWhxaYdPM9lfQv63IT+s9j1VOHvPlSjYZLud4SJh3dLQ8PGjCmu3nkEE3JBRkHVbQUI6pvzBiQade52YscLxbL/ywOURpb8eg0bBF0qhfGtOrsdzYEpYmILZPt4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OQZcZjeW; arc=fail smtp.client-ip=52.101.48.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ndvcPTdG8K561eI+/xxoF56GW17hy2QopZNGA8SY27VhEcqlXQJgiAIgKgu40wfftSXkx6PRholgtWCDfGKasbk7L8idrCFuGu2H/SNBYhi9Uf/N79nMZG3glV4v9zpqD1WLAwHkYw+IraGCZRn5blFOosfIC6kvs+eB+b9xFk827A+l7Ls90AeOIaLcLV7HYVMImweTsf9TT1Yql11onqjPsIuGPajoN/8Jlapc0PV32o5dVgHdZEJNu5WKczXZ8uPyGPP90UdZdIuJwAw0+0dzynFLnEv+cVwzY/B6z6BK8+HtdzgB1v2Kmeh1Etv/hP5BKvm4M5/tB3ZQoGzTkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FXwRJw/kXuFWvbzfbPcGe2EuO+zSv0mwjKJKiQmd5IE=;
 b=a5/igCGqRwIEGWSvF0lSY7PfrWNjUvGLAVtgErdYBpFxYs2OWRLc3+Cguqj3+94MNKCNNvVola/YoENsomyeDwthyxEu87gg5K2a2bmx98DWgn9lUGuHueJCFColdc6riSM0EtT6Q8hLl/RUpdwUdtNUKt1yxKj6FjgzZJvuIM9DY+4Qs3vV116u/R6VMl0aPvdOHNQfUPhzlHHm9VLuv8uYUO7VNBBpqVL6CEa2ocfj+EzujL2oVisbD6NLjqx454ekkULdMkQJuWOcKmvAKlcNPlX47tZ1uWtK7uGZDl579Hp3eCK7iNVt8RgWZ4WBvuBAxyFq6myY9pZ7v4+taQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FXwRJw/kXuFWvbzfbPcGe2EuO+zSv0mwjKJKiQmd5IE=;
 b=OQZcZjeWpa8De4xVKR3XbIHMmI54cLewjKiTkjIHZjjYdHlEFhDy/hVOFWKEJ6eWbe460usxY5VjTXyuHZmgw2SXnI9aiIpaGBi3UjS2tFUJ77vcTXcNzx3CeGmu7z1tZsvkSTU9CzGb1zNMxb2NvPdn6Azd76rEEFpgsFYLOCL5/pOG0K2kpq/0pAS0hMPjB2Rj5M4w7gYC46Cnz73ymcvDj4GMRyE6364Hfwbbc5oxOodK3vaQqV8HYpimiDuWTb+BwHiWGG+lQhY3npLtIgRqjZTwdNskd7MQeOJsZkV8bfM9SV24oUwh/kM2s/mfOmcyUp23YLGFnIPc9IKuQw==
Received: from PH7PR03CA0010.namprd03.prod.outlook.com (2603:10b6:510:339::27)
 by BY5PR12MB4066.namprd12.prod.outlook.com (2603:10b6:a03:207::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Thu, 11 Dec
 2025 07:06:20 +0000
Received: from CY4PEPF0000E9D0.namprd03.prod.outlook.com
 (2603:10b6:510:339:cafe::43) by PH7PR03CA0010.outlook.office365.com
 (2603:10b6:510:339::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.16 via Frontend Transport; Thu,
 11 Dec 2025 07:06:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000E9D0.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Thu, 11 Dec 2025 07:06:20 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 10 Dec
 2025 23:06:05 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 10 Dec
 2025 23:06:05 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 10 Dec 2025 23:06:05 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
	<mochs@nvidia.com>, <jgg@ziepe.ca>, <skolothumtho@nvidia.com>,
	<alex@shazbot.org>, <akpm@linux-foundation.org>, <linmiaohe@huawei.com>,
	<nao.horiguchi@gmail.com>
CC: <cjia@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH v1 1/3] mm: fixup pfnmap memory failure handling to use pgoff
Date: Thu, 11 Dec 2025 07:06:01 +0000
Message-ID: <20251211070603.338701-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251211070603.338701-1-ankita@nvidia.com>
References: <20251211070603.338701-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D0:EE_|BY5PR12MB4066:EE_
X-MS-Office365-Filtering-Correlation-Id: e674c306-3ae4-46cc-99b8-08de3883c996
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bxEPiqhuFIUn96+NY8yeuejrhGAJ0mhHC7AdNydTZs8pWZWSlsVtxdFBmBbq?=
 =?us-ascii?Q?w3t3MOmO9pzYk67PGMDIyjpXDi08Z7xaSovniOZWF5yZMtx1E6MNyY2CMmlF?=
 =?us-ascii?Q?sm3/3d9gVo+6tvby/TDd1Xi8Mdlqrceqwk9vMN+69y6+N1p3YUCF7bQILkQj?=
 =?us-ascii?Q?DJC9cJW0s7WCBpjslXC0H33FHRXTZDIaoM3qT9M+3PXskc2NNEZEYxJBavfX?=
 =?us-ascii?Q?3iNwq4f88upGHPZ+F4ifXSfGjYiIvZCeEEEOp2I8qA34855IWbHF1NfI+f41?=
 =?us-ascii?Q?eakZK/6Srn9Eebhsq90Lurn9D+dTxp6WyH2Fzg8vKvNXPNHxebgH0bHlAZXl?=
 =?us-ascii?Q?XgCetTlWuMhJIibiSVSGKhCavpxaOo0Q6ZcOxfH74rzrfyMUI0T00pjabQlS?=
 =?us-ascii?Q?VMMzLLslJTMwOpZGsgWAW16JZEZ7WS4l7z6ort3pj7w1zHYboDj8lLVFTot2?=
 =?us-ascii?Q?Di2kjs3wnGGpGE+QN5E0TUI+QzCnDoM6DVmLNlOz78ARo/mc1fH+uHCtzAmi?=
 =?us-ascii?Q?tTCFHSQWUPZn33mt8MD4WkejmXS4InND+eqK38N00vdjNXLzw85QjqL63Ecf?=
 =?us-ascii?Q?gfwFPnKtk5DxyTE/b9JnJSF8Ug4dXh/tCfs+RJ60WBfyUvJZh/2bA0yef4BZ?=
 =?us-ascii?Q?w+93RpsJ/BLstWpi9Rhf8VwKZT5nO5pUu6/jgMN1k5LtjW/8BKZ3liFJb+wi?=
 =?us-ascii?Q?NhNJbmqEK8O0dESP5CyrKg6o8IF/g8JdT0bpXqAWSFLwbqtq9F42I7JoHizm?=
 =?us-ascii?Q?VY2WvycZTZzvC46ZodpMo+bhi7fGiRDluwDuuJNDxrkwmhanHBpEMuMCC0xF?=
 =?us-ascii?Q?QBSRdM2tVjfrTBPkii5lnxt2ZUEWe/4jVCGCUKonOSI7IAQDCfnvyxLNF5wc?=
 =?us-ascii?Q?oIyNY7dwAdmdLQ3fjrozbk9/QL5h67rpXpmzjxX00V5aQsL9r+1HTvR8qL/f?=
 =?us-ascii?Q?ujKgR7qLdsXUkh+P+FL5UVPzkh/fhz0j7GTCWiD1XICYqMLl/6/Nl3DWXY+E?=
 =?us-ascii?Q?6vvbePcyjpISxphP2UUxIQUiG92lVPZ5/l1pw9/yrUEs00ID8xqkSxv+KC3v?=
 =?us-ascii?Q?9Uk9lBrBW1Vaakj/APhy5/5FXaqn0KJAVM+n8hr09Sv61IkUd4IHsWA9yG5V?=
 =?us-ascii?Q?PyEGlZh66xwsX+y4eUK2N7LMwbJ+KKQtg/eT9W46b2MaJg5izP0CkeC3tnTA?=
 =?us-ascii?Q?yDdwtxN4CDlG5YaGXYZWWxFPY76V0GyuYI59qIWwNr0UOFplP8rk5Q0whyid?=
 =?us-ascii?Q?NgAQZLg/o9Ht+LQBfnPA65OuRSJlgJNQ0IRs5ljU7xYDQsxfgIurup48cwMq?=
 =?us-ascii?Q?EESha7c/RCgCG8n2JqfsN+sRpALAd97/0eoSzhHpjjjmH0Hqbbuqqja4X3fx?=
 =?us-ascii?Q?7LJG++/ZB+46THNUbV8zogWx+8lLu2wkoN5qGn8y5OtidcMgJ8H/xNHJpiBM?=
 =?us-ascii?Q?gOFAN6sSa/Y2V7JQvgzoOv1vXo8nNwOwcvFYrFLJTfeBtHx/GqyDGfdvXwNK?=
 =?us-ascii?Q?+Aodm/WDLzLS29Lgc4807BQBd/QhWbaiMSHEeFm/2ZrSstp7axtQ/HOT38YQ?=
 =?us-ascii?Q?zlLZ+jSm3sYahBxC9Da/oLoy89e0gt7J84c++rJ4?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2025 07:06:20.6004
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e674c306-3ae4-46cc-99b8-08de3883c996
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4066

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


