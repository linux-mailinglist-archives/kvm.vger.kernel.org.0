Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3973E7E20
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 19:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbhHJRUi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 13:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhHJRUd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 13:20:33 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237D2C0613C1
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 10:20:11 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id o6-20020a05620a0546b02903d22e7d9864so5470157qko.16
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 10:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=gTrvBU5BCZz88nYYTzOB3fPPmplR6fDFeeaXK8gldEk=;
        b=l9PJFM/0r1rwinnIsqSDGisVVjf0eWKNm5DQQYfUs+E+j51lqIA0oil6yCvF3BOiYw
         sGV1DdLN/LsTt+CeAyIvu3cqALJoeuETJ0h1xFEmHAg6pN3QXPg4kWwWwkQE5cn8a+Wi
         hRT+CmSDa2LY4r+g5sa9zJtwE0H19PUZhrS7zVWEUNya/mIPuQ7cwcFFpFA/o/XFvKC+
         sHpO7jPWlFqkydcY8Jxqk+MnASUr5HB2taxPymStlS+Ut1pngHvCLf0P2mGiHiGASk0R
         M9xsdHoXisOYtZSQypAio2qkcvfAaeMIwj7arPmvdbgH0f1Einnagg7/04XNDRsKYVK+
         wZDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=gTrvBU5BCZz88nYYTzOB3fPPmplR6fDFeeaXK8gldEk=;
        b=l4JwwW2gzi5IiIJrv/zwBuCquoiPB7eJCpkIFjEJXLsisXdkZseoIoE59h2HuqXhZt
         +CWbuPCv20In5a1S4OizoxavReyP4839m3EdW00rjdbXoLkanTFD0GuLnmpIFjDH7HHQ
         xbJKBKwCBR5bL+hwVPJGX0dvXyZUCv2+3DAeo8DbCFj0+DtwhrfXDRAzzFpYNjtOyoSe
         VwLwXBr4Ex/bRmvazWrL+p/xImUu0ZHJooflBYeMITLI3rgdcHqZUaSzEneC/PVitHE4
         783dr9konUjy45ZetuZwMJvXztLkqOmikNLEjeg4BzTD5d5c9LiSWldlc8I53McchbeO
         xINg==
X-Gm-Message-State: AOAM5314efgQtUm9cXgzCctQu/o29VkrtymehCMmXe4HX1GfEQ0QsgOc
        xiA8AI6JqgbBIm9/9TaNl2bPvPK+nIE=
X-Google-Smtp-Source: ABdhPJz8zUkSj29Bso6TbU2Lkpcvx9y9QcGRUVf1oj8MCD/YRyTJHg7pCkQ/AG9NrNvd8tygdWcjmo0IviE=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:de69:b19a:1af5:866d])
 (user=seanjc job=sendgmr) by 2002:ad4:5ccc:: with SMTP id iu12mr19232697qvb.47.1628616010064;
 Tue, 10 Aug 2021 10:20:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 10 Aug 2021 10:19:52 -0700
In-Reply-To: <20210810171952.2758100-1-seanjc@google.com>
Message-Id: <20210810171952.2758100-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210810171952.2758100-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH 4/4] KVM: VMX: Hide VMCS control calculators in vmx.c
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

Now that nested VMX pulls KVM's desired VMCS controls from vmcs01 instead
of re-calculating on the fly, bury the helpers that do the calcluations
in vmx.c.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 30 +++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/vmx.h | 26 --------------------------
 2 files changed, 27 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6c93122363b2..c771575a8c9c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4095,7 +4095,7 @@ void set_cr4_guest_host_mask(struct vcpu_vmx *vmx)
 	vmcs_writel(CR4_GUEST_HOST_MASK, ~vcpu->arch.cr4_guest_owned_bits);
 }
 
-u32 vmx_pin_based_exec_ctrl(struct vcpu_vmx *vmx)
+static u32 vmx_pin_based_exec_ctrl(struct vcpu_vmx *vmx)
 {
 	u32 pin_based_exec_ctrl = vmcs_config.pin_based_exec_ctrl;
 
@@ -4111,6 +4111,30 @@ u32 vmx_pin_based_exec_ctrl(struct vcpu_vmx *vmx)
 	return pin_based_exec_ctrl;
 }
 
