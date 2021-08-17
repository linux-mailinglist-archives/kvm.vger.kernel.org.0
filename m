Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83AB93EE822
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 10:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234923AbhHQIMk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 04:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234952AbhHQIMe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 04:12:34 -0400
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A04C061764
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 01:12:01 -0700 (PDT)
Received: by mail-wm1-x34a.google.com with SMTP id f6-20020a05600c1546b029025af999e04dso4756112wmg.7
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 01:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wCAlPucxwkxQDsZjrMwYYiCi5QbYeNWxBim5zrWnq2Y=;
        b=Aakqhp0ujPFBkz2t9XKF2sWAACl4G7B5hxJDrt2uXINVbL4SDQRXJFOegBUQ1cWZ/J
         0jUUeLw9Od7HUTBaHF2bEbcWHbDSiLs7WOuMmHvkgQ9aKAKEc1Se9jaIc0RdmvVOh0fO
         2EN/wB6tJc5Zuqxbzk63h/bmcGOdULfseyFm4sZABt1qcXnPvBSlGoCTvs5yVR6Y8Yo1
         YMuBWKj78N9MEBXEHK0yav34qJ6J/ferOrSpzyXe15duHhdaVH3IinJtQB7TmOXkIdhf
         EGOlFmuP1fTlBQFW97lGVUPjXY5ipiWvG/UMC6271totgCudngPKM0tiXwaU5gQ9KdQm
         5UzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wCAlPucxwkxQDsZjrMwYYiCi5QbYeNWxBim5zrWnq2Y=;
        b=l3dy4+ONtDDRAefMC+TYSfXtYczqZ5r/SWp9MoMv47nS5vV2XajIWitYkJhYt/yeq7
         DQx0xwdCWlADzUV8jAVtdYwLOWrIMwjEJOwGlxnSb1jN0nowG081ci97vFqoSXCtd+u8
         6okGt7/JySMjGpsmOFoqdBLAx1yEgKm8e+WYGPOuJz10P81pZJc09LUFFamCS6IMt6Vy
         Qb2hVnlix+u4958pQmgT4jf+kJsjzUGq9mhmdgzEhoMLc/FT0jWXCtNoXfX4TvAK4awp
         MkNQ5B0xiHzKuN/zYPDFoabLuaNME49a3n6eQRbzFWx1VWmhtVsLj4xzobBfNlToa0zD
         PWnQ==
X-Gm-Message-State: AOAM530tdTvCybLt08oJTDzbiWmmIIkF4FpQb3HhGS0jcqrNUL7s3Wvm
        yM1wyD+74qt+cHBpkIggK8J5oeZKaw==
X-Google-Smtp-Source: ABdhPJyYTcbz4UVboGo7zKDmnSidrFF2RAjsx5lYf6M4UE4X0H/bCAlk0j+kiCGYLkR2pXqzSg2USK4ZwA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a1c:c914:: with SMTP id f20mr2057147wmb.140.1629187919570;
 Tue, 17 Aug 2021 01:11:59 -0700 (PDT)
Date:   Tue, 17 Aug 2021 09:11:30 +0100
In-Reply-To: <20210817081134.2918285-1-tabba@google.com>
Message-Id: <20210817081134.2918285-12-tabba@google.com>
Mime-Version: 1.0
References: <20210817081134.2918285-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v4 11/15] KVM: arm64: Guest exit handlers for nVHE hyp
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
 arch/arm64/kvm/hyp/nvhe/switch.c        | 33 +++++++++++++++++++
 2 files changed, 76 insertions(+)

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
index 86f3d6482935..b7f25307a7b9 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -158,6 +158,39 @@ static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
 		write_sysreg(pmu->events_host, pmcntenset_el0);
 }
 
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
2.33.0.rc1.237.g0d66db33f3-goog

