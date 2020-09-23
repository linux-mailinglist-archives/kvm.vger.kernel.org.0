Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B6D275DE5
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 18:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgIWQuu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 12:50:50 -0400
Received: from mga06.intel.com ([134.134.136.31]:17994 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726184AbgIWQut (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 12:50:49 -0400
IronPort-SDR: F/fretrXfzeCEWNQemE60rLuGjORalX9m1f1+79oZNYe+37F8SzR2wDnEjFBgPxOGqwFOB+v36
 0db31aiY9lSw==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="222529027"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="222529027"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 09:50:48 -0700
IronPort-SDR: 2gcjom9DEQpF2izpHbXLtYH7jQGi8ELW2PWYwc2mkedzZ8iTfcVrFIeFsxporCVfoTeMToJ0JK
 Nljkga1Z4o4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="454985298"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga004.jf.intel.com with ESMTP; 23 Sep 2020 09:50:48 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] KVM: VMX: Unconditionally clear CPUID.INVPCID if !CPUID.PCID
Date:   Wed, 23 Sep 2020 09:50:46 -0700
Message-Id: <20200923165048.20486-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923165048.20486-1-sean.j.christopherson@intel.com>
References: <20200923165048.20486-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If PCID is not exposed to the guest, clear INVPCID in the guest's CPUID
even if the VMCS INVPCID enable is not supported.  This will allow
consolidating the secondary execution control adjustment code without
having to special case INVPCID.

Technically, this fixes a bug where !CPUID.PCID && CPUID.INVCPID would
result in unexpected guest behavior (#UD instead of #GP/#PF), but KVM
doesn't support exposing INVPCID if it's not supported in the VMCS, i.e.
such a config is broken/bogus no matter what.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cfed29329e4f..57e48c5a1e91 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4149,16 +4149,22 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 		}
 	}
 
+	/*
+	 * Expose INVPCID if and only if PCID is also exposed to the guest.
+	 * INVPCID takes a #UD when it's disabled in the VMCS, but a #GP or #PF
+	 * if CR4.PCIDE=0.  Enumerating CPUID.INVPCID=1 would lead to incorrect
+	 * behavior from the guest perspective (it would expect #GP or #PF).
+	 */
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_PCID))
+		guest_cpuid_clear(vcpu, X86_FEATURE_INVPCID);
+
 	if (cpu_has_vmx_invpcid()) {
 		/* Exposing INVPCID only when PCID is exposed */
 		bool invpcid_enabled =
-			guest_cpuid_has(vcpu, X86_FEATURE_INVPCID) &&
-			guest_cpuid_has(vcpu, X86_FEATURE_PCID);
+			guest_cpuid_has(vcpu, X86_FEATURE_INVPCID);
 
-		if (!invpcid_enabled) {
+		if (!invpcid_enabled)
 			exec_control &= ~SECONDARY_EXEC_ENABLE_INVPCID;
-			guest_cpuid_clear(vcpu, X86_FEATURE_INVPCID);
-		}
 
 		if (nested) {
 			if (invpcid_enabled)
-- 
2.28.0

