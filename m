Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B87E58547A
	for <lists+kvm@lfdr.de>; Fri, 29 Jul 2022 19:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237685AbiG2R2V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Jul 2022 13:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237298AbiG2R2T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Jul 2022 13:28:19 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409EE11811
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 10:28:18 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id c3so5167054pfb.13
        for <kvm@vger.kernel.org>; Fri, 29 Jul 2022 10:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=i2DBZrmp1kG353wRp96OgDU8tzPdFdzK0pwSzpxJdZc=;
        b=tVwRBWf78Wbh6/fPKmOlTPNDHU3CtchgusUguhARSF1nK1Ajl6bZcHNVrq+AIZanL5
         0oe1+ifvnRQZH5Hzr1dkyH6tJZjwNOrFwxSiFM57vXE3ZzUXaVHe2FzTjk0CfCzf+3bX
         RbDTAwEIXN7ofyk8vIcof72+TXql0JZEwMAJ7vIBzs12O1Y/Dm80jeZkMZ0zOuUrGA+d
         ec+ZmkIhNadLbrKsGMQ6e29uaoprUH5Uivk/iawP3pkAgvWw6Dgz4tKV3Go39oE1NaaF
         EZqAoPS0ReMyQIK6E4S8U8e890s3DOvLLspty8+dQKobbqX3rvR4HNPcOvs+mM1Fw7a7
         nHuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=i2DBZrmp1kG353wRp96OgDU8tzPdFdzK0pwSzpxJdZc=;
        b=2F6DM/KiQGT1BXvbJi+jUsu/HspPBoiD1kRu7vSEN1wat+0LBHpKvf5YQ9WB2kO05j
         0M2RsbjbjeRnW1zdysQIwqzRw7vPM5zFTUHgmhe+SdxiVi1RJlmXBXMD5hfneIofLORB
         N4/u6diW0JBi1M0Ycvwb24MWTS6m5+j133sdrrNLOy+67hwa8WNBFE2DVPsJjnoFYg3h
         3ny6qXvSNjuOyP5ceK9+ZOTEy8Hm8PjhP0peQn1xc420AgIZo8u5XdOuZtq97QjsOkCl
         6zd9ob7ssuzpCUobjqWMT5XKmzMUmpO7S7VGX14I4+NpdzqS1mq/YDkCElfs5Xp5T5TZ
         eyfg==
X-Gm-Message-State: AJIora+3tiGHsviJVmk67NlQh1dz76lS+LTLtSUWC6hp/s8dlRaKPaMQ
        14PJzPY+JlgGT+QzC5+YFHTbBQ==
X-Google-Smtp-Source: AGRyM1vHJN8qYtPdiXH7MyYyyOd3p95/ovUuMPEQUsqsWZ3fHGRxiHuDWhHAoR7vwoHIs12YOhRMbg==
X-Received: by 2002:a63:fd14:0:b0:41a:20e8:c1e2 with SMTP id d20-20020a63fd14000000b0041a20e8c1e2mr3760595pgh.286.1659115697490;
        Fri, 29 Jul 2022 10:28:17 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 139-20020a621991000000b0050dc76281e0sm3126784pfz.186.2022.07.29.10.28.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 10:28:16 -0700 (PDT)
Date:   Fri, 29 Jul 2022 17:28:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] KVM: VMX: Adjust number of LBR records for
 PERF_CAPABILITIES at refresh
Message-ID: <YuQYrBhJB1rNxkyp@google.com>
References: <20220727233424.2968356-1-seanjc@google.com>
 <20220727233424.2968356-4-seanjc@google.com>
 <2d932ad7-899b-ed26-d77c-f149fb2afc36@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="dx/GFEplJzZRgpXz"
