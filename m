Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28C07692C1D
	for <lists+kvm@lfdr.de>; Sat, 11 Feb 2023 01:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjBKAfr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 19:35:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjBKAfo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 19:35:44 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB4BB54554
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 16:35:41 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id j18-20020a170903029200b00198aa765a9dso3722407plr.6
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 16:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=lmsg+5V35acSdfbJb/dgFwZCkcY3fbnY+ZUgRxDIMyc=;
        b=BAOAgMaiw1HfVC6cI2qDycwby87Gn/+VElcBlW7UjLY/VI8ABpo3kU+saozZqz6HA8
         mObqLrElTKxPoMdDCXblOecR4tM389vyuVazvjCoMNTjVq5XKVlAosWEud/zlxbApoDo
         3MBNOtyYyJCuZsxAy2+qAX08Fze2quXl3/gWedcP1UxsWd7oAc4cbf8zCps2hMRGlApE
         Bl3ntMnbjAqLXPLuxxbkuYTsmVpi118SYA/4nCfncGDn8i3x9/6qtfiGt+1epC9b4vnc
         ZvtGAIZ1uz8by2AJllatxH0jpQIlTJrFhyFE0uYX1yizkhP6SLuufky/qNWPBBdxSPBD
         +jyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lmsg+5V35acSdfbJb/dgFwZCkcY3fbnY+ZUgRxDIMyc=;
        b=newsVhG0zAHS05+vTgHYqYBesBmncuFNwSDwIb7SFOzeI7QpciBObgfchaCwzfjNFR
         InyvHmKzAtoPiBlYPCNcwopjTf4y4RkwS2BBSNk6Tx/90ZIMXe/5C0d+lOxZFYzje6Ck
         uoF8I12Z+hJCscJ9NAAVmM3NUG0S/oDpLmS8bsVLRmjxuGnk0dOxVY5B3rPxoroEThhN
         FycGcke7aBxJgnfwW+S0sExUd7uHzeE+cAYehbdfpnspyOUBCedgJ+D3H5zbk13BRJdZ
         Zdl3EX1tG0xj3OyVryG8rQvsMYAXujzpSdnOJ0uE6hIxOhHNKE3G5p2/SgLspVfR6B1k
         azbQ==
X-Gm-Message-State: AO0yUKXkQjMxUXd5PLgwutOfLXJ/aoI1gaRCVpW0adK+1EelzBXFQrA9
        dpgX8xU+pvucbh3CqztEaP5EaTt1B7c=
X-Google-Smtp-Source: AK7set+2rb93OyPq4idvwtFOyGonwgn/t+1nr+mTAtoPkFUJdzXTHev7O/i8ztfJ7KtVuApgY8UBVhFc/Yc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:61c7:0:b0:593:c940:f0c7 with SMTP id
 v190-20020a6261c7000000b00593c940f0c7mr3886470pfb.16.1676075740854; Fri, 10
 Feb 2023 16:35:40 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 11 Feb 2023 00:35:33 +0000
In-Reply-To: <20230211003534.564198-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230211003534.564198-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230211003534.564198-3-seanjc@google.com>
Subject: [PATCH v2 2/3] KVM: VMX: Stub out enable_evmcs static key for CONFIG_HYPERV=n
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
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

