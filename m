Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B095A2DE297
	for <lists+kvm@lfdr.de>; Fri, 18 Dec 2020 13:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbgLRMMz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Dec 2020 07:12:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727416AbgLRMMx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Dec 2020 07:12:53 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA6BC0611CE;
        Fri, 18 Dec 2020 04:11:53 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id y24so1435658edt.10;
        Fri, 18 Dec 2020 04:11:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fpfHgLjNqUef0wN0lc7+nNzCiw4Mf77uS73mqGKZnIM=;
        b=mCkVQjDpB6nuKIaWx8YJljXcOY94LkJ5nKGV8N08bV1bxTNGuPBSeyEA7vA83YccO5
         8SHhceT0oQJtyM4+hihCu6p3LQabHOp05TLVcAjJvxFU5XGY7cWaXEgkDmAksyy2I0+g
         GQXz2py0/u5nox0lGpJiIPgfXnZNrOHaaFMIu+Fb18rcfUbMCFCYs8sIxgvEnRmLL5tZ
         /50BZ79EQpqx+fpGZoWK7mxElPkr6BA3JPXIhjAFvx9USGSVqIWmJGe1pWcvoLugr6qe
         9dcUQ1QlESgvPSqMg4H3BkdqE0G8lsuKMYBV+ZH6ljEQjdTq9JqSj+kiFq84xv6DrS91
         e0sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fpfHgLjNqUef0wN0lc7+nNzCiw4Mf77uS73mqGKZnIM=;
        b=BhjkzMydxt6vMnpRp51S0KLDw3so1MqdEMVkt65ufS7mi1Ftt6AELy56BlUfrp0eIx
         otd+sjMf3fxB/eFB6//h2MI8Ynk8lgjxDPUiUGrMoh6YOIMrNL0IwAb8GClbjAesLUYT
         CE/SUftwQwEPxH6iL0lhBIQs7blSQYoZfJHWD6/bRVFgLAlnWwLfQAUq+8sISFJ3VGjx
         eS0d8Q53PV3LZoN/SQNa7JtQakL2N/cCzJCcYHGJoOvzavZpub7ZntWas63kLu15nySe
         0Ktlp8FSXXvcx1vVjNs3G79Mo2knGRF6m5BbL2rUQ+Exfp392u0RmxZEl/hX8JtLTuz+
         VsWA==
X-Gm-Message-State: AOAM531vm/luIYPS9r1cc61dgIFur75Slz0Itn+Ll2/iQrkpcxC7CNLn
        UVQKA2zNDDhWTruwqMRPj7FwOZiC6PFntw==
X-Google-Smtp-Source: ABdhPJzfkGsxDIrFIIAEvsjC2QCxFCNKemW4SsggW8Fc3JEQLPdbEflH3gID8c3dDMLijzQHBOqdjw==
X-Received: by 2002:aa7:ca03:: with SMTP id y3mr4106732eds.87.1608293512052;
        Fri, 18 Dec 2020 04:11:52 -0800 (PST)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id i13sm15852716edu.22.2020.12.18.04.11.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 04:11:51 -0800 (PST)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH] KVM/x86: Move definition of __ex to x86.h
Date:   Fri, 18 Dec 2020 13:11:46 +0100
Message-Id: <20201218121146.432286-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Merge __kvm_handle_fault_on_reboot with its sole user
and move the definition of __ex to a common include to be
shared between VMX and SVM.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
 arch/x86/include/asm/kvm_host.h | 25 -------------------------
 arch/x86/kvm/svm/svm.c          |  2 --
 arch/x86/kvm/vmx/vmx_ops.h      |  4 +---
 arch/x86/kvm/x86.h              | 23 +++++++++++++++++++++++
 4 files changed, 24 insertions(+), 30 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7e5f33a0d0e2..ff152ee1d63f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1623,31 +1623,6 @@ enum {
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
-
 #define KVM_ARCH_WANT_MMU_NOTIFIER
 int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
 			unsigned flags);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index da7eb4aaf44f..0a72ab9fd568 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -42,8 +42,6 @@
 
 #include "svm.h"
 
-#define __ex(x) __kvm_handle_fault_on_reboot(x)
-
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
 
diff --git a/arch/x86/kvm/vmx/vmx_ops.h b/arch/x86/kvm/vmx/vmx_ops.h
index 692b0c31c9c8..7e3cb53c413f 100644
--- a/arch/x86/kvm/vmx/vmx_ops.h
+++ b/arch/x86/kvm/vmx/vmx_ops.h
@@ -4,13 +4,11 @@
 
 #include <linux/nospec.h>
 
-#include <asm/kvm_host.h>
 #include <asm/vmx.h>
 
 #include "evmcs.h"
 #include "vmcs.h"
-
-#define __ex(x) __kvm_handle_fault_on_reboot(x)
+#include "x86.h"
 
 asmlinkage void vmread_error(unsigned long field, bool fault);
 __attribute__((regparm(0))) void vmread_error_trampoline(unsigned long field,
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index e7ca622a468f..608548d05e84 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -7,6 +7,29 @@
 #include "kvm_cache_regs.h"
 #include "kvm_emulate.h"
 
+asmlinkage void kvm_spurious_fault(void);
+
+/*
+ * Hardware virtualization extension instructions may fault if a
+ * reboot turns off virtualization while processes are running.
+ * Usually after catching the fault we just panic; during reboot
+ * instead the instruction is ignored.
+ */
+#define __ex(insn)							\
+	"666:	" insn "\n"						\
+	"	jmp 669f\n"						\
+	"667:\n"							\
+	".pushsection .discard.instr_begin\n"				\
+	".long 667b - .\n"						\
+	".popsection\n"							\
+	"	call kvm_spurious_fault\n"				\
+	"668:\n"							\
+	".pushsection .discard.instr_end\n"				\
+	".long 668b - .\n"						\
+	".popsection\n"							\
+	"669:\n"							\
+	_ASM_EXTABLE(666b, 667b)
+
 #define KVM_DEFAULT_PLE_GAP		128
 #define KVM_VMX_DEFAULT_PLE_WINDOW	4096
 #define KVM_DEFAULT_PLE_WINDOW_GROW	2
-- 
2.26.2

