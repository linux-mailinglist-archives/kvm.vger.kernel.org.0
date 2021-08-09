Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFBF3E3E7D
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 05:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbhHIDzK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Aug 2021 23:55:10 -0400
Received: from mga05.intel.com ([192.55.52.43]:23274 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232942AbhHIDzJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Aug 2021 23:55:09 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10070"; a="300206602"
X-IronPort-AV: E=Sophos;i="5.84,305,1620716400"; 
   d="scan'208";a="300206602"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2021 20:54:49 -0700
X-IronPort-AV: E=Sophos;i="5.84,305,1620716400"; 
   d="scan'208";a="483124564"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.1])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2021 20:54:44 -0700
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
Subject: [PATCH v4 4/6] KVM: VMX: dump_vmcs() reports tertiary_exec_control field as well
Date:   Mon,  9 Aug 2021 11:29:23 +0800
Message-Id: <20210809032925.3548-5-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210809032925.3548-1-guang.zeng@intel.com>
References: <20210809032925.3548-1-guang.zeng@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Robert Hoo <robert.hu@linux.intel.com>

Add tertiary_exec_control field report in dump_vmcs()

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Zeng Guang <guang.zeng@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ee8c5664dc95..9eb351c351ce 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5745,6 +5745,7 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 vmentry_ctl, vmexit_ctl;
 	u32 cpu_based_exec_ctrl, pin_based_exec_ctrl, secondary_exec_control;
+	u64 tertiary_exec_control = 0;
 	unsigned long cr4;
 	int efer_slot;
 
@@ -5762,6 +5763,9 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 	if (cpu_has_secondary_exec_ctrls())
 		secondary_exec_control = vmcs_read32(SECONDARY_VM_EXEC_CONTROL);
 
+	if (cpu_has_tertiary_exec_ctrls())
+		tertiary_exec_control = vmcs_read64(TERTIARY_VM_EXEC_CONTROL);
+
 	pr_err("VMCS %p, last attempted VM-entry on CPU %d\n",
 	       vmx->loaded_vmcs->vmcs, vcpu->arch.last_vmentry_cpu);
 	pr_err("*** Guest State ***\n");
@@ -5860,8 +5864,9 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 		vmx_dump_msrs("host autoload", &vmx->msr_autoload.host);
 
 	pr_err("*** Control State ***\n");
-	pr_err("PinBased=%08x CPUBased=%08x SecondaryExec=%08x\n",
-	       pin_based_exec_ctrl, cpu_based_exec_ctrl, secondary_exec_control);
+	pr_err("PinBased=0x%08x CPUBased=0x%08x SecondaryExec=0x%08x TertiaryExec=0x%016llx\n",
+	       pin_based_exec_ctrl, cpu_based_exec_ctrl, secondary_exec_control,
+	       tertiary_exec_control);
 	pr_err("EntryControls=%08x ExitControls=%08x\n", vmentry_ctl, vmexit_ctl);
 	pr_err("ExceptionBitmap=%08x PFECmask=%08x PFECmatch=%08x\n",
 	       vmcs_read32(EXCEPTION_BITMAP),
-- 
2.25.1

