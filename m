Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7282E18470D
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 13:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgCMMks (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 08:40:48 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28344 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726534AbgCMMks (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Mar 2020 08:40:48 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02DCY1lh116216
        for <kvm@vger.kernel.org>; Fri, 13 Mar 2020 08:40:47 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yr0stnkwy-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 13 Mar 2020 08:40:46 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <mimu@linux.ibm.com>;
        Fri, 13 Mar 2020 12:40:44 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 13 Mar 2020 12:40:42 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02DCee6n20054074
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Mar 2020 12:40:40 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C21F542042;
        Fri, 13 Mar 2020 12:40:40 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 739B142041;
        Fri, 13 Mar 2020 12:40:40 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 13 Mar 2020 12:40:40 +0000 (GMT)
From:   Michael Mueller <mimu@linux.ibm.com>
To:     linux-s390@vger.kernel.org, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        Michael Mueller <mimu@linux.ibm.com>
Subject: [PATCH] KVM: s390: pending interrupts are unlikely
Date:   Fri, 13 Mar 2020 13:40:30 +0100
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 20031312-0020-0000-0000-000003B3C72E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031312-0021-0000-0000-0000220C1F6D
Message-Id: <20200313124030.99834-1-mimu@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-13_04:2020-03-12,2020-03-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 mlxlogscore=616 clxscore=1015 mlxscore=0 lowpriorityscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003130067
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A statistical analysis shows that in most cases when deliverable_irqs()
is called, no interrupts are pending. (see: early exit ratio)

The data was sampled during an iperf3 run over virtio_net
between one guest and the host.

deliverable_irqs()
        called = 3145123
           by kvm_s390_vcpu_has_irq() = 3005581 (95.56%)
              by kvm_arch_vcpu_runnable() = 3005578 (95.56%)
                 by kvm_s390_handle_wait() = 1219331 (38.76%)
                 by kvm_vcpu_check_block() = 2943565 (93.59%)
                    by kvm_cpu_block(1) = 2826431 (89.86%)
                    by kvm_cpu_block(2) = 117136 (3.72%)
                 by kvm_arch_dy_runnable() = 0 (0%)
              by kvm_arch_setup_async_pf() = 0 (0%)
              by handle_stop() = 0 (0%)
           by kvm_s390_deliver_pending_interrupt() = 139542 (4.43%)
              irqs_delivered = (0:15917 1:61810 2:1 3:0 4:0 x:0)
              irqs_pending = (0:15917 1:61722 2:86 3:1 4:0 x:0)
    early exit = 3021787 (96.07%)
  pending irqs = 123237 (3.91%)

Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
---
 arch/s390/kvm/interrupt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 028167d6eacd..c34d62b4209e 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -369,7 +369,7 @@ static unsigned long deliverable_irqs(struct kvm_vcpu *vcpu)
 	unsigned long active_mask;
 
 	active_mask = pending_irqs(vcpu);
-	if (!active_mask)
+	if (likely(!active_mask))
 		return 0;
 
 	if (psw_extint_disabled(vcpu))
-- 
2.17.0

