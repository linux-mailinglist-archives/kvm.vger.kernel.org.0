Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 900A0386553
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 22:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237912AbhEQUJh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 16:09:37 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2456 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237742AbhEQUJ0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 May 2021 16:09:26 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14HK4Hg8183379;
        Mon, 17 May 2021 16:08:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=bnVeoD6ON7hqjE0coBt2L5l0wKjnD1KkG0IvtSHOVu4=;
 b=owUYNa8ViiTDJGFHytwV1iYD/deYS/J3uKfpNHsL7wQobmcRtvYqrBAzOZdXq5piHzoQ
 oL5Th0tr6pHGLqxTclYUWJCZBToELI+/JD7rDK93cCtKzA39f2Mv2hlqqrZUEup28U6E
 6PpBji+O/k228LWD45hxEYvAaauUepU4YURIA/KfbaIF745PKhVGz7Zbq5Nl7TCqpCDN
 q0+Q2PqHnxRLsliUkG1+DbPLC1mKxY2zGz0nFlSsm+XZAeq+vQDHCd0hcmUfr85CS2kt
 ++Bugivy1vQhKo14rM6EjfEyjrXibp42g07x53aI2UzEtlX3ZxObCMSR8yHtsCq3PYPD /w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38kxncrvtc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 16:08:08 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14HK4Q5h184227;
        Mon, 17 May 2021 16:08:08 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38kxncrvsk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 16:08:07 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14HK86pi027592;
        Mon, 17 May 2021 20:08:06 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 38j5x80kd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 20:08:06 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14HK836Y30605574
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 May 2021 20:08:03 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC2D152063;
        Mon, 17 May 2021 20:08:02 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.14.34])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 897F252050;
        Mon, 17 May 2021 20:08:02 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 08/11] KVM: s390: pv: lazy destroy for reboot
Date:   Mon, 17 May 2021 22:07:55 +0200
Message-Id: <20210517200758.22593-9-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517200758.22593-1-imbrenda@linux.ibm.com>
References: <20210517200758.22593-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 227rVPf5j77BU9_UYeeM4D_N1xkJkEWa
X-Proofpoint-ORIG-GUID: Xs8z7nIk3KgxHxg8uYG3k5Ch8_MTRQv2
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-17_08:2021-05-17,2021-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 phishscore=0 mlxlogscore=912 clxscore=1015 spamscore=0
 lowpriorityscore=0 suspectscore=0 mlxscore=0 bulkscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105170140
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Until now, destroying a protected guest was an entirely synchronous
operation that could potentially take a very long time, depending on
the size of the guest, due to the time needed to clean up the address
space from protected pages.

This patch implements a lazy destroy mechanism, that allows a protected
guest to reboot significantly faster than previously.

This is achieved by clearing the pages of the old guest in background.
In case of reboot, the new guest will be able to run in the same
address space almost immediately.

The old protected guest is then only destroyed when all of its memory has
been destroyed or otherwise made non protected.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c |   6 +-
 arch/s390/kvm/kvm-s390.h |   2 +-
 arch/s390/kvm/pv.c       | 118 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 120 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 2f09e9d7dc95..db25aa1fb6a6 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2248,7 +2248,7 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 
 		r = kvm_s390_cpus_to_pv(kvm, &cmd->rc, &cmd->rrc);
 		if (r)
-			kvm_s390_pv_deinit_vm(kvm, &dummy, &dummy);
+			kvm_s390_pv_deinit_vm_deferred(kvm, &dummy, &dummy);
 
 		/* we need to block service interrupts from now on */
 		set_bit(IRQ_PEND_EXT_SERVICE, &kvm->arch.float_int.masked_irqs);
@@ -2267,7 +2267,7 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 		 */
 		if (r)
 			break;
-		r = kvm_s390_pv_deinit_vm(kvm, &cmd->rc, &cmd->rrc);
+		r = kvm_s390_pv_deinit_vm_deferred(kvm, &cmd->rc, &cmd->rrc);
 
 		/* no need to block service interrupts any more */
 		clear_bit(IRQ_PEND_EXT_SERVICE, &kvm->arch.float_int.masked_irqs);
@@ -2796,7 +2796,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	 * complaining we do not use kvm_s390_pv_is_protected.
 	 */
 	if (kvm_s390_pv_get_handle(kvm))
-		kvm_s390_pv_deinit_vm(kvm, &rc, &rrc);
+		kvm_s390_pv_deinit_vm_deferred(kvm, &rc, &rrc);
 	debug_unregister(kvm->arch.dbf);
 	free_page((unsigned long)kvm->arch.sie_page2);
 	if (!kvm_is_ucontrol(kvm))
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 79dcd647b378..b3c0796a3cc1 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -211,7 +211,7 @@ static inline int kvm_s390_user_cpu_state_ctrl(struct kvm *kvm)
 /* implemented in pv.c */
 int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
 int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
-int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc);
+int kvm_s390_pv_deinit_vm_deferred(struct kvm *kvm, u16 *rc, u16 *rrc);
 int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc);
 int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length, u16 *rc,
 			      u16 *rrc);
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 59039b8a7be7..9a3547966e18 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -14,8 +14,17 @@
 #include <asm/mman.h>
 #include <linux/pagewalk.h>
 #include <linux/sched/mm.h>
+#include <linux/kthread.h>
 #include "kvm-s390.h"
 
