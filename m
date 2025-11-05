Return-Path: <kvm+bounces-62085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DE70AC365B5
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 16:36:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 72E721A270B7
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 15:25:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ECF9338594;
	Wed,  5 Nov 2025 15:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="O5HQpvDv"
X-Original-To: kvm@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09ECD337B9C
	for <kvm@vger.kernel.org>; Wed,  5 Nov 2025 15:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762355863; cv=none; b=HAPS7SjISXkeJOJh3JYrVIdI/xex+qn9US5KvZw30mz0pT94FvyEZNdknh1/PQnghq9lEjBUZUH1kc665JFJ+XnPKzRQPt+GarVgkMYjPK1wgTZczURwEorGYAJtBrmPBRugSiLeaZvpKdkKoWNOJQlzwSO3Xdkkl35KXgKnhxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762355863; c=relaxed/simple;
	bh=c9SLWHQtfImXQXCj5SjPTg9JAAAgpj3FHP5QB9S9pYE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lrJcFK7+2ocVxDz0O5HzER2HKeAvPCnIylz+IKjqKTB0/hC2i3M25PgWY7BtBjrHByp/OO5Xq8zW+T2EuaTey123USfGxlVnrYha723hdJKAT/tR5bZ8GGOLXuODDAm+QMkPsNbju+rmt0sng1BbcjSLL44yvz/BgwjqUxqyDc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sanechips.com.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=O5HQpvDv; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sanechips.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=xa
	Nnz3xllFFklv0+6RHlce9uSFLQrslVQn0HbzGh3CM=; b=O5HQpvDvHlo0jkxy1w
	b/h0vb6/XPd+WqP7L9Fv7Q54ZGKEs86l2mSmZhUdjsV3i2256wSLzClKXgWGTPNe
	cKmP88Zdfg0z6d61AdF9lMHNujhfVODiXTx+JUuWMa5tbJAn6nnMTLEH50pQ9pBp
	OFXsGF0EJGYikDl2NMO/sxgC4=
Received: from wufei (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wDnz70cagtpVB05Bw--.55534S2;
	Wed, 05 Nov 2025 23:16:02 +0800 (CST)
From: Wu Fei <wu.fei9@sanechips.com.cn>
To: kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Wu Fei <wu.fei9@sanechips.com.cn>,
	Andrew Jones <ajones@ventanamicro.com>,
	Nutty Liu <nutty.liu@hotmail.com>,
	Anup Patel <anup@brainfault.org>
Subject: [PATCH v2 RESEND] KVM: riscv: selftests: Add riscv vm satp modes
Date: Wed,  5 Nov 2025 23:14:26 +0800
Message-ID: <20251105151442.28767-1-wu.fei9@sanechips.com.cn>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnz70cagtpVB05Bw--.55534S2
X-Coremail-Antispam: 1Uf129KBjvJXoW3ZryrCF4UAr47Ar1fur1UAwb_yoWDCryUpF
	4DGw10k347tFy3ZFy8Gr9YvrWxJw1rJrW8ury2ganruw4ktr1xJr1xKFZxAa43urW8W3Wr
	Cr1SgFy7WrWkWF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07je9a9UUUUU=
Sender: atwufei@163.com
X-CM-SenderInfo: pdwz3wlhl6il2tof0z/1tbiYB38oWkLYPnhsgAAsI

Current vm modes cannot represent riscv guest modes precisely, here add
all 9 combinations of P(56,40,41) x V(57,48,39). Also the default vm
mode is detected on runtime instead of hardcoded one, which might not be
supported on specific machine.

Signed-off-by: Wu Fei <wu.fei9@sanechips.com.cn>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>
Reviewed-by: Anup Patel <anup@brainfault.org>
---
 .../testing/selftests/kvm/include/kvm_util.h  | 17 ++++-
 .../selftests/kvm/include/riscv/processor.h   |  2 +
 tools/testing/selftests/kvm/lib/guest_modes.c | 41 +++++++++---
 tools/testing/selftests/kvm/lib/kvm_util.c    | 33 ++++++++++
 .../selftests/kvm/lib/riscv/processor.c       | 63 +++++++++++++++++--
 5 files changed, 142 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index d3f3e455c031..c6d0b4a5b263 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -185,6 +185,17 @@ enum vm_guest_mode {
 	VM_MODE_P36V48_64K,
 	VM_MODE_P47V47_16K,
 	VM_MODE_P36V47_16K,
+
+	VM_MODE_P56V57_4K,	/* For riscv64 */
+	VM_MODE_P56V48_4K,
+	VM_MODE_P56V39_4K,
+	VM_MODE_P50V57_4K,
+	VM_MODE_P50V48_4K,
+	VM_MODE_P50V39_4K,
+	VM_MODE_P41V57_4K,
+	VM_MODE_P41V48_4K,
+	VM_MODE_P41V39_4K,
+
 	NUM_VM_MODES,
 };
 
@@ -209,10 +220,10 @@ kvm_static_assert(sizeof(struct vm_shape) == sizeof(uint64_t));
 	shape;					\
 })
 
