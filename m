Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED453EE82D
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 10:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239233AbhHQINE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 04:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239011AbhHQIMk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 04:12:40 -0400
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD88C061764
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 01:12:07 -0700 (PDT)
Received: by mail-wr1-x449.google.com with SMTP id z1-20020adfdf810000b0290154f7f8c412so6297829wrl.21
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 01:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=RY75TCp6EAmYPGA4I7+3iKQeuuwEdqY335GXVfnDS7k=;
        b=JYCa6cCgNtWF/sF0Bltf5bVCZmJFXv4748Iy5bRGGb+tbvHOCstp6BQWGgNwnjAz++
         ykeIvouot4Gx+7bHS4lR/vf4n38EIQV5c0vwbqfIxMWQ0Duh2plc+Z1hOYwMDf/PE7ii
         vrpDAnMRve8T7iTnx6xxkIr8J6d4/pGuQTJBcGtf72MnjQEoMT5z3cZE0IFKB4vIYZ8N
         Qyi+s2nQAKNGBdoqQCdd1Xj7jHpqX8ASK00m5yoxaaItWnRhIdmYBTuHaw8wSd2taDTR
         qMDZNZI/1U33C12jgjXOkicmnbPFKTwXX6/BXOCPPyKK1haKx+ejllyelOjzD62GHB4r
         Khbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=RY75TCp6EAmYPGA4I7+3iKQeuuwEdqY335GXVfnDS7k=;
        b=ZHBTU4/xgsWgkxFkFgvchjX+Zxd0ePbagaATU0ruXyw7eIuuKvEJO4DlGRGoBmpzyf
         j+5n5JXLQZPfvob3SkjPlJZ0bqptvtMvJu7ApEeT6YugofX9Dd9k1I9Q3wktSj0kSBWg
         /zq2Lf2uPSjZWl6WKG0+ezncfi3XSr+cAgoj+5+BAoaH0E0BHoP8G/xM4cGZxUKUvxYs
         02jIWCUzH47jrt9TOehiuR08gHzlWAzUr+70X1VB2Tc2sHhilgymhf9cVW8T0n7dzHL0
         ZlzQqd+wPzkIzU/LfaxBaHcwm4CsDcxTBhAxCdfHr8rjzfZ9sclEfbJoyWREK+zSHNez
         uqWw==
X-Gm-Message-State: AOAM531yV4Bn3SB1xP59R3Xds3F5lDGO2qoxZ86grqzsxynUxZtM6yi4
        L+0YQthI1JXvI4ttxuSiOEd48krFjg==
X-Google-Smtp-Source: ABdhPJy/OtVFqjYy4H9XKyK309GPg+Qg6SCvxgN3Qdf+Y2tTkAyZkPf+vBPU02aV6SLjKwZnco28Op+O2Q==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a1c:32c1:: with SMTP id y184mr2010593wmy.70.1629187925926;
 Tue, 17 Aug 2021 01:12:05 -0700 (PDT)
Date:   Tue, 17 Aug 2021 09:11:33 +0100
In-Reply-To: <20210817081134.2918285-1-tabba@google.com>
Message-Id: <20210817081134.2918285-15-tabba@google.com>
Mime-Version: 1.0
References: <20210817081134.2918285-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v4 14/15] KVM: arm64: Trap access to pVM restricted features
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

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h |  3 +++
 arch/arm64/kvm/hyp/nvhe/switch.c        | 34 ++++++++++++++-----------
 2 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 5a2b89b96c67..8431f1514280 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -33,6 +33,9 @@
 extern struct exception_table_entry __start___kvm_ex_table;
 extern struct exception_table_entry __stop___kvm_ex_table;
 
+int kvm_handle_pvm_sys64(struct kvm_vcpu *vcpu);
+int kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu);
+
 /* Check whether the FP regs were dirtied while in the host-side run loop: */
 static inline bool update_fp_enabled(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index b7f25307a7b9..398e62098898 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -159,27 +159,27 @@ static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
 }
 
 static exit_handle_fn hyp_exit_handlers[] = {
-	[0 ... ESR_ELx_EC_MAX]		= NULL,
+	[0 ... ESR_ELx_EC_MAX]		= kvm_handle_pvm_restricted,
 	[ESR_ELx_EC_WFx]		= NULL,
-	[ESR_ELx_EC_CP15_32]		= NULL,
-	[ESR_ELx_EC_CP15_64]		= NULL,
-	[ESR_ELx_EC_CP14_MR]		= NULL,
-	[ESR_ELx_EC_CP14_LS]		= NULL,
-	[ESR_ELx_EC_CP14_64]		= NULL,
+	[ESR_ELx_EC_CP15_32]		= kvm_handle_pvm_restricted,
+	[ESR_ELx_EC_CP15_64]		= kvm_handle_pvm_restricted,
+	[ESR_ELx_EC_CP14_MR]		= kvm_handle_pvm_restricted,
+	[ESR_ELx_EC_CP14_LS]		= kvm_handle_pvm_restricted,
+	[ESR_ELx_EC_CP14_64]		= kvm_handle_pvm_restricted,
 	[ESR_ELx_EC_HVC32]		= NULL,
 	[ESR_ELx_EC_SMC32]		= NULL,
 	[ESR_ELx_EC_HVC64]		= NULL,
 	[ESR_ELx_EC_SMC64]		= NULL,
-	[ESR_ELx_EC_SYS64]		= NULL,
-	[ESR_ELx_EC_SVE]		= NULL,
+	[ESR_ELx_EC_SYS64]		= kvm_handle_pvm_sys64,
+	[ESR_ELx_EC_SVE]		= kvm_handle_pvm_restricted,
 	[ESR_ELx_EC_IABT_LOW]		= NULL,
 	[ESR_ELx_EC_DABT_LOW]		= NULL,
-	[ESR_ELx_EC_SOFTSTP_LOW]	= NULL,
-	[ESR_ELx_EC_WATCHPT_LOW]	= NULL,
-	[ESR_ELx_EC_BREAKPT_LOW]	= NULL,
-	[ESR_ELx_EC_BKPT32]		= NULL,
-	[ESR_ELx_EC_BRK64]		= NULL,
-	[ESR_ELx_EC_FP_ASIMD]		= NULL,
+	[ESR_ELx_EC_SOFTSTP_LOW]	= kvm_handle_pvm_restricted,
+	[ESR_ELx_EC_WATCHPT_LOW]	= kvm_handle_pvm_restricted,
+	[ESR_ELx_EC_BREAKPT_LOW]	= kvm_handle_pvm_restricted,
+	[ESR_ELx_EC_BKPT32]		= kvm_handle_pvm_restricted,
+	[ESR_ELx_EC_BRK64]		= kvm_handle_pvm_restricted,
+	[ESR_ELx_EC_FP_ASIMD]		= kvm_handle_pvm_restricted,
 	[ESR_ELx_EC_PAC]		= NULL,
 };
 
@@ -188,7 +188,11 @@ exit_handle_fn kvm_get_nvhe_exit_handler(struct kvm_vcpu *vcpu)
 	u32 esr = kvm_vcpu_get_esr(vcpu);
 	u8 esr_ec = ESR_ELx_EC(esr);
 
-	return hyp_exit_handlers[esr_ec];
+	/* For now, only protected VMs have exit handlers. */
+	if (unlikely(kvm_vm_is_protected(kern_hyp_va(vcpu->kvm))))
+		return hyp_exit_handlers[esr_ec];
+	else
+		return NULL;
 }
 
 /* Switch to the guest for legacy non-VHE systems */
-- 
2.33.0.rc1.237.g0d66db33f3-goog

