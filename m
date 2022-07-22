Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3CFA57EA67
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 01:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236315AbiGVXsr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 19:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235452AbiGVXsp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 19:48:45 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8201EBF9BD
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 16:48:44 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 83-20020a250156000000b006707fbc22ddso4714856ybb.3
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 16:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=KFQW7jsAcLHmWp9w2LJQVvYaLlYILuaNUn+12sIyDcY=;
        b=qxbrGOijKZeV2cD7ZxgNjzGsfWLCuscD/Si2sRkuqHSu8wUOQXPslVMbJSSYHi5WV+
         u/HvgFWLP/siEPKRUx4ziTzEQfjV2d5L3UuvlCJV9K3ptVIlSVxIQKSE3MG02rfw/iDw
         lhwjyYlOwSTv/J29vvRVTu8HAfmQIrV3muEmsRAX1KDRoAZD4nHKZvPQXhV23lK9xjsh
         E9/rln3BX1SRs/9gCiQFyyUAydR3G2hJB4rVIv1vSAblexVGKvYmaXjRbdTez46Aufsr
         YgUpMKo7UeZR9+ProUmVORWAcH/QmnfYzfumj9HF8aC4d/xGrCmSybQJL/2mqD+JpIWf
         jdSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KFQW7jsAcLHmWp9w2LJQVvYaLlYILuaNUn+12sIyDcY=;
        b=JnkCW7OaUqVJG/QL6KCc6FWpk3fw7sZo9z0/W6nxh7ntalVyuCF2DesZClC0mAaJ5v
         zLV/Qclp633/MJv6D4kXOivGdD/7v7U4faeIiObzod9T2EHTdugkzwXIC2cZqQqV8mkZ
         jmO3WEBiLI/XSc/0QXfbvST220SV0OY783l/XMKie3jl1xldTwyjc7zggEyZeYmXwved
         //OmjMkH/tHjf92ybLgTgHQQPNd/nIuXah7QR8i0j2VmBRDJDAk+HsoYUcsKHcQBR4V8
         7FnBezVH0VKN+zIJsnCi73LKvyWbWGwaAyohYfjj/O3eTg/ICL6AKMImHWqm2LElectE
         UKtw==
X-Gm-Message-State: AJIora+xrEKerwDZn886Q9O6L47i6GMDTtzh8cEo6+7ndso+rxkc/RzQ
        LuklvNG/r7YAvCH0osWjFSdBN94GGUeVdQ==
X-Google-Smtp-Source: AGRyM1sOKspIXC3FlbYTAoXrIrzhWcsWZPMFx9n/05iN/AmSnKvxUUNxuiPxUVme/T+yNRebujFPkHOoZl+wog==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:d606:0:b0:66e:b73d:5de3 with SMTP id
 n6-20020a25d606000000b0066eb73d5de3mr1845516ybg.360.1658533723862; Fri, 22
 Jul 2022 16:48:43 -0700 (PDT)
Date:   Fri, 22 Jul 2022 23:48:37 +0000
In-Reply-To: <20220722234838.2160385-1-dmatlack@google.com>
Message-Id: <20220722234838.2160385-2-dmatlack@google.com>
Mime-Version: 1.0
References: <20220722234838.2160385-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH 1/2] KVM: selftests: Fix KVM_EXCEPTION_MAGIC build with Clang
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

Change KVM_EXCEPTION_MAGIC to use the all-caps "ULL", rather than lower
case. This fixes a build failure with Clang:

  In file included from x86_64/hyperv_features.c:13:
  include/x86_64/processor.h:825:9: error: unexpected token in argument list
          return kvm_asm_safe("wrmsr", "a"(val & -1u), "d"(val >> 32), "c"(msr));
                 ^
  include/x86_64/processor.h:802:15: note: expanded from macro 'kvm_asm_safe'
          asm volatile(KVM_ASM_SAFE(insn)                 \
                       ^
  include/x86_64/processor.h:785:2: note: expanded from macro 'KVM_ASM_SAFE'
          "mov $" __stringify(KVM_EXCEPTION_MAGIC) ", %%r9\n\t"   \
          ^
  <inline asm>:1:18: note: instantiated into assembly here
          mov $0xabacadabaull, %r9
                          ^

Fixes: 3b23054cd3f5 ("KVM: selftests: Add x86-64 support for exception fixup")
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/include/x86_64/processor.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 45edf45821d0..51c6661aca77 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -754,7 +754,7 @@ void vm_install_exception_handler(struct kvm_vm *vm, int vector,
 			void (*handler)(struct ex_regs *));
 
 /* If a toddler were to say "abracadabra". */
-#define KVM_EXCEPTION_MAGIC 0xabacadabaull
+#define KVM_EXCEPTION_MAGIC 0xabacadabaULL
 
 /*
  * KVM selftest exception fixup uses registers to coordinate with the exception
-- 
2.37.1.359.gd136c6c3e2-goog

