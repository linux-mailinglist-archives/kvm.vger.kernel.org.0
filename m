Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1F607AC028
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 12:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbjIWKPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Sep 2023 06:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231713AbjIWKPZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 Sep 2023 06:15:25 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4114910C1;
        Sat, 23 Sep 2023 03:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695463920; x=1726999920;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MZgokrEaX/IcaX3hD6O7bYEAIXqVjdzkrr/jdEXzfh8=;
  b=cqZIw/GH/2210S2Zzg56rpU4JD+tvIVoft0VnGbzfvZj6nYlJbBnZsjb
   EdECRi2YzccxaRkXbG5w0xYrZkWyHPDScax6AfFTk+YOkw0Le/jhcBVSR
   dJnO2GVJ3jw5rcppjdwMfISE5+bUtm7dGC2n5Ji24YGiWoKIK1WDYKev9
   mf7bPlSf1K0Gld7ZhUrXL3uYkJHK5ZejgdWBDMVtTVcjI7rwaXNrw/5nU
   4a3K5oXI02LtAeYDegd74LHSwi6emEl+io1g23YJePz59ebxmI3MXn/Ei
   S7Vi69C+VHo8fT0m5azS/EeN9Fv1CseT/OM1mdGlquCsG4RpWCPP+YKDc
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="447492485"
X-IronPort-AV: E=Sophos;i="6.03,171,1694761200"; 
   d="scan'208";a="447492485"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2023 03:11:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="813388225"
X-IronPort-AV: E=Sophos;i="6.03,171,1694761200"; 
   d="scan'208";a="813388225"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga008.fm.intel.com with ESMTP; 23 Sep 2023 03:11:52 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        peterz@infradead.org, jgross@suse.com, ravi.v.shankar@intel.com,
        mhiramat@kernel.org, andrew.cooper3@citrix.com,
        jiangshanlai@gmail.com, nik.borisov@suse.com
Subject: [PATCH v11 34/37] KVM: VMX: Call fred_entry_from_kvm() for IRQ/NMI handling
Date:   Sat, 23 Sep 2023 02:42:09 -0700
Message-Id: <20230923094212.26520-35-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230923094212.26520-1-xin3.li@intel.com>
References: <20230923094212.26520-1-xin3.li@intel.com>
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

When FRED is enabled, call fred_entry_from_kvm() to handle IRQ/NMI in
IRQ/NMI induced VM exits.

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 72e3943f3693..db55b8418fa3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -38,6 +38,7 @@
 #include <asm/desc.h>
 #include <asm/fpu/api.h>
 #include <asm/fpu/xstate.h>
+#include <asm/fred.h>
 #include <asm/idtentry.h>
 #include <asm/io.h>
 #include <asm/irq_remapping.h>
@@ -6962,14 +6963,16 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 {
 	u32 intr_info = vmx_get_intr_info(vcpu);
 	unsigned int vector = intr_info & INTR_INFO_VECTOR_MASK;
-	gate_desc *desc = (gate_desc *)host_idt_base + vector;
 
 	if (KVM_BUG(!is_external_intr(intr_info), vcpu->kvm,
 	    "unexpected VM-Exit interrupt info: 0x%x", intr_info))
 		return;
 
 	kvm_before_interrupt(vcpu, KVM_HANDLING_IRQ);
-	vmx_do_interrupt_irqoff(gate_offset(desc));
+	if (cpu_feature_enabled(X86_FEATURE_FRED))
+		fred_entry_from_kvm(EVENT_TYPE_EXTINT, vector);
+	else
+		vmx_do_interrupt_irqoff(gate_offset((gate_desc *)host_idt_base + vector));
 	kvm_after_interrupt(vcpu);
 
 	vcpu->arch.at_instruction_boundary = true;
@@ -7262,7 +7265,10 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	if ((u16)vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI &&
 	    is_nmi(vmx_get_intr_info(vcpu))) {
 		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
-		vmx_do_nmi_irqoff();
+		if (cpu_feature_enabled(X86_FEATURE_FRED))
+			fred_entry_from_kvm(EVENT_TYPE_NMI, NMI_VECTOR);
+		else
+			vmx_do_nmi_irqoff();
 		kvm_after_interrupt(vcpu);
 	}
 
-- 
2.34.1

