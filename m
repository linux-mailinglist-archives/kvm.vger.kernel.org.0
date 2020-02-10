Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB1051573A4
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 12:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbgBJLpe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 06:45:34 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60768 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726950AbgBJLpd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Feb 2020 06:45:33 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01ABiJjJ062110;
        Mon, 10 Feb 2020 06:45:31 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y1tp147w3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Feb 2020 06:45:31 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01ABiTVx062650;
        Mon, 10 Feb 2020 06:45:31 -0500
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y1tp147vs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Feb 2020 06:45:31 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01ABj8X5006826;
        Mon, 10 Feb 2020 11:45:30 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma04wdc.us.ibm.com with ESMTP id 2y1mm68rn2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Feb 2020 11:45:30 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01ABjSX353608932
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Feb 2020 11:45:28 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F7F3124053;
        Mon, 10 Feb 2020 11:45:28 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5567D124052;
        Mon, 10 Feb 2020 11:45:28 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 10 Feb 2020 11:45:28 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     borntraeger@de.ibm.com
Cc:     Ulrich.Weigand@de.ibm.com, aarcange@redhat.com, cohuck@redhat.com,
        david@redhat.com, frankja@linux.ibm.com,
        frankja@linux.vnet.ibm.com, gor@linux.ibm.com,
        imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, mimu@linux.ibm.com, thuth@redhat.com
Subject: [PATCH/RFC] KVM: s390: protvirt: pass-through rc and rrc
Date:   Mon, 10 Feb 2020 06:45:26 -0500
Message-Id: <20200210114526.134769-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <62d5cd46-93d7-e272-f9bb-d4ec3c7a1f71@de.ibm.com>
References: <62d5cd46-93d7-e272-f9bb-d4ec3c7a1f71@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-10_02:2020-02-10,2020-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 spamscore=0 clxscore=1015 bulkscore=0 phishscore=0
 mlxscore=0 lowpriorityscore=0 suspectscore=3 adultscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002100093
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This would be one variant to get the RC/RRC to userspace.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 34 +++++++++++++++++++++++++---------
 arch/s390/kvm/kvm-s390.h | 15 ++++++++-------
 arch/s390/kvm/pv.c       | 30 ++++++++++++++++++++++--------
 include/uapi/linux/kvm.h |  4 ++--
 4 files changed, 57 insertions(+), 26 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index e1bccbb41fdd..8dae9629b47f 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2172,6 +2172,8 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 	int r = 0;
 	void __user *argp = (void __user *)cmd->data;
 
+	cmd->rc = 0;
+	cmd->rrc = 0;
 	switch (cmd->cmd) {
 	case KVM_PV_VM_CREATE: {
 		r = -EINVAL;
@@ -2192,7 +2194,7 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 			mutex_unlock(&kvm->lock);
 			break;
 		}
-		r = kvm_s390_pv_create_vm(kvm);
+		r = kvm_s390_pv_create_vm(kvm, cmd);
 		kvm_s390_vcpu_unblock_all(kvm);
 		mutex_unlock(&kvm->lock);
 		break;
@@ -2205,7 +2207,7 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 		/* All VCPUs have to be destroyed before this call. */
 		mutex_lock(&kvm->lock);
 		kvm_s390_vcpu_block_all(kvm);
-		r = kvm_s390_pv_destroy_vm(kvm);
+		r = kvm_s390_pv_destroy_vm(kvm, cmd);
 		if (!r)
 			kvm_s390_pv_dealloc_vm(kvm);
 		kvm_s390_vcpu_unblock_all(kvm);
@@ -2237,7 +2239,7 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 		r = -EFAULT;
 		if (!copy_from_user(hdr, (void __user *)parms.origin,
 				   parms.length))
-			r = kvm_s390_pv_set_sec_parms(kvm, hdr, parms.length);
+			r = kvm_s390_pv_set_sec_parms(kvm, hdr, parms.length, cmd);
 
 		vfree(hdr);
 		break;
@@ -2253,7 +2255,7 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 		if (copy_from_user(&unp, argp, sizeof(unp)))
 			break;
 
-		r = kvm_s390_pv_unpack(kvm, unp.addr, unp.size, unp.tweak);
+		r = kvm_s390_pv_unpack(kvm, unp.addr, unp.size, unp.tweak, cmd);
 		break;
 	}
 	case KVM_PV_VM_VERIFY: {
@@ -2268,6 +2270,8 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 				  &ret);
 		VM_EVENT(kvm, 3, "PROTVIRT VERIFY: rc %x rrc %x",
 			 ret >> 16, ret & 0x0000ffff);
+		cmd->rc = ret >> 16;
+		cmd->rrc = ret & 0xffff;
 		break;
 	}
 	default:
@@ -2385,6 +2389,10 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			break;
 
 		r = kvm_s390_handle_pv(kvm, &args);
+
+		if (copy_to_user(argp, &args, sizeof(args)))
+			r = -EFAULT;
+
 		break;
 	}
 	default:
