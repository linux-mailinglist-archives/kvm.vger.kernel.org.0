Return-Path: <kvm+bounces-66887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 47AA1CEAD4D
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 00:06:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EED4E30519F2
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 23:04:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F3E032FA12;
	Tue, 30 Dec 2025 23:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QC5JJ93d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB7A32862B
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 23:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767135745; cv=none; b=HjgOgIejOFzkqxwxIdeLFAcIWtEcJ8Db84YL6heA0bOpStW839TXqlq0cpyny7Npfkx6nAkbW6Cd5w/F46gSJDbeS+NOkghUbTLEhHMlToBalbcVCZjkToO2yiJBYvLKNdeo/mb8F3Ctgtqu55Aq4h/t3RrugTt3NXZz1M7gLA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767135745; c=relaxed/simple;
	bh=MPbkHc4GV4TzFE9XoAUnnbKF5eS/YzsDgg5s4A8v2yQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=upzaFqNICSZgdn0oxxOXzHQGO0YyQOXfRa4/gvQt6JBYI9/ahoblztvKxQU5DZ8irfc/0PXQjWlIwZNf7VW9BmCGYWdKcUZgU+65xuA1/2nzbeBYe6iWCEvVvHRICFIxtHDGfsFNomLygVZ8yr2XTtnpWxKwhuS4Mqu3jk1lg34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QC5JJ93d; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34ac814f308so23353030a91.3
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 15:02:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767135740; x=1767740540; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=J6aMxlCW9zWw4tw+lh+J4j0Q+W18rvfDg7v6hfZtyes=;
        b=QC5JJ93dMbM5QK+ubSuJf0hON/hzsIi1EgqzhnOjxGW7/reU2Z1vl+KkBX7NbutwK4
         5k4bShqEy18WORIf8N0woE6Ukg9FMteAM+dV7cEaZUkrp5AoiSJ6gqy/3blRcs+0JwLc
         E+AT/968f29drHcOwwu+F/6WFx0XqO4MKZ7UogInMuVVQOp0LU+kV08VmciGfc3AIJ+e
         S2uZU2Wjo77++tJxXvT/0DESmtNwcP9z5im26ehIyc3dDJdc/ueAk/H+ajPnYi3j6Owz
         DCxMUC0+/6lZka/lvNRk225erzZJ2ZhqqhxpWPRdIb1Nz2vHWoEEvaN/TBDtND9hof3e
         gIgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767135740; x=1767740540;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J6aMxlCW9zWw4tw+lh+J4j0Q+W18rvfDg7v6hfZtyes=;
        b=AKqGnDYzMDNy3jrhHhN/5q2lvP7ztYP59mTOE3xENXA/B5s3bHoIWJvXwbarqU/bGN
         IsaOw6md2kljx7B18xrHePdnlmCAucgaO0nuZ8GPLJHasf64JFOheuStjk2zwP0NVHqV
         MJTnDzNkZL88KY/t5zY/ksUBX0wQP4ezdHKXpfxzAPtfMlzG9am2YmpnpqLRzR3jUDoK
         GBO0DMMRqwbqFLK3cCBOpA9i6pixkn7N7TuvaxGPWi+BRjQhKhKFMnu1B/fI8BhM3NN0
         7WIoS98tAWlM+86BeEd+4l2fRzdiyL6WO4UdvGjs6YS8lNHrZ7ZcblVDWoKpcFTn6mfY
         Zk/g==
X-Gm-Message-State: AOJu0Yzo1E06JGT2lNOvn0mP0DZf3kE97Wkttcq/1CbRZ3lZXtSEwbyB
	rw0NnvXibZtnDMjvtiz/ipfJtB5cA6KzpKiVhLkqCGX212le4iVxrBaf31xv446y5lM8cQON5Wd
	ufsZSGg==
