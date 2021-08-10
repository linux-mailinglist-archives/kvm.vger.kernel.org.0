Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D12A3E7E1C
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 19:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbhHJRUd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 13:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhHJRU3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 13:20:29 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1EEFC0613C1
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 10:20:06 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id p71-20020a25424a0000b029056092741626so21507912yba.19
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 10:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=+FdPtt1gIyWdtJwR96FojqIZZO8xBKxmUJW/dW0jey0=;
        b=auC2nZcEpNop+elKZgkGnBCjO3Oi6Sq/LnrUKFFAXa/5kBJuF5+Jd39KQLPVkQ+X8O
         4ovf84y3FfD2bqZfrL9/otvnAUA5dJrJVP8IhTlt9Skxb6anrOEXGp3zlQ+sVd+kIDA3
         piWPx5uzlc7DabEqUccNIhK1LEPNHMyS9uzeeq4LveduoWP6JDzhAg7dOrRSy055v8PX
         cHdWXHvShIHLLGiNK/CwbK4BKR234cETr52ZH3qhhr8DCUpAoAuW8y6VU079lK2K+VwM
         dvg6XnkUamOtc7VkX2YAupa7SNvKTTGXVYf45qJr1LW7pZKAu1mslTGCekN5OgBpeBSq
         NVpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=+FdPtt1gIyWdtJwR96FojqIZZO8xBKxmUJW/dW0jey0=;
        b=QDkWZX8UMdNWArJXbhOU2ruRdZE/iwIW8J3l1I0hvGYrvcfTd+TxxR+s7YUayDRhkr
         lk1eqOQCnooOu375kSGbWm2/wAzLLa9fYCzqktY5dF0z7YN9vLKmlR0JWfQF0X1G48lo
         gwWk5I0eCSY/dgjm49yHchgY6thoP9Li92UF/akmOFoT3DHJSa3GB0f0wERsIsiA3Tnw
         NBpKAS5g/xWck2ci6nFYjFyIgfnov2IAN4rPhlDlVtdo/xSQ5kDSf4qNwqbh64Ri7vSc
         uwirWrwIG4hrJrjUj5gOlGySZBlS5XOFDK77lnQdMROYTGwndkaUnbsb8qsi9mmvFNnT
         FIMA==
X-Gm-Message-State: AOAM533YauVq/DbqsisFg+ApniX8ys/0u5LYAvCzJPARWmqkcd83uMNS
        cvQnx0LRgxABR2oFa+oY2oubZUOYyio=
X-Google-Smtp-Source: ABdhPJwWryO7R316ID223MrnmPvOT0fxqoe8ritntlzNx22oEJgIiugp0/2IjXxhEy14sOvMwz60qzUtwzU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:de69:b19a:1af5:866d])
 (user=seanjc job=sendgmr) by 2002:a25:8101:: with SMTP id o1mr42334214ybk.83.1628616006021;
 Tue, 10 Aug 2021 10:20:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 10 Aug 2021 10:19:50 -0700
In-Reply-To: <20210810171952.2758100-1-seanjc@google.com>
Message-Id: <20210810171952.2758100-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210810171952.2758100-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH 2/4] KVM: nVMX: Pull KVM L0's desired controls directly from vmcs01
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeng Guang <guang.zeng@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When preparing controls for vmcs02, grab KVM's desired controls from
vmcs01's shadow state instead of recalculating the controls from scratch,
or in the secondary execution controls, instead of using the dedicated
cache.  Calculating secondary exec controls is eye-poppingly expensive
due to the guest CPUID checks, hence the dedicated cache, but the other
calculations aren't exactly free either.

Explicitly clear several bits (x2APIC, DESC exiting, and load EFER on
exit) as appropriate as they may be set in vmcs01, whereas the previous
implementation relied on dynamic bits being cleared in the calculator.

Intentionally propagate VM_{ENTRY,EXIT}_LOAD_IA32_PERF_GLOBAL_CTRL from
vmcs01 to vmcs02.  Whether or not PERF_GLOBAL_CTRL is loaded depends on
whether or not perf itself is active, so unless perf stops between the
exit from L1 and entry to L2, vmcs01 will hold the desired value.  This
is purely an optimization as atomic_switch_perf_msrs() will set/clear
the control as needed at VM-Enter, i.e. it avoids two extra VMWRITEs in
the case where perf is active (versus starting with the bits clear in
vmcs02, which was the previous behavior).

Cc: Zeng Guang <guang.zeng@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 25 ++++++++++++++++---------
 arch/x86/kvm/vmx/vmx.h    |  6 +++++-
 2 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0d0dd6580cfd..264a9f4c9179 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2170,7 +2170,8 @@ static void prepare_vmcs02_early_rare(struct vcpu_vmx *vmx,
 	}
 }
 
