Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED6468F917
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 21:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbjBHUyp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 15:54:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231929AbjBHUyj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 15:54:39 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1714F2D159
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 12:54:36 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id s16-20020a17090aba1000b002303782fcd8so1819134pjr.9
        for <kvm@vger.kernel.org>; Wed, 08 Feb 2023 12:54:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=15FiKcaU7Ahr0kQcj4HYZoBjaRHQdfsVpR1F+LgCEnA=;
        b=rtJpDnUZXOsfk9URRCxUeUD5K3dxQbHH7IuYCLY5vldCxlhunEGOjsIfeNMu69uXdi
         EP8/3oma2EDJ6YmBrr1QBLee+ZhVtpXTPNTLixDdwoB76sPC8O4lvhczZOIUXguL9Hm8
         to1cCgTBkzDHFQoOJeFi0Mxd/ANDiZCvLVJlvWnoVHesTWYbEsX4IqpZrvPCczkosEQd
         kbrcL/KICzTWE5yFIB4hDCD9ippMjF7gdDA4ZuD15nzVn8/lwD+vjU/4Y11lnKow6tFg
         7RpGcanpvdfcO854cyQ3EOIk/qvfG3YGgkmJzBe1lHsPHq8Q022rGWLKL9NpsMuP/Mvx
         kcJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=15FiKcaU7Ahr0kQcj4HYZoBjaRHQdfsVpR1F+LgCEnA=;
        b=yN0MoNIfR8D7BT/7tjNIHpwNY1a3/3hMTS2+k70Bq1kxV/WotSWkrL98gBhRbaLXJP
         KDPHHgD+JDdZtE2fUvR6FroHmRVYySSa1Wkz5GosBU4jI1FZMCvHXx0VlWT4GHczAYp8
         lwiBazAqb83ySdQn9MjwjjJzndKmydpOTWMMezZlGcvMGqfdOFLvtzMe4IqVFEIgkWWV
         cgCM7Zis8+FundNeiTdS60Eqxo4n7YXs6l1Gau/d5T0658PQdcKX47AMlEfOQA5Zuai5
         jolnVcSRWFytTUWu5tsWWJoC+D/UqbrYqZjKQTZ8PpoTKqnz1quRLoHt8BSY4jMPgfxx
         ovig==
X-Gm-Message-State: AO0yUKX1CyCBv6thJtLfH+AcgYLVUTEmmYVGiIQFn3/moCMEmO4D8uas
        zA4+ksw1nYp+HwtXzvLfU+bGmwE5MZI=
X-Google-Smtp-Source: AK7set8VgAf8bYv+jS0e4RWZcvGNUGRkCep+NAgSd9ZVHsbVeVT/eXL+UvuHvRDg6/xuISavfKuWaIoGXjo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:962e:0:b0:5a8:4cad:5a72 with SMTP id
 r14-20020aa7962e000000b005a84cad5a72mr424077pfg.24.1675889675591; Wed, 08 Feb
 2023 12:54:35 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Feb 2023 20:54:30 +0000
In-Reply-To: <20230208205430.1424667-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230208205430.1424667-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230208205430.1424667-3-seanjc@google.com>
Subject: [PATCH 2/2] KVM: VMX: Stub out enable_evmcs static key for CONFIG_HYPERV=n
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wrap enable_evmcs in a helper and stub it out when CONFIG_HYPERV=n in
order to eliminate the static branch nop placeholders.  clang-14 is clever
enough to elide the nop, but gcc-12 is not.  Stubbing out the key reduces
the size of kvm-intel.ko by ~7.5% (200KiB) when compiled with gcc-12
(there are a _lot_ of VMCS accesses throughout KVM).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/hyperv.c  |  4 ++--
 arch/x86/kvm/vmx/hyperv.h  | 10 ++++++++--
 arch/x86/kvm/vmx/vmx.c     | 15 +++++++--------
 arch/x86/kvm/vmx/vmx_ops.h | 22 +++++++++++-----------
 4 files changed, 28 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/vmx/hyperv.c b/arch/x86/kvm/vmx/hyperv.c
index b6748055c586..274fbd38c64e 100644
--- a/arch/x86/kvm/vmx/hyperv.c
+++ b/arch/x86/kvm/vmx/hyperv.c
@@ -118,8 +118,6 @@
 
 #define EVMCS1_SUPPORTED_VMFUNC (0)
 
-DEFINE_STATIC_KEY_FALSE(enable_evmcs);
-
 #define EVMCS1_OFFSET(x) offsetof(struct hv_enlightened_vmcs, x)
 #define EVMCS1_FIELD(number, name, clean_field)[ROL16(number, 6)] = \
 		{EVMCS1_OFFSET(name), clean_field}
@@ -611,6 +609,8 @@ int nested_evmcs_check_controls(struct vmcs12 *vmcs12)
 }
 
 #if IS_ENABLED(CONFIG_HYPERV)
