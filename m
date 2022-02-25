Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79C4F4C40B0
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 09:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238756AbiBYIyK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 03:54:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238758AbiBYIyF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 03:54:05 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10DE7222187;
        Fri, 25 Feb 2022 00:53:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645779214; x=1677315214;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=6nN+aBuikGWyJ9R1HQeB9Y3n4h+iAnnSA4KQ/7gg/yc=;
  b=EfowDODoAVx6dNlhcUWBJUWMtw8DRP7hcH4hMUzg0Bl4mSxDaHGAv7ya
   K9VZRl4MFSnzX+6c5COdcwyeDMSN6OfwtCek+KdGefrSEWsbYv1DkdX6e
   JfsIvX5QG4PBYOHO+wG8OaJeiqN7a76mQsMvQlpp45Gy11qcINEJro/Ut
   837Oe84wKji1uNF4oUCdQYpwsSwbp6AH3VT3+Jpqe0vXBqPMdeCrzvG7D
   ZweKk1zlP3XkmMMIr4pU6p62OGPM6DaVK+ss7Rws08DHl0kguPuixtTx/
   aQLwySL5q6r1wjE1kClX+FLwj6WQa9+FVLX9RTcq9+UqFvEXwOzZ3VGcY
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="277090064"
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="277090064"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 00:53:33 -0800
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="549186493"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.120])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 00:53:24 -0800
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
Subject: [PATCH v6 4/9] KVM: VMX: dump_vmcs() reports tertiary_exec_control field as well
Date:   Fri, 25 Feb 2022 16:22:18 +0800
Message-Id: <20220225082223.18288-5-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220225082223.18288-1-guang.zeng@intel.com>
References: <20220225082223.18288-1-guang.zeng@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Robert Hoo <robert.hu@linux.intel.com>

Add tertiary_exec_control field report in dump_vmcs()

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8a5713d49635..7beba7a9f247 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5891,6 +5891,7 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 vmentry_ctl, vmexit_ctl;
 	u32 cpu_based_exec_ctrl, pin_based_exec_ctrl, secondary_exec_control;
+	u64 tertiary_exec_control;
 	unsigned long cr4;
 	int efer_slot;
 
@@ -5904,9 +5905,16 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
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
@@ -6006,9 +6014,10 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
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

