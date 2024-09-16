Return-Path: <kvm+bounces-26974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C49F8979FAC
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 12:46:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81A72286C52
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2024 10:46:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 512EB1547C8;
	Mon, 16 Sep 2024 10:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="egRTU+b8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84288145341;
	Mon, 16 Sep 2024 10:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726483557; cv=none; b=WOd1gWmwQEZ24ykJ6VcCd8u2CxCNLEn8fsb9Ronp2InknFbKBcY3zolvvcyAQP4ss3epmukMMnBeJxlV7EZjRxv6/Fp+3UyIrlqvWLM2xiBoR63CFHb8TOVMf7kY+psyneJuodMNyQSkpgg688ccqjjL9SjDh8vSQr6muFjq7C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726483557; c=relaxed/simple;
	bh=xpAYmVkuDb3jvuGQAPJjKWVFAtUGdu6vJY1oEdSf4rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xn44yPfHiKWpnAjqjw7ez0MHLOV/5Ldap+KpdA7eW+ZV2CTDdUlqCfJS0s8SCnym3rxnFdss4JqbR8+n/sJ0y4xGf1sTrAPW/50jLsIOK3EGnRljDGEQhM9Z7A6vHlZ4RhYYXSFqtqYdEdOebHURjw+oxMLX0rpuS9Bg6EpRB4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=egRTU+b8; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48FHOtef017982;
	Mon, 16 Sep 2024 10:45:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:mime-version; s=pp1; bh=u00xHdrAkQEE5
	dyQFXGc6kt6WclaWDKMbTdiuH2nUzM=; b=egRTU+b8/tSeFKQvO2WMfa3m54vrq
	P2/XqeNqjayrKMsVo7gA4eSMp9K7mU6b4Jo8swhq8A+p7B+7qA8cnBoDdE3sQF3Z
	xgmGJ/3lUEVF0Xf9eNHQB/PzsVeLy2nAsn9ubIw5YvCY2PVOnFwrR6Bn7g6KS44z
	vqv8G7f9GWU3+pVV7UUU3PaXT+SknVaomTNGFpXHDiWgCT+T3hbLmZD0qMSSwwpk
	LnrbxMXuTJmG7eFwD6l7OU+yw0OCl3yJS5mzEWHw+9lmZWFYVyNvuGVELhY80YmT
	1lLJkovL3XtMPRxH7Ux/HhrniIjagwWD7kbtL/y7P7rp5MziIXlFnyYUg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41n3vd99vc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Sep 2024 10:45:49 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 48GAi2kZ026523;
	Mon, 16 Sep 2024 10:45:48 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41n3vd99v5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Sep 2024 10:45:48 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48GACViM001785;
	Mon, 16 Sep 2024 10:45:48 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 41nqh3ecjd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Sep 2024 10:45:47 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48GAji9W59703630
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Sep 2024 10:45:44 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 68BCE20040;
	Mon, 16 Sep 2024 10:45:44 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0C48E20049;
	Mon, 16 Sep 2024 10:45:44 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.179.30.170])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 16 Sep 2024 10:45:43 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
Subject: [GIT PULL 7/8] selftests: kvm: s390: Add VM run test case
Date: Mon, 16 Sep 2024 12:43:02 +0200
Message-ID: <20240916104458.66521-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916104458.66521-1-frankja@linux.ibm.com>
References: <20240916104458.66521-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LKh0q1cihEYg2-oGYFjMxcjSAdutt1sH
X-Proofpoint-GUID: UhGEOyNT1Wyq2JdXnAXu6pVX-bqIh0X2
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-16_06,2024-09-13_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 clxscore=1015 mlxscore=0
 malwarescore=0 mlxlogscore=728 priorityscore=1501 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2409160065

From: Christoph Schlameuss <schlameuss@linux.ibm.com>

Add test case running code interacting with registers within a
ucontrol VM.

* Add uc_gprs test case

The test uses the same VM setup using the fixture and debug macros
introduced in earlier patches in this series.

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20240807154512.316936-7-schlameuss@linux.ibm.com
[frankja@linux.ibm.com: Removed leftover comment line]
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-ID: <20240807154512.316936-7-schlameuss@linux.ibm.com>
---
 .../selftests/kvm/s390x/ucontrol_test.c       | 125 ++++++++++++++++++
 1 file changed, 125 insertions(+)

diff --git a/tools/testing/selftests/kvm/s390x/ucontrol_test.c b/tools/testing/selftests/kvm/s390x/ucontrol_test.c
index d103a92e7495..f257beec1430 100644
--- a/tools/testing/selftests/kvm/s390x/ucontrol_test.c
+++ b/tools/testing/selftests/kvm/s390x/ucontrol_test.c
@@ -7,6 +7,7 @@
  * Authors:
  *  Christoph Schlameuss <schlameuss@linux.ibm.com>
  */
+#include "debug_print.h"
 #include "kselftest_harness.h"
 #include "kvm_util.h"
 #include "processor.h"
@@ -40,6 +41,23 @@ void require_ucontrol_admin(void)
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_S390_UCONTROL));
 }
 
