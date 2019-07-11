Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0AAA658F4
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 16:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728830AbfGKO1y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 10:27:54 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39580 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728809AbfGKO1x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 10:27:53 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6BEO7gP100410;
        Thu, 11 Jul 2019 14:26:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=tktXu8oSlvrRNi4oCpkMHKHtnQ30RjQ+vGHk9xchmuI=;
 b=Xw8imofO8fKNfBvyII53RRKIWPHJ/UdjgH1ZSaBocnV0EADrjb1GTZYN4HsE7xrVPRc/
 TEHR2f4ozNEvHmT4xkzmrRWShe8NJkdGTGU5UyvTwwVLuobGplkQYt22venKGQfjZsCi
 BuPNZ1Zy1I5Lm3q4cyPwf0rvVmiPcVoh9A/tJ1V5PFUsSDajeMDtZazluCVycnUMAv6u
 /YyGN39NkO9rtwovlVRiIRORlVYEoHIigSvvQZaOjXC7B6+jVAU9bBj+zUDnf/Rei8Mf
 yGpCGEFGnOwzX/ATnI3MWljtUlcXz+wMpxZcI3AhvYUC5PX/005SgrPaW6hQhMYqVhz6 ew== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2tjkkq0cat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 14:26:39 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x6BEPcu8021444;
        Thu, 11 Jul 2019 14:26:31 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, alexandre.chartre@oracle.com
Subject: [RFC v2 15/26] mm/asi: Initialize the ASI page-table with core mappings
Date:   Thu, 11 Jul 2019 16:25:27 +0200
Message-Id: <1562855138-19507-16-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9314 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907110162
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Core mappings are the minimal mappings we need to be able to
enter isolation and handle an isolation abort or exit. This
includes the kernel code, the GDT and the percpu ASI sessions.
We also need a stack so we map the current stack when entering
isolation and unmap it on exit/abort.

Optionally, additional mappins can be added like the stack canary
or the percpu offset to be able to use get_cpu_var()/this_cpu_ptr()
when isolation is active.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/include/asm/asi.h  |    9 ++++-
 arch/x86/mm/asi.c           |   75 +++++++++++++++++++++++++++++++++++++++---
 arch/x86/mm/asi_pagetable.c |   30 ++++++++++++----
 3 files changed, 99 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index cf5d198..1ac8fd3 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -11,6 +11,13 @@
 #include <asm/pgtable.h>
 #include <linux/xarray.h>
 
