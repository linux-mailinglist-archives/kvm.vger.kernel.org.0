Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8303D165C06
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 11:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbgBTKlb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 05:41:31 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57376 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727681AbgBTKk3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Feb 2020 05:40:29 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01KAYm9l058183;
        Thu, 20 Feb 2020 05:40:28 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y8ubpkr6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Feb 2020 05:40:28 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01KAZ6ZI059223;
        Thu, 20 Feb 2020 05:40:28 -0500
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y8ubpkr69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Feb 2020 05:40:28 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01KAaf9M023851;
        Thu, 20 Feb 2020 10:40:27 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma04dal.us.ibm.com with ESMTP id 2y68976yte-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Feb 2020 10:40:27 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01KAeOUK53739922
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 10:40:24 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E845112072;
        Thu, 20 Feb 2020 10:40:24 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 66F7E112075;
        Thu, 20 Feb 2020 10:40:24 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 20 Feb 2020 10:40:24 +0000 (GMT)
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
Subject: [PATCH v3 19/37] KVM: S390: protvirt: Introduce instruction data area bounce buffer
Date:   Thu, 20 Feb 2020 05:40:02 -0500
Message-Id: <20200220104020.5343-20-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200220104020.5343-1-borntraeger@de.ibm.com>
References: <20200220104020.5343-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-20_02:2020-02-19,2020-02-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 priorityscore=1501 suspectscore=2 spamscore=0 bulkscore=0 impostorscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002200078
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
 arch/s390/kvm/pv.c               | 10 +++++
 include/uapi/linux/kvm.h         |  9 ++++-
 4 files changed, 84 insertions(+), 11 deletions(-)

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
index 4750f36dc16d..4f7d70157b2c 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4471,12 +4471,40 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
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
 
@@ -4491,8 +4519,8 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 		if (!tmpbuf)
 			return -ENOMEM;
 	}
-
-	srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+	if (kvm_s390_pv_cpu_is_protected(vcpu))
+		return -EINVAL;
 
 	switch (mop->op) {
 	case KVM_S390_MEMOP_LOGICAL_READ:
@@ -4519,12 +4547,8 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
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
 
@@ -4532,6 +4556,31 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
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
@@ -4662,7 +4711,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		struct kvm_s390_mem_op mem_op;
 
 		if (copy_from_user(&mem_op, argp, sizeof(mem_op)) == 0)
-			r = kvm_s390_guest_mem_op(vcpu, &mem_op);
+			r = kvm_s390_guest_memsida_op(vcpu, &mem_op);
 		else
 			r = -EFAULT;
 		break;
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 7d95d7437140..a9c7e97d98e1 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -93,10 +93,12 @@ void kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
 
 	free_pages(vcpu->arch.pv.stor_base,
 		   get_order(uv_info.guest_cpu_stor_len));
+	free_page(sida_origin(vcpu->arch.sie_block));
 	vcpu->arch.sie_block->pv_handle_cpu = 0;
 	vcpu->arch.sie_block->pv_handle_config = 0;
 	memset(&vcpu->arch.pv, 0, sizeof(vcpu->arch.pv));
 	vcpu->arch.sie_block->sdf = 0;
+	vcpu->arch.sie_block->gbea = 1;
 	kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
 }
 
@@ -122,6 +124,14 @@ int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
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
index efb5c4d65396..69ccbbabfc03 100644
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

