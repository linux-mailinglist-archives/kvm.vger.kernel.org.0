Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C2F492333
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 10:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235764AbiARJw5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 04:52:57 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54510 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234398AbiARJwd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 04:52:33 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20I8SHvV019121;
        Tue, 18 Jan 2022 09:52:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ULLbwYkob+HZevHR5XDtUR5tIEtlKlrn79Si6zxTJuQ=;
 b=BS/3egoCSkgzARwkJhLa0k+u4W1H7+pO+nCtBj+JUh6++kpYPDjbQz4M79gN0FQjJIZb
 UQDdhOKLIL3ARctgs0E9xQSzpt62kPpqHR5OtxT4EUtRBgBEBC7iWOlGnQvublq0w6UE
 Y5gptHm8fONZyK0OQDbW+vV7hg1FTw69Zwr4jXDCBxrOvBB7XPb2mSVN7+PjwKyI1JI3
 FuKAH+kKR2hOOvB1NoIXlJLIX0cDXxDpjwflO1srJq+PdhYcsuV2hQgSnfxes44lPyfu
 gqghzTmJSqwBOIGXAutl1kmsOyKh3uFqdx/6bjAVoc2c2xblDUjeKRCKjKEG+A1OA6n7 XQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnt2f1gk5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:52:33 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20I9k9qk008926;
        Tue, 18 Jan 2022 09:52:32 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnt2f1gjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:52:32 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20I9lNrT027130;
        Tue, 18 Jan 2022 09:52:30 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3dknw99gjc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:52:29 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20I9qQCK45285688
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 09:52:26 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 777A7A4055;
        Tue, 18 Jan 2022 09:52:26 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32F8EA404D;
        Tue, 18 Jan 2022 09:52:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 09:52:26 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v1 08/10] KVM: s390: selftests: Test memops with storage keys
Date:   Tue, 18 Jan 2022 10:52:08 +0100
Message-Id: <20220118095210.1651483-9-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220118095210.1651483-1-scgl@linux.ibm.com>
References: <20220118095210.1651483-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GD3f1Yo84cKtx2zUcxULX_3u7M1pcTpD
X-Proofpoint-GUID: K6M_p8gUHtxQzpYAMCbsRjH16d5_gmJT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_02,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 malwarescore=0 bulkscore=0 mlxscore=0
 suspectscore=0 spamscore=0 impostorscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201180057
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test vm and vcpu memops with storage keys, both successful accesses
as well as various exception conditions.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
 tools/testing/selftests/kvm/s390x/memop.c | 548 +++++++++++++++++++---
 1 file changed, 485 insertions(+), 63 deletions(-)

diff --git a/tools/testing/selftests/kvm/s390x/memop.c b/tools/testing/selftests/kvm/s390x/memop.c
index 9f49ead380ab..774d5756f41d 100644
--- a/tools/testing/selftests/kvm/s390x/memop.c
+++ b/tools/testing/selftests/kvm/s390x/memop.c
@@ -13,28 +13,305 @@
 #include "test_util.h"
 #include "kvm_util.h"
 
+#define PAGE_SHIFT 12
+#define PAGE_SIZE (1 << PAGE_SHIFT)
+#define PAGE_MASK (~(PAGE_SIZE - 1))
+#define CR0_FETCH_PROTECTION_OVERRIDE	(1UL << (63 - 38))
+#define CR0_STORAGE_PROTECTION_OVERRIDE	(1UL << (63 - 39))
+
 #define VCPU_ID 1
 
+const uint64_t last_page_addr = UINT64_MAX - PAGE_SIZE + 1;
+const unsigned int key_shift = ffs(KVM_S390_MEMOP_F_SKEYS_ACC) - 1;
+
 static uint8_t mem1[65536];
 static uint8_t mem2[65536];
 
