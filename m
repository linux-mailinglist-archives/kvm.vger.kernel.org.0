Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B16C06B69AC
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 19:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbjCLSGX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 14:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbjCLSEz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 14:04:55 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B1C211F2;
        Sun, 12 Mar 2023 11:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678644042; x=1710180042;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XtJ0TXiY5/dEhxXqWKIXFHQ6ZVYT/3nRMRKqesdcsR4=;
  b=MWMds/cclyJdenCN9zt58pOvZTLzpWbsie2q+d6idvp+F9pmpTlA2zfI
   IJDlLJ4NnyahfKI8dZKS0KOtL6JYEAinpw59HVGMz5m8cW2ZZHSZcr1HJ
   58YUiUbPE5cjCegMz8oHPiVkbWQTF7jx9TAxrolh6XNMq0hJUet6JXKz5
   lsh6GgCvYaumA5j9KDg2UshTjzEEOUkcNNTAMvhUgEb3CaZRRiNhz2AR7
   x6DM3eK048ZHPPeGWlH3zcAn0i87ri73AgsM8FdGMHmOmrq7XAuFfKfWz
   rcbl0U7KUfpGHu+fkPjf1+b7ajTY0FA10+COfDxGOFE2jK7kAIqTTrtR4
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="316660048"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316660048"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="742596787"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="742596787"
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
Subject: [PATCH v13 087/113] KVM: TDX: handle EXCEPTION_NMI and EXTERNAL_INTERRUPT
Date:   Sun, 12 Mar 2023 10:56:51 -0700
Message-Id: <819e2c4415a2b2d0089b1d7c808dfc2b98ef83ed.1678643052.git.isaku.yamahata@intel.com>
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
index b2ea9b2f8e60..f7840232be85 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -777,6 +777,25 @@ void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
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
@@ -1205,6 +1224,10 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
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

