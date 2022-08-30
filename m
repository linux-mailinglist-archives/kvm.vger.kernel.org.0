Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA085A718F
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 01:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbiH3XRf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 19:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231788AbiH3XQr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 19:16:47 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB85C6BCEE
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:16:22 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id p8-20020a170902e74800b0017307429ca3so8840455plf.17
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=Mh9I+JSjtQjMTePFCwYbFYKBb/UOzkx18CwX/puQayY=;
        b=b1q1QQ4hrOfrbYEtpy2NkDBcAcbbfMYmT/fY1WwkyNSFMjAozfijLm6XzZA6JQMTzz
         aAmfoOaBs1XKxk5IgrD2mRkHfbjzebx/tis9Q89UvMOGgSKksqPK8fn7YDmkBtiCc9Cs
         n/E//Vxa8YG7s4TeHEDpzp3JgEpFz92AMkBHOJmbNIQy3yR0l+osHWJsGJcwSHWBjmTw
         RFAwXbn6QNxSmTOTj8uruEVUeGL1FJHcwfE5mGRKAlsChFrSD2k4X1MT5WaliTihBAZm
         VsrRO6ZeomETA1TnxUwKH6SRy/ufq3xU98IuKMwVaAu1HrV9lO6kDJiTjQQ3UZ43iNKA
         qPVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=Mh9I+JSjtQjMTePFCwYbFYKBb/UOzkx18CwX/puQayY=;
        b=MJ/yfN0Zi+hEFfyd17PloKDbcx76000WoQudcKlBhXE/knVBtXUlM2AUMWE1Q2Bcsf
         qjdrQdmfaRUacxAptCTEa93Rq+JPNjUjHqJ4slGiOq1iKG2OjF5YuHtBrSNlo7oUS5YW
         4dPiJbiuWABWdxdE01JfwLLPLX+JXIBKGsB40iXt7f0CONxMpmR0cYziKf4N0ywBf5zQ
         CSm/c5wCSmSTedM/QKq/aeYvb0X77qMseI8EZXAUnAvT/D0dThQ5Py6S5z6MdeRUVpEJ
         Ua5vN1K8xpGbGEGf44opdpU/gy3UB0K45oz8t+bdY1wx1+QtZxu0eUXNc4R7cCi81ARM
         NO7Q==
X-Gm-Message-State: ACgBeo2BZ5Z0smF6/hDWpWgfayl49lGk5Y6eBERPxEMioG/nmD9wfsD5
        fosqOFSJG4n3oUKODZUiUyVNm7E8kuE=
X-Google-Smtp-Source: AA6agR5ZXNMSxVy2nO07PEqB0rsk6xgiev+DGTd8hj8k9d4mvJC+KST/4NEANGNvwwPDv321ttXfwjotZFY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d50c:b0:175:2cb2:e0e7 with SMTP id
 b12-20020a170902d50c00b001752cb2e0e7mr3760462plg.157.1661901381865; Tue, 30
 Aug 2022 16:16:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 30 Aug 2022 23:15:50 +0000
In-Reply-To: <20220830231614.3580124-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220830231614.3580124-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830231614.3580124-4-seanjc@google.com>
Subject: [PATCH v5 03/27] KVM: x86: Don't check for code breakpoints when
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/x86.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d7374d768296..fead0e8cd3e3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8535,8 +8535,29 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
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
+	 *
+	 * Note, KVM needs to check for code #DBs on EMULTYPE_TRAP_UD_FORCED as
+	 * hardware has checked the RIP of the magic prefix, but not the RIP of
+	 * the instruction being emulated.  The intent of forced emulation is
+	 * to behave as if KVM intercepted the instruction without an exception
+	 * and without a prefix.
+	 */
+	if (emulation_type & (EMULTYPE_NO_DECODE | EMULTYPE_SKIP |
+			      EMULTYPE_TRAP_UD | EMULTYPE_VMWARE_GP | EMULTYPE_PF))
+		return false;
+
 	if (unlikely(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) &&
 	    (vcpu->arch.guest_debug_dr7 & DR7_BP_EN_MASK)) {
 		struct kvm_run *kvm_run = vcpu->run;
@@ -8658,8 +8679,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		 * are fault-like and are higher priority than any faults on
 		 * the code fetch itself.
 		 */
-		if (!(emulation_type & EMULTYPE_SKIP) &&
-		    kvm_vcpu_check_code_breakpoint(vcpu, &r))
+		if (kvm_vcpu_check_code_breakpoint(vcpu, emulation_type, &r))
 			return r;
 
 		r = x86_decode_emulated_instruction(vcpu, emulation_type,
-- 
2.37.2.672.g94769d06f0-goog

