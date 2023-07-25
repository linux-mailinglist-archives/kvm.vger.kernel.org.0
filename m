Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 248C6762677
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232621AbjGYWYY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232697AbjGYWWV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:22:21 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7924F4EC5;
        Tue, 25 Jul 2023 15:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323471; x=1721859471;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7lKJ6bOIOJBVCdWzKOJhecQyu0qSSTJAZTUYFEWCbkQ=;
  b=l5w4VWLpwj9Bs4aZIcmRFTodHtJl8UPAP5oHF34FmxwzBRyDaAZNP2dr
   uDf423V+FgKTXcl7Ru/nA75jSf6K0xJHjnFUyWjrBUMsXKfK9V5xsbKok
   tm6wdzs1UHo6hzT5CPS4iKyKZ4hSwZKqXDFVo0+JFfwRMYWHOkyw3J/j+
   n+RkSNUzQRV9vGGAPFYZwCRpZuaypcaF9WUNzWiaLFPx6SiCw6l7Rk1tN
   9jzk9WSo/+b2Txj4znjPWLTGl8EsJmiX/zsTUGS2HWaEE2vPfTKvlf2bP
   qv/LmWdtbibDULT346bBEfLjax+4HSTN6DbuIEIvzSc4laNQo8/TgzmMw
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="367882669"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="367882669"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:16:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="840001876"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="840001876"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:16:00 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [PATCH v15 086/115] KVM: TDX: handle ept violation/misconfig exit
Date:   Tue, 25 Jul 2023 15:14:37 -0700
Message-Id: <b5989acb056eb58f9923f78ad8d548334e9737d1.1690322424.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690322424.git.isaku.yamahata@intel.com>
References: <cover.1690322424.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

On EPT violation, call a common function, __vmx_handle_ept_violation() to
trigger x86 MMU code.  On EPT misconfiguration, exit to ring 3 with
KVM_EXIT_UNKNOWN.  because EPT misconfiguration can't happen as MMIO is
trigged by TDG.VP.VMCALL. No point to set a misconfiguration value for the
fast path.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

---
v14 -> v15:
- use PFERR_GUEST_ENC_MASK to tell the fault is private

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/common.h |  3 +++
 arch/x86/kvm/vmx/tdx.c    | 46 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index aaab1d407207..e4fec792a3ae 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -87,6 +87,9 @@ static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
 	error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) != 0 ?
 	       PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
 
+	if (kvm_is_private_gpa(vcpu->kvm, gpa))
+		error_code |= PFERR_GUEST_ENC_MASK;
+
 	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
 }
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 0d92253ea40e..1a41e12f0942 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1136,6 +1136,48 @@ void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 	__vmx_deliver_posted_interrupt(vcpu, &tdx->pi_desc, vector);
 }
 
+static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
+{
+	unsigned long exit_qual;
+
+	if (kvm_is_private_gpa(vcpu->kvm, tdexit_gpa(vcpu))) {
+		/*
+		 * Always treat SEPT violations as write faults.  Ignore the
+		 * EXIT_QUALIFICATION reported by TDX-SEAM for SEPT violations.
+		 * TD private pages are always RWX in the SEPT tables,
+		 * i.e. they're always mapped writable.  Just as importantly,
+		 * treating SEPT violations as write faults is necessary to
+		 * avoid COW allocations, which will cause TDAUGPAGE failures
+		 * due to aliasing a single HPA to multiple GPAs.
+		 */
+#define TDX_SEPT_VIOLATION_EXIT_QUAL	EPT_VIOLATION_ACC_WRITE
+		exit_qual = TDX_SEPT_VIOLATION_EXIT_QUAL;
+	} else {
+		exit_qual = tdexit_exit_qual(vcpu);
+		if (exit_qual & EPT_VIOLATION_ACC_INSTR) {
+			pr_warn("kvm: TDX instr fetch to shared GPA = 0x%lx @ RIP = 0x%lx\n",
+				tdexit_gpa(vcpu), kvm_rip_read(vcpu));
+			vcpu->run->exit_reason = KVM_EXIT_EXCEPTION;
+			vcpu->run->ex.exception = PF_VECTOR;
+			vcpu->run->ex.error_code = exit_qual;
+			return 0;
+		}
+	}
+
+	trace_kvm_page_fault(vcpu, tdexit_gpa(vcpu), exit_qual);
+	return __vmx_handle_ept_violation(vcpu, tdexit_gpa(vcpu), exit_qual);
+}
+
+static int tdx_handle_ept_misconfig(struct kvm_vcpu *vcpu)
+{
+	WARN_ON_ONCE(1);
+
+	vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
+	vcpu->run->hw.hardware_exit_reason = EXIT_REASON_EPT_MISCONFIG;
+
+	return 0;
+}
+
 int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 {
 	union tdx_exit_reason exit_reason = to_tdx(vcpu)->exit_reason;
@@ -1196,6 +1238,10 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 	WARN_ON_ONCE(fastpath != EXIT_FASTPATH_NONE);
 
 	switch (exit_reason.basic) {
+	case EXIT_REASON_EPT_VIOLATION:
+		return tdx_handle_ept_violation(vcpu);
+	case EXIT_REASON_EPT_MISCONFIG:
+		return tdx_handle_ept_misconfig(vcpu);
 	case EXIT_REASON_OTHER_SMI:
 		/*
 		 * If reach here, it's not a Machine Check System Management
-- 
2.25.1

