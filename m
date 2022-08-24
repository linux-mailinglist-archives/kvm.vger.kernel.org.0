Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 971D059F1C2
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234591AbiHXDEi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234451AbiHXDDr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:03:47 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3A582874
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:25 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-33d9f6f4656so24360547b3.21
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=A2Qe07HLSt0YnMAEbCCGW/epEtWrezK3js7eF+iYjWI=;
        b=BphdX7/sIhuq3JYx/VNDnV2w868AcG9njRvNUJg8uIvQtl9qdjn/qrgzK2KJcrkqSm
         PnVJZDMLtLrKTZ1hHsKWPT72H4/Bg0IYHjd4W6/clK0e9g8kkDtt8d9I3Lmt0gmeZJPw
         4oxQGtyifKS71v9zTOz3t1vxeStYM7U4gyyLkkM7WXKREMypl1m3A+B24QPrIoaO65sY
         cIIZJpC3Gbz4MhAS0gn825xuZQKFc1+Rm3hCv97zpOWAXcq5cjXCU/2P3gAYGpk/xERH
         oo3ym0DrE8wTZzyDP1818HWrd2zxXnIl3L6G/zSZEY6QBP9fXoVBFYlkU37qaK+vMg+9
         wmJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=A2Qe07HLSt0YnMAEbCCGW/epEtWrezK3js7eF+iYjWI=;
        b=w4VFk6eRSNfGdVLnJMNKXuIhty+LfK4fTW4OCZOmqX9Vnp8lIhGHXgB9AShGzcqEOa
         PI8r1DMX/3Yp27DjW3GVPlTDWQNL85RbNJ9eIWx4S+I5mLlzgvthpX5cPXi1ynqFAkNQ
         7x79xvM08kdM/XFvETMdr15Gt8Cqe5w5aI+5eFWyjrGf3CDuesaPVJ09fgpEDrIOTHf4
         TL9qAX6IF4qRyc8YdeA9B+NMvF6KA6LPg0qLisZEr1+q5AT0C+dnssUf74hQfUBdTp/U
         Zwk+UhFXS9c6AFjhAzxdAzP4j7T4dRmTbc15O8j7X7HtODC7ux7Im330pBZ0tFl2Pa8z
         hwsg==
X-Gm-Message-State: ACgBeo1G1udDeIGNt+2c1bvOk+EgE3xfCQvYozL4a+eFI4sLQ+Rk7FeK
        ozXYCqAIMhDZIFab/SCi73O/eB90fRU=
X-Google-Smtp-Source: AA6agR7Z7cmUFjOh7Uti662m8wf5i+kSHhzLlsPtFo6j8xOz57z9zs6LTtJbvvEhDCMn8SNt2CR2wVkOZeQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d855:0:b0:336:ad56:7bf8 with SMTP id
 a82-20020a0dd855000000b00336ad567bf8mr28404061ywe.403.1661310144448; Tue, 23
 Aug 2022 20:02:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:28 +0000
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
Message-Id: <20220824030138.3524159-27-seanjc@google.com>
Mime-Version: 1.0
References: <20220824030138.3524159-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 26/36] KVM: VMX: Extend VMX controls macro shenanigans
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75,
        USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

When VMX controls macros are used to set or clear a control bit, make
sure that this bit was checked in setup_vmcs_config() and thus is properly
reflected in vmcs_config.

Opportunistically drop pointless "< 0" check for adjust_vmx_controls()'s
return value.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 112 +++++++----------------------
 arch/x86/kvm/vmx/vmx.h | 155 +++++++++++++++++++++++++++++++++++------
 2 files changed, 156 insertions(+), 111 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cbb88d1fd55d..5f5e48d0dbcb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -864,7 +864,7 @@ unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx)
 	return flags;
 }
 
-static void clear_atomic_switch_msr_special(struct vcpu_vmx *vmx,
+static __always_inline void clear_atomic_switch_msr_special(struct vcpu_vmx *vmx,
 		unsigned long entry, unsigned long exit)
 {
 	vm_entry_controls_clearbit(vmx, entry);
@@ -922,7 +922,7 @@ static void clear_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr)
 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, m->host.nr);
 }
 
-static void add_atomic_switch_msr_special(struct vcpu_vmx *vmx,
+static __always_inline void add_atomic_switch_msr_special(struct vcpu_vmx *vmx,
 		unsigned long entry, unsigned long exit,
 		unsigned long guest_val_vmcs, unsigned long host_val_vmcs,
 		u64 guest_val, u64 host_val)
@@ -2521,7 +2521,6 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 				    struct vmx_capability *vmx_cap)
 {
 	u32 vmx_msr_low, vmx_msr_high;
-	u32 min, opt, min2, opt2;
 	u32 _pin_based_exec_control = 0;
 	u32 _cpu_based_exec_control = 0;
 	u32 _cpu_based_2nd_exec_control = 0;
@@ -2547,29 +2546,11 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	};
 
 	memset(vmcs_conf, 0, sizeof(*vmcs_conf));
