Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B67E6658EA
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 16:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbfGKO2Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 10:28:24 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37832 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728926AbfGKO2T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 10:28:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6BEO90p001480;
        Thu, 11 Jul 2019 14:26:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=k/9Fug63afNC647KTGwGwhcj7r27BkaO1PdUgfdBHl8=;
 b=5KLn6vAlS8mqB4CpSvgIU+Q+dh/FIPZ30597ShKunxhzPyWufNzv9Z2Cx08UVoBiEll/
 JBVMx/vKSYB0C0s+WVyLcIBN58ZXRTbwEhf/IwNYl7zZ7sSsGPjmF/6hyaDRwuF9hk/r
 Od3KI8aMoJde526KmMFcX2swAUblIJ6IEJr7eaGDmgCNG3lLZyVRqS3W4XYV29OC/ZVc
 4mk68QurguhhWeX8FUCmmK47mMaaLROKzVLzTFajITGGIClxoo3c+fKTYG1lt2Dpitky
 k9uYwYmfAA4lryCWr9Zg3nU9L0blXjaO/G+ZtIQSyB+mD3low+GPiTf4kzuLZVh/PRPA cg== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2tjk2u0e0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 14:26:38 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x6BEPcu9021444;
        Thu, 11 Jul 2019 14:26:34 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, alexandre.chartre@oracle.com
Subject: [RFC v2 16/26] mm/asi: Option to map current task into ASI
Date:   Thu, 11 Jul 2019 16:25:28 +0200
Message-Id: <1562855138-19507-17-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9314 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=853
 adultscore=26 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907110162
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an option to map the current task into an ASI page-table.
The task is mapped when entering isolation and unmapped on
abort/exit.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/include/asm/asi.h  |    2 ++
 arch/x86/mm/asi.c           |   25 +++++++++++++++++++++----
 arch/x86/mm/asi_pagetable.c |    4 ++--
 3 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index 1ac8fd3..a277e43 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -17,6 +17,7 @@
  */
 #define ASI_MAP_STACK_CANARY	0x01	/* map stack canary */
 #define ASI_MAP_CPU_PTR		0x02	/* for get_cpu_var()/this_cpu_ptr() */
+#define ASI_MAP_CURRENT_TASK	0x04	/* map the current task */
 
 enum page_table_level {
 	PGT_LEVEL_PTE,
@@ -31,6 +32,7 @@ enum page_table_level {
 struct asi {
 	spinlock_t		lock;		/* protect all attributes */
 	pgd_t			*pgd;		/* ASI page-table */
+	int			mapping_flags;	/* map flags */
 	struct list_head	mapping_list;	/* list of VA range mapping */
 
 	/*
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index f049438..acd1135 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -28,6 +28,7 @@ struct asi_map_option {
 struct asi_map_option asi_map_percpu_options[] = {
 	{ ASI_MAP_STACK_CANARY, &fixed_percpu_data, sizeof(fixed_percpu_data) },
 	{ ASI_MAP_CPU_PTR, &this_cpu_off, sizeof(this_cpu_off) },
+	{ ASI_MAP_CURRENT_TASK, &current_task, sizeof(current_task) },
 };
 
 static void asi_log_fault(struct asi *asi, struct pt_regs *regs,
@@ -96,8 +97,9 @@ bool asi_fault(struct pt_regs *regs, unsigned long error_code,
 	return true;
 }
 
-static int asi_init_mapping(struct asi *asi, int flags)
+static int asi_init_mapping(struct asi *asi)
 {
+	int flags = asi->mapping_flags;
 	struct asi_map_option *option;
 	int i, err;
 
@@ -164,8 +166,9 @@ struct asi *asi_create(int map_flags)
 	spin_lock_init(&asi->lock);
 	spin_lock_init(&asi->fault_lock);
 	asi_init_backend(asi);
+	asi->mapping_flags = map_flags;
 
-	err = asi_init_mapping(asi, map_flags);
+	err = asi_init_mapping(asi);
 	if (err)
 		goto error;
 
@@ -248,6 +251,15 @@ int asi_enter(struct asi *asi)
 		goto err_clear_asi;
 
 	/*
+	 * Optionally, also map the current task.
+	 */
+	if (asi->mapping_flags & ASI_MAP_CURRENT_TASK) {
+		err = asi_map(asi, current, sizeof(struct task_struct));
+		if (err)
+			goto err_unmap_stack;
+	}
+
+	/*
 	 * Instructions ordering is important here because we should be
 	 * able to deal with any interrupt/exception which will abort
 	 * the isolation and restore CR3 to its original value:
@@ -269,7 +281,7 @@ int asi_enter(struct asi *asi)
 	if (!original_cr3) {
 		WARN_ON(1);
 		err = -EINVAL;
-		goto err_unmap_stack;
+		goto err_unmap_task;
 	}
 	asi_session->original_cr3 = original_cr3;
 
@@ -286,6 +298,9 @@ int asi_enter(struct asi *asi)
 
 	return 0;
 
+err_unmap_task:
+	if (asi->mapping_flags & ASI_MAP_CURRENT_TASK)
+		asi_unmap(asi, current);
 err_unmap_stack:
 	asi_unmap(asi, current->stack);
 err_clear_asi:
@@ -345,8 +360,10 @@ void asi_exit(struct asi *asi)
 	 */
 	asi_session->abort_depth = 0;
 
-	/* unmap stack */
+	/* unmap stack and task */
 	asi_unmap(asi, current->stack);
+	if (asi->mapping_flags & ASI_MAP_CURRENT_TASK)
+		asi_unmap(asi, current);
 }
 EXPORT_SYMBOL(asi_exit);
 
diff --git a/arch/x86/mm/asi_pagetable.c b/arch/x86/mm/asi_pagetable.c
index bcc95f2..8076626 100644
--- a/arch/x86/mm/asi_pagetable.c
+++ b/arch/x86/mm/asi_pagetable.c
@@ -714,7 +714,7 @@ int asi_map_range(struct asi *asi, void *ptr, size_t size,
 	 * Don't log info the current stack because it is mapped/unmapped
 	 * everytime we enter/exit isolation.
 	 */
-	if (ptr != current->stack) {
+	if (ptr != current->stack && ptr != current) {
 		pr_debug("ASI %p: MAP %px/%lx/%d -> %lx-%lx\n",
 			 asi, ptr, size, level, map_addr, map_end);
 		if (map_addr < addr)
@@ -1001,7 +1001,7 @@ void asi_unmap(struct asi *asi, void *ptr)
 	 * Don't log info the current stack because it is mapped/unmapped
 	 * everytime we enter/exit isolation.
 	 */
-	if (ptr != current->stack) {
+	if (ptr != current->stack && ptr != current) {
 		pr_debug("ASI %p: UNMAP %px/%lx/%d\n", asi, ptr,
 			 range_mapping->size, range_mapping->level);
 	}
-- 
1.7.1

