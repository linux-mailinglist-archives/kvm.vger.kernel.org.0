Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32574372EB7
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 19:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhEDRTP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 13:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232220AbhEDRTC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 13:19:02 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A53C0613ED
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 10:18:07 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id u7-20020a259b470000b02904dca50820c2so12588479ybo.11
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 10:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ui+JXTkoxDdvwTCRiewZGYRxlMDy8e9kXT2BE3xqXtU=;
        b=S3hEGvhbPEekD+aCXuLlUiynkTyC45PVD7hjC6JATa85ouheGVuvmafHDWknN9bH/s
         XukGjXIT/clrheeK5PifQDXlfpG6fG7rBlb8UktuxQkUsPW3PiadJTVSrLxKAmTrnUev
         WpUzkfX12zPAXP9fxSSbmpNL3sCjYqndEI4ySMMBgbsGDHoXLvjhnXsZH4SZKdmqkKff
         n0/jgK+xmFOM6n/pSEW5O+1ChTwgCiqrq05+Ccc2xBl1DDfnQi32k+IeDkPMST0TP1SO
         tSyJtMoHzKCOf2zqouTt8k8ASBnRwqUhuACf6M71tEjt9bVEYhz358TzJ6IdPeoZQN9I
         QKFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ui+JXTkoxDdvwTCRiewZGYRxlMDy8e9kXT2BE3xqXtU=;
        b=GMJXsPEZpaBV4MsakR8XgZtRCfmKeN8jVLN6Uyf+HRxbtYApbaKAlUXpRHyDAv0a/N
         QzkmbsUiJFPmdUo+37V2abJQBX7fVk5YHBh6lzpXa+Rv65nyVsPc9eZxHO6dVhfVEu/J
         Ysr4wuc2Gq5BGFqA7WmZUDPXb1P5Ezd9pGn4brorzXmfzVyuhog1SGKWUq4d9XzGLmUh
         if4rGqcwt3mx3163L5dmdLtBQBlffWwaOnqaVq7FV4Va4aFvrX7ly6FMD5e6BhcuFnAQ
         jYl5Ydc8f3c4vQI3NhwFKo7WQWpMI8T6hp5tsfD/fin3Nt2SmESWtM/wfUB1pvA0zCFq
         Kfwg==
X-Gm-Message-State: AOAM5311abItF/HH4NLQOvNx+aMW4sAzJWKEV3ZViOHtSKaxNe5sfoys
        0fOy/GBqftNdjKtrlLmuC9tfTf9ha8U=
X-Google-Smtp-Source: ABdhPJypHZ1VkL2AY0aogZQv1fR5oFfAY2i3dt5Xcgm+D9QA2gWxFmOgsndFRP9+IHwaAAJoB/Y0iGLTguI=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:df57:48cb:ea33:a156])
 (user=seanjc job=sendgmr) by 2002:a25:c801:: with SMTP id y1mr37699490ybf.250.1620148686337;
 Tue, 04 May 2021 10:18:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 May 2021 10:17:29 -0700
In-Reply-To: <20210504171734.1434054-1-seanjc@google.com>
Message-Id: <20210504171734.1434054-11-seanjc@google.com>
Mime-Version: 1.0
References: <20210504171734.1434054-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH 10/15] KVM: VMX: Use common x86's uret MSR list as the one
 true list
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop VMX's global list of user return MSRs now that VMX doesn't resort said
list to isolate "active" MSRs, i.e. now that VMX's list and x86's list have
the same MSRs in the same order.

In addition to eliminating the redundant list, this will also allow moving
more of the list management into common x86.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/vmx.c          | 97 ++++++++++++++-------------------
 arch/x86/kvm/x86.c              | 12 ++++
 3 files changed, 53 insertions(+), 57 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a02c9bf3f7f1..c9452472ed55 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1778,6 +1778,7 @@ int kvm_pv_send_ipi(struct kvm *kvm, unsigned long ipi_bitmap_low,
 		    unsigned long icr, int op_64_bit);
 
 void kvm_define_user_return_msr(unsigned index, u32 msr);
+int kvm_find_user_return_msr(u32 msr);
 int kvm_probe_user_return_msr(u32 msr);
 int kvm_set_user_return_msr(unsigned index, u64 val, u64 mask);
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6caabcd5037e..4b432d2bbd06 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -454,26 +454,7 @@ static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
 
 static unsigned long host_idt_base;
 
-/*
- * Though SYSCALL is only supported in 64-bit mode on Intel CPUs, kvm
- * will emulate SYSCALL in legacy mode if the vendor string in guest
- * CPUID.0:{EBX,ECX,EDX} is "AuthenticAMD" or "AMDisbetter!" To
- * support this emulation, MSR_STAR is included in the list for i386,
- * but is never loaded into hardware.  MSR_CSTAR is also never loaded
- * into hardware and is here purely for emulation purposes.
- */
-static u32 vmx_uret_msrs_list[] = {
-#ifdef CONFIG_X86_64
-	MSR_SYSCALL_MASK, MSR_LSTAR, MSR_CSTAR,
-#endif
-	MSR_EFER, MSR_TSC_AUX, MSR_STAR,
-	MSR_IA32_TSX_CTRL,
-};
-
-/*
- * Number of user return MSRs that are actually supported in hardware.
- * vmx_uret_msrs_list is modified when KVM is loaded to drop unsupported MSRs.
- */
+/* Number of user return MSRs that are actually supported in hardware. */
 static int vmx_nr_uret_msrs;
 
 #if IS_ENABLED(CONFIG_HYPERV)
