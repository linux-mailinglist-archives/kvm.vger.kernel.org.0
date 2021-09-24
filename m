Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8AF341758F
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 15:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345113AbhIXNZl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 09:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345287AbhIXNZA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 09:25:00 -0400
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54674C08EB3F
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:45 -0700 (PDT)
Received: by mail-wr1-x449.google.com with SMTP id h5-20020a5d6885000000b0015e21e37523so7980359wru.10
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xhHjvocneo3OmYPl2aUhxqJ3BMqVUjdViv8A/KXRtOc=;
        b=J/C7Ta1yUem3gYRbil/zKRF0IxStHUFvTVNEvuRRLK6gctPS7/SC8wGX+7hdV8c7WF
         sjSMDuG0NjrV+/3ZNT0KciOwQfFrUiKwdKHNGGAYU85PPOeEbgyIDakYmiziwKsXibQN
         ZPrs0iDshzZjAJZ1kGyfQ1P565o2m8tAaHk2VwfnaXwwQCX46G347RPHq4hD4gmQ2LzT
         SLor++gvWIZW6zyDo3nnux9Tf+Km2hcZI0xela+/ti30GaLVylKlApErL4/QNfcgmrZL
         +j6MVi7XB5CJE/FaDfjRSKxRzHxJNULy6UVDbKmpOpKkV6+Jjj8ul6m6gZRAuZ+d1A50
         4JLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xhHjvocneo3OmYPl2aUhxqJ3BMqVUjdViv8A/KXRtOc=;
        b=quJROKQSUFs8WDP2464uczfwwxF3qM7JUbp0oFaWr7D6QQmGnIEVF95R8gwikSEE2Z
         mhDN16iPc3t2my3U5EU2CM/7C7YgoTvIigl6JZdIIsF1lgEuo75N4L4T66d6GNpPmqga
         NEnbLJByylfvWJFTP2UsKZpL6Xtgz8DhQJO+AMwbAMuw4fK2B8Aod28EyhtSJzDYVExv
         RFCMQrrhIC6fPDD06fQcHthsrUMiXhXH+KlEoyDMKKl1alwYeHrmGKWcYqJsQWBN4Jy1
         dhX5a9Hu+zVDk/2bo9SWf/CA7GrbafB2nNeZuENlSKrl3q13fEIJ3l2WcrpjTgAGo2RM
         9Grg==
X-Gm-Message-State: AOAM530jnQnIYkj9m7N2lDgpwoOm03GFGr3a4UihIAG7W7IDrwD8UTHL
        UdB+EmndUASiQbefaLKNS9L1ZBL5mA==
X-Google-Smtp-Source: ABdhPJxU6dLnsCPB/2TUUhu7b+8Tafoe11ACEILnegBEKHhcSyod6McampCuDXPyU43B2yIY76HX2EhGMA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6000:1a89:: with SMTP id
 f9mr11219965wry.19.1632488083973; Fri, 24 Sep 2021 05:54:43 -0700 (PDT)
Date:   Fri, 24 Sep 2021 13:53:49 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-21-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 20/30] KVM: arm64: add __hyp_running_ctxt and __hyp_running_hyps
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com, drjones@redhat.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to prepare to remove __hyp_running_vcpu, add
__hyp_running_ctxt and __hyp_running_hyps to access the running
kvm_cpu_ctxt and the hyp_state, as well as their associated
assembly offsets.

