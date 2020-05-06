Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2EF41C6B69
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 10:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728835AbgEFITu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 04:19:50 -0400
Received: from mga12.intel.com ([192.55.52.136]:35426 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728712AbgEFITt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 04:19:49 -0400
IronPort-SDR: cVAWsG3BIuqihxI7rEXhv/daE/oDKudioThd3dj4wxyJVEEdJF58UgSqPvKKJlq2XgEwH5huPe
 2cEMse+QjpSQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2020 01:19:48 -0700
IronPort-SDR: hrgJYBBPPtcTpIv0lz6Ley/L/1lI3uFYZWZDa9zLPv3o1VgeEN/am13KQZcIcUU6kr9dJz3gsa
 jp10tzITKOMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,358,1583222400"; 
   d="scan'208";a="260030122"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.128])
  by orsmga003.jf.intel.com with ESMTP; 06 May 2020 01:19:46 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v12 08/10] KVM: VMX: Add VMCS dump and sanity check for CET states
Date:   Wed,  6 May 2020 16:21:07 +0800
Message-Id: <20200506082110.25441-9-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200506082110.25441-1-weijiang.yang@intel.com>
References: <20200506082110.25441-1-weijiang.yang@intel.com>
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