-#if defined(__aarch64__)
-
 extern enum vm_guest_mode vm_mode_default;
 
+#if defined(__aarch64__)
+
 #define VM_MODE_DEFAULT			vm_mode_default
 #define MIN_PAGE_SHIFT			12U
 #define ptes_per_page(page_size)	((page_size) / 8)
@@ -235,7 +246,7 @@ extern enum vm_guest_mode vm_mode_default;
 #error "RISC-V 32-bit kvm selftests not supported"
 #endif
 
-#define VM_MODE_DEFAULT			VM_MODE_P40V48_4K
+#define VM_MODE_DEFAULT			vm_mode_default
 #define MIN_PAGE_SHIFT			12U
 #define ptes_per_page(page_size)	((page_size) / 8)
 
diff --git a/tools/testing/selftests/kvm/include/riscv/processor.h b/tools/testing/selftests/kvm/include/riscv/processor.h
index e58282488beb..4dade8c4d18e 100644
--- a/tools/testing/selftests/kvm/include/riscv/processor.h
+++ b/tools/testing/selftests/kvm/include/riscv/processor.h
@@ -192,4 +192,6 @@ static inline void local_irq_disable(void)
 	csr_clear(CSR_SSTATUS, SR_SIE);
 }
 
+unsigned long riscv64_get_satp_mode(void);
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testing/selftests/kvm/lib/guest_modes.c
index b04901e55138..ce3099630397 100644
--- a/tools/testing/selftests/kvm/lib/guest_modes.c
+++ b/tools/testing/selftests/kvm/lib/guest_modes.c
@@ -4,7 +4,7 @@
  */
 #include "guest_modes.h"
 
-#ifdef __aarch64__
+#if defined(__aarch64__) || defined(__riscv)
 #include "processor.h"
 enum vm_guest_mode vm_mode_default;
 #endif
