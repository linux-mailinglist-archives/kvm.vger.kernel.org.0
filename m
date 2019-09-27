Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D95E5BFD20
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 04:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728716AbfI0CRS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 22:17:18 -0400
Received: from mga17.intel.com ([192.55.52.151]:25572 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728656AbfI0CRR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 22:17:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 19:17:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,553,1559545200"; 
   d="scan'208";a="193020675"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by orsmga003.jf.intel.com with ESMTP; 26 Sep 2019 19:17:15 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com
Cc:     mst@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v7 4/7] KVM: VMX: Load Guest CET via VMCS when CET is enabled in Guest
Date:   Fri, 27 Sep 2019 10:19:24 +0800
Message-Id: <20190927021927.23057-5-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190927021927.23057-1-weijiang.yang@intel.com>
References: <20190927021927.23057-1-weijiang.yang@intel.com>
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
 arch/x86/kvm/vmx/vmx.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f720baa7a9ba..ba1a83d11e69 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -44,6 +44,7 @@
 #include <asm/spec-ctrl.h>
 #include <asm/virtext.h>
 #include <asm/vmx.h>
+#include <asm/cet.h>
 
 #include "capabilities.h"
 #include "cpuid.h"
@@ -2918,6 +2919,37 @@ void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	vmcs_writel(GUEST_CR3, guest_cr3);
 }
 
+static int set_cet_bit(struct kvm_vcpu *vcpu, unsigned long cr4)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	const u64 cet_bits = XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL;
+	bool cet_xss = vmx_xsaves_supported() &&
+		       (kvm_supported_xss() & cet_bits);
+	bool cet_cpuid = guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
+			 guest_cpuid_has(vcpu, X86_FEATURE_IBT);
+	bool cet_on = !!(cr4 & X86_CR4_CET);
+
+	if (cet_on && vmx->nested.vmxon)
+		return 1;
+
+	if (cet_on && !cpu_x86_cet_enabled())
+		return 1;
+
+	if (cet_on && !cet_xss)
+		return 1;
+
+	if (cet_on && !cet_cpuid)
+		return 1;
+
+	if (cet_on)
+		vmcs_set_bits(VM_ENTRY_CONTROLS,
+			      VM_ENTRY_LOAD_GUEST_CET_STATE);
+	else
+		vmcs_clear_bits(VM_ENTRY_CONTROLS,
+				VM_ENTRY_LOAD_GUEST_CET_STATE);
+	return 0;
+}
+
 int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -2958,6 +2990,9 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 			return 1;
 	}
 
+	if (set_cet_bit(vcpu, cr4))
+		return 1;
+
 	if (vmx->nested.vmxon && !nested_cr4_valid(vcpu, cr4))
 		return 1;
 
-- 
2.17.2

