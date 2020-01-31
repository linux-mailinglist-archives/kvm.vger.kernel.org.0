Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C058E14EF11
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 16:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbgAaPEF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 10:04:05 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52836 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729235AbgAaPEF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jan 2020 10:04:05 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00VF1CIJ114656
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2020 10:04:04 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xvf34nxyu-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2020 10:04:02 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Fri, 31 Jan 2020 15:03:54 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 31 Jan 2020 15:03:51 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00VF3oOk42991786
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jan 2020 15:03:50 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0FA284203F;
        Fri, 31 Jan 2020 15:03:50 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0617242057;
        Fri, 31 Jan 2020 15:03:50 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 31 Jan 2020 15:03:49 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id B7AB3E0378; Fri, 31 Jan 2020 16:03:49 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [GIT PULL 2/7] KVM: s390: do not clobber registers during guest reset/store status
Date:   Fri, 31 Jan 2020 16:03:43 +0100
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200131150348.73360-1-borntraeger@de.ibm.com>
References: <20200131150348.73360-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20013115-0028-0000-0000-000003D64A14
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20013115-0029-0000-0000-0000249A9C7E
Message-Id: <20200131150348.73360-3-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-31_03:2020-01-31,2020-01-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 spamscore=0
 adultscore=0 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1911200001 definitions=main-2001310127
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The initial CPU reset clobbers the userspace fpc and the store status
ioctl clobbers the guest acrs + fpr.  As these calls are only done via
ioctl (and not via vcpu_run), no CPU context is loaded, so we can (and
must) act directly on the sync regs, not on the thread context.

Cc: stable@kernel.org
Fixes: e1788bb995be ("KVM: s390: handle floating point registers in the run ioctl not in vcpu_put/load")
Fixes: 31d8b8d41a7e ("KVM: s390: handle access registers in the run ioctl not in vcpu_put/load")
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20200131100205.74720-2-frankja@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d9e6bf3d54f0..876802894b35 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2860,9 +2860,7 @@ static void kvm_s390_vcpu_initial_reset(struct kvm_vcpu *vcpu)
 	vcpu->arch.sie_block->gcr[14] = CR14_UNUSED_32 |
 					CR14_UNUSED_33 |
 					CR14_EXTERNAL_DAMAGE_SUBMASK;
-	/* make sure the new fpc will be lazily loaded */
-	save_fpu_regs();
-	current->thread.fpu.fpc = 0;
+	vcpu->run->s.regs.fpc = 0;
 	vcpu->arch.sie_block->gbea = 1;
 	vcpu->arch.sie_block->pp = 0;
 	vcpu->arch.sie_block->fpf &= ~FPF_BPBC;
@@ -4351,7 +4349,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	switch (ioctl) {
 	case KVM_S390_STORE_STATUS:
 		idx = srcu_read_lock(&vcpu->kvm->srcu);
-		r = kvm_s390_vcpu_store_status(vcpu, arg);
+		r = kvm_s390_store_status_unloaded(vcpu, arg);
 		srcu_read_unlock(&vcpu->kvm->srcu, idx);
 		break;
 	case KVM_S390_SET_INITIAL_PSW: {
-- 
2.21.0

