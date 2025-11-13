Return-Path: <kvm+bounces-63017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 49DA2C58006
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 15:42:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A05D3A9C49
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 14:33:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AE222C21C6;
	Thu, 13 Nov 2025 14:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fVIgBVN0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE70D273D6D;
	Thu, 13 Nov 2025 14:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763044404; cv=none; b=fdotxvvWHy9/3ZWzP1EvRfbFBYAeTghp9pzP83O9134DrYnntmRUFK7++pYZBbZNZe+CSP+Udrr4knYFl99ygjhh96naHHxAOL96V77jHVXBnenT9qmZN1KYhKata7imG4Gp489fPynE7fqN/hkjZdD02QN474MrsYF2aE5qqkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763044404; c=relaxed/simple;
	bh=SAgPSYL0oeFXVdIm/JOYWtWUH7gHoSO7xlQjUHhvNRo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lTteymDXkEFSAAsbF3qgv1+XuB7Kjz//4zlSS+22iFmMFQ/d5TusDuN8zsBBYYAwBKEnUzzvoMwqesiR3mFCpj4lIFt12NDLXwdcqB/M0pz+vGXvp8cJ2H71YktgmlmCEVNQW9NlxuXEkTi2PXXKCArn9B2v5FuUv8JHemSwMaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fVIgBVN0; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ADEWOTP030681;
	Thu, 13 Nov 2025 14:33:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=0o+zlbQsNurV6yPuCnocbIwulBus14VZFwnY2d23i
	4I=; b=fVIgBVN0HjsyjekY8Q7pTJY5QilOgzS73n2x/2uswR691X3VPj0/n6UIv
	fwJEAfGaYYT2NKPR14CJLHt1FQrEf9BKh9lbn5eE7eFW0D9YQ6HubMofUwbWkQLo
	QURsEjYB6H08MziYXaUdf21toOBJ87wG2QvpNwurGhOnQUZri/cdsebFm69cLZsn
	AKhH270bkWHtOwx3lEoh1W0gjLs57OSfDRfGIm34lw3nJ0CGtEfwBfZeAyc6N+9z
	GfMRJnmLm5RUCg/g5ZTv4Lu5HHC44q9MwuMKrpa4meaFGMG+ymwJhX6wvqfR3HKY
	HDxLyOTw0QA0mQcznCUAqmnqz3OAg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a9wk8gfts-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Nov 2025 14:33:20 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5ADCIxdr007375;
	Thu, 13 Nov 2025 14:33:19 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4aajdjp2vr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Nov 2025 14:33:19 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5ADEXFf062718242
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 14:33:15 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B495620040;
	Thu, 13 Nov 2025 14:33:15 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 90CBC20043;
	Thu, 13 Nov 2025 14:33:15 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 13 Nov 2025 14:33:15 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        borntraeger@linux.ibm.com, thuth@redhat.com
Subject: [PATCH v2] KVM: s390: Add capability that forwards operation exceptions
Date: Thu, 13 Nov 2025 14:32:22 +0000
Message-ID: <20251113143310.4187-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDAyMiBTYWx0ZWRfXwg8wQ0ISjlWU
 kOL1KadZdOxf0/44Pk/1bRTeSnVaPlfbj1dBVc5sakkGLz0VPwGCiCz/o1gZg9m7NJYUTd1kAhh
 fqZDUb30OpBxgGeHdMwWZPWCZEbck2tNuwm3Q/CCGcN6xRALTRbhqR1/ZTe8ldeBZrrXtOiESAy
 5rpjNpgs9F+cn0TnC4MwlecBCSaL3x23GG6A3cL6msZw1Q2bdzfIaAGpR9qGgP7g/XbrB6/LkkK
 eISfdJDL36WE2PWAMLBW1BXiKwp6PcE4HxO/oOvz/EIsfR7H+apB8zTCFxIkvBzBi4eWJ0xtFni
 GssBO6KUKxBbhwfo/pP6yjrQE1D0UIN096uvGzNxZTVJyqSl6nVFrC6yKtPvaRep4bY68NW4+Sy
 d5sqQW65/OlSpf+5OSoOJ1bVUI8eSg==
X-Authority-Analysis: v=2.4 cv=ZK3aWH7b c=1 sm=1 tr=0 ts=6915ec30 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=2J_RzahkHEl8vmpqG00A:9
X-Proofpoint-ORIG-GUID: l1lgQes7MlUj3m4YL0jW-kSxV2P6bsWr
X-Proofpoint-GUID: l1lgQes7MlUj3m4YL0jW-kSxV2P6bsWr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-13_02,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 phishscore=0 impostorscore=0 spamscore=0 bulkscore=0 adultscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511080022

Setting KVM_CAP_S390_USER_OPEREXEC will forward all operation
exceptions to user space. This also includes the 0x0000 instructions
managed by KVM_CAP_S390_USER_INSTR0. It's helpful if user space wants
to emulate instructions which do not (yet) have an opcode.

