Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7838E6221
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2019 12:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbfJ0LMn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Oct 2019 07:12:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:12497 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726869AbfJ0LMm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Oct 2019 07:12:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Oct 2019 04:12:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,236,1569308400"; 
   d="scan'208";a="282690172"
Received: from unknown (HELO snr.jf.intel.com) ([10.54.39.141])
  by orsmga001.jf.intel.com with ESMTP; 27 Oct 2019 04:12:40 -0700
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
Subject: [PATCH v1 6/8] KVM: X86: MSR_IA32_PERF_CAPABILITIES MSR emulation
Date:   Sun, 27 Oct 2019 19:11:15 -0400
Message-Id: <1572217877-26484-7-git-send-email-luwei.kang@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1572217877-26484-1-git-send-email-luwei.kang@intel.com>
References: <1572217877-26484-1-git-send-email-luwei.kang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Expose some bits of definition which relate with enable
PEBS to KVM guest especially PEBS via PT feature.

Signed-off-by: Luwei Kang <luwei.kang@intel.com>
---
 arch/x86/include/asm/kvm_host.h  |  1 +
 arch/x86/include/asm/msr-index.h |  3 +++
 arch/x86/kvm/vmx/vmx.c           | 14 ++++++++++++++
 3 files changed, 18 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a987ae1..24a0ab9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -569,6 +569,7 @@ struct kvm_vcpu_arch {
 	u64 ia32_xss;
 	u64 microcode_version;
 	u64 arch_capabilities;
+	u64 ia32_perf_capabilities;
 
 	/*
 	 * Paging state of the vcpu
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index d22f8d9..75c09e4 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -137,6 +137,9 @@
 #define MSR_IA32_PEBS_ENABLE		0x000003f1
 #define MSR_PEBS_DATA_CFG		0x000003f2
 #define MSR_IA32_DS_AREA		0x00000600
+#define MSR_IA32_PERF_CAP_PEBS_TRAP		BIT_ULL(6)
+#define MSR_IA32_PERF_CAP_PEBS_ARCH_REG		BIT_ULL(7)
+#define MSR_IA32_PERF_CAP_PEBS_REC_FMT		(0xfULL << 8)
 #define MSR_IA32_PERF_CAP_PEBS_OUTPUT_PT	BIT_ULL(16)
 #define MSR_IA32_PERF_CAPABILITIES	0x00000345
 #define MSR_PEBS_LD_LAT_THRESHOLD	0x000003f6
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6c29a57..5c4dd05 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1828,6 +1828,16 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		msr_info->data = vcpu->arch.ia32_xss;
 		break;
+	case MSR_IA32_PERF_CAPABILITIES:
+		if (!vmx_pdcm_supported() || !vmx_pebs_supported())
+			return 1;
+		rdmsrl(MSR_IA32_PERF_CAPABILITIES, msr_info->data);
+		msr_info->data = msr_info->data &
+			(MSR_IA32_PERF_CAP_PEBS_TRAP |
+			 MSR_IA32_PERF_CAP_PEBS_ARCH_REG |
+			 MSR_IA32_PERF_CAP_PEBS_REC_FMT |
+			 MSR_IA32_PERF_CAP_PEBS_OUTPUT_PT);
+		break;
 	case MSR_IA32_RTIT_CTL:
 		if (pt_mode != PT_MODE_HOST_GUEST)
 			return 1;
@@ -2082,6 +2092,10 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		else
 			clear_atomic_switch_msr(vmx, MSR_IA32_XSS);
 		break;
+	case MSR_IA32_PERF_CAPABILITIES:
+		if (!vmx_pdcm_supported() || !vmx_pebs_supported())
+			return 1;
+		break;
 	case MSR_IA32_RTIT_CTL:
 		if ((pt_mode != PT_MODE_HOST_GUEST) ||
 			vmx_rtit_ctl_check(vcpu, data) ||
-- 
1.8.3.1

