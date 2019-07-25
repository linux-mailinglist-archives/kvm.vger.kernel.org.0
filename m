Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC1DA743B9
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 05:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389775AbfGYDLu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 23:11:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:24587 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389769AbfGYDL2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jul 2019 23:11:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jul 2019 20:11:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,305,1559545200"; 
   d="scan'208";a="321537753"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by orsmga004.jf.intel.com with ESMTP; 24 Jul 2019 20:11:26 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, pbonzini@redhat.com
Cc:     mst@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v6 5/8] KVM: VMX: Load Guest CET via VMCS when CET is enabled in Guest
Date:   Thu, 25 Jul 2019 11:12:43 +0800
Message-Id: <20190725031246.8296-6-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190725031246.8296-1-weijiang.yang@intel.com>
References: <20190725031246.8296-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Load Guest CET state" bit controls whether Guest CET states
will be loaded at Guest entry. Before doing that, KVM needs
to check if CPU CET feature is enabled on host and available
to Guest.

Note: SHSTK and IBT features share one control MSR:
MSR_IA32_{U,S}_CET, which means it's difficult to hide
one feature from another in the case of SHSTK != IBT,
after discussed in community, it's agreed to allow Guest
control two features independently as it won't introduce
security hole.

Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ce5d1e45b7a5..fbf9c335cf7b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -44,6 +44,7 @@
 #include <asm/spec-ctrl.h>
 #include <asm/virtext.h>
 #include <asm/vmx.h>
+#include <asm/cet.h>
 
 #include "capabilities.h"
 #include "cpuid.h"
@@ -2923,6 +2924,18 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		if (!nested_vmx_allowed(vcpu) || is_smm(vcpu))
 			return 1;
 	}
+	if (cpu_x86_cet_enabled() &&
+	    (guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
+	    guest_cpuid_has(vcpu, X86_FEATURE_IBT))) {
+		if (cr4 & X86_CR4_CET)
+			vmcs_set_bits(VM_ENTRY_CONTROLS,
+				      VM_ENTRY_LOAD_GUEST_CET_STATE);
+		else
+			vmcs_clear_bits(VM_ENTRY_CONTROLS,
+					VM_ENTRY_LOAD_GUEST_CET_STATE);
+	} else if (cr4 & X86_CR4_CET) {
+		return 1;
+	}
 
 	if (to_vmx(vcpu)->nested.vmxon && !nested_cr4_valid(vcpu, cr4))
 		return 1;
-- 
2.17.2

