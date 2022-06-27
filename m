Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFCB55D9D0
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241850AbiF0V6K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241575AbiF0Vzr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:55:47 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB7214032;
        Mon, 27 Jun 2022 14:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366907; x=1687902907;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=D2gA4rK9DEmpJ37PjtOp6NTlDb5+OVX21I4TAO+cMHY=;
  b=faAtRQT18yBMyjIYB8uTiPQI6nj8PpNP/VwjR1ccUCte74Imq+j8zXn6
   i2+ZFQAuYZHaeazAdA57E+kEaE9NAJ19ArSzejh5W3xXQdrJEw+nmZf8L
   tTqicvUrMv8jFTsyUPtf8PhvYBmR2p61WfY5+kJnbNFS/jfAnAsA8aMcm
   iMm8flZL47vjsYlaeyMCmprTk8sN5ZsJIx9jOdYt9GOqCCQIBawbhR679
   B/RXi6fk5ouDdGd92wKOPDwkPK8DFHfRFbttSNtOKC36QbPD82FcF2CJl
   ds3b0E0eW/d2ulzJeONVPeYE8ejWn54WhA9kYczQdcJmo++LoNumGhbQq
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="279116133"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="279116133"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:55:01 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863719"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:55:00 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v7 086/102] KVM: TDX: handle EXCEPTION_NMI and EXTERNAL_INTERRUPT
Date:   Mon, 27 Jun 2022 14:54:18 -0700
Message-Id: <98e0297d90081a48fba2b55658fbd0a69950837d.1656366338.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1656366337.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index 14f65d7b3824..6e8a7e4b4da2 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -852,6 +852,25 @@ void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
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

