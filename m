Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04123958FD
	for <lists+kvm@lfdr.de>; Mon, 31 May 2021 12:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbhEaKfq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 May 2021 06:35:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22795 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231283AbhEaKfn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 31 May 2021 06:35:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622457243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2ncrnD0QLrwz5vEecYkAxbmcquVHQDZY24zx21flAiw=;
        b=O5gDuspHmjUe3XHznrt2QSGgrWr3erPPEc/wa3d8m2K0bTOs2dc2fgwu1wZBbshuDAzHu+
        n1bfRULA1fpQALmYG+XGa3Dbri8ifA+aOiZx+aYjznGCsMqhf8yeQQOzm1O4Sr5o9frkLk
        S7n2TDTYmhCv91BbPJeyzmV9zc7SnjM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-a8ZtudY_NCKKolQaX9TSBw-1; Mon, 31 May 2021 06:33:55 -0400
X-MC-Unique: a8ZtudY_NCKKolQaX9TSBw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB237101371C;
        Mon, 31 May 2021 10:33:53 +0000 (UTC)
Received: from gator.redhat.com (unknown [10.40.195.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8605C5D9CD;
        Mon, 31 May 2021 10:33:51 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, ricarkol@google.com, eric.auger@redhat.com,
        alexandru.elisei@arm.com, pbonzini@redhat.com
Subject: [PATCH v3 1/5] KVM: arm64: selftests: get-reg-list: Introduce vcpu configs
Date:   Mon, 31 May 2021 12:33:40 +0200
Message-Id: <20210531103344.29325-2-drjones@redhat.com>
In-Reply-To: <20210531103344.29325-1-drjones@redhat.com>
References: <20210531103344.29325-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We already break register lists into sublists that get selected based
on vcpu config. However, since we only had two configs (vregs and sve),
we didn't structure the code very well to manage them. Restructure it
now to more cleanly handle register sublists that are dependent on the
vcpu config.

This patch has no intended functional change (except for the vcpu
config name now being prepended to all output).

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 .../selftests/kvm/aarch64/get-reg-list.c      | 265 ++++++++++++------
 1 file changed, 175 insertions(+), 90 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index 486932164cf2..7bb09ce20dde 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -37,7 +37,30 @@
 #define reg_list_sve() (false)
 #endif
 
-#define REG_MASK (KVM_REG_ARCH_MASK | KVM_REG_SIZE_MASK | KVM_REG_ARM_COPROC_MASK)
+static struct kvm_reg_list *reg_list;
+static __u64 *blessed_reg, blessed_n;
+
+struct reg_sublist {
+	const char *name;
+	long capability;
+	int feature;
+	bool finalize;
+	__u64 *regs;
+	__u64 regs_n;
+	__u64 *rejects_set;
+	__u64 rejects_set_n;
+};
+
+struct vcpu_config {
+	char *name;
+	struct reg_sublist sublists[];
+};
+
+static struct vcpu_config vregs_config;
+static struct vcpu_config sve_config;
+
+#define for_each_sublist(c, s)							\
+	for ((s) = &(c)->sublists[0]; (s)->regs; ++(s))
 
 #define for_each_reg(i)								\
 	for ((i) = 0; (i) < reg_list->n; ++(i))
@@ -54,12 +77,41 @@
 	for_each_reg_filtered(i)						\
 		if (!find_reg(blessed_reg, blessed_n, reg_list->reg[i]))
 
+static const char *config_name(struct vcpu_config *c)
+{
+	struct reg_sublist *s;
+	int len = 0;
 
-static struct kvm_reg_list *reg_list;
+	if (c->name)
+		return c->name;
 
-static __u64 base_regs[], vregs[], sve_regs[], rejects_set[];
-static __u64 base_regs_n, vregs_n, sve_regs_n, rejects_set_n;
-static __u64 *blessed_reg, blessed_n;
+	for_each_sublist(c, s)
+		len += strlen(s->name) + 1;
+
+	c->name = malloc(len);
+
+	len = 0;
+	for_each_sublist(c, s) {
+		if (!strcmp(s->name, "base"))
+			continue;
+		strcat(c->name + len, s->name);
+		len += strlen(s->name) + 1;
+		c->name[len - 1] = '+';
+	}
+	c->name[len - 1] = '\0';
+
+	return c->name;
+}
+
+static bool has_cap(struct vcpu_config *c, long capability)
+{
+	struct reg_sublist *s;
+
+	for_each_sublist(c, s)
+		if (s->capability == capability)
+			return true;
+	return false;
+}
 
 static bool filter_reg(__u64 reg)
 {
@@ -96,11 +148,13 @@ static const char *str_with_index(const char *template, __u64 index)
 	return (const char *)str;
 }
 
+#define REG_MASK (KVM_REG_ARCH_MASK | KVM_REG_SIZE_MASK | KVM_REG_ARM_COPROC_MASK)
+
 #define CORE_REGS_XX_NR_WORDS	2
 #define CORE_SPSR_XX_NR_WORDS	2
 #define CORE_FPREGS_XX_NR_WORDS	4
 
-static const char *core_id_to_str(__u64 id)
+static const char *core_id_to_str(struct vcpu_config *c, __u64 id)
 {
 	__u64 core_off = id & ~REG_MASK, idx;
 
@@ -111,7 +165,7 @@ static const char *core_id_to_str(__u64 id)
 	case KVM_REG_ARM_CORE_REG(regs.regs[0]) ...
 	     KVM_REG_ARM_CORE_REG(regs.regs[30]):
 		idx = (core_off - KVM_REG_ARM_CORE_REG(regs.regs[0])) / CORE_REGS_XX_NR_WORDS;
-		TEST_ASSERT(idx < 31, "Unexpected regs.regs index: %lld", idx);
+		TEST_ASSERT(idx < 31, "%s: Unexpected regs.regs index: %lld", config_name(c), idx);
 		return str_with_index("KVM_REG_ARM_CORE_REG(regs.regs[##])", idx);
 	case KVM_REG_ARM_CORE_REG(regs.sp):
 		return "KVM_REG_ARM_CORE_REG(regs.sp)";
@@ -126,12 +180,12 @@ static const char *core_id_to_str(__u64 id)
 	case KVM_REG_ARM_CORE_REG(spsr[0]) ...
 	     KVM_REG_ARM_CORE_REG(spsr[KVM_NR_SPSR - 1]):
 		idx = (core_off - KVM_REG_ARM_CORE_REG(spsr[0])) / CORE_SPSR_XX_NR_WORDS;
-		TEST_ASSERT(idx < KVM_NR_SPSR, "Unexpected spsr index: %lld", idx);
+		TEST_ASSERT(idx < KVM_NR_SPSR, "%s: Unexpected spsr index: %lld", config_name(c), idx);
 		return str_with_index("KVM_REG_ARM_CORE_REG(spsr[##])", idx);
 	case KVM_REG_ARM_CORE_REG(fp_regs.vregs[0]) ...
 	     KVM_REG_ARM_CORE_REG(fp_regs.vregs[31]):
 		idx = (core_off - KVM_REG_ARM_CORE_REG(fp_regs.vregs[0])) / CORE_FPREGS_XX_NR_WORDS;
-		TEST_ASSERT(idx < 32, "Unexpected fp_regs.vregs index: %lld", idx);
+		TEST_ASSERT(idx < 32, "%s: Unexpected fp_regs.vregs index: %lld", config_name(c), idx);
 		return str_with_index("KVM_REG_ARM_CORE_REG(fp_regs.vregs[##])", idx);
 	case KVM_REG_ARM_CORE_REG(fp_regs.fpsr):
 		return "KVM_REG_ARM_CORE_REG(fp_regs.fpsr)";
@@ -139,11 +193,11 @@ static const char *core_id_to_str(__u64 id)
 		return "KVM_REG_ARM_CORE_REG(fp_regs.fpcr)";
 	}
 
-	TEST_FAIL("Unknown core reg id: 0x%llx", id);
+	TEST_FAIL("%s: Unknown core reg id: 0x%llx", config_name(c), id);
 	return NULL;
 }
 
-static const char *sve_id_to_str(__u64 id)
+static const char *sve_id_to_str(struct vcpu_config *c, __u64 id)
 {
 	__u64 sve_off, n, i;
 
@@ -153,37 +207,37 @@ static const char *sve_id_to_str(__u64 id)
 	sve_off = id & ~(REG_MASK | ((1ULL << 5) - 1));
 	i = id & (KVM_ARM64_SVE_MAX_SLICES - 1);
 
-	TEST_ASSERT(i == 0, "Currently we don't expect slice > 0, reg id 0x%llx", id);
+	TEST_ASSERT(i == 0, "%s: Currently we don't expect slice > 0, reg id 0x%llx", config_name(c), id);
 
 	switch (sve_off) {
 	case KVM_REG_ARM64_SVE_ZREG_BASE ...
 	     KVM_REG_ARM64_SVE_ZREG_BASE + (1ULL << 5) * KVM_ARM64_SVE_NUM_ZREGS - 1:
 		n = (id >> 5) & (KVM_ARM64_SVE_NUM_ZREGS - 1);
 		TEST_ASSERT(id == KVM_REG_ARM64_SVE_ZREG(n, 0),
-			    "Unexpected bits set in SVE ZREG id: 0x%llx", id);
+			    "%s: Unexpected bits set in SVE ZREG id: 0x%llx", config_name(c), id);
 		return str_with_index("KVM_REG_ARM64_SVE_ZREG(##, 0)", n);
 	case KVM_REG_ARM64_SVE_PREG_BASE ...
 	     KVM_REG_ARM64_SVE_PREG_BASE + (1ULL << 5) * KVM_ARM64_SVE_NUM_PREGS - 1:
 		n = (id >> 5) & (KVM_ARM64_SVE_NUM_PREGS - 1);
 		TEST_ASSERT(id == KVM_REG_ARM64_SVE_PREG(n, 0),
-			    "Unexpected bits set in SVE PREG id: 0x%llx", id);
+			    "%s: Unexpected bits set in SVE PREG id: 0x%llx", config_name(c), id);
 		return str_with_index("KVM_REG_ARM64_SVE_PREG(##, 0)", n);
 	case KVM_REG_ARM64_SVE_FFR_BASE:
 		TEST_ASSERT(id == KVM_REG_ARM64_SVE_FFR(0),
-			    "Unexpected bits set in SVE FFR id: 0x%llx", id);
+			    "%s: Unexpected bits set in SVE FFR id: 0x%llx", config_name(c), id);
 		return "KVM_REG_ARM64_SVE_FFR(0)";
 	}
 
 	return NULL;
 }
 