@@ -13,9 +13,11 @@ struct guest_mode guest_modes[NUM_VM_MODES];
 
 void guest_modes_append_default(void)
 {
-#ifndef __aarch64__
+#if !defined(__aarch64__) && !defined(__riscv)
 	guest_mode_append(VM_MODE_DEFAULT, true);
-#else
+#endif
+
+#ifdef __aarch64__
 	{
 		unsigned int limit = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
 		uint32_t ipa4k, ipa16k, ipa64k;
@@ -74,11 +76,36 @@ void guest_modes_append_default(void)
 #ifdef __riscv
 	{
 		unsigned int sz = kvm_check_cap(KVM_CAP_VM_GPA_BITS);
+		unsigned long satp_mode = riscv64_get_satp_mode() << SATP_MODE_SHIFT;
+		int i;
 
-		if (sz >= 52)
-			guest_mode_append(VM_MODE_P52V48_4K, true);
-		if (sz >= 48)
-			guest_mode_append(VM_MODE_P48V48_4K, true);
+		switch (sz) {
+		case 59:
+			guest_mode_append(VM_MODE_P56V57_4K, satp_mode >= SATP_MODE_57);
+			guest_mode_append(VM_MODE_P56V48_4K, satp_mode >= SATP_MODE_48);
+			guest_mode_append(VM_MODE_P56V39_4K, satp_mode >= SATP_MODE_39);
+			break;
+		case 50:
+			guest_mode_append(VM_MODE_P50V57_4K, satp_mode >= SATP_MODE_57);
+			guest_mode_append(VM_MODE_P50V48_4K, satp_mode >= SATP_MODE_48);
+			guest_mode_append(VM_MODE_P50V39_4K, satp_mode >= SATP_MODE_39);
+			break;
+		case 41:
+			guest_mode_append(VM_MODE_P41V57_4K, satp_mode >= SATP_MODE_57);
+			guest_mode_append(VM_MODE_P41V48_4K, satp_mode >= SATP_MODE_48);
+			guest_mode_append(VM_MODE_P41V39_4K, satp_mode >= SATP_MODE_39);
+			break;
+		default:
+			break;
+		}
+
+		/* set the first supported mode as default */
+		vm_mode_default = NUM_VM_MODES;
+		for (i = 0; vm_mode_default == NUM_VM_MODES && i < NUM_VM_MODES; i++) {
+			if (guest_modes[i].supported && guest_modes[i].enabled)
+				vm_mode_default = i;
+		}
+		TEST_ASSERT(vm_mode_default != NUM_VM_MODES, "No supported mode!");
 	}
 #endif
 }
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 1a93d6361671..a6a4bbc07211 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -209,6 +209,15 @@ const char *vm_guest_mode_string(uint32_t i)
 		[VM_MODE_P36V48_64K]	= "PA-bits:36,  VA-bits:48, 64K pages",
 		[VM_MODE_P47V47_16K]	= "PA-bits:47,  VA-bits:47, 16K pages",
 		[VM_MODE_P36V47_16K]	= "PA-bits:36,  VA-bits:47, 16K pages",
+		[VM_MODE_P56V57_4K]	= "PA-bits:56,  VA-bits:57,  4K pages",
+		[VM_MODE_P56V48_4K]	= "PA-bits:56,  VA-bits:48,  4K pages",
+		[VM_MODE_P56V39_4K]	= "PA-bits:56,  VA-bits:39,  4K pages",
+		[VM_MODE_P50V57_4K]	= "PA-bits:50,  VA-bits:57,  4K pages",
+		[VM_MODE_P50V48_4K]	= "PA-bits:50,  VA-bits:48,  4K pages",
+		[VM_MODE_P50V39_4K]	= "PA-bits:50,  VA-bits:39,  4K pages",
+		[VM_MODE_P41V57_4K]	= "PA-bits:41,  VA-bits:57,  4K pages",
+		[VM_MODE_P41V48_4K]	= "PA-bits:41,  VA-bits:48,  4K pages",
+		[VM_MODE_P41V39_4K]	= "PA-bits:41,  VA-bits:39,  4K pages",
 	};
 	_Static_assert(sizeof(strings)/sizeof(char *) == NUM_VM_MODES,
 		       "Missing new mode strings?");
@@ -236,6 +245,15 @@ const struct vm_guest_mode_params vm_guest_mode_params[] = {
 	[VM_MODE_P36V48_64K]	= { 36, 48, 0x10000, 16 },
 	[VM_MODE_P47V47_16K]	= { 47, 47,  0x4000, 14 },
 	[VM_MODE_P36V47_16K]	= { 36, 47,  0x4000, 14 },
+	[VM_MODE_P56V57_4K]	= { 56, 57,  0x1000, 12 },
+	[VM_MODE_P56V48_4K]	= { 56, 48,  0x1000, 12 },
+	[VM_MODE_P56V39_4K]	= { 56, 39,  0x1000, 12 },
+	[VM_MODE_P50V57_4K]	= { 50, 57,  0x1000, 12 },
+	[VM_MODE_P50V48_4K]	= { 50, 48,  0x1000, 12 },
+	[VM_MODE_P50V39_4K]	= { 50, 39,  0x1000, 12 },
+	[VM_MODE_P41V57_4K]	= { 41, 57,  0x1000, 12 },
+	[VM_MODE_P41V48_4K]	= { 41, 48,  0x1000, 12 },
+	[VM_MODE_P41V39_4K]	= { 41, 39,  0x1000, 12 },
 };
 _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params) == NUM_VM_MODES,
 	       "Missing new mode params?");
@@ -336,6 +354,21 @@ struct kvm_vm *____vm_create(struct vm_shape shape)
 	case VM_MODE_P44V64_4K:
 		vm->pgtable_levels = 5;
 		break;
+	case VM_MODE_P56V57_4K:
+	case VM_MODE_P50V57_4K:
+	case VM_MODE_P41V57_4K:
+		vm->pgtable_levels = 5;
+		break;
+	case VM_MODE_P56V48_4K:
+	case VM_MODE_P50V48_4K:
+	case VM_MODE_P41V48_4K:
+		vm->pgtable_levels = 4;
+		break;
+	case VM_MODE_P56V39_4K:
+	case VM_MODE_P50V39_4K:
+	case VM_MODE_P41V39_4K:
+		vm->pgtable_levels = 3;
+		break;
 	default:
 		TEST_FAIL("Unknown guest mode: 0x%x", vm->mode);
 	}
