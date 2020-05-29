Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7523D1E82C9
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 18:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgE2QBt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 12:01:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:40546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727842AbgE2QBq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 12:01:46 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3202A2145D;
        Fri, 29 May 2020 16:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590768106;
        bh=PtgXYMxsBbdXRBCTL48ndwUY3jYZvLqzZqr/d+1pk5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BS7EqjDsT9wMf3axjFkd2hxFKW8HVeYYu7p10YTlyNWYAmW9wxl0xD2PU+9Jofez3
         jBWB0wMluKofR2V8YawqK7FWMPag/l8/5Lfwjmqx0JJD/yu5bBk+ecmj/qKwrRsG4H
         Bwv5VFDL9gvZHAlS3zjLt99+95cRwYdrZ1N9J+gY=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jehS4-00GJKc-Lp; Fri, 29 May 2020 17:01:44 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Christoffer Dall <christoffer.dall@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Fuad Tabba <tabba@google.com>,
        James Morse <james.morse@arm.com>,
        Jiang Yi <giangyi@amazon.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [PATCH 06/24] KVM: arm64: Simplify __kvm_timer_set_cntvoff implementation
Date:   Fri, 29 May 2020 17:01:03 +0100
Message-Id: <20200529160121.899083-7-maz@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529160121.899083-1-maz@kernel.org>
References: <20200529160121.899083-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, ascull@google.com, ardb@kernel.org, christoffer.dall@arm.com, dbrazdil@google.com, tabba@google.com, james.morse@arm.com, giangyi@amazon.com, zhukeqian1@huawei.com, mark.rutland@arm.com, suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com, julien.thierry.kdev@gmail.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
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
 arch/arm64/kvm/arch_timer.c      | 12 +-----------
 arch/arm64/kvm/hyp/timer-sr.c    |  3 +--
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
 
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 93bd59b46848..487eba9f87cd 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
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
diff --git a/arch/arm64/kvm/hyp/timer-sr.c b/arch/arm64/kvm/hyp/timer-sr.c
index ff76e6845fe4..fb5c0be33223 100644
--- a/arch/arm64/kvm/hyp/timer-sr.c
+++ b/arch/arm64/kvm/hyp/timer-sr.c
@@ -10,9 +10,8 @@
 
 #include <asm/kvm_hyp.h>
 
-void __hyp_text __kvm_timer_set_cntvoff(u32 cntvoff_low, u32 cntvoff_high)
+void __hyp_text __kvm_timer_set_cntvoff(u64 cntvoff)
 {
-	u64 cntvoff = (u64)cntvoff_high << 32 | cntvoff_low;
 	write_sysreg(cntvoff, cntvoff_el2);
 }
 
-- 
2.26.2