-static void print_reg(__u64 id)
+static void print_reg(struct vcpu_config *c, __u64 id)
 {
 	unsigned op0, op1, crn, crm, op2;
 	const char *reg_size = NULL;
 
 	TEST_ASSERT((id & KVM_REG_ARCH_MASK) == KVM_REG_ARM64,
-		    "KVM_REG_ARM64 missing in reg id: 0x%llx", id);
+		    "%s: KVM_REG_ARM64 missing in reg id: 0x%llx", config_name(c), id);
 
 	switch (id & KVM_REG_SIZE_MASK) {
 	case KVM_REG_SIZE_U8:
@@ -214,17 +268,17 @@ static void print_reg(__u64 id)
 		reg_size = "KVM_REG_SIZE_U2048";
 		break;
 	default:
-		TEST_FAIL("Unexpected reg size: 0x%llx in reg id: 0x%llx",
-			  (id & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT, id);
+		TEST_FAIL("%s: Unexpected reg size: 0x%llx in reg id: 0x%llx",
+			  config_name(c), (id & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT, id);
 	}
 
 	switch (id & KVM_REG_ARM_COPROC_MASK) {
 	case KVM_REG_ARM_CORE:
-		printf("\tKVM_REG_ARM64 | %s | KVM_REG_ARM_CORE | %s,\n", reg_size, core_id_to_str(id));
+		printf("\tKVM_REG_ARM64 | %s | KVM_REG_ARM_CORE | %s,\n", reg_size, core_id_to_str(c, id));
 		break;
 	case KVM_REG_ARM_DEMUX:
 		TEST_ASSERT(!(id & ~(REG_MASK | KVM_REG_ARM_DEMUX_ID_MASK | KVM_REG_ARM_DEMUX_VAL_MASK)),
-			    "Unexpected bits set in DEMUX reg id: 0x%llx", id);
+			    "%s: Unexpected bits set in DEMUX reg id: 0x%llx", config_name(c), id);
 		printf("\tKVM_REG_ARM64 | %s | KVM_REG_ARM_DEMUX | KVM_REG_ARM_DEMUX_ID_CCSIDR | %lld,\n",
 		       reg_size, id & KVM_REG_ARM_DEMUX_VAL_MASK);
 		break;
@@ -235,23 +289,23 @@ static void print_reg(__u64 id)
 		crm = (id & KVM_REG_ARM64_SYSREG_CRM_MASK) >> KVM_REG_ARM64_SYSREG_CRM_SHIFT;
 		op2 = (id & KVM_REG_ARM64_SYSREG_OP2_MASK) >> KVM_REG_ARM64_SYSREG_OP2_SHIFT;
 		TEST_ASSERT(id == ARM64_SYS_REG(op0, op1, crn, crm, op2),
-			    "Unexpected bits set in SYSREG reg id: 0x%llx", id);
+			    "%s: Unexpected bits set in SYSREG reg id: 0x%llx", config_name(c), id);
 		printf("\tARM64_SYS_REG(%d, %d, %d, %d, %d),\n", op0, op1, crn, crm, op2);
 		break;
 	case KVM_REG_ARM_FW:
 		TEST_ASSERT(id == KVM_REG_ARM_FW_REG(id & 0xffff),
-			    "Unexpected bits set in FW reg id: 0x%llx", id);
+			    "%s: Unexpected bits set in FW reg id: 0x%llx", config_name(c), id);
 		printf("\tKVM_REG_ARM_FW_REG(%lld),\n", id & 0xffff);
 		break;
 	case KVM_REG_ARM64_SVE:
