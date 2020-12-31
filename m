Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D816C2E7D69
	for <lists+kvm@lfdr.de>; Thu, 31 Dec 2020 01:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgLaA2q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Dec 2020 19:28:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbgLaA2p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Dec 2020 19:28:45 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B021AC0617A1
        for <kvm@vger.kernel.org>; Wed, 30 Dec 2020 16:27:34 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id e14so10490693qtr.8
        for <kvm@vger.kernel.org>; Wed, 30 Dec 2020 16:27:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Tucg/+W3WHc5RU8v1ZH0tJXOCpyf6aOsIMisUdgCGHs=;
        b=sKF2tCwSjXqqow4Iyi9/IUyLP1Pk16kGLgcb/1bBrlx9SA+kGWO1rn3Lr6uHczoS1/
         ZnTiTkLMgb0IxPEQfNCjvfoMP3rwWVVv/Qa1DWmo2Dj/FOTt+J33lvdltNOtcmTWu6rY
         EoToBy+ib7K7ssV7zDDJa9sCFEb4KtASgymMlQwkzpfRLkyUZ7Yr5ACyfcMJMZBlTtI2
         aTyuFfc5O41mNAJ1818U5Ogj5q7GMo6UFpaWyTCiQbwtJ6wZgIDS9TUirQFLE6HXR75F
         /E0MgCevzBg3bF/KZF4G3wx5KkQZOebW/yoqbEqsoFcdrjdsdazdAzP7e9mX1UM/l45T
         gnpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Tucg/+W3WHc5RU8v1ZH0tJXOCpyf6aOsIMisUdgCGHs=;
        b=Ti8mDJIlSSB3sArNSMLpQsgwzJUtvt0Od/oxpc1uNxgUg6ouyUHDSIGi7BsaGEpPTl
         RPtbLfH9OrxcY2Pec4mfkL+OVg5kRwF9LLaSiwlBSoY3F+bAD8gLdyIRIFZn6egQB5ho
         UOflXzZYjLsYI1N+QQA7GaVKSQ6PD6N2oRBjj/0XLfrV1FrRROnSf3HX7rwkAZMcylGF
         EmWFVzWZWF2am/TD7nQqYIRRbsG2RqtzOYOU0yaAjImxYloHvneH4y3+LoA4d5nabR5w
         G9TwuIdIxo6lu2sQiy16pci05c7REUPiMmxsA4XpDjfImEdSvgPqXpGsr/4cbs6J1FX9
         wjhA==
X-Gm-Message-State: AOAM5339lpN+7w0bjUVkWxgQ1In8Bcnc6uYn6WKLjT06zlnyhAspjsy9
        jGkxecTtahkisMvBswzhFwU/fu0G0Ys=
X-Google-Smtp-Source: ABdhPJyRF6MBNzauYpfMo3rlcvAY1wQ8KAAg+zarlNAgqRQOVqqLCIHOyRWg4T+qI4hXF9KqonLI3d1QuAI=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a05:6214:58d:: with SMTP id
 bx13mr12664650qvb.61.1609374453844; Wed, 30 Dec 2020 16:27:33 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 30 Dec 2020 16:26:57 -0800
In-Reply-To: <20201231002702.2223707-1-seanjc@google.com>
Message-Id: <20201231002702.2223707-5-seanjc@google.com>
Mime-Version: 1.0
References: <20201231002702.2223707-1-seanjc@google.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH 4/9] KVM/nVMX: Use __vmx_vcpu_run in nested_vmx_check_vmentry_hw
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David P . Reed" <dpreed@deepplum.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Uros Bizjak <ubizjak@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Uros Bizjak <ubizjak@gmail.com>

Replace inline assembly in nested_vmx_check_vmentry_hw
with a call to __vmx_vcpu_run.  The function is not
performance critical, so (double) GPR save/restore
in __vmx_vcpu_run can be tolerated, as far as performance
effects are concerned.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Reviewed-and-tested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
[sean: dropped versioning info from changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c  | 32 +++-----------------------------
 arch/x86/kvm/vmx/vmenter.S |  2 +-
 arch/x86/kvm/vmx/vmx.c     |  2 --
 arch/x86/kvm/vmx/vmx.h     |  1 +
 4 files changed, 5 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e2f26564a12d..5bbb4d667370 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -12,6 +12,7 @@
 #include "nested.h"
 #include "pmu.h"
 #include "trace.h"
+#include "vmx.h"
 #include "x86.h"
 
 static bool __read_mostly enable_shadow_vmcs = 1;
@@ -3057,35 +3058,8 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
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
+	vm_fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
+				 vmx->loaded_vmcs->launched);
 
 	if (vmx->msr_autoload.host.nr)
 		vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index e85aa5faa22d..3a6461694fc2 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -44,7 +44,7 @@
  * they VM-Fail, whereas a successful VM-Enter + VM-Exit will jump
  * to vmx_vmexit.
  */
-SYM_FUNC_START(vmx_vmenter)
+SYM_FUNC_START_LOCAL(vmx_vmenter)
 	/* EFLAGS.ZF is set if VMCS.LAUNCHED == 0 */
 	je 2f
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 75c9c6a0a3a4..65b5f02b199f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6577,8 +6577,6 @@ static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 	}
 }
 
-bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
-
 static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 					struct vcpu_vmx *vmx)
 {
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 9d3a557949ac..03fc90569ae1 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -339,6 +339,7 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 struct vmx_uret_msr *vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr);
 void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu);
 void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
+bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
 int vmx_find_loadstore_msr_slot(struct vmx_msrs *m, u32 msr);
 void vmx_ept_load_pdptrs(struct kvm_vcpu *vcpu);
 
-- 
2.29.2.729.g45daf8777d-goog

