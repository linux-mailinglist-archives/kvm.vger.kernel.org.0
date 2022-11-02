Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B52C0616D12
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 19:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231707AbiKBSrT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 14:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbiKBSrK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 14:47:10 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D5F2F67C
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 11:47:09 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e8-20020a5b0cc8000000b006bca0fa3ab6so16982454ybr.0
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 11:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EumOl5mGgVnCEzDA+UueSGzDQoNJ9RAkypwsXwSdasQ=;
        b=UZJ4hHhdrFkLZ870xr/rjRoaNrd6lIUolSt2myKZViZ/GGgQJ/pbadILfT8PMgjEmu
         ZYJWMBFgnYN1VAS1sLdD1zns2vEJ7+9ZGXFVeb557F/DY1ywKHMoyiUM5NbF4Qf0vWV0
         HWQGgu6owiFBTWoUE5C8Xs10LQnj5RtBCy/8pYbOiom4+jomeGFSih3281H71Xj7S1CY
         D03bNpNLbV1lB7R/ldNZ8/3BuLzXQIaL2U2XmlK0oMiMBUyuxlinHckz1iU6srG3GjKh
         w2zFicVm0sILsMZZH9FSCLtgKgywo4OjhLDhwc4g+PEgq1k0SfpdqxDIGTaNTZ81gLoW
         VJgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EumOl5mGgVnCEzDA+UueSGzDQoNJ9RAkypwsXwSdasQ=;
        b=7SZtV8zFE2msxO4kQBt42Jdl7/AtDYJdECtttvvO9nm/rbCxu4Qc1pzMnIWoUkRZmK
         6cfy1/XXLvyEPpDVT2Y68LV7xhaOfboGlVpWkLk/BQehxtPg6KUyL6cTwCXs6PogskYm
         rhg1rNR59rO8sWY5Zae+xUarfmHk57n72679Pi5hdT1iKuruWPFlUNtKwv2KNGIKX88T
         Kwk05dAjKJzdWytmUe7nIupYc6QOXRlDZw59ufCvUB42ttrH8x6kPMPZGIKnBDCKr1za
         qz59lhI9kHXvkpKJDTxzFzA9AJlhHRXFSgbe7fOjf227PPDpTMOnxy6tUYq/js7FoxWE
         GAKQ==
X-Gm-Message-State: ACrzQf2lBxHElFP4SnYRw33rOx+FTof36bXn7eXDNIJdlnr5jea+KI2G
        093CRHOkWB6haxnNMU7bwvLleiNrUqiFXQ==
X-Google-Smtp-Source: AMsMyM5ppov+wqEqcSKl5tRhi1ODfgtFQA4ohSDwa8CL7qUIHi6UlCTVjKAHH7wax6oVG0rPEXTX5URrinBHZA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:d491:0:b0:6ca:ef3c:d5f6 with SMTP id
 m139-20020a25d491000000b006caef3cd5f6mr23347532ybf.343.1667414829036; Wed, 02
 Nov 2022 11:47:09 -0700 (PDT)
Date:   Wed,  2 Nov 2022 11:46:51 -0700
In-Reply-To: <20221102184654.282799-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221102184654.282799-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221102184654.282799-8-dmatlack@google.com>
Subject: [PATCH v4 07/10] KVM: selftests: Avoid JMP in non-faulting path of KVM_ASM_SAFE()
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