-		if (reg_list_sve())
-			printf("\t%s,\n", sve_id_to_str(id));
+		if (has_cap(c, KVM_CAP_ARM_SVE))
+			printf("\t%s,\n", sve_id_to_str(c, id));
 		else
-			TEST_FAIL("KVM_REG_ARM64_SVE is an unexpected coproc type in reg id: 0x%llx", id);
+			TEST_FAIL("%s: KVM_REG_ARM64_SVE is an unexpected coproc type in reg id: 0x%llx", config_name(c), id);
 		break;
 	default:
-		TEST_FAIL("Unexpected coproc type: 0x%llx in reg id: 0x%llx",
-			  (id & KVM_REG_ARM_COPROC_MASK) >> KVM_REG_ARM_COPROC_SHIFT, id);
+		TEST_FAIL("%s: Unexpected coproc type: 0x%llx in reg id: 0x%llx",
+			  config_name(c), (id & KVM_REG_ARM_COPROC_MASK) >> KVM_REG_ARM_COPROC_SHIFT, id);
 	}
 }
 
@@ -312,40 +366,51 @@ static void core_reg_fixup(void)
 	reg_list = tmp;
 }
 
-static void prepare_vcpu_init(struct kvm_vcpu_init *init)
+static void prepare_vcpu_init(struct vcpu_config *c, struct kvm_vcpu_init *init)
 {
-	if (reg_list_sve())
-		init->features[0] |= 1 << KVM_ARM_VCPU_SVE;
+	struct reg_sublist *s;
+
+	for_each_sublist(c, s)
+		if (s->capability)
+			init->features[s->feature / 32] |= 1 << (s->feature % 32);
 }
 
