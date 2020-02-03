Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3CC31506F2
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 14:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgBCNUo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 08:20:44 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53428 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728298AbgBCNUJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Feb 2020 08:20:09 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 013DG2cI105261
        for <kvm@vger.kernel.org>; Mon, 3 Feb 2020 08:20:08 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xx3cya4dn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2020 08:20:08 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 013DGTMB109012
        for <kvm@vger.kernel.org>; Mon, 3 Feb 2020 08:20:07 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xx3cya4cu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 08:20:07 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 013DHjn4007841;
        Mon, 3 Feb 2020 13:20:06 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02wdc.us.ibm.com with ESMTP id 2xw0y6109d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 13:20:06 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 013DK57m53871076
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Feb 2020 13:20:05 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F06D2806F;
        Mon,  3 Feb 2020 13:20:05 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B05628058;
        Mon,  3 Feb 2020 13:20:05 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  3 Feb 2020 13:20:04 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [RFCv2 21/37] KVM: S390: protvirt: Introduce instruction data area bounce buffer
Date:   Mon,  3 Feb 2020 08:19:41 -0500
Message-Id: <20200203131957.383915-22-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200203131957.383915-1-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-03_04:2020-02-02,2020-02-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 impostorscore=0 clxscore=1015 mlxlogscore=999 priorityscore=1501
 suspectscore=2 lowpriorityscore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2002030099
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Now that we can't access guest memory anymore, we have a dedicated
sattelite block that's a bounce buffer for instruction data.

We re-use the memop interface to copy the instruction data to / from
userspace. This lets us re-use a lot of QEMU code which used that
interface to make logical guest memory accesses which are not possible
anymore in protected mode anyway.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h | 11 ++++++-
 arch/s390/kvm/kvm-s390.c         | 49 ++++++++++++++++++++++++++++++++
 arch/s390/kvm/pv.c               |  9 ++++++
 include/uapi/linux/kvm.h         | 11 +++++--
 4 files changed, 77 insertions(+), 3 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 125511ec6eb0..48f382680755 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -127,6 +127,12 @@ struct mcck_volatile_info {
 #define CR14_INITIAL_MASK (CR14_UNUSED_32 | CR14_UNUSED_33 | \
 			   CR14_EXTERNAL_DAMAGE_SUBMASK)
 
+#define SIDAD_SIZE_MASK		0xff
+#define sida_origin(sie_block) \
+	(sie_block->sidad & PAGE_MASK)
+#define sida_size(sie_block) \
+	(((sie_block->sidad & SIDAD_SIZE_MASK) + 1) * PAGE_SIZE)
+
 #define CPUSTAT_STOPPED    0x80000000
 #define CPUSTAT_WAIT       0x10000000
 #define CPUSTAT_ECALL_PEND 0x08000000
@@ -315,7 +321,10 @@ struct kvm_s390_sie_block {
 #define CRYCB_FORMAT2 0x00000003
 	__u32	crycbd;			/* 0x00fc */
 	__u64	gcr[16];		/* 0x0100 */
-	__u64	gbea;			/* 0x0180 */
+	union {
+		__u64	gbea;			/* 0x0180 */
+		__u64	sidad;
+	};
 	__u8    reserved188[8];		/* 0x0188 */
 	__u64   sdnxo;			/* 0x0190 */
 	__u8    reserved198[8];		/* 0x0198 */
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 1945180b857a..76303b0f1226 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4441,6 +4441,8 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 	const u64 supported_flags = KVM_S390_MEMOP_F_INJECT_EXCEPTION
 				    | KVM_S390_MEMOP_F_CHECK_ONLY;
 
+
+	BUILD_BUG_ON(sizeof(*mop) != 64);
 	if (mop->flags & ~supported_flags || mop->ar >= NUM_ACRS || !mop->size)
 		return -EINVAL;
 
@@ -4522,6 +4524,39 @@ long kvm_arch_vcpu_async_ioctl(struct file *filp,
 }
 
 #ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
+static long kvm_s390_guest_sida_op(struct kvm_vcpu *vcpu,
+				   struct kvm_s390_mem_op *mop)
+{
+	int r = 0;
+	void __user *uaddr = (void __user *)mop->buf;
+
+	if (mop->flags || !mop->size)
+		return -EINVAL;
+
+	if (mop->size > sida_size(vcpu->arch.sie_block))
+		return -E2BIG;
+
+	if (mop->size + mop->offset > sida_size(vcpu->arch.sie_block))
+		return -E2BIG;
+
+	switch (mop->op) {
+	case KVM_S390_MEMOP_SIDA_READ:
+		r = 0;
+		if (copy_to_user(uaddr, (void *)sida_origin(vcpu->arch.sie_block) +
+				 mop->offset, mop->size))
+			r = -EFAULT;
+
+		break;
+	case KVM_S390_MEMOP_SIDA_WRITE:
+		r = 0;
+		if (copy_from_user((void *)vcpu->arch.sie_block->sidad +
+				   mop->offset, uaddr, mop->size))
+			r = -EFAULT;
+		break;
+	}
+	return r;
+}
+
 static int kvm_s390_handle_pv_vcpu(struct kvm_vcpu *vcpu,
 				   struct kvm_pv_cmd *cmd)
 {
@@ -4708,6 +4743,20 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r = kvm_s390_handle_pv_vcpu(vcpu, &args);
 		break;
 	}
+	case KVM_S390_SIDA_OP: {
+		struct kvm_s390_mem_op mem_op;
+
+		if (!kvm_s390_pv_is_protected(vcpu->kvm)) {
+			r = -EINVAL;
+			break;
+		}
+
+		if (copy_from_user(&mem_op, argp, sizeof(mem_op)) == 0)
+			r = kvm_s390_guest_sida_op(vcpu, &mem_op);
+		else
+			r = -EFAULT;
+		break;
+	}
 #endif
 	default:
 		r = -ENOTTY;
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 24d802072ac7..50e1dc68d972 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -93,6 +93,7 @@ int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu)
 
 	free_pages(vcpu->arch.pv.stor_base,
 		   get_order(uv_info.guest_cpu_stor_len));
