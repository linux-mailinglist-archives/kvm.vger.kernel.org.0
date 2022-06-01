Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E11E53AA3C
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 17:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349980AbiFAPhU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 11:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355677AbiFAPhB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 11:37:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57748B48A;
        Wed,  1 Jun 2022 08:36:59 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 251EuTvV029999;
        Wed, 1 Jun 2022 15:36:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=SD4x0mOmB7k+Hw4S6fa+A4UBxx75q7uLG6PNisgwcaM=;
 b=k7tBQRkGl7Jivlq4iJQGV4A6NT2dilBuzIiTkzXMZJwtmKKHS1e+jXD4tEUTFRObwRy8
 dEe3pR8WYT6vWuoq4NYQYUwQ1+e6krZu+OI+WwBSOfHUJyWg93WQTtyjetjclLqZ7Sll
 ZLXcHHB60cPUXOmOX0IS1lh+5+s1GQNABiz3EooqFMsGP+1vIKb1lhJ1//oXefD2BBrk
 CihRuRsET6cwfKreojTbyG7K/aYTfDMyoMRYjh8sUGJYSRE0ePqjm0cRntzRR0Jb7lGR
 26Nlv87yuRyyso8WomltwhtgYZ2deykk5VmVNSdbgoHraXN3S1WxWTbWgSf3QITmZXl6 Lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3geaap8xh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 15:36:58 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 251EuxlN031589;
        Wed, 1 Jun 2022 15:36:58 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3geaap8xg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 15:36:57 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 251FKZXA010124;
        Wed, 1 Jun 2022 15:36:56 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3gbc97vdtr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Jun 2022 15:36:56 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 251FarHd24773112
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Jun 2022 15:36:53 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7480A4040;
        Wed,  1 Jun 2022 15:36:52 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3609A4051;
        Wed,  1 Jun 2022 15:36:52 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  1 Jun 2022 15:36:52 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 7608EE028C; Wed,  1 Jun 2022 17:36:52 +0200 (CEST)
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
        Thomas Huth <thuth@redhat.com>
Subject: [GIT PULL 15/15] KVM: s390: selftests: Use TAP interface in the reset test
Date:   Wed,  1 Jun 2022 17:36:46 +0200
Message-Id: <20220601153646.6791-16-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601153646.6791-1-borntraeger@linux.ibm.com>
References: <20220601153646.6791-1-borntraeger@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -8-9ZJcmMHhEWmT1daP95KMukHcexlTO
X-Proofpoint-GUID: eZAHznRjEpyjudz9uTf2Qjo0Obh86HWY
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-01_05,2022-06-01_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206010072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Huth <thuth@redhat.com>

Let's standardize the s390x KVM selftest output to the TAP output
generated via the kselftests.h interface.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
Link: https://lore.kernel.org/r/20220531101554.36844-5-thuth@redhat.com
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 tools/testing/selftests/kvm/s390x/resets.c | 38 +++++++++++++++++-----
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/s390x/resets.c b/tools/testing/selftests/kvm/s390x/resets.c
index b143db6d8693..889449a22e7a 100644
--- a/tools/testing/selftests/kvm/s390x/resets.c
+++ b/tools/testing/selftests/kvm/s390x/resets.c
@@ -12,6 +12,7 @@
 
 #include "test_util.h"
 #include "kvm_util.h"
+#include "kselftest.h"
 
 #define VCPU_ID 3
 #define LOCAL_IRQS 32
@@ -202,7 +203,7 @@ static void inject_irq(int cpu_id)
 
 static void test_normal(void)
 {
-	pr_info("Testing normal reset\n");
+	ksft_print_msg("Testing normal reset\n");
 	/* Create VM */
 	vm = vm_create_default(VCPU_ID, 0, guest_code_initial);
 	run = vcpu_state(vm, VCPU_ID);
@@ -225,7 +226,7 @@ static void test_normal(void)
 
 static void test_initial(void)
 {
-	pr_info("Testing initial reset\n");
+	ksft_print_msg("Testing initial reset\n");
 	vm = vm_create_default(VCPU_ID, 0, guest_code_initial);
 	run = vcpu_state(vm, VCPU_ID);
 	sync_regs = &run->s.regs;
@@ -247,7 +248,7 @@ static void test_initial(void)
 
 static void test_clear(void)
 {
-	pr_info("Testing clear reset\n");
+	ksft_print_msg("Testing clear reset\n");
 	vm = vm_create_default(VCPU_ID, 0, guest_code_initial);
 	run = vcpu_state(vm, VCPU_ID);
 	sync_regs = &run->s.regs;
@@ -266,14 +267,35 @@ static void test_clear(void)
 	kvm_vm_free(vm);
 }
 
+struct testdef {
+	const char *name;
+	void (*test)(void);
+	bool needs_cap;
+} testlist[] = {
+	{ "initial", test_initial, false },
+	{ "normal", test_normal, true },
+	{ "clear", test_clear, true },
+};
+
 int main(int argc, char *argv[])
 {
+	bool has_s390_vcpu_resets = kvm_check_cap(KVM_CAP_S390_VCPU_RESETS);
+	int idx;
+
 	setbuf(stdout, NULL);	/* Tell stdout not to buffer its content */
 
-	test_initial();
-	if (kvm_check_cap(KVM_CAP_S390_VCPU_RESETS)) {
-		test_normal();
-		test_clear();
+	ksft_print_header();
+	ksft_set_plan(ARRAY_SIZE(testlist));
+
+	for (idx = 0; idx < ARRAY_SIZE(testlist); idx++) {
+		if (!testlist[idx].needs_cap || has_s390_vcpu_resets) {
+			testlist[idx].test();
+			ksft_test_result_pass("%s\n", testlist[idx].name);
+		} else {
+			ksft_test_result_skip("%s - no VCPU_RESETS capability\n",
+					      testlist[idx].name);
+		}
 	}
-	return 0;
+
+	ksft_finished();	/* Print results and exit() accordingly */
 }
-- 
2.35.1

