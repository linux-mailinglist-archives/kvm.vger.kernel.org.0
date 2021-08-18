Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2FAE3F04BA
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 15:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237531AbhHRN1n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 09:27:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52090 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236720AbhHRN1N (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 09:27:13 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17ID3xxV122428;
        Wed, 18 Aug 2021 09:26:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=K1xU8JHDb4NajmQenM9atuxnK5c3T/2MWeMJq+CdbEg=;
 b=VuYp18Vj7on3yWe6GW1sl4GOa8A+21xtdXO3knH6ImwBd4vWRGvJ/YOtnUE1MMTaZLsi
 0xsncQSwps35mXterP4PVRDZn+tHTFS2ZCaFF4J0nRCaEgYEEL/O+3KxNvX8EzmBFFhl
 lafWa44kNp59DBDFFSFNpRSnhE13/lXXbNr+kVYXtOGYwhaehYH/iFp+JQWzJ5e6rkud
 9nqQJTbChP06Dg7erVv4fhT5904kq3/FGH4xcacPLLM8AKdBeyhIo4jn/J4Q+m6+Df36
 10Hf9AqsCEb1L7rkOHkWKM3SrKMsvckThoLHoaZ/xw8SaKa6LTmwx7/F/u1SYE74LEea lQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3agf0esax2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 09:26:37 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17ID4XUt124386;
        Wed, 18 Aug 2021 09:26:37 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3agf0esawb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 09:26:37 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17IDCtHL029201;
        Wed, 18 Aug 2021 13:26:35 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3ae5f8dqpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 13:26:35 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17IDQUcI53674352
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 13:26:30 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D43A64C06E;
        Wed, 18 Aug 2021 13:26:29 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4CBCB4C063;
        Wed, 18 Aug 2021 13:26:29 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.14.177])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 18 Aug 2021 13:26:29 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com
Subject: [PATCH v4 13/14] KVM: s390: pv: lazy destroy for reboot
Date:   Wed, 18 Aug 2021 15:26:19 +0200
Message-Id: <20210818132620.46770-14-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210818132620.46770-1-imbrenda@linux.ibm.com>
References: <20210818132620.46770-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: g-Jgrx4_LxVZZJI57Uy1wrNGr3POXFwQ
X-Proofpoint-GUID: Isp-VNnPrGFF6FpUdxb4aqgjIEcwWoGl
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-18_04:2021-08-17,2021-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501
 malwarescore=0 mlxscore=0 impostorscore=0 clxscore=1015 suspectscore=0
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108180082
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
 arch/s390/kvm/pv.c       | 132 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 134 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index b655a7d82bf0..238297a7bb46 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2281,7 +2281,7 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 
 		r = kvm_s390_cpus_to_pv(kvm, &cmd->rc, &cmd->rrc);
 		if (r)
-			kvm_s390_pv_deinit_vm(kvm, &dummy, &dummy);
+			kvm_s390_pv_deinit_vm_deferred(kvm, &dummy, &dummy);
 
 		/* we need to block service interrupts from now on */
 		set_bit(IRQ_PEND_EXT_SERVICE, &kvm->arch.float_int.masked_irqs);
@@ -2300,7 +2300,7 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 		 */
 		if (r)
 			break;
-		r = kvm_s390_pv_deinit_vm(kvm, &cmd->rc, &cmd->rrc);
+		r = kvm_s390_pv_deinit_vm_deferred(kvm, &cmd->rc, &cmd->rrc);
 
 		/* no need to block service interrupts any more */
 		clear_bit(IRQ_PEND_EXT_SERVICE, &kvm->arch.float_int.masked_irqs);
@@ -2829,7 +2829,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	 * complaining we do not use kvm_s390_pv_is_protected.
 	 */
 	if (kvm_s390_pv_get_handle(kvm))
