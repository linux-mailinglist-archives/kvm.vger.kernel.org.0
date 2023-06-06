Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0CA724958
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 18:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237361AbjFFQkp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 12:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbjFFQko (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 12:40:44 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 526A6E60
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 09:40:43 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-565ba5667d5so89906947b3.0
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 09:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686069642; x=1688661642;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CDHXe6/mXqOWQkeWC60ckAzzU5mVeJqLNCMLvLmgUos=;
        b=xhDTcceBwAw9Hs5SifWGC5faHwzclH50ckfhr+4ZttJgMnRdSwdWP59i2ZeVHRVvNN
         NQ2I6AxxNTUHDKNrbeoVw+nkD1Q4+6gU51HtkZiMwABvNhVDX+ioWikU0a6VsWiBCoHl
         zTEybfVeAEphjLcwjwGwRzeSvwr8pYARX9ec2lZkB7VQOyvc9ZtEZREYge2RlSiJSm+b
         H6bc6EHPyMpbk5BRCREhxXd8SRhb2gjTe+L5FTmyhWnZK6hBbeUq8J3GLXc7oPQQRvtx
         nkBSFr9Nw9ifdA4X4iDe09re0Dqv9PzOeBdVdKqLVTE3spemNoerz8dgDjzKLvYhyUAL
         D+bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686069642; x=1688661642;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CDHXe6/mXqOWQkeWC60ckAzzU5mVeJqLNCMLvLmgUos=;
        b=MbdDxuNw1m8yfSOfoUQ6cdzMsUYEMvACqlbZquVTXsPdvLVgTy2LVhXNUX2KuSi0Ka
         kaIKfGgPAIEoptOSPL6w3zPtGZn95mda15WpJPDcBtMnRE0jtu4a4BrzbnQRc+DX0d0f
         EHROz9ehb8Uvojg6BtSqCFkZiwe53hHRYDLAgjzKnZC5yEfTcfebm4pyJP4asrkGszdO
         /P+8QeX4AXhRlW0Z2IA+FrL1yxSfK/xArULzoYVvObSG3AkU7QgCRD3oR3ohb/UM64Nx
         qwu5xsIed6Dp5EpCa+vm9iMThfEXNrp0xBG7PNoClSaj2SakgvNDA6WUkAlpe74LLOmk
         op6g==
X-Gm-Message-State: AC+VfDzEktFh4xjH89a3A3hiPgFaDjlW5VT+lsNO4+lQxs1I1kLz/nd8
        CCTTER/k3jfTNVvyLTC+3eq6igBtBoE=
X-Google-Smtp-Source: ACHHUZ7YfN+4stEUN8h1tykFk/Ez/hVtkSfng+Y2nfGVFX0HgWdJ2ji8gf0BFxO78aNTgD4sEMFEFR3Smcs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ac08:0:b0:552:d924:a304 with SMTP id
 k8-20020a81ac08000000b00552d924a304mr1325753ywh.4.1686069642539; Tue, 06 Jun
 2023 09:40:42 -0700 (PDT)
Date:   Tue, 6 Jun 2023 09:40:40 -0700
In-Reply-To: <20230524061634.54141-2-chao.gao@intel.com>
Mime-Version: 1.0
References: <20230524061634.54141-1-chao.gao@intel.com> <20230524061634.54141-2-chao.gao@intel.com>
Message-ID: <ZH9hiCWupvMS40Eu@google.com>
Subject: Re: [PATCH v2 1/3] KVM: x86: Track supported ARCH_CAPABILITIES in kvm_caps
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, xiaoyao.li@intel.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 24, 2023, Chao Gao wrote:
> @@ -9532,6 +9532,7 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>  		kvm_caps.max_guest_tsc_khz = max;
>  	}
>  	kvm_caps.default_tsc_scaling_ratio = 1ULL << kvm_caps.tsc_scaling_ratio_frac_bits;
> +	kvm_caps.supported_arch_cap = kvm_get_arch_capabilities();
>  	kvm_init_msr_lists();
>  	return 0;
>  
> @@ -11895,7 +11896,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	if (r)
>  		goto free_guest_fpu;
>  
> -	vcpu->arch.arch_capabilities = kvm_get_arch_capabilities();
> +	vcpu->arch.arch_capabilities = kvm_caps.supported_arch_cap;
>  	vcpu->arch.msr_platform_info = MSR_PLATFORM_INFO_CPUID_FAULT;
>  	kvm_xen_init_vcpu(vcpu);
>  	kvm_vcpu_mtrr_init(vcpu);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index c544602d07a3..d3e524bcc169 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -29,6 +29,7 @@ struct kvm_caps {
>  	u64 supported_xcr0;
>  	u64 supported_xss;
>  	u64 supported_perf_cap;
> +	u64 supported_arch_cap;

Hrm, I take back my earlier vote about using a dynamic snapshot.

"supported" isn't quite right.  KVM always "supports" advertising SKIP_VMENTRY_L1DFLUSH
to the guest.  And KVM really does treat the MSR like a CPUID leaf, in that KVM
doesn't sanity check the value coming in from userspace.  Whether or not that's
a good idea is debatable, but it is was it is.  The value is more like KVM's current
default.

Looking at all the uses of both the default/supported value, and the host MSR,
I think it makes more sense to snapshot the host value than it does to snapshot
and update the default/supported value.  The default value is used only when a
vCPU is created and when userspace does a system-scoped KVM_GET_MSRS, i.e. avoiding
the RDMSR is nice, but making the read super fast isn't necessary, e.g. the overhead
of the boot_cpu_has() and boot_cpu_has_bug() checks is negligible.

And if KVM snapshots the MSR, the other usage of the host value can be cleaned up
too.

I'm leaning towards doing this instead of patches [1/3] and [3/3]:

From: Sean Christopherson <seanjc@google.com>
Date: Tue, 6 Jun 2023 09:20:31 -0700
Subject: [PATCH 1/2] KVM: x86: Snapshot host's MSR_IA32_ARCH_CAPABILITIES

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 22 ++++++----------------
 arch/x86/kvm/x86.c     | 13 +++++++------
 arch/x86/kvm/x86.h     |  1 +
 3 files changed, 14 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2d9d155691a7..42d1148f933c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -255,14 +255,9 @@ static int vmx_setup_l1d_flush(enum vmx_l1d_flush_state l1tf)
 		return 0;
 	}
 
