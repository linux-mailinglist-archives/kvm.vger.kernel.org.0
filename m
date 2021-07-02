Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D27E3BA55B
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 00:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhGBWHz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 18:07:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:51166 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230415AbhGBWHx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 18:07:53 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10033"; a="195951882"
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="195951882"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:19 -0700
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="642814675"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:19 -0700
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
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com
Subject: [RFC PATCH v2 03/69] KVM: X86: move out the definition vmcs_hdr/vmcs from kvm to x86
Date:   Fri,  2 Jul 2021 15:04:09 -0700
Message-Id: <62b61eb968f867518aedd98a0753b7fd29958efb.1625186503.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625186503.git.isaku.yamahata@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

This is preparation for TDX support.

Because SEAMCALL instruction requires VMX enabled, it needs to initialize
struct vmcs and load it before SEAMCALL instruction.[1] [2]  Move out the
definition of vmcs into a common x86 header, arch/x86/include/asm/vmx.h, so
that seamloader code can share the same definition.

[1] Intel Trust Domain CPU Architectural Extensions
https://software.intel.com/content/dam/develop/external/us/en/documents/intel-tdx-cpu-architectural-specification.pdf

[2] TDX Module spec
https://software.intel.com/content/dam/develop/external/us/en/documents/tdx-module-1eas-v0.85.039.pdf

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/vmx.h | 11 +++++++++++
 arch/x86/kvm/vmx/vmcs.h    | 11 -----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 0ffaa3156a4e..035dfdafa2c1 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -17,6 +17,17 @@
 #include <uapi/asm/vmx.h>
 #include <asm/vmxfeatures.h>
 
+struct vmcs_hdr {
+	u32 revision_id:31;
+	u32 shadow_vmcs:1;
+};
+
+struct vmcs {
+	struct vmcs_hdr hdr;
+	u32 abort;
+	char data[];
+};
+
 #define VMCS_CONTROL_BIT(x)	BIT(VMX_FEATURE_##x & 0x1f)
 
 /*
diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index 1472c6c376f7..ac09bc4996a5 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -11,17 +11,6 @@
 
 #include "capabilities.h"
 
-struct vmcs_hdr {
-	u32 revision_id:31;
-	u32 shadow_vmcs:1;
-};
-
-struct vmcs {
-	struct vmcs_hdr hdr;
-	u32 abort;
-	char data[];
-};
-
 DECLARE_PER_CPU(struct vmcs *, current_vmcs);
 
 /*
-- 
2.25.1

