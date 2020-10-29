Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE2D29F603
	for <lists+kvm@lfdr.de>; Thu, 29 Oct 2020 21:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgJ2URf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 16:17:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46916 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726575AbgJ2URe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Oct 2020 16:17:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604002651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/dY+ItMrgLUkWxvnZwxxGu3YGowRmlRDtj7w4B2RoBg=;
        b=hzWq2sbAsqz9E+suGPD5ADUdNnrgsGIEJlBRsuPub3I8VX6LbcEcCQjRVOL2XarxoKRqrP
        UEK8Jnl65xDmtYZGsPapGJnXbwBt8CmsTi3YKtjgyb+fc11mL3eynzT4khVMAu//115X/u
        LqZOKeyibCqtkHJAm1w0qM6STM6LYfI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-50-X6MDt82jOR6D_Gkebw8SXA-1; Thu, 29 Oct 2020 16:17:22 -0400
X-MC-Unique: X6MDt82jOR6D_Gkebw8SXA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD3611074643;
        Thu, 29 Oct 2020 20:17:20 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B51FB60DA0;
        Thu, 29 Oct 2020 20:17:18 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, Dave.Martin@arm.com,
        peter.maydell@linaro.org, eric.auger@redhat.com
Subject: [PATCH 4/4] KVM: selftests: Add blessed SVE registers to get-reg-list
Date:   Thu, 29 Oct 2020 21:17:03 +0100
Message-Id: <20201029201703.102716-5-drjones@redhat.com>
In-Reply-To: <20201029201703.102716-1-drjones@redhat.com>
References: <20201029201703.102716-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for the SVE registers to get-reg-list and create a
new test, get-reg-list-sve, which tests them when running on a
machine with SVE support.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/get-reg-list-sve.c  |   3 +
 .../selftests/kvm/aarch64/get-reg-list.c      | 254 +++++++++++++++---
 4 files changed, 217 insertions(+), 42 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/aarch64/get-reg-list-sve.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index d1c82ab8d131..3af38b20d0ee 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 /aarch64/get-reg-list
+/aarch64/get-reg-list-sve
 /s390x/memop
 /s390x/resets
 /s390x/sync_regs_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 64a76f4ef8ba..5f222fd07dea 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -65,6 +65,7 @@ TEST_GEN_PROGS_x86_64 += set_memory_region_test
 TEST_GEN_PROGS_x86_64 += steal_time
 
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
+TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list-sve
 TEST_GEN_PROGS_aarch64 += clear_dirty_log_test
 TEST_GEN_PROGS_aarch64 += demand_paging_test
 TEST_GEN_PROGS_aarch64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list-sve.c b/tools/testing/selftests/kvm/aarch64/get-reg-list-sve.c
new file mode 100644
index 000000000000..efba76682b4b
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list-sve.c
@@ -0,0 +1,3 @@
+// SPDX-License-Identifier: GPL-2.0
+#define REG_LIST_SVE
+#include "get-reg-list.c"
diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index 3ff097f6886e..33218a395d9f 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -29,6 +29,13 @@
 #include <string.h>
 #include "kvm_util.h"
 #include "test_util.h"
+#include "processor.h"
+
+#ifdef REG_LIST_SVE
+#define reg_list_sve() (true)
+#else
+#define reg_list_sve() (false)
+#endif
 
 #define REG_MASK (KVM_REG_ARCH_MASK | KVM_REG_SIZE_MASK | KVM_REG_ARM_COPROC_MASK)
 
@@ -46,8 +53,9 @@
 
 static struct kvm_reg_list *reg_list;
 
-static __u64 blessed_reg[];
-static __u64 blessed_n;
+static __u64 base_regs[], vregs[], sve_regs[], rejects_set[];
+static __u64 base_regs_n, vregs_n, sve_regs_n, rejects_set_n;
+static __u64 *blessed_reg, blessed_n;
 
 static bool find_reg(__u64 regs[], __u64 nr_regs, __u64 reg)
 {
@@ -119,6 +127,40 @@ static const char *core_id_to_str(__u64 id)
 	return NULL;
 }
 
