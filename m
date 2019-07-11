Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51916658E7
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 16:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbfGKO2Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 10:28:16 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37756 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728926AbfGKO2P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 10:28:15 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6BEO8vO001464;
        Thu, 11 Jul 2019 14:26:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=2d2Yv2y5zLW9fLZ4ZOO2tadSx6yS9UU2pD1uUkqP2I4=;
 b=PEK1VY+3UVMeYt+RB002bYINLbdCxWtdVaXXuLcUErNmdDVQeXpj0b9OMDpmCIqqZa4Y
 9PvB0Lnb9b0uhxGmrMFXcR44+qa8LQlt1HNPX0Dv/WgAESNOrwyxaWcdUWdyw5aYvMo9
 6hMEg+A/C1vRmGh2CVcZaeUmibNGRM+Z0ynXpbec7GOZxoWF9wbcV+Bk5OzwKInmLI0/
 2E7YCwLLpvnIvEy49dwDdr51/iqNr/GOk+NSxBuovD4OQOPclLfLK8Qy+EAEEUquuZ8L
 HADMT7wC0JoiunyhO1kAnDjpVZAnFUxpCSF1OfqJMoGYFOwX+PMYYSzDX1GbCZ5/xKmc PQ== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2tjk2u0e24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 14:26:48 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x6BEPcuC021444;
        Thu, 11 Jul 2019 14:26:44 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, alexandre.chartre@oracle.com
Subject: [RFC v2 19/26] mm/asi: Add option to map RCU data
Date:   Thu, 11 Jul 2019 16:25:31 +0200
Message-Id: <1562855138-19507-20-git-send-email-alexandre.chartre@oracle.com>
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

Add an option to map RCU data when creating an ASI. This will map
the percpu rcu_data (which is not exported by the kernel), and
allow ASI to use RCU without faulting.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/include/asm/asi.h |    1 +
 arch/x86/mm/asi.c          |    4 ++++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index a277e43..8199618 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -18,6 +18,7 @@
 #define ASI_MAP_STACK_CANARY	0x01	/* map stack canary */
 #define ASI_MAP_CPU_PTR		0x02	/* for get_cpu_var()/this_cpu_ptr() */
 #define ASI_MAP_CURRENT_TASK	0x04	/* map the current task */
+#define ASI_MAP_RCU_DATA	0x08	/* map rcu data */
 
 enum page_table_level {
 	PGT_LEVEL_PTE,
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index acd1135..20c23dc 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -7,6 +7,7 @@
 
 #include <linux/export.h>
 #include <linux/gfp.h>
+#include <linux/irq_work.h>
 #include <linux/mm.h>
 #include <linux/printk.h>
 #include <linux/sched/debug.h>
@@ -16,6 +17,8 @@
 #include <asm/bug.h>
 #include <asm/mmu_context.h>
 
+#include "../../../kernel/rcu/tree.h"
+
 /* ASI sessions, one per cpu */
 DEFINE_PER_CPU_PAGE_ALIGNED(struct asi_session, cpu_asi_session);
 
@@ -29,6 +32,7 @@ struct asi_map_option asi_map_percpu_options[] = {
 	{ ASI_MAP_STACK_CANARY, &fixed_percpu_data, sizeof(fixed_percpu_data) },
 	{ ASI_MAP_CPU_PTR, &this_cpu_off, sizeof(this_cpu_off) },
 	{ ASI_MAP_CURRENT_TASK, &current_task, sizeof(current_task) },
+	{ ASI_MAP_RCU_DATA, &rcu_data, sizeof(rcu_data) },
 };
 
 static void asi_log_fault(struct asi *asi, struct pt_regs *regs,
-- 
1.7.1

