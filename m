Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 148A942BF80
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 14:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbhJMMGM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 08:06:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232645AbhJMMGF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 08:06:05 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D7A6610E6;
        Wed, 13 Oct 2021 12:04:02 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1maczI-00GTgY-Pj; Wed, 13 Oct 2021 13:04:00 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     will@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com, pbonzini@redhat.com,
        drjones@redhat.com, oupton@google.com, qperret@google.com,
        kernel-team@android.com, tabba@google.com
Subject: [PATCH v9 20/22] KVM: arm64: pkvm: Move kvm_handle_pvm_restricted around
Date:   Wed, 13 Oct 2021 13:03:44 +0100
Message-Id: <20211013120346.2926621-10-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211013120346.2926621-1-maz@kernel.org>
References: <20211010145636.1950948-12-tabba@google.com>
 <20211013120346.2926621-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, will@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com, pbonzini@redhat.com, drjones@redhat.com, oupton@google.com, qperret@google.com, kernel-team@android.com, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Place kvm_handle_pvm_restricted() next to its little friends such
as kvm_handle_pvm_sysreg().

This allows to make inject_undef64() static.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h |  2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c               | 12 ------------
 arch/arm64/kvm/hyp/nvhe/sys_regs.c             | 14 +++++++++++++-
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
index 747fc79ae784..eea1f6a53723 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
@@ -194,7 +194,7 @@
 
 u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
 bool kvm_handle_pvm_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code);
+bool kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu, u64 *exit_code);
 int kvm_check_pvm_sysreg_table(void);
-void inject_undef64(struct kvm_vcpu *vcpu);
 
 #endif /* __ARM64_KVM_FIXED_CONFIG_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 317dba6a018d..be6889e33b2b 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -159,18 +159,6 @@ static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
 		write_sysreg(pmu->events_host, pmcntenset_el0);
 }
 
-/**
- * Handler for protected VM restricted exceptions.
- *
- * Inject an undefined exception into the guest and return true to indicate that
- * the hypervisor has handled the exit, and control should go back to the guest.
- */
-static bool kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu, u64 *exit_code)
-{
-	inject_undef64(vcpu);
-	return true;
-}
-
 /**
  * Handler for protected VM MSR, MRS or System instruction execution in AArch64.
  *
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 052f885e65b2..3787ee6fb1a2 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -30,7 +30,7 @@ u64 id_aa64mmfr2_el1_sys_val;
  * Inject an unknown/undefined exception to an AArch64 guest while most of its
  * sysregs are live.
  */
-void inject_undef64(struct kvm_vcpu *vcpu)
+static void inject_undef64(struct kvm_vcpu *vcpu)
 {
 	u32 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
 
@@ -473,3 +473,15 @@ bool kvm_handle_pvm_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code)
 
 	return true;
 }
+
+/**
+ * Handler for protected VM restricted exceptions.
+ *
+ * Inject an undefined exception into the guest and return true to indicate that
+ * the hypervisor has handled the exit, and control should go back to the guest.
+ */
+bool kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	inject_undef64(vcpu);
+	return true;
+}
-- 
2.30.2

