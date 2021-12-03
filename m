Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6345467BFB
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 17:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382366AbhLCRCB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 12:02:01 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3780 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1382291AbhLCRBy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Dec 2021 12:01:54 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B3GmB48001029;
        Fri, 3 Dec 2021 16:58:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ywDdzQ3pSkJhAoPkMS4wjXJfUaJY8rHigmZ5Ou6gfxs=;
 b=h1uksuskfNtJLmS3+VpHhKz2V+aEGxBjoyGLAeRoX6RJACCEX3CrONbMobf9FyDZQ+Rz
 tsI0GCtGM0rXVoV1xoXCB0vXXfrJ/khHK5rudw7mFzSx3xzBuRPwjuptHgimoQUAYwbl
 DpXrZAujOsxw2IvE4IOlcuGRXIVdPU59xJ5IVBhW4cuL5/kxP2bz814f+Fj/Yl3OOzev
 YjpUHASO5VCdJLZZZYV1z5ITMbnvfv8Blg17nkDdIO/tBgh3YYInEPk2DAAU5G3qoZ/b
 b32dX07q847K/PUMe+uMCWgUOoPv4flaWKqbWIdDmNP8XbjgSyUQcxNBuZ9nDSRD1nMC pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cqq2rr5gw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 16:58:29 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B3GnWrn002988;
        Fri, 3 Dec 2021 16:58:28 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cqq2rr5gj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 16:58:28 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B3GvZxq015842;
        Fri, 3 Dec 2021 16:58:27 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3ckcaaftgt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 16:58:26 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B3GwNvH32833874
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Dec 2021 16:58:23 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC1CF5204E;
        Fri,  3 Dec 2021 16:58:23 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.14.21])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 29A8852052;
        Fri,  3 Dec 2021 16:58:23 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 14/17] KVM: s390: pv: asynchronous destroy for reboot
Date:   Fri,  3 Dec 2021 17:58:11 +0100
Message-Id: <20211203165814.73016-15-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211203165814.73016-1-imbrenda@linux.ibm.com>
References: <20211203165814.73016-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Bhg86aq4FldQt_bPy3S2SdmxHd7V9UGZ
X-Proofpoint-GUID: NsSMqNE6laxv4f4Htbp_iEt41LSrmf5X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-03_07,2021-12-02_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 suspectscore=0 phishscore=0 adultscore=0 spamscore=0
 bulkscore=0 mlxlogscore=873 lowpriorityscore=0 mlxscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112030105
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Until now, destroying a protected guest was an entirely synchronous
operation that could potentially take a very long time, depending on
the size of the guest, due to the time needed to clean up the address
space from protected pages.

This patch implements an asynchronous destroy mechanism, that allows a
protected guest to reboot significantly faster than previously.

This is achieved by clearing the pages of the old guest in background.
In case of reboot, the new guest will be able to run in the same
address space almost immediately.

The old protected guest is then only destroyed when all of its memory has
been destroyed or otherwise made non protected.

Two new PV commands are added for the KVM_S390_PV_COMMAND ioctl:

KVM_PV_ASYNC_DISABLE_PREPARE: prepares the current protected VM for
asynchronous teardown. The current VM will then continue immediately
as non-protected. If a protected VM had already been set aside without
starting the teardown process, this call will fail.

KVM_PV_ASYNC_DISABLE: tears down the protected VM previously set aside
for asynchronous teardown. This PV command should ideally be issued by
userspace from a separate thread. If a fatal signal is received (or the
process terminates naturally), the command will terminate immediately
without completing.

Leftover protected VMs are cleaned up when a KVM VM is torn down
normally (either via IOCTL or when the process terminates); this
cleanup has been implemented in a previous patch.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c |  24 ++++++++
 arch/s390/kvm/kvm-s390.h |   2 +
 arch/s390/kvm/pv.c       | 126 +++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h |   2 +
 4 files changed, 154 insertions(+)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 1b83fd3b1322..a3710e21099f 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2314,6 +2314,30 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 		set_bit(IRQ_PEND_EXT_SERVICE, &kvm->arch.float_int.masked_irqs);
 		break;
 	}
