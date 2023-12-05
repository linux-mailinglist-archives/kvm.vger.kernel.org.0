Return-Path: <kvm+bounces-3548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7133A8052A9
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 12:24:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D7C4283BF9
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:24:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 899FF68EBF;
	Tue,  5 Dec 2023 11:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OlibKuwE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6B0D4F;
	Tue,  5 Dec 2023 03:21:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701775297; x=1733311297;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SQLskgfezeMmMUQK7hRm+in8U5EG93C8+IUmjWFkZJ4=;
  b=OlibKuwEy+FIpwvCBCGs+hWByLFWCrEdYyxCLxmuOIaVvDNP73o4CRR4
   rolX/+63VpPr7pTHYRG8d4crgG0FBeVAFdfScFiDMparkTpkfigk10Bju
   iBip5D6Yfu6JAFG0E8wi890/2x08MLIKtmfU2VBuEjho1EEFUFzzpRETX
   6+vzpc1Wdf409bqbNeaCRWvxtg6jKI8ApaUTn6m/yCqyk8CiAYfZVmuZl
   BXIP1MbQ8WU0K6NdcQf2Bb8h/fhmOB7HnSFFTYs6K4DxoRRx1Vmmmi0O8
   V+9mqmj/hR9q48R1s6rRxsa+x6EXC7WqAFHkT6n8vGwVZnJSD3fMpJe2n
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="942718"
X-IronPort-AV: E=Sophos;i="6.04,252,1695711600"; 
   d="scan'208";a="942718"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 03:21:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="1018193012"
X-IronPort-AV: E=Sophos;i="6.04,252,1695711600"; 
   d="scan'208";a="1018193012"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga006.fm.intel.com with ESMTP; 05 Dec 2023 03:21:26 -0800
From: Xin Li <xin3.li@intel.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-edac@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	luto@kernel.org,
	pbonzini@redhat.com,
	seanjc@google.com,
	peterz@infradead.org,
	jgross@suse.com,
	ravi.v.shankar@intel.com,
	mhiramat@kernel.org,
	andrew.cooper3@citrix.com,
	jiangshanlai@gmail.com,
	nik.borisov@suse.com,
	shan.kang@intel.com
Subject: [PATCH v13 32/35] KVM: VMX: Call fred_entry_from_kvm() for IRQ/NMI handling
Date: Tue,  5 Dec 2023 02:50:21 -0800
Message-ID: <20231205105030.8698-33-xin3.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205105030.8698-1-xin3.li@intel.com>
References: <20231205105030.8698-1-xin3.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When FRED is enabled, call fred_entry_from_kvm() to handle IRQ/NMI in
IRQ/NMI induced VM exits.

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index be20a60047b1..ba5cd26137e0 100644
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
2.43.0


