Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE292B4F4F
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732502AbgKPS2V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:28:21 -0500
Received: from mga06.intel.com ([134.134.136.31]:20651 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388289AbgKPS2R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:17 -0500
IronPort-SDR: BTeLHS9JlxKxF175a5D8YFPWTwm2SSaQ1u08KgQ50OE7lgwvqgQTFilowAl82s6FA1FFBD1xLl
 r3kcFr0EsQhQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232410068"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232410068"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:14 -0800
IronPort-SDR: UD3yKWGQO3tGvFl0MpsnzYn91WJuGOszSka5r9isZ6wW8QEURdUge9LxmwlWloWa4kUclIR8Lk
 d/1Yd2EEPLMQ==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400528221"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:14 -0800
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
Subject: [RFC PATCH 47/67] KVM: VMX: Define EPT Violation architectural bits
Date:   Mon, 16 Nov 2020 10:26:32 -0800
Message-Id: <008b247c268b398120019c316083ae80cd26e2d7.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Define the EPT Violation #VE control bit, #VE info VMCS fields, and the
suppress #VE bit for EPT entries.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/vmx.h         | 4 ++++
 arch/x86/include/asm/vmxfeatures.h | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index f8ba5289ecb0..8a3a2e2dc208 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -67,6 +67,7 @@
 #define SECONDARY_EXEC_ENCLS_EXITING		VMCS_CONTROL_BIT(ENCLS_EXITING)
 #define SECONDARY_EXEC_RDSEED_EXITING		VMCS_CONTROL_BIT(RDSEED_EXITING)
 #define SECONDARY_EXEC_ENABLE_PML               VMCS_CONTROL_BIT(PAGE_MOD_LOGGING)
+#define SECONDARY_EXEC_EPT_VIOLATION_VE		VMCS_CONTROL_BIT(EPT_VIOLATION_VE)
 #define SECONDARY_EXEC_PT_CONCEAL_VMX		VMCS_CONTROL_BIT(PT_CONCEAL_VMX)
 #define SECONDARY_EXEC_XSAVES			VMCS_CONTROL_BIT(XSAVES)
 #define SECONDARY_EXEC_MODE_BASED_EPT_EXEC	VMCS_CONTROL_BIT(MODE_BASED_EPT_EXEC)
@@ -213,6 +214,8 @@ enum vmcs_field {
 	VMREAD_BITMAP_HIGH              = 0x00002027,
 	VMWRITE_BITMAP                  = 0x00002028,
 	VMWRITE_BITMAP_HIGH             = 0x00002029,
+	VE_INFO_ADDRESS                 = 0x0000202A,
+	VE_INFO_ADDRESS_HIGH            = 0x0000202B,
 	XSS_EXIT_BITMAP                 = 0x0000202C,
 	XSS_EXIT_BITMAP_HIGH            = 0x0000202D,
 	ENCLS_EXITING_BITMAP		= 0x0000202E,
@@ -495,6 +498,7 @@ enum vmcs_field {
 #define VMX_EPT_IPAT_BIT    			(1ull << 6)
 #define VMX_EPT_ACCESS_BIT			(1ull << 8)
 #define VMX_EPT_DIRTY_BIT			(1ull << 9)
+#define VMX_EPT_SUPPRESS_VE_BIT			(1ull << 63)
 #define VMX_EPT_RWX_MASK                        (VMX_EPT_READABLE_MASK |       \
 						 VMX_EPT_WRITABLE_MASK |       \
 						 VMX_EPT_EXECUTABLE_MASK)
diff --git a/arch/x86/include/asm/vmxfeatures.h b/arch/x86/include/asm/vmxfeatures.h
index 9915990fd8cf..9013e383fee6 100644
--- a/arch/x86/include/asm/vmxfeatures.h
+++ b/arch/x86/include/asm/vmxfeatures.h
@@ -75,7 +75,7 @@
 #define VMX_FEATURE_ENCLS_EXITING	( 2*32+ 15) /* "" VM-Exit on ENCLS (leaf dependent) */
 #define VMX_FEATURE_RDSEED_EXITING	( 2*32+ 16) /* "" VM-Exit on RDSEED */
 #define VMX_FEATURE_PAGE_MOD_LOGGING	( 2*32+ 17) /* "pml" Log dirty pages into buffer */
-#define VMX_FEATURE_EPT_VIOLATION_VE	( 2*32+ 18) /* "" Conditionally reflect EPT violations as #VE exceptions */
+#define VMX_FEATURE_EPT_VIOLATION_VE	( 2*32+ 18) /* Conditionally reflect EPT violations as #VE exceptions */
 #define VMX_FEATURE_PT_CONCEAL_VMX	( 2*32+ 19) /* "" Suppress VMX indicators in Processor Trace */
 #define VMX_FEATURE_XSAVES		( 2*32+ 20) /* "" Enable XSAVES and XRSTORS in guest */
 #define VMX_FEATURE_MODE_BASED_EPT_EXEC	( 2*32+ 22) /* "ept_mode_based_exec" Enable separate EPT EXEC bits for supervisor vs. user */
-- 
2.17.1

