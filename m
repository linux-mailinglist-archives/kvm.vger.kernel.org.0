Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F114FB953
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 12:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345295AbiDKKXJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 06:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345364AbiDKKWi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 06:22:38 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34FFD43380;
        Mon, 11 Apr 2022 03:20:14 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id bx5so14807357pjb.3;
        Mon, 11 Apr 2022 03:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JtGly5pTzMQ28A+2MXS/RnCSuq1EH9qW5f0VBSEP53o=;
        b=UoDVLBg9XuyGYzAIAh4fugb8Nm2QoBG1aaL28PYabMCuYGwPSRNDaH83L+ZlP3d2Tk
         stmFs6UjtE/nYJ08Ve5GXjc+M9wGFydqhw17k8qgWY7Eik/hliUlMpE77+LijoNkchrH
         4JrBzQv/p0USw6PWl5VKRKeXySvC6uMlgy0oRr3thi8dDlLfLwdfa4oJ+YTVz5cin8M7
         2ZrlkavwN6G9z4/OHnOMAUkI+BF/qdiBMCXB5PBr6GeQqurN0EgaxWhzzUaVbg/UPsEZ
         2H6X7xuOAtC+zoJ6AY92YIwTGwkMIR9P/9NFw2UCfyakXi4pS7Xqmb6iLIN42yVsmk6y
         KBKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JtGly5pTzMQ28A+2MXS/RnCSuq1EH9qW5f0VBSEP53o=;
        b=vjpHB+F4+aQ3s6vLp6AEL05yY3Qq3pjy3tOviprXHwI9xAfrxpwXCWBl433TVJTFga
         +1Kj9KHNct04s2zaBIlpaTRVcl2BCxz/X4wCZpsFmiNne1VN5km5yf1/00qOhxlxOE+P
         YI85Kyi1BnQMKtXywAuD6JH5VFAaCk8faIbeHhN1ccjQDkINn0j5Th6HJQDAD1Bfb+3H
         5jdXbyQ5XjL0X7VBePiL3vztOPbgyT+VMKwdXOXA+p3IrXYw59TUcpk6U9APOcHyYD1K
         9m71HnIQF0OkV31DV2ca2VHbP6diuoBBq9Rxay3v07p0lYtWjqv2LU/wxBaExWe/uoO/
         2tpA==
X-Gm-Message-State: AOAM531qOOFUZptRgfjpG2S7r9W2Te/znXPY4VzG/4juWuSmAoxWGdS0
        VKjEhqArfbnnNHq0kMKheMI=
X-Google-Smtp-Source: ABdhPJz6FKqJCh9xqX0Sj8OlGuIcvsvjmK0ydOnuIgeHhSgTOZZc3f856D/Jkk2oWnstFs02CqCJ9A==
X-Received: by 2002:a17:902:d481:b0:154:7f0b:62fb with SMTP id c1-20020a170902d48100b001547f0b62fbmr31932130plg.41.1649672413610;
        Mon, 11 Apr 2022 03:20:13 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.112])
        by smtp.gmail.com with ESMTPSA id h10-20020a056a00230a00b004faa0f67c3esm34012280pfh.23.2022.04.11.03.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 03:20:13 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RESEND v12 07/17] KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS
Date:   Mon, 11 Apr 2022 18:19:36 +0800
Message-Id: <20220411101946.20262-8-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411101946.20262-1-likexu@tencent.com>
References: <20220411101946.20262-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

If IA32_PERF_CAPABILITIES.PEBS_BASELINE [bit 14] is set, the
IA32_PEBS_ENABLE MSR exists and all architecturally enumerated fixed
and general-purpose counters have corresponding bits in IA32_PEBS_ENABLE
that enable generation of PEBS records. The general-purpose counter bits
start at bit IA32_PEBS_ENABLE[0], and the fixed counter bits start at
bit IA32_PEBS_ENABLE[32].

When guest PEBS is enabled, the IA32_PEBS_ENABLE MSR will be
added to the perf_guest_switch_msr() and atomically switched during
the VMX transitions just like CORE_PERF_GLOBAL_CTRL MSR.

Based on whether the platform supports x86_pmu.pebs_ept, it has also
refactored the way to add more msrs to arr[] in intel_guest_get_msrs()
for extensibility.

