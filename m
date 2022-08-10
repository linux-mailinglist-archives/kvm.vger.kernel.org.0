Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE71F58EC82
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 14:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbiHJM62 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 08:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232598AbiHJM6E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 08:58:04 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C38F792C0;
        Wed, 10 Aug 2022 05:57:49 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27ACp9Ja003092;
        Wed, 10 Aug 2022 12:57:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=gzUpqzZDiQS9sW95qvXQ9TNYxgFoMe/fUsi+No7IIqY=;
 b=LSD2kq4Gzo5gQmVZ5pQlBN0bggKRscO8281HVVNp2ZeEQgKNgjj0OIILUdOe3EepJ5Gb
 DepcBAG/xWbLbRMWJSixZ2fJZecATmZFuqRM6WvAJeD2i7xfbs2PfJleOzK5odBfv1mU
 SU3UtPjixLx4tytZn1wehDSDAPtM0jr4NXfpSom6zBy7dc7g0Ve/sy4W/EHI2Par85fu
 x6+K/npx1f4PK9ophAO72RLp5E6IzIYoedTqzWmc4dx8l7HqR2bu5D+rxozsdXS1OwRH
 MJ6yMu5emBapFNa/ccivOfzILIzMBPTs7xeC10T/SOHXQqZ+vfDKVW8JLrad+VsOC7I5 wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hv3fg1wy6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 12:57:48 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27ACpkNU005561;
        Wed, 10 Aug 2022 12:57:47 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hv3fg1wxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 12:57:47 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27ACr0af026122;
        Wed, 10 Aug 2022 12:57:45 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3huww0rup4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 12:57:45 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27ACui8S28246510
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 12:56:44 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 627D74C044;
        Wed, 10 Aug 2022 12:56:27 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0E9B4C040;
        Wed, 10 Aug 2022 12:56:26 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.0.105])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 10 Aug 2022 12:56:26 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v13 1/6] KVM: s390: pv: asynchronous destroy for reboot
Date:   Wed, 10 Aug 2022 14:56:20 +0200
Message-Id: <20220810125625.45295-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220810125625.45295-1-imbrenda@linux.ibm.com>
References: <20220810125625.45295-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SBD5SIEB1WxYbw0LYUQPh2AzfpCrkcQC
X-Proofpoint-GUID: FjUL69XcaVkDAFdCqZUQH5ESHtSB--M0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_07,2022-08-10_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 impostorscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 spamscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100038
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

KVM_PV_ASYNC_CLEANUP_PREPARE: prepares the current protected VM for
asynchronous teardown. The current VM will then continue immediately
as non-protected. If a protected VM had already been set aside without
starting the teardown process, this call will fail. There can be at
most one prepared VM at any time.

KVM_PV_ASYNC_CLEANUP_PERFORM: tears down the protected VM previously
set aside for asynchronous teardown. This PV command should ideally be
issued by userspace from a separate thread. If a fatal signal is
received (or the process terminates naturally), the command will
terminate immediately without completing. The rest of the normal KVM
teardown process will take care of properly cleaning up all remaining
protected VMs.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |   2 +
 arch/s390/kvm/kvm-s390.c         |  46 ++++-
 arch/s390/kvm/kvm-s390.h         |   3 +
 arch/s390/kvm/pv.c               | 290 +++++++++++++++++++++++++++++--
 include/uapi/linux/kvm.h         |   2 +
 5 files changed, 325 insertions(+), 18 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index f39092e0ceaa..38558e5f554e 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -942,6 +942,8 @@ struct kvm_s390_pv {
 	unsigned long stor_base;
 	void *stor_var;
 	bool dumping;
+	void *set_aside;
+	struct list_head need_cleanup;
 	struct mmu_notifier mmu_notifier;
 };
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index edfd4bbd0cba..96ec6ecb6b74 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -209,6 +209,8 @@ unsigned int diag9c_forwarding_hz;
 module_param(diag9c_forwarding_hz, uint, 0644);
 MODULE_PARM_DESC(diag9c_forwarding_hz, "Maximum diag9c forwarding per second, 0 to turn off");
 