-static void finalize_vcpu(struct kvm_vm *vm, uint32_t vcpuid)
+static void finalize_vcpu(struct kvm_vm *vm, uint32_t vcpuid, struct vcpu_config *c)
 {
+	struct reg_sublist *s;
 	int feature;
 
-	if (reg_list_sve()) {
-		feature = KVM_ARM_VCPU_SVE;
-		vcpu_ioctl(vm, vcpuid, KVM_ARM_VCPU_FINALIZE, &feature);
+	for_each_sublist(c, s) {
+		if (s->finalize) {
+			feature = s->feature;
+			vcpu_ioctl(vm, vcpuid, KVM_ARM_VCPU_FINALIZE, &feature);
+		}
 	}
 }
 
-static void check_supported(void)
+static void check_supported(struct vcpu_config *c)
 {
-	if (reg_list_sve() && !kvm_check_cap(KVM_CAP_ARM_SVE)) {
-		fprintf(stderr, "SVE not available, skipping tests\n");
-		exit(KSFT_SKIP);
+	struct reg_sublist *s;
+
+	for_each_sublist(c, s) {
+		if (s->capability && !kvm_check_cap(s->capability)) {
+			fprintf(stderr, "%s: %s not available, skipping tests\n", config_name(c), s->name);
+			exit(KSFT_SKIP);
+		}
 	}
 }
 
 int main(int ac, char **av)
 {
+	struct vcpu_config *c = reg_list_sve() ? &sve_config : &vregs_config;
 	struct kvm_vcpu_init init = { .target = -1, };
-	int new_regs = 0, missing_regs = 0, i;
+	int new_regs = 0, missing_regs = 0, i, n;
 	int failed_get = 0, failed_set = 0, failed_reject = 0;
 	bool print_list = false, print_filtered = false, fixup_core_regs = false;
 	struct kvm_vm *vm;
-	__u64 *vec_regs;
+	struct reg_sublist *s;
 
-	check_supported();
+	check_supported(c);
 
 	for (i = 1; i < ac; ++i) {
 		if (strcmp(av[i], "--core-reg-fixup") == 0)
@@ -359,9 +424,9 @@ int main(int ac, char **av)
 	}
 
 	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
-	prepare_vcpu_init(&init);
+	prepare_vcpu_init(c, &init);
 	aarch64_vcpu_add_default(vm, 0, &init, NULL);
-	finalize_vcpu(vm, 0);
+	finalize_vcpu(vm, 0, c);
 
 	reg_list = vcpu_get_reg_list(vm, 0);
 
@@ -374,7 +439,7 @@ int main(int ac, char **av)
 			__u64 id = reg_list->reg[i];
 			if ((print_list && !filter_reg(id)) ||
 			    (print_filtered && filter_reg(id)))
-				print_reg(id);
+				print_reg(c, id);
 		}
 		putchar('\n');
 		return 0;
@@ -396,50 +461,52 @@ int main(int ac, char **av)
 			.id = reg_list->reg[i],
 			.addr = (__u64)&addr,
 		};
+		bool reject_reg = false;
 		int ret;
 
 		ret = _vcpu_ioctl(vm, 0, KVM_GET_ONE_REG, &reg);
 		if (ret) {
-			puts("Failed to get ");
-			print_reg(reg.id);
+			printf("%s: Failed to get ", config_name(c));
+			print_reg(c, reg.id);
 			putchar('\n');
 			++failed_get;
 		}
 
 		/* rejects_set registers are rejected after KVM_ARM_VCPU_FINALIZE */
-		if (find_reg(rejects_set, rejects_set_n, reg.id)) {
-			ret = _vcpu_ioctl(vm, 0, KVM_SET_ONE_REG, &reg);
-			if (ret != -1 || errno != EPERM) {
-				printf("Failed to reject (ret=%d, errno=%d) ", ret, errno);
-				print_reg(reg.id);
-				putchar('\n');
-				++failed_reject;
+		for_each_sublist(c, s) {
+			if (s->rejects_set && find_reg(s->rejects_set, s->rejects_set_n, reg.id)) {
+				reject_reg = true;
+				ret = _vcpu_ioctl(vm, 0, KVM_SET_ONE_REG, &reg);
+				if (ret != -1 || errno != EPERM) {
+					printf("%s: Failed to reject (ret=%d, errno=%d) ", config_name(c), ret, errno);
+					print_reg(c, reg.id);
+					putchar('\n');
+					++failed_reject;
+				}
+				break;
 			}
-			continue;
 		}
 
-		ret = _vcpu_ioctl(vm, 0, KVM_SET_ONE_REG, &reg);
-		if (ret) {
-			puts("Failed to set ");
-			print_reg(reg.id);
-			putchar('\n');
-			++failed_set;
+		if (!reject_reg) {
+			ret = _vcpu_ioctl(vm, 0, KVM_SET_ONE_REG, &reg);
+			if (ret) {
+				printf("%s: Failed to set ", config_name(c));
+				print_reg(c, reg.id);
+				putchar('\n');
+				++failed_set;
+			}
 		}
 	}
 
-	if (reg_list_sve()) {
-		blessed_n = base_regs_n + sve_regs_n;
-		vec_regs = sve_regs;
-	} else {
-		blessed_n = base_regs_n + vregs_n;
-		vec_regs = vregs;
-	}
-
+	for_each_sublist(c, s)
+		blessed_n += s->regs_n;
 	blessed_reg = calloc(blessed_n, sizeof(__u64));
-	for (i = 0; i < base_regs_n; ++i)
-		blessed_reg[i] = base_regs[i];
-	for (i = 0; i < blessed_n - base_regs_n; ++i)
-		blessed_reg[base_regs_n + i] = vec_regs[i];
+
+	n = 0;
+	for_each_sublist(c, s) {
+		for (i = 0; i < s->regs_n; ++i)
+			blessed_reg[n++] = s->regs[i];
+	}
 
 	for_each_new_reg(i)
 		++new_regs;
@@ -448,31 +515,31 @@ int main(int ac, char **av)
 		++missing_regs;
 
 	if (new_regs || missing_regs) {
-		printf("Number blessed registers: %5lld\n", blessed_n);
-		printf("Number registers:         %5lld\n", reg_list->n);
+		printf("%s: Number blessed registers: %5lld\n", config_name(c), blessed_n);
+		printf("%s: Number registers:         %5lld\n", config_name(c), reg_list->n);
 	}
 
 	if (new_regs) {
-		printf("\nThere are %d new registers.\n"
+		printf("\n%s: There are %d new registers.\n"
 		       "Consider adding them to the blessed reg "
-		       "list with the following lines:\n\n", new_regs);
+		       "list with the following lines:\n\n", config_name(c), new_regs);
 		for_each_new_reg(i)
-			print_reg(reg_list->reg[i]);
+			print_reg(c, reg_list->reg[i]);
 		putchar('\n');
 	}
 
 	if (missing_regs) {
-		printf("\nThere are %d missing registers.\n"
-		       "The following lines are missing registers:\n\n", missing_regs);
+		printf("\n%s: There are %d missing registers.\n"
+		       "The following lines are missing registers:\n\n", config_name(c), missing_regs);
 		for_each_missing_reg(i)
-			print_reg(blessed_reg[i]);
+			print_reg(c, blessed_reg[i]);
 		putchar('\n');
 	}
 
 	TEST_ASSERT(!missing_regs && !failed_get && !failed_set && !failed_reject,
-		    "There are %d missing registers; "
+		    "%s: There are %d missing registers; "
 		    "%d registers failed get; %d registers failed set; %d registers failed reject",
-		    missing_regs, failed_get, failed_set, failed_reject);
+		    config_name(c), missing_regs, failed_get, failed_set, failed_reject);
 
 	return 0;
 }
@@ -761,7 +828,6 @@ static __u64 base_regs[] = {
 	ARM64_SYS_REG(3, 4, 5, 0, 1),	/* IFSR32_EL2 */
 	ARM64_SYS_REG(3, 4, 5, 3, 0),	/* FPEXC32_EL2 */
 };
-static __u64 base_regs_n = ARRAY_SIZE(base_regs);
 
 static __u64 vregs[] = {
 	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[0]),
@@ -797,7 +863,6 @@ static __u64 vregs[] = {
 	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[30]),
 	KVM_REG_ARM64 | KVM_REG_SIZE_U128 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(fp_regs.vregs[31]),
 };
