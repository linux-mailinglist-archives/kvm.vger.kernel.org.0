Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35571770578
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 18:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbjHDQCl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 12:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjHDQCk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 12:02:40 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0212F46B1
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 09:02:38 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d07cb52a768so2435297276.1
        for <kvm@vger.kernel.org>; Fri, 04 Aug 2023 09:02:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691164957; x=1691769757;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cuCBtoQdI93dHT+cZwGP8pXvIQr2Syt9WOhIw05rJFI=;
        b=j5VnIqwSoLckq3DYeEJA9MUnThstOKIAeTrJ2DJibvxhFLyDAdlWfMFXfokliUo+AF
         tyBnFkvVavmJwINoQFtyLs+lt+2vl3DFqO0ZIk5puTPFAS27D5iL8Juyq6tXU+CQ9d8T
         Fgin9GD7L43wzl5OKADswzZ+xWQz72Es868+eVrM5+7YeuTyVjcU6XORU9DLoM8uvlEw
         OLvJV9FLLl9qskaB3LykUJL15fQvv5zAwasBEjQ/cHi5y6AtYPDylW9jYhjKD0Wv9RRr
         u1nhCTxbE5SKB3/Ri7uuRReR+ii3OF3Q0Q0GGhKGXPTVsPk9sxgveRHUd5Z/GeTmltWf
         PbqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691164957; x=1691769757;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cuCBtoQdI93dHT+cZwGP8pXvIQr2Syt9WOhIw05rJFI=;
        b=mBSra8XBO9rQHyZZbB1wUW8bIsHLx8Pxe1AvJ4ZNkaecSqxHMo2YREWl5zM+teQYSF
         +8Ah05ACTWzlpBTHS2LZv/TMJJFRTENspbr2IbJOTJysIMmmuj4ci1ogpEu+92J5bGyt
         TgduCvCaFZN6YcGNbns+Cqu3XpS5Lv2WMF1/oKzeskxdt9/9zIEEGVyZ1LETZIQPfPo5
         JbqfbMCAF5/hs6KQQusuNhnf/rQ3k62Y245PoLqZHiuc5no3toTACLH/3nPyblbsqJph
         MeDw1+bPu7SytE9wnmsWY/KY33wNbu/Kmc4d2q+hdhqSyOarwLSaEzEcdI66ujR2Qo5h
         IdaQ==
X-Gm-Message-State: AOJu0YzypExQGZlmsyYYov+KFQnRSxxwKABj+xQf+Z80ez2ZJJaD74uF
        PXqgRcbbZDwXd9c0fPdUdiVVR+sG9mY=
X-Google-Smtp-Source: AGHT+IHYUxUlo5rz82mD8KV7ITNLs34kQJKSqyy2f82gkbp9HL8WYSMDX0mX28/OucVaQDC3e8vyXuDwGWM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:f80b:0:b0:d3f:cfa:2350 with SMTP id
 u11-20020a25f80b000000b00d3f0cfa2350mr12714ybd.10.1691164957224; Fri, 04 Aug
 2023 09:02:37 -0700 (PDT)
Date:   Fri, 4 Aug 2023 09:02:35 -0700
In-Reply-To: <20230803042732.88515-5-weijiang.yang@intel.com>
Mime-Version: 1.0
References: <20230803042732.88515-1-weijiang.yang@intel.com> <20230803042732.88515-5-weijiang.yang@intel.com>
Message-ID: <ZM0hG7Pn/fkGruWu@google.com>
Subject: Re: [PATCH v5 04/19] KVM:x86: Refresh CPUID on write to guest MSR_IA32_XSS
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, peterz@infradead.org, john.allen@amd.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rick.p.edgecombe@intel.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 03, 2023, Yang Weijiang wrote:
> Update CPUID(EAX=0DH,ECX=1) when the guest's XSS is modified.
> CPUID(EAX=0DH,ECX=1).EBX reports required storage size of
> all enabled xstate features in XCR0 | XSS. Guest can allocate
> sufficient xsave buffer based on the info.

Please wrap changelogs closer to ~75 chars.  I'm pretty sure this isn't the first
time I've made this request...

> Note, KVM does not yet support any XSS based features, i.e.
> supported_xss is guaranteed to be zero at this time.
> 
> Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/cpuid.c            | 20 ++++++++++++++++++--
>  arch/x86/kvm/x86.c              |  8 +++++---
>  3 files changed, 24 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 28bd38303d70..20bbcd95511f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -804,6 +804,7 @@ struct kvm_vcpu_arch {
>  
>  	u64 xcr0;
>  	u64 guest_supported_xcr0;
> +	u64 guest_supported_xss;
>  
>  	struct kvm_pio_request pio;
>  	void *pio_data;
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 7f4d13383cf2..0338316b827c 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -249,6 +249,17 @@ static u64 cpuid_get_supported_xcr0(struct kvm_cpuid_entry2 *entries, int nent)
>  	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
>  }
>  
> +static u64 cpuid_get_supported_xss(struct kvm_cpuid_entry2 *entries, int nent)
> +{
> +	struct kvm_cpuid_entry2 *best;
> +
> +	best = cpuid_entry2_find(entries, nent, 0xd, 1);
> +	if (!best)
> +		return 0;
> +
> +	return (best->ecx | ((u64)best->edx << 32)) & kvm_caps.supported_xss;
> +}
> +
>  static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *entries,
>  				       int nent)
>  {
> @@ -276,8 +287,11 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
>  
>  	best = cpuid_entry2_find(entries, nent, 0xD, 1);
>  	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
> -		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
> -		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
> +		     cpuid_entry_has(best, X86_FEATURE_XSAVEC))) {
> +		u64 xstate = vcpu->arch.xcr0 | vcpu->arch.ia32_xss;

Nit, the variable should be xfeatures, not xstate.  Though I vote to avoid the
variable entirely,

	best = cpuid_entry2_find(entries, nent, 0xD, 1);
	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
		best->ebx = xstate_required_size(vcpu->arch.xcr0 |
						 vcpu->arch.ia32_xss, true);

though it's only a slight preference, i.e. feel free to keep your approach if
you or others feel strongly about the style.

> +	}
>  
>  	best = __kvm_find_kvm_cpuid_features(vcpu, entries, nent);
>  	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
> @@ -325,6 +339,8 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>  
>  	vcpu->arch.guest_supported_xcr0 =
>  		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
> +	vcpu->arch.guest_supported_xss =
> +		cpuid_get_supported_xss(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);

