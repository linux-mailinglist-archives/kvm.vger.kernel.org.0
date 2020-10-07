Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C140528566C
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 03:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbgJGBoV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 21:44:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:7786 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726323AbgJGBoT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Oct 2020 21:44:19 -0400
IronPort-SDR: OQZzdcldT/AWS8dV55KTiw1kOjynNkACiTreEVQmX5tEUz4ZDympu1zekgdIk4WhVo1uIFSuHM
 J+w2u77omkpw==
X-IronPort-AV: E=McAfee;i="6000,8403,9766"; a="164914596"
X-IronPort-AV: E=Sophos;i="5.77,344,1596524400"; 
   d="scan'208";a="164914596"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2020 18:44:18 -0700
IronPort-SDR: vdIVN1gcPV5l+C1riTE0uMgVqZRz19PP8fLkc8NyKxq/zSXAadMYnLp8a/oCbygAnVpLRS/dFO
 dIxG6y8AWqgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,344,1596524400"; 
   d="scan'208";a="297410297"
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
Subject: [PATCH 1/6] KVM: VMX: Drop guest CPUID check for VMXE in vmx_set_cr4()
Date:   Tue,  6 Oct 2020 18:44:12 -0700
Message-Id: <20201007014417.29276-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201007014417.29276-1-sean.j.christopherson@intel.com>
References: <20201007014417.29276-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop vmx_set_cr4()'s somewhat hidden guest_cpuid_has() check on VMXE now
that common x86 handles the check by incorporating VMXE into the CR4
reserved bits, i.e. in cr4_guest_rsvd_bits.  This fixes a bug where KVM
incorrectly rejects KVM_SET_SREGS with CR4.VMXE=1 if it's executed
before KVM_SET_CPUID{,2}.

Fixes: 5e1746d6205d ("KVM: nVMX: Allow setting the VMXE bit in CR4")
Reported-by: Stas Sergeev <stsp@users.sourceforge.net>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e23c41ccfac9..99ea57ba2a84 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3110,9 +3110,10 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		 * must first be able to turn on cr4.VMXE (see handle_vmon()).
 		 * So basically the check on whether to allow nested VMX
 		 * is here.  We operate under the default treatment of SMM,
-		 * so VMX cannot be enabled under SMM.
+		 * so VMX cannot be enabled under SMM.  Note, guest CPUID is
+		 * intentionally ignored, it's handled by cr4_guest_rsvd_bits.
 		 */
-		if (!nested_vmx_allowed(vcpu) || is_smm(vcpu))
+		if (!nested || is_smm(vcpu))
 			return 1;
 	}
 
-- 
2.28.0