+static u32 vmx_vmentry_ctrl(void)
+{
+	u32 vmentry_ctrl = vmcs_config.vmentry_ctrl;
+
+	if (vmx_pt_mode_is_system())
+		vmentry_ctrl &= ~(VM_ENTRY_PT_CONCEAL_PIP |
+				  VM_ENTRY_LOAD_IA32_RTIT_CTL);
+	/* Loading of EFER and PERF_GLOBAL_CTRL are toggled dynamically */
+	return vmentry_ctrl &
+		~(VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL | VM_ENTRY_LOAD_IA32_EFER);
+}
+
+static u32 vmx_vmexit_ctrl(void)
+{
+	u32 vmexit_ctrl = vmcs_config.vmexit_ctrl;
+
+	if (vmx_pt_mode_is_system())
+		vmexit_ctrl &= ~(VM_EXIT_PT_CONCEAL_PIP |
+				 VM_EXIT_CLEAR_IA32_RTIT_CTL);
+	/* Loading of EFER and PERF_GLOBAL_CTRL are toggled dynamically */
+	return vmexit_ctrl &
+		~(VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL | VM_EXIT_LOAD_IA32_EFER);
+}
+
 static void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -4130,7 +4154,7 @@ static void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 	vmx_update_msr_bitmap_x2apic(vcpu);
 }
 
-u32 vmx_exec_control(struct vcpu_vmx *vmx)
+static u32 vmx_exec_control(struct vcpu_vmx *vmx)
 {
 	u32 exec_control = vmcs_config.cpu_based_exec_ctrl;
 
@@ -4212,7 +4236,7 @@ vmx_adjust_secondary_exec_control(struct vcpu_vmx *vmx, u32 *exec_control,
 #define vmx_adjust_sec_exec_exiting(vmx, exec_control, lname, uname) \
 	vmx_adjust_sec_exec_control(vmx, exec_control, lname, uname, uname##_EXITING, true)
 
-u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
+static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
 {
 	struct kvm_vcpu *vcpu = &vmx->vcpu;
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 2bd07867e9da..4858c5fd95f2 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -452,32 +452,6 @@ static inline void vmx_register_cache_reset(struct kvm_vcpu *vcpu)
 	vcpu->arch.regs_dirty = 0;
 }
 
-static inline u32 vmx_vmentry_ctrl(void)
-{
-	u32 vmentry_ctrl = vmcs_config.vmentry_ctrl;
-	if (vmx_pt_mode_is_system())
-		vmentry_ctrl &= ~(VM_ENTRY_PT_CONCEAL_PIP |
-				  VM_ENTRY_LOAD_IA32_RTIT_CTL);
-	/* Loading of EFER and PERF_GLOBAL_CTRL are toggled dynamically */
-	return vmentry_ctrl &
-		~(VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL | VM_ENTRY_LOAD_IA32_EFER);
-}
-
-static inline u32 vmx_vmexit_ctrl(void)
-{
-	u32 vmexit_ctrl = vmcs_config.vmexit_ctrl;
-	if (vmx_pt_mode_is_system())
-		vmexit_ctrl &= ~(VM_EXIT_PT_CONCEAL_PIP |
-				 VM_EXIT_CLEAR_IA32_RTIT_CTL);
-	/* Loading of EFER and PERF_GLOBAL_CTRL are toggled dynamically */
-	return vmexit_ctrl &
-		~(VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL | VM_EXIT_LOAD_IA32_EFER);
-}
-
-u32 vmx_exec_control(struct vcpu_vmx *vmx);
-u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx);
-u32 vmx_pin_based_exec_ctrl(struct vcpu_vmx *vmx);
-
 static inline struct kvm_vmx *to_kvm_vmx(struct kvm *kvm)
 {
 	return container_of(kvm, struct kvm_vmx, kvm);
-- 
2.32.0.605.g8dce9f2422-goog

