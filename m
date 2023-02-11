Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A22E7692C1B
	for <lists+kvm@lfdr.de>; Sat, 11 Feb 2023 01:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjBKAfo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 19:35:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjBKAfl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 19:35:41 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A841ADC5
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 16:35:40 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 191-20020a2504c8000000b008e2fd9e34e6so4827188ybe.9
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 16:35:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0uuK9iAHmKUf8EJlnN50jouQ/uuHchMNZ+3f1j53sII=;
        b=QxBKjkpCGXwRCwoLPjUTR05BSE0y6a8k47q1fMfB/sVkrbYcRAKFAKGB+MbKZWKByo
         EwGDTJhiXV6XuAvFgjOgZUUxVL0Q35NXtVt48pnZE9UrqZwCIpm0tKfI3rmZwqmmFeva
         zb8dmIYbuYbpzl+r6gD3eA+T8Mu+MlUDCs+TfJE7c2d9qsKMUvVDk9OHEOw+qBfkRaVs
         hBRJnW51p/nQ/RC9Ih7pzFXY/P048q3cpOdIDIxVKEQeqGWLtjls+IWKhxKvzzbvdRDu
         hw7xMhj+wj7ZwSr4jlzzqUugXmkYTKSo84Nk00UoDaUET2uBiKFJWvSA0+UcKtK6Cy9I
         2Qxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0uuK9iAHmKUf8EJlnN50jouQ/uuHchMNZ+3f1j53sII=;
        b=QitmUaGCtBbzS+Guo+AGfOGhDojhLhK2H1fyGkDCjmh9BFo32/uqcCYmLo7kNKdRJt
         uwVmR+wqcfuo+4YFZthJ0SGVUJB+Uo0rnnbyhhHpUP3rREJbQhCnEVecM/8SjRjvcoqg
         PemWrR8Ur28pBLcJFHQo9IuRdPEIW3b/wM6nLXpHYLTRUtB8KgyDzv+ubLba7f1PTw36
         WjMS6kLv93LpGFmgcuiJqJKA5+KgO9k+AaJ+laFwj1tJgAeAXNaatJRt4Ps4lNAa9M+j
         +UqMSiDNJBojZ84ahVB+jg+2T0v15YepaQV0OoqtC0PDi7wUp8+2UPP44M4noCLPzbKI
         HBkw==
X-Gm-Message-State: AO0yUKWABKxVO8VTpXRa+GXgYNYzU6ep0kgvagN2evhkRGQOPzMkZfnd
        i96VwZrPWpscXJnbsUc7HIUlFKSfBUo=
X-Google-Smtp-Source: AK7set/GsgXKoufMCXrj5K6QaDN5lnBvviCVf9uSPHpPH/2kmoUGKbpDYxgzuCfeG04XfNtQ5rrR5yzEaEQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:dc3:0:b0:87d:6d83:21a6 with SMTP id
 t3-20020a5b0dc3000000b0087d6d8321a6mr1760553ybr.126.1676075739272; Fri, 10
 Feb 2023 16:35:39 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 11 Feb 2023 00:35:32 +0000
In-Reply-To: <20230211003534.564198-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230211003534.564198-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230211003534.564198-2-seanjc@google.com>
Subject: [PATCH v2 1/3] KVM: nVMX: Move EVMCS1_SUPPORT_* macros to hyperv.c
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
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
2.39.1.581.gbfd45094c4-goog

