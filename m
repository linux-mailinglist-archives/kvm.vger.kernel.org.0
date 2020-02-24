Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86DA616A542
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 12:41:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbgBXLlp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 06:41:45 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4144 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727421AbgBXLlQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Feb 2020 06:41:16 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01OBdgrG094473;
        Mon, 24 Feb 2020 06:41:15 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yax44adc0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 06:41:15 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01OBeA6n095889;
        Mon, 24 Feb 2020 06:41:14 -0500
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yax44adbj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 06:41:14 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01OBdol5030261;
        Mon, 24 Feb 2020 11:41:13 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma01dal.us.ibm.com with ESMTP id 2yaux6fwd6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 11:41:13 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01OBfBPj44958000
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 11:41:11 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ABF9F28058;
        Mon, 24 Feb 2020 11:41:11 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8FAF428059;
        Mon, 24 Feb 2020 11:41:11 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 24 Feb 2020 11:41:11 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [PATCH v4 18/36] KVM: S390: protvirt: Introduce instruction data area bounce buffer
Date:   Mon, 24 Feb 2020 06:40:49 -0500
Message-Id: <20200224114107.4646-19-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200224114107.4646-1-borntraeger@de.ibm.com>
References: <20200224114107.4646-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-24_02:2020-02-21,2020-02-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 mlxlogscore=999 suspectscore=2 spamscore=0 priorityscore=1501
 impostorscore=0 mlxscore=0 malwarescore=0 phishscore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240099
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Now that we can't access guest memory anymore, we have a dedicated
satellite block that's a bounce buffer for instruction data.

We re-use the memop interface to copy the instruction data to / from
userspace. This lets us re-use a lot of QEMU code which used that
interface to make logical guest memory accesses which are not possible
anymore in protected mode anyway.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
[borntraeger@de.ibm.com: patch merging, splitting, fixing]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/include/asm/kvm_host.h | 11 +++++-
 arch/s390/kvm/kvm-s390.c         | 65 ++++++++++++++++++++++++++++----
 arch/s390/kvm/pv.c               | 11 ++++++
 include/uapi/linux/kvm.h         |  9 ++++-
 4 files changed, 85 insertions(+), 11 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 4fcbb055a565..aa945b101fff 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -127,6 +127,12 @@ struct mcck_volatile_info {
 #define CR14_INITIAL_MASK (CR14_UNUSED_32 | CR14_UNUSED_33 | \
 			   CR14_EXTERNAL_DAMAGE_SUBMASK)
 
+#define SIDAD_SIZE_MASK		0xff
+#define sida_origin(sie_block) \
+	((sie_block)->sidad & PAGE_MASK)
+#define sida_size(sie_block) \
+	((((sie_block)->sidad & SIDAD_SIZE_MASK) + 1) * PAGE_SIZE)
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
+		__u64	gbea;		/* 0x0180 */
+		__u64	sidad;
+	};
 	__u8    reserved188[8];		/* 0x0188 */
 	__u64   sdnxo;			/* 0x0190 */
 	__u8    reserved198[8];		/* 0x0198 */
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 93bf8f103f05..67a746b0f8b9 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4492,12 +4492,40 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 	return r;
 }
 
+static long kvm_s390_guest_sida_op(struct kvm_vcpu *vcpu,
+				   struct kvm_s390_mem_op *mop)
+{
+	void __user *uaddr = (void __user *)mop->buf;
+	int r = 0;
+
+	if (mop->flags || !mop->size)
+		return -EINVAL;
+	if (mop->size + mop->sida_offset < mop->size)
+		return -EINVAL;
+	if (mop->size + mop->sida_offset > sida_size(vcpu->arch.sie_block))
+		return -E2BIG;
+
+	switch (mop->op) {
+	case KVM_S390_MEMOP_SIDA_READ:
+		if (copy_to_user(uaddr, (void *)(sida_origin(vcpu->arch.sie_block) +
+				 mop->sida_offset), mop->size))
+			r = -EFAULT;
+
+		break;
+	case KVM_S390_MEMOP_SIDA_WRITE:
+		if (copy_from_user((void *)(sida_origin(vcpu->arch.sie_block) +
+				   mop->sida_offset), uaddr, mop->size))
+			r = -EFAULT;
+		break;
+	}
+	return r;
+}
 static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 				  struct kvm_s390_mem_op *mop)
 {
 	void __user *uaddr = (void __user *)mop->buf;
 	void *tmpbuf = NULL;
-	int r, srcu_idx;
+	int r = 0;
 	const u64 supported_flags = KVM_S390_MEMOP_F_INJECT_EXCEPTION
 				    | KVM_S390_MEMOP_F_CHECK_ONLY;
 
@@ -4512,8 +4540,8 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 		if (!tmpbuf)
 			return -ENOMEM;
 	}