@@ -703,22 +684,11 @@ static bool is_valid_passthrough_msr(u32 msr)
 	return r;
 }
 
-static inline int __vmx_find_uret_msr(u32 msr)
-{
-	int i;
-
-	for (i = 0; i < vmx_nr_uret_msrs; ++i) {
-		if (vmx_uret_msrs_list[i] == msr)
-			return i;
-	}
-	return -1;
-}
-
 struct vmx_uret_msr *vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr)
 {
 	int i;
 
-	i = __vmx_find_uret_msr(msr);
+	i = kvm_find_user_return_msr(msr);
 	if (i >= 0)
 		return &vmx->guest_uret_msrs[i];
 	return NULL;
@@ -1086,7 +1056,7 @@ static bool update_transition_efer(struct vcpu_vmx *vmx)
 		return false;
 	}
 
-	i = __vmx_find_uret_msr(MSR_EFER);
+	i = kvm_find_user_return_msr(MSR_EFER);
 	if (i < 0)
 		return false;
 
@@ -6922,6 +6892,7 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 
 static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 {
+	struct vmx_uret_msr *tsx_ctrl;
 	struct vcpu_vmx *vmx;
 	int i, cpu, err;
 
@@ -6946,29 +6917,25 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 
 	for (i = 0; i < vmx_nr_uret_msrs; ++i) {
 		vmx->guest_uret_msrs[i].data = 0;
-
-		switch (vmx_uret_msrs_list[i]) {
-		case MSR_IA32_TSX_CTRL:
-			/*
-			 * TSX_CTRL_CPUID_CLEAR is handled in the CPUID
-			 * interception.  Keep the host value unchanged to avoid
-			 * changing CPUID bits under the host kernel's feet.
-			 *
-			 * hle=0, rtm=0, tsx_ctrl=1 can be found with some
-			 * combinations of new kernel and old userspace.  If
-			 * those guests run on a tsx=off host, do allow guests
-			 * to use TSX_CTRL, but do not change the value on the
-			 * host so that TSX remains always disabled.
-			 */
-			if (boot_cpu_has(X86_FEATURE_RTM))
-				vmx->guest_uret_msrs[i].mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
-			else
-				vmx->guest_uret_msrs[i].mask = 0;
-			break;
-		default:
-			vmx->guest_uret_msrs[i].mask = -1ull;
-			break;
-		}
+		vmx->guest_uret_msrs[i].mask = -1ull;
+	}
+	tsx_ctrl = vmx_find_uret_msr(vmx, MSR_IA32_TSX_CTRL);
+	if (tsx_ctrl) {
+		/*
+		 * TSX_CTRL_CPUID_CLEAR is handled in the CPUID interception.
+		 * Keep the host value unchanged to avoid changing CPUID bits
+		 * under the host kernel's feet.
+		 *
+		 * hle=0, rtm=0, tsx_ctrl=1 can be found with some combinations
+		 * of new kernel and old userspace.  If those guests run on a
+		 * tsx=off host, do allow guests to use TSX_CTRL, but do not
+		 * change the value on the host so that TSX remains always
+		 * disabled.
+		 */
+		if (boot_cpu_has(X86_FEATURE_RTM))
+			vmx->guest_uret_msrs[i].mask = ~(u64)TSX_CTRL_CPUID_CLEAR;
+		else
+			vmx->guest_uret_msrs[i].mask = 0;
 	}
 
 	err = alloc_loaded_vmcs(&vmx->vmcs01);
@@ -7829,6 +7796,22 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 
 static __init void vmx_setup_user_return_msrs(void)
 {
+
+	/*
+	 * Though SYSCALL is only supported in 64-bit mode on Intel CPUs, kvm
+	 * will emulate SYSCALL in legacy mode if the vendor string in guest
+	 * CPUID.0:{EBX,ECX,EDX} is "AuthenticAMD" or "AMDisbetter!" To
+	 * support this emulation, MSR_STAR is included in the list for i386,
+	 * but is never loaded into hardware.  MSR_CSTAR is also never loaded
+	 * into hardware and is here purely for emulation purposes.
+	 */
+	const u32 vmx_uret_msrs_list[] = {
+	#ifdef CONFIG_X86_64
+		MSR_SYSCALL_MASK, MSR_LSTAR, MSR_CSTAR,
+	#endif
+		MSR_EFER, MSR_TSC_AUX, MSR_STAR,
+		MSR_IA32_TSX_CTRL,
+	};
 	u32 msr;
 	int i;
 
@@ -7841,7 +7824,7 @@ static __init void vmx_setup_user_return_msrs(void)
 			continue;
 
 		kvm_define_user_return_msr(vmx_nr_uret_msrs, msr);
-		vmx_uret_msrs_list[vmx_nr_uret_msrs++] = msr;
+		vmx_nr_uret_msrs++;
 	}
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b4516d303413..90ef340565a4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -364,6 +364,18 @@ void kvm_define_user_return_msr(unsigned slot, u32 msr)
 }
 EXPORT_SYMBOL_GPL(kvm_define_user_return_msr);
 
+int kvm_find_user_return_msr(u32 msr)
+{
+	int i;
+
+	for (i = 0; i < user_return_msrs_global.nr; ++i) {
+		if (user_return_msrs_global.msrs[i] == msr)
+			return i;
+	}
+	return -1;
+}
+EXPORT_SYMBOL_GPL(kvm_find_user_return_msr);
+
 static void kvm_user_return_msr_cpu_online(void)
 {
 	unsigned int cpu = smp_processor_id();
-- 
2.31.1.527.g47e6f16901-goog