+static void set_storage_key_range(void *addr, size_t len, char key)
+{
+	uintptr_t _addr, abs, i;
+
+	_addr = (uintptr_t)addr;
+	for (i = _addr & PAGE_MASK; i < _addr + len; i += PAGE_SIZE) {
+		abs = i;
+		asm volatile (
+			       "lra	%[abs], 0(0,%[abs])\n"
+			"	sske	%[key], %[abs]\n"
+			: [abs] "+&a" (abs)
+			: [key] "r" (key)
+			: "cc"
+		);
+	}
+}
+
 static void guest_code(void)
+{
+	/* Set storage key */
+	set_storage_key_range(mem1, sizeof(mem1), 0x90);
+	set_storage_key_range(mem2, sizeof(mem2), 0x90);
+	GUEST_SYNC(0);
+
+	/* Write, read back, without keys */
+	memcpy(mem2, mem1, sizeof(mem2));
+	GUEST_SYNC(10);
+
+	/* Write, read back, key 0 */
+	memcpy(mem2, mem1, sizeof(mem2));
+	GUEST_SYNC(20);
+
+	/* Write, read back, matching key, 1 page */
+	memcpy(mem2, mem1, sizeof(mem2));
+	GUEST_SYNC(30);
+
+	/* Write, read back, matching key, all pages */
+	memcpy(mem2, mem1, sizeof(mem2));
+	GUEST_SYNC(40);
+
+	/* Set fetch protection */
+	set_storage_key_range(0, 1, 0x18);
+	GUEST_SYNC(50);
+
+	/* Enable fetch protection override */
+	GUEST_SYNC(60);
+
+	/* Enable storage protection override, set fetch protection*/
+	set_storage_key_range(mem1, sizeof(mem1), 0x98);
+	set_storage_key_range(mem2, sizeof(mem2), 0x98);
+	GUEST_SYNC(70);
+
+	/* Write, read back, mismatching key,
+	 * storage protection override, all pages
+	 */
+	memcpy(mem2, mem1, sizeof(mem2));
+	GUEST_SYNC(80);
+
+	/* VM memop, write, read back, matching key */
+	memcpy(mem2, mem1, sizeof(mem2));
+	GUEST_SYNC(90);
+
+	/* VM memop, write, read back, key 0 */
+	memcpy(mem2, mem1, sizeof(mem2));
+	/* VM memop, fail to read from 0 absolute/virtual, mismatching key,
+	 * fetch protection override does not apply to VM memops
+	 */
+	asm volatile ("sske %1,%0\n"
+		: : "r"(0), "r"(0x18) : "cc"
+	);
+	GUEST_SYNC(100);
+
+	/* Enable AR mode */
+	GUEST_SYNC(110);
+
+	/* Disable AR mode */
+	GUEST_SYNC(120);
+}
+
+static void reroll_mem1(void)
 {
 	int i;
 
-	for (;;) {
-		for (i = 0; i < sizeof(mem2); i++)
-			mem2[i] = mem1[i];
-		GUEST_SYNC(0);
-	}
+	for (i = 0; i < sizeof(mem1); i++)
+		mem1[i] = rand();
+}
+
+static int _vcpu_read_guest(struct kvm_vm *vm, void *host_addr,
+			    uintptr_t guest_addr, size_t len)
+{
+	struct kvm_s390_mem_op ksmo = {
+		.gaddr = guest_addr,
+		.flags = 0,
+		.size = len,
+		.op = KVM_S390_MEMOP_LOGICAL_READ,
+		.buf = (uintptr_t)host_addr,
+		.ar = 0,
+	};
+
+	return _vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+}
+
+static void vcpu_read_guest(struct kvm_vm *vm, void *host_addr,
+			    uintptr_t guest_addr, size_t len)
+{
+	int rv;
+
+	rv = _vcpu_read_guest(vm, host_addr, guest_addr, len);
+	TEST_ASSERT(rv == 0, "vcpu memop read failed: reason = %d\n", rv);
+}
+
+static int _vcpu_read_guest_key(struct kvm_vm *vm, void *host_addr,
+				uintptr_t guest_addr, size_t len, char key)
+{
+	struct kvm_s390_mem_op ksmo = {
+		.gaddr = guest_addr,
+		.flags = key << key_shift,
+		.size = len,
+		.op = KVM_S390_MEMOP_LOGICAL_READ,
+		.buf = (uintptr_t)host_addr,
+		.ar = 0,
+	};
+
+	return _vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+}
+
+static void vcpu_read_guest_key(struct kvm_vm *vm, void *host_addr,
+				uintptr_t guest_addr, size_t len, char key)
+{
+	int rv;
+
+	rv = _vcpu_read_guest_key(vm, host_addr, guest_addr, len, key);
+	TEST_ASSERT(rv == 0, "vcpu memop read failed: reason = %d\n", rv);
+}
+
+static int _vcpu_write_guest(struct kvm_vm *vm, uintptr_t guest_addr,
+			     void *host_addr, size_t len)
+{
+	struct kvm_s390_mem_op ksmo = {
+		.gaddr = guest_addr,
+		.flags = 0,
+		.size = len,
+		.op = KVM_S390_MEMOP_LOGICAL_WRITE,
+		.buf = (uintptr_t)host_addr,
+		.ar = 0,
+	};
+	return _vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+}
+
+static void vcpu_write_guest(struct kvm_vm *vm, uintptr_t guest_addr,
+			     void *host_addr, size_t len)
+{
+	int rv;
+
+	rv = _vcpu_write_guest(vm, guest_addr, host_addr, len);
+	TEST_ASSERT(rv == 0, "vcpu memop write failed: reason = %d\n", rv);
+}
+
+static int _vcpu_write_guest_key(struct kvm_vm *vm, uintptr_t guest_addr,
+				 void *host_addr, size_t len, char key)
+{
+	struct kvm_s390_mem_op ksmo = {
+		.gaddr = guest_addr,
+		.flags = key << key_shift,
+		.size = len,
+		.op = KVM_S390_MEMOP_LOGICAL_WRITE,
+		.buf = (uintptr_t)host_addr,
+		.ar = 0,
+	};
+
+	return _vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+}
+
+static void vcpu_write_guest_key(struct kvm_vm *vm, uintptr_t guest_addr,
+				 void *host_addr, size_t len, char key)
+{
+	int rv;
+
+	rv = _vcpu_write_guest_key(vm, guest_addr, host_addr, len, key);
+	TEST_ASSERT(rv == 0, "vcpu memop write failed: reason = %d\n", rv);
+}
+
+static int _vm_read_guest_key(struct kvm_vm *vm, void *host_addr,
+			      uintptr_t guest_addr, size_t len, char key)
+{
+	struct kvm_s390_mem_op ksmo = {
+		.gaddr = guest_addr,
+		.flags = key << key_shift,
+		.size = len,
+		.op = KVM_S390_MEMOP_ABSOLUTE_READ,
+		.buf = (uintptr_t)host_addr,
+		.reserved = {0},
+	};
+
+	return _vm_ioctl(vm, KVM_S390_MEM_OP, &ksmo);
+}
+
+static void vm_read_guest_key(struct kvm_vm *vm, void *host_addr,
+			      uintptr_t guest_addr, size_t len, char key)
+{
+	int rv;
+
+	rv = _vm_read_guest_key(vm, host_addr, guest_addr, len, key);
+	TEST_ASSERT(rv == 0, "vm memop read failed: reason = %d\n", rv);
+}
+
+static int _vm_write_guest_key(struct kvm_vm *vm, uintptr_t guest_addr,
+			       void *host_addr, size_t len, char key)
+{
+	struct kvm_s390_mem_op ksmo = {
+		.gaddr = guest_addr,
+		.flags = key << key_shift,
+		.size = len,
+		.op = KVM_S390_MEMOP_ABSOLUTE_WRITE,
+		.buf = (uintptr_t)host_addr,
+		.reserved = {0},
+	};
+
+	return _vm_ioctl(vm, KVM_S390_MEM_OP, &ksmo);
+}
+
+static void vm_write_guest_key(struct kvm_vm *vm, uintptr_t guest_addr,
+			       void *host_addr, size_t len, char key)
+{
+	int rv;
+
+	rv = _vm_write_guest_key(vm, guest_addr, host_addr, len, key);
+	TEST_ASSERT(rv == 0, "vm memop write failed: reason = %d\n", rv);
+}
+
+enum access_mode {
+	ACCESS_READ,
+	ACCESS_WRITE
+};
+
+static int _vm_check_guest_key(struct kvm_vm *vm, enum access_mode mode,
+			       uintptr_t guest_addr, size_t len, char key)
+{
+	int op;
+
+	if (mode == ACCESS_READ)
+		op = KVM_S390_MEMOP_ABSOLUTE_READ;
+	else
+		op = KVM_S390_MEMOP_ABSOLUTE_WRITE;
+	struct kvm_s390_mem_op ksmo = {
+		.gaddr = guest_addr,
+		.flags = key << key_shift | KVM_S390_MEMOP_F_CHECK_ONLY,
+		.size = len,
+		.op = op,
+		.reserved = {0},
+	};
+
+	return _vm_ioctl(vm, KVM_S390_MEM_OP, &ksmo);
 }
 
