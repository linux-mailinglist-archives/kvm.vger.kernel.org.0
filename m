Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 097DE2B4F6A
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388459AbgKPS3G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:29:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:48453 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388317AbgKPS2V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:21 -0500
IronPort-SDR: n/m9Zva0Mc5aknYfyhNvp02npyMv6qkbHnAq8wDAQoow8eYlG33n3jNl5MDYqEsIHv0W3k7FZO
 Yb4kn+Ksz5zQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="157819199"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="157819199"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:19 -0800
IronPort-SDR: AqtDAvX5LM2JAXr/Y+/57MQKnPKjTrQw+7pJJA77ng9VkPN5mC3045vHsh8xjvAGGN3RTkBe9v
 YAFjQXjlrPHw==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400528339"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:19 -0800
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
Subject: [RFC PATCH 58/67] KVM: VMX: Add macro framework to read/write VMCS for VMs and TDs
Date:   Mon, 16 Nov 2020 10:26:43 -0800
Message-Id: <3a5f49671c7bc14323bfb15ac04c90b28b6faaad.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add a macro framework to hide VMX vs. TDX details of VMREAD and VMWRITE
so the VMX and TDX can shared common flows, e.g. accessing DTs.

Note, the TDX paths are dead code at this time.  There is no great way
to deal with the chicken-and-egg scenario of having things in place for
TDX without first having TDX.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/common.h | 41 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index 58edf1296cbd..baee96abdd7e 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -11,6 +11,47 @@
 #include "vmcs.h"
 #include "vmx.h"
 #include "x86.h"
+#include "tdx.h"
+
+#ifdef CONFIG_KVM_INTEL_TDX
+#define VT_BUILD_VMCS_HELPERS(type, bits, tdbits)			   \
+static __always_inline type vmread##bits(struct kvm_vcpu *vcpu,		   \
+					 unsigned long field)		   \
+{									   \
+	if (unlikely(is_td_vcpu(vcpu))) {				   \
+		if (KVM_BUG_ON(!is_debug_td(vcpu), vcpu->kvm))		   \
+			return 0;					   \
+		return td_vmcs_read##tdbits(to_tdx(vcpu), field);	   \
+	}								   \
+	return vmcs_read##bits(field);					   \
+}									   \
+static __always_inline void vmwrite##bits(struct kvm_vcpu *vcpu,	   \
+					  unsigned long field, type value) \
+{									   \
+	if (unlikely(is_td_vcpu(vcpu))) {				   \
+		if (KVM_BUG_ON(!is_debug_td(vcpu), vcpu->kvm))		   \
+			return;						   \
+		return td_vmcs_write##tdbits(to_tdx(vcpu), field, value);  \
+	}								   \
+	vmcs_write##bits(field, value);					   \
+}
+#else
+#define VT_BUILD_VMCS_HELPERS(type, bits, tdbits)			   \
+static __always_inline type vmread##bits(struct kvm_vcpu *vcpu,		   \
+					 unsigned long field)		   \
+{									   \
+	return vmcs_read##bits(field);					   \
+}									   \
+static __always_inline void vmwrite##bits(struct kvm_vcpu *vcpu,	   \
+					  unsigned long field, type value) \
+{									   \
+	vmcs_write##bits(field, value);					   \
+}
+#endif /* CONFIG_KVM_INTEL_TDX */
+VT_BUILD_VMCS_HELPERS(u16, 16, 16);
+VT_BUILD_VMCS_HELPERS(u32, 32, 32);
+VT_BUILD_VMCS_HELPERS(u64, 64, 64);
+VT_BUILD_VMCS_HELPERS(unsigned long, l, 64);
 
 void vmx_handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu, u32 intr_info);
 
-- 
2.17.1

