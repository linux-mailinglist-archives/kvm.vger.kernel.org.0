Return-Path: <kvm+bounces-56755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 27128B43308
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:58:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E15741C25E3A
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 06:58:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8974296BCB;
	Thu,  4 Sep 2025 06:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GgvjP2fs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1D328FA9A
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 06:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756968920; cv=none; b=SbikhFt94puwNR+/+NNYe+1EfnEPQdNcFOMlE39wMx1ycdb8pgtA0M5xo78E5FmLM2Tf1Oph30WEj/CSMWhql6cvLofPnlk0e5DYOUS6MFoe790CG7crJpjT9H6FlwVufyDAn3uLiKjbGLXa7OjNMr+w6qlF8Cvph3pDvP/AL98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756968920; c=relaxed/simple;
	bh=EjU7KXG/u8BDzqWiSLIwzY5YgLrkcSk96k/s3PgaIBo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tWdci+XhVCc16Sb4sGm0+fJ8EfaPK8CRpD1q/oRztf3+Q3i/Q74clGcvm1NNespAA0NF24IYWbC6Tklm6cuAcZ4AqVQbXcMCLzuPMXLzTn7L6u1KsnyJbso0WPdCB0NzMoMJHm8NNO15svwcY16xSam4vfxsfqvFkkmXSVqnYKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GgvjP2fs; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-329dbf4476cso553223a91.1
        for <kvm@vger.kernel.org>; Wed, 03 Sep 2025 23:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756968919; x=1757573719; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Dgx8Xu0K0l7QI5WLWZT874WzrkjZA4BwF6/XUfU7Kgk=;
        b=GgvjP2fsnafsPQj5ldQ6TWBIiyCVIR1an0UK/O8Lv3EXZbPnC/HxC7JV0Q5IxtyDdF
         iSQMZANuh4Q1gEU4jt4AVHguVD1D3ViYr1lDtQkRJviLV16tljy9qB5obD84hGH3uHRw
         OUFDlE3Y2yKu40/4N6//Q6RwoxGLDAJckO3DSteaMTwKIPryXF5FTEmXm6yPryxr+lMh
         3w5eJXMTAtXBpDCpbqvMEdEHr60jXxNn2EgFjWzP62NYynu2gUQ2Cu9goShL+xZ3mGci
         /YMaLVyhoL6tXRI8sbN3NneNxxMG06nfLHA/MoxlLBQ55CCGnFp1glq9P6gChoAf9xCU
         9DMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756968919; x=1757573719;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dgx8Xu0K0l7QI5WLWZT874WzrkjZA4BwF6/XUfU7Kgk=;
        b=oHOriEd22aSzEeVcS38SD+Q8tDdTPUXbiMbNkbuyKZqTKDgLR6RqdLoELYEv0ict7n
         cQzU7S0Q58+hV1uMGHTcJKAGg9ttFjTxrOVYIupEKGTKe79QLvSoj7Jp/PzAmtn3rDpx
         eSRUZbANg0+z4lfgjH4G5N0jbh/9rAGsDOkLY7m4cOSa5oqtw+zMyh4j3MTfzyrbH5Rb
         cwgR9H3ZZ/4brXpEOa3JmQu2UajTVj8kJrw3c5d4X1Y6IlUu132N8v64uts8/hA8Lkn7
         TTkSnmivjh8camEEZMRZ5SwcdPQVaF/eT1hS7d89mPVHY8ygk5PnrI8ye1ehRgJGXMID
         1wuw==
X-Forwarded-Encrypted: i=1; AJvYcCUoxnYBFXYIQNCI/8GvRXUIQZAC5IrM4tP7oQ7J/wXHs0y9WYLL/t3DFLTLOfxxNhJ/0Cc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuWqVO4Y5S6K4fbYt42tVuSCMk4ou9ciuplcT5AXLCV3vjQAOP
	6qLqWBTIgHVQonIDX0LxHhy4s3QNmNUn0I3KklgYLVCgj9OX5NmEHMrL6pGrgkrrdyg1B6S3LLY
	wfg==
X-Google-Smtp-Source: AGHT+IEDD0RpQidmxQgchdEDviTmdvlzKZbtFlp08ExqfbX8gfhH6zR2n2zVMd0EWyK22yxxdHJme2n8bw==
X-Received: from pjboh15.prod.google.com ([2002:a17:90b:3a4f:b0:32b:827b:f76e])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d54d:b0:248:f30e:6a10
 with SMTP id d9443c01a7336-24944ab8c9cmr239531135ad.35.1756968918676; Wed, 03
 Sep 2025 23:55:18 -0700 (PDT)
Date: Wed,  3 Sep 2025 23:54:40 -0700
In-Reply-To: <20250904065453.639610-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250904065453.639610-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.338.gd7d06c2dae-goog
Message-ID: <20250904065453.639610-11-sagis@google.com>
Subject: [PATCH v10 10/21] KVM: selftests: Set up TDX boot parameters region
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Sagi Shahar <sagis@google.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Allocate memory for TDX boot parameters and define the utility functions
necessary to fill this memory with the boot parameters.

Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 .../selftests/kvm/include/x86/tdx/tdx_util.h  |  4 +
 .../selftests/kvm/lib/x86/tdx/tdx_util.c      | 75 +++++++++++++++++++
 2 files changed, 79 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h b/tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h