-static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
+static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs01,
+				 struct vmcs12 *vmcs12)
 {
 	u32 exec_control;
 	u64 guest_efer = nested_vmx_calc_efer(vmx, vmcs12);
@@ -2181,7 +2182,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	/*
 	 * PIN CONTROLS
 	 */
-	exec_control = vmx_pin_based_exec_ctrl(vmx);
+	exec_control = __pin_controls_get(vmcs01);
 	exec_control |= (vmcs12->pin_based_vm_exec_control &
 			 ~PIN_BASED_VMX_PREEMPTION_TIMER);
 
@@ -2197,7 +2198,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	/*
 	 * EXEC CONTROLS
 	 */
-	exec_control = vmx_exec_control(vmx); /* L0's desires */
+	exec_control = __exec_controls_get(vmcs01); /* L0's desires */
 	exec_control &= ~CPU_BASED_INTR_WINDOW_EXITING;
 	exec_control &= ~CPU_BASED_NMI_WINDOW_EXITING;
 	exec_control &= ~CPU_BASED_TPR_SHADOW;
@@ -2234,10 +2235,11 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	 * SECONDARY EXEC CONTROLS
 	 */
 	if (cpu_has_secondary_exec_ctrls()) {
-		exec_control = vmx->secondary_exec_control;
+		exec_control = __secondary_exec_controls_get(vmcs01);
 
 		/* Take the following fields only from vmcs12 */
 		exec_control &= ~(SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
+				  SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |
 				  SECONDARY_EXEC_ENABLE_INVPCID |
 				  SECONDARY_EXEC_ENABLE_RDTSCP |
 				  SECONDARY_EXEC_XSAVES |
@@ -2245,7 +2247,9 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 				  SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
 				  SECONDARY_EXEC_APIC_REGISTER_VIRT |
 				  SECONDARY_EXEC_ENABLE_VMFUNC |
-				  SECONDARY_EXEC_TSC_SCALING);
+				  SECONDARY_EXEC_TSC_SCALING |
+				  SECONDARY_EXEC_DESC);
+
 		if (nested_cpu_has(vmcs12,
 				   CPU_BASED_ACTIVATE_SECONDARY_CONTROLS))
 			exec_control |= vmcs12->secondary_vm_exec_control;
@@ -2285,8 +2289,9 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	 * on the related bits (if supported by the CPU) in the hope that
 	 * we can avoid VMWrites during vmx_set_efer().
 	 */
-	exec_control = (vmcs12->vm_entry_controls | vmx_vmentry_ctrl()) &
-			~VM_ENTRY_IA32E_MODE & ~VM_ENTRY_LOAD_IA32_EFER;
+	exec_control = __vm_entry_controls_get(vmcs01);
+	exec_control |= vmcs12->vm_entry_controls;
+	exec_control &= ~(VM_ENTRY_IA32E_MODE | VM_ENTRY_LOAD_IA32_EFER);
 	if (cpu_has_load_ia32_efer()) {
 		if (guest_efer & EFER_LMA)
 			exec_control |= VM_ENTRY_IA32E_MODE;
@@ -2302,9 +2307,11 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	 * we should use its exit controls. Note that VM_EXIT_LOAD_IA32_EFER
 	 * bits may be modified by vmx_set_efer() in prepare_vmcs02().
 	 */
-	exec_control = vmx_vmexit_ctrl();
+	exec_control = __vm_exit_controls_get(vmcs01);
 	if (cpu_has_load_ia32_efer() && guest_efer != host_efer)
 		exec_control |= VM_EXIT_LOAD_IA32_EFER;
+	else
+		exec_control &= ~VM_EXIT_LOAD_IA32_EFER;
 	vm_exit_controls_set(vmx, exec_control);
 
 	/*
@@ -3347,7 +3354,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 
 	vmx_switch_vmcs(vcpu, &vmx->nested.vmcs02);
 
-	prepare_vmcs02_early(vmx, vmcs12);
+	prepare_vmcs02_early(vmx, &vmx->vmcs01, vmcs12);
 
 	if (from_vmentry) {
 		if (unlikely(!nested_get_vmcs12_pages(vcpu))) {
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 4f151175d45a..414b440de9ac 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -418,9 +418,13 @@ static inline void lname##_controls_set(struct vcpu_vmx *vmx, u32 val)	    \
 		vmx->loaded_vmcs->controls_shadow.lname = val;		    \
 	}								    \
 }									    \
+static inline u32 __##lname##_controls_get(struct loaded_vmcs *vmcs)	    \
+{									    \
+	return vmcs->controls_shadow.lname;				    \
+}									    \
 static inline u32 lname##_controls_get(struct vcpu_vmx *vmx)		    \
 {									    \
-	return vmx->loaded_vmcs->controls_shadow.lname;			    \
+	return __##lname##_controls_get(vmx->loaded_vmcs);		    \
 }									    \
 static inline void lname##_controls_setbit(struct vcpu_vmx *vmx, u32 val)   \
 {									    \
-- 
2.32.0.605.g8dce9f2422-goog

