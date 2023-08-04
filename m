Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85159770AE5
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 23:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbjHDV2b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 17:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbjHDV2P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 17:28:15 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8BD4EEF
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 14:27:19 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-584126c65d1so27285587b3.3
        for <kvm@vger.kernel.org>; Fri, 04 Aug 2023 14:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691184438; x=1691789238;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dNpHi0H0JcjrXcAHJRDNNHS6Y3QY9pKXg8U5IrwTnBs=;
        b=0FN5uRLRqrsD90WzzdfAeMZh4tueUhB9PD+hZyku7Yes5vYpRmV0ytHIvi1ESesthC
         bQhoLs0jwubz4BIi92YdoJye+vLRPAhQWGaXmSMAnvh3/Pv/RJPieK2zC7Ut088jG4Rl
         LDw5EWrx4L2HAUnsHp1CjTKeBHPjwu1/4O7eOfWtWUp+SlJ6B1pqhZ1XNB78TQ4Xrfwg
         2yhJqW3ROu2QT0+zUnLrpqh3sS990o60YFRoNdGzHy9IWYrZ77JJf5h4cJMIWTkYQUE4
         ZQYpnKpymvcffu3pnfxCSA6TBI4k0QNi0/25+uCbDtu+C0YNyl9wAvMlbe+v1/JgYf2V
         ZGfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691184438; x=1691789238;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dNpHi0H0JcjrXcAHJRDNNHS6Y3QY9pKXg8U5IrwTnBs=;
        b=CYuN+Cj/Y9l+05OmyleK1bukYflU1wRSjU6IS69S/TArEEfcWuhJi7kur8OCHXa1QV
         Sm8PJ/sh1WvK8vtYlxCE6XK11QK7WtYA0gAiT7465O1qoSdbjv4fqAoNx/TyFrHvtwOn
         WVuLgjXDvlxdIYiFo1mg6vREQEf0G7FQE9QdWeZwVlWsDdErm8qAs2et3gQrmaAK5/iu
         L3iaNqlZphX5EB4gxwdmtrlknh2Fh7alfUOMD8ZKznDR8GiVOn0CQK599JuAdNgZXm9a
         9YtV60h4zWvcBnxHzRVrxOu1/WANFMOpHqd+NRvQPwW3xGiZbC71l3pRip2y+ZHftP4I
         URmQ==
X-Gm-Message-State: AOJu0YxVZNXA5I/2gIORvE/JtLSDW2fKhbMFVAolkFQggTt0MGjrNyVA
        tf2c2ukXq/G1RSOlt15PIhqoJTHA+ZM=
X-Google-Smtp-Source: AGHT+IGwcdJEfUk/OfNG1yBdtUEU6hlEffR2mhxDVSF5tsVq3uBIL2FdQ1z+Q3WKGIVD5J+CXt7b0qBhE3w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ae68:0:b0:584:6210:2e42 with SMTP id
 g40-20020a81ae68000000b0058462102e42mr21523ywk.4.1691184438464; Fri, 04 Aug
 2023 14:27:18 -0700 (PDT)
Date:   Fri, 4 Aug 2023 14:27:16 -0700
In-Reply-To: <ZMyJIq4CgXxudJED@chao-email>
Mime-Version: 1.0
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-12-weijiang.yang@intel.com> <ZMyJIq4CgXxudJED@chao-email>
Message-ID: <ZM1tNJ9ZdQb+VZVo@google.com>
Subject: Re: [PATCH v5 11/19] KVM:VMX: Emulate read and write to CET MSRs
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        peterz@infradead.org, john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com,
        binbin.wu@linux.intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 04, 2023, Chao Gao wrote:
