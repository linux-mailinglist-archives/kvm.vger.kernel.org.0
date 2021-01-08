Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54A62EEB06
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 02:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729873AbhAHBo4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 20:44:56 -0500
Received: from mga09.intel.com ([134.134.136.24]:28000 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727634AbhAHBo4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 20:44:56 -0500
IronPort-SDR: gezU8Bg7z5lJouakynAtjOYUjvV7M0MX4F/z1h4PCCmva7TdY2Hm02J5P/i8HWBlezYo94MjcN
 Cn7OWI+jXTZw==
X-IronPort-AV: E=McAfee;i="6000,8403,9857"; a="177672382"
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="177672382"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 17:43:10 -0800
IronPort-SDR: TleXBY4Q+h7S5GQQZ64EWYJEh4MdbfmmU77MRXl3RYguG7R5seBQAshzujRnbLbg6nFEofFsW7
 6mRLD7CBC0HQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="379938037"
Received: from clx-ap-likexu.sh.intel.com ([10.239.48.108])
  by orsmga008.jf.intel.com with ESMTP; 07 Jan 2021 17:43:06 -0800
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, kan.liang@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND v13 02/10] KVM: x86/vmx: Make vmx_set_intercept_for_msr() non-static
Date:   Fri,  8 Jan 2021 09:36:56 +0800
Message-Id: <20210108013704.134985-3-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210108013704.134985-1-like.xu@linux.intel.com>
References: <20210108013704.134985-1-like.xu@linux.intel.com>
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
index 23b46327527e..035bd6d279a4 100644
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