-
-	srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+	if (kvm_s390_pv_cpu_is_protected(vcpu))
+		return -EINVAL;
 
 	switch (mop->op) {
 	case KVM_S390_MEMOP_LOGICAL_READ:
@@ -4540,12 +4568,8 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 		}
 		r = write_guest(vcpu, mop->gaddr, mop->ar, tmpbuf, mop->size);
 		break;
-	default:
-		r = -EINVAL;
 	}
 
-	srcu_read_unlock(&vcpu->kvm->srcu, srcu_idx);
-
 	if (r > 0 && (mop->flags & KVM_S390_MEMOP_F_INJECT_EXCEPTION) != 0)
 		kvm_s390_inject_prog_irq(vcpu, &vcpu->arch.pgm);
 
@@ -4553,6 +4577,31 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 	return r;
 }
 
+static long kvm_s390_guest_memsida_op(struct kvm_vcpu *vcpu,
+				      struct kvm_s390_mem_op *mop)
+{
+	int r, srcu_idx;
+
+	srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+
+	switch (mop->op) {
+	case KVM_S390_MEMOP_LOGICAL_READ:
+	case KVM_S390_MEMOP_LOGICAL_WRITE:
+		r = kvm_s390_guest_mem_op(vcpu, mop);
+		break;
+	case KVM_S390_MEMOP_SIDA_READ:
+	case KVM_S390_MEMOP_SIDA_WRITE:
+		/* we are locked against sida going away by the vcpu->mutex */
+		r = kvm_s390_guest_sida_op(vcpu, mop);
+		break;
+	default:
+		r = -EINVAL;
+	}
+
+	srcu_read_unlock(&vcpu->kvm->srcu, srcu_idx);
+	return r;
+}
+
 long kvm_arch_vcpu_async_ioctl(struct file *filp,
 			       unsigned int ioctl, unsigned long arg)
 {
@@ -4683,7 +4732,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		struct kvm_s390_mem_op mem_op;
 
 		if (copy_from_user(&mem_op, argp, sizeof(mem_op)) == 0)
-			r = kvm_s390_guest_mem_op(vcpu, &mem_op);
+			r = kvm_s390_guest_memsida_op(vcpu, &mem_op);
 		else
 			r = -EFAULT;
 		break;
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 014e53a41ead..cd81a58349a9 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -33,10 +33,13 @@ int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
 	if (!cc)
 		free_pages(vcpu->arch.pv.stor_base,
 			   get_order(uv_info.guest_cpu_stor_len));
+
+	free_page(sida_origin(vcpu->arch.sie_block));
 	vcpu->arch.sie_block->pv_handle_cpu = 0;
 	vcpu->arch.sie_block->pv_handle_config = 0;
 	memset(&vcpu->arch.pv, 0, sizeof(vcpu->arch.pv));
 	vcpu->arch.sie_block->sdf = 0;
+	vcpu->arch.sie_block->gbea = 1;
 	kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
 
 	return cc;
@@ -64,6 +67,14 @@ int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
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
 	cc = uv_call(0, (u64)&uvcb);
 	*rc = uvcb.header.rc;
 	*rrc = uvcb.header.rrc;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index ad69817f7792..f4cac1c09e97 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -474,12 +474,17 @@ struct kvm_s390_mem_op {
 	__u32 size;		/* amount of bytes */
 	__u32 op;		/* type of operation */
 	__u64 buf;		/* buffer in userspace */
-	__u8 ar;		/* the access register number */
-	__u8 reserved[31];	/* should be set to 0 */
+	union {
+		__u8 ar;	/* the access register number */
+		__u32 sida_offset; /* offset into the sida */
+		__u8 reserved[32]; /* should be set to 0 */
+	};
 };
 /* types for kvm_s390_mem_op->op */
 #define KVM_S390_MEMOP_LOGICAL_READ	0
 #define KVM_S390_MEMOP_LOGICAL_WRITE	1
+#define KVM_S390_MEMOP_SIDA_READ	2
+#define KVM_S390_MEMOP_SIDA_WRITE	3
 /* flags for kvm_s390_mem_op->flags */
 #define KVM_S390_MEMOP_F_CHECK_ONLY		(1ULL << 0)
 #define KVM_S390_MEMOP_F_INJECT_EXCEPTION	(1ULL << 1)
-- 
2.25.0

