Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B31857EABE
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 02:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236454AbiGWAv5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 20:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236160AbiGWAvs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 20:51:48 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31CC13E04
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 17:51:47 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 1-20020a17090a190100b001f05565f004so2620572pjg.0
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 17:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=cAX1yeYYe1qjAZf7Suz3oA25ZI3D0KwAESBSQk1/8Uc=;
        b=cOXrACnvJt1gAw6Hnq8VaDtjh0r3jmfmqe7BQWGe611UOjBM9A5zup37jEDgwM4vaL
         o5ZYdhY9UkfhzxJyITivmKwh3lx2nGpIihLMSl+Y9bWRIHbBShT6+Iyn6QcBh3JHH/+E
         afpoSxPwU8NjoH7kZoGFKflgeyNYocJHtgn/tUsNeJjxNWAluq2gG4qoYpLkXvraqcbM
         +IM9nfaz34Esk7x+4InPy7IqxEHeGRtuSqVGK5LBCRjKI3H24y4SOYZ9C/CxVRQnfYnC
         V2bG75ssa7q8DpPYLPg0+hUuoU8qYhU+55GHSflgDDcGPRcCWBbn9l04dWS6+fd02ef2
         2czg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=cAX1yeYYe1qjAZf7Suz3oA25ZI3D0KwAESBSQk1/8Uc=;
        b=0xfiKuRlBZHQ0eUZVdMfAQdY0a70UOixBYopuT86IsbRmsDP+0wk1CwRV2QrjMpMOr
         39CwlEe5Mcf2eC0pLLa+WytVMiIbQvHZCXZW2ztm4k1dnSQQnMjXsaUBqR+BfVPnPvAr
         Qx4tRNPU0SofLNmYG9RDjtiPUbHlzq57g7sWETMwQFX0WOwzRWWHf5LQs4u8MYM1N+21
         EwE0NXdoQuAUyTMnGpSP1oInK3exfG/1NESOqwhfKrPZ+/ZdbPlANnXwm2gTPEmnFYvG
         2ykCZqk8528nS98DZXdab3A06ztBzAPFVudBTj6+RK+FXghsSkbZV1ump9o3O4cmxpIR
         ahxg==
X-Gm-Message-State: AJIora8H4V448XRYwqLtXOdrjpHMKmQ+FqF0DDVtNoZ8V17SqXG9yZo6
        KZMAcuWf/k+qGGAQ43+lLFztH4VguhQ=
X-Google-Smtp-Source: AGRyM1ulE71cWQYBxtp6QFCb3feddEWBkaHLlNHeg6YlqDZv1Upu2hGFboVtRurkns20hxNN61R1FG282Bg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ec8b:b0:16c:20d4:eb3 with SMTP id
 x11-20020a170902ec8b00b0016c20d40eb3mr2384465plg.40.1658537507307; Fri, 22
 Jul 2022 17:51:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Jul 2022 00:51:16 +0000
In-Reply-To: <20220723005137.1649592-1-seanjc@google.com>
Message-Id: <20220723005137.1649592-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220723005137.1649592-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v4 03/24] KVM: x86: Don't check for code breakpoints when
 emulating on exception
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't check for code breakpoints during instruction emulation if the
emulation was triggered by exception interception.  Code breakpoints are
the highest priority fault-like exception, and KVM only emulates on
exceptions that are fault-like.  Thus, if hardware signaled a different
exception, then the vCPU is already passed the stage of checking for
hardware breakpoints.

This is likely a glorified nop in terms of functionality, and is more for
clarification and is technically an optimization.  Intel's SDM explicitly
states vmcs.GUEST_RFLAGS.RF on exception interception is the same as the
value that would have been saved on the stack had the exception not been
intercepted, i.e. will be '1' due to all fault-like exceptions setting RF
to '1'.  AMD says "guest state saved ... is the processor state as of the
moment the intercept triggers", but that begs the question, "when does
the intercept trigger?".

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5366f884e9a7..566f9512b4a3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8523,8 +8523,24 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_skip_emulated_instruction);
 
-static bool kvm_vcpu_check_code_breakpoint(struct kvm_vcpu *vcpu, int *r)
+static bool kvm_vcpu_check_code_breakpoint(struct kvm_vcpu *vcpu,
+					   int emulation_type, int *r)
 {
+	WARN_ON_ONCE(emulation_type & EMULTYPE_NO_DECODE);
+
+	/*
+	 * Do not check for code breakpoints if hardware has already done the
+	 * checks, as inferred from the emulation type.  On NO_DECODE and SKIP,
+	 * the instruction has passed all exception checks, and all intercepted
+	 * exceptions that trigger emulation have lower priority than code
+	 * breakpoints, i.e. the fact that the intercepted exception occurred
+	 * means any code breakpoints have already been serviced.
+	 */
+	if (emulation_type & (EMULTYPE_NO_DECODE | EMULTYPE_SKIP |
+			      EMULTYPE_TRAP_UD | EMULTYPE_TRAP_UD_FORCED |
+			      EMULTYPE_VMWARE_GP | EMULTYPE_PF))
+		return false;
+
 	if (unlikely(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) &&
 	    (vcpu->arch.guest_debug_dr7 & DR7_BP_EN_MASK)) {
 		struct kvm_run *kvm_run = vcpu->run;
@@ -8646,8 +8662,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		 * are fault-like and are higher priority than any faults on
 		 * the code fetch itself.
 		 */
-		if (!(emulation_type & EMULTYPE_SKIP) &&
-		    kvm_vcpu_check_code_breakpoint(vcpu, &r))
+		if (kvm_vcpu_check_code_breakpoint(vcpu, emulation_type, &r))
 			return r;
 
 		r = x86_decode_emulated_instruction(vcpu, emulation_type,
-- 
2.37.1.359.gd136c6c3e2-goog

