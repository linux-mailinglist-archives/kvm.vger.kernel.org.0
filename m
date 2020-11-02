Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7282A338D
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 20:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbgKBTDe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 14:03:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42768 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726189AbgKBTDe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Nov 2020 14:03:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604343809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tLi0mkmyL37d/Hqs0YLzICtRdg2xi0vohTWYYe1nieE=;
        b=G1gSgURUmaqgCCu2L+NGjWXpUv2XnZmdl3Q/E4EOegbsvLiqaeI/lnuwyncyDrSousv6zq
        6FgL/lCUfZXMyZbWaELL79SkMBFogvLodUojJqSX6UX1/HhH2yt6CwBaBYPxFuswHgFXRC
        YoJYfTCESIWOV5I58yYl17yp2gONBzY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-iM2dGjNrNg2KSAvuRfE5Fg-1; Mon, 02 Nov 2020 14:03:13 -0500
X-MC-Unique: iM2dGjNrNg2KSAvuRfE5Fg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 210766D240;
        Mon,  2 Nov 2020 19:03:12 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DEC665B4D7;
        Mon,  2 Nov 2020 19:03:03 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org, Dave.Martin@arm.com,
        peter.maydell@linaro.org, eric.auger@redhat.com
Subject: [PATCH v2 1/3] KVM: selftests: Add aarch64 get-reg-list test
Date:   Mon,  2 Nov 2020 20:02:51 +0100
Message-Id: <20201102190253.50575-2-drjones@redhat.com>
In-Reply-To: <20201102190253.50575-1-drjones@redhat.com>
References: <20201102190253.50575-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check for KVM_GET_REG_LIST regressions. The blessed list was
created by running on v4.15 with the --core-reg-fixup option.
The following script was also used in order to annotate system
registers with their names when possible. When new system
registers are added the names can just be added manually using
the same grep.

while read reg; do
	if [[ ! $reg =~ ARM64_SYS_REG ]]; then
		printf "\t$reg\n"
		continue
	fi
	encoding=$(echo "$reg" | sed "s/ARM64_SYS_REG(//;s/),//")
	if ! name=$(grep "$encoding" ../../../../arch/arm64/include/asm/sysreg.h); then
		printf "\t$reg\n"
		continue
	fi
	name=$(echo "$name" | sed "s/.*SYS_//;s/[\t ]*sys_reg($encoding)$//")
	printf "\t$reg\t/* $name */\n"
done < <(aarch64/get-reg-list --core-reg-fixup --list)

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/get-reg-list.c      | 665 ++++++++++++++++++
 .../testing/selftests/kvm/include/kvm_util.h  |   1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  29 +
 5 files changed, 697 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/get-reg-list.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index d2c2d6205008..b2fc44bf8c3c 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
+/aarch64/get-reg-list
 /s390x/memop
 /s390x/resets
 /s390x/sync_regs_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 30afbad36cd5..54c931e70089 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -65,6 +65,7 @@ TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
 TEST_GEN_PROGS_x86_64 += set_memory_region_test
 TEST_GEN_PROGS_x86_64 += steal_time
 
+TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
 TEST_GEN_PROGS_aarch64 += clear_dirty_log_test
 TEST_GEN_PROGS_aarch64 += demand_paging_test
 TEST_GEN_PROGS_aarch64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
