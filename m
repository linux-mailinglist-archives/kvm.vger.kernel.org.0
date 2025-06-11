Return-Path: <kvm+bounces-49120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD021AD610D
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:19:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0710C3AB2EA
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 21:19:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 144B625A2CF;
	Wed, 11 Jun 2025 21:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZV7tdnUB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFE82550A4
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 21:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749676633; cv=none; b=Q7G8rtpqnHY976Rq9LcSfTdcmEKObbfggkt/yC5e9T+ltCJpaNPLpZnqE/lbw4hQuw4oQd3a8rOdZfT2/2kXZdFFgRK96718z2NZM9doCneWprq3mwKzjGCvpig0Z7e9T7gvJtsh8T7RHkEsmjPn+6jIlW73H5fgAyb/Tbe1dGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749676633; c=relaxed/simple;
	bh=3IrONkjSfZHSUwPR/efaP61FbpeztFmotATV6TKU0Sg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rMHmunHG+A/4HqQXqCDS8YBA24RgTB+5zL6HtzSJ1PZArNlkQIg3QTdrVMpXAeLQnWbHCvyl91Y0/2KFoAqwr2UNusLdK/a0XKAgAwMqm2ETkOfDt9C3KC1Vhoej0/WmcW9EZ4ZC65fmWfU3x0nrTmmYkceBUlRbx4l27VEQY8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--afranji.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZV7tdnUB; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--afranji.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b2eeff19115so207112a12.0
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 14:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749676631; x=1750281431; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QL/RdKZkxRdzT4JBOycXHxG8/DXNnGB2DrLug1v+dg0=;
        b=ZV7tdnUBH7W/TiD8a+shEajDUUciHLwOeLt4XifblkGDIDt/v+vY8x5tWNzKM2nIaI
         7VEwlkaUcNbQv8ReQJq+6q05xo/cUpIKL6ISijk3z0hh9uCbH7ZflqE1kp27tvO1tlCm
         mW4fU1TFw4Csj/wFf6puQsJ3dBN1Cl/G7CTf/c+9KUMtUDilIzVL95VWwVdoYqe4M5Ot
         sO5U8k81U72XmfRluECrxRj2JlKhmo9Sdqo2B0sJ/NkztKlTFJQYqzbDnS1yPjTtvCvu
         VEEZt/CratzuBVTjEX2HQpF1arDr2GBiJjWrND3TCCpUPuGEu9qFDGASNBrQgn6mDfuy
         4HqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749676631; x=1750281431;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QL/RdKZkxRdzT4JBOycXHxG8/DXNnGB2DrLug1v+dg0=;
        b=Q2tkljWxjAWCN4buRQ/NZjb4qbLlrU2/zaf3dETlXot3aj5UwWj4oEzPb7iW0ojHJc
         dCrOFtIdN7UqqLGNfl04PnE+6KPrxX7E77fp5GwLil6RjXCCK9EU4vZ1tHEc79tY7kqi
         BlUHsKlmVqtik63rYTmjQdzwsw8sCBW6cud4bfwzJ+7zSuPrj63aYNkpO0tCGktlEPF4
         z7x3kLriqcw8Gd8DbquwcOXD71YQFfg2DQG5fzrHlENf0d9FK5MatyRyOBlHh7lPHIMx
         DpNyT59YGjl+e28tRSS5x1GaopLXagJ46U+vvQq/7mc9Sr6mUDXYTXWojvgb57oB06fV
         H1jA==
X-Gm-Message-State: AOJu0YwSbRqa6Zut3E8Vktxg/QMtIdSdCR/Mr1MYg8cCcC8IaV2EdfF2
	2HyoZ9QP3jS8p/ANk+u+Q4FrJ0xcPZsM4Q2qBZmrEfPrnoPn0hmv6NkhWnhI0wuZXvxDfj6U25P
	JY9lB1uCYtmcBa3zn2La0qH55tsSJx64e4ixSlyad5hw4RLGwIV7Hba8UTil8ejhMQ3DNPvQfyq
	Y4HxP3Hyob3xXaEcxwZveX/0JSMUcSg5tf5+Jitw==
