Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B28869B643
	for <lists+kvm@lfdr.de>; Sat, 18 Feb 2023 00:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjBQXKt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 18:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjBQXKk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 18:10:40 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DE65B755
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 15:10:34 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5365663d982so25234637b3.3
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 15:10:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=CaPfkcXmkBtA2D8Z87DWoQYnHOyWPdakqD7fSwd7G24=;
        b=o8r/4PULq9yEbjeUsh71LSJhc1lJ8bkaR5WaNXMyqA4+4XPVUCxKwwXcnLE1CHGc8w
         9nyn5fAOI8sLNMoIzdrE5cBMEqd0dlUyNoM7LxPIN6JSi9K23b3EyCUEQf8J37GO/zMG
         H00hMnY3qXelWrkK9CPXZzNlGE1mw41mxNbmUDZxiyolPd3uTBR31wt1uousgdnKjTJe
         dJJDypc6eJMlVyXE+SV3aKkIt5IUvagP3iIExEM1EGabPJWdzyPTlyLh/IIneyXVQiUh
         eOTOeI9RCJRBr4b3AeCsJKgUyQHXtSzg72E0/FW6HWWC67noH7trvDIYJhw1yQCd5iUA
         j+ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CaPfkcXmkBtA2D8Z87DWoQYnHOyWPdakqD7fSwd7G24=;
        b=qvv6g5Jkrl//g4HH0MXBnt9NIz0Hm3SzuKMVIFRzZprw4gpixImYi5YuB/zdH10rFS
         1jbVZLr/GnDJsqkVhv7K3zrkMfbaFgqLANdsd/beHWq2Kj0W3H3LWC4FqpNtqFQqMCxg
         gquVBgSpOpZqVLIM0ljjT2HvsAh8714C/KbHrcxfapW0paDmhPz4KNGOdge5iZKm+/Rl
         57rkAYGaxu6Y9uk/q7W6496ocyZbq6GBafeaey9VKWIrnfr3EXep2Oa3ZZaDksbRNPnu
         WFHFFuHc8vPaEYmxbyryooj6+REkl8SIuX9RxG6F7b5pSCUk55ML/Jbh/19vbEYWen5k
         GDqw==
X-Gm-Message-State: AO0yUKWn6/HsbdZa19zCmkrw8si4edpZsp6Lf9gAmEVbDh+hrXG0W3qw
        54dfVQyGuRiJAGoIh9GP9NgnQb3Dnpk=
X-Google-Smtp-Source: AK7set9lwmygVTrhElwNKRyRVFkTjGN/CJxbBQigJrcSU8FY/SWoZqMg5AO6hWJ8rwepN8u9uOFmXoH9ZfY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1024:b0:8fc:686c:cf87 with SMTP id
 x4-20020a056902102400b008fc686ccf87mr29473ybt.4.1676675433776; Fri, 17 Feb
 2023 15:10:33 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 17 Feb 2023 15:10:14 -0800
In-Reply-To: <20230217231022.816138-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230217231022.816138-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230217231022.816138-5-seanjc@google.com>
Subject: [PATCH 04/12] KVM: VMX: Rename XSAVES control to follow KVM's
 preferred "ENABLE_XYZ"
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/x86/kvm/vmx/hyperv.h       | 2 +-
 arch/x86/kvm/vmx/nested.c       | 6 +++---
 arch/x86/kvm/vmx/nested.h       | 2 +-
 arch/x86/kvm/vmx/vmx.c          | 2 +-
 arch/x86/kvm/vmx/vmx.h          | 2 +-
 7 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 498dc600bd5c..aeb319665502 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -69,7 +69,7 @@
 #define SECONDARY_EXEC_RDSEED_EXITING		VMCS_CONTROL_BIT(RDSEED_EXITING)
 #define SECONDARY_EXEC_ENABLE_PML               VMCS_CONTROL_BIT(PAGE_MOD_LOGGING)
 #define SECONDARY_EXEC_PT_CONCEAL_VMX		VMCS_CONTROL_BIT(PT_CONCEAL_VMX)
-#define SECONDARY_EXEC_XSAVES			VMCS_CONTROL_BIT(XSAVES)
+#define SECONDARY_EXEC_ENABLE_XSAVES		VMCS_CONTROL_BIT(XSAVES)
 #define SECONDARY_EXEC_MODE_BASED_EPT_EXEC	VMCS_CONTROL_BIT(MODE_BASED_EPT_EXEC)
 #define SECONDARY_EXEC_PT_USE_GPA		VMCS_CONTROL_BIT(PT_USE_GPA)
 #define SECONDARY_EXEC_TSC_SCALING              VMCS_CONTROL_BIT(TSC_SCALING)
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 45162c1bcd8f..3c3875b3dedd 100644
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
diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
index 78d17667e7ec..51fe0251cb67 100644
--- a/arch/x86/kvm/vmx/hyperv.h
+++ b/arch/x86/kvm/vmx/hyperv.h
@@ -87,7 +87,7 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
 	 SECONDARY_EXEC_DESC |						\
 	 SECONDARY_EXEC_ENABLE_RDTSCP |					\
 	 SECONDARY_EXEC_ENABLE_INVPCID |				\
-	 SECONDARY_EXEC_XSAVES |					\
+	 SECONDARY_EXEC_ENABLE_XSAVES |					\
 	 SECONDARY_EXEC_RDSEED_EXITING |				\
 	 SECONDARY_EXEC_RDRAND_EXITING |				\
 	 SECONDARY_EXEC_TSC_SCALING |					\
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 7c4f5ca405c7..1d19fcf02a8e 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2301,7 +2301,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 				  SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |
 				  SECONDARY_EXEC_ENABLE_INVPCID |
 				  SECONDARY_EXEC_ENABLE_RDTSCP |
-				  SECONDARY_EXEC_XSAVES |
+				  SECONDARY_EXEC_ENABLE_XSAVES |
 				  SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE |
 				  SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
 				  SECONDARY_EXEC_APIC_REGISTER_VIRT |
@@ -6321,7 +6321,7 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu,
 		 * If if it were, XSS would have to be checked against
 		 * the XSS exit bitmap in vmcs12.
 		 */
-		return nested_cpu_has2(vmcs12, SECONDARY_EXEC_XSAVES);
+		return nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENABLE_XSAVES);
 	case EXIT_REASON_UMWAIT:
 	case EXIT_REASON_TPAUSE:
 		return nested_cpu_has2(vmcs12,
@@ -6882,7 +6882,7 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
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
index b6fdb311a7d8..14ce195eee5a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4622,7 +4622,7 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
 
 	if (cpu_has_vmx_xsaves())
 		vmx_adjust_secondary_exec_control(vmx, &exec_control,
-						  SECONDARY_EXEC_XSAVES,
+						  SECONDARY_EXEC_ENABLE_XSAVES,
 						  vcpu->arch.xsaves_enabled, false);
 
 	/*
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 2acdc54bc34b..2db14e0f4081 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -574,7 +574,7 @@ static inline u8 vmx_get_rvi(void)
 	 SECONDARY_EXEC_APIC_REGISTER_VIRT |				\
 	 SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |				\
 	 SECONDARY_EXEC_SHADOW_VMCS |					\
-	 SECONDARY_EXEC_XSAVES |					\
+	 SECONDARY_EXEC_ENABLE_XSAVES |					\
 	 SECONDARY_EXEC_RDSEED_EXITING |				\
 	 SECONDARY_EXEC_RDRAND_EXITING |				\
 	 SECONDARY_EXEC_ENABLE_PML |					\
-- 
2.39.2.637.g21b0678d19-goog