> On Thu, Aug 03, 2023 at 12:27:24AM -0400, Yang Weijiang wrote:
> >Add emulation interface for CET MSR read and write.
> >The emulation code is split into common part and vendor specific
> >part, the former resides in x86.c to benefic different x86 CPU
> >vendors, the latter for VMX is implemented in this patch.
> >
> >Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> >---
> > arch/x86/kvm/vmx/vmx.c |  27 +++++++++++
> > arch/x86/kvm/x86.c     | 104 +++++++++++++++++++++++++++++++++++++----
> > arch/x86/kvm/x86.h     |  18 +++++++
> > 3 files changed, 141 insertions(+), 8 deletions(-)
> >
> >diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> >index 6aa76124e81e..ccf750e79608 100644
> >--- a/arch/x86/kvm/vmx/vmx.c
> >+++ b/arch/x86/kvm/vmx/vmx.c
> >@@ -2095,6 +2095,18 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> > 		else
> > 			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
> > 		break;
> >+	case MSR_IA32_S_CET:
> >+	case MSR_KVM_GUEST_SSP:
> >+	case MSR_IA32_INT_SSP_TAB:
> >+		if (kvm_get_msr_common(vcpu, msr_info))
> >+			return 1;
> >+		if (msr_info->index == MSR_KVM_GUEST_SSP)
> >+			msr_info->data = vmcs_readl(GUEST_SSP);
> >+		else if (msr_info->index == MSR_IA32_S_CET)
> >+			msr_info->data = vmcs_readl(GUEST_S_CET);
> >+		else if (msr_info->index == MSR_IA32_INT_SSP_TAB)
> >+			msr_info->data = vmcs_readl(GUEST_INTR_SSP_TABLE);
> 
> This if-else-if suggests that they are focibly grouped together to just
> share the call of kvm_get_msr_common(). For readability, I think it is better
> to handle them separately.
> 
> e.g.,
> 	case MSR_IA32_S_CET:
> 		if (kvm_get_msr_common(vcpu, msr_info))
> 			return 1;
> 		msr_info->data = vmcs_readl(GUEST_S_CET);
> 		break;
> 
> 	case MSR_KVM_GUEST_SSP:
> 		if (kvm_get_msr_common(vcpu, msr_info))
> 			return 1;
> 		msr_info->data = vmcs_readl(GUEST_SSP);
> 		break;

Actually, we can do even better.  We have an existing framework for these types
of prechecks, I just completely forgot about it :-(  (my "look at PAT" was a bad
suggestion).

Handle the checks in __kvm_set_msr() and __kvm_get_msr(), i.e. *before* calling
into vendor code.  Then vendor code doesn't need to make weird callbacks.

> > int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> > {
> > 	u32 msr = msr_info->index;
> >@@ -3981,6 +4014,45 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> > 		vcpu->arch.guest_fpu.xfd_err = data;
> > 		break;
> > #endif
> >+#define CET_EXCLUSIVE_BITS		(CET_SUPPRESS | CET_WAIT_ENDBR)
> >+#define CET_CTRL_RESERVED_BITS		GENMASK(9, 6)

Please use a single namespace for these #defines, e.g. CET_CTRL_* or maybe
CET_US_* for everything.

> >+#define CET_SHSTK_MASK_BITS		GENMASK(1, 0)
> >+#define CET_IBT_MASK_BITS		(GENMASK_ULL(5, 2) | \
> >+					 GENMASK_ULL(63, 10))
> >+#define CET_LEG_BITMAP_BASE(data)	((data) >> 12)

Bah, stupid SDM.  Please spell out "LEGACY", I though "LEG" was short for "LEGAL"
since this looks a lot like a page shift, i.e. getting a pfn.

> >+static bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu,
> >+				      struct msr_data *msr)
> >+{
> >+	if (is_shadow_stack_msr(msr->index)) {
> >+		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK))
> >+			return false;
> >+
> >+		if (msr->index == MSR_KVM_GUEST_SSP)
> >+			return msr->host_initiated;
> >+
> >+		return msr->host_initiated ||
> >+			guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
> >+	}
> >+
> >+	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
> >+	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
> >+		return false;
> >+
> >+	return msr->host_initiated ||
> >+		guest_cpuid_has(vcpu, X86_FEATURE_IBT) ||
> >+		guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);

Similar to my suggestsion for XSS, I think we drop the waiver for host_initiated
accesses, i.e. require the feature to be enabled and exposed to the guest, even
for the host.

