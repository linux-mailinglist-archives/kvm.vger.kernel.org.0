Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 165DA65D7BA
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 16:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239755AbjADP7U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 10:59:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239752AbjADP7K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 10:59:10 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E1513F54
        for <kvm@vger.kernel.org>; Wed,  4 Jan 2023 07:59:09 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id v3so22508222pgh.4
        for <kvm@vger.kernel.org>; Wed, 04 Jan 2023 07:59:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cee0Ydp1kO8u9xvcfzgAFfEixnJwANHVFnUtawqlX6A=;
        b=RYSfNU7f19kuYS+NK9ORiTJ2YFf+MpKbJu6OJ1dC7hGiGBzmsADpOpXN9ixPxSJXqi
         eeVmOEMI6ITcl6AAk5C9EoFRE0J+mFglb/nsjL50aeuS7IRBUB4AutID7OoqujFAZzni
         dzssnwes+Te0Kf1uQGeJT25TQMPVHfeLtePh5t2JWPwsbgQAIeYiHmVYA6wjWYlKS9B/
         d+R0Y5lpM8d8dM/wIZ77Bi4OFNDSadKoJfvzzfLOcrAEfPSOD1LiC6G1K+CXPaHb2hOI
         sVhwmeRdg55weYnDlKH1eBMIb+loLBfW45choQ5IT6ZwA2a1wVgZujDMteplLyj+xJPE
         M8yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cee0Ydp1kO8u9xvcfzgAFfEixnJwANHVFnUtawqlX6A=;
        b=GaoN0W5nzfDUU5Lkn8w0irMxzjgANuNfjulZ1QtHbrRVPU7HclWq/QSv1/vEKx9h7C
         AFlE22soTFYzK6C8ZOZ7lNbs7GMSZ7nPmUMnxkmSTQdq4C2nUl1biTjEklS+3S5bq7YH
         ocMT1E4bf0D3kqljwdSMtG3W77PKvAioZ2h04Vvv3p2izFEKqEECWPEAaRF9c0jHnvRy
         TTNCQv4kPOoYU9SUOMHPvKn0yMwFsdPpjiAySZ9nt0N8xsbXhc9SVzcYVicMNvexbNkw
         mp3g8d0muTCOJkPUIpvDaFs/Q8B+WvihdmIm5FONx44oVkJABm6YcDvKuRUAdS7Ym32U
         dJQw==
X-Gm-Message-State: AFqh2koFONxWhmCg3tuBcF73XaRnfIVEptJ5qPD4AUeSU9BEKV5XA9DJ
        EOQMH827n/csKX/vPhIppYY0Gg==
X-Google-Smtp-Source: AMrXdXsLRLCer+GNS5A8O6r0Qdt+lzJgTREMPRI5uA3P7HKDR4KqMywbZZ4UuWll9d4bNzJrn+3F1A==
X-Received: by 2002:a05:6a00:1c8e:b0:581:bfac:7a52 with SMTP id y14-20020a056a001c8e00b00581bfac7a52mr1727118pfw.1.1672847948421;
        Wed, 04 Jan 2023 07:59:08 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y2-20020a62ce02000000b00582388bd80csm8249512pfg.83.2023.01.04.07.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 07:59:07 -0800 (PST)
Date:   Wed, 4 Jan 2023 15:59:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Yang, Weijiang" <weijiang.yang@intel.com>
Cc:     Like Xu <like.xu.linux@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Aaron Lewis <aaronlewis@google.com>
Subject: Re: [PATCH 1/3] KVM: x86: Omit PMU MSRs from KVM_GET_MSR_INDEX_LIST
 if !enable_pmu
Message-ID: <Y7WiSDPRwb5NDhn+@google.com>
References: <20221226111710.51831-1-likexu@tencent.com>
 <20221226111710.51831-2-likexu@tencent.com>
 <752cacbf-5268-6ea0-8c5d-36fb297789ee@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <752cacbf-5268-6ea0-8c5d-36fb297789ee@intel.com>
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

