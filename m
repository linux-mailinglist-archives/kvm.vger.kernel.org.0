Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 608B93CE521
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 18:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347015AbhGSPrt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 11:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350271AbhGSPpr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 11:45:47 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301FCC0ABCAA
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 08:38:26 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id r13-20020a0cf60d0000b02902f3a4c41d77so15582205qvm.18
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 09:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=SMvDYa3zVL7ibMIO+tJttZvbwBrpgIyQmskq/9zvomc=;
        b=nGcldOEvZ5gWaVQK3V9NQw9Y7jzhGQff63UdVHhYuhqFTHhJpJgtfItHCpgXnUYWgF
         riofulYZNFspqyBcwCFLJYzHtqPp7NhHlSodygph/7KFIIvnll+TXaRp0kPqqEh/U0Cs
         hDFWRlxh0nov15s4XBnXuod8MiCXG4gUVh+ikbJO7n765CkOWYE+flUQJdauB4NeQ94H
         ihAhIjrc1bevXuKouvZqlPPKHhtbR0NSN5zY5CxKWS3eMe/lfvR0H93BDEfyvf4b4WLL
         G84YFwcjbBHDCk/WjsnL3veSJD7H1hP4jcoOsJGM1B81Rz0uuU4xj50iHAK7mizg8DuJ
         vM1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SMvDYa3zVL7ibMIO+tJttZvbwBrpgIyQmskq/9zvomc=;
        b=kxVhYDVZV2cWhUnbS/qsXtEe44kAM8NPJjkFA4ArmJDpgYjq0mlp/diY0TIdXc1ptj
         PatuFIqKvvx7Ljnu7Hihjp6b70IxDd3U3yzGlL1dlMk80nDoTVm6/dOqP7h4ZVuZJIMx
         XB7aVb37jWgW38tEbgfvFFpxpYidgS7gRlHQt8FeA7077Hi8MsOsz5b86eoKbHhex070
         kZKU8ideQeThWKpTG8s5L21mhdOZkGP/hlOhN7CTIMuz2KlWdlhtl79aFaFYIik/IwAb
         vbScN2ajzH3CtYseIV+fZ7iLOYIXcFYUTND4v2fd6UA6OWfRKK4+k7WSPVbcxvIxCOGS
         U6fQ==
X-Gm-Message-State: AOAM533xOT5PJWkZaHfRHXt6Fr2heze9UcbfdqJss6qZf39Zz6K4YbdR
        EG4+E6Yelb5Gcd8gTdnFYzZog4lEjw==
X-Google-Smtp-Source: ABdhPJwjha9rcUJY9NIyV03u/us5GcujWpRscIOZkLe7Tu5+P5KuYptKASNahYciLnoOFUq0gk0t4prOVg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:ad4:4bae:: with SMTP id i14mr25407298qvw.24.1626710648907;
 Mon, 19 Jul 2021 09:04:08 -0700 (PDT)
Date:   Mon, 19 Jul 2021 17:03:41 +0100
In-Reply-To: <20210719160346.609914-1-tabba@google.com>
Message-Id: <20210719160346.609914-11-tabba@google.com>
Mime-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 10/15] KVM: arm64: Guest exit handlers for nVHE hyp
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, drjones@redhat.com, qperret@google.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-team@android.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an array of pointers to handlers for various trap reasons in
nVHE code.

The current code selects how to fixup a guest on exit based on a
series of if/else statements. Future patches will also require
different handling for guest exists. Create an array of handlers
to consolidate them.

No functional change intended as the array isn't populated yet.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 43 +++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c        | 35 ++++++++++++++++++++
 2 files changed, 78 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index a0e78a6027be..5a2b89b96c67 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -409,6 +409,46 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+typedef int (*exit_handle_fn)(struct kvm_vcpu *);
