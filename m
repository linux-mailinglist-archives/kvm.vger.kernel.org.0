Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F312DA10F3
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 07:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727551AbfH2FjM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 01:39:12 -0400
Received: from mga17.intel.com ([192.55.52.151]:42121 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727487AbfH2FjM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 01:39:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Aug 2019 22:39:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,442,1559545200"; 
   d="scan'208";a="210416244"
Received: from icl-2s.bj.intel.com ([10.240.193.48])
  by fmsmga002.fm.intel.com with ESMTP; 28 Aug 2019 22:39:09 -0700
From:   Luwei Kang <luwei.kang@intel.com>
To:     pbonzini@redhat.com, rkrcmar@redhat.com
Cc:     sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, ak@linux.intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luwei Kang <luwei.kang@intel.com>
Subject: [RFC v1 4/9] KVM: x86: Implement counter reload MSRs read/write emulation
Date:   Thu, 29 Aug 2019 13:34:04 +0800
Message-Id: <1567056849-14608-5-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567056849-14608-1-git-send-email-luwei.kang@intel.com>
References: <1567056849-14608-1-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch implements the counter reload register
MSR_RELOAD_PMCx/FIXED_CTRx read/write emulation. These registers
can be accessed only when PEBS is supported in KVM.

VMM need to reprogram the counters to make the host PMU framework
load the value to real hardware after configuration has been changed.

Signed-off-by: Luwei Kang <luwei.kang@intel.com>
---
 arch/x86/include/asm/kvm_host.h  |  1 +
 arch/x86/include/asm/msr-index.h |  3 +++
 arch/x86/kvm/vmx/pmu_intel.c     | 22 +++++++++++++++++++++-
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index df966c9..9b930b5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -454,6 +454,7 @@ struct kvm_pmc {
 	enum pmc_type type;
 	u8 idx;
 	u64 counter;
+	u64 reload_cnt;
 	u64 eventsel;
 	struct perf_event *perf_event;
 	struct kvm_vcpu *vcpu;
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index a9e8720..6321acb 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -141,6 +141,9 @@
 #define MSR_IA32_PERF_CAPABILITIES	0x00000345
 #define MSR_PEBS_LD_LAT_THRESHOLD	0x000003f6
 
+#define MSR_IA32_RELOAD_PMC0		0x000014c1
+#define MSR_IA32_RELOAD_FIXED_CTR0	0x00001309
+
 #define MSR_IA32_RTIT_CTL		0x00000570
 #define RTIT_CTL_TRACEEN		BIT(0)
 #define RTIT_CTL_CYCLEACC		BIT(1)
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index fc79cc6..ebd3efc 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -175,7 +175,9 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
-			get_fixed_pmc(pmu, msr, MSR_CORE_PERF_FIXED_CTR0);
+			get_fixed_pmc(pmu, msr, MSR_CORE_PERF_FIXED_CTR0) ||
+			get_gp_pmc(pmu, msr, MSR_IA32_RELOAD_PMC0) ||
+			get_fixed_pmc(pmu, msr, MSR_IA32_RELOAD_FIXED_CTR0);
 		break;
 	}
 
@@ -216,6 +218,11 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data)
 		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
 			*data = pmc->eventsel;
 			return 0;
+		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_RELOAD_PMC0)) ||
+			   (pmc = get_fixed_pmc(pmu, msr,
+						MSR_IA32_RELOAD_FIXED_CTR0))) {
+			*data = pmc->reload_cnt;
+			return 0;
 		}
 	}
 
@@ -288,6 +295,19 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 				reprogram_gp_counter(pmc, data);
 				return 0;
 			}
+		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_RELOAD_PMC0)) ||
+			   (pmc = get_fixed_pmc(pmu, msr,
+						MSR_IA32_RELOAD_FIXED_CTR0))) {
+			if (data == pmc->reload_cnt)
+				return 0;
+			if (!(data & ~pmc_bitmask(pmc))) {
+				int pmc_idx = pmc_is_fixed(pmc) ?
+					pmc->idx + INTEL_PMC_IDX_FIXED :
+								pmc->idx;
+				pmc->reload_cnt = data;
+				reprogram_counter(pmu, pmc_idx);
+				return 0;
+			}
 		}
 	}
 
-- 
1.8.3.1