Originally-by: Andi Kleen <ak@linux.intel.com>
Co-developed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Co-developed-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Luwei Kang <luwei.kang@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/events/intel/core.c     | 75 ++++++++++++++++++++++++--------
 arch/x86/include/asm/kvm_host.h  |  3 ++
 arch/x86/include/asm/msr-index.h |  6 +++
 arch/x86/kvm/vmx/pmu_intel.c     | 31 +++++++++++++
 arch/x86/kvm/x86.c               |  1 +
 5 files changed, 98 insertions(+), 18 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 4a3619ed66d1..270356df4add 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3969,33 +3969,72 @@ static int intel_pmu_hw_config(struct perf_event *event)
 	return 0;
 }
 
+/*
+ * Currently, the only caller of this function is the atomic_switch_perf_msrs().
+ * The host perf conext helps to prepare the values of the real hardware for
+ * a set of msrs that need to be switched atomically in a vmx transaction.
+ *
+ * For example, the pseudocode needed to add a new msr should look like:
+ *
+ * arr[(*nr)++] = (struct perf_guest_switch_msr){
+ *	.msr = the hardware msr address,
+ *	.host = the value the hardware has when it doesn't run a guest,
+ *	.guest = the value the hardware has when it runs a guest,
+ * };
+ *
+ * These values have nothing to do with the emulated values the guest sees
+ * when it uses {RD,WR}MSR, which should be handled by the KVM context,
+ * specifically in the intel_pmu_{get,set}_msr().
+ */
 static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
 	u64 intel_ctrl = hybrid(cpuc->pmu, intel_ctrl);
+	u64 pebs_mask = cpuc->pebs_enabled & x86_pmu.pebs_capable;
+	int global_ctrl, pebs_enable;
 
-	arr[0].msr = MSR_CORE_PERF_GLOBAL_CTRL;
-	arr[0].host = intel_ctrl & ~cpuc->intel_ctrl_guest_mask;
-	arr[0].guest = intel_ctrl & ~cpuc->intel_ctrl_host_mask;
-	arr[0].guest &= ~(cpuc->pebs_enabled & x86_pmu.pebs_capable);
-	*nr = 1;
+	*nr = 0;
+	global_ctrl = (*nr)++;
+	arr[global_ctrl] = (struct perf_guest_switch_msr){
+		.msr = MSR_CORE_PERF_GLOBAL_CTRL,
+		.host = intel_ctrl & ~cpuc->intel_ctrl_guest_mask,
+		.guest = intel_ctrl & (~cpuc->intel_ctrl_host_mask | ~pebs_mask),
+	};
 
