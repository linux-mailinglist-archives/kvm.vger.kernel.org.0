Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50256603479
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 22:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbiJRU7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 16:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbiJRU7I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 16:59:08 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A22FC09A5
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 13:59:04 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id p3-20020a170902e74300b0018546b77dccso7382441plf.17
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 13:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ve65J9Yhx3cpA/bFRhrVBhV9zjGGaLIwJGnKq/Q7y38=;
        b=C72G0aJjdK6yM+RjPgGcs072tgdVOtq3S4hGXSDnUYaVRYsCH+XL33OLTod89SPxOr
         vls+fg5Vdocuwqsw+i3a3HmExE1xx1Hl/yJ6ogvmfENbXGip+G16DxCyj1z2XsAStM+o
         erveJCfUYaDxzeXXdIKosTXAeYec4a9Rk3KSbP5meQZbO0lfXBie+M+tMn+/J/sSfl9A
         qV3F1LNKVTeIov5Y2nOCPrh9y7teB9WnRz8XS7PYwzyQbG5SyjH++9Z6xmbmKP7mzAKU
         BLLT6ah+MWjXMp9+TlZIRIYRxy3ItpbcURUO4/5Za7iKgkOyklztJlUmpDO3EBoGgTz2
         7xqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ve65J9Yhx3cpA/bFRhrVBhV9zjGGaLIwJGnKq/Q7y38=;
        b=aWQ16XGy3MF1Drx6lJvygoL2xS/zL0pCknnjkixh0C4e5RlbFo466hiP9QM/pY3/z5
         HPhypuCh2y388/8OqTPPHHevBHHPjCfCc0/q2F0oEP+oRBaFexjZacl8VSfHM/eMbn/h
         JdHqNFaanoxoMfBL9mpiELnIhOEOJVRTCHKMJLUc6hBg97tDZfkl2gY2LgOqvON6PkZF
         Va3vXerP1v+7vxprYKgTndw2kcsVbYyHa9LDAD5KLFKs3XtX/g3v6pzN/gwcQVqmyLvO
         aGUY2TMo2rr+oYngm9kMqgfUnD4o1kELQEP38ohvVDYofPx3lSDWHxrSrh+AGnDgvne6
         i1eA==
X-Gm-Message-State: ACrzQf3C+5l0L0fkST/thaDFbS5pCI1SQOm/iiksFTg0oixdSMSmEJ/q
        AIF6tpK0u+5UUKNXUjTxFIsRgTFPb2PIUw+EkxTMDZQfiWgVUlhBoGTkpBxmNbcp/164k3xAlYg
        0yP7pm3s4gUEyijZ09jM9dV+aMk4rGisXVg/VH1o5+sWPcETobqcF2+BYGA==
X-Google-Smtp-Source: AMsMyM4xf+eUbTCM6enfOWd8zUROkz+y4f20+kr+rRrV19g5SddrIt58NJC+gorIAQFPQuvwSJVKBefNTJk=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:c89b:7f49:3437:9db8])
 (user=pgonda job=sendgmr) by 2002:a17:90b:4a4d:b0:20d:4dc7:fa72 with SMTP id
 lb13-20020a17090b4a4d00b0020d4dc7fa72mr5493661pjb.86.1666126743629; Tue, 18
 Oct 2022 13:59:03 -0700 (PDT)
Date:   Tue, 18 Oct 2022 13:58:43 -0700
In-Reply-To: <20221018205845.770121-1-pgonda@google.com>
Message-Id: <20221018205845.770121-6-pgonda@google.com>
Mime-Version: 1.0
References: <20221018205845.770121-1-pgonda@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Subject: [PATCH V5 5/7] KVM: selftests: add library for creating/interacting
 with SEV guests
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, marcorr@google.com,
        seanjc@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        andrew.jones@linux.dev, pgonda@google.com, vannapurve@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add interfaces to allow tests to create SEV guests. The additional
