Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0B46616D0B
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 19:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbiKBSrV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 14:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbiKBSrN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 14:47:13 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B6D2FFD8
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 11:47:11 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id e13-20020a17090301cd00b001871e6f8714so6713782plh.14
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 11:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KMoIap0sR+1CcUsNo9fMIcDCtwhfe98yh5fTCarrD0c=;
        b=k1yXSjshfABPqBWzkk2re+5NTx0r1/omNxYPIhvfkrWPWOXQ3FDs8tlXd0BS10PfBn
         sIs/Hi3l8f6BNYAm0REVTPHyrmG9K7BzizWj7vjmVWwyUdSpJ3jse/1wzbTuYuz346fA
         odG+5EaTWzlr8ZbCQA34/E/aQoFtQ5fsxGYXp+OUKV4vuVHfIg+MSfLquVktJihbS6m8
         /IXUNoe8XbV7njQf5AOmZzjox2KDVvFzIsaxo/RD728X41FYQpqh3nDVRURNPDLUR34b
         L2qlQhINf0RH3gnunJd8nBJznViQZZh5hXHrNszL5J2v2bsPCQ2iuOkTKKS8+aHndIcP
         BAbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KMoIap0sR+1CcUsNo9fMIcDCtwhfe98yh5fTCarrD0c=;
        b=yx45q6V6PGLh1v1wLGp9XGNwjAeTEq6O0fadpfUgfpRdQd7zzi59nyn2siO0IL7U5H
         VdfN7mRqJWvCW09Ak+0eyHT5vpqLkc7bpmStDdXscpjpGYr4LtW7K4fl+8IZR4W1DZNe
         RVrjJhgbV9xQ8UKvyX5w2P3yqO+lFrIVCpAz943cViIBWhGAqPC6L5xIUt6UhI9PIQzr
         Pmjh+7s+mWcLiKxJlDbekK7PaWfAum7YEYWAdXQJw0fFS0m3QEHFEsNWzpceDoLwj658
         MEw9Yv/eYnyh5WV8t854oUH3xownU5YKhCqNhThnQ7sdowiDJ4JIZ1AxSZ0TgWDdsvN6
         h1sg==
X-Gm-Message-State: ACrzQf1E7fJD5WTsfA4JBvWn9PaugngWM5+eV4elKC5VyvHRBLKqQlac
        Gcd3CbVafoyFLVCaB3HluuRVlwtDZ4/6vA==
X-Google-Smtp-Source: AMsMyM48FymbReh5snaAz2jmylT9nC4FzX0GZg+//beH/EXpya9DpGzRz3RTzXCaxExeLJ4ck1uJogvMSA7pJA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:f291:b0:20a:eab5:cf39 with SMTP
 id fs17-20020a17090af29100b0020aeab5cf39mr79473pjb.1.1667414830700; Wed, 02
 Nov 2022 11:47:10 -0700 (PDT)
Date:   Wed,  2 Nov 2022 11:46:52 -0700
In-Reply-To: <20221102184654.282799-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221102184654.282799-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221102184654.282799-9-dmatlack@google.com>
Subject: [PATCH v4 08/10] KVM: selftests: Provide error code as a
 KVM_ASM_SAFE() output
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Colton Lewis <coltonlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vipin Sharma <vipinsh@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
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

From: Sean Christopherson <seanjc@google.com>

Provide the error code on a fault in KVM_ASM_SAFE(), e.g. to allow tests
to assert that #PF generates the correct error code without needing to
manually install a #PF handler.  Use r10 as the scratch register for the
error code, as it's already clobbered by the asm blob (loaded with the
RIP of the to-be-executed instruction).  Deliberately load the output
"error_code" even in the non-faulting path so that error_code is always
initialized with deterministic data (the aforementioned RIP), i.e to
ensure a selftest won't end up with uninitialized consumption regardless
of how KVM_ASM_SAFE() is used.

Don't clear r10 in the non-faulting case and instead load error code with
the RIP (see above).  The error code is valid if and only if an exception
occurs, and '0' isn't necessarily a better "invalid" value, e.g. '0'
could result in false passes for a buggy test.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 39 +++++++++++++------
 .../selftests/kvm/lib/x86_64/processor.c      |  1 +
 .../selftests/kvm/x86_64/hyperv_features.c    |  3 +-
 3 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 9efe80d52389..33b0f19e502c 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -780,6 +780,7 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
  *
  * REGISTER OUTPUTS:
  * r9  = exception vector (non-zero)
