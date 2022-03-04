Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 640124CD0C2
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 10:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236078AbiCDJGv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 04:06:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236062AbiCDJFy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 04:05:54 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F051A1C71;
        Fri,  4 Mar 2022 01:05:05 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id y11so7107270pfa.6;
        Fri, 04 Mar 2022 01:05:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Yvo6RB3Xciz0sz0Rm8miPF4MC/GSVIrI82K2Ajhd1tc=;
        b=B1FQDE93NhjWObjRaULGB1tqb7At8GCba9UH+jnnEpntwTZvqeQAY+4WzFwqYyaoMF
         kGkJpSTMlB3qwcC/rERKKZaGCeLJfC/zH1Qzy5wOvXIDOmb5WT0G+4p+eF6LDAzVgM0f
         WCG72ugRqH1x3yODawFCuU3n3hA+2HmV7nHmQ4+2PQ20/W2VUvI29YIlEdx0eDQwUErh
         LsN59M4cEFjW932dt5hqYgTnkB5nG1/+p18kJAFy7d+oO6TFIpAERmKiuT2BKi2D5Yl5
         e+T6Fh1PzrqydUqz9bBItJTvJiSeIsKjoDAiTOg7HH2Ewbxk0Nh8CvUwayZcZ8BcpiDd
         hH+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yvo6RB3Xciz0sz0Rm8miPF4MC/GSVIrI82K2Ajhd1tc=;
        b=4yzXcY/hkTcQBxdggcmTW6v+j2kW2CwxAoX+rPBJBgnpuKctyvBcmu+GYpUj5tLrMn
         5+CtmVyjvSZMNfSGbNxGQylaeYArMvIt/+QFsukhXJLT9o6u0jJCfzvFR4AyrEV18Yqf
         +J+emXaPBYBQvPd55CXITfLqyz4qd0DgmTBbkAw7LKhDmTA/4UO7NabO5HaajQXw8pxm
         kbkRGsLJfyC1XANvT3z4Vw6hIm5b48a9UqfzOspBefOJe7fsDmjWcduP5vNZSsx7rmBr
         N8yroUh84dX2VpZGrcRkgBTnER2ZkccfTGf7lj4ae6vkPZENcirTRN30hszgDLvic194
         Uz6Q==
X-Gm-Message-State: AOAM531k2S8d3HLtXsE23E58QUlsdIDkN7NfEzmxwP0f31MMjrrBSwfK
        RRUDhgzA0HtPEG+aPKidOWc=
X-Google-Smtp-Source: ABdhPJy7CYPkYFUoA8ySEE78xUtZE4FeyrJb9yFcdxT1Nwe9IPasuxDEw2RCHH2X9GPAwKwQyNPtkw==
X-Received: by 2002:a63:f551:0:b0:36c:54bd:da32 with SMTP id e17-20020a63f551000000b0036c54bdda32mr32965306pgk.285.1646384704631;
        Fri, 04 Mar 2022 01:05:04 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id j2-20020a655582000000b00372b2b5467asm4192968pgs.10.2022.03.04.01.05.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 01:05:04 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v12 07/17] KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS
Date:   Fri,  4 Mar 2022 17:04:17 +0800
Message-Id: <20220304090427.90888-8-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220304090427.90888-1-likexu@tencent.com>
References: <20220304090427.90888-1-likexu@tencent.com>
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
 4 files changed, 97 insertions(+), 18 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 7f0bab2f70fd..b08f0eb6cfee 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3948,33 +3948,72 @@ static int intel_pmu_hw_config(struct perf_event *event)
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
index cf5ce12557f2..3bc4c5d79110 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -519,6 +519,9 @@ struct kvm_pmu {
 	DECLARE_BITMAP(all_valid_pmc_idx, X86_PMC_IDX_MAX);
 	DECLARE_BITMAP(pmc_in_use, X86_PMC_IDX_MAX);
 
+	u64 pebs_enable;
+	u64 pebs_enable_mask;
+
 	/*
 	 * The gate to release perf_events not marked in
 	 * pmc_in_use only once in a vcpu time slice.
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index a4a39c3e0f19..ec0207a43f4d 100644
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
index c5f885198c60..9f1b25d7b966 100644
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
@@ -420,6 +426,14 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -487,6 +501,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->version = 0;
 	pmu->reserved_bits = 0xffffffff00200000ull;
 	pmu->fixed_ctr_ctrl_mask = ~0ull;
+	pmu->pebs_enable_mask = ~0ull;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
 	if (!entry || !vcpu->kvm->arch.enable_pmu)
@@ -556,6 +571,22 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 
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
-- 
2.35.1

