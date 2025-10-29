Return-Path: <kvm+bounces-61391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C510C1AA8A
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 14:26:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9F1D561E28
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 13:12:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D91F2D8398;
	Wed, 29 Oct 2025 13:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jN4F5gdT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72B52D23BC;
	Wed, 29 Oct 2025 13:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761743315; cv=none; b=EBzy4fF7WBrxDxw/geAbkgsijm56ioPV3ld66JW+H3CLFX8L5ZTRK3eFoMlU6D7O6FlFy6UKcB+HacBwUkrbFruHeSN5s+tpwwNVXZXxMojaN3R41hQhyYxP4NtRcmitAKmLjiJEGSMtFm58FDzEwXwcuaTKgGF6uz1bxgpA1/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761743315; c=relaxed/simple;
	bh=tDMkOiHrA3eT74QLyYSrwUUima+EcBylwbkvubbTnd4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KhLUrpiIbqxNvdkXBM2la37+LW3YsirRMjZT4HGXeHhYr74p2JU42CX4q9d1tMMxObuo9ttKCEIW6Usxfi8GJmh+22We3uwu2EUHI5YWeFWOMkupOOXKrp/0jQd+SO+LtR3XjyvTcBkv1JzZ2uGec9323+aHrWNxMkI5fRAv4mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jN4F5gdT; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59TApkTp025816;
	Wed, 29 Oct 2025 13:08:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=yDOnppx9B6iPjPkweVjzeGhNFNR0KwdHKQ8WJGxje
	bI=; b=jN4F5gdTRi8qL103RM/LvaAHSk7Hzpv5OCJfU/stG/30yooFBFctenQG8
	KtY2iBExeHYcGaQd+8cd9lsEPzHtTenV+lFFdLiFhAmKEybtxM4SszilrMaHB8GQ
	U/tgWqIDswddR9fiujVAPRUtYRxvXMa+tn4HzvyAOf0lqIckHedO09vXiehkSbA+
	Z6Whl7HAmM3kf2D2krzuIddlZsGfeP4PWoSDLCaQUkjKY5UE5wsC/87U19inqWpm
	30p+4KIHpOmuNY4cLwckjHcmEQvFzkzURzK48uWBgpC579nSUS1LDuMkBYaBOZY0
	WcXcUQhUEhmnNxXvKaUjTnIT0tyjg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a34ackcaq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Oct 2025 13:08:31 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59T9r9ok027546;
	Wed, 29 Oct 2025 13:08:30 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4a33w2kcrm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Oct 2025 13:08:30 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59TD8RPv51118338
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Oct 2025 13:08:27 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 223D920043;
	Wed, 29 Oct 2025 13:08:27 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 00E8320040;
	Wed, 29 Oct 2025 13:08:27 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 29 Oct 2025 13:08:26 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        borntraeger@linux.ibm.com
Subject: [PATCH] KVM: s390: Add capability that forwards operation exceptions
Date: Wed, 29 Oct 2025 13:04:11 +0000
Message-ID: <20251029130744.6422-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=XbuEDY55 c=1 sm=1 tr=0 ts=690211cf cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=2J_RzahkHEl8vmpqG00A:9
X-Proofpoint-ORIG-GUID: 94MvI6_RQSdsbD-AUyT1iTYSfF6e8W64
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI4MDE2NiBTYWx0ZWRfXzmub4T8MWIEI
 jgXuHbz0R8wvFjf17j7UGDAqe27m5kPgsOlIArJYB77KV1jSKhwQVWmnAdvmJ+9RWydqKbN6kpB
 +Nx//Q2gAGHwklRi0G+f9XKU1Z3WRttN90DewFLbau6ONOw3pfwAlue9QyhTFgvZwhTFDwfPUUh
 MWUL2/x1IHT79VXJDcmr21FvoVKyiGEEbFieUCs3VGXWpceO8e7ix5KfOP3Wn7A8Qcg2n5HiBip
 I4zewVqZlo2Q1UUYhr7oI/5i6I4IYIN40x1KRDE7r1xxS3LHtALxm/hJD4oySEw0RsCWfVdl420
 s8x4k6OOwC8F5RlJkboPpXsAEyzPba/9+MKQnBLl8aio6NOQTIKBSv3+OB5KdrpB3Md/hdYC51N
 BWe+KKUAIP9qalan3ceYs9dA6WBINg==
X-Proofpoint-GUID: 94MvI6_RQSdsbD-AUyT1iTYSfF6e8W64
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-29_05,2025-10-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 suspectscore=0 bulkscore=0 spamscore=0
 impostorscore=0 phishscore=0 priorityscore=1501 clxscore=1015
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2510280166

Setting KVM_CAP_S390_USER_OPEREXEC will forward all operation
exceptions to user space. This also includes the 0x0000 instructions
managed by KVM_CAP_S390_USER_INSTR0. It's helpful if user space wants
to emulate instructions which do not (yet) have an opcode.

While we're at it refine the documentation for
KVM_CAP_S390_USER_INSTR0.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---

This is based on the api documentation ordering fix that's in our next
branch.

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
index 72b2fae99a83..67837207dc9b 100644
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
+helpful if user space wants to emulate instructions which do not (yet)
+have an opcode.
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


