Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30975787D3F
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 03:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238133AbjHYBg5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 21:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237296AbjHYBg1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 21:36:27 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC52510F4
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 18:36:25 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-26f591c1a2cso419024a91.3
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 18:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692927385; x=1693532185;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bJJ3epqDVWn/KgYpEj6yufH8AAy7yBUMi0zyuddHTI0=;
        b=XqOqBAKajc/Uga/xASsgoKffklBZQ5azzky229tcolshI77rjyjQMLre9b7dPzSIgj
         lVG4ew55uuC8R5nZ7nXg2b5A+L2qS52P9RfkYbnzcPJE/4NVnU4xH89WhtRpG4ofsstc
         uy27UmXSND3YGSD+LBGo/LIhYYA7XV1THT9iHEfQSmAqHdt/Y54W+Vl1lD6cDXhnd43Z
         UYCZeNDwkAIB7MM/GKjVgTCGdpX1j7846UcfyU2S6YP9AU+ERAsvIctRqa1lccR5EBbU
         se9PTfEaPArj+ryD0h9Kun/f8ZvK/Xso/s+fZ/k/hC7e3Lna8ETybEyMa2okbU1dH+vj
         qOAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692927385; x=1693532185;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bJJ3epqDVWn/KgYpEj6yufH8AAy7yBUMi0zyuddHTI0=;
        b=OdOmRYBzxRA02b1VEKKpsVdGnjso82SbEJcQYMegx0CJXgEGQTlXINcfW5qeEIQK+d
         aBuiZ+9H182Q/94hQLQ4G4XCiuUgl88Y19yqhYuAUCzQfH49lIO47z7so4WfAyHkdaCP
         5KN+b3ayM/mlDvHNtTYnFxNVfUv6AmWLx0t3KV5vFNccJrhFOonVr3znO5czoEdNUEwN
         MAjp7fOkwVlj9C4ArV9r0hGTpX25MuBgGDK6ZAvFYwerOhZE9BjY1MwUPlLEqrvG2O8a
         rENW72lzjz3A5756YbNswk2KoGkbBvwCbz4/1qJkIUZFKmd1wjin28EgKhxSSZMybnWR
         BYUA==
X-Gm-Message-State: AOJu0Yw7NsI4ZsKD+ZfBGVjb8leONCK08pUj5IoC7xWEKy7tIFMCs8UQ
        f1rxf7XHPxMgrLb/hxQzmnM+971IM/s=
X-Google-Smtp-Source: AGHT+IH1W88yr05UABQ3pKkKEY6GI4o4pwaiVeo9ubY08TwPWlJzGKO/s9Bw0wnhW3tjJB3QbnPgiKkjsFg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:383:b0:268:1d63:b9ae with SMTP id
 ga3-20020a17090b038300b002681d63b9aemr4281422pjb.3.1692927385357; Thu, 24 Aug
 2023 18:36:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 24 Aug 2023 18:36:18 -0700
In-Reply-To: <20230825013621.2845700-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230825013621.2845700-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.rc2.253.gd59a3bf2b4-goog
Message-ID: <20230825013621.2845700-2-seanjc@google.com>
Subject: [PATCH v2 1/4] KVM: SVM: Don't inject #UD if KVM attempts to skip SEV
 guest insn
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wu Zongyo <wuzongyo@mail.ustc.edu.cn>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't inject a #UD if KVM attempts to "emulate" to skip an instruction
for an SEV guest, and instead resume the guest and hope that it can make
forward progress.  When commit 04c40f344def ("KVM: SVM: Inject #UD on
attempted emulation for SEV guest w/o insn buffer") added the completely
arbitrary #UD behavior, there were no known scenarios where a well-behaved
guest would induce a VM-Exit that triggered emulation, i.e. it was thought
that injecting #UD would be helpful.

However, now that KVM (correctly) attempts to re-inject INT3/INTO, e.g. if
a #NPF is encountered when attempting to deliver the INT3/INTO, an SEV
guest can trigger emulation without a buffer, through no fault of its own.
Resuming the guest and retrying the INT3/INTO is architecturally wrong,
e.g. the vCPU will incorrectly re-hit code #DBs, but for SEV guests there
is literally no other option that has a chance of making forward progress.

Drop the #UD injection for all "skip" emulation, not just those related to
INT3/INTO, even though that means that the guest will likely end up in an
infinite loop instead of getting a #UD (the vCPU may also crash, e.g. if
KVM emulated everything about an instruction except for advancing RIP).
There's no evidence that suggests that an unexpected #UD is actually
better than hanging the vCPU, e.g. a soft-hung vCPU can still respond to
IRQs and NMIs to generate a backtrace.

