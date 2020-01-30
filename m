Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB58814DAA9
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 13:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbgA3MfC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 07:35:02 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:7644 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727191AbgA3MfC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jan 2020 07:35:02 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00UCGfaP103535
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2020 07:35:00 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xttnuujr4-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2020 07:34:59 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 30 Jan 2020 12:34:56 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 30 Jan 2020 12:34:54 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00UCY2in41025948
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Jan 2020 12:34:02 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D144B52051;
        Thu, 30 Jan 2020 12:34:53 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.44])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 549415204F;
        Thu, 30 Jan 2020 12:34:52 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, borntraeger@de.ibm.com, david@redhat.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
Subject: [PATCH v9 6/6] selftests: KVM: testing the local IRQs resets
Date:   Thu, 30 Jan 2020 07:34:34 -0500
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200130123434.68129-1-frankja@linux.ibm.com>
References: <20200130123434.68129-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20013012-4275-0000-0000-0000039C69AF
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20013012-4276-0000-0000-000038B08759
Message-Id: <20200130123434.68129-7-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-30_03:2020-01-28,2020-01-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 spamscore=0 impostorscore=0 phishscore=0 bulkscore=0 suspectscore=3
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2001300091
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Pierre Morel <pmorel@linux.ibm.com>

Local IRQs are reset by a normal cpu reset.  The initial cpu reset and
the clear cpu reset, as superset of the normal reset, both clear the
IRQs too.

Let's inject an interrupt to a vCPU before calling a reset and see if
it is gone after the reset.

We choose to inject only an emergency interrupt at this point and can
extend the test to other types of IRQs later.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>[minor fixups]
---
 tools/testing/selftests/kvm/s390x/resets.c | 46 ++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/tools/testing/selftests/kvm/s390x/resets.c b/tools/testing/selftests/kvm/s390x/resets.c
index 4e173517f909..8a2507930e7d 100644
--- a/tools/testing/selftests/kvm/s390x/resets.c
+++ b/tools/testing/selftests/kvm/s390x/resets.c
@@ -14,6 +14,9 @@
 #include "kvm_util.h"
 
 #define VCPU_ID 3
+#define LOCAL_IRQS 32
+
+struct kvm_s390_irq buf[VCPU_ID + LOCAL_IRQS];
 
 struct kvm_vm *vm;
 struct kvm_run *run;
@@ -53,6 +56,27 @@ static void test_one_reg(uint64_t id, uint64_t value)
 	TEST_ASSERT(eval_reg == value, "value == %s", value);
 }
 
+static void assert_noirq(void)
+{
+	struct kvm_s390_irq_state irq_state;
+	int irqs;
+
+	if (!(kvm_check_cap(KVM_CAP_S390_INJECT_IRQ) &&
+	    kvm_check_cap(KVM_CAP_S390_IRQ_STATE)))
+		return;
+
+	irq_state.len = sizeof(buf);
+	irq_state.buf = (unsigned long)buf;
+	irqs = _vcpu_ioctl(vm, VCPU_ID, KVM_S390_GET_IRQ_STATE, &irq_state);
+	/*
+	 * irqs contains the number of retrieved interrupts, apart from the
+	 * emergency call that should be cleared by the resets, there should be
+	 * none.
+	 */
+	TEST_ASSERT(irqs >= 0, "Could not fetch IRQs: errno %d\n", errno);
+	TEST_ASSERT(!irqs, "IRQ pending");
+}
+
 static void assert_clear(void)
 {
 	struct kvm_sregs sregs;
@@ -94,6 +118,22 @@ static void assert_initial(void)
 static void assert_normal(void)
 {
 	test_one_reg(KVM_REG_S390_PFTOKEN, KVM_S390_PFAULT_TOKEN_INVALID);
+	assert_noirq();
+}
+
+static void inject_irq(int cpu_id)
+{
+	struct kvm_s390_irq_state irq_state;
+	struct kvm_s390_irq *irq = &buf[0];
+	int irqs;
+
+	/* Inject IRQ */
+	irq_state.len = sizeof(struct kvm_s390_irq);
+	irq_state.buf = (unsigned long)buf;
+	irq->type = KVM_S390_INT_EMERGENCY;
+	irq->u.emerg.code = cpu_id;
+	irqs = _vcpu_ioctl(vm, cpu_id, KVM_S390_SET_IRQ_STATE, &irq_state);
+	TEST_ASSERT(irqs >= 0, "Error injecting EMERGENCY IRQ errno %d\n", errno);
 }
 
 static void test_normal(void)
@@ -106,6 +146,8 @@ static void test_normal(void)
 
 	vcpu_run(vm, VCPU_ID);
 
+	inject_irq(VCPU_ID);
+
 	vcpu_ioctl(vm, VCPU_ID, KVM_S390_NORMAL_RESET, 0);
 	assert_normal();
 	kvm_vm_free(vm);
@@ -121,6 +163,8 @@ static void test_initial(void)
 
 	vcpu_run(vm, VCPU_ID);
 
+	inject_irq(VCPU_ID);
+
 	vcpu_ioctl(vm, VCPU_ID, KVM_S390_INITIAL_RESET, 0);
 	assert_normal();
 	assert_initial();
@@ -137,6 +181,8 @@ static void test_clear(void)
 
 	vcpu_run(vm, VCPU_ID);
 
+	inject_irq(VCPU_ID);
+
 	vcpu_ioctl(vm, VCPU_ID, KVM_S390_CLEAR_RESET, 0);
 	assert_normal();
 	assert_initial();
-- 
2.20.1