Blech.  I tried to clean up this ugly, but Paolo disagreed[*].  Can you fold in
the below (compile tested only) patch at the very beginning of this series?  It
implements my suggested alternative.  And then this would become:

static u64 vcpu_get_supported_xss(struct kvm_vcpu *vcpu)
{
	struct kvm_cpuid_entry2 *best;

	best = kvm_find_cpuid_entry_index(vcpu, 0xd, 1);
	if (!best)
		return 0;

	return (best->ecx | ((u64)best->edx << 32)) & kvm_caps.supported_xss;
}

[*] https://lore.kernel.org/all/ZGfius5UkckpUyXl@google.com

>  	/*
>  	 * FP+SSE can always be saved/restored via KVM_{G,S}ET_XSAVE, even if
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0b9033551d8c..5d6d6fa33e5b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3780,10 +3780,12 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		 * IA32_XSS[bit 8]. Guests have to use RDMSR/WRMSR rather than
>  		 * XSAVES/XRSTORS to save/restore PT MSRs.
>  		 */
> -		if (data & ~kvm_caps.supported_xss)
> +		if (data & ~vcpu->arch.guest_supported_xss)
>  			return 1;
> -		vcpu->arch.ia32_xss = data;
> -		kvm_update_cpuid_runtime(vcpu);
> +		if (vcpu->arch.ia32_xss != data) {
> +			vcpu->arch.ia32_xss = data;
> +			kvm_update_cpuid_runtime(vcpu);
> +		}

Nit, I prefer this style:

		if (vcpu->arch.ia32_xss == data)
			break;

		vcpu->arch.ia32_xss = data;
		kvm_update_cpuid_runtime(vcpu);

so that the common path isn't buried in an if-statement.

>  		break;
>  	case MSR_SMI_COUNT:
>  		if (!msr_info->host_initiated)
> -- 


From: Sean Christopherson <seanjc@google.com>
Date: Fri, 4 Aug 2023 08:48:03 -0700
Subject: [PATCH] KVM: x86: Rework cpuid_get_supported_xcr0() to operate on
 vCPU data

Rework and rename cpuid_get_supported_xcr0() to explicitly operate on vCPU
state, i.e. on a vCPU's CPUID state.  Prior to commit 275a87244ec8 ("KVM:
x86: Don't adjust guest's CPUID.0x12.1 (allowed SGX enclave XFRM)"), KVM
incorrectly fudged guest CPUID at runtime, which in turn necessitated
massaging the incoming CPUID state for KVM_SET_CPUID{2} so as not to run
afoul of kvm_cpuid_check_equal().

Opportunistically move the helper below kvm_update_cpuid_runtime() to make
it harder to repeat the mistake of querying supported XCR0 for runtime
updates.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 7f4d13383cf2..5e42846c948a 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -234,21 +234,6 @@ void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
 		vcpu->arch.pv_cpuid.features = best->eax;
 }
 
-/*
- * Calculate guest's supported XCR0 taking into account guest CPUID data and
- * KVM's supported XCR0 (comprised of host's XCR0 and KVM_SUPPORTED_XCR0).
- */
-static u64 cpuid_get_supported_xcr0(struct kvm_cpuid_entry2 *entries, int nent)
-{
-	struct kvm_cpuid_entry2 *best;
-
-	best = cpuid_entry2_find(entries, nent, 0xd, 0);
-	if (!best)
-		return 0;
-
-	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
-}
-
 static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *entries,
 				       int nent)
 {
@@ -299,6 +284,21 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_update_cpuid_runtime);
 
+/*
+ * Calculate guest's supported XCR0 taking into account guest CPUID data and
+ * KVM's supported XCR0 (comprised of host's XCR0 and KVM_SUPPORTED_XCR0).
+ */
+static u64 vcpu_get_supported_xcr0(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid_entry2 *best;
+
+	best = kvm_find_cpuid_entry_index(vcpu, 0xd, 0);
+	if (!best)
+		return 0;
+
+	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
+}
+
 static bool kvm_cpuid_has_hyperv(struct kvm_cpuid_entry2 *entries, int nent)
 {
 	struct kvm_cpuid_entry2 *entry;
@@ -323,8 +323,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		kvm_apic_set_version(vcpu);
 	}
 
-	vcpu->arch.guest_supported_xcr0 =
-		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
+	vcpu->arch.guest_supported_xcr0 = vcpu_get_supported_xcr0(vcpu);
 
 	/*
 	 * FP+SSE can always be saved/restored via KVM_{G,S}ET_XSAVE, even if

base-commit: f0147fcfab840fe9a3f03e9645d25c1326373fe6
-- 