Content-Disposition: inline
In-Reply-To: <2d932ad7-899b-ed26-d77c-f149fb2afc36@gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--dx/GFEplJzZRgpXz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 29, 2022, Like Xu wrote:
> On 28/7/2022 7:34 am, Sean Christopherson wrote:
> > guest_cpuid_has() is expensive due to the linear search of guest CPUID
> > entries, intel_pmu_lbr_is_enabled() is checked on every VM-Enter,_and_
> > simply enumerating the same "Model" as the host causes KVM to set the
> > number of LBR records to a non-zero value.
> 
> Before reconsidering vcpu->arch.perf_capabilities to reach a conclusion,
> how about this minor inline change help reduce my sins ?
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 0ecbbae42976..06a21d66be13 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7039,7 +7039,8 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  	pt_guest_enter(vmx);
> 
>  	atomic_switch_perf_msrs(vmx);
> -	if (intel_pmu_lbr_is_enabled(vcpu))
> +	if (vmx->lbr_desc.records.nr &&
> +	    (vcpu->arch.perf_capabilities & PMU_CAP_LBR_FMT))

That doesn't do the right thing if X86_FEATURE_PDCM is cleared in guest CPUID.
It doesn't even require odd userspace behavior since intel_pmu_init() does:

	vcpu->arch.perf_capabilities = vmx_get_perf_capabilities();

E.g. older userspace that doesn't set MSR_IA32_PERF_CAPABILITIES will clear PDCM
without touching the vCPU's MSR value.

In the unlikely scenario we can't figure out a solution for PERF_CAPABILITIES,
the alternative I tried first is to implement a generic CPUID feature "caching"
scheme and use it to expedite the PDCM lookup.  I scrapped that approach when I
realized that KVM really should be able to consume PERF_CAPABILITIES during PMU
refresh.

I'm hesitant to even suggest a generic caching implementation because I suspect 
most performance critical uses of guest CPUID will be similar to PDMC, i.e. can
be captured during KVM_SET_CPUID2 without requiring an explicit cache.  And for
PERF_CAPABILITIES, IMO a robust implementation is a must have, i.e. we've failed
if we can't handle it during PMU refresh.

--dx/GFEplJzZRgpXz
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-x86-Add-CPUID-cache-for-frequent-X86_FEATURE_-gu.patch"

From 2b5621e0a504c821125d24475ee83d9e1cf24e96 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 26 Jul 2022 09:20:37 -0700
Subject: [PATCH 1/2] KVM: x86: Add CPUID cache for frequent X86_FEATURE_*
 guest lookups

Implement a small "cache" for expediting guest_cpuid_has() lookups of
frequently used features.  Guest CPUID lookups are slow, especially if
the associated leaf has no entry, as KVM uses a linear walk of all CPUID
entries to find the associated leaf, e.g. adding a guest_cpuid_has()
lookup in the VM-Enter path is slow enough that it shows up on perf
traces.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/cpuid.c            |  9 +++++++++
 arch/x86/kvm/cpuid.h            | 28 ++++++++++++++++++++++++++--
 3 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e8281d64a431..8cdb5c46815d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -759,6 +759,7 @@ struct kvm_vcpu_arch {
 	int cpuid_nent;
 	struct kvm_cpuid_entry2 *cpuid_entries;
 	u32 kvm_cpuid_base;
+	u32 kvm_cpuid_x86_feature_cache;
 
 	u64 reserved_gpa_bits;
 	int maxphyaddr;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 75dcf7a72605..27b25fdb4335 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -377,6 +377,12 @@ u64 kvm_vcpu_reserved_gpa_bits_raw(struct kvm_vcpu *vcpu)
 	return rsvd_bits(cpuid_maxphyaddr(vcpu), 63);
 }
 