requirements for SEV guests PTs and other state is encapsulated by the
new vm_sev_create_with_one_vcpu() function. This can future be
generalized for more vCPUs but the first set of SEV selftests in this
series only uses a single vCPU.

Originally-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 tools/arch/x86/include/asm/kvm_host.h         |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/kvm_util_base.h     |  15 +-
 .../selftests/kvm/include/x86_64/sev.h        |  22 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    |   4 +-
 .../selftests/kvm/lib/x86_64/processor.c      |   4 +
 tools/testing/selftests/kvm/lib/x86_64/sev.c  | 243 ++++++++++++++++++
 7 files changed, 286 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/sev.h
 create mode 100644 tools/testing/selftests/kvm/lib/x86_64/sev.c

diff --git a/tools/arch/x86/include/asm/kvm_host.h b/tools/arch/x86/include/asm/kvm_host.h
index 03153c18c747..0357a7135835 100644
--- a/tools/arch/x86/include/asm/kvm_host.h
+++ b/tools/arch/x86/include/asm/kvm_host.h
@@ -9,6 +9,7 @@ struct kvm_vm_arch {
 	uint64_t pte_me_mask;
 	uint64_t c_bit;
 	uint64_t s_bit;
+	bool is_pt_protected;
 };
 
 #endif  // _TOOLS_LINUX_ASM_X86_KVM_HOST_H
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 65eb45ff1bff..4f27ef70cf2b 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -58,6 +58,7 @@ LIBKVM_x86_64 += lib/x86_64/processor.c
 LIBKVM_x86_64 += lib/x86_64/svm.c
 LIBKVM_x86_64 += lib/x86_64/ucall.c
 LIBKVM_x86_64 += lib/x86_64/vmx.c
+LIBKVM_x86_64 += lib/x86_64/sev.c
 
 LIBKVM_aarch64 += lib/aarch64/gic.c
 LIBKVM_aarch64 += lib/aarch64/gic_v3.c
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 4224026fbe25..8e4ded757a40 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -68,6 +68,13 @@ struct userspace_mem_regions {
 	DECLARE_HASHTABLE(slot_hash, 9);
 };
 
+/* VM protection policy/configuration. */
+struct protected_vm {
+	bool enabled;
+	bool has_protected_bit;
+	int8_t protected_bit;
+};
+
 struct kvm_vm {
 	int mode;
 	unsigned long type;
@@ -670,6 +677,10 @@ static inline vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 	return _vm_phy_pages_alloc(vm, num, paddr_min, memslot, vm->protected);
 }
 
+uint64_t vm_nr_pages_required(enum vm_guest_mode mode,
+			      uint32_t nr_runnable_vcpus,
+			      uint64_t extra_mem_pages);
+
 /*
  * ____vm_create() does KVM_CREATE_VM and little else.  __vm_create() also
  * loads the test binary into guest memory and creates an IRQ chip (x86 only).
@@ -722,8 +733,8 @@ unsigned long vm_compute_max_gfn(struct kvm_vm *vm);
 unsigned int vm_calc_num_guest_pages(enum vm_guest_mode mode, size_t size);
 unsigned int vm_num_host_pages(enum vm_guest_mode mode, unsigned int num_guest_pages);
 unsigned int vm_num_guest_pages(enum vm_guest_mode mode, unsigned int num_host_pages);
-static inline unsigned int
-vm_adjust_num_guest_pages(enum vm_guest_mode mode, unsigned int num_guest_pages)
+static inline unsigned int vm_adjust_num_guest_pages(enum vm_guest_mode mode,
+						     unsigned int num_guest_pages)
 {
 	unsigned int n;
 	n = vm_num_guest_pages(mode, vm_num_host_pages(mode, num_guest_pages));
diff --git a/tools/testing/selftests/kvm/include/x86_64/sev.h b/tools/testing/selftests/kvm/include/x86_64/sev.h
new file mode 100644
index 000000000000..1148db928d0b
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/x86_64/sev.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Helpers used for SEV guests
+ *
+ */
+#ifndef SELFTEST_KVM_SEV_H
+#define SELFTEST_KVM_SEV_H
+
+#include <stdint.h>
+#include <stdbool.h>
+
+#include "kvm_util.h"
+
+#define SEV_POLICY_NO_DBG	(1UL << 0)
+#define SEV_POLICY_ES		(1UL << 2)
+
+bool is_kvm_sev_supported(void);
+
+struct kvm_vm *vm_sev_create_with_one_vcpu(uint32_t policy, void *guest_code,
+					   struct kvm_vcpu **cpu);
+
+#endif /* SELFTEST_KVM_SEV_H */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index d753345993d6..753b8991eff3 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -254,7 +254,7 @@ struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
 		vm->pgtable_levels = 4;
 		vm->va_bits = 48;
 #else
