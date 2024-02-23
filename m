Return-Path: <kvm+bounces-9453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E70C38607CD
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 01:44:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3463A286A4A
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 00:44:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE904BA28;
	Fri, 23 Feb 2024 00:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aQEWBEBw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4258EC8E0
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 00:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708648993; cv=none; b=bj99WWQlIkBlv4GE527mzfjceWfuStIaqRpkEFnbufAhpFUpO62kTLnhACbfXJjt8O41/kDxf+WboBlNbabL1Xx+Sq1TpRJWRECmHnW5UV5MSFBq46fF9MOAhSqwKYY+m5JzpWzTOd3fdoBlHlRnTuq+j51AG7GI2k2fhEoNBHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708648993; c=relaxed/simple;
	bh=kOWMpHRm0Jt6rsGNN4rcuUv5pHmG0Bajgke/K8TPQlw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TETgBI8/vCI4u0z77AP0/wY8jLIlNeb7SypEIMoRn5DkT9OnPM3+/55V3B7p72jyXkIuNt4rAmgB82Zmi2wKMCZrTR0DUZsy+KTqRsPiJ6FL+GVvk7K0J+lfaxENNvwAJYzbAT/VZVqYTK65ZW4YseC2TbcLtmYZhDokv0NyO4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aQEWBEBw; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbf618042daso522746276.0
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 16:43:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708648989; x=1709253789; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=HqrOgwqdeyKlRqEiiRXs7cvS3neUx0UIcneX8OI5QMg=;
        b=aQEWBEBwkqntI56A32yvU+TzYfrUGEtwR7LHvWnjZTTOCDLtIIfVp+1ArIfc1u8ycu
         nAWWA1EhGy7NGJlFkIhps/7bNmHhsI5XR0Fa+jh0pIeXHrc2YDXYKMRHEyzYQh1ndUdu
         lO/ZTN5HSPKgXqylaH86fwmg5304SXqqG/F/L0Iv4x15vle1MWkrNeRLNsCc6fmuRpQH
         7RGWMk7EMITNDvtl9slESSt+htJ5vfpxV7qDOF5IvZNWOjRPUBqZhp+u0kV02cS4yaO2
         wH3OicR9QYQPqk3zyhFv7IdTCs2A4ea94sCcRR52AWGylv01cQQp2jn04cNHi3yD4Ado
         Lv4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708648989; x=1709253789;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HqrOgwqdeyKlRqEiiRXs7cvS3neUx0UIcneX8OI5QMg=;
        b=Jiuv4jli14hxXeuYdzW2cW1gpGGaUpCEWmjMkhQJ13Vod+ZyIUZ8ChLklwZq8X4Yvf
         JkhCLLS4s+K9O+mxpTQXW+2SDVfqNReQB8zAGx8e9+ijDtWpxkqMFopqpDUjivun4uUL
         02QD+14usOtkF/Nei1zv40LRFUsP8jdMqrwcFdCXyK0qpsv/PXxu90msXFaAgiqxT5cf
         EMMYCS8l71i1QS0DEC17Rck0hL23DbvEZ9z4FkcR0gtauK1Ue1clbS8415hLbIvBNywz
         oU4+50rvwkPaequUAPgRY6d3ejfD0Ktx3ksvnGPbYxpNNgXlLNODoqepZsvBHh3U/d/b
         poeg==
X-Gm-Message-State: AOJu0Yzv2rOI4GIiXCEexP4Ervjpb15G71XMiLcI+5nvnrI7QYPbZp7d
	LRP4NFODzElUygxDCk2aqijQyvBClt3DAlJC8rs3fMSrFY9xPQMzUYXoY9tzzqoWFriLlH/XFgr
	gAQ==
X-Google-Smtp-Source: AGHT+IHAocQThc2nDGuTHCVQAHxE7aFJD+GhXyIt2aJYre2j8M6mtpdSWTf/tdU8cZ1cYJDcvyTMlv2LL8I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:181f:b0:dcc:94b7:a7a3 with SMTP id
 cf31-20020a056902181f00b00dcc94b7a7a3mr21587ybb.12.1708648989306; Thu, 22 Feb
 2024 16:43:09 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 Feb 2024 16:42:51 -0800
In-Reply-To: <20240223004258.3104051-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240223004258.3104051-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240223004258.3104051-5-seanjc@google.com>
Subject: [PATCH v9 04/11] KVM: selftests: Add support for allocating/managing
 protected guest memory
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

Add support for differentiating between protected (a.k.a. private, a.k.a.
encrypted) memory and normal (a.k.a. shared) memory for VMs that support
protected guest memory, e.g. x86's SEV.  Provide and manage a common
bitmap for tracking whether a given physical page resides in protected
memory, as support for protected memory isn't x86 specific, i.e. adding a
arch hook would be a net negative now, and in the future.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>
cc: Andrew Jones <andrew.jones@linux.dev>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Michael Roth <michael.roth@amd.com>
Reviewed-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Tested-by: Carlos Bilbao <carlos.bilbao@amd.com>
Originally-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Peter Gonda <pgonda@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     | 25 +++++++++++++++++--
 tools/testing/selftests/kvm/lib/kvm_util.c    | 22 +++++++++++++---
 2 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index d9dc31af2f96..a82149305349 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -46,6 +46,7 @@ typedef uint64_t vm_vaddr_t; /* Virtual Machine (Guest) virtual address */
 struct userspace_mem_region {
 	struct kvm_userspace_memory_region2 region;
 	struct sparsebit *unused_phy_pages;
+	struct sparsebit *protected_phy_pages;
 	int fd;
 	off_t offset;
 	enum vm_mem_backing_src_type backing_src_type;
@@ -573,6 +574,13 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		uint64_t guest_paddr, uint32_t slot, uint64_t npages,
 		uint32_t flags, int guest_memfd_fd, uint64_t guest_memfd_offset);
 
