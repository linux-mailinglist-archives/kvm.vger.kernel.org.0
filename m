Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E805EEA11
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 01:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbiI1XU1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 19:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiI1XUV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 19:20:21 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3EA927FD5
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 16:20:19 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id mi9-20020a17090b4b4900b00202b50464b6so2404331pjb.9
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 16:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date;
        bh=1BcvkZblEoh81UGBvcbacOXFb2nRKlIjpIAm5OdbSA8=;
        b=Xk8jpCAp7kAIuzwk7BIrTBWEa1j4mAf0fiyNchS/feUtRG57b/rQVM9QarpWa9NP0B
         XFEhW7pOb7H/nYHmczRTjoELvh3S/cY6sekhURDN2N5y69ljts5bXEwWS9ULvqEATSXx
         8/HurJTtyAboLQfzBk2/w8I9te4jVhTMgRXZq2puvhkRRpnavVrCl5xyMbAzvrW3fOzj
         LKoGpCXWnSLxkZF66UBHebmttqXXVYEvE60N4MB5YCjgXyV2uNepsSMh2Or/bbXt1xR1
         myqQwp8jG9tSx90nJl6syWtYPxTwX6HacZ3T4bJkv/8phDkqkX0o+T38xD5xF3Xuhd9Z
         g3EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date;
        bh=1BcvkZblEoh81UGBvcbacOXFb2nRKlIjpIAm5OdbSA8=;
        b=1ry59laA4lXqH3bBwxmv/NfwKgaNJw3q0T8iaty2ncUFlyRvp1xgrOEwmOj66VW7uz
         IJv+Cq7c86+j5GpffHW+XLObZXl2IkXMm6r8sGxLb4QVU7Fz+QM/G0i21ioMw51ANa8i
         qAZIKafPw0HeWUFD9HGVCcUfa97I0HYUxekKWumGrExjahQjqScYhaOyokaJUUfMEYRR
         ouiu/XRgBjy83KMoIwU2KtHj63vFVJGuxsYRcQDH4+2N1Ak44dP1iSOSS5lHX7GcrJOB
         3gBc0danBckWC/ZEV5V2o7G2xlxLVREMz1Tc0DFG/EWkCNuwbPqwxSOTXAo++004fynn
         Z8mQ==
X-Gm-Message-State: ACrzQf229b7nqo6O7pNtwCs7m30cDT34W2qavMeJFcxVmrT+Bd5NGNak
        esRNMGbU0UurURYII+ZW27eK/GjVQWY=
X-Google-Smtp-Source: AMsMyM7wvxCBb8zWCK0CcdiW+UMbMYc8u643F2ltwA5W/bmQ3Mq+yYFDMGhidW94hvR/6yHGKZK1ZccUaJY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:8704:0:b0:542:5288:5e32 with SMTP id
 b4-20020aa78704000000b0054252885e32mr153082pfo.84.1664407219578; Wed, 28 Sep
 2022 16:20:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 28 Sep 2022 23:20:15 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
Message-ID: <20220928232015.745948-1-seanjc@google.com>
Subject: [PATCH] KVM: VMX: Make vmread_error_trampoline() uncallable from C code
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Uros Bizjak <ubizjak@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Declare vmread_error_trampoline() as an opaque symbol so that it cannot
be called from C code, at least not without some serious fudging.  The
trampoline always passes parameters on the stack so that the inline
VMREAD sequence doesn't need to clobber registers.  regparm(0) was
originally added to document the stack behavior, but it ended up being
confusing because regparm(0) is a nop for 64-bit targets.

Opportunustically wrap the trampoline and its declaration in #ifdeffery
to make it even harder to invoke incorrectly, to document why it exists,
and so that it's not left behind if/when CONFIG_CC_HAS_ASM_GOTO_OUTPUT
is true for all supported toolchains.

No functional change intended.

Cc: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmenter.S |  2 ++
 arch/x86/kvm/vmx/vmx_ops.h | 18 ++++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 8477d8bdd69c..24c54577ac84 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -269,6 +269,7 @@ SYM_FUNC_END(__vmx_vcpu_run)
 
 .section .text, "ax"
 
+#ifndef CONFIG_CC_HAS_ASM_GOTO_OUTPUT
 /**
  * vmread_error_trampoline - Trampoline from inline asm to vmread_error()
  * @field:	VMCS field encoding that failed
@@ -317,6 +318,7 @@ SYM_FUNC_START(vmread_error_trampoline)
 
 	RET
 SYM_FUNC_END(vmread_error_trampoline)
+#endif
 
 SYM_FUNC_START(vmx_do_interrupt_nmi_irqoff)
 	/*
diff --git a/arch/x86/kvm/vmx/vmx_ops.h b/arch/x86/kvm/vmx/vmx_ops.h
index ec268df83ed6..80ad6b0a5599 100644
--- a/arch/x86/kvm/vmx/vmx_ops.h
+++ b/arch/x86/kvm/vmx/vmx_ops.h
@@ -11,14 +11,28 @@
 #include "../x86.h"
 
 void vmread_error(unsigned long field, bool fault);
-__attribute__((regparm(0))) void vmread_error_trampoline(unsigned long field,
-							 bool fault);
 void vmwrite_error(unsigned long field, unsigned long value);
 void vmclear_error(struct vmcs *vmcs, u64 phys_addr);
 void vmptrld_error(struct vmcs *vmcs, u64 phys_addr);
 void invvpid_error(unsigned long ext, u16 vpid, gva_t gva);
 void invept_error(unsigned long ext, u64 eptp, gpa_t gpa);
 
+#ifndef CONFIG_CC_HAS_ASM_GOTO_OUTPUT
+/*
+ * The VMREAD error trampoline _always_ uses the stack to pass parameters, even
+ * for 64-bit targets.  Preserving all registers allows the VMREAD inline asm
+ * blob to avoid clobbering GPRs, which in turn allows the compiler to better
+ * optimize sequences of VMREADs.
+ *
+ * Declare the trampoline as an opaque label as it's not safe to call from C
+ * code; there is no way to tell the compiler to pass params on the stack for
+ * 64-bit targets.
+ *
+ * void vmread_error_trampoline(unsigned long field, bool fault);
+ */
+extern unsigned long vmread_error_trampoline;
+#endif
+
 static __always_inline void vmcs_check16(unsigned long field)
 {
 	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && ((field) & 0x6001) == 0x2000,

base-commit: c59fb127583869350256656b7ed848c398bef879
-- 
2.37.3.998.g577e59143f-goog

