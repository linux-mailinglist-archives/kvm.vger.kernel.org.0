Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42D33163592
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 22:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbgBRV6h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 16:58:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:52969 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728065AbgBRV6e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 16:58:34 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 13:58:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,458,1574150400"; 
   d="scan'208";a="436004649"
Received: from gza.jf.intel.com ([10.54.75.28])
  by fmsmga006.fm.intel.com with ESMTP; 18 Feb 2020 13:58:33 -0800
From:   John Andersen <john.s.andersen@intel.com>
To:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        pbonzini@redhat.com
Cc:     hpa@zytor.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        liran.alon@oracle.com, luto@kernel.org, joro@8bytes.org,
        rick.p.edgecombe@intel.com, kristen@linux.intel.com,
        arjan@linux.intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, John Andersen <john.s.andersen@intel.com>
Subject: [RFC v2 3/4] selftests: kvm: add test for CR pinning with SMM
Date:   Tue, 18 Feb 2020 13:59:01 -0800
Message-Id: <20200218215902.5655-4-john.s.andersen@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200218215902.5655-1-john.s.andersen@intel.com>
References: <20200218215902.5655-1-john.s.andersen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check that paravirtualized control register pinning blocks modifications
of pinned CR values stored in SMRAM on exit from SMM.

Signed-off-by: John Andersen <john.s.andersen@intel.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/include/x86_64/processor.h  |   9 +
 .../selftests/kvm/x86_64/smm_cr_pin_test.c    | 180 ++++++++++++++++++
 4 files changed, 191 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86_64/smm_cr_pin_test.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 30072c3f52fb..08e18ae1b80f 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -7,6 +7,7 @@
 /x86_64/platform_info_test
 /x86_64/set_sregs_test
 /x86_64/smm_test
+/x86_64/smm_cr_pin_test
 /x86_64/state_test
 /x86_64/sync_regs_test
 /x86_64/vmx_close_while_nested_test
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index d91c53b726e6..f3fdac72fc74 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -19,6 +19,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/mmio_warning_test
 TEST_GEN_PROGS_x86_64 += x86_64/platform_info_test
 TEST_GEN_PROGS_x86_64 += x86_64/set_sregs_test
 TEST_GEN_PROGS_x86_64 += x86_64/smm_test
+TEST_GEN_PROGS_x86_64 += x86_64/smm_cr_pin_test
 TEST_GEN_PROGS_x86_64 += x86_64/state_test
 TEST_GEN_PROGS_x86_64 += x86_64/sync_regs_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 7428513a4c68..70394d2ffa5d 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -197,6 +197,11 @@ static inline uint64_t get_cr0(void)
 	return cr0;
 }
 
+static inline void set_cr0(uint64_t val)
+{
+	__asm__ __volatile__("mov %0, %%cr0" : : "r" (val) : "memory");
+}
+
 static inline uint64_t get_cr3(void)
 {
 	uint64_t cr3;
@@ -380,4 +385,8 @@ void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits);
 /* VMX_EPT_VPID_CAP bits */
 #define VMX_EPT_VPID_CAP_AD_BITS       (1ULL << 21)
 
