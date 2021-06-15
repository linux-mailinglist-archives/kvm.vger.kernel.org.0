Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83DC3A80F5
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 15:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbhFONnC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 09:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231500AbhFONmk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 09:42:40 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3B46C061156
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 06:40:10 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id v1-20020a372f010000b02903aa9be319adso18429044qkh.11
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 06:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/ZNj//y7/SjoAxBEcefkL8ebDQE/+CV8RIiKr82iulc=;
        b=c8jRQUYuhTzwZVthFQCOV+MDGIBkdEnFNJ4lhEsf2PofCyfKBFI18FQmhYJgOYOeHX
         dFwtBz1+MhteiRUdOLVy0Nr/WE4hGhdHENFeFijmHo6T5RNO6lNzZDwqlTv6GVBpmuJt
         r/KfWXNR7QKgkmy1mnorlbDV16p5ViychL2SmieQggSi6PVzVERnItzKKzNewDKe1xgK
         2gnCu5LIlFYc4FNARtvkmDVOVFdPYsNE6C1yEdW7Mvl4HNKpHgmyb4TfTyM3jfpiTL3N
         TMy0TIUoQ+G8Xxd4cpEj5gpalk3HXOI88vG6n5KphoXtaN1yqdbDGR2OA8QDMq0C1BLF
         T0bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/ZNj//y7/SjoAxBEcefkL8ebDQE/+CV8RIiKr82iulc=;
        b=UytlCQW8BabYTBbyThYN1iABgu+qs58FALS0GG+5A8kp5qHw4fsrJsgL4jzMutrXbT
         18GvQfNyohtpUK5qH6uuwmUZIEr7AQ8BAp28tTXhSOqrh87S4VXsqifltyF8pjutdsKz
         sJmSxVK9DOemnKhN6kNqI0CYf7PyurcSmMzr/Ai8HN4uMsfe04VAVK19t6R6TO41/2sL
         0nq9ehzPOvGs1gQBTH1NZ/3fvSCOA0T17b3UszGNI2XDs13JN27DjCVFeCNHbfetoSRE
         Zgc5wk4rj3c9WnQXARgo6psGi+gr36Rkjp9AkNnZGz9Vvh13+K6XM3yXmz6MLBXf6l9Z
         unRw==
X-Gm-Message-State: AOAM532uxMyX30TSElNJqFbgB5gNNovHh4iq2AdA+PUv6o7I0AwmGaTl
        glQ8HcdEpHysMwI6uXD5Z4esGYTzFw==
X-Google-Smtp-Source: ABdhPJyTH68YPgkTSm2Hcof67XgYUf622myCRuThdrPr64jnQPXjhSM3f8Eps/2UjP0pI0ln/LGlMYSQ4A==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:20e3:: with SMTP id
 3mr5303675qvk.53.1623764409740; Tue, 15 Jun 2021 06:40:09 -0700 (PDT)
Date:   Tue, 15 Jun 2021 14:39:45 +0100
In-Reply-To: <20210615133950.693489-1-tabba@google.com>
Message-Id: <20210615133950.693489-9-tabba@google.com>
Mime-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v2 08/13] KVM: arm64: Guest exit handlers for nVHE hyp
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

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 19 ++++++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c        | 35 +++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index e4a2f295a394..f5d3d1da0aec 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -405,6 +405,18 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+typedef int (*exit_handle_fn)(struct kvm_vcpu *);
+
+exit_handle_fn kvm_get_nvhe_exit_handler(struct kvm_vcpu *vcpu);
+
+static exit_handle_fn kvm_get_hyp_exit_handler(struct kvm_vcpu *vcpu)
+{
+	if (is_nvhe_hyp_code())
+		return kvm_get_nvhe_exit_handler(vcpu);
+	else
+		return NULL;
+}
+
 /*
  * Return true when we were able to fixup the guest exit and should return to
  * the guest, false when we should restore the host state and return to the
@@ -412,6 +424,8 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
  */
 static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
+	exit_handle_fn exit_handler;
+
 	if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
 		vcpu->arch.fault.esr_el2 = read_sysreg_el2(SYS_ESR);
 
@@ -492,6 +506,11 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 			goto guest;
 	}
 
+	/* Check if there's an exit handler and allow it to handle the exit. */
+	exit_handler = kvm_get_hyp_exit_handler(vcpu);
+	if (exit_handler && exit_handler(vcpu))
+		goto guest;
+
 exit:
 	/* Return to the host kernel and handle the exit */
 	return false;
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 430b5bae8761..967a3ad74fbd 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -165,6 +165,41 @@ static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
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
2.32.0.272.g935e593368-goog

