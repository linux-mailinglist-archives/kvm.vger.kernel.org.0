Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C086F36004E
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 05:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbhDODVh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 23:21:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:10590 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230023AbhDODVa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 23:21:30 -0400
IronPort-SDR: Lmg4q4qpWnM5rX0EsvYGpIylfMLtmaqjVG/SwkN7l4gKdDAPmm4WkRDt5bzrMoeb81qRrA7oCp
 naeiw/ZvwyBg==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="215281573"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="215281573"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 20:21:08 -0700
IronPort-SDR: 961zQWue4/RwxgW/9FPxzaO/OOhXO39JbejTexb1K23s115QbuocFNquUBkweee2bZV1u+iXKh
 QS8YdScasLBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="425014069"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga008.jf.intel.com with ESMTP; 14 Apr 2021 20:21:04 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     peterz@infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     andi@firstfloor.org, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v5 11/16] KVM: x86/pmu: Adjust precise_ip to emulate Ice Lake guest PDIR counter
Date:   Thu, 15 Apr 2021 11:20:11 +0800
Message-Id: <20210415032016.166201-12-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210415032016.166201-1-like.xu@linux.intel.com>
References: <20210415032016.166201-1-like.xu@linux.intel.com>
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
index 7b30bc967af3..d9157128e6eb 100644
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
2.30.2

