Return-Path: <kvm+bounces-31633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 16D1F9C5D26
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 17:27:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA24E2837C0
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 16:27:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C35FC20651A;
	Tue, 12 Nov 2024 16:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="D3cMsP2F"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB7520604D;
	Tue, 12 Nov 2024 16:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731428780; cv=none; b=NyXv8ylocMp/Z3bCQ7K9A7YDxrD87EZFnjYkeAbz7O1Zwq5jHxzVWd+5xvhKevNkww6r7/mB2210VkzG1cQve8LfKjWKrohwvc8FYbSVHyUhpWlE/ndSzVr2k3OLYPFQkjKepxktiLq21Nu85mKObZVFRpnorXCdO9EYp7LMiX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731428780; c=relaxed/simple;
	bh=kM9S7b2G36nRfypllBSq9izBSiJQesTDGXabjV/VaO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6xAs/vNqKGle8jHexEnjUFZbasC7+SGy9lMfIpUzUMjpVcNlEG0MMPgXvzOYAv3am8EL3aBgDUPBm5xCEP4Tk4qtmMaCEGwwXFH5WCox26/YMf3l6Sp+DRfc0pRBdZxa61N02gMyLf7+tFKMM1J9fq0+RR4zLfMGNnPiHBZRyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=D3cMsP2F; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACFA3Nb032755;
	Tue, 12 Nov 2024 16:26:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=NZccN8EYhgJ4vRRO9
	VTXCB2FC+f5SNupbnQXLmB+zqU=; b=D3cMsP2Fg8aiA5DH9asImBGeneOpDvGK0
	GgCLdM4xqqMhJpoNBVreZiNxlBtZcW5AD2J6CTDyZZqmOVx7bL2Erp3KgN5qWPIA
	3a6KmmfcVoGCPXlnfM+99CkSLUvCBIn7vbU9uQpFqvh8V+lH8IaURNMpO8cuQaXX
	YuVzA9whJ2yzQ8hNPfiAns1T7V55TXCzxwZ8cRyDxKGh/nHu6VKWQxgYu9kyZqOx
	7Sju8ytjZH7k0EzYB2YWtw5ONtQmCIKulBCrxmca0v0M8gNAemhXTvDjym6bMPty
	gDw4+qthL4d809icjyU7+s5ubKAydLwX8jEy+zT+QpLuoY6Qjbi1g==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42v9dv0amf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Nov 2024 16:26:14 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4ACG0rsI029707;
	Tue, 12 Nov 2024 16:26:13 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 42tkjktqwp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Nov 2024 16:26:13 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4ACGQ96u37683638
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Nov 2024 16:26:10 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D36CA20049;
	Tue, 12 Nov 2024 16:26:09 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6BDF320040;
	Tue, 12 Nov 2024 16:26:09 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.fritz.box (unknown [9.179.25.251])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 12 Nov 2024 16:26:09 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
Subject: [GIT PULL 07/14] KVM: s390: selftests: Add uc_skey VM test case
Date: Tue, 12 Nov 2024 17:23:21 +0100
Message-ID: <20241112162536.144980-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112162536.144980-1-frankja@linux.ibm.com>
References: <20241112162536.144980-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LLYvAZapWtYLAYNq8ui7wszuWBF6XpoV
X-Proofpoint-ORIG-GUID: LLYvAZapWtYLAYNq8ui7wszuWBF6XpoV
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 bulkscore=0 malwarescore=0 adultscore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 mlxlogscore=977 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2411120128

From: Christoph Schlameuss <schlameuss@linux.ibm.com>

Add a test case manipulating s390 storage keys from within the ucontrol
VM.

Storage key instruction (ISKE, SSKE and RRBE) intercepts and
Keyless-subset facility are disabled on first use, where the skeys are
setup by KVM in non ucontrol VMs.

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Link: https://lore.kernel.org/r/20241108091620.289406-1-schlameuss@linux.ibm.com
Acked-by: Janosch Frank <frankja@linux.ibm.com>
[frankja@linux.ibm.com: Fixed patch prefix]
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Message-ID: <20241108091620.289406-1-schlameuss@linux.ibm.com>
---
 .../selftests/kvm/include/s390x/processor.h   |   6 +
 .../selftests/kvm/s390x/ucontrol_test.c       | 145 +++++++++++++++++-
 2 files changed, 149 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/s390x/processor.h b/tools/testing/selftests/kvm/include/s390x/processor.h
