Return-Path: <kvm+bounces-49680-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D8CEADC36D
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 09:34:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E9A41604DD
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 07:34:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F2D028FA8D;
	Tue, 17 Jun 2025 07:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="xf9Ma34l"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775DA1E22FC;
	Tue, 17 Jun 2025 07:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750145628; cv=none; b=kr+Atp71xZyPLRMeCWRHPKoE2f2xpHTF344bqXFzUlkTy7pyztdon4MtyvaO6Vm4i3y3vvalo2ufffHzPkIflYYDnntvvljmQ0DJeGcFyMzLPpBN/HLNsHLbZ5DgP3qnhkuLEtNTFxmLQNZXLpMPoUYSutj0xYmnv2TYgdvXHiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750145628; c=relaxed/simple;
	bh=SjPjqhJUo5tnTLAx9gehS2WYxidqB/n4ashPnn4A23c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FzfZ5bAOh9PHsGzTviyr2UwsKpOptVJgtHvfZFU9XxwN2eDbawliRYsIqtPOIiVIqI3XkZgLOgQCvdD360hmablHNlUMuYgEignEWKh4iP4wK8pJMU4fbNoniERmqkBX1hHrUi82xk10olUOh0T++De4u+qJnakSBvu4A/PpVag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=xf9Ma34l; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 55H7WY901020658
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 17 Jun 2025 00:32:39 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 55H7WY901020658
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025052101; t=1750145560;
	bh=qaHWaR3qS+VvBjhBQiLm25PU4KqdjLMxlrG3QnDM/6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xf9Ma34lhmlCiTJKHLkI2fxVy55T2Igy/PPE/WbwHAr/rq+yB/pJzd8Nd3AwM8y3R
	 Ns6u5aWKbEXTaoLzNF1AvwJ1gKAe+uIO5arCwuwQdOapjaLANj3elfLlQUanGoo+QA
	 /AxKqiuEN6fUIxrtBmCUekBTvoSCEuElM2hy6g9vlUewNq97ms7N7jQRRMIcKfhBH0
	 SgnwjL5L9ysquzN8N7co0xljDm8ekkE76UfSNHUKklIVlcCyULxljIAWOHGKXSri8/
	 edrI+W1Fs26lV8UTISLoYR+DDCYbgN0Hfpr7wT5zyP3jFQmdhpctp9CnDcmcl4haER
	 JPEdn29h/AHAA==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, peterz@infradead.org,
        sohil.mehta@intel.com, brgerst@gmail.com, tony.luck@intel.com,
        fenghuay@nvidia.com
Subject: [PATCH v2 2/2] x86/traps: Initialize DR7 by writing its architectural reset value
Date: Tue, 17 Jun 2025 00:32:34 -0700
Message-ID: <20250617073234.1020644-3-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617073234.1020644-1-xin@zytor.com>
References: <20250617073234.1020644-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Initialize DR7 by writing its architectural reset value to ensure
compliance with the specification.

Reviewed-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---

Changes in v2:
*) Use debug register index 7 rather than DR_CONTROL (PeterZ and Sean).
*) Use DR7_FIXED_1 as the architectural reset value of DR7 (Sean).
---
 arch/x86/include/asm/debugreg.h | 14 ++++++++++----
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kernel/cpu/common.c    |  2 +-
 arch/x86/kernel/kgdb.c          |  2 +-
 arch/x86/kernel/process_32.c    |  2 +-
 arch/x86/kernel/process_64.c    |  2 +-
 arch/x86/kvm/x86.c              |  4 ++--
 7 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
index 363110e6b2e3..3acb85850c19 100644
--- a/arch/x86/include/asm/debugreg.h
+++ b/arch/x86/include/asm/debugreg.h
@@ -9,6 +9,9 @@
 #include <asm/cpufeature.h>
 #include <asm/msr.h>
 
+/* DR7_FIXED_1 is also used as the init/reset value for DR7 */
+#define DR7_FIXED_1	0x00000400
+
 DECLARE_PER_CPU(unsigned long, cpu_dr7);
 
 #ifndef CONFIG_PARAVIRT_XXL