+static void vm_check_guest_key(struct kvm_vm *vm, enum access_mode mode,
+			       uintptr_t guest_addr, size_t len, char key)
+{
+	int rv;
+
+	rv = _vm_check_guest_key(vm, mode, guest_addr, len, key);
+	TEST_ASSERT(rv == 0, "vm memop write failed: reason = %d\n", rv);
+}
+
+#define HOST_SYNC(vmp, stage)						\
+({									\
+	struct kvm_vm *__vm = (vmp);					\
+	struct ucall uc;						\
+	int __stage = (stage);						\
+									\
+	vcpu_run(__vm, VCPU_ID);					\
+	get_ucall(__vm, VCPU_ID, &uc);					\
+	ASSERT_EQ(uc.cmd, UCALL_SYNC);					\
+	ASSERT_EQ(uc.args[1], __stage);					\
+})									\
+
 int main(int argc, char *argv[])
 {
 	struct kvm_vm *vm;
 	struct kvm_run *run;
 	struct kvm_s390_mem_op ksmo;
-	int rv, i, maxsize;
+	vm_vaddr_t guest_mem1;
+	vm_vaddr_t guest_mem2;
+	vm_paddr_t guest_mem1_abs;
+	int rv, maxsize;
 
 	setbuf(stdout, NULL);	/* Tell stdout not to buffer its content */
 
@@ -49,63 +326,210 @@ int main(int argc, char *argv[])
 	/* Create VM */
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
 	run = vcpu_state(vm, VCPU_ID);
+	guest_mem1 = (uintptr_t)mem1;
+	guest_mem2 = (uintptr_t)mem2;
+	guest_mem1_abs = addr_gva2gpa(vm, guest_mem1);
 
-	for (i = 0; i < sizeof(mem1); i++)
-		mem1[i] = i * i + i;
+	/* Set storage key */
+	HOST_SYNC(vm, 0);
 
-	/* Set the first array */
-	ksmo.gaddr = addr_gva2gpa(vm, (uintptr_t)mem1);
-	ksmo.flags = 0;
-	ksmo.size = maxsize;
-	ksmo.op = KVM_S390_MEMOP_LOGICAL_WRITE;
-	ksmo.buf = (uintptr_t)mem1;
-	ksmo.ar = 0;
-	vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+	/* Write, read back, without keys */
+	reroll_mem1();
+	vcpu_write_guest(vm, guest_mem1, mem1, maxsize);
+	HOST_SYNC(vm, 10); // Copy in vm
+	memset(mem2, 0xaa, sizeof(mem2));
+	vcpu_read_guest(vm, mem2, guest_mem2, maxsize);
+	TEST_ASSERT(!memcmp(mem1, mem2, maxsize),
+		    "Memory contents do not match!");
 
-	/* Let the guest code copy the first array to the second */
-	vcpu_run(vm, VCPU_ID);
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_S390_SIEIC,
-		    "Unexpected exit reason: %u (%s)\n",
-		    run->exit_reason,
-		    exit_reason_str(run->exit_reason));
+	{
+		vm_vaddr_t guest_0_page = vm_vaddr_alloc(vm, PAGE_SIZE, 0);
+		vm_vaddr_t guest_last_page = vm_vaddr_alloc(vm, PAGE_SIZE, last_page_addr);
+		vm_paddr_t guest_mem2_abs = addr_gva2gpa(vm, guest_mem2);
 
-	memset(mem2, 0xaa, sizeof(mem2));
+		/* Write, read back, key 0 */
+		reroll_mem1();
+		vcpu_write_guest_key(vm, guest_mem1, mem1, maxsize, 0);
+		HOST_SYNC(vm, 20); // Copy in vm
+		memset(mem2, 0xaa, sizeof(mem2));
+		vcpu_read_guest_key(vm, mem2, guest_mem2, maxsize, 0);
+		TEST_ASSERT(!memcmp(mem1, mem2, maxsize),
+			    "Memory contents do not match!");
 
-	/* Get the second array */
-	ksmo.gaddr = (uintptr_t)mem2;
-	ksmo.flags = 0;
-	ksmo.size = maxsize;
-	ksmo.op = KVM_S390_MEMOP_LOGICAL_READ;
-	ksmo.buf = (uintptr_t)mem2;
-	ksmo.ar = 0;
-	vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+		/* Write, read back, matching key, 1 page */
+		reroll_mem1();
+		vcpu_write_guest_key(vm, guest_mem1, mem1, PAGE_SIZE, 9);
+		HOST_SYNC(vm, 30); // Copy in vm
+		memset(mem2, 0xaa, sizeof(mem2));
+		vcpu_read_guest_key(vm, mem2, guest_mem2, PAGE_SIZE, 9);
+		TEST_ASSERT(!memcmp(mem1, mem2, PAGE_SIZE),
+			    "Memory contents do not match!");
 
-	TEST_ASSERT(!memcmp(mem1, mem2, maxsize),
-		    "Memory contents do not match!");
+		/* Write, read back, matching key, all pages */
+		reroll_mem1();
+		vcpu_write_guest_key(vm, guest_mem1, mem1, maxsize, 9);
+		HOST_SYNC(vm, 40); // Copy in vm
+		memset(mem2, 0xaa, sizeof(mem2));
+		vcpu_read_guest_key(vm, mem2, guest_mem2, maxsize, 9);
+		TEST_ASSERT(!memcmp(mem1, mem2, maxsize),
+			    "Memory contents do not match!");
 
-	/* Check error conditions - first bad size: */
-	ksmo.gaddr = (uintptr_t)mem1;
-	ksmo.flags = 0;
-	ksmo.size = -1;
-	ksmo.op = KVM_S390_MEMOP_LOGICAL_WRITE;
-	ksmo.buf = (uintptr_t)mem1;
-	ksmo.ar = 0;
-	rv = _vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+		/* Fail to write, read back old value, mismatching key */
+		rv = _vcpu_write_guest_key(vm, guest_mem1, mem1, maxsize, 2);
+		TEST_ASSERT(rv == 4, "Store should result in protection exception");
+		memset(mem2, 0xaa, sizeof(mem2));
+		vcpu_read_guest_key(vm, mem2, guest_mem2, maxsize, 2);
+		TEST_ASSERT(!memcmp(mem1, mem2, maxsize),
+			    "Memory contents do not match!");
+
+		/* Set fetch protection */
+		HOST_SYNC(vm, 50);
+
+		/* Write without key, read back, machting key, fetch protection */
+		reroll_mem1();
+		vcpu_write_guest(vm, guest_0_page, mem1, PAGE_SIZE);
+		memset(mem2, 0xaa, sizeof(mem2));
+		/* Lets not copy in the guest, in case guest_0_page != 0 */
+		vcpu_read_guest_key(vm, mem2, guest_0_page, PAGE_SIZE, 1);
+		TEST_ASSERT(!memcmp(mem1, mem2, PAGE_SIZE),
+			    "Memory contents do not match!");
+
+		/* Fail to read,  mismatching key, fetch protection */
+		rv = _vcpu_read_guest_key(vm, mem2, guest_0_page, PAGE_SIZE, 2);
+		TEST_ASSERT(rv == 4, "Fetch should result in protection exception");
+
+		/* Enable fetch protection override */
+		run->s.regs.crs[0] |= CR0_FETCH_PROTECTION_OVERRIDE;
+		run->kvm_dirty_regs = KVM_SYNC_CRS;
+		HOST_SYNC(vm, 60);
+
+		if (guest_0_page != 0)
+			print_skip("Did not allocate page at 0 for fetch protection override test");
+
+		/* Write without key, read back, mismachting key,
+		 * fetch protection override, 1 page
+		 */
+		if (guest_0_page == 0) {
+			reroll_mem1();
+			vcpu_write_guest(vm, guest_0_page, mem1, PAGE_SIZE);
+			memset(mem2, 0xaa, sizeof(mem2));
+			/* Lets not copy in the guest, in case guest_0_page != 0 */
+			vcpu_read_guest_key(vm, mem2, guest_0_page, 2048, 2);
+			TEST_ASSERT(!memcmp(mem1, mem2, 2048),
+				    "Memory contents do not match!");
+		}
+
+		/* Fail to read, mismatching key,
+		 * fetch protection override address exceeded, 1 page
+		 */
+		if (guest_0_page == 0) {
+			rv = _vcpu_read_guest_key(vm, mem2, 0, 2048 + 1, 2);
+			TEST_ASSERT(rv == 4,
+				    "Fetch should result in protection exception");
+		}
+
+		if (guest_last_page != last_page_addr)
+			print_skip("Did not allocate last page for fetch protection override test");
+
+		/* Write without key, read back, mismachting key,
+		 * fetch protection override, 2 pages, last page not fetch protected
+		 */
+		reroll_mem1();
+		vcpu_write_guest(vm, guest_last_page, mem1, PAGE_SIZE);
+		vcpu_write_guest(vm, guest_0_page, mem1 + PAGE_SIZE, PAGE_SIZE);
+		if (guest_0_page == 0 && guest_last_page == last_page_addr) {
+			memset(mem2, 0xaa, sizeof(mem2));
+			/* Lets not copy in the guest, in case guest_0_page != 0 */
+			vcpu_read_guest_key(vm, mem2, last_page_addr,
+					    PAGE_SIZE + 2048, 2);
+			TEST_ASSERT(!memcmp(mem1, mem2, PAGE_SIZE + 2048),
+				    "Memory contents do not match!");
+		}
+
+		/* Fail to read, mismatching key, fetch protection override address
+		 * exceeded, 2 pages, last page not fetch protected
+		 */
+		if (guest_0_page == 0 && guest_last_page == last_page_addr) {
+			rv = _vcpu_read_guest_key(vm, mem2, last_page_addr,
+						  PAGE_SIZE + 2048 + 1, 2);
+			TEST_ASSERT(rv == 4,
+				    "Fetch should result in protection exception");
+		}
+
+		/* Enable storage protection override, set fetch protection*/
+		run->s.regs.crs[0] |= CR0_STORAGE_PROTECTION_OVERRIDE;
+		run->kvm_dirty_regs = KVM_SYNC_CRS;
+		HOST_SYNC(vm, 70);
+
+		/* Write, read back, mismatching key,
+		 * storage protection override, all pages
+		 */
+		reroll_mem1();
+		vcpu_write_guest_key(vm, guest_mem1, mem1, maxsize, 2);
+		HOST_SYNC(vm, 80); // Copy in vm
+		memset(mem2, 0xaa, sizeof(mem2));
+		vcpu_read_guest_key(vm, mem2, guest_mem2, maxsize, 2);
+		TEST_ASSERT(!memcmp(mem1, mem2, maxsize),
+			    "Memory contents do not match!");
+
+		/* VM memop, write, read back, matching key */
+		reroll_mem1();
+		vm_write_guest_key(vm, guest_mem1_abs, mem1, maxsize, 9);
+		HOST_SYNC(vm, 90); // Copy in vm
+		memset(mem2, 0xaa, sizeof(mem2));
+		vm_read_guest_key(vm, mem2, guest_mem2_abs, maxsize, 9);
+		TEST_ASSERT(!memcmp(mem1, mem2, maxsize),
+			    "Memory contents do not match!");
+		vm_check_guest_key(vm, ACCESS_WRITE, guest_mem1_abs, maxsize, 9);
+		vm_check_guest_key(vm, ACCESS_READ, guest_mem2_abs, maxsize, 9);
+
+		/* VM memop, write, read back, key 0 */
+		reroll_mem1();
+		vm_write_guest_key(vm, guest_mem1_abs, mem1, maxsize, 0);
+		HOST_SYNC(vm, 100); // Copy in vm
+		memset(mem2, 0xaa, sizeof(mem2));
+		vm_read_guest_key(vm, mem2, guest_mem2_abs, maxsize, 0);
+		TEST_ASSERT(!memcmp(mem1, mem2, maxsize),
+			    "Memory contents do not match!");
+		rv = _vm_check_guest_key(vm, ACCESS_READ, guest_mem1_abs, maxsize, 9);
+		TEST_ASSERT(rv == 0, "Check should succeed");
+		vm_check_guest_key(vm, ACCESS_WRITE, guest_mem1_abs, maxsize, 0);
+		vm_check_guest_key(vm, ACCESS_READ, guest_mem2_abs, maxsize, 0);
+
+		/* VM memop, fail to write, fail to read, mismatching key,
+		 * storage protection override does not apply to VM memops
+		 */
+		rv = _vm_write_guest_key(vm, guest_mem1_abs, mem1, maxsize, 2);
+		TEST_ASSERT(rv == 4, "Store should result in protection exception");
+		rv = _vm_read_guest_key(vm, mem2, guest_mem2_abs, maxsize, 2);
+		TEST_ASSERT(rv == 4, "Fetch should result in protection exception");
+		rv = _vm_check_guest_key(vm, ACCESS_WRITE, guest_mem1_abs, maxsize, 2);
+		TEST_ASSERT(rv == 4, "Check should indicate protection exception");
+		rv = _vm_check_guest_key(vm, ACCESS_READ, guest_mem2_abs, maxsize, 2);
+		TEST_ASSERT(rv == 4, "Check should indicate protection exception");
+
+		/* VM memop, fail to read from 0 absolute/virtual, mismatching key,
+		 * fetch protection override does not apply to VM memops
+		 */
+		rv = _vm_read_guest_key(vm, mem2, 0, 2048, 2);
+		TEST_ASSERT(rv != 0, "Fetch should result in exception");
+		rv = _vm_read_guest_key(vm, mem2, addr_gva2gpa(vm, 0), 2048, 2);
+		TEST_ASSERT(rv == 4, "Fetch should result in protection exception");
+	}
+
+	/* Check error conditions */
+
+	/* Bad size: */
+	rv = _vcpu_write_guest(vm, (uintptr_t)mem1, mem1, -1);
 	TEST_ASSERT(rv == -1 && errno == E2BIG, "ioctl allows insane sizes");
 
 	/* Zero size: */
