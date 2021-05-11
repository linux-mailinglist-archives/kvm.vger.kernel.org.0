Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 084F7379D13
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 04:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbhEKCpC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 22:45:02 -0400
Received: from mga14.intel.com ([192.55.52.115]:39581 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230360AbhEKCoy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 22:44:54 -0400
IronPort-SDR: KHZM87gkq5rO1VvN0PDZeNmSHCnaVSK2CeTY1TBJHBUG6BU+WqCBolEJuEpJ/ryT/Wtq8FI0v6
 wn7yk4SB0BiQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9980"; a="199015632"
X-IronPort-AV: E=Sophos;i="5.82,290,1613462400"; 
   d="scan'208";a="199015632"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 19:43:48 -0700
IronPort-SDR: ZF4aXKIKalxcAeWfmLIEGFgyL2m9Zuxzs7YqxrAkTsj+w8joXHmQlPzgVDi7qoDEcnBUGDtze3
 4Ud/8GII6BmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,290,1613462400"; 
   d="scan'208";a="468591977"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by fmsmga002.fm.intel.com with ESMTP; 10 May 2021 19:43:41 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        Kan Liang <kan.liang@linux.intel.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v6 11/16] KVM: x86/pmu: Adjust precise_ip to emulate Ice Lake guest PDIR counter
Date:   Tue, 11 May 2021 10:42:09 +0800
Message-Id: <20210511024214.280733-12-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210511024214.280733-1-like.xu@linux.intel.com>
References: <20210511024214.280733-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PEBS-PDIR facility on Ice Lake server is supported on IA31_FIXED0 only.
If the guest configures counter 32 and PEBS is enabled, the PEBS-PDIR
facility is supposed to be used, in which case KVM adjusts attr.precise_ip
to 3 and request host perf to assign the exactly requested counter or fail.

The cpu model check is also required since some platforms may place the
PEBS-PDIR facility in another counter index.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/pmu.c | 2 ++
 arch/x86/kvm/pmu.h | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 0f86c1142f17..d3f746877d1b 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -149,6 +149,8 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		 * in the PEBS record is calibrated on the guest side.
 		 */
 		attr.precise_ip = 1;
+		if (x86_match_cpu(vmx_icl_pebs_cpu) && pmc->idx == 32)
+			attr.precise_ip = 3;
 	}
 
 	event = perf_event_create_kernel_counter(&attr, -1, current,
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 67e753edfa22..1af86ae1d3f2 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -4,6 +4,8 @@
 
 #include <linux/nospec.h>
 
+#include <asm/cpu_device_id.h>
+
 #define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu)
 #define pmu_to_vcpu(pmu)  (container_of((pmu), struct kvm_vcpu, arch.pmu))
 #define pmc_to_pmu(pmc)   (&(pmc)->vcpu->arch.pmu)
@@ -16,6 +18,11 @@
 #define VMWARE_BACKDOOR_PMC_APPARENT_TIME	0x10002
 
 #define MAX_FIXED_COUNTERS	3
+static const struct x86_cpu_id vmx_icl_pebs_cpu[] = {
+	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X, NULL),
+	{}
+};
 
 struct kvm_event_hw_type_mapping {
 	u8 eventsel;
-- 
2.31.1

