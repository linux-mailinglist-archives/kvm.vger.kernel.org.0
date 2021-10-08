Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21984426E46
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 17:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243265AbhJHQA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 12:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243213AbhJHQAw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 12:00:52 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E356C061755
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 08:58:57 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id p8-20020a056902114800b005bad2571fbeso1638543ybu.23
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 08:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wJJszilA4UjK4AVsoFrSiurMN2NLV1CPui7ahB+b56k=;
        b=M51Vbk1q9IjlvFH69oju/v/0EZl0tmloeEi+Zm7yAa5eIazZ3bwWbULGhXTFrF3g+I
         nvKA2iN14W9lBh5jRZQHy7dbu97XxDElG+vOlto2BkZcB8XdOec8cUXJixbIVWPST05c
         yqL0gGAZaoP8OUS2Wrd5IOydUMck54gjCvrKb10++sXrM5ZrhxqkwHCz+SGsd/Ap4fYG
         MMCokjmynYOtvo0q6VOEpMNIMkvHXThtGSd5q/nk60vDUZPj3tKzmViUw7S3+cNNuUth
         3rkXCfe7mJk20Q7NOKta4Nj9y/Yp3ENKePr2eqDZcegBFtPhjGY9Kx9ubWGg0Rj2og+u
         vZVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wJJszilA4UjK4AVsoFrSiurMN2NLV1CPui7ahB+b56k=;
        b=Y6zbkv/qgS+FZaMQmTosEwzbWDiqkoVqL48xvLUiy4DsTSwXDRptgKALpDJDlWUTXd
         w8So+K2jYjahLsxRDOGVv42aJVdAMyHJa7Nrs6Uxtd3U71ylDE/sOtfnQs6v0owQNyZ/
         Y7eEgmrC4979mqn5u6sQusjHtHMmdIKkciNxCLa7MOzUg2rKGTjH8Q1nda3idfR0Nzr7
         rhNwGzAg9/+gU0C+Jn2oNXtb3YuP/YAcqAlzNM+zWbatIhLNAEMllzEFGKGIO5YAn2bl
         WqXK4BsndHEWrQRke9eYrQJMbTrK7hryzF2wqWPwiIemmfAUtzI6Vik9NhwoNT/HnifQ
         aJdA==
X-Gm-Message-State: AOAM532FmanuoCC8x4Bwtu2//c2mBS6ccbhIwRT+U2NgmDxEc4fNSa+5
        kzTx3EHAeV5YDXIV/vJWa/DNcx9djQ==
X-Google-Smtp-Source: ABdhPJypJlyAK9gZ3NArU2IoVCZTDXwNxMf5X4WHL+8HZexKeq/iR/ES1qBsGJeLq1H3EWl/v9iimIx4Sg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a25:3491:: with SMTP id b139mr4249799yba.229.1633708736091;
 Fri, 08 Oct 2021 08:58:56 -0700 (PDT)
Date:   Fri,  8 Oct 2021 16:58:31 +0100
In-Reply-To: <20211008155832.1415010-1-tabba@google.com>
Message-Id: <20211008155832.1415010-11-tabba@google.com>
Mime-Version: 1.0
References: <20211008155832.1415010-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v7 10/11] KVM: arm64: Trap access to pVM restricted features
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