+static const char *sve_id_to_str(__u64 id)
+{
+	__u64 sve_off, n, i;
+
+	if (id == KVM_REG_ARM64_SVE_VLS)
+		return "KVM_REG_ARM64_SVE_VLS";
+
+	sve_off = id & ~(REG_MASK | ((1ULL << 5) - 1));
+	i = id & (KVM_ARM64_SVE_MAX_SLICES - 1);
+
+	TEST_ASSERT(i == 0, "Currently we don't expect slice > 0, reg id 0x%llx", id);
+
+	switch (sve_off) {
+	case KVM_REG_ARM64_SVE_ZREG_BASE ...
+	     KVM_REG_ARM64_SVE_ZREG_BASE + (1ULL << 5) * KVM_ARM64_SVE_NUM_ZREGS - 1:
+		n = (id >> 5) & (KVM_ARM64_SVE_NUM_ZREGS - 1);
+		TEST_ASSERT(id == KVM_REG_ARM64_SVE_ZREG(n, 0),
+			    "Unexpected bits set in SVE ZREG id: 0x%llx", id);
+		return str_with_index("KVM_REG_ARM64_SVE_ZREG(##, 0)", n);
+	case KVM_REG_ARM64_SVE_PREG_BASE ...
+	     KVM_REG_ARM64_SVE_PREG_BASE + (1ULL << 5) * KVM_ARM64_SVE_NUM_PREGS - 1:
+		n = (id >> 5) & (KVM_ARM64_SVE_NUM_PREGS - 1);
+		TEST_ASSERT(id == KVM_REG_ARM64_SVE_PREG(n, 0),
+			    "Unexpected bits set in SVE PREG id: 0x%llx", id);
+		return str_with_index("KVM_REG_ARM64_SVE_PREG(##, 0)", n);
+	case KVM_REG_ARM64_SVE_FFR_BASE:
+		TEST_ASSERT(id == KVM_REG_ARM64_SVE_FFR(0),
+			    "Unexpected bits set in SVE FFR id: 0x%llx", id);
+		return "KVM_REG_ARM64_SVE_FFR(0)";
+	}
+
+	return NULL;
+}
+
 static void print_reg(__u64 id)
 {
 	unsigned op0, op1, crn, crm, op2;
@@ -186,7 +228,10 @@ static void print_reg(__u64 id)
 		printf("\tKVM_REG_ARM_FW_REG(%lld),\n", id & 0xffff);
 		break;
 	case KVM_REG_ARM64_SVE:
-		TEST_FAIL("KVM_REG_ARM64_SVE is an unexpected coproc type in reg id: 0x%llx", id);
+		if (reg_list_sve())
+			printf("\t%s,\n", sve_id_to_str(id));
+		else
+			TEST_FAIL("KVM_REG_ARM64_SVE is an unexpected coproc type in reg id: 0x%llx", id);
 		break;
 	default:
 		TEST_FAIL("Unexpected coproc type: 0x%llx in reg id: 0x%llx",
@@ -251,12 +296,40 @@ static void core_reg_fixup(void)
 	reg_list = tmp;
 }
 
+static void prepare_vcpu_init(struct kvm_vcpu_init *init)
+{
+	if (reg_list_sve())
+		init->features[0] |= 1 << KVM_ARM_VCPU_SVE;
+}
+
+static void finalize_vcpu(struct kvm_vm *vm, uint32_t vcpuid)
+{
+	int feature;
+
+	if (reg_list_sve()) {
+		feature = KVM_ARM_VCPU_SVE;
+		vcpu_ioctl(vm, vcpuid, KVM_ARM_VCPU_FINALIZE, &feature);
+	}
+}
+
+static void check_supported(void)
+{
+	if (reg_list_sve() && !kvm_check_cap(KVM_CAP_ARM_SVE)) {
+		fprintf(stderr, "SVE not available, skipping tests\n");
+		exit(KSFT_SKIP);
+	}
+}
+
 int main(int ac, char **av)
 {
+	struct kvm_vcpu_init init = { .target = -1, };
 	int new_regs = 0, missing_regs = 0, i;
-	int failed_get = 0, failed_set = 0;
+	int failed_get = 0, failed_set = 0, failed_reject = 0;
 	bool print_list = false, fixup_core_regs = false;
 	struct kvm_vm *vm;
+	__u64 *vec_regs;
+
+	check_supported();
 
 	for (i = 1; i < ac; ++i) {
 		if (strcmp(av[i], "--core-reg-fixup") == 0)
@@ -267,7 +340,11 @@ int main(int ac, char **av)
 			fprintf(stderr, "Ignoring unknown option: %s\n", av[i]);
 	}
 
-	vm = vm_create_default(0, 0, NULL);
+	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
+	prepare_vcpu_init(&init);
+	aarch64_vcpu_add_default(vm, 0, &init, NULL);
+	finalize_vcpu(vm, 0);
+
 	reg_list = vcpu_get_reg_list(vm, 0);
 
 	if (fixup_core_regs)
@@ -307,6 +384,18 @@ int main(int ac, char **av)
 			++failed_get;
 		}
 
+		/* rejects_set registers are rejected after KVM_ARM_VCPU_FINALIZE */
+		if (find_reg(rejects_set, rejects_set_n, reg.id)) {
+			ret = _vcpu_ioctl(vm, 0, KVM_SET_ONE_REG, &reg);
+			if (ret != -1 || errno != EPERM) {
+				printf("Failed to reject (ret=%d, errno=%d) ", ret, errno);
+				print_reg(reg.id);
+				putchar('\n');
+				++failed_reject;
+			}
+			continue;
+		}
+
 		ret = _vcpu_ioctl(vm, 0, KVM_SET_ONE_REG, &reg);
 		if (ret) {
 			puts("Failed to set ");
@@ -316,6 +405,20 @@ int main(int ac, char **av)
 		}
 	}
 
