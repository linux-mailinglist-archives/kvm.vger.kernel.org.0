Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079813B0096
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 11:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbhFVJqp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 05:46:45 -0400
Received: from mga18.intel.com ([134.134.136.126]:20229 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230083AbhFVJq0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 05:46:26 -0400
IronPort-SDR: 5hNk4FX5JqagLOLL+f18VZ914uSGraWgmHYycsczab+ax1PHR0RyemlXnl7DAnJIP3BdVNH6tM
 UmnJaV2bjCQQ==
X-IronPort-AV: E=McAfee;i="6200,9189,10022"; a="194331004"
X-IronPort-AV: E=Sophos;i="5.83,291,1616482800"; 
   d="scan'208";a="194331004"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2021 02:44:03 -0700
IronPort-SDR: Fpyh1Z2Cb8sxx3pgdBnSzyIIjbQ9eIN7V3nDGDwjr7dH0regVmxgM2+5pPNTriPG0F16tTNzdl
 DqYbDrmIzqgg==
X-IronPort-AV: E=Sophos;i="5.83,291,1616482800"; 
   d="scan'208";a="641600236"
Received: from vmm_a4_icx.sh.intel.com (HELO localhost.localdomain) ([10.239.53.245])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2021 02:43:58 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     peterz@infradead.org, pbonzini@redhat.com
Cc:     bp@alien8.de, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        weijiang.yang@intel.com, kan.liang@linux.intel.com,
        ak@linux.intel.com, wei.w.wang@intel.com, eranian@google.com,
        liuxiangdong5@huawei.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, like.xu.linux@gmail.com,
        Like Xu <like.xu@linux.intel.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V7 10/18] KVM: x86/pmu: Adjust precise_ip to emulate Ice Lake guest PDIR counter
Date:   Tue, 22 Jun 2021 17:42:58 +0800
Message-Id: <20210622094306.8336-11-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210622094306.8336-1-lingshan.zhu@intel.com>
References: <20210622094306.8336-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

The PEBS-PDIR facility on Ice Lake server is supported on IA31_FIXED0 only.
If the guest configures counter 32 and PEBS is enabled, the PEBS-PDIR
facility is supposed to be used, in which case KVM adjusts attr.precise_ip
to 3 and request host perf to assign the exactly requested counter or fail.

The CPU model check is also required since some platforms may place the
PEBS-PDIR facility in another counter index.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
---
 arch/x86/kvm/pmu.c | 2 ++
 arch/x86/kvm/pmu.h | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index d76b0a5d80d7..b907aba35ff3 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -153,6 +153,8 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		 * could possibly care here is unsupported and needs changes.
 		 */
 		attr.precise_ip = 1;
+		if (x86_match_cpu(vmx_icl_pebs_cpu) && pmc->idx == 32)
+			attr.precise_ip = 3;
 	}
 	if (pebs || intr)
 		ovf = kvm_perf_overflow_intr;
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
2.27.0