Wrap enable_evmcs in a helper and stub it out when CONFIG_HYPERV=n in
order to eliminate the static branch nop placeholders.  clang-14 is clever
enough to elide the nop, but gcc-12 is not.  Stubbing out the key reduces
the size of kvm-intel.ko by ~7.5% (200KiB) when compiled with gcc-12
(there are a _lot_ of VMCS accesses throughout KVM).

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
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
index 1299143d00df..a54a2fdf0a5b 100644
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
+static __always_inline bool kvm_is_using_evmcs(void)
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
+static __always_inline bool kvm_is_using_evmcs(void) { return false; }
 static __always_inline void evmcs_write64(unsigned long field, u64 value) {}
 static __always_inline void evmcs_write32(unsigned long field, u32 value) {}
 static __always_inline void evmcs_write16(unsigned long field, u16 value) {}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 33614ee2cd67..d80cbe01b5d7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -595,7 +595,7 @@ static void hv_reset_evmcs(void)
 {
 	struct hv_vp_assist_page *vp_ap;
 
-	if (!static_branch_unlikely(&enable_evmcs))
+	if (!kvm_is_using_evmcs())
 		return;
 
 	/*
@@ -2818,8 +2818,7 @@ static int vmx_hardware_enable(void)
 	 * This can happen if we hot-added a CPU but failed to allocate
 	 * VP assist page for it.
 	 */
-	if (static_branch_unlikely(&enable_evmcs) &&
-	    !hv_get_vp_assist_page(cpu))
+	if (kvm_is_using_evmcs() && !hv_get_vp_assist_page(cpu))
 		return -EFAULT;
 
 	intel_pt_handle_vmx(1);
@@ -2871,7 +2870,7 @@ struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags)
 	memset(vmcs, 0, vmcs_config.size);
 
 	/* KVM supports Enlightened VMCS v1 only */
-	if (static_branch_unlikely(&enable_evmcs))
+	if (kvm_is_using_evmcs())
 		vmcs->hdr.revision_id = KVM_EVMCS_VERSION;
 	else
 		vmcs->hdr.revision_id = vmcs_config.revision_id;
@@ -2966,7 +2965,7 @@ static __init int alloc_kvm_area(void)
 		 * still be marked with revision_id reported by
 		 * physical CPU.
 		 */
-		if (static_branch_unlikely(&enable_evmcs))
+		if (kvm_is_using_evmcs())
 			vmcs->hdr.revision_id = vmcs_config.revision_id;
 
 		per_cpu(vmxarea, cpu) = vmcs;
@@ -3936,7 +3935,7 @@ static void vmx_msr_bitmap_l01_changed(struct vcpu_vmx *vmx)
 	 * 'Enlightened MSR Bitmap' feature L0 needs to know that MSR
 	 * bitmap has changed.
 	 */
