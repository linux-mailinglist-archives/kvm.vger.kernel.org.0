Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21EE568F913
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 21:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbjBHUyh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 15:54:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232297AbjBHUyf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 15:54:35 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B7513D69
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 12:54:34 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id k15-20020a17090a590f00b002300fe6b09dso1854129pji.0
        for <kvm@vger.kernel.org>; Wed, 08 Feb 2023 12:54:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=cdKjOxPhnI15TJtrp1GzE3Eb2aiZOdiZBGXaDkr9Tz0=;
        b=mEa/if5r9fK/a5hSE0OmuuZQF/MrtVdy9W6hLlGRfDAVLYsh+ZpiKYI6vHuiZIJNjk
         FOZ3aChDbfKBz4OeAyhaUDTZlffPetVi13qzSrO7LwmEo17NJIhV8Ep9ktlD6c/vSAfn
         qNjUFqdJcD3jrbuNpgMOaj0uyW/M0o2YGaFtFA5ksTlyfhcvGrxPVP6TM1NTsp8vxT5k
         TuI7xIlcTlRjw96JRaiiEIC8DS+0CY5klo3sUXWUTpHH3S/7yUCC2AjRR/slr5qReoBA
         LYvp4i+8uGN0lGsMM4BKIlVc/UnatVQMrSnr+m0HDNKu1dUIU+nPoxBQObXLFQQthL1a
         7Ycw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cdKjOxPhnI15TJtrp1GzE3Eb2aiZOdiZBGXaDkr9Tz0=;
        b=L0NgvHHk0F9J/kZovILSO67hryhkCAsIJxhz9tWTsGQbipHgF6X5QW8lzDP+GXtGIx
         ao8UgyJsihFHafH1nbfabHbgJL1UqdALOs/WPGPetInhaPhkPbSUGTA2Fqz2d78sUUy5
         y4Fe32KK31VzHgZrqLGvpGiQ97JGhEK8P6+0EYi/iDkYpuX/hkj/hYf2cImdpfzBmc+Y
         4UUeFXL8bmsI7KgasyHvJSxTLz7Kf7x4U1J1jPJgGqwtVDA6hjTI1XOVBeJdSfaNCU/6
         FTF8i3WcbJTUYWcmy6tx+YtNfZE4UgxHBmpWAM3HRwC/3K/8nNgz2FajAAtlHQhBpyGE
         Lnbw==
X-Gm-Message-State: AO0yUKW90sBu6S6k6V5BuHH/gP1SDTBMyQPXGbZGNK5ZDL6HYSD3dDmS
        QzfOf8toai+a/SLOiBGLzp2U1EYdx6Y=
X-Google-Smtp-Source: AK7set+iJJplh9nQ0JxIwsuKk80sHzde1RQA+BgkxDgas3LPxiSzxhnecQ3RpMl6VjKU7rr0Q1VPhn+BUv8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:fa8c:b0:230:f42f:99c2 with SMTP id
 cu12-20020a17090afa8c00b00230f42f99c2mr1063320pjb.32.1675889674126; Wed, 08
 Feb 2023 12:54:34 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Feb 2023 20:54:29 +0000
In-Reply-To: <20230208205430.1424667-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230208205430.1424667-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230208205430.1424667-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: nVMX: Move EVMCS1_SUPPORT_* macros to hyperv.c
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Tom Rix <trix@redhat.com>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75,USER_IN_DEF_DKIM_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the macros that define the set of VMCS controls that are supported
by eVMCS1 from hyperv.h to hyperv.c, i.e. make them "private".   The
macros should never be consumed directly by KVM at-large since the "final"
set of supported controls depends on guest CPUID.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/hyperv.c | 105 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/hyperv.h | 105 --------------------------------------
 2 files changed, 105 insertions(+), 105 deletions(-)

diff --git a/arch/x86/kvm/vmx/hyperv.c b/arch/x86/kvm/vmx/hyperv.c
index 22daca752797..b6748055c586 100644
--- a/arch/x86/kvm/vmx/hyperv.c
+++ b/arch/x86/kvm/vmx/hyperv.c
@@ -13,6 +13,111 @@
 
 #define CC KVM_NESTED_VMENTER_CONSISTENCY_CHECK
 
