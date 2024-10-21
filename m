Return-Path: <kvm+bounces-29272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C7A409A62AF
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 12:24:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6666BB212E8
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 10:24:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FF7B1E3DEB;
	Mon, 21 Oct 2024 10:24:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mediconcil.de (mail.mediconcil.de [91.107.198.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6A216F27E
	for <kvm@vger.kernel.org>; Mon, 21 Oct 2024 10:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.107.198.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506244; cv=none; b=GWKq/TvPNH5BMerv+TPusRpVVVMPPnKGl2KgF+G+IU7AvRH6xrao671xhCizfWjf+/y5GgeggNZbopxyYajNwvTocGrnjOXTi05+jCthNty6aNAKdcZKaN3Pe9qjU5aG/eevI22jlbVONL06dng57TPWjTBxRmc5mQFWiWacw30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506244; c=relaxed/simple;
	bh=e7hPhBmbgU4bQ7ePC6yU6bCJOVl7aC3sO5oZ4vkHjsM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kZ2Gt9XKcUdaOoAvB5kQibn674xNFnkNvtY+Btd7+vpDjVnRsknbWilBDb42o65SYMk0PEaaW9ocQ2vD4iovRKQheSr1DTqNIvr1G5WPd26SEJqDc5R7omP23xV8oY9p3yCfknCZnHNzyDYz2rWxKZqCg1jawq1wcJxSon9ee8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpico.io; spf=none smtp.mailfrom=silver.spittel.net; arc=none smtp.client-ip=91.107.198.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpico.io
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=silver.spittel.net
Received: from [10.42.0.1] (helo=silver)
	by mediconcil.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <kauer@silver.spittel.net>)
	id 1t2pZe-002FSN-2z;
	Mon, 21 Oct 2024 12:23:42 +0200
Received: from kauer by silver with local (Exim 4.98)
	(envelope-from <kauer@silver.spittel.net>)
	id 1t2pZe-00000002n10-1lfl;
	Mon, 21 Oct 2024 12:23:42 +0200
From: Bernhard Kauer <bk@alpico.io>
To: kvm@vger.kernel.org
Cc: Chao Gao <chao.gao@intel.com>,
	Bernhard Kauer <bk@alpico.io>
Subject: [PATCH v2] KVM: x86: Drop the kvm_has_noapic_vcpu optimization
Date: Mon, 21 Oct 2024 12:22:47 +0200
Message-ID: <20241021102321.665060-1-bk@alpico.io>
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

V1->V2: remove spillover from other patch and fix style

 arch/x86/kvm/lapic.c | 10 ++--------
 arch/x86/kvm/lapic.h |  6 +-----
 arch/x86/kvm/x86.c   |  6 ------
 3 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 2098dc689088..287a43fae041 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -135,8 +135,6 @@ static inline int __apic_test_and_clear_vector(int vec, void *bitmap)
 	return __test_and_clear_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
 }
 
-__read_mostly DEFINE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
-EXPORT_SYMBOL_GPL(kvm_has_noapic_vcpu);
 
 __read_mostly DEFINE_STATIC_KEY_DEFERRED_FALSE(apic_hw_disabled, HZ);
 __read_mostly DEFINE_STATIC_KEY_DEFERRED_FALSE(apic_sw_disabled, HZ);
@@ -2517,10 +2515,8 @@ void kvm_free_lapic(struct kvm_vcpu *vcpu)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
-	if (!vcpu->arch.apic) {
-		static_branch_dec(&kvm_has_noapic_vcpu);
+	if (!vcpu->arch.apic)
 		return;
-	}
 
 	hrtimer_cancel(&apic->lapic_timer.timer);
 
@@ -2863,10 +2859,8 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu)
 
 	ASSERT(vcpu != NULL);
 
-	if (!irqchip_in_kernel(vcpu->kvm)) {
-		static_branch_inc(&kvm_has_noapic_vcpu);
+	if (!irqchip_in_kernel(vcpu->kvm))
 		return 0;
-	}
 
 	apic = kzalloc(sizeof(*apic), GFP_KERNEL_ACCOUNT);
 	if (!apic)
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
index 83fe0a78146f..88b04355273d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -14015,9 +14015,3 @@ static int __init kvm_x86_init(void)
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