> >diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> >index c69fc027f5ec..3b79d6db2f83 100644
> >--- a/arch/x86/kvm/x86.h
> >+++ b/arch/x86/kvm/x86.h
> >@@ -552,4 +552,22 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
> > 			 unsigned int port, void *data,  unsigned int count,
> > 			 int in);
> > 
> >+/*
> >+ * Guest xstate MSRs have been loaded in __msr_io(), disable preemption before
> >+ * access the MSRs to avoid MSR content corruption.
> >+ */
> 
> I think it is better to describe what the function does prior to jumping into
> details like where guest FPU is loaded.
> 
> /*
>  * Lock and/or reload guest FPU and access xstate MSRs. For accesses initiated
>  * by host, guest FPU is loaded in __msr_io(). For accesses initiated by guest,
>  * guest FPU should have been loaded already.
>  */
> >+static inline void kvm_get_xsave_msr(struct msr_data *msr_info)
> >+{
> >+	kvm_fpu_get();
> >+	rdmsrl(msr_info->index, msr_info->data);
> >+	kvm_fpu_put();
> >+}
> >+
> >+static inline void kvm_set_xsave_msr(struct msr_data *msr_info)
> >+{
> >+	kvm_fpu_get();
> >+	wrmsrl(msr_info->index, msr_info->data);
> >+	kvm_fpu_put();
> >+}
> 
> Can you rename functions to kvm_get/set_xstate_msr() to align with the comment
> and patch 6? And if there is no user outside x86.c, you can just put these two
> functions right after the is_xstate_msr() added in patch 6.

+1.  These should also assert that (a) guest FPU state is loaded and (b) the MSR
is passed through to the guest.  I might be ok dropping (b) if both VMX and SVM
passthrough all MSRs if they're exposed to the guest, i.e. not lazily passed
through.

Sans any changes to kvm_{g,s}et_xsave_msr(), I think this?  (completely untested)


---
 arch/x86/kvm/vmx/vmx.c |  34 +++-------
 arch/x86/kvm/x86.c     | 151 +++++++++++++++--------------------------
 2 files changed, 64 insertions(+), 121 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 491039aeb61b..1211eb469d06 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2100,16 +2100,13 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
 		break;
 	case MSR_IA32_S_CET:
+		msr_info->data = vmcs_readl(GUEST_S_CET);
+		break;
 	case MSR_KVM_GUEST_SSP:
+		msr_info->data = vmcs_readl(GUEST_SSP);
+		break;
 	case MSR_IA32_INT_SSP_TAB:
-		if (kvm_get_msr_common(vcpu, msr_info))
-			return 1;
-		if (msr_info->index == MSR_KVM_GUEST_SSP)
-			msr_info->data = vmcs_readl(GUEST_SSP);
-		else if (msr_info->index == MSR_IA32_S_CET)
-			msr_info->data = vmcs_readl(GUEST_S_CET);
-		else if (msr_info->index == MSR_IA32_INT_SSP_TAB)
-			msr_info->data = vmcs_readl(GUEST_INTR_SSP_TABLE);
+		msr_info->data = vmcs_readl(GUEST_INTR_SSP_TABLE);
 		break;
 	case MSR_IA32_DEBUGCTLMSR:
 		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
@@ -2432,25 +2429,14 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			vmx->pt_desc.guest.addr_a[index / 2] = data;
 		break;
-	case MSR_IA32_PL0_SSP ... MSR_IA32_PL2_SSP:
-		if (kvm_set_msr_common(vcpu, msr_info))
-			return 1;
-		if (data) {
-			vmx_disable_write_intercept_sss_msr(vcpu);
-			wrmsrl(msr_index, data);
-		}
-		break;
 	case MSR_IA32_S_CET:
+		vmcs_writel(GUEST_S_CET, data);
+		break;
 	case MSR_KVM_GUEST_SSP:
+		vmcs_writel(GUEST_SSP, data);
+		break;
 	case MSR_IA32_INT_SSP_TAB:
-		if (kvm_set_msr_common(vcpu, msr_info))
-			return 1;
-		if (msr_index == MSR_KVM_GUEST_SSP)
-			vmcs_writel(GUEST_SSP, data);
-		else if (msr_index == MSR_IA32_S_CET)
-			vmcs_writel(GUEST_S_CET, data);
-		else if (msr_index == MSR_IA32_INT_SSP_TAB)
-			vmcs_writel(GUEST_INTR_SSP_TABLE, data);
+		vmcs_writel(GUEST_INTR_SSP_TABLE, data);
 		break;
 	case MSR_IA32_PERF_CAPABILITIES:
 		if (data && !vcpu_to_pmu(vcpu)->version)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7385fc25a987..75e6de7c9268 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1838,6 +1838,11 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type)
 }
 EXPORT_SYMBOL_GPL(kvm_msr_allowed);
 
