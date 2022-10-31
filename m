Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F44613CCA
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 19:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbiJaSBN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 14:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiJaSBH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 14:01:07 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E6E13D6F
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:01:05 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 204-20020a250fd5000000b006ccc0e91098so1677984ybp.13
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KMoIap0sR+1CcUsNo9fMIcDCtwhfe98yh5fTCarrD0c=;
        b=VLj3zRJLo2Nc3pt/6PLTuz73FGjUXZHI+ss8K4kGwcdY9WYhL/h3+bd7wVTujqbsxK
         Njc0xZihrFpNQECfQyYwVmTV74B8Hgpb/tbbqO2iR1d7GakKXdBa9T+fMSjpRWNItcBh
         YcIILblPGHdbp8SEL6gItvb+2mfhZGvRbm8VU7DHSAet99kBSSZ3WBYggp6btxpHIawf
         mBaXaiwBJNBhjDNmCO9GSKBLLhbjU7vJKmpm6NZ4yKMEB0s52TsbHEi+VIdY8JTB0rcS
         zJBKaOywg57weYiiRYoo9al80OZSmMbT6G+NJ4NhmktEwyQP3a1M3wMQ4dq4DFRQOO9B
         F7mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KMoIap0sR+1CcUsNo9fMIcDCtwhfe98yh5fTCarrD0c=;
        b=4gKOWWlvkaL1g2eM/4xBnlX+9P2P3BFe1sn29uKV1WaZ+eh3c2rVkDxWokXpI1k0Ei
         WS9xszipimrTKX2FyRXIaRW/+3nADPg9dZU0LicIvIOLDVRE+atSvDFVSspFhjKryCeH
         c0PDTYplDWJkFuGyz7JSi0iqpURFCRhTEzcnrcPPDvcSz15xsoeqvBOZEtPvsSnqym1k
         SuqImSSNyXzqSNzLGTBN9ZNRk5UiZttGTR75J3LZe5J8F2IJfj5zK5R2FqpBiccCPBVd
         2f/mYidhN/e3kD+zloYA+33O5rfboy2+mtbLkT4xUJeMDNWxcICaAG3X5Z8JEtCz1o3/
         XcDA==
X-Gm-Message-State: ACrzQf1CgCLe+Y3sQiA5bkiPBIL0wtgd7E8JplBGvAUmEUCJsc4kgk2I
        K++DuwKBk3EpmmI5GQJi+PzTGI2i8KtfhQ==
X-Google-Smtp-Source: AMsMyM4U9Rbs0fvhBZ53r4dAC1ISz0ocqdMAMluyOod/5k8dcgP8aQKc2vlbCtT9g8F7baxM7AkAlokX+RUnEA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:6902:13c7:b0:695:84d9:c5da with SMTP
 id y7-20020a05690213c700b0069584d9c5damr13953475ybu.650.1667239264359; Mon,
 31 Oct 2022 11:01:04 -0700 (PDT)
Date:   Mon, 31 Oct 2022 11:00:43 -0700
In-Reply-To: <20221031180045.3581757-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221031180045.3581757-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221031180045.3581757-9-dmatlack@google.com>
Subject: [PATCH v3 08/10] KVM: selftests: Provide error code as a
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