@@ -2650,6 +2658,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
+	struct kvm_pv_cmd dummy;
+
 	VCPU_EVENT(vcpu, 3, "%s", "free cpu");
 	trace_kvm_s390_destroy_vcpu(vcpu->vcpu_id);
 	kvm_s390_clear_local_irqs(vcpu);
@@ -2663,7 +2673,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	if (vcpu->kvm->arch.use_cmma)
 		kvm_s390_vcpu_unsetup_cmma(vcpu);
 	if (kvm_s390_pv_handle_cpu(vcpu))
-		kvm_s390_pv_destroy_cpu(vcpu);
+		kvm_s390_pv_destroy_cpu(vcpu, &dummy);
 	free_page((unsigned long)(vcpu->arch.sie_block));
 
 	kvm_vcpu_uninit(vcpu);
@@ -2688,11 +2698,13 @@ static void kvm_free_vcpus(struct kvm *kvm)
 
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
+	struct kvm_pv_cmd dummy;
+
 	kvm_free_vcpus(kvm);
 	sca_dispose(kvm);
 	kvm_s390_gisa_destroy(kvm);
 	if (kvm_s390_pv_is_protected(kvm)) {
-		kvm_s390_pv_destroy_vm(kvm);
+		kvm_s390_pv_destroy_vm(kvm, &dummy);
 		kvm_s390_pv_dealloc_vm(kvm);
 	}
 	debug_unregister(kvm->arch.dbf);
@@ -3153,6 +3165,7 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 {
 	struct kvm_vcpu *vcpu;
 	struct sie_page *sie_page;
+	struct kvm_pv_cmd dummy;
 	int rc = -EINVAL;
 
 	if (!kvm_is_ucontrol(kvm) && !sca_can_add_vcpu(kvm, id))
@@ -3188,7 +3201,7 @@ struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 		goto out_free_sie_block;
 
 	if (kvm_s390_pv_is_protected(kvm)) {
-		rc = kvm_s390_pv_create_cpu(vcpu);
+		rc = kvm_s390_pv_create_cpu(vcpu, &dummy);
 		if (rc) {
 			kvm_vcpu_uninit(vcpu);
 			goto out_free_sie_block;
@@ -4511,19 +4524,22 @@ static int kvm_s390_handle_pv_vcpu(struct kvm_vcpu *vcpu,
 	if (!kvm_s390_pv_is_protected(vcpu->kvm))
 		return -EINVAL;
 
+	cmd->rc = 0;
+	cmd->rrc = 0;
+
 	switch (cmd->cmd) {
 	case KVM_PV_VCPU_CREATE: {
 		if (kvm_s390_pv_handle_cpu(vcpu))
 			return -EINVAL;
 
-		r = kvm_s390_pv_create_cpu(vcpu);
+		r = kvm_s390_pv_create_cpu(vcpu, cmd);
 		break;
 	}
 	case KVM_PV_VCPU_DESTROY: {
 		if (!kvm_s390_pv_handle_cpu(vcpu))
 			return -EINVAL;
 
-		r = kvm_s390_pv_destroy_cpu(vcpu);
+		r = kvm_s390_pv_destroy_cpu(vcpu, cmd);
 		break;
 	}
 	default:
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 32c0c01d5df0..b77d5f565b5c 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -199,14 +199,15 @@ static inline int kvm_s390_user_cpu_state_ctrl(struct kvm *kvm)
 /* implemented in pv.c */
 void kvm_s390_pv_dealloc_vm(struct kvm *kvm);
 int kvm_s390_pv_alloc_vm(struct kvm *kvm);
-int kvm_s390_pv_create_vm(struct kvm *kvm);
-int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu);
-int kvm_s390_pv_destroy_vm(struct kvm *kvm);
-int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu);
-int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length);
+int kvm_s390_pv_create_vm(struct kvm *kvm, struct kvm_pv_cmd *cmd);
+int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, struct kvm_pv_cmd *cmd);
+int kvm_s390_pv_destroy_vm(struct kvm *kvm, struct kvm_pv_cmd *cmd);
+int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, struct kvm_pv_cmd *cmd);
+int kvm_s390_pv_set_sec_parms(struct kvm *kvm, void *hdr, u64 length,
+			      struct kvm_pv_cmd *cmd);
 int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned long size,
-		       unsigned long tweak);
-int kvm_s390_pv_verify(struct kvm *kvm);
+		       unsigned long tweak, struct kvm_pv_cmd *cmd);
+int kvm_s390_pv_verify(struct kvm *kvm, struct kvm_pv_cmd *cmd);
 
 static inline bool kvm_s390_pv_is_protected(struct kvm *kvm)
 {
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index c1778cb3f8ac..381dc3fefac4 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -61,7 +61,7 @@ int kvm_s390_pv_alloc_vm(struct kvm *kvm)
 	return -ENOMEM;
 }
 