+DEFINE_STATIC_KEY_FALSE(enable_evmcs);
+
 /*
  * KVM on Hyper-V always uses the latest known eVMCSv1 revision, the assumption
  * is: in case a feature has corresponding fields in eVMCS described and it was
diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
index 1299143d00df..a0b6d05dba5d 100644
--- a/arch/x86/kvm/vmx/hyperv.h
+++ b/arch/x86/kvm/vmx/hyperv.h
@@ -16,8 +16,6 @@
 
 struct vmcs_config;
 
-DECLARE_STATIC_KEY_FALSE(enable_evmcs);
-
 #define current_evmcs ((struct hv_enlightened_vmcs *)this_cpu_read(current_vmcs))
 
 #define KVM_EVMCS_VERSION 1
@@ -69,6 +67,13 @@ static inline u64 evmcs_read_any(struct hv_enlightened_vmcs *evmcs,
 
 #if IS_ENABLED(CONFIG_HYPERV)
 
+DECLARE_STATIC_KEY_FALSE(enable_evmcs);
+
+static __always_inline bool is_evmcs_enabled(void)
+{
+	return static_branch_unlikely(&enable_evmcs);
+}
+
 static __always_inline int get_evmcs_offset(unsigned long field,
 					    u16 *clean_field)
 {
@@ -158,6 +163,7 @@ static inline void evmcs_load(u64 phys_addr)
 
 void evmcs_sanitize_exec_ctrls(struct vmcs_config *vmcs_conf);
 #else /* !IS_ENABLED(CONFIG_HYPERV) */
+static __always_inline bool is_evmcs_enabled(void) { return false; }
 static __always_inline void evmcs_write64(unsigned long field, u64 value) {}
 static __always_inline void evmcs_write32(unsigned long field, u32 value) {}
 static __always_inline void evmcs_write16(unsigned long field, u16 value) {}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 33614ee2cd67..9f0098c9ad64 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -595,7 +595,7 @@ static void hv_reset_evmcs(void)
 {
 	struct hv_vp_assist_page *vp_ap;
 
-	if (!static_branch_unlikely(&enable_evmcs))
+	if (!is_evmcs_enabled())
 		return;
 
 	/*
@@ -2818,8 +2818,7 @@ static int vmx_hardware_enable(void)
 	 * This can happen if we hot-added a CPU but failed to allocate
 	 * VP assist page for it.
 	 */
-	if (static_branch_unlikely(&enable_evmcs) &&
-	    !hv_get_vp_assist_page(cpu))
+	if (is_evmcs_enabled() && !hv_get_vp_assist_page(cpu))
 		return -EFAULT;
 
 	intel_pt_handle_vmx(1);
@@ -2871,7 +2870,7 @@ struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags)
 	memset(vmcs, 0, vmcs_config.size);
 
 	/* KVM supports Enlightened VMCS v1 only */
-	if (static_branch_unlikely(&enable_evmcs))
+	if (is_evmcs_enabled())
 		vmcs->hdr.revision_id = KVM_EVMCS_VERSION;
 	else
 		vmcs->hdr.revision_id = vmcs_config.revision_id;
@@ -2966,7 +2965,7 @@ static __init int alloc_kvm_area(void)
 		 * still be marked with revision_id reported by
 		 * physical CPU.
 		 */
-		if (static_branch_unlikely(&enable_evmcs))
+		if (is_evmcs_enabled())
 			vmcs->hdr.revision_id = vmcs_config.revision_id;
 
 		per_cpu(vmxarea, cpu) = vmcs;
@@ -3936,7 +3935,7 @@ static void vmx_msr_bitmap_l01_changed(struct vcpu_vmx *vmx)
 	 * 'Enlightened MSR Bitmap' feature L0 needs to know that MSR
 	 * bitmap has changed.
 	 */
