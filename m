Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDCF24CAD2A
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 19:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244517AbiCBSN2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 13:13:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244491AbiCBSMn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 13:12:43 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16604D2071;
        Wed,  2 Mar 2022 10:11:59 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 222FsBsw007340;
        Wed, 2 Mar 2022 18:11:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=yd62+gKhnufyg31t0V+kwGQPAog/FFcx7rzmp5gp79c=;
 b=BcsQIAsi9kPs0LleRmmGCxhyVKTExGb1YU7cAcNyvj0+qKAAkFpbxK9rU9Zj+D37Czfy
 krwviRdDeIvVkko1bI7PqCOEtdk9oAL32IERlH5eEXlqiRzPYyxj/oYBEQF2eCuar2Qj
 SyNplUU6jF+z5/0pnoNuvPP1ZApQpxNkR8mbzFveX3M6rESV6lS4xnMjPNgPxYw4fa1y
 /BV0h7Aig2KK/0cuoZYxJu/ghhgPh1UmAl0+1cCLA4qn7uM6zupQ+1eFEeGbaE+x6pIU
 rLuIk+WDaIQfamAHEKudf+0K/fYIajIGFezQzBht/l1DTI0Zp7VorH6+zZoa1A17ZxA1 nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ejbmdtv67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 18:11:58 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 222HubOw027893;
        Wed, 2 Mar 2022 18:11:58 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ejbmdtv55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 18:11:57 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 222I8nBk028577;
        Wed, 2 Mar 2022 18:11:55 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 3efbu9e2kd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 18:11:55 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 222IBq4t55181658
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Mar 2022 18:11:52 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4273C5204F;
        Wed,  2 Mar 2022 18:11:52 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.5.37])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id BC0B452052;
        Wed,  2 Mar 2022 18:11:51 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v8 14/17] KVM: s390: pv: asynchronous destroy for reboot
Date:   Wed,  2 Mar 2022 19:11:40 +0100
Message-Id: <20220302181143.188283-15-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220302181143.188283-1-imbrenda@linux.ibm.com>
References: <20220302181143.188283-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JZt9cN5ufILSyxLd0z3UIQ3jKuSUbChn
X-Proofpoint-GUID: 62QIncunqvi8PC5dhbW_xmPAa8WkXXtP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-02_12,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0 adultscore=0
 mlxlogscore=895 malwarescore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203020078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index 3637f556ff33..2453d2d90d6c 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2285,6 +2285,30 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
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
index 9276d910631b..be53c7750248 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -234,6 +234,8 @@ static inline unsigned long kvm_s390_get_gfn_end(struct kvm_memslots *slots)
 /* implemented in pv.c */
 int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
 int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
+int kvm_s390_pv_deinit_vm_async_prepare(struct kvm *kvm, u16 *rc, u16 *rrc);
+int kvm_s390_pv_deinit_vm_async(struct kvm *kvm, u16 *rc, u16 *rrc);
 int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc);
 int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc);
 int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length, u16 *rc,
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 56412617dd01..5111f1fc64ab 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -262,6 +262,132 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
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
index 507ee1f2aa96..d150610e7a4b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1644,6 +1644,8 @@ enum pv_cmd_id {
 	KVM_PV_VERIFY,
 	KVM_PV_PREP_RESET,
 	KVM_PV_UNSHARE_ALL,
+	KVM_PV_ASYNC_DISABLE_PREPARE,
+	KVM_PV_ASYNC_DISABLE,
 };
 
 struct kvm_pv_cmd {
-- 
2.34.1