+ * r10 = error code
  */
 #define KVM_ASM_SAFE(insn)					\
 	"mov $" __stringify(KVM_EXCEPTION_MAGIC) ", %%r9\n\t"	\
@@ -788,29 +789,43 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 	"1: " insn "\n\t"					\
 	"xor %%r9, %%r9\n\t"					\
 	"2:\n\t"						\
-	"mov  %%r9b, %[vector]\n\t"
+	"mov  %%r9b, %[vector]\n\t"				\
+	"mov  %%r10, %[error_code]\n\t"
 
-#define KVM_ASM_SAFE_OUTPUTS(v)	[vector] "=qm"(v)
+#define KVM_ASM_SAFE_OUTPUTS(v, ec)	[vector] "=qm"(v), [error_code] "=rm"(ec)
 #define KVM_ASM_SAFE_CLOBBERS	"r9", "r10", "r11"
 
-#define kvm_asm_safe(insn, inputs...)			\
-({							\
-	uint8_t vector;					\
-							\
-	asm volatile(KVM_ASM_SAFE(insn)			\
-		     : KVM_ASM_SAFE_OUTPUTS(vector)	\
-		     : inputs				\
-		     : KVM_ASM_SAFE_CLOBBERS);		\
-	vector;						\
+#define kvm_asm_safe(insn, inputs...)					\
+({									\
+	uint64_t ign_error_code;					\
+	uint8_t vector;							\
+									\
+	asm volatile(KVM_ASM_SAFE(insn)					\
+		     : KVM_ASM_SAFE_OUTPUTS(vector, ign_error_code)	\
+		     : inputs						\
+		     : KVM_ASM_SAFE_CLOBBERS);				\
+	vector;								\
+})
+
+#define kvm_asm_safe_ec(insn, error_code, inputs...)			\
+({									\
+	uint8_t vector;							\
+									\
+	asm volatile(KVM_ASM_SAFE(insn)					\
+		     : KVM_ASM_SAFE_OUTPUTS(vector, error_code)		\
+		     : inputs						\
+		     : KVM_ASM_SAFE_CLOBBERS);				\
+	vector;								\
 })
 
 static inline uint8_t rdmsr_safe(uint32_t msr, uint64_t *val)
 {
+	uint64_t error_code;
 	uint8_t vector;
 	uint32_t a, d;
 
 	asm volatile(KVM_ASM_SAFE("rdmsr")
-		     : "=a"(a), "=d"(d), KVM_ASM_SAFE_OUTPUTS(vector)
+		     : "=a"(a), "=d"(d), KVM_ASM_SAFE_OUTPUTS(vector, error_code)
 		     : "c"(msr)
 		     : KVM_ASM_SAFE_CLOBBERS);
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 39c4409ef56a..fc6c724e0d24 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1116,6 +1116,7 @@ static bool kvm_fixup_exception(struct ex_regs *regs)
 
 	regs->rip = regs->r11;
 	regs->r9 = regs->vector;
+	regs->r10 = regs->error_code;
 	return true;
 }
 
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index 05b32e550a80..2b6d455acf8a 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -18,6 +18,7 @@
 static inline uint8_t hypercall(u64 control, vm_vaddr_t input_address,
 				vm_vaddr_t output_address, uint64_t *hv_status)
 {
+	uint64_t error_code;
 	uint8_t vector;
 
 	/* Note both the hypercall and the "asm safe" clobber r9-r11. */
@@ -25,7 +26,7 @@ static inline uint8_t hypercall(u64 control, vm_vaddr_t input_address,
 		     KVM_ASM_SAFE("vmcall")
 		     : "=a" (*hv_status),
 		       "+c" (control), "+d" (input_address),
-		       KVM_ASM_SAFE_OUTPUTS(vector)
+		       KVM_ASM_SAFE_OUTPUTS(vector, error_code)
 		     : [output_address] "r"(output_address),
 		       "a" (-EFAULT)
 		     : "cc", "memory", "r8", KVM_ASM_SAFE_CLOBBERS);
-- 
2.38.1.273.g43a17bfeac-goog