+#define kvm_cpuid_cache_update(__vcpu, x86_feature)						\
+do {												\
+	if (__guest_cpuid_has(__vcpu, x86_feature))						\
+		(__vcpu)->arch.kvm_cpuid_x86_feature_cache |= BIT(KVM_CACHED_ ## x86_feature);	\
+} while (0)
+
 static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
                         int nent)
 {
@@ -412,6 +418,9 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 	vcpu->arch.cpuid_entries = e2;
 	vcpu->arch.cpuid_nent = nent;
 
+	/* Update the cache before doing anything else. */
+	vcpu->arch.kvm_cpuid_x86_feature_cache = 0;
+
 	kvm_update_kvm_cpuid_base(vcpu);
 	kvm_vcpu_after_set_cpuid(vcpu);
 
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index b1658c0de847..49009d16022a 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -85,8 +85,21 @@ static __always_inline u32 *guest_cpuid_get_register(struct kvm_vcpu *vcpu,
 	return __cpuid_entry_get_reg(entry, cpuid.reg);
 }
 
-static __always_inline bool guest_cpuid_has(struct kvm_vcpu *vcpu,
-					    unsigned int x86_feature)
+enum kvm_cpuid_cached_feature {
+	NR_KVM_CACHED_X86_FEATURES,
+};
+
+static __always_inline int guest_cpuid_get_cache_bit(unsigned int x86_feature)
+{
+	int cache_bytes = sizeof((struct kvm_vcpu_arch *)0)->kvm_cpuid_x86_feature_cache;
+
+	BUILD_BUG_ON(NR_KVM_CACHED_X86_FEATURES > cache_bytes * BITS_PER_BYTE);
+
+	return NR_KVM_CACHED_X86_FEATURES;
+}
+
+static __always_inline bool __guest_cpuid_has(struct kvm_vcpu *vcpu,
+					      unsigned int x86_feature)
 {
 	u32 *reg;
 
@@ -97,6 +110,17 @@ static __always_inline bool guest_cpuid_has(struct kvm_vcpu *vcpu,
 	return *reg & __feature_bit(x86_feature);
 }
 
+static __always_inline bool guest_cpuid_has(struct kvm_vcpu *vcpu,
+					    unsigned int x86_feature)
+{
+	int cache_bit = guest_cpuid_get_cache_bit(x86_feature);
+
+	if (cache_bit != NR_KVM_CACHED_X86_FEATURES)
+		return vcpu->arch.kvm_cpuid_x86_feature_cache & BIT(cache_bit);
+
+	return __guest_cpuid_has(vcpu, x86_feature);
+}
+
 static __always_inline void guest_cpuid_clear(struct kvm_vcpu *vcpu,
 					      unsigned int x86_feature)
 {

base-commit: 1a4d88a361af4f2e91861d632c6a1fe87a9665c2
-- 
2.37.1.455.g008518b4e5-goog


--dx/GFEplJzZRgpXz
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-KVM-x86-Cache-guest-CPUID-s-PDMC-for-fast-lookup.patch"

From fd2d041407ce8c3c8c643d9d64c63a8a05ba85af Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 26 Jul 2022 09:37:49 -0700
Subject: [PATCH 2/2] KVM: x86: Cache guest CPUID's PDMC for fast lookup

Add a cache entry for X86_FEATURE_PDCM to allow for expedited lookups.
For all intents and purposes, VMX queries X86_FEATURE_PDCM by default on
every VM-Enter.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 1 +
 arch/x86/kvm/cpuid.h | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 27b25fdb4335..fd32fddd7bc1 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -420,6 +420,7 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 
 	/* Update the cache before doing anything else. */
 	vcpu->arch.kvm_cpuid_x86_feature_cache = 0;
+	kvm_cpuid_cache_update(vcpu, X86_FEATURE_PDCM);
 
 	kvm_update_kvm_cpuid_base(vcpu);
 	kvm_vcpu_after_set_cpuid(vcpu);
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 49009d16022a..65114cf7742e 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -86,6 +86,7 @@ static __always_inline u32 *guest_cpuid_get_register(struct kvm_vcpu *vcpu,
 }
 
 enum kvm_cpuid_cached_feature {
+	KVM_CACHED_X86_FEATURE_PDCM,
 	NR_KVM_CACHED_X86_FEATURES,
 };
 
@@ -95,6 +96,10 @@ static __always_inline int guest_cpuid_get_cache_bit(unsigned int x86_feature)
 
 	BUILD_BUG_ON(NR_KVM_CACHED_X86_FEATURES > cache_bytes * BITS_PER_BYTE);
 
+	/* Use a "dumb" if statement, this is all resolved at compile time. */
+	if (x86_feature == X86_FEATURE_PDCM)
+		return KVM_CACHED_X86_FEATURE_PDCM;
+
 	return NR_KVM_CACHED_X86_FEATURES;
 }
 
-- 
2.37.1.455.g008518b4e5-goog


--dx/GFEplJzZRgpXz--