+	case KVM_PV_ASYNC_DISABLE_PREPARE:
+		r = -EINVAL;
+		if (!kvm_s390_pv_is_protected(kvm) || !lazy_destroy)
+			break;
+
+		r = kvm_s390_cpus_from_pv(kvm, &cmd->rc, &cmd->rrc);
+		/*
+		 * If a CPU could not be destroyed, destroy VM will also fail.
+		 * There is no point in trying to destroy it. Instead return
+		 * the rc and rrc from the first CPU that failed destroying.
+		 */
+		if (r)
+			break;
+		r = kvm_s390_pv_deinit_vm_async_prepare(kvm, &cmd->rc, &cmd->rrc);
+
+		/* no need to block service interrupts any more */
+		clear_bit(IRQ_PEND_EXT_SERVICE, &kvm->arch.float_int.masked_irqs);
+		break;
+	case KVM_PV_ASYNC_DISABLE:
+		r = -EINVAL;
+		if (!kvm->arch.pv.async_deinit)
+			break;
+		r = kvm_s390_pv_deinit_vm_async(kvm, &cmd->rc, &cmd->rrc);
+		break;
 	case KVM_PV_DISABLE: {
 		r = -EINVAL;
 		if (!kvm_s390_pv_is_protected(kvm))
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index ef9429cb0307..0168db8cd2c2 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -220,6 +220,8 @@ static inline void kvm_s390_set_user_cpu_state_ctrl(struct kvm *kvm)
 /* implemented in pv.c */
 int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
 int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
+int kvm_s390_pv_deinit_vm_async_prepare(struct kvm *kvm, u16 *rc, u16 *rrc);
+int kvm_s390_pv_deinit_vm_async(struct kvm *kvm, u16 *rc, u16 *rrc);
 int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc);
 int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc);
 int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length, u16 *rc,
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 825d69601fe5..929ffea6a8cc 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -264,6 +264,132 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	return cc ? -EIO : 0;
 }
 
