Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3B586904B8
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 11:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbjBIKZs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 05:25:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjBIKZQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 05:25:16 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B7F66EEF;
        Thu,  9 Feb 2023 02:25:14 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 319AGKgd003850;
        Thu, 9 Feb 2023 10:25:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=Zlz2Kay0W8QqiVpwKhghbgq+FWPQoFVSg5O4xPM+q2k=;
 b=ete9Mi6Drkct4qMWPz7xi2D9kC0y9UtJrC8NFPdiU4O5VXiNHL3GxOIvQkLTmXTo9KW6
 EyUdktUBK/Ga/dy4UMSqY4R+1UjAi1SOLvRklmWidThZppVBB44lz/qASBwakMn7EZx2
 6r/8Y24/+CFLnRgIUNoDUPDW7NXPgby44yR3b1wf3rl3LKPalPytskePc5gyDJDZFZQF
 BROSoPDhp02AB5bJkGC6zYIJDD776kSDAdWHMdVs005LWL44TA8xY2L1ICEqqJI6X/8G
 WO7eTD7WDOUXfRn1bq7uoHUV18s8v3dJizDToQpa/vgwFxtNLqQkDsarCdGx+AfiIcdj 1Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmxxbr60n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 10:25:13 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 319AI56O012769;
        Thu, 9 Feb 2023 10:25:13 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmxxbr607-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 10:25:13 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31916IGY022813;
        Thu, 9 Feb 2023 10:25:11 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3nhemfm9ph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 10:25:11 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 319AP7hU44630360
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Feb 2023 10:25:07 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3DEF2006A;
        Thu,  9 Feb 2023 10:25:07 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E40920071;
        Thu,  9 Feb 2023 10:25:07 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com (unknown [9.152.224.253])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  9 Feb 2023 10:25:07 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com
Subject: [GIT PULL 16/18] KVM: s390: selftest: memop: Add cmpxchg tests
Date:   Thu,  9 Feb 2023 11:22:58 +0100
Message-Id: <20230209102300.12254-17-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230209102300.12254-1-frankja@linux.ibm.com>
References: <20230209102300.12254-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CD_0-Nfjd4Jq0MxxuJbc_QtDjubKp6Nh
X-Proofpoint-ORIG-GUID: EIZyS34UIfOG5Bog9kdFXqEtsy3CjqPn
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_07,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 lowpriorityscore=0
 malwarescore=0 mlxlogscore=932 mlxscore=0 impostorscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090090
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Test successful exchange, unsuccessful exchange, storage key protection
and invalid arguments.

Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20230207164225.2114706-1-scgl@linux.ibm.com
Message-Id: <20230207164225.2114706-1-scgl@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 tools/testing/selftests/kvm/s390x/memop.c | 411 +++++++++++++++++++++-
 1 file changed, 394 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/s390x/memop.c b/tools/testing/selftests/kvm/s390x/memop.c
index c5fec84ef3c2..8e4b94d7b8dd 100644
--- a/tools/testing/selftests/kvm/s390x/memop.c
+++ b/tools/testing/selftests/kvm/s390x/memop.c
@@ -9,6 +9,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <sys/ioctl.h>
+#include <pthread.h>
 
 #include <linux/bits.h>
 