-	if (IS_ENABLED(CONFIG_HYPERV) && static_branch_unlikely(&enable_evmcs)) {
+	if (kvm_is_using_evmcs()) {
 		struct hv_enlightened_vmcs *evmcs = (void *)vmx->vmcs01.vmcs;
 
 		if (evmcs->hv_enlightenments_control.msr_bitmap)
@@ -7313,7 +7312,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	vmx_vcpu_enter_exit(vcpu, __vmx_vcpu_run_flags(vmx));
 
 	/* All fields are clean at this point */
-	if (static_branch_unlikely(&enable_evmcs)) {
+	if (kvm_is_using_evmcs()) {
 		current_evmcs->hv_clean_fields |=
 			HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
 
@@ -7443,7 +7442,7 @@ static int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 	 * feature only for vmcs01, KVM currently isn't equipped to realize any
 	 * performance benefits from enabling it for vmcs02.
 	 */
-	if (IS_ENABLED(CONFIG_HYPERV) && static_branch_unlikely(&enable_evmcs) &&
+	if (kvm_is_using_evmcs() &&
 	    (ms_hyperv.nested_features & HV_X64_NESTED_MSR_BITMAP)) {
 		struct hv_enlightened_vmcs *evmcs = (void *)vmx->vmcs01.vmcs;
 
diff --git a/arch/x86/kvm/vmx/vmx_ops.h b/arch/x86/kvm/vmx/vmx_ops.h
index db95bde52998..ce47dc265f89 100644
--- a/arch/x86/kvm/vmx/vmx_ops.h
+++ b/arch/x86/kvm/vmx/vmx_ops.h
@@ -147,7 +147,7 @@ static __always_inline unsigned long __vmcs_readl(unsigned long field)
 static __always_inline u16 vmcs_read16(unsigned long field)
 {
 	vmcs_check16(field);
-	if (static_branch_unlikely(&enable_evmcs))
+	if (kvm_is_using_evmcs())
 		return evmcs_read16(field);
 	return __vmcs_readl(field);
 }
@@ -155,7 +155,7 @@ static __always_inline u16 vmcs_read16(unsigned long field)
 static __always_inline u32 vmcs_read32(unsigned long field)
 {
 	vmcs_check32(field);
-	if (static_branch_unlikely(&enable_evmcs))
+	if (kvm_is_using_evmcs())
 		return evmcs_read32(field);
 	return __vmcs_readl(field);
 }
@@ -163,7 +163,7 @@ static __always_inline u32 vmcs_read32(unsigned long field)
 static __always_inline u64 vmcs_read64(unsigned long field)
 {
 	vmcs_check64(field);
-	if (static_branch_unlikely(&enable_evmcs))
+	if (kvm_is_using_evmcs())
 		return evmcs_read64(field);
 #ifdef CONFIG_X86_64
 	return __vmcs_readl(field);
@@ -175,7 +175,7 @@ static __always_inline u64 vmcs_read64(unsigned long field)
 static __always_inline unsigned long vmcs_readl(unsigned long field)
 {
 	vmcs_checkl(field);
-	if (static_branch_unlikely(&enable_evmcs))
+	if (kvm_is_using_evmcs())
 		return evmcs_read64(field);
 	return __vmcs_readl(field);
 }
@@ -222,7 +222,7 @@ static __always_inline void __vmcs_writel(unsigned long field, unsigned long val
 static __always_inline void vmcs_write16(unsigned long field, u16 value)
 {
 	vmcs_check16(field);
-	if (static_branch_unlikely(&enable_evmcs))
+	if (kvm_is_using_evmcs())
 		return evmcs_write16(field, value);
 
 	__vmcs_writel(field, value);
@@ -231,7 +231,7 @@ static __always_inline void vmcs_write16(unsigned long field, u16 value)
 static __always_inline void vmcs_write32(unsigned long field, u32 value)
 {
 	vmcs_check32(field);
-	if (static_branch_unlikely(&enable_evmcs))
+	if (kvm_is_using_evmcs())
 		return evmcs_write32(field, value);
 
 	__vmcs_writel(field, value);
@@ -240,7 +240,7 @@ static __always_inline void vmcs_write32(unsigned long field, u32 value)
 static __always_inline void vmcs_write64(unsigned long field, u64 value)
 {
 	vmcs_check64(field);
-	if (static_branch_unlikely(&enable_evmcs))
+	if (kvm_is_using_evmcs())
 		return evmcs_write64(field, value);
 
 	__vmcs_writel(field, value);
@@ -252,7 +252,7 @@ static __always_inline void vmcs_write64(unsigned long field, u64 value)
 static __always_inline void vmcs_writel(unsigned long field, unsigned long value)
 {
 	vmcs_checkl(field);
-	if (static_branch_unlikely(&enable_evmcs))
+	if (kvm_is_using_evmcs())
 		return evmcs_write64(field, value);
 
 	__vmcs_writel(field, value);
@@ -262,7 +262,7 @@ static __always_inline void vmcs_clear_bits(unsigned long field, u32 mask)
 {
 	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && ((field) & 0x6000) == 0x2000,
 			 "vmcs_clear_bits does not support 64-bit fields");
-	if (static_branch_unlikely(&enable_evmcs))
+	if (kvm_is_using_evmcs())
 		return evmcs_write32(field, evmcs_read32(field) & ~mask);
 
 	__vmcs_writel(field, __vmcs_readl(field) & ~mask);
@@ -272,7 +272,7 @@ static __always_inline void vmcs_set_bits(unsigned long field, u32 mask)
 {
 	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && ((field) & 0x6000) == 0x2000,
 			 "vmcs_set_bits does not support 64-bit fields");
-	if (static_branch_unlikely(&enable_evmcs))
+	if (kvm_is_using_evmcs())
 		return evmcs_write32(field, evmcs_read32(field) | mask);
 
 	__vmcs_writel(field, __vmcs_readl(field) | mask);
@@ -289,7 +289,7 @@ static inline void vmcs_load(struct vmcs *vmcs)
 {
 	u64 phys_addr = __pa(vmcs);
 
-	if (static_branch_unlikely(&enable_evmcs))
+	if (kvm_is_using_evmcs())
 		return evmcs_load(phys_addr);
 
 	vmx_asm1(vmptrld, "m"(phys_addr), vmcs, phys_addr);
-- 
2.39.1.581.gbfd45094c4-goog

