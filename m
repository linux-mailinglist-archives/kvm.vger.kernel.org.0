Return-Path: <kvm+bounces-57939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 253D0B81EF5
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 23:22:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C91341C06DD4
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 21:22:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 734F3304BB9;
	Wed, 17 Sep 2025 21:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LhtXKQxy"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA7F30B52A
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 21:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758144105; cv=none; b=p9vLsfPRIVFZrR6mbD0mNXKey+Tc1NRtQ4ci+X/bSRMmxyU6wcbknr5LtmvE+YOnH2Aw0QFaIdHffzSHI7WC+PxLvoX8uZaf6fLkNQ/C7Fc/vt6CUoQbKVB0/9ji0oITPFP/fD2UnDbLugmvHUbPCpAC7rXfTbr4AifsTF0roCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758144105; c=relaxed/simple;
	bh=sOGBGwS3uSUAnE7CAR3aObmoouAimZ/hpNjSSo3+nJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYYALsXgkoA/ZMewS4vTYk5LYteehTwVRVAeIPwcSSqikQl/FQVEk37f2fCyTpxFrr86C5WUWpb9YoaryMVfGlmCM/8Ssp9+XpMGHUeM3SqTR+Fz014QsUV+SlAoryougaOk346MWlNU+Wj6ZVwi4JdTNq8OyBOGN9NLBsCHgW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LhtXKQxy; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758144102;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=heQb+iYD8jR8m/89CClYw8LjpM8o65KodnM7TACOfHw=;
	b=LhtXKQxygwRr6p80+WV16dRNpdzx6/AueMYGQg8fwzM98mzk+48gYIM2korn6AarU7T/pZ
	rbPXAHQsr0y5aYuuNary7mcK107C5eO0VODxtcrZsERoxXwCassFYXqv+6a+r3DG+4N020
	SOnwk1JThiZdjkGZI+aN2hRWmK1XI5A=
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
Subject: [PATCH 09/13] KVM: arm64: selftests: Use hyp timer IRQs when test runs at EL2
Date: Wed, 17 Sep 2025 14:20:39 -0700
Message-ID: <20250917212044.294760-10-oliver.upton@linux.dev>
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

Arch timer registers are redirected to their hypervisor counterparts
when running in VHE EL2. This is great, except for the fact that the
hypervisor timers use different PPIs. Use the correct INTIDs when that
is the case.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 .../testing/selftests/kvm/arm64/arch_timer.c  |  6 ++---
 .../kvm/arm64/arch_timer_edge_cases.c         |  6 ++---
 .../selftests/kvm/include/arm64/arch_timer.h  | 24 +++++++++++++++++++
 3 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/arch_timer.c b/tools/testing/selftests/kvm/arm64/arch_timer.c
index c753013319bc..d592a4515399 100644
--- a/tools/testing/selftests/kvm/arm64/arch_timer.c
+++ b/tools/testing/selftests/kvm/arm64/arch_timer.c
@@ -165,10 +165,8 @@ static void guest_code(void)
 static void test_init_timer_irq(struct kvm_vm *vm)
 {
 	/* Timer initid should be same for all the vCPUs, so query only vCPU-0 */
-	vcpu_device_attr_get(vcpus[0], KVM_ARM_VCPU_TIMER_CTRL,
-			     KVM_ARM_VCPU_TIMER_IRQ_PTIMER, &ptimer_irq);
-	vcpu_device_attr_get(vcpus[0], KVM_ARM_VCPU_TIMER_CTRL,
-			     KVM_ARM_VCPU_TIMER_IRQ_VTIMER, &vtimer_irq);
+	ptimer_irq = vcpu_get_ptimer_irq(vcpus[0]);
+	vtimer_irq = vcpu_get_vtimer_irq(vcpus[0]);
 
 	sync_global_to_guest(vm, ptimer_irq);
 	sync_global_to_guest(vm, vtimer_irq);
diff --git a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
index 5c60262f4c2e..91906414a474 100644
--- a/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
+++ b/tools/testing/selftests/kvm/arm64/arch_timer_edge_cases.c
@@ -924,10 +924,8 @@ static void test_run(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 
 static void test_init_timer_irq(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 {
-	vcpu_device_attr_get(vcpu, KVM_ARM_VCPU_TIMER_CTRL,
-			     KVM_ARM_VCPU_TIMER_IRQ_PTIMER, &ptimer_irq);
-	vcpu_device_attr_get(vcpu, KVM_ARM_VCPU_TIMER_CTRL,
-			     KVM_ARM_VCPU_TIMER_IRQ_VTIMER, &vtimer_irq);
+	ptimer_irq = vcpu_get_ptimer_irq(vcpu);
+	vtimer_irq = vcpu_get_vtimer_irq(vcpu);
 
 	sync_global_to_guest(vm, ptimer_irq);
 	sync_global_to_guest(vm, vtimer_irq);
diff --git a/tools/testing/selftests/kvm/include/arm64/arch_timer.h b/tools/testing/selftests/kvm/include/arm64/arch_timer.h
index bf461de34785..e2c4e9f0010f 100644
--- a/tools/testing/selftests/kvm/include/arm64/arch_timer.h
+++ b/tools/testing/selftests/kvm/include/arm64/arch_timer.h
@@ -155,4 +155,28 @@ static inline void timer_set_next_tval_ms(enum arch_timer timer, uint32_t msec)
 	timer_set_tval(timer, msec_to_cycles(msec));
 }
 
+static inline u32 vcpu_get_vtimer_irq(struct kvm_vcpu *vcpu)
+{
+	u32 intid;
+	u64 attr;
+
+	attr = vcpu_has_el2(vcpu) ? KVM_ARM_VCPU_TIMER_IRQ_HVTIMER :
+				    KVM_ARM_VCPU_TIMER_IRQ_VTIMER;
+	vcpu_device_attr_get(vcpu, KVM_ARM_VCPU_TIMER_CTRL, attr, &intid);
+
+	return intid;
+}
+
+static inline u32 vcpu_get_ptimer_irq(struct kvm_vcpu *vcpu)
+{
+	u32 intid;
+	u64 attr;
+
+	attr = vcpu_has_el2(vcpu) ? KVM_ARM_VCPU_TIMER_IRQ_HPTIMER :
+				    KVM_ARM_VCPU_TIMER_IRQ_PTIMER;
+	vcpu_device_attr_get(vcpu, KVM_ARM_VCPU_TIMER_CTRL, attr, &intid);
+
+	return intid;
+}
+
 #endif /* SELFTEST_KVM_ARCH_TIMER_H */
-- 
2.47.3


