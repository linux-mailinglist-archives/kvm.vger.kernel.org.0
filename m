Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21C375072A2
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 18:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239466AbiDSQJ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 12:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354397AbiDSQJK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 12:09:10 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4F03A5F5;
        Tue, 19 Apr 2022 09:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650384387; x=1681920387;
  h=from:to:cc:subject:date:message-id;
  bh=1FfTghodE/lp1El9D6x6y9QyfhA09HoGqoypZzcTnLQ=;
  b=EKoANuCGYYbaeqJ92+MxwniWwQ4pKCu+YGiYztQxniPdTwrXs3OdQBuM
   cYdbWDR/aj5GUbj353160IErLNuMklVkEumkInnHaT4UcDKUdFKA6MD2L
   ySufwlznKcwNDHn6GStYUr2LJeXDWNXzB8+dGruGIug6AIhMgT5B4Tmi5
   HH2/kJE1gHydOWO3XnVXPfyCizlSEA078bVAlTQxd0eMiR3uZ/czXxy1E
   5/mNzOm52KjWeLG0f3UuxKAc0ZvObPxe36a6JxOagc9ES7tbFR0NF//zC
   lZIkF/ytKKce9TAT6ig9c46S66/eqFYMmqPPWgYCHF2ELh+QYBof1nNhf
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10322"; a="263975769"
X-IronPort-AV: E=Sophos;i="5.90,273,1643702400"; 
   d="scan'208";a="263975769"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 09:06:26 -0700
X-IronPort-AV: E=Sophos;i="5.90,273,1643702400"; 
   d="scan'208";a="529370448"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.120])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 09:06:20 -0700
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
        Zeng Guang <guang.zeng@intel.com>,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v9 4/9] KVM: VMX: Report tertiary_exec_control field in dump_vmcs()
Date:   Tue, 19 Apr 2022 23:34:41 +0800
Message-Id: <20220419153441.11687-1-guang.zeng@intel.com>
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

From: Robert Hoo <robert.hu@linux.intel.com>

Add tertiary_exec_control field report in dump_vmcs(). Meanwhile,
reorganize the dump output of VMCS category as follows.

Before change:
*** Control State ***
 PinBased=0x000000ff CPUBased=0xb5a26dfa SecondaryExec=0x061037eb
 EntryControls=0000d1ff ExitControls=002befff

After change:
*** Control State ***
 CPUBased=0xb5a26dfa SecondaryExec=0x061037eb TertiaryExec=0x0000000000000010
 PinBased=0x000000ff EntryControls=0000d1ff ExitControls=002befff

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 961e61044341..f439abd52bad 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5867,6 +5867,7 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 vmentry_ctl, vmexit_ctl;
 	u32 cpu_based_exec_ctrl, pin_based_exec_ctrl, secondary_exec_control;
+	u64 tertiary_exec_control;
 	unsigned long cr4;
 	int efer_slot;
 
@@ -5880,9 +5881,16 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 	cpu_based_exec_ctrl = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
 	pin_based_exec_ctrl = vmcs_read32(PIN_BASED_VM_EXEC_CONTROL);
 	cr4 = vmcs_readl(GUEST_CR4);
-	secondary_exec_control = 0;
+
 	if (cpu_has_secondary_exec_ctrls())
 		secondary_exec_control = vmcs_read32(SECONDARY_VM_EXEC_CONTROL);
+	else
+		secondary_exec_control = 0;
+
+	if (cpu_has_tertiary_exec_ctrls())
+		tertiary_exec_control = vmcs_read64(TERTIARY_VM_EXEC_CONTROL);
+	else
+		tertiary_exec_control = 0;
 
 	pr_err("VMCS %p, last attempted VM-entry on CPU %d\n",
 	       vmx->loaded_vmcs->vmcs, vcpu->arch.last_vmentry_cpu);
@@ -5982,9 +5990,10 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 		vmx_dump_msrs("host autoload", &vmx->msr_autoload.host);
 
 	pr_err("*** Control State ***\n");
-	pr_err("PinBased=%08x CPUBased=%08x SecondaryExec=%08x\n",
-	       pin_based_exec_ctrl, cpu_based_exec_ctrl, secondary_exec_control);
-	pr_err("EntryControls=%08x ExitControls=%08x\n", vmentry_ctl, vmexit_ctl);
+	pr_err("CPUBased=0x%08x SecondaryExec=0x%08x TertiaryExec=0x%016llx\n",
+	       cpu_based_exec_ctrl, secondary_exec_control, tertiary_exec_control);
+	pr_err("PinBased=0x%08x EntryControls=%08x ExitControls=%08x\n",
+	       pin_based_exec_ctrl, vmentry_ctl, vmexit_ctl);
 	pr_err("ExceptionBitmap=%08x PFECmask=%08x PFECmatch=%08x\n",
 	       vmcs_read32(EXCEPTION_BITMAP),
 	       vmcs_read32(PAGE_FAULT_ERROR_CODE_MASK),
-- 
2.27.0

