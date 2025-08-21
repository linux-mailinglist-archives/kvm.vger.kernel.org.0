Return-Path: <kvm+bounces-55250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 365BDB2ECF7
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 06:36:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 46323B623DB
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 04:32:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9071B2EBB85;
	Thu, 21 Aug 2025 04:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s4v+XJUm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93132EB5AF
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 04:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755750587; cv=none; b=Stg8WaMGM7PW5v4auzFA9CB8AYpZ+6M2Xgu5H1JX3kz06DN7fDhcfrauWflIEdE6ffo6tnKUaEwP0MzGOXrj51jyEdfanq+TzIOaqCQ8ii4Y/g/fCscvoR7z5AjeYGvpNuNx5NGRTv+sdbBvubSLpP2NcDghdEPvgDCzxuzvetA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755750587; c=relaxed/simple;
	bh=m3Ri8EOCJWQEZ/4FSF9yjTz3eDvfep4JMqgy1mWrXGs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H8vsTuMR0kNiQpqS9f3OCWAQsN0KRsCSfgmo2K2QDU8u9oY+XrFK2fekN50aE97+Ot/0120uVdowQUdFZ1007PKBp/fRQCE9Vi9Eb1voFpzR1IV25p2Mky2LzJRA1Ozasqa7o2Gb7dN8rI9KDkEd6yObWWAf3z1yQZ4AwiaTcBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s4v+XJUm; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76e364afb44so502026b3a.3
        for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 21:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755750585; x=1756355385; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tBQFuFZYWge8bx60kNf5qVNyqDjFsXjzBvHdLVsh8nI=;
        b=s4v+XJUmoD1HLXSXDRYfdy4vQf3KxFIIOtK4yoA7JBDkOrStfYs/KRhBQ199LhCVFH
         vuqxTK7k7aj6C9/WNh4VVeR3ly08zJoW+j5c6TKKTqWL92dMvujK3iPyYbKlUBqvy3qF
         D/JQV0RXQoO3UUOrd2pl5tSO5jxqpg4RN1LVxug+qrCuKSyh4/FuJdOx8A5ST+dVl/9U
         EI2xsC5N9CohbrAyb8Rxbu+GBrKxgr/vIsn/aLV1mQTYH/s5o4dNUzG5txgMLIpynRB7
         vZXuk3r53dIci5WQOLhRg5a7KGBNp1d4HAQIHTRXttBfYVBaADzdDO8+t2q/DrQy9as3
         djHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755750585; x=1756355385;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tBQFuFZYWge8bx60kNf5qVNyqDjFsXjzBvHdLVsh8nI=;
        b=a6pdFYc3/Jt31JdDa+TI8kOKTETmnIQv0o//H67jlJ6mxpsCd4rFyMC12cBnqCFl1r
         uVFB1c3kIKZMRrm3g2jyDeZttdq416b1Yz2PLno6uR0wzTM3p60xKBVL3BqrnhYHat6T
         mrUHgHhlsStN0q6c5m7gU3Y1cXn1lIUjrn+tLVSas9gpZxREfJsJY0uTxDWs+sUhdzd4
         a8VuQsHlQ9VGTn0F9np+a6cQaNduuEcrWdPFJfkFoAjnUZ+o27NjH+KO2ftfL5t5nkmq
         yzh7h2L1PIZbhuFoLyZDW1yZhqmX2BfzZH1k8FaxoVixlFoWgA3mOaTHIRQIiPal62TT
         3N5A==
X-Forwarded-Encrypted: i=1; AJvYcCWdi4zrsOLjfE3onnavQtqiewKTDRDe2F6rbd3HmwxcV+RPWTIqfT41sOzLA7lqtuT7aSk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqXjUyOdBy+q6FnoXL00oZ7YSSiuecIFyC1GeLGIVr/RGIvEGs
	3UYdqq0uVXDlBhVNQnKJh5qwZE6pb6OR2ZaQXaYWo7RtlapibNzcTj8XJmNXE47RtkS3GwT/Jec
	DPw==
X-Google-Smtp-Source: AGHT+IH/I8if9wLwMPgXY315eQh/FR5Hg8ZLke7otIfPDonF6CjXt5sWEqVQ5gJKNGQL276+i/A2sjmXLw==
X-Received: from pfbna33.prod.google.com ([2002:a05:6a00:3e21:b0:76e:9907:3909])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:23d1:b0:76e:885a:c334
 with SMTP id d2e1a72fcca58-76ea326634bmr1164724b3a.26.1755750585082; Wed, 20
 Aug 2025 21:29:45 -0700 (PDT)
Date: Wed, 20 Aug 2025 21:29:07 -0700
In-Reply-To: <20250821042915.3712925-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250821042915.3712925-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.rc1.193.gad69d77794-goog
Message-ID: <20250821042915.3712925-15-sagis@google.com>
Subject: [PATCH v9 14/19] KVM: selftests: Add helpers to init TDX memory and
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
 .../selftests/kvm/lib/x86/tdx/tdx_util.c      | 97 +++++++++++++++++++
 2 files changed, 99 insertions(+)

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
index d8eab99d9333..4024587ed3c2 100644
--- a/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
+++ b/tools/testing/selftests/kvm/lib/x86/tdx/tdx_util.c
@@ -274,3 +274,100 @@ void vm_tdx_init_vm(struct kvm_vm *vm, uint64_t attributes)
 
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
+static void tdx_init_pages(struct kvm_vm *vm, void *hva, uint64_t gpa,
+			   uint64_t size)
+{
+	void *scratch_page = calloc(1, PAGE_SIZE);
+	uint64_t nr_pages = size / PAGE_SIZE;
+	int i;
+
+	TEST_ASSERT(scratch_page,
+		    "Could not allocate memory for loading memory region");
+
+	for (i = 0; i < nr_pages; i++) {
+		memcpy(scratch_page, hva, PAGE_SIZE);
+
+		tdx_init_mem_region(vm, scratch_page, gpa, PAGE_SIZE);
+
+		hva += PAGE_SIZE;
+		gpa += PAGE_SIZE;
+	}
+
+	free(scratch_page);
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
+
+		sparsebit_idx_t i;
+		sparsebit_idx_t j;
+
+		if (!sparsebit_any_set(protected_pages))
+			continue;
+
+		sparsebit_for_each_set_range(protected_pages, i, j) {
+			const uint64_t size_to_load = (j - i + 1) * vm->page_size;
+			const uint64_t offset =
+				(i - lowest_page_in_region) * vm->page_size;
+			const uint64_t hva = hva_base + offset;
+			const uint64_t gpa = gpa_base + offset;
+
+			vm_set_memory_attributes(vm, gpa, size_to_load,
+						 KVM_MEMORY_ATTRIBUTE_PRIVATE);
+
+			/*
+			 * Here, memory is being loaded from hva to gpa. If the memory
+			 * mapped to hva is also used to back gpa, then a copy has to be
+			 * made just for loading, since KVM_TDX_INIT_MEM_REGION ioctl
+			 * cannot encrypt memory in place.
+			 *
+			 * To determine if memory mapped to hva is also used to back
+			 * gpa, use a heuristic:
+			 *
+			 * If this memslot has guest_memfd, then this memslot should
+			 * have memory backed from two sources: hva for shared memory
+			 * and gpa will be backed by guest_memfd.
+			 */
+			if (region->region.guest_memfd == -1)
+				tdx_init_pages(vm, (void *)hva, gpa, size_to_load);
+			else
+				tdx_init_mem_region(vm, (void *)hva, gpa, size_to_load);
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
2.51.0.rc1.193.gad69d77794-goog


