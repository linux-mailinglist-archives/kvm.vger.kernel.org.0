Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC9BD315DC5
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 04:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbhBJDSP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 22:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbhBJDSO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Feb 2021 22:18:14 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 245BFC061574
        for <kvm@vger.kernel.org>; Tue,  9 Feb 2021 19:17:28 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id r15so514025qke.5
        for <kvm@vger.kernel.org>; Tue, 09 Feb 2021 19:17:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=MAgnKOR63Vcbcr0Q3TwMb9QZTto3ra+JOzUzTYPtlnU=;
        b=NwTUueZoXliqack72iXTFwL1gnkNW6k3ZRqDYuiBGQsjNCeUi+pOm8jVnO+jWcdGdW
         dNRqkrMg/R3xscTgyY2sogn0pEoXXGsPlmxXakd/PdvFctE5rCzcCtfUe3BS9uZxopBr
         8kJBGa3+3AF3Ec3YdU6Hn5ydF74JPygNJ07ek21hvQKtYaFpHxk+iyRGgJHeq96zWICB
         6j7+HsU8aHQJgpes9N7MpXFQrByFYK2C/AvPXC7WtKeipnq0+Ft90pGNCwxezHtjZH0v
         lOrZ+gvceKl2dTFHjyP5M2kZxDEhwNlCzyxwoDAe54YRSVCc7jYYIXzZfHm58PMWJVMd
         n9/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=MAgnKOR63Vcbcr0Q3TwMb9QZTto3ra+JOzUzTYPtlnU=;
        b=P53Vv77+uQThBOiHz3zwrFisCmpNX65DRWvES5aR4jZRaJ9mr8RlaBo2fCi2idhNW9
         U1inrgeJys0pQ8lM8LU9fgf8zvT/i3AIVgxvgp0J67p0kDP8GBTfes+HAd45zQ1nR9mt
         MgMnfB6EhFCtTDE96O1q/cLvM1dvLrrV7Jt9rJ23zgBbkElRlDW+Pjfk1i5OBnL7YP7w
         tw1nxyIKzP3T9kAX+lTui7bN7v/GfmsrmLtZyJHZ5qDNBlMjp5/d0rJdvcf1ILH1wraV
         RRf2hEAuLWhtZctjQBtynT3FMvHk/KGAkw0bydyAtzH6EvglI2L/51AMCjb6X/I50Iix
         XtkQ==
X-Gm-Message-State: AOAM533uj/WxgB7s32FRk1E9mTLHYNKFKjnqbioN29geI3nYeLFAGQzS
        mz9ByksR9+sBWMWSrlpTNkwgowiaZTPx9Zve6o6wlq5RbfKNMZOTAuIVKO3JMN4a0vbuaKxEIiZ
        efKh/IXbe3+o2kMFLQUMmTlX0UYLDbDqUfL/EUUcTg0VVH6jUMO1w1sShWwE4Ay4=
X-Google-Smtp-Source: ABdhPJznceEJmYN2lSndCVF1dYbLmr7yfbOdiiTIgbipZwEQS+eD1zbdVyodcuyqit3PqhUyC6hn3730h4QgLQ==
Sender: "ricarkol via sendgmr" <ricarkol@ricarkol2.c.googlers.com>
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a0c:e14c:: with SMTP id
 c12mr1008982qvl.54.1612927047140; Tue, 09 Feb 2021 19:17:27 -0800 (PST)
Date:   Wed, 10 Feb 2021 03:17:19 +0000
Message-Id: <20210210031719.769837-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH] KVM: selftests: Add operand to vmsave/vmload/vmrun in svm.c
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Building the KVM selftests with LLVM's integrated assembler fails with:

  $ CFLAGS=-fintegrated-as make -C tools/testing/selftests/kvm CC=clang
  lib/x86_64/svm.c:77:16: error: too few operands for instruction
          asm volatile ("vmsave\n\t" : : "a" (vmcb_gpa) : "memory");
                        ^
  <inline asm>:1:2: note: instantiated into assembly here
          vmsave
          ^
  lib/x86_64/svm.c:134:3: error: too few operands for instruction
                  "vmload\n\t"
                  ^
  <inline asm>:1:2: note: instantiated into assembly here
          vmload
          ^
This is because LLVM IAS does not currently support calling vmsave,
vmload, or vmload without an explicit %rax operand.

Add an explicit operand to vmsave, vmload, and vmrum in svm.c. Fixing
this was suggested by Sean Christopherson.

Tested: building without this error in clang 11. The following patch
(not queued yet) needs to be applied to solve the other remaining error:
"selftests: kvm: remove reassignment of non-absolute variables".

Suggested-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/kvm/X+Df2oQczVBmwEzi@google.com/
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/lib/x86_64/svm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/svm.c b/tools/testing/selftests/kvm/lib/x86_64/svm.c
index 3a5c72ed2b79..827fe6028dd4 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/svm.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/svm.c
@@ -74,7 +74,7 @@ void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_r
 	wrmsr(MSR_VM_HSAVE_PA, svm->save_area_gpa);
 
 	memset(vmcb, 0, sizeof(*vmcb));
-	asm volatile ("vmsave\n\t" : : "a" (vmcb_gpa) : "memory");
+	asm volatile ("vmsave %0\n\t" : : "a" (vmcb_gpa) : "memory");
 	vmcb_set_seg(&save->es, get_es(), 0, -1U, data_seg_attr);
 	vmcb_set_seg(&save->cs, get_cs(), 0, -1U, code_seg_attr);
 	vmcb_set_seg(&save->ss, get_ss(), 0, -1U, data_seg_attr);
@@ -131,19 +131,19 @@ void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_r
 void run_guest(struct vmcb *vmcb, uint64_t vmcb_gpa)
 {
 	asm volatile (
-		"vmload\n\t"
+		"vmload %[vmcb_gpa]\n\t"
 		"mov rflags, %%r15\n\t"	// rflags
 		"mov %%r15, 0x170(%[vmcb])\n\t"
 		"mov guest_regs, %%r15\n\t"	// rax
 		"mov %%r15, 0x1f8(%[vmcb])\n\t"
 		LOAD_GPR_C
-		"vmrun\n\t"
+		"vmrun %[vmcb_gpa]\n\t"
 		SAVE_GPR_C
 		"mov 0x170(%[vmcb]), %%r15\n\t"	// rflags
 		"mov %%r15, rflags\n\t"
 		"mov 0x1f8(%[vmcb]), %%r15\n\t"	// rax
 		"mov %%r15, guest_regs\n\t"
-		"vmsave\n\t"
+		"vmsave %[vmcb_gpa]\n\t"
 		: : [vmcb] "r" (vmcb), [vmcb_gpa] "a" (vmcb_gpa)
 		: "r15", "memory");
 }
-- 
2.30.0.478.g8a0d178c01-goog