+static int async_destroy;
+
 /*
  * For now we handle at most 16 double words as this is what the s390 base
  * kernel handles and stores in the prefix page. If we ever need to go beyond
@@ -2504,9 +2506,13 @@ static int kvm_s390_pv_dmp(struct kvm *kvm, struct kvm_pv_cmd *cmd,
 
 static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 {
+	const bool needslock = (cmd->cmd != KVM_PV_ASYNC_CLEANUP_PERFORM);
+	void __user *argp = (void __user *)cmd->data;
 	int r = 0;
 	u16 dummy;
-	void __user *argp = (void __user *)cmd->data;
+
+	if (needslock)
+		mutex_lock(&kvm->lock);
 
 	switch (cmd->cmd) {
 	case KVM_PV_ENABLE: {
@@ -2540,6 +2546,28 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 		set_bit(IRQ_PEND_EXT_SERVICE, &kvm->arch.float_int.masked_irqs);
 		break;
 	}
+	case KVM_PV_ASYNC_CLEANUP_PREPARE:
+		r = -EINVAL;
+		if (!kvm_s390_pv_is_protected(kvm) || !async_destroy)
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
+		r = kvm_s390_pv_set_aside(kvm, &cmd->rc, &cmd->rrc);
+
+		/* no need to block service interrupts any more */
+		clear_bit(IRQ_PEND_EXT_SERVICE, &kvm->arch.float_int.masked_irqs);
+		break;
+	case KVM_PV_ASYNC_CLEANUP_PERFORM:
+		/* This must not be called while holding kvm->lock */
+		r = kvm_s390_pv_deinit_aside_vm(kvm, &cmd->rc, &cmd->rrc);
+		break;
 	case KVM_PV_DISABLE: {
 		r = -EINVAL;
 		if (!kvm_s390_pv_is_protected(kvm))
@@ -2553,7 +2581,7 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 		 */
 		if (r)
 			break;
-		r = kvm_s390_pv_deinit_vm(kvm, &cmd->rc, &cmd->rrc);
+		r = kvm_s390_pv_deinit_cleanup_all(kvm, &cmd->rc, &cmd->rrc);
 
 		/* no need to block service interrupts any more */
 		clear_bit(IRQ_PEND_EXT_SERVICE, &kvm->arch.float_int.masked_irqs);
@@ -2703,6 +2731,9 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 	default:
 		r = -ENOTTY;
 	}
+	if (needslock)
+		mutex_unlock(&kvm->lock);
+
 	return r;
 }
 
@@ -2907,9 +2938,8 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			r = -EINVAL;
 			break;
 		}
-		mutex_lock(&kvm->lock);
+		/* must be called without kvm->lock */
 		r = kvm_s390_handle_pv(kvm, &args);
-		mutex_unlock(&kvm->lock);
 		if (copy_to_user(argp, &args, sizeof(args))) {
 			r = -EFAULT;
 			break;
@@ -3228,6 +3258,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	kvm_s390_vsie_init(kvm);
 	if (use_gisa)
 		kvm_s390_gisa_init(kvm);
+	INIT_LIST_HEAD(&kvm->arch.pv.need_cleanup);
+	kvm->arch.pv.set_aside = NULL;
 	KVM_EVENT(3, "vm 0x%pK created by pid %u", kvm, current->pid);
 
 	return 0;
@@ -3272,11 +3304,9 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	/*
 	 * We are already at the end of life and kvm->lock is not taken.
 	 * This is ok as the file descriptor is closed by now and nobody
-	 * can mess with the pv state. To avoid lockdep_assert_held from
-	 * complaining we do not use kvm_s390_pv_is_protected.
+	 * can mess with the pv state.
 	 */
-	if (kvm_s390_pv_get_handle(kvm))
-		kvm_s390_pv_deinit_vm(kvm, &rc, &rrc);
+	kvm_s390_pv_deinit_cleanup_all(kvm, &rc, &rrc);
 	/*
 	 * Remove the mmu notifier only when the whole KVM VM is torn down,
 	 * and only if one was registered to begin with. If the VM is
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index f6fd668f887e..e70b895f640e 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -243,6 +243,9 @@ static inline u32 kvm_s390_get_gisa_desc(struct kvm *kvm)
 /* implemented in pv.c */
 int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
 int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc);
+int kvm_s390_pv_set_aside(struct kvm *kvm, u16 *rc, u16 *rrc);
+int kvm_s390_pv_deinit_aside_vm(struct kvm *kvm, u16 *rc, u16 *rrc);
+int kvm_s390_pv_deinit_cleanup_all(struct kvm *kvm, u16 *rc, u16 *rrc);
 int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc);
 int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc);
 int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length, u16 *rc,
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 7cb7799a0acb..eba4f3fc2138 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -18,6 +18,29 @@
 #include <linux/mmu_notifier.h>
 #include "kvm-s390.h"
 