-	ksmo.gaddr = (uintptr_t)mem1;
-	ksmo.flags = 0;
-	ksmo.size = 0;
-	ksmo.op = KVM_S390_MEMOP_LOGICAL_WRITE;
-	ksmo.buf = (uintptr_t)mem1;
-	ksmo.ar = 0;
-	rv = _vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+	rv = _vcpu_write_guest(vm, (uintptr_t)mem1, mem1, 0);
 	TEST_ASSERT(rv == -1 && (errno == EINVAL || errno == ENOMEM),
 		    "ioctl allows 0 as size");
 
 	/* Bad flags: */
-	ksmo.gaddr = (uintptr_t)mem1;
+	ksmo.gaddr = guest_mem1;
 	ksmo.flags = -1;
 	ksmo.size = maxsize;
 	ksmo.op = KVM_S390_MEMOP_LOGICAL_WRITE;
@@ -115,7 +539,7 @@ int main(int argc, char *argv[])
 	TEST_ASSERT(rv == -1 && errno == EINVAL, "ioctl allows all flags");
 
 	/* Bad operation: */
-	ksmo.gaddr = (uintptr_t)mem1;
+	ksmo.gaddr = guest_mem1;
 	ksmo.flags = 0;
 	ksmo.size = maxsize;
 	ksmo.op = -1;
