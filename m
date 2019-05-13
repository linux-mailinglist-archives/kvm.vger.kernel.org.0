Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFCCE1B8B7
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 16:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730415AbfEMOj7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 10:39:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45696 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730379AbfEMOj6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 10:39:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DEd3Xk181510;
        Mon, 13 May 2019 14:39:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=bWRO35KV4FFQ3ievQKGZUgx84GSk+HyQdow97r7zwRo=;
 b=m4RXoI1fsAKJ65HwcxYTTiRielpSLksHyApCP0jeXXPvtewp5rwRVYDUYtxPM3t1rURV
 OUQPSWm2qaD3jmmQMsTFovUD4DnaSZ9GrLWp+D/fBi4LLvQVebxgVSc9OJHFf2CRAqzr
 jMs2DWV9OiHzkIdKAyWvrDZ3MS42p42Wdt2fSuBYwE1/w/asqQj5umS4w9GtEYvIA23u
 3rWtsxf8YqaVnsN0/d1amhOkTseV2bABVDPs67GwZ9yZi2jVBvqt2G58KXhAHzSc5cet
 2eTD9xR3JIRNVohIEeFBP6T1HxJGuEpp2qFDS0MQNFcDFncFDyVl1u6MqmF255tAofwm Xw== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2sdnttfeh6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 14:39:25 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x4DEcZQI022780;
        Mon, 13 May 2019 14:39:22 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com,
        alexandre.chartre@oracle.com
Subject: [RFC KVM 15/27] kvm/isolation: keep track of VA range mapped in KVM address space
Date:   Mon, 13 May 2019 16:38:23 +0200
Message-Id: <1557758315-12667-16-git-send-email-alexandre.chartre@oracle.com>
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

This will be used when we have to clear mappings to ensure the same
range is cleared at the same page table level it was copied.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/kvm/isolation.c |   86 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 84 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/isolation.c b/arch/x86/kvm/isolation.c
index 4f1b511..c8358a9 100644
--- a/arch/x86/kvm/isolation.c
+++ b/arch/x86/kvm/isolation.c
@@ -61,6 +61,20 @@ struct pgt_directory_group {
 #define PGTD_ALIGN(entry)	\
 	((typeof(entry))(((unsigned long)(entry)) & PAGE_MASK))
 
+/*
+ * Variables to keep track of address ranges mapped into the KVM
+ * address space.
+ */
+struct kvm_range_mapping {
+	struct list_head list;
+	void *ptr;
+	size_t size;
+	enum page_table_level level;
+};
+
+static LIST_HEAD(kvm_range_mapping_list);
+static DEFINE_MUTEX(kvm_range_mapping_lock);
+
 
 struct mm_struct kvm_mm = {
 	.mm_rb			= RB_ROOT,
@@ -91,6 +105,52 @@ struct mm_struct kvm_mm = {
 static bool __read_mostly address_space_isolation;
 module_param(address_space_isolation, bool, 0444);
 
+static struct kvm_range_mapping *kvm_get_range_mapping_locked(void *ptr,
+							      bool *subset)
+{
+	struct kvm_range_mapping *range;
+
+	list_for_each_entry(range, &kvm_range_mapping_list, list) {
+		if (range->ptr == ptr) {
+			if (subset)
+				*subset = false;
+			return range;
+		}
+		if (ptr > range->ptr && ptr < range->ptr + range->size) {
+			if (subset)
+				*subset = true;
+			return range;
+		}
+	}
+
+	return NULL;
+}
+
+static struct kvm_range_mapping *kvm_get_range_mapping(void *ptr, bool *subset)
+{
+	struct kvm_range_mapping *range;
+
+	mutex_lock(&kvm_range_mapping_lock);
+	range = kvm_get_range_mapping_locked(ptr, subset);
+	mutex_unlock(&kvm_range_mapping_lock);
+
+	return range;
+}
+
+static void kvm_free_all_range_mapping(void)
+{
+	struct kvm_range_mapping *range, *range_next;
+
+	mutex_lock(&kvm_range_mapping_lock);
+
+	list_for_each_entry_safe(range, range_next,
+				 &kvm_range_mapping_list, list) {
+		list_del(&range->list);
+		kfree(range);
+	}
+
+	mutex_unlock(&kvm_range_mapping_lock);
+}
 
 static struct pgt_directory_group *pgt_directory_group_create(void)
 {
@@ -661,10 +721,30 @@ static int kvm_copy_mapping(void *ptr, size_t size, enum page_table_level level)
 {
 	unsigned long addr = (unsigned long)ptr;
 	unsigned long end = addr + ((unsigned long)size);
+	struct kvm_range_mapping *range_mapping;
+	bool subset;
+	int err;
 
 	BUG_ON(current->mm == &kvm_mm);
-	pr_debug("KERNMAP COPY addr=%px size=%lx\n", ptr, size);
-	return kvm_copy_pgd_range(&kvm_mm, current->mm, addr, end, level);
+	pr_debug("KERNMAP COPY addr=%px size=%lx level=%d\n", ptr, size, level);
+
+	range_mapping = kmalloc(sizeof(struct kvm_range_mapping), GFP_KERNEL);
+	if (!range_mapping)
+		return -ENOMEM;
+
+	err = kvm_copy_pgd_range(&kvm_mm, current->mm, addr, end, level);
+	if (err) {
+		kfree(range_mapping);
+		return err;
+	}
+
+	INIT_LIST_HEAD(&range_mapping->list);
+	range_mapping->ptr = ptr;
+	range_mapping->size = size;
+	range_mapping->level = level;
+	list_add(&range_mapping->list, &kvm_range_mapping_list);
+
+	return 0;
 }
 
 
@@ -720,6 +800,8 @@ static void kvm_isolation_uninit_mm(void)
 
 	destroy_context(&kvm_mm);
 
+	kvm_free_all_range_mapping();
+
 #ifdef CONFIG_PAGE_TABLE_ISOLATION
 	/*
 	 * With PTI, the KVM address space is defined in the user
-- 
1.7.1

