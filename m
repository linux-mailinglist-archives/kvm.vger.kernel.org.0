Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95F61767AA4
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 03:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237518AbjG2BRt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 21:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237354AbjG2BR0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 21:17:26 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A574EDA
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:16:57 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d11f35a0d5cso2593468276.1
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690593394; x=1691198194;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=txdsA1xtp9opNpvC2N9YIeErGNCur9/2M/6XZwnPohE=;
        b=X/UYeRCMQX8Eu9aWHhq75jQGUGL5bLyA71aOLK+Lx7A7sJ9r+Bx7QwhdNrIw4gJUdX
         /FVtta1v5YqwQaCJonKbTtCYFJCYboHzXK7DfnJRMUgleO5LJ6nIVVq/GFjTrjM68fCa
         7vVF2JmEDsxFnWJiki9i003iyqtuYGt5WXx95tGx5s1Sw6aF1xEWNiGtVk76Pdrx1Fna
         91SguJH+ATnTEShAEIWEgOjRn3Gv6MOhegfUJbXNWSup4GfS+BQEHtWfUkVE07RBpnP8
         E9UyDiIVBjb8c5GIUuXDzPRoJlmN8LSBlH8Jec4Nh0YdePtBTWyuQcVh9j70+YAtNlfn
         YyEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690593394; x=1691198194;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=txdsA1xtp9opNpvC2N9YIeErGNCur9/2M/6XZwnPohE=;
        b=CNAVHs55JuOsQRlIcknwk+HjA4ciL1bMQTLDTRSvj93XxhL0IBOf+p7+uWean97aeW
         vu/vz3r9PoHTwOEtKO7ECpFX0NkvRDH0+1Uw8ltsgCtSjxBBuwOMgLXwU5MMFUBPtf8W
         ifF0FEVEXvDF+hu5b1pKfAi/0763prBuwYEEyGSyXWnd7KPHntnsNXxABv7mjbDgdCjn
         WR3y0+sufe6jeJ9ePA+eNx97yI2A/c5O/O/oIkF5ImZ33p/LN1XURuwsRw2LDIx1jE9u
         fC58o4Wbq/Jht7W6+/Vxw1VODMXIJsnrT3tl7uB5C6Sw6H2bZBmNdxikkRgSJ4WBr2xj
         LQoQ==
X-Gm-Message-State: ABy/qLaeVS+G7dnQu1WW5nKF7nKrizjx8mROS+XrcfxccnnyVJiuvnDp
        lvZym0RNUY/Ijsw0v0LHbE/fwo7KL5M=
X-Google-Smtp-Source: APBJJlHm92p3mBshzqwFy8AkJJGn2KFFOP58Bbms+0JsAktDEbZUGe75BC0IveFbL/cDfaFSFLZV+ASfxeg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:e6d3:0:b0:c72:2386:7d26 with SMTP id
 d202-20020a25e6d3000000b00c7223867d26mr18792ybh.0.1690593394398; Fri, 28 Jul
 2023 18:16:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 18:15:58 -0700
In-Reply-To: <20230729011608.1065019-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729011608.1065019-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729011608.1065019-12-seanjc@google.com>
Subject: [PATCH v2 11/21] KVM: VMX: Rename XSAVES control to follow KVM's
 preferred "ENABLE_XYZ"
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename the XSAVES secondary execution control to follow KVM's preferred
style so that XSAVES related logic can use common macros that depend on
KVM's preferred style.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/vmx.h      | 2 +-
 arch/x86/kvm/vmx/capabilities.h | 2 +-
 arch/x86/kvm/vmx/hyperv.c       | 2 +-
 arch/x86/kvm/vmx/nested.c       | 6 +++---
 arch/x86/kvm/vmx/nested.h       | 2 +-
 arch/x86/kvm/vmx/vmx.c          | 2 +-
 arch/x86/kvm/vmx/vmx.h          | 2 +-
 7 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 0d02c4aafa6f..0e73616b82f3 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -71,7 +71,7 @@
 #define SECONDARY_EXEC_RDSEED_EXITING		VMCS_CONTROL_BIT(RDSEED_EXITING)
 #define SECONDARY_EXEC_ENABLE_PML               VMCS_CONTROL_BIT(PAGE_MOD_LOGGING)
 #define SECONDARY_EXEC_PT_CONCEAL_VMX		VMCS_CONTROL_BIT(PT_CONCEAL_VMX)
