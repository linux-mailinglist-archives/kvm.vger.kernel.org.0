Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 468772043ED
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 00:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731511AbgFVWoe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 18:44:34 -0400
Received: from mga18.intel.com ([134.134.136.126]:27426 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730943AbgFVWm7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 18:42:59 -0400
IronPort-SDR: XLFIK+YfUKeGhx+Tet1yfda2xJKB0G8cYqne/26fINdreBNzTGl7IusJgjbyLjDViBLp3x08EE
 DKiSaR37P+OQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="131303578"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="131303578"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 15:42:55 -0700
IronPort-SDR: FGeySH7zGAHkWHnu3g5/cg1JH6n1nzHSgyhIDbSMWmggd/VhzW1w1yE+Qspo7J9cXaFqxvshkA
 Qzk6yYhWPXfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="264634940"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga008.fm.intel.com with ESMTP; 22 Jun 2020 15:42:55 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 13/15] KVM: VMX: Rename "vmx_set_guest_msr" to "vmx_set_guest_uret_msr"
Date:   Mon, 22 Jun 2020 15:42:47 -0700
Message-Id: <20200622224249.29562-14-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200622224249.29562-1-sean.j.christopherson@intel.com>
References: <20200622224249.29562-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
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
index 6662c1aab9b2..178315b2758b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -645,7 +645,8 @@ struct vmx_uret_msr *vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr)
 	return NULL;
 }
 
-static int vmx_set_guest_msr(struct vcpu_vmx *vmx, struct vmx_uret_msr *msr, u64 data)
+static int vmx_set_guest_uret_msr(struct vcpu_vmx *vmx,
+				  struct vmx_uret_msr *msr, u64 data)
 {
 	int ret = 0;
 
@@ -2232,7 +2233,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	find_uret_msr:
 		msr = vmx_find_uret_msr(vmx, msr_index);
 		if (msr)
-			ret = vmx_set_guest_msr(vmx, msr, data);
+			ret = vmx_set_guest_uret_msr(vmx, msr, data);
 		else
 			ret = kvm_set_msr_common(vcpu, msr_info);
 	}
@@ -7282,7 +7283,7 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
 		msr = vmx_find_uret_msr(vmx, MSR_IA32_TSX_CTRL);
 		if (msr) {
 			bool enabled = guest_cpuid_has(vcpu, X86_FEATURE_RTM);
-			vmx_set_guest_msr(vmx, msr, enabled ? 0 : TSX_CTRL_RTM_DISABLE);
+			vmx_set_guest_uret_msr(vmx, msr, enabled ? 0 : TSX_CTRL_RTM_DISABLE);
 		}
 	}
 }
-- 
2.26.0