X-Google-Smtp-Source: AGHT+IH14aTAy2iw/U4wnQQFAPnkTzil6bCM78S3xEy8UEiHKZBuOafN0hQzXY+znZ0hE18aaQ9zR5PzBo4m
X-Received: from plog2.prod.google.com ([2002:a17:902:8682:b0:235:85e:1fac])
 (user=afranji job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f60e:b0:236:363e:55d
 with SMTP id d9443c01a7336-23641b19883mr73107675ad.28.1749676630519; Wed, 11
 Jun 2025 14:17:10 -0700 (PDT)
Date: Wed, 11 Jun 2025 21:16:36 +0000
In-Reply-To: <cover.1749672978.git.afranji@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1749672978.git.afranji@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <09d68c4748c0804f86aa6d943cf416742ef0f741.1749672978.git.afranji@google.com>
Subject: [RFC PATCH v2 09/10] KVM: selftests: Add TDX support for ucalls
From: Ryan Afranji <afranji@google.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc: sagis@google.com, bp@alien8.de, chao.p.peng@linux.intel.com, 
	dave.hansen@linux.intel.com, dmatlack@google.com, erdemaktas@google.com, 
	isaku.yamahata@intel.com, kai.huang@intel.com, mingo@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de, 
	zhi.wang.linux@gmail.com, ackerleytng@google.com, andrew.jones@linux.dev, 
	david@redhat.com, hpa@zytor.com, kirill.shutemov@linux.intel.com, 
	linux-kselftest@vger.kernel.org, tabba@google.com, vannapurve@google.com, 
	yan.y.zhao@intel.com, rick.p.edgecombe@intel.com, 
	Ryan Afranji <afranji@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Ackerley Tng <ackerleytng@google.com>

ucalls for non-Coco VMs work by having the guest write to the rdi
register, then perform an io instruction to exit to the host. The host
then reads rdi using kvm_get_regs().

CPU registers can't be read using kvm_get_regs() for TDX, so TDX
guests use MMIO to pass the struct ucall's hva to the host. MMIO was
chosen because it is one of the simplest (hence unlikely to fail)
mechanisms that support passing 8 bytes from guest to host.

A new kvm_mem_region_type, MEM_REGION_UCALL, is added so TDX VMs can
set up a different memslot for the ucall_pool that is set up as shared
memory.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ryan Afranji <afranji@google.com>
---
 .../testing/selftests/kvm/include/kvm_util.h  |   1 +
 .../testing/selftests/kvm/include/x86/ucall.h |   4 +-
 .../testing/selftests/kvm/lib/ucall_common.c  |   2 +-
 .../selftests/kvm/lib/x86/tdx/tdx_util.c      |  40 +++++++
 tools/testing/selftests/kvm/lib/x86/ucall.c   | 108 ++++++++++++------
 5 files changed, 118 insertions(+), 37 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 1b6489081e74..8b252a668c78 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -80,6 +80,7 @@ enum kvm_mem_region_type {
 	MEM_REGION_PT,
 	MEM_REGION_TEST_DATA,
 	MEM_REGION_TDX_BOOT_PARAMS,
+	MEM_REGION_UCALL,
 	NR_MEM_REGIONS,
 };
 
diff --git a/tools/testing/selftests/kvm/include/x86/ucall.h b/tools/testing/selftests/kvm/include/x86/ucall.h
index d3825dcc3cd9..0494a4a21557 100644
--- a/tools/testing/selftests/kvm/include/x86/ucall.h
+++ b/tools/testing/selftests/kvm/include/x86/ucall.h
@@ -6,8 +6,6 @@
 
 #define UCALL_EXIT_REASON       KVM_EXIT_IO
 
-static inline void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
-{
-}
+void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa);
 
 #endif
diff --git a/tools/testing/selftests/kvm/lib/ucall_common.c b/tools/testing/selftests/kvm/lib/ucall_common.c
index 42151e571953..5f195d4d15dc 100644
--- a/tools/testing/selftests/kvm/lib/ucall_common.c
+++ b/tools/testing/selftests/kvm/lib/ucall_common.c
@@ -33,7 +33,7 @@ void ucall_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
 	int i;
 
 	vaddr = vm_vaddr_alloc_shared(vm, sizeof(*hdr), KVM_UTIL_MIN_VADDR,
-				      MEM_REGION_DATA);
+				      MEM_REGION_UCALL);
 	hdr = (struct ucall_header *)addr_gva2hva(vm, vaddr);
 	memset(hdr, 0, sizeof(*hdr));
 
