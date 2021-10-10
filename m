Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D898428216
	for <lists+kvm@lfdr.de>; Sun, 10 Oct 2021 16:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbhJJO7B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Oct 2021 10:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbhJJO7A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Oct 2021 10:59:00 -0400
Received: from mail-wr1-x44a.google.com (mail-wr1-x44a.google.com [IPv6:2a00:1450:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9A4C061570
        for <kvm@vger.kernel.org>; Sun, 10 Oct 2021 07:57:01 -0700 (PDT)
Received: by mail-wr1-x44a.google.com with SMTP id j19-20020adfb313000000b00160a9de13b3so11187559wrd.8
        for <kvm@vger.kernel.org>; Sun, 10 Oct 2021 07:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wJJszilA4UjK4AVsoFrSiurMN2NLV1CPui7ahB+b56k=;
        b=Ow5SKrzHi5KMDQpSvK1KHntWnfWS6myL/6y9xdSh1m6R/DWZ1eRdqgTSKPYAgsfnAx
         OpQTYkvyjAdwdeXBAMwATpF/MsyXpZCpx/uagnVUtK6MWlyFl+dluZ9wg6DUz6k3vn6y
         XSfLM/GETYlCxwiWvtr8D5PdSQ5++Exmc+T5GNuH27MhVNIFA4NxZLjqlJF6W8KW5g2w
         fOCX/KWYV0nHOShCZ7hh6LAkq6U/Ch1E+8daVXbpTYbl7Lu8Nu995QJ9HIVWXPBtDXvl
         WzbuXfYNdVHH75mRS09WF3kHHBcfTtWWDDLMsqKnN5BL2jm287j33R/pHVMhH6byiHHh
         MHMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wJJszilA4UjK4AVsoFrSiurMN2NLV1CPui7ahB+b56k=;
        b=A0x636XqNvDbLf9cSlisAeDgEYfnMDMoGjZxpLKO+TYxiid+NPz3+iT2AfVrf5e2k6
         Tdy0MqUSlcyGtNtIghxCLBqg9z4Sc1u+VHyIW09QbzD7t2Hdm97TNnPZTBNlfYglPYyA
         RoP6ii6eJ+ki1QnIl8N7ua6n3jbB2GdSb5XhEVFGVKQbzKDdW2mVrFwDRkU+dlQ131+o
         lW9O2MRB50vWNQk4WyuTBr6rqWFn7OoF+CW4CQvMzPZMZKLJr08uhNWuooAq6dhRiZzD
         qva/3s7kkuqchU3QWwWOxPl6/++/H30rMMJaBHdBiSd4tuXrVtFDe/+0woQoND6FL35t
         TW6Q==
X-Gm-Message-State: AOAM532Y1uTyytqQdCbcgsBtuNoZ2+sO8bBWWyzN0yZ1LyX/7+RfDvUy
        EOj0+8nWdx8FbWIDKaiPfUknecBjxQ==
X-Google-Smtp-Source: ABdhPJwvTl9Wcky+c5OAdYZqVghTezWFoe2hGlafMlweZuHYVdQl8lMVeo4zq56ls1vQDJ2SAjw04f/lhQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a5d:54cc:: with SMTP id x12mr6892549wrv.343.1633877820327;
 Sun, 10 Oct 2021 07:57:00 -0700 (PDT)
Date:   Sun, 10 Oct 2021 15:56:35 +0100
In-Reply-To: <20211010145636.1950948-1-tabba@google.com>
Message-Id: <20211010145636.1950948-11-tabba@google.com>
Mime-Version: 1.0
References: <20211010145636.1950948-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v8 10/11] KVM: arm64: Trap access to pVM restricted features
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
 arch/arm64/kvm/hyp/nvhe/switch.c | 57 ++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 17d1a9512507..2c72c31e516e 100644
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
@@ -159,6 +160,49 @@ static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
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
+	inject_undef64(vcpu);
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
+
+	return kvm_hyp_handle_sysreg(vcpu, exit_code);
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
 	[ESR_ELx_EC_CP15_32]		= kvm_hyp_handle_cp15_32,
@@ -170,8 +214,21 @@ static const exit_handler_fn hyp_exit_handlers[] = {
 	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
 };
 
+static const exit_handler_fn pvm_exit_handlers[] = {
+	[0 ... ESR_ELx_EC_MAX]		= NULL,
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
2.33.0.882.g93a45727a2-goog