index 481bd2fd6a32..33fef6fd9617 100644
--- a/tools/testing/selftests/kvm/include/s390x/processor.h
+++ b/tools/testing/selftests/kvm/include/s390x/processor.h
@@ -32,4 +32,10 @@ static inline void cpu_relax(void)
 	barrier();
 }
 
+/* Get the instruction length */
+static inline int insn_length(unsigned char code)
+{
+	return ((((int)code + 64) >> 7) + 1) << 1;
+}
+
 #endif
diff --git a/tools/testing/selftests/kvm/s390x/ucontrol_test.c b/tools/testing/selftests/kvm/s390x/ucontrol_test.c
index 3e649b12a0b9..ad95087cc74c 100644
--- a/tools/testing/selftests/kvm/s390x/ucontrol_test.c
+++ b/tools/testing/selftests/kvm/s390x/ucontrol_test.c
@@ -79,6 +79,33 @@ asm("test_mem_asm:\n"
 	"	j	0b\n"
 );
 
+/* Test program manipulating storage keys */
+extern char test_skey_asm[];
+asm("test_skey_asm:\n"
+	"xgr	%r0, %r0\n"
+
+	"0:\n"
+	"	ahi	%r0,1\n"
+	"	st	%r1,0(%r5,%r6)\n"
+
+	"	iske	%r1,%r6\n"
+	"	ahi	%r0,1\n"
+	"	diag	0,0,0x44\n"
+
+	"	sske	%r1,%r6\n"
+	"	xgr	%r1,%r1\n"
+	"	iske	%r1,%r6\n"
+	"	ahi	%r0,1\n"
+	"	diag	0,0,0x44\n"
+
+	"	rrbe	%r1,%r6\n"
+	"	iske	%r1,%r6\n"
+	"	ahi	%r0,1\n"
+	"	diag	0,0,0x44\n"
+
+	"	j	0b\n"
+);
+
 FIXTURE(uc_kvm)
 {
 	struct kvm_s390_sie_block *sie_block;
@@ -298,8 +325,50 @@ static void uc_handle_exit_ucontrol(FIXTURE_DATA(uc_kvm) *self)
 	}
 }
 
-/* verify SIEIC exit
+/*
+ * Handle the SIEIC exit
  * * fail on codes not expected in the test cases
+ * Returns if interception is handled / execution can be continued
+ */
+static void uc_skey_enable(FIXTURE_DATA(uc_kvm) *self)
+{
+	struct kvm_s390_sie_block *sie_block = self->sie_block;
+
+	/* disable KSS */
+	sie_block->cpuflags &= ~CPUSTAT_KSS;
+	/* disable skey inst interception */
+	sie_block->ictl &= ~(ICTL_ISKE | ICTL_SSKE | ICTL_RRBE);
+}
+
+/*
+ * Handle the instruction intercept
+ * Returns if interception is handled / execution can be continued
+ */
+static bool uc_handle_insn_ic(FIXTURE_DATA(uc_kvm) *self)
+{
+	struct kvm_s390_sie_block *sie_block = self->sie_block;
+	int ilen = insn_length(sie_block->ipa >> 8);
+	struct kvm_run *run = self->run;
+
+	switch (run->s390_sieic.ipa) {
+	case 0xB229: /* ISKE */
+	case 0xB22b: /* SSKE */
+	case 0xB22a: /* RRBE */
+		uc_skey_enable(self);
+
+		/* rewind to reexecute intercepted instruction */
+		run->psw_addr = run->psw_addr - ilen;
+		pr_info("rewind guest addr to 0x%.16llx\n", run->psw_addr);
+		return true;
+	default:
+		return false;
+	}
+}
+
+/*
+ * Handle the SIEIC exit
+ * * fail on codes not expected in the test cases
+ * Returns if interception is handled / execution can be continued
  */
 static bool uc_handle_sieic(FIXTURE_DATA(uc_kvm) * self)
 {
@@ -315,7 +384,10 @@ static bool uc_handle_sieic(FIXTURE_DATA(uc_kvm) * self)
 	case ICPT_INST:
 		/* end execution in caller on intercepted instruction */
 		pr_info("sie instruction interception\n");
-		return false;
+		return uc_handle_insn_ic(self);
+	case ICPT_KSS:
+		uc_skey_enable(self);
+		return true;
 	case ICPT_OPEREXC:
 		/* operation exception */
 		TEST_FAIL("sie exception on %.4x%.8x", sie_block->ipa, sie_block->ipb);
@@ -472,4 +544,73 @@ TEST_F(uc_kvm, uc_gprs)
 	ASSERT_EQ(1, sync_regs->gprs[0]);
 }
 
