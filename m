Return-Path: <kvm+bounces-55247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 30CAFB2ECEC
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 06:34:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99765A2251A
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 04:33:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EB2E2EA75C;
	Thu, 21 Aug 2025 04:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TMCLAx3J"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236F92EA46E
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 04:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755750582; cv=none; b=L8llBWfBedOYnUFQIFkVC9hPGgslvQngjwOM2svmYT+TYPzLxr0xhsx5IUdoBVDHt1pf/EqD1JO23CNTaZ85hDAw112suhij/G57tNzqVt5ke0cN2IvwjV+PUcwxlZdR2Z9uaDa2Z9ricMWhGOoW8Sy5GwCSvMqwrHRqreA+Seg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755750582; c=relaxed/simple;
	bh=FpYo1ms5I2w2FSdE2WWD0f2b2tjuJeIdKXug1uiSfdI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aL8NGrk2Dk2Y73WPBG0+o0d7ak2GJ5rC0WfIvfGeIt3+gA985TOBwKoZs5p4HT9f4ukCaJsBK+IwdPYTD6hfDbrbnQ/+jpaludEbDrGQZSnY2fTE0rH4xQIirDxnmCHFF6uBFP8ngiIDawySIcWzAB8NHD3It47ZMrq4IuxJXIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TMCLAx3J; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32326e0c0baso640814a91.2
        for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 21:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755750580; x=1756355380; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vSLWtY+GKeQEYDQMa4cXM5mk60zIsuzRFHdNMwLX5Fs=;
        b=TMCLAx3JI0xN3zGEV5FhYmjQZE6fKNaCDNmXH84zb8uyRdEO9TSKIGyknS5+4u5Cu+
         bvF5NcnjtQUp9NxqW7hW1byu3dPAc+EAIaWun+GzUiFF0n7tn6afA9+AB5QBnnqSYAW/
         azy23GO5lF2P9Enxk98InR/I2iZKNgjLIMpb6whlwNk18sxGcN8DfmaEJACu+KB5nyvy
         /D9jgTr8Z198qAdcMeoy2jVHc/caM10kzdwN/B6RNKkpCbNS7EHp8NwzvKq/MTV9SdgH
         1CD4jw/3zsvz0P/dZMESuE5v//cCOz53inJ4v2yMZVSqgI3CjISVyOSE0LlIVoIcZoj1
         EKpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755750580; x=1756355380;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vSLWtY+GKeQEYDQMa4cXM5mk60zIsuzRFHdNMwLX5Fs=;
        b=fdMobV9FM00ZoCll7WSUywNx7/giObXO0+zq1de6DcQJ9ZWwO4sIG4EcVfhYork8h5
         EdtxBM48FwYFqyWqQW9o6wIJpJ13WE2eJUA0PjaJ/EdoVsuQryaDnCjHjbyETXwLc4CH
         LtsjKyRXHixdlhPSu39av0pPECR6ieyJPZ1DKBus+4Wdm/8tvvd7E99G7DmuJ2q0dsfu
         x1Aw6pxvQAs4YNzMzOj+XM0zfoQnlH2aWTHFar8XIiDl+sXmMGt67GkFCeNZ+385PIvX
         EIg/z62xBunklhxb5QTwSc6sCjbKP4YA8qm5Frrw0qpGHMvJDafAELTPr4uz8Tw+lWhZ
         3pTg==
X-Forwarded-Encrypted: i=1; AJvYcCXDl5G2/E5xYta6LnzdEwOS/VSHASDyu7vp6XbzdtdZ52d+wLX7TVtPChz0rPFmYVPbylI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKF7SMuvBtIpUu5ZjGx70xij6OHkY0RgNsQyWxAvj6hNhiEW27
	kIQht0MPPJ3JIGR5oqkujtGu4EghcN5nPaCsYfn5bzL26uhJzAgE+SE/WPH0tQ7Vat4KAg6y4NB
	6EQ==
X-Google-Smtp-Source: AGHT+IGE2GEJUcGNKEQmBkApaYqJ8IVfqmnRGMrQ0Rbu+EA1KbNaVBMaF+VhfLNDi6fLEoJVkODux/wMuA==
X-Received: from pjboh13.prod.google.com ([2002:a17:90b:3a4d:b0:31f:26b:cc66])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a0e:b0:31a:ab75:6e45
 with SMTP id 98e67ed59e1d1-324ed12d30emr1584154a91.28.1755750580482; Wed, 20
 Aug 2025 21:29:40 -0700 (PDT)
Date: Wed, 20 Aug 2025 21:29:04 -0700
In-Reply-To: <20250821042915.3712925-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250821042915.3712925-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.rc1.193.gad69d77794-goog
Message-ID: <20250821042915.3712925-12-sagis@google.com>
Subject: [PATCH v9 11/19] KVM: selftests: Set up TDX boot parameters region
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
 .../selftests/kvm/lib/x86/tdx/tdx_util.c      | 73 +++++++++++++++++++
 2 files changed, 77 insertions(+)

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
index 15833b9eb5d5..52dc25e0cce4 100644
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
@@ -52,3 +54,74 @@ void vm_tdx_setup_boot_code_region(struct kvm_vm *vm)
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
+	struct td_boot_parameters *params = addr_gpa2hva(vcpu->vm, TD_BOOT_PARAMETERS_GPA);
+	struct td_per_vcpu_parameters *vcpu_params = &params->per_vcpu[vcpu->id];
+
+	vcpu_params->guest_code = (uint64_t)guest_code;
+}
-- 
2.51.0.rc1.193.gad69d77794-goog


