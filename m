Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 817314D9D10
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 15:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348996AbiCOONH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 10:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349040AbiCOOM7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 10:12:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DFA546B9;
        Tue, 15 Mar 2022 07:11:46 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22FDa7N6012359;
        Tue, 15 Mar 2022 14:11:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=fUJ0PW6+HLr6dIHZzShpkZb7Nkxj/ZfwczrCVkP5M3M=;
 b=tD7WtjFkm9EaRENeRhcRvqt1pAAFQ9WHN9VgbG7OvIhFkScXB9t2essYV5HmR7Z7Gxji
 rYxWWxoIysZaDMWvzQfp8rB23y5OW2IHzGF1DOhQ+lwztREFaVyp0YEjEGFrcQOkIEKH
 lmTG8I3F+IkDy8cIytBkQTlQ6aYqk0Xw8QVna27I27JlxdwG8Wt3ZsA+pEH6GZ64AodX
 JNWNldC369o1prwmxgAGeE69e3iSjJTTh1zQBgwtS89bLvSTCK5itQRRmTaiCBXKNULI
 VWO/wHrUfZU1Qhn77HvHnu7A+zvM6llL8RJc05ShonR4NutwLjLGuP//s1jBbd6J7dOL 8g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3etscymh70-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 14:11:46 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22FEADIM011826;
        Tue, 15 Mar 2022 14:11:46 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3etscymh64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 14:11:45 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22FE83ia028989;
        Tue, 15 Mar 2022 14:11:43 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3erk58nt76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 14:11:43 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22FEBe9V55181600
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 14:11:40 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 59E954C04A;
        Tue, 15 Mar 2022 14:11:40 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 380BE4C046;
        Tue, 15 Mar 2022 14:11:40 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 15 Mar 2022 14:11:40 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id E6EA6E127A; Tue, 15 Mar 2022 15:11:39 +0100 (CET)
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
Subject: [GIT PULL 6/7] KVM: s390: selftests: Add more copy memop tests
Date:   Tue, 15 Mar 2022 15:11:36 +0100
Message-Id: <20220315141137.357923-7-borntraeger@linux.ibm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220315141137.357923-1-borntraeger@linux.ibm.com>
References: <20220315141137.357923-1-borntraeger@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RaZBhQ7cf73SslW9Gwkp_Ji_TWVdFTeB
X-Proofpoint-ORIG-GUID: ky8-D_akuMLZEWv5GZ62zoUb4RleoKhP
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-15_03,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 impostorscore=0 mlxlogscore=999 mlxscore=0 clxscore=1015
 spamscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203150092
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Do not just test the actual copy, but also that success is indicated
when using the check only flag.
Add copy test with storage key checking enabled, including tests for
storage and fetch protection override.
These test cover both logical vcpu ioctls as well as absolute vm ioctls.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Link: https://lore.kernel.org/r/20220308125841.3271721-5-scgl@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
---
 tools/testing/selftests/kvm/s390x/memop.c | 247 ++++++++++++++++++++--
 1 file changed, 232 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/s390x/memop.c b/tools/testing/selftests/kvm/s390x/memop.c
index 88ce2d670ed5..42282663b38b 100644
--- a/tools/testing/selftests/kvm/s390x/memop.c
+++ b/tools/testing/selftests/kvm/s390x/memop.c
@@ -195,13 +195,21 @@ static int err_memop_ioctl(struct test_vcpu vcpu, struct kvm_s390_mem_op *ksmo)
 #define AR(a) ._ar = 1, .ar = (a)
 #define KEY(a) .f_key = 1, .key = (a)
 
+#define CHECK_N_DO(f, ...) ({ f(__VA_ARGS__, CHECK_ONLY); f(__VA_ARGS__); })
+
 #define VCPU_ID 1