While we're at it refine the documentation for
KVM_CAP_S390_USER_INSTR0.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---

Reworded api documentation as per Thomas' request.

---
 Documentation/virt/kvm/api.rst                |  17 ++-
 arch/s390/include/asm/kvm_host.h              |   1 +
 arch/s390/kvm/intercept.c                     |   3 +
 arch/s390/kvm/kvm-s390.c                      |   7 +
 include/uapi/linux/kvm.h                      |   1 +
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/s390/user_operexec.c        | 140 ++++++++++++++++++
 7 files changed, 169 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/s390/user_operexec.c

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 72b2fae99a83..9d2b1c08d321 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7820,7 +7820,7 @@ where 0xff represents CPUs 0-7 in cluster 0.
 :Architectures: s390
 :Parameters: none
 
-With this capability enabled, all illegal instructions 0x0000 (2 bytes) will
+With this capability enabled, the illegal instruction 0x0000 (2 bytes) will
 be intercepted and forwarded to user space. User space can use this
 mechanism e.g. to realize 2-byte software breakpoints. The kernel will
 not inject an operating exception for these instructions, user space has
@@ -8703,6 +8703,21 @@ This capability indicate to the userspace whether a PFNMAP memory region
 can be safely mapped as cacheable. This relies on the presence of
 force write back (FWB) feature support on the hardware.
 
