Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F28FC29FC5C
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 04:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgJ3D4o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Oct 2020 23:56:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:4238 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725806AbgJ3D4n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Oct 2020 23:56:43 -0400
IronPort-SDR: cn+X+mMRBdsXM3H7JPHE1aRuTU99+VUQ+wWK1m6cy3cvLeY/hO/svT7T4Asar1tbSePFi7Up5O
 hq16o0jVeTWQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9789"; a="168685735"
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="168685735"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2020 20:56:42 -0700
IronPort-SDR: QOnp9+w/Jn9qEmdAlU/HRL1fIh3DwDlK4H7NjgvjMNnYR4zhy71OLIMyns+Pav1nn6j4pkyw8C
 KtmTSCOjwg8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,432,1596524400"; 
   d="scan'208";a="525770411"
Received: from sqa-gate.sh.intel.com (HELO clx-ap-likexu.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 29 Oct 2020 20:56:39 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND v13 02/10] KVM: x86/vmx: Make vmx_set_intercept_for_msr() non-static and expose it
Date:   Fri, 30 Oct 2020 11:52:12 +0800
Message-Id: <20201030035220.102403-3-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20201030035220.102403-1-like.xu@linux.intel.com>
References: <20201030035220.102403-1-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To make code responsibilities clear, we may resue and invoke the
vmx_set_intercept_for_msr() in other vmx-specific files (e.g. pmu_intel.c),
so expose it to passthrough LBR msrs later.

Signed-off-by: Like Xu <like.xu@linux.intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 arch/x86/kvm/vmx/vmx.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c12faeebd390..4085c90c8fc2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3788,7 +3788,7 @@ static __always_inline void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu,
 		vmx_set_msr_bitmap_write(msr_bitmap, msr);
 }
 
-static __always_inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu,
+void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu,
 						      u32 msr, int type, bool value)
 {
 	if (value)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index f6f66e5c6510..cf9d27f1e122 100644
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
2.21.3