new file mode 100644
index 000000000000..6fae4c3cb0c6
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -0,0 +1,665 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Check for KVM_GET_REG_LIST regressions.
+ *
+ * Copyright (C) 2020, Red Hat, Inc.
+ *
+ * When attempting to migrate from a host with an older kernel to a host
+ * with a newer kernel we allow the newer kernel on the destination to
+ * list new registers with get-reg-list. We assume they'll be unused, at
+ * least until the guest reboots, and so they're relatively harmless.
+ * However, if the destination host with the newer kernel is missing
+ * registers which the source host with the older kernel has, then that's
+ * a regression in get-reg-list. This test checks for that regression by
+ * checking the current list against a blessed list. We should never have
+ * missing registers, but if new ones appear then they can probably be
+ * added to the blessed list. A completely new blessed list can be created
+ * by running the test with the --list command line argument.
+ *
+ * Note, the blessed list should be created from the oldest possible
+ * kernel. We can't go older than v4.15, though, because that's the first
+ * release to expose the ID system registers in KVM_GET_REG_LIST, see
+ * commit 93390c0a1b20 ("arm64: KVM: Hide unsupported AArch64 CPU features
+ * from guests"). Also, one must use the --core-reg-fixup command line
+ * option when running on an older kernel that doesn't include df205b5c6328
+ * ("KVM: arm64: Filter out invalid core register IDs in KVM_GET_REG_LIST")
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include "kvm_util.h"
+#include "test_util.h"
+
+#define REG_MASK (KVM_REG_ARCH_MASK | KVM_REG_SIZE_MASK | KVM_REG_ARM_COPROC_MASK)
+
+#define for_each_reg(i)								\
+	for ((i) = 0; (i) < reg_list->n; ++(i))
+
+#define for_each_missing_reg(i)							\
+	for ((i) = 0; (i) < blessed_n; ++(i))					\
+		if (!find_reg(reg_list->reg, reg_list->n, blessed_reg[i]))
+
+#define for_each_new_reg(i)							\
+	for ((i) = 0; (i) < reg_list->n; ++(i))					\
+		if (!find_reg(blessed_reg, blessed_n, reg_list->reg[i]))
+
+
+static struct kvm_reg_list *reg_list;
+
+static __u64 blessed_reg[];
+static __u64 blessed_n;
+
+static bool find_reg(__u64 regs[], __u64 nr_regs, __u64 reg)
+{
+	int i;
+
+	for (i = 0; i < nr_regs; ++i)
+		if (reg == regs[i])
+			return true;
+	return false;
+}
+
+static const char *str_with_index(const char *template, __u64 index)
+{
+	char *str, *p;
+	int n;
+
+	str = strdup(template);
+	p = strstr(str, "##");
+	n = sprintf(p, "%lld", index);
+	strcat(p + n, strstr(template, "##") + 2);
+
+	return (const char *)str;
+}
+
+#define CORE_REGS_XX_NR_WORDS	2
+#define CORE_SPSR_XX_NR_WORDS	2
+#define CORE_FPREGS_XX_NR_WORDS	4
+
+static const char *core_id_to_str(__u64 id)
+{
+	__u64 core_off = id & ~REG_MASK, idx;
+
+	/*
+	 * core_off is the offset into struct kvm_regs
+	 */
+	switch (core_off) {
+	case KVM_REG_ARM_CORE_REG(regs.regs[0]) ...
+	     KVM_REG_ARM_CORE_REG(regs.regs[30]):
+		idx = (core_off - KVM_REG_ARM_CORE_REG(regs.regs[0])) / CORE_REGS_XX_NR_WORDS;
+		TEST_ASSERT(idx < 31, "Unexpected regs.regs index: %lld", idx);
+		return str_with_index("KVM_REG_ARM_CORE_REG(regs.regs[##])", idx);
+	case KVM_REG_ARM_CORE_REG(regs.sp):
+		return "KVM_REG_ARM_CORE_REG(regs.sp)";
+	case KVM_REG_ARM_CORE_REG(regs.pc):
+		return "KVM_REG_ARM_CORE_REG(regs.pc)";
+	case KVM_REG_ARM_CORE_REG(regs.pstate):
+		return "KVM_REG_ARM_CORE_REG(regs.pstate)";
+	case KVM_REG_ARM_CORE_REG(sp_el1):
+		return "KVM_REG_ARM_CORE_REG(sp_el1)";
+	case KVM_REG_ARM_CORE_REG(elr_el1):
+		return "KVM_REG_ARM_CORE_REG(elr_el1)";
+	case KVM_REG_ARM_CORE_REG(spsr[0]) ...
+	     KVM_REG_ARM_CORE_REG(spsr[KVM_NR_SPSR - 1]):
+		idx = (core_off - KVM_REG_ARM_CORE_REG(spsr[0])) / CORE_SPSR_XX_NR_WORDS;
+		TEST_ASSERT(idx < KVM_NR_SPSR, "Unexpected spsr index: %lld", idx);
+		return str_with_index("KVM_REG_ARM_CORE_REG(spsr[##])", idx);
+	case KVM_REG_ARM_CORE_REG(fp_regs.vregs[0]) ...
+	     KVM_REG_ARM_CORE_REG(fp_regs.vregs[31]):
+		idx = (core_off - KVM_REG_ARM_CORE_REG(fp_regs.vregs[0])) / CORE_FPREGS_XX_NR_WORDS;
+		TEST_ASSERT(idx < 32, "Unexpected fp_regs.vregs index: %lld", idx);
+		return str_with_index("KVM_REG_ARM_CORE_REG(fp_regs.vregs[##])", idx);
+	case KVM_REG_ARM_CORE_REG(fp_regs.fpsr):
+		return "KVM_REG_ARM_CORE_REG(fp_regs.fpsr)";
+	case KVM_REG_ARM_CORE_REG(fp_regs.fpcr):
+		return "KVM_REG_ARM_CORE_REG(fp_regs.fpcr)";
+	}
+
+	TEST_FAIL("Unknown core reg id: 0x%llx", id);
+	return NULL;
+}
+
+static void print_reg(__u64 id)
+{
+	unsigned op0, op1, crn, crm, op2;
+	const char *reg_size = NULL;
+
+	TEST_ASSERT((id & KVM_REG_ARCH_MASK) == KVM_REG_ARM64,
+		    "KVM_REG_ARM64 missing in reg id: 0x%llx", id);
+
+	switch (id & KVM_REG_SIZE_MASK) {
+	case KVM_REG_SIZE_U8:
+		reg_size = "KVM_REG_SIZE_U8";
+		break;
+	case KVM_REG_SIZE_U16:
+		reg_size = "KVM_REG_SIZE_U16";
+		break;
+	case KVM_REG_SIZE_U32:
+		reg_size = "KVM_REG_SIZE_U32";
+		break;
+	case KVM_REG_SIZE_U64:
+		reg_size = "KVM_REG_SIZE_U64";
+		break;
+	case KVM_REG_SIZE_U128:
+		reg_size = "KVM_REG_SIZE_U128";
+		break;
+	case KVM_REG_SIZE_U256:
+		reg_size = "KVM_REG_SIZE_U256";
+		break;
+	case KVM_REG_SIZE_U512:
+		reg_size = "KVM_REG_SIZE_U512";
+		break;
+	case KVM_REG_SIZE_U1024:
+		reg_size = "KVM_REG_SIZE_U1024";
+		break;
+	case KVM_REG_SIZE_U2048:
+		reg_size = "KVM_REG_SIZE_U2048";
+		break;
+	default:
+		TEST_FAIL("Unexpected reg size: 0x%llx in reg id: 0x%llx",
+			  (id & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT, id);
+	}
+
+	switch (id & KVM_REG_ARM_COPROC_MASK) {
+	case KVM_REG_ARM_CORE:
+		printf("\tKVM_REG_ARM64 | %s | KVM_REG_ARM_CORE | %s,\n", reg_size, core_id_to_str(id));
+		break;
+	case KVM_REG_ARM_DEMUX:
+		TEST_ASSERT(!(id & ~(REG_MASK | KVM_REG_ARM_DEMUX_ID_MASK | KVM_REG_ARM_DEMUX_VAL_MASK)),
+			    "Unexpected bits set in DEMUX reg id: 0x%llx", id);
+		printf("\tKVM_REG_ARM64 | %s | KVM_REG_ARM_DEMUX | KVM_REG_ARM_DEMUX_ID_CCSIDR | %lld,\n",
+		       reg_size, id & KVM_REG_ARM_DEMUX_VAL_MASK);
+		break;
+	case KVM_REG_ARM64_SYSREG:
+		op0 = (id & KVM_REG_ARM64_SYSREG_OP0_MASK) >> KVM_REG_ARM64_SYSREG_OP0_SHIFT;
+		op1 = (id & KVM_REG_ARM64_SYSREG_OP1_MASK) >> KVM_REG_ARM64_SYSREG_OP1_SHIFT;
+		crn = (id & KVM_REG_ARM64_SYSREG_CRN_MASK) >> KVM_REG_ARM64_SYSREG_CRN_SHIFT;
+		crm = (id & KVM_REG_ARM64_SYSREG_CRM_MASK) >> KVM_REG_ARM64_SYSREG_CRM_SHIFT;
+		op2 = (id & KVM_REG_ARM64_SYSREG_OP2_MASK) >> KVM_REG_ARM64_SYSREG_OP2_SHIFT;
+		TEST_ASSERT(id == ARM64_SYS_REG(op0, op1, crn, crm, op2),
+			    "Unexpected bits set in SYSREG reg id: 0x%llx", id);
+		printf("\tARM64_SYS_REG(%d, %d, %d, %d, %d),\n", op0, op1, crn, crm, op2);
+		break;
+	case KVM_REG_ARM_FW:
+		TEST_ASSERT(id == KVM_REG_ARM_FW_REG(id & 0xffff),
+			    "Unexpected bits set in FW reg id: 0x%llx", id);
+		printf("\tKVM_REG_ARM_FW_REG(%lld),\n", id & 0xffff);
+		break;
+	case KVM_REG_ARM64_SVE:
+		TEST_FAIL("KVM_REG_ARM64_SVE is an unexpected coproc type in reg id: 0x%llx", id);
+		break;
+	default:
+		TEST_FAIL("Unexpected coproc type: 0x%llx in reg id: 0x%llx",
+			  (id & KVM_REG_ARM_COPROC_MASK) >> KVM_REG_ARM_COPROC_SHIFT, id);
+	}
+}
+
+/*
+ * Older kernels listed each 32-bit word of CORE registers separately.
+ * For 64 and 128-bit registers we need to ignore the extra words. We
+ * also need to fixup the sizes, because the older kernels stated all
+ * registers were 64-bit, even when they weren't.
+ */
+static void core_reg_fixup(void)
+{
+	struct kvm_reg_list *tmp;
+	__u64 id, core_off;
+	int i;
+
+	tmp = calloc(1, sizeof(*tmp) + reg_list->n * sizeof(__u64));
+
+	for (i = 0; i < reg_list->n; ++i) {
+		id = reg_list->reg[i];
+
+		if ((id & KVM_REG_ARM_COPROC_MASK) != KVM_REG_ARM_CORE) {
+			tmp->reg[tmp->n++] = id;
+			continue;
+		}
+
+		core_off = id & ~REG_MASK;
+
+		switch (core_off) {
+		case 0x52: case 0xd2: case 0xd6:
+			/*
+			 * These offsets are pointing at padding.
+			 * We need to ignore them too.
+			 */
+			continue;
+		case KVM_REG_ARM_CORE_REG(fp_regs.vregs[0]) ...
+		     KVM_REG_ARM_CORE_REG(fp_regs.vregs[31]):
+			if (core_off & 3)
+				continue;
+			id &= ~KVM_REG_SIZE_MASK;
+			id |= KVM_REG_SIZE_U128;
+			tmp->reg[tmp->n++] = id;
+			continue;
+		case KVM_REG_ARM_CORE_REG(fp_regs.fpsr):
+		case KVM_REG_ARM_CORE_REG(fp_regs.fpcr):
+			id &= ~KVM_REG_SIZE_MASK;
+			id |= KVM_REG_SIZE_U32;
+			tmp->reg[tmp->n++] = id;
+			continue;
+		default:
+			if (core_off & 1)
+				continue;
+			tmp->reg[tmp->n++] = id;
+			break;
+		}
+	}
+
+	free(reg_list);
+	reg_list = tmp;
+}
+
+int main(int ac, char **av)
+{
+	int new_regs = 0, missing_regs = 0, i;
+	int failed_get = 0, failed_set = 0;
+	bool print_list = false, fixup_core_regs = false;
+	struct kvm_vm *vm;
+
+	for (i = 1; i < ac; ++i) {
+		if (strcmp(av[i], "--core-reg-fixup") == 0)
+			fixup_core_regs = true;
+		else if (strcmp(av[i], "--list") == 0)
+			print_list = true;
+		else
+			TEST_FAIL("Unknown option: %s\n", av[i]);
+	}
+
+	vm = vm_create_default(0, 0, NULL);
+	reg_list = vcpu_get_reg_list(vm, 0);
+
+	if (fixup_core_regs)
+		core_reg_fixup();
+
+	if (print_list) {
+		putchar('\n');
+		for_each_reg(i)
+			print_reg(reg_list->reg[i]);
+		putchar('\n');
+		return 0;
+	}
+
+	/*
+	 * We only test that we can get the register and then write back the
+	 * same value. Some registers may allow other values to be written
+	 * back, but others only allow some bits to be changed, and at least
+	 * for ID registers set will fail if the value does not exactly match
+	 * what was returned by get. If registers that allow other values to
+	 * be written need to have the other values tested, then we should
+	 * create a new set of tests for those in a new independent test
+	 * executable.
+	 */
+	for_each_reg(i) {
+		uint8_t addr[2048 / 8];
+		struct kvm_one_reg reg = {
+			.id = reg_list->reg[i],
+			.addr = (__u64)&addr,
+		};
+		int ret;
+
+		ret = _vcpu_ioctl(vm, 0, KVM_GET_ONE_REG, &reg);
+		if (ret) {
+			puts("Failed to get ");
+			print_reg(reg.id);
+			putchar('\n');
+			++failed_get;
+		}
+
+		ret = _vcpu_ioctl(vm, 0, KVM_SET_ONE_REG, &reg);
+		if (ret) {
+			puts("Failed to set ");
+			print_reg(reg.id);
+			putchar('\n');
+			++failed_set;
+		}
+	}
+
+	for_each_new_reg(i)
+		++new_regs;
+
+	for_each_missing_reg(i)
+		++missing_regs;
+
+	if (new_regs || missing_regs) {
+		printf("Number blessed registers: %5lld\n", blessed_n);
+		printf("Number registers:         %5lld\n", reg_list->n);
+	}
+
+	if (new_regs) {
+		printf("\nThere are %d new registers.\n"
+		       "Consider adding them to the blessed reg "
+		       "list with the following lines:\n\n", new_regs);
+		for_each_new_reg(i)
+			print_reg(reg_list->reg[i]);
+		putchar('\n');
+	}
+
+	if (missing_regs) {
+		printf("\nThere are %d missing registers.\n"
+		       "The following lines are missing registers:\n\n", missing_regs);
+		for_each_missing_reg(i)
+			print_reg(blessed_reg[i]);
+		putchar('\n');
+	}
+
+	TEST_ASSERT(!missing_regs && !failed_get && !failed_set,
+		    "There are %d missing registers; %d registers failed get; %d registers failed set",
+		    missing_regs, failed_get, failed_set);
+
+	return 0;
+}
+
+/*
+ * The current blessed list comes from kernel version v4.15 with --core-reg-fixup
+ */
+static __u64 blessed_reg[] = {
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[0]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[1]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[2]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[3]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[4]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[5]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[6]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[7]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[8]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[9]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[10]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[11]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[12]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[13]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[14]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[15]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[16]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[17]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[18]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[19]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[20]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[21]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[22]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[23]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[24]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[25]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[26]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[27]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[28]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[29]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[30]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.sp),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.pc),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.pstate),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(sp_el1),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(elr_el1),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(spsr[0]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(spsr[1]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(spsr[2]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(spsr[3]),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(spsr[4]),
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
+	KVM_REG_ARM64 | KVM_REG_SIZE_U32 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.fpsr),
+	KVM_REG_ARM64 | KVM_REG_SIZE_U32 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.fpcr),
+	ARM64_SYS_REG(3, 3, 14, 3, 1),	/* CNTV_CTL_EL0 */
+	ARM64_SYS_REG(3, 3, 14, 3, 2),	/* CNTV_CVAL_EL0 */
+	ARM64_SYS_REG(3, 3, 14, 0, 2),
+	ARM64_SYS_REG(3, 0, 0, 0, 0),	/* MIDR_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 0, 6),	/* REVIDR_EL1 */
+	ARM64_SYS_REG(3, 1, 0, 0, 1),	/* CLIDR_EL1 */
+	ARM64_SYS_REG(3, 1, 0, 0, 7),	/* AIDR_EL1 */
+	ARM64_SYS_REG(3, 3, 0, 0, 1),	/* CTR_EL0 */
+	ARM64_SYS_REG(2, 0, 0, 0, 4),
+	ARM64_SYS_REG(2, 0, 0, 0, 5),
+	ARM64_SYS_REG(2, 0, 0, 0, 6),
+	ARM64_SYS_REG(2, 0, 0, 0, 7),
+	ARM64_SYS_REG(2, 0, 0, 1, 4),
+	ARM64_SYS_REG(2, 0, 0, 1, 5),
+	ARM64_SYS_REG(2, 0, 0, 1, 6),
+	ARM64_SYS_REG(2, 0, 0, 1, 7),
+	ARM64_SYS_REG(2, 0, 0, 2, 0),	/* MDCCINT_EL1 */
+	ARM64_SYS_REG(2, 0, 0, 2, 2),	/* MDSCR_EL1 */
+	ARM64_SYS_REG(2, 0, 0, 2, 4),
+	ARM64_SYS_REG(2, 0, 0, 2, 5),
+	ARM64_SYS_REG(2, 0, 0, 2, 6),
+	ARM64_SYS_REG(2, 0, 0, 2, 7),
+	ARM64_SYS_REG(2, 0, 0, 3, 4),
+	ARM64_SYS_REG(2, 0, 0, 3, 5),
+	ARM64_SYS_REG(2, 0, 0, 3, 6),
+	ARM64_SYS_REG(2, 0, 0, 3, 7),
+	ARM64_SYS_REG(2, 0, 0, 4, 4),
+	ARM64_SYS_REG(2, 0, 0, 4, 5),
+	ARM64_SYS_REG(2, 0, 0, 4, 6),
+	ARM64_SYS_REG(2, 0, 0, 4, 7),
+	ARM64_SYS_REG(2, 0, 0, 5, 4),
+	ARM64_SYS_REG(2, 0, 0, 5, 5),
+	ARM64_SYS_REG(2, 0, 0, 5, 6),
+	ARM64_SYS_REG(2, 0, 0, 5, 7),
+	ARM64_SYS_REG(2, 0, 0, 6, 4),
+	ARM64_SYS_REG(2, 0, 0, 6, 5),
+	ARM64_SYS_REG(2, 0, 0, 6, 6),
+	ARM64_SYS_REG(2, 0, 0, 6, 7),
+	ARM64_SYS_REG(2, 0, 0, 7, 4),
+	ARM64_SYS_REG(2, 0, 0, 7, 5),
+	ARM64_SYS_REG(2, 0, 0, 7, 6),
+	ARM64_SYS_REG(2, 0, 0, 7, 7),
+	ARM64_SYS_REG(2, 0, 0, 8, 4),
+	ARM64_SYS_REG(2, 0, 0, 8, 5),
+	ARM64_SYS_REG(2, 0, 0, 8, 6),
+	ARM64_SYS_REG(2, 0, 0, 8, 7),
+	ARM64_SYS_REG(2, 0, 0, 9, 4),
+	ARM64_SYS_REG(2, 0, 0, 9, 5),
+	ARM64_SYS_REG(2, 0, 0, 9, 6),
+	ARM64_SYS_REG(2, 0, 0, 9, 7),
+	ARM64_SYS_REG(2, 0, 0, 10, 4),
+	ARM64_SYS_REG(2, 0, 0, 10, 5),
+	ARM64_SYS_REG(2, 0, 0, 10, 6),
+	ARM64_SYS_REG(2, 0, 0, 10, 7),
+	ARM64_SYS_REG(2, 0, 0, 11, 4),
+	ARM64_SYS_REG(2, 0, 0, 11, 5),
+	ARM64_SYS_REG(2, 0, 0, 11, 6),
+	ARM64_SYS_REG(2, 0, 0, 11, 7),
+	ARM64_SYS_REG(2, 0, 0, 12, 4),
+	ARM64_SYS_REG(2, 0, 0, 12, 5),
+	ARM64_SYS_REG(2, 0, 0, 12, 6),
+	ARM64_SYS_REG(2, 0, 0, 12, 7),
+	ARM64_SYS_REG(2, 0, 0, 13, 4),
+	ARM64_SYS_REG(2, 0, 0, 13, 5),
+	ARM64_SYS_REG(2, 0, 0, 13, 6),
+	ARM64_SYS_REG(2, 0, 0, 13, 7),
+	ARM64_SYS_REG(2, 0, 0, 14, 4),
+	ARM64_SYS_REG(2, 0, 0, 14, 5),
+	ARM64_SYS_REG(2, 0, 0, 14, 6),
+	ARM64_SYS_REG(2, 0, 0, 14, 7),
+	ARM64_SYS_REG(2, 0, 0, 15, 4),
+	ARM64_SYS_REG(2, 0, 0, 15, 5),
+	ARM64_SYS_REG(2, 0, 0, 15, 6),
+	ARM64_SYS_REG(2, 0, 0, 15, 7),
+	ARM64_SYS_REG(2, 4, 0, 7, 0),	/* DBGVCR32_EL2 */
+	ARM64_SYS_REG(3, 0, 0, 0, 5),	/* MPIDR_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 1, 0),	/* ID_PFR0_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 1, 1),	/* ID_PFR1_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 1, 2),	/* ID_DFR0_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 1, 3),	/* ID_AFR0_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 1, 4),	/* ID_MMFR0_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 1, 5),	/* ID_MMFR1_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 1, 6),	/* ID_MMFR2_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 1, 7),	/* ID_MMFR3_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 2, 0),	/* ID_ISAR0_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 2, 1),	/* ID_ISAR1_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 2, 2),	/* ID_ISAR2_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 2, 3),	/* ID_ISAR3_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 2, 4),	/* ID_ISAR4_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 2, 5),	/* ID_ISAR5_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 2, 6),	/* ID_MMFR4_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 2, 7),	/* ID_ISAR6_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 3, 0),	/* MVFR0_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 3, 1),	/* MVFR1_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 3, 2),	/* MVFR2_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 3, 3),
+	ARM64_SYS_REG(3, 0, 0, 3, 4),	/* ID_PFR2_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 3, 5),	/* ID_DFR1_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 3, 6),	/* ID_MMFR5_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 3, 7),
+	ARM64_SYS_REG(3, 0, 0, 4, 0),	/* ID_AA64PFR0_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 4, 1),	/* ID_AA64PFR1_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 4, 2),
+	ARM64_SYS_REG(3, 0, 0, 4, 3),
+	ARM64_SYS_REG(3, 0, 0, 4, 4),	/* ID_AA64ZFR0_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 4, 5),
+	ARM64_SYS_REG(3, 0, 0, 4, 6),
+	ARM64_SYS_REG(3, 0, 0, 4, 7),
+	ARM64_SYS_REG(3, 0, 0, 5, 0),	/* ID_AA64DFR0_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 5, 1),	/* ID_AA64DFR1_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 5, 2),
+	ARM64_SYS_REG(3, 0, 0, 5, 3),
+	ARM64_SYS_REG(3, 0, 0, 5, 4),	/* ID_AA64AFR0_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 5, 5),	/* ID_AA64AFR1_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 5, 6),
+	ARM64_SYS_REG(3, 0, 0, 5, 7),
+	ARM64_SYS_REG(3, 0, 0, 6, 0),	/* ID_AA64ISAR0_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 6, 1),	/* ID_AA64ISAR1_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 6, 2),
+	ARM64_SYS_REG(3, 0, 0, 6, 3),
+	ARM64_SYS_REG(3, 0, 0, 6, 4),
+	ARM64_SYS_REG(3, 0, 0, 6, 5),
+	ARM64_SYS_REG(3, 0, 0, 6, 6),
+	ARM64_SYS_REG(3, 0, 0, 6, 7),
+	ARM64_SYS_REG(3, 0, 0, 7, 0),	/* ID_AA64MMFR0_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 7, 1),	/* ID_AA64MMFR1_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 7, 2),	/* ID_AA64MMFR2_EL1 */
+	ARM64_SYS_REG(3, 0, 0, 7, 3),
+	ARM64_SYS_REG(3, 0, 0, 7, 4),
+	ARM64_SYS_REG(3, 0, 0, 7, 5),
+	ARM64_SYS_REG(3, 0, 0, 7, 6),
+	ARM64_SYS_REG(3, 0, 0, 7, 7),
+	ARM64_SYS_REG(3, 0, 1, 0, 0),	/* SCTLR_EL1 */
+	ARM64_SYS_REG(3, 0, 1, 0, 1),	/* ACTLR_EL1 */
+	ARM64_SYS_REG(3, 0, 1, 0, 2),	/* CPACR_EL1 */
+	ARM64_SYS_REG(3, 0, 2, 0, 0),	/* TTBR0_EL1 */
+	ARM64_SYS_REG(3, 0, 2, 0, 1),	/* TTBR1_EL1 */
+	ARM64_SYS_REG(3, 0, 2, 0, 2),	/* TCR_EL1 */
+	ARM64_SYS_REG(3, 0, 5, 1, 0),	/* AFSR0_EL1 */
+	ARM64_SYS_REG(3, 0, 5, 1, 1),	/* AFSR1_EL1 */
+	ARM64_SYS_REG(3, 0, 5, 2, 0),	/* ESR_EL1 */
+	ARM64_SYS_REG(3, 0, 6, 0, 0),	/* FAR_EL1 */
+	ARM64_SYS_REG(3, 0, 7, 4, 0),	/* PAR_EL1 */
+	ARM64_SYS_REG(3, 0, 9, 14, 1),	/* PMINTENSET_EL1 */
+	ARM64_SYS_REG(3, 0, 9, 14, 2),	/* PMINTENCLR_EL1 */
+	ARM64_SYS_REG(3, 0, 10, 2, 0),	/* MAIR_EL1 */
+	ARM64_SYS_REG(3, 0, 10, 3, 0),	/* AMAIR_EL1 */
+	ARM64_SYS_REG(3, 0, 12, 0, 0),	/* VBAR_EL1 */
+	ARM64_SYS_REG(3, 0, 13, 0, 1),	/* CONTEXTIDR_EL1 */
+	ARM64_SYS_REG(3, 0, 13, 0, 4),	/* TPIDR_EL1 */
+	ARM64_SYS_REG(3, 0, 14, 1, 0),	/* CNTKCTL_EL1 */
+	ARM64_SYS_REG(3, 2, 0, 0, 0),	/* CSSELR_EL1 */
+	ARM64_SYS_REG(3, 3, 9, 12, 1),	/* PMCNTENSET_EL0 */
+	ARM64_SYS_REG(3, 3, 9, 12, 2),	/* PMCNTENCLR_EL0 */
+	ARM64_SYS_REG(3, 3, 9, 12, 3),	/* PMOVSCLR_EL0 */
+	ARM64_SYS_REG(3, 3, 9, 12, 4),	/* PMSWINC_EL0 */
+	ARM64_SYS_REG(3, 3, 9, 12, 5),	/* PMSELR_EL0 */
+	ARM64_SYS_REG(3, 3, 9, 13, 0),	/* PMCCNTR_EL0 */
+	ARM64_SYS_REG(3, 3, 9, 14, 0),	/* PMUSERENR_EL0 */
+	ARM64_SYS_REG(3, 3, 9, 14, 3),	/* PMOVSSET_EL0 */
+	ARM64_SYS_REG(3, 3, 13, 0, 2),	/* TPIDR_EL0 */
+	ARM64_SYS_REG(3, 3, 13, 0, 3),	/* TPIDRRO_EL0 */
+	ARM64_SYS_REG(3, 3, 14, 8, 0),
+	ARM64_SYS_REG(3, 3, 14, 8, 1),
+	ARM64_SYS_REG(3, 3, 14, 8, 2),
+	ARM64_SYS_REG(3, 3, 14, 8, 3),
+	ARM64_SYS_REG(3, 3, 14, 8, 4),
+	ARM64_SYS_REG(3, 3, 14, 8, 5),
+	ARM64_SYS_REG(3, 3, 14, 8, 6),
+	ARM64_SYS_REG(3, 3, 14, 8, 7),
+	ARM64_SYS_REG(3, 3, 14, 9, 0),
+	ARM64_SYS_REG(3, 3, 14, 9, 1),
+	ARM64_SYS_REG(3, 3, 14, 9, 2),
+	ARM64_SYS_REG(3, 3, 14, 9, 3),
+	ARM64_SYS_REG(3, 3, 14, 9, 4),
+	ARM64_SYS_REG(3, 3, 14, 9, 5),
+	ARM64_SYS_REG(3, 3, 14, 9, 6),
+	ARM64_SYS_REG(3, 3, 14, 9, 7),
+	ARM64_SYS_REG(3, 3, 14, 10, 0),
+	ARM64_SYS_REG(3, 3, 14, 10, 1),
+	ARM64_SYS_REG(3, 3, 14, 10, 2),
+	ARM64_SYS_REG(3, 3, 14, 10, 3),
+	ARM64_SYS_REG(3, 3, 14, 10, 4),
+	ARM64_SYS_REG(3, 3, 14, 10, 5),
+	ARM64_SYS_REG(3, 3, 14, 10, 6),
+	ARM64_SYS_REG(3, 3, 14, 10, 7),
+	ARM64_SYS_REG(3, 3, 14, 11, 0),
+	ARM64_SYS_REG(3, 3, 14, 11, 1),
+	ARM64_SYS_REG(3, 3, 14, 11, 2),
+	ARM64_SYS_REG(3, 3, 14, 11, 3),
+	ARM64_SYS_REG(3, 3, 14, 11, 4),
+	ARM64_SYS_REG(3, 3, 14, 11, 5),
+	ARM64_SYS_REG(3, 3, 14, 11, 6),
+	ARM64_SYS_REG(3, 3, 14, 12, 0),
+	ARM64_SYS_REG(3, 3, 14, 12, 1),
+	ARM64_SYS_REG(3, 3, 14, 12, 2),
+	ARM64_SYS_REG(3, 3, 14, 12, 3),
+	ARM64_SYS_REG(3, 3, 14, 12, 4),
+	ARM64_SYS_REG(3, 3, 14, 12, 5),
+	ARM64_SYS_REG(3, 3, 14, 12, 6),
+	ARM64_SYS_REG(3, 3, 14, 12, 7),
+	ARM64_SYS_REG(3, 3, 14, 13, 0),
+	ARM64_SYS_REG(3, 3, 14, 13, 1),
+	ARM64_SYS_REG(3, 3, 14, 13, 2),
+	ARM64_SYS_REG(3, 3, 14, 13, 3),
+	ARM64_SYS_REG(3, 3, 14, 13, 4),
+	ARM64_SYS_REG(3, 3, 14, 13, 5),
+	ARM64_SYS_REG(3, 3, 14, 13, 6),
+	ARM64_SYS_REG(3, 3, 14, 13, 7),
+	ARM64_SYS_REG(3, 3, 14, 14, 0),
+	ARM64_SYS_REG(3, 3, 14, 14, 1),
+	ARM64_SYS_REG(3, 3, 14, 14, 2),
+	ARM64_SYS_REG(3, 3, 14, 14, 3),
+	ARM64_SYS_REG(3, 3, 14, 14, 4),
+	ARM64_SYS_REG(3, 3, 14, 14, 5),
+	ARM64_SYS_REG(3, 3, 14, 14, 6),
+	ARM64_SYS_REG(3, 3, 14, 14, 7),
+	ARM64_SYS_REG(3, 3, 14, 15, 0),
+	ARM64_SYS_REG(3, 3, 14, 15, 1),
+	ARM64_SYS_REG(3, 3, 14, 15, 2),
+	ARM64_SYS_REG(3, 3, 14, 15, 3),
+	ARM64_SYS_REG(3, 3, 14, 15, 4),
+	ARM64_SYS_REG(3, 3, 14, 15, 5),
+	ARM64_SYS_REG(3, 3, 14, 15, 6),
+	ARM64_SYS_REG(3, 3, 14, 15, 7),	/* PMCCFILTR_EL0 */
+	ARM64_SYS_REG(3, 4, 3, 0, 0),	/* DACR32_EL2 */
+	ARM64_SYS_REG(3, 4, 5, 0, 1),	/* IFSR32_EL2 */
+	ARM64_SYS_REG(3, 4, 5, 3, 0),	/* FPEXC32_EL2 */
+	KVM_REG_ARM64 | KVM_REG_SIZE_U32 | KVM_REG_ARM_DEMUX | KVM_REG_ARM_DEMUX_ID_CCSIDR | 0,
+	KVM_REG_ARM64 | KVM_REG_SIZE_U32 | KVM_REG_ARM_DEMUX | KVM_REG_ARM_DEMUX_ID_CCSIDR | 1,
+	KVM_REG_ARM64 | KVM_REG_SIZE_U32 | KVM_REG_ARM_DEMUX | KVM_REG_ARM_DEMUX_ID_CCSIDR | 2,
+};
+static __u64 blessed_n = ARRAY_SIZE(blessed_reg);
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 919e161dd289..eef061de7087 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -149,6 +149,7 @@ void vcpu_set_guest_debug(struct kvm_vm *vm, uint32_t vcpuid,
 			  struct kvm_guest_debug *debug);
 void vcpu_set_mp_state(struct kvm_vm *vm, uint32_t vcpuid,
 		       struct kvm_mp_state *mp_state);
