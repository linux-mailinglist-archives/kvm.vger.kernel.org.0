Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46EE440F98E
	for <lists+kvm@lfdr.de>; Fri, 17 Sep 2021 15:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240970AbhIQNxb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 09:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbhIQNxb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Sep 2021 09:53:31 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67D7C061574;
        Fri, 17 Sep 2021 06:52:08 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id g21so30386362edw.4;
        Fri, 17 Sep 2021 06:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v1rZTCjKNkaAkGoNurrwA7Id4hvtXdsRm/dxQ92FX6Y=;
        b=ReXFzh4Cwh1eq+CM8cb6vh2xI9EnodXB08FzGaf/SWIfleBnF9JKIYRYyX7+GwfFno
         hcxqyMIAf7vJV9wFosIareu+gMUzgEOLBufGz/PNpatu1hyNqPA56A75O7LsmtfxFybC
         ZCK+1SC4wVdkCUizMaMqZGTC25e5eIAX+NLyulybT8VDCaQNk8O1Zpu3XCJJsq9Fbqv+
         fr7DPv06rnoYN876b2IqnrTW+c2p/bj8dqmugMeH0R6qkHgV1OusGsiRa4z6p4vzHQK6
         vvOaXd5AMF9hiGgrOuF0ts8y1lfdE4aalWFW3ZMrgo7VtuYwj/w3Y23pDc2Inu7BtMDe
         G38g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v1rZTCjKNkaAkGoNurrwA7Id4hvtXdsRm/dxQ92FX6Y=;
        b=g+PnjlUC2Xpi5IQSjJjy5cW3lVPFyM6hJN4tSIE5DlPxF5lmG6cBSxjkQnrh751G+z
         ski9EWJ7N4JYjeiPjIJOstci86PGx4g2AlLgcHEE2cE9K2l17MSovpHdvOd0RJHRBlt6
         xF6kndj2/8A7nnpxjBE3Nr7/HEzh4dqTMmPm3IKTTPyLJG8Vs9ngrndVX9VfuW0Q1cYt
         FtWaMcht3eSCbCGQjAvXClsjGDK9GtCQfZfTW5bYBOoi3NCFLH3XpUn1L8FgXuGQ6T3G
         R97D9j+SbR/T+tIdPgtMmKUU1CkR+Ng6mMPPuXktw2aBoG0q/6sMNH0exP/6UCqbtBVh
         Qpdw==
X-Gm-Message-State: AOAM5328Xcui4bggTAXagkUpsvOTDUEjcZGEL0RxkETwf4DZlj20ltQD
        Rmv11oa6ZTnVqQP9/06Upfi5ZU78igTOug==
X-Google-Smtp-Source: ABdhPJx9+01uaaV1B7YKwL5gKrKy1F+Ph966cpPF37yQcaYoMnWJA+OYTsYh7JPosq2HjY4t/4e1JA==
X-Received: by 2002:a17:906:2a0a:: with SMTP id j10mr12166713eje.103.1631886727062;
        Fri, 17 Sep 2021 06:52:07 -0700 (PDT)
Received: from localhost.localdomain (93-103-178-73.dynamic.t-2.net. [93.103.178.73])
        by smtp.gmail.com with ESMTPSA id e7sm2903282edk.3.2021.09.17.06.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 06:52:06 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH] KVM: x86: Improve exception safe wrappers in emulate.c
Date:   Fri, 17 Sep 2021 15:51:52 +0200
Message-Id: <20210917135152.5111-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Improve exception safe wrappers in emulate.c by converting them to
ASM GOTO (and ASM GOTO OUTPUT when supported) statements.  Also, convert
wrappers to inline functions to avoid statement as expression
GNU extension and to remove weird requirement where user must know
where the asm argument is being expanded.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson  <seanjc@google.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
 arch/x86/kvm/emulate.c | 80 ++++++++++++++++++++++++++++++------------
 1 file changed, 57 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 2837110e66ed..2197a3ecc55b 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -464,25 +464,59 @@ FOP_FUNC(salc)
 FOP_RET(salc)
 FOP_END;
 