These new fields are updated but not accessed yet. Their state is
consistent with __hyp_running_vcpu.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_asm.h  | 13 +++++++++++++
 arch/arm64/include/asm/kvm_host.h | 19 ++++++++++++++++---
 arch/arm64/kernel/asm-offsets.c   |  2 ++
 arch/arm64/kvm/hyp/entry.S        |  2 +-
 4 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 766b6a852407..52079e937fcd 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -271,6 +271,19 @@ extern u32 __kvm_get_mdcr_el2(void);
 .macro set_loaded_vcpu vcpu, ctxt, tmp
 	adr_this_cpu \ctxt, kvm_hyp_ctxt, \tmp
 	str	\vcpu, [\ctxt, #HOST_CONTEXT_VCPU]
+
+	add	\tmp, \vcpu, #VCPU_CONTEXT
+	str	\tmp, [\ctxt, #HOST_CONTEXT_CTXT]
+
+	add	\tmp, \vcpu, #VCPU_HYPS
+	str	\tmp, [\ctxt, #HOST_CONTEXT_HYPS]
+.endm
+
+.macro clear_loaded_vcpu ctxt, tmp
+	adr_this_cpu \ctxt, kvm_hyp_ctxt, \tmp
+	str	xzr, [\ctxt, #HOST_CONTEXT_VCPU]
+	str	xzr, [\ctxt, #HOST_CONTEXT_CTXT]
+	str	xzr, [\ctxt, #HOST_CONTEXT_HYPS]
 .endm
 
 .macro get_loaded_vcpu_ctxt vcpu, ctxt
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4b01c74705ad..b42d0c6c8004 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -228,14 +228,27 @@ struct kvm_cpu_context {
 	u64 sys_regs[NR_SYS_REGS];
 
 	struct kvm_vcpu *__hyp_running_vcpu;
+	struct kvm_cpu_context *__hyp_running_ctxt;
+	struct vcpu_hyp_state *__hyp_running_hyps;
 };
 
 #define get_hyp_running_vcpu(ctxt) (ctxt)->__hyp_running_vcpu
-#define set_hyp_running_vcpu(ctxt, vcpu) (ctxt)->__hyp_running_vcpu = (vcpu)
+#define set_hyp_running_vcpu(host_ctxt, vcpu) do { \
+	struct kvm_vcpu *v = (vcpu); \
+	(host_ctxt)->__hyp_running_vcpu = v; \
+	if (vcpu) { \
+		(host_ctxt)->__hyp_running_ctxt = &v->arch.ctxt; \
+		(host_ctxt)->__hyp_running_hyps = &v->arch.hyp_state; \
+	} else { \
+		(host_ctxt)->__hyp_running_ctxt = NULL; \
+		(host_ctxt)->__hyp_running_hyps = NULL;	\
+	}\
+} while(0)
+
 #define is_hyp_running_vcpu(ctxt) (ctxt)->__hyp_running_vcpu
 
-#define get_hyp_running_ctxt(host_ctxt) (host_ctxt)->__hyp_running_vcpu ? &(host_ctxt)->__hyp_running_vcpu->arch.ctxt : NULL
-#define get_hyp_running_hyps(host_ctxt) (host_ctxt)->__hyp_running_vcpu ? &(host_ctxt)->__hyp_running_vcpu->arch.hyp_state : NULL
+#define get_hyp_running_ctxt(host_ctxt) (host_ctxt)->__hyp_running_ctxt
+#define get_hyp_running_hyps(host_ctxt) (host_ctxt)->__hyp_running_hyps
 
 struct kvm_pmu_events {
 	u32 events_host;
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 1ecc55570acc..9c25078da294 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -117,6 +117,8 @@ int main(void)
   DEFINE(CPU_APDBKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APDBKEYLO_EL1]));
   DEFINE(CPU_APGAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APGAKEYLO_EL1]));
   DEFINE(HOST_CONTEXT_VCPU,	offsetof(struct kvm_cpu_context, __hyp_running_vcpu));
+  DEFINE(HOST_CONTEXT_CTXT,	offsetof(struct kvm_cpu_context, __hyp_running_ctxt));
+  DEFINE(HOST_CONTEXT_HYPS,	offsetof(struct kvm_cpu_context, __hyp_running_hyps));
   DEFINE(HOST_DATA_CONTEXT,	offsetof(struct kvm_host_data, host_ctxt));
   DEFINE(NVHE_INIT_MAIR_EL2,	offsetof(struct kvm_nvhe_init_params, mair_el2));
   DEFINE(NVHE_INIT_TCR_EL2,	offsetof(struct kvm_nvhe_init_params, tcr_el2));
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 1804be5b7ead..8e7033aa5770 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -145,7 +145,7 @@ SYM_INNER_LABEL(__guest_exit, SYM_L_GLOBAL)
 	// Now restore the hyp regs
 	restore_callee_saved_regs x2
 
-	set_loaded_vcpu xzr, x2, x3
+	clear_loaded_vcpu x2, x3
 
 alternative_if ARM64_HAS_RAS_EXTN
 	// If we have the RAS extensions we can consume a pending error
-- 
2.33.0.685.g46640cef36-goog

