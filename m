Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 391C1603480
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 22:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbiJRU7p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 16:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiJRU7e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 16:59:34 -0400
Received: from mail-oa1-x4a.google.com (mail-oa1-x4a.google.com [IPv6:2001:4860:4864:20::4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106CEC1D9B
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 13:59:11 -0700 (PDT)
Received: by mail-oa1-x4a.google.com with SMTP id 586e51a60fabf-13193fb45b9so6532631fac.1
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 13:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oqylZsVtegWBY/vSLJsU224U61TcYtzc2MAlvromGyY=;
        b=nRW/h/U52g0e28hPPRHZidXvY8y+CEzkntU07RTkvXFZ4VT9PjpliUBP2F2iL2G4/r
         w9IBrH2q0ezrMRZi2+krSBRRNmO2qkFcC1vsiFHFY3HiRHvpdS2AAj4nnk8KPd3ZenlR
         SnnlKClc539jmBBmiNXMc1PFbw4xDMIdeLlDMEkby/MsmPLAwYqtA4QN8CxbtWwMro8O
         XNB6T9DzTpPkQYxfsBhMOhig0Md8v4Q1EJds602SRogvCdgD45yU60eoKP6T3AHqxC8A
         VjAShJlGPHlo6f5IxB4bMNd2gND7u/Gu2zT2L/nQA6sbrThOs2q9L9Hr4hv2lBjN6ttZ
         wXPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oqylZsVtegWBY/vSLJsU224U61TcYtzc2MAlvromGyY=;
        b=jrObA1Gg0G0Y9WjnmpyXMvULtLkgAVf2iej11D9FCH373Jh34l6HYTPiOnZwiMr2Ts
         GtzACYVCtwz5VHRXnwsXCSIWFTn+D9MZ0PlOflnb1S2sCzjZ5P2h/n3tbIYTeQO9oMPY
         vgbTGb4vk34vMb5WdxfSPjMLSQS95IOe8jOuRqBhWe07ur9l/Q2uxTgXlbNa1zjfcsvj
         NKZWuaHFw70X/xVUipw0bdTkurkU+6GmUBtG+QfdlyHaWNq5PmtiTiII+qZu1+c2FuFq
         1OY3ktxtOGQL7w1QDsohDfOGdklkKbh5kphKIL9LLFh5xUCneH8trbWjNKyttxIPNQAb
         s/2Q==
X-Gm-Message-State: ACrzQf2HIX6QAp8TeorpPDK1PZzdiBAF5W9FtAZj+X82mp4iRGVx+iDM
        hCstld+TJmADs2NQbs/RMzhsbKxTebYD8IsMYVZ8tOYimd3opvagq31XAT1AnzrBvTEcJZJqX9W
        JvgLSx26PTYMVSyej6D6gmTCKORC4SkBaHALnBsCZPGVxUxjquy4boTYvAA==
X-Google-Smtp-Source: AMsMyM68vjQxBXPqCTGxpc9mKsI0Ul9SndoYroBz5rXwSwUPvj8HAwbq4rbuJOSCAzCwpgcQ2JIb6HJBuKs=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:c89b:7f49:3437:9db8])
 (user=pgonda job=sendgmr) by 2002:a17:90b:692:b0:203:6c21:b4aa with SMTP id
 m18-20020a17090b069200b002036c21b4aamr40162380pjz.227.1666126739717; Tue, 18
 Oct 2022 13:58:59 -0700 (PDT)
Date:   Tue, 18 Oct 2022 13:58:41 -0700
In-Reply-To: <20221018205845.770121-1-pgonda@google.com>
Message-Id: <20221018205845.770121-4-pgonda@google.com>
Mime-Version: 1.0
References: <20221018205845.770121-1-pgonda@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Subject: [PATCH V5 3/7] KVM: selftests: handle protected bits in page tables
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

SEV guests rely on an encyption bit which resides within the range that
current code treats as address bits. Guest code will expect these bits
to be set appropriately in their page tables, whereas the rest of the
kvm_util functions will generally expect these bits to not be present.
Introduce pte_me_mask and struct kvm_vm_arch to allow for arch specific
address tagging. Currently just adding x86 c_bit and s_bit support for
SEV and TDX.

