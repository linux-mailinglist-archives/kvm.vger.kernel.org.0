Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9452E7D71
	for <lists+kvm@lfdr.de>; Thu, 31 Dec 2020 01:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgLaA3B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Dec 2020 19:29:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbgLaA3A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Dec 2020 19:29:00 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29B0C0617AB
        for <kvm@vger.kernel.org>; Wed, 30 Dec 2020 16:27:44 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id l8so31412352ybj.16
        for <kvm@vger.kernel.org>; Wed, 30 Dec 2020 16:27:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=uVgCl7Nu2FXUG56acnNl/pxMnIlKTrWSEFVB9EZQEgA=;
        b=BJ2saRRgGYmNkHST+OHJwIlTUSitobyo5wgejFmXy5xfCg6xSaYArcCOTEYxCCu95U
         YWKCmMqsisWCZS3hxI3HnDbCy5Ros0QQDgNSw2jXRIKVUgK5qYsoWCnd1/Zr9Am3Jpf3
         1LXOXXhpQe68JSKwm1hGr16/CuH+MjxjWS1CSjne44ZFILzQNMDIhoOsoWom4ED8qC8X
         A81GKMwT+ClV9tL5J53kIlHdgcVtG3bIHgfuDn6RUFSH5461/5f9jAaZtl1yqg1j41yL
         avtBwbEgi96C0KQvIYLPq2IA7Gnvu5Qc9GpiOacbuWk/DMyJ0xiNJ4GMtEBBpV5IJi+J
         PD+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=uVgCl7Nu2FXUG56acnNl/pxMnIlKTrWSEFVB9EZQEgA=;
        b=ARB1hxnALMIJTWY6CZb5et3S98YPo7KZ5kmiSAG2yESZySSgPlM9xrE/u2iOp6QcYo
         M2t7cCVAYK6q8eiGrUbm+OnxUe0rcOHewaHpiNQOIrI9D8nR6Ucj2+MwyFmZFcw2mtwx
         do0DDQ00G1Q1Hs4HAaO0g0XFsnoP/3t5gpXzy/U54oeaAll0Xb5DWaBWbBdSgabKjsFu
         h5udtAga+fi9rN5L4NHaj6qCSjg9SAxWQD/xfQ5OIkZ1klik/wLBCudGSxhfoIJZA2s/
         frmIYwiyTnZGs4SDE2QUHEMsmVzdyaeuXfWWUSDW5lV+GrR+ffysr0e3//ATzwKUBX0o
         X/sQ==
X-Gm-Message-State: AOAM532TPvW0N81enDDcJxilC8tTTuWKeCl16/8mI8VhDi4bELIcHWwp
        HFHYnSq6wVln3aH2rL65+8Xj0GgY2Oc=
X-Google-Smtp-Source: ABdhPJxRcor84DKLBK+eKyb4sF+wbye6f6qXwCr9kBSPQnUHfIL18nDVMp+WW7CEI0G/PeDoxrWqFnvHCnw=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a25:6b46:: with SMTP id o6mr79807409ybm.409.1609374464238;
 Wed, 30 Dec 2020 16:27:44 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 30 Dec 2020 16:27:01 -0800
In-Reply-To: <20201231002702.2223707-1-seanjc@google.com>
Message-Id: <20201231002702.2223707-9-seanjc@google.com>
Mime-Version: 1.0
References: <20201231002702.2223707-1-seanjc@google.com>
X-Mailer: git-send-email 2.29.2.729.g45daf8777d-goog
Subject: [PATCH 8/9] KVM: x86: Kill off __ex() and __kvm_handle_fault_on_reboot()
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

Remove the __kvm_handle_fault_on_reboot() and __ex() macros now that all
VMX and SVM instructions use asm goto to handle the fault (or in the
case of VMREAD, completely custom logic).  Drop kvm_spurious_fault()'s
asmlinkage annotation as __kvm_handle_fault_on_reboot() was the only
flow that invoked it from assembly code.

Cc: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 25 +------------------------
 arch/x86/kvm/svm/sev.c          |  2 --
 arch/x86/kvm/svm/svm.c          |  2 --
 arch/x86/kvm/vmx/vmx_ops.h      |  2 --
 arch/x86/kvm/x86.c              |  9 ++++++++-
 5 files changed, 9 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3ab7b46087b7..51ba20ffaedb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1634,30 +1634,7 @@ enum {
 #define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_MASK ? 1 : 0)
 #define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role).smm)
 
-asmlinkage void kvm_spurious_fault(void);
-
-/*
- * Hardware virtualization extension instructions may fault if a
- * reboot turns off virtualization while processes are running.
- * Usually after catching the fault we just panic; during reboot
- * instead the instruction is ignored.
- */
-#define __kvm_handle_fault_on_reboot(insn)				\
-	"666: \n\t"							\
-	insn "\n\t"							\
-	"jmp	668f \n\t"						\
-	"667: \n\t"							\
-	"1: \n\t"							\
-	".pushsection .discard.instr_begin \n\t"			\
-	".long 1b - . \n\t"						\
-	".popsection \n\t"						\
-	"call	kvm_spurious_fault \n\t"				\
-	"1: \n\t"							\
-	".pushsection .discard.instr_end \n\t"				\
-	".long 1b - . \n\t"						\
-	".popsection \n\t"						\
-	"668: \n\t"							\
-	_ASM_EXTABLE(666b, 667b)
+void kvm_spurious_fault(void);
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
 int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 4511d7ccdb19..e7080e5056a4 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -26,8 +26,6 @@
 #include "cpuid.h"
 #include "trace.h"
 
-#define __ex(x) __kvm_handle_fault_on_reboot(x)
-
 static u8 sev_enc_bit;
 static int sev_flush_asids(void);
 static DECLARE_RWSEM(sev_deactivate_lock);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4308ab5ca27e..e4907e490c24 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -43,8 +43,6 @@
 #include "svm.h"
 #include "svm_ops.h"
 
-#define __ex(x) __kvm_handle_fault_on_reboot(x)
-
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
diff --git a/arch/x86/kvm/vmx/vmx_ops.h b/arch/x86/kvm/vmx/vmx_ops.h
index 692b0c31c9c8..7b6fbe103c61 100644
--- a/arch/x86/kvm/vmx/vmx_ops.h
+++ b/arch/x86/kvm/vmx/vmx_ops.h
@@ -10,8 +10,6 @@
 #include "evmcs.h"
 #include "vmcs.h"
 
-#define __ex(x) __kvm_handle_fault_on_reboot(x)
-
 asmlinkage void vmread_error(unsigned long field, bool fault);
 __attribute__((regparm(0))) void vmread_error_trampoline(unsigned long field,
 							 bool fault);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3f7c1fc7a3ce..836912b42030 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -412,7 +412,14 @@ int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 }
 EXPORT_SYMBOL_GPL(kvm_set_apic_base);
 
-asmlinkage __visible noinstr void kvm_spurious_fault(void)
+/*
+ * Handle a fault on a hardware virtualization (VMX or SVM) instruction.
+ *
+ * Hardware virtualization extension instructions may fault if a reboot turns
+ * off virtualization while processes are running.  Usually after catching the
+ * fault we just panic; during reboot instead the instruction is ignored.
+ */
+noinstr void kvm_spurious_fault(void)
 {
 	/* Fault while not rebooting.  We want the trace. */
 	BUG_ON(!kvm_rebooting);
-- 
2.29.2.729.g45daf8777d-goog

