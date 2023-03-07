Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBD1C6AD551
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 04:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbjCGDIS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 22:08:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231151AbjCGDHl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 22:07:41 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4517C87A23;
        Mon,  6 Mar 2023 19:06:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678158374; x=1709694374;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ldK8JEsrDCe0H7nzPkeyohBcSS2VhVlUfGora58zyTs=;
  b=gYUd1i5p3deU1a1+kFJPfJk4eomdmH6lOxmc6qsu+Gr+NU5l8BlT8EmT
   sRChkgj/gRtxAPW9GdXvCuA7w7fVvHrevUkVf6mugSbd+xpsEPHISfMZT
   RXO9b+tE7G07P7WwgHukCGFr7CxfnwQsSkPKyALVks1NY6/Ut/uH0Khq4
   FfLIAMXa40Gsbuf0vL/4QNjCLTFhpc+yjjpnroDWrjsTc0+wNbPQCV8iq
   do89m4ky2SSoiBLURfulzR2Td7/xzUJGMZ3qQEqE6189xyqyba9bUs4+/
   zcu6Eu7i+BIfJXmLgq2hwRVQJqH9+VFPheQ+vSKAghgh4hYco+ajKZvCy
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="338072644"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="338072644"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 19:05:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="676409966"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="676409966"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga002.jf.intel.com with ESMTP; 06 Mar 2023 19:05:23 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [PATCH v5 34/34] KVM: x86/vmx: execute "int $2" to handle NMI in NMI caused VM exits when FRED is enabled
Date:   Mon,  6 Mar 2023 18:39:46 -0800
Message-Id: <20230307023946.14516-35-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230307023946.14516-1-xin3.li@intel.com>
References: <20230307023946.14516-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Execute "int $2" to handle NMI in NMI caused VM exits when FRED is enabled.

Like IRET for IDT, ERETS/ERETU are required to end the NMI handler for FRED
to unblock NMI ASAP (w/ bit 28 of CS set). And there are 2 approaches to
invoke the FRED NMI handler:
1) execute "int $2", let the h/w do the job.
2) create a FRED NMI stack frame on the current kernel stack with ASM,
   and then jump to fred_entrypoint_kernel in arch/x86/entry/entry_64_fred.S.

1) is preferred as we want less ASM.

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---

Changes since v4:
*) Do NOT use the term "injection", which in the KVM context means to
   reinject an event into the guest (Sean Christopherson).
*) Add the explanation of why to execute "int $2" to invoke the NMI handler
   in NMI caused VM exits (Sean Christopherson).
---
 arch/x86/kvm/vmx/vmx.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3ebeaab34b2e..4f12ead2266b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7229,7 +7229,16 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	if ((u16)vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI &&
 	    is_nmi(vmx_get_intr_info(vcpu))) {
 		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
-		vmx_do_nmi_irqoff();
+		/*
+		 * Like IRET for IDT, ERETS/ERETU are required to end the NMI
+		 * handler for FRED to unblock NMI ASAP (w/ bit 28 of CS set).
+		 *
+		 * Invoke the FRED NMI handler through executing "int $2".
+		 */
+		if (cpu_feature_enabled(X86_FEATURE_FRED))
+			asm volatile("int $2");
+		else
+			vmx_do_nmi_irqoff();
 		kvm_after_interrupt(vcpu);
 	}
 
-- 
2.34.1