-static __u64 vregs_n = ARRAY_SIZE(vregs);
 
 static __u64 sve_regs[] = {
 	KVM_REG_ARM64_SVE_VLS,
@@ -852,11 +917,31 @@ static __u64 sve_regs[] = {
 	KVM_REG_ARM64_SVE_FFR(0),
 	ARM64_SYS_REG(3, 0, 1, 2, 0),   /* ZCR_EL1 */
 };
-static __u64 sve_regs_n = ARRAY_SIZE(sve_regs);
 
-static __u64 rejects_set[] = {
-#ifdef REG_LIST_SVE
+static __u64 sve_rejects_set[] = {
 	KVM_REG_ARM64_SVE_VLS,
-#endif
 };
-static __u64 rejects_set_n = ARRAY_SIZE(rejects_set);
+
+#define BASE_SUBLIST \
+	{ "base", .regs = base_regs, .regs_n = ARRAY_SIZE(base_regs), }
+#define VREGS_SUBLIST \
+	{ "vregs", .regs = vregs, .regs_n = ARRAY_SIZE(vregs), }
+#define SVE_SUBLIST \
+	{ "sve", .capability = KVM_CAP_ARM_SVE, .feature = KVM_ARM_VCPU_SVE, .finalize = true, \
+	  .regs = sve_regs, .regs_n = ARRAY_SIZE(sve_regs), \
+	  .rejects_set = sve_rejects_set, .rejects_set_n = ARRAY_SIZE(sve_rejects_set), }
+
+static struct vcpu_config vregs_config = {
+	.sublists = {
+	BASE_SUBLIST,
+	VREGS_SUBLIST,
+	{0},
+	},
+};
+static struct vcpu_config sve_config = {
+	.sublists = {
+	BASE_SUBLIST,
+	SVE_SUBLIST,
+	{0},
+	},
+};
-- 
2.31.1