-int kvm_s390_pv_destroy_vm(struct kvm *kvm)
+int kvm_s390_pv_destroy_vm(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 {
 	int rc;
 	u32 ret;
@@ -72,10 +72,12 @@ int kvm_s390_pv_destroy_vm(struct kvm *kvm)
 	atomic_set(&kvm->mm->context.is_protected, 0);
 	VM_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x",
 		 ret >> 16, ret & 0x0000ffff);
+	cmd->rc = ret >> 16;
+	cmd->rrc = ret & 0xffff;
 	return rc;
 }
 
-int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu)
+int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, struct kvm_pv_cmd *cmd)
 {
 	int rc = 0;
 	u32 ret;
@@ -87,6 +89,8 @@ int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu)
 
 		VCPU_EVENT(vcpu, 3, "PROTVIRT DESTROY VCPU: cpu %d rc %x rrc %x",
 			   vcpu->vcpu_id, ret >> 16, ret & 0x0000ffff);
+		cmd->rc = ret >> 16;
+		cmd->rrc = ret & 0xffff;
 	}
 
 	free_pages(vcpu->arch.pv.stor_base,
@@ -98,7 +102,7 @@ int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu)
 	return rc;
 }
 
-int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu)
+int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, struct kvm_pv_cmd *cmd)
 {
 	int rc;
 	struct uv_cb_csc uvcb = {
@@ -124,9 +128,13 @@ int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu)
 	VCPU_EVENT(vcpu, 3, "PROTVIRT CREATE VCPU: cpu %d handle %llx rc %x rrc %x",
 		   vcpu->vcpu_id, uvcb.cpu_handle, uvcb.header.rc,
 		   uvcb.header.rrc);
+	cmd->rc = uvcb.header.rc;
+	cmd->rrc = uvcb.header.rrc;
 
 	if (rc) {
-		kvm_s390_pv_destroy_cpu(vcpu);
+		struct kvm_pv_cmd dummy;
+
+		kvm_s390_pv_destroy_cpu(vcpu, &dummy);
 		return -EINVAL;
 	}
 
@@ -138,7 +146,7 @@ int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-int kvm_s390_pv_create_vm(struct kvm *kvm)
+int kvm_s390_pv_create_vm(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 {
 	int rc;
 
@@ -162,12 +170,15 @@ int kvm_s390_pv_create_vm(struct kvm *kvm)
 	VM_EVENT(kvm, 3, "PROTVIRT CREATE VM: handle %llx len %llx rc %x rrc %x",
 		 uvcb.guest_handle, uvcb.guest_stor_len, uvcb.header.rc,
 		 uvcb.header.rrc);
+	cmd->rc = uvcb.header.rc;
+	cmd->rrc = uvcb.header.rrc;
 
 	/* Outputs */
 	kvm->arch.pv.handle = uvcb.guest_handle;
 
 	if (rc && (uvcb.header.rc & UVC_RC_NEED_DESTROY)) {
-		kvm_s390_pv_destroy_vm(kvm);
+		struct kvm_pv_cmd dummy;
+		kvm_s390_pv_destroy_vm(kvm, &dummy);
 		return -EINVAL;
 	}
 	kvm->arch.gmap->guest_handle = uvcb.guest_handle;
@@ -176,7 +187,7 @@ int kvm_s390_pv_create_vm(struct kvm *kvm)
 }
 
 int kvm_s390_pv_set_sec_parms(struct kvm *kvm,
-			      void *hdr, u64 length)
+			      void *hdr, u64 length, struct kvm_pv_cmd *cmd)
 {
 	int rc;
 	struct uv_cb_ssc uvcb = {
@@ -193,6 +204,9 @@ int kvm_s390_pv_set_sec_parms(struct kvm *kvm,
 	rc = uv_call(0, (u64)&uvcb);
 	VM_EVENT(kvm, 3, "PROTVIRT VM SET PARMS: rc %x rrc %x",
 		 uvcb.header.rc, uvcb.header.rrc);
+	cmd->rc = uvcb.header.rc;
+	cmd->rrc = uvcb.header.rrc;
+
 	if (rc)
 		return -EINVAL;
 	return 0;
@@ -219,7 +233,7 @@ static int unpack_one(struct kvm *kvm, unsigned long addr, u64 tweak[2])
 }
 
 int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned long size,
-		       unsigned long tweak)
+		       unsigned long tweak, struct kvm_pv_cmd *cmd)
 {
 	int rc = 0;
 	u64 tw[2] = {tweak, 0};
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index eab741bc12c3..17c1a9556eac 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1508,8 +1508,8 @@ struct kvm_pv_cmd {
 };
 
 /* Available with KVM_CAP_S390_PROTECTED */
-#define KVM_S390_PV_COMMAND		_IOW(KVMIO, 0xc5, struct kvm_pv_cmd)
-#define KVM_S390_PV_COMMAND_VCPU	_IOW(KVMIO, 0xc6, struct kvm_pv_cmd)
+#define KVM_S390_PV_COMMAND		_IOWR(KVMIO, 0xc5, struct kvm_pv_cmd)
+#define KVM_S390_PV_COMMAND_VCPU	_IOWR(KVMIO, 0xc6, struct kvm_pv_cmd)
 
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
-- 
2.24.0

