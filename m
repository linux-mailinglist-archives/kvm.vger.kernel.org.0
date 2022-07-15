Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7161576855
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 22:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbiGOUnE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 16:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbiGOUmt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 16:42:49 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9747987F69
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:42:45 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id a17-20020a170902ecd100b0016c012c4cf3so2617287plh.15
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=iNAk41tsUidTro9q8ZhzpvrmhAAQBQ9Auq7TykB2O7k=;
        b=AOqLpJxVuh5bfFX7HjNUVWHjX8WUmZZlVreIDVpmWFszzrEKn/6Q5oMYVsR0iD56lL
         8OavSYfIbOdtxLPsSxTqk0+js2AaonIwXPDXa6EW2lMdTCz/rYO14U5Ge7WWEGlQOpyh
         F1F5AcMoVLXj+dUrKpfA/4HgiPrwqGEUhS7Jr+k6pJFxuRgONJeXOk6YUcMc5eS/hbfn
         7O/LbWWJZTS62LTiNoQAFCL4vUUzXBcZaeT1MAWPL/LtkT3DpVxfxiqUiaU7k3zugKou
         KH7UKG7G9+Lea/xH0QVLEEHY21Vlkodd31qv1K+2ktEFpr+9+5IwBZxLmyVQYSXWzY9w
         dUUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=iNAk41tsUidTro9q8ZhzpvrmhAAQBQ9Auq7TykB2O7k=;
        b=uMngFkBKFi8+jD2JSLuJETAPbjSqcJiZJO/Xzrcx1TPYAov2bCCZzLN2Seou/b3lDp
         AmY1Gx81G6J84VkXcSxLz3SvRR+GOj/NHvULK1wWiYuviWHAJULZGAidTnEAdt3/Y+Xg
         Lsk6Bsk9D9GXKxnVuL5+lN+5R8RxC/Falu7mHLsimTBi8j6kFOvn1Hg1Cyv/s7WqFnQF
         mrDNMY2yHloPHSVUc9BSl2Nw8TLP0uEr0vAKpHaqhrNiCn5VIvoKTY18uG3jKmk4fvb+
         JgoKGhS5T9/G5Yj+DmGNAR6mxqUhZfr1m0ktWH0RstrUmoTbYDZP9riO3ygShY2xFEvl
         YoMQ==
X-Gm-Message-State: AJIora/ivrYTeuptEQwjYHqBXBOvkVItJg6GAenptknzXItWnKTsAUbC
        e7q7bHHRz8/p8eewHhY8BM1zStLINQI=
X-Google-Smtp-Source: AGRyM1tsoX3vE8EAQuWM9f010GpKCLZT6AjFx+Rkk4JwsaX0b0mfooLowEqtouv7f3Bl2TR5fsxEljTByo0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d191:b0:16b:ea2d:60f2 with SMTP id
 m17-20020a170902d19100b0016bea2d60f2mr15049037plb.24.1657917764585; Fri, 15
 Jul 2022 13:42:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Jul 2022 20:42:08 +0000
In-Reply-To: <20220715204226.3655170-1-seanjc@google.com>
Message-Id: <20220715204226.3655170-7-seanjc@google.com>
Mime-Version: 1.0
References: <20220715204226.3655170-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v2 06/24] KVM: x86: Treat #DBs from the emulator as fault-like
 (code and DR7.GD=1)
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a dedicated "exception type" for #DBs, as #DBs can be fault-like or
trap-like depending the sub-type of #DB, and effectively defer the
decision of what to do with the #DB to the caller.

For the emulator's two calls to exception_type(), treat the #DB as
fault-like, as the emulator handles only code breakpoint and general
detect #DBs, both of which are fault-like.

For event injection, which uses exception_type() to determine whether to
set EFLAGS.RF=1 on the stack, keep the current behavior of not setting
RF=1 for #DBs.  Intel and AMD explicitly state RF isn't set on code #DBs,
so exempting by failing the "== EXCPT_FAULT" check is correct.  The only
other fault-like #DB is General Detect, and despite Intel and AMD both
strongly implying (through omission) that General Detect #DBs should set
RF=1, hardware (multiple generations of both Intel and AMD), in fact does
not.  Through insider knowledge, extreme foresight, sheer dumb luck, or
some combination thereof, KVM correctly handled RF for General Detect #DBs.

Fixes: 38827dbd3fb8 ("KVM: x86: Do not update EFLAGS on faulting emulation")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4efdb61e60ba..37d686dbb6aa 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -529,6 +529,7 @@ static int exception_class(int vector)
 #define EXCPT_TRAP		1
 #define EXCPT_ABORT		2
 #define EXCPT_INTERRUPT		3
+#define EXCPT_DB		4
 
 static int exception_type(int vector)
 {
@@ -539,8 +540,14 @@ static int exception_type(int vector)
 
 	mask = 1 << vector;
 
-	/* #DB is trap, as instruction watchpoints are handled elsewhere */
-	if (mask & ((1 << DB_VECTOR) | (1 << BP_VECTOR) | (1 << OF_VECTOR)))
+	/*
+	 * #DBs can be trap-like or fault-like, the caller must check other CPU
+	 * state, e.g. DR6, to determine whether a #DB is a trap or fault.
+	 */
+	if (mask & (1 << DB_VECTOR))
+		return EXCPT_DB;
+
+	if (mask & ((1 << BP_VECTOR) | (1 << OF_VECTOR)))
 		return EXCPT_TRAP;
 
 	if (mask & ((1 << DF_VECTOR) | (1 << MC_VECTOR)))
@@ -8785,6 +8792,12 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		unsigned long rflags = static_call(kvm_x86_get_rflags)(vcpu);
 		toggle_interruptibility(vcpu, ctxt->interruptibility);
 		vcpu->arch.emulate_regs_need_sync_to_vcpu = false;
+
+		/*
+		 * Note, EXCPT_DB is assumed to be fault-like as the emulator
+		 * only supports code breakpoints and general detect #DB, both
+		 * of which are fault-like.
+		 */
 		if (!ctxt->have_exception ||
 		    exception_type(ctxt->exception.vector) == EXCPT_TRAP) {
 			kvm_pmu_trigger_event(vcpu, PERF_COUNT_HW_INSTRUCTIONS);
@@ -9701,6 +9714,16 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 
 	/* try to inject new event if pending */
 	if (vcpu->arch.exception.pending) {
+		/*
+		 * Fault-class exceptions, except #DBs, set RF=1 in the RFLAGS
+		 * value pushed on the stack.  Trap-like exception and all #DBs
+		 * leave RF as-is (KVM follows Intel's behavior in this regard;
+		 * AMD states that code breakpoint #DBs excplitly clear RF=0).
+		 *
+		 * Note, most versions of Intel's SDM and AMD's APM incorrectly
+		 * describe the behavior of General Detect #DBs, which are
+		 * fault-like.  They do _not_ set RF, a la code breakpoints.
+		 */
 		if (exception_type(vcpu->arch.exception.nr) == EXCPT_FAULT)
 			__kvm_set_rflags(vcpu, kvm_get_rflags(vcpu) |
 					     X86_EFLAGS_RF);
-- 
2.37.0.170.g444d1eabd0-goog