+	free_page(sida_origin(vcpu->arch.sie_block));
 	/* Clear cpu and vm handle */
 	memset(&vcpu->arch.sie_block->reserved10, 0,
 	       sizeof(vcpu->arch.sie_block->reserved10));
@@ -124,6 +125,14 @@ int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu)
 	uvcb.state_origin = (u64)vcpu->arch.sie_block;
 	uvcb.stor_origin = (u64)vcpu->arch.pv.stor_base;
 
+	/* Alloc Secure Instruction Data Area Designation */
+	vcpu->arch.sie_block->sidad = __get_free_page(GFP_KERNEL | __GFP_ZERO);
+	if (!vcpu->arch.sie_block->sidad) {
+		free_pages(vcpu->arch.pv.stor_base,
+			   get_order(uv_info.guest_cpu_stor_len));
+		return -ENOMEM;
+	}
+
 	rc = uv_call(0, (u64)&uvcb);
 	VCPU_EVENT(vcpu, 3, "PROTVIRT CREATE VCPU: cpu %d handle %llx rc %x rrc %x",
 		   vcpu->vcpu_id, uvcb.cpu_handle, uvcb.header.rc,
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index eab741bc12c3..20969ce12096 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -466,7 +466,7 @@ struct kvm_translation {
 	__u8  pad[5];
 };
 
-/* for KVM_S390_MEM_OP */
+/* for KVM_S390_MEM_OP and KVM_S390_SIDA_OP */
 struct kvm_s390_mem_op {
 	/* in */
 	__u64 gaddr;		/* the guest address */
@@ -475,11 +475,17 @@ struct kvm_s390_mem_op {
 	__u32 op;		/* type of operation */
 	__u64 buf;		/* buffer in userspace */
 	__u8 ar;		/* the access register number */
-	__u8 reserved[31];	/* should be set to 0 */
+	__u8 reserved21[3];	/* should be set to 0 */
+	__u32 offset;		/* offset into the sida */
+	__u8 reserved28[24];	/* should be set to 0 */
 };
+
+
 /* types for kvm_s390_mem_op->op */
 #define KVM_S390_MEMOP_LOGICAL_READ	0
 #define KVM_S390_MEMOP_LOGICAL_WRITE	1
+#define KVM_S390_MEMOP_SIDA_READ	2
+#define KVM_S390_MEMOP_SIDA_WRITE	3
 /* flags for kvm_s390_mem_op->flags */
 #define KVM_S390_MEMOP_F_CHECK_ONLY		(1ULL << 0)
 #define KVM_S390_MEMOP_F_INJECT_EXCEPTION	(1ULL << 1)
@@ -1510,6 +1516,7 @@ struct kvm_pv_cmd {
 /* Available with KVM_CAP_S390_PROTECTED */
 #define KVM_S390_PV_COMMAND		_IOW(KVMIO, 0xc5, struct kvm_pv_cmd)
 #define KVM_S390_PV_COMMAND_VCPU	_IOW(KVMIO, 0xc6, struct kvm_pv_cmd)
+#define KVM_S390_SIDA_OP		_IOW(KVMIO, 0xc7, struct kvm_s390_mem_op)
 
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
-- 
2.24.0