+#define PAGE_SHIFT 12
+#define PAGE_SIZE (1ULL << PAGE_SHIFT)
+#define PAGE_MASK (~(PAGE_SIZE - 1))
+#define CR0_FETCH_PROTECTION_OVERRIDE	(1UL << (63 - 38))
+#define CR0_STORAGE_PROTECTION_OVERRIDE	(1UL << (63 - 39))
 
 static uint8_t mem1[65536];
 static uint8_t mem2[65536];
 
 struct test_default {
 	struct kvm_vm *kvm_vm;
+	struct test_vcpu vm;
 	struct test_vcpu vcpu;
 	struct kvm_run *run;
 	int size;
@@ -213,6 +221,7 @@ static struct test_default test_default_init(void *guest_code)
 
 	t.size = min((size_t)kvm_check_cap(KVM_CAP_S390_MEM_OP), sizeof(mem1));
 	t.kvm_vm = vm_create_default(VCPU_ID, 0, guest_code);
+	t.vm = (struct test_vcpu) { t.kvm_vm, VM_VCPU_ID };
 	t.vcpu = (struct test_vcpu) { t.kvm_vm, VCPU_ID };
 	t.run = vcpu_state(t.kvm_vm, VCPU_ID);
 	return t;
@@ -223,6 +232,8 @@ enum stage {
 	STAGE_INITED,
 	/* Guest did nothing */
 	STAGE_IDLED,
+	/* Guest set storage keys (specifics up to test case) */
+	STAGE_SKEYS_SET,
 	/* Guest copied memory (locations up to test case) */
 	STAGE_COPIED,
 };
@@ -239,6 +250,47 @@ enum stage {
 	ASSERT_EQ(uc.args[1], __stage);					\
 })									\
 
