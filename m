Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF1243E4B00
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 19:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234517AbhHIRka (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 13:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234478AbhHIRk3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 13:40:29 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85510C061796
        for <kvm@vger.kernel.org>; Mon,  9 Aug 2021 10:40:08 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id f8-20020a2585480000b02905937897e3daso4865375ybn.2
        for <kvm@vger.kernel.org>; Mon, 09 Aug 2021 10:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=WgM1rHWTEQ88VWq1QXAKlkRg7Ku/fTNmk2s9vPOGTSU=;
        b=nmLv+8+BJaylwlAX+r1hu86nxvV72YQpQyFWShicKDV8mgVF7wMyNrI26ld/StVhGU
         8kK3BP88rqhT3m67QXqNByr/QcHULz9zrcxhWV/R+IZ0ywieJU0haPc7mHdtuiyC/K2U
         f7aU1cPRYHNoSd02Fc+VYQCGykwGw1ZDuwvRj2rxga40C/bcdY5DTVpR6aW1ceI4u1jH
         fFkTwpxeHZcq9E9bVeJ1VmtdPtfjRVx1JYU/wUlfhfnZegLve8KEUMpehV31qP3jfClm
         YTyWg23U+5JcGzTUckhzbnNbwUyAtqgqhEX/ZtX9PupbqFjYcJweMjvN7YECT+HQ0yf7
         SAmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=WgM1rHWTEQ88VWq1QXAKlkRg7Ku/fTNmk2s9vPOGTSU=;
        b=emmlKZxE0mTdC0pV05Vh7ITvRSSTTN+ilC7rPPkAU93AvRms7SrtmA8utegqoZgDRR
         4U3+obF2PQDpiyehPVDxab2T+XZheZbFQpEahKGfQT77pSOrEoPhr2O/oACiMbXr7i70
         Tx8PjreNVGsJ/ZxiKsfaQ4JzBjh7RE5Ws5AsB7At8+kKo9gyKsv8UhPXdwIXUXIJr98q
         T6t9tDKlm8JYqZsUGA1IPEbkAs+9xzmPaKxKyMjBGd5QPEqtwefF1xv6wBHbB2nBL9xG
         S7IQWr0abAqLvcwpmzjLKa/iziMtxBVBVOdXFI6gP/YggDRiDdqAT1IH6VbHeqH0BTwi
         oL/g==
X-Gm-Message-State: AOAM530UBROE7EzsP3qH2kYYmbIDZ1mT7uWf2/0JD+H09++RIPbmnGme
        cQTX5io6FvO2OU2jq1rda3u13aqqHDQ=
X-Google-Smtp-Source: ABdhPJzPn+kMbRgFIOABgArxR49CGtmW3TRfLaX/eRrVBiwwOiqIisWTL9efoB+7dmtN/FFgs8vG2ennD+U=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:b967:644e:62eb:1752])
 (user=seanjc job=sendgmr) by 2002:a25:6406:: with SMTP id y6mr30323336ybb.110.1628530807686;
 Mon, 09 Aug 2021 10:40:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon,  9 Aug 2021 10:39:54 -0700
In-Reply-To: <20210809173955.1710866-1-seanjc@google.com>
Message-Id: <20210809173955.1710866-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210809173955.1710866-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v2 1/2] KVM: x86: Kill off __ex() and __kvm_handle_fault_on_reboot()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Uros Bizjak <ubizjak@gmail.com>,
        Like Xu <like.xu.linux@gmail.com>
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
Cc: Like Xu <like.xu.linux@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 25 +------------------------
 arch/x86/kvm/svm/sev.c          |  2 --
 arch/x86/kvm/svm/svm.c          |  2 --
 arch/x86/kvm/vmx/vmx_ops.h      |  2 --
 arch/x86/kvm/x86.c              |  9 ++++++++-
 5 files changed, 9 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4c567b05edad..56540b5befd0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1798,30 +1798,7 @@ enum {
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
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 9f1585f40c85..19cdb73aa623 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -28,8 +28,6 @@
 #include "cpuid.h"
 #include "trace.h"
 
-#define __ex(x) __kvm_handle_fault_on_reboot(x)
-
 #ifndef CONFIG_KVM_AMD_SEV
 /*
  * When this config is not defined, SEV feature is not supported and APIs in
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9d72b1df426e..2b6632d4c76f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -46,8 +46,6 @@
 #include "kvm_onhyperv.h"
 #include "svm_onhyperv.h"
 
-#define __ex(x) __kvm_handle_fault_on_reboot(x)
-
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
diff --git a/arch/x86/kvm/vmx/vmx_ops.h b/arch/x86/kvm/vmx/vmx_ops.h
index 164b64f65a8f..c0d74b994b56 100644
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
index df71f5e3e23b..156564c34624 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -486,7 +486,14 @@ int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
2.32.0.605.g8dce9f2422-goog

