Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82EB157685B
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 22:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbiGOUmr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 16:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbiGOUml (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 16:42:41 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E6787C37
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:42:39 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-31ce88f9ab8so47824347b3.16
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=XaWS8LbhbBC14KHRu/UMZ0VrY5IYn1B7OmHtIsROozk=;
        b=FxXXiG7IAizzt0hgccKAXP+W3ljcErsJLZbJeNfT7M2oIx33QM508seYqWjRWt3Gvz
         I1fLkEyrAvAH4AL4RuCjYVswSaIEPNNRB0qnLVHCrfvSTKhs2wNTLjpUxVlx3ILUIvVw
         hcGnO72MJ+W84VkhzA2tDsy9YpdBHAG8qnvdMSQ0cliOol5SQzxDLnPglfHyt8MItuZQ
         38mxtL+96Argz1UQmzN4ZPg9BmOQLJfKHatFRyGbU9SLw4H/3oyM3sSrx0UpbTckkMj6
         SUN6mq2PNlaB+kNc9fdsIKu5VOpPyFA4VbyiyDg/20KV8PvVjqYH35D7Qebor5hsci4f
         7FdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=XaWS8LbhbBC14KHRu/UMZ0VrY5IYn1B7OmHtIsROozk=;
        b=QUOGCpwwryOA5AD5miVL+JItKpfxwxFKB6GpiPbIZj1iCwGImTSj+IzXmNh3DCrXTA
         JGDtHOashZbNFM4nLvyCFBowUs1C9bAYCvu+uHSIiKzGUyL1mduzFFA3tOvutksl35Dp
         diwEcjh+FJ6NtzUPBcN4Yy8RHyhNWoiJNukCdPZGj7yaRYMh7SKTXPmiu2Dl3c8TrSE1
         GxEDUicdu+RTwhDdZhO/JSkE834rkmDi65nppKOTmXwM6K/NU2MKPSFx2HI0ReUPKold
         1LPaHzoYWemEesPA6/nVy98/QgJH5scBDQ3w3DEYyEPGOHJoFdviWv4c/8B/8xuUrCmY
         ymUQ==
X-Gm-Message-State: AJIora8yymLoCFpLFoE7sctdEHkY86P8bOW+gR+TWksI5wwQb2rxhXDp
        BFkBocKgGNRjJcXTfGJmj0j1rUcfg+I=
X-Google-Smtp-Source: AGRyM1usU0pP86LIERbZu4Kai+tEgErFUJB47c2GKFB2+e50nsaw7Up7PfX2doLx1/n0IaB6CFPcH/l+ehk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:88a:0:b0:31c:51cd:9e09 with SMTP id
 132-20020a81088a000000b0031c51cd9e09mr18049167ywi.374.1657917759022; Fri, 15
 Jul 2022 13:42:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Jul 2022 20:42:05 +0000
In-Reply-To: <20220715204226.3655170-1-seanjc@google.com>
Message-Id: <20220715204226.3655170-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220715204226.3655170-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v2 03/24] KVM: x86: Don't check for code breakpoints when
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
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
index f389691d8c04..4efdb61e60ba 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8517,8 +8517,24 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
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
@@ -8640,8 +8656,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		 * are fault-like and are higher priority than any faults on
 		 * the code fetch itself.
 		 */
-		if (!(emulation_type & EMULTYPE_SKIP) &&
-		    kvm_vcpu_check_code_breakpoint(vcpu, &r))
+		if (kvm_vcpu_check_code_breakpoint(vcpu, emulation_type, &r))
 			return r;
 
 		r = x86_decode_emulated_instruction(vcpu, emulation_type,
-- 
2.37.0.170.g444d1eabd0-goog

