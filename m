Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99FB375C650
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 14:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbjGUMBJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jul 2023 08:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbjGUMBF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jul 2023 08:01:05 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCFDB19A1;
        Fri, 21 Jul 2023 05:00:58 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36LBiIaa026012;
        Fri, 21 Jul 2023 12:00:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=M9iU994YnfA1Gkvnrb+uZ/PYL9/3UMtlopdDcmArkNE=;
 b=QH3FtBkO0d/713aPxQLQxaA+m4LHZT77jUX/Muec5DS2N1hVejpVEdnaYPMc8c0iOX6F
 8y4KoUUMgHMP24lWrs78u5ynqBMr2LqifSWuTBNoIBh+p83khmCLM/9zevCvqhnv6pNU
 p1y3Lev3GSOjeD+LQZp3+GsAxjT8yLP1ekJX02ib67EA9sJKqEn0dL/7p327+bVtkR0V
 XlA7JcJAsmRDfEsa1MW7cLnt758t2qT4JX0scjTHNbodP97NLZl3BuWlAqh0QzATzFGZ
 LVI9CVXzsu9/UBvikY+S3ViCk4RknVT1LQtdfW3yd0NACXQqMTyHDFZLz8VEeskNOBfZ xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rycb8yx55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jul 2023 12:00:57 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36LBjfch029281;
        Fri, 21 Jul 2023 12:00:57 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rycb8yx4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jul 2023 12:00:57 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36LAFHvc007605;
        Fri, 21 Jul 2023 12:00:56 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3rv80jkxga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jul 2023 12:00:56 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36LC0rGT57344482
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jul 2023 12:00:53 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 912E12004B;
        Fri, 21 Jul 2023 12:00:53 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 109FB20040;
        Fri, 21 Jul 2023 12:00:53 +0000 (GMT)
Received: from heavy.boeblingen.de.ibm.com (unknown [9.155.200.166])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 21 Jul 2023 12:00:53 +0000 (GMT)
From:   Ilya Leoshkevich <iii@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Freimann <jfreimann@redhat.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v2 2/6] KVM: s390: interrupt: Fix single-stepping into program interrupt handlers
Date:   Fri, 21 Jul 2023 13:57:55 +0200
Message-ID: <20230721120046.2262291-3-iii@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721120046.2262291-1-iii@linux.ibm.com>
References: <20230721120046.2262291-1-iii@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ThDyW68OWxMmTQBa1TOXtKYQV2vYEA0T
X-Proofpoint-ORIG-GUID: uABwNVdjpWsxdKu_44p1A_YHEs-pWdXB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-21_07,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 clxscore=1015 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 priorityscore=1501 bulkscore=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307210104
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
---
 arch/s390/kvm/intercept.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 954d39adf85c..7cdd927541b0 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -226,7 +226,22 @@ static int handle_itdb(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-#define per_event(vcpu) (vcpu->arch.sie_block->iprcc & PGM_PER)
+static bool should_handle_per_event(const struct kvm_vcpu *vcpu)
+{
+	if (!guestdbg_enabled(vcpu))
+		return false;
+	if (!(vcpu->arch.sie_block->iprcc & PGM_PER))
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
 
 static int handle_prog(struct kvm_vcpu *vcpu)
 {
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