+/* Test program setting some registers and looping */
+extern char test_gprs_asm[];
+asm("test_gprs_asm:\n"
+	"xgr	%r0, %r0\n"
+	"lgfi	%r1,1\n"
+	"lgfi	%r2,2\n"
+	"lgfi	%r3,3\n"
+	"lgfi	%r4,4\n"
+	"lgfi	%r5,5\n"
+	"lgfi	%r6,6\n"
+	"lgfi	%r7,7\n"
+	"0:\n"
+	"	diag	0,0,0x44\n"
+	"	ahi	%r0,1\n"
+	"	j	0b\n"
+);
+
 FIXTURE(uc_kvm)
 {
 	struct kvm_s390_sie_block *sie_block;
@@ -204,4 +222,111 @@ TEST(uc_cap_hpage)
 	close(kvm_fd);
 }
 
+/* verify SIEIC exit
+ * * fail on codes not expected in the test cases
+ */
+static bool uc_handle_sieic(FIXTURE_DATA(uc_kvm) * self)
+{
+	struct kvm_s390_sie_block *sie_block = self->sie_block;
+	struct kvm_run *run = self->run;
+
+	/* check SIE interception code */
+	pr_info("sieic: 0x%.2x 0x%.4x 0x%.4x\n",
+		run->s390_sieic.icptcode,
+		run->s390_sieic.ipa,
+		run->s390_sieic.ipb);
+	switch (run->s390_sieic.icptcode) {
+	case ICPT_INST:
+		/* end execution in caller on intercepted instruction */
+		pr_info("sie instruction interception\n");
+		return false;
+	case ICPT_OPEREXC:
+		/* operation exception */
+		TEST_FAIL("sie exception on %.4x%.8x", sie_block->ipa, sie_block->ipb);
+	default:
+		TEST_FAIL("UNEXPECTED SIEIC CODE %d", run->s390_sieic.icptcode);
+	}
+	return true;
+}
+
+/* verify VM state on exit */
+static bool uc_handle_exit(FIXTURE_DATA(uc_kvm) * self)
+{
+	struct kvm_run *run = self->run;
+
+	switch (run->exit_reason) {
+	case KVM_EXIT_S390_SIEIC:
+		return uc_handle_sieic(self);
+	default:
+		pr_info("exit_reason %2d not handled\n", run->exit_reason);
+	}
+	return true;
+}
+
+/* run the VM until interrupted */
+static int uc_run_once(FIXTURE_DATA(uc_kvm) * self)
+{
+	int rc;
+
+	rc = ioctl(self->vcpu_fd, KVM_RUN, NULL);
+	print_run(self->run, self->sie_block);
+	print_regs(self->run);
+	pr_debug("run %d / %d %s\n", rc, errno, strerror(errno));
+	return rc;
+}
+
+static void uc_assert_diag44(FIXTURE_DATA(uc_kvm) * self)
+{
+	struct kvm_s390_sie_block *sie_block = self->sie_block;
+
+	/* assert vm was interrupted by diag 0x0044 */
+	TEST_ASSERT_EQ(KVM_EXIT_S390_SIEIC, self->run->exit_reason);
+	TEST_ASSERT_EQ(ICPT_INST, sie_block->icptcode);
+	TEST_ASSERT_EQ(0x8300, sie_block->ipa);
+	TEST_ASSERT_EQ(0x440000, sie_block->ipb);
+}
+
+TEST_F(uc_kvm, uc_gprs)
+{
+	struct kvm_sync_regs *sync_regs = &self->run->s.regs;
+	struct kvm_run *run = self->run;
+	struct kvm_regs regs = {};
+
+	/* Set registers to values that are different from the ones that we expect below */
+	for (int i = 0; i < 8; i++)
+		sync_regs->gprs[i] = 8;
+	run->kvm_dirty_regs |= KVM_SYNC_GPRS;
+
+	/* copy test_gprs_asm to code_hva / code_gpa */
+	TH_LOG("copy code %p to vm mapped memory %p / %p",
+	       &test_gprs_asm, (void *)self->code_hva, (void *)self->code_gpa);
+	memcpy((void *)self->code_hva, &test_gprs_asm, PAGE_SIZE);
+
+	/* DAT disabled + 64 bit mode */
+	run->psw_mask = 0x0000000180000000ULL;
+	run->psw_addr = self->code_gpa;
+
+	/* run and expect interception of diag 44 */
+	ASSERT_EQ(0, uc_run_once(self));
+	ASSERT_EQ(false, uc_handle_exit(self));
+	uc_assert_diag44(self);
+
+	/* Retrieve and check guest register values */
+	ASSERT_EQ(0, ioctl(self->vcpu_fd, KVM_GET_REGS, &regs));
+	for (int i = 0; i < 8; i++) {
+		ASSERT_EQ(i, regs.gprs[i]);
+		ASSERT_EQ(i, sync_regs->gprs[i]);
+	}
+
+	/* run and expect interception of diag 44 again */
+	ASSERT_EQ(0, uc_run_once(self));
+	ASSERT_EQ(false, uc_handle_exit(self));
+	uc_assert_diag44(self);
+
+	/* check continued increment of register 0 value */
+	ASSERT_EQ(0, ioctl(self->vcpu_fd, KVM_GET_REGS, &regs));
+	ASSERT_EQ(1, regs.gprs[0]);
+	ASSERT_EQ(1, sync_regs->gprs[0]);
+}
+
 TEST_HARNESS_MAIN
-- 
2.46.0


