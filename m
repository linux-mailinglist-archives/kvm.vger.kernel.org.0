Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD2D767A72D
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 00:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234163AbjAXXt0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 18:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234364AbjAXXtX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 18:49:23 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 171B64FACD
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 15:49:18 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id d10-20020a631d4a000000b00491da16dc44so7554891pgm.16
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 15:49:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=PCuRaPACRckOLmMloMboeg+q3NxGqmxKSfZdPmlSu+Y=;
        b=lQgVxYI7Exbz/lKh6x84rMBA9rVOW4Lup6GD4ApHB6oURXKeNhSWfzSzS36TaNiAeB
         HpNwQsE/GD2SSSG1me6iMgqx+5OU7pErcewwwbJfYjRkua0LE6tZqv3RRg78k5MGiLY9
         hAqhOa9PPiZTpHHRL391qNjCWrU1/eGinF1girUo0rpUAG95vrGjsAkCO3ykM41H9Ay8
         pmix913ZqE5rdz5+Nt9AUnUF/PkDDB5bB8Hz2sMjjC6J4caP/KAA4uctFs0jiVZbpZMN
         HPlzJn6AzD/QW6eh3/7AA3o+9kAzAIZTWG1WaPAxLh5gyM+qbFTDz9iQOKQU30zpEnhi
         oRmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PCuRaPACRckOLmMloMboeg+q3NxGqmxKSfZdPmlSu+Y=;
        b=XKDCERzZrDODRP31BvTz6Hha4k8fvERhhbJu9TyMQaYx0J1GCha4ri+QtjlgqWFmBL
         jdR3Xy3FF0AHDMy6PN7FUbXFFz50BDNanIJudNh4X+AE1ucGidMdKYEYT1GanAqvJWrN
         UAmF74ifxQOKpwrKowWgr5me286tCS34EG0LRviO8/NE9g1ArejiqUy4YyGua5G+todo
         lmJB1zRAzLn9F1Jl3iooPcI8+i58SETWX1dsD852V+Gj0FwpQR02Gnr5lO5H+QjyoiBZ
         YU08ttKExYKuFEMV/9MvzFiRQgHJg03SOqssz+sIbIWW8KsCMpjVxgC0bZ54nUn0lqfc
         NNog==
X-Gm-Message-State: AFqh2krk2mC+vH97IVOMr2yyLzF+lQRjsg7YUJah2m6B2yGb23fSGOq+
        pIOLZCSCjiFd49BRh3UE2Fwu1+soVss=
X-Google-Smtp-Source: AMrXdXv+L6/9pHp9W3kDcSor6PnS/wvwK/SJwdt9uWwpfHJrbHNyg6r9R1SSmgEoF76rKj8r2ten0LoOJ14=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:65cb:b0:227:4d5:6d64 with SMTP id
 i11-20020a17090a65cb00b0022704d56d64mr3937714pjs.29.1674604158365; Tue, 24
 Jan 2023 15:49:18 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 24 Jan 2023 23:49:02 +0000
In-Reply-To: <20230124234905.3774678-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230124234905.3774678-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230124234905.3774678-4-seanjc@google.com>
Subject: [PATCH 3/6] KVM: x86/pmu: Use separate array for defining "PMU MSRs
 to save"
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Weijiang Yang <weijiang.yang@intel.com>,
        Like Xu <likexu@tencent.com>
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

Move all potential to-be-saved PMU MSRs into a separate array so that a
future patch can easily omit all PMU MSRs from the list when the PMU is
disabled.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 153 ++++++++++++++++++++++++---------------------
 1 file changed, 82 insertions(+), 71 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d4a610ffe2b8..9b6e1af63531 100644
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
@@ -6994,84 +6997,92 @@ long kvm_arch_vm_ioctl(struct file *filp,
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
+	 * Even MSRs that are valid in the host may not be exposed to guests in
+	 * some cases.
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
+		    kvm_pmu_cap.num_counters_gp)
+			return;
+		break;
+	case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL_MAX:
+		if (msr_index - MSR_ARCH_PERFMON_EVENTSEL0 >=
+		    kvm_pmu_cap.num_counters_gp)
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
-			 "Please update the fixed PMCs in msrs_to_saved_all[]");
+			 "Please update the fixed PMCs in msrs_to_save_pmu[]");
 
 	num_msrs_to_save = 0;
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
-			    kvm_pmu_cap.num_counters_gp)
-				continue;
-			break;
-		case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL_MAX:
-			if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
-			    kvm_pmu_cap.num_counters_gp)
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
-	}
+	for (i = 0; i < ARRAY_SIZE(msrs_to_save_pmu); i++)
+		kvm_probe_msr_to_save(msrs_to_save_pmu[i]);
 
 	for (i = 0; i < ARRAY_SIZE(emulated_msrs_all); i++) {
 		if (!static_call(kvm_x86_has_emulated_msr)(NULL, emulated_msrs_all[i]))
-- 
2.39.1.456.gfc5497dd1b-goog

