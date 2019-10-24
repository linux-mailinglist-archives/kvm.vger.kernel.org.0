Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11385E30D3
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 13:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409271AbfJXLm2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 07:42:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9824 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405117AbfJXLm1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Oct 2019 07:42:27 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9OBc18D108225
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 07:42:26 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vu9nxm16n-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 07:42:25 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 24 Oct 2019 12:42:23 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 24 Oct 2019 12:42:20 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9OBgJL751118270
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 11:42:19 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CFC5852051;
        Thu, 24 Oct 2019 11:42:18 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.131])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 4D98952050;
        Thu, 24 Oct 2019 11:42:17 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com, frankja@linux.ibm.com
Subject: [RFC 20/37] KVM: S390: protvirt: Introduce instruction data area bounce buffer
Date:   Thu, 24 Oct 2019 07:40:42 -0400
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024114059.102802-1-frankja@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19102411-4275-0000-0000-00000376D3D7
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102411-4276-0000-0000-00003889FDDC
Message-Id: <20191024114059.102802-21-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-24_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=756 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910240115
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that we can't access guest memory anymore, we have a dedicated
sattelite block that's a bounce buffer for instruction data.

We re-use the memop interface to copy the instruction data to / from
userspace. This lets us re-use a lot of QEMU code which used that
interface to make logical guest memory accesses which are not possible
anymore in protected mode anyway.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h |  5 ++++-
 arch/s390/kvm/kvm-s390.c         | 31 +++++++++++++++++++++++++++++++
 arch/s390/kvm/pv.c               |  9 +++++++++
 3 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 5deabf9734d9..2a8a1e21e1c3 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -308,7 +308,10 @@ struct kvm_s390_sie_block {
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
index 97d3a81e5074..6747cb6cf062 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4416,6 +4416,13 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 	if (mop->size > MEM_OP_MAX_SIZE)
 		return -E2BIG;
 
+	/* Protected guests move instruction data over the satellite
+	 * block which has its own size limit
+	 */
+	if (kvm_s390_pv_is_protected(vcpu->kvm) &&
+	    mop->size > ((vcpu->arch.sie_block->sidad & 0x0f) + 1) * PAGE_SIZE)
+		return -E2BIG;
+
 	if (!(mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY)) {
 		tmpbuf = vmalloc(mop->size);
 		if (!tmpbuf)
@@ -4427,10 +4434,22 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 	switch (mop->op) {
 	case KVM_S390_MEMOP_LOGICAL_READ:
 		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
+			if (kvm_s390_pv_is_protected(vcpu->kvm)) {
+				r = 0;
+				break;
+			}
 			r = check_gva_range(vcpu, mop->gaddr, mop->ar,
 					    mop->size, GACC_FETCH);
 			break;
 		}
+		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
+			r = 0;
+			if (copy_to_user(uaddr, (void *)vcpu->arch.sie_block->sidad +
+					 (mop->gaddr & ~PAGE_MASK),
+					 mop->size))
+				r = -EFAULT;
+			break;
+		}
 		r = read_guest(vcpu, mop->gaddr, mop->ar, tmpbuf, mop->size);
 		if (r == 0) {
 			if (copy_to_user(uaddr, tmpbuf, mop->size))
@@ -4439,10 +4458,22 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 		break;
 	case KVM_S390_MEMOP_LOGICAL_WRITE:
 		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
+			if (kvm_s390_pv_is_protected(vcpu->kvm)) {
+				r = 0;
+				break;
+			}
 			r = check_gva_range(vcpu, mop->gaddr, mop->ar,
 					    mop->size, GACC_STORE);
 			break;
 		}
+		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
+			r = 0;
+			if (copy_from_user((void *)vcpu->arch.sie_block->sidad +
+					   (mop->gaddr & ~PAGE_MASK), uaddr,
+					   mop->size))
+				r = -EFAULT;
+			break;
+		}
 		if (copy_from_user(tmpbuf, uaddr, mop->size)) {
 			r = -EFAULT;
 			break;
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 383e660e2221..be7d558ab897 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -119,6 +119,7 @@ int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu)
 
 	free_pages(vcpu->arch.pv.stor_base,
 		   get_order(uv_info.guest_cpu_stor_len));
+	free_page(vcpu->arch.sie_block->sidad);
 	/* Clear cpu and vm handle */
 	memset(&vcpu->arch.sie_block->reserved10, 0,
 	       sizeof(vcpu->arch.sie_block->reserved10));
@@ -150,6 +151,14 @@ int kvm_s390_pv_create_cpu(struct kvm_vcpu *vcpu)
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
-- 
2.20.1

