Return-Path: <kvm+bounces-59224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE95EBAE737
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 21:34:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 669C84A241C
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 19:34:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCC8E28726F;
	Tue, 30 Sep 2025 19:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gqoZAzjF"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFD925A326
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 19:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759260846; cv=none; b=TnGIyITfWvDFQvFJjoIAhz6zPtzM09n7Ja/ggcqxjJhaZpFHoOsshc1+iNuNof/tGXpDB05Wt7teA8WBbVKP3PtWWnoHwJaTTPbfaC0jYx6yBoUMpSCQANha+rPln7RyDBLBbZgTYAQ6PFCYJW2idbnrBsiqMpK3SHeeBOW8k94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759260846; c=relaxed/simple;
	bh=xYKR40vNtaYRSW7FtdkJ0YG59kj3MlAgXnDr5+axDWU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tZeZ5pwVRPqdRQH8845QUDHakU07mhC/kwWml8sNhPmPnWjPSDwaRXjiNoOvu+bLny96L/7em/IGckJ61tywo0xAw0EbMU1gSBCEnclnMLbRncnuHAeGqz6edV72MaaX7BFA7cSIH/tESbPUND9MHIchCSwoCccq+hZYiiE8a+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gqoZAzjF; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759260832;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=cVwjmx1ELBFjaS4qlIZB3z3BcagTICcLIaSMZ/Dsh0E=;
	b=gqoZAzjFZSvEUFUgmNkLmROdNCjhkPpaecLICdf8Ab7AtU8DN4gq4tBJkINY+U9qk0nBUm
	bBzQzeQ6A5GiX33R0ozGgBirPYG2Nwcw7o6wGhbPCfQCj81/1dbtQSLR3iZv3bAd303SMf
	3MAxbWoBULqbIu97/VR2lymLTqEBFqw=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Sebastian Ott <sebott@redhat.com>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH] KVM: selftests: Fix irqfd_test for non-x86 architectures
Date: Tue, 30 Sep 2025 12:33:02 -0700
Message-Id: <20250930193301.119859-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The KVM_IRQFD ioctl fails if no irqchip is present in-kernel, which
isn't too surprising as there's not much KVM can do for an IRQ if it
cannot resolve a destination.

As written the irqfd_test assumes that a 'default' VM created in
selftests has an in-kernel irqchip created implicitly. That may be the
case on x86 but it isn't necessarily true on other architectures.

Add an arch predicate indicating if 'default' VMs get an irqchip and
make the irqfd_test depend on it. Work around arm64 VGIC initialization
requirements by using vm_create_with_one_vcpu(), ignoring the created
vCPU as it isn't used for the test.

Reported-by: Sebastian Ott <sebott@redhat.com>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Acked-by: Sean Christopherson <seanjc@google.com>
Fixes: 7e9b231c402a ("KVM: selftests: Add a KVM_IRQFD test to verify uniqueness requirements")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/include/kvm_util.h    |  2 ++
 tools/testing/selftests/kvm/irqfd_test.c          | 14 +++++++++++---
 tools/testing/selftests/kvm/lib/arm64/processor.c |  5 +++++
 tools/testing/selftests/kvm/lib/kvm_util.c        |  5 +++++
 tools/testing/selftests/kvm/lib/s390/processor.c  |  5 +++++
 tools/testing/selftests/kvm/lib/x86/processor.c   |  5 +++++
 6 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 11b6c5aa3f12..8f23362f59fa 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -1268,4 +1268,6 @@ bool vm_is_gpa_protected(struct kvm_vm *vm, vm_paddr_t paddr);
 
 uint32_t guest_get_vcpuid(void);
 
+bool kvm_arch_has_default_irqchip(void);
+
 #endif /* SELFTEST_KVM_UTIL_H */
diff --git a/tools/testing/selftests/kvm/irqfd_test.c b/tools/testing/selftests/kvm/irqfd_test.c
index 7c301b4c7005..5d7590d01868 100644
--- a/tools/testing/selftests/kvm/irqfd_test.c
+++ b/tools/testing/selftests/kvm/irqfd_test.c
@@ -89,11 +89,19 @@ static void juggle_eventfd_primary(struct kvm_vm *vm, int eventfd)
 int main(int argc, char *argv[])
 {
 	pthread_t racing_thread;
+	struct kvm_vcpu *unused;
 	int r, i;
 
-	/* Create "full" VMs, as KVM_IRQFD requires an in-kernel IRQ chip. */
-	vm1 = vm_create(1);
-	vm2 = vm_create(1);
+	TEST_REQUIRE(kvm_arch_has_default_irqchip());
+
+	/*
+	 * Create "full" VMs, as KVM_IRQFD requires an in-kernel IRQ chip. Also
+	 * create an unused vCPU as certain architectures (like arm64) need to
+	 * complete IRQ chip initialization after all possible vCPUs for a VM
+	 * have been created.
+	 */
+	vm1 = vm_create_with_one_vcpu(&unused, NULL);
+	vm2 = vm_create_with_one_vcpu(&unused, NULL);
 
 	WRITE_ONCE(__eventfd, kvm_new_eventfd());
 
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index 369a4c87dd8f..54f6d17c78f7 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -725,3 +725,8 @@ void kvm_arch_vm_release(struct kvm_vm *vm)
 	if (vm->arch.has_gic)
 		close(vm->arch.gic_fd);
 }
+
+bool kvm_arch_has_default_irqchip(void)
+{
+	return request_vgic && kvm_supports_vgic_v3();
+}
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 67f32d41a59c..40d0252f146f 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2374,3 +2374,8 @@ bool vm_is_gpa_protected(struct kvm_vm *vm, vm_paddr_t paddr)
 	pg = paddr >> vm->page_shift;
 	return sparsebit_is_set(region->protected_phy_pages, pg);
 }
+
+__weak bool kvm_arch_has_default_irqchip(void)
+{
+	return false;
+}
diff --git a/tools/testing/selftests/kvm/lib/s390/processor.c b/tools/testing/selftests/kvm/lib/s390/processor.c
index 20cfe970e3e3..8ceeb17c819a 100644
--- a/tools/testing/selftests/kvm/lib/s390/processor.c
+++ b/tools/testing/selftests/kvm/lib/s390/processor.c
@@ -221,3 +221,8 @@ void vcpu_arch_dump(FILE *stream, struct kvm_vcpu *vcpu, uint8_t indent)
 void assert_on_unhandled_exception(struct kvm_vcpu *vcpu)
 {
 }
+
+bool kvm_arch_has_default_irqchip(void)
+{
+	return true;
+}
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index bff75aa341bf..0d3cfb9e9c3c 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -1281,3 +1281,8 @@ bool sys_clocksource_is_based_on_tsc(void)
 
 	return ret;
 }
+
+bool kvm_arch_has_default_irqchip(void)
+{
+	return true;
+}

base-commit: 10fd0285305d0b48e8a3bf15d4f17fc4f3d68cb6
-- 
2.39.5


