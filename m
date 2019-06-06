Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAB7E36DA1
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 09:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfFFHoq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 03:44:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:25012 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727017AbfFFHoo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 03:44:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 00:44:38 -0700
X-ExtLoop1: 1
Received: from devel-ww.sh.intel.com ([10.239.48.128])
  by orsmga005.jf.intel.com with ESMTP; 06 Jun 2019 00:44:36 -0700
From:   Wei Wang <wei.w.wang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, ak@linux.intel.com, peterz@infradead.org
Cc:     kan.liang@intel.com, mingo@redhat.com, rkrcmar@redhat.com,
        like.xu@intel.com, wei.w.wang@intel.com, jannh@google.com,
        arei.gonglei@huawei.com, jmattson@google.com
Subject: [PATCH v6 06/12] KVM/x86: expose MSR_IA32_PERF_CAPABILITIES to the guest
Date:   Thu,  6 Jun 2019 15:02:25 +0800
Message-Id: <1559804551-42271-7-git-send-email-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559804551-42271-1-git-send-email-wei.w.wang@intel.com>
References: <1559804551-42271-1-git-send-email-wei.w.wang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Bits [0, 5] of MSR_IA32_PERF_CAPABILITIES tell about the format of
the addresses stored in the LBR stack. Expose those bits to the guest
when the guest lbr feature is enabled.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/perf_event.h |  2 ++
 arch/x86/kvm/cpuid.c              |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c      | 16 ++++++++++++++++
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 2606100..aa77da2 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -95,6 +95,8 @@
 #define PEBS_DATACFG_LBRS	BIT_ULL(3)
 #define PEBS_DATACFG_LBR_SHIFT	24
 
+#define X86_PERF_CAP_MASK_LBR_FMT			0x3f
+
 /*
  * Intel "Architectural Performance Monitoring" CPUID
  * detection/enumeration details:
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index e18a9f9..c5b4264 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -364,7 +364,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		F(XMM3) | F(PCLMULQDQ) | 0 /* DTES64, MONITOR */ |
 		0 /* DS-CPL, VMX, SMX, EST */ |
 		0 /* TM2 */ | F(SSSE3) | 0 /* CNXT-ID */ | 0 /* Reserved */ |
-		F(FMA) | F(CX16) | 0 /* xTPR Update, PDCM */ |
+		F(FMA) | F(CX16) | 0 /* xTPR Update*/ | F(PDCM) |
 		F(PCID) | 0 /* Reserved, DCA */ | F(XMM4_1) |
 		F(XMM4_2) | F(X2APIC) | F(MOVBE) | F(POPCNT) |
 		0 /* Reserved*/ | F(AES) | F(XSAVE) | 0 /* OSXSAVE */ | F(AVX) |
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index f14e764..8df5e97 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -154,6 +154,7 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	case MSR_CORE_PERF_GLOBAL_STATUS:
 	case MSR_CORE_PERF_GLOBAL_CTRL:
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
+	case MSR_IA32_PERF_CAPABILITIES:
 		ret = pmu->version > 1;
 		break;
 	default:
@@ -319,6 +320,19 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
 		msr_info->data = pmu->global_ovf_ctrl;
 		return 0;
+	case MSR_IA32_PERF_CAPABILITIES: {
+		u64 data;
+
+		if (!boot_cpu_has(X86_FEATURE_PDCM) ||
+		    (!msr_info->host_initiated &&
+		     !guest_cpuid_has(vcpu, X86_FEATURE_PDCM)))
+			return 1;
+		data = native_read_msr(MSR_IA32_PERF_CAPABILITIES);
+		msr_info->data = 0;
+		if (vcpu->kvm->arch.lbr_in_guest)
+			msr_info->data |= (data & X86_PERF_CAP_MASK_LBR_FMT);
+		return 0;
+	}
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
 			u64 val = pmc_read_counter(pmc);
@@ -377,6 +391,8 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 0;
 		}
 		break;
+	case MSR_IA32_PERF_CAPABILITIES:
+		return 1; /* RO MSR */
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0))) {
 			if (msr_info->host_initiated)
-- 
2.7.4

