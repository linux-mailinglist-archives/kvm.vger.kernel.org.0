Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18CC1B1ED9
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 08:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgDUGe4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 02:34:56 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12712 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725902AbgDUGe4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Apr 2020 02:34:56 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03L6Xbbg088887
        for <kvm@vger.kernel.org>; Tue, 21 Apr 2020 02:34:55 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30gmuy8pkv-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 21 Apr 2020 02:34:55 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Tue, 21 Apr 2020 07:34:19 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 21 Apr 2020 07:34:16 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03L6XgSS66519400
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Apr 2020 06:33:42 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67A19AE045;
        Tue, 21 Apr 2020 06:34:49 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4FFDDAE051;
        Tue, 21 Apr 2020 06:34:49 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 21 Apr 2020 06:34:49 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 1036EE05A7; Tue, 21 Apr 2020 08:34:49 +0200 (CEST)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>
Subject: [GIT PULL 1/2] KVM: s390: Fix PV check in deliverable_irqs()
Date:   Tue, 21 Apr 2020 08:34:46 +0200
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200421063447.6814-1-borntraeger@de.ibm.com>
References: <20200421063447.6814-1-borntraeger@de.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20042106-0008-0000-0000-000003748EA0
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042106-0009-0000-0000-00004A96530A
Message-Id: <20200421063447.6814-2-borntraeger@de.ibm.com>
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-21_02:2020-04-20,2020-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 adultscore=0 malwarescore=0
 suspectscore=0 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004210055
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

The diag 0x44 handler, which handles a directed yield, goes into a
a codepath that does a kvm_for_each_vcpu() and ultimately
deliverable_irqs().  The new check for kvm_s390_pv_cpu_is_protected()
contains an assertion that the vcpu->mutex is held, which isn't going
to be the case in this scenario.

The result is a plethora of these messages if the lock debugging
is enabled, and thus an implication that we have a problem.

  WARNING: CPU: 9 PID: 16167 at arch/s390/kvm/kvm-s390.h:239 deliverable_irqs+0x1c6/0x1d0 [kvm]
  ...snip...
  Call Trace:
   [<000003ff80429bf2>] deliverable_irqs+0x1ca/0x1d0 [kvm]
  ([<000003ff80429b34>] deliverable_irqs+0x10c/0x1d0 [kvm])
   [<000003ff8042ba82>] kvm_s390_vcpu_has_irq+0x2a/0xa8 [kvm]
   [<000003ff804101e2>] kvm_arch_dy_runnable+0x22/0x38 [kvm]
   [<000003ff80410284>] kvm_vcpu_on_spin+0x8c/0x1d0 [kvm]
   [<000003ff80436888>] kvm_s390_handle_diag+0x3b0/0x768 [kvm]
   [<000003ff80425af4>] kvm_handle_sie_intercept+0x1cc/0xcd0 [kvm]
   [<000003ff80422bb0>] __vcpu_run+0x7b8/0xfd0 [kvm]
   [<000003ff80423de6>] kvm_arch_vcpu_ioctl_run+0xee/0x3e0 [kvm]
   [<000003ff8040ccd8>] kvm_vcpu_ioctl+0x2c8/0x8d0 [kvm]
   [<00000001504ced06>] ksys_ioctl+0xae/0xe8
   [<00000001504cedaa>] __s390x_sys_ioctl+0x2a/0x38
   [<0000000150cb9034>] system_call+0xd8/0x2d8
  2 locks held by CPU 2/KVM/16167:
   #0: 00000001951980c0 (&vcpu->mutex){+.+.}, at: kvm_vcpu_ioctl+0x90/0x8d0 [kvm]
   #1: 000000019599c0f0 (&kvm->srcu){....}, at: __vcpu_run+0x4bc/0xfd0 [kvm]
  Last Breaking-Event-Address:
   [<000003ff80429b34>] deliverable_irqs+0x10c/0x1d0 [kvm]
  irq event stamp: 11967
  hardirqs last  enabled at (11975): [<00000001502992f2>] console_unlock+0x4ca/0x650
  hardirqs last disabled at (11982): [<0000000150298ee8>] console_unlock+0xc0/0x650
  softirqs last  enabled at (7940): [<0000000150cba6ca>] __do_softirq+0x422/0x4d8
  softirqs last disabled at (7929): [<00000001501cd688>] do_softirq_own_stack+0x70/0x80

Considering what's being done here, let's fix this by removing the
mutex assertion rather than acquiring the mutex for every other vcpu.

Fixes: 201ae986ead7 ("KVM: s390: protvirt: Implement interrupt injection")
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Link: https://lore.kernel.org/r/20200415190353.63625-1-farman@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/interrupt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 8191106bf7b9..bfb481134994 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -393,7 +393,7 @@ static unsigned long deliverable_irqs(struct kvm_vcpu *vcpu)
 	if (psw_mchk_disabled(vcpu))
 		active_mask &= ~IRQ_PEND_MCHK_MASK;
 	/* PV guest cpus can have a single interruption injected at a time. */
-	if (kvm_s390_pv_cpu_is_protected(vcpu) &&
+	if (kvm_s390_pv_cpu_get_handle(vcpu) &&
 	    vcpu->arch.sie_block->iictl != IICTL_CODE_NONE)
 		active_mask &= ~(IRQ_PEND_EXT_II_MASK |
 				 IRQ_PEND_IO_MASK |
-- 
2.25.2

