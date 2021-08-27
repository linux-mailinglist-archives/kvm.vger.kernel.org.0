Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 691623F97F6
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 12:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244801AbhH0KRE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 06:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244492AbhH0KRD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 06:17:03 -0400
Received: from mail-ej1-x64a.google.com (mail-ej1-x64a.google.com [IPv6:2a00:1450:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB218C061757
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 03:16:14 -0700 (PDT)
Received: by mail-ej1-x64a.google.com with SMTP id m18-20020a170906849200b005c701c9b87cso2470522ejx.8
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 03:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NFmwahCJPjKMgLXFE2G8OWVIMCZP6DkMYgpwDJuIwBQ=;
        b=qhIOD7wrafZ3Mp7/O97JQuMwyNkxsnet3wMwgSz0WksNAzWWoS7Zpt7qlYNuM3Bh49
         6Lce9FCBBjV9NB5YiY8doZmpbw/Fl1pTpt/1JWIEMEm1dywjeI44OcKKoJ96pCsK7uaf
         tEx0G9XGZiCMcdS/vj83Ex+g9bXbT1QprKQTpwU+2BbGddW0hh1t7ofVEDr0kq9TAOSK
         1braZtcsXz8mEsZL7F/AbqfJj0EIejHT2FCnwmY5ILqg7TxF0lpZFlWLZooVGVesFWSJ
         XKA0/nQYB8LSsg8mcnrg53jVvs+38oiJ7/614HUG+4qDLoyxq81/JKpOpQUUWxPD01rZ
         a2qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NFmwahCJPjKMgLXFE2G8OWVIMCZP6DkMYgpwDJuIwBQ=;
        b=NO+iGLJX2Q4v9/VqngbGbWElgJwJpf53gxkJUZjuR7VsubgEISw6NRL0hZw8Yglp51
         nk6Y+tPxeHIDVjeyzMWEvdn0P95H8fYFfPUPoe2dtshef1WdArHxvNwZeYa3glNr2XIT
         gZXjjVHGt2wk7qsihAiEBHjZzisCQzbvOEbx4rHrijQyYtWAY9985c/4E+L5QSe9O98k
         F4hNrBzwDDLnVKtMFMGVQcaZOfFIuegPxia2+CzKCir9HOaq4aGHaZJ+bmaUg5CUy3TR
         X9tgQbmVcwuTo8Wl1N89GV1z8q6afi+CCGcx5LuugbOY5UuiDxhps95kz+ahoPLN3G6B
         Br1w==
X-Gm-Message-State: AOAM530PbSwIfxS2Q54L3Tp8Qe8/1BROJxSgfclT0pPsENDjHfDxOd6H
        d/13+1eRoCTrJu4JL2WrSIgHed+k+A==
X-Google-Smtp-Source: ABdhPJySMX7A3RFpshpjMxp86rhAKRZwfXVLPHQJsDtHSPkVKvJlSoEvVmAgZkoW3RSZfKiUcuwfCmB/ew==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a17:906:29c7:: with SMTP id
 y7mr9236324eje.258.1630059373138; Fri, 27 Aug 2021 03:16:13 -0700 (PDT)
Date:   Fri, 27 Aug 2021 11:16:02 +0100
In-Reply-To: <20210827101609.2808181-1-tabba@google.com>
Message-Id: <20210827101609.2808181-2-tabba@google.com>
Mime-Version: 1.0
References: <20210827101609.2808181-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH v5 1/8] KVM: arm64: Pass struct kvm to per-EC handlers
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

We need struct kvm to check for protected VMs to be able to pick
the right handlers for them.

Mark the handler functions inline, since some handlers will be
called in future code from the protected VM handlers.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 16 ++++++++--------
 arch/arm64/kvm/hyp/nvhe/switch.c        |  2 +-
 arch/arm64/kvm/hyp/vhe/switch.c         |  2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 0397606c0951..7cbff0ee59a5 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -163,7 +163,7 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
  * If FP/SIMD is not implemented, handle the trap and inject an undefined
  * instruction exception to the guest. Similarly for trapped SVE accesses.
  */
-static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
+static inline bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	bool sve_guest, sve_host;
 	u8 esr_ec;
@@ -318,7 +318,7 @@ static inline bool esr_is_ptrauth_trap(u32 esr)
 
 DECLARE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
 
-static bool kvm_hyp_handle_ptrauth(struct kvm_vcpu *vcpu, u64 *exit_code)
+static inline bool kvm_hyp_handle_ptrauth(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	struct kvm_cpu_context *ctxt;
 	u64 val;
@@ -343,7 +343,7 @@ static bool kvm_hyp_handle_ptrauth(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return true;
 }
 
-static bool kvm_hyp_handle_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code)
+static inline bool kvm_hyp_handle_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	if (cpus_have_final_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM) &&
 	    handle_tx2_tvm(vcpu))
@@ -356,7 +356,7 @@ static bool kvm_hyp_handle_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return false;
 }
 
-static bool kvm_hyp_handle_cp15(struct kvm_vcpu *vcpu, u64 *exit_code)
+static inline bool kvm_hyp_handle_cp15(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	if (static_branch_unlikely(&vgic_v3_cpuif_trap) &&
 	    __vgic_v3_perform_cpuif_access(vcpu) == 1)
@@ -365,7 +365,7 @@ static bool kvm_hyp_handle_cp15(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return false;
 }
 
-static bool kvm_hyp_handle_iabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
+static inline bool kvm_hyp_handle_iabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	if (!__populate_fault_info(vcpu))
 		return true;
@@ -373,7 +373,7 @@ static bool kvm_hyp_handle_iabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return false;
 }
 
-static bool kvm_hyp_handle_dabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
+static inline bool kvm_hyp_handle_dabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	if (!__populate_fault_info(vcpu))
 		return true;
@@ -403,7 +403,7 @@ static bool kvm_hyp_handle_dabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
 
 typedef bool (*exit_handler_fn)(struct kvm_vcpu *, u64 *);
 
-static const exit_handler_fn *kvm_get_exit_handler_array(void);
+const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm);
 
 /*
  * Allow the hypervisor to handle the exit with an exit handler if it has one.
@@ -413,7 +413,7 @@ static const exit_handler_fn *kvm_get_exit_handler_array(void);
  */
 static inline bool kvm_hyp_handle_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
-	const exit_handler_fn *handlers = kvm_get_exit_handler_array();
+	const exit_handler_fn *handlers = kvm_get_exit_handler_array(kern_hyp_va(vcpu->kvm));
 	exit_handler_fn fn;
 
 	fn = handlers[kvm_vcpu_trap_get_class(vcpu)];
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index c52d580708e0..ebc0a5a4dd6a 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -170,7 +170,7 @@ static const exit_handler_fn hyp_exit_handlers[] = {
 	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
 };
 
-static const exit_handler_fn *kvm_get_exit_handler_array(void)
+const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm)
 {
 	return hyp_exit_handlers;
 }
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 0e0d342358f7..d823b089d3e9 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -108,7 +108,7 @@ static const exit_handler_fn hyp_exit_handlers[] = {
 	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
 };
 
-static const exit_handler_fn *kvm_get_exit_handler_array(void)
+const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm)
 {
 	return hyp_exit_handlers;
 }
-- 
2.33.0.259.gc128427fd7-goog

