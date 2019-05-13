Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99EFE1B8A4
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 16:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730543AbfEMOkK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 10:40:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59876 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730542AbfEMOkJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 10:40:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DEd2Gn194925;
        Mon, 13 May 2019 14:39:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=+MaSC7D5NYyFHcoLlt21rqwn+ky+e8tS8duegev3cnQ=;
 b=z6slNgJ9MrFp8uPsBPJmJU6GEaQ8wt3ZidHa0OAjWLM8dA3+hvZO3Q2zqNmvKu+Qfvha
 f39YKjJiNdGzsIVZtiZmHgCAk3/RyTNp7XRWQJE/vV0AXPAhhrT+G+j8gHuyTYUQNX0f
 AIhcCp0PH4W5K5mBi7O15eBaUEQLLjjyWKwdghJjGta7Pwvvxw11nROudMT9WBKTJRLS
 bc5hFg0tiztOk+LrZZH2/SQPAOQVHBG6LvLcBcZDJcfhj/iVjW1L4APtEZtPI5sxvMGw
 RUUksDo71NnDOv56zatbXlgzV01aZsNu7msINVw4f0f0NjXKNnCv8fOY+KxWkWNogtPN 5Q== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2sdq1q7axg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 14:39:31 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x4DEcZQK022780;
        Mon, 13 May 2019 14:39:28 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com,
        alexandre.chartre@oracle.com
Subject: [RFC KVM 17/27] kvm/isolation: improve mapping copy when mapping is already present
Date:   Mon, 13 May 2019 16:38:25 +0200
Message-Id: <1557758315-12667-18-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9255 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905130103
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A mapping can already exist if a buffer was mapped in the KVM
address space, and then the buffer was freed but there was no
request to unmap from the KVM address space. In that case, clear
the existing mapping before mapping the new buffer.

Also if the new mapping is a subset of an already larger mapped
range, then remap the entire larger map.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/kvm/isolation.c |   67 +++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 63 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/isolation.c b/arch/x86/kvm/isolation.c
index e494a15..539e287 100644
--- a/arch/x86/kvm/isolation.c
+++ b/arch/x86/kvm/isolation.c
@@ -88,6 +88,9 @@ struct mm_struct kvm_mm = {
 DEFINE_STATIC_KEY_FALSE(kvm_isolation_enabled);
 EXPORT_SYMBOL(kvm_isolation_enabled);
 
+static void kvm_clear_mapping(void *ptr, size_t size,
+			      enum page_table_level level);
+
 /*
  * When set to true, KVM #VMExit handlers run in isolated address space
  * which maps only KVM required code and per-VM information instead of
@@ -721,6 +724,7 @@ static int kvm_copy_mapping(void *ptr, size_t size, enum page_table_level level)
 {
 	unsigned long addr = (unsigned long)ptr;
 	unsigned long end = addr + ((unsigned long)size);
+	unsigned long range_addr, range_end;
 	struct kvm_range_mapping *range_mapping;
 	bool subset;
 	int err;
@@ -728,22 +732,77 @@ static int kvm_copy_mapping(void *ptr, size_t size, enum page_table_level level)
 	BUG_ON(current->mm == &kvm_mm);
 	pr_debug("KERNMAP COPY addr=%px size=%lx level=%d\n", ptr, size, level);
 
-	range_mapping = kmalloc(sizeof(struct kvm_range_mapping), GFP_KERNEL);
-	if (!range_mapping)
-		return -ENOMEM;
+	mutex_lock(&kvm_range_mapping_lock);
+
+	/*
+	 * A mapping can already exist if the buffer was mapped and then
+	 * freed but there was no request to unmap it. We might also be
+	 * trying to map a subset of an already mapped buffer.
+	 */
+	range_mapping = kvm_get_range_mapping_locked(ptr, &subset);
+	if (range_mapping) {
+		if (subset) {
+			pr_debug("range %px/%lx/%d is a subset of %px/%lx/%d already mapped, remapping\n",
+				 ptr, size, level, range_mapping->ptr,
+				 range_mapping->size, range_mapping->level);
+			range_addr = (unsigned long)range_mapping->ptr;
+			range_end = range_addr +
+				((unsigned long)range_mapping->size);
+			err = kvm_copy_pgd_range(&kvm_mm, current->mm,
+						 range_addr, range_end,
+						 range_mapping->level);
+			if (end <= range_end) {
+				/*
+				 * We effectively have a subset, fully contained
+				 * in the superset. So we are done.
+				 */
+				mutex_unlock(&kvm_range_mapping_lock);
+				return err;
+			}
+			/*
+			 * The new range is larger than the existing mapped
+			 * range. So we need an extra mapping to map the end
+			 * of the range.
+			 */
+			addr = range_end;
+			range_mapping = NULL;
+			pr_debug("adding extra range %lx-%lx (%d)\n", addr,
+				 end, level);
+		} else {
+			pr_debug("range %px size=%lx level=%d already mapped, clearing\n",
+				 range_mapping->ptr, range_mapping->size,
+				 range_mapping->level);
+			kvm_clear_mapping(range_mapping->ptr,
+					  range_mapping->size,
+					  range_mapping->level);
+			list_del(&range_mapping->list);
+		}
+	}
+
+	if (!range_mapping) {
+		range_mapping = kmalloc(sizeof(struct kvm_range_mapping),
+		    GFP_KERNEL);
+		if (!range_mapping) {
+			mutex_unlock(&kvm_range_mapping_lock);
+			return -ENOMEM;
+		}
+		INIT_LIST_HEAD(&range_mapping->list);
+	}
 
 	err = kvm_copy_pgd_range(&kvm_mm, current->mm, addr, end, level);
 	if (err) {
+		mutex_unlock(&kvm_range_mapping_lock);
 		kfree(range_mapping);
 		return err;
 	}
 
-	INIT_LIST_HEAD(&range_mapping->list);
 	range_mapping->ptr = ptr;
 	range_mapping->size = size;
 	range_mapping->level = level;
 	list_add(&range_mapping->list, &kvm_range_mapping_list);
 
+	mutex_unlock(&kvm_range_mapping_lock);
+
 	return 0;
 }
 
-- 
1.7.1

