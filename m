Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2861FCAAC
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 17:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbfKNQWl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 11:22:41 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37724 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726263AbfKNQWl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 Nov 2019 11:22:41 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAEGLBCo071798
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 11:22:39 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2w92jm6nwd-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 11:22:36 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 14 Nov 2019 16:22:03 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 14 Nov 2019 16:22:00 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAEGLwxm65798238
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 16:21:59 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CDE4711C052;
        Thu, 14 Nov 2019 16:21:58 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F17F11C050;
        Thu, 14 Nov 2019 16:21:57 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.131])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 14 Nov 2019 16:21:57 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com
Subject: [PATCH] Fixup sida bouncing
Date:   Thu, 14 Nov 2019 11:21:53 -0500
X-Mailer: git-send-email 2.20.1
In-Reply-To: <ad0f9b90-3ce4-c2d2-b661-635fe439f7e2@redhat.com>
References: <ad0f9b90-3ce4-c2d2-b661-635fe439f7e2@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19111416-4275-0000-0000-0000037DBE94
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19111416-4276-0000-0000-000038912593
Message-Id: <20191114162153.25349-1-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-14_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=649 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911140147
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 0fa7c6d9ed0e..9820fde04887 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4432,13 +4432,21 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 	if (mop->size > MEM_OP_MAX_SIZE)
 		return -E2BIG;
 
-	/* Protected guests move instruction data over the satellite
+	/*
+	 * Protected guests move instruction data over the satellite
 	 * block which has its own size limit
 	 */
 	if (kvm_s390_pv_is_protected(vcpu->kvm) &&
-	    mop->size > ((vcpu->arch.sie_block->sidad & 0x0f) + 1) * PAGE_SIZE)
+	    mop->size > ((vcpu->arch.sie_block->sidad & 0xff) + 1) * PAGE_SIZE)
 		return -E2BIG;
 
+	/* We can currently only offset into the one SIDA page. */
+	if (kvm_s390_pv_is_protected(vcpu->kvm)) {
+		mop->gaddr &= ~PAGE_MASK;
+		if (mop->gaddr + mop->size > PAGE_SIZE)
+			return -EINVAL;
+	}
+
 	if (!(mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY)) {
 		tmpbuf = vmalloc(mop->size);
 		if (!tmpbuf)
@@ -4451,6 +4459,7 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 	case KVM_S390_MEMOP_LOGICAL_READ:
 		if (mop->flags & KVM_S390_MEMOP_F_CHECK_ONLY) {
 			if (kvm_s390_pv_is_protected(vcpu->kvm)) {
+				/* We can always copy into the SIDA */
 				r = 0;
 				break;
 			}
@@ -4461,8 +4470,7 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
 			r = 0;
 			if (copy_to_user(uaddr, (void *)vcpu->arch.sie_block->sidad +
-					 (mop->gaddr & ~PAGE_MASK),
-					 mop->size))
+					 mop->gaddr, mop->size))
 				r = -EFAULT;
 			break;
 		}
@@ -4485,8 +4493,7 @@ static long kvm_s390_guest_mem_op(struct kvm_vcpu *vcpu,
 		if (kvm_s390_pv_is_protected(vcpu->kvm)) {
 			r = 0;
 			if (copy_from_user((void *)vcpu->arch.sie_block->sidad +
-					   (mop->gaddr & ~PAGE_MASK), uaddr,
-					   mop->size))
+					   mop->gaddr, uaddr, mop->size))
 				r = -EFAULT;
 			break;
 		}
-- 
2.20.1

