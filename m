Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5983F30A124
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 06:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhBAFTB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 00:19:01 -0500
Received: from mga17.intel.com ([192.55.52.151]:9254 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229557AbhBAFS4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 00:18:56 -0500
IronPort-SDR: QUkfAx+HIcWOgSAvuPuauGtXmMgTpS5v308jxX8LPQKmVgPXHlO/50NjUL8aQQkr54dNtr0OZh
 vuy1ielIzL0w==
X-IronPort-AV: E=McAfee;i="6000,8403,9881"; a="160401827"
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="160401827"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2021 21:17:11 -0800
IronPort-SDR: 0hlxxwExa63tdWHjRkLRb8aR41/Iswwcm3TstTtVQpxu90IQlSP3P9yQ91Q1OjLswhrvNE1yGs
 CLmfyjxIInvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,391,1602572400"; 
   d="scan'208";a="390694260"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga008.jf.intel.com with ESMTP; 31 Jan 2021 21:17:08 -0800
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
Subject: [PATCH v14 01/11] KVM: x86/vmx: Make vmx_set_intercept_for_msr() non-static
Date:   Mon,  1 Feb 2021 13:10:29 +0800
Message-Id: <20210201051039.255478-2-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210201051039.255478-1-like.xu@linux.intel.com>
References: <20210201051039.255478-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To make code responsibilities clear, we may resue and invoke the
vmx_set_intercept_for_msr() in other vmx-specific files (e.g. pmu_intel.c),
so expose it to passthrough LBR msrs later.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 arch/x86/kvm/vmx/vmx.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6f94620fd0db..4aa378c20986 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3787,7 +3787,7 @@ static __always_inline void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu,
 		vmx_set_msr_bitmap_write(msr_bitmap, msr);
 }
 
-static __always_inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu,
+void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu,
 						      u32 msr, int type, bool value)
 {
 	if (value)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 9d3a557949ac..adc40d36909c 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -341,6 +341,8 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu);
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
 int vmx_find_loadstore_msr_slot(struct vmx_msrs *m, u32 msr);
 void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu);
+void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu,
+	u32 msr, int type, bool value);
 
 static inline u8 vmx_get_rvi(void)
 {
-- 
2.29.2

