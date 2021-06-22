Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4361C3B0E3A
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 22:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbhFVUIh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 16:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233074AbhFVUIW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 16:08:22 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACE6C0613A2
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 13:06:05 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id r8-20020a0562140c88b0290242bf8596feso330297qvr.8
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 13:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=hugxhKQhauFR3I0guQ9wYlQek+dQcx4V3so6DCnGCGE=;
        b=dhsifGvlL19vWStFz7Qr8f4VNFS34Vojr9pT+9HrBzSoFl+S8opYsHHOlUirrJnWAg
         b3jQ0ONrn4RCxmookwcnxySNdA8+Ij8a8loyMJSY59f3S+2xXNCMH8XmdqVpEJ0gcJew
         3HEZsooI0/T1Jfcjbe1jawKyisBCYLEU/cbrY4oFObxABiw0kwPxucIiD2mt291g/p86
         5tRyPR4D0T6yQe2DSOYb5cVqYX3gTbfkulzQw38+FpqpxInBx7iFXpkN1TSPOsampgJu
         i/n7YOZUT0ODbSiGKOeqy57A7wAWbmGDTqlD0I3ewgM7FQGAWSpFdAAFm7x8nwIdjMTT
         4SmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=hugxhKQhauFR3I0guQ9wYlQek+dQcx4V3so6DCnGCGE=;
        b=PcpzgtY/eVDp7dQ+ivWz4ZcAtoGdvHtmzrP2308UTq5BIVHerCY0sitG82tBOZ8wvz
         ysnEPWYvLuqa4MxU+7AVuJZXX73jVI8MuO4Chfbzj/YkJTmpV6FX4CbwrgJnmFGHOpZC
         V0LJc0NAAvOQUdgdcP1tEY/ajCZN4RlZzMT/qJ135fD7djV5por7HVTmBeFTbEuMhd1p
         Pj0auCHGA+foD5yYObYx5hVZ8juWED6oOBz7tU5ZgkJ75Q5XaWjKVDF8o4ZDiTAIuvkx
         obRlnjwzZe1p2cTYSrQRuPzjDX+H6rPGcvtS8/sxHN1XoiZU50SsSEWBfwKItDtfyH+7
         nB5A==
X-Gm-Message-State: AOAM531SHDvkz5CqA5SqtmsN4M0aSQR/a8wYjfzcwIrIhZ4o5Adc+dGZ
        Zo3bInXQLyNoBuXK4wmSeakV45FRGkY=
X-Google-Smtp-Source: ABdhPJwZ3D3BgF8K6rS1PCuptRNFKR3Dsk0rB1cQ28unHDcaLJgjxX4AlBzEa3wJFEaJioe7/GmzyUP9GOE=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:7d90:4528:3c45:18fb])
 (user=seanjc job=sendgmr) by 2002:a25:d18d:: with SMTP id i135mr7151734ybg.262.1624392364179;
 Tue, 22 Jun 2021 13:06:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 13:05:21 -0700
In-Reply-To: <20210622200529.3650424-1-seanjc@google.com>
Message-Id: <20210622200529.3650424-12-seanjc@google.com>
Mime-Version: 1.0
References: <20210622200529.3650424-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 11/19] KVM: selftest: Unconditionally use memslot 0 for vaddr allocations
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the memslot param(s) from vm_vaddr_alloc() now that all callers
directly specific '0' as the memslot.  Drop the memslot param from
virt_pgd_alloc() as well since vm_vaddr_alloc() is its only user.
I.e. shove the hardcoded '0' down to the vm_phy_pages_alloc() calls.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h      |  5 ++---
 tools/testing/selftests/kvm/lib/aarch64/processor.c |  6 +++---
 tools/testing/selftests/kvm/lib/elf.c               |  2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c          | 12 +++++-------
 tools/testing/selftests/kvm/lib/s390x/processor.c   |  6 +++---
 tools/testing/selftests/kvm/lib/x86_64/processor.c  |  6 +++---
 tools/testing/selftests/kvm/x86_64/get_cpuid_test.c |  2 +-
 7 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 70385bf25446..72cdd4d0a6ee 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -140,8 +140,7 @@ void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
 void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
 void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
 void vm_vcpu_add(struct kvm_vm *vm, uint32_t vcpuid);
-vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
-			  uint32_t data_memslot, uint32_t pgd_memslot);
+vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min);
 vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages);
 vm_vaddr_t vm_vaddr_alloc_page(struct kvm_vm *vm);
 