+#ifndef vm_arch_has_protected_memory
+static inline bool vm_arch_has_protected_memory(struct kvm_vm *vm)
+{
+	return false;
+}
+#endif
+
 void vm_mem_region_set_flags(struct kvm_vm *vm, uint32_t slot, uint32_t flags);
 void vm_mem_region_move(struct kvm_vm *vm, uint32_t slot, uint64_t new_gpa);
 void vm_mem_region_delete(struct kvm_vm *vm, uint32_t slot);
@@ -836,10 +844,23 @@ const char *exit_reason_str(unsigned int exit_reason);
 
 vm_paddr_t vm_phy_page_alloc(struct kvm_vm *vm, vm_paddr_t paddr_min,
 			     uint32_t memslot);
-vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
-			      vm_paddr_t paddr_min, uint32_t memslot);
+vm_paddr_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+				vm_paddr_t paddr_min, uint32_t memslot,
+				bool protected);
 vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
 
+static inline vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+					    vm_paddr_t paddr_min, uint32_t memslot)
+{
+	/*
+	 * By default, allocate memory as protected for VMs that support
+	 * protected memory, as the majority of memory for such VMs is
+	 * protected, i.e. using shared memory is effectively opt-in.
+	 */
+	return __vm_phy_pages_alloc(vm, num, paddr_min, memslot,
+				    vm_arch_has_protected_memory(vm));
+}
+
 /*
  * ____vm_create() does KVM_CREATE_VM and little else.  __vm_create() also
  * loads the test binary into guest memory and creates an IRQ chip (x86 only).
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index a53caf81eb87..ea677aa019ef 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -717,6 +717,7 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
 	vm_ioctl(vm, KVM_SET_USER_MEMORY_REGION2, &region->region);
 
 	sparsebit_free(&region->unused_phy_pages);
+	sparsebit_free(&region->protected_phy_pages);
 	ret = munmap(region->mmap_start, region->mmap_size);
 	TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
 	if (region->fd >= 0) {
@@ -1098,6 +1099,8 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 	}
 
 	region->unused_phy_pages = sparsebit_alloc();
+	if (vm_arch_has_protected_memory(vm))
+		region->protected_phy_pages = sparsebit_alloc();
 	sparsebit_set_num(region->unused_phy_pages,
 		guest_paddr >> vm->page_shift, npages);
 	region->region.slot = slot;
@@ -1924,6 +1927,10 @@ void vm_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 			region->host_mem);
 		fprintf(stream, "%*sunused_phy_pages: ", indent + 2, "");
 		sparsebit_dump(stream, region->unused_phy_pages, 0);
+		if (region->protected_phy_pages) {
+			fprintf(stream, "%*sprotected_phy_pages: ", indent + 2, "");
+			sparsebit_dump(stream, region->protected_phy_pages, 0);
+		}
 	}
 	fprintf(stream, "%*sMapped Virtual Pages:\n", indent, "");
 	sparsebit_dump(stream, vm->vpages_mapped, indent + 2);
@@ -2025,6 +2032,7 @@ const char *exit_reason_str(unsigned int exit_reason)
  *   num - number of pages
  *   paddr_min - Physical address minimum
  *   memslot - Memory region to allocate page from
+ *   protected - True if the pages will be used as protected/private memory
  *
  * Output Args: None
  *
@@ -2036,8 +2044,9 @@ const char *exit_reason_str(unsigned int exit_reason)
  * and their base address is returned. A TEST_ASSERT failure occurs if
  * not enough pages are available at or above paddr_min.
  */
-vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
-			      vm_paddr_t paddr_min, uint32_t memslot)
+vm_paddr_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
+				vm_paddr_t paddr_min, uint32_t memslot,
+				bool protected)
 {
 	struct userspace_mem_region *region;
 	sparsebit_idx_t pg, base;
@@ -2050,8 +2059,10 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 		paddr_min, vm->page_size);
 
 	region = memslot2region(vm, memslot);
+	TEST_ASSERT(!protected || region->protected_phy_pages,
+		    "Region doesn't support protected memory");
+
 	base = pg = paddr_min >> vm->page_shift;
-
 	do {
 		for (; pg < base + num; ++pg) {
 			if (!sparsebit_is_set(region->unused_phy_pages, pg)) {
@@ -2070,8 +2081,11 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 		abort();
 	}
 
-	for (pg = base; pg < base + num; ++pg)
+	for (pg = base; pg < base + num; ++pg) {
 		sparsebit_clear(region->unused_phy_pages, pg);
+		if (protected)
+			sparsebit_set(region->protected_phy_pages, pg);
+	}
 
 	return base * vm->page_size;
 }
-- 
2.44.0.rc0.258.g7320e95886-goog


