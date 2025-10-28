Return-Path: <kvm+bounces-61338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 434DBC16F49
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 22:25:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E65863BC1F9
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 21:24:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 074483587DD;
	Tue, 28 Oct 2025 21:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OYbwj55L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC04C357739
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 21:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761686471; cv=none; b=Ryw+iZXzP9TsfVERVGZmn/ujAIJ7t3yo6OW3XVm2U+4RRYwWpCWciWSYQwSIupF9CFE5sI5Dn/XUSzI5gQgdl3BrnoF7VHzYyjew9xUdu4bRR7g5o/JoJBgK9iG9cL3gwZNM0U4Z8ZynQqpFC8N5AbVI7roccKxdrR/ERnsih1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761686471; c=relaxed/simple;
	bh=vjcKoVxUyMFdBNpUH5EV0hEcZvuRzhIkP9civjlkuQo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=f3LOuo40PpwxUNZeRgVD656tZSEeW8YCAYdRMSkewnGAU1iIz6vEy3CpAu1HSKNUdWgjFk6MNYsnKeiirUEZdsKempl51WgbHsd/hBDHEAjJh8qYLwo6CQMg2Lv+eIzGcLzNVQvrMkHw6N50LhVc0wZBUhqCi9CKWfC6n0JvbOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OYbwj55L; arc=none smtp.client-ip=209.85.210.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-ot1-f73.google.com with SMTP id 46e09a7af769-7c52a4599abso2557179a34.1
        for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 14:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761686469; x=1762291269; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0oc8rR4nuEc1GfIKeSsx9lUre37E4S8CP1H4USv00uM=;
        b=OYbwj55L3cQCBhbAVhG9X5w87LENn7YqY8ZNdyYxm8o6VyF9p2o/nqKcv7DapNH69N
         wf4ql7GjrUUc0NHfl2MTNy+52avztxPrvYkpmqhXqGGWX6rpeeQTAjRhlYIvdT6JX+ZX
         ncTXPCHgv+Mk9xM1pkSpAR4Sw655RG1s+UaxuxCBITbY0kV8K/zDons4jDmjA7d0JL0N
         sQYX+bA/tooOoQokEfecNbP9kicAs4+bz8bnbKaGC/STTr4uJjmW/1vPTNaeL4bVknnX
         jASnmqLAXFnYH8UbjwbYxHLZhlt3Lx8JzPCyiF9RYJkCZr9mOX4r26KSHHqnJftM4H5I
         HeGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761686469; x=1762291269;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0oc8rR4nuEc1GfIKeSsx9lUre37E4S8CP1H4USv00uM=;
        b=JfX+Ef8Q2XTILVkiFaYVfgD1CwShKcQuRUB4WJ7MpEXE72s/wrp6LMULmaaoWl1S1v
         2/swd22hChIloVpWo8rfKKhd575qh+jX3MZpD7+ks2vRDIizewCsL3m67AnSFr2YO/bF
         tp8IKI4lf4CBKRHnyMwyUSr8gEk57+sTzZIOFINZeVYJ42RZ8sD0sJuosmD8xUahnpK7
         1rRPNWVGKLRwyPhIFJwWtB+75AYKCnaa6YLaYs+3W5wlT4C5wZI/H0s/EU4sfTFAuHjF
         /+AfjVModS/qxMmql4J7tbIbIvsyhn5aM2DhSmQ2MqZcRNuGM8EWGM0dvJsAGQ3Cj17U
         yEqw==
X-Forwarded-Encrypted: i=1; AJvYcCXMXiSi4xjP3wQdJxDhgfbyrBnzH4QDRtdYy5FH/0dQghNFMz5NYsIsqRwIfq4FhZWA6iM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyChDKy3rApvH9far38eKvr8e4zS7IIBnIxNMr4pox7E0j8KB9L
	JRXzj2DkrS+rqykOTdhgY6Ubm8cF49aGgvzGW04NcGRSu8LPBLh7AUXxOjVuD/Esay2DSAnez+9
	TzA==
X-Google-Smtp-Source: AGHT+IHZMCGdpKqrQt1Ndz8cUX7RM3WeHfxynrLZL3xwZ6VBiPV5P6FIbF6ZCFaX1uUWwjdSNsQwirMvAA==
X-Received: from oibb23-n1.prod.google.com ([2002:a05:6808:a597:10b0:44d:b42b:240a])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6808:c169:b0:44d:baaa:c52e
 with SMTP id 5614622812f47-44f7a55580bmr384625b6e.46.1761686469038; Tue, 28
 Oct 2025 14:21:09 -0700 (PDT)