+7.45 KVM_CAP_S390_USER_OPEREXEC
+----------------------------
+
+:Architectures: s390
+:Parameters: none
+
+When this capability is enabled KVM forwards all operation exceptions
+that it doesn't handle itself to user space. This also includes the
+0x0000 instructions managed by KVM_CAP_S390_USER_INSTR0. This is
+helpful if user space wants to emulate instructions which are not
+(yet) implemented in hardware.
+
+This capability can be enabled dynamically even if VCPUs were already
+created and are running.
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 22cedcaea475..1e4829c70216 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -648,6 +648,7 @@ struct kvm_arch {
 	int user_sigp;
 	int user_stsi;
 	int user_instr0;
+	int user_operexec;
 	struct s390_io_adapter *adapters[MAX_S390_IO_ADAPTERS];
 	wait_queue_head_t ipte_wq;
 	int ipte_lock_count;
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index c7908950c1f4..420ae62977e2 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -471,6 +471,9 @@ static int handle_operexc(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.sie_block->ipa == 0xb256)
 		return handle_sthyi(vcpu);
 
+	if (vcpu->kvm->arch.user_operexec)
+		return -EOPNOTSUPP;
+
 	if (vcpu->arch.sie_block->ipa == 0 && vcpu->kvm->arch.user_instr0)
 		return -EOPNOTSUPP;
 	rc = read_guest_lc(vcpu, __LC_PGM_NEW_PSW, &newpsw, sizeof(psw_t));
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 70ebc54b1bb1..56d4730b7c41 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -606,6 +606,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_S390_DIAG318:
 	case KVM_CAP_IRQFD_RESAMPLE:
+	case KVM_CAP_S390_USER_OPEREXEC:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
@@ -921,6 +922,12 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 		VM_EVENT(kvm, 3, "ENABLE: CAP_S390_CPU_TOPOLOGY %s",
 			 r ? "(not available)" : "(success)");
 		break;
+	case KVM_CAP_S390_USER_OPEREXEC:
+		VM_EVENT(kvm, 3, "%s", "ENABLE: CAP_S390_USER_OPEREXEC");
+		kvm->arch.user_operexec = 1;
+		icpt_operexc_on_all_vcpus(kvm);
+		r = 0;
+		break;
 	default:
 		r = -EINVAL;
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 52f6000ab020..8ab07396ce3b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -963,6 +963,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_RISCV_MP_STATE_RESET 242
 #define KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED 243
 #define KVM_CAP_GUEST_MEMFD_FLAGS 244
+#define KVM_CAP_S390_USER_OPEREXEC 245
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 148d427ff24b..87e429206bb8 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -194,6 +194,7 @@ TEST_GEN_PROGS_s390 += s390/debug_test
 TEST_GEN_PROGS_s390 += s390/cpumodel_subfuncs_test
 TEST_GEN_PROGS_s390 += s390/shared_zeropage_test
 TEST_GEN_PROGS_s390 += s390/ucontrol_test
+TEST_GEN_PROGS_s390 += s390/user_operexec
 TEST_GEN_PROGS_s390 += rseq_test
 
 TEST_GEN_PROGS_riscv = $(TEST_GEN_PROGS_COMMON)
diff --git a/tools/testing/selftests/kvm/s390/user_operexec.c b/tools/testing/selftests/kvm/s390/user_operexec.c
new file mode 100644
index 000000000000..714906c1d12a
--- /dev/null
+++ b/tools/testing/selftests/kvm/s390/user_operexec.c
@@ -0,0 +1,140 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Test operation exception forwarding.
+ *
+ * Copyright IBM Corp. 2025
+ *
+ * Authors:
+ *  Janosch Frank <frankja@linux.ibm.com>
+ */
+#include "kselftest.h"
+#include "kvm_util.h"
+#include "test_util.h"
+#include "sie.h"
+
+#include <linux/kvm.h>
+
+static void guest_code_instr0(void)
+{
+	asm(".word 0x0000");
+}
+
+static void test_user_instr0(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	int rc;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code_instr0);
+	rc = __vm_enable_cap(vm, KVM_CAP_S390_USER_INSTR0, 0);
+	TEST_ASSERT_EQ(0, rc);
+
+	vcpu_run(vcpu);
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_S390_SIEIC);
+	TEST_ASSERT_EQ(vcpu->run->s390_sieic.icptcode, ICPT_OPEREXC);
+	TEST_ASSERT_EQ(vcpu->run->s390_sieic.ipa, 0);
+
+	kvm_vm_free(vm);
+}
+
+static void guest_code_user_operexec(void)
+{
+	asm(".word 0x0807");
+}
+
+static void test_user_operexec(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	int rc;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code_user_operexec);
+	rc = __vm_enable_cap(vm, KVM_CAP_S390_USER_OPEREXEC, 0);
+	TEST_ASSERT_EQ(0, rc);
+
+	vcpu_run(vcpu);
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_S390_SIEIC);
+	TEST_ASSERT_EQ(vcpu->run->s390_sieic.icptcode, ICPT_OPEREXC);
+	TEST_ASSERT_EQ(vcpu->run->s390_sieic.ipa, 0x0807);
+
+	kvm_vm_free(vm);
+
+	/*
+	 * Since user_operexec is the superset it can be used for the
+	 * 0 instruction.
+	 */
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code_instr0);
+	rc = __vm_enable_cap(vm, KVM_CAP_S390_USER_OPEREXEC, 0);
+	TEST_ASSERT_EQ(0, rc);
+
+	vcpu_run(vcpu);
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_S390_SIEIC);
+	TEST_ASSERT_EQ(vcpu->run->s390_sieic.icptcode, ICPT_OPEREXC);
+	TEST_ASSERT_EQ(vcpu->run->s390_sieic.ipa, 0);
+
+	kvm_vm_free(vm);
+}
+
+/* combine user_instr0 and user_operexec */
+static void test_user_operexec_combined(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	int rc;
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code_user_operexec);
+	rc = __vm_enable_cap(vm, KVM_CAP_S390_USER_INSTR0, 0);
+	TEST_ASSERT_EQ(0, rc);
+	rc = __vm_enable_cap(vm, KVM_CAP_S390_USER_OPEREXEC, 0);
+	TEST_ASSERT_EQ(0, rc);
+
+	vcpu_run(vcpu);
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_S390_SIEIC);
+	TEST_ASSERT_EQ(vcpu->run->s390_sieic.icptcode, ICPT_OPEREXC);
+	TEST_ASSERT_EQ(vcpu->run->s390_sieic.ipa, 0x0807);
+
+	kvm_vm_free(vm);
+
+	/* Reverse enablement order */
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code_user_operexec);
+	rc = __vm_enable_cap(vm, KVM_CAP_S390_USER_OPEREXEC, 0);
+	TEST_ASSERT_EQ(0, rc);
+	rc = __vm_enable_cap(vm, KVM_CAP_S390_USER_INSTR0, 0);
+	TEST_ASSERT_EQ(0, rc);
+
+	vcpu_run(vcpu);
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_S390_SIEIC);
+	TEST_ASSERT_EQ(vcpu->run->s390_sieic.icptcode, ICPT_OPEREXC);
+	TEST_ASSERT_EQ(vcpu->run->s390_sieic.ipa, 0x0807);
+
+	kvm_vm_free(vm);
+}
+
+/*
+ * Run all tests above.
+ *
+ * Enablement after VCPU has been added is automatically tested since
+ * we enable the capability after VCPU creation.
+ */
+static struct testdef {
+	const char *name;
+	void (*test)(void);
+} testlist[] = {
+	{ "instr0", test_user_instr0 },
+	{ "operexec", test_user_operexec },
+	{ "operexec_combined", test_user_operexec_combined},
+};
+
+int main(int argc, char *argv[])
+{
+	int idx;
+
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_S390_USER_INSTR0));
+
+	ksft_print_header();
+	ksft_set_plan(ARRAY_SIZE(testlist));
+	for (idx = 0; idx < ARRAY_SIZE(testlist); idx++) {
+		testlist[idx].test();
+		ksft_test_result_pass("%s\n", testlist[idx].name);
+	}
+	ksft_finished();
+}
-- 
2.48.1


