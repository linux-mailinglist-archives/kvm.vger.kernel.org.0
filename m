Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88DF2275F6A
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 20:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgIWSEO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 14:04:14 -0400
Received: from mga14.intel.com ([192.55.52.115]:6222 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbgIWSEN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 14:04:13 -0400
IronPort-SDR: /0McvvQZ/cnAJD4Rt7Dz5aD4LTU4wniefl4rPxTT2j1/f1S+PGsmE5cOk/e8pNzcKMbTb6n/S/
 4LP9lT6oCEvQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="160269599"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="160269599"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 11:04:13 -0700
IronPort-SDR: DLoVR0vZdjC/HM/THjfAigtTJkqWRS3+NKwKrtQZkxvUb+tiVlpIqvm4akPIYr0w8oGmi2ahFr
 7myyLUsDdsdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="322670303"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga002.jf.intel.com with ESMTP; 23 Sep 2020 11:04:11 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 13/15] KVM: VMX: Rename "vmx_set_guest_msr" to "vmx_set_guest_uret_msr"
Date:   Wed, 23 Sep 2020 11:04:07 -0700
Message-Id: <20200923180409.32255-14-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923180409.32255-1-sean.j.christopherson@intel.com>
References: <20200923180409.32255-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add "uret" to vmx_set_guest_msr() to explicitly associate it with the
guest_uret_msrs array, and to differentiate it from vmx_set_msr() as
well as VMX's load/store MSRs.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3b4fb9ef511d..363099ec661d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -643,7 +643,8 @@ struct vmx_uret_msr *vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr)
 	return NULL;
 }
 
-static int vmx_set_guest_msr(struct vcpu_vmx *vmx, struct vmx_uret_msr *msr, u64 data)
+static int vmx_set_guest_uret_msr(struct vcpu_vmx *vmx,
+				  struct vmx_uret_msr *msr, u64 data)
 {
 	int ret = 0;
 
@@ -2203,7 +2204,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	find_uret_msr:
 		msr = vmx_find_uret_msr(vmx, msr_index);
 		if (msr)
-			ret = vmx_set_guest_msr(vmx, msr, data);
+			ret = vmx_set_guest_uret_msr(vmx, msr, data);
 		else
 			ret = kvm_set_msr_common(vcpu, msr_info);
 	}
@@ -7240,7 +7241,7 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		msr = vmx_find_uret_msr(vmx, MSR_IA32_TSX_CTRL);
 		if (msr) {
 			bool enabled = guest_cpuid_has(vcpu, X86_FEATURE_RTM);
-			vmx_set_guest_msr(vmx, msr, enabled ? 0 : TSX_CTRL_RTM_DISABLE);
+			vmx_set_guest_uret_msr(vmx, msr, enabled ? 0 : TSX_CTRL_RTM_DISABLE);
 		}
 	}
 }
-- 
2.28.0

