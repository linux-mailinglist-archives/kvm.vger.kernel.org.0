Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 422DE79FAAC
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 07:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235915AbjINFU4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 01:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235199AbjINFUC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 01:20:02 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530E12122;
        Wed, 13 Sep 2023 22:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694668766; x=1726204766;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=T0jTyejyJ8JvDYansScu0V1dL1MHLI4ucPruSc2ZVaA=;
  b=h0h99R6OY5/nOSiEIXvynNt43Y4BJHh6hoxNoYCgOCp24tPeHsnB9KjE
   iT9l5pGI3OWBVbUBbcirR9tb6Ra3j79x4OzXkwJJJ7ojocxN/QFHZ49Vc
   YVrytypL6blQbjGGUZPjsNwgeqOEd7pKyt5oVqAwWfiS60DqvKBy2YLEm
   gAxZYJp6wlpBm/e0DWg0DOp4kPVtnZxP3m1s/NkiQ1Rk9bxq22wMvDnmp
   m91A/li/977op/1/zgjFpmAl8fKlOVyHopwk5/2QFR3wiF1+pX1+212cw
   K6B9I3hDxp8fdm4kfcrilLpIhL//IR2gKzuUCXHumSV1WkBHa3vgXaNre
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="382661510"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="382661510"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 22:17:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="779488841"
X-IronPort-AV: E=Sophos;i="6.02,145,1688454000"; 
   d="scan'208";a="779488841"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga001.jf.intel.com with ESMTP; 13 Sep 2023 22:17:46 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        peterz@infradead.org, jgross@suse.com, ravi.v.shankar@intel.com,
        mhiramat@kernel.org, andrew.cooper3@citrix.com,
        jiangshanlai@gmail.com
Subject: [PATCH v10 34/38] KVM: VMX: Call fred_entry_from_kvm() for IRQ/NMI handling
Date:   Wed, 13 Sep 2023 21:48:01 -0700
Message-Id: <20230914044805.301390-35-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914044805.301390-1-xin3.li@intel.com>
References: <20230914044805.301390-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When FRED is enabled, call fred_entry_from_kvm() to handle IRQ/NMI in
IRQ/NMI induced VM exits.

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
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