@@ -26,6 +27,7 @@ enum mop_target {
 enum mop_access_mode {
 	READ,
 	WRITE,
+	CMPXCHG,
 };
 
 struct mop_desc {
@@ -44,13 +46,16 @@ struct mop_desc {
 	enum mop_access_mode mode;
 	void *buf;
 	uint32_t sida_offset;
+	void *old;
+	uint8_t old_value[16];
+	bool *cmpxchg_success;
 	uint8_t ar;
 	uint8_t key;
 };
 
 const uint8_t NO_KEY = 0xff;
 
-static struct kvm_s390_mem_op ksmo_from_desc(const struct mop_desc *desc)
+static struct kvm_s390_mem_op ksmo_from_desc(struct mop_desc *desc)
 {
 	struct kvm_s390_mem_op ksmo = {
 		.gaddr = (uintptr_t)desc->gaddr,
@@ -77,6 +82,11 @@ static struct kvm_s390_mem_op ksmo_from_desc(const struct mop_desc *desc)
 			ksmo.op = KVM_S390_MEMOP_ABSOLUTE_READ;
 		if (desc->mode == WRITE)
 			ksmo.op = KVM_S390_MEMOP_ABSOLUTE_WRITE;
+		if (desc->mode == CMPXCHG) {
+			ksmo.op = KVM_S390_MEMOP_ABSOLUTE_CMPXCHG;
+			ksmo.old_addr = (uint64_t)desc->old;
+			memcpy(desc->old_value, desc->old, desc->size);
+		}
 		break;
 	case INVALID:
 		ksmo.op = -1;
@@ -135,9 +145,13 @@ static void print_memop(struct kvm_vcpu *vcpu, const struct kvm_s390_mem_op *ksm
 	case KVM_S390_MEMOP_ABSOLUTE_WRITE:
 		printf("ABSOLUTE, WRITE, ");
 		break;
+	case KVM_S390_MEMOP_ABSOLUTE_CMPXCHG:
+		printf("ABSOLUTE, CMPXCHG, ");
+		break;
 	}
-	printf("gaddr=%llu, size=%u, buf=%llu, ar=%u, key=%u",
-	       ksmo->gaddr, ksmo->size, ksmo->buf, ksmo->ar, ksmo->key);
+	printf("gaddr=%llu, size=%u, buf=%llu, ar=%u, key=%u, old_addr=%llx",
+	       ksmo->gaddr, ksmo->size, ksmo->buf, ksmo->ar, ksmo->key,
+	       ksmo->old_addr);
 	if (ksmo->flags & KVM_S390_MEMOP_F_CHECK_ONLY)
 		printf(", CHECK_ONLY");
 	if (ksmo->flags & KVM_S390_MEMOP_F_INJECT_EXCEPTION)
@@ -147,17 +161,8 @@ static void print_memop(struct kvm_vcpu *vcpu, const struct kvm_s390_mem_op *ksm
 	puts(")");
 }
 
-static void memop_ioctl(struct test_info info, struct kvm_s390_mem_op *ksmo)
-{
-	struct kvm_vcpu *vcpu = info.vcpu;
-
-	if (!vcpu)
-		vm_ioctl(info.vm, KVM_S390_MEM_OP, ksmo);
-	else
-		vcpu_ioctl(vcpu, KVM_S390_MEM_OP, ksmo);
-}
-
-static int err_memop_ioctl(struct test_info info, struct kvm_s390_mem_op *ksmo)
+static int err_memop_ioctl(struct test_info info, struct kvm_s390_mem_op *ksmo,
+			   struct mop_desc *desc)
 {
 	struct kvm_vcpu *vcpu = info.vcpu;
 
@@ -167,6 +172,21 @@ static int err_memop_ioctl(struct test_info info, struct kvm_s390_mem_op *ksmo)
 		return __vcpu_ioctl(vcpu, KVM_S390_MEM_OP, ksmo);
 }
 
+static void memop_ioctl(struct test_info info, struct kvm_s390_mem_op *ksmo,
+			struct mop_desc *desc)
+{
+	int r;
+
+	r = err_memop_ioctl(info, ksmo, desc);
+	if (ksmo->op == KVM_S390_MEMOP_ABSOLUTE_CMPXCHG) {
+		if (desc->cmpxchg_success) {
+			int diff = memcmp(desc->old_value, desc->old, desc->size);
+			*desc->cmpxchg_success = !diff;
+		}
+	}
+	TEST_ASSERT(!r, __KVM_IOCTL_ERROR("KVM_S390_MEM_OP", r));
+}
+
 #define MEMOP(err, info_p, mop_target_p, access_mode_p, buf_p, size_p, ...)	\
 ({										\
 	struct test_info __info = (info_p);					\
@@ -187,7 +207,7 @@ static int err_memop_ioctl(struct test_info info, struct kvm_s390_mem_op *ksmo)
 	}									\
 	__ksmo = ksmo_from_desc(&__desc);					\
 	print_memop(__info.vcpu, &__ksmo);					\
-	err##memop_ioctl(__info, &__ksmo);					\
+	err##memop_ioctl(__info, &__ksmo, &__desc);				\
 })
 
 #define MOP(...) MEMOP(, __VA_ARGS__)
@@ -201,6 +221,8 @@ static int err_memop_ioctl(struct test_info info, struct kvm_s390_mem_op *ksmo)
 #define AR(a) ._ar = 1, .ar = (a)
 #define KEY(a) .f_key = 1, .key = (a)
 #define INJECT .f_inject = 1
+#define CMPXCHG_OLD(o) .old = (o)
+#define CMPXCHG_SUCCESS(s) .cmpxchg_success = (s)
 
 #define CHECK_N_DO(f, ...) ({ f(__VA_ARGS__, CHECK_ONLY); f(__VA_ARGS__); })
 
@@ -210,8 +232,8 @@ static int err_memop_ioctl(struct test_info info, struct kvm_s390_mem_op *ksmo)
 #define CR0_FETCH_PROTECTION_OVERRIDE	(1UL << (63 - 38))
 #define CR0_STORAGE_PROTECTION_OVERRIDE	(1UL << (63 - 39))
 
-static uint8_t mem1[65536];
-static uint8_t mem2[65536];
+static uint8_t __aligned(PAGE_SIZE) mem1[65536];
+static uint8_t __aligned(PAGE_SIZE) mem2[65536];
 
 struct test_default {
 	struct kvm_vm *kvm_vm;
@@ -243,6 +265,8 @@ enum stage {
 	STAGE_SKEYS_SET,
 	/* Guest copied memory (locations up to test case) */
 	STAGE_COPIED,
+	/* End of guest code reached */
+	STAGE_DONE,
 };
 
 #define HOST_SYNC(info_p, stage)					\
@@ -254,6 +278,9 @@ enum stage {
 									\
 	vcpu_run(__vcpu);						\
 	get_ucall(__vcpu, &uc);						\
+	if (uc.cmd == UCALL_ABORT) {					\
+		REPORT_GUEST_ASSERT_2(uc, "hints: %lu, %lu");		\
+	}								\
 	ASSERT_EQ(uc.cmd, UCALL_SYNC);					\
 	ASSERT_EQ(uc.args[1], __stage);					\
 })									\
@@ -293,6 +320,44 @@ static void default_read(struct test_info copy_cpu, struct test_info mop_cpu,
 	ASSERT_MEM_EQ(mem1, mem2, size);
 }
 
+static void default_cmpxchg(struct test_default *test, uint8_t key)
+{
+	for (int size = 1; size <= 16; size *= 2) {
+		for (int offset = 0; offset < 16; offset += size) {
+			uint8_t __aligned(16) new[16] = {};
+			uint8_t __aligned(16) old[16];
+			bool succ;
+
+			prepare_mem12();
+			default_write_read(test->vcpu, test->vcpu, LOGICAL, 16, NO_KEY);
+
+			memcpy(&old, mem1, 16);
+			MOP(test->vm, ABSOLUTE, CMPXCHG, new + offset,
+			    size, GADDR_V(mem1 + offset),
+			    CMPXCHG_OLD(old + offset),
+			    CMPXCHG_SUCCESS(&succ), KEY(key));
+			HOST_SYNC(test->vcpu, STAGE_COPIED);
+			MOP(test->vm, ABSOLUTE, READ, mem2, 16, GADDR_V(mem2));
+			TEST_ASSERT(succ, "exchange of values should succeed");
+			memcpy(mem1 + offset, new + offset, size);
+			ASSERT_MEM_EQ(mem1, mem2, 16);
+
+			memcpy(&old, mem1, 16);
+			new[offset]++;
+			old[offset]++;
+			MOP(test->vm, ABSOLUTE, CMPXCHG, new + offset,
+			    size, GADDR_V(mem1 + offset),
+			    CMPXCHG_OLD(old + offset),
+			    CMPXCHG_SUCCESS(&succ), KEY(key));
+			HOST_SYNC(test->vcpu, STAGE_COPIED);
+			MOP(test->vm, ABSOLUTE, READ, mem2, 16, GADDR_V(mem2));
+			TEST_ASSERT(!succ, "exchange of values should not succeed");
+			ASSERT_MEM_EQ(mem1, mem2, 16);
+			ASSERT_MEM_EQ(&old, mem1, 16);
+		}
+	}
+}
+
 static void guest_copy(void)
 {
 	GUEST_SYNC(STAGE_INITED);
@@ -377,6 +442,248 @@ static void test_copy_key(void)
 	kvm_vm_free(t.kvm_vm);
 }
 
+static void test_cmpxchg_key(void)
+{
+	struct test_default t = test_default_init(guest_copy_key);
+
+	HOST_SYNC(t.vcpu, STAGE_SKEYS_SET);
+
+	default_cmpxchg(&t, NO_KEY);
+	default_cmpxchg(&t, 0);
+	default_cmpxchg(&t, 9);
+
+	kvm_vm_free(t.kvm_vm);
+}
+
+static __uint128_t cut_to_size(int size, __uint128_t val)
+{
+	switch (size) {
+	case 1:
+		return (uint8_t)val;
+	case 2:
+		return (uint16_t)val;
+	case 4:
+		return (uint32_t)val;
+	case 8:
+		return (uint64_t)val;
+	case 16:
+		return val;
+	}
+	GUEST_ASSERT_1(false, "Invalid size");
+	return 0;
+}
+
+static bool popcount_eq(__uint128_t a, __uint128_t b)
+{
+	unsigned int count_a, count_b;
+
+	count_a = __builtin_popcountl((uint64_t)(a >> 64)) +
+		  __builtin_popcountl((uint64_t)a);
+	count_b = __builtin_popcountl((uint64_t)(b >> 64)) +
+		  __builtin_popcountl((uint64_t)b);
+	return count_a == count_b;
+}
+
+static __uint128_t rotate(int size, __uint128_t val, int amount)
+{
+	unsigned int bits = size * 8;
+
+	amount = (amount + bits) % bits;
+	val = cut_to_size(size, val);
+	return (val << (bits - amount)) | (val >> amount);
+}
+
+const unsigned int max_block = 16;
+
+static void choose_block(bool guest, int i, int *size, int *offset)
+{
+	unsigned int rand;
+
+	rand = i;
+	if (guest) {
+		rand = rand * 19 + 11;
+		*size = 1 << ((rand % 3) + 2);
+		rand = rand * 19 + 11;
+		*offset = (rand % max_block) & ~(*size - 1);
+	} else {
+		rand = rand * 17 + 5;
+		*size = 1 << (rand % 5);
+		rand = rand * 17 + 5;
+		*offset = (rand % max_block) & ~(*size - 1);
+	}
+}
+
+static __uint128_t permutate_bits(bool guest, int i, int size, __uint128_t old)
+{
+	unsigned int rand;
+	int amount;
+	bool swap;
+
+	rand = i;
+	rand = rand * 3 + 1;
+	if (guest)
+		rand = rand * 3 + 1;
+	swap = rand % 2 == 0;
+	if (swap) {
+		int i, j;
+		__uint128_t new;
+		uint8_t byte0, byte1;
+
+		rand = rand * 3 + 1;
+		i = rand % size;
+		rand = rand * 3 + 1;
+		j = rand % size;
+		if (i == j)
+			return old;
+		new = rotate(16, old, i * 8);
+		byte0 = new & 0xff;
+		new &= ~0xff;
+		new = rotate(16, new, -i * 8);
+		new = rotate(16, new, j * 8);
+		byte1 = new & 0xff;
+		new = (new & ~0xff) | byte0;
+		new = rotate(16, new, -j * 8);
+		new = rotate(16, new, i * 8);
+		new = new | byte1;
+		new = rotate(16, new, -i * 8);
+		return new;
+	}
+	rand = rand * 3 + 1;
+	amount = rand % (size * 8);
+	return rotate(size, old, amount);
+}
+
+static bool _cmpxchg(int size, void *target, __uint128_t *old_addr, __uint128_t new)
+{
+	bool ret;
+
+	switch (size) {
+	case 4: {
+			uint32_t old = *old_addr;
+
+			asm volatile ("cs %[old],%[new],%[address]"
+			    : [old] "+d" (old),
+			      [address] "+Q" (*(uint32_t *)(target))
+			    : [new] "d" ((uint32_t)new)
+			    : "cc"
+			);
+			ret = old == (uint32_t)*old_addr;
+			*old_addr = old;
+			return ret;
+		}
+	case 8: {
+			uint64_t old = *old_addr;
+
+			asm volatile ("csg %[old],%[new],%[address]"
+			    : [old] "+d" (old),
+			      [address] "+Q" (*(uint64_t *)(target))
+			    : [new] "d" ((uint64_t)new)
+			    : "cc"
+			);
+			ret = old == (uint64_t)*old_addr;
+			*old_addr = old;
+			return ret;
+		}
+	case 16: {
+			__uint128_t old = *old_addr;
+
+			asm volatile ("cdsg %[old],%[new],%[address]"
+			    : [old] "+d" (old),
+			      [address] "+Q" (*(__uint128_t *)(target))
+			    : [new] "d" (new)
+			    : "cc"
+			);
+			ret = old == *old_addr;
+			*old_addr = old;
+			return ret;
+		}
+	}
+	GUEST_ASSERT_1(false, "Invalid size");
+	return 0;
+}
+
+const unsigned int cmpxchg_iter_outer = 100, cmpxchg_iter_inner = 10000;
+
+static void guest_cmpxchg_key(void)
+{
+	int size, offset;
+	__uint128_t old, new;
+
+	set_storage_key_range(mem1, max_block, 0x10);
+	set_storage_key_range(mem2, max_block, 0x10);
+	GUEST_SYNC(STAGE_SKEYS_SET);
+
+	for (int i = 0; i < cmpxchg_iter_outer; i++) {
+		do {
+			old = 1;
+		} while (!_cmpxchg(16, mem1, &old, 0));
+		for (int j = 0; j < cmpxchg_iter_inner; j++) {
+			choose_block(true, i + j, &size, &offset);
+			do {
+				new = permutate_bits(true, i + j, size, old);
+			} while (!_cmpxchg(size, mem2 + offset, &old, new));
+		}
+	}
+
+	GUEST_SYNC(STAGE_DONE);
+}
+
+static void *run_guest(void *data)
+{
+	struct test_info *info = data;
+
+	HOST_SYNC(*info, STAGE_DONE);
+	return NULL;
+}
+
+static char *quad_to_char(__uint128_t *quad, int size)
+{
+	return ((char *)quad) + (sizeof(*quad) - size);
+}
+
+static void test_cmpxchg_key_concurrent(void)
+{
+	struct test_default t = test_default_init(guest_cmpxchg_key);
+	int size, offset;
+	__uint128_t old, new;
+	bool success;
+	pthread_t thread;
+
+	HOST_SYNC(t.vcpu, STAGE_SKEYS_SET);
+	prepare_mem12();
+	MOP(t.vcpu, LOGICAL, WRITE, mem1, max_block, GADDR_V(mem2));
+	pthread_create(&thread, NULL, run_guest, &t.vcpu);
+
+	for (int i = 0; i < cmpxchg_iter_outer; i++) {
+		do {
+			old = 0;
+			new = 1;
+			MOP(t.vm, ABSOLUTE, CMPXCHG, &new,
+			    sizeof(new), GADDR_V(mem1),
+			    CMPXCHG_OLD(&old),
+			    CMPXCHG_SUCCESS(&success), KEY(1));
+		} while (!success);
+		for (int j = 0; j < cmpxchg_iter_inner; j++) {
+			choose_block(false, i + j, &size, &offset);
+			do {
+				new = permutate_bits(false, i + j, size, old);
+				MOP(t.vm, ABSOLUTE, CMPXCHG, quad_to_char(&new, size),
+				    size, GADDR_V(mem2 + offset),
+				    CMPXCHG_OLD(quad_to_char(&old, size)),
+				    CMPXCHG_SUCCESS(&success), KEY(1));
+			} while (!success);
+		}
+	}
+
+	pthread_join(thread, NULL);
+
+	MOP(t.vcpu, LOGICAL, READ, mem2, max_block, GADDR_V(mem2));
+	TEST_ASSERT(popcount_eq(*(__uint128_t *)mem1, *(__uint128_t *)mem2),
+		    "Must retain number of set bits");
+
+	kvm_vm_free(t.kvm_vm);
+}
+
 static void guest_copy_key_fetch_prot(void)
 {
 	/*
@@ -457,6 +764,24 @@ static void test_errors_key(void)
 	kvm_vm_free(t.kvm_vm);
 }
 
+static void test_errors_cmpxchg_key(void)
+{
+	struct test_default t = test_default_init(guest_copy_key_fetch_prot);
+	int i;
+
+	HOST_SYNC(t.vcpu, STAGE_INITED);
+	HOST_SYNC(t.vcpu, STAGE_SKEYS_SET);
+
+	for (i = 1; i <= 16; i *= 2) {
+		__uint128_t old = 0;
+
+		ERR_PROT_MOP(t.vm, ABSOLUTE, CMPXCHG, mem2, i, GADDR_V(mem2),
+			     CMPXCHG_OLD(&old), KEY(2));
+	}
+
+	kvm_vm_free(t.kvm_vm);
+}
+
 static void test_termination(void)
 {
 	struct test_default t = test_default_init(guest_error_key);
@@ -692,6 +1017,38 @@ static void test_errors(void)
 	kvm_vm_free(t.kvm_vm);
 }
 
+static void test_errors_cmpxchg(void)
+{
+	struct test_default t = test_default_init(guest_idle);
+	__uint128_t old;
+	int rv, i, power = 1;
+
+	HOST_SYNC(t.vcpu, STAGE_INITED);
+
+	for (i = 0; i < 32; i++) {
+		if (i == power) {
+			power *= 2;
+			continue;
+		}
+		rv = ERR_MOP(t.vm, ABSOLUTE, CMPXCHG, mem1, i, GADDR_V(mem1),
+			     CMPXCHG_OLD(&old));
+		TEST_ASSERT(rv == -1 && errno == EINVAL,
+			    "ioctl allows bad size for cmpxchg");
+	}
+	for (i = 1; i <= 16; i *= 2) {
+		rv = ERR_MOP(t.vm, ABSOLUTE, CMPXCHG, mem1, i, GADDR((void *)~0xfffUL),
+			     CMPXCHG_OLD(&old));
+		TEST_ASSERT(rv > 0, "ioctl allows bad guest address for cmpxchg");
+	}
+	for (i = 2; i <= 16; i *= 2) {
+		rv = ERR_MOP(t.vm, ABSOLUTE, CMPXCHG, mem1, i, GADDR_V(mem1 + 1),
+			     CMPXCHG_OLD(&old));
+		TEST_ASSERT(rv == -1 && errno == EINVAL,
+			    "ioctl allows bad alignment for cmpxchg");
+	}
+
+	kvm_vm_free(t.kvm_vm);
+}
 
 int main(int argc, char *argv[])
 {
@@ -720,6 +1077,16 @@ int main(int argc, char *argv[])
 			.test = test_copy_key,
 			.requirements_met = extension_cap > 0,
 		},
+		{
+			.name = "cmpxchg with storage keys",
+			.test = test_cmpxchg_key,
+			.requirements_met = extension_cap & 0x2,
+		},
+		{
+			.name = "concurrently cmpxchg with storage keys",
+			.test = test_cmpxchg_key_concurrent,
+			.requirements_met = extension_cap & 0x2,
+		},
 		{
 			.name = "copy with key storage protection override",
 			.test = test_copy_key_storage_prot_override,
@@ -740,6 +1107,16 @@ int main(int argc, char *argv[])
 			.test = test_errors_key,
 			.requirements_met = extension_cap > 0,
 		},
+		{
+			.name = "error checks for cmpxchg with key",
+			.test = test_errors_cmpxchg_key,
+			.requirements_met = extension_cap & 0x2,
+		},
+		{
+			.name = "error checks for cmpxchg",
+			.test = test_errors_cmpxchg,
+			.requirements_met = extension_cap & 0x2,
+		},
 		{
 			.name = "termination",
 			.test = test_termination,
-- 
2.39.1

