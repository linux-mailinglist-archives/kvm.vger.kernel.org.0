Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3164B2CC4
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 19:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350350AbiBKSWb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 13:22:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347352AbiBKSW2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 13:22:28 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE2AD4B;
        Fri, 11 Feb 2022 10:22:26 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21BG7FdC006066;
        Fri, 11 Feb 2022 18:22:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=OiuAH7C13RosG5m5BaiojgfE/FWaUD5nb7GxdoFhOB8=;
 b=mwuLCNYqavCtI18aYoQfu9Zuf3vtoC8Q6A4y00SCMMBWKoxlZWFsz1TfaTmWEVQGeqgv
 LpFeXTj4Izoe7meRAIQn7OyMgSDUvdIXRdzrTZLVYs6xotO8jr7HwUH2BDmTLWNmz0VO
 zDx4OYIBorZ8/LJeIt7qZYgLzFiDhTes3O6ZCB9dmaN8TTY8BnLa+DiJhbw4t2tYxUzP
 YdnQ5bq1X5GH3Dhi8Ym3H7ItzbsV1u0PRPn4eaXvsJdfNntCgvXMT1WyvIjflDFZ3rvN
 bMFmLVTsw1uOiJGnFkoWsBV+H39hZQUFhgZwwPaiNmBzIVTNboshWLJ7BsbOhG5Ceu/3 mA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e5mrk3hdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 18:22:25 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21BI5bk3026068;
        Fri, 11 Feb 2022 18:22:25 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e5mrk3hcx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 18:22:24 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21BIDaTc000939;
        Fri, 11 Feb 2022 18:22:22 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3e1gva9htf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Feb 2022 18:22:22 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21BIMJrQ21889528
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 18:22:19 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F45952050;
        Fri, 11 Feb 2022 18:22:19 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id CA52452051;
        Fri, 11 Feb 2022 18:22:18 +0000 (GMT)
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH v4 04/10] KVM: s390: selftests: Test TEST PROTECTION emulation
Date:   Fri, 11 Feb 2022 19:22:09 +0100
Message-Id: <20220211182215.2730017-5-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220211182215.2730017-1-scgl@linux.ibm.com>
References: <20220211182215.2730017-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7GiqbC5VG26JgIkBRbJY_mmX12LFaTwT
X-Proofpoint-GUID: NFMhRKCoTO6YUr1KsBm6M-EF7vyjU3F-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-11_05,2022-02-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 suspectscore=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 malwarescore=0
 mlxlogscore=999 clxscore=1015 spamscore=0 phishscore=0 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202110098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test the emulation of TEST PROTECTION in the presence of storage keys.
Emulation only occurs under certain conditions, one of which is the host
page being protected.
Trigger this by protecting the test pages via mprotect.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 tools/testing/selftests/kvm/.gitignore    |   1 +
 tools/testing/selftests/kvm/Makefile      |   1 +
 tools/testing/selftests/kvm/s390x/tprot.c | 227 ++++++++++++++++++++++
 3 files changed, 229 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/s390x/tprot.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index dce7de7755e6..7903580a48ac 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -8,6 +8,7 @@
 /s390x/memop
 /s390x/resets
 /s390x/sync_regs_test
+/s390x/tprot
 /x86_64/amx_test
 /x86_64/cpuid_test
 /x86_64/cr4_cpuid_sync_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 0e4926bc9a58..086f490e808d 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -121,6 +121,7 @@ TEST_GEN_PROGS_aarch64 += kvm_binary_stats_test
 TEST_GEN_PROGS_s390x = s390x/memop
 TEST_GEN_PROGS_s390x += s390x/resets
 TEST_GEN_PROGS_s390x += s390x/sync_regs_test
+TEST_GEN_PROGS_s390x += s390x/tprot
 TEST_GEN_PROGS_s390x += demand_paging_test
 TEST_GEN_PROGS_s390x += dirty_log_test
 TEST_GEN_PROGS_s390x += kvm_create_max_vcpus
