Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1263414DAA3
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 13:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbgA3Meu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 07:34:50 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59216 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726873AbgA3Meu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jan 2020 07:34:50 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00UCYPfZ044760
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2020 07:34:49 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xu5q68jrn-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2020 07:34:48 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 30 Jan 2020 12:34:47 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 30 Jan 2020 12:34:45 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00UCYiQe48038074
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jan 2020 12:34:44 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 234ED52051;
        Thu, 30 Jan 2020 12:34:44 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.44])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id A38FF5204F;
        Thu, 30 Jan 2020 12:34:42 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, borntraeger@de.ibm.com, david@redhat.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
Subject: [PATCH v9 1/6] KVM: s390: do not clobber registers during guest reset/store status
Date:   Thu, 30 Jan 2020 07:34:29 -0500
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200130123434.68129-1-frankja@linux.ibm.com>
References: <20200130123434.68129-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20013012-0016-0000-0000-000002E2285B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20013012-0017-0000-0000-00003344F261
Message-Id: <20200130123434.68129-2-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-30_03:2020-01-28,2020-01-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 mlxlogscore=880
 clxscore=1015 mlxscore=0 bulkscore=0 spamscore=0 suspectscore=1
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2001300092
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

The initial CPU reset clobbers the userspace fpc and the store status
ioctl clobbers the guest acrs + fpr.  As these calls are only done via
ioctl (and not via vcpu_run), no CPU context is loaded, so we can (and
must) act directly on the sync regs, not on the thread context.

Cc: stable@kernel.org
Fixes: e1788bb995be ("KVM: s390: handle floating point registers in the run ioctl not in vcpu_put/load")
Fixes: 31d8b8d41a7e ("KVM: s390: handle access registers in the run ioctl not in vcpu_put/load")
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index c059b86aacd4..328dee666b24 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2824,8 +2824,7 @@ static void kvm_s390_vcpu_initial_reset(struct kvm_vcpu *vcpu)
 	vcpu->arch.sie_block->gcr[14] = CR14_UNUSED_32 |
 					CR14_UNUSED_33 |
 					CR14_EXTERNAL_DAMAGE_SUBMASK;
-	/* make sure the new fpc will be lazily loaded */
-	save_fpu_regs();
+	vcpu->run->s.regs.fpc = 0;
 	current->thread.fpu.fpc = 0;
 	vcpu->arch.sie_block->gbea = 1;
 	vcpu->arch.sie_block->pp = 0;
@@ -4343,7 +4342,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	switch (ioctl) {
 	case KVM_S390_STORE_STATUS:
 		idx = srcu_read_lock(&vcpu->kvm->srcu);
-		r = kvm_s390_vcpu_store_status(vcpu, arg);
+		r = kvm_s390_store_status_unloaded(vcpu, arg);
 		srcu_read_unlock(&vcpu->kvm->srcu, idx);
 		break;
 	case KVM_S390_SET_INITIAL_PSW: {
-- 
2.20.1

