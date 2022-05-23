Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA82530DD2
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 12:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233650AbiEWJ4p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 05:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233706AbiEWJ4g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 05:56:36 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0DA25F65;
        Mon, 23 May 2022 02:56:34 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24N8QVHP025985;
        Mon, 23 May 2022 09:56:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=cq3/GyAiL8SasLhjOTeasd+ZAk/uxnedlv68Liwuf+Q=;
 b=RANknKloJWDeC/3X/sIwDmwgrAKyCw/VcxOVnpM8+XtaPdjedWZRHkny/iAWJzikgLV0
 TSb6ErZnoBfHlKe/NOo9R65joU+Af6WCssscaPVsrdDa3414aF7X5ZOuHD0qLp9cyko3
 BfQ692CZXe/mIYNA8vKBd+Z2xCgdPTiHR23XA1c4chWLWpOK/ByV/N1xJgoIUJ7jgt+f
 BpQXq6946d5DDpA+xWq3r1L8KaOa+2xpOqI5Ujw2ID80s3UMNbA/v1HiguJV5HMdTLcw
 GlJRRsUxkd52LAC4o4Y0/6YFv/0Eb8xkeaXZRkRkfvp44Hc0gs4HCvOwh3JQFy/d9hpz lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g79f59hjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 09:56:33 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24N9q7S3015177;
        Mon, 23 May 2022 09:56:32 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g79f59hhn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 09:56:32 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24N9bBaO017984;
        Mon, 23 May 2022 09:56:30 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3g6qq92jy3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 09:56:30 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24N9uRDL22086020
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 May 2022 09:56:27 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6EDC5204E;
        Mon, 23 May 2022 09:56:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id D599C5204F;
        Mon, 23 May 2022 09:56:26 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id A6FA8E7962; Mon, 23 May 2022 11:56:26 +0200 (CEST)
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
Subject: [GIT PULL 4/4] KVM: s390: selftest: Test suppression indication on key prot exception
Date:   Mon, 23 May 2022 11:56:25 +0200
Message-Id: <20220523095625.13913-5-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220523095625.13913-1-borntraeger@linux.ibm.com>
References: <20220523095625.13913-1-borntraeger@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 95h6uRVGVhM1RkDkMDI14THDanxokYa6
X-Proofpoint-ORIG-GUID: Zjo0qOn1TZlrbZ0KGfsXP-lCKH7R9PcT
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-23_03,2022-05-20_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 impostorscore=0 mlxscore=0 suspectscore=0 clxscore=1015 phishscore=0
 mlxlogscore=999 adultscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205230051
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Check that suppression is not indicated on injection of a key checked
protection exception caused by a memop after it already modified guest
memory, as that violates the definition of suppression.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Link: https://lore.kernel.org/r/20220512131019.2594948-3-scgl@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 tools/testing/selftests/kvm/s390x/memop.c | 46 ++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/s390x/memop.c b/tools/testing/selftests/kvm/s390x/memop.c
index b04c2c1b3c30..49f26f544127 100644
--- a/tools/testing/selftests/kvm/s390x/memop.c
+++ b/tools/testing/selftests/kvm/s390x/memop.c
@@ -10,6 +10,8 @@
 #include <string.h>
 #include <sys/ioctl.h>
 
+#include <linux/bits.h>
+
 #include "test_util.h"
 #include "kvm_util.h"
 
@@ -194,6 +196,7 @@ static int err_memop_ioctl(struct test_vcpu vcpu, struct kvm_s390_mem_op *ksmo)
 #define SIDA_OFFSET(o) ._sida_offset = 1, .sida_offset = (o)
 #define AR(a) ._ar = 1, .ar = (a)
 #define KEY(a) .f_key = 1, .key = (a)
+#define INJECT .f_inject = 1
 
 #define CHECK_N_DO(f, ...) ({ f(__VA_ARGS__, CHECK_ONLY); f(__VA_ARGS__); })
 
@@ -430,9 +433,18 @@ static void test_copy_key_fetch_prot(void)
 	TEST_ASSERT(rv == 4, "Should result in protection exception");		\
 })
 
+static void guest_error_key(void)
+{
+	GUEST_SYNC(STAGE_INITED);
+	set_storage_key_range(mem1, PAGE_SIZE, 0x18);
+	set_storage_key_range(mem1 + PAGE_SIZE, sizeof(mem1) - PAGE_SIZE, 0x98);
+	GUEST_SYNC(STAGE_SKEYS_SET);
+	GUEST_SYNC(STAGE_IDLED);
+}
+
 static void test_errors_key(void)
 {
-	struct test_default t = test_default_init(guest_copy_key_fetch_prot);
+	struct test_default t = test_default_init(guest_error_key);
 
 	HOST_SYNC(t.vcpu, STAGE_INITED);
 	HOST_SYNC(t.vcpu, STAGE_SKEYS_SET);
@@ -446,6 +458,37 @@ static void test_errors_key(void)
 	kvm_vm_free(t.kvm_vm);
 }
 
+static void test_termination(void)
+{
+	struct test_default t = test_default_init(guest_error_key);
+	uint64_t prefix;
+	uint64_t teid;
+	uint64_t teid_mask = BIT(63 - 56) | BIT(63 - 60) | BIT(63 - 61);
+	uint64_t psw[2];
+
+	HOST_SYNC(t.vcpu, STAGE_INITED);
+	HOST_SYNC(t.vcpu, STAGE_SKEYS_SET);
+
+	/* vcpu, mismatching keys after first page */
+	ERR_PROT_MOP(t.vcpu, LOGICAL, WRITE, mem1, t.size, GADDR_V(mem1), KEY(1), INJECT);
+	/*
+	 * The memop injected a program exception and the test needs to check the
+	 * Translation-Exception Identification (TEID). It is necessary to run
+	 * the guest in order to be able to read the TEID from guest memory.
+	 * Set the guest program new PSW, so the guest state is not clobbered.
+	 */
+	prefix = t.run->s.regs.prefix;
+	psw[0] = t.run->psw_mask;
+	psw[1] = t.run->psw_addr;
+	MOP(t.vm, ABSOLUTE, WRITE, psw, sizeof(psw), GADDR(prefix + 464));
+	HOST_SYNC(t.vcpu, STAGE_IDLED);
+	MOP(t.vm, ABSOLUTE, READ, &teid, sizeof(teid), GADDR(prefix + 168));
+	/* Bits 56, 60, 61 form a code, 0 being the only one allowing for termination */
+	ASSERT_EQ(teid & teid_mask, 0);
+
+	kvm_vm_free(t.kvm_vm);
+}
+
 static void test_errors_key_storage_prot_override(void)
 {
 	struct test_default t = test_default_init(guest_copy_key_fetch_prot);
@@ -668,6 +711,7 @@ int main(int argc, char *argv[])
 		test_copy_key_fetch_prot();
 		test_copy_key_fetch_prot_override();
 		test_errors_key();
+		test_termination();
 		test_errors_key_storage_prot_override();
 		test_errors_key_fetch_prot_override_not_enabled();
 		test_errors_key_fetch_prot_override_enabled();
-- 
2.35.1

