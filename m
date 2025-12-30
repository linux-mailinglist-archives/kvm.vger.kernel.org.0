Return-Path: <kvm+bounces-66890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D3C73CEAD65
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 00:11:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2F50C30094F8
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 23:11:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03777331208;
	Tue, 30 Dec 2025 23:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KHJJfccE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3592F25F0
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 23:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767135752; cv=none; b=SYo4AHj41t8KBdKjAxXu6jyUBLKvMySMIEoG1f+N/XU/lhZiKTnRknrwMcvm3lkCkWx4IIMNBtaH8YFw14Gdr7hEPyt6VhQNI7r19GFk6SPKgBTnNSfd1czvDaqGbtmUUguv7JjeB5XbItirY1mGwihFO38P4PhoAKhFf7YOILM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767135752; c=relaxed/simple;
	bh=Eq5mGpLfTFizGCRwHdHtCNJ7Yw0gxiv2sS6vsyfOLoI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZhIjpZx1rTzMhQv95xL8R4opb2CodETyeQV5dm3CngcIwAqRP17zWQiZ523WPfjHcrBF6Bz3M73DrDzBH5WEab0Hv8pwC2dz7ENX9Mr8a0SfwdhF2FpzHz64by4gY7Em1RncQQ4Zugic1IAf6xCb2P8vS88Hm0zT6dWU/u9/Z0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KHJJfccE; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7b9c91b814cso23582152b3a.2
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 15:02:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767135747; x=1767740547; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=DkXelmu7bqFxndg8qpo6pKIzfvXDHv9zHII5ienX1m4=;
        b=KHJJfccEAu9ygfghc1NclStBZFqg2G+X34jOX1BC7x2tVkMyGfJ70S9zZTcMQw8efJ
         yZw2SWk3JEtm1ah4KcaRwGbHsWS/3nQaZsi/1nnFemLNnXEy43XP6mneOtej3DKMT6UZ
         TQbTSxwlWePWhHWORKPMxghOiSic6KdOfWg7mj/7TyYwQ8AZ/djoGqPrmtCsb1ZQrA2I
         XRg0u8mGAqUosc31n0M6crfNVMIfeE9Y6VrHxNbHz8RjjXRXe8v/nl3YWFl7S0BKWpfg
         52oQ0AdXq4vmiNnWtsKTEs7+/3U1R02X3fdJZqNDE6fWeFU1XLc8RT5wB9E4oAJB/1HO
         R2qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767135747; x=1767740547;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DkXelmu7bqFxndg8qpo6pKIzfvXDHv9zHII5ienX1m4=;
        b=Hswncl+Jaoq+Yp4hTqmjANWxmq5WklOd07m+Oc7Q3bdAbNfs3VGikg9fzfE3RGvxvc
         lllLqplpcMk2ZtB15HSUQswrqHDrjTgZkN6/Or91c0wn08yS4a7CHdzyFocbRS6tB7PL
         xSOXKJS1M9KVve3sUgwOPDXWTYADtKxw3TeujZDvgakZuawFJQ91gAZV2Z2neqXhD/7t
         f0G6yrld6Fc+Vx+xmVOpynyUE7x2ONNeOru/OZLQahAeiXZUZ43LfEKLt/2FcZ2rSwhW
         boRjZ7MN8091Vs+0LGmHtgT+EoX/cNJJx4+XM4Z/DPei6FCkGXJnphoEc/NTQRyI7JWZ
         Ntcw==
X-Gm-Message-State: AOJu0Yyxnhd0ioNS4HIr8VOcTdGWr2zqKeiW6FBDXd7NkW43H+clvdiR
	112F1mxmDoyuX5o722+uHSGIQ0q/32iAGnbwDl1LfxACeqxeS9CTaYMI59hAtYCtaeskHkNHpyY
	jl0J6ag==