+TEST_F(uc_kvm, uc_skey)
+{
+	struct kvm_s390_sie_block *sie_block = self->sie_block;
+	struct kvm_sync_regs *sync_regs = &self->run->s.regs;
+	u64 test_vaddr = VM_MEM_SIZE - (SZ_1M / 2);
+	struct kvm_run *run = self->run;
+	const u8 skeyvalue = 0x34;
+
+	/* copy test_skey_asm to code_hva / code_gpa */
+	TH_LOG("copy code %p to vm mapped memory %p / %p",
+	       &test_skey_asm, (void *)self->code_hva, (void *)self->code_gpa);
+	memcpy((void *)self->code_hva, &test_skey_asm, PAGE_SIZE);
+
+	/* set register content for test_skey_asm to access not mapped memory */
+	sync_regs->gprs[1] = skeyvalue;
+	sync_regs->gprs[5] = self->base_gpa;
+	sync_regs->gprs[6] = test_vaddr;
+	run->kvm_dirty_regs |= KVM_SYNC_GPRS;
+
+	/* DAT disabled + 64 bit mode */
+	run->psw_mask = 0x0000000180000000ULL;
+	run->psw_addr = self->code_gpa;
+
+	ASSERT_EQ(0, uc_run_once(self));
+	ASSERT_EQ(true, uc_handle_exit(self));
+	ASSERT_EQ(1, sync_regs->gprs[0]);
+
+	/* ISKE */
+	ASSERT_EQ(0, uc_run_once(self));
+
+	/*
+	 * Bail out and skip the test after uc_skey_enable was executed but iske
+	 * is still intercepted. Instructions are not handled by the kernel.
+	 * Thus there is no need to test this here.
+	 */
+	TEST_ASSERT_EQ(0, sie_block->cpuflags & CPUSTAT_KSS);
+	TEST_ASSERT_EQ(0, sie_block->ictl & (ICTL_ISKE | ICTL_SSKE | ICTL_RRBE));
+	TEST_ASSERT_EQ(KVM_EXIT_S390_SIEIC, self->run->exit_reason);
+	TEST_ASSERT_EQ(ICPT_INST, sie_block->icptcode);
+	TEST_REQUIRE(sie_block->ipa != 0xb229);
+
+	/* ISKE contd. */
+	ASSERT_EQ(false, uc_handle_exit(self));
+	ASSERT_EQ(2, sync_regs->gprs[0]);
+	/* assert initial skey (ACC = 0, R & C = 1) */
+	ASSERT_EQ(0x06, sync_regs->gprs[1]);
+	uc_assert_diag44(self);
+
+	/* SSKE + ISKE */
+	sync_regs->gprs[1] = skeyvalue;
+	run->kvm_dirty_regs |= KVM_SYNC_GPRS;
+	ASSERT_EQ(0, uc_run_once(self));
+	ASSERT_EQ(false, uc_handle_exit(self));
+	ASSERT_EQ(3, sync_regs->gprs[0]);
+	ASSERT_EQ(skeyvalue, sync_regs->gprs[1]);
+	uc_assert_diag44(self);
+
+	/* RRBE + ISKE */
+	sync_regs->gprs[1] = skeyvalue;
+	run->kvm_dirty_regs |= KVM_SYNC_GPRS;
+	ASSERT_EQ(0, uc_run_once(self));
+	ASSERT_EQ(false, uc_handle_exit(self));
+	ASSERT_EQ(4, sync_regs->gprs[0]);
+	/* assert R reset but rest of skey unchanged */
+	ASSERT_EQ(skeyvalue & 0xfa, sync_regs->gprs[1]);
+	ASSERT_EQ(0, sync_regs->gprs[1] & 0x04);
+	uc_assert_diag44(self);
+}
+
 TEST_HARNESS_MAIN
-- 
2.47.0


