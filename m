Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62CBD285671
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 03:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbgJGBoU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 21:44:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:7786 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725996AbgJGBoT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Oct 2020 21:44:19 -0400
IronPort-SDR: augEx6RMjvDLytXLG/GDFNBA2sNW3r6SLo93/tBX1nLOydiaXJV+tKA/2/gVdghC8xT0a/DvAv
 a7CRZppb8RlQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9766"; a="164914598"
X-IronPort-AV: E=Sophos;i="5.77,344,1596524400"; 
   d="scan'208";a="164914598"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 18:44:18 -0700
IronPort-SDR: ClxIysU7kjze7rjcytzQqlWKI4Hrh8ofDwhey6mUxV/8Oq67RLswPUT3G7X60HFIQ+ziR+v/2o
 qzZ0O3o5fI0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,344,1596524400"; 
   d="scan'208";a="297410300"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga008.fm.intel.com with ESMTP; 06 Oct 2020 18:44:18 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stas Sergeev <stsp@users.sourceforge.net>
Subject: [PATCH 2/6] KVM: VMX: Drop explicit 'nested' check from vmx_set_cr4()
Date:   Tue,  6 Oct 2020 18:44:13 -0700
Message-Id: <20201007014417.29276-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201007014417.29276-1-sean.j.christopherson@intel.com>
References: <20201007014417.29276-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop vmx_set_cr4()'s explicit check on the 'nested' module param now
that common x86 handles the check by incorporating VMXE into the CR4
reserved bits, via kvm_cpu_caps.  X86_FEATURE_VMX is set in kvm_cpu_caps
(by vmx_set_cpu_caps()), if and only if 'nested' is true.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 99ea57ba2a84..dac93346aca9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3104,18 +3104,13 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		}
 	}
 
-	if (cr4 & X86_CR4_VMXE) {
-		/*
-		 * To use VMXON (and later other VMX instructions), a guest
-		 * must first be able to turn on cr4.VMXE (see handle_vmon()).
-		 * So basically the check on whether to allow nested VMX
-		 * is here.  We operate under the default treatment of SMM,
-		 * so VMX cannot be enabled under SMM.  Note, guest CPUID is
-		 * intentionally ignored, it's handled by cr4_guest_rsvd_bits.
-		 */
-		if (!nested || is_smm(vcpu))
-			return 1;
-	}
+	/*
+	 * We operate under the default treatment of SMM, so VMX cannot be
+	 * enabled under SMM.  Note, whether or not VMXE is allowed at all is
+	 * handled by kvm_valid_cr4().
+	 */
+	if ((cr4 & X86_CR4_VMXE) && is_smm(vcpu))
+		return 1;
 
 	if (vmx->nested.vmxon && !nested_cr4_valid(vcpu, cr4))
 		return 1;
-- 
2.28.0