-		TEST_FAIL("VM_MODE_PXXV48_4K not supported on non-x86 platforms");
+		TEST_FAIL("VM_MODE_PXXV48_4K* not supported on non-x86 platforms");
 #endif
 		break;
 	case VM_MODE_P47V64_4K:
@@ -294,7 +294,7 @@ struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
 	return vm;
 }
 
-static uint64_t vm_nr_pages_required(enum vm_guest_mode mode,
+uint64_t vm_nr_pages_required(enum vm_guest_mode mode,
 				     uint32_t nr_runnable_vcpus,
 				     uint64_t extra_mem_pages)
 {
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 377e342ecff7..04a5434ba3dd 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -529,6 +529,10 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 	uint64_t *pml4e, *pdpe, *pde;
 	uint64_t *pte;
 
+	TEST_ASSERT(
+		!vm->arch.is_pt_protected,
+		"Protected guests have their page tables protected so gva2gpa conversions are not possible.");
+
 	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
 		"unknown or unsupported guest mode, mode: 0x%x", vm->mode);
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/sev.c b/tools/testing/selftests/kvm/lib/x86_64/sev.c
new file mode 100644
index 000000000000..faed2ebe63ac
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/x86_64/sev.c
@@ -0,0 +1,243 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Helpers used for SEV guests
+ *
+ */
+
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include <stdint.h>
+#include <stdbool.h>
+
+#include "kvm_util.h"
+#include "svm_util.h"
+#include "linux/psp-sev.h"
+#include "processor.h"
+#include "sev.h"
+
+#define CPUID_MEM_ENC_LEAF 0x8000001f
+#define CPUID_EBX_CBIT_MASK 0x3f
+
+#define SEV_FW_REQ_VER_MAJOR 0
+#define SEV_FW_REQ_VER_MINOR 17
+
+enum sev_guest_state {
+	SEV_GSTATE_UNINIT = 0,
+	SEV_GSTATE_LUPDATE,
+	SEV_GSTATE_LSECRET,
+	SEV_GSTATE_RUNNING,
+};
+
+static void sev_ioctl(int cmd, void *data)
+{
+	int ret;
+	struct sev_issue_cmd arg;
+
+	arg.cmd = cmd;
+	arg.data = (unsigned long)data;
+	ret = ioctl(open_sev_dev_path_or_exit(), SEV_ISSUE_CMD, &arg);
+	TEST_ASSERT(ret == 0, "SEV ioctl %d failed, error: %d, fw_error: %d",
+		    cmd, ret, arg.error);
+}
+
+static void kvm_sev_ioctl(struct kvm_vm *vm, int cmd, void *data)
+{
+	struct kvm_sev_cmd arg = {0};
+	int ret;
+
+	arg.id = cmd;
+	arg.sev_fd = open_sev_dev_path_or_exit();
+	arg.data = (__u64)data;
+
+	ret = ioctl(vm->fd, KVM_MEMORY_ENCRYPT_OP, &arg);
+	TEST_ASSERT(
+		ret == 0,
+		"SEV KVM ioctl %d failed, rc: %i errno: %i (%s), fw_error: %d",
+		cmd, ret, errno, strerror(errno), arg.error);
+}
+
+static void sev_register_user_region(struct kvm_vm *vm, struct userspace_mem_region *region)
+{
+	struct kvm_enc_region range = {0};
+	int ret;
+
+	range.addr = (__u64)region->region.userspace_addr;
+	;
+	range.size = region->region.memory_size;
+
+	ret = ioctl(vm->fd, KVM_MEMORY_ENCRYPT_REG_REGION, &range);
+	TEST_ASSERT(ret == 0, "failed to register user range, errno: %i\n",
+		    errno);
+}
+
+static void sev_launch_update_data(struct kvm_vm *vm, vm_paddr_t gpa, uint64_t size)
+{
+	struct kvm_sev_launch_update_data ksev_update_data = {0};
+
+	pr_debug("%s: addr: 0x%lx, size: %lu\n", __func__, gpa, size);
+
+	ksev_update_data.uaddr = (__u64)addr_gpa2hva(vm, gpa);
+	ksev_update_data.len = size;
+
+	kvm_sev_ioctl(vm, KVM_SEV_LAUNCH_UPDATE_DATA, &ksev_update_data);
+}
+
+static void encrypt_region(struct kvm_vm *vm, struct userspace_mem_region *region)
+{
+	const struct sparsebit *protected_phy_pages =
+		region->protected_phy_pages;
+	const uint64_t memory_size = region->region.memory_size;
+	const vm_paddr_t gpa_start = region->region.guest_phys_addr;
+	sparsebit_idx_t pg = 0;
+
+	sev_register_user_region(vm, region);
+
+	while (pg < (memory_size / vm->page_size)) {
+		sparsebit_idx_t nr_pages;
+
+		if (sparsebit_is_clear(protected_phy_pages, pg)) {
+			pg = sparsebit_next_set(protected_phy_pages, pg);
+			if (!pg)
+				break;
+		}
+
+		nr_pages = sparsebit_next_clear(protected_phy_pages, pg) - pg;
+		if (nr_pages <= 0)
+			nr_pages = 1;
+
+		sev_launch_update_data(vm, gpa_start + pg * vm->page_size,
+				       nr_pages * vm->page_size);
+		pg += nr_pages;
+	}
+}
+
+static void sev_encrypt(struct kvm_vm *vm)
+{
+	int ctr;
+	struct userspace_mem_region *region;
+
+	hash_for_each(vm->regions.slot_hash, ctr, region, slot_node) {
+		encrypt_region(vm, region);
+	}
+
+	vm->arch.is_pt_protected = true;
+}
+
+bool is_kvm_sev_supported(void)
+{
+	struct sev_user_data_status sev_status;
+
+	sev_ioctl(SEV_PLATFORM_STATUS, &sev_status);
+
+	if (!(sev_status.api_major > SEV_FW_REQ_VER_MAJOR ||
+	      (sev_status.api_major == SEV_FW_REQ_VER_MAJOR &&
+	       sev_status.api_minor >= SEV_FW_REQ_VER_MINOR))) {
+		pr_info("SEV FW version too old. Have API %d.%d (build: %d), need %d.%d, skipping test.\n",
+			sev_status.api_major, sev_status.api_minor,
+			sev_status.build, SEV_FW_REQ_VER_MAJOR,
+			SEV_FW_REQ_VER_MINOR);
+		return false;
+	}
+
+	return true;
+}
+
+static void sev_vm_launch(struct kvm_vm *vm, uint32_t policy)
+{
+	struct kvm_sev_launch_start ksev_launch_start = {0};
+	struct kvm_sev_guest_status ksev_status;
+
+	ksev_launch_start.policy = policy;
+	kvm_sev_ioctl(vm, KVM_SEV_LAUNCH_START, &ksev_launch_start);
+	kvm_sev_ioctl(vm, KVM_SEV_GUEST_STATUS, &ksev_status);
+	TEST_ASSERT(ksev_status.policy == policy, "Incorrect guest policy.");
+	TEST_ASSERT(ksev_status.state == SEV_GSTATE_LUPDATE,
+		    "Unexpected guest state: %d", ksev_status.state);
+
+	ucall_init(vm, 0);
+
+	sev_encrypt(vm);
+}
+
+static void sev_vm_launch_measure(struct kvm_vm *vm, uint8_t *measurement)
+{
+	struct kvm_sev_launch_measure ksev_launch_measure;
+	struct kvm_sev_guest_status ksev_guest_status;
+
+	ksev_launch_measure.len = 256;
+	ksev_launch_measure.uaddr = (__u64)measurement;
+	kvm_sev_ioctl(vm, KVM_SEV_LAUNCH_MEASURE, &ksev_launch_measure);
+
+	kvm_sev_ioctl(vm, KVM_SEV_GUEST_STATUS, &ksev_guest_status);
+	TEST_ASSERT(ksev_guest_status.state == SEV_GSTATE_LSECRET,
+		    "Unexpected guest state: %d", ksev_guest_status.state);
+}
+
+static void sev_vm_launch_finish(struct kvm_vm *vm)
+{
+	struct kvm_sev_guest_status ksev_status;
+
+	kvm_sev_ioctl(vm, KVM_SEV_GUEST_STATUS, &ksev_status);
+	TEST_ASSERT(ksev_status.state == SEV_GSTATE_LUPDATE ||
+			    ksev_status.state == SEV_GSTATE_LSECRET,
+		    "Unexpected guest state: %d", ksev_status.state);
+
+	kvm_sev_ioctl(vm, KVM_SEV_LAUNCH_FINISH, NULL);
+
+	kvm_sev_ioctl(vm, KVM_SEV_GUEST_STATUS, &ksev_status);
+	TEST_ASSERT(ksev_status.state == SEV_GSTATE_RUNNING,
+		    "Unexpected guest state: %d", ksev_status.state);
+}
+
+static void configure_sev_pte_masks(struct kvm_vm *vm)
+{
+	uint32_t eax, ebx, ecx, edx, enc_bit;
+
+	cpuid(CPUID_MEM_ENC_LEAF, &eax, &ebx, &ecx, &edx);
+	enc_bit = ebx & CPUID_EBX_CBIT_MASK;
+
+	vm->arch.c_bit = 1 << enc_bit;
+	vm->arch.pte_me_mask = vm->arch.c_bit | vm->arch.s_bit;
+	vm->protected = true;
+}
+
+static void sev_vm_measure(struct kvm_vm *vm)
+{
+	uint8_t measurement[512];
+	int i;
+
+	sev_vm_launch_measure(vm, measurement);
+
+	/* TODO: Validate the measurement is as expected. */
+	pr_debug("guest measurement: ");
+	for (i = 0; i < 32; ++i)
+		pr_debug("%02x", measurement[i]);
+	pr_debug("\n");
+}
+
+struct kvm_vm *vm_sev_create_with_one_vcpu(uint32_t policy, void *guest_code,
+					   struct kvm_vcpu **cpu)
+{
+	enum vm_guest_mode mode = VM_MODE_PXXV48_4K;
+	uint64_t nr_pages = vm_nr_pages_required(mode, 1, 0);
+	struct kvm_vm *vm;
+
+	vm = ____vm_create(mode, nr_pages);
+
+	kvm_sev_ioctl(vm, KVM_SEV_INIT, NULL);
+
+	configure_sev_pte_masks(vm);
+
+	*cpu = vm_vcpu_add(vm, 0, guest_code);
+	kvm_vm_elf_load(vm, program_invocation_name);
+
+	sev_vm_launch(vm, policy);
+
+	sev_vm_measure(vm);
+
+	sev_vm_launch_finish(vm);
+
+	pr_info("SEV guest created, policy: 0x%x, size: %lu KB\n", policy,
+		nr_pages * vm->page_size / 1024);
+
+	return vm;
+}
-- 
2.38.0.413.g74048e4d9e-goog