+/*
+ * asi_create() map flags. Flags are used to map optional data
+ * when creating an ASI.
+ */
+#define ASI_MAP_STACK_CANARY	0x01	/* map stack canary */
+#define ASI_MAP_CPU_PTR		0x02	/* for get_cpu_var()/this_cpu_ptr() */
+
 enum page_table_level {
 	PGT_LEVEL_PTE,
 	PGT_LEVEL_PMD,
@@ -73,7 +80,7 @@ struct asi_session {
 void asi_init_range_mapping(struct asi *asi);
 void asi_fini_range_mapping(struct asi *asi);
 
-extern struct asi *asi_create(void);
+extern struct asi *asi_create(int map_flags);
 extern void asi_destroy(struct asi *asi);
 extern int asi_enter(struct asi *asi);
 extern void asi_exit(struct asi *asi);
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index 25633a6..f049438 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -19,6 +19,17 @@
 /* ASI sessions, one per cpu */
 DEFINE_PER_CPU_PAGE_ALIGNED(struct asi_session, cpu_asi_session);
 
+struct asi_map_option {
+	int	flag;
+	void	*ptr;
+	size_t	size;
+};
+
+struct asi_map_option asi_map_percpu_options[] = {
+	{ ASI_MAP_STACK_CANARY, &fixed_percpu_data, sizeof(fixed_percpu_data) },
+	{ ASI_MAP_CPU_PTR, &this_cpu_off, sizeof(this_cpu_off) },
+};
+
 static void asi_log_fault(struct asi *asi, struct pt_regs *regs,
 			  unsigned long error_code, unsigned long address)
 {
@@ -85,16 +96,55 @@ bool asi_fault(struct pt_regs *regs, unsigned long error_code,
 	return true;
 }
 
-static int asi_init_mapping(struct asi *asi)
+static int asi_init_mapping(struct asi *asi, int flags)
 {
+	struct asi_map_option *option;
+	int i, err;
+
+	/*
+	 * Map the kernel.
+	 *
+	 * XXX We should check if we can map only kernel text, i.e. map with
+	 * size = _etext - _text
+	 */
+	err = asi_map(asi, (void *)__START_KERNEL_map, KERNEL_IMAGE_SIZE);
+	if (err)
+		return err;
+
 	/*
-	 * TODO: Populate the ASI page-table with minimal mappings so
-	 * that we can at least enter isolation and abort.
+	 * Map the cpu_entry_area because we need the GDT to be mapped.
+	 * Not sure we need anything else from cpu_entry_area.
 	 */
+	err = asi_map_range(asi, (void *)CPU_ENTRY_AREA_PER_CPU, P4D_SIZE,
+			    PGT_LEVEL_P4D);
+	if (err)
+		return err;
+
+	/*
+	 * Map the percpu ASI sessions. This is used by interrupt handlers
+	 * to figure out if we have entered isolation and switch back to
+	 * the kernel address space.
+	 */
+	err = ASI_MAP_CPUVAR(asi, cpu_asi_session);
+	if (err)
+		return err;
+
+	/*
+	 * Optional percpu mappings.
+	 */
+	for (i = 0; i < ARRAY_SIZE(asi_map_percpu_options); i++) {
+		option = &asi_map_percpu_options[i];
+		if (flags & option->flag) {
+			err = asi_map_percpu(asi, option->ptr, option->size);
+			if (err)
+				return err;
+		}
+	}
+
 	return 0;
 }
 
-struct asi *asi_create(void)
+struct asi *asi_create(int map_flags)
 {
 	struct page *page;
 	struct asi *asi;
@@ -115,7 +165,7 @@ struct asi *asi_create(void)
 	spin_lock_init(&asi->fault_lock);
 	asi_init_backend(asi);
 
-	err = asi_init_mapping(asi);
+	err = asi_init_mapping(asi, map_flags);
 	if (err)
 		goto error;
 
@@ -159,6 +209,7 @@ int asi_enter(struct asi *asi)
 	struct asi *current_asi;
 	struct asi_session *asi_session;
 	unsigned long original_cr3;
+	int err;
 
 	state = this_cpu_read(cpu_asi_session.state);
 	/*
@@ -190,6 +241,13 @@ int asi_enter(struct asi *asi)
 	WARN_ON(asi_session->abort_depth > 0);
 
 	/*
+	 * We need a stack to run with isolation, so map the current stack.
+	 */
+	err = asi_map(asi, current->stack, PAGE_SIZE << THREAD_SIZE_ORDER);
+	if (err)
+		goto err_clear_asi;
+
+	/*
 	 * Instructions ordering is important here because we should be
 	 * able to deal with any interrupt/exception which will abort
 	 * the isolation and restore CR3 to its original value:
@@ -211,7 +269,7 @@ int asi_enter(struct asi *asi)
 	if (!original_cr3) {
 		WARN_ON(1);
 		err = -EINVAL;
-		goto err_clear_asi;
+		goto err_unmap_stack;
 	}
 	asi_session->original_cr3 = original_cr3;
 
@@ -228,6 +286,8 @@ int asi_enter(struct asi *asi)
 
 	return 0;
 
+err_unmap_stack:
+	asi_unmap(asi, current->stack);
 err_clear_asi:
 	asi_session->asi = NULL;
 	asi_session->task = NULL;
@@ -284,6 +344,9 @@ void asi_exit(struct asi *asi)
 	 * exit isolation before abort_depth reaches 0.
 	 */
 	asi_session->abort_depth = 0;
+
+	/* unmap stack */
+	asi_unmap(asi, current->stack);
 }
 EXPORT_SYMBOL(asi_exit);
 
diff --git a/arch/x86/mm/asi_pagetable.c b/arch/x86/mm/asi_pagetable.c
index f1ee65b..bcc95f2 100644
--- a/arch/x86/mm/asi_pagetable.c
+++ b/arch/x86/mm/asi_pagetable.c
@@ -710,12 +710,20 @@ int asi_map_range(struct asi *asi, void *ptr, size_t size,
 	map_addr = round_down(addr, page_dir_size);
 	map_end = round_up(end, page_dir_size);
 
-	pr_debug("ASI %p: MAP %px/%lx/%d -> %lx-%lx\n", asi, ptr, size, level,
-		 map_addr, map_end);
-	if (map_addr < addr)
-		pr_debug("ASI %p: MAP LEAK %lx-%lx\n", asi, map_addr, addr);
-	if (map_end > end)
-		pr_debug("ASI %p: MAP LEAK %lx-%lx\n", asi, end, map_end);
+	/*
+	 * Don't log info the current stack because it is mapped/unmapped
+	 * everytime we enter/exit isolation.
+	 */
+	if (ptr != current->stack) {
+		pr_debug("ASI %p: MAP %px/%lx/%d -> %lx-%lx\n",
+			 asi, ptr, size, level, map_addr, map_end);
+		if (map_addr < addr)
+			pr_debug("ASI %p: MAP LEAK %lx-%lx\n",
+				 asi, map_addr, addr);
+		if (map_end > end)
+			pr_debug("ASI %p: MAP LEAK %lx-%lx\n",
+				 asi, end, map_end);
+	}
 
 	spin_lock_irqsave(&asi->lock, flags);
 
@@ -989,8 +997,14 @@ void asi_unmap(struct asi *asi, void *ptr)
 
 	addr = (unsigned long)range_mapping->ptr;
 	end = addr + range_mapping->size;
-	pr_debug("ASI %p: UNMAP %px/%lx/%d\n", asi, ptr,
-		 range_mapping->size, range_mapping->level);
+	/*
+	 * Don't log info the current stack because it is mapped/unmapped
+	 * everytime we enter/exit isolation.
+	 */
+	if (ptr != current->stack) {
+		pr_debug("ASI %p: UNMAP %px/%lx/%d\n", asi, ptr,
+			 range_mapping->size, range_mapping->level);
+	}
 	list_del(&range_mapping->list);
 	asi_unmap_overlap(asi, range_mapping);
 	kfree(range_mapping);
-- 
1.7.1

