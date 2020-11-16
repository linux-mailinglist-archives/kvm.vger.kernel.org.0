Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDD22B4F75
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388259AbgKPS2S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:28:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:48445 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388286AbgKPS2R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:17 -0500
IronPort-SDR: o6Oy/oSOe80uoASTaoq2hYXUv7to8oL3KnTDo9VGT/7EqR34aCLdbteTAIKCcyJbFSVCT5E2es
 gqrGAPZ/kevA==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="157819179"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="157819179"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:15 -0800
IronPort-SDR: two99wgknky1TIpk7qAH9FAMPhBzehL+u6OEXQXm11sneW92gZzgirhbmbWAtDroe0mwdh9X0D
 WClcJEV4St9w==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400528251"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:15 -0800
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
Subject: [RFC PATCH 50/67] KVM: VMX: Move setting of EPT MMU masks to common VT-x code
Date:   Mon, 16 Nov 2020 10:26:35 -0800
Message-Id: <2c648e2f7fb9debcef370fcce64219b9a065727f.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/main.c | 17 +++++++++++++++++
 arch/x86/kvm/vmx/vmx.c  | 13 -------------
 2 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 85bc238c0852..52e7a9d25e9c 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -26,6 +26,20 @@ static int __init vt_check_processor_compatibility(void)
 	return 0;
 }
 
+static __init void vt_set_ept_masks(void)
+{
+	const u64 u_mask = VMX_EPT_READABLE_MASK;
+	const u64 a_mask = enable_ept_ad_bits ? VMX_EPT_ACCESS_BIT : 0ull;
+	const u64 d_mask = enable_ept_ad_bits ? VMX_EPT_DIRTY_BIT : 0ull;
+	const u64 p_mask = cpu_has_vmx_ept_execute_only() ? 0ull :
+							    VMX_EPT_READABLE_MASK;
+	const u64 x_mask = VMX_EPT_EXECUTABLE_MASK;
+	const u64 nx_mask = 0ull;
+
+	kvm_mmu_set_mask_ptes(u_mask, a_mask, d_mask, nx_mask, x_mask, p_mask,
+			      VMX_EPT_RWX_MASK, 0ull);
+}
+
 static __init int vt_hardware_setup(void)
 {
 	int ret;
@@ -34,6 +48,9 @@ static __init int vt_hardware_setup(void)
 	if (ret)
 		return ret;
 
+	if (enable_ept)
+		vt_set_ept_masks();
+
 	return 0;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 966d48eada40..f6b2ddff58e1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5411,16 +5411,6 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void vmx_enable_tdp(void)
-{
-	kvm_mmu_set_mask_ptes(VMX_EPT_READABLE_MASK,
-		enable_ept_ad_bits ? VMX_EPT_ACCESS_BIT : 0ull,
-		enable_ept_ad_bits ? VMX_EPT_DIRTY_BIT : 0ull,
-		0ull, VMX_EPT_EXECUTABLE_MASK,
-		cpu_has_vmx_ept_execute_only() ? 0ull : VMX_EPT_READABLE_MASK,
-		VMX_EPT_RWX_MASK, 0ull);
-}
-
 /*
  * Indicate a busy-waiting vcpu in spinlock. We do not enable the PAUSE
  * exiting, so only get here on cpu with PAUSE-Loop-Exiting.
@@ -7602,9 +7592,6 @@ static __init int hardware_setup(struct kvm_x86_ops *x86_ops)
 
 	set_bit(0, vmx_vpid_bitmap); /* 0 is reserved for host */
 
-	if (enable_ept)
-		vmx_enable_tdp();
-
 	if (!enable_ept)
 		ept_lpage_level = 0;
 	else if (cpu_has_vmx_ept_1g_page())
-- 
2.17.1