-	min = CPU_BASED_HLT_EXITING |
-#ifdef CONFIG_X86_64
-	      CPU_BASED_CR8_LOAD_EXITING |
-	      CPU_BASED_CR8_STORE_EXITING |
-#endif
-	      CPU_BASED_CR3_LOAD_EXITING |
-	      CPU_BASED_CR3_STORE_EXITING |
-	      CPU_BASED_UNCOND_IO_EXITING |
-	      CPU_BASED_MOV_DR_EXITING |
-	      CPU_BASED_USE_TSC_OFFSETTING |
-	      CPU_BASED_MWAIT_EXITING |
-	      CPU_BASED_MONITOR_EXITING |
-	      CPU_BASED_INVLPG_EXITING |
-	      CPU_BASED_RDPMC_EXITING |
-	      CPU_BASED_INTR_WINDOW_EXITING;
 
-	opt = CPU_BASED_TPR_SHADOW |
-	      CPU_BASED_USE_MSR_BITMAPS |
-	      CPU_BASED_NMI_WINDOW_EXITING |
-	      CPU_BASED_ACTIVATE_SECONDARY_CONTROLS |
-	      CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
-	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_PROCBASED_CTLS,
-				&_cpu_based_exec_control) < 0)
+	if (adjust_vmx_controls(KVM_REQUIRED_VMX_CPU_BASED_VM_EXEC_CONTROL,
+				KVM_OPTIONAL_VMX_CPU_BASED_VM_EXEC_CONTROL,
+				MSR_IA32_VMX_PROCBASED_CTLS,
+				&_cpu_based_exec_control))
 		return -EIO;
 #ifdef CONFIG_X86_64
 	if (_cpu_based_exec_control & CPU_BASED_TPR_SHADOW)
@@ -2577,36 +2558,10 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 					   ~CPU_BASED_CR8_STORE_EXITING;
 #endif
 	if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_SECONDARY_CONTROLS) {
-		min2 = 0;
-		opt2 = SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
-			SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |
-			SECONDARY_EXEC_WBINVD_EXITING |
-			SECONDARY_EXEC_ENABLE_VPID |
-			SECONDARY_EXEC_ENABLE_EPT |
-			SECONDARY_EXEC_UNRESTRICTED_GUEST |
-			SECONDARY_EXEC_PAUSE_LOOP_EXITING |
-			SECONDARY_EXEC_DESC |
-			SECONDARY_EXEC_ENABLE_RDTSCP |
-			SECONDARY_EXEC_ENABLE_INVPCID |
-			SECONDARY_EXEC_APIC_REGISTER_VIRT |
-			SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
-			SECONDARY_EXEC_SHADOW_VMCS |
-			SECONDARY_EXEC_XSAVES |
-			SECONDARY_EXEC_RDSEED_EXITING |
-			SECONDARY_EXEC_RDRAND_EXITING |
-			SECONDARY_EXEC_ENABLE_PML |
-			SECONDARY_EXEC_TSC_SCALING |
-			SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE |
-			SECONDARY_EXEC_PT_USE_GPA |
-			SECONDARY_EXEC_PT_CONCEAL_VMX |
-			SECONDARY_EXEC_ENABLE_VMFUNC |
-			SECONDARY_EXEC_BUS_LOCK_DETECTION |
-			SECONDARY_EXEC_NOTIFY_VM_EXITING |
-			SECONDARY_EXEC_ENCLS_EXITING;
-
-		if (adjust_vmx_controls(min2, opt2,
+		if (adjust_vmx_controls(KVM_REQUIRED_VMX_SECONDARY_VM_EXEC_CONTROL,
+					KVM_OPTIONAL_VMX_SECONDARY_VM_EXEC_CONTROL,
 					MSR_IA32_VMX_PROCBASED_CTLS2,
-					&_cpu_based_2nd_exec_control) < 0)
+					&_cpu_based_2nd_exec_control))
 			return -EIO;
 	}
 #ifndef CONFIG_X86_64
@@ -2653,32 +2608,21 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 	if (!cpu_has_sgx())
 		_cpu_based_2nd_exec_control &= ~SECONDARY_EXEC_ENCLS_EXITING;
 