@@ -239,7 +238,7 @@ int kvm_device_access(int dev_fd, uint32_t group, uint64_t attr,
 
 const char *exit_reason_str(unsigned int exit_reason);
 
-void virt_pgd_alloc(struct kvm_vm *vm, uint32_t pgd_memslot);
+void virt_pgd_alloc(struct kvm_vm *vm);
 
 /*
  * VM Virtual Page Map
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index cee92d477dc0..eb079d828b36 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -72,12 +72,12 @@ static uint64_t __maybe_unused ptrs_per_pte(struct kvm_vm *vm)
 	return 1 << (vm->page_shift - 3);
 }
 
-void virt_pgd_alloc(struct kvm_vm *vm, uint32_t pgd_memslot)
+void virt_pgd_alloc(struct kvm_vm *vm)
 {
 	if (!vm->pgd_created) {
 		vm_paddr_t paddr = vm_phy_pages_alloc(vm,
 			page_align(vm, ptrs_per_pgd(vm) * 8) / vm->page_size,
-			KVM_GUEST_PAGE_TABLE_MIN_PADDR, pgd_memslot);
+			KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
 		vm->pgd = paddr;
 		vm->pgd_created = true;
 	}
@@ -302,7 +302,7 @@ void aarch64_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid,
 					DEFAULT_STACK_PGS * vm->page_size :
 					vm->page_size;
 	uint64_t stack_vaddr = vm_vaddr_alloc(vm, stack_size,
-					DEFAULT_ARM64_GUEST_STACK_VADDR_MIN, 0, 0);
+					      DEFAULT_ARM64_GUEST_STACK_VADDR_MIN);
 
 	vm_vcpu_add(vm, vcpuid);
 	aarch64_vcpu_setup(vm, vcpuid, init);
diff --git a/tools/testing/selftests/kvm/lib/elf.c b/tools/testing/selftests/kvm/lib/elf.c
index edeeaf73d3b1..eac44f5d0db0 100644
--- a/tools/testing/selftests/kvm/lib/elf.c
+++ b/tools/testing/selftests/kvm/lib/elf.c
@@ -163,7 +163,7 @@ void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename)
 		seg_vend |= vm->page_size - 1;
 		size_t seg_size = seg_vend - seg_vstart + 1;
 
-		vm_vaddr_t vaddr = vm_vaddr_alloc(vm, seg_size, seg_vstart, 0, 0);
+		vm_vaddr_t vaddr = vm_vaddr_alloc(vm, seg_size, seg_vstart);
 		TEST_ASSERT(vaddr == seg_vstart, "Unable to allocate "
 			"virtual memory for segment at requested min addr,\n"
 			"  segment idx: %u\n"
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 26db0e6aa329..541315dc230f 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1251,15 +1251,13 @@ static vm_vaddr_t vm_vaddr_unused_gap(struct kvm_vm *vm, size_t sz,
  * a unique set of pages, with the minimum real allocation being at least
  * a page.
  */
-vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
-			  uint32_t data_memslot, uint32_t pgd_memslot)
+vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min)
 {
 	uint64_t pages = (sz >> vm->page_shift) + ((sz % vm->page_size) != 0);
 
-	virt_pgd_alloc(vm, pgd_memslot);
+	virt_pgd_alloc(vm);
 	vm_paddr_t paddr = vm_phy_pages_alloc(vm, pages,
-					      KVM_UTIL_MIN_PFN * vm->page_size,
-					      data_memslot);
+					      KVM_UTIL_MIN_PFN * vm->page_size, 0);
 
 	/*
 	 * Find an unused range of virtual page addresses of at least
@@ -1271,7 +1269,7 @@ vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
 	for (vm_vaddr_t vaddr = vaddr_start; pages > 0;
 		pages--, vaddr += vm->page_size, paddr += vm->page_size) {
 
-		virt_pg_map(vm, vaddr, paddr, pgd_memslot);
+		virt_pg_map(vm, vaddr, paddr, 0);
 
 		sparsebit_set(vm->vpages_mapped,
 			vaddr >> vm->page_shift);
@@ -1296,7 +1294,7 @@ vm_vaddr_t vm_vaddr_alloc(struct kvm_vm *vm, size_t sz, vm_vaddr_t vaddr_min,
  */
 vm_vaddr_t vm_vaddr_alloc_pages(struct kvm_vm *vm, int nr_pages)
 {
-	return vm_vaddr_alloc(vm, nr_pages * getpagesize(), KVM_UTIL_MIN_VADDR, 0, 0);
+	return vm_vaddr_alloc(vm, nr_pages * getpagesize(), KVM_UTIL_MIN_VADDR);
 }
 
 /*
diff --git a/tools/testing/selftests/kvm/lib/s390x/processor.c b/tools/testing/selftests/kvm/lib/s390x/processor.c
index 0152f356c099..b46e90b88820 100644
--- a/tools/testing/selftests/kvm/lib/s390x/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390x/processor.c
@@ -13,7 +13,7 @@
 
 #define PAGES_PER_REGION 4
 
-void virt_pgd_alloc(struct kvm_vm *vm, uint32_t memslot)
+void virt_pgd_alloc(struct kvm_vm *vm)
 {
 	vm_paddr_t paddr;
 
@@ -24,7 +24,7 @@ void virt_pgd_alloc(struct kvm_vm *vm, uint32_t memslot)
 		return;
 
 	paddr = vm_phy_pages_alloc(vm, PAGES_PER_REGION,
-				   KVM_GUEST_PAGE_TABLE_MIN_PADDR, memslot);
+				   KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
 	memset(addr_gpa2hva(vm, paddr), 0xff, PAGES_PER_REGION * vm->page_size);
 
 	vm->pgd = paddr;
@@ -170,7 +170,7 @@ void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
 		    vm->page_size);
 
 	stack_vaddr = vm_vaddr_alloc(vm, stack_size,
-				     DEFAULT_GUEST_STACK_VADDR_MIN, 0, 0);
+				     DEFAULT_GUEST_STACK_VADDR_MIN);
 
 	vm_vcpu_add(vm, vcpuid);
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index afe15a238a81..c647e8175090 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -207,7 +207,7 @@ void sregs_dump(FILE *stream, struct kvm_sregs *sregs,
 	}
 }
 
-void virt_pgd_alloc(struct kvm_vm *vm, uint32_t pgd_memslot)
+void virt_pgd_alloc(struct kvm_vm *vm)
 {
 	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
 		"unknown or unsupported guest mode, mode: 0x%x", vm->mode);
@@ -215,7 +215,7 @@ void virt_pgd_alloc(struct kvm_vm *vm, uint32_t pgd_memslot)
 	/* If needed, create page map l4 table. */
 	if (!vm->pgd_created) {
 		vm_paddr_t paddr = vm_phy_page_alloc(vm,
-			KVM_GUEST_PAGE_TABLE_MIN_PADDR, pgd_memslot);
+			KVM_GUEST_PAGE_TABLE_MIN_PADDR, 0);
 		vm->pgd = paddr;
 		vm->pgd_created = true;
 	}
