Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C97535072A9
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 18:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354388AbiDSQKf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 12:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244081AbiDSQKe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 12:10:34 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C73F7381A8;
        Tue, 19 Apr 2022 09:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650384471; x=1681920471;
  h=from:to:cc:subject:date:message-id;
  bh=fdubxdHgoQUUeVvOw4eAWUS9eh70LgX2k0wAmWAjbnI=;
  b=dXN91BdIWABZY1r1Sx77XGP0EB3QIkbxZKtBkcKG6M5Q0g+txVR7Nphu
   zLNfrGzQlGvlMEF0IWxsv6cVBeeFUeLYauxduUGojwVE4qPF4ZNeeGqns
   hjJJVXYJmG9Hyxw9JcqJwiS6rmAAQ2j+UgbYheNoxoTQWPinf3aB1f87i
   GE28ZarNAUmBDgBugv2sIijVqeCmLA3vkZUkEYhIa80lqSa+h+2vJmNAT
   y1pXq71VihEwACgwHhk25LlK950Tokg0mEn3pXIn1Tgrzuj4jNUiaGLVt
   ORkcxe4DlmFOkFdvHy6i9NeY8j3CyMS1GnVTWQer8zVfY5x2/amugkJBa
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10322"; a="261405680"
X-IronPort-AV: E=Sophos;i="5.90,273,1643702400"; 
   d="scan'208";a="261405680"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 09:07:51 -0700
X-IronPort-AV: E=Sophos;i="5.90,273,1643702400"; 
   d="scan'208";a="529370957"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.120])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 09:07:46 -0700
From:   Zeng Guang <guang.zeng@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>, Gao Chao <chao.gao@intel.com>,
        Zeng Guang <guang.zeng@intel.com>
Subject: [PATCH v9 6/9] KVM: VMX: Clean up vmx_refresh_apicv_exec_ctrl()
Date:   Tue, 19 Apr 2022 23:36:04 +0800
Message-Id: <20220419153604.11786-1-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the condition check cpu_has_secondary_exec_ctrls(). Calling
vmx_refresh_apicv_exec_ctrl() premises secondary controls activated
and VMCS fields related to APICv valid as well. If it's invoked in
wrong circumstance at the worst case, VMX operation will report
VMfailValid error without further harmful impact and just functions
as if all the secondary controls were 0.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f439abd52bad..c6ad82116804 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4194,16 +4194,15 @@ static void vmx_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	pin_controls_set(vmx, vmx_pin_based_exec_ctrl(vmx));
-	if (cpu_has_secondary_exec_ctrls()) {
-		if (kvm_vcpu_apicv_active(vcpu))
-			secondary_exec_controls_setbit(vmx,
-				      SECONDARY_EXEC_APIC_REGISTER_VIRT |
-				      SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
-		else
-			secondary_exec_controls_clearbit(vmx,
-					SECONDARY_EXEC_APIC_REGISTER_VIRT |
-					SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
-	}
+
+	if (kvm_vcpu_apicv_active(vcpu))
+		secondary_exec_controls_setbit(vmx,
+					       SECONDARY_EXEC_APIC_REGISTER_VIRT |
+					       SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
+	else
+		secondary_exec_controls_clearbit(vmx,
+						 SECONDARY_EXEC_APIC_REGISTER_VIRT |
+						 SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
 
 	vmx_update_msr_bitmap_x2apic(vcpu);
 }
-- 
2.27.0