-	if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS) {
-		u64 opt3 = TERTIARY_EXEC_IPI_VIRT;
-
-		_cpu_based_3rd_exec_control = adjust_vmx_controls64(opt3,
+	if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS)
+		_cpu_based_3rd_exec_control =
+			adjust_vmx_controls64(KVM_OPTIONAL_VMX_TERTIARY_VM_EXEC_CONTROL,
 					      MSR_IA32_VMX_PROCBASED_CTLS3);
-	}
 
-	min = VM_EXIT_SAVE_DEBUG_CONTROLS | VM_EXIT_ACK_INTR_ON_EXIT;
-#ifdef CONFIG_X86_64
-	min |= VM_EXIT_HOST_ADDR_SPACE_SIZE;
-#endif
-	opt = VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |
-	      VM_EXIT_LOAD_IA32_PAT |
-	      VM_EXIT_LOAD_IA32_EFER |
-	      VM_EXIT_CLEAR_BNDCFGS |
-	      VM_EXIT_PT_CONCEAL_PIP |
-	      VM_EXIT_CLEAR_IA32_RTIT_CTL;
-	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_EXIT_CTLS,
-				&_vmexit_control) < 0)
+	if (adjust_vmx_controls(KVM_REQUIRED_VMX_VM_EXIT_CONTROLS,
+				KVM_OPTIONAL_VMX_VM_EXIT_CONTROLS,
+				MSR_IA32_VMX_EXIT_CTLS,
+				&_vmexit_control))
 		return -EIO;
 
-	min = PIN_BASED_EXT_INTR_MASK | PIN_BASED_NMI_EXITING;
-	opt = PIN_BASED_VIRTUAL_NMIS | PIN_BASED_POSTED_INTR |
-		 PIN_BASED_VMX_PREEMPTION_TIMER;
-	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_PINBASED_CTLS,
-				&_pin_based_exec_control) < 0)
+	if (adjust_vmx_controls(KVM_REQUIRED_VMX_PIN_BASED_VM_EXEC_CONTROL,
+				KVM_OPTIONAL_VMX_PIN_BASED_VM_EXEC_CONTROL,
+				MSR_IA32_VMX_PINBASED_CTLS,
+				&_pin_based_exec_control))
 		return -EIO;
 
 	if (cpu_has_broken_vmx_preemption_timer())
@@ -2687,18 +2631,10 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 		SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY))
 		_pin_based_exec_control &= ~PIN_BASED_POSTED_INTR;
 
-	min = VM_ENTRY_LOAD_DEBUG_CONTROLS;
-#ifdef CONFIG_X86_64
-	min |= VM_ENTRY_IA32E_MODE;
-#endif
-	opt = VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |
-	      VM_ENTRY_LOAD_IA32_PAT |
-	      VM_ENTRY_LOAD_IA32_EFER |
-	      VM_ENTRY_LOAD_BNDCFGS |
-	      VM_ENTRY_PT_CONCEAL_PIP |
-	      VM_ENTRY_LOAD_IA32_RTIT_CTL;
-	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_ENTRY_CTLS,
-				&_vmentry_control) < 0)
+	if (adjust_vmx_controls(KVM_REQUIRED_VMX_VM_ENTRY_CONTROLS,
+				KVM_OPTIONAL_VMX_VM_ENTRY_CONTROLS,
+				MSR_IA32_VMX_ENTRY_CTLS,
+				&_vmentry_control))
 		return -EIO;
 
 	for (i = 0; i < ARRAY_SIZE(vmcs_entry_exit_pairs); i++) {
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index a7a05b5e41d2..3cfacf04be09 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -479,29 +479,138 @@ static inline u8 vmx_get_rvi(void)
 	return vmcs_read16(GUEST_INTR_STATUS) & 0xff;
 }
 
