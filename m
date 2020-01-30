Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 752FA14D7FE
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 09:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbgA3IzH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 03:55:07 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34802 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727132AbgA3IzH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jan 2020 03:55:07 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00U8sfh2025080;
        Thu, 30 Jan 2020 03:55:06 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xttw843wj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jan 2020 03:55:05 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 00U8t5dq025970;
        Thu, 30 Jan 2020 03:55:05 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xttw843vj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jan 2020 03:55:05 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 00U8qoYh012061;
        Thu, 30 Jan 2020 08:55:04 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02wdc.us.ibm.com with ESMTP id 2xrda72fev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 30 Jan 2020 08:55:04 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00U8t3Dr51118382
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jan 2020 08:55:03 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF9C2112064;
        Thu, 30 Jan 2020 08:55:03 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6C89112065;
        Thu, 30 Jan 2020 08:55:02 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.152.224.41])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 30 Jan 2020 08:55:02 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     frankja@linux.ibm.com
Cc:     borntraeger@de.ibm.com, cohuck@redhat.com, david@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        stable@kernel.org
Subject: [PATCH/FIXUP FOR STABLE BEFORE THIS SERIES] KVM: s390: do not clobber user space fpc during guest reset
Date:   Thu, 30 Jan 2020 09:55:00 +0100
Message-Id: <1580374500-31247-1-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20200129200312.3200-2-frankja@linux.ibm.com>
References: <20200129200312.3200-2-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-30_02:2020-01-28,2020-01-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 suspectscore=1
 lowpriorityscore=0 adultscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 spamscore=0 mlxlogscore=852 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2001300063
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The initial CPU reset currently clobbers the userspace fpc. This was an
oversight during a fixup for the lazy fpu reloading rework.  The reset
calls are only done from userspace ioctls. No CPU context is loaded, so
we can (and must) act directly on the sync regs, not on the thread
context. Otherwise the fpu restore call will restore the zeroes fpc to
userspace.

Cc: stable@kernel.org
Fixes: 9abc2a08a7d6 ("KVM: s390: fix memory overwrites when vx is disabled")
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index c059b86..eb789cd 100644
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
-- 
1.8.3.1

