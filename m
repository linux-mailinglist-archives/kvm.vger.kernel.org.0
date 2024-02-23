Return-Path: <kvm+bounces-9456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AD3528607D3
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 01:45:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1A8991F24E1B
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 00:45:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F16412B6C;
	Fri, 23 Feb 2024 00:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TLHF0+dY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B779611705
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 00:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708648997; cv=none; b=Su1wB2AYTF8+yPPi5qvRolpePspC/VPEPgtJPbByBeUrXxtcjm7ZZ9RS8Sa0zKr3C4DUpp1Zelf6LK4T/RSswPRFQG5cfSEaYpjd2ZSvJWrc16s6/Vs/xfCbFlgyBzdfFer5jZWioNfTuRDrkE9QSzYH6/rXSIggIppQfyktCmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708648997; c=relaxed/simple;
	bh=lmObn+99bRFIPg/jYAV295z2lJEvLtzb/rpu32UHeHI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rro+XfvARgZtw78pap2n7F2K4uxc3pMi7k0JD7OR6e1rmvaJ6QhOq8mEM1CXoXNNu8miTFFeTj+3to15vPXkmOFAhkmo0+j10lT5eIuISwryhV0yNfni6CtZ51HqgWSFcXAXdxxP1eXIouR9gaB11BtmRbmPGtF2tz1LbgsauNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TLHF0+dY; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6e4cce1df30so150876b3a.2
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 16:43:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708648995; x=1709253795; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=5xSck0kmkPmdifT3b5IqGmDzhnUFDNPygC9r66kostc=;
        b=TLHF0+dY1tlKySZoKw8EtlsyocNA2eHRoxtykNArX4ohS0YBrSeOshMf8QwDEHzRhw
         96GawnInAnQH+OQuK4neFpdIitiYrfytJ1fjV799wKbZMjA9iGsN+CJibBU20lyJodkJ
         WqWah5xB6D71N/vHUa3XKOHl7opo1RbTLEsR1fFTEzUw/03EEdNi3F1dnTkX5/VY4BcQ
         cdmFX8K+SqJjLLFIc91x1ISVwp8X0SNyK+9Q6TrfcKXbFKRRn0et8hVBKubY3Xv2FwTS
         TIZjk5QQWpR6iQYjo0RczepaWWp6VmHhoyoMBDildJr6JAV81MpgnWRGy6zpyqPU+mWD
         IjxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708648995; x=1709253795;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5xSck0kmkPmdifT3b5IqGmDzhnUFDNPygC9r66kostc=;
        b=I29LTwZc4ErhP1GDTzTIb/mZkuhHFPcxdfDnR9rEYcA015ghfl0dPG+L6GfnxB5cCd
         ZoEs8AH3OUcTdNdGc7vFG+0g6k5DG1qk7AOrHBrz1LCeINRzEkiLszPkYVettZguFxj9
         TLRNjAG/UsYBJGyFWRhEtN9xN2xigs8MAe4WGHinTpjSQQCGbr+fhOFlT9NyYegvKaoU
         /PFIWpPipOltoSO0YKc7oaXz9rMFnTW7OBW87gFczhaX5gNlxeVjx8eB9NXDvBOYc+xI
         uPQUFSsAnpW9NM/oq3IIlwHmWdGbh8hiXWWBAqVavZPWzEBF5k2q8OUE93ec0hRhwDA5
         kJxg==
X-Gm-Message-State: AOJu0Yx/7buuc75AtkvEJJso6ad/f+V+pxbK0KE3c8+D/fyLCo0G5d59
	vryO7YxF46foat0z8DoSDrtL0O2AOjVKzKAdKT0frR1jS/7dW7Hzdf2AOx65JmgqtVVctBPPDBO
	/wA==
X-Google-Smtp-Source: AGHT+IFB6M2rOVCDVxCF+KOWKQZKQwIJ1lp1wD007XU4N9VSw/D1xYHfznSXOlgl1HSeFtLBBbcKp5MS4rw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:23c7:b0:6e4:d2ba:b4c4 with SMTP id
 g7-20020a056a0023c700b006e4d2bab4c4mr40112pfc.3.1708648995172; Thu, 22 Feb
 2024 16:43:15 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 Feb 2024 16:42:54 -0800
In-Reply-To: <20240223004258.3104051-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240223004258.3104051-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240223004258.3104051-8-seanjc@google.com>
Subject: [PATCH v9 07/11] KVM: selftests: Allow tagging protected memory in
 guest page tables
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Andrew Jones <andrew.jones@linux.dev>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Carlos Bilbao <carlos.bilbao@amd.com>, 
	Peter Gonda <pgonda@google.com>, Itaru Kitayama <itaru.kitayama@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"

