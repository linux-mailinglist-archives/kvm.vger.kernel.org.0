Return-Path: <kvm+bounces-29164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D758E9A3B16
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 12:14:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 849AB1F22E12
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 10:14:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45BBD2010E7;
	Fri, 18 Oct 2024 10:14:52 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mediconcil.de (mail.mediconcil.de [91.107.198.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7765420103B
	for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 10:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.107.198.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729246491; cv=none; b=sb+0ayIyyEHuii+Lo5fi/LVyJWEKP8ZcreTlzzaMd8d3sIR+gZdV4KWAuR+WrrDUojlpFYYYSa2ZUxEF7kg3c9bTyjxEKbTbDpt0NgjPqUEkCk7VcMOrBQQ4wAPDHlM2CtmMYeWX7wZLm4cM+Qs/hqSEZl1sepTHmw1laBWEWI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729246491; c=relaxed/simple;
	bh=SfFvhycAMqev+CSgEdNl+pqqcxbIp+oynD7wDLlT8gs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uD8PX4hW9LI4JOQ3X0QqrkBYRvLtPWFgnJkZYU6Y58l+kVC9QD8isUqx1IQfKG//6/3Hhxwh9wh/uoHJVjAIV2GkiOg82kzQpXibYh+S0TwwyVtUVrZqwRv+c94xTGZFPVh6idYxCEFkS0WELvYd70AovNS9z8Vwx3weIYcIpYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpico.io; spf=none smtp.mailfrom=silver.spittel.net; arc=none smtp.client-ip=91.107.198.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpico.io
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=silver.spittel.net
Received: from [10.42.0.1] (helo=silver)
	by mediconcil.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <kauer@silver.spittel.net>)
	id 1t1jvV-00GYtJ-0G;
	Fri, 18 Oct 2024 12:09:45 +0200
Received: from kauer by silver with local (Exim 4.98)
	(envelope-from <kauer@silver.spittel.net>)
	id 1t1jvU-000000008ne-2s4l;
	Fri, 18 Oct 2024 12:09:44 +0200
From: Bernhard Kauer <bk@alpico.io>
To: kvm@vger.kernel.org
Cc: Bernhard Kauer <bk@alpico.io>
Subject: [PATCH] KVM: drop the kvm_has_noapic_vcpu optimization
Date: Fri, 18 Oct 2024 12:08:45 +0200
Message-ID: <20241018100919.33814-1-bk@alpico.io>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It used a static key to avoid loading the lapic pointer from
the vcpu->arch structure.  However, in the common case the load
is from a hot cacheline and the CPU should be able to perfectly
predict it. Thus there is no upside of this premature optimization.

The downside is that code patching including an IPI to all CPUs
is required whenever the first VM without an lapic is created or
the last is destroyed.

Signed-off-by: Bernhard Kauer <bk@alpico.io>
---
 arch/x86/kvm/lapic.c | 4 ----
 arch/x86/kvm/lapic.h | 6 +-----
 arch/x86/kvm/x86.c   | 8 --------
 3 files changed, 1 insertion(+), 17 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 2098dc689088..0c75b3cc01f2 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -135,8 +135,6 @@ static inline int __apic_test_and_clear_vector(int vec, void *bitmap)
 	return __test_and_clear_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
 }
 
-__read_mostly DEFINE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
-EXPORT_SYMBOL_GPL(kvm_has_noapic_vcpu);
 
 __read_mostly DEFINE_STATIC_KEY_DEFERRED_FALSE(apic_hw_disabled, HZ);
 __read_mostly DEFINE_STATIC_KEY_DEFERRED_FALSE(apic_sw_disabled, HZ);
@@ -2518,7 +2516,6 @@ void kvm_free_lapic(struct kvm_vcpu *vcpu)
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
 	if (!vcpu->arch.apic) {
-		static_branch_dec(&kvm_has_noapic_vcpu);
 		return;
 	}
 
@@ -2864,7 +2861,6 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu)
 	ASSERT(vcpu != NULL);
 
 	if (!irqchip_in_kernel(vcpu->kvm)) {
-		static_branch_inc(&kvm_has_noapic_vcpu);
 		return 0;
 	}
 
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 1b8ef9856422..157af18c9fc8 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -179,13 +179,9 @@ static inline u32 kvm_lapic_get_reg(struct kvm_lapic *apic, int reg_off)
 	return __kvm_lapic_get_reg(apic->regs, reg_off);
 }
 
-DECLARE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
-
 static inline bool lapic_in_kernel(struct kvm_vcpu *vcpu)
 {
-	if (static_branch_unlikely(&kvm_has_noapic_vcpu))
-		return vcpu->arch.apic;
-	return true;
+	return vcpu->arch.apic;
 }
 
 extern struct static_key_false_deferred apic_hw_disabled;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 83fe0a78146f..ca73cae31f53 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9828,8 +9828,6 @@ void kvm_x86_vendor_exit(void)
 	if (hypervisor_is_type(X86_HYPER_MS_HYPERV))
 		clear_hv_tscchange_cb();
 #endif
-	kvm_lapic_exit();
-
 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
 		cpufreq_unregister_notifier(&kvmclock_cpufreq_notifier_block,
 					    CPUFREQ_TRANSITION_NOTIFIER);
@@ -14015,9 +14013,3 @@ static int __init kvm_x86_init(void)
 	return 0;
 }
 module_init(kvm_x86_init);
-
-static void __exit kvm_x86_exit(void)
-{
-	WARN_ON_ONCE(static_branch_unlikely(&kvm_has_noapic_vcpu));
-}
-module_exit(kvm_x86_exit);
-- 
2.45.2


