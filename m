Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7525C2ECEAF
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 12:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbhAGLWl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 06:22:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:35928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726822AbhAGLWk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 06:22:40 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFC2C23340;
        Thu,  7 Jan 2021 11:21:23 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kxTM1-005p1o-Uv; Thu, 07 Jan 2021 11:21:22 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Qian Cai <qcai@redhat.com>,
        Shannon Zhao <shannon.zhao@linux.alibaba.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 07/18] KVM: arm64: Move skip_host_instruction to adjust_pc.h
Date:   Thu,  7 Jan 2021 11:20:50 +0000
Message-Id: <20210107112101.2297944-8-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107112101.2297944-1-maz@kernel.org>
References: <20210107112101.2297944-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, dbrazdil@google.com, eric.auger@redhat.com, mark.rutland@arm.com, natechancellor@gmail.com, qcai@redhat.com, shannon.zhao@linux.alibaba.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Brazdil <dbrazdil@google.com>

Move function for skipping host instruction in the host trap handler to
a header file containing analogical helpers for guests.

Signed-off-by: David Brazdil <dbrazdil@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20201208142452.87237-7-dbrazdil@google.com
---
 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h |  9 +++++++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c         | 12 ++----------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h b/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
index b1f60923a8fe..61716359035d 100644
--- a/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
+++ b/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
@@ -59,4 +59,13 @@ static inline void __adjust_pc(struct kvm_vcpu *vcpu)
 	}
 }
 
+/*
+ * Skip an instruction while host sysregs are live.
+ * Assumes host is always 64-bit.
+ */
+static inline void kvm_skip_host_instr(void)
+{
+	write_sysreg_el2(read_sysreg_el2(SYS_ELR) + 4, SYS_ELR);
+}
+
 #endif
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index bde658d51404..a906f9e2ff34 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -157,11 +157,6 @@ static void default_host_smc_handler(struct kvm_cpu_context *host_ctxt)
 	__kvm_hyp_host_forward_smc(host_ctxt);
 }
 
-static void skip_host_instruction(void)
-{
-	write_sysreg_el2(read_sysreg_el2(SYS_ELR) + 4, SYS_ELR);
-}
-
 static void handle_host_smc(struct kvm_cpu_context *host_ctxt)
 {
 	bool handled;
@@ -170,11 +165,8 @@ static void handle_host_smc(struct kvm_cpu_context *host_ctxt)
 	if (!handled)
 		default_host_smc_handler(host_ctxt);
 
-	/*
-	 * Unlike HVC, the return address of an SMC is the instruction's PC.
-	 * Move the return address past the instruction.
-	 */
-	skip_host_instruction();
+	/* SMC was trapped, move ELR past the current PC. */
+	kvm_skip_host_instr();
 }
 
 void handle_trap(struct kvm_cpu_context *host_ctxt)
-- 
2.29.2

