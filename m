Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 831EB57EA68
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 01:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236399AbiGVXst (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 19:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234919AbiGVXsr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 19:48:47 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6F65C06C2
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 16:48:46 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-31e65a848daso50605917b3.20
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 16:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=C5vxcKBsXfUKk2MUSnDuijEsY5Uu1XCESOEGFEpHan4=;
        b=Utdu1V3aRcGKKdAJiX1P6WXcvxoJLpXF8LbdwZgQ2R2R8j/6WsY8HUYm06OrvZY4B9
         VZDgDdFPliKb2A21kfpagaDCr3hSzuk07GJTzX4xKoYTukGX7X6x+v/OKdMt08DlJQuL
         cip9S4pmjPz13jQlWcDoQqd98cR7AgfDgYdBZO0qwLNfICob/mXUBOmSEaeKyxCwPhg3
         Xh7PlWjmdmj8mxZ2E/AZ7Ud1E6YVP1qJ16h2kryDbkLHW+FlihzkrITlgMCXm7fJxHp+
         pKUyuBIrrv/yMsooOhKXxACpWSPyQ7idgj+jQ0J1T2hWTjCh750l11CsZ1SGFvf+QVPO
         JZCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=C5vxcKBsXfUKk2MUSnDuijEsY5Uu1XCESOEGFEpHan4=;
        b=wdvQv5ZX50AmAp2NDr/+7ZV4p0q/3njEEtbNeLeNRffme/fJsnrViYMUD1sZHXji2s
         giOVQ1H/WBQGfGMte5XPXjdggovIomYbDUkyWCpplDv7Mor7kpO96IrHn3QapvQbGoJZ
         Ngfp2LtRv4VDE/yFhYmjNYpMi+PadIfTHSJqPwjpavIDIxIApin8yvXNkiREyd3LQSKD
         GdF7GXpceS1h96UGHqr0KlBC9A+xno6jWsijDPqEubNiArUSfjsqIWiSWuyaa1uX6VXp
         pbumMrF9oPh6L3ocQx6MF2KF3MgfjU3nW9mVuph38x7PJ4rgAcgwfwgOUiQpyLwpKlg4
         OPvw==
X-Gm-Message-State: AJIora8lVz70jvVve996l07BAcxzN2gCFWfo3QI/10sZSdi75iAed0cH
        zvGSixwS/udCxNtDK2/ScaNeX/wlXvC7kw==
X-Google-Smtp-Source: AGRyM1tn9WYAdHKqq6lfJAZm8nBg32Zv2QGSkMx1BhgjaHTdJKmr0cWym95nsT9ukBiTU4ZQC0T077veefdMvQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a0d:c603:0:b0:31e:7d54:17fd with SMTP id
 i3-20020a0dc603000000b0031e7d5417fdmr1922347ywd.421.1658533726164; Fri, 22
 Jul 2022 16:48:46 -0700 (PDT)
Date:   Fri, 22 Jul 2022 23:48:38 +0000
In-Reply-To: <20220722234838.2160385-1-dmatlack@google.com>
Message-Id: <20220722234838.2160385-3-dmatlack@google.com>
Mime-Version: 1.0
References: <20220722234838.2160385-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH 2/2] KVM: selftests: Fix ambiguous mov in KVM_ASM_SAFE()
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>,
        "open list:CLANG/LLVM BUILD SUPPORT" <llvm@lists.linux.dev>,
        kvm@vger.kernel.org
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

Change the mov in KVM_ASM_SAFE() that zeroes @vector to a movb to
make it unambiguous.

This fixes a build failure with Clang since, unlike the GNU assembler,
the LLVM integrated assembler rejects ambiguous X86 instructions that
don't have suffixes:

  In file included from x86_64/hyperv_features.c:13:
  include/x86_64/processor.h:825:9: error: ambiguous instructions require an explicit suffix (could be 'movb', 'movw', 'movl', or 'movq')
          return kvm_asm_safe("wrmsr", "a"(val & -1u), "d"(val >> 32), "c"(msr));
                 ^
  include/x86_64/processor.h:802:15: note: expanded from macro 'kvm_asm_safe'
          asm volatile(KVM_ASM_SAFE(insn)                 \
                       ^
  include/x86_64/processor.h:788:16: note: expanded from macro 'KVM_ASM_SAFE'
          "1: " insn "\n\t"                                       \
                        ^
  <inline asm>:5:2: note: instantiated into assembly here
          mov $0, 15(%rsp)
          ^

It seems like this change could introduce undesirable behavior in the
future, e.g. if someone used a type larger than a u8 for @vector, since
KVM_ASM_SAFE() will only zero the bottom byte. I tried changing the type
of @vector to an int to see what would happen. GCC failed to compile due
to a size mismatch between `movb` and `%eax`. Clang succeeded in
compiling, but the generated code looked correct, so perhaps it will not
be an issue. That being said it seems like there could be a better
solution to this issue that does not assume @vector is a u8.

Fixes: 3b23054cd3f5 ("KVM: selftests: Add x86-64 support for exception fixup")
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 51c6661aca77..0cbc71b7af50 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -786,7 +786,7 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 	"lea 1f(%%rip), %%r10\n\t"				\
 	"lea 2f(%%rip), %%r11\n\t"				\
 	"1: " insn "\n\t"					\
-	"mov $0, %[vector]\n\t"					\
+	"movb $0, %[vector]\n\t"				\
 	"jmp 3f\n\t"						\
 	"2:\n\t"						\
 	"mov  %%r9b, %[vector]\n\t"				\
-- 
2.37.1.359.gd136c6c3e2-goog

