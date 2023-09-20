Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 122497A8608
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 16:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235932AbjITOC4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 10:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234978AbjITOCz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 10:02:55 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2049.outbound.protection.outlook.com [40.107.244.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46C29D6;
        Wed, 20 Sep 2023 07:02:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OVaTSCbfPXN4Oh4u3RPpFjsccPAKhHwXzDIIrf+hC21etT/xAC97c5mT+m0RdtjXCIsUjybMLfuJi40cKjs+zeseR37a1x9ylQ2M7J7/Rw4MwwSIKX4MKI2O7DYnQ8lxCD6xhRyRK+hsVA5TAeBIqrRBLtpDpUWWRn5jypLC8YMG7DkBZNYtwVgWGX1Txw7FcCQ2LJtwvzF1fb9EpcFKPhlt+ivXMXcbhvWfVyR9wRJwMoTqg6Ml3mz2aSxgm0DtLKanljt0k1NbqXunhYrxIFzBqiQhxyFEtSVjF0TC61Yi0OObMGygctNGjof3s4mlstHhnHaJUBa1MfNNXnwD2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1/esQzqxfrhDN5pKRJQJwHN3r7WLnGtT5aODQpWge2I=;
 b=ZPbDVi6gq8ENdomvUkHpsIMeVkqER+QiMV0vtqs3wtfo8jTASME9PTlbFr+SP7c5NgEnTLWXMwZ868sseU+VYqNTRR31kkGhe6WJZbM8TnKdwgFssu52XejCXP4Y1y7W5Gm7cdWJ3+EwCgC4Z9N38apY2RAOPK8WW2NOGF7eytWG9HkHF/9f2BOqOa1xJlelDkMNW7P1cYNJV6dDrGnWlyCgdnOTcXgMyWr72MG8t9pFupj0d9pZQZCY2bXmyT7EMK2KGSeJiiLmHvRtPFfnJLW8r1gw5Zewd7G/lhTkxbpZFA5jCCN5Qp9AK9QbDgE+PY7rhSr1AODh7GRH/Q0dlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kvack.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1/esQzqxfrhDN5pKRJQJwHN3r7WLnGtT5aODQpWge2I=;
 b=qc9yeCCTr1MtLoD9tT0Su3rNNOEfS44Rta1ZxI3/znmbc1mLNdWosGMoHk0+E3bXP52mJ5+HysIuYxn8bvw7hUHly8k23jZVMpScXCpcbC1UeWqAnjaeL3B1EBgKYqndsw2pOx5gAUiTzjFvhEqKY86g54AwhMmqg/z40UrSvFRFZwyM87e1UMBNcNAHz0iCTu8wmb4EKkWDnnw31NxiQTbGQzUjq5P6E0zNuHzOSxI7LykTObG1H4QJ+6cA2VtgLMg99yMUhwKwr9aVLe1Y3XfJovalUCsOPN1wojOX1sY7oE8n11ywD7B846iUuRhi2oLBWKUeJk3AIc0NghPidg==
Received: from DM5PR07CA0070.namprd07.prod.outlook.com (2603:10b6:4:ad::35) by
 SN7PR12MB6931.namprd12.prod.outlook.com (2603:10b6:806:261::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.27; Wed, 20 Sep
 2023 14:02:38 +0000
Received: from DS2PEPF00003444.namprd04.prod.outlook.com
 (2603:10b6:4:ad:cafe::a7) by DM5PR07CA0070.outlook.office365.com
 (2603:10b6:4:ad::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.28 via Frontend
 Transport; Wed, 20 Sep 2023 14:02:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS2PEPF00003444.mail.protection.outlook.com (10.167.17.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.19 via Frontend Transport; Wed, 20 Sep 2023 14:02:37 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 20 Sep
 2023 07:02:24 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 20 Sep
 2023 07:02:24 -0700
Received: from sgarnayak-dt.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Wed, 20 Sep 2023 07:02:18 -0700
From:   <ankita@nvidia.com>
To:     <ankita@nvidia.com>, <jgg@nvidia.com>,
        <alex.williamson@redhat.com>, <akpm@linux-foundation.org>,
        <tony.luck@intel.com>, <bp@alien8.de>, <naoya.horiguchi@nec.com>,
        <linmiaohe@huawei.com>
CC:     <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
        <targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
        <anuaggarwal@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-edac@vger.kernel.org>,
        <kvm@vger.kernel.org>
Subject: [PATCH v1 1/4] mm: handle poisoning of pfn without struct pages
Date:   Wed, 20 Sep 2023 19:32:07 +0530
Message-ID: <20230920140210.12663-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230920140210.12663-1-ankita@nvidia.com>
References: <20230920140210.12663-1-ankita@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003444:EE_|SN7PR12MB6931:EE_
X-MS-Office365-Filtering-Correlation-Id: 21ab9138-4687-41fc-ce88-08dbb9e23f32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qs+0LhfxU7AbH5bsjHByhHm+4xGwWndLWXGec1sGCvY8/wrLqw+nw1JpCJIdEPd2HFuxT3hwDqcgZG6MKOevvf9RhXWQEQzBIL52KdZH7dh6mLALIHWPW/Vpbj+MuYI+7ULxtQK9PNmau0An1+m+7weH+/6h21I+06fTtP6Y8t5pOALMAH9UAVDuGXIPzdya6Hf6PoQnf7+/lxNqmIkorvShm9KVXijmf2lUMfMPic/BZe7isVn7ytR1zA4OQkOMxy7/+79mk//ZJ3OkKyCFoNy637chJA44isLfN9qHo7Jwbm78NBM6Ipgq9mELPQ9nTb2BueJSqlgvxuP+N7Yrza0tO1Lz6ZnKrEVMUV4E1dUoLsIJ2UoAmwsA9/U4NX+dIZV7XXWN78y3j1d0gLmyFzmUwjnZiEdzqkx6oeUfEEAaViskRmiXWdDMNZCY16XmJqqIfp8YPH7NuTsN0u35uS9m3fRDeecWNE4WMBRtQx8pBuD9j4C92CtLo/PuphCFZ6WuccXidg0xBhhn72GOVCQTv8X2WSwfupg8aTguBPfLHi2IoYDMDyPFUEgK6iX+yPC/JxpG7VG5CU7aIZjWIkJqN3YgdejemboR5/6EjGxcf6FSL1C+78VbBGmOaKJZOIAmxo5L+eA0ek9tF8qWfl8s2JX8z1U0ZsLpbwX4dEAxEPEH+cRd61r09gsaUYyUxxtF2ZJKlQ7bJQ56qUfOgfr2n8oMyYgnNuli+r8jD74KzNWg0ng0GiTeLPLOYEnseYW/Dr2mAnlJlSJ5FM9duQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(396003)(376002)(39860400002)(186009)(82310400011)(1800799009)(451199024)(40470700004)(46966006)(36840700001)(7636003)(356005)(2616005)(82740400003)(8936002)(26005)(40460700003)(1076003)(4326008)(8676002)(7416002)(2906002)(2876002)(36860700001)(83380400001)(47076005)(36756003)(30864003)(426003)(336012)(5660300002)(86362001)(7696005)(110136005)(40480700001)(6666004)(54906003)(478600001)(70586007)(316002)(41300700001)(70206006)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2023 14:02:37.5536
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 21ab9138-4687-41fc-ce88-08dbb9e23f32
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS2PEPF00003444.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6931
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ankit Agrawal <ankita@nvidia.com>

The kernel MM currently does not handle ECC errors / poison on a memory
region that is not backed by struct pages. If a memory region is mapped
using remap_pfn_range(), but not added to the kernel, MM will not have
associated struct pages. Add a new mechanism to handle memory failure
on such memory.

Make kernel MM expose a function to allow modules managing the device
memory to register a failure function and the physical address space
associated with the device memory. MM maintains this information as
interval tree. The registered memory failure function is used by MM to
notify the kernel module managing the PFN, so that the module may take
any required action. The module for example may use the information
to track the poisoned pages.

In this implementation, kernel MM follows the following sequence similar
(mostly) to the memory_failure() handler for struct page backed memory:
1. memory_failure() is triggered on reception of a poison error. An
absence of struct page is detected and consequently memory_failure_pfn()
is executed.
2. memory_failure_pfn() call the newly introduced failure handler exposed
by the module managing the poisoned memory to notify it of the problematic
PFN.
3. memory_failure_pfn() unmaps the stage-2 mapping to the PFN.
4. memory_failure_pfn() collects the processes mapped to the PFN.
5. memory_failure_pfn() sends SIGBUS (BUS_MCEERR_AO) to all the processes
mapping the faulty PFN using kill_procs().
6. An access to the faulty PFN by an operation in VM at a later point
is trapped and user_mem_abort() is called.
7. The vma ops fault function gets called due to the absence of Stage-2
mapping. It is expected to return VM_FAULT_HWPOISON on the PFN.
8. __gfn_to_pfn_memslot() then returns KVM_PFN_ERR_HWPOISON, which cause
the poison with SIGBUS (BUS_MCEERR_AR) to be sent to the QEMU process
through kvm_send_hwpoison_signal().

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 include/linux/memory-failure.h |  22 ++++++
 include/linux/mm.h             |   1 +
 include/ras/ras_event.h        |   1 +
 mm/Kconfig                     |   1 +
 mm/memory-failure.c            | 135 ++++++++++++++++++++++++++++-----
 5 files changed, 139 insertions(+), 21 deletions(-)
 create mode 100644 include/linux/memory-failure.h

diff --git a/include/linux/memory-failure.h b/include/linux/memory-failure.h
new file mode 100644
index 000000000000..9a579960972a
--- /dev/null
+++ b/include/linux/memory-failure.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_MEMORY_FAILURE_H
+#define _LINUX_MEMORY_FAILURE_H
+
+#include <linux/interval_tree.h>
+
+struct pfn_address_space;
+
+struct pfn_address_space_ops {
+	void (*failure)(struct pfn_address_space *pfn_space, unsigned long pfn);
+};
+
+struct pfn_address_space {
+	struct interval_tree_node node;
+	const struct pfn_address_space_ops *ops;
+	struct address_space *mapping;
+};
+
+int register_pfn_address_space(struct pfn_address_space *pfn_space);
+void unregister_pfn_address_space(struct pfn_address_space *pfn_space);
+
+#endif /* _LINUX_MEMORY_FAILURE_H */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index bf5d0b1b16f4..d677688c016c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3934,6 +3934,7 @@ enum mf_action_page_type {
 	MF_MSG_BUDDY,
 	MF_MSG_DAX,
 	MF_MSG_UNSPLIT_THP,
+	MF_MSG_PFN_MAP,
 	MF_MSG_UNKNOWN,
 };
 
diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
index cbd3ddd7c33d..05c3e6f6bd02 100644
--- a/include/ras/ras_event.h
+++ b/include/ras/ras_event.h
@@ -373,6 +373,7 @@ TRACE_EVENT(aer_event,
 	EM ( MF_MSG_BUDDY, "free buddy page" )				\
 	EM ( MF_MSG_DAX, "dax page" )					\
 	EM ( MF_MSG_UNSPLIT_THP, "unsplit thp" )			\
+	EM ( MF_MSG_PFN_MAP, "non struct page pfn" )			\
 	EMe ( MF_MSG_UNKNOWN, "unknown page" )
 
 /*
diff --git a/mm/Kconfig b/mm/Kconfig
index 264a2df5ecf5..2ee42ff8b6ca 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -762,6 +762,7 @@ config MEMORY_FAILURE
 	depends on ARCH_SUPPORTS_MEMORY_FAILURE
 	bool "Enable recovery from hardware memory errors"
 	select MEMORY_ISOLATION
+	select INTERVAL_TREE
 	select RAS
 	help
 	  Enables code to recover from some memory failures on systems
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 4d6e43c88489..e1e1d96fd6a2 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -38,6 +38,7 @@
 
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/memory-failure.h>
 #include <linux/page-flags.h>
 #include <linux/sched/signal.h>
 #include <linux/sched/task.h>
@@ -60,6 +61,7 @@
 #include <linux/pagewalk.h>
 #include <linux/shmem_fs.h>
 #include <linux/sysctl.h>
+#include <linux/pfn_t.h>
 #include "swap.h"
 #include "internal.h"
 #include "ras/ras_event.h"
@@ -144,6 +146,10 @@ static struct ctl_table memory_failure_table[] = {
 	{ }
 };
 
+static struct rb_root_cached pfn_space_itree = RB_ROOT_CACHED;
+
+static DEFINE_MUTEX(pfn_space_lock);
+
 /*
  * Return values:
  *   1:   the page is dissolved (if needed) and taken off from buddy,
@@ -422,15 +428,15 @@ static unsigned long dev_pagemap_mapping_shift(struct vm_area_struct *vma,
  * Schedule a process for later kill.
  * Uses GFP_ATOMIC allocations to avoid potential recursions in the VM.
  *
- * Note: @fsdax_pgoff is used only when @p is a fsdax page and a
- * filesystem with a memory failure handler has claimed the
- * memory_failure event. In all other cases, page->index and
- * page->mapping are sufficient for mapping the page back to its
+ * Notice: @pgoff is used either when @p is a fsdax page or a PFN is not
+ * backed by struct page and a filesystem with a memory failure handler
+ * has claimed the memory_failure event. In all other cases, page->index
+ * and page->mapping are sufficient for mapping the page back to its
  * corresponding user virtual address.
  */
 static void __add_to_kill(struct task_struct *tsk, struct page *p,
 			  struct vm_area_struct *vma, struct list_head *to_kill,
-			  unsigned long ksm_addr, pgoff_t fsdax_pgoff)
+			  unsigned long ksm_addr, pgoff_t pgoff)
 {
 	struct to_kill *tk;
 
@@ -440,13 +446,18 @@ static void __add_to_kill(struct task_struct *tsk, struct page *p,
 		return;
 	}
 
-	tk->addr = ksm_addr ? ksm_addr : page_address_in_vma(p, vma);
-	if (is_zone_device_page(p)) {
-		if (fsdax_pgoff != FSDAX_INVALID_PGOFF)
-			tk->addr = vma_pgoff_address(fsdax_pgoff, 1, vma);
-		tk->size_shift = dev_pagemap_mapping_shift(vma, tk->addr);
-	} else
-		tk->size_shift = page_shift(compound_head(p));
+	if (vma->vm_flags | PFN_MAP) {
+		tk->addr = vma_pgoff_address(pgoff, 1, vma);
+		tk->size_shift = PAGE_SHIFT;
+	} else {
+		tk->addr = ksm_addr ? ksm_addr : page_address_in_vma(p, vma);
+		if (is_zone_device_page(p)) {
+			if (pgoff != FSDAX_INVALID_PGOFF)
+				tk->addr = vma_pgoff_address(pgoff, 1, vma);
+			tk->size_shift = dev_pagemap_mapping_shift(vma, tk->addr);
+		} else
+			tk->size_shift = page_shift(compound_head(p));
+	}
 
 	/*
 	 * Send SIGKILL if "tk->addr == -EFAULT". Also, as
@@ -666,8 +677,7 @@ static void collect_procs_file(struct page *page, struct list_head *to_kill,
 	i_mmap_unlock_read(mapping);
 }
 
-#ifdef CONFIG_FS_DAX
-static void add_to_kill_fsdax(struct task_struct *tsk, struct page *p,
+static void add_to_kill_pgoff(struct task_struct *tsk, struct page *p,
 			      struct vm_area_struct *vma,
 			      struct list_head *to_kill, pgoff_t pgoff)
 {
@@ -677,9 +687,9 @@ static void add_to_kill_fsdax(struct task_struct *tsk, struct page *p,
 /*
  * Collect processes when the error hit a fsdax page.
  */
-static void collect_procs_fsdax(struct page *page,
-		struct address_space *mapping, pgoff_t pgoff,
-		struct list_head *to_kill)
+static void collect_procs_pgoff(struct page *page,
+				struct address_space *mapping, pgoff_t pgoff,
+				struct list_head *to_kill)
 {
 	struct vm_area_struct *vma;
 	struct task_struct *tsk;
@@ -693,13 +703,12 @@ static void collect_procs_fsdax(struct page *page,
 			continue;
 		vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 			if (vma->vm_mm == t->mm)
-				add_to_kill_fsdax(t, page, vma, to_kill, pgoff);
+				add_to_kill_pgoff(t, page, vma, to_kill, pgoff);
 		}
 	}
 	rcu_read_unlock();
 	i_mmap_unlock_read(mapping);
 }
-#endif /* CONFIG_FS_DAX */
 
 /*
  * Collect the processes who have the corrupted page mapped to kill.
@@ -893,6 +902,7 @@ static const char * const action_page_types[] = {
 	[MF_MSG_BUDDY]			= "free buddy page",
 	[MF_MSG_DAX]			= "dax page",
 	[MF_MSG_UNSPLIT_THP]		= "unsplit thp",
+	[MF_MSG_PFN_MAP]		= "non struct page pfn",
 	[MF_MSG_UNKNOWN]		= "unknown page",
 };
 
@@ -1324,7 +1334,8 @@ static int action_result(unsigned long pfn, enum mf_action_page_type type,
 
 	num_poisoned_pages_inc(pfn);
 
-	update_per_node_mf_stats(pfn, result);
+	if (type != MF_MSG_PFN_MAP)
+		update_per_node_mf_stats(pfn, result);
 
 	pr_err("%#lx: recovery action for %s: %s\n",
 		pfn, action_page_types[type], action_name[result]);
@@ -1805,7 +1816,7 @@ int mf_dax_kill_procs(struct address_space *mapping, pgoff_t index,
 
 		SetPageHWPoison(page);
 
-		collect_procs_fsdax(page, mapping, index, &to_kill);
+		collect_procs_pgoff(page, mapping, index, &to_kill);
 		unmap_and_kill(&to_kill, page_to_pfn(page), mapping,
 				index, mf_flags);
 unlock:
@@ -2144,6 +2155,83 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
 	return rc;
 }
 
+int register_pfn_address_space(struct pfn_address_space *pfn_space)
+{
+	if (!pfn_space)
+		return -EINVAL;
+
+	if (!request_mem_region(pfn_space->node.start << PAGE_SHIFT,
+		(pfn_space->node.last - pfn_space->node.start + 1) << PAGE_SHIFT, ""))
+		return -EBUSY;
+
+	mutex_lock(&pfn_space_lock);
+	interval_tree_insert(&pfn_space->node, &pfn_space_itree);
+	mutex_unlock(&pfn_space_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(register_pfn_address_space);
+
+void unregister_pfn_address_space(struct pfn_address_space *pfn_space)
+{
+	if (!pfn_space)
+		return;
+
+	mutex_lock(&pfn_space_lock);
+	interval_tree_remove(&pfn_space->node, &pfn_space_itree);
+	mutex_unlock(&pfn_space_lock);
+	release_mem_region(pfn_space->node.start << PAGE_SHIFT,
+		(pfn_space->node.last - pfn_space->node.start + 1) << PAGE_SHIFT);
+}
+EXPORT_SYMBOL_GPL(unregister_pfn_address_space);
+
+static int memory_failure_pfn(unsigned long pfn, int flags)
+{
+	struct interval_tree_node *node;
+	int res = MF_FAILED;
+	LIST_HEAD(tokill);
+
+	mutex_lock(&pfn_space_lock);
+	/*
+	 * Modules registers with MM the address space mapping to the device memory they
+	 * manage. Iterate to identify exactly which address space has mapped to this
+	 * failing PFN.
+	 */
+	for (node = interval_tree_iter_first(&pfn_space_itree, pfn, pfn); node;
+	     node = interval_tree_iter_next(node, pfn, pfn)) {
+		struct pfn_address_space *pfn_space =
+			container_of(node, struct pfn_address_space, node);
+		/*
+		 * Modules managing the device memory need to be conveyed about the
+		 * memory failure so that the poisoned PFN can be tracked.
+		 */
+		if (pfn_space->ops)
+			pfn_space->ops->failure(pfn_space, pfn);
+
+		collect_procs_pgoff(NULL, pfn_space->mapping, pfn, &tokill);
+
+		unmap_mapping_range(pfn_space->mapping, pfn << PAGE_SHIFT,
+				    PAGE_SIZE, 0);
+
+		res = MF_RECOVERED;
+	}
+	mutex_unlock(&pfn_space_lock);
+
+	if (res == MF_FAILED)
+		return action_result(pfn, MF_MSG_PFN_MAP, res);
+
+	/*
+	 * Unlike System-RAM there is no possibility to swap in a different
+	 * physical page at a given virtual address, so all userspace
+	 * consumption of direct PFN memory necessitates SIGBUS (i.e.
+	 * MF_MUST_KILL)
+	 */
+	flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
+	kill_procs(&tokill, true, false, pfn, flags);
+
+	return action_result(pfn, MF_MSG_PFN_MAP, MF_RECOVERED);
+}
+
 /**
  * memory_failure - Handle memory failure of a page.
  * @pfn: Page Number of the corrupted page
@@ -2183,6 +2271,11 @@ int memory_failure(unsigned long pfn, int flags)
 	if (!(flags & MF_SW_SIMULATED))
 		hw_memory_failure = true;
 
+	if (!pfn_valid(pfn) && !arch_is_platform_page(PFN_PHYS(pfn))) {
+		res = memory_failure_pfn(pfn, flags);
+		goto unlock_mutex;
+	}
+
 	p = pfn_to_online_page(pfn);
 	if (!p) {
 		res = arch_memory_failure(pfn, flags);
-- 
2.17.1