+
+exit_handle_fn kvm_get_nvhe_exit_handler(struct kvm_vcpu *vcpu);
+
+static exit_handle_fn kvm_get_hyp_exit_handler(struct kvm_vcpu *vcpu)
+{
+	return is_nvhe_hyp_code() ? kvm_get_nvhe_exit_handler(vcpu) : NULL;
+}
+
+/*
+ * Allow the hypervisor to handle the exit with an exit handler if it has one.
+ *
+ * Returns true if the hypervisor handled the exit, and control should go back
+ * to the guest, or false if it hasn't.
+ */
+static bool kvm_hyp_handle_exit(struct kvm_vcpu *vcpu)
+{
+	bool is_handled = false;
+	exit_handle_fn exit_handler = kvm_get_hyp_exit_handler(vcpu);
+
+	if (exit_handler) {
+		/*
+		 * There's limited vcpu context here since it's not synced yet.
+		 * Ensure that relevant vcpu context that might be used by the
+		 * exit_handler is in sync before it's called and if handled.
+		 */
+		*vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
+		*vcpu_cpsr(vcpu) = read_sysreg_el2(SYS_SPSR);
+
+		is_handled = exit_handler(vcpu);
+
+		if (is_handled) {
+			write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
+			write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);
+		}
+	}
+
+	return is_handled;
+}
+
 /*
  * Return true when we were able to fixup the guest exit and should return to
  * the guest, false when we should restore the host state and return to the
@@ -496,6 +536,9 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 			goto guest;
 	}
 
+	/* Check if there's an exit handler and allow it to handle the exit. */
+	if (kvm_hyp_handle_exit(vcpu))
+		goto guest;
 exit:
 	/* Return to the host kernel and handle the exit */
 	return false;
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 86f3d6482935..36da423006bd 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -158,6 +158,41 @@ static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
 		write_sysreg(pmu->events_host, pmcntenset_el0);
 }
 
+typedef int (*exit_handle_fn)(struct kvm_vcpu *);
+
+static exit_handle_fn hyp_exit_handlers[] = {
+	[0 ... ESR_ELx_EC_MAX]		= NULL,
+	[ESR_ELx_EC_WFx]		= NULL,
+	[ESR_ELx_EC_CP15_32]		= NULL,
+	[ESR_ELx_EC_CP15_64]		= NULL,
+	[ESR_ELx_EC_CP14_MR]		= NULL,
+	[ESR_ELx_EC_CP14_LS]		= NULL,
+	[ESR_ELx_EC_CP14_64]		= NULL,
+	[ESR_ELx_EC_HVC32]		= NULL,
+	[ESR_ELx_EC_SMC32]		= NULL,
+	[ESR_ELx_EC_HVC64]		= NULL,
+	[ESR_ELx_EC_SMC64]		= NULL,
+	[ESR_ELx_EC_SYS64]		= NULL,
+	[ESR_ELx_EC_SVE]		= NULL,
+	[ESR_ELx_EC_IABT_LOW]		= NULL,
+	[ESR_ELx_EC_DABT_LOW]		= NULL,
+	[ESR_ELx_EC_SOFTSTP_LOW]	= NULL,
+	[ESR_ELx_EC_WATCHPT_LOW]	= NULL,
+	[ESR_ELx_EC_BREAKPT_LOW]	= NULL,
+	[ESR_ELx_EC_BKPT32]		= NULL,
+	[ESR_ELx_EC_BRK64]		= NULL,
+	[ESR_ELx_EC_FP_ASIMD]		= NULL,
+	[ESR_ELx_EC_PAC]		= NULL,
+};
+
+exit_handle_fn kvm_get_nvhe_exit_handler(struct kvm_vcpu *vcpu)
+{
+	u32 esr = kvm_vcpu_get_esr(vcpu);
+	u8 esr_ec = ESR_ELx_EC(esr);
+
+	return hyp_exit_handlers[esr_ec];
+}
+
 /* Switch to the guest for legacy non-VHE systems */
 int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 {
-- 
2.32.0.402.g57bb445576-goog