index ec05bcd59145..dafdc7e46abe 100644
--- a/tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h
+++ b/tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h
@@ -12,5 +12,9 @@ static inline bool is_tdx_vm(struct kvm_vm *vm)
 }
 
 void vm_tdx_setup_boot_code_region(struct kvm_vm *vm);
+void vm_tdx_setup_boot_parameters_region(struct kvm_vm *vm, uint32_t nr_runnable_vcpus);
+void vm_tdx_load_common_boot_parameters(struct kvm_vm *vm);
+void vm_tdx_load_vcpu_boot_parameters(struct kvm_vm *vm, struct kvm_vcpu *vcpu);
+void vm_tdx_set_vcpu_entry_point(struct kvm_vcpu *vcpu, void *guest_code);
 
 #endif // SELFTESTS_TDX_TDX_UTIL_H
diff --git a/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c b/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
index a1cf12de9d56..ff61333bc848 100644
--- a/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
+++ b/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
@@ -5,10 +5,12 @@
 #include "kvm_util.h"
 #include "processor.h"
 #include "tdx/td_boot.h"
+#include "tdx/td_boot_asm.h"
 #include "tdx/tdx_util.h"
 
 /* Arbitrarily selected to avoid overlaps with anything else */
 #define TD_BOOT_CODE_SLOT	20
+#define TD_BOOT_PARAMETERS_SLOT	21
 
 #define X86_RESET_VECTOR	0xfffffff0ul
 #define X86_RESET_VECTOR_SIZE	16
@@ -52,3 +54,76 @@ void vm_tdx_setup_boot_code_region(struct kvm_vm *vm)
 	hva[1] = 256 - 2 - TD_BOOT_CODE_SIZE;
 	hva[2] = 0xcc;
 }
+
+void vm_tdx_setup_boot_parameters_region(struct kvm_vm *vm, uint32_t nr_runnable_vcpus)
+{
+	size_t boot_params_size =
+		sizeof(struct td_boot_parameters) +
+		nr_runnable_vcpus * sizeof(struct td_per_vcpu_parameters);
+	int npages = DIV_ROUND_UP(boot_params_size, PAGE_SIZE);
+	vm_paddr_t gpa;
+
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
+				    TD_BOOT_PARAMETERS_GPA,
+				    TD_BOOT_PARAMETERS_SLOT, npages,
+				    KVM_MEM_GUEST_MEMFD);
+	gpa = vm_phy_pages_alloc(vm, npages, TD_BOOT_PARAMETERS_GPA, TD_BOOT_PARAMETERS_SLOT);
+	TEST_ASSERT(gpa == TD_BOOT_PARAMETERS_GPA, "Failed vm_phy_pages_alloc\n");
+
+	virt_map(vm, TD_BOOT_PARAMETERS_GPA, TD_BOOT_PARAMETERS_GPA, npages);
+}
+
+void vm_tdx_load_common_boot_parameters(struct kvm_vm *vm)
+{
+	struct td_boot_parameters *params =
+		addr_gpa2hva(vm, TD_BOOT_PARAMETERS_GPA);
+	uint32_t cr4;
+
+	TEST_ASSERT_EQ(vm->mode, VM_MODE_PXXV48_4K);
+
+	cr4 = kvm_get_default_cr4();
+
+	/* TDX spec 11.6.2: CR4 bit MCE is fixed to 1 */
+	cr4 |= X86_CR4_MCE;
+
+	/* Set this because UEFI also sets this up, to handle XMM exceptions */
+	cr4 |= X86_CR4_OSXMMEXCPT;
+
+	/* TDX spec 11.6.2: CR4 bit VMXE and SMXE are fixed to 0 */
+	cr4 &= ~(X86_CR4_VMXE | X86_CR4_SMXE);
+
+	/* Set parameters! */
+	params->cr0 = kvm_get_default_cr0();
+	params->cr3 = vm->pgd;
+	params->cr4 = cr4;
+	params->idtr.base = vm->arch.idt;
+	params->idtr.limit = kvm_get_default_idt_limit();
+	params->gdtr.base = vm->arch.gdt;
+	params->gdtr.limit = kvm_get_default_gdt_limit();
+
+	TEST_ASSERT(params->cr0 != 0, "cr0 should not be 0");
+	TEST_ASSERT(params->cr3 != 0, "cr3 should not be 0");
+	TEST_ASSERT(params->cr4 != 0, "cr4 should not be 0");
+	TEST_ASSERT(params->gdtr.base != 0, "gdt base address should not be 0");
+	TEST_ASSERT(params->idtr.base != 0, "idt base address should not be 0");
+}
+
+void vm_tdx_load_vcpu_boot_parameters(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
+{
+	struct td_boot_parameters *params =
+		addr_gpa2hva(vm, TD_BOOT_PARAMETERS_GPA);
+	struct td_per_vcpu_parameters *vcpu_params =
+		&params->per_vcpu[vcpu->id];
+
+	vcpu_params->esp_gva = kvm_allocate_vcpu_stack(vm);
+}
+
+void vm_tdx_set_vcpu_entry_point(struct kvm_vcpu *vcpu, void *guest_code)
+{
+	struct td_boot_parameters *params =
+		addr_gpa2hva(vcpu->vm, TD_BOOT_PARAMETERS_GPA);
+	struct td_per_vcpu_parameters *vcpu_params =
+		&params->per_vcpu[vcpu->id];
+
+	vcpu_params->guest_code = (uint64_t)guest_code;
+}
-- 
2.51.0.338.gd7d06c2dae-goog


