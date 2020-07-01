Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0889B2105AD
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 10:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgGAIEf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 04:04:35 -0400
Received: from mga14.intel.com ([192.55.52.115]:2448 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728605AbgGAIEd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jul 2020 04:04:33 -0400
IronPort-SDR: eC2CcBf7HtzLKGjjrDvrp/XJaStblirT3DHke7OGqNAxIAWHjvpmLjLJWpwoVEL+ypRTjqH4O8
 LRdg64tmC5qQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9668"; a="145581952"
X-IronPort-AV: E=Sophos;i="5.75,299,1589266800"; 
   d="scan'208";a="145581952"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2020 01:04:32 -0700
IronPort-SDR: XPNqiTnSJykft4Um8Mi/OIjM3UP+K5u3J3gRCoXuzGJFGq/+KcQ+dkFGPbTNmT/i+y/p+bgOsV
 KolUFuXLtCEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,299,1589266800"; 
   d="scan'208";a="455010340"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by orsmga005.jf.intel.com with ESMTP; 01 Jul 2020 01:04:30 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v13 09/11] KVM: VMX: Add VMCS dump and sanity check for CET states
Date:   Wed,  1 Jul 2020 16:04:09 +0800
Message-Id: <20200701080411.5802-10-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200701080411.5802-1-weijiang.yang@intel.com>
References: <20200701080411.5802-1-weijiang.yang@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dump CET VMCS states for debug purpose. Since CET kernel protection is
not enabled, if related MSRs in host are filled by mistake, warn once on
detecting it.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 32893573b630..70cb2d4a1391 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5941,6 +5941,12 @@ void dump_vmcs(void)
 		pr_err("InterruptStatus = %04x\n",
 		       vmcs_read16(GUEST_INTR_STATUS));
 
+	if (vmentry_ctl & VM_ENTRY_LOAD_CET_STATE) {
+		pr_err("S_CET = 0x%016lx\n", vmcs_readl(GUEST_S_CET));
+		pr_err("SSP = 0x%016lx\n", vmcs_readl(GUEST_SSP));
+		pr_err("SSP TABLE = 0x%016lx\n",
+		       vmcs_readl(GUEST_INTR_SSP_TABLE));
+	}
 	pr_err("*** Host State ***\n");
 	pr_err("RIP = 0x%016lx  RSP = 0x%016lx\n",
 	       vmcs_readl(HOST_RIP), vmcs_readl(HOST_RSP));
@@ -6023,6 +6029,12 @@ void dump_vmcs(void)
 	if (secondary_exec_control & SECONDARY_EXEC_ENABLE_VPID)
 		pr_err("Virtual processor ID = 0x%04x\n",
 		       vmcs_read16(VIRTUAL_PROCESSOR_ID));
+	if (vmexit_ctl & VM_EXIT_LOAD_CET_STATE) {
+		pr_err("S_CET = 0x%016lx\n", vmcs_readl(HOST_S_CET));
+		pr_err("SSP = 0x%016lx\n", vmcs_readl(HOST_SSP));
+		pr_err("SSP TABLE = 0x%016lx\n",
+		       vmcs_readl(HOST_INTR_SSP_TABLE));
+	}
 }
 
 /*
@@ -8075,6 +8087,7 @@ static __init int hardware_setup(void)
 	unsigned long host_bndcfgs;
 	struct desc_ptr dt;
 	int r, i, ept_lpage_level;
+	u64 cet_msr;
 
 	store_idt(&dt);
 	host_idt_base = dt.address;
@@ -8236,6 +8249,16 @@ static __init int hardware_setup(void)
 			return r;
 	}
 
+	if (boot_cpu_has(X86_FEATURE_IBT) || boot_cpu_has(X86_FEATURE_SHSTK)) {
+		rdmsrl(MSR_IA32_S_CET, cet_msr);
+		WARN_ONCE(cet_msr, "KVM: CET S_CET in host will be lost!\n");
+	}
+
+	if (boot_cpu_has(X86_FEATURE_SHSTK)) {
+		rdmsrl(MSR_IA32_PL0_SSP, cet_msr);
+		WARN_ONCE(cet_msr, "KVM: CET PL0_SSP in host will be lost!\n");
+	}
+
 	vmx_set_cpu_caps();
 
 	r = alloc_kvm_area();
-- 
2.17.2