+/*
+ * Enlightened VMCSv1 doesn't support these:
+ *
+ *	POSTED_INTR_NV                  = 0x00000002,
+ *	GUEST_INTR_STATUS               = 0x00000810,
+ *	APIC_ACCESS_ADDR		= 0x00002014,
+ *	POSTED_INTR_DESC_ADDR           = 0x00002016,
+ *	EOI_EXIT_BITMAP0                = 0x0000201c,
+ *	EOI_EXIT_BITMAP1                = 0x0000201e,
+ *	EOI_EXIT_BITMAP2                = 0x00002020,
+ *	EOI_EXIT_BITMAP3                = 0x00002022,
+ *	GUEST_PML_INDEX			= 0x00000812,
+ *	PML_ADDRESS			= 0x0000200e,
+ *	VM_FUNCTION_CONTROL             = 0x00002018,
+ *	EPTP_LIST_ADDRESS               = 0x00002024,
+ *	VMREAD_BITMAP                   = 0x00002026,
+ *	VMWRITE_BITMAP                  = 0x00002028,
+ *
+ *	TSC_MULTIPLIER                  = 0x00002032,
+ *	PLE_GAP                         = 0x00004020,
+ *	PLE_WINDOW                      = 0x00004022,
+ *	VMX_PREEMPTION_TIMER_VALUE      = 0x0000482E,
+ *
+ * Currently unsupported in KVM:
+ *	GUEST_IA32_RTIT_CTL		= 0x00002814,
+ */
+#define EVMCS1_SUPPORTED_PINCTRL					\
+	(PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR |				\
+	 PIN_BASED_EXT_INTR_MASK |					\
+	 PIN_BASED_NMI_EXITING |					\
+	 PIN_BASED_VIRTUAL_NMIS)
+
+#define EVMCS1_SUPPORTED_EXEC_CTRL					\
+	(CPU_BASED_ALWAYSON_WITHOUT_TRUE_MSR |				\
+	 CPU_BASED_HLT_EXITING |					\
+	 CPU_BASED_CR3_LOAD_EXITING |					\
+	 CPU_BASED_CR3_STORE_EXITING |					\
+	 CPU_BASED_UNCOND_IO_EXITING |					\
+	 CPU_BASED_MOV_DR_EXITING |					\
+	 CPU_BASED_USE_TSC_OFFSETTING |					\
+	 CPU_BASED_MWAIT_EXITING |					\
+	 CPU_BASED_MONITOR_EXITING |					\
+	 CPU_BASED_INVLPG_EXITING |					\
+	 CPU_BASED_RDPMC_EXITING |					\
+	 CPU_BASED_INTR_WINDOW_EXITING |				\
+	 CPU_BASED_CR8_LOAD_EXITING |					\
+	 CPU_BASED_CR8_STORE_EXITING |					\
+	 CPU_BASED_RDTSC_EXITING |					\
+	 CPU_BASED_TPR_SHADOW |						\
+	 CPU_BASED_USE_IO_BITMAPS |					\
+	 CPU_BASED_MONITOR_TRAP_FLAG |					\
+	 CPU_BASED_USE_MSR_BITMAPS |					\
+	 CPU_BASED_NMI_WINDOW_EXITING |					\
+	 CPU_BASED_PAUSE_EXITING |					\
+	 CPU_BASED_ACTIVATE_SECONDARY_CONTROLS)
+
+#define EVMCS1_SUPPORTED_2NDEXEC					\
+	(SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |			\
+	 SECONDARY_EXEC_WBINVD_EXITING |				\
+	 SECONDARY_EXEC_ENABLE_VPID |					\
+	 SECONDARY_EXEC_ENABLE_EPT |					\
+	 SECONDARY_EXEC_UNRESTRICTED_GUEST |				\
+	 SECONDARY_EXEC_DESC |						\
+	 SECONDARY_EXEC_ENABLE_RDTSCP |					\
+	 SECONDARY_EXEC_ENABLE_INVPCID |				\
+	 SECONDARY_EXEC_XSAVES |					\
+	 SECONDARY_EXEC_RDSEED_EXITING |				\
+	 SECONDARY_EXEC_RDRAND_EXITING |				\
+	 SECONDARY_EXEC_TSC_SCALING |					\
+	 SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE |				\
+	 SECONDARY_EXEC_PT_USE_GPA |					\
+	 SECONDARY_EXEC_PT_CONCEAL_VMX |				\
+	 SECONDARY_EXEC_BUS_LOCK_DETECTION |				\
+	 SECONDARY_EXEC_NOTIFY_VM_EXITING |				\
+	 SECONDARY_EXEC_ENCLS_EXITING)
+
+#define EVMCS1_SUPPORTED_3RDEXEC (0ULL)
+
+#define EVMCS1_SUPPORTED_VMEXIT_CTRL					\
+	(VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |				\
+	 VM_EXIT_SAVE_DEBUG_CONTROLS |					\
+	 VM_EXIT_ACK_INTR_ON_EXIT |					\
+	 VM_EXIT_HOST_ADDR_SPACE_SIZE |					\
+	 VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |				\
+	 VM_EXIT_SAVE_IA32_PAT |					\
+	 VM_EXIT_LOAD_IA32_PAT |					\
+	 VM_EXIT_SAVE_IA32_EFER |					\
+	 VM_EXIT_LOAD_IA32_EFER |					\
+	 VM_EXIT_CLEAR_BNDCFGS |					\
+	 VM_EXIT_PT_CONCEAL_PIP |					\
+	 VM_EXIT_CLEAR_IA32_RTIT_CTL)
+
+#define EVMCS1_SUPPORTED_VMENTRY_CTRL					\
+	(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR |				\
+	 VM_ENTRY_LOAD_DEBUG_CONTROLS |					\
+	 VM_ENTRY_IA32E_MODE |						\
+	 VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |				\
+	 VM_ENTRY_LOAD_IA32_PAT |					\
+	 VM_ENTRY_LOAD_IA32_EFER |					\
+	 VM_ENTRY_LOAD_BNDCFGS |					\
+	 VM_ENTRY_PT_CONCEAL_PIP |					\
+	 VM_ENTRY_LOAD_IA32_RTIT_CTL)
+
+#define EVMCS1_SUPPORTED_VMFUNC (0)
+
 DEFINE_STATIC_KEY_FALSE(enable_evmcs);
 
 #define EVMCS1_OFFSET(x) offsetof(struct hv_enlightened_vmcs, x)
diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
index 78d17667e7ec..1299143d00df 100644
--- a/arch/x86/kvm/vmx/hyperv.h
+++ b/arch/x86/kvm/vmx/hyperv.h
@@ -22,111 +22,6 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
 
 #define KVM_EVMCS_VERSION 1
 
-/*
- * Enlightened VMCSv1 doesn't support these:
- *
- *	POSTED_INTR_NV                  = 0x00000002,
- *	GUEST_INTR_STATUS               = 0x00000810,
- *	APIC_ACCESS_ADDR		= 0x00002014,
- *	POSTED_INTR_DESC_ADDR           = 0x00002016,
- *	EOI_EXIT_BITMAP0                = 0x0000201c,
- *	EOI_EXIT_BITMAP1                = 0x0000201e,
- *	EOI_EXIT_BITMAP2                = 0x00002020,
- *	EOI_EXIT_BITMAP3                = 0x00002022,
- *	GUEST_PML_INDEX			= 0x00000812,
- *	PML_ADDRESS			= 0x0000200e,
- *	VM_FUNCTION_CONTROL             = 0x00002018,
- *	EPTP_LIST_ADDRESS               = 0x00002024,
- *	VMREAD_BITMAP                   = 0x00002026,
- *	VMWRITE_BITMAP                  = 0x00002028,
- *
- *	TSC_MULTIPLIER                  = 0x00002032,
- *	PLE_GAP                         = 0x00004020,
- *	PLE_WINDOW                      = 0x00004022,
- *	VMX_PREEMPTION_TIMER_VALUE      = 0x0000482E,
- *
- * Currently unsupported in KVM:
- *	GUEST_IA32_RTIT_CTL		= 0x00002814,
- */
-#define EVMCS1_SUPPORTED_PINCTRL					\
-	(PIN_BASED_ALWAYSON_WITHOUT_TRUE_MSR |				\
-	 PIN_BASED_EXT_INTR_MASK |					\
-	 PIN_BASED_NMI_EXITING |					\
-	 PIN_BASED_VIRTUAL_NMIS)
-
-#define EVMCS1_SUPPORTED_EXEC_CTRL					\
-	(CPU_BASED_ALWAYSON_WITHOUT_TRUE_MSR |				\
-	 CPU_BASED_HLT_EXITING |					\
-	 CPU_BASED_CR3_LOAD_EXITING |					\
-	 CPU_BASED_CR3_STORE_EXITING |					\
-	 CPU_BASED_UNCOND_IO_EXITING |					\
-	 CPU_BASED_MOV_DR_EXITING |					\
-	 CPU_BASED_USE_TSC_OFFSETTING |					\
-	 CPU_BASED_MWAIT_EXITING |					\
-	 CPU_BASED_MONITOR_EXITING |					\
-	 CPU_BASED_INVLPG_EXITING |					\
-	 CPU_BASED_RDPMC_EXITING |					\
-	 CPU_BASED_INTR_WINDOW_EXITING |				\
-	 CPU_BASED_CR8_LOAD_EXITING |					\
-	 CPU_BASED_CR8_STORE_EXITING |					\
-	 CPU_BASED_RDTSC_EXITING |					\
-	 CPU_BASED_TPR_SHADOW |						\
-	 CPU_BASED_USE_IO_BITMAPS |					\
-	 CPU_BASED_MONITOR_TRAP_FLAG |					\
-	 CPU_BASED_USE_MSR_BITMAPS |					\
-	 CPU_BASED_NMI_WINDOW_EXITING |					\
-	 CPU_BASED_PAUSE_EXITING |					\
-	 CPU_BASED_ACTIVATE_SECONDARY_CONTROLS)
-
-#define EVMCS1_SUPPORTED_2NDEXEC					\
-	(SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |			\
-	 SECONDARY_EXEC_WBINVD_EXITING |				\
-	 SECONDARY_EXEC_ENABLE_VPID |					\
-	 SECONDARY_EXEC_ENABLE_EPT |					\
-	 SECONDARY_EXEC_UNRESTRICTED_GUEST |				\
-	 SECONDARY_EXEC_DESC |						\
-	 SECONDARY_EXEC_ENABLE_RDTSCP |					\
-	 SECONDARY_EXEC_ENABLE_INVPCID |				\
-	 SECONDARY_EXEC_XSAVES |					\
-	 SECONDARY_EXEC_RDSEED_EXITING |				\
-	 SECONDARY_EXEC_RDRAND_EXITING |				\
-	 SECONDARY_EXEC_TSC_SCALING |					\
-	 SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE |				\
-	 SECONDARY_EXEC_PT_USE_GPA |					\
-	 SECONDARY_EXEC_PT_CONCEAL_VMX |				\
-	 SECONDARY_EXEC_BUS_LOCK_DETECTION |				\
-	 SECONDARY_EXEC_NOTIFY_VM_EXITING |				\
-	 SECONDARY_EXEC_ENCLS_EXITING)
-
-#define EVMCS1_SUPPORTED_3RDEXEC (0ULL)
-
-#define EVMCS1_SUPPORTED_VMEXIT_CTRL					\
-	(VM_EXIT_ALWAYSON_WITHOUT_TRUE_MSR |				\
-	 VM_EXIT_SAVE_DEBUG_CONTROLS |					\
-	 VM_EXIT_ACK_INTR_ON_EXIT |					\
-	 VM_EXIT_HOST_ADDR_SPACE_SIZE |					\
-	 VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |				\
-	 VM_EXIT_SAVE_IA32_PAT |					\
-	 VM_EXIT_LOAD_IA32_PAT |					\
-	 VM_EXIT_SAVE_IA32_EFER |					\
-	 VM_EXIT_LOAD_IA32_EFER |					\
-	 VM_EXIT_CLEAR_BNDCFGS |					\
-	 VM_EXIT_PT_CONCEAL_PIP |					\
-	 VM_EXIT_CLEAR_IA32_RTIT_CTL)
-
-#define EVMCS1_SUPPORTED_VMENTRY_CTRL					\
-	(VM_ENTRY_ALWAYSON_WITHOUT_TRUE_MSR |				\
-	 VM_ENTRY_LOAD_DEBUG_CONTROLS |					\
-	 VM_ENTRY_IA32E_MODE |						\
-	 VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |				\
-	 VM_ENTRY_LOAD_IA32_PAT |					\
-	 VM_ENTRY_LOAD_IA32_EFER |					\
-	 VM_ENTRY_LOAD_BNDCFGS |					\
-	 VM_ENTRY_PT_CONCEAL_PIP |					\
-	 VM_ENTRY_LOAD_IA32_RTIT_CTL)
-
-#define EVMCS1_SUPPORTED_VMFUNC (0)
-
 struct evmcs_field {
 	u16 offset;
 	u16 clean_field;
-- 
2.39.1.519.gcb327c4b5f-goog