From: Peter Gonda <pgonda@google.com>

Add support for tagging and untagging guest physical address, e.g. to
allow x86's SEV and TDX guests to embed shared vs. private information in
the GPA.  SEV (encryption, a.k.a. C-bit) and TDX (shared, a.k.a. S-bit)
steal bits from the guest's physical address space that is consumed by the
CPU metadata, i.e. effectively aliases the "real" GPA.

Implement generic "tagging" so that the shared vs. private metadata can be
managed by x86 without bleeding too many details into common code.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerly Tng <ackerleytng@google.com>
cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>
Tested-by: Carlos Bilbao <carlos.bilbao@amd.com>
Originally-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../kvm/include/aarch64/kvm_util_arch.h       |  7 +++++++
 .../selftests/kvm/include/kvm_util_base.h     | 13 ++++++++++++
 .../kvm/include/riscv/kvm_util_arch.h         |  7 +++++++
 .../kvm/include/s390x/kvm_util_arch.h         |  7 +++++++
 .../kvm/include/x86_64/kvm_util_arch.h        | 21 +++++++++++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 17 +++++++++++++++
 .../selftests/kvm/lib/x86_64/processor.c      | 15 ++++++++++++-
 7 files changed, 86 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/kvm_util_arch.h
 create mode 100644 tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h
 create mode 100644 tools/testing/selftests/kvm/include/s390x/kvm_util_arch.h
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h

diff --git a/tools/testing/selftests/kvm/include/aarch64/kvm_util_arch.h b/tools/testing/selftests/kvm/include/aarch64/kvm_util_arch.h
new file mode 100644
index 000000000000..218f5cdf0d86
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/aarch64/kvm_util_arch.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _TOOLS_LINUX_ASM_ARM64_KVM_HOST_H
+#define _TOOLS_LINUX_ASM_ARM64_KVM_HOST_H
+
+struct kvm_vm_arch {};
+
+#endif  // _TOOLS_LINUX_ASM_ARM64_KVM_HOST_H
diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index cb3159af6db3..4b266dc0c9bd 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -18,9 +18,11 @@
 #include <linux/types.h>
 
 #include <asm/atomic.h>
+#include <asm/kvm.h>
 
 #include <sys/ioctl.h>
 
+#include "kvm_util_arch.h"
 #include "sparsebit.h"
 
 /*
@@ -113,6 +115,9 @@ struct kvm_vm {
 	vm_vaddr_t idt;
 	vm_vaddr_t handlers;
 	uint32_t dirty_ring_size;
+	uint64_t gpa_tag_mask;
+
+	struct kvm_vm_arch arch;
 
 	/* Cache of information for binary stats interface */
 	int stats_fd;
@@ -605,6 +610,12 @@ void *addr_gva2hva(struct kvm_vm *vm, vm_vaddr_t gva);
 vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva);
 void *addr_gpa2alias(struct kvm_vm *vm, vm_paddr_t gpa);
 
+
+static inline vm_paddr_t vm_untag_gpa(struct kvm_vm *vm, vm_paddr_t gpa)
+{
+	return gpa & ~vm->gpa_tag_mask;
+}
+
 void vcpu_run(struct kvm_vcpu *vcpu);
 int _vcpu_run(struct kvm_vcpu *vcpu);
 
@@ -1114,4 +1125,6 @@ void kvm_selftest_arch_init(void);
 
 void kvm_arch_vm_post_create(struct kvm_vm *vm);
 
+bool vm_is_gpa_protected(struct kvm_vm *vm, vm_paddr_t paddr);
+
 #endif /* SELFTEST_KVM_UTIL_BASE_H */
