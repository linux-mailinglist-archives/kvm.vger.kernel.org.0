Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E551717DB97
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 09:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgCIIvn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 04:51:43 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6018 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726659AbgCIIvm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Mar 2020 04:51:42 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0298oPcW056644
        for <kvm@vger.kernel.org>; Mon, 9 Mar 2020 04:51:40 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ym8k7cx7j-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 04:51:40 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 9 Mar 2020 08:51:38 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 9 Mar 2020 08:51:35 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0298pXmX54788146
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Mar 2020 08:51:34 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D01EB11C05C;
        Mon,  9 Mar 2020 08:51:33 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2FB811C052;
        Mon,  9 Mar 2020 08:51:33 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon,  9 Mar 2020 08:51:33 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 71320E0251; Mon,  9 Mar 2020 09:51:33 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Ulrich Weigand <uweigand@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL 18/36] KVM: S390: protvirt: Introduce instruction data area bounce buffer
Date:   Mon,  9 Mar 2020 09:51:08 +0100
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309085126.3334302-1-borntraeger@de.ibm.com>
References: <20200309085126.3334302-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20030908-0008-0000-0000-0000035AA7E0
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030908-0009-0000-0000-00004A7BE6E6
Message-Id: <20200309085126.3334302-19-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-09_02:2020-03-06,2020-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 bulkscore=0 priorityscore=1501 adultscore=0 suspectscore=2 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003090066
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
Reviewed-by: David Hildenbrand <david@redhat.com>
[borntraeger@de.ibm.com: patch merging, splitting, fixing]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/include/asm/kvm_host.h | 11 +++++-
 arch/s390/kvm/kvm-s390.c         | 66 ++++++++++++++++++++++++++++----
 arch/s390/kvm/pv.c               | 16 ++++++++
 include/uapi/linux/kvm.h         |  9 ++++-
 4 files changed, 91 insertions(+), 11 deletions(-)

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
index bd62312fdc0e..efbbcd2948a3 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4495,12 +4495,40 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
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
 
@@ -4510,14 +4538,15 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 	if (mop->size > MEM_OP_MAX_SIZE)
 		return -E2BIG;
 
+	if (kvm_s390_pv_cpu_is_protected(vcpu))
+		return -EINVAL;
+
 	if (!(mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY)) {
 		tmpbuf = vmalloc(mop->size);
 		if (!tmpbuf)
 			return -ENOMEM;
 	}
 
-	srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
-
 	switch (mop->op) {
 	case KVM_S390_MEMOP_LOGICAL_READ:
 		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
@@ -4543,12 +4572,8 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
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
 
@@ -4556,6 +4581,31 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
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
@@ -4686,7 +4736,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		struct kvm_s390_mem_op mem_op;
 
 		if (copy_from_user(&mem_op, argp, sizeof(mem_op)) == 0)
-			r = kvm_s390_guest_mem_op(vcpu, &mem_op);
+			r = kvm_s390_guest_memsida_op(vcpu, &mem_op);
 		else
 			r = -EFAULT;
 		break;
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 9840ee49e572..13a41533eacf 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -33,10 +33,18 @@ int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
 	if (!cc)
 		free_pages(vcpu->arch.pv.stor_base,
 			   get_order(uv_info.guest_cpu_stor_len));
+
+	free_page(sida_origin(vcpu->arch.sie_block));
 	vcpu->arch.sie_block->pv_handle_cpu = 0;
 	vcpu->arch.sie_block->pv_handle_config = 0;
 	memset(&vcpu->arch.pv, 0, sizeof(vcpu->arch.pv));
 	vcpu->arch.sie_block->sdf = 0;
+	/*
+	 * The sidad field (for sdf == 2) is now the gbea field (for sdf == 0).
+	 * Use the reset value of gbea to avoid leaking the kernel pointer of
+	 * the just freed sida.
+	 */
+	vcpu->arch.sie_block->gbea = 1;
 	kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
 
 	return cc ? EIO : 0;
@@ -64,6 +72,14 @@ int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
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
2.24.1

