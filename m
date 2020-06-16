Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBDE1FC1C9
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 00:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbgFPWne (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 18:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgFPWne (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 18:43:34 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6E8C061573
        for <kvm@vger.kernel.org>; Tue, 16 Jun 2020 15:43:32 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id v15so223968qvm.2
        for <kvm@vger.kernel.org>; Tue, 16 Jun 2020 15:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=1ZS29LeX+3tvxr4Tw+LAYsKpl9FN0zDSujjFudjKbJQ=;
        b=bGdZAuvy5rOwnjAX9d4wyGzm0CnX0+lD7ClzAMndgj+qrBhgc5HjY9oZHMuI6dHP52
         9bE29dG6T2aQndRP95tWHfvNZWS/umrbje6gRxjpUN+Jwwg9jo3REkb3xfOxuvF4M4cg
         vvI7q8AHWNUdXt6GwwsejTQYOU0/W3fqUjwiB+WmShlgrRoGiT9R+KLgIPzRE5D7XqjD
         2Y6K53CJV+5XdXuNPGDZR6UeYvO2zihCwi2xZmJOo0sah3TvX+/kWpyIFkAgicrvjj+u
         vVzjz+T2frAPtNb/mlOrNz0aevldzm08mz9FuKS6729qjFjxSYy1OG/YCCqML+yXrdev
         7tYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=1ZS29LeX+3tvxr4Tw+LAYsKpl9FN0zDSujjFudjKbJQ=;
        b=INyaqj4BhdaIE5rG6J0PgfYq1IKJafL7/H9k7tvZXNqXGUn/O4BADgUZI4xrny8UKr
         Y2ox0ImjuTQn8utLwvGmBP/Vjt3phAd+FT2Ji+CtWcTE1cK5gLU9qiTW6BXFpLH/Ezy3
         g6ORjxY+0QWE8aSae0lFcdrNJTsO2CV6XAG2eMdGn2ftbXuwHgv38FfwNAXRlic5hakr
         VuXPun7B7MSuosW2G01n3sX4S0HmjtstjEubjIwqJwyS2M5VUl12agM0ld8sq2PrV3lj
         2hmunVyC8FGNw9yREpIUSpslxqp9GFS5JpA7jKSqGE5IvFdlpAImG1J79W4ENdLLTAGr
         rtJA==
X-Gm-Message-State: AOAM530zHx1azKc71gYttwMsekMEgx1pFKK2h0+kXFRH5E/QAU5WR3/j
        /ToVYBee/ed3wtbeZJtnKRSH9TUZ3rm1ZNRiKENrJIFYpaS+kLwF8BgMuw82JzI+fpimRLtkcAl
        5ruFPI94ee6QTaPD9i5xGmN4kWAAtKfRt9CYBbQuHaCTFHTb8TSHfpUmFbw==
X-Google-Smtp-Source: ABdhPJwm7FxidjZUR9hxNa4GxH27OP1BwC5fHRY1imNw5xCwm176YSy1ku28UHX9qndJjVNoOLGXv01fm3Y=
X-Received: by 2002:a05:6214:12cf:: with SMTP id s15mr4581045qvv.242.1592347411747;
 Tue, 16 Jun 2020 15:43:31 -0700 (PDT)
Date:   Tue, 16 Jun 2020 22:43:05 +0000
Message-Id: <20200616224305.44242-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
Subject: [PATCH] kvm: nVMX: flush TLB when decoded insn != VM-exit reason
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Oliver Upton <oupton@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is possible for the instruction emulator to decode a different
instruction from what was implied by the VM-exit information provided by
hardware in vmcs02. Such is the case when the TLB entry for the guest's
IP is out of sync with the appropriate page-table mapping if page
installation isn't followed with a TLB flush.

Currently, KVM refuses to emulate in these scenarios, instead injecting
a #UD into L2. While this does address the security risk of
CVE-2020-2732, it could result in spurious #UDs to the L2 guest. Fix
this by instead flushing the TLB then resuming L2, allowing hardware to
generate the appropriate VM-exit to be reflected into L1.

Exceptional handling is also required for RSM and RDTSCP instructions.
RDTSCP could be emulated on hardware which doesn't support it,
therefore hardware will not generate a RDTSCP VM-exit on L2 resume. The
dual-monitor treatment of SMM is not supported in nVMX, which implies
that L0 should never handle a RSM instruction. Resuming the guest will
only result in another #UD. Avoid getting stuck in a loop with these
instructions by injecting a #UD for RSM and the appropriate VM-exit for
RDTSCP.

Fixes: 07721feee46b ("KVM: nVMX: Don't emulate instructions in guest mode")
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 arch/x86/kvm/emulate.c     |  2 ++
 arch/x86/kvm/kvm_emulate.h |  1 +
 arch/x86/kvm/vmx/vmx.c     | 68 ++++++++++++++++++++++++++++----------
 arch/x86/kvm/x86.c         |  2 +-
 4 files changed, 55 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index d0e2825ae617..6e56e7a29ba1 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -5812,6 +5812,8 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 	}
 	if (rc == X86EMUL_INTERCEPTED)
 		return EMULATION_INTERCEPTED;
+	if (rc == X86EMUL_RETRY_INSTR)
+		return EMULATION_RETRY_INSTR;
 
 	if (rc == X86EMUL_CONTINUE)
 		writeback_registers(ctxt);
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 43c93ffa76ed..5bfab8d65cd1 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -496,6 +496,7 @@ bool x86_page_table_writing_insn(struct x86_emulate_ctxt *ctxt);
 #define EMULATION_OK 0
 #define EMULATION_RESTART 1
 #define EMULATION_INTERCEPTED 2
+#define EMULATION_RETRY_INSTR 3
 void init_decode_cache(struct x86_emulate_ctxt *ctxt);
 int x86_emulate_insn(struct x86_emulate_ctxt *ctxt);
 int emulator_task_switch(struct x86_emulate_ctxt *ctxt,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 08e26a9518c2..ebfafd7837ba 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7329,12 +7329,11 @@ static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)
 	to_vmx(vcpu)->req_immediate_exit = true;
 }
 