+/**
+ * kvm_s390_clear_2g - Clear the first 2GB of guest memory.
+ * @kvm the VM whose memory is to be cleared.
+ * Clear the first 2GB of guest memory, to avoid prefix issues after reboot.
+ */
+static void kvm_s390_clear_2g(struct kvm *kvm)
+{
+	struct kvm_memory_slot *slot;
+	unsigned long lim;
+	int srcu_idx;
+
+	srcu_idx = srcu_read_lock(&kvm->srcu);
+
+	slot = gfn_to_memslot(kvm, 0);
+	/* Clear all slots that are completely below 2GB */
+	while (slot && slot->base_gfn + slot->npages < SZ_2G / PAGE_SIZE) {
+		lim = slot->userspace_addr + slot->npages * PAGE_SIZE;
+		s390_uv_destroy_range(kvm->mm, slot->userspace_addr, lim);
+		slot = gfn_to_memslot(kvm, slot->base_gfn + slot->npages);
+	}
+	/* Last slot crosses the 2G boundary, clear only up to 2GB */
+	if (slot && slot->base_gfn < SZ_2G / PAGE_SIZE) {
+		lim = slot->userspace_addr + SZ_2G - slot->base_gfn * PAGE_SIZE;
+		s390_uv_destroy_range(kvm->mm, slot->userspace_addr, lim);
+	}
+
+	srcu_read_unlock(&kvm->srcu, srcu_idx);
+}
+
+/**
+ * kvm_s390_pv_deinit_vm_async_prepare - Prepare a protected VM for
+ * asynchronous teardown.
+ * @kvm the VM
+ * @rc return value for the RC field of the UVCB
+ * @rrc return value for the RRC field of the UVCB
+ *
+ * Prepare the protected VM for asynchronous teardown. The VM will be able
+ * to continue immediately as a non-secure VM, and the information needed to
+ * properly tear down the protected VM is set aside. If another protected VM
+ * was already set aside without starting a teardown, the function will
+ * fail.
+ *
+ * Context: kvm->lock needs to be held
+ *
+ * Return: 0 in case of success, -EINVAL if another protected VM was already set
+ * aside, -ENOMEM if the system ran out of memory.
+ */
+int kvm_s390_pv_deinit_vm_async_prepare(struct kvm *kvm, u16 *rc, u16 *rrc)
+{
+	struct deferred_priv *priv;
+
+	/*
+	 * If an asynchronous deinitialization is already pending, refuse.
+	 * A synchronous deinitialization has to be performed instead.
+	 */
+	if (kvm->arch.pv.async_deinit)
+		return -EINVAL;
+	priv = kmalloc(sizeof(*priv), GFP_KERNEL | __GFP_ZERO);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->stor_var = kvm->arch.pv.stor_var;
+	priv->stor_base = kvm->arch.pv.stor_base;
+	priv->handle = kvm_s390_pv_get_handle(kvm);
+	priv->old_table = (unsigned long)kvm->arch.gmap->table;
+	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
+	if (s390_replace_asce(kvm->arch.gmap)) {
+		kfree(priv);
+		return -ENOMEM;
+	}
+
+	kvm_s390_clear_2g(kvm);
+	kvm_s390_clear_pv_state(kvm);
+	kvm->arch.pv.async_deinit = priv;
+
+	*rc = 1;
+	*rrc = 42;
+	return 0;
+}
+
+/**
+ * kvm_s390_pv_deinit_vm_async - Perform an asynchronous teardown of a
+ * protected VM.
+ * @kvm the VM previously associated with the protected VM
+ * @rc return value for the RC field of the UVCB
+ * @rrc return value for the RRC field of the UVCB
+ *
+ * Tear down the protected VM that had previously been set aside using
+ * kvm_s390_pv_deinit_vm_async_prepare.
+ *
+ * Context: kvm->lock needs to be held
+ *
+ * Return: 0 in case of success, -EINVAL if no protected VM had been
+ * prepared for asynchronous teardowm, -EIO in case of other errors.
+ */
+int kvm_s390_pv_deinit_vm_async(struct kvm *kvm, u16 *rc, u16 *rrc)
+{
+	struct deferred_priv *p = kvm->arch.pv.async_deinit;
+	int ret = 0;
+
+	if (!p)
+		return -EINVAL;
+	kvm->arch.pv.async_deinit = NULL;
+	mutex_unlock(&kvm->lock);
+
+	/* When a fatal signal is received, stop immediately */
+	if (s390_uv_destroy_range_interruptible(kvm->mm, 0, TASK_SIZE_MAX))
+		goto done;
+	if (kvm_s390_pv_cleanup_deferred(kvm, p))
+		ret = -EIO;
+	else
+		atomic_dec(&kvm->mm->context.protected_count);
+	kfree(p);
+	p = NULL;
+done:
+	/* The caller expects the lock to be held */
+	mutex_lock(&kvm->lock);
+	/*
+	 * p is not NULL if we aborted because of a fatal signal, in which
+	 * case queue the leftover for later cleanup.
+	 */
+	if (p)
+		list_add(&p->list, &kvm->arch.pv.need_cleanup);
+	return ret;
+}
+
 static void kvm_s390_pv_mmu_notifier_release(struct mmu_notifier *subscription,
 					     struct mm_struct *mm)
 {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 1daa45268de2..5166c90d1a1e 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1629,6 +1629,8 @@ enum pv_cmd_id {
 	KVM_PV_VERIFY,
 	KVM_PV_PREP_RESET,
 	KVM_PV_UNSHARE_ALL,
+	KVM_PV_ASYNC_DISABLE_PREPARE,
+	KVM_PV_ASYNC_DISABLE,
 };
 
 struct kvm_pv_cmd {
-- 
2.31.1

