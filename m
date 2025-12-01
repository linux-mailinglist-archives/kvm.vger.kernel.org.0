Return-Path: <kvm+bounces-64998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BBF7C9766B
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 13:54:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AEFD63A7EAA
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 12:49:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 784CB313E02;
	Mon,  1 Dec 2025 12:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YsFKdi6Y"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D51313273;
	Mon,  1 Dec 2025 12:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764593121; cv=none; b=aa3bXkRF9Llh2PJJd5qY4/LJLPUSnKdW0bu/IAtrhVJw66f5qQbYmK4gys6kqmKJ3+FmUuGPzA5tjlUiYMCF7QK9bkOalyJsKT3jDyYC/jAcOJByEiN9Au0H2AkGnhqVgh1kQcJDjV4FZQ5FHsNVd+GSdnyigM6IUhB8XQcaf+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764593121; c=relaxed/simple;
	bh=Raar1vijsQHVWdyL/+dZ8DPhACFuMm37TTn8+hpW0Wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kL34tcaSO2lFEjySKsotCLBEliG6mjCGPjg98gspBRjOaepf5h4pFJIxm3UfI/pXh68dtPo10aRbnzCgi+NPYwDMaumQW/bGsmsO+aem7nlwu/XxL+r7YaxWrT1WlihX8om6EvCsuzP+tyybVoUNlfl8a0RqftnIR4t6IxkUWo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YsFKdi6Y; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5B1CRujb017501;
	Mon, 1 Dec 2025 12:45:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=UAdLRzHLc0sLLFWLQ
	MMTfLtsqJckIXoShnONpfuWETM=; b=YsFKdi6Yc/dtwmj0Ysg266pMzG6oZkUW2
	qBcw1yAIDluyshPJbl4lTRwk5jloGgwDYbf47mRPYBuoLKLz8BL+IPYj1HuzwTbh
	+4AMhRzit4eBnsomPjjtrcnV5P+0v0XzjGYzGOwRRSo0z624hZ5Xo3KXa7j2d08V
	WX4K8mnWnn+oEMxiGzBc2BkaVycTCvq6T6EEJ8etBphGnTsqLtqALnHYR0W8axWf
	Ir8BJxKYaZ1+D2dz1SEZ4bQ1SwEYpCZZj3PVUPjpFhmlYfjr1WRBge4z3swjxRd3
	4/bAKpfacm+NVStXooIpt5XRMLUtYzUIuWFwe5q7FPZMIwnjKUvJg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aqrj9f3sw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 12:45:16 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5B1ASVxe029392;
	Mon, 1 Dec 2025 12:45:15 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ardv164c4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 12:45:15 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5B1CjCxc30015746
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 1 Dec 2025 12:45:12 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E6CBA20040;
	Mon,  1 Dec 2025 12:45:11 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8111A20043;
	Mon,  1 Dec 2025 12:45:11 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.111.74.48])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  1 Dec 2025 12:45:11 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, hca@linux.ibm.com
Subject: [GIT PULL 06/10] KVM: s390: Add capability that forwards operation exceptions
Date: Mon,  1 Dec 2025 13:33:48 +0100
Message-ID: <20251201124334.110483-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201124334.110483-1-frankja@linux.ibm.com>
References: <20251201124334.110483-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Yb-CyeE2sV3kzHP2iWdtrmA91mLWDjvh
X-Proofpoint-ORIG-GUID: Yb-CyeE2sV3kzHP2iWdtrmA91mLWDjvh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI5MDAyMCBTYWx0ZWRfXyLm+uEdQNEUf
 E9eCv2V38bY83WVULB5qhJkAR7+RFJBOjTFkcjtBbgI6SrI8OLttTjcSyHUYZsWYGd5vSZ0yjKA
 JzbP0TMIRljmkmgiqfXcq/cSUYRnuUAh74EOb0fiXH9dw1O5vs+jiki7m8K8tDetOiEZg2qSEqV
 LQhXHO/aQ2XOFhnYIyF8R+gkKVMUU8mkQVc1s0PP8Ai0QYzrQRBPvEzTE91HX6YLc0Dc+1Wz0ti
 S31byEVsuIhRva2maJ9ToX2kqE72mbnwZG3HmCO5WiUGmxZXezL0JTXIl5ASAo1nxUi30VgosDj
 3BOiiEZUDZ5vrdNqTz/g2+6bk7ZMLNCD2lOo/FzGW7Yb03OQU/ntW9eeVTKfQGcAZDwy2Hl36c/
 jsvX0h1qWSnU80ZO9X+vurqNB59w9Q==
X-Authority-Analysis: v=2.4 cv=dYGNHHXe c=1 sm=1 tr=0 ts=692d8ddc cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=2J_RzahkHEl8vmpqG00A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 suspectscore=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511290020

Setting KVM_CAP_S390_USER_OPEREXEC will forward all operation
exceptions to user space. This also includes the 0x0000 instructions
managed by KVM_CAP_S390_USER_INSTR0. It's helpful if user space wants
to emulate instructions which do not (yet) have an opcode.

While we're at it refine the documentation for
KVM_CAP_S390_USER_INSTR0.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
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
index 72b2fae99a83..1bc2a84c59ee 100644
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
+-------------------------------
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
2.52.0