diff --git a/tools/testing/selftests/kvm/lib/riscv/processor.c b/tools/testing/selftests/kvm/lib/riscv/processor.c
index 2eac7d4b59e9..003693576225 100644
--- a/tools/testing/selftests/kvm/lib/riscv/processor.c
+++ b/tools/testing/selftests/kvm/lib/riscv/processor.c
@@ -8,6 +8,7 @@
 #include <linux/compiler.h>
 #include <assert.h>
 
+#include "guest_modes.h"
 #include "kvm_util.h"
 #include "processor.h"
 #include "ucall_common.h"
@@ -197,22 +198,41 @@ void riscv_vcpu_mmu_setup(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vm *vm = vcpu->vm;
 	unsigned long satp;
+	unsigned long satp_mode;
+	unsigned long max_satp_mode;
 
 	/*
 	 * The RISC-V Sv48 MMU mode supports 56-bit physical address
 	 * for 48-bit virtual address with 4KB last level page size.
 	 */
 	switch (vm->mode) {
-	case VM_MODE_P52V48_4K:
-	case VM_MODE_P48V48_4K:
-	case VM_MODE_P40V48_4K:
+	case VM_MODE_P56V57_4K:
+	case VM_MODE_P50V57_4K:
+	case VM_MODE_P41V57_4K:
+		satp_mode = SATP_MODE_57;
+		break;
+	case VM_MODE_P56V48_4K:
+	case VM_MODE_P50V48_4K:
+	case VM_MODE_P41V48_4K:
+		satp_mode = SATP_MODE_48;
+		break;
+	case VM_MODE_P56V39_4K:
+	case VM_MODE_P50V39_4K:
+	case VM_MODE_P41V39_4K:
+		satp_mode = SATP_MODE_39;
 		break;
 	default:
 		TEST_FAIL("Unknown guest mode, mode: 0x%x", vm->mode);
 	}
 
+	max_satp_mode = vcpu_get_reg(vcpu, RISCV_CONFIG_REG(satp_mode));
+
+	if ((satp_mode >> SATP_MODE_SHIFT) > max_satp_mode)
+		TEST_FAIL("Unable to set satp mode 0x%lx, max mode 0x%lx\n",
+			  satp_mode >> SATP_MODE_SHIFT, max_satp_mode);
+
 	satp = (vm->pgd >> PGTBL_PAGE_SIZE_SHIFT) & SATP_PPN;
-	satp |= SATP_MODE_48;
+	satp |= satp_mode;
 
 	vcpu_set_reg(vcpu, RISCV_GENERAL_CSR_REG(satp), satp);
 }
@@ -515,3 +535,38 @@ unsigned long get_host_sbi_spec_version(void)
 
 	return ret.value;
 }
+
+void kvm_selftest_arch_init(void)
+{
+	/*
+	 * riscv64 doesn't have a true default mode, so start by detecting the
+	 * supported vm mode.
+	 */
+	guest_modes_append_default();
+}
+
+unsigned long riscv64_get_satp_mode(void)
+{
+	int kvm_fd, vm_fd, vcpu_fd, err;
+	uint64_t val;
+	struct kvm_one_reg reg = {
+		.id     = RISCV_CONFIG_REG(satp_mode),
+		.addr   = (uint64_t)&val,
+	};
+
+	kvm_fd = open_kvm_dev_path_or_exit();
+	vm_fd = __kvm_ioctl(kvm_fd, KVM_CREATE_VM, NULL);
+	TEST_ASSERT(vm_fd >= 0, KVM_IOCTL_ERROR(KVM_CREATE_VM, vm_fd));
+
+	vcpu_fd = ioctl(vm_fd, KVM_CREATE_VCPU, 0);
+	TEST_ASSERT(vcpu_fd >= 0, KVM_IOCTL_ERROR(KVM_CREATE_VCPU, vcpu_fd));
+
+	err = ioctl(vcpu_fd, KVM_GET_ONE_REG, &reg);
+	TEST_ASSERT(err == 0, KVM_IOCTL_ERROR(KVM_GET_ONE_REG, vcpu_fd));
+
+	close(vcpu_fd);
+	close(vm_fd);
+	close(kvm_fd);
+
+	return val;
+}
-- 
2.51.0