diff --git a/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c b/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
index ef03d42f58d0..a3612bf187a0 100644
--- a/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
+++ b/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
@@ -11,6 +11,7 @@
 #include "tdx/td_boot.h"
 #include "tdx/tdx.h"
 #include "test_util.h"
+#include "ucall_common.h"
 
 uint64_t tdx_s_bit;
 
@@ -568,6 +569,43 @@ static void td_setup_boot_parameters(struct kvm_vm *vm, enum vm_mem_backing_src_
 	TEST_ASSERT_EQ(addr, TD_BOOT_PARAMETERS_GPA);
 }
 
+/*
+ * GPA where ucall headers/pool will be set up
+ *
+ * TD_UCALL_POOL_GPA is arbitrarily chosen to
+ *
+ * + Be within the 4GB address space
+ * + Not clash with the other memslots for boot parameters, boot code and test
+ *   code
+ */
+#define TD_UCALL_POOL_GPA 0x30000000
+/*
+ * GPA to use for ucall MMIO writes
+ *
+ * TD_UCALL_MMIO_GPA is arbitrarily chosen to
+ *
+ * + Be within the 4GB address space
+ * + Not clash with the other memslots for boot parameters, boot code and test
+ *   code
+ * + Not be configured in any memslot (unconfigured GPAs are treated as
+ *   MMIOs). For now, TDX VMs can't be used with KVM_MEM_READONLY so using
+ *   readonly memslots won't work for TDX VMs.
+ */
+#define TD_UCALL_MMIO_GPA 0x40000000
+#define TD_UCALL_MEMSLOT  4
+
+static void td_setup_ucall(struct kvm_vm *vm)
+{
+	int npages;
+
+	npages = ucall_nr_pages_required(PAGE_SIZE);
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, TD_UCALL_POOL_GPA,
+				    TD_UCALL_MEMSLOT, npages, 0);
+	vm->memslots[MEM_REGION_UCALL] = TD_UCALL_MEMSLOT;
+
+	ucall_init(vm, TD_UCALL_MMIO_GPA);
+}
+
 void td_initialize(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		   uint64_t attributes)
 {
@@ -593,6 +631,8 @@ void td_initialize(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 
 	td_setup_boot_code(vm, src_type);
 	td_setup_boot_parameters(vm, src_type);
+
+	td_setup_ucall(vm);
 }
 
 void td_finalize(struct kvm_vm *vm)
diff --git a/tools/testing/selftests/kvm/lib/x86/ucall.c b/tools/testing/selftests/kvm/lib/x86/ucall.c
index 1265cecc7dd1..5cf915dbb588 100644
--- a/tools/testing/selftests/kvm/lib/x86/ucall.c
+++ b/tools/testing/selftests/kvm/lib/x86/ucall.c
@@ -5,52 +5,94 @@
  * Copyright (C) 2018, Red Hat, Inc.
  */
 #include "kvm_util.h"
+#include "kvm_util_types.h"
+#include "tdx/tdx.h"
 
 #define UCALL_PIO_PORT ((uint16_t)0x1000)
 
+static uint8_t vm_type;
+static vm_paddr_t host_ucall_mmio_gpa;
+static vm_paddr_t ucall_mmio_gpa;
+
+void ucall_arch_init(struct kvm_vm *vm, vm_paddr_t mmio_gpa)
+{
+	vm_type = vm->type;
+	sync_global_to_guest(vm, vm_type);
+
+	host_ucall_mmio_gpa = ucall_mmio_gpa = mmio_gpa;
+
+#ifdef __x86_64__
+	if (vm_type == KVM_X86_TDX_VM)
+		ucall_mmio_gpa |= vm->arch.s_bit;
+#endif
+
+	sync_global_to_guest(vm, ucall_mmio_gpa);
+}
+
 void ucall_arch_do_ucall(vm_vaddr_t uc)
 {
-	/*
-	 * FIXME: Revert this hack (the entire commit that added it) once nVMX
-	 * preserves L2 GPRs across a nested VM-Exit.  If a ucall from L2, e.g.
-	 * to do a GUEST_SYNC(), lands the vCPU in L1, any and all GPRs can be
-	 * clobbered by L1.  Save and restore non-volatile GPRs (clobbering RBP
-	 * in particular is problematic) along with RDX and RDI (which are
-	 * inputs), and clobber volatile GPRs. *sigh*
-	 */
-#define HORRIFIC_L2_UCALL_CLOBBER_HACK	\
+	switch (vm_type) {
+	case KVM_X86_TDX_VM:
+		tdg_vp_vmcall_ve_request_mmio_write(ucall_mmio_gpa, 8, uc);
+		return;
+	default:
+		/*
+		 * FIXME: Revert this hack (the entire commit that added it)
+		 * once nVMX preserves L2 GPRs across a nested VM-Exit.  If a
+		 * ucall from L2, e.g.  to do a GUEST_SYNC(), lands the vCPU in
+		 * L1, any and all GPRs can be clobbered by L1.  Save and
+		 * restore non-volatile GPRs (clobbering RBP in particular is
+		 * problematic) along with RDX and RDI (which are inputs), and
+		 * clobber volatile GPRs. *sigh*
+		 */
+#define HORRIFIC_L2_UCALL_CLOBBER_HACK		\
 	"rcx", "rsi", "r8", "r9", "r10", "r11"
 
-	asm volatile("push %%rbp\n\t"
-		     "push %%r15\n\t"
-		     "push %%r14\n\t"
-		     "push %%r13\n\t"
-		     "push %%r12\n\t"
-		     "push %%rbx\n\t"
-		     "push %%rdx\n\t"
-		     "push %%rdi\n\t"
-		     "in %[port], %%al\n\t"
-		     "pop %%rdi\n\t"
-		     "pop %%rdx\n\t"
-		     "pop %%rbx\n\t"
-		     "pop %%r12\n\t"
-		     "pop %%r13\n\t"
-		     "pop %%r14\n\t"
-		     "pop %%r15\n\t"
-		     "pop %%rbp\n\t"
-		: : [port] "d" (UCALL_PIO_PORT), "D" (uc) : "rax", "memory",
-		     HORRIFIC_L2_UCALL_CLOBBER_HACK);
+		asm volatile("push %%rbp\n\t"
+			     "push %%r15\n\t"
+			     "push %%r14\n\t"
+			     "push %%r13\n\t"
+			     "push %%r12\n\t"
+			     "push %%rbx\n\t"
+			     "push %%rdx\n\t"
+			     "push %%rdi\n\t"
+			     "in %[port], %%al\n\t"
+			     "pop %%rdi\n\t"
+			     "pop %%rdx\n\t"
+			     "pop %%rbx\n\t"
+			     "pop %%r12\n\t"
+			     "pop %%r13\n\t"
+			     "pop %%r14\n\t"
+			     "pop %%r15\n\t"
+			     "pop %%rbp\n\t"
+			     :
+			     : [port] "d"(UCALL_PIO_PORT), "D"(uc)
+			     : "rax", "memory", HORRIFIC_L2_UCALL_CLOBBER_HACK);
+	}
 }
 
 void *ucall_arch_get_ucall(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
 
-	if (run->exit_reason == KVM_EXIT_IO && run->io.port == UCALL_PIO_PORT) {
-		struct kvm_regs regs;
+	switch (vm_type) {
+	case KVM_X86_TDX_VM:
+		if (vcpu->run->exit_reason == KVM_EXIT_MMIO &&
+		    vcpu->run->mmio.phys_addr == host_ucall_mmio_gpa &&
+		    vcpu->run->mmio.len == 8 && vcpu->run->mmio.is_write) {
+			uint64_t data = *(uint64_t *)vcpu->run->mmio.data;
+
+			return (void *)data;
+		}
+		return NULL;
+	default:
+		if (run->exit_reason == KVM_EXIT_IO &&
+		    run->io.port == UCALL_PIO_PORT) {
+			struct kvm_regs regs;
 
-		vcpu_regs_get(vcpu, &regs);
-		return (void *)regs.rdi;
+			vcpu_regs_get(vcpu, &regs);
+			return (void *)regs.rdi;
+		}
+		return NULL;
 	}
-	return NULL;
 }
-- 
2.50.0.rc1.591.g9c95f17f64-goog


