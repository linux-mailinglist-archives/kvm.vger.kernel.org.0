Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E75F11B89F
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 16:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730669AbfEMOkz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 10:40:55 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:38294 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729639AbfEMOky (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 10:40:54 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DEd2hT193056;
        Mon, 13 May 2019 14:39:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=lqyn+UMxH2H0mFstbeYlyK/O28QxJu29o92QL7NqRo0=;
 b=Jr5TCZD/u/xNJPZvrSFuZJzX/+fkjXUeKcGKj+LAFsPLKhL5qgqU35GRnUUc8xQu8pLv
 kJ2cgm2Uaj8fWZEV+R26AC0h34/IHr0xch9O9VC8DBfJZs45MDHArPHOrKH2BZgkZn0g
 Vo1Qsw+WtWbru1nSWeUWRDzk0S8BMwbmJOSxY9hDJpCKuZ4Rjcl9KR+8ZAUPwwUnSucl
 F6NkZr7jZnrzkGGfd72bek1kv1u5Rb/uWnD+/v6jia+yUhHtbKzvABFRbX3KACRbuEhG
 GYu3aCArrPJv0oQqS9LptBfUuYpEaXqIKNe+OKRLzFVYsoDNcshbQCQH2UMO7meQY53G qQ== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2sdkwdfkvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 14:39:08 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x4DEcZQC022780;
        Mon, 13 May 2019 14:39:05 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com,
        alexandre.chartre@oracle.com
Subject: [RFC KVM 09/27] kvm/isolation: function to track buffers allocated for the KVM page table
Date:   Mon, 13 May 2019 16:38:17 +0200
Message-Id: <1557758315-12667-10-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9255 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905130103
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM page table will have direct references to the kernel page table,
at different levels (PGD, P4D, PUD, PMD). When freeing the KVM page table,
we should make sure that we free parts actually allocated for the KVM
page table, and not parts of the kernel page table referenced from the
KVM page table. To do so, we will keep track of buffers when building
the KVM page table.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/kvm/isolation.c |  119 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 119 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/isolation.c b/arch/x86/kvm/isolation.c
index 43fd924..1efdab1 100644
--- a/arch/x86/kvm/isolation.c
+++ b/arch/x86/kvm/isolation.c
@@ -8,12 +8,60 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/printk.h>
+#include <linux/slab.h>
 
 #include <asm/mmu_context.h>
 #include <asm/pgalloc.h>
 
 #include "isolation.h"
 
+
+enum page_table_level {
+	PGT_LEVEL_PTE,
+	PGT_LEVEL_PMD,
+	PGT_LEVEL_PUD,
+	PGT_LEVEL_P4D,
+	PGT_LEVEL_PGD
+};
+
+/*
+ * The KVM page table can have direct references to the kernel page table,
+ * at different levels (PGD, P4D, PUD, PMD). When freeing the KVM page
+ * table, we should make sure that we free parts actually allocated for
+ * the KVM page table, and not parts of the kernel page table referenced
+ * from the KVM page table.
+ *
+ * To do so, page table directories (struct pgt_directory) are used to keep
+ * track of buffers allocated when building the KVM page table. Also, as
+ * a page table can have many buffers, page table directory groups (struct
+ * (pgt_directory_group) are used to group page table directories and save
+ * some space (instead of allocating each directory individually).
+ */
+
+#define PGT_DIRECTORY_GROUP_SIZE	64
+
+struct pgt_directory {
+	enum page_table_level level;
+	void *ptr;
+};
+
+struct pgt_directory_group {
+	struct list_head list;
+	int count;
+	struct pgt_directory directory[PGT_DIRECTORY_GROUP_SIZE];
+};
+
+static LIST_HEAD(kvm_pgt_dgroup_list);
+static DEFINE_MUTEX(kvm_pgt_dgroup_lock);
+
+/*
+ * Get the pointer to the beginning of a page table directory from a page
+ * table directory entry.
+ */
+#define PGTD_ALIGN(entry)	\
+	((typeof(entry))(((unsigned long)(entry)) & PAGE_MASK))
+
+
 struct mm_struct kvm_mm = {
 	.mm_rb			= RB_ROOT,
 	.mm_users		= ATOMIC_INIT(2),
@@ -43,6 +91,77 @@ struct mm_struct kvm_mm = {
 static bool __read_mostly address_space_isolation;
 module_param(address_space_isolation, bool, 0444);
 
+
+static struct pgt_directory_group *pgt_directory_group_create(void)
+{
+	struct pgt_directory_group *dgroup;
+
+	dgroup = kzalloc(sizeof(struct pgt_directory_group), GFP_KERNEL);
+	if (!dgroup)
+		return NULL;
+
+	INIT_LIST_HEAD(&dgroup->list);
+	dgroup->count = 0;
+
+	return dgroup;
+}
+
+static bool kvm_add_pgt_directory(void *ptr, enum page_table_level level)
+{
+	struct pgt_directory_group *dgroup;
+	int index;
+
+	mutex_lock(&kvm_pgt_dgroup_lock);
+
+	if (list_empty(&kvm_pgt_dgroup_list))
+		dgroup = NULL;
+	else
+		dgroup = list_entry(kvm_pgt_dgroup_list.next,
+				    struct pgt_directory_group, list);
+
+	if (!dgroup || dgroup->count >= PGT_DIRECTORY_GROUP_SIZE) {
+		dgroup = pgt_directory_group_create();
+		if (!dgroup) {
+			mutex_unlock(&kvm_pgt_dgroup_lock);
+			return false;
+		}
+		list_add_tail(&dgroup->list, &kvm_pgt_dgroup_list);
+	}
+
+	index = dgroup->count;
+	dgroup->directory[index].level = level;
+	dgroup->directory[index].ptr = PGTD_ALIGN(ptr);
+	dgroup->count = index + 1;
+
+	mutex_unlock(&kvm_pgt_dgroup_lock);
+
+	return true;
+}
+
+static bool kvm_valid_pgt_entry(void *ptr)
+{
+	struct pgt_directory_group *dgroup;
+	int i;
+
+	mutex_lock(&kvm_pgt_dgroup_lock);
+
+	ptr = PGTD_ALIGN(ptr);
+	list_for_each_entry(dgroup, &kvm_pgt_dgroup_list, list) {
+		for (i = 0; i < dgroup->count; i++) {
+			if (dgroup->directory[i].ptr == ptr) {
+				mutex_unlock(&kvm_pgt_dgroup_lock);
+				return true;
+			}
+		}
+	}
+
+	mutex_unlock(&kvm_pgt_dgroup_lock);
+
+	return false;
+
+}
+
+
 static int kvm_isolation_init_mm(void)
 {
 	pgd_t *kvm_pgd;
-- 
1.7.1

