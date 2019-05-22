Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E16CB25E62
	for <lists+kvm@lfdr.de>; Wed, 22 May 2019 09:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728658AbfEVHCE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 May 2019 03:02:04 -0400
Received: from mga18.intel.com ([134.134.136.126]:31984 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728603AbfEVHCD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 May 2019 03:02:03 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 May 2019 00:02:03 -0700
X-ExtLoop1: 1
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.128])
  by fmsmga001.fm.intel.com with ESMTP; 22 May 2019 00:02:01 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        mst@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        yu-cheng.yu@intel.com
Cc:     weijiang.yang@intel.com
Subject: [PATCH v5 5/8] KVM: VMX: Load Guest CET via VMCS when CET is enabled in Guest
Date:   Wed, 22 May 2019 15:00:58 +0800
Message-Id: <20190522070101.7636-6-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190522070101.7636-1-weijiang.yang@intel.com>
References: <20190522070101.7636-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Load Guest CET state" bit controls whether Guest CET states
will be loaded at Guest entry. Before doing that, KVM needs
to check if CPU CET feature is available to Guest.

Note: SHSTK and IBT features share one control MSR:
MSR_IA32_{U,S}_CET, which means it's difficult to hide
one feature from another in the case of SHSTK != IBT,
after discussed in community, it's agreed to allow Guest
control two features independently as it won't introduce
security hole.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9321da538f65..1c0d487a4037 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -47,6 +47,7 @@
 #include <asm/spec-ctrl.h>
 #include <asm/virtext.h>
 #include <asm/vmx.h>
+#include <asm/cet.h>
 
 #include "capabilities.h"
 #include "cpuid.h"
@@ -2929,6 +2930,17 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		if (!nested_vmx_allowed(vcpu) || is_smm(vcpu))
 			return 1;
 	}
+	if (guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
+	    guest_cpuid_has(vcpu, X86_FEATURE_IBT)) {
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

