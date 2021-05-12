Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011D237B850
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 10:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbhELIrM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 04:47:12 -0400
Received: from mga17.intel.com ([192.55.52.151]:10038 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230498AbhELIq5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 04:46:57 -0400
IronPort-SDR: SJfQ0DHc2GxqxaCGnpqoSYHE9pYkS/u3t5PBMEh5+Ep5weZot+zbDI1254xpM5RlqY8BCsXJsu
 lo8CxCEz0HZg==
X-IronPort-AV: E=McAfee;i="6200,9189,9981"; a="179918887"
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; 
   d="scan'208";a="179918887"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2021 01:45:49 -0700
IronPort-SDR: H6o6VzF/Tuz6GSKhXx19UWOhNqXTidR80XhT9ufzH8IdO2tDOsbvOqxs6/FZJJWYokFcMhNt9e
 9lVbj4V+hx5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,293,1613462400"; 
   d="scan'208";a="392636420"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga006.jf.intel.com with ESMTP; 12 May 2021 01:45:45 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, peterz@infradead.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        eranian@google.com, wei.w.wang@intel.com, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <andi.kleen@intel.com>
Subject: [PATCH v3 5/5] KVM: x86/pmu: Expose PEBS-via-PT in the KVM supported capabilities
Date:   Wed, 12 May 2021 16:44:46 +0800
Message-Id: <20210512084446.342526-6-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512084446.342526-1-like.xu@linux.intel.com>
References: <20210512084446.342526-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The hypervisor userspace can dis/enable it via the MSR-based feature
"MSR_IA32_PERF_CAPABILITIES [bit 16]". If guest also has basic PT support,
it can output the PEBS records to the PT buffer.

Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <andi.kleen@intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/vmx/capabilities.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index fd8c9822db9e..e04b50174dd5 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -398,8 +398,11 @@ static inline u64 vmx_get_perf_capabilities(void)
 
 	perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
 
-	if (vmx_pebs_supported())
+	if (vmx_pebs_supported()) {
 		perf_cap |= host_perf_cap & PERF_CAP_PEBS_MASK;
+		if (vmx_pt_mode_is_host_guest())
+			perf_cap |= host_perf_cap & PERF_CAP_PEBS_OUTPUT_PT;
+	}
 
 	return perf_cap;
 }
-- 
2.31.1