@@ -580,7 +580,7 @@ void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code)
 	struct kvm_regs regs;
 	vm_vaddr_t stack_vaddr;
 	stack_vaddr = vm_vaddr_alloc(vm, DEFAULT_STACK_PGS * getpagesize(),
-				     DEFAULT_GUEST_STACK_VADDR_MIN, 0, 0);
+				     DEFAULT_GUEST_STACK_VADDR_MIN);
 
 	/* Create VCPU */
 	vm_vcpu_add(vm, vcpuid);
diff --git a/tools/testing/selftests/kvm/x86_64/get_cpuid_test.c b/tools/testing/selftests/kvm/x86_64/get_cpuid_test.c
index 5e5682691f87..a711f83749ea 100644
--- a/tools/testing/selftests/kvm/x86_64/get_cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/get_cpuid_test.c
@@ -145,7 +145,7 @@ static void run_vcpu(struct kvm_vm *vm, uint32_t vcpuid, int stage)
 struct kvm_cpuid2 *vcpu_alloc_cpuid(struct kvm_vm *vm, vm_vaddr_t *p_gva, struct kvm_cpuid2 *cpuid)
 {
 	int size = sizeof(*cpuid) + cpuid->nent * sizeof(cpuid->entries[0]);
-	vm_vaddr_t gva = vm_vaddr_alloc(vm, size, KVM_UTIL_MIN_VADDR, 0, 0);
+	vm_vaddr_t gva = vm_vaddr_alloc(vm, size, KVM_UTIL_MIN_VADDR);
 	struct kvm_cpuid2 *guest_cpuids = addr_gva2hva(vm, gva);
 
 	memcpy(guest_cpuids, cpuid, size);
-- 
2.32.0.288.g62a8d224e6-goog

