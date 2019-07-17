Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0FA36B4C2
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2019 04:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbfGQCyY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jul 2019 22:54:24 -0400
Received: from mga18.intel.com ([134.134.136.126]:5742 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725294AbfGQCyY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jul 2019 22:54:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jul 2019 19:54:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,272,1559545200"; 
   d="scan'208";a="175583455"
Received: from likexu-e5-2699-v4.sh.intel.com ([10.239.48.159])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Jul 2019 19:54:22 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     like.xu@linux.intel.com, wehuang@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/vPMU: reset pmc->counter to 0 for pmu fixed_counters
Date:   Wed, 17 Jul 2019 10:51:18 +0800
Message-Id: <20190717025118.16783-1-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To avoid semantic inconsistency, the fixed_counters in Intel vPMU
need to be reset to 0 in intel_pmu_reset() as gp_counters does.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 68d231d49c7a..4dea0e0e7e39 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -337,17 +337,22 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 static void intel_pmu_reset(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc = NULL;
 	int i;
 
 	for (i = 0; i < INTEL_PMC_MAX_GENERIC; i++) {
-		struct kvm_pmc *pmc = &pmu->gp_counters[i];
+		pmc = &pmu->gp_counters[i];
 
 		pmc_stop_counter(pmc);
 		pmc->counter = pmc->eventsel = 0;
 	}
 
-	for (i = 0; i < INTEL_PMC_MAX_FIXED; i++)
-		pmc_stop_counter(&pmu->fixed_counters[i]);
+	for (i = 0; i < INTEL_PMC_MAX_FIXED; i++) {
+		pmc = &pmu->fixed_counters[i];
+
+		pmc_stop_counter(pmc);
+		pmc->counter = 0;
+	}
 
 	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status =
 		pmu->global_ovf_ctrl = 0;
-- 
2.21.0