+	if (reg_list_sve()) {
+		blessed_n = base_regs_n + sve_regs_n;
+		vec_regs = sve_regs;
+	} else {
+		blessed_n = base_regs_n + vregs_n;
+		vec_regs = vregs;
+	}
+
+	blessed_reg = calloc(blessed_n, sizeof(__u64));
+	for (i = 0; i < base_regs_n; ++i)
+		blessed_reg[i] = base_regs[i];
+	for (i = 0; i < blessed_n - base_regs_n; ++i)
+		blessed_reg[base_regs_n + i] = vec_regs[i];
+
 	for_each_new_reg(i)
 		++new_regs;
 
@@ -344,9 +447,10 @@ int main(int ac, char **av)
 		putchar('\n');
 	}
 
-	TEST_ASSERT(!missing_regs && !failed_get && !failed_set,
-		    "There are %d missing registers; %d registers failed get; %d registers failed set",
-		    missing_regs, failed_get, failed_set);
+	TEST_ASSERT(!missing_regs && !failed_get && !failed_set && !failed_reject,
+		    "There are %d missing registers; "
+		    "%d registers failed get; %d registers failed set; %d registers failed reject",
+		    missing_regs, failed_get, failed_set, failed_reject);
 
 	return 0;
 }
@@ -355,7 +459,7 @@ int main(int ac, char **av)
  * The current blessed list was primed with the output of kernel version
  * v4.15 with --core-reg-fixup and then later updated with new registers.
  */
-static __u64 blessed_reg[] = {
+static __u64 base_regs[] = {
 	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[0]),
 	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[1]),
 	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[2]),
@@ -397,38 +501,6 @@ static __u64 blessed_reg[] = {
 	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(spsr[2]),
 	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(spsr[3]),
 	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(spsr[4]),
-	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[0]),
-	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[1]),
-	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[2]),
-	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[3]),
-	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[4]),
-	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[5]),
-	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[6]),
-	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[7]),
-	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[8]),
-	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[9]),
-	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[10]),
-	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[11]),
-	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[12]),
-	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[13]),
-	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[14]),
-	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[15]),
-	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[16]),
-	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[17]),
-	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[18]),
-	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[19]),
-	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[20]),
-	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[21]),
-	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[22]),
-	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[23]),
-	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[24]),
-	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[25]),
-	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[26]),
-	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[27]),
-	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[28]),
-	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[29]),
-	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[30]),
-	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[31]),
 	KVM_REG_ARM64 | KVM_REG_SIZE_U32 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.fpsr),
 	KVM_REG_ARM64 | KVM_REG_SIZE_U32 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.fpcr),
 	KVM_REG_ARM_FW_REG(0),
@@ -668,4 +740,102 @@ static __u64 blessed_reg[] = {
 	KVM_REG_ARM64 | KVM_REG_SIZE_U32 | KVM_REG_ARM_DEMUX | KVM_REG_ARM_DEMUX_ID_CCSIDR | 1,
 	KVM_REG_ARM64 | KVM_REG_SIZE_U32 | KVM_REG_ARM_DEMUX | KVM_REG_ARM_DEMUX_ID_CCSIDR | 2,
 };
