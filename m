Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46194467C0A
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 17:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382265AbhLCRCW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 12:02:22 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18274 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1382293AbhLCRBy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Dec 2021 12:01:54 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B3GINJx015551;
        Fri, 3 Dec 2021 16:58:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=d11DLyLtJOYyz7DWSFWOfQXhLAqAqaWFEFQ+VcsoDDU=;
 b=O/69AwPpXHt38hvOmfOWNReFf41k1pPEl4UR1HugYWWAhMcYaIcbeeKbFDii14vMNUBn
 li2oElXO6cvkeBnwbmdybI037XRq69xzoUkUOo4yA2BMNwQx24TLOdHJwGvYSaf+S6OG
 jV714cFr4p+VG9YWCUBSCGD9MDjNtEiLPfWw1kj+OfWmZwNPdLFU5uc/SkrWDuowK9p9
 htFSrOSe+rvjpNf02yUeZeLG39cvXgeK//wdgFsFZnCH5DlRXlYOumCgekMELN87HJiq
 y0syPCpBRqwOrmCW2yoLd/w9Y5pnidf6S8C9a9qGG5KtiE7EYQq++Zxi6T1qse8K2KP5 9w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cqpn28s08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 16:58:29 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B3GPkfR024566;
        Fri, 3 Dec 2021 16:58:29 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cqpn28ryr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 16:58:29 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B3GvmMo008195;
        Fri, 3 Dec 2021 16:58:26 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3cncgn3v2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 16:58:26 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B3GwN1s32440782
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Dec 2021 16:58:23 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E44D5204E;
        Fri,  3 Dec 2021 16:58:23 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.14.21])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 8FF8C52054;
        Fri,  3 Dec 2021 16:58:22 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 13/17] KVM: s390: pv: cleanup leftover protected VMs if needed
Date:   Fri,  3 Dec 2021 17:58:10 +0100
Message-Id: <20211203165814.73016-14-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211203165814.73016-1-imbrenda@linux.ibm.com>
References: <20211203165814.73016-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TQJDThi0OUrzwWvZEmLzjAT1ClYM_vT_
X-Proofpoint-ORIG-GUID: xZ7-RjI-8vulHYKDXZucSzYKVq3YISpN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-03_07,2021-12-02_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112030105
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In upcoming patches it will be possible to start tearing down a
protected VM, and finish the teardown concurrently in a different
thread.

Protected VMs that are pending for tear down ("leftover") need to be
cleaned properly when the userspace process (e.g. qemu) terminates.

This patch makes sure that all "leftover" protected VMs are always
properly torn down.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  2 +
 arch/s390/kvm/kvm-s390.c         |  1 +
 arch/s390/kvm/pv.c               | 69 ++++++++++++++++++++++++++++++++
 3 files changed, 72 insertions(+)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 8b288cff2a3a..948c9d4b0b51 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -921,6 +921,8 @@ struct kvm_s390_pv {
 	u64 guest_len;
 	unsigned long stor_base;
 	void *stor_var;
+	void *async_deinit;
+	struct list_head need_cleanup;
 	struct mmu_notifier mmu_notifier;
 };
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 850d86995083..1b83fd3b1322 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2817,6 +2817,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm_s390_vsie_init(kvm);
 	if (use_gisa)
 		kvm_s390_gisa_init(kvm);
+	INIT_LIST_HEAD(&kvm->arch.pv.need_cleanup);
 	KVM_EVENT(3, "vm 0x%pK created by pid %u", kvm, current->pid);
 
 	return 0;
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index a54f6e98fa6f..825d69601fe5 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -16,6 +16,19 @@
 #include <linux/sched/mm.h>
 #include "kvm-s390.h"
 
+/**
+ * @struct deferred_priv
+ * Represents a "leftover" protected VM that does not correspond to any
+ * active KVM VM.
+ */
+struct deferred_priv {
+	struct list_head list;
+	unsigned long old_table;
+	u64 handle;
+	void *stor_var;
+	unsigned long stor_base;
+};
+
 static void kvm_s390_clear_pv_state(struct kvm *kvm)
 {
 	kvm->arch.pv.handle = 0;
@@ -165,6 +178,60 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
 	return -ENOMEM;
 }
 
+/**
+ * kvm_s390_pv_cleanup_deferred - Clean up one leftover protected VM.
+ * @kvm the KVM that was associated with this leftover protected VM
+ * @deferred details about the leftover protected VM that needs a clean up
+ * Return: 0 in case of success, otherwise 1
+ */
+static int kvm_s390_pv_cleanup_deferred(struct kvm *kvm, struct deferred_priv *deferred)
+{
+	u16 rc, rrc;
+	int cc;
+
+	cc = uv_cmd_nodata(deferred->handle, UVC_CMD_DESTROY_SEC_CONF, &rc, &rrc);
+	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", rc, rrc);
+	WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc %x", rc, rrc);
+	if (cc)
+		return cc;
+	/*
+	 * Intentionally leak unusable memory. If the UVC fails, the memory
+	 * used for the VM and its metadata is permanently unusable.
+	 * This can only happen in case of a serious KVM or hardware bug; it
+	 * is not expected to happen in normal operation.
+	 */
+	free_pages(deferred->stor_base, get_order(uv_info.guest_base_stor_len));
+	free_pages(deferred->old_table, CRST_ALLOC_ORDER);
+	vfree(deferred->stor_var);
+	return 0;
+}
+
+/**
+ * kvm_s390_pv_cleanup_leftovers - Clean up all leftover protected VMs.
+ * @kvm the KVM whose leftover protected VMs are to be cleaned up
+ * Return: 0 in case of success, otherwise 1
+ */
+static int kvm_s390_pv_cleanup_leftovers(struct kvm *kvm)
+{
+	struct deferred_priv *deferred;
+	int cc = 0;
+
+	if (kvm->arch.pv.async_deinit)
+		list_add(kvm->arch.pv.async_deinit, &kvm->arch.pv.need_cleanup);
+
+	while (!list_empty(&kvm->arch.pv.need_cleanup)) {
+		deferred = list_first_entry(&kvm->arch.pv.need_cleanup, typeof(*deferred), list);
+		if (kvm_s390_pv_cleanup_deferred(kvm, deferred))
+			cc = 1;
+		else
+			atomic_dec(&kvm->mm->context.protected_count);
+		list_del(&deferred->list);
+		kfree(deferred);
+	}
+	kvm->arch.pv.async_deinit = NULL;
+	return cc;
+}
+
 /* this should not fail, but if it does, we must not free the donated memory */
 int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 {
@@ -192,6 +259,8 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", *rc, *rrc);
 	WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc %x", *rc, *rrc);
 
+	cc |= kvm_s390_pv_cleanup_leftovers(kvm);
+
 	return cc ? -EIO : 0;
 }
 
-- 
2.31.1

