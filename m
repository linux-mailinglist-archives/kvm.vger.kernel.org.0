Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3846D8589
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 20:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjDESC4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 14:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233354AbjDESCu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 14:02:50 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2053.outbound.protection.outlook.com [40.107.102.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4387AB3;
        Wed,  5 Apr 2023 11:02:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WNJuBIWO5tL7OjllMJfC7zFWEySvvPRmrfCU5VRvA48/qNbpCYcUoiTkaCZH7IigA7wT2/HRfWhTvj28gUcx9Bly4vvvp3F08iAJlPwSI+KIbjz5uwgSlyhJdf30oTIQi6HT0GcABiZm7as9mPJ71KKJ2E23XcysYU9+qMM6OdH10O+Ix+r0WqNUd5e1f9o3V6EyfvUCIgV20S2qyT9QqiIpFV6lcDddSKl+eqdYD+DFfc682P8vByUq0kawPJKSpj4A9K+kvoOGuDz5MV3lZD01ZbYBxIFZygqJZKcIiGyCG5qL1tvAy3xG6RkZfpYBvH8JHslJODzY9Q41DeBqPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lN7JCeX+38WUzhVmzlDe4zwhECT4eimEo59GDuBNPwk=;
 b=iEgQjGnI0feL3TnVyS7MsvEM/nD656gCc4re2gVfL8tcRZNL5RE9qlP0VlfAF1m+hQPUrk5bR9TfieoVBozLLlkJcoIqC/KjhrpzPlXeArvD2sZ3Mw1JsF5UFLI0x5CiE0NV/kkcXfFBonurU3LIJsvRlS6JFcV2+ScSUQsQjWYga+jsdwf+JQBTreEY0Jb0UGoBhbNhG8D0RoZPNvXTUGDjeWUfTypCCJhxPbyDBN64elmnL19U33eyxLXj+Zz8dO94JQUYgw1mAvRWUWJhJ9ugBcPdWgsT2B2V7oyKMJ4RQk1uPnskR0yc+Ex8c83Y/J04JjAjRTEKEPVUNX2DhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lN7JCeX+38WUzhVmzlDe4zwhECT4eimEo59GDuBNPwk=;
 b=knD+HkYCUJOzMuS9wVgQb50u3hipM/e5qHocdCCInJsDEfpzABiIuF03hDg2Jo2eRPqU9Dti+3oX853gRrVJ3V3kyCqJ6KgV5A6WgQTigDIm/55Gtu/NlFhOolsMbS4lzYiAskBRZ5auQxWrbfCnuR41dm4bZ2URIdrbCWZCrLpDgxaGmMxe+TD4tjO4B3dH0IZh8Oo9TuBAvUrJMWyvvuWmF0UavB7lIDLJTqD3BnYrvXmzHZGaOX/NYgqYUOGlMYpVBKfV/7ZQbeXq05ZyXVclqcJZhNwfoElZVGCHkYXBl+3W/SqH6m1HvGMqB/KJtthaAxQBwWr7AXctSozMew==
Received: from DM6PR17CA0008.namprd17.prod.outlook.com (2603:10b6:5:1b3::21)
 by PH7PR12MB5688.namprd12.prod.outlook.com (2603:10b6:510:130::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 18:02:11 +0000
Received: from DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b3:cafe::51) by DM6PR17CA0008.outlook.office365.com
 (2603:10b6:5:1b3::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22 via Frontend
 Transport; Wed, 5 Apr 2023 18:02:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT049.mail.protection.outlook.com (10.13.172.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.28 via Frontend Transport; Wed, 5 Apr 2023 18:02:10 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 5 Apr 2023
 11:01:35 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Wed, 5 Apr 2023 11:01:35 -0700
Received: from localhost.localdomain (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37 via Frontend
 Transport; Wed, 5 Apr 2023 11:01:35 -0700
From:   <ankita@nvidia.com>
To:     <ankita@nvidia.com>, <jgg@nvidia.com>,
        <alex.williamson@redhat.com>, <naoya.horiguchi@nec.com>,
        <maz@kernel.org>, <oliver.upton@linux.dev>
CC:     <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
        <targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
        <apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>
Subject: [PATCH v3 3/6] mm: handle poisoning of pfn without struct pages
Date:   Wed, 5 Apr 2023 11:01:31 -0700
Message-ID: <20230405180134.16932-4-ankita@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230405180134.16932-1-ankita@nvidia.com>
References: <20230405180134.16932-1-ankita@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT049:EE_|PH7PR12MB5688:EE_
X-MS-Office365-Filtering-Correlation-Id: 76f0e9a7-ff18-4cd7-a82a-08db35ffe0e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2zM+XAVqxDJZqQdem4U+vrXQLcPxhbPFnGHor3CvunsvcXg9T8g7oM84thFiaxZN/8r85ENobh/hvuEpz07SVSmapIT+LNzIsmpGjbWaK7xbouJP0R778ciEGxJEnXdrCs+U8Nhi10PTH1f3TTnLr3B31eP3juvoo1JbZz4pieIZNi5bucYHzuEAi6MibHYYzDw4zXrn5UhkF7IAs2dptARo5ptWEMvQmcomWTK4K2OY5+s9EbZULehgMsae8RbeeaDp6HFZPflslb8HjPy8uAjFosZ5hBJ+yNmpEfR8gJ25zl7JAGIJF/PwJHirksIMFqsC6sIyyyBCqnTH8oLpUELlT1YElViqfxWuY3rY2MgNCZdD1OoIwg1krROVO/sJp46CbAwqjCGJHSjvBth7R1h/McHN8Rgfn51wVtI6rlDM6CP+CPYAGtcmvbvGKeR0m4/McW3rcUqMC0G4gyaWK9ZtG3wRCBBlORZSx6QPrkKcAHqeXoyNuttbtaQZPCW8X5Txfuh2jjiTOHhO7HiexbVKC2AZ37Oij/pH06YVrOBoJE9h5pM/JtKXW2ipW+ShvEb6Pa8c2m110j8keBofXWDxHQd81D3XbVRuHl76V1iefy4EitjiApl8UmXJR3JdNPQM99XMyZQ3hRa41E3k3VYLlZz5gBOjfOqHwDZoOEyK1h1pVe/aC6/a+/xL6uTpAjZx3UqjzpsHEsV7/E8Dhx/ZMAeGy1SGD04Crf8KogvCbh7ixEmuFV0EZeaZs1tr
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(396003)(346002)(376002)(451199021)(46966006)(40470700004)(36840700001)(6666004)(83380400001)(40480700001)(336012)(36860700001)(47076005)(2616005)(82310400005)(86362001)(82740400003)(426003)(356005)(36756003)(7636003)(40460700003)(1076003)(26005)(186003)(8936002)(70206006)(70586007)(54906003)(2906002)(4326008)(8676002)(41300700001)(316002)(110136005)(5660300002)(2876002)(30864003)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 18:02:10.7887
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 76f0e9a7-ff18-4cd7-a82a-08db35ffe0e5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5688
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ankit Agrawal <ankita@nvidia.com>

The kernel MM does not currently handle ECC errors / poison on a memory
region that is not backed by struct pages. In this series, mapping request
from QEMU to the device memory is executed using remap_pfn_range().
Hence added a new mechanism to handle memory failure on such memory.

Make kernel MM expose a function to allow modules managing the device
memory to register a failure function and the address space that is
associated with the device memory. MM maintains this information as
interval tree. The registered memory failure function is used by MM to
notify the module of the PFN, so that the module may take any required
action. The module for example may use the information to track the
poisoned pages.

In this implementation, kernel MM follows the following sequence (mostly)
similar to the memory_failure() handler for struct page backed memory:
1. memory_failure() is triggered on reception of a poison error. An
absence of struct page is detected and consequently memory_failure_pfn
is executed.
2. memory_failure_pfn() call the newly introduced failure handler exposed
by the module managing the poisoned memory to notify it of the problematic
PFN.
3. memory_failure_pfn() unmaps the stage-2 mapping to the PFN.
4. memory_failure_pfn() collects the processes mapped to the PFN.
5. memory_failure_pfn() sends SIGBUS (BUS_MCEERR_AO) to all the processes
mapping the faulty PFN using kill_procs().
6. An access to the faulty PFN by an operation in VM at a later point of
time is trapped and user_mem_abort() is called.
7. user_mem_abort() calls __gfn_to_pfn_memslot() on the PFN, and the
following execution path is followed: __gfn_to_pfn_memslot() ->
hva_to_pfn() -> hva_to_pfn_remapped() -> fixup_user_fault() ->
handle_mm_fault() -> handle_pte_fault() -> do_fault(). do_fault() is
expected to return VM_FAULT_HWPOISON on the PFN (it currently does not
and is fixed as part of another patch in the series).
8. __gfn_to_pfn_memslot() then returns KVM_PFN_ERR_HWPOISON, which cause
the poison with SIGBUS (BUS_MCEERR_AR) to be sent to the QEMU process
through kvm_send_hwpoison_signal().

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 include/linux/memory-failure.h |  22 +++++
 include/linux/mm.h             |   1 +
 include/ras/ras_event.h        |   1 +
 mm/memory-failure.c            | 148 +++++++++++++++++++++++++++++----
 4 files changed, 154 insertions(+), 18 deletions(-)
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
index 1f79667824eb..e3ef52d3d45a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3530,6 +3530,7 @@ enum mf_action_page_type {
 	MF_MSG_BUDDY,
 	MF_MSG_DAX,
 	MF_MSG_UNSPLIT_THP,
+	MF_MSG_PFN,
 	MF_MSG_UNKNOWN,
 };
 
diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
index cbd3ddd7c33d..5c62a4d17172 100644
--- a/include/ras/ras_event.h
+++ b/include/ras/ras_event.h
@@ -373,6 +373,7 @@ TRACE_EVENT(aer_event,
 	EM ( MF_MSG_BUDDY, "free buddy page" )				\
 	EM ( MF_MSG_DAX, "dax page" )					\
 	EM ( MF_MSG_UNSPLIT_THP, "unsplit thp" )			\
+	EM ( MF_MSG_PFN, "non struct page pfn" )					\
 	EMe ( MF_MSG_UNKNOWN, "unknown page" )
 
 /*
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index fae9baf3be16..2c1a2ec42f7b 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -38,6 +38,7 @@
 
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/memory-failure.h>
 #include <linux/page-flags.h>
 #include <linux/kernel-page-flags.h>
 #include <linux/sched/signal.h>
@@ -62,6 +63,7 @@
 #include <linux/page-isolation.h>
 #include <linux/pagewalk.h>
 #include <linux/shmem_fs.h>
+#include <linux/pfn_t.h>
 #include "swap.h"
 #include "internal.h"
 #include "ras/ras_event.h"
@@ -122,6 +124,10 @@ const struct attribute_group memory_failure_attr_group = {
 	.attrs = memory_failure_attr,
 };
 
+static struct rb_root_cached pfn_space_itree = RB_ROOT_CACHED;
+
+static DEFINE_MUTEX(pfn_space_lock);
+
 /*
  * Return values:
  *   1:   the page is dissolved (if needed) and taken off from buddy,
@@ -399,15 +405,14 @@ static unsigned long dev_pagemap_mapping_shift(struct vm_area_struct *vma,
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
-static void add_to_kill(struct task_struct *tsk, struct page *p,
-			pgoff_t fsdax_pgoff, struct vm_area_struct *vma,
-			struct list_head *to_kill)
+static void add_to_kill(struct task_struct *tsk, struct page *p, pgoff_t pgoff,
+			struct vm_area_struct *vma, struct list_head *to_kill)
 {
 	struct to_kill *tk;
 
@@ -417,13 +422,20 @@ static void add_to_kill(struct task_struct *tsk, struct page *p,
 		return;
 	}
 
-	tk->addr = page_address_in_vma(p, vma);
-	if (is_zone_device_page(p)) {
-		if (fsdax_pgoff != FSDAX_INVALID_PGOFF)
-			tk->addr = vma_pgoff_address(fsdax_pgoff, 1, vma);
+	if (vma->vm_flags | PFN_MAP) {
+		tk->addr =
+			vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
+		tk->size_shift = PAGE_SHIFT;
+	} else if (is_zone_device_page(p)) {
+		if (pgoff != FSDAX_INVALID_PGOFF)
+			tk->addr = vma_pgoff_address(pgoff, 1, vma);
+		else
+			tk->addr = page_address_in_vma(p, vma);
 		tk->size_shift = dev_pagemap_mapping_shift(vma, tk->addr);
-	} else
+	} else {
+		tk->addr = page_address_in_vma(p, vma);
 		tk->size_shift = page_shift(compound_head(p));
+	}
 
 	/*
 	 * Send SIGKILL if "tk->addr == -EFAULT". Also, as
@@ -617,13 +629,12 @@ static void collect_procs_file(struct page *page, struct list_head *to_kill,
 	i_mmap_unlock_read(mapping);
 }
 
-#ifdef CONFIG_FS_DAX
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
@@ -643,7 +654,6 @@ static void collect_procs_fsdax(struct page *page,
 	read_unlock(&tasklist_lock);
 	i_mmap_unlock_read(mapping);
 }
-#endif /* CONFIG_FS_DAX */
 
 /*
  * Collect the processes who have the corrupted page mapped to kill.
@@ -835,6 +845,7 @@ static const char * const action_page_types[] = {
 	[MF_MSG_BUDDY]			= "free buddy page",
 	[MF_MSG_DAX]			= "dax page",
 	[MF_MSG_UNSPLIT_THP]		= "unsplit thp",
+	[MF_MSG_PFN]			= "non struct page pfn",
 	[MF_MSG_UNKNOWN]		= "unknown page",
 };
 
@@ -1745,7 +1756,7 @@ int mf_dax_kill_procs(struct address_space *mapping, pgoff_t index,
 
 		SetPageHWPoison(page);
 
-		collect_procs_fsdax(page, mapping, index, &to_kill);
+		collect_procs_pgoff(page, mapping, index, &to_kill);
 		unmap_and_kill(&to_kill, page_to_pfn(page), mapping,
 				index, mf_flags);
 unlock:
@@ -2052,6 +2063,99 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
 	return rc;
 }
 
+/**
+ * register_pfn_address_space - Register PA region for poison notification.
+ * @pfn_space: structure containing region range and callback function on
+ *             poison detection.
+ *
+ * This function is called by a kernel module to register a PA region and
+ * a callback function with the kernel. On detection of poison, the
+ * kernel code will go through all registered regions and call the
+ * appropriate callback function associated with the range. The kernel
+ * module is responsible for tracking the poisoned pages.
+ *
+ * Return: 0 if successfully registered,
+ *         -EBUSY if the region is already registered
+ */
+int register_pfn_address_space(struct pfn_address_space *pfn_space)
+{
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
+/**
+ * unregister_pfn_address_space - Unregister a PA region from poison
+ * notification.
+ * @pfn_space: structure containing region range to be unregistered.
+ *
+ * This function is called by a kernel module to unregister the PA region
+ * from the kernel from poison tracking.
+ */
+void unregister_pfn_address_space(struct pfn_address_space *pfn_space)
+{
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
+	int rc = -EBUSY;
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
+		rc = 0;
+
+		/*
+		 * Modules managing the device memory needs to be conveyed about the
+		 * memory failure so that the poisoned PFN can be tracked.
+		 */
+		pfn_space->ops->failure(pfn_space, pfn);
+
+		collect_procs_pgoff(NULL, pfn_space->mapping, pfn, &tokill);
+
+		unmap_mapping_range(pfn_space->mapping, pfn << PAGE_SHIFT,
+				    PAGE_SIZE, 0);
+	}
+	mutex_unlock(&pfn_space_lock);
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
+	pr_err("%#lx: recovery action for %s: %s\n",
+			pfn, action_page_types[MF_MSG_PFN],
+			action_name[rc ? MF_FAILED : MF_RECOVERED]);
+
+	return rc;
+}
+
 static DEFINE_MUTEX(mf_mutex);
 
 /**
@@ -2093,6 +2197,11 @@ int memory_failure(unsigned long pfn, int flags)
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
@@ -2106,6 +2215,9 @@ int memory_failure(unsigned long pfn, int flags)
 								 pgmap);
 				goto unlock_mutex;
 			}
+
+			res = memory_failure_pfn(pfn, flags);
+			goto unlock_mutex;
 		}
 		pr_err("%#lx: memory outside kernel control\n", pfn);
 		res = -ENXIO;
-- 
2.17.1