-		kvm_s390_pv_deinit_vm(kvm, &rc, &rrc);
+		kvm_s390_pv_deinit_vm_deferred(kvm, &rc, &rrc);
 	debug_unregister(kvm->arch.dbf);
 	free_page((unsigned long)kvm->arch.sie_page2);
 	if (!kvm_is_ucontrol(kvm))
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 9fad25109b0d..d2380f5e7e1f 100644
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
index e29109af7956..e6672937abef 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -14,12 +14,21 @@
 #include <asm/mman.h>
 #include <linux/pagewalk.h>
 #include <linux/sched/mm.h>
+#include <linux/kthread.h>
 #include "kvm-s390.h"
 
 static int lazy_destroy = 1;
 module_param(lazy_destroy, int, 0444);
 MODULE_PARM_DESC(lazy_destroy, "Deferred destroy for protected guests");
 
+struct deferred_priv {
+	struct mm_struct *mm;
+	unsigned long old_table;
+	u64 handle;
+	void *stor_var;
+	unsigned long stor_base;
+};
+
 int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
 {
 	int cc;
@@ -161,7 +170,7 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
 }
 
 /* this should not fail, but if it does, we must not free the donated memory */
-int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
+static int kvm_s390_pv_deinit_vm_now(struct kvm *kvm, u16 *rc, u16 *rrc)
 {
 	int cc;
 
@@ -189,6 +198,125 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	return cc ? -EIO : 0;
 }
 
+static int kvm_s390_pv_destroy_vm_thread(void *priv)
+{
+	struct deferred_priv *p = priv;
+	u16 rc, rrc;
+	int r;
+
+	/* Clear all the pages as long as we are not the only users of the mm */
+	s390_uv_destroy_range(p->mm, 1, 0, TASK_SIZE_MAX);
+	/*
+	 * If we were the last user of the mm, synchronously free (and clear
+	 * if needed) all pages.
+	 * Otherwise simply decrease the reference counter; in this case we
+	 * have already cleared all pages.
+	 */
+	mmput(p->mm);
+
+	r = uv_cmd_nodata(p->handle, UVC_CMD_DESTROY_SEC_CONF, &rc, &rrc);
+	WARN_ONCE(r, "protvirt destroy vm failed rc %x rrc %x", rc, rrc);
+	if (r) {
+		mmdrop(p->mm);
+		return r;
+	}
+	atomic_dec(&p->mm->context.is_protected);
+	mmdrop(p->mm);
+
+	/*
+	 * Intentional leak in case the destroy secure VM call fails. The
+	 * call should never fail if the hardware is not broken.
+	 */
+	free_pages(p->stor_base, get_order(uv_info.guest_base_stor_len));
+	free_pages(p->old_table, CRST_ALLOC_ORDER);
+	vfree(p->stor_var);
+	kfree(p);
+	return 0;
+}
+
+static int deferred_destroy(struct kvm *kvm, struct deferred_priv *priv, u16 *rc, u16 *rrc)
+{
+	struct task_struct *t;
+
+	priv->stor_var = kvm->arch.pv.stor_var;
+	priv->stor_base = kvm->arch.pv.stor_base;
+	priv->handle = kvm_s390_pv_get_handle(kvm);
+	priv->old_table = (unsigned long)kvm->arch.gmap->table;
+	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
+
+	if (s390_replace_asce(kvm->arch.gmap))
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
+	if (!lazy_destroy)
+		return kvm_s390_pv_deinit_vm_now(kvm, rc, rrc);
+
+	priv = kmalloc(sizeof(*priv), GFP_KERNEL | __GFP_ZERO);
+	if (!priv)
+		return kvm_s390_pv_deinit_vm_now(kvm, rc, rrc);
+
+	mmgrab(kvm->mm);
+	if (mmget_not_zero(kvm->mm)) {
+		kvm_s390_clear_2g(kvm);
+	} else {
+		/* No deferred work to do */
+		mmdrop(kvm->mm);
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
@@ -222,7 +350,7 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
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