+#define CET_US_RESERVED_BITS		GENMASK(9, 6)
+#define CET_US_SHSTK_MASK_BITS		GENMASK(1, 0)
+#define CET_US_IBT_MASK_BITS		(GENMASK_ULL(5, 2) | GENMASK_ULL(63, 10))
+#define CET_US_LEGACY_BITMAP_BASE(data)	((data) >> 12)
+
 /*
  * Write @data into the MSR specified by @index.  Select MSR specific fault
  * checks are bypassed if @host_initiated is %true.
@@ -1897,6 +1902,35 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 
 		data = (u32)data;
 		break;
+	case MSR_IA32_U_CET:
+	case MSR_IA32_S_CET:
+		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK) &&
+		    !guest_can_use(vcpu, X86_FEATURE_IBT))
+		    	return 1;
+		if (data & CET_US_RESERVED_BITS)
+			return 1;
+		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK) &&
+		    (data & CET_US_SHSTK_MASK_BITS))
+			return 1;
+		if (!guest_can_use(vcpu, X86_FEATURE_IBT) &&
+		    (data & CET_US_IBT_MASK_BITS))
+			return 1;
+		if (!IS_ALIGNED(CET_US_LEGACY_BITMAP_BASE(data), 4))
+			return 1;
+
+		/* IBT can be suppressed iff the TRACKER isn't WAIT_ENDR. */
+		if ((data & CET_SUPPRESS) && (data & CET_WAIT_ENDBR))
+			return 1;
+		break;
+	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
+	case MSR_KVM_GUEST_SSP:
+		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK))
+			return 1;
+		if (is_noncanonical_address(data, vcpu))
+			return 1;
+		if (!IS_ALIGNED(data, 4))
+			return 1;
+		break;
 	}
 
 	msr.data = data;
@@ -1940,6 +1974,17 @@ static int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
 		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
 			return 1;
 		break;
+	case MSR_IA32_U_CET:
+	case MSR_IA32_S_CET:
+		if (!guest_can_use(vcpu, X86_FEATURE_IBT) &&
+		    !guest_can_use(vcpu, X86_FEATURE_SHSTK))
+			return 1;
+		break;
+	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
+	case MSR_KVM_GUEST_SSP:
+		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK))
+			return 1;
+		break;
 	}
 
 	msr.index = index;
@@ -3640,47 +3685,6 @@ static bool kvm_is_msr_to_save(u32 msr_index)
 	return false;
 }
 
-static inline bool is_shadow_stack_msr(u32 msr)
-{
-	return msr == MSR_IA32_PL0_SSP ||
-		msr == MSR_IA32_PL1_SSP ||
-		msr == MSR_IA32_PL2_SSP ||
-		msr == MSR_IA32_PL3_SSP ||
-		msr == MSR_IA32_INT_SSP_TAB ||
-		msr == MSR_KVM_GUEST_SSP;
-}
-
-static bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu,
-				      struct msr_data *msr)
-{
-	if (is_shadow_stack_msr(msr->index)) {
-		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK))
-			return false;
-
-		/*
-		 * This MSR is synthesized mainly for userspace access during
-		 * Live Migration, it also can be accessed in SMM mode by VMM.
-		 * Guest is not allowed to access this MSR.
-		 */
-		if (msr->index == MSR_KVM_GUEST_SSP) {
-			if (IS_ENABLED(CONFIG_X86_64) && is_smm(vcpu))
-				return true;
-
-			return msr->host_initiated;
-		}
-
-		return msr->host_initiated ||
-			guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
-	}
-
-	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
-	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
-		return false;
-
-	return msr->host_initiated ||
-		guest_cpuid_has(vcpu, X86_FEATURE_IBT) ||
-		guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
-}
 
 int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
@@ -4036,46 +4040,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vcpu->arch.guest_fpu.xfd_err = data;
 		break;
 #endif
-#define CET_EXCLUSIVE_BITS		(CET_SUPPRESS | CET_WAIT_ENDBR)
-#define CET_CTRL_RESERVED_BITS		GENMASK(9, 6)
-#define CET_SHSTK_MASK_BITS		GENMASK(1, 0)
-#define CET_IBT_MASK_BITS		(GENMASK_ULL(5, 2) | \
-					 GENMASK_ULL(63, 10))
-#define CET_LEG_BITMAP_BASE(data)	((data) >> 12)
 	case MSR_IA32_U_CET:
