Return-Path: <kvm+bounces-57937-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 79A77B81EFB
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 23:22:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 29D7F7BC99F
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 21:20:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EB7A30AABF;
	Wed, 17 Sep 2025 21:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hGuzkiCE"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202753043A4
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 21:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758144099; cv=none; b=SSL7OFOoIkRUKvT7uJWDDVdJ55n23WDVkHE8YC8aiG5jfLzgEtPsd+m7pPtt0xZawKHG0q5vDgjdw2HQbgoAHgM4woKMXzB4cOyRNxyftGXkek3UqmXLyyN+6I7ALuDb3qeK/MnsEMBaHtiUBII9vhuo0OzL6psw2vu5WQLV2WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758144099; c=relaxed/simple;
	bh=vWC21og7vyvi2GstiinoI+j57ci46YIovHASdBAvxTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eq35Z8OGfUIaOOR6LJYFDgyoQBrps+8VrwGF+GJvF3oSXYwtvg1/khWWbw1jz9SjSBZci0OYU2YbDz2HsxI9jI7Hr5QjPHd7P/u4QBsDmJ1b07IUrGscsuR96CeZJ780QMix6sk/WpZy1qVifia6RVGmq215jO79CBFT3q/kjJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hGuzkiCE; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758144096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=loMy4TUif8ykaDI5FK6KRKdzewryzSo9NF7v0gGWyiQ=;
	b=hGuzkiCE37zZWKiNLcSTbrvIyvfllDCUQeghB17bTsvfJ+3j4Hj4a0IKn2uYjHxfdX/DDT
	nLGY+q3R819cm3YtduFoSw/aA40NKLUXCNpxeDeorlq4lsv8JxRQt/t9dFmKy9ESVovyBq
	4wvh909sf/MJzD0dHMzrTk8ch9De/eM=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 07/13] KVM: arm64: selftests: Provide helper for getting default vCPU target
Date: Wed, 17 Sep 2025 14:20:37 -0700
Message-ID: <20250917212044.294760-8-oliver.upton@linux.dev>
In-Reply-To: <20250917212044.294760-1-oliver.upton@linux.dev>
References: <20250917212044.294760-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The default vCPU target in KVM selftests is pretty boring in that it
doesn't enable any vCPU features. Expose a helper for getting the
default target to prepare for cramming in more features. Call
KVM_ARM_PREFERRED_TARGET directly from get-reg-list as it needs
fine-grained control over feature flags.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/arm64/psci_test.c   |  2 +-
 .../testing/selftests/kvm/arm64/smccc_filter.c  |  2 +-
 .../selftests/kvm/arm64/vpmu_counter_access.c   |  4 ++--
 tools/testing/selftests/kvm/get-reg-list.c      |  9 ++++++---
 .../selftests/kvm/include/arm64/processor.h     |  2 ++
 .../testing/selftests/kvm/lib/arm64/processor.c | 17 +++++++++++------
 6 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/psci_test.c b/tools/testing/selftests/kvm/arm64/psci_test.c
