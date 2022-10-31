Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31DE4613CC9
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 19:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiJaSBK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 14:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiJaSBE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 14:01:04 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062E413D3C
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:01:03 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id j22-20020aa79296000000b0056d3180c800so2366567pfa.3
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 11:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EumOl5mGgVnCEzDA+UueSGzDQoNJ9RAkypwsXwSdasQ=;
        b=nmA84ddMcpRP2hFYDqoMp2XhVwDw0uGolYYYJo8yoKEeGUTwIcNkDhfeLAmWW/F6oW
         oLUUPUeRENd3+vUw22CvKmI9o0MEP8zAPsZ9QmuQI/4YEt80KgXrdz3YIf7Ddf6W2jEY
         N1DeK1POtHRaWUTOr1DDvz/yuL3vV0eDKCq8H2EDK0YUrxqU4ixGybWBzA7Fxjxrk8Pf
         6i/07Qj30aMH2VcbHYR7Jur2RoVXb+h3iRUVtmpoZ7cOYv8KJ1nOnqga9ljYe/K4YiFl
         I4AbXKP7rcb3GkQOG9/rZzatx9bkzvgIQmzRSzIO2kg+HfwQmAkbf2tMBLeWNHPuwuj5
         FoNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EumOl5mGgVnCEzDA+UueSGzDQoNJ9RAkypwsXwSdasQ=;
        b=GFRGTej6J4/wk7quB47Q+0eVykAZ+WIxUbhl6lCmKV2BhUgVu5yjf7yBFxTPhoteyj
         CDdP1jvph9UY5ySQ+luC0n1hHYwaIBRaUDFtg8/2x38bQs1lGNtAhx4jUmTazmEI6zSb
         eNXAfUq9VSgkraDTMDGuoYd2KMqkSJWOJf3G30xDCaVu//KTMdaZfbl8QFEFWt1zifeZ
         nNI8mSEO9ujEPA8hKdGAKmBng64D52Vv+nZXZBuRRST/9BIhXRHqm+jUvleNULgmLauQ
         oc7ARsypHrualIhVk3ut9EACk6/QmIhYP4uX7goPmTWyzZzeqnGoEZ/s4c3I180T1IHr
         /4ww==
X-Gm-Message-State: ACrzQf2DkjCN2tK3L0PGv93ye9/1pu4DyJ2ZjSlSPkeIr3mOSQT1o1a/
        lWx1zT7XXPKXEYzEWQUzarJNnW543wi0MA==
X-Google-Smtp-Source: AMsMyM5efca/PyxNmqTIb6Ud/6wk5zBYuG9TABpZz5Sadm8w5mD6vosLbMuigQHzECNtMr3fA/F1iLGoEYPiYA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:c691:b0:212:fd5f:1ab8 with SMTP
 id n17-20020a17090ac69100b00212fd5f1ab8mr32667755pjt.11.1667239262566; Mon,
 31 Oct 2022 11:01:02 -0700 (PDT)
Date:   Mon, 31 Oct 2022 11:00:42 -0700
In-Reply-To: <20221031180045.3581757-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221031180045.3581757-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221031180045.3581757-8-dmatlack@google.com>
Subject: [PATCH v3 07/10] KVM: selftests: Avoid JMP in non-faulting path of KVM_ASM_SAFE()
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

Clear R9 in the non-faulting path of KVM_ASM_SAFE() and fall through to
to a common load of "vector" to effectively load "vector" with '0' to
reduce the code footprint of the asm blob, to reduce the runtime overhead
of the non-faulting path (when "vector" is stored in a register), and so
that additional output constraints that are valid if and only if a fault
occur are loaded even in the non-faulting case.

A future patch will add a 64-bit output for the error code, and if its
output is not explicitly loaded with _something_, the user of the asm
blob can end up technically consuming uninitialized data.  Using a
common path to load the output constraints will allow using an existing
scratch register, e.g. r10, to hold the error code in the faulting path,
while also guaranteeing the error code is initialized with deterministic
data in the non-faulting patch (r10 is loaded with the RIP of
to-be-executed instruction).

Consuming the error code when a fault doesn't occur would obviously be a
test bug, but there's no guarantee the compiler will detect uninitialized
consumption.  And conversely, it's theoretically possible that the
compiler might throw a false positive on uninitialized data, e.g. if the
compiler can't determine that the non-faulting path won't touch the error
code.

Alternatively, the error code could be explicitly loaded in the
non-faulting path, but loading a 64-bit memory|register output operand
with an explicitl value requires a sign-extended "MOV imm32, r/m64",
which isn't exactly straightforward and has a largish code footprint.
And loading the error code with what is effectively garbage (from a
scratch register) avoids having to choose an arbitrary value for the
non-faulting case.

Opportunistically remove a rogue asterisk in the block comment.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index f7249cb27e0d..9efe80d52389 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -764,7 +764,7 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
  * for recursive faults when accessing memory in the handler.  The downside to
  * using registers is that it restricts what registers can be used by the actual
  * instruction.  But, selftests are 64-bit only, making register* pressure a
- * minor concern.  Use r9-r11 as they are volatile, i.e. don't need* to be saved
+ * minor concern.  Use r9-r11 as they are volatile, i.e. don't need to be saved
  * by the callee, and except for r11 are not implicit parameters to any
  * instructions.  Ideally, fixup would use r8-r10 and thus avoid implicit
  * parameters entirely, but Hyper-V's hypercall ABI uses r8 and testing Hyper-V
@@ -786,11 +786,9 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 	"lea 1f(%%rip), %%r10\n\t"				\
 	"lea 2f(%%rip), %%r11\n\t"				\
 	"1: " insn "\n\t"					\
-	"movb $0, %[vector]\n\t"				\
-	"jmp 3f\n\t"						\
+	"xor %%r9, %%r9\n\t"					\
 	"2:\n\t"						\
-	"mov  %%r9b, %[vector]\n\t"				\
-	"3:\n\t"
+	"mov  %%r9b, %[vector]\n\t"
 
 #define KVM_ASM_SAFE_OUTPUTS(v)	[vector] "=qm"(v)
 #define KVM_ASM_SAFE_CLOBBERS	"r9", "r10", "r11"
-- 
2.38.1.273.g43a17bfeac-goog