-	case MSR_IA32_S_CET:
-		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
-			return 1;
-		if (!!(data & CET_CTRL_RESERVED_BITS))
-			return 1;
-		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK) &&
-		    (data & CET_SHSTK_MASK_BITS))
-			return 1;
-		if (!guest_can_use(vcpu, X86_FEATURE_IBT) &&
-		    (data & CET_IBT_MASK_BITS))
-			return 1;
-		if (!IS_ALIGNED(CET_LEG_BITMAP_BASE(data), 4) ||
-		    (data & CET_EXCLUSIVE_BITS) == CET_EXCLUSIVE_BITS)
-			return 1;
-		if (msr == MSR_IA32_U_CET)
-			kvm_set_xsave_msr(msr_info);
-		break;
-	case MSR_KVM_GUEST_SSP:
-	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
-		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
-			return 1;
-		if (is_noncanonical_address(data, vcpu))
-			return 1;
-		if (!IS_ALIGNED(data, 4))
-			return 1;
-		if (msr == MSR_IA32_PL0_SSP || msr == MSR_IA32_PL1_SSP ||
-		    msr == MSR_IA32_PL2_SSP) {
-			vcpu->arch.cet_s_ssp[msr - MSR_IA32_PL0_SSP] = data;
-			if (!vcpu->arch.cet_sss_active && data)
-				vcpu->arch.cet_sss_active = true;
-		} else if (msr == MSR_IA32_PL3_SSP) {
-			kvm_set_xsave_msr(msr_info);
-		}
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+		kvm_set_xsave_msr(msr_info);
 		break;
 	default:
 		if (kvm_pmu_is_valid_msr(vcpu, msr))
@@ -4436,17 +4403,8 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 #endif
 	case MSR_IA32_U_CET:
-	case MSR_IA32_S_CET:
-	case MSR_KVM_GUEST_SSP:
-	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
-		if (!kvm_cet_is_msr_accessible(vcpu, msr_info))
-			return 1;
-		if (msr == MSR_IA32_PL0_SSP || msr == MSR_IA32_PL1_SSP ||
-		    msr == MSR_IA32_PL2_SSP) {
-			msr_info->data = vcpu->arch.cet_s_ssp[msr - MSR_IA32_PL0_SSP];
-		} else if (msr == MSR_IA32_U_CET || msr == MSR_IA32_PL3_SSP) {
-			kvm_get_xsave_msr(msr_info);
-		}
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+		kvm_get_xsave_msr(msr_info);
 		break;
 	default:
 		if (kvm_pmu_is_valid_msr(vcpu, msr))
@@ -7330,9 +7288,13 @@ static void kvm_probe_msr_to_save(u32 msr_index)
 		break;
 	case MSR_IA32_U_CET:
 	case MSR_IA32_S_CET:
+		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
+		    !kvm_cpu_cap_has(X86_FEATURE_IBT))
+			return;
+		break;
 	case MSR_KVM_GUEST_SSP:
 	case MSR_IA32_PL0_SSP ... MSR_IA32_INT_SSP_TAB:
-		if (!kvm_is_cet_supported())
+		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK))
 			return;
 		break;
 	default:
@@ -9664,13 +9626,8 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 		kvm_caps.supported_xcr0 = host_xcr0 & KVM_SUPPORTED_XCR0;
 	}
 	if (boot_cpu_has(X86_FEATURE_XSAVES)) {
-		u32 eax, ebx, ecx, edx;
-
-		cpuid_count(0xd, 1, &eax, &ebx, &ecx, &edx);
 		rdmsrl(MSR_IA32_XSS, host_xss);
 		kvm_caps.supported_xss = host_xss & KVM_SUPPORTED_XSS;
-		if (ecx & XFEATURE_MASK_CET_KERNEL)
-			kvm_caps.supported_xss |= XFEATURE_MASK_CET_KERNEL;
 	}
 
 	rdmsrl_safe(MSR_EFER, &host_efer);

base-commit: efb9177acd7a4df5883b844e1ec9c69ef0899c9c
-- 

