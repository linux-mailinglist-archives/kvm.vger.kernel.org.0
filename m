Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34C6E4D9D20
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 15:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237940AbiCOONr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 10:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349038AbiCOOM7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 10:12:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4654D54BCD;
        Tue, 15 Mar 2022 07:11:46 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22FDt0Pl002090;
        Tue, 15 Mar 2022 14:11:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=Cky0JAwB0FgiuTE1ZIray99YAgYqwPDLl4P5F6cVtEI=;
 b=NtIsWLuZexB+2tDxLwDtBuMzNa6cEkgw2Ew5nSIFihOAV+2ZH3/QH5W3cd1RmOxRMN24
 c5r5cb5PmOCY9JNlV0vU09aoBhhEajYjwToh67aVvC8ZDFq8uBv4rrk6no4rs/73zWXZ
 k0fVrD3TheCdidw2GATnG5dQUd9mAcxXISYPsEbYWKMyLu34L8lFAgqiN4+6bBp4NwF5
 Zgtvmt6wslNorX151QjMR8/NoXr2Xv9idq/YG/2hNqQPDfxYu2SNQXWKqdl/v6YYBMCW
 PiGVtzntb6T061Mbx2vi08hgBAM8J+m71gopqTWAh9HRAC4dgS+jZsgF3WouFmlg5G+0 nA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3etv3vgdyv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 14:11:45 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22FDv1kD011216;
        Tue, 15 Mar 2022 14:11:44 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3etv3vgdy3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 14:11:44 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22FE99CR008054;
        Tue, 15 Mar 2022 14:11:43 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3et95wt42h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 14:11:43 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22FEBeau51839320
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 14:11:40 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08D20A4051;
        Tue, 15 Mar 2022 14:11:40 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7F60A4040;
        Tue, 15 Mar 2022 14:11:39 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 15 Mar 2022 14:11:39 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id A45D8E11F3; Tue, 15 Mar 2022 15:11:39 +0100 (CET)
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Subject: [GIT PULL 5/7] KVM: s390: selftests: Add named stages for memop test
Date:   Tue, 15 Mar 2022 15:11:35 +0100
Message-Id: <20220315141137.357923-6-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220315141137.357923-1-borntraeger@linux.ibm.com>
References: <20220315141137.357923-1-borntraeger@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: r-8Q2hpkvyMQ8djxIU3CRnXE2OfCSrmW
X-Proofpoint-ORIG-GUID: lRMS3UHQJrqefBg2XevS771abHSjfS07
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-15_03,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 suspectscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 malwarescore=0 mlxscore=0 spamscore=0 impostorscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203150092
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

The stages synchronize guest and host execution.
This helps the reader and constraits the execution of the test -- if the
observed staging differs from the expected the test fails.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Link: https://lore.kernel.org/r/20220308125841.3271721-4-scgl@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 tools/testing/selftests/kvm/s390x/memop.c | 44 +++++++++++++++++------
 1 file changed, 33 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/s390x/memop.c b/tools/testing/selftests/kvm/s390x/memop.c
index e2ad3d70bae4..88ce2d670ed5 100644
--- a/tools/testing/selftests/kvm/s390x/memop.c
+++ b/tools/testing/selftests/kvm/s390x/memop.c
@@ -218,10 +218,32 @@ static struct test_default test_default_init(void *guest_code)
 	return t;
 }
 
+enum stage {
+	/* Synced state set by host, e.g. DAT */
+	STAGE_INITED,
+	/* Guest did nothing */
+	STAGE_IDLED,
+	/* Guest copied memory (locations up to test case) */
+	STAGE_COPIED,
+};
+
+#define HOST_SYNC(vcpu_p, stage)					\
+({									\
+	struct test_vcpu __vcpu = (vcpu_p);				\
+	struct ucall uc;						\
+	int __stage = (stage);						\
+									\
+	vcpu_run(__vcpu.vm, __vcpu.id);					\
+	get_ucall(__vcpu.vm, __vcpu.id, &uc);				\
+	ASSERT_EQ(uc.cmd, UCALL_SYNC);					\
+	ASSERT_EQ(uc.args[1], __stage);					\
+})									\
+
 static void guest_copy(void)
 {
+	GUEST_SYNC(STAGE_INITED);
 	memcpy(&mem2, &mem1, sizeof(mem2));
-	GUEST_SYNC(0);
+	GUEST_SYNC(STAGE_COPIED);
 }
 
 static void test_copy(void)
@@ -232,16 +254,13 @@ static void test_copy(void)
 	for (i = 0; i < sizeof(mem1); i++)
 		mem1[i] = i * i + i;
 
+	HOST_SYNC(t.vcpu, STAGE_INITED);
+
 	/* Set the first array */
-	MOP(t.vcpu, LOGICAL, WRITE, mem1, t.size,
-	    GADDR(addr_gva2gpa(t.kvm_vm, (uintptr_t)mem1)));
+	MOP(t.vcpu, LOGICAL, WRITE, mem1, t.size, GADDR_V(mem1));
 
 	/* Let the guest code copy the first array to the second */
-	vcpu_run(t.kvm_vm, VCPU_ID);
-	TEST_ASSERT(t.run->exit_reason == KVM_EXIT_S390_SIEIC,
-		    "Unexpected exit reason: %u (%s)\n",
-		    t.run->exit_reason,
-		    exit_reason_str(t.run->exit_reason));
+	HOST_SYNC(t.vcpu, STAGE_COPIED);
 
 	memset(mem2, 0xaa, sizeof(mem2));
 
@@ -256,8 +275,9 @@ static void test_copy(void)
 
 static void guest_idle(void)
 {
+	GUEST_SYNC(STAGE_INITED); /* for consistency's sake */
 	for (;;)
-		GUEST_SYNC(0);
+		GUEST_SYNC(STAGE_IDLED);
 }
 
 static void test_errors(void)
@@ -265,6 +285,8 @@ static void test_errors(void)
 	struct test_default t = test_default_init(guest_idle);
 	int rv;
 
+	HOST_SYNC(t.vcpu, STAGE_INITED);
+
 	/* Bad size: */
 	rv = ERR_MOP(t.vcpu, LOGICAL, WRITE, mem1, -1, GADDR_V(mem1));
 	TEST_ASSERT(rv == -1 && errno == E2BIG, "ioctl allows insane sizes");
@@ -294,11 +316,11 @@ static void test_errors(void)
 	/* Bad access register: */
 	t.run->psw_mask &= ~(3UL << (63 - 17));
 	t.run->psw_mask |= 1UL << (63 - 17);  /* Enable AR mode */
-	vcpu_run(t.kvm_vm, VCPU_ID);              /* To sync new state to SIE block */
+	HOST_SYNC(t.vcpu, STAGE_IDLED); /* To sync new state to SIE block */
 	rv = ERR_MOP(t.vcpu, LOGICAL, WRITE, mem1, t.size, GADDR_V(mem1), AR(17));
 	TEST_ASSERT(rv == -1 && errno == EINVAL, "ioctl allows ARs > 15");
 	t.run->psw_mask &= ~(3UL << (63 - 17));   /* Disable AR mode */
-	vcpu_run(t.kvm_vm, VCPU_ID);                  /* Run to sync new state */
+	HOST_SYNC(t.vcpu, STAGE_IDLED); /* Run to sync new state */
 
 	/* Check that the SIDA calls are rejected for non-protected guests */
 	rv = ERR_MOP(t.vcpu, SIDA, READ, mem1, 8, GADDR(0), SIDA_OFFSET(0x1c0));
-- 
2.35.1