Reported-by: Wu Zongyo <wuzongyo@mail.ustc.edu.cn>
Closes: https://lore.kernel.org/all/8eb933fd-2cf3-d7a9-32fe-2a1d82eac42a@mail.ustc.edu.cn
Fixes: 6ef88d6e36c2 ("KVM: SVM: Re-inject INT3/INTO instead of retrying the instruction")
Cc: stable@vger.kernel.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a139c626fa8b..bd53b2d497d0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -364,6 +364,8 @@ static void svm_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
 		svm->vmcb->control.int_state |= SVM_INTERRUPT_SHADOW_MASK;
 
 }
+static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
+					void *insn, int insn_len);
 
 static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
 					   bool commit_side_effects)
@@ -384,6 +386,14 @@ static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
 	}
 
 	if (!svm->next_rip) {
+		/*
+		 * FIXME: Drop this when kvm_emulate_instruction() does the
+		 * right thing and treats "can't emulate" as outright failure
+		 * for EMULTYPE_SKIP.
+		 */
+		if (!svm_can_emulate_instruction(vcpu, EMULTYPE_SKIP, NULL, 0))
+			return 0;
+
 		if (unlikely(!commit_side_effects))
 			old_rflags = svm->vmcb->save.rflags;
 
@@ -4724,16 +4734,25 @@ static bool svm_can_emulate_instruction(struct kvm_vcpu *vcpu, int emul_type,
 	 * and cannot be decrypted by KVM, i.e. KVM would read cyphertext and
 	 * decode garbage.
 	 *
-	 * Inject #UD if KVM reached this point without an instruction buffer.
-	 * In practice, this path should never be hit by a well-behaved guest,
-	 * e.g. KVM doesn't intercept #UD or #GP for SEV guests, but this path
-	 * is still theoretically reachable, e.g. via unaccelerated fault-like
-	 * AVIC access, and needs to be handled by KVM to avoid putting the
-	 * guest into an infinite loop.   Injecting #UD is somewhat arbitrary,
-	 * but its the least awful option given lack of insight into the guest.
+	 * If KVM is NOT trying to simply skip an instruction, inject #UD if
+	 * KVM reached this point without an instruction buffer.  In practice,
+	 * this path should never be hit by a well-behaved guest, e.g. KVM
+	 * doesn't intercept #UD or #GP for SEV guests, but this path is still
+	 * theoretically reachable, e.g. via unaccelerated fault-like AVIC
+	 * access, and needs to be handled by KVM to avoid putting the guest
+	 * into an infinite loop.   Injecting #UD is somewhat arbitrary, but
+	 * its the least awful option given lack of insight into the guest.
+	 *
+	 * If KVM is trying to skip an instruction, simply resume the guest.
+	 * If a #NPF occurs while the guest is vectoring an INT3/INTO, then KVM
+	 * will attempt to re-inject the INT3/INTO and skip the instruction.
+	 * In that scenario, retrying the INT3/INTO and hoping the guest will
+	 * make forward progress is the only option that has a chance of
+	 * success (and in practice it will work the vast majority of the time).
 	 */
 	if (unlikely(!insn)) {
-		kvm_queue_exception(vcpu, UD_VECTOR);
+		if (!(emul_type & EMULTYPE_SKIP))
+			kvm_queue_exception(vcpu, UD_VECTOR);
 		return false;
 	}
 
-- 
2.42.0.rc2.253.gd59a3bf2b4-goog

