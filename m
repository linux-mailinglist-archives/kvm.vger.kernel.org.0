Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3CF141498E
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 14:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236144AbhIVMtH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 08:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236158AbhIVMtA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 08:49:00 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943E9C061574
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 05:47:30 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id x28-20020ac8701c000000b0029f4b940566so8227252qtm.19
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 05:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fhuyzDrWVkEjtHzFzN+Fx6ExKEiC8uquGig/dbG3Bns=;
        b=nC1xPUxkO/dCfs8FVpTPJ8s8ewk2VV5qT2a4qephLr4t+EZ5A/JCaPLQIOMf+T4A/F
         HD3I6c8yXTN2Z1GmvjAB9kHrih+iGQhAnSj1eKpqqyjbYMxx5FzYKn/LNr25KlV8WOU7
         CcDVOxXpkPE/wH4yhdOaoYTeBKhVu3k7Xpbf8LOWTzYwQTU5G11agDQnhZ993/d6nOuo
         e1Zutmt0OI78WrqGYEv1VInt2IpLFMQGCTIjv7vJxx231AmMFGbcOlYGjkTYsksFY5tn
         byC+9fZxDfQkQ2z8VdC1X5jVwHcf9KuiWm1qDyHW9xbjqQ1JBPkX9mywJExzn54KfSYI
         j6kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fhuyzDrWVkEjtHzFzN+Fx6ExKEiC8uquGig/dbG3Bns=;
        b=C/ohPLFHsSQHnZRYnhV4R2vE0ZaFU8It1frxpMxHbeASs5UsRxtJPayjnV4ipIQiei
         mF00dW8CzK/sWdlykiJ8A36pGjzn2Lu18zP4HtGWvziRallQdAsc+cFyHxNjo4IAH3sy
         MCRY72ln688A+2e/aFMY3CLPAZr7qR+b3Hyr1g04x5/jYz5HFMFJ7NhygkwFubxzEeMP
         RCA4/WmvPx1jlyybLQLgYWGJ1DvTbotJY1yYLDaOZAWet+ZssAUWMJVWiR7OZiVAo4d+
         nSNyj3qAeUdn42qmRZgbjQs7XKjJqo6WIfoGzHfZYSB9arJzzPO+KbETA59MuKFDk4Kq
         /Fqg==
X-Gm-Message-State: AOAM532Ljbr7mbpA+o2AMPEq8e8UzmXtIWDX/zBlgHVEPKvrt5sDyn0F
        8kbJL3qNA3CnibP/g5xhsJ3OCXZYjg==
X-Google-Smtp-Source: ABdhPJxbrBtZRxlrZyFXhw9pE2+iVlXS5BSDuMMG1cQhJ1gtaZoBRAu5TJ0pEsjLM6ux6doDiNfYq5ulMg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:ad4:556d:: with SMTP id w13mr8188690qvy.4.1632314849777;
 Wed, 22 Sep 2021 05:47:29 -0700 (PDT)
Date:   Wed, 22 Sep 2021 13:47:03 +0100
In-Reply-To: <20210922124704.600087-1-tabba@google.com>
Message-Id: <20210922124704.600087-12-tabba@google.com>
Mime-Version: 1.0
References: <20210922124704.600087-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v6 11/12] KVM: arm64: Trap access to pVM restricted features
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, oupton@google.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Trap accesses to restricted features for VMs running in protected
mode.

Access to feature registers are emulated, and only supported
features are exposed to protected VMs.

Accesses to restricted registers as well as restricted
instructions are trapped, and an undefined exception is injected
into the protected guests, i.e., with EC = 0x0 (unknown reason).
This EC is the one used, according to the Arm Architecture
Reference Manual, for unallocated or undefined system registers
or instructions.

Only affects the functionality of protected VMs. Otherwise,
should not affect non-protected VMs when KVM is running in
protected mode.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 60 ++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 49080c607838..2bf5952f651b 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -20,6 +20,7 @@
 #include <asm/kprobes.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_fixed_config.h>
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 #include <asm/fpsimd.h>
@@ -28,6 +29,7 @@
 #include <asm/thread_info.h>
 
 #include <nvhe/mem_protect.h>
+#include <nvhe/sys_regs.h>
 
 /* Non-VHE specific context */
 DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
@@ -158,6 +160,49 @@ static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
 		write_sysreg(pmu->events_host, pmcntenset_el0);
 }
 
+/**
+ * Handler for protected VM restricted exceptions.
+ *
+ * Inject an undefined exception into the guest and return true to indicate that
+ * the hypervisor has handled the exit, and control should go back to the guest.
+ */
+static bool kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	__inject_undef64(vcpu);
+	return true;
+}
+
+/**
+ * Handler for protected VM MSR, MRS or System instruction execution in AArch64.
+ *
+ * Returns true if the hypervisor has handled the exit, and control should go
+ * back to the guest, or false if it hasn't.
+ */
+static bool kvm_handle_pvm_sys64(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	if (kvm_handle_pvm_sysreg(vcpu, exit_code))
+		return true;
+	else
+		return kvm_hyp_handle_sysreg(vcpu, exit_code);
+}
+
+/**
+ * Handler for protected floating-point and Advanced SIMD accesses.
+ *
+ * Returns true if the hypervisor has handled the exit, and control should go
+ * back to the guest, or false if it hasn't.
+ */
+static bool kvm_handle_pvm_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	/* Linux guests assume support for floating-point and Advanced SIMD. */
+	BUILD_BUG_ON(!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_FP),
+				PVM_ID_AA64PFR0_ALLOW));
+	BUILD_BUG_ON(!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_ASIMD),
+				PVM_ID_AA64PFR0_ALLOW));
+
+	return kvm_hyp_handle_fpsimd(vcpu, exit_code);
+}
+
 static const exit_handler_fn hyp_exit_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]		= NULL,
 	[ESR_ELx_EC_CP15_32]		= kvm_hyp_handle_cp15,
@@ -170,8 +215,23 @@ static const exit_handler_fn hyp_exit_handlers[] = {
 	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
 };
 
+static const exit_handler_fn pvm_exit_handlers[] = {
+	[0 ... ESR_ELx_EC_MAX]		= NULL,
+	[ESR_ELx_EC_CP15_32]		= kvm_hyp_handle_cp15,
+	[ESR_ELx_EC_CP15_64]		= kvm_hyp_handle_cp15,
+	[ESR_ELx_EC_SYS64]		= kvm_handle_pvm_sys64,
+	[ESR_ELx_EC_SVE]		= kvm_handle_pvm_restricted,
+	[ESR_ELx_EC_FP_ASIMD]		= kvm_handle_pvm_fpsimd,
+	[ESR_ELx_EC_IABT_LOW]		= kvm_hyp_handle_iabt_low,
+	[ESR_ELx_EC_DABT_LOW]		= kvm_hyp_handle_dabt_low,
+	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
+};
+
 static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm)
 {
+	if (unlikely(kvm_vm_is_protected(kvm)))
+		return pvm_exit_handlers;
+
 	return hyp_exit_handlers;
 }
 
-- 
2.33.0.464.g1972c5931b-goog

