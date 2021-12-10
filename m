Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 358AD4701D1
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 14:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242308AbhLJNkS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 08:40:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242116AbhLJNjt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 08:39:49 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91FEDC061A32;
        Fri, 10 Dec 2021 05:36:14 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so9448692pjb.5;
        Fri, 10 Dec 2021 05:36:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OOybioaRtxDxC3yor+JF9ftmOt9vp16fzmRSZ4dMKhA=;
        b=OrnzPF/HKU3avmHQ3coNw9v4vgkOwzo/im0xiubOYr72UeTRtFvWflrNtYW+GkRXIX
         IprpXnaPxFp/3SusS5ekCfRiZ6OjqpYWap3iVj2R7m+oD7GOBxsvbfcO2oELU0jVFtYT
         mLbFhFJERhBw4nymBVsu28On6ZN+oR+UqpAzxzsNvR0yyz5C2WsqTEkuogQFdET7qAHx
         nxhwxGSUuThexrz7UE00phuomET+HHLX+PFDPf6VZ4q/Qat/JbRzL6Gf49puzLnIS+lz
         yJDfSpOodL8dcrmaynbwMwYNdoPC1uJw0RdtJn78BEzuhj1TNk6H+nx+3+ovTapGPY7C
         0OkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OOybioaRtxDxC3yor+JF9ftmOt9vp16fzmRSZ4dMKhA=;
        b=PQcqd4OsYXbTV1xNsglCTEzL1AlqRwa1ET9X0DAoRjP27jZgkGHhKLgduYebxaMsDN
         lmceALFdnYM29/M7ta7krXlay14GfNtbEvdA6qI8nHKARZlDIe0QDChX/sKZ8aQ7/j3b
         QKOSveA7qxgQnElrtWN4X9KnjRV/JrGHnMs4VbgtPFnfVNS4Qryay9yZZmBywGcaFpNb
         oiR0sWMS0tR9BcxKkgJMXsR52zx/DKfUVHscAh27l5I4lDMD2WRnxse+TuCh55L5ysve
         qfkwRKZKNAILhch6GwKpLOPHuq0fbc3U4qsqqksWjWqfTFKUQqGRnCf5QU9rBk6/9ogI
         qaLA==
X-Gm-Message-State: AOAM533waTBSCHliLr2y1Bg2qZhkGlSh93KRpjowXbyDNADDzMLJtLuc
        nXp185r9gRCZYT1YyacEQuM=
X-Google-Smtp-Source: ABdhPJwxqgRjXRLqvsWiyVyvJuUKBRtZhQNhS4Qogwr1YUPHmD9eKytsedGPDVt/veFnBOl9Yftmkg==
X-Received: by 2002:a17:902:a40e:b0:143:ca72:be9d with SMTP id p14-20020a170902a40e00b00143ca72be9dmr75662813plq.67.1639143374142;
        Fri, 10 Dec 2021 05:36:14 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id t4sm3596068pfj.168.2021.12.10.05.36.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Dec 2021 05:36:13 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Like Xu <likexu@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v11 10/17] KVM: x86/pmu: Add IA32_DS_AREA MSR emulation to support guest DS
Date:   Fri, 10 Dec 2021 21:35:18 +0800
Message-Id: <20211210133525.46465-11-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210133525.46465-1-likexu@tencent.com>
References: <20211210133525.46465-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

From: Like Xu <like.xu@linux.intel.com>

When CPUID.01H:EDX.DS[21] is set, the IA32_DS_AREA MSR exists and points
to the linear address of the first byte of the DS buffer management area,
which is used to manage the PEBS records.

When guest PEBS is enabled, the MSR_IA32_DS_AREA MSR will be added to the
perf_guest_switch_msr() and switched during the VMX transitions just like
CORE_PERF_GLOBAL_CTRL MSR. The WRMSR to IA32_DS_AREA MSR brings a #GP(0)
if the source register contains a non-canonical address.

Originally-by: Andi Kleen <ak@linux.intel.com>
Co-developed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/events/intel/core.c    | 10 +++++++++-
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx/pmu_intel.c    | 11 +++++++++++
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 67ff6823dd62..7c6ba10c8422 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -21,6 +21,7 @@
 #include <asm/intel_pt.h>
 #include <asm/apic.h>
 #include <asm/cpu_device_id.h>
+#include <asm/kvm_host.h>
 
 #include "../perf_event.h"
 
@@ -3972,6 +3973,7 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
+	struct kvm_pmu *kvm_pmu = (struct kvm_pmu *)data;
 	u64 intel_ctrl = hybrid(cpuc->pmu, intel_ctrl);
 	u64 pebs_mask = cpuc->pebs_enabled & x86_pmu.pebs_capable;
 	int global_ctrl, pebs_enable;
@@ -4004,9 +4006,15 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 		return arr;
 	}
 
-	if (!x86_pmu.pebs_vmx)
+	if (!kvm_pmu || !x86_pmu.pebs_vmx)
 		return arr;
 
+	arr[(*nr)++] = (struct perf_guest_switch_msr){
+		.msr = MSR_IA32_DS_AREA,
+		.host = (unsigned long)cpuc->ds,
+		.guest = kvm_pmu->ds_area,
+	};
+
 	pebs_enable = (*nr)++;
 	arr[pebs_enable] = (struct perf_guest_switch_msr){
 		.msr = MSR_IA32_PEBS_ENABLE,
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d8b4d2072abb..8eac3ef5b05f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -518,6 +518,7 @@ struct kvm_pmu {
 	DECLARE_BITMAP(all_valid_pmc_idx, X86_PMC_IDX_MAX);
 	DECLARE_BITMAP(pmc_in_use, X86_PMC_IDX_MAX);
 
+	u64 ds_area;
 	u64 pebs_enable;
 	u64 pebs_enable_mask;
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index b7afd10c098e..a60221ed9b78 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -211,6 +211,9 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	case MSR_IA32_PEBS_ENABLE:
 		ret = vcpu->arch.perf_capabilities & PERF_CAP_PEBS_FORMAT;
 		break;
+	case MSR_IA32_DS_AREA:
+		ret = guest_cpuid_has(vcpu, X86_FEATURE_DS);
+		break;
 	default:
 		ret = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0) ||
 			get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0) ||
@@ -361,6 +364,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_PEBS_ENABLE:
 		msr_info->data = pmu->pebs_enable;
 		return 0;
+	case MSR_IA32_DS_AREA:
+		msr_info->data = pmu->ds_area;
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
@@ -428,6 +434,11 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 0;
 		}
 		break;
+	case MSR_IA32_DS_AREA:
+		if (is_noncanonical_address(data, vcpu))
+			return 1;
+		pmu->ds_area = data;
+		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
 		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
-- 
2.33.1

