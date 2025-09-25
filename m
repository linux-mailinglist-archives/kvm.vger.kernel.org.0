Return-Path: <kvm+bounces-58802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF5BDBA0E00
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 19:34:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 868336C1B7C
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 17:33:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7718331E8BD;
	Thu, 25 Sep 2025 17:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dziUl5Tl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F5A31D399
	for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 17:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758821364; cv=none; b=eNGkklTMt6jO4kdJeg1SJC9sAGw1/m8NUZ+08hnT8IAR6DBETIsracvqVnomrhg+o10z+PCZm0jMdQsnIHOoAtE6ZolrSyLKcRpAtskwI/0C1o4D2iJV6ZIsnQjnF1XUal6J44qoMdUS5Nbe6/SjX1AVNp4EWFkfbYcHRcDOF6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758821364; c=relaxed/simple;
	bh=DUH9fjzyZeNaJk1vwhK4spw7UfiiPdlKPNLppXCGf6A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c3AB/GUYcukQCFWx24+LlO2eBZTCasFguI/ufBxFRY4CFclsZYlyDLfp9dZO69Lvck1ClkvXux+llGQnBf6ABv9QJzksSL8WYMhBdAQ+g7jtesjiwQ7dxw3xw/CYZxuRCbkAmr1cTEP+d+j1nfxIsgD4f7CV9JLmE84E/2Mwpo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dziUl5Tl; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-77f180e8da5so1513873b3a.3
        for <kvm@vger.kernel.org>; Thu, 25 Sep 2025 10:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758821361; x=1759426161; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UwluHtdboHgFkjYLYoAoxhCM/ZvR3gc2caEP86bvb2g=;
        b=dziUl5Tl5bolv7VWhbzYosLweLmTfkb5PAd+ZiCzZqdttYHlGyU2OHjLWDrGxYqzNY
         /Xdpx84m2/KP6U3+BXuGRyNKEL8iDptuDE//c1M6d9xdOzjMO9EJscBnDIbgWfbm3szH
         i5QpjWpaKjryA3UTvyqrWxxXz5PEg1Eno55YBuIS6tSbrQy0fuTaCeIMvonCIg8rS+V4
         60ZQy1fE7i9upYH5pigfGMHnCRPV9XISxUuk8xgxEDSvpDKoKcCPA5msTHI5SnTvPTZp
         CJLQaSvux9LYvkr/FUXLjncI7cMm2e1ZNIMBb7EQ3yPAN4p+m947NJa4BYaOcLV0wWiE
         rUwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758821361; x=1759426161;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UwluHtdboHgFkjYLYoAoxhCM/ZvR3gc2caEP86bvb2g=;
        b=kM+Jtnz2oVLmT7OucztTlaYSBjRherd559O29HpkAlmYuoTSXeCSOO0h7fm9HawQRX
         tBw1WLd4g9ko05wDIqSTV4VYoluArzZ+7/iqovX+Xewm96MbDJu2aDeIMlRhpTN6FlGd
         NBy7zvXeAYOOtM56cLp1mRXd0pSU9TSiv86uY3HGHqvJkGKYsX9NYu2SN6RYzTV1gLlH
         6Nh1N8I7JWMOPIOJVp6ptC/e/5UlgiON/oS09MnDFNZOn4qssdUYOBmZKsPwsoXYJkiq
         Jssk+ys+22bvuNIri3qLb1GLLH6SfOIdm1gmYH0S12I55rpRd3pqd/WeWE9582wg2vFm
         ux1w==
X-Forwarded-Encrypted: i=1; AJvYcCUOM9pAPy8/dIhE3M47j1EdSSjoNGAHe3uIqItl0Q+/uo41guEtQ/MRRE6e3VTX5ffHSXg=@vger.kernel.org
X-Gm-Message-State: AOJu0YypztB6D/esRBn4WF5M9a9xr4L6vG5GbSL2I8L1umnfpRuMZTIq
	sfZ67dosOO7xd5QCSrVlpuFb90aPdU6IMOQkt0Ar033XXSQQcXhgcdO9rhJ4Z250QPcnZ0kowxl
	8pg==
X-Google-Smtp-Source: AGHT+IG5bIjhoprp/h1DT6S8BYHcRFaJOqG+ix6N3YO2qGG59dz6qELsQRMpwnSKkFLz6xfS5/BegDK77g==
X-Received: from pfug20.prod.google.com ([2002:a05:6a00:794:b0:77f:3341:eef2])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:194f:b0:77d:2ca7:84be
 with SMTP id d2e1a72fcca58-780fcea2dd6mr4953965b3a.18.1758821360611; Thu, 25
 Sep 2025 10:29:20 -0700 (PDT)
Date: Thu, 25 Sep 2025 10:28:41 -0700
In-Reply-To: <20250925172851.606193-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250925172851.606193-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
Message-ID: <20250925172851.606193-14-sagis@google.com>
Subject: [PATCH v11 13/21] KVM: selftests: Add helpers to init TDX memory and
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
2.51.0.536.g15c5d4f767-goog