+struct kvm_reg_list *vcpu_get_reg_list(struct kvm_vm *vm, uint32_t vcpuid);
 void vcpu_regs_get(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_regs *regs);
 void vcpu_regs_set(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_regs *regs);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 3327cebc1095..2e990727b893 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1260,6 +1260,35 @@ void vcpu_set_mp_state(struct kvm_vm *vm, uint32_t vcpuid,
 		"rc: %i errno: %i", ret, errno);
 }
 
+/*
+ * VM VCPU Get Reg List
+ *
+ * Input Args:
+ *   vm - Virtual Machine
+ *   vcpuid - VCPU ID
+ *
+ * Output Args:
+ *   None
+ *
+ * Return:
+ *   A pointer to an allocated struct kvm_reg_list
+ *
+ * Get the list of guest registers which are supported for
+ * KVM_GET_ONE_REG/KVM_SET_ONE_REG calls
+ */
+struct kvm_reg_list *vcpu_get_reg_list(struct kvm_vm *vm, uint32_t vcpuid)
+{
+	struct kvm_reg_list reg_list_n = { .n = 0 }, *reg_list;
+	int ret;
+
+	ret = _vcpu_ioctl(vm, vcpuid, KVM_GET_REG_LIST, &reg_list_n);
+	TEST_ASSERT(ret == -1 && errno == E2BIG, "KVM_GET_REG_LIST n=0");
+	reg_list = calloc(1, sizeof(*reg_list) + reg_list_n.n * sizeof(__u64));
+	reg_list->n = reg_list_n.n;
+	vcpu_ioctl(vm, vcpuid, KVM_GET_REG_LIST, reg_list);
+	return reg_list;
+}
+
 /*
  * VM VCPU Regs Get
  *
-- 
2.26.2

