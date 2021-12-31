Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB5F48247A
	for <lists+kvm@lfdr.de>; Fri, 31 Dec 2021 15:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbhLaO7V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Dec 2021 09:59:21 -0500
Received: from mga03.intel.com ([134.134.136.65]:47298 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231154AbhLaO7P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Dec 2021 09:59:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640962755; x=1672498755;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=VFfD9eTpxtjDaqvPE492xPzn5UqT5dKTnIj6sllM0iQ=;
  b=gdoCzp9FTl60e+tmw9/S1WMIfkk0aw+KhxbYabIMhGW/8o96rTA1cU62
   oaeH9YTQuBG0tnrCVbeoiQn6B+Oz7iHhQgwVfA9uf8J1reB6eg3sdrDrA
   wzgg3Pe1RE0oR6YyARUEWQDfIfLOBAlDQll4aDNbwkkTzS7D50isozSF8
   bCOY2pRlBsgXf3CYT4xI3KV+k1aNLcM1OXbN6zZoroG3hOEFIhCPK9CaZ
   OL/TkDGYwHn19ywDydSWWNF0FIEPpHkVtWINGbCN8KVAdnUjPQkqBM+jg
   hJxHGJXianEqNuUhojnEH+fcu8mQ83RZ/8LeCNEyg6zqQAoPUFOW0u6fy
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10213"; a="241773897"
X-IronPort-AV: E=Sophos;i="5.88,251,1635231600"; 
   d="scan'208";a="241773897"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Dec 2021 06:59:14 -0800
X-IronPort-AV: E=Sophos;i="5.88,251,1635231600"; 
   d="scan'208";a="524758450"
Received: from arthur-vostro-3668.sh.intel.com ([10.239.13.120])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Dec 2021 06:59:09 -0800
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
Subject: [PATCH v5 4/8] KVM: VMX: dump_vmcs() reports tertiary_exec_control field as well
Date:   Fri, 31 Dec 2021 22:28:45 +0800
Message-Id: <20211231142849.611-5-guang.zeng@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211231142849.611-1-guang.zeng@intel.com>
References: <20211231142849.611-1-guang.zeng@intel.com>
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
index fb0f600368c6..5716db9704c0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5729,6 +5729,7 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 vmentry_ctl, vmexit_ctl;
 	u32 cpu_based_exec_ctrl, pin_based_exec_ctrl, secondary_exec_control;
+	u64 tertiary_exec_control = 0;
 	unsigned long cr4;
 	int efer_slot;
 
@@ -5746,6 +5747,9 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
 	if (cpu_has_secondary_exec_ctrls())
 		secondary_exec_control = vmcs_read32(SECONDARY_VM_EXEC_CONTROL);
 
+	if (cpu_has_tertiary_exec_ctrls())
+		tertiary_exec_control = vmcs_read64(TERTIARY_VM_EXEC_CONTROL);
+
 	pr_err("VMCS %p, last attempted VM-entry on CPU %d\n",
 	       vmx->loaded_vmcs->vmcs, vcpu->arch.last_vmentry_cpu);
 	pr_err("*** Guest State ***\n");
@@ -5844,8 +5848,9 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
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
2.27.0