@@ -100,8 +103,8 @@ static __always_inline void native_set_debugreg(int regno, unsigned long value)
 
 static inline void hw_breakpoint_disable(void)
 {
-	/* Zero the control register for HW Breakpoint */
-	set_debugreg(0UL, 7);
+	/* Reset the control register for HW Breakpoint */
+	set_debugreg(DR7_FIXED_1, 7);
 
 	/* Zero-out the individual HW breakpoint address registers */
 	set_debugreg(0UL, 0);
@@ -125,9 +128,12 @@ static __always_inline unsigned long local_db_save(void)
 		return 0;
 
 	get_debugreg(dr7, 7);
-	dr7 &= ~0x400; /* architecturally set bit */
+
+	/* Architecturally set bit */
+	dr7 &= ~DR7_FIXED_1;
 	if (dr7)
-		set_debugreg(0, 7);
+		set_debugreg(DR7_FIXED_1, 7);
+
 	/*
 	 * Ensure the compiler doesn't lower the above statements into
 	 * the critical section; disabling breakpoints late would not
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b4a391929cdb..639d9bcee842 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -31,6 +31,7 @@
 
 #include <asm/apic.h>
 #include <asm/pvclock-abi.h>
+#include <asm/debugreg.h>
 #include <asm/desc.h>
 #include <asm/mtrr.h>
 #include <asm/msr-index.h>
@@ -249,7 +250,6 @@ enum x86_intercept_stage;
 #define DR7_BP_EN_MASK	0x000000ff
 #define DR7_GE		(1 << 9)
 #define DR7_GD		(1 << 13)
-#define DR7_FIXED_1	0x00000400
 #define DR7_VOLATILE	0xffff2bff
 
 #define KVM_GUESTDBG_VALID_MASK \
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 3bd7c9ac7576..183765fdb56b 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2248,7 +2248,7 @@ static void initialize_debug_regs(void)
 	int i;
 
 	/* Control register first */
-	set_debugreg(0, 7);
+	set_debugreg(DR7_FIXED_1, 7);
 	set_debugreg(DR6_RESERVED, 6);
 
 	/* Ignore db4, db5 */
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 102641fd2172..8b1a9733d13e 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -385,7 +385,7 @@ static void kgdb_disable_hw_debug(struct pt_regs *regs)
 	struct perf_event *bp;
 
 	/* Disable hardware debugging while we are in kgdb: */
-	set_debugreg(0UL, 7);
+	set_debugreg(DR7_FIXED_1, 7);
 	for (i = 0; i < HBP_NUM; i++) {
 		if (!breakinfo[i].enabled)
 			continue;
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index a10e180cbf23..3ef15c2f152f 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -93,7 +93,7 @@ void __show_regs(struct pt_regs *regs, enum show_regs_mode mode,
 
 	/* Only print out debug registers if they are in their non-default state. */
 	if ((d0 == 0) && (d1 == 0) && (d2 == 0) && (d3 == 0) &&
-	    (d6 == DR6_RESERVED) && (d7 == 0x400))
+	    (d6 == DR6_RESERVED) && (d7 == DR7_FIXED_1))
 		return;
 
 	printk("%sDR0: %08lx DR1: %08lx DR2: %08lx DR3: %08lx\n",
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 8d6cf25127aa..b972bf72fb8b 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -133,7 +133,7 @@ void __show_regs(struct pt_regs *regs, enum show_regs_mode mode,
 
 	/* Only print out debug registers if they are in their non-default state. */
 	if (!((d0 == 0) && (d1 == 0) && (d2 == 0) && (d3 == 0) &&
-	    (d6 == DR6_RESERVED) && (d7 == 0x400))) {
+	    (d6 == DR6_RESERVED) && (d7 == DR7_FIXED_1))) {
 		printk("%sDR0: %016lx DR1: %016lx DR2: %016lx\n",
 		       log_lvl, d0, d1, d2);
 		printk("%sDR3: %016lx DR6: %016lx DR7: %016lx\n",
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b58a74c1722d..a9d992d5652f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11035,7 +11035,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	if (unlikely(vcpu->arch.switch_db_regs &&
 		     !(vcpu->arch.switch_db_regs & KVM_DEBUGREG_AUTO_SWITCH))) {
-		set_debugreg(0, 7);
+		set_debugreg(DR7_FIXED_1, 7);
 		set_debugreg(vcpu->arch.eff_db[0], 0);
 		set_debugreg(vcpu->arch.eff_db[1], 1);
 		set_debugreg(vcpu->arch.eff_db[2], 2);
@@ -11044,7 +11044,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT))
 			kvm_x86_call(set_dr6)(vcpu, vcpu->arch.dr6);
 	} else if (unlikely(hw_breakpoint_active())) {
-		set_debugreg(0, 7);
+		set_debugreg(DR7_FIXED_1, 7);
 	}
 
 	vcpu->arch.host_debugctl = get_debugctlmsr();
-- 
2.49.0