diff --git a/tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h b/tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h
new file mode 100644
index 000000000000..c8280d5659ce
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/riscv/kvm_util_arch.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _TOOLS_LINUX_ASM_RISCV_KVM_HOST_H
+#define _TOOLS_LINUX_ASM_RISCV_KVM_HOST_H
+
+struct kvm_vm_arch {};
+
+#endif  // _TOOLS_LINUX_ASM_RISCV_KVM_HOST_H
diff --git a/tools/testing/selftests/kvm/include/s390x/kvm_util_arch.h b/tools/testing/selftests/kvm/include/s390x/kvm_util_arch.h
new file mode 100644
index 000000000000..4c4c1c1e4bf8
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/s390x/kvm_util_arch.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _TOOLS_LINUX_ASM_S390_KVM_HOST_H
+#define _TOOLS_LINUX_ASM_S390_KVM_HOST_H
+
+struct kvm_vm_arch {};
+
+#endif  // _TOOLS_LINUX_ASM_S390_KVM_HOST_H
diff --git a/tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h b/tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h
new file mode 100644
index 000000000000..17bb38236d97
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/x86_64/kvm_util_arch.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _TOOLS_LINUX_ASM_X86_KVM_HOST_H
+#define _TOOLS_LINUX_ASM_X86_KVM_HOST_H
+
+#include <stdbool.h>
+#include <stdint.h>
+
+struct kvm_vm_arch {
+	uint64_t c_bit;
+	uint64_t s_bit;
+};
+
+static inline bool __vm_arch_has_protected_memory(struct kvm_vm_arch *arch)
+{
+	return arch->c_bit || arch->s_bit;
+}
+
+#define vm_arch_has_protected_memory(vm) \
+	__vm_arch_has_protected_memory(&(vm)->arch)
+
+#endif  // _TOOLS_LINUX_ASM_X86_KVM_HOST_H
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index e7f4f84f2e68..19511137d1ae 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1597,6 +1597,8 @@ void *addr_gpa2hva(struct kvm_vm *vm, vm_paddr_t gpa)
 {
 	struct userspace_mem_region *region;
 
+	gpa = vm_untag_gpa(vm, gpa);
+
 	region = userspace_mem_region_find(vm, gpa, gpa);
 	if (!region) {
 		TEST_FAIL("No vm physical memory at 0x%lx", gpa);
@@ -2305,3 +2307,18 @@ void __attribute((constructor)) kvm_selftest_init(void)
 
 	kvm_selftest_arch_init();
 }
+
+bool vm_is_gpa_protected(struct kvm_vm *vm, vm_paddr_t paddr)
+{
+	sparsebit_idx_t pg = 0;
+	struct userspace_mem_region *region;
+
+	if (!vm_arch_has_protected_memory(vm))
+		return false;
+
+	region = userspace_mem_region_find(vm, paddr, paddr);
+	TEST_ASSERT(region, "No vm physical memory at 0x%lx", paddr);
+
+	pg = paddr >> vm->page_shift;
+	return sparsebit_is_set(region->protected_phy_pages, pg);
+}
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 615d05247470..6c1d2c0ec584 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -157,6 +157,8 @@ static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
 {
 	uint64_t *pte = virt_get_pte(vm, parent_pte, vaddr, current_level);
 
+	paddr = vm_untag_gpa(vm, paddr);
+
 	if (!(*pte & PTE_PRESENT_MASK)) {
 		*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK;
 		if (current_level == target_level)
@@ -200,6 +202,8 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 		    "Physical address beyond maximum supported,\n"
 		    "  paddr: 0x%lx vm->max_gfn: 0x%lx vm->page_size: 0x%x",
 		    paddr, vm->max_gfn, vm->page_size);
+	TEST_ASSERT(vm_untag_gpa(vm, paddr) == paddr,
+		    "Unexpected bits in paddr: %lx", paddr);
 
 	/*
 	 * Allocate upper level page tables, if not already present.  Return
@@ -222,6 +226,15 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 	TEST_ASSERT(!(*pte & PTE_PRESENT_MASK),
 		    "PTE already present for 4k page at vaddr: 0x%lx", vaddr);
 	*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK | (paddr & PHYSICAL_PAGE_MASK);
+
+	/*
+	 * Neither SEV nor TDX supports shared page tables, so only the final
+	 * leaf PTE needs manually set the C/S-bit.
+	 */
+	if (vm_is_gpa_protected(vm, paddr))
+		*pte |= vm->arch.c_bit;
+	else
+		*pte |= vm->arch.s_bit;
 }
 
 void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
@@ -496,7 +509,7 @@ vm_paddr_t addr_arch_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva)
 	 * No need for a hugepage mask on the PTE, x86-64 requires the "unused"
 	 * address bits to be zero.
 	 */
-	return PTE_GET_PA(*pte) | (gva & ~HUGEPAGE_MASK(level));
+	return vm_untag_gpa(vm, PTE_GET_PA(*pte)) | (gva & ~HUGEPAGE_MASK(level));
 }
 
 static void kvm_setup_gdt(struct kvm_vm *vm, struct kvm_dtable *dt)
-- 
2.44.0.rc0.258.g7320e95886-goog