+static void prepare_mem12(void)
+{
+	int i;
+
+	for (i = 0; i < sizeof(mem1); i++)
+		mem1[i] = rand();
+	memset(mem2, 0xaa, sizeof(mem2));
+}
+
+#define ASSERT_MEM_EQ(p1, p2, size) \
+	TEST_ASSERT(!memcmp(p1, p2, size), "Memory contents do not match!")
+
+#define DEFAULT_WRITE_READ(copy_cpu, mop_cpu, mop_target_p, size, ...)		\
+({										\
+	struct test_vcpu __copy_cpu = (copy_cpu), __mop_cpu = (mop_cpu);	\
+	enum mop_target __target = (mop_target_p);				\
+	uint32_t __size = (size);						\
+										\
+	prepare_mem12();							\
+	CHECK_N_DO(MOP, __mop_cpu, __target, WRITE, mem1, __size,		\
+			GADDR_V(mem1), ##__VA_ARGS__);				\
+	HOST_SYNC(__copy_cpu, STAGE_COPIED);					\
+	CHECK_N_DO(MOP, __mop_cpu, __target, READ, mem2, __size,		\
+			GADDR_V(mem2), ##__VA_ARGS__);				\
+	ASSERT_MEM_EQ(mem1, mem2, __size);					\
+})
+
+#define DEFAULT_READ(copy_cpu, mop_cpu, mop_target_p, size, ...)		\
+({										\
+	struct test_vcpu __copy_cpu = (copy_cpu), __mop_cpu = (mop_cpu);	\
+	enum mop_target __target = (mop_target_p);				\
+	uint32_t __size = (size);						\
+										\
+	prepare_mem12();							\
+	CHECK_N_DO(MOP, __mop_cpu, __target, WRITE, mem1, __size,		\
+			GADDR_V(mem1));						\
+	HOST_SYNC(__copy_cpu, STAGE_COPIED);					\
+	CHECK_N_DO(MOP, __mop_cpu, __target, READ, mem2, __size, ##__VA_ARGS__);\
+	ASSERT_MEM_EQ(mem1, mem2, __size);					\
+})
+
 static void guest_copy(void)
 {
 	GUEST_SYNC(STAGE_INITED);
@@ -249,27 +301,183 @@ static void guest_copy(void)
 static void test_copy(void)
 {
 	struct test_default t = test_default_init(guest_copy);
-	int i;
-
-	for (i = 0; i < sizeof(mem1); i++)
-		mem1[i] = i * i + i;
 
 	HOST_SYNC(t.vcpu, STAGE_INITED);
 
-	/* Set the first array */
-	MOP(t.vcpu, LOGICAL, WRITE, mem1, t.size, GADDR_V(mem1));
+	DEFAULT_WRITE_READ(t.vcpu, t.vcpu, LOGICAL, t.size);
 
-	/* Let the guest code copy the first array to the second */
+	kvm_vm_free(t.kvm_vm);
+}
+
+static void set_storage_key_range(void *addr, size_t len, uint8_t key)
+{
+	uintptr_t _addr, abs, i;
+	int not_mapped = 0;
+
+	_addr = (uintptr_t)addr;
+	for (i = _addr & PAGE_MASK; i < _addr + len; i += PAGE_SIZE) {
+		abs = i;
+		asm volatile (
+			       "lra	%[abs], 0(0,%[abs])\n"
+			"	jz	0f\n"
+			"	llill	%[not_mapped],1\n"
+			"	j	1f\n"
+			"0:	sske	%[key], %[abs]\n"
+			"1:"
+			: [abs] "+&a" (abs), [not_mapped] "+r" (not_mapped)
+			: [key] "r" (key)
+			: "cc"
+		);
+		GUEST_ASSERT_EQ(not_mapped, 0);
+	}
+}
+
+static void guest_copy_key(void)
+{
+	set_storage_key_range(mem1, sizeof(mem1), 0x90);
+	set_storage_key_range(mem2, sizeof(mem2), 0x90);
+	GUEST_SYNC(STAGE_SKEYS_SET);
+
+	for (;;) {
+		memcpy(&mem2, &mem1, sizeof(mem2));
+		GUEST_SYNC(STAGE_COPIED);
+	}
+}
+
+static void test_copy_key(void)
+{
+	struct test_default t = test_default_init(guest_copy_key);
+
+	HOST_SYNC(t.vcpu, STAGE_SKEYS_SET);
+
+	/* vm, no key */
+	DEFAULT_WRITE_READ(t.vcpu, t.vm, ABSOLUTE, t.size);
+
+	/* vm/vcpu, machting key or key 0 */
+	DEFAULT_WRITE_READ(t.vcpu, t.vcpu, LOGICAL, t.size, KEY(0));
+	DEFAULT_WRITE_READ(t.vcpu, t.vcpu, LOGICAL, t.size, KEY(9));
+	DEFAULT_WRITE_READ(t.vcpu, t.vm, ABSOLUTE, t.size, KEY(0));
+	DEFAULT_WRITE_READ(t.vcpu, t.vm, ABSOLUTE, t.size, KEY(9));
+	/*
+	 * There used to be different code paths for key handling depending on
+	 * if the region crossed a page boundary.
+	 * There currently are not, but the more tests the merrier.
+	 */
+	DEFAULT_WRITE_READ(t.vcpu, t.vcpu, LOGICAL, 1, KEY(0));
+	DEFAULT_WRITE_READ(t.vcpu, t.vcpu, LOGICAL, 1, KEY(9));
+	DEFAULT_WRITE_READ(t.vcpu, t.vm, ABSOLUTE, 1, KEY(0));
+	DEFAULT_WRITE_READ(t.vcpu, t.vm, ABSOLUTE, 1, KEY(9));
+
+	/* vm/vcpu, mismatching keys on read, but no fetch protection */
+	DEFAULT_READ(t.vcpu, t.vcpu, LOGICAL, t.size, GADDR_V(mem2), KEY(2));
+	DEFAULT_READ(t.vcpu, t.vm, ABSOLUTE, t.size, GADDR_V(mem1), KEY(2));
+
+	kvm_vm_free(t.kvm_vm);
+}
+
+static void guest_copy_key_fetch_prot(void)
+{
+	/*
+	 * For some reason combining the first sync with override enablement
+	 * results in an exception when calling HOST_SYNC.
+	 */
+	GUEST_SYNC(STAGE_INITED);
+	/* Storage protection override applies to both store and fetch. */
+	set_storage_key_range(mem1, sizeof(mem1), 0x98);
+	set_storage_key_range(mem2, sizeof(mem2), 0x98);
+	GUEST_SYNC(STAGE_SKEYS_SET);
+
+	for (;;) {
+		memcpy(&mem2, &mem1, sizeof(mem2));
+		GUEST_SYNC(STAGE_COPIED);
+	}
+}
+
+static void test_copy_key_storage_prot_override(void)
+{
+	struct test_default t = test_default_init(guest_copy_key_fetch_prot);
+
+	HOST_SYNC(t.vcpu, STAGE_INITED);
+	t.run->s.regs.crs[0] |= CR0_STORAGE_PROTECTION_OVERRIDE;
+	t.run->kvm_dirty_regs = KVM_SYNC_CRS;
+	HOST_SYNC(t.vcpu, STAGE_SKEYS_SET);
+
+	/* vcpu, mismatching keys, storage protection override in effect */
+	DEFAULT_WRITE_READ(t.vcpu, t.vcpu, LOGICAL, t.size, KEY(2));
+
+	kvm_vm_free(t.kvm_vm);
+}
+
+static void test_copy_key_fetch_prot(void)
+{
+	struct test_default t = test_default_init(guest_copy_key_fetch_prot);
+
+	HOST_SYNC(t.vcpu, STAGE_INITED);
+	HOST_SYNC(t.vcpu, STAGE_SKEYS_SET);
+
+	/* vm/vcpu, matching key, fetch protection in effect */
+	DEFAULT_READ(t.vcpu, t.vcpu, LOGICAL, t.size, GADDR_V(mem2), KEY(9));
+	DEFAULT_READ(t.vcpu, t.vm, ABSOLUTE, t.size, GADDR_V(mem2), KEY(9));
+
+	kvm_vm_free(t.kvm_vm);
+}
+
+const uint64_t last_page_addr = -PAGE_SIZE;
+
+static void guest_copy_key_fetch_prot_override(void)
+{
+	int i;
+	char *page_0 = 0;
+
+	GUEST_SYNC(STAGE_INITED);
+	set_storage_key_range(0, PAGE_SIZE, 0x18);
+	set_storage_key_range((void *)last_page_addr, PAGE_SIZE, 0x0);
+	asm volatile ("sske %[key],%[addr]\n" :: [addr] "r"(0), [key] "r"(0x18) : "cc");
+	GUEST_SYNC(STAGE_SKEYS_SET);
+
+	for (;;) {
+		for (i = 0; i < PAGE_SIZE; i++)
+			page_0[i] = mem1[i];
+		GUEST_SYNC(STAGE_COPIED);
+	}
+}
+
+static void test_copy_key_fetch_prot_override(void)
+{
+	struct test_default t = test_default_init(guest_copy_key_fetch_prot_override);
+	vm_vaddr_t guest_0_page, guest_last_page;
+
+	guest_0_page = vm_vaddr_alloc(t.kvm_vm, PAGE_SIZE, 0);
+	guest_last_page = vm_vaddr_alloc(t.kvm_vm, PAGE_SIZE, last_page_addr);
+	if (guest_0_page != 0 || guest_last_page != last_page_addr) {
+		print_skip("did not allocate guest pages at required positions");
+		goto out;
+	}
+
+	HOST_SYNC(t.vcpu, STAGE_INITED);
+	t.run->s.regs.crs[0] |= CR0_FETCH_PROTECTION_OVERRIDE;
+	t.run->kvm_dirty_regs = KVM_SYNC_CRS;
+	HOST_SYNC(t.vcpu, STAGE_SKEYS_SET);
+
+	/* vcpu, mismatching keys on fetch, fetch protection override applies */
+	prepare_mem12();
+	MOP(t.vcpu, LOGICAL, WRITE, mem1, PAGE_SIZE, GADDR_V(mem1));
 	HOST_SYNC(t.vcpu, STAGE_COPIED);
+	CHECK_N_DO(MOP, t.vcpu, LOGICAL, READ, mem2, 2048, GADDR_V(guest_0_page), KEY(2));
+	ASSERT_MEM_EQ(mem1, mem2, 2048);
 
-	memset(mem2, 0xaa, sizeof(mem2));
-
-	/* Get the second array */
-	MOP(t.vcpu, LOGICAL, READ, mem2, t.size, GADDR_V(mem2));
-
-	TEST_ASSERT(!memcmp(mem1, mem2, t.size),
-		    "Memory contents do not match!");
+	/*
+	 * vcpu, mismatching keys on fetch, fetch protection override applies,
+	 * wraparound
+	 */
+	prepare_mem12();
+	MOP(t.vcpu, LOGICAL, WRITE, mem1, 2 * PAGE_SIZE, GADDR_V(guest_last_page));
+	HOST_SYNC(t.vcpu, STAGE_COPIED);
+	CHECK_N_DO(MOP, t.vcpu, LOGICAL, READ, mem2, PAGE_SIZE + 2048,
+		   GADDR_V(guest_last_page), KEY(2));
+	ASSERT_MEM_EQ(mem1, mem2, 2048);
 
+out:
 	kvm_vm_free(t.kvm_vm);
 }
 
@@ -335,17 +543,26 @@ static void test_errors(void)
 
 int main(int argc, char *argv[])
 {
-	int memop_cap;
+	int memop_cap, extension_cap;
 
 	setbuf(stdout, NULL);	/* Tell stdout not to buffer its content */
 
 	memop_cap = kvm_check_cap(KVM_CAP_S390_MEM_OP);
+	extension_cap = kvm_check_cap(KVM_CAP_S390_MEM_OP_EXTENSION);
 	if (!memop_cap) {
 		print_skip("CAP_S390_MEM_OP not supported");
 		exit(KSFT_SKIP);
 	}
 
 	test_copy();
+	if (extension_cap > 0) {
+		test_copy_key();
+		test_copy_key_storage_prot_override();
+		test_copy_key_fetch_prot();
+		test_copy_key_fetch_prot_override();
+	} else {
+		print_skip("storage key memop extension not supported");
+	}
 	test_errors();
 
 	return 0;
-- 
2.35.1