diff --git a/tools/testing/selftests/kvm/s390x/tprot.c b/tools/testing/selftests/kvm/s390x/tprot.c
new file mode 100644
index 000000000000..c097b9db495e
--- /dev/null
+++ b/tools/testing/selftests/kvm/s390x/tprot.c
@@ -0,0 +1,227 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Test TEST PROTECTION emulation.
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
+/* Nonzero return value indicates that address not mapped */
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
+	RW_PROTECTED = 2,
+	TRANSL_UNAVAIL = 3,
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
+	return (enum permission)(mask >> 28);
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
+	/*
+	 * We perform each test in the array by executing TEST PROTECTION on
+	 * the specified addr with the specified key and checking if the returned
+	 * permissions match the expected value.
+	 * Both guest and host cooperate to set up the required test conditions.
+	 * A central condition is that the page targeted by addr has to be DAT
+	 * protected in the host mappings, in order for KVM to emulate the
+	 * TEST PROTECTION instruction.
+	 * Since the page tables are shared, the host uses mprotect to achieve
+	 * this.
+	 *
+	 * Test resulting in RW_PROTECTED/TRANSL_UNAVAIL will be interpreted
+	 * by SIE, not KVM, but there is no harm in testing them also.
+	 * See Enhanced Suppression-on-Protection Facilities in the
+	 * Interpretive-Execution Mode
+	 */
+	/*
+	 * guest: set storage key of page_store_prot to 1
+	 *        storage key of page_fetch_prot to 9 and enable
+	 *        protection for it
+	 * STAGE_INIT_SIMPLE
+	 * host: write protect both via mprotect
+	 */
+	/* access key 0 matches any storage key -> RW */
+	{ TEST_SIMPLE, page_store_prot, 0x00, READ_WRITE },
+	/* access key matches storage key -> RW */
+	{ TEST_SIMPLE, page_store_prot, 0x10, READ_WRITE },
+	/* mismatched keys, but no fetch protection -> RO */
+	{ TEST_SIMPLE, page_store_prot, 0x20, READ },
+	/* access key 0 matches any storage key -> RW */
+	{ TEST_SIMPLE, page_fetch_prot, 0x00, READ_WRITE },
+	/* access key matches storage key -> RW */
+	{ TEST_SIMPLE, page_fetch_prot, 0x90, READ_WRITE },
+	/* mismatched keys, fetch protection -> inaccessible */
+	{ TEST_SIMPLE, page_fetch_prot, 0x10, RW_PROTECTED },
+	/* page 0 not mapped yet -> translation not available */
+	{ TEST_SIMPLE, (void *)0x00, 0x10, TRANSL_UNAVAIL },
+	/*
+	 * host: try to map page 0
+	 * guest: set storage key of page 0 to 9 and enable fetch protection
+	 * STAGE_INIT_FETCH_PROT_OVERRIDE
+	 * host: write protect page 0
+	 *       enable fetch protection override
+	 */
+	/* mismatched keys, fetch protection, but override applies -> RO */
+	{ TEST_FETCH_PROT_OVERRIDE, (void *)0x00, 0x10, READ },
+	/* mismatched keys, fetch protection, override applies to 0-2048 only -> inaccessible */
+	{ TEST_FETCH_PROT_OVERRIDE, (void *)2049, 0x10, RW_PROTECTED },
+	/*
+	 * host: enable storage protection override
+	 */
+	/* mismatched keys, but override applies (storage key 9) -> RW */
+	{ TEST_STORAGE_PROT_OVERRIDE, page_fetch_prot, 0x10, READ_WRITE },
+	/* mismatched keys, no fetch protection, override doesn't apply -> RO */
+	{ TEST_STORAGE_PROT_OVERRIDE, page_store_prot, 0x20, READ },
+	/* mismatched keys, but override applies (storage key 9) -> RW */
+	{ TEST_STORAGE_PROT_OVERRIDE, (void *)2049, 0x10, READ_WRITE },
+	/* end marker */
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
+		/*
+		 * Some fetch protection override tests require that page 0
+		 * be mapped, however, when the hosts tries to map that page via
+		 * vm_vaddr_alloc, it may happen that some other page gets mapped
+		 * instead.
+		 * In order to skip these tests we detect this inside the guest
+		 */
+		skip = tests[*i].addr < (void *)4096 &&
+		       tests[*i].expected != TRANSL_UNAVAIL &&
+		       !mapped_0;
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