X-Google-Smtp-Source: AGHT+IESYs7jwx5GIZk4Cye/l7AaZRkTq4obaLXSbCdWxS8VVf/3eTwf0I/EcUJvNMDTKAMTNzECK0j0uSQ=
X-Received: from pjbkk6.prod.google.com ([2002:a17:90b:4a06:b0:34e:795d:fe31])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:49:b0:343:5f43:933e
 with SMTP id 98e67ed59e1d1-34e921afaf8mr26205194a91.19.1767135740506; Tue, 30
 Dec 2025 15:02:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 15:01:45 -0800
In-Reply-To: <20251230230150.4150236-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251230230150.4150236-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230230150.4150236-17-seanjc@google.com>
Subject: [PATCH v4 16/21] KVM: selftests: Add support for nested NPTs
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

From: Yosry Ahmed <yosry.ahmed@linux.dev>

Implement nCR3 and NPT initialization functions, similar to the EPT
equivalents, and create common TDP helpers for enablement checking and
initialization. Enable NPT for nested guests by default if the TDP MMU
was initialized, similar to VMX.

Reuse the PTE masks from the main MMU in the NPT MMU, except for the C
and S bits related to confidential VMs.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86/processor.h     |  2 ++
 .../selftests/kvm/include/x86/svm_util.h      |  9 ++++++++
 .../testing/selftests/kvm/lib/x86/memstress.c |  4 ++--
 .../testing/selftests/kvm/lib/x86/processor.c | 15 +++++++++++++
 tools/testing/selftests/kvm/lib/x86/svm.c     | 21 +++++++++++++++++++
 .../selftests/kvm/x86/vmx_dirty_log_test.c    |  4 ++--
 6 files changed, 51 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index d134c886f280..deb471fb9b51 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1477,6 +1477,8 @@ void __virt_pg_map(struct kvm_vm *vm, struct kvm_mmu *mmu, uint64_t vaddr,
 void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
 		    uint64_t nr_bytes, int level);
 
+void vm_enable_tdp(struct kvm_vm *vm);
+bool kvm_cpu_has_tdp(void);
 void tdp_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr, uint64_t size);
 void tdp_identity_map_default_memslots(struct kvm_vm *vm);
 void tdp_identity_map_1g(struct kvm_vm *vm,  uint64_t addr, uint64_t size);
diff --git a/tools/testing/selftests/kvm/include/x86/svm_util.h b/tools/testing/selftests/kvm/include/x86/svm_util.h
index b74c6dcddcbd..5d7c42534bc4 100644
--- a/tools/testing/selftests/kvm/include/x86/svm_util.h
+++ b/tools/testing/selftests/kvm/include/x86/svm_util.h
@@ -27,6 +27,9 @@ struct svm_test_data {
 	void *msr; /* gva */
 	void *msr_hva;
 	uint64_t msr_gpa;
+
+	/* NPT */
+	uint64_t ncr3_gpa;
 };
 
 static inline void vmmcall(void)
@@ -57,6 +60,12 @@ struct svm_test_data *vcpu_alloc_svm(struct kvm_vm *vm, vm_vaddr_t *p_svm_gva);
 void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_rsp);
 void run_guest(struct vmcb *vmcb, uint64_t vmcb_gpa);
 
+static inline bool kvm_cpu_has_npt(void)
+{
+	return kvm_cpu_has(X86_FEATURE_NPT);
+}
+void vm_enable_npt(struct kvm_vm *vm);
+
 int open_sev_dev_path_or_exit(void);
 
 #endif /* SELFTEST_KVM_SVM_UTILS_H */
diff --git a/tools/testing/selftests/kvm/lib/x86/memstress.c b/tools/testing/selftests/kvm/lib/x86/memstress.c
index 3319cb57a78d..407abfc34909 100644
--- a/tools/testing/selftests/kvm/lib/x86/memstress.c
+++ b/tools/testing/selftests/kvm/lib/x86/memstress.c
@@ -82,9 +82,9 @@ void memstress_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vc
 	int vcpu_id;
 
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
-	TEST_REQUIRE(kvm_cpu_has_ept());
+	TEST_REQUIRE(kvm_cpu_has_tdp());
 