@@ -135,21 +559,17 @@ int main(int argc, char *argv[])
 	TEST_ASSERT(rv > 0, "ioctl does not report bad guest memory access");
 
 	/* Bad host address: */
-	ksmo.gaddr = (uintptr_t)mem1;
-	ksmo.flags = 0;
-	ksmo.size = maxsize;
-	ksmo.op = KVM_S390_MEMOP_LOGICAL_WRITE;
-	ksmo.buf = 0;
-	ksmo.ar = 0;
-	rv = _vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
+	rv = _vcpu_write_guest(vm, guest_mem1, 0, maxsize);
 	TEST_ASSERT(rv == -1 && errno == EFAULT,
 		    "ioctl does not report bad host memory address");
 
-	/* Bad access register: */
+	/* Enable AR mode */
 	run->psw_mask &= ~(3UL << (63 - 17));
-	run->psw_mask |= 1UL << (63 - 17);  /* Enable AR mode */
-	vcpu_run(vm, VCPU_ID);              /* To sync new state to SIE block */
-	ksmo.gaddr = (uintptr_t)mem1;
+	run->psw_mask |= 1UL << (63 - 17);
+	HOST_SYNC(vm, 110);
+
+	/* Bad access register: */
+	ksmo.gaddr = guest_mem1;
 	ksmo.flags = 0;
 	ksmo.size = maxsize;
 	ksmo.op = KVM_S390_MEMOP_LOGICAL_WRITE;
@@ -157,8 +577,10 @@ int main(int argc, char *argv[])
 	ksmo.ar = 17;
 	rv = _vcpu_ioctl(vm, VCPU_ID, KVM_S390_MEM_OP, &ksmo);
 	TEST_ASSERT(rv == -1 && errno == EINVAL, "ioctl allows ARs > 15");
-	run->psw_mask &= ~(3UL << (63 - 17));   /* Disable AR mode */
-	vcpu_run(vm, VCPU_ID);                  /* Run to sync new state */
+
+	/* Disable AR mode */
+	run->psw_mask &= ~(3UL << (63 - 17));
+	HOST_SYNC(vm, 120);
 
 	kvm_vm_free(vm);
 
-- 
2.32.0