-	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES)) {
-		u64 msr;
-
-		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, msr);
-		if (msr & ARCH_CAP_SKIP_VMENTRY_L1DFLUSH) {
-			l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_NOT_REQUIRED;
-			return 0;
-		}
+	if (host_arch_capabilities & ARCH_CAP_SKIP_VMENTRY_L1DFLUSH) {
+		l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_NOT_REQUIRED;
+		return 0;
 	}
 
 	/* If set to auto use the default l1tf mitigation method */
@@ -373,15 +368,10 @@ static int vmentry_l1d_flush_get(char *s, const struct kernel_param *kp)
 
 static void vmx_setup_fb_clear_ctrl(void)
 {
-	u64 msr;
-
-	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES) &&
+	if ((host_arch_capabilities & ARCH_CAP_FB_CLEAR_CTRL) &&
 	    !boot_cpu_has_bug(X86_BUG_MDS) &&
-	    !boot_cpu_has_bug(X86_BUG_TAA)) {
-		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, msr);
-		if (msr & ARCH_CAP_FB_CLEAR_CTRL)
-			vmx_fb_clear_ctrl_available = true;
-	}
+	    !boot_cpu_has_bug(X86_BUG_TAA))
+		vmx_fb_clear_ctrl_available = true;
 }
 
 static __always_inline void vmx_disable_fb_clear(struct vcpu_vmx *vmx)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7c7be4815eaa..7c2e796fa460 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -237,6 +237,9 @@ EXPORT_SYMBOL_GPL(enable_apicv);
 u64 __read_mostly host_xss;
 EXPORT_SYMBOL_GPL(host_xss);
 