Date: Tue, 28 Oct 2025 21:20:40 +0000
In-Reply-To: <20251028212052.200523-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251028212052.200523-1-sagis@google.com>
X-Mailer: git-send-email 2.51.1.851.g4ebd6896fd-goog
Message-ID: <20251028212052.200523-15-sagis@google.com>
Subject: [PATCH v12 14/23] KVM: selftests: Add helpers to init TDX memory and
 finalize VM
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

From: Ackerley Tng <ackerleytng@google.com>

TDX protected memory needs to be measured and encrypted before it can be
used by the guest. Traverse the VM's memory regions and initialize all
the protected ranges by calling KVM_TDX_INIT_MEM_REGION.

Once all the memory is initialized, the VM can be finalized by calling
KVM_TDX_FINALIZE_VM.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Erdem Aktas <erdemaktas@google.com>
Signed-off-by: Erdem Aktas <erdemaktas@google.com>
Co-developed-by: Sagi Shahar <sagis@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 .../selftests/kvm/include/x86/tdx/tdx_util.h  |  2 +
 .../selftests/kvm/lib/x86/tdx/tdx_util.c      | 58 +++++++++++++++++++
 2 files changed, 60 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h b/tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h
index a2509959c7ce..2467b6c35557 100644
--- a/tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h
+++ b/tools/testing/selftests/kvm/include/x86/tdx/tdx_util.h
@@ -71,4 +71,6 @@ void vm_tdx_load_common_boot_parameters(struct kvm_vm *vm);
 void vm_tdx_load_vcpu_boot_parameters(struct kvm_vm *vm, struct kvm_vcpu *vcpu);
 void vm_tdx_set_vcpu_entry_point(struct kvm_vcpu *vcpu, void *guest_code);
 
+void vm_tdx_finalize(struct kvm_vm *vm);
+
 #endif // SELFTESTS_TDX_TDX_UTIL_H
diff --git a/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c b/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
index 2551b3eac8f8..53cfadeff8de 100644
--- a/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
+++ b/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
@@ -270,3 +270,61 @@ void vm_tdx_init_vm(struct kvm_vm *vm, uint64_t attributes)
 
 	free(init_vm);
 }
+
+static void tdx_init_mem_region(struct kvm_vm *vm, void *source_pages,
+				uint64_t gpa, uint64_t size)
+{
+	uint32_t metadata = KVM_TDX_MEASURE_MEMORY_REGION;
+	struct kvm_tdx_init_mem_region mem_region = {
+		.source_addr = (uint64_t)source_pages,
+		.gpa = gpa,
+		.nr_pages = size / PAGE_SIZE,
+	};
+	struct kvm_vcpu *vcpu;
+
+	vcpu = list_first_entry_or_null(&vm->vcpus, struct kvm_vcpu, list);
+
+	TEST_ASSERT((mem_region.nr_pages > 0) &&
+		    ((mem_region.nr_pages * PAGE_SIZE) == size),
+		    "Cannot add partial pages to the guest memory.\n");
+	TEST_ASSERT(((uint64_t)source_pages & (PAGE_SIZE - 1)) == 0,
+		    "Source memory buffer is not page aligned\n");
+	vm_tdx_vcpu_ioctl(vcpu, KVM_TDX_INIT_MEM_REGION, metadata, &mem_region);
+}
+
+static void load_td_private_memory(struct kvm_vm *vm)
+{
+	struct userspace_mem_region *region;
+	int ctr;
+
+	hash_for_each(vm->regions.slot_hash, ctr, region, slot_node) {
+		const struct sparsebit *protected_pages = region->protected_phy_pages;
+		const vm_paddr_t gpa_base = region->region.guest_phys_addr;
+		const uint64_t hva_base = region->region.userspace_addr;
+		const sparsebit_idx_t lowest_page_in_region = gpa_base >> vm->page_shift;
+		sparsebit_idx_t i, j;
+
+		if (!sparsebit_any_set(protected_pages))
+			continue;
+
+		TEST_ASSERT(region->region.guest_memfd != -1,
+			    "TD private memory must be backed by guest_memfd");
+
+		sparsebit_for_each_set_range(protected_pages, i, j) {
+			const uint64_t size_to_load = (j - i + 1) * vm->page_size;
+			const uint64_t offset =
+				(i - lowest_page_in_region) * vm->page_size;
+			const uint64_t hva = hva_base + offset;
+			const uint64_t gpa = gpa_base + offset;
+
+			vm_mem_set_private(vm, gpa, size_to_load);
+			tdx_init_mem_region(vm, (void *)hva, gpa, size_to_load);
+		}
+	}
+}
+
+void vm_tdx_finalize(struct kvm_vm *vm)
+{
+	load_td_private_memory(vm);
+	vm_tdx_vm_ioctl(vm, KVM_TDX_FINALIZE_VM, 0, NULL);
+}
-- 
2.51.1.851.g4ebd6896fd-goog