-static int vmx_check_intercept_io(struct kvm_vcpu *vcpu,
-				  struct x86_instruction_info *info)
+static bool vmx_check_intercept_io(struct kvm_vcpu *vcpu,
+				   struct x86_instruction_info *info)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	unsigned short port;
-	bool intercept;
 	int size;
 
 	if (info->intercept == x86_intercept_in ||
@@ -7354,13 +7353,10 @@ static int vmx_check_intercept_io(struct kvm_vcpu *vcpu,
 	 * Otherwise, IO instruction VM-exits are controlled by the IO bitmaps.
 	 */
 	if (!nested_cpu_has(vmcs12, CPU_BASED_USE_IO_BITMAPS))
-		intercept = nested_cpu_has(vmcs12,
-					   CPU_BASED_UNCOND_IO_EXITING);
-	else
-		intercept = nested_vmx_check_io_bitmaps(vcpu, port, size);
+		return nested_cpu_has(vmcs12,
+				      CPU_BASED_UNCOND_IO_EXITING);
 
-	/* FIXME: produce nested vmexit and return X86EMUL_INTERCEPTED.  */
-	return intercept ? X86EMUL_UNHANDLEABLE : X86EMUL_CONTINUE;
+	return nested_vmx_check_io_bitmaps(vcpu, port, size);
 }
 
 static int vmx_check_intercept(struct kvm_vcpu *vcpu,
@@ -7369,6 +7365,7 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
 			       struct x86_exception *exception)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
+	bool intercepted;
 
 	switch (info->intercept) {
 	/*
@@ -7381,13 +7378,27 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
 			exception->error_code_valid = false;
 			return X86EMUL_PROPAGATE_FAULT;
 		}
+
+		intercepted = nested_cpu_has(vmcs12, CPU_BASED_RDTSC_EXITING);
+
+		/*
+		 * RDTSCP could be emulated on a CPU which doesn't support it.
+		 * As such, flushing the TLB and resuming L2 will result in
+		 * another #UD rather than a VM-exit to reflect into L1.
+		 * Instead, synthesize the VM-exit here.
+		 */
+		if (intercepted) {
+			nested_vmx_vmexit(vcpu, EXIT_REASON_RDTSCP, 0, 0);
+			return X86EMUL_INTERCEPTED;
+		}
 		break;
 
 	case x86_intercept_in:
 	case x86_intercept_ins:
 	case x86_intercept_out:
 	case x86_intercept_outs:
-		return vmx_check_intercept_io(vcpu, info);
+		intercepted = vmx_check_intercept_io(vcpu, info);
+		break;
 
 	case x86_intercept_lgdt:
 	case x86_intercept_lidt:
@@ -7397,18 +7408,41 @@ static int vmx_check_intercept(struct kvm_vcpu *vcpu,
 	case x86_intercept_sidt:
 	case x86_intercept_sldt:
 	case x86_intercept_str:
-		if (!nested_cpu_has2(vmcs12, SECONDARY_EXEC_DESC))
-			return X86EMUL_CONTINUE;
-
-		/* FIXME: produce nested vmexit and return X86EMUL_INTERCEPTED.  */
+		intercepted = nested_cpu_has2(vmcs12, SECONDARY_EXEC_DESC);
 		break;
 
-	/* TODO: check more intercepts... */
+	/*
+	 * The dual-monitor treatment of SMM is not supported in nVMX. As such,
+	 * L0 will never handle the RSM instruction nor should it retry
+	 * instruction execution. Instead, a #UD should be injected into the
+	 * guest for the execution of RSM outside of SMM.
+	 */
+	case x86_intercept_rsm:
+		exception->vector = UD_VECTOR;
+		exception->error_code_valid = false;
+		return X86EMUL_PROPAGATE_FAULT;
+
 	default:
-		break;
+		intercepted = true;
 	}
 
-	return X86EMUL_UNHANDLEABLE;
+	if (!intercepted)
+		return X86EMUL_CONTINUE;
+
+	/*
+	 * The only uses of the emulator in VMX for instructions which may be
+	 * intercepted are port IO instructions, descriptor-table accesses, and
+	 * the RDTSCP instruction. As such, if the emulator has decoded an
+	 * instruction that is different from the VM-exit provided by hardware
+	 * it is likely that the TLB entry and page-table mapping for the
+	 * guest's RIP are out of sync.
+	 *
+	 * Rather than synthesizing a VM-exit into L1 for every possible
+	 * instruction just flush the TLB, resume L2, and let hardware generate
+	 * the appropriate VM-exit.
+	 */
+	vmx_flush_tlb_gva(vcpu, kvm_rip_read(vcpu));
+	return X86EMUL_RETRY_INSTR;
 }
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 00c88c2f34e4..2ab47485100f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6967,7 +6967,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 
 	r = x86_emulate_insn(ctxt);
 
-	if (r == EMULATION_INTERCEPTED)
+	if (r == EMULATION_INTERCEPTED || r == EMULATION_RETRY_INSTR)
 		return 1;
 
 	if (r == EMULATION_FAILED) {
-- 
2.27.0.290.gba653c62da-goog

