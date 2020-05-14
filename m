Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4FA1D2A35
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 10:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgENIb7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 04:31:59 -0400
Received: from mga18.intel.com ([134.134.136.126]:12116 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726170AbgENIb6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 04:31:58 -0400
IronPort-SDR: tZ8rUyBH5JtvRGlCcggewRvjav/RWEMlBimSEkLx0428gDuqTVrna+VDQpr3YjXpv4Tog3siCi
 Vm0N+YBIMWkg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2020 01:31:48 -0700
IronPort-SDR: bIFdmafFsMjEa8hO3SPpcMFfY4ADcsoVaH6+a8TCzaMA/b+LX37aMRpsVnsMM61CUVePSMmSI3
 WRG2qw8ZHC2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,390,1583222400"; 
   d="scan'208";a="341540043"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by orsmga001.jf.intel.com with ESMTP; 14 May 2020 01:31:45 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>, ak@linux.intel.com,
        wei.w.wang@intel.com, Like Xu <like.xu@linux.intel.com>
Subject: [PATCH v11 11/11] KVM: x86/pmu: Reduce the overhead of LBR passthrough or cancellation
Date:   Thu, 14 May 2020 16:30:54 +0800
Message-Id: <20200514083054.62538-12-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200514083054.62538-1-like.xu@linux.intel.com>
References: <20200514083054.62538-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After passthrough the LBR msrs to the guest, there is no need to call
intel_pmu_intercept_lbr_msrs() again and again, and vice versa.

If host reclaims the LBR between two availability checks, the interception
state and LBR records can be safely preserved due to native save/restore
support from guest LBR event.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h | 3 +++
 arch/x86/kvm/pmu.c              | 1 +
 arch/x86/kvm/vmx/pmu_intel.c    | 9 +++++++++
 3 files changed, 13 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 57b281c4b196..dd51250c5688 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -511,6 +511,9 @@ struct kvm_pmu {
 	 * The records may be inaccurate if the host reclaims the LBR.
 	 */
 	struct perf_event *lbr_event;
+
+	/* A flag to reduce the overhead of LBR pass-through or cancellation. */
+	bool lbr_already_available;
 };
 
 struct kvm_pmu_ops;
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index d0dece055605..583ecb5f5f7c 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -437,6 +437,7 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
 	init_irq_work(&pmu->irq_work, kvm_pmi_trigger_fn);
 	pmu->event_count = 0;
 	pmu->need_cleanup = false;
+	pmu->lbr_already_available = false;
 	kvm_pmu_refresh(vcpu);
 }
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index db185dca903d..408d80c9418b 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -316,6 +316,7 @@ static void intel_pmu_free_lbr_event(struct kvm_vcpu *vcpu)
 
 	perf_event_release_kernel(event);
 	intel_pmu_intercept_lbr_msrs(vcpu, true);
+	pmu->lbr_already_available = false;
 	pmu->event_count--;
 	pmu->lbr_event = NULL;
 }
@@ -653,10 +654,18 @@ static bool intel_pmu_lbr_is_availabile(struct kvm_vcpu *vcpu)
 	if (!pmu->lbr_event)
 		return false;
 
+	if (pmu->lbr_already_available && event_is_oncpu(pmu->lbr_event))
+		return true;
+
+	if (!pmu->lbr_already_available && !event_is_oncpu(pmu->lbr_event))
+		return false;
+
 	if (event_is_oncpu(pmu->lbr_event)) {
 		intel_pmu_intercept_lbr_msrs(vcpu, false);
+		pmu->lbr_already_available = true;
 	} else {
 		intel_pmu_intercept_lbr_msrs(vcpu, true);
+		pmu->lbr_already_available = false;
 		return false;
 	}
 
-- 
2.21.3