On Tue, Dec 27, 2022, Yang, Weijiang wrote:
> 
> On 12/26/2022 7:17 PM, Like Xu wrote:
> > From: Like Xu <likexu@tencent.com>
> > 
> > When the PMU is disabled, don't bother sharing the PMU MSRs with
> > userspace through KVM_GET_MSR_INDEX_LIST.  Instead, filter them out
> > so userspace doesn't have to keep track of them.
> > 
> > Note that 'enable_pmu' is read-only, so userspace has no control over
> > whether the PMU MSRs are included in the list or not.
> > 
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Co-developed-by: Aaron Lewis <aaronlewis@google.com>
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > Signed-off-by: Like Xu <likexu@tencent.com>
> > ---
> >   arch/x86/include/asm/kvm_host.h |  1 +
> >   arch/x86/kvm/x86.c              | 22 ++++++++++++++++++++--
> >   2 files changed, 21 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index f35f1ff4427b..2ed710b393eb 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -514,6 +514,7 @@ struct kvm_pmc {
> >   #define MSR_ARCH_PERFMON_PERFCTR_MAX	(MSR_ARCH_PERFMON_PERFCTR0 + KVM_INTEL_PMC_MAX_GENERIC - 1)
> >   #define MSR_ARCH_PERFMON_EVENTSEL_MAX	(MSR_ARCH_PERFMON_EVENTSEL0 + KVM_INTEL_PMC_MAX_GENERIC - 1)
> >   #define KVM_PMC_MAX_FIXED	3
> > +#define MSR_ARCH_PERFMON_FIXED_CTR_MAX	(MSR_ARCH_PERFMON_FIXED_CTR0 + KVM_PMC_MAX_FIXED - 1)
> >   #define KVM_AMD_PMC_MAX_GENERIC	6
> >   struct kvm_pmu {
> >   	unsigned nr_arch_gp_counters;
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 5c3ce39cdccb..f570367463c8 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -7054,15 +7054,32 @@ static void kvm_init_msr_list(void)
> >   				continue;
> >   			break;
> >   		case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR_MAX:
> > -			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
> > +			if (!enable_pmu || msrs_to_save_all[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
> >   			    min(KVM_INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
> >   				continue;
> >   			break;
> >   		case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL_MAX:
> > -			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
> > +			if (!enable_pmu || msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
> >   			    min(KVM_INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
> >   				continue;
> >   			break;
> > +		case MSR_ARCH_PERFMON_FIXED_CTR0 ... MSR_ARCH_PERFMON_FIXED_CTR_MAX:
> > +			if (!enable_pmu || msrs_to_save_all[i] - MSR_ARCH_PERFMON_FIXED_CTR0 >=
> > +			    min(KVM_PMC_MAX_FIXED, kvm_pmu_cap.num_counters_fixed))

The num_counters_fixed check is a separate change, no?

> > +				continue;
> > +			break;
> > +		case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
> > +		case MSR_K7_EVNTSEL0 ... MSR_K7_PERFCTR3:
> > +		case MSR_CORE_PERF_FIXED_CTR_CTRL:
> > +		case MSR_CORE_PERF_GLOBAL_STATUS:
> > +		case MSR_CORE_PERF_GLOBAL_CTRL:
> > +		case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
> > +		case MSR_IA32_DS_AREA:
> > +		case MSR_IA32_PEBS_ENABLE:
> > +		case MSR_PEBS_DATA_CFG:

Rather than duplicating all list entries, which will be a maintenance problem,
what about moving PMU MSRs to a separate array?  Sample patch (that applies on top
of the num_counters_fixed change) at the bottom.

> > +			if (!enable_pmu)
> > +				continue;
> > +			break;
> 
> 
> I prefer use a helper to wrap the hunk of PMU msr checks and move the helper
> to the "default" branch of switch, it makes the code looks nicer:
> 
> default:

That won't work as "default" is used to catch MSRs that always exist from the
guest's perspective.  And even if that weren't the case, I don't like the idea of
utilizing "default" for PMU MSRs.  The default=>PMU logic in kvm_{g,s}et_msr_common()
isn't ideal, but it's the lesser of all evils.  But in this case there's no need
since common KVM code knows all possible MSRs that might be saved.

---
 arch/x86/kvm/x86.c | 161 ++++++++++++++++++++++++---------------------
 1 file changed, 87 insertions(+), 74 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1cc8036d9e91..87bb7024e18f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1419,7 +1419,7 @@ EXPORT_SYMBOL_GPL(kvm_emulate_rdpmc);
  * may depend on host virtualization features rather than host cpu features.
  */
 
-static const u32 msrs_to_save_all[] = {
+static const u32 msrs_to_save_base[] = {
 	MSR_IA32_SYSENTER_CS, MSR_IA32_SYSENTER_ESP, MSR_IA32_SYSENTER_EIP,
 	MSR_STAR,
 #ifdef CONFIG_X86_64
@@ -1436,6 +1436,10 @@ static const u32 msrs_to_save_all[] = {
 	MSR_IA32_RTIT_ADDR3_A, MSR_IA32_RTIT_ADDR3_B,
 	MSR_IA32_UMWAIT_CONTROL,
 
+	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
+};
+
+static const u32 msrs_to_save_pmu[] = {
 	MSR_ARCH_PERFMON_FIXED_CTR0, MSR_ARCH_PERFMON_FIXED_CTR1,
 	MSR_ARCH_PERFMON_FIXED_CTR0 + 2,
 	MSR_CORE_PERF_FIXED_CTR_CTRL, MSR_CORE_PERF_GLOBAL_STATUS,
@@ -1460,11 +1464,10 @@ static const u32 msrs_to_save_all[] = {
 	MSR_F15H_PERF_CTL3, MSR_F15H_PERF_CTL4, MSR_F15H_PERF_CTL5,
 	MSR_F15H_PERF_CTR0, MSR_F15H_PERF_CTR1, MSR_F15H_PERF_CTR2,
 	MSR_F15H_PERF_CTR3, MSR_F15H_PERF_CTR4, MSR_F15H_PERF_CTR5,
-
-	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
 };
 
-static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
+static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_base) +
+			ARRAY_SIZE(msrs_to_save_pmu)];
 static unsigned num_msrs_to_save;
 
 static const u32 emulated_msrs_all[] = {
@@ -7001,9 +7004,83 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	return r;
 }
 
-static void kvm_init_msr_list(void)
+static void kvm_probe_msr_to_save(u32 msr_index)
 {
 	u32 dummy[2];
+
+	if (rdmsr_safe(msr_index, &dummy[0], &dummy[1]))
+		return;
+
+	/*
+	 * Even MSRs that are valid in the host may not be exposed to the
+	 * guests in some cases.
+	 */
+	switch (msr_index) {
+	case MSR_IA32_BNDCFGS:
+		if (!kvm_mpx_supported())
+			return;
+		break;
+	case MSR_TSC_AUX:
+		if (!kvm_cpu_cap_has(X86_FEATURE_RDTSCP) &&
+		    !kvm_cpu_cap_has(X86_FEATURE_RDPID))
+			return;
+		break;
+	case MSR_IA32_UMWAIT_CONTROL:
+		if (!kvm_cpu_cap_has(X86_FEATURE_WAITPKG))
+			return;
+		break;
+	case MSR_IA32_RTIT_CTL:
+	case MSR_IA32_RTIT_STATUS:
+		if (!kvm_cpu_cap_has(X86_FEATURE_INTEL_PT))
+			return;
+		break;
+	case MSR_IA32_RTIT_CR3_MATCH:
+		if (!kvm_cpu_cap_has(X86_FEATURE_INTEL_PT) ||
+		    !intel_pt_validate_hw_cap(PT_CAP_cr3_filtering))
+			return;
+		break;
+	case MSR_IA32_RTIT_OUTPUT_BASE:
+	case MSR_IA32_RTIT_OUTPUT_MASK:
+		if (!kvm_cpu_cap_has(X86_FEATURE_INTEL_PT) ||
+		    (!intel_pt_validate_hw_cap(PT_CAP_topa_output) &&
+		     !intel_pt_validate_hw_cap(PT_CAP_single_range_output)))
+			return;
+		break;
+	case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
+		if (!kvm_cpu_cap_has(X86_FEATURE_INTEL_PT) ||
+		    (msr_index - MSR_IA32_RTIT_ADDR0_A >=
+		     intel_pt_validate_hw_cap(PT_CAP_num_address_ranges) * 2))
+			return;
+		break;
+	case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR_MAX:
+		if (msr_index - MSR_ARCH_PERFMON_PERFCTR0 >=
+		    min(KVM_INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
+			return;
+		break;
+	case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL_MAX:
+		if (msr_index - MSR_ARCH_PERFMON_EVENTSEL0 >=
+		    min(KVM_INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
+			return;
+		break;
+	case MSR_ARCH_PERFMON_FIXED_CTR0 ... MSR_ARCH_PERFMON_FIXED_CTR_MAX:
+		if (msr_index - MSR_ARCH_PERFMON_FIXED_CTR0 >=
+		    min(KVM_PMC_MAX_FIXED, kvm_pmu_cap.num_counters_fixed))
+			return;
+		break;
+	case MSR_IA32_XFD:
+	case MSR_IA32_XFD_ERR:
+		if (!kvm_cpu_cap_has(X86_FEATURE_XFD))
+			return;
+		break;
+	default:
+		break;
+	}
+
+	msrs_to_save[num_msrs_to_save++] = msr_index;
+}
+
+static void kvm_init_msr_list(void)
+{
 	unsigned i;
 
 	BUILD_BUG_ON_MSG(KVM_PMC_MAX_FIXED != 3,
@@ -7013,76 +7090,12 @@ static void kvm_init_msr_list(void)
 	num_emulated_msrs = 0;
 	num_msr_based_features = 0;
 
-	for (i = 0; i < ARRAY_SIZE(msrs_to_save_all); i++) {
-		if (rdmsr_safe(msrs_to_save_all[i], &dummy[0], &dummy[1]) < 0)
-			continue;
+	for (i = 0; i < ARRAY_SIZE(msrs_to_save_base); i++)
+		kvm_probe_msr_to_save(msrs_to_save_base[i]);
 
-		/*
-		 * Even MSRs that are valid in the host may not be exposed
-		 * to the guests in some cases.
-		 */
-		switch (msrs_to_save_all[i]) {
-		case MSR_IA32_BNDCFGS:
-			if (!kvm_mpx_supported())
-				continue;
-			break;
-		case MSR_TSC_AUX:
-			if (!kvm_cpu_cap_has(X86_FEATURE_RDTSCP) &&
-			    !kvm_cpu_cap_has(X86_FEATURE_RDPID))
-				continue;
-			break;
-		case MSR_IA32_UMWAIT_CONTROL:
-			if (!kvm_cpu_cap_has(X86_FEATURE_WAITPKG))
-				continue;
-			break;
-		case MSR_IA32_RTIT_CTL:
-		case MSR_IA32_RTIT_STATUS:
-			if (!kvm_cpu_cap_has(X86_FEATURE_INTEL_PT))
-				continue;
-			break;
-		case MSR_IA32_RTIT_CR3_MATCH:
-			if (!kvm_cpu_cap_has(X86_FEATURE_INTEL_PT) ||
-			    !intel_pt_validate_hw_cap(PT_CAP_cr3_filtering))
-				continue;
-			break;
-		case MSR_IA32_RTIT_OUTPUT_BASE:
-		case MSR_IA32_RTIT_OUTPUT_MASK:
-			if (!kvm_cpu_cap_has(X86_FEATURE_INTEL_PT) ||
-				(!intel_pt_validate_hw_cap(PT_CAP_topa_output) &&
-				 !intel_pt_validate_hw_cap(PT_CAP_single_range_output)))
-				continue;
-			break;
-		case MSR_IA32_RTIT_ADDR0_A ... MSR_IA32_RTIT_ADDR3_B:
-			if (!kvm_cpu_cap_has(X86_FEATURE_INTEL_PT) ||
-				msrs_to_save_all[i] - MSR_IA32_RTIT_ADDR0_A >=
-				intel_pt_validate_hw_cap(PT_CAP_num_address_ranges) * 2)
-				continue;
-			break;
-		case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR_MAX:
-			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
-			    min(KVM_INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
-				continue;
-			break;
-		case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL_MAX:
-			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
-			    min(KVM_INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
-				continue;
-			break;
-		case MSR_ARCH_PERFMON_FIXED_CTR0 ... MSR_ARCH_PERFMON_FIXED_CTR_MAX:
-			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_FIXED_CTR0 >=
-			    min(KVM_PMC_MAX_FIXED, kvm_pmu_cap.num_counters_fixed))
-				continue;
-			break;
-		case MSR_IA32_XFD:
-		case MSR_IA32_XFD_ERR:
-			if (!kvm_cpu_cap_has(X86_FEATURE_XFD))
-				continue;
-			break;
-		default:
-			break;
-		}
-
-		msrs_to_save[num_msrs_to_save++] = msrs_to_save_all[i];
+	if (enable_pmu) {
+		for (i = 0; i < ARRAY_SIZE(msrs_to_save_pmu); i++)
+			kvm_probe_msr_to_save(msrs_to_save_pmu[i]);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(emulated_msrs_all); i++) {

base-commit: 248deec419748c75f3a0fd6c075fc7687441b7ea
-- 

