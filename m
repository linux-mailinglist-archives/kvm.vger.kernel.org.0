Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6094CDD8C
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 20:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiCDT7f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 14:59:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiCDT7L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 14:59:11 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6192325F3;
        Fri,  4 Mar 2022 11:50:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646423443; x=1677959443;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lBNgey1dNY1UFmNmMzmdiOJCYlx7auBIKRKZTs2fnBM=;
  b=Bhs4kg6j+yT142fS5y71Xz1yF5E7iu78Iai3ViDjDEuQqp8rGf/D6zaZ
   B2mjEBEMyVsFv9xDNaDkJh+ki8coKfcxVaqERuHYtAkPFlXU2niH3fQKf
   F7nnGFZgGpq60Ryerf2mXU2q5NBo/0yRNaibj/lGvQ/ROHPx1M1qqid3E
   4r9hMFOumUOtpnKRva+9KQTeemMrpS+uF7fZYZmYxzcX77Ut+lG8FvhV0
   E7oCHiz9OWBTA6VIMdwsHLJyu3zEBl/XeOZ4jKPZ/tnXxrAeAST3/KlqX
   nnoj5eRuQoMTMjR8SG9pGoJUyksMnYlp4iTDbfos+7x/XChelOqqmYV8Y
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253779641"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253779641"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:41 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344528"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:40 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 085/104] KVM: TDX: handle EXIT_REASON_OTHER_SMI
Date:   Fri,  4 Mar 2022 11:49:41 -0800
Message-Id: <ea42891d7b9b378242bc027976415d8d81e21310.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

If the control reaches EXIT_REASON_OTHER_SMI, #SMI is delivered and
handled right after returning from the TDX module to KVM nothing needs to
be done in KVM.  Continue TDX vcpu execution.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/uapi/asm/vmx.h | 1 +
 arch/x86/kvm/vmx/tdx.c          | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index 946d761adbd3..3d9b4598e166 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -34,6 +34,7 @@
 #define EXIT_REASON_TRIPLE_FAULT        2
 #define EXIT_REASON_INIT_SIGNAL			3
 #define EXIT_REASON_SIPI_SIGNAL         4
+#define EXIT_REASON_OTHER_SMI           6
 
 #define EXIT_REASON_INTERRUPT_WINDOW    7
 #define EXIT_REASON_NMI_WINDOW          8
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 155208a8d768..6fbe89bcfe1e 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1097,6 +1097,13 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 	WARN_ON_ONCE(fastpath != EXIT_FASTPATH_NONE);
 
 	switch (exit_reason.basic) {
+	case EXIT_REASON_OTHER_SMI:
+		/*
+		 * If reach here, it's not a MSMI.
+		 * #SMI is delivered and handled right after SEAMRET, nothing
+		 * needs to be done in KVM.
+		 */
+		return 1;
 	default:
 		break;
 	}
-- 
2.25.1

