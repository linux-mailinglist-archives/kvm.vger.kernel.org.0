Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276E338056F
	for <lists+kvm@lfdr.de>; Fri, 14 May 2021 10:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233693AbhENIqn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 04:46:43 -0400
Received: from mga06.intel.com ([134.134.136.31]:2925 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231839AbhENIqn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 May 2021 04:46:43 -0400
IronPort-SDR: l4e5DGRN86ONAeZfXa6utUVo8amSBRPu8oKaJbFwxl80CBXD5WhiV3RWRkwBcqThd5ZaxAq4LS
 o9e3xItDLUMQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9983"; a="261379995"
X-IronPort-AV: E=Sophos;i="5.82,299,1613462400"; 
   d="scan'208";a="261379995"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2021 01:45:31 -0700
IronPort-SDR: GWVlx1jD/WhhKk0Pyewb9aPU/D6oWp9TNtglPJKLRhY1pr62N0XD6c5OWGIz0W5r7jqP3JmbpJ
 u4RpKUnL1Dqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,299,1613462400"; 
   d="scan'208";a="538739299"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by fmsmga001.fm.intel.com with ESMTP; 14 May 2021 01:45:28 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
Subject: [PATCH] KVM: x86/pt: Do not inject TraceToPAPMI when guest PT isn't supported
Date:   Fri, 14 May 2021 16:44:36 +0800
Message-Id: <20210514084436.848396-1-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a PT perf user is running in system-wide mode on the host,
the guest (w/ pt_mode=0) will warn about anonymous NMIs from
kvm_handle_intel_pt_intr():

[   18.126444] Uhhuh. NMI received for unknown reason 10 on CPU 0.
[   18.126447] Do you have a strange power saving mode enabled?
[   18.126448] Dazed and confused, but trying to continue

In this case, these PMIs should be handled by the host PT handler().
When PT is used in guest-only mode, it's harmless to call host handler.

Fix: 8479e04e7d("KVM: x86: Inject PMI for KVM guest")
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/events/intel/core.c | 3 +--
 arch/x86/kvm/x86.c           | 3 +++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 2521d03de5e0..2f09eb0853de 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2853,8 +2853,7 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
 		if (unlikely(perf_guest_cbs && perf_guest_cbs->is_in_guest() &&
 			perf_guest_cbs->handle_intel_pt_intr))
 			perf_guest_cbs->handle_intel_pt_intr();
-		else
-			intel_pt_interrupt();
+		intel_pt_interrupt();
 	}
 
 	/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6529e2023147..6660f3948cea 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8087,6 +8087,9 @@ static void kvm_handle_intel_pt_intr(void)
 {
 	struct kvm_vcpu *vcpu = __this_cpu_read(current_vcpu);
 
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_INTEL_PT))
+		return;
+
 	kvm_make_request(KVM_REQ_PMI, vcpu);
 	__set_bit(MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI_BIT,
 			(unsigned long *)&vcpu->arch.pmu.global_status);
-- 
2.31.1