+u64 __read_mostly host_arch_capabilities;
+EXPORT_SYMBOL_GPL(host_arch_capabilities);
+
 const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_GENERIC_VM_STATS(),
 	STATS_DESC_COUNTER(VM, mmu_shadow_zapped),
@@ -1612,12 +1615,7 @@ static bool kvm_is_immutable_feature_msr(u32 msr)
 
 static u64 kvm_get_arch_capabilities(void)
 {
-	u64 data = 0;
-
-	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES)) {
-		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, data);
-		data &= KVM_SUPPORTED_ARCH_CAP;
-	}
+	u64 data = host_arch_capabilities & KVM_SUPPORTED_ARCH_CAP;
 
 	/*
 	 * If nx_huge_pages is enabled, KVM's shadow paging will ensure that
@@ -9492,6 +9490,9 @@ static int __kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 
 	kvm_init_pmu_capability(ops->pmu_ops);
 
+	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
+		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, host_arch_capabilities);
+
 	r = ops->hardware_setup();
 	if (r != 0)
 		goto out_mmu_exit;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 82e3dafc5453..1e7be1f6ab29 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -323,6 +323,7 @@ fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
 
 extern u64 host_xcr0;
 extern u64 host_xss;
+extern u64 host_arch_capabilities;
 
 extern struct kvm_caps kvm_caps;
 

base-commit: 02f1b0b736606f9870595b3089d9c124f9da8be9
-- 
2.41.0.rc2.161.g9c6817b8e7-goog

From bd4b41fea5d5fa0347c5ef1ffb73dbdf783b23d0 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 6 Jun 2023 09:25:55 -0700
Subject: [PATCH 2/2] KVM: VMX: Drop unnecessary vmx_fb_clear_ctrl_available
 "cache"

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 42d1148f933c..17003660138a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -237,9 +237,6 @@ static const struct {
 #define L1D_CACHE_ORDER 4
 static void *vmx_l1d_flush_pages;
 
-/* Control for disabling CPU Fill buffer clear */
-static bool __read_mostly vmx_fb_clear_ctrl_available;
-
 static int vmx_setup_l1d_flush(enum vmx_l1d_flush_state l1tf)
 {
 	struct page *page;
@@ -366,14 +363,6 @@ static int vmentry_l1d_flush_get(char *s, const struct kernel_param *kp)
 	return sprintf(s, "%s\n", vmentry_l1d_param[l1tf_vmx_mitigation].option);
 }
 
-static void vmx_setup_fb_clear_ctrl(void)
-{
-	if ((host_arch_capabilities & ARCH_CAP_FB_CLEAR_CTRL) &&
-	    !boot_cpu_has_bug(X86_BUG_MDS) &&
-	    !boot_cpu_has_bug(X86_BUG_TAA))
-		vmx_fb_clear_ctrl_available = true;
-}
-
 static __always_inline void vmx_disable_fb_clear(struct vcpu_vmx *vmx)
 {
 	u64 msr;
@@ -399,7 +388,9 @@ static __always_inline void vmx_enable_fb_clear(struct vcpu_vmx *vmx)
 
 static void vmx_update_fb_clear_dis(struct kvm_vcpu *vcpu, struct vcpu_vmx *vmx)
 {
-	vmx->disable_fb_clear = vmx_fb_clear_ctrl_available;
+	vmx->disable_fb_clear = (host_arch_capabilities & ARCH_CAP_FB_CLEAR_CTRL) &&
+				!boot_cpu_has_bug(X86_BUG_MDS) &&
+				!boot_cpu_has_bug(X86_BUG_TAA);
 
 	/*
 	 * If guest will not execute VERW, there is no need to set FB_CLEAR_DIS
@@ -8580,8 +8571,6 @@ static int __init vmx_init(void)
 	if (r)
 		goto err_l1d_flush;
 
-	vmx_setup_fb_clear_ctrl();
-
 	for_each_possible_cpu(cpu) {
 		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
 
-- 



