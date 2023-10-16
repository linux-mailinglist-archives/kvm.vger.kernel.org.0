Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36CF97CAF92
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234114AbjJPQfX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234123AbjJPQeU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:34:20 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F323469D;
        Mon, 16 Oct 2023 09:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473209; x=1729009209;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MsBktsb3DAZzlx1/Ek1C6F/9rTLE6JI+J9Y+xXj79Bo=;
  b=OPXa8Dzosc9Jf1o1F5uVb+Clncb39WiEQS6MbEYPbbm9YrbZqX/GsqAC
   +4KCqGciHD1hXLB9pSFXJVMHkLB2bMBIhNd9ylGJRcHZe/daZvx4cEqd5
   cV+xPVZD3c/39ROJ1uMXLHxhk+wkUszJnDA6hNXS+5NaWZv4YksXygN0f
   1bw+KO1WVNZJljcjy6mpMdjnCRlEjKLkEh5kLaiSy+B/HVA0FwL+V1N97
   WsHWxBDhhTsEoGQSGmKv/oy9MjCEmIHwbOX44vhXoGgoFe9Iyf4NzLg86
   ho1TnPYEtHokvx36nCPOdHHfwVMDwhkcq4wIcFCyq/Wq3Lf6DZ+TBCWTQ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="364922012"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="364922012"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:16:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="846448273"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="846448273"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:16:02 -0700
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
Subject: [PATCH v16 086/116] KVM: TDX: handle EXCEPTION_NMI and EXTERNAL_INTERRUPT
Date:   Mon, 16 Oct 2023 09:14:38 -0700
Message-Id: <ef0f9f19d2bcebd873ba396fd0f49cb744cfcf17.1697471314.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697471314.git.isaku.yamahata@intel.com>
References: <cover.1697471314.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
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
index f98b27cb9003..6bed75c4069c 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -892,6 +892,25 @@ void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 		vmx_handle_exception_irqoff(vcpu, tdexit_intr_info(vcpu));
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
@@ -1381,6 +1400,10 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
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

