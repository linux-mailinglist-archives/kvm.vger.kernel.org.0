Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8FE786F73
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 14:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240629AbjHXMrD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 08:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239508AbjHXMq1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 08:46:27 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F2AE59;
        Thu, 24 Aug 2023 05:46:26 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37OCgm7v019885;
        Thu, 24 Aug 2023 12:46:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=dAa3CtX2Pmh+hCQbsbyuY6/Nrq1h5cGWKDkPYPy4AdI=;
 b=arzJ48va09wUYgt9LlzMc5mX+hwM6x6r4qP7fUl7RQ6679rpYhAL+AnDbwvmJRHsebcN
 UpMvvkwYUmD74AUi/p+QN3jG1DyuW649bIdWZa6PdF/yzZxojnqcTnIgbapoi571e5vF
 J2ZFditAhv9+SvvI/duiqckCygjCve4E/cRa3qlhS6jZPxrNPkZkG7WK/8LCsDnon2AL
 KUv9Cp2xKYRbDh1RbeLLr0g5PrsQESlTSW/CySD7Ao1movss+Xxit+goCHA1cKEYnUB/
 a8X8MQPz1J5xcdriTaMFxAFydgCXsJRB0985IegQ64pq4cKM5MUd2hDmC+oz4FBoTzjA jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp7ey0gwm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:25 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37OCiINM029807;
        Thu, 24 Aug 2023 12:46:21 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp7ey0g3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:21 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37OCZ4hK004047;
        Thu, 24 Aug 2023 12:46:13 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3sn21rpxjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 12:46:12 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37OCk9cP21824098
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Aug 2023 12:46:09 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B4EEA2004B;
        Thu, 24 Aug 2023 12:46:09 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D90420043;
        Thu, 24 Aug 2023 12:46:09 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.171.27.69])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 24 Aug 2023 12:46:08 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, mihajlov@linux.ibm.com, seiden@linux.ibm.com,
        akrowiak@linux.ibm.com
Subject: [GIT PULL 02/22] KVM: s390: interrupt: Fix single-stepping into program interrupt handlers
Date:   Thu, 24 Aug 2023 14:43:11 +0200
Message-ID: <20230824124522.75408-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230824124522.75408-1-frankja@linux.ibm.com>
References: <20230824124522.75408-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ontr2J7MWwuT_ebh5wXMrHgIq2btJhbv
X-Proofpoint-GUID: uLP6KFAWkOLyor6gkOla4-3LPTCR70U8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-24_09,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 adultscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 spamscore=0 mlxlogscore=904
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2308240103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ilya Leoshkevich <iii@linux.ibm.com>

Currently, after single-stepping an instruction that generates a
specification exception, GDB ends up on the instruction immediately
following it.

The reason is that vcpu_post_run() injects the interrupt and sets
KVM_GUESTDBG_EXIT_PENDING, causing a KVM_SINGLESTEP exit. The
interrupt is not delivered, however, therefore userspace sees the
address of the next instruction.

Fix by letting the __vcpu_run() loop go into the next iteration,
where vcpu_pre_run() delivers the interrupt and sets
KVM_GUESTDBG_EXIT_PENDING.

Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <20230725143857.228626-3-iii@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/intercept.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 954d39adf85c..e54496740859 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -228,6 +228,21 @@ static int handle_itdb(struct kvm_vcpu *vcpu)
 
 #define per_event(vcpu) (vcpu->arch.sie_block->iprcc & PGM_PER)
 
+static bool should_handle_per_event(const struct kvm_vcpu *vcpu)
+{
+	if (!guestdbg_enabled(vcpu) || !per_event(vcpu))
+		return false;
+	if (guestdbg_sstep_enabled(vcpu) &&
+	    vcpu->arch.sie_block->iprcc != PGM_PER) {
+		/*
+		 * __vcpu_run() will exit after delivering the concurrently
+		 * indicated condition.
+		 */
+		return false;
+	}
+	return true;
+}
+
 static int handle_prog(struct kvm_vcpu *vcpu)
 {
 	psw_t psw;
@@ -242,7 +257,7 @@ static int handle_prog(struct kvm_vcpu *vcpu)
 	if (kvm_s390_pv_cpu_is_protected(vcpu))
 		return -EOPNOTSUPP;
 
-	if (guestdbg_enabled(vcpu) && per_event(vcpu)) {
+	if (should_handle_per_event(vcpu)) {
 		rc = kvm_s390_handle_per_event(vcpu);
 		if (rc)
 			return rc;
-- 
2.41.0