Originally-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 tools/arch/arm64/include/asm/kvm_host.h       |  7 ++++++
 tools/arch/riscv/include/asm/kvm_host.h       |  7 ++++++
 tools/arch/s390/include/asm/kvm_host.h        |  7 ++++++
 tools/arch/x86/include/asm/kvm_host.h         | 14 ++++++++++++
 .../selftests/kvm/include/kvm_util_base.h     | 19 ++++++++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 22 ++++++++++++++++++-
 .../selftests/kvm/lib/x86_64/processor.c      | 19 +++++++++++++---
 7 files changed, 91 insertions(+), 4 deletions(-)
 create mode 100644 tools/arch/arm64/include/asm/kvm_host.h
 create mode 100644 tools/arch/riscv/include/asm/kvm_host.h
 create mode 100644 tools/arch/s390/include/asm/kvm_host.h
 create mode 100644 tools/arch/x86/include/asm/kvm_host.h

diff --git a/tools/arch/arm64/include/asm/kvm_host.h b/tools/arch/arm64/include/asm/kvm_host.h
new file mode 100644
index 000000000000..218f5cdf0d86
--- /dev/null
+++ b/tools/arch/arm64/include/asm/kvm_host.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _TOOLS_LINUX_ASM_ARM64_KVM_HOST_H
+#define _TOOLS_LINUX_ASM_ARM64_KVM_HOST_H
+
+struct kvm_vm_arch {};
+
+#endif  // _TOOLS_LINUX_ASM_ARM64_KVM_HOST_H
diff --git a/tools/arch/riscv/include/asm/kvm_host.h b/tools/arch/riscv/include/asm/kvm_host.h
new file mode 100644
index 000000000000..c8280d5659ce
--- /dev/null
+++ b/tools/arch/riscv/include/asm/kvm_host.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _TOOLS_LINUX_ASM_RISCV_KVM_HOST_H
+#define _TOOLS_LINUX_ASM_RISCV_KVM_HOST_H
+
+struct kvm_vm_arch {};
+
+#endif  // _TOOLS_LINUX_ASM_RISCV_KVM_HOST_H
diff --git a/tools/arch/s390/include/asm/kvm_host.h b/tools/arch/s390/include/asm/kvm_host.h
new file mode 100644
index 000000000000..4c4c1c1e4bf8
--- /dev/null
+++ b/tools/arch/s390/include/asm/kvm_host.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _TOOLS_LINUX_ASM_S390_KVM_HOST_H
+#define _TOOLS_LINUX_ASM_S390_KVM_HOST_H
+
+struct kvm_vm_arch {};
+
+#endif  // _TOOLS_LINUX_ASM_S390_KVM_HOST_H
diff --git a/tools/arch/x86/include/asm/kvm_host.h b/tools/arch/x86/include/asm/kvm_host.h
new file mode 100644
index 000000000000..03153c18c747
--- /dev/null
+++ b/tools/arch/x86/include/asm/kvm_host.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _TOOLS_LINUX_ASM_X86_KVM_HOST_H
+#define _TOOLS_LINUX_ASM_X86_KVM_HOST_H
+
+#include <stdbool.h>
+#include <stdint.h>
+
+struct kvm_vm_arch {
+	uint64_t pte_me_mask;
+	uint64_t c_bit;
+	uint64_t s_bit;
+};
+
+#endif  // _TOOLS_LINUX_ASM_X86_KVM_HOST_H
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 625f13cf3b58..9aacc6110d09 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -17,6 +17,8 @@
 #include "linux/rbtree.h"
 
 #include <asm/atomic.h>
+#include <asm/kvm.h>
+#include <asm/kvm_host.h>
 
 #include <sys/ioctl.h>
 
@@ -90,6 +92,9 @@ struct kvm_vm {
 	vm_vaddr_t idt;
 	vm_vaddr_t handlers;
 	uint32_t dirty_ring_size;
+	uint64_t gpa_protected_mask;
+
+	struct kvm_vm_arch arch;
 
 	/* VM protection enabled: SEV, etc*/
 	bool protected;
@@ -127,6 +132,7 @@ enum vm_guest_mode {
 	VM_MODE_P40V48_16K,
 	VM_MODE_P40V48_64K,
 	VM_MODE_PXXV48_4K,	/* For 48bits VA but ANY bits PA */
+	VM_MODE_PXXV48_4K_SEV,	/* For 48bits VA but ANY bits PA */
 	VM_MODE_P47V64_4K,
 	VM_MODE_P44V64_4K,
 	VM_MODE_P36V48_4K,
@@ -400,6 +406,17 @@ void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva);
 vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva);
 void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa);
 
+
+static inline vm_paddr_t vm_untag_gpa(struct kvm_vm *vm, vm_paddr_t gpa)
+{
+	return gpa & ~vm->gpa_protected_mask;
+}
+
+static inline vm_paddr_t vm_tag_gpa(struct kvm_vm *vm, vm_paddr_t gpa)
+{
+	return gpa | vm->gpa_protected_mask;
+}
+
 void vcpu_run(struct kvm_vcpu *vcpu);
 int _vcpu_run(struct kvm_vcpu *vcpu);
 
