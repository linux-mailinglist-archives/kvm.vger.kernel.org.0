Return-Path: <kvm+bounces-2073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 422987F13F5
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 14:11:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EFEA82818EE
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 13:11:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DDFF1B287;
	Mon, 20 Nov 2023 13:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WGRxGSf/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F94199C0;
	Mon, 20 Nov 2023 13:10:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64DC6C433C9;
	Mon, 20 Nov 2023 13:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700485851;
	bh=cnnR1GiuAdqI7cIUWV8YwegSKl7BLiTICT76URqAWmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WGRxGSf/XaxZOAGBOPG36xVSFO3CiDSXb6MYUDjIIQg/+IdlsJNKrEcTgU3CdCbsS
	 jqGkJbysh5s01mu4h6QpaG0uyycWFf6NGVEdjPuIO508S4CwYcUbpt6u52Vpjm+gPT
	 1okDh+cMkdaoWtcIjV6TXXAufS3CQp0ZcdcpekZlEtcjkOa7lNWDIQNPNe5bZZ9eoR
	 kQdOUNr3N/yiMY0eBEBjbP9OeQ4cphOBJb6F6kkYDNd9HHTjIB7NbVoXCqx1fws3pE
	 EWP5NSD5Mkf/mSEgt99lH1pDtvJu+OKJuXDSUqZfmsG5v/umme1rSKKP8BnyrQ5D4N
	 MsJH9K5Eet7PQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r5437-00EjnU-GT;
	Mon, 20 Nov 2023 13:10:49 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Darren Hart <darren@os.amperecomputing.com>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Miguel Luis <miguel.luis@oracle.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v11 02/43] KVM: arm64: nv: Hoist vcpu_has_nv() into is_hyp_ctxt()
Date: Mon, 20 Nov 2023 13:09:46 +0000
Message-Id: <20231120131027.854038-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231120131027.854038-1-maz@kernel.org>
References: <20231120131027.854038-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

A rather common idiom when writing NV code as part of KVM is
to have things such has:

	if (vcpu_has_nv(vcpu) && is_hyp_ctxt(vcpu)) {
		[...]
	}

to check that we are in a hyp-related context. The second part of
the conjunction would be enough, but the first one contains a
static key that allows the rest of the checkis to be elided when
in a non-NV environment.

Rewrite is_hyp_ctxt() to directly use vcpu_has_nv(). The result
is the same, and the code easier to read. The one occurence of
this that is already merged is rewritten in the process.

In order to avoid nasty cirtular dependencies between kvm_emulate.h
and kvm_nested.h, vcpu_has_feature() is itself hoisted into kvm_host.h,
at the cost of some #deferry...

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 8 ++------
 arch/arm64/include/asm/kvm_host.h    | 7 +++++++
 arch/arm64/kvm/arch_timer.c          | 3 +--
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 7b10a44189d0..ca9168d23cd6 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -17,6 +17,7 @@
 #include <asm/esr.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_hyp.h>
+#include <asm/kvm_nested.h>
 #include <asm/ptrace.h>
 #include <asm/cputype.h>
 #include <asm/virt.h>
@@ -54,11 +55,6 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu);
 int kvm_inject_nested_sync(struct kvm_vcpu *vcpu, u64 esr_el2);
 int kvm_inject_nested_irq(struct kvm_vcpu *vcpu);
 
-static inline bool vcpu_has_feature(const struct kvm_vcpu *vcpu, int feature)
-{
-	return test_bit(feature, vcpu->kvm->arch.vcpu_features);
-}
-
 #if defined(__KVM_VHE_HYPERVISOR__) || defined(__KVM_NVHE_HYPERVISOR__)
 static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
 {
@@ -249,7 +245,7 @@ static inline bool __is_hyp_ctxt(const struct kvm_cpu_context *ctxt)
 
 static inline bool is_hyp_ctxt(const struct kvm_vcpu *vcpu)
 {
-	return __is_hyp_ctxt(&vcpu->arch.ctxt);
+	return vcpu_has_nv(vcpu) && __is_hyp_ctxt(&vcpu->arch.ctxt);
 }
 
 /*
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 824f29f04916..4103a12ecaaf 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1177,6 +1177,13 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 #define kvm_vm_has_ran_once(kvm)					\
 	(test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &(kvm)->arch.flags))
 
+static inline bool __vcpu_has_feature(const struct kvm_arch *ka, int feature)
+{
+	return test_bit(feature, ka->vcpu_features);
+}
+
+#define vcpu_has_feature(v, f)	__vcpu_has_feature(&(v)->kvm->arch, (f))
+
 int kvm_trng_call(struct kvm_vcpu *vcpu);
 #ifdef CONFIG_KVM
 extern phys_addr_t hyp_mem_base;
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 13ba691b848f..9dec8c419bf4 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -295,8 +295,7 @@ static u64 wfit_delay_ns(struct kvm_vcpu *vcpu)
 	u64 val = vcpu_get_reg(vcpu, kvm_vcpu_sys_get_rt(vcpu));
 	struct arch_timer_context *ctx;
 
-	ctx = (vcpu_has_nv(vcpu) && is_hyp_ctxt(vcpu)) ? vcpu_hvtimer(vcpu)
-						       : vcpu_vtimer(vcpu);
+	ctx = is_hyp_ctxt(vcpu) ? vcpu_hvtimer(vcpu) : vcpu_vtimer(vcpu);
 
 	return kvm_counter_compute_delta(ctx, val);
 }
-- 
2.39.2