-	if (x86_pmu.pebs && x86_pmu.pebs_no_isolation) {
-		/*
-		 * If PMU counter has PEBS enabled it is not enough to
-		 * disable counter on a guest entry since PEBS memory
-		 * write can overshoot guest entry and corrupt guest
-		 * memory. Disabling PEBS solves the problem.
-		 *
-		 * Don't do this if the CPU already enforces it.
-		 */
-		arr[1].msr = MSR_IA32_PEBS_ENABLE;
-		arr[1].host = cpuc->pebs_enabled;
-		arr[1].guest = 0;
-		*nr = 2;
+	if (!x86_pmu.pebs)
+		return arr;
+
+	/*
+	 * If PMU counter has PEBS enabled it is not enough to
+	 * disable counter on a guest entry since PEBS memory
+	 * write can overshoot guest entry and corrupt guest
+	 * memory. Disabling PEBS solves the problem.
+	 *
+	 * Don't do this if the CPU already enforces it.
+	 */
+	if (x86_pmu.pebs_no_isolation) {
+		arr[(*nr)++] = (struct perf_guest_switch_msr){
+			.msr = MSR_IA32_PEBS_ENABLE,
+			.host = cpuc->pebs_enabled,
+			.guest = 0,
+		};
+		return arr;
 	}
 
+	if (!x86_pmu.pebs_ept)
+		return arr;
+	pebs_enable = (*nr)++;
+
+	arr[pebs_enable] = (struct perf_guest_switch_msr){
+		.msr = MSR_IA32_PEBS_ENABLE,
+		.host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask,
+		.guest = pebs_mask & ~cpuc->intel_ctrl_host_mask,
+	};
+
+	/* Set hw GLOBAL_CTRL bits for PEBS counter when it runs for guest */
+	arr[0].guest |= arr[*nr].guest;
+
 	return arr;
 }
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6e3eeadfe8e3..be65c6527a8b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -518,6 +518,9 @@ struct kvm_pmu {
 	DECLARE_BITMAP(all_valid_pmc_idx, X86_PMC_IDX_MAX);
 	DECLARE_BITMAP(pmc_in_use, X86_PMC_IDX_MAX);
 
+	u64 pebs_enable;
+	u64 pebs_enable_mask;
+
 	/*
 	 * The gate to release perf_events not marked in
 	 * pmc_in_use only once in a vcpu time slice.
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 0eb90d21049e..c72770942413 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -189,6 +189,12 @@
 #define PERF_CAP_PT_IDX			16
 
 #define MSR_PEBS_LD_LAT_THRESHOLD	0x000003f6
+#define PERF_CAP_PEBS_TRAP             BIT_ULL(6)
+#define PERF_CAP_ARCH_REG              BIT_ULL(7)
+#define PERF_CAP_PEBS_FORMAT           0xf00
+#define PERF_CAP_PEBS_BASELINE         BIT_ULL(14)
+#define PERF_CAP_PEBS_MASK	(PERF_CAP_PEBS_TRAP | PERF_CAP_ARCH_REG | \
+				 PERF_CAP_PEBS_FORMAT | PERF_CAP_PEBS_BASELINE)
 
 #define MSR_IA32_RTIT_CTL		0x00000570
 #define RTIT_CTL_TRACEEN		BIT(0)
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 2aeabb067bad..c7de5bc985c2 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -214,6 +214,9 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		ret = pmu->version > 1;
 		break;
+	case MSR_IA32_PEBS_ENABLE:
+		ret = vcpu->arch.perf_capabilities & PERF_CAP_PEBS_FORMAT;
+		break;
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
@@ -361,6 +364,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		msr_info->data = 0;
 		return 0;
+	case MSR_IA32_PEBS_ENABLE:
+		msr_info->data = pmu->pebs_enable;
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -421,6 +427,14 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 0;
 		}
 		break;
+	case MSR_IA32_PEBS_ENABLE:
+		if (pmu->pebs_enable == data)
+			return 0;
+		if (!(data & pmu->pebs_enable_mask)) {
+			pmu->pebs_enable = data;
+			return 0;
+		}
+		break;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -493,6 +507,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->reserved_bits = 0xffffffff00200000ull;
 	pmu->raw_event_mask = X86_RAW_EVENT_MASK;
 	pmu->fixed_ctr_ctrl_mask = ~0ull;
+	pmu->pebs_enable_mask = ~0ull;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
 	if (!entry || !vcpu->kvm->arch.enable_pmu)
@@ -564,6 +579,22 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 
 	if (lbr_desc->records.nr)
 		bitmap_set(pmu->all_valid_pmc_idx, INTEL_PMC_IDX_FIXED_VLBR, 1);
+
+	if (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_FORMAT) {
+		if (vcpu->arch.perf_capabilities & PERF_CAP_PEBS_BASELINE) {
+			pmu->pebs_enable_mask = ~pmu->global_ctrl;
+			pmu->reserved_bits &= ~ICL_EVENTSEL_ADAPTIVE;
+			for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
+				pmu->fixed_ctr_ctrl_mask &=
+					~(1ULL << (INTEL_PMC_IDX_FIXED + i * 4));
+			}
+		} else {
+			pmu->pebs_enable_mask =
+				~((1ull << pmu->nr_arch_gp_counters) - 1);
+		}
+	} else {
+		vcpu->arch.perf_capabilities &= ~PERF_CAP_PEBS_MASK;
+	}
 }
 
 static void intel_pmu_init(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4b64b3ff5b67..14902288cbb8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1443,6 +1443,7 @@ static const u32 msrs_to_save_all[] = {
 	MSR_ARCH_PERFMON_EVENTSEL0 + 12, MSR_ARCH_PERFMON_EVENTSEL0 + 13,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 14, MSR_ARCH_PERFMON_EVENTSEL0 + 15,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
+	MSR_IA32_PEBS_ENABLE,
 
 	MSR_K7_EVNTSEL0, MSR_K7_EVNTSEL1, MSR_K7_EVNTSEL2, MSR_K7_EVNTSEL3,
 	MSR_K7_PERFCTR0, MSR_K7_PERFCTR1, MSR_K7_PERFCTR2, MSR_K7_PERFCTR3,
-- 
2.35.1

