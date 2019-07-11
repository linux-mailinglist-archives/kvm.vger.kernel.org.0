Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68E4D658F2
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 16:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbfGKO2N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 10:28:13 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42496 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728826AbfGKO2L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 10:28:11 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6BEOMdI013631;
        Thu, 11 Jul 2019 14:26:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=9FGKxWOaR9lg8qKZvVxZYyBDHDZO4/U+GnNunz7EXSk=;
 b=lniqBkC9yuqD/Ju9/6Xyu42PxGGU6Yt/2fjCL1pA8uTadjROIw7CBcc8faiSFRo7Bv3q
 BPubFEelFsfRjyPHH37WhqoIXQX5UbWj/nD4TDzwZBHQoeubLcnl1AB5vQ/mCucdF+Yu
 6nQIlGjLClEFr6VXl3jVjtuCT9T1LE8cucXjWWInMM2yXZ80VjgZXh9Wagaq6vop/Niu
 wJjXwR5Jbi7oMNqUbY65Is6pPs++Vxlbu62PVImCdj3jQ/wjgIZg0r9DuCe22wMVOgbF
 ph3T8g1h5qYYjiZctfTIEHMk2DM78dBxXxMV6ZGQQw9l9nE44jpFZXce/yhCQnDc6q9c 6g== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2tjm9r0bsr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 14:26:51 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x6BEPcuD021444;
        Thu, 11 Jul 2019 14:26:47 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, alexandre.chartre@oracle.com
Subject: [RFC v2 20/26] mm/asi: Add option to map cpu_hw_events
Date:   Thu, 11 Jul 2019 16:25:32 +0200
Message-Id: <1562855138-19507-21-git-send-email-alexandre.chartre@oracle.com>
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

Add option to map cpu_hw_events in ASI pagetable. Also restructure
to select ptions for percpu optional mapping.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/include/asm/asi.h |    1 +
 arch/x86/mm/asi.c          |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index 8199618..f489551 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -19,6 +19,7 @@
 #define ASI_MAP_CPU_PTR		0x02	/* for get_cpu_var()/this_cpu_ptr() */
 #define ASI_MAP_CURRENT_TASK	0x04	/* map the current task */
 #define ASI_MAP_RCU_DATA	0x08	/* map rcu data */
+#define ASI_MAP_CPU_HW_EVENTS	0x10	/* map cpu hw events */
 
 enum page_table_level {
 	PGT_LEVEL_PTE,
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index 20c23dc..d488704 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -8,6 +8,7 @@
 #include <linux/export.h>
 #include <linux/gfp.h>
 #include <linux/irq_work.h>
+#include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/printk.h>
 #include <linux/sched/debug.h>
@@ -17,6 +18,7 @@
 #include <asm/bug.h>
 #include <asm/mmu_context.h>
 
+#include "../events/perf_event.h"
 #include "../../../kernel/rcu/tree.h"
 
 /* ASI sessions, one per cpu */
@@ -33,6 +35,7 @@ struct asi_map_option asi_map_percpu_options[] = {
 	{ ASI_MAP_CPU_PTR, &this_cpu_off, sizeof(this_cpu_off) },
 	{ ASI_MAP_CURRENT_TASK, &current_task, sizeof(current_task) },
 	{ ASI_MAP_RCU_DATA, &rcu_data, sizeof(rcu_data) },
+	{ ASI_MAP_CPU_HW_EVENTS, &cpu_hw_events, sizeof(cpu_hw_events) },
 };
 
 static void asi_log_fault(struct asi *asi, struct pt_regs *regs,
-- 
1.7.1

