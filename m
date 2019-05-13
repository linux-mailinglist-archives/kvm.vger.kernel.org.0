Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 244A21B8BF
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 16:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbfEMOl4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 10:41:56 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:39134 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729742AbfEMOle (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 10:41:34 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4DEdhZc193417;
        Mon, 13 May 2019 14:40:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=WgSqF1N9AL8OkCOWJMjKijUQDrf/NZQ7sjOAy3KvX18=;
 b=F3ixlg5Del/kZFpkm5V339YqcYZIvytCmmZa2JMsPdT9dTNJdzNgJr2su3ZaFPX7+xSo
 OgE5doXVsWLJE6lg24N70KQRsqrw7KDlX0Lmv11xaiukFvSmC1PL9Z+pb6KOsPd3f9/Q
 TysNHNbYW17DUsb88Xzm+0xLKL38OFY7GPCscqM5Sr2RGXWabgevtm0BY8LIkE1hebHi
 ZDG3ZUmmf/4/2FsM+aInuyKqWofpo40CdOK/HySYEBTuzbf6QiQlJM7oxHIAKfyG/xd8
 7z7TkAUzLmadWyiur41dp0GSyhTRruaBBuRMWSLXH6YSLiSP0FUqhXsgwlGrUBetwxxp pQ== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2sdkwdfm1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 May 2019 14:40:01 +0000
Received: from achartre-desktop.fr.oracle.com (dhcp-10-166-106-34.fr.oracle.com [10.166.106.34])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x4DEcZQT022780;
        Mon, 13 May 2019 14:39:53 GMT
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com,
        alexandre.chartre@oracle.com
Subject: [RFC KVM 26/27] kvm/isolation: initialize the KVM page table with KVM memslots
Date:   Mon, 13 May 2019 16:38:34 +0200
Message-Id: <1557758315-12667-27-git-send-email-alexandre.chartre@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9255 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=970
 adultscore=15 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905130103
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM memslots can change after they have been created so new memslots
have to be mapped when they are created.

TODO: we currently don't unmapped old memslots, they should be unmapped
when they are freed.

Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
---
 arch/x86/kvm/isolation.c |   39 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/isolation.h |    1 +
 arch/x86/kvm/x86.c       |    3 +++
 3 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/isolation.c b/arch/x86/kvm/isolation.c
index b0c789f..255b2da 100644
--- a/arch/x86/kvm/isolation.c
+++ b/arch/x86/kvm/isolation.c
@@ -1593,13 +1593,45 @@ static void kvm_isolation_clear_handlers(void)
 	kvm_page_fault_handler = NULL;
 }
 
+void kvm_isolation_check_memslots(struct kvm *kvm)
+{
+	struct kvm_range_mapping *rmapping;
+	int i, err;
+
+	if (!kvm_isolation())
+		return;
+
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		rmapping = kvm_get_range_mapping(kvm->memslots[i], NULL);
+		if (rmapping)
+			continue;
+		pr_debug("remapping kvm memslots[%d]\n", i);
+		err = kvm_copy_ptes(kvm->memslots[i],
+		    sizeof(struct kvm_memslots));
+		if (err)
+			pr_debug("failed to map kvm memslots[%d]\n", i);
+	}
+
+}
+
 int kvm_isolation_init_vm(struct kvm *kvm)
 {
+	int err, i;
+
 	if (!kvm_isolation())
 		return 0;
 
 	kvm_clear_page_fault();
 
+	pr_debug("mapping kvm memslots\n");
+
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		err = kvm_copy_ptes(kvm->memslots[i],
+		    sizeof(struct kvm_memslots));
+		if (err)
+			return err;
+	}
+
 	pr_debug("mapping kvm srcu sda\n");
 
 	return (kvm_copy_percpu_mapping(kvm->srcu.sda,
@@ -1608,9 +1640,16 @@ int kvm_isolation_init_vm(struct kvm *kvm)
 
 void kvm_isolation_destroy_vm(struct kvm *kvm)
 {
+	int i;
+
 	if (!kvm_isolation())
 		return;
 
+	pr_debug("unmapping kvm memslots\n");
+
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
+		kvm_clear_range_mapping(kvm->memslots[i]);
+
 	pr_debug("unmapping kvm srcu sda\n");
 
 	kvm_clear_percpu_mapping(kvm->srcu.sda);
diff --git a/arch/x86/kvm/isolation.h b/arch/x86/kvm/isolation.h
index 2d7d016..1e55799 100644
--- a/arch/x86/kvm/isolation.h
+++ b/arch/x86/kvm/isolation.h
@@ -32,6 +32,7 @@ static inline bool kvm_isolation(void)
 extern void kvm_clear_range_mapping(void *ptr);
 extern int kvm_copy_percpu_mapping(void *percpu_ptr, size_t size);
 extern void kvm_clear_percpu_mapping(void *percpu_ptr);
+extern void kvm_isolation_check_memslots(struct kvm *kvm);
 extern int kvm_add_task_mapping(struct task_struct *tsk);
 extern void kvm_cleanup_task_mapping(struct task_struct *tsk);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e1cc3a6..7d98e9f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9438,6 +9438,7 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
 	 * mmio generation may have reached its maximum value.
 	 */
 	kvm_mmu_invalidate_mmio_sptes(kvm, gen);
+	kvm_isolation_check_memslots(kvm);
 }
 
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
@@ -9537,6 +9538,8 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	 */
 	if (change != KVM_MR_DELETE)
 		kvm_mmu_slot_apply_flags(kvm, (struct kvm_memory_slot *) new);
+
+	kvm_isolation_check_memslots(kvm);
 }
 
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
-- 
1.7.1

