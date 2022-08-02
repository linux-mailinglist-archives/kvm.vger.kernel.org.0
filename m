Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCE09587FE1
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 18:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237826AbiHBQKc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 12:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237757AbiHBQKJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 12:10:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9FB7A48C82
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 09:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659456529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0wJBYlwZRYru9+TsRUkiomy796uTXF4DVLc7OZKmmVY=;
        b=WADB9PkwVU654S3Yz1G8DFfaAe0WUVlnPJIsG/rK9sSKnB0p6HIJyDFgFWgffn9P/+Bfy9
        jWhlqVGB5wmvlIVFAGzCgRk+A1rx227GpMYaMrI5Dj30S0AKHBcQ06SqYgq0LfhbKhdOZD
        E7O4K4AFxwChB6q5H8vtJKQgV7LPwEA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-qQf3nhShM_6tgigiBDwybA-1; Tue, 02 Aug 2022 12:08:46 -0400
X-MC-Unique: qQf3nhShM_6tgigiBDwybA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0792185A58F;
        Tue,  2 Aug 2022 16:08:46 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 872F92166B2B;
        Tue,  2 Aug 2022 16:08:43 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 16/26] KVM: VMX: Extend VMX controls macro shenanigans
Date:   Tue,  2 Aug 2022 18:07:46 +0200
Message-Id: <20220802160756.339464-17-vkuznets@redhat.com>
In-Reply-To: <20220802160756.339464-1-vkuznets@redhat.com>
References: <20220802160756.339464-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,UPPERCASE_50_75 autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When VMX controls macros are used to set or clear a control bit, make
sure that this bit was checked in setup_vmcs_config() and thus is properly
reflected in vmcs_config.

Opportunistically drop pointless "< 0" check for adjust_vmx_controls()'s
return value.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 114 +++++++-----------------------
 arch/x86/kvm/vmx/vmx.h | 155 +++++++++++++++++++++++++++++++++++------
 2 files changed, 157 insertions(+), 112 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f5217ba9269c..75cadb371fbb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -865,7 +865,7 @@ unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx)
 	return flags;
 }
 
-static void clear_atomic_switch_msr_special(struct vcpu_vmx *vmx,
+static __always_inline void clear_atomic_switch_msr_special(struct vcpu_vmx *vmx,
 		unsigned long entry, unsigned long exit)
 {
 	vm_entry_controls_clearbit(vmx, entry);
@@ -923,7 +923,7 @@ static void clear_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr)
 	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, m->host.nr);
 }
 
-static void add_atomic_switch_msr_special(struct vcpu_vmx *vmx,
+static __always_inline void add_atomic_switch_msr_special(struct vcpu_vmx *vmx,
 		unsigned long entry, unsigned long exit,
 		unsigned long guest_val_vmcs, unsigned long host_val_vmcs,
 		u64 guest_val, u64 host_val)
@@ -2527,7 +2527,6 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 				    struct vmx_capability *vmx_cap)
 {
 	u32 vmx_msr_low, vmx_msr_high;
-	u32 min, opt, min2, opt2;
 	u32 _pin_based_exec_control = 0;
 	u32 _cpu_based_exec_control = 0;
 	u32 _cpu_based_2nd_exec_control = 0;
@@ -2553,29 +2552,11 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
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
-
-	opt = CPU_BASED_TPR_SHADOW |
-	      CPU_BASED_USE_MSR_BITMAPS |
-	      CPU_BASED_NMI_WINDOW_EXITING |
-	      CPU_BASED_ACTIVATE_SECONDARY_CONTROLS |
-	      CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
-	if (adjust_vmx_controls(min, opt, MSR_IA32_VMX_PROCBASED_CTLS,
-				&_cpu_based_exec_control) < 0)
+
+	if (adjust_vmx_controls(KVM_REQUIRED_VMX_CPU_BASED_VM_EXEC_CONTROL,
+				KVM_OPTIONAL_VMX_CPU_BASED_VM_EXEC_CONTROL,
+				MSR_IA32_VMX_PROCBASED_CTLS,
+				&_cpu_based_exec_control))
 		return -EIO;
 #ifdef CONFIG_X86_64
 	if (_cpu_based_exec_control & CPU_BASED_TPR_SHADOW)
@@ -2583,36 +2564,10 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
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
@@ -2659,32 +2614,21 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
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
@@ -2693,18 +2637,10 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
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
index fb8e3480a9d7..8dd942aeaa4a 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -485,29 +485,138 @@ static inline u8 vmx_get_rvi(void)
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
2.35.3

