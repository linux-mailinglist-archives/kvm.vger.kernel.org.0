Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7FB54D58E8
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 04:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346052AbiCKD3S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 22:29:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346015AbiCKD3N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 22:29:13 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A0EEBAF5
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 19:28:11 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id cl16-20020a17090af69000b001beea61ada4so4520998pjb.5
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 19:28:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=eeiWwVzbFJEQZHfLJkzt4Xui3WAD154yxH7Bf8Mh/wY=;
        b=V8JhYgObuMTrguU8wNFOf3ct7rERE5iwETFN/nEi8Fb5T8mhY+8sLgfuIrQes2c7Z7
         WMz7v6Jdka2/myXZW9wPkAlUuiNYnXUk9XJhcUpuQ0HQ0LbfrAe78PWpwjBxFJvyTk5z
         5Z7aVor0PaHxajLjeI8+OU0MN2d6tOYar7q4f0IN3loPRUqNIcDMnbECQPiZX0zA3E58
         KirztV80EUnbIUgx5VeZ4+5rCDsT5+52GXkgUE4hHjbu4/G3d82KQIZOl9kqjBOgmGZT
         2Vb8pRnjRVQu0ClJ6CrKYsM59OI2cTpBse7wmQy8WHEfhsjGw4tgpXIWPtPD9dkEuzAB
         kzGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=eeiWwVzbFJEQZHfLJkzt4Xui3WAD154yxH7Bf8Mh/wY=;
        b=L5srpNkiNI536WAE97tmgcvFumLjafBX7sQRmyDDLhHw8sAl81P4QrkEUN1Wej2jL9
         inM0z/yuB1waBXzo2NR7cBMDJXVjAT0zVezujQepZ5AzJWusX948ssHeO66DjBUk3a0U
         n2/8gR1um3sgghEKf8g89sJB4jdPzKXhKnRgJGTS9ibIr/16trzdguNt7qHNUJjKZZuY
         xFTOOAlPbgR3sFNQ28ACGsdhqcUsGjTzKJN3j9CjOWa8JGDQzguAn4C0OIXLzXiOmEqW
         F6ZNCnhGna4klDtrtoMuBzsovuJOvkxGKlb1vxEdftKJwQ8q4B88Mmo6FxIR5FjY6Tpy
         Wzow==
X-Gm-Message-State: AOAM530iJZmBQC00WcVJbPfh+rF19HZGSzFxplK6Jo4ibx48RkD0PPBu
        o7PKxGGjsOnh6xDnJ77PC0ucajQEtdU=
X-Google-Smtp-Source: ABdhPJzx/4uQjDdd07wksC3Yi2WeYGtP6QOPZzhgOg23mGYLXrxk0cTDsoZNU9dWNj57GJ6PFu5ayq1LiOo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:bc8:b0:4f6:ff68:50ba with SMTP id
 x8-20020a056a000bc800b004f6ff6850bamr7992417pfu.69.1646969290649; Thu, 10 Mar
 2022 19:28:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 11 Mar 2022 03:27:44 +0000
In-Reply-To: <20220311032801.3467418-1-seanjc@google.com>
Message-Id: <20220311032801.3467418-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220311032801.3467418-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 04/21] KVM: x86: Don't check for code breakpoints when
 emulating on exception
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
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
---
 arch/x86/kvm/x86.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index feacc0901c24..3636206ed3e4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8212,8 +8212,24 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
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
@@ -8335,8 +8351,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		 * are fault-like and are higher priority than any faults on
 		 * the code fetch itself.
 		 */
-		if (!(emulation_type & EMULTYPE_SKIP) &&
-		    kvm_vcpu_check_code_breakpoint(vcpu, &r))
+		if (kvm_vcpu_check_code_breakpoint(vcpu, emulation_type, &r))
 			return r;
 
 		r = x86_decode_emulated_instruction(vcpu, emulation_type,
-- 
2.35.1.723.g4982287a31-goog

