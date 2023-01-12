Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1533D667B06
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240098AbjALQiH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:38:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231421AbjALQhV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:37:21 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D26155A7;
        Thu, 12 Jan 2023 08:33:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541223; x=1705077223;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fkeGVFQD0dn9Ucy3QnRtrSa1lunrjVgLXe37fk9K2VY=;
  b=IVcr2ltu+Xcm1z8CuHtF4H3IkgVYAoB7x26N22UX+IkGoLiqHWoGVirT
   324YEOEt77VaqMZfLSEUrAE7oqrsc6eUYcJWUE7LWHucA5Gv+Mn2YP6sX
   Ua6/oJjXKsbeoJ1UYhB8s+8pHfGRN36MDaptfkTfVAqH13cEXl5XM32a4
   Q4fINbvQjqVOzPGzWgQhQRtb1ucP9HNBLbF7rBUH3KZgJuTvYJ9IiVBcT
   bhub1bE6RwBQ+/7HenR9tjzMjCjMI2vsMT/zkaegIjAnJWSAzh0BNP2WH
   LLveXLFjyw+iLaqybz1WqdqBPXfkX3HQb35NfuqaNUFV4cdy6z7elt/V7
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="386089700"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="386089700"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:35 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="726372540"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="726372540"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:35 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 088/113] KVM: TDX: handle EXCEPTION_NMI and EXTERNAL_INTERRUPT
Date:   Thu, 12 Jan 2023 08:32:36 -0800
Message-Id: <014bd803709f234942f0bcff754115489c4ffdb0.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index 2bea7c96536b..d3181e191adf 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -742,6 +742,25 @@ void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
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
@@ -1161,6 +1180,10 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
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