@@ -863,4 +880,6 @@ static inline int __vm_disable_nx_huge_pages(struct kvm_vm *vm)
 	return __vm_enable_cap(vm, KVM_CAP_VM_DISABLE_NX_HUGE_PAGES, 0);
 }
 
+bool vm_is_gpa_protected(struct kvm_vm *vm, vm_paddr_t paddr);
+
 #endif /* SELFTEST_KVM_UTIL_BASE_H */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 0ce5cdb52f0c..f5f18a802434 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1363,9 +1363,10 @@ void virt_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
  * address providing the memory to the vm physical address is returned.
  * A TEST_ASSERT failure occurs if no region containing gpa exists.
  */
-void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa)
+void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa_tagged)
 {
 	struct userspace_mem_region *region;
+	vm_paddr_t gpa = vm_untag_gpa(vm, gpa_tagged);
 
 	region = userspace_mem_region_find(vm, gpa, gpa);
 	if (!region) {
@@ -2042,3 +2043,22 @@ void __vm_get_stat(struct kvm_vm *vm, const char *stat_name, uint64_t *data,
 		break;
 	}
 }
+
+bool vm_is_gpa_protected(struct kvm_vm *vm, vm_paddr_t paddr)
+{
+	sparsebit_idx_t pg = 0;
+	struct userspace_mem_region *region;
+
+	if (!vm->protected)
+		return false;
+
+	region = userspace_mem_region_find(vm, paddr, paddr);
+	if (!region) {
+		TEST_FAIL("No vm physical memory at 0x%lx", paddr);
+		return false;
+	}
+
+	pg = paddr >> vm->page_shift;
+	return sparsebit_is_set(region->protected_phy_pages, pg);
+
+}
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 39c4409ef56a..377e342ecff7 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -127,6 +127,8 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 	/* If needed, create page map l4 table. */
 	if (!vm->pgd_created) {
 		vm->pgd = vm_alloc_page_table(vm);
+		vm->pgd |= vm->arch.pte_me_mask;
+
 		vm->pgd_created = true;
 	}
 }
@@ -148,13 +150,17 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
 				       int target_level)
 {
 	uint64_t *pte = virt_get_pte(vm, pt_pfn, vaddr, current_level);
+	uint64_t paddr_raw = vm_untag_gpa(vm, paddr);
 
 	if (!(*pte & PTE_PRESENT_MASK)) {
 		*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK;
 		if (current_level == target_level)
-			*pte |= PTE_LARGE_MASK | (paddr & PHYSICAL_PAGE_MASK);
-		else
+			*pte |= PTE_LARGE_MASK | (paddr_raw & PHYSICAL_PAGE_MASK);
+		else {
 			*pte |= vm_alloc_page_table(vm) & PHYSICAL_PAGE_MASK;
+			*pte |= vm->arch.pte_me_mask;
+		}
+
 	} else {
 		/*
 		 * Entry already present.  Assert that the caller doesn't want
@@ -192,6 +198,8 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 		    "Physical address beyond maximum supported,\n"
 		    "  paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
 		    paddr, vm->max_gfn, vm->page_size);
+	TEST_ASSERT(vm_untag_gpa(vm, paddr) == paddr,
+		    "Unexpected bits in paddr: %lx", paddr);
 
 	/*
 	 * Allocate upper level page tables, if not already present.  Return
@@ -215,6 +223,11 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 	TEST_ASSERT(!(*pte & PTE_PRESENT_MASK),
 		    "PTE already present for 4k page at vaddr: 0x%lx\n", vaddr);
 	*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK | (paddr & PHYSICAL_PAGE_MASK);
+
+	if (vm_is_gpa_protected(vm, paddr))
+		*pte |= vm->arch.c_bit;
+	else
+		*pte |= vm->arch.s_bit;
 }
 
 void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
@@ -542,7 +555,7 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 	if (!(pte[index[0]] & PTE_PRESENT_MASK))
 		goto unmapped_gva;
 
-	return (PTE_GET_PFN(pte[index[0]]) * vm->page_size) + (gva & ~PAGE_MASK);
+	return vm_untag_gpa(vm, PTE_GET_PFN(pte[index[0]]) * vm->page_size) + (gva & ~PAGE_MASK);
 
 unmapped_gva:
 	TEST_FAIL("No mapping for vm virtual address, gva: 0x%lx", gva);
-- 
2.38.0.413.g74048e4d9e-goog

