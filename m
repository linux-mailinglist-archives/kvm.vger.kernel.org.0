Return-Path: <kvm+bounces-64816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 50996C8C94E
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 02:39:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 77ACC354423
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 01:39:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74FD72BE7B1;
	Thu, 27 Nov 2025 01:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LGyV/JDz"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CBD2BE031
	for <kvm@vger.kernel.org>; Thu, 27 Nov 2025 01:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764207328; cv=none; b=kL2PgkrKFENrF+R6FOQZrCFgy0NX5LaFFj3u96LQGP2WBRmp91SbBEVkI2NFJ4HuWRxIsM57C8mbJeATzwe0NfXJEgVPKO0Fehhpq8W4VKzK8bYe2btMZfPMswPCyvaoISBO49UdfZ0MpqZJ37BQbM0w7T5ZlhaW4Cr8yQ6RFRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764207328; c=relaxed/simple;
	bh=fM2U9rXbLFACC7DHpSZE7lUsaAwQh/Zi05xmZm288pI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HksbdxAx+lBzE0rAXW/3d/TdpkMIaHIJQXgMgdKsG3Fv/9gDHAY3epFl2DRaoUlkAKn4mkKVRcJVk7sbRE9dtWnTAMh86xfrRkK3T/uNSpIwS5pIWX27rO7yVgHZuXfMddWh4RkOcCUfZlYqBAEX7i1l6h4ez2GfdY5jX3bp7LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LGyV/JDz; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764207322;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GWwtx5jx/PEkw/2itB59dU+0w4OnN5aW9YGDJcyPCFs=;
	b=LGyV/JDzd6JHrZGcZwoMT68JFibeAPmZRUE2ZFRLir3XpYrGea8eeI8JGg66Bi3QFl99CE
	1Ge3SxhSFHmtDucCidhXfnxe3WDe72012Em8iDezEUorqgQ0JPkv3OaP+ZNkxDhWAlS97S
	sAmRKtNFmH/w1VqVAKh2CYU5hwe+qAc=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v3 16/16] KVM: selftests: Extend memstress to run on nested SVM
Date: Thu, 27 Nov 2025 01:34:40 +0000
Message-ID: <20251127013440.3324671-17-yosry.ahmed@linux.dev>
In-Reply-To: <20251127013440.3324671-1-yosry.ahmed@linux.dev>
References: <20251127013440.3324671-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add L1 SVM code and generalize the setup code to work for both VMX and
SVM. This allows running 'dirty_log_perf_test -n' on AMD CPUs.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
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
+	GUEST_DONE();
+}
+
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
 	GUEST_DONE();
 }
 
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
2.52.0.158.g65b55ccf14-goog