-#define SECONDARY_EXEC_XSAVES			VMCS_CONTROL_BIT(XSAVES)
+#define SECONDARY_EXEC_ENABLE_XSAVES		VMCS_CONTROL_BIT(XSAVES)
 #define SECONDARY_EXEC_MODE_BASED_EPT_EXEC	VMCS_CONTROL_BIT(MODE_BASED_EPT_EXEC)
 #define SECONDARY_EXEC_PT_USE_GPA		VMCS_CONTROL_BIT(PT_USE_GPA)
 #define SECONDARY_EXEC_TSC_SCALING              VMCS_CONTROL_BIT(TSC_SCALING)
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index d0abee35d7ba..41a4533f9989 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -252,7 +252,7 @@ static inline bool cpu_has_vmx_pml(void)
 static inline bool cpu_has_vmx_xsaves(void)
 {
 	return vmcs_config.cpu_based_2nd_exec_ctrl &
-		SECONDARY_EXEC_XSAVES;
+		SECONDARY_EXEC_ENABLE_XSAVES;
 }
 
 static inline bool cpu_has_vmx_waitpkg(void)
diff --git a/arch/x86/kvm/vmx/hyperv.c b/arch/x86/kvm/vmx/hyperv.c
index 79450e1ed7cf..313b8bb5b8a7 100644
--- a/arch/x86/kvm/vmx/hyperv.c
+++ b/arch/x86/kvm/vmx/hyperv.c
@@ -78,7 +78,7 @@
 	 SECONDARY_EXEC_DESC |						\
 	 SECONDARY_EXEC_ENABLE_RDTSCP |					\
 	 SECONDARY_EXEC_ENABLE_INVPCID |				\
-	 SECONDARY_EXEC_XSAVES |					\
+	 SECONDARY_EXEC_ENABLE_XSAVES |					\
 	 SECONDARY_EXEC_RDSEED_EXITING |				\
 	 SECONDARY_EXEC_RDRAND_EXITING |				\
 	 SECONDARY_EXEC_TSC_SCALING |					\
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 516391cc0d64..22e08d30baef 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2307,7 +2307,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 				  SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |
 				  SECONDARY_EXEC_ENABLE_INVPCID |
 				  SECONDARY_EXEC_ENABLE_RDTSCP |
-				  SECONDARY_EXEC_XSAVES |
+				  SECONDARY_EXEC_ENABLE_XSAVES |
 				  SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE |
 				  SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
 				  SECONDARY_EXEC_APIC_REGISTER_VIRT |
@@ -6331,7 +6331,7 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu,
 		 * If if it were, XSS would have to be checked against
 		 * the XSS exit bitmap in vmcs12.
 		 */
-		return nested_cpu_has2(vmcs12, SECONDARY_EXEC_XSAVES);
+		return nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENABLE_XSAVES);
 	case EXIT_REASON_UMWAIT:
 	case EXIT_REASON_TPAUSE:
 		return nested_cpu_has2(vmcs12,
@@ -6874,7 +6874,7 @@ static void nested_vmx_setup_secondary_ctls(u32 ept_caps,
 		SECONDARY_EXEC_ENABLE_INVPCID |
 		SECONDARY_EXEC_ENABLE_VMFUNC |
 		SECONDARY_EXEC_RDSEED_EXITING |
-		SECONDARY_EXEC_XSAVES |
+		SECONDARY_EXEC_ENABLE_XSAVES |
 		SECONDARY_EXEC_TSC_SCALING |
 		SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE;
 
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 96952263b029..b4b9d51438c6 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -168,7 +168,7 @@ static inline int nested_cpu_has_ept(struct vmcs12 *vmcs12)
 
 static inline bool nested_cpu_has_xsaves(struct vmcs12 *vmcs12)
 {
-	return nested_cpu_has2(vmcs12, SECONDARY_EXEC_XSAVES);
+	return nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENABLE_XSAVES);
 }
 
 static inline bool nested_cpu_has_pml(struct vmcs12 *vmcs12)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e358e3fa1ced..a0a47be2feed 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4589,7 +4589,7 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
 
 	if (cpu_has_vmx_xsaves())
 		vmx_adjust_secondary_exec_control(vmx, &exec_control,
-						  SECONDARY_EXEC_XSAVES,
+						  SECONDARY_EXEC_ENABLE_XSAVES,
 						  vcpu->arch.xsaves_enabled, false);
 
 	/*
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 32384ba38499..cde902b44d97 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -562,7 +562,7 @@ static inline u8 vmx_get_rvi(void)
 	 SECONDARY_EXEC_APIC_REGISTER_VIRT |				\
 	 SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |				\
 	 SECONDARY_EXEC_SHADOW_VMCS |					\
-	 SECONDARY_EXEC_XSAVES |					\
+	 SECONDARY_EXEC_ENABLE_XSAVES |					\
 	 SECONDARY_EXEC_RDSEED_EXITING |				\
 	 SECONDARY_EXEC_RDRAND_EXITING |				\
 	 SECONDARY_EXEC_ENABLE_PML |					\
-- 
2.41.0.487.g6d72f3e995-goog