-	vm_enable_ept(vm);
+	vm_enable_tdp(vm);
 	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
 		vcpu_alloc_vmx(vm, &vmx_gva);
 
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 29e7d172f945..a3a4c9a4cbcb 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -8,7 +8,9 @@
 #include "kvm_util.h"
 #include "pmu.h"
 #include "processor.h"
+#include "svm_util.h"
 #include "sev.h"
+#include "vmx.h"
 
 #ifndef NUM_INTERRUPTS
 #define NUM_INTERRUPTS 256
@@ -472,6 +474,19 @@ void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 	}
 }
 
+void vm_enable_tdp(struct kvm_vm *vm)
+{
+	if (kvm_cpu_has(X86_FEATURE_VMX))
+		vm_enable_ept(vm);
+	else
+		vm_enable_npt(vm);
+}
+
+bool kvm_cpu_has_tdp(void)
+{
+	return kvm_cpu_has_ept() || kvm_cpu_has_npt();
+}
+
 void __tdp_map(struct kvm_vm *vm, uint64_t nested_paddr, uint64_t paddr,
 	       uint64_t size, int level)
 {
diff --git a/tools/testing/selftests/kvm/lib/x86/svm.c b/tools/testing/selftests/kvm/lib/x86/svm.c
index d239c2097391..8e4795225595 100644
--- a/tools/testing/selftests/kvm/lib/x86/svm.c
+++ b/tools/testing/selftests/kvm/lib/x86/svm.c
@@ -59,6 +59,22 @@ static void vmcb_set_seg(struct vmcb_seg *seg, u16 selector,
 	seg->base = base;
 }
 
+void vm_enable_npt(struct kvm_vm *vm)
+{
+	struct pte_masks pte_masks;
+
+	TEST_ASSERT(kvm_cpu_has_npt(), "KVM doesn't supported nested NPT");
+
+	/*
+	 * NPTs use the same PTE format, but deliberately drop the C-bit as the
+	 * per-VM shared vs. private information is only meant for stage-1.
+	 */
+	pte_masks = vm->mmu.arch.pte_masks;
+	pte_masks.c = 0;
+
+	tdp_mmu_init(vm, vm->mmu.pgtable_levels, &pte_masks);
+}
+
 void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_rsp)
 {
 	struct vmcb *vmcb = svm->vmcb;
@@ -102,6 +118,11 @@ void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_r
 	vmcb->save.rip = (u64)guest_rip;
 	vmcb->save.rsp = (u64)guest_rsp;
 	guest_regs.rdi = (u64)svm;
+
+	if (svm->ncr3_gpa) {
+		ctrl->nested_ctl |= SVM_NESTED_CTL_NP_ENABLE;
+		ctrl->nested_cr3 = svm->ncr3_gpa;
+	}
 }
 
 /*
diff --git a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
index 370f8d3117c2..032ab8bf60a4 100644
--- a/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_dirty_log_test.c
@@ -93,7 +93,7 @@ static void test_vmx_dirty_log(bool enable_ept)
 	/* Create VM */
 	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
 	if (enable_ept)
-		vm_enable_ept(vm);
+		vm_enable_tdp(vm);
 
 	vcpu_alloc_vmx(vm, &vmx_pages_gva);
 	vcpu_args_set(vcpu, 1, vmx_pages_gva);
@@ -170,7 +170,7 @@ int main(int argc, char *argv[])
 
 	test_vmx_dirty_log(/*enable_ept=*/false);
 
-	if (kvm_cpu_has_ept())
+	if (kvm_cpu_has_tdp())
 		test_vmx_dirty_log(/*enable_ept=*/true);
 
 	return 0;
-- 
2.52.0.351.gbe84eed79e-goog