-#define BUILD_CONTROLS_SHADOW(lname, uname, bits)				\
-static inline void lname##_controls_set(struct vcpu_vmx *vmx, u##bits val)	\
-{										\
-	if (vmx->loaded_vmcs->controls_shadow.lname != val) {			\
-		vmcs_write##bits(uname, val);					\
-		vmx->loaded_vmcs->controls_shadow.lname = val;			\
-	}									\
-}										\
-static inline u##bits __##lname##_controls_get(struct loaded_vmcs *vmcs)	\
-{										\
-	return vmcs->controls_shadow.lname;					\
-}										\
-static inline u##bits lname##_controls_get(struct vcpu_vmx *vmx)		\
-{										\
-	return __##lname##_controls_get(vmx->loaded_vmcs);			\
-}										\
-static inline void lname##_controls_setbit(struct vcpu_vmx *vmx, u##bits val)	\
-{										\
-	lname##_controls_set(vmx, lname##_controls_get(vmx) | val);		\
-}										\
-static inline void lname##_controls_clearbit(struct vcpu_vmx *vmx, u##bits val)	\
-{										\
-	lname##_controls_set(vmx, lname##_controls_get(vmx) & ~val);		\
+#define __KVM_REQUIRED_VMX_VM_ENTRY_CONTROLS				\
+	(VM_ENTRY_LOAD_DEBUG_CONTROLS)
+#ifdef CONFIG_X86_64
+	#define KVM_REQUIRED_VMX_VM_ENTRY_CONTROLS			\
+		(__KVM_REQUIRED_VMX_VM_ENTRY_CONTROLS |			\
+		 VM_ENTRY_IA32E_MODE)
+#else
+	#define KVM_REQUIRED_VMX_VM_ENTRY_CONTROLS			\
+		__KVM_REQUIRED_VMX_VM_ENTRY_CONTROLS
+#endif
+#define KVM_OPTIONAL_VMX_VM_ENTRY_CONTROLS				\
+	(VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL |				\
+	 VM_ENTRY_LOAD_IA32_PAT |					\
+	 VM_ENTRY_LOAD_IA32_EFER |					\
+	 VM_ENTRY_LOAD_BNDCFGS |					\
+	 VM_ENTRY_PT_CONCEAL_PIP |					\
+	 VM_ENTRY_LOAD_IA32_RTIT_CTL)
+
+#define __KVM_REQUIRED_VMX_VM_EXIT_CONTROLS				\
+	(VM_EXIT_SAVE_DEBUG_CONTROLS |					\
+	 VM_EXIT_ACK_INTR_ON_EXIT)
+#ifdef CONFIG_X86_64
+	#define KVM_REQUIRED_VMX_VM_EXIT_CONTROLS			\
+		(__KVM_REQUIRED_VMX_VM_EXIT_CONTROLS |			\
+		 VM_EXIT_HOST_ADDR_SPACE_SIZE)
+#else
+	#define KVM_REQUIRED_VMX_VM_EXIT_CONTROLS			\
+		__KVM_REQUIRED_VMX_VM_EXIT_CONTROLS
+#endif
+#define KVM_OPTIONAL_VMX_VM_EXIT_CONTROLS				\
+	      (VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |			\
+	       VM_EXIT_LOAD_IA32_PAT |					\
+	       VM_EXIT_LOAD_IA32_EFER |					\
+	       VM_EXIT_CLEAR_BNDCFGS |					\
+	       VM_EXIT_PT_CONCEAL_PIP |					\
+	       VM_EXIT_CLEAR_IA32_RTIT_CTL)
+
+#define KVM_REQUIRED_VMX_PIN_BASED_VM_EXEC_CONTROL			\
+	(PIN_BASED_EXT_INTR_MASK |					\
+	 PIN_BASED_NMI_EXITING)
+#define KVM_OPTIONAL_VMX_PIN_BASED_VM_EXEC_CONTROL			\
+	(PIN_BASED_VIRTUAL_NMIS |					\
+	 PIN_BASED_POSTED_INTR |					\
+	 PIN_BASED_VMX_PREEMPTION_TIMER)
+
+#define __KVM_REQUIRED_VMX_CPU_BASED_VM_EXEC_CONTROL			\
+	(CPU_BASED_HLT_EXITING |					\
+	 CPU_BASED_CR3_LOAD_EXITING |					\
+	 CPU_BASED_CR3_STORE_EXITING |					\
+	 CPU_BASED_UNCOND_IO_EXITING |					\
+	 CPU_BASED_MOV_DR_EXITING |					\
+	 CPU_BASED_USE_TSC_OFFSETTING |					\
+	 CPU_BASED_MWAIT_EXITING |					\
+	 CPU_BASED_MONITOR_EXITING |					\
+	 CPU_BASED_INVLPG_EXITING |					\
+	 CPU_BASED_RDPMC_EXITING |					\
+	 CPU_BASED_INTR_WINDOW_EXITING)
+
+#ifdef CONFIG_X86_64
+	#define KVM_REQUIRED_VMX_CPU_BASED_VM_EXEC_CONTROL		\
+		(__KVM_REQUIRED_VMX_CPU_BASED_VM_EXEC_CONTROL |		\
+		 CPU_BASED_CR8_LOAD_EXITING |				\
+		 CPU_BASED_CR8_STORE_EXITING)
+#else
+	#define KVM_REQUIRED_VMX_CPU_BASED_VM_EXEC_CONTROL		\
+		__KVM_REQUIRED_VMX_CPU_BASED_VM_EXEC_CONTROL
+#endif
+
+#define KVM_OPTIONAL_VMX_CPU_BASED_VM_EXEC_CONTROL			\
+	(CPU_BASED_TPR_SHADOW |						\
+	 CPU_BASED_USE_MSR_BITMAPS |					\
+	 CPU_BASED_NMI_WINDOW_EXITING |					\
+	 CPU_BASED_ACTIVATE_SECONDARY_CONTROLS |			\
+	 CPU_BASED_ACTIVATE_TERTIARY_CONTROLS)
+
+#define KVM_REQUIRED_VMX_SECONDARY_VM_EXEC_CONTROL 0
+#define KVM_OPTIONAL_VMX_SECONDARY_VM_EXEC_CONTROL			\
+	(SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |			\
+	 SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |			\
+	 SECONDARY_EXEC_WBINVD_EXITING |				\
+	 SECONDARY_EXEC_ENABLE_VPID |					\
+	 SECONDARY_EXEC_ENABLE_EPT |					\
+	 SECONDARY_EXEC_UNRESTRICTED_GUEST |				\
+	 SECONDARY_EXEC_PAUSE_LOOP_EXITING |				\
+	 SECONDARY_EXEC_DESC |						\
+	 SECONDARY_EXEC_ENABLE_RDTSCP |					\
+	 SECONDARY_EXEC_ENABLE_INVPCID |				\
+	 SECONDARY_EXEC_APIC_REGISTER_VIRT |				\
+	 SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |				\
+	 SECONDARY_EXEC_SHADOW_VMCS |					\
+	 SECONDARY_EXEC_XSAVES |					\
+	 SECONDARY_EXEC_RDSEED_EXITING |				\
+	 SECONDARY_EXEC_RDRAND_EXITING |				\
+	 SECONDARY_EXEC_ENABLE_PML |					\
+	 SECONDARY_EXEC_TSC_SCALING |					\
+	 SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE |				\
+	 SECONDARY_EXEC_PT_USE_GPA |					\
+	 SECONDARY_EXEC_PT_CONCEAL_VMX |				\
+	 SECONDARY_EXEC_ENABLE_VMFUNC |					\
+	 SECONDARY_EXEC_BUS_LOCK_DETECTION |				\
+	 SECONDARY_EXEC_NOTIFY_VM_EXITING |				\
+	 SECONDARY_EXEC_ENCLS_EXITING)
+
+#define KVM_REQUIRED_VMX_TERTIARY_VM_EXEC_CONTROL 0
+#define KVM_OPTIONAL_VMX_TERTIARY_VM_EXEC_CONTROL			\
+	(TERTIARY_EXEC_IPI_VIRT)
+
+#define BUILD_CONTROLS_SHADOW(lname, uname, bits)						\
+static inline void lname##_controls_set(struct vcpu_vmx *vmx, u##bits val)			\
+{												\
+	if (vmx->loaded_vmcs->controls_shadow.lname != val) {					\
+		vmcs_write##bits(uname, val);							\
+		vmx->loaded_vmcs->controls_shadow.lname = val;					\
+	}											\
+}												\
+static inline u##bits __##lname##_controls_get(struct loaded_vmcs *vmcs)			\
+{												\
+	return vmcs->controls_shadow.lname;							\
+}												\
+static inline u##bits lname##_controls_get(struct vcpu_vmx *vmx)				\
+{												\
+	return __##lname##_controls_get(vmx->loaded_vmcs);					\
+}												\
+static __always_inline void lname##_controls_setbit(struct vcpu_vmx *vmx, u##bits val)		\
+{												\
+	BUILD_BUG_ON(!(val & (KVM_REQUIRED_VMX_##uname | KVM_OPTIONAL_VMX_##uname)));		\
+	lname##_controls_set(vmx, lname##_controls_get(vmx) | val);				\
+}												\
+static __always_inline void lname##_controls_clearbit(struct vcpu_vmx *vmx, u##bits val)	\
+{												\
+	BUILD_BUG_ON(!(val & (KVM_REQUIRED_VMX_##uname | KVM_OPTIONAL_VMX_##uname)));		\
+	lname##_controls_set(vmx, lname##_controls_get(vmx) & ~val);				\
 }
 BUILD_CONTROLS_SHADOW(vm_entry, VM_ENTRY_CONTROLS, 32)
 BUILD_CONTROLS_SHADOW(vm_exit, VM_EXIT_CONTROLS, 32)
-- 
2.37.1.595.g718a3a8f04-goog