+/* KVM MSRs */
+#define MSR_KVM_CR0_PINNED	0x4b564d08
+#define MSR_KVM_CR4_PINNED	0x4b564d09
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/x86_64/smm_cr_pin_test.c b/tools/testing/selftests/kvm/x86_64/smm_cr_pin_test.c
new file mode 100644
index 000000000000..013983bb4ba4
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/smm_cr_pin_test.c
@@ -0,0 +1,180 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Tests for control register pinning not being affected by SMRAM writes.
+ */
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <string.h>
+#include <sys/ioctl.h>
+
+#include "test_util.h"
+
+#include "kvm_util.h"
+
+#include "processor.h"
+
+#define VCPU_ID	      1
+
+#define PAGE_SIZE  4096
+
+#define SMRAM_SIZE 65536
+#define SMRAM_MEMSLOT ((1 << 16) | 1)
+#define SMRAM_PAGES (SMRAM_SIZE / PAGE_SIZE)
+#define SMRAM_GPA 0x1000000
+#define SMRAM_STAGE 0xfe
+
+#define STR(x) #x
+#define XSTR(s) STR(s)
+
+#define SYNC_PORT 0xe
+#define DONE 0xff
+
+#define CR0_PINNED X86_CR0_WP
+#define CR4_PINNED (X86_CR4_SMAP | X86_CR4_UMIP)
+#define CR4_ALL (CR4_PINNED | X86_CR4_SMEP)
+
+/*
+ * This is compiled as normal 64-bit code, however, SMI handler is executed
+ * in real-address mode. To stay simple we're limiting ourselves to a mode
+ * independent subset of asm here.
+ * SMI handler always report back fixed stage SMRAM_STAGE.
+ */
+uint8_t smi_handler[] = {
+	0xb0, SMRAM_STAGE,    /* mov $SMRAM_STAGE, %al */
+	0xe4, SYNC_PORT,      /* in $SYNC_PORT, %al */
+	0x0f, 0xaa,           /* rsm */
+};
+
+void sync_with_host(uint64_t phase)
+{
+	asm volatile("in $" XSTR(SYNC_PORT)", %%al \n"
+		     : : "a" (phase));
+}
+
+void self_smi(void)
+{
+	wrmsr(APIC_BASE_MSR + (APIC_ICR >> 4),
+	      APIC_DEST_SELF | APIC_INT_ASSERT | APIC_DM_SMI);
+}
+
+void guest_code(void *unused)
+{
+	uint64_t apicbase = rdmsr(MSR_IA32_APICBASE);
+
+	(void)unused;
+
+	sync_with_host(1);
+
+	wrmsr(MSR_IA32_APICBASE, apicbase | X2APIC_ENABLE);
+
+	sync_with_host(2);
+
+	set_cr0(get_cr0() | CR0_PINNED);
+
+	wrmsr(MSR_KVM_CR0_PINNED, CR0_PINNED);
+
+	sync_with_host(3);
+
+	set_cr4(get_cr4() | CR4_PINNED);
+
+	sync_with_host(4);
+
+	/* Pin SMEP low */
+	wrmsr(MSR_KVM_CR4_PINNED, CR4_PINNED);
+
+	sync_with_host(5);
+
+	self_smi();
+
+	sync_with_host(DONE);
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_regs regs;
+	struct kvm_sregs sregs;
+	struct kvm_vm *vm;
+	struct kvm_run *run;
+	struct kvm_x86_state *state;
+	int stage, stage_reported;
+	u64 *cr;
+
+	/* Create VM */
+	vm = vm_create_default(VCPU_ID, 0, guest_code);
+
+	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+
+	run = vcpu_state(vm, VCPU_ID);
+
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, SMRAM_GPA,
+				    SMRAM_MEMSLOT, SMRAM_PAGES, 0);
+	TEST_ASSERT(vm_phy_pages_alloc(vm, SMRAM_PAGES, SMRAM_GPA, SMRAM_MEMSLOT)
+		    == SMRAM_GPA, "could not allocate guest physical addresses?");
+
+	memset(addr_gpa2hva(vm, SMRAM_GPA), 0x0, SMRAM_SIZE);
+	memcpy(addr_gpa2hva(vm, SMRAM_GPA) + 0x8000, smi_handler,
+	       sizeof(smi_handler));
+
+	vcpu_set_msr(vm, VCPU_ID, MSR_IA32_SMBASE, SMRAM_GPA);
+
+	vcpu_args_set(vm, VCPU_ID, 1, 0);
+
+	for (stage = 1;; stage++) {
+		_vcpu_run(vm, VCPU_ID);
+
+		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+			    "Stage %d: unexpected exit reason: %u (%s),\n",
+			    stage, run->exit_reason,
+			    exit_reason_str(run->exit_reason));
+
+		memset(&regs, 0, sizeof(regs));
+		vcpu_regs_get(vm, VCPU_ID, &regs);
+
+		memset(&sregs, 0, sizeof(sregs));
+		vcpu_sregs_get(vm, VCPU_ID, &sregs);
+
+		stage_reported = regs.rax & 0xff;
+
+		if (stage_reported == DONE) {
+			TEST_ASSERT((sregs.cr0 & CR0_PINNED) == CR0_PINNED,
+				    "Unexpected cr0. Bits missing: %llx",
+				    sregs.cr0 ^ (CR0_PINNED | sregs.cr0));
+			TEST_ASSERT((sregs.cr4 & CR4_ALL) == CR4_PINNED,
+				    "Unexpected cr4. Bits missing: %llx, cr4: %llx",
+				    sregs.cr4 ^ (CR4_ALL | sregs.cr4),
+				    sregs.cr4);
+			goto done;
+		}
+
+		TEST_ASSERT(stage_reported == stage ||
+			    stage_reported == SMRAM_STAGE,
+			    "Unexpected stage: #%x, got %x",
+			    stage, stage_reported);
+
+		/* Within SMM modify CR0/4 to not contain pinned bits. */
+		if (stage_reported == SMRAM_STAGE) {
+			cr = (u64 *)(addr_gpa2hva(vm, SMRAM_GPA + 0x8000 + 0x7f58));
+			*cr &= ~CR0_PINNED;
+
+			cr = (u64 *)(addr_gpa2hva(vm, SMRAM_GPA + 0x8000 + 0x7f48));
+			/* Unset pinned, set one that was pinned low */
+			*cr &= ~CR4_PINNED;
+			*cr |= X86_CR4_SMEP;
+		}
+
+		state = vcpu_save_state(vm, VCPU_ID);
+		kvm_vm_release(vm);
+		kvm_vm_restart(vm, O_RDWR);
+		vm_vcpu_add(vm, VCPU_ID);
+		vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+		vcpu_load_state(vm, VCPU_ID, state);
+		run = vcpu_state(vm, VCPU_ID);
+		free(state);
+	}
+
+done:
+	kvm_vm_free(vm);
+}
-- 
2.21.0

