Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0A775F039
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 11:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232505AbjGXJuh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 05:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232437AbjGXJtq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 05:49:46 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904F730DD;
        Mon, 24 Jul 2023 02:47:53 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36O9dfX7002965;
        Mon, 24 Jul 2023 09:47:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Kav8AiZbJFyu39hpeIgBeh/TEWgKrM6uTJhL4zC3z+Q=;
 b=ERgxMDH21UJlEfcXxfkbhf0Eo/YWIySRwkP83YbmcfnO8YUfA0UyhSi6BKcZtkGTyfsj
 4EUpGF5r1eiMfqcS1iO5Z3o7zOr4bQxGOPXWlzC6Yn4AmuTtVtb3Cnp0jyNxSN/v/v1C
 9WGtrjhIGRshrfdF3hiGvefrZ0juI2zlaN/yrO6qCN1mHd1olNG5/uDTKzXQ/qil7iKM
 se5dNVaehBMvZVO6Cy10Ghd9H7DOqhllsLtmQoc5Me8IoQ4FVqRZGX80mSrV//31LSBW
 ssGAip+LEB9PQfCcj34qsGy5jP3J4fyIVKom0fl4b+oZv1Asf/WnCqHpe/jEJoKrMTc1 pQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s1k3un6h3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jul 2023 09:47:35 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36O9eCxd005938;
        Mon, 24 Jul 2023 09:47:34 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3s1k3un6gp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jul 2023 09:47:33 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36O82FmK014387;
        Mon, 24 Jul 2023 09:47:33 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3s0stxj9p9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Jul 2023 09:47:33 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36O9lSJx10617456
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Jul 2023 09:47:28 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8630E20043;
        Mon, 24 Jul 2023 09:47:28 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BDFFD20049;
        Mon, 24 Jul 2023 09:47:27 +0000 (GMT)
Received: from heavy.boeblingen.de.ibm.com (unknown [9.171.11.212])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 24 Jul 2023 09:47:27 +0000 (GMT)
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
Subject: [PATCH v3 2/6] KVM: s390: interrupt: Fix single-stepping into program interrupt handlers
Date:   Mon, 24 Jul 2023 11:44:08 +0200
Message-ID: <20230724094716.91510-3-iii@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230724094716.91510-1-iii@linux.ibm.com>
References: <20230724094716.91510-1-iii@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: iohybCMRRangLPQ4qh_brvqOVYxmDxOr
X-Proofpoint-GUID: K0RTg496uVXr1ZtEHXhOdiZPXrleNwPk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-24_07,2023-07-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 mlxscore=0 phishscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307240084
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

Reviewed-by: David Hildenbrand <david@redhat.com>
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