-	if (IS_ENABLED(CONFIG_HYPERV) && static_branch_unlikely(&enable_evmcs)) {
+	if (is_evmcs_enabled()) {
 		struct hv_enlightened_vmcs *evmcs = (void *)vmx->vmcs01.vmcs;
 
 		if (evmcs->hv_enlightenments_control.msr_bitmap)
@@ -7313,7 +7312,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	vmx_vcpu_enter_exit(vcpu, __vmx_vcpu_run_flags(vmx));
 
 	/* All fields are clean at this point */
-	if (static_branch_unlikely(&enable_evmcs)) {
+	if (is_evmcs_enabled()) {
 		current_evmcs->hv_clean_fields |=
 			HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
 
@@ -7443,7 +7442,7 @@ static int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 	 * feature only for vmcs01, KVM currently isn't equipped to realize any
 	 * performance benefits from enabling it for vmcs02.
 	 */
-	if (IS_ENABLED(CONFIG_HYPERV) && static_branch_unlikely(&enable_evmcs) &&
+	if (is_evmcs_enabled() &&
 	    (ms_hyperv.nested_features & HV_X64_NESTED_MSR_BITMAP)) {
 		struct hv_enlightened_vmcs *evmcs = (void *)vmx->vmcs01.vmcs;
 
diff --git a/arch/x86/kvm/vmx/vmx_ops.h b/arch/x86/kvm/vmx/vmx_ops.h
index db95bde52998..6b072db47fdc 100644
--- a/arch/x86/kvm/vmx/vmx_ops.h
+++ b/arch/x86/kvm/vmx/vmx_ops.h
@@ -147,7 +147,7 @@ static __always_inline unsigned long __vmcs_readl(unsigned long field)
 static __always_inline u16 vmcs_read16(unsigned long field)
 {
 	vmcs_check16(field);
-	if (static_branch_unlikely(&enable_evmcs))
+	if (is_evmcs_enabled())
 		return evmcs_read16(field);
 	return __vmcs_readl(field);
 }
@@ -155,7 +155,7 @@ static __always_inline u16 vmcs_read16(unsigned long field)
 static __always_inline u32 vmcs_read32(unsigned long field)
 {
 	vmcs_check32(field);
-	if (static_branch_unlikely(&enable_evmcs))
+	if (is_evmcs_enabled())
 		return evmcs_read32(field);
 	return __vmcs_readl(field);
 }
@@ -163,7 +163,7 @@ static __always_inline u32 vmcs_read32(unsigned long field)
 static __always_inline u64 vmcs_read64(unsigned long field)
 {
 	vmcs_check64(field);
-	if (static_branch_unlikely(&enable_evmcs))
+	if (is_evmcs_enabled())
 		return evmcs_read64(field);
 #ifdef CONFIG_X86_64
 	return __vmcs_readl(field);
@@ -175,7 +175,7 @@ static __always_inline u64 vmcs_read64(unsigned long field)
 static __always_inline unsigned long vmcs_readl(unsigned long field)
 {
 	vmcs_checkl(field);
-	if (static_branch_unlikely(&enable_evmcs))
+	if (is_evmcs_enabled())
 		return evmcs_read64(field);
 	return __vmcs_readl(field);
 }
@@ -222,7 +222,7 @@ static __always_inline void __vmcs_writel(unsigned long field, unsigned long val
 static __always_inline void vmcs_write16(unsigned long field, u16 value)
 {
 	vmcs_check16(field);
-	if (static_branch_unlikely(&enable_evmcs))
+	if (is_evmcs_enabled())
 		return evmcs_write16(field, value);
 
 	__vmcs_writel(field, value);
@@ -231,7 +231,7 @@ static __always_inline void vmcs_write16(unsigned long field, u16 value)
 static __always_inline void vmcs_write32(unsigned long field, u32 value)
 {
 	vmcs_check32(field);
-	if (static_branch_unlikely(&enable_evmcs))
+	if (is_evmcs_enabled())
 		return evmcs_write32(field, value);
 
 	__vmcs_writel(field, value);
@@ -240,7 +240,7 @@ static __always_inline void vmcs_write32(unsigned long field, u32 value)
 static __always_inline void vmcs_write64(unsigned long field, u64 value)
 {
 	vmcs_check64(field);
-	if (static_branch_unlikely(&enable_evmcs))
+	if (is_evmcs_enabled())
 		return evmcs_write64(field, value);
 
 	__vmcs_writel(field, value);
@@ -252,7 +252,7 @@ static __always_inline void vmcs_write64(unsigned long field, u64 value)
 static __always_inline void vmcs_writel(unsigned long field, unsigned long value)
 {
 	vmcs_checkl(field);
-	if (static_branch_unlikely(&enable_evmcs))
+	if (is_evmcs_enabled())
 		return evmcs_write64(field, value);
 
 	__vmcs_writel(field, value);
@@ -262,7 +262,7 @@ static __always_inline void vmcs_clear_bits(unsigned long field, u32 mask)
 {
 	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && ((field) & 0x6000) == 0x2000,
 			 "vmcs_clear_bits does not support 64-bit fields");
-	if (static_branch_unlikely(&enable_evmcs))
+	if (is_evmcs_enabled())
 		return evmcs_write32(field, evmcs_read32(field) & ~mask);
 
 	__vmcs_writel(field, __vmcs_readl(field) & ~mask);
@@ -272,7 +272,7 @@ static __always_inline void vmcs_set_bits(unsigned long field, u32 mask)
 {
 	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && ((field) & 0x6000) == 0x2000,
 			 "vmcs_set_bits does not support 64-bit fields");
-	if (static_branch_unlikely(&enable_evmcs))
+	if (is_evmcs_enabled())
 		return evmcs_write32(field, evmcs_read32(field) | mask);
 
 	__vmcs_writel(field, __vmcs_readl(field) | mask);
@@ -289,7 +289,7 @@ static inline void vmcs_load(struct vmcs *vmcs)
 {
 	u64 phys_addr = __pa(vmcs);
 
-	if (static_branch_unlikely(&enable_evmcs))
+	if (is_evmcs_enabled())
 		return evmcs_load(phys_addr);
 
 	vmx_asm1(vmptrld, "m"(phys_addr), vmcs, phys_addr);
-- 
2.39.1.519.gcb327c4b5f-goog

