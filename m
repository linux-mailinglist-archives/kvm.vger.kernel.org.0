Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67AF749232B
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 10:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234838AbiARJwt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 04:52:49 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42406 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234353AbiARJwb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jan 2022 04:52:31 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20I6veaV031253;
        Tue, 18 Jan 2022 09:52:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=CWphYnoAn4X3KFvzgjnix9eYbpjkMml042BBcdSCMlg=;
 b=a7f1gIeZWW8UNOcZcgtFCbZ+qoE8Gg1GUDNMxzUAcfLvtAqX/6ghoByiO3djbd220B+u
 J3CqLf+7Aom1nTF3DKKU/aQTW/rstqOitIYVSIav37oI9LogirZ18Rbci0ho5iYwMJnF
 qsdxnezfSHQqaaSkfT2T5TNU+DD9u7LO72shcPNOYD7uUk3bQh04SQD6+On1hSAotwzR
 Y8HiAw5KY78w9ZLlgsq1Az/4OeueixdSSAlNya487e6ltJB0BtvfKteyDkVFS1HAPmKy
 FpB300Jn96POh98+CiJmaTDxC8o7iCCkc6w1rGJDgLsxWBYdL26bWK3OECB5QrE9Fo4r 3Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnrr6bjm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:52:31 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20I9i0SQ012118;
        Tue, 18 Jan 2022 09:52:30 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dnrr6bjk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:52:30 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20I9kw1f013287;
        Tue, 18 Jan 2022 09:52:28 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3dknwa9hf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 09:52:28 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20I9h6tu49676568
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jan 2022 09:43:06 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 217A2A404D;
        Tue, 18 Jan 2022 09:52:23 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CEA0EA4040;
        Tue, 18 Jan 2022 09:52:22 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 18 Jan 2022 09:52:22 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [RFC PATCH v1 04/10] KVM: s390: selftests: Test TEST PROTECTION emulation
Date:   Tue, 18 Jan 2022 10:52:04 +0100
Message-Id: <20220118095210.1651483-5-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220118095210.1651483-1-scgl@linux.ibm.com>
References: <20220118095210.1651483-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rDdCwB2FoauxiYbQ3zYelp8eQNt-M03I
X-Proofpoint-ORIG-GUID: o6p6IA0XRfAFH81qMdcLlS1xbqON-4rx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_02,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=999 adultscore=0 spamscore=0 phishscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180057
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test the emulation of TEST PROTECTION in the presence of storage keys.
Emulation only occurs under certain conditions, one of which is the host
page being protected.
Trigger this by protecting the test pages via mprotect.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
---
 tools/testing/selftests/kvm/.gitignore    |   1 +
 tools/testing/selftests/kvm/Makefile      |   1 +
 tools/testing/selftests/kvm/s390x/tprot.c | 184 ++++++++++++++++++++++
 3 files changed, 186 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/s390x/tprot.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 3763105029fb..82c0470b6849 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -7,6 +7,7 @@
 /s390x/memop
 /s390x/resets
 /s390x/sync_regs_test
+/s390x/tprot
 /x86_64/cr4_cpuid_sync_test
 /x86_64/debug_regs
 /x86_64/evmcs_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index c4e34717826a..df6de8d155e8 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -109,6 +109,7 @@ TEST_GEN_PROGS_aarch64 += kvm_binary_stats_test
 TEST_GEN_PROGS_s390x = s390x/memop
 TEST_GEN_PROGS_s390x += s390x/resets
 TEST_GEN_PROGS_s390x += s390x/sync_regs_test
+TEST_GEN_PROGS_s390x += s390x/tprot
 TEST_GEN_PROGS_s390x += demand_paging_test
 TEST_GEN_PROGS_s390x += dirty_log_test
 TEST_GEN_PROGS_s390x += kvm_create_max_vcpus
