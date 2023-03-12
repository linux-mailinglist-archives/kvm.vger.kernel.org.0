Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9003E6B69AB
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 19:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbjCLSGV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 14:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231969AbjCLSEy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 14:04:54 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A140509BF;
        Sun, 12 Mar 2023 11:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678644038; x=1710180038;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uUDL5EsTWCGPAHBYa5egZLwHo8qrHMyp0EmWEOTNPtQ=;
  b=hwmM8/IY/fjWJ6ziytWA4jE4mFZ8/0dT34PCncHIZnOYpPVRUHDUy56z
   j/jxAdb/f9ACAZsd0CX8e59s4eUuCh7VQWSrmZ5jm728JE6AEtfnERhNV
   5TlDpzxcOc0UhD/q9bPeJrCxTCSvnYeCDvflawwf7uR0dZCC4o+7ei8j9
   dZxpZ+U8BAzaBXlCNAK5Jry+pXZ+aW9uuT1S8xRCCnmScGnqfFaJbHyZo
   CuMHCdbDlqeWgGGd+WT+Eiwc2o3SnZlk54Zwas+n2eTITM6HWz9axYE2r
   ly/86wIvpLRK0SZtWxIb2QNiiQ8eF7Gs1Ntbl3SWoP+iEMa2HnPuH4VW1
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="316660044"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316660044"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="742596783"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="742596783"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:13 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v13 086/113] KVM: TDX: handle ept violation/misconfig exit
Date:   Sun, 12 Mar 2023 10:56:50 -0700
Message-Id: <15b23d369ecf9d0389db40b6ba6362568c447cbe.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1678643051.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/vmx/tdx.c | 46 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ab4e030b8323..b2ea9b2f8e60 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1110,6 +1110,48 @@ void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
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
@@ -1163,6 +1205,10 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
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