index cf208390fd0e..0d4680da66d1 100644
--- a/tools/testing/selftests/kvm/arm64/psci_test.c
+++ b/tools/testing/selftests/kvm/arm64/psci_test.c
@@ -89,7 +89,7 @@ static struct kvm_vm *setup_vm(void *guest_code, struct kvm_vcpu **source,
 
 	vm = vm_create(2);
 
-	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
+	kvm_get_default_vcpu_target(vm, &init);
 	init.features[0] |= (1 << KVM_ARM_VCPU_PSCI_0_2);
 
 	*source = aarch64_vcpu_add(vm, 0, &init, guest_code);
diff --git a/tools/testing/selftests/kvm/arm64/smccc_filter.c b/tools/testing/selftests/kvm/arm64/smccc_filter.c
index eb5551d21dbe..a8e22d866ea7 100644
--- a/tools/testing/selftests/kvm/arm64/smccc_filter.c
+++ b/tools/testing/selftests/kvm/arm64/smccc_filter.c
@@ -64,7 +64,7 @@ static struct kvm_vm *setup_vm(struct kvm_vcpu **vcpu)
 	struct kvm_vm *vm;
 
 	vm = vm_create(1);
-	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
+	kvm_get_default_vcpu_target(vm, &init);
 
 	/*
 	 * Enable in-kernel emulation of PSCI to ensure that calls are denied
diff --git a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
index 36a3a8b4e0b5..2a8f31c8e59f 100644
--- a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
@@ -430,7 +430,7 @@ static void create_vpmu_vm(void *guest_code)
 	}
 
 	/* Create vCPU with PMUv3 */
-	vm_ioctl(vpmu_vm.vm, KVM_ARM_PREFERRED_TARGET, &init);
+	kvm_get_default_vcpu_target(vpmu_vm.vm, &init);
 	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
 	vpmu_vm.vcpu = aarch64_vcpu_add(vpmu_vm.vm, 0, &init, guest_code);
 	vcpu_init_descriptor_tables(vpmu_vm.vcpu);
@@ -525,7 +525,7 @@ static void run_access_test(uint64_t pmcr_n)
 	 * Reset and re-initialize the vCPU, and run the guest code again to
 	 * check if PMCR_EL0.N is preserved.
 	 */
-	vm_ioctl(vpmu_vm.vm, KVM_ARM_PREFERRED_TARGET, &init);
+	kvm_get_default_vcpu_target(vpmu_vm.vm, &init);
 	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
 	aarch64_vcpu_setup(vcpu, &init);
 	vcpu_init_descriptor_tables(vcpu);
diff --git a/tools/testing/selftests/kvm/get-reg-list.c b/tools/testing/selftests/kvm/get-reg-list.c
index 91f05f78e824..f4644c9d2d3b 100644
--- a/tools/testing/selftests/kvm/get-reg-list.c
+++ b/tools/testing/selftests/kvm/get-reg-list.c
@@ -116,10 +116,13 @@ void __weak finalize_vcpu(struct kvm_vcpu *vcpu, struct vcpu_reg_list *c)
 }
 
 #ifdef __aarch64__
-static void prepare_vcpu_init(struct vcpu_reg_list *c, struct kvm_vcpu_init *init)
+static void prepare_vcpu_init(struct kvm_vm *vm, struct vcpu_reg_list *c,
+			      struct kvm_vcpu_init *init)
 {
 	struct vcpu_reg_sublist *s;
 
+	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, init);
+
 	for_each_sublist(c, s)
 		if (s->capability)
 			init->features[s->feature / 32] |= 1 << (s->feature % 32);
@@ -127,10 +130,10 @@ static void prepare_vcpu_init(struct vcpu_reg_list *c, struct kvm_vcpu_init *ini
 
 static struct kvm_vcpu *vcpu_config_get_vcpu(struct vcpu_reg_list *c, struct kvm_vm *vm)
 {
-	struct kvm_vcpu_init init = { .target = -1, };
+	struct kvm_vcpu_init init;
 	struct kvm_vcpu *vcpu;
 
-	prepare_vcpu_init(c, &init);
+	prepare_vcpu_init(vm, c, &init);
 	vcpu = __vm_vcpu_add(vm, 0);
 	aarch64_vcpu_setup(vcpu, &init);
 
diff --git a/tools/testing/selftests/kvm/include/arm64/processor.h b/tools/testing/selftests/kvm/include/arm64/processor.h
index 5a4b29c1b965..87f50efed720 100644
--- a/tools/testing/selftests/kvm/include/arm64/processor.h
+++ b/tools/testing/selftests/kvm/include/arm64/processor.h
@@ -357,4 +357,6 @@ static __always_inline u64 ctxt_reg_alias(struct kvm_vcpu *vcpu, u32 encoding)
 	return KVM_ARM64_SYS_REG(alias);
 }
 
+void kvm_get_default_vcpu_target(struct kvm_vm *vm, struct kvm_vcpu_init *init);
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index 311660a9f655..5ae65fefd48c 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -267,19 +267,24 @@ void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 	}
 }
 
+void kvm_get_default_vcpu_target(struct kvm_vm *vm, struct kvm_vcpu_init *init)
+{
+	struct kvm_vcpu_init preferred = {};
+
+	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &preferred);
+
+	*init = preferred;
+}
+
 void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init)
 {
 	struct kvm_vcpu_init default_init = { .target = -1, };
 	struct kvm_vm *vm = vcpu->vm;
 	uint64_t sctlr_el1, tcr_el1, ttbr0_el1;
 
-	if (!init)
+	if (!init) {
+		kvm_get_default_vcpu_target(vm, &default_init);
 		init = &default_init;
-
-	if (init->target == -1) {
-		struct kvm_vcpu_init preferred;
-		vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &preferred);
-		init->target = preferred.target;
 	}
 
 	vcpu_ioctl(vcpu, KVM_ARM_VCPU_INIT, init);
-- 
2.47.3


