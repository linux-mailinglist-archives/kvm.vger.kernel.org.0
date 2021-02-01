Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9C9D30A21B
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 07:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232179AbhBAGnF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 01:43:05 -0500
Received: from mga17.intel.com ([192.55.52.151]:9254 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231513AbhBAFZ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 00:25:57 -0500
IronPort-SDR: sJLq/ATtHEar+p4mTKyiXdf6/Ln5AkGcDfsK6g5awEz/Oh/qsEaESmkRVc/tmRPYuNhBveAwXt
 1W4QMIuobFTQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9881"; a="160401854"
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="160401854"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2021 21:17:39 -0800
IronPort-SDR: qYLShahsDQnOc5eCpWaICfHY+mfxnKdCTdXP0KwuqDV+ks+zV0MhHIH9lP677H1PeqJOxOttZp
 sl+kPuymgD4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="390694331"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga008.jf.intel.com with ESMTP; 31 Jan 2021 21:17:36 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, ak@linux.intel.com,
        wei.w.wang@intel.com, kan.liang@intel.com,
        alex.shi@linux.alibaba.com, kvm@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v14 10/11] KVM: vmx/pmu: Expose LBR_FMT in the MSR_IA32_PERF_CAPABILITIES
Date:   Mon,  1 Feb 2021 13:10:38 +0800
Message-Id: <20210201051039.255478-11-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210201051039.255478-1-like.xu@linux.intel.com>
References: <20210201051039.255478-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Userspace could enable guest LBR feature when the exactly supported
LBR format value is initialized to the MSR_IA32_PERF_CAPABILITIES
and the LBR is also compatible with vPMU version and host cpu model.

The LBR could be enabled on the guest if host perf supports LBR
(checked via x86_perf_get_lbr()) and the vcpu model is compatible
with the host one.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/vmx/capabilities.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 57b940c613ab..c49f3ee8eca8 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -374,11 +374,18 @@ static inline bool vmx_pt_mode_is_host_guest(void)
 
 static inline u64 vmx_get_perf_capabilities(void)
 {
+	u64 perf_cap;
+
+	if (boot_cpu_has(X86_FEATURE_PDCM))
+		rdmsrl(MSR_IA32_PERF_CAPABILITIES, perf_cap);
+
+	perf_cap &= PMU_CAP_LBR_FMT;
+
 	/*
 	 * Since counters are virtualized, KVM would support full
 	 * width counting unconditionally, even if the host lacks it.
 	 */
-	return PMU_CAP_FW_WRITES;
+	return PMU_CAP_FW_WRITES | perf_cap;
 }
 
 static inline u64 vmx_supported_debugctl(void)
-- 
2.29.2