+struct deferred_priv {
+	struct mm_struct *mm;
+	unsigned long old_table;
+	u64 handle;
+	void *virt;
+	unsigned long real;
+};
+
 int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
 {
 	int cc = 0;
@@ -202,7 +211,7 @@ static int kvm_s390_pv_replace_asce(struct kvm *kvm)
 }
 
 /* this should not fail, but if it does, we must not free the donated memory */
-int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
+static int kvm_s390_pv_deinit_vm_now(struct kvm *kvm, u16 *rc, u16 *rrc)
 {
 	int cc;
 
@@ -230,6 +239,111 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	return cc ? -EIO : 0;
 }
 
+static int kvm_s390_pv_destroy_vm_thread(void *priv)
+{
+	struct deferred_priv *p = priv;
+	u16 rc, rrc;
+	int r = 1;
+
+	/* Exit early if we end up being the only users of the mm */
+	s390_uv_destroy_range(p->mm, 1, 0, TASK_SIZE_MAX);
+	mmput(p->mm);
+
+	r = uv_cmd_nodata(p->handle, UVC_CMD_DESTROY_SEC_CONF, &rc, &rrc);
+	WARN_ONCE(r, "protvirt destroy vm failed rc %x rrc %x", rc, rrc);
+	if (r)
+		return r;
+	atomic_dec(&p->mm->context.is_protected);
+
+	/*
+	 * Intentional leak in case the destroy secure VM call fails. The
+	 * call should never fail if the hardware is not broken.
+	 */
+	free_pages(p->real, get_order(uv_info.guest_base_stor_len));
+	free_pages(p->old_table, CRST_ALLOC_ORDER);
+	vfree(p->virt);
+	kfree(p);
+	return 0;
+}
+
+static int deferred_destroy(struct kvm *kvm, struct deferred_priv *priv, u16 *rc, u16 *rrc)
+{
+	struct task_struct *t;
+
+	priv->virt = kvm->arch.pv.stor_var;
+	priv->real = kvm->arch.pv.stor_base;
+	priv->handle = kvm_s390_pv_get_handle(kvm);
+	priv->old_table = (unsigned long)kvm->arch.gmap->table;
+	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
+
+	if (kvm_s390_pv_replace_asce(kvm))
+		goto fail;
+
+	t = kthread_create(kvm_s390_pv_destroy_vm_thread, priv,
+			   "kvm_s390_pv_destroy_vm_thread");
+	if (IS_ERR_OR_NULL(t))
+		goto fail;
+
+	memset(&kvm->arch.pv, 0, sizeof(kvm->arch.pv));
+	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM DEFERRED %d", t->pid);
+	wake_up_process(t);
+	/*
+	 * no actual UVC is performed at this point, just return a successful
+	 * rc value to make userspace happy, and an arbitrary rrc
+	 */
+	*rc = 1;
+	*rrc = 42;
+
+	return 0;
+
+fail:
+	kfree(priv);
+	return kvm_s390_pv_deinit_vm_now(kvm, rc, rrc);
+}
+
+/*  Clear the first 2GB of guest memory, to avoid prefix issues after reboot */
+static void kvm_s390_clear_2g(struct kvm *kvm)
+{
+	struct kvm_memory_slot *slot;
+	struct kvm_memslots *slots;
+	unsigned long lim;
+	int idx;
+
+	idx = srcu_read_lock(&kvm->srcu);
+
+	slots = kvm_memslots(kvm);
+	kvm_for_each_memslot(slot, slots) {
+		if (slot->base_gfn >= (SZ_2G / PAGE_SIZE))
+			continue;
+		if (slot->base_gfn + slot->npages > (SZ_2G / PAGE_SIZE))
+			lim = slot->userspace_addr + SZ_2G - slot->base_gfn * PAGE_SIZE;
+		else
+			lim = slot->userspace_addr + slot->npages * PAGE_SIZE;
+		s390_uv_destroy_range(kvm->mm, 1, slot->userspace_addr, lim);
+	}
+
+	srcu_read_unlock(&kvm->srcu, idx);
+}
+
+int kvm_s390_pv_deinit_vm_deferred(struct kvm *kvm, u16 *rc, u16 *rrc)
+{
+	struct deferred_priv *priv;
+
+	priv = kmalloc(sizeof(*priv), GFP_KERNEL | __GFP_ZERO);
+	if (!priv)
+		return kvm_s390_pv_deinit_vm_now(kvm, rc, rrc);
+
+	if (mmget_not_zero(kvm->mm)) {
+		kvm_s390_clear_2g(kvm);
+	} else {
+		/* No deferred work to do */
+		kfree(priv);
+		return kvm_s390_pv_deinit_vm_now(kvm, rc, rrc);
+	}
+	priv->mm = kvm->mm;
+	return deferred_destroy(kvm, priv, rc, rrc);
+}
+
 int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 {
 	struct uv_cb_cgc uvcb = {
@@ -263,7 +377,7 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	atomic_inc(&kvm->mm->context.is_protected);
 	if (cc) {
 		if (uvcb.header.rc & UVC_RC_NEED_DESTROY) {
-			kvm_s390_pv_deinit_vm(kvm, &dummy, &dummy);
+			kvm_s390_pv_deinit_vm_now(kvm, &dummy, &dummy);
 		} else {
 			atomic_dec(&kvm->mm->context.is_protected);
 			kvm_s390_pv_dealloc_vm(kvm);
-- 
2.31.1