diff --git a/tools/testing/selftests/kvm/s390x/tprot.c b/tools/testing/selftests/kvm/s390x/tprot.c
new file mode 100644
index 000000000000..8b52675307f6
--- /dev/null
+++ b/tools/testing/selftests/kvm/s390x/tprot.c
@@ -0,0 +1,184 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Test TEST PROTECTION emulation.
+ * In order for emulation occur the target page has to be DAT protected in the
+ * host mappings. Since the page tables are shared, we can use mprotect
+ * to achieve this.
+ *
+ * Copyright IBM Corp. 2021
+ */
+
+#include <sys/mman.h>
+#include "test_util.h"
+#include "kvm_util.h"
+
+#define PAGE_SHIFT 12
+#define PAGE_SIZE (1 << PAGE_SHIFT)
+#define CR0_FETCH_PROTECTION_OVERRIDE	(1UL << (63 - 38))
+#define CR0_STORAGE_PROTECTION_OVERRIDE	(1UL << (63 - 39))
+
+#define VCPU_ID 1
+
+static __aligned(PAGE_SIZE) uint8_t pages[2][PAGE_SIZE];
+static uint8_t *const page_store_prot = pages[0];
+static uint8_t *const page_fetch_prot = pages[1];
+
+static int set_storage_key(void *addr, uint8_t key)
+{
+	int not_mapped = 0;
+
+	asm volatile (
+		       "lra	%[addr], 0(0,%[addr])\n"
+		"	jz	0f\n"
+		"	llill	%[not_mapped],1\n"
+		"	j	1f\n"
+		"0:	sske	%[key], %[addr]\n"
+		"1:"
+		: [addr] "+&a" (addr), [not_mapped] "+r" (not_mapped)
+		: [key] "r" (key)
+		: "cc"
+	);
+	return -not_mapped;
+}
+
+enum permission {
+	READ_WRITE = 0,
+	READ = 1,
+	NONE = 2,
+	UNAVAILABLE = 3,
+};
+
+static enum permission test_protection(void *addr, uint8_t key)
+{
+	uint64_t mask;
+
+	asm volatile (
+		       "tprot	%[addr], 0(%[key])\n"
+		"	ipm	%[mask]\n"
+		: [mask] "=r" (mask)
+		: [addr] "Q" (*(char *)addr),
+		  [key] "a" (key)
+		: "cc"
+	);
+
+	return (enum permission)mask >> 28;
+}
+
+enum stage {
+	STAGE_END,
+	STAGE_INIT_SIMPLE,
+	TEST_SIMPLE,
+	STAGE_INIT_FETCH_PROT_OVERRIDE,
+	TEST_FETCH_PROT_OVERRIDE,
+	TEST_STORAGE_PROT_OVERRIDE,
+};
+
+struct test {
+	enum stage stage;
+	void *addr;
+	uint8_t key;
+	enum permission expected;
+} tests[] = {
+	/* Those which result in NONE/UNAVAILABLE will be interpreted by SIE,
+	 * not KVM, but there is no harm in testing them also.
+	 * See Enhanced Suppression-on-Protection Facilities in the
+	 * Interpretive-Execution Mode
+	 */
+	{ TEST_SIMPLE, page_store_prot, 0x00, READ_WRITE },
+	{ TEST_SIMPLE, page_store_prot, 0x10, READ_WRITE },
+	{ TEST_SIMPLE, page_store_prot, 0x20, READ },
+	{ TEST_SIMPLE, page_fetch_prot, 0x00, READ_WRITE },
+	{ TEST_SIMPLE, page_fetch_prot, 0x90, READ_WRITE },
+	{ TEST_SIMPLE, page_fetch_prot, 0x10, NONE },
+	{ TEST_SIMPLE, (void *)0x00, 0x10, UNAVAILABLE },
+	/* Fetch-protection override */
+	{ TEST_FETCH_PROT_OVERRIDE, (void *)0x00, 0x10, READ },
+	{ TEST_FETCH_PROT_OVERRIDE, (void *)2049, 0x10, NONE },
+	/* Storage-protection override */
+	{ TEST_STORAGE_PROT_OVERRIDE, page_fetch_prot, 0x10, READ_WRITE },
+	{ TEST_STORAGE_PROT_OVERRIDE, page_store_prot, 0x20, READ },
+	{ TEST_STORAGE_PROT_OVERRIDE, (void *)2049, 0x10, READ_WRITE },
+	/* End marker */
+	{ STAGE_END, 0, 0, 0 },
+};
+
+static enum stage perform_next_stage(int *i, bool mapped_0)
+{
+	enum stage stage = tests[*i].stage;
+	enum permission result;
+	bool skip;
+
+	for (; tests[*i].stage == stage; (*i)++) {
+		skip = tests[*i].addr < (void *)4096 &&
+		       !mapped_0 &&
+		       tests[*i].expected != UNAVAILABLE;
+		if (!skip) {
+			result = test_protection(tests[*i].addr, tests[*i].key);
+			GUEST_ASSERT_2(result == tests[*i].expected, *i, result);
+		}
+	}
+	return stage;
+}
+
+static void guest_code(void)
+{
+	bool mapped_0;
+	int i = 0;
+
+	GUEST_ASSERT_EQ(set_storage_key(page_store_prot, 0x10), 0);
+	GUEST_ASSERT_EQ(set_storage_key(page_fetch_prot, 0x98), 0);
+	GUEST_SYNC(STAGE_INIT_SIMPLE);
+	GUEST_SYNC(perform_next_stage(&i, false));
+
+	/* Fetch-protection override */
+	mapped_0 = !set_storage_key((void *)0, 0x98);
+	GUEST_SYNC(STAGE_INIT_FETCH_PROT_OVERRIDE);
+	GUEST_SYNC(perform_next_stage(&i, mapped_0));
+
+	/* Storage-protection override */
+	GUEST_SYNC(perform_next_stage(&i, mapped_0));
+}
+
+#define HOST_SYNC(vmp, stage)							\
+({										\
+	struct kvm_vm *__vm = (vmp);						\
+	struct ucall uc;							\
+	int __stage = (stage);							\
+										\
+	vcpu_run(__vm, VCPU_ID);						\
+	get_ucall(__vm, VCPU_ID, &uc);						\
+	if (uc.cmd == UCALL_ABORT) {						\
+		TEST_FAIL("line %lu: %s, hints: %lu, %lu", uc.args[1],		\
+			  (const char *)uc.args[0], uc.args[2], uc.args[3]);	\
+	}									\
+	ASSERT_EQ(uc.cmd, UCALL_SYNC);						\
+	ASSERT_EQ(uc.args[1], __stage);						\
+})
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vm *vm;
+	struct kvm_run *run;
+	vm_vaddr_t guest_0_page;
+
+	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	run = vcpu_state(vm, VCPU_ID);
+
+	HOST_SYNC(vm, STAGE_INIT_SIMPLE);
+	mprotect(addr_gva2hva(vm, (vm_vaddr_t)pages), PAGE_SIZE * 2, PROT_READ);
+	HOST_SYNC(vm, TEST_SIMPLE);
+
+	guest_0_page = vm_vaddr_alloc(vm, PAGE_SIZE, 0);
+	if (guest_0_page != 0)
+		print_skip("Did not allocate page at 0 for fetch protection override tests");
+	HOST_SYNC(vm, STAGE_INIT_FETCH_PROT_OVERRIDE);
+	if (guest_0_page == 0)
+		mprotect(addr_gva2hva(vm, (vm_vaddr_t)0), PAGE_SIZE, PROT_READ);
+	run->s.regs.crs[0] |= CR0_FETCH_PROTECTION_OVERRIDE;
+	run->kvm_dirty_regs = KVM_SYNC_CRS;
+	HOST_SYNC(vm, TEST_FETCH_PROT_OVERRIDE);
+
+	run->s.regs.crs[0] |= CR0_STORAGE_PROTECTION_OVERRIDE;
+	run->kvm_dirty_regs = KVM_SYNC_CRS;
+	HOST_SYNC(vm, TEST_STORAGE_PROT_OVERRIDE);
+}
-- 
2.32.0

