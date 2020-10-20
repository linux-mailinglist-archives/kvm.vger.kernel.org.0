Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A227E28616C
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 16:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728675AbgJGOnW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 10:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728658AbgJGOnW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Oct 2020 10:43:22 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5655CC061755
        for <kvm@vger.kernel.org>; Wed,  7 Oct 2020 07:43:22 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id i5so2450720edr.5
        for <kvm@vger.kernel.org>; Wed, 07 Oct 2020 07:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qCIIRICP5BmlqsnVWzmVkgnL6wAkef7/AiOVTqohN0Y=;
        b=X98lGedUR8e4n8Ung1tsGM6cKOxNpJspLUSoFZ74ntHufrkdcvTMq2IhzCqdXnZKvQ
         cMKlGu3QUtXtFOBtgi6X8GRB7oHavtdY8fgpzeZOczuFXzhlJVEaOHprJL6fl6tm7rVi
         JghNORWau8WDEHq2/OjGuC3uaujSH2S7QEvLXmj3HOkhSnKISClfDc7OC515BWq+nUm4
         zXUw91t5uouB7HTsLOd/3WA6IlrsI3HXufo335+/+9YbRoHTMvfNuuB0NYt3bgSdhFq8
         Ewe84UA4K/Hlq79zwiVPkh+/6EBR4UxakV9dyCVMb01YthFEF/zLJXDPTvOdsN+cmtqU
         sRdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qCIIRICP5BmlqsnVWzmVkgnL6wAkef7/AiOVTqohN0Y=;
        b=g5T6UuCWwl5W0VnOH2X2HyeDO4cgIYaMhkLI1BRGNAzCM3/9L+/EyL7DsC4nvZKbYr
         2zqO9Hb0zu/Q3IopRCCze59XAP8+/Rj9CN1k/IsOWHsZJ5VGN+MMUEBYxzGd6H4N01Nf
         z5ykf7zl+AYsKZoRhkpKIObtCmheLUl0NEkV/3D0+eZToJFP94U8CUJgQkxcNeaMQKDz
         iJOeavQ94RDjOrx1MNO6LxMuY2jrbKEhQ3eMStM0PBnFgvLJJvILZHfjbBaenyS05B3c
         ZfnC+g8UWX8jYc+436nmAA5nBvXM8f3e+6pNpncJ4EpKwJ+R+0HNQBQrkxLgu9FmxSgE
         kqpg==
X-Gm-Message-State: AOAM530PAgfYvdbLDdwknpYnPIJA2P8CMz+Z11p1jCHPGrPU60dNJBzZ
        FTJQM8RCKWswEaUq1zvfFV4kVgv/4OB5mQ==
X-Google-Smtp-Source: ABdhPJyXRJu56wmEseZO5gAR6t1GJhlbHm1VJJ/BE0/MivhrUtp1b1U8+K7IpNTApC66pE+8luxCAQ==
X-Received: by 2002:aa7:dd01:: with SMTP id i1mr4083581edv.84.1602081800686;
        Wed, 07 Oct 2020 07:43:20 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id w4sm1629570edr.72.2020.10.07.07.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 07:43:20 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH] KVM/nVMX: Move nested_vmx_check_vmentry_hw inline assembly to vmenter.S
Date:   Wed,  7 Oct 2020 16:43:12 +0200
Message-Id: <20201007144312.55203-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the big inline assembly block from nested_vmx_check_vmentry_hw
to vmenter.S assembly file, taking into account all ABI requirements.

The new function is modelled after __vmx_vcpu_run, and also calls
vmx_update_host_rsp instead of open-coding the function in assembly.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
 arch/x86/kvm/vmx/nested.c  | 32 +++-----------------------------
 arch/x86/kvm/vmx/vmenter.S | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1bb6b31eb646..7b26e983e31c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3012,6 +3012,8 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+bool __nested_vmx_check_vmentry_hw(struct vcpu_vmx *vmx, bool launched);
+
 static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -3050,35 +3052,7 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
 		vmx->loaded_vmcs->host_state.cr4 = cr4;
 	}
 
-	asm(
-		"sub $%c[wordsize], %%" _ASM_SP "\n\t" /* temporarily adjust RSP for CALL */
-		"cmp %%" _ASM_SP ", %c[host_state_rsp](%[loaded_vmcs]) \n\t"
-		"je 1f \n\t"
-		__ex("vmwrite %%" _ASM_SP ", %[HOST_RSP]") "\n\t"
-		"mov %%" _ASM_SP ", %c[host_state_rsp](%[loaded_vmcs]) \n\t"
-		"1: \n\t"
-		"add $%c[wordsize], %%" _ASM_SP "\n\t" /* un-adjust RSP */
-
-		/* Check if vmlaunch or vmresume is needed */
-		"cmpb $0, %c[launched](%[loaded_vmcs])\n\t"
-
-		/*
-		 * VMLAUNCH and VMRESUME clear RFLAGS.{CF,ZF} on VM-Exit, set
-		 * RFLAGS.CF on VM-Fail Invalid and set RFLAGS.ZF on VM-Fail
-		 * Valid.  vmx_vmenter() directly "returns" RFLAGS, and so the
-		 * results of VM-Enter is captured via CC_{SET,OUT} to vm_fail.
-		 */
-		"call vmx_vmenter\n\t"
-
-		CC_SET(be)
-	      : ASM_CALL_CONSTRAINT, CC_OUT(be) (vm_fail)
-	      :	[HOST_RSP]"r"((unsigned long)HOST_RSP),
-		[loaded_vmcs]"r"(vmx->loaded_vmcs),
-		[launched]"i"(offsetof(struct loaded_vmcs, launched)),
-		[host_state_rsp]"i"(offsetof(struct loaded_vmcs, host_state.rsp)),
-		[wordsize]"i"(sizeof(ulong))
-	      : "memory"
-	);
+	vm_fail = __nested_vmx_check_vmentry_hw(vmx, vmx->loaded_vmcs->launched);
 
 	if (vmx->msr_autoload.host.nr)
 		vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 799db084a336..9fdcbd9320dc 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -234,6 +234,42 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	jmp 1b
 SYM_FUNC_END(__vmx_vcpu_run)
 
+/**
+ * __nested_vmx_check_vmentry_hw - Run a vCPU via a transition to
+ *				   a nested VMX guest mode
+ * @vmx:	struct vcpu_vmx * (forwarded to vmx_update_host_rsp)
+ * @launched:	%true if the VMCS has been launched
+ *
+ * Returns:
+ *	0 on VM-Exit, 1 on VM-Fail
+ */
+SYM_FUNC_START(__nested_vmx_check_vmentry_hw)
+	push %_ASM_BP
+	mov  %_ASM_SP, %_ASM_BP
+
+	push %_ASM_BX
+
+	/* Copy @launched to BL, _ASM_ARG2 is volatile. */
+	mov %_ASM_ARG2B, %bl
+
+	/* Adjust RSP to account for the CALL to vmx_vmenter(). */
+	lea -WORD_SIZE(%_ASM_SP), %_ASM_ARG2
+	call vmx_update_host_rsp
+
+	/* Check if vmlaunch or vmresume is needed */
+	cmpb $0, %bl
+
+	/* Enter guest mode */
+	call vmx_vmenter
+
+	/* Return 0 on VM-Exit, 1 on VM-Fail */
+	setbe %al
+
+	pop %_ASM_BX
+
+	pop %_ASM_BP
+	ret
+SYM_FUNC_END(__nested_vmx_check_vmentry_hw)
 
 .section .text, "ax"
 
-- 
2.26.2