-static __u64 blessed_n = ARRAY_SIZE(blessed_reg);
+static __u64 base_regs_n = ARRAY_SIZE(base_regs);
+
+static __u64 vregs[] = {
+	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[0]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[1]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[2]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[3]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[4]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[5]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[6]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[7]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[8]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[9]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[10]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[11]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[12]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[13]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[14]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[15]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[16]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[17]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[18]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[19]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[20]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[21]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[22]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[23]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[24]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[25]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[26]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[27]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[28]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[29]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[30]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[31]),
+};
+static __u64 vregs_n = ARRAY_SIZE(vregs);
+
+static __u64 sve_regs[] = {
+	KVM_REG_ARM64_SVE_VLS,
+	KVM_REG_ARM64_SVE_ZREG(0, 0),
+	KVM_REG_ARM64_SVE_ZREG(1, 0),
+	KVM_REG_ARM64_SVE_ZREG(2, 0),
+	KVM_REG_ARM64_SVE_ZREG(3, 0),
+	KVM_REG_ARM64_SVE_ZREG(4, 0),
+	KVM_REG_ARM64_SVE_ZREG(5, 0),
+	KVM_REG_ARM64_SVE_ZREG(6, 0),
+	KVM_REG_ARM64_SVE_ZREG(7, 0),
+	KVM_REG_ARM64_SVE_ZREG(8, 0),
+	KVM_REG_ARM64_SVE_ZREG(9, 0),
+	KVM_REG_ARM64_SVE_ZREG(10, 0),
+	KVM_REG_ARM64_SVE_ZREG(11, 0),
+	KVM_REG_ARM64_SVE_ZREG(12, 0),
+	KVM_REG_ARM64_SVE_ZREG(13, 0),
+	KVM_REG_ARM64_SVE_ZREG(14, 0),
+	KVM_REG_ARM64_SVE_ZREG(15, 0),
+	KVM_REG_ARM64_SVE_ZREG(16, 0),
+	KVM_REG_ARM64_SVE_ZREG(17, 0),
+	KVM_REG_ARM64_SVE_ZREG(18, 0),
+	KVM_REG_ARM64_SVE_ZREG(19, 0),
+	KVM_REG_ARM64_SVE_ZREG(20, 0),
+	KVM_REG_ARM64_SVE_ZREG(21, 0),
+	KVM_REG_ARM64_SVE_ZREG(22, 0),
+	KVM_REG_ARM64_SVE_ZREG(23, 0),
+	KVM_REG_ARM64_SVE_ZREG(24, 0),
+	KVM_REG_ARM64_SVE_ZREG(25, 0),
+	KVM_REG_ARM64_SVE_ZREG(26, 0),
+	KVM_REG_ARM64_SVE_ZREG(27, 0),
+	KVM_REG_ARM64_SVE_ZREG(28, 0),
+	KVM_REG_ARM64_SVE_ZREG(29, 0),
+	KVM_REG_ARM64_SVE_ZREG(30, 0),
+	KVM_REG_ARM64_SVE_ZREG(31, 0),
+	KVM_REG_ARM64_SVE_PREG(0, 0),
+	KVM_REG_ARM64_SVE_PREG(1, 0),
+	KVM_REG_ARM64_SVE_PREG(2, 0),
+	KVM_REG_ARM64_SVE_PREG(3, 0),
+	KVM_REG_ARM64_SVE_PREG(4, 0),
+	KVM_REG_ARM64_SVE_PREG(5, 0),
+	KVM_REG_ARM64_SVE_PREG(6, 0),
+	KVM_REG_ARM64_SVE_PREG(7, 0),
+	KVM_REG_ARM64_SVE_PREG(8, 0),
+	KVM_REG_ARM64_SVE_PREG(9, 0),
+	KVM_REG_ARM64_SVE_PREG(10, 0),
+	KVM_REG_ARM64_SVE_PREG(11, 0),
+	KVM_REG_ARM64_SVE_PREG(12, 0),
+	KVM_REG_ARM64_SVE_PREG(13, 0),
+	KVM_REG_ARM64_SVE_PREG(14, 0),
+	KVM_REG_ARM64_SVE_PREG(15, 0),
+	KVM_REG_ARM64_SVE_FFR(0),
+	ARM64_SYS_REG(3, 0, 1, 2, 0),   /* ZCR_EL1 */
+};
+static __u64 sve_regs_n = ARRAY_SIZE(sve_regs);
+
+static __u64 rejects_set[] = {
+#ifdef REG_LIST_SVE
+	KVM_REG_ARM64_SVE_VLS,
+#endif
+};
+static __u64 rejects_set_n = ARRAY_SIZE(rejects_set);
-- 
2.27.0

