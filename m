Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB131D126C
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 14:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731762AbgEMMPo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 08:15:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726020AbgEMMPn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 08:15:43 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06B57206D6;
        Wed, 13 May 2020 12:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589372143;
        bh=OFXMCfgg4QqvOju+IW8sguzu0zPnRXnwQP6ptWcD06o=;
        h=From:To:Cc:Subject:Date:From;
        b=V7AbQPKgWJK6PakqeqU1LoITqszt4ASQ0z0pTXUY0NNsOaMoL9t0daWUpgx4oLM0Y
         2ht5Hbpe+SAGdYjs1pamcS00ro46OAHdHHR0JUoJe1EmRtvmlrhAYJYvBroFwq2sIl
         c2rj3Urk/Mqqdmgzmt2UAuD0Kjsmsplvns3EUbJM=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jYqIX-00BxoR-Df; Wed, 13 May 2020 13:15:41 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH] KVM: arm64: Simplify __kvm_timer_set_cntvoff implementation
Date:   Wed, 13 May 2020 13:15:37 +0100
Message-Id: <20200513121537.77546-1-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that this function isn't constrained by the 32bit PCS,
let's simplify it by taking a single 64bit offset instead
of two 32bit parameters.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h |  2 +-
 virt/kvm/arm/arch_timer.c        | 12 +-----------
 virt/kvm/arm/hyp/timer-sr.c      |  3 +--
 3 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 7c7eeeaab9fa..59e314f38e43 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -64,7 +64,7 @@ extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
 extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
 extern void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu);
 
-extern void __kvm_timer_set_cntvoff(u32 cntvoff_low, u32 cntvoff_high);
+extern void __kvm_timer_set_cntvoff(u64 cntvoff);
 
 extern int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu);
 
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 93bd59b46848..487eba9f87cd 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -451,17 +451,7 @@ static void timer_restore_state(struct arch_timer_context *ctx)
 
 static void set_cntvoff(u64 cntvoff)
 {
-	u32 low = lower_32_bits(cntvoff);
-	u32 high = upper_32_bits(cntvoff);
-
-	/*
-	 * Since kvm_call_hyp doesn't fully support the ARM PCS especially on
-	 * 32-bit systems, but rather passes register by register shifted one
-	 * place (we put the function address in r0/x0), we cannot simply pass
-	 * a 64-bit value as an argument, but have to split the value in two
-	 * 32-bit halves.
-	 */
-	kvm_call_hyp(__kvm_timer_set_cntvoff, low, high);
+	kvm_call_hyp(__kvm_timer_set_cntvoff, cntvoff);
 }
 
 static inline void set_timer_irq_phys_active(struct arch_timer_context *ctx, bool active)
diff --git a/virt/kvm/arm/hyp/timer-sr.c b/virt/kvm/arm/hyp/timer-sr.c
index ff76e6845fe4..fb5c0be33223 100644
--- a/virt/kvm/arm/hyp/timer-sr.c
+++ b/virt/kvm/arm/hyp/timer-sr.c
@@ -10,9 +10,8 @@
 
 #include <asm/kvm_hyp.h>
 
-void __hyp_text __kvm_timer_set_cntvoff(u32 cntvoff_low, u32 cntvoff_high)
+void __hyp_text __kvm_timer_set_cntvoff(u64 cntvoff)
 {
-	u64 cntvoff = (u64)cntvoff_high << 32 | cntvoff_low;
 	write_sysreg(cntvoff, cntvoff_el2);
 }
 
-- 
2.20.1