-/*
- * XXX: inoutclob user must know where the argument is being expanded.
- *      Relying on CONFIG_CC_HAS_ASM_GOTO would allow us to remove _fault.
- */
-#define asm_safe(insn, inoutclob...) \
-({ \
-	int _fault = 0; \
- \
-	asm volatile("1:" insn "\n" \
-	             "2:\n" \
-	             ".pushsection .fixup, \"ax\"\n" \
-	             "3: movl $1, %[_fault]\n" \
-	             "   jmp  2b\n" \
-	             ".popsection\n" \
-	             _ASM_EXTABLE(1b, 3b) \
-	             : [_fault] "+qm"(_fault) inoutclob ); \
- \
-	_fault ? X86EMUL_UNHANDLEABLE : X86EMUL_CONTINUE; \
-})
+static __always_inline int safe_fwait(void)
+{
+	asm_volatile_goto("1: fwait\n\t"
+			  _ASM_EXTABLE(1b, %l[fault])
+			  : : : : fault);
+	return X86EMUL_CONTINUE;
+ fault:
+	return X86EMUL_UNHANDLEABLE;
+}
+
+static __always_inline int safe_fxrstor(struct fxregs_state *fx_state)
+{
+	asm_volatile_goto("1: fxrstor %0\n\t"
+			  _ASM_EXTABLE(1b, %l[fault])
+			  : : "m" (*fx_state) : : fault);
+	return X86EMUL_CONTINUE;
+ fault:
+	return X86EMUL_UNHANDLEABLE;
+}
+
+#ifdef CONFIG_CC_HAS_ASM_GOTO_OUTPUT
+
+static __always_inline int safe_fxsave(struct fxregs_state *fx_state)
+{
+	asm_volatile_goto("1: fxsave %0\n\t"
+			  _ASM_EXTABLE(1b, %l[fault])
+			  : "=m" (*fx_state) : : : fault);
+	return X86EMUL_CONTINUE;
+ fault:
+	return X86EMUL_UNHANDLEABLE;
+}
+
+#else // !CONFIG_CC_HAS_ASM_GOTO_OUTPUT
+
+static __always_inline int safe_fxsave(struct fxregs_state *fx_state)
+{
+	int rc;
+
+	asm volatile("1: fxsave %0\n\t"
+		     "movl %2, %1\n\t"
+		     "2:\n\t"
+	             ".pushsection .fixup, \"ax\"\n\t"
+	             "3: movl %3, %1\n\t"
+	             "jmp 2b\n\t"
+	             ".popsection\n\t"
+	             _ASM_EXTABLE(1b, 3b)
+	             : "=m" (*fx_state), "=rm" (rc)
+		     : "i" (X86EMUL_CONTINUE),
+		       "i" (X86EMUL_UNHANDLEABLE));
+	return rc;
+}
+
+#endif // CONFIG_CC_ASM_GOTO_OUTPUT
 
 static int emulator_check_intercept(struct x86_emulate_ctxt *ctxt,
 				    enum x86_intercept intercept,
@@ -4030,7 +4064,7 @@ static int em_fxsave(struct x86_emulate_ctxt *ctxt)
 
 	kvm_fpu_get();
 
-	rc = asm_safe("fxsave %[fx]", , [fx] "+m"(fx_state));
+	rc = safe_fxsave (&fx_state);
 
 	kvm_fpu_put();
 
@@ -4054,7 +4088,7 @@ static noinline int fxregs_fixup(struct fxregs_state *fx_state,
 	struct fxregs_state fx_tmp;
 	int rc;
 
-	rc = asm_safe("fxsave %[fx]", , [fx] "+m"(fx_tmp));
+	rc = safe_fxsave (&fx_tmp);
 	memcpy((void *)fx_state + used_size, (void *)&fx_tmp + used_size,
 	       __fxstate_size(16) - used_size);
 
@@ -4090,7 +4124,7 @@ static int em_fxrstor(struct x86_emulate_ctxt *ctxt)
 	}
 
 	if (rc == X86EMUL_CONTINUE)
-		rc = asm_safe("fxrstor %[fx]", : [fx] "m"(fx_state));
+		rc = safe_fxrstor (&fx_state);
 
 out:
 	kvm_fpu_put();
@@ -5342,7 +5376,7 @@ static int flush_pending_x87_faults(struct x86_emulate_ctxt *ctxt)
 	int rc;
 
 	kvm_fpu_get();
-	rc = asm_safe("fwait");
+	rc = safe_fwait();
 	kvm_fpu_put();
 
 	if (unlikely(rc != X86EMUL_CONTINUE))
-- 
2.31.1

