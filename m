Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8F4C17FC9E
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 14:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730876AbgCJNWM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 09:22:12 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35544 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730313AbgCJNBt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Mar 2020 09:01:49 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02ACwvxj092202;
        Tue, 10 Mar 2020 09:01:48 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ym8n8jx9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Mar 2020 09:01:48 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 02ACxB05093256;
        Tue, 10 Mar 2020 09:01:47 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ym8n8jx8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Mar 2020 09:01:47 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 02ACtZAd021229;
        Tue, 10 Mar 2020 13:01:46 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma01dal.us.ibm.com with ESMTP id 2ym386sd1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Mar 2020 13:01:46 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02AD1kwG51183920
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Mar 2020 13:01:46 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DFC6728060;
        Tue, 10 Mar 2020 13:01:45 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA8172805E;
        Tue, 10 Mar 2020 13:01:45 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 10 Mar 2020 13:01:45 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3/5] selftests: KVM: s390: check for registers to NOT change on reset
Date:   Tue, 10 Mar 2020 09:01:42 -0400
Message-Id: <20200310130144.9921-4-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200310130144.9921-1-borntraeger@de.ibm.com>
References: <20200310130144.9921-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-10_06:2020-03-10,2020-03-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 mlxlogscore=999 mlxscore=0 suspectscore=2 spamscore=0
 phishscore=0 bulkscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003100087
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Normal reset and initial CPU reset do not clear all registers. Add a
test that those registers are NOT changed.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 tools/testing/selftests/kvm/s390x/resets.c | 55 +++++++++++++++++++++-
 1 file changed, 53 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/s390x/resets.c b/tools/testing/selftests/kvm/s390x/resets.c
index c385842792b7..b567705f0d41 100644
--- a/tools/testing/selftests/kvm/s390x/resets.c
+++ b/tools/testing/selftests/kvm/s390x/resets.c
@@ -40,8 +40,22 @@ static void guest_code_initial(void)
 		"	lctlg	8,8,%1\n"
 		"	lctlg	10,10,%2\n"
 		"	lctlg	11,11,%3\n"
-		: : "m" (cr2_59), "m" (cr8_63), "m" (cr10), "m" (cr11) : "2");
-	GUEST_SYNC(0);
+		/* now clobber some general purpose regs */
+		"	llihh	0,0xffff\n"
+		"	llihl	1,0x5555\n"
+		"	llilh	2,0xaaaa\n"
+		"	llill	3,0x0000\n"
+		/* now clobber a floating point reg */
+		"	lghi	4,0x1\n"
+		"	cdgbr	0,4\n"
+		/* now clobber an access reg */
+		"	sar	9,4\n"
+		/* We embed diag 501 here to control register content */
+		"	diag 0,0,0x501\n"
+		:
+		: "m" (cr2_59), "m" (cr8_63), "m" (cr10), "m" (cr11)
+		/* no clobber list as this should not return */
+		);
 }
 
 static void test_one_reg(uint64_t id, uint64_t value)
@@ -98,6 +112,21 @@ static void assert_clear(void)
 		    "vrs0-15 == 0 (sync_regs)");
 }
 
+static void assert_initial_noclear(void)
+{
+	TEST_ASSERT(sync_regs->gprs[0] == 0xffff000000000000UL,
+		    "gpr0 == 0xffff000000000000 (sync_regs)");
+	TEST_ASSERT(sync_regs->gprs[1] == 0x0000555500000000UL,
+		    "gpr1 == 0x0000555500000000 (sync_regs)");
+	TEST_ASSERT(sync_regs->gprs[2] == 0x00000000aaaa0000UL,
+		    "gpr2 == 0x00000000aaaa0000 (sync_regs)");
+	TEST_ASSERT(sync_regs->gprs[3] == 0x0000000000000000UL,
+		    "gpr3 == 0x0000000000000000 (sync_regs)");
+	TEST_ASSERT(sync_regs->fprs[0] == 0x3ff0000000000000UL,
+		    "fpr0 == 0f1 (sync_regs)");
+	TEST_ASSERT(sync_regs->acrs[9] == 1, "ar9 == 1 (sync_regs)");
+}
+
 static void assert_initial(void)
 {
 	struct kvm_sregs sregs;
@@ -140,6 +169,14 @@ static void assert_initial(void)
 	test_one_reg(KVM_REG_S390_CLOCK_COMP, 0);
 }
 
+static void assert_normal_noclear(void)
+{
+	TEST_ASSERT(sync_regs->crs[2] == 0x10, "cr2 == 10 (sync_regs)");
+	TEST_ASSERT(sync_regs->crs[8] == 1, "cr10 == 1 (sync_regs)");
+	TEST_ASSERT(sync_regs->crs[10] == 1, "cr10 == 1 (sync_regs)");
+	TEST_ASSERT(sync_regs->crs[11] == -1, "cr11 == -1 (sync_regs)");
+}
+
 static void assert_normal(void)
 {
 	test_one_reg(KVM_REG_S390_PFTOKEN, KVM_S390_PFAULT_TOKEN_INVALID);
@@ -176,7 +213,13 @@ static void test_normal(void)
 	inject_irq(VCPU_ID);
 
 	vcpu_ioctl(vm, VCPU_ID, KVM_S390_NORMAL_RESET, 0);
+
+	/* must clears */
 	assert_normal();
+	/* must not clears */
+	assert_normal_noclear();
+	assert_initial_noclear();
+
 	kvm_vm_free(vm);
 }
 
@@ -192,8 +235,13 @@ static void test_initial(void)
 	inject_irq(VCPU_ID);
 
 	vcpu_ioctl(vm, VCPU_ID, KVM_S390_INITIAL_RESET, 0);
+
+	/* must clears */
 	assert_normal();
 	assert_initial();
+	/* must not clears */
+	assert_initial_noclear();
+
 	kvm_vm_free(vm);
 }
 
@@ -209,9 +257,12 @@ static void test_clear(void)
 	inject_irq(VCPU_ID);
 
 	vcpu_ioctl(vm, VCPU_ID, KVM_S390_CLEAR_RESET, 0);
+
+	/* must clears */
 	assert_normal();
 	assert_initial();
 	assert_clear();
+
 	kvm_vm_free(vm);
 }
 
-- 
2.25.0