X-Google-Smtp-Source: AGHT+IEInX/hcWFTn62wzbw74nK2yGoqn05dsItc6QCyzO/aFUt0jVk0kLNXelUPHMxHCU04rbTUsERgFgA=
X-Received: from pgav5.prod.google.com ([2002:a05:6a02:2dc5:b0:b55:6eb3:fd4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7346:b0:319:fc6f:8adf
 with SMTP id adf61e73a8af0-376a81e2c20mr34940934637.12.1767135747025; Tue, 30
 Dec 2025 15:02:27 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 15:01:48 -0800
In-Reply-To: <20251230230150.4150236-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251230230150.4150236-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230230150.4150236-20-seanjc@google.com>
Subject: [PATCH v4 19/21] KVM: selftests: Extend memstress to run on nested SVM
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

Add L1 SVM code and generalize the setup code to work for both VMX and
SVM. This allows running 'dirty_log_perf_test -n' on AMD CPUs.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/lib/x86/memstress.c | 42 +++++++++++++++----
 1 file changed, 35 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86/memstress.c b/tools/testing/selftests/kvm/lib/x86/memstress.c
index 407abfc34909..86f4c5e4c430 100644
--- a/tools/testing/selftests/kvm/lib/x86/memstress.c
+++ b/tools/testing/selftests/kvm/lib/x86/memstress.c
@@ -13,6 +13,7 @@
 #include "kvm_util.h"
 #include "memstress.h"
 #include "processor.h"
+#include "svm_util.h"
 #include "vmx.h"
 
 void memstress_l2_guest_code(uint64_t vcpu_id)
@@ -29,9 +30,10 @@ __asm__(
 "	ud2;"
 );
 
-static void memstress_l1_guest_code(struct vmx_pages *vmx, uint64_t vcpu_id)
-{
 #define L2_GUEST_STACK_SIZE 64
+
+static void l1_vmx_code(struct vmx_pages *vmx, uint64_t vcpu_id)
+{
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
 	unsigned long *rsp;
 
@@ -45,10 +47,34 @@ static void memstress_l1_guest_code(struct vmx_pages *vmx, uint64_t vcpu_id)
 	prepare_vmcs(vmx, memstress_l2_guest_entry, rsp);
 
 	GUEST_ASSERT(!vmlaunch());
-	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
+	GUEST_ASSERT_EQ(vmreadz(VM_EXIT_REASON), EXIT_REASON_VMCALL);
 	GUEST_DONE();
 }
 
+static void l1_svm_code(struct svm_test_data *svm, uint64_t vcpu_id)
+{
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	unsigned long *rsp;
+
+
+	rsp = &l2_guest_stack[L2_GUEST_STACK_SIZE - 1];
+	*rsp = vcpu_id;
+	generic_svm_setup(svm, memstress_l2_guest_entry, rsp);
+
+	run_guest(svm->vmcb, svm->vmcb_gpa);
+	GUEST_ASSERT_EQ(svm->vmcb->control.exit_code, SVM_EXIT_VMMCALL);
+	GUEST_DONE();
+}
+
+
+static void memstress_l1_guest_code(void *data, uint64_t vcpu_id)
+{
+	if (this_cpu_has(X86_FEATURE_VMX))
+		l1_vmx_code(data, vcpu_id);
+	else
+		l1_svm_code(data, vcpu_id);
+}
+
 uint64_t memstress_nested_pages(int nr_vcpus)
 {
 	/*
@@ -78,15 +104,17 @@ static void memstress_setup_ept_mappings(struct kvm_vm *vm)
 void memstress_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vcpus[])
 {
 	struct kvm_regs regs;
-	vm_vaddr_t vmx_gva;
+	vm_vaddr_t nested_gva;
 	int vcpu_id;
 
-	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
 	TEST_REQUIRE(kvm_cpu_has_tdp());
 
 	vm_enable_tdp(vm);
 	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
-		vcpu_alloc_vmx(vm, &vmx_gva);
+		if (kvm_cpu_has(X86_FEATURE_VMX))
+			vcpu_alloc_vmx(vm, &nested_gva);
+		else
+			vcpu_alloc_svm(vm, &nested_gva);
 
 		/* The EPTs are shared across vCPUs, setup the mappings once */
 		if (vcpu_id == 0)
@@ -99,6 +127,6 @@ void memstress_setup_nested(struct kvm_vm *vm, int nr_vcpus, struct kvm_vcpu *vc
 		vcpu_regs_get(vcpus[vcpu_id], &regs);
 		regs.rip = (unsigned long) memstress_l1_guest_code;
 		vcpu_regs_set(vcpus[vcpu_id], &regs);
-		vcpu_args_set(vcpus[vcpu_id], 2, vmx_gva, vcpu_id);
+		vcpu_args_set(vcpus[vcpu_id], 2, nested_gva, vcpu_id);
 	}
 }
-- 
2.52.0.351.gbe84eed79e-goog


