Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7942D3BA5A0
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 00:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233842AbhGBWJE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 18:09:04 -0400
Received: from mga17.intel.com ([192.55.52.151]:15270 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233819AbhGBWIh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 18:08:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10033"; a="189168403"
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="189168403"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:31 -0700
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="642814880"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:31 -0700
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v2 60/69] KVM: VMX: Add macro framework to read/write VMCS for VMs and TDs
Date:   Fri,  2 Jul 2021 15:05:06 -0700
Message-Id: <5735bf9268130a70b49bc32ff4b68ffc53ee788c.1625186503.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625186503.git.isaku.yamahata@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/common.h | 41 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index 9e5865b05d47..aa6a569b87d1 100644
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
 
 extern unsigned long vmx_host_idt_base;
 void vmx_do_interrupt_nmi_irqoff(unsigned long entry);
-- 
2.25.1

