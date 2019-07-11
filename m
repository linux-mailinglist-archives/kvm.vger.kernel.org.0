Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6BD1658D9
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 16:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbfGKO2v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 10:28:51 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40570 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729087AbfGKO2s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 10:28:48 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6BEO7gN100410;
        Thu, 11 Jul 2019 14:26:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=d9A9L3caok6Qomoe3AKAL7r9AlPWZpUNUtRWqLcduag=;
 b=MARahqNw+qo/sURXfHbD3S/83gqCOgFJ/swtRFnPmTZXmwoCOVR/N/i1pIKlToYWY/Ri
 k2aBJrN9/v+khzouzf0G9zHxuoQwHwjL5cB4NqEmK6LZPn4Du9L8R3LvRixNs0Ek2k51
 TpfCDdoT/V5OQHZtXE2PjUdEaibVkBeu3OSq6a2iDA4XeaUx9Z+Ps6cN0b9Yifm/yA4j
 Iy9lSi7ma1G+usDIN0MJA79lNYFYSEqhzzbTW8owPRRK6v2c+xTImcLNpv1ndNvar4Yf
 gffkGfUVZ70Om45QblhdamFaGWrmGQZSauAg6M3MpWqBnQzN6fxwcMN6Aymg/BBEx4rs vQ== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2tjkkq0c8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Jul 2019 14:26:23 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x6BEPcu3021444;
        Thu, 11 Jul 2019 14:26:15 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, alexandre.chartre@oracle.com
Subject: [RFC v2 10/26] mm/asi: Keep track of VA ranges mapped in ASI page-table
Date:   Thu, 11 Jul 2019 16:25:22 +0200
Message-Id: <1562855138-19507-11-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9314 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=882 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907110162
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add functions to keep track of VA ranges mapped in an ASI page-table.
This will be used when unmapping to ensure the same range is unmapped,
at the same page-table level. This is also be used to handle mapping
and unmapping of overlapping VA ranges.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/include/asm/asi.h  |    3 ++
 arch/x86/mm/asi.c           |    3 ++
 arch/x86/mm/asi_pagetable.c |   71 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 77 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index b5dbc49..be1c190 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -24,6 +24,7 @@ enum page_table_level {
 struct asi {
 	spinlock_t		lock;		/* protect all attributes */
 	pgd_t			*pgd;		/* ASI page-table */
+	struct list_head	mapping_list;	/* list of VA range mapping */
 
 	/*
 	 * An ASI page-table can have direct references to the full kernel
@@ -69,6 +70,8 @@ struct asi_session {
 
 void asi_init_backend(struct asi *asi);
 void asi_fini_backend(struct asi *asi);
+void asi_init_range_mapping(struct asi *asi);
+void asi_fini_range_mapping(struct asi *asi);
 
 extern struct asi *asi_create(void);
 extern void asi_destroy(struct asi *asi);
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
index dfde245..25633a6 100644
--- a/arch/x86/mm/asi.c
+++ b/arch/x86/mm/asi.c
@@ -104,6 +104,8 @@ struct asi *asi_create(void)
 	if (!asi)
 		return NULL;
 
+	asi_init_range_mapping(asi);
+
 	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!page)
 		goto error;
@@ -133,6 +135,7 @@ void asi_destroy(struct asi *asi)
 	if (asi->pgd)
 		free_page((unsigned long)asi->pgd);
 
+	asi_fini_range_mapping(asi);
 	asi_fini_backend(asi);
 
 	kfree(asi);
diff --git a/arch/x86/mm/asi_pagetable.c b/arch/x86/mm/asi_pagetable.c
index 0169395..a09a22d 100644
--- a/arch/x86/mm/asi_pagetable.c
+++ b/arch/x86/mm/asi_pagetable.c
@@ -5,10 +5,21 @@
  */
 
 #include <linux/mm.h>
+#include <linux/slab.h>
 
 #include <asm/asi.h>
 
 /*
+ * Structure to keep track of address ranges mapped into an ASI.
+ */
+struct asi_range_mapping {
+	struct list_head list;
+	void *ptr;			/* range start address */
+	size_t size;			/* range size */
+	enum page_table_level level;	/* mapping level */
+};
+
+/*
  * Get the pointer to the beginning of a page table directory from a page
  * table directory entry.
  */
@@ -75,6 +86,39 @@ void asi_fini_backend(struct asi *asi)
 	}
 }
 
+void asi_init_range_mapping(struct asi *asi)
+{
+	INIT_LIST_HEAD(&asi->mapping_list);
+}
+
+void asi_fini_range_mapping(struct asi *asi)
+{
+	struct asi_range_mapping *range, *range_next;
+
+	list_for_each_entry_safe(range, range_next, &asi->mapping_list, list) {
+		list_del(&range->list);
+		kfree(range);
+	}
+}
+
+/*
+ * Return the range mapping starting at the specified address, or NULL if
+ * no such range is found.
+ */
+static struct asi_range_mapping *asi_get_range_mapping(struct asi *asi,
+						       void *ptr)
+{
+	struct asi_range_mapping *range;
+
+	lockdep_assert_held(&asi->lock);
+	list_for_each_entry(range, &asi->mapping_list, list) {
+		if (range->ptr == ptr)
+			return range;
+	}
+
+	return NULL;
+}
+
 /*
  * Check if an offset in the address space isolation page-table is valid,
  * i.e. check that the offset is on a page effectively belonging to the
@@ -574,6 +618,7 @@ static int asi_copy_pgd_range(struct asi *asi,
 int asi_map_range(struct asi *asi, void *ptr, size_t size,
 		  enum page_table_level level)
 {
+	struct asi_range_mapping *range_mapping;
 	unsigned long addr = (unsigned long)ptr;
 	unsigned long end = addr + ((unsigned long)size);
 	unsigned long flags;
@@ -582,8 +627,34 @@ int asi_map_range(struct asi *asi, void *ptr, size_t size,
 	pr_debug("ASI %p: MAP %px/%lx/%d\n", asi, ptr, size, level);
 
 	spin_lock_irqsave(&asi->lock, flags);
+
+	/* check if the range is already mapped */
+	range_mapping = asi_get_range_mapping(asi, ptr);
+	if (range_mapping) {
+		pr_debug("ASI %p: MAP %px/%lx/%d already mapped\n",
+			 asi, ptr, size, level);
+		err = -EBUSY;
+		goto done;
+	}
+
+	/* map new range */
+	range_mapping = kmalloc(sizeof(*range_mapping), GFP_KERNEL);
+	if (!range_mapping) {
+		err = -ENOMEM;
+		goto done;
+	}
+
 	err = asi_copy_pgd_range(asi, asi->pgd, current->mm->pgd,
 				 addr, end, level);
+	if (err)
+		goto done;
+
+	INIT_LIST_HEAD(&range_mapping->list);
+	range_mapping->ptr = ptr;
+	range_mapping->size = size;
+	range_mapping->level = level;
+	list_add(&range_mapping->list, &asi->mapping_list);
+done:
 	spin_unlock_irqrestore(&asi->lock, flags);
 
 	return err;
-- 
1.7.1

