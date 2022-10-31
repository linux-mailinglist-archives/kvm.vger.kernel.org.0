Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D031613BB3
	for <lists+kvm@lfdr.de>; Mon, 31 Oct 2022 17:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbiJaQsT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 12:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbiJaQsD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 12:48:03 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B084613CC0
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 09:47:57 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id i3so11139177pfc.11
        for <kvm@vger.kernel.org>; Mon, 31 Oct 2022 09:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fBNYrsJt+PhCPrel5hUlVMcI9WM1tkzUtvJ5AOja7Uk=;
        b=VCHZylniitUmaVGlfmhSfp6Co4XMArZdN0OrPisZe5bq3xl2jGv4u25+yEuHauUq7T
         lhsygeoMURL9/PHQ2UyjyiFpo9lQFP2lWRu0581uC1O2TI8ZyxXw/0gDcvK4esrGJQAU
         pNq4qAAtxrMWuMDVi68U4v027Ri225MiASIn4Ei3NN6eC4DJE17pv9vQIm5hTQh7CvkN
         ZC2Yby9+ZZ1VzuyIX0s29rGZblZMfh+0T1t3w78Sr3AFhcB4g1CgkfnOyr9Rqy41XJbd
         5xUyHRLX+lIDHQzhTYyOHs5lHuUM6l9jRY91fB0EktokM5Rf7m0ZH6TeIW5ZbWqdV+hc
         uznQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fBNYrsJt+PhCPrel5hUlVMcI9WM1tkzUtvJ5AOja7Uk=;
        b=BMyWX+6IaT12dPu5XuPsZLvRHLkL02sYX5He8hqzk4XyPSEcY2h1j+NHZfrGi8r04i
         n34oMGLXFUPkxOHWPgxqy6W0cf6Z0iJV6oj9jq/E1hbcrQ5fcFLVvmgN45xXlM36oGwC
         ImUbhJ9GV82t0knPfCCnwSfKcJGB0LcewoUu5+qyzBBwGV1sP2kuKY6kcBe53iaLX05K
         grNTlOrKDqlbtuU8F2K7BFGK023XL6zDRjEPpeDhXgasmS3RpIwGRdHSsVIfvNlTU0c3
         kBIzJMiSrg6tAtfC28qlEaEvCcumsRzgse4SFrXgiAKPBnOK7882B2jW7Fa+24ujoAXi
         9gfQ==
X-Gm-Message-State: ACrzQf3wA0DVAvI2NPjr8r9pf7bbmGXT48kssizSq/ALvqv9zEi38E76
        Xsv3EHJE2D1yc98EmTxC8R8mgw==
X-Google-Smtp-Source: AMsMyM79ev5agn/gqvXx5HykrFpRmtyAJg2aJBtd0/94aLm/lKFlAwKmPAYJsksal0Q3sOQYD3CTlg==
X-Received: by 2002:a05:6a00:234d:b0:561:f0c3:cde1 with SMTP id j13-20020a056a00234d00b00561f0c3cde1mr15337536pfj.34.1667234877059;
        Mon, 31 Oct 2022 09:47:57 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s9-20020a170903214900b00186748fe6ccsm4652912ple.214.2022.10.31.09.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 09:47:56 -0700 (PDT)
Date:   Mon, 31 Oct 2022 16:47:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>,
        Colton Lewis <coltonlewis@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 7/8] KVM: selftests: Expect #PF(RSVD) when TDP is
 disabled
Message-ID: <Y1/8OXK5qSJKGyCk@google.com>
References: <20221018214612.3445074-1-dmatlack@google.com>
 <20221018214612.3445074-8-dmatlack@google.com>
 <Y1si3zrLnC0IIwG1@google.com>
 <CALzav=cuLhif=EMURyMuREKjENK-mxDvBry_x=fvGrnkgG8XqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="q0KEvcjxdmi/YvKb"
Content-Disposition: inline
In-Reply-To: <CALzav=cuLhif=EMURyMuREKjENK-mxDvBry_x=fvGrnkgG8XqQ@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--q0KEvcjxdmi/YvKb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 28, 2022, David Matlack wrote:
> On Thu, Oct 27, 2022 at 5:31 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Tue, Oct 18, 2022, David Matlack wrote:
> > > @@ -50,6 +73,9 @@ int main(int argc, char *argv[])
> > >       TEST_REQUIRE(kvm_has_cap(KVM_CAP_SMALLER_MAXPHYADDR));
> > >
> > >       vm = vm_create_with_one_vcpu(&vcpu, guest_code);
> > > +     vm_init_descriptor_tables(vm);
> > > +     vcpu_init_descriptor_tables(vcpu);
> > > +     vm_install_exception_handler(vm, PF_VECTOR, guest_page_fault_handler);
> >
> > Instead of installing an exception handler,
> >
> >         u8 vector = kvm_asm_safe(KVM_ASM_SAFE(FLDS_MEM_EAX),
> >                                  "a"(MEM_REGION_GVA));
> >
> > then the guest/test can provide more precise information if a #PF doesn't occur.
> 
> I gave this a shot and realized this would prevent checking that it is
> a reserved #PF, since kvm_asm_safe() only returns the vector.
> 
> It's probably more important to have more precise testing rather than
> more precise failure reporting. But what did you have in mind
> specifically? Maybe there's another way.

I didn't have anything in mind, I just overlooked the error code.  That said, this
is a good excuse to expand KVM_ASM_SAFE() to provide the error code.  There's
already a clobbered scratch register (two, actually) that can be used to propagate
the error code from the exception handler back to the asm blob, so it's easy to
squeeze into the existing framework.

Patches attached.

--q0KEvcjxdmi/YvKb
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-KVM-selftests-Avoid-JMP-in-non-faulting-path-of-KVM_.patch"

From 4379b8a511b64e21a93a30b33a4c770eecd22672 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Mon, 31 Oct 2022 08:44:15 -0700
Subject: [PATCH 1/2] KVM: selftests: Avoid JMP in non-faulting path of
 KVM_ASM_SAFE()

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
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index e8ca0d8a6a7e..fd9778d1de3d 100644
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

base-commit: e18d6152ff0f41b7f01f9817372022df04e0d354
-- 
2.38.1.273.g43a17bfeac-goog


--q0KEvcjxdmi/YvKb
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-KVM-selftests-Provide-error-code-as-a-KVM_ASM_SAFE-o.patch"

From a5d5a821524ece6796e05fb1b8c69c9ddb98d312 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Mon, 31 Oct 2022 09:21:28 -0700
Subject: [PATCH 2/2] KVM: selftests: Provide error code as a KVM_ASM_SAFE()
 output

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
---
 .../selftests/kvm/include/x86_64/processor.h  | 39 +++++++++++++------
 .../selftests/kvm/lib/x86_64/processor.c      |  1 +
 .../selftests/kvm/x86_64/hyperv_features.c    |  3 +-
 3 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index fd9778d1de3d..4c6e0e60609b 100644
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


--q0KEvcjxdmi/YvKb--
