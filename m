Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9EAFE6226
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2019 12:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfJ0LMy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Oct 2019 07:12:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:12498 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726882AbfJ0LMn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Oct 2019 07:12:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Oct 2019 04:12:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,236,1569308400"; 
   d="scan'208";a="282690177"
Received: from unknown (HELO snr.jf.intel.com) ([10.54.39.141])
  by orsmga001.jf.intel.com with ESMTP; 27 Oct 2019 04:12:41 -0700
From:   Luwei Kang <luwei.kang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, ak@linux.intel.com, thomas.lendacky@amd.com,
        peterz@infradead.org, acme@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        namhyung@kernel.org, Luwei Kang <luwei.kang@intel.com>
Subject: [PATCH v1 7/8] KVM: x86: Expose PEBS feature to guest
Date:   Sun, 27 Oct 2019 19:11:16 -0400
Message-Id: <1572217877-26484-8-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1572217877-26484-1-git-send-email-luwei.kang@intel.com>
References: <1572217877-26484-1-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Expose PEBS feature to guest by IA32_MISC_ENABLE[bit12].
IA32_MISC_ENABLE[bit12] is Processor Event Based Sampling (PEBS)
Unavailable (RO) flag:
1 = PEBS is not supported; 0 = PEBS is supported.

Signed-off-by: Luwei Kang <luwei.kang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm.c              |  6 ++++++
 arch/x86/kvm/vmx/vmx.c          |  1 +
 arch/x86/kvm/x86.c              | 22 +++++++++++++++++-----
 4 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 24a0ab9..76f5fa5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1127,6 +1127,7 @@ struct kvm_x86_ops {
 	bool (*xsaves_supported)(void);
 	bool (*umip_emulated)(void);
 	bool (*pt_supported)(void);
+	bool (*pebs_supported)(void);
 	bool (*pdcm_supported)(void);
 
 	int (*check_nested_events)(struct kvm_vcpu *vcpu, bool external_intr);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 7e0a7b3..3a1bbb3 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5975,6 +5975,11 @@ static bool svm_pt_supported(void)
 	return false;
 }
 
+static bool svm_pebs_supported(void)
+{
+	return false;
+}
+
 static bool svm_pdcm_supported(void)
 {
 	return false;
@@ -7277,6 +7282,7 @@ static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 	.xsaves_supported = svm_xsaves_supported,
 	.umip_emulated = svm_umip_emulated,
 	.pt_supported = svm_pt_supported,
+	.pebs_supported = svm_pebs_supported,
 	.pdcm_supported = svm_pdcm_supported,
 
 	.set_supported_cpuid = svm_set_supported_cpuid,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5c4dd05..3c370a3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7879,6 +7879,7 @@ static __exit void hardware_unsetup(void)
 	.xsaves_supported = vmx_xsaves_supported,
 	.umip_emulated = vmx_umip_emulated,
 	.pt_supported = vmx_pt_supported,
+	.pebs_supported = vmx_pebs_supported,
 	.pdcm_supported = vmx_pdcm_supported,
 
 	.request_immediate_exit = vmx_request_immediate_exit,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 661e2bf..5f59073 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2591,6 +2591,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	bool pr = false;
+	bool update_cpuid = false;
 	u32 msr = msr_info->index;
 	u64 data = msr_info->data;
 
@@ -2671,11 +2672,17 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    ((vcpu->arch.ia32_misc_enable_msr ^ data) & MSR_IA32_MISC_ENABLE_MWAIT)) {
 			if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))
 				return 1;
-			vcpu->arch.ia32_misc_enable_msr = data;
-			kvm_update_cpuid(vcpu);
-		} else {
-			vcpu->arch.ia32_misc_enable_msr = data;
+			update_cpuid = true;
 		}
+
+		if (kvm_x86_ops->pebs_supported())
+			data &=  ~MSR_IA32_MISC_ENABLE_PEBS;
+		else
+			data |= MSR_IA32_MISC_ENABLE_PEBS;
+
+		vcpu->arch.ia32_misc_enable_msr = data;
+		if (update_cpuid)
+			kvm_update_cpuid(vcpu);
 		break;
 	case MSR_IA32_SMBASE:
 		if (!msr_info->host_initiated)
@@ -2971,7 +2978,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = (u64)vcpu->arch.ia32_tsc_adjust_msr;
 		break;
 	case MSR_IA32_MISC_ENABLE:
-		msr_info->data = vcpu->arch.ia32_misc_enable_msr;
+		if (kvm_x86_ops->pebs_supported())
+			msr_info->data = (vcpu->arch.ia32_misc_enable_msr &
+						~MSR_IA32_MISC_ENABLE_PEBS);
+		else
+			msr_info->data = (vcpu->arch.ia32_misc_enable_msr |
+						MSR_IA32_MISC_ENABLE_PEBS);
 		break;
 	case MSR_IA32_SMBASE:
 		if (!msr_info->host_initiated)
-- 
1.8.3.1

