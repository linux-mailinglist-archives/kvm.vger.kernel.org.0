Return-Path: <kvm+bounces-57942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 66F1EB81F01
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 23:22:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 208FF5226E6
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 21:22:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD7F630C36A;
	Wed, 17 Sep 2025 21:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Rkhveltu"
X-Original-To: kvm@vger.kernel.org
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CC930C34E
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 21:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758144131; cv=none; b=RAwGDUewLQqsmpG9sD7dADtpP3TgMKV+vy3UYyDfnE2BGc8koThtyo2DizsOjmYVzaH7se2HTlFEUQ+k5/742EbpQodGyT8LjZ9dnTZChNvmF8I28vlDlSVlom4ECUDY5dmOiOIlI/MHI45x2CUshVbRcM0jd0tQpm2Cg9KHEJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758144131; c=relaxed/simple;
	bh=ppZbqVxELUwABEPXhIHc/fcF0J0q3x59/PQjcwtWW9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F5ArutiJREYZLVo/q8cPiwbGpwZrHv1JJ6qJJs0ZiSzpop8IzXSU8iBo+JHC1WZ/7C7mVtU2/729ZxZN5XAvsMJqUkQzL/9cUTaTmkUqAWbHbPzO94vCMZXaMZOe8cqJD440peU+36iTMqJz514O8lhN1BdpC3xtDaV6TmFMWgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Rkhveltu; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758144127;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2g20CiixGKavOGLKNyQ2qkYwlpIzcS1YH+nuvzs7O38=;
	b=RkhveltuCLEdr/Ea1r66lo+1t+ofYHmhkUWjdn+WV1GH0eTmPX3/Q3jt8Rg2KNjstoG2tF
	lMITCTvZQeOs1Afui8HT2h9Twd9tubC166CFfLRR2+aG6+t6BMmeqloHd+RS1CoS8sBt3l
	VB4mtgsKvAXlpI/ehZUNXk9TLx5KLAY=
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
Subject: [PATCH 12/13] KVM: arm64: selftests: Enable EL2 by default
Date: Wed, 17 Sep 2025 14:20:42 -0700
Message-ID: <20250917212044.294760-13-oliver.upton@linux.dev>
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

Take advantage of VHE to implicitly promote KVM selftests to run at EL2
with only slight modification. Update the smccc_filter test to account
for this now that the EL2-ness of a VM is visible to tests.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 tools/testing/selftests/kvm/arm64/smccc_filter.c   | 14 +++++++++++++-
 .../selftests/kvm/include/arm64/processor.h        |  1 +
 tools/testing/selftests/kvm/lib/arm64/processor.c  | 12 ++++++++++++
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/arm64/smccc_filter.c b/tools/testing/selftests/kvm/arm64/smccc_filter.c
index a8e22d866ea7..1763b9d45400 100644
--- a/tools/testing/selftests/kvm/arm64/smccc_filter.c
+++ b/tools/testing/selftests/kvm/arm64/smccc_filter.c
@@ -22,8 +22,20 @@ enum smccc_conduit {
 	SMC_INSN,
 };
 
+static bool test_runs_at_el2(void)
+{
+	struct kvm_vm *vm = vm_create(1);
+	struct kvm_vcpu_init init;
+
+	kvm_get_default_vcpu_target(vm, &init);
+	kvm_vm_free(vm);
+
+	return init.features[0] & BIT(KVM_ARM_VCPU_HAS_EL2);
+}
+
 #define for_each_conduit(conduit)					\
-	for (conduit = HVC_INSN; conduit <= SMC_INSN; conduit++)
+	for (conduit = test_runs_at_el2() ? SMC_INSN : HVC_INSN;	\
+	     conduit <= SMC_INSN; conduit++)
 
 static void guest_main(uint32_t func_id, enum smccc_conduit conduit)
 {
diff --git a/tools/testing/selftests/kvm/include/arm64/processor.h b/tools/testing/selftests/kvm/include/arm64/processor.h
index f037c1bb8e63..b6b86e2cd59c 100644
--- a/tools/testing/selftests/kvm/include/arm64/processor.h
+++ b/tools/testing/selftests/kvm/include/arm64/processor.h
@@ -303,6 +303,7 @@ void wfi(void);
 void test_wants_mte(void);
 void test_disable_default_vgic(void);
 
+bool vm_supports_el2(struct kvm_vm *vm);
 static bool vcpu_has_el2(struct kvm_vcpu *vcpu)
 {
 	return vcpu->init.features[0] & BIT(KVM_ARM_VCPU_HAS_EL2);
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index 4339de2fc482..74324915b41e 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -267,11 +267,23 @@ void virt_arch_dump(FILE *stream, struct kvm_vm *vm, uint8_t indent)
 	}
 }
 
+bool vm_supports_el2(struct kvm_vm *vm)
+{
+	const char *value = getenv("NV");
+
+	if (value && *value == '0')
+		return false;
+
+	return vm_check_cap(vm, KVM_CAP_ARM_EL2) && vm->arch.has_gic;
+}
+
 void kvm_get_default_vcpu_target(struct kvm_vm *vm, struct kvm_vcpu_init *init)
 {
 	struct kvm_vcpu_init preferred = {};
 
 	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &preferred);
+	if (vm_supports_el2(vm))
+		preferred.features[0] |= BIT(KVM_ARM_VCPU_HAS_EL2);
 
 	*init = preferred;
 }
-- 
2.47.3


