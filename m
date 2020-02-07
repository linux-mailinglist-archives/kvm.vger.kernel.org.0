Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C17D61556D6
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 12:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgBGLkI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 06:40:08 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36134 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727031AbgBGLkH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 06:40:07 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 017Baagw089158;
        Fri, 7 Feb 2020 06:40:06 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y0n7h8646-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Feb 2020 06:40:05 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 017Bb5Va090432;
        Fri, 7 Feb 2020 06:40:05 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y0n7h863r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Feb 2020 06:40:05 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 017BcnBt026919;
        Fri, 7 Feb 2020 11:40:04 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02dal.us.ibm.com with ESMTP id 2xykca1y7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Feb 2020 11:40:04 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 017Be2KU50266450
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Feb 2020 11:40:02 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F2BEAC062;
        Fri,  7 Feb 2020 11:40:02 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A8BBAC05F;
        Fri,  7 Feb 2020 11:40:02 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  7 Feb 2020 11:40:02 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [PATCH 19/35] KVM: S390: protvirt: Introduce instruction data area bounce buffer
Date:   Fri,  7 Feb 2020 06:39:42 -0500
Message-Id: <20200207113958.7320-20-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200207113958.7320-1-borntraeger@de.ibm.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-07_01:2020-02-07,2020-02-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 adultscore=0 suspectscore=2 priorityscore=1501 malwarescore=0 phishscore=0
 mlxscore=0 clxscore=1015 spamscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002070089
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
 arch/s390/include/asm/kvm_host.h | 11 ++++++++-
 arch/s390/kvm/kvm-s390.c         | 42 ++++++++++++++++++++++++++++++++
 arch/s390/kvm/pv.c               |  9 +++++++
 include/uapi/linux/kvm.h         |  6 ++++-
 4 files changed, 66 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 9d7b248dcadc..05949ff75a1e 100644
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
+		__u64	gbea;		/* 0x0180 */
+		__u64	sidad;
+	};
 	__u8    reserved188[8];		/* 0x0188 */
 	__u64   sdnxo;			/* 0x0190 */
 	__u8    reserved198[8];		/* 0x0198 */
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 6f90d16cad92..1797490e3e77 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4435,6 +4435,34 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
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
@@ -4444,6 +4472,7 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 	const u64 supported_flags = KVM_S390_MEMOP_F_INJECT_EXCEPTION
 				    | KVM_S390_MEMOP_F_CHECK_ONLY;
 
+	BUILD_BUG_ON(sizeof(*mop) != 64);
 	if (mop->flags & ~supported_flags || mop->ar >= NUM_ACRS || !mop->size)
 		return -EINVAL;
 
@@ -4460,6 +4489,10 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 
 	switch (mop->op) {
 	case KVM_S390_MEMOP_LOGICAL_READ:
+		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
+			r = -EINVAL;
+			break;
+		}
 		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
 			r = check_gva_range(vcpu, mop->gaddr, mop->ar,
 					    mop->size, GACC_FETCH);
@@ -4472,6 +4505,10 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 		}
 		break;
 	case KVM_S390_MEMOP_LOGICAL_WRITE:
+		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
+			r = -EINVAL;
+			break;
+		}
 		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
 			r = check_gva_range(vcpu, mop->gaddr, mop->ar,
 					    mop->size, GACC_STORE);
@@ -4483,6 +4520,11 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 		}
 		r = write_guest(vcpu, mop->gaddr, mop->ar, tmpbuf, mop->size);
 		break;
+	case KVM_S390_MEMOP_SIDA_READ:
+	case KVM_S390_MEMOP_SIDA_WRITE:
+		/* we are locked against sida going away by the vcpu->mutex */
+		r = kvm_s390_guest_sida_op(vcpu, mop);
+		break;
 	default:
 		r = -EINVAL;
 	}
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 392795a92bd9..70e452192468 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -93,6 +93,7 @@ int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu)
 
 	free_pages(vcpu->arch.pv.stor_base,
 		   get_order(uv_info.guest_cpu_stor_len));
+	free_page(sida_origin(vcpu->arch.sie_block));
 	vcpu->arch.sie_block->pv_handle_cpu = 0;
 	vcpu->arch.sie_block->pv_handle_config = 0;
 	memset(&vcpu->arch.pv, 0, sizeof(vcpu->arch.pv));
@@ -122,6 +123,14 @@ int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu)
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
index eab741bc12c3..51d4018c3be3 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -475,11 +475,15 @@ struct kvm_s390_mem_op {
 	__u32 op;		/* type of operation */
 	__u64 buf;		/* buffer in userspace */
 	__u8 ar;		/* the access register number */
-	__u8 reserved[31];	/* should be set to 0 */
+	__u8 reserved21[3];	/* should be set to 0 */
+	__u32 sida_offset;	/* offset into the sida */
+	__u8 reserved28[24];	/* should be set to 0 */
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
2.24.0

