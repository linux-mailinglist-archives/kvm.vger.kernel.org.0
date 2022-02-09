Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1484AF7BD
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 18:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237966AbiBIRFF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 12:05:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237871AbiBIREj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 12:04:39 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25721C050CCD;
        Wed,  9 Feb 2022 09:04:33 -0800 (PST)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219F3a4O027616;
        Wed, 9 Feb 2022 17:04:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=OiuAH7C13RosG5m5BaiojgfE/FWaUD5nb7GxdoFhOB8=;
 b=GBxWwotuVnL+ZqlTkKA3kCSxLQoKK6q5/KQMaV0uAZOlHFCbBUnrrTFmQv3U9yqFUO+x
 e0ZzTAZZ2TZ79+mmOqsPWhB5vrDTf++HP9JgREA/EenS9N4HnuPgfcUJmf/B4O63NjDq
 Lmk2dTkvT8oq0aAwRVwOpE5haBby9y2esXPhOn4SIWm6F0+tnUs2LRQtm5XbOw51qDdz
 eVI2gCRjYk1m+EECbMC78T607WIpOuT8AxgkPhw8nkw0mfGTzsNTyD6l2lGpI8q5C8MS
 DseVQtlpTXNfrNUYPkrcA+mvgGSDxA378atzOppdh1zYPz4WHc8Mx6E81ABWFuWxRrTT 4g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e4fww2vae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 17:04:31 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 219GAJGt000877;
        Wed, 9 Feb 2022 17:04:31 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e4fww2v9v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 17:04:31 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 219H25up011944;
        Wed, 9 Feb 2022 17:04:29 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3e1gv9rxw1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Feb 2022 17:04:29 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 219H4QIY41025918
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Feb 2022 17:04:26 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F75DA405B;
        Wed,  9 Feb 2022 17:04:26 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B9FB2A4060;
        Wed,  9 Feb 2022 17:04:25 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Feb 2022 17:04:25 +0000 (GMT)
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
Subject: [PATCH v3 04/10] KVM: s390: selftests: Test TEST PROTECTION emulation
Date:   Wed,  9 Feb 2022 18:04:16 +0100
Message-Id: <20220209170422.1910690-5-scgl@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220209170422.1910690-1-scgl@linux.ibm.com>
References: <20220209170422.1910690-1-scgl@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0ea236Lf88n0R78SUYLInU-4GUVUEn9x
X-Proofpoint-GUID: chIgOkzcqjCxvP7W-pqQalBKtKekPgqz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-09_09,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999
 clxscore=1015 spamscore=0 bulkscore=0 mlxscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202090094
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