+/**
+ * struct pv_vm_to_be_destroyed - Represents a protected VM that needs to
+ * be destroyed
+ *
+ * @list: list head for the list of leftover VMs
+ * @old_gmap_table: the gmap table of the leftover protected VM
+ * @handle: the handle of the leftover protected VM
+ * @stor_var: pointer to the variable storage of the leftover protected VM
+ * @stor_base: address of the base storage of the leftover protected VM
+ *
+ * Represents a protected VM that is still registered with the Ultravisor,
+ * but which does not correspond any longer to an active KVM VM. It should
+ * be destroyed at some point later, either asynchronously or when the
+ * process terminates.
+ */
+struct pv_vm_to_be_destroyed {
+	struct list_head list;
+	unsigned long old_gmap_table;
+	u64 handle;
+	void *stor_var;
+	unsigned long stor_base;
+};
+
 static void kvm_s390_clear_pv_state(struct kvm *kvm)
 {
 	kvm->arch.pv.handle = 0;
@@ -159,23 +182,149 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
 	return -ENOMEM;
 }
 
-/* this should not fail, but if it does, we must not free the donated memory */
-int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
+/**
+ * kvm_s390_pv_dispose_one_leftover - Clean up one leftover protected VM.
+ * @kvm: the KVM that was associated with this leftover protected VM
+ * @leftover: details about the leftover protected VM that needs a clean up
+ * @rc: the RC code of the Destroy Secure Configuration UVC
+ * @rrc: the RRC code of the Destroy Secure Configuration UVC
+ *
+ * Destroy one leftover protected VM.
+ * On success, kvm->mm->context.protected_count will be decremented atomically
+ * and all other resources used by the VM will be freed.
+ *
+ * Return: 0 in case of success, otherwise 1
+ */
+static int kvm_s390_pv_dispose_one_leftover(struct kvm *kvm,
+					    struct pv_vm_to_be_destroyed *leftover,
+					    u16 *rc, u16 *rrc)
 {
 	int cc;
 
-	cc = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
-			   UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
-	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
+	cc = uv_cmd_nodata(leftover->handle, UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
+	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY LEFTOVER VM: rc %x rrc %x", *rc, *rrc);
+	WARN_ONCE(cc, "protvirt destroy leftover vm failed rc %x rrc %x", *rc, *rrc);
+	if (cc)
+		return cc;
 	/*
-	 * if the mm still has a mapping, make all its pages accessible
-	 * before destroying the guest
+	 * Intentionally leak unusable memory. If the UVC fails, the memory
+	 * used for the VM and its metadata is permanently unusable.
+	 * This can only happen in case of a serious KVM or hardware bug; it
+	 * is not expected to happen in normal operation.
 	 */
-	if (mmget_not_zero(kvm->mm)) {
-		s390_uv_destroy_range(kvm->mm, 0, TASK_SIZE);
-		mmput(kvm->mm);
+	free_pages(leftover->stor_base, get_order(uv_info.guest_base_stor_len));
+	free_pages(leftover->old_gmap_table, CRST_ALLOC_ORDER);
+	vfree(leftover->stor_var);
+	atomic_dec(&kvm->mm->context.protected_count);
+	return 0;
+}
+
+/**
+ * kvm_s390_destroy_lower_2g - Destroy the first 2GB of protected guest memory.
+ * @kvm: the VM whose memory is to be cleared.
+ *
+ * Destroy the first 2GB of guest memory, to avoid prefix issues after reboot.
+ * The CPUs of the protected VM need to be destroyed beforehand.
+ */
+static void kvm_s390_destroy_lower_2g(struct kvm *kvm)
+{
+	const unsigned long pages_2g = SZ_2G / PAGE_SIZE;
+	struct kvm_memory_slot *slot;
+	unsigned long len;
+	int srcu_idx;
+
+	srcu_idx = srcu_read_lock(&kvm->srcu);
+
+	/* Take the memslot containing guest absolute address 0 */
+	slot = gfn_to_memslot(kvm, 0);
+	/* Clear all slots or parts thereof that are below 2GB */
+	while (slot && slot->base_gfn < pages_2g) {
+		len = min_t(u64, slot->npages, pages_2g - slot->base_gfn) * PAGE_SIZE;
+		s390_uv_destroy_range(kvm->mm, slot->userspace_addr, slot->userspace_addr + len);
+		/* Take the next memslot */
+		slot = gfn_to_memslot(kvm, slot->base_gfn + slot->npages);
+	}
+
+	srcu_read_unlock(&kvm->srcu, srcu_idx);
+}
+
+/**
+ * kvm_s390_pv_set_aside - Set aside a protected VM for later teardown.
+ * @kvm: the VM
+ * @rc: return value for the RC field of the UVCB
+ * @rrc: return value for the RRC field of the UVCB
+ *
+ * Set aside the protected VM for a subsequent teardown. The VM will be able
+ * to continue immediately as a non-secure VM, and the information needed to
+ * properly tear down the protected VM is set aside. If another protected VM
+ * was already set aside without starting its teardown, this function will
+ * fail.
+ * The CPUs of the protected VM need to be destroyed beforehand.
+ *
+ * Context: kvm->lock needs to be held
+ *
+ * Return: 0 in case of success, -EINVAL if another protected VM was already set
+ * aside, -ENOMEM if the system ran out of memory.
+ */
+int kvm_s390_pv_set_aside(struct kvm *kvm, u16 *rc, u16 *rrc)
+{
+	struct pv_vm_to_be_destroyed *priv;
+
+	/*
+	 * If another protected VM was already prepared, refuse.
+	 * A normal deinitialization has to be performed instead.
+	 */
+	if (kvm->arch.pv.set_aside)
+		return -EINVAL;
+	priv = kmalloc(sizeof(*priv), GFP_KERNEL | __GFP_ZERO);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->stor_var = kvm->arch.pv.stor_var;
+	priv->stor_base = kvm->arch.pv.stor_base;
+	priv->handle = kvm_s390_pv_get_handle(kvm);
+	priv->old_gmap_table = (unsigned long)kvm->arch.gmap->table;
+	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
+	if (s390_replace_asce(kvm->arch.gmap)) {
+		kfree(priv);
+		return -ENOMEM;
 	}
 
+	kvm_s390_destroy_lower_2g(kvm);
+	kvm_s390_clear_pv_state(kvm);
+	kvm->arch.pv.set_aside = priv;
+
+	*rc = 1;
+	*rrc = 42;
+	return 0;
+}
+
+/**
+ * kvm_s390_pv_deinit_vm - Deinitialize the current protected VM
+ * @kvm: the KVM whose protected VM needs to be deinitialized
+ * @rc: the RC code of the UVC
+ * @rrc: the RRC code of the UVC
+ *
+ * Deinitialize the current protected VM. This function will destroy and
+ * cleanup the current protected VM, but it will not cleanup the guest
+ * memory. This function should only be called when the protected VM has
+ * just been created and therefore does not have any guest memory, or when
+ * the caller cleans up the guest memory separately.
+ *
+ * This function should not fail, but if it does, the donated memory must
+ * not be freed.
+ *
+ * Context: kvm->lock needs to be held
+ *
+ * Return: 0 in case of success, otherwise -EIO
+ */
+int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
+{
+	int cc;
+
+	cc = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
+			   UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
+	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
 	if (!cc) {
 		atomic_dec(&kvm->mm->context.protected_count);
 		kvm_s390_pv_dealloc_vm(kvm);
@@ -189,6 +338,127 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	return cc ? -EIO : 0;
 }
 
+/**
+ * kvm_s390_pv_deinit_cleanup_all - Clean up all protected VMs associated
+ * with a specific KVM.
+ * @kvm: the KVM to be cleaned up
+ * @rc: the RC code of the first failing UVC
+ * @rrc: the RRC code of the first failing UVC
+ *
+ * This function will clean up all protected VMs associated with a KVM.
+ * This includes the active one, the one prepared for deinitialization with
+ * kvm_s390_pv_set_aside, and any still pending in the need_cleanup list.
+ *
+ * Context: kvm->lock needs to be held unless being called from
+ * kvm_arch_destroy_vm.
+ *
+ * Return: 0 if all VMs are successfully cleaned up, otherwise -EIO
+ */
+int kvm_s390_pv_deinit_cleanup_all(struct kvm *kvm, u16 *rc, u16 *rrc)
+{
+	struct pv_vm_to_be_destroyed *cur;
+	bool need_zap = false;
+	u16 _rc, _rrc;
+	int cc = 0;
+
+	/* Make sure the counter does not reach 0 before calling s390_uv_destroy_range */
+	atomic_inc(&kvm->mm->context.protected_count);
+
+	*rc = 1;
+	/* If the current VM is protected, destroy it */
+	if (kvm_s390_pv_get_handle(kvm)) {
+		cc = kvm_s390_pv_deinit_vm(kvm, rc, rrc);
+		need_zap = true;
+	}
+
+	/* If a previous protected VM was set aside, put it in the need_cleanup list */
+	if (kvm->arch.pv.set_aside) {
+		list_add(kvm->arch.pv.set_aside, &kvm->arch.pv.need_cleanup);
+		kvm->arch.pv.set_aside = NULL;
+	}
+
+	/* Cleanup all protected VMs in the need_cleanup list */
+	while (!list_empty(&kvm->arch.pv.need_cleanup)) {
+		cur = list_first_entry(&kvm->arch.pv.need_cleanup, typeof(*cur), list);
+		need_zap = true;
+		if (kvm_s390_pv_dispose_one_leftover(kvm, cur, &_rc, &_rrc)) {
+			cc = 1;
+			/* do not overwrite a previous error code */
+			if (*rc == 1) {
+				*rc = _rc;
+				*rrc = _rrc;
+			}
+		}
+		list_del(&cur->list);
+		kfree(cur);
+	}
+
+	/*
+	 * If the mm still has a mapping, try to mark all its pages as
+	 * accessible. The counter should not reach zero before this
+	 * cleanup has been performed.
+	 */
+	if (need_zap && mmget_not_zero(kvm->mm)) {
+		s390_uv_destroy_range(kvm->mm, 0, TASK_SIZE);
+		mmput(kvm->mm);
+	}
+
+	/* Now the counter can safely reach 0 */
+	atomic_dec(&kvm->mm->context.protected_count);
+	return cc ? -EIO : 0;
+}
+
+/**
+ * kvm_s390_pv_deinit_aside_vm - Teardown a previously set aside protected VM.
+ * @kvm the VM previously associated with the protected VM
+ * @rc return value for the RC field of the UVCB
+ * @rrc return value for the RRC field of the UVCB
+ *
+ * Tear down the protected VM that had been previously set aside using
+ * kvm_s390_pv_set_aside_vm. Ideally this should be called by
+ * userspace asynchronously from a separate thread.
+ *
+ * Context: kvm->lock must not be held.
+ *
+ * Return: 0 in case of success, -EINVAL if no protected VM had been
+ * prepared for asynchronous teardowm, -EIO in case of other errors.
+ */
+int kvm_s390_pv_deinit_aside_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
+{
+	struct pv_vm_to_be_destroyed *p;
+	int ret = 0;
+
+	lockdep_assert_not_held(&kvm->lock);
+	mutex_lock(&kvm->lock);
+	p = kvm->arch.pv.set_aside;
+	kvm->arch.pv.set_aside = NULL;
+	mutex_unlock(&kvm->lock);
+	if (!p)
+		return -EINVAL;
+
+	/* When a fatal signal is received, stop immediately */
+	if (s390_uv_destroy_range_interruptible(kvm->mm, 0, TASK_SIZE_MAX))
+		goto done;
+	if (kvm_s390_pv_dispose_one_leftover(kvm, p, rc, rrc))
+		ret = -EIO;
+	kfree(p);
+	p = NULL;
+done:
+	/*
+	 * p is not NULL if we aborted because of a fatal signal, in which
+	 * case queue the leftover for later cleanup.
+	 */
+	if (p) {
+		mutex_lock(&kvm->lock);
+		list_add(&p->list, &kvm->arch.pv.need_cleanup);
+		mutex_unlock(&kvm->lock);
+		/* Did not finish, but pretend things went well */
+		*rc = 1;
+		*rrc = 42;
+	}
+	return ret;
+}
+
 static void kvm_s390_pv_mmu_notifier_release(struct mmu_notifier *subscription,
 					     struct mm_struct *mm)
 {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index eed0315a77a6..02602c5c1975 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1739,6 +1739,8 @@ enum pv_cmd_id {
 	KVM_PV_UNSHARE_ALL,
 	KVM_PV_INFO,
 	KVM_PV_DUMP,
+	KVM_PV_ASYNC_CLEANUP_PREPARE,
+	KVM_PV_ASYNC_CLEANUP_PERFORM,
 };
 
 struct kvm_pv_cmd {
-- 
2.37.1

