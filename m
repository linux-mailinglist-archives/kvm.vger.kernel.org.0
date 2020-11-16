Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620182B4FB9
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388218AbgKPScD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:32:03 -0500
Received: from mga06.intel.com ([134.134.136.31]:20638 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388105AbgKPS2H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:07 -0500
IronPort-SDR: 8h7dCpqrMi/07FLmw0OTrbtlI3j8yv1h99ZLocsxs2mnesjDXuGRmmo09WV9tHF8lfBSI33Odw
 6U+/1YAg7lDg==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232410041"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232410041"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:06 -0800
IronPort-SDR: ajiByAb1hVChYsZUFFQ7uIGLi6KwM6u6oxMMjqY9x9doO9Vi3e4cvqsAx9/chXBzCakBLPE+ld
 XdccLw3JdClQ==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400528044"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:06 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 30/67] KVM: x86: Check for pending APICv interrupt in kvm_vcpu_has_events()
Date:   Mon, 16 Nov 2020 10:26:15 -0800
Message-Id: <a3dff0c9711f20071f971b0036573cfc26153f32.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Return true for kvm_vcpu_has_events() if the vCPU has a pending APICv
interrupt to support TDX's usage of APICv.  Unlike VMX, TDX doesn't have
access to vmcs.GUEST_INTR_STATUS and so can't emulate posted interrupts,
i.e. needs to generate a posted interrupt and more importantly can't
manually move requested interrupts into the vIRR (which it also doesn't
have access to).

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 098888edc3ad..c233e7ef3366 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10813,7 +10813,9 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
 
 	if (kvm_arch_interrupt_allowed(vcpu) &&
 	    (kvm_cpu_has_interrupt(vcpu) ||
-	    kvm_guest_apic_has_interrupt(vcpu)))
+	     kvm_guest_apic_has_interrupt(vcpu) ||
+	     (vcpu->arch.apicv_active &&
+	      kvm_x86_ops.dy_apicv_has_pending_interrupt(vcpu))))
 		return true;
 
 	if (kvm_hv_has_stimer_pending(vcpu))
-- 
2.17.1

