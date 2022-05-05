Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3765151C720
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383271AbiEESZF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383371AbiEESTw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:19:52 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB4A2C67A;
        Thu,  5 May 2022 11:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651774567; x=1683310567;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=674P44PKVle2HtNNXJ57ExY7a4p/nlHO2jQBLfs+yQs=;
  b=C9siS0z2iBUzM3u4OPcBz8PfIyYk0x9JraBr8t0yhWlj2/KxCdTlgOVH
   8vFP9xKJc8ybvKt9FkNt4omkQ1wKXmUtbIavPuOb4/HgctSiFtY35/6Ew
   VzCLqPQhCw1l5UdcgpfWJwf8P3Rie6Vw4cOwCDMF2v1vbcfBSguKS5dG5
   b3LqtqUnxmDr4Cq7ijq/SR/HuXpRZTg3PfopgLHZ78HZoQEkPxYPYAEym
   Yx9CXlWLU3484+WVknqd8jJuNIeOsZB2wu/rz+zv6rgpCSJEoT7BaEsih
   bD5nFkOFJMpb7WKuFU4eCZay91TOv5kUB8TKtJZfOcZbvl1Gjnsz0etCn
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248742060"
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="248742060"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:53 -0700
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="665083456"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:53 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH v6 087/104] KVM: TDX: handle EXCEPTION_NMI and EXTERNAL_INTERRUPT
Date:   Thu,  5 May 2022 11:15:21 -0700
Message-Id: <1eef3971c8fa43816bb8fae57cff75584549a1a0.1651774250.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651774250.git.isaku.yamahata@intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Because guest TD state is protected, exceptions in guest TDs can't be
intercepted.  TDX VMM doesn't need to handle exceptions.
tdx_handle_exit_irqoff() handles NMI and machine check.  Ignore NMI and
machine check and continue guest TD execution.

For external interrupt, increment stats same to the VMX case.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/tdx.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 82bfdb05e67b..2f88871b5b86 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -851,6 +851,25 @@ void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 						     tdexit_intr_info(vcpu));
 }
 
+static int tdx_handle_exception(struct kvm_vcpu *vcpu)
+{
+	u32 intr_info = tdexit_intr_info(vcpu);
+
+	if (is_nmi(intr_info) || is_machine_check(intr_info))
+		return 1;
+
+	kvm_pr_unimpl("unexpected exception 0x%x(exit_reason 0x%llx qual 0x%lx)\n",
+		intr_info,
+		to_tdx(vcpu)->exit_reason.full, tdexit_exit_qual(vcpu));
+	return -EFAULT;
+}
+
+static int tdx_handle_external_interrupt(struct kvm_vcpu *vcpu)
+{
+	++vcpu->stat.irq_exits;
+	return 1;
+}
+
 static int tdx_handle_triple_fault(struct kvm_vcpu *vcpu)
 {
 	vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
@@ -1251,6 +1270,10 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 	WARN_ON_ONCE(fastpath != EXIT_FASTPATH_NONE);
 
 	switch (exit_reason.basic) {
+	case EXIT_REASON_EXCEPTION_NMI:
+		return tdx_handle_exception(vcpu);
+	case EXIT_REASON_EXTERNAL_INTERRUPT:
+		return tdx_handle_external_interrupt(vcpu);
 	case EXIT_REASON_EPT_VIOLATION:
 		return tdx_handle_ept_violation(vcpu);
 	case EXIT_REASON_EPT_MISCONFIG:
-- 
2.25.1

