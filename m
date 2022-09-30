Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150765F08CA
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbiI3KWt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231859AbiI3KUk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:20:40 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7052A1F9CB9;
        Fri, 30 Sep 2022 03:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533154; x=1696069154;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Uio+2tF2pQzjJFOB8U+cXpbHmxFv+7xgGFcTZNRudcc=;
  b=WZ7uPNi+D7JIbJA0xC99H4WvL+wpT/NGe41iAV75RWuwrmbnaAruIAfu
   eugRWb0Y3uM1W8xbQ01l4o55H0Ytx6sgL2WWF0l5u/qdDG7nb5gEngcXC
   HHigrpbLiNXXt8CUDIfsF9FrqvKjQ5JJUka4wT6rbmE7OXpGz8QCXGT6Q
   KFqiBrkOIy2jWhg8pIsGaYS9AKTpHEw0OVubgEn/IKh91Wyn6+MJuBtRq
   44psKSmxgzWCMgRAdPdz1i14DghfVHoCdaB7/8wwzfFiTp6E70oxYMd6n
   dWIFL/bLcpfiBPJ77AAc/AePRDw5d87MpV/5p91uydPr5f3PhiucBvJKN
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="328540158"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="328540158"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:19:06 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807788"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807788"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:19:06 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v9 087/105] KVM: TDX: handle ept violation/misconfig exit
Date:   Fri, 30 Sep 2022 03:18:21 -0700
Message-Id: <07f45330c377c6fbd700e8538ed9f718bac07598.1664530908.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
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
 arch/x86/kvm/vmx/tdx.c | 46 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index fbf7968bf718..def8eb3df75f 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1015,6 +1015,48 @@ void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
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
+	trace_kvm_page_fault(tdexit_gpa(vcpu), exit_qual);
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
@@ -1037,6 +1079,10 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
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

