Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFC79576853
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 22:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbiGOUnU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 16:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231676AbiGOUnD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 16:43:03 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1A688F2A
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:42:50 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id i17-20020a170902c95100b0016c449584a9so2565091pla.1
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=5CEhQev3jj2fjNVlxRNDIRhfS/5UeBz9oyunGAn2304=;
        b=NNA8lQszOAmO31FpoWVTflYcxyF1CSjoFt7c2TX/9M7M2sXpzawmpD7jBlmnno5Dsg
         05unw8PJlwoPd2RVKF8Eculu+XoBQBVJUfbJdvlnnCAsS4o5Uk5kwZhPlDkHaDzYW4TO
         Q+FhEqfLQ0LBHLmpPe7DoQmrZya47lqlV9aSiJRI6x9uKzRoFiHzFkz6IJpBIuu2vcTj
         ggC+1z9sOLVTmrjD9kAYuquqeR5HhpkPoWoITmVATT0/yHnxOrr1A1iYuuufgjb8oWe0
         vqtNDzprgIv8vETqeNEIa6LNAdwKCV70q0xZgUc2Hz22WHhhG0HTo6vsw+NNAt8wt6sy
         Z8Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=5CEhQev3jj2fjNVlxRNDIRhfS/5UeBz9oyunGAn2304=;
        b=PvOnrogAECcRH9sjv/7xcu7vbPuRGySM1N3pkjEEpb67WaEq4XngJnLHdTIQ4aqXCJ
         G8Ldb9niqbVNzcjEUKeF39N9xSNVjlIeUKX7WQDIe6DqJeI3I5SWEUZNTaPw1DInOKDg
         +v7HtclbDV/AoAfkivMgag5gC9ePf9wx0lQwrMkkTM09Ur+KSVgRr/qQh3AQ+Qsbfk9B
         kzDcN1LORYNtnRrSdmn1If+/IMXb1sugPxlKKN3MKZxsccxp4cFNrwgGIU06+f8A5HJ7
         l1wr5RijmsR6KYB+SHPmQ7RgCLEmAOi7zdE48Ugx94bDlMMnIk7tB5jesZbykZH+2xAf
         NAdQ==
X-Gm-Message-State: AJIora+D0yMf3rLeXxaBKie3wK/2j5g+Qc+Zgs9VXx9SCnBWOtL1MvW6
        9OA2Zr3Av57wKH3tQhEVbi4uE9OcKAk=
X-Google-Smtp-Source: AGRyM1v6WidDYKv44QbhzpbakqdfUUDtGY8sqpKaznPPvicJwCxncilPQhITSL5pK1WDZyWpvaIkDd0Qnk0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2143:b0:16b:e136:12d2 with SMTP id
 s3-20020a170903214300b0016be13612d2mr14838302ple.5.1657917769383; Fri, 15 Jul
 2022 13:42:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Jul 2022 20:42:11 +0000
In-Reply-To: <20220715204226.3655170-1-seanjc@google.com>
Message-Id: <20220715204226.3655170-10-seanjc@google.com>
Mime-Version: 1.0
References: <20220715204226.3655170-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v2 09/24] KVM: nVMX: Unconditionally clear mtf_pending on
 nested VM-Exit
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

Clear mtf_pending on nested VM-Exit instead of handling the clear on a
case-by-case basis in vmx_check_nested_events().  The pending MTF should
never survive nested VM-Exit, as it is a property of KVM's run of the
current L2, i.e. should never affect the next L2 run by L1.  In practice,
this is likely a nop as getting to L1 with nested_run_pending is
impossible, and KVM doesn't correctly handle morphing a pending exception
that occurs on a prior injected exception (need for re-injected exception
being the other case where MTF isn't cleared).  However, KVM will
hopefully soon correctly deal with a pending exception on top of an
injected exception.

Add a TODO to document that KVM has an inversion priority bug between
SMIs and MTF (and trap-like #DBS), and that KVM also doesn't properly
save/restore MTF across SMI/RSM.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 104f233ddd5d..a85f31cee149 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3898,16 +3898,8 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	unsigned long exit_qual;
 	bool block_nested_events =
 	    vmx->nested.nested_run_pending || kvm_event_needs_reinjection(vcpu);
-	bool mtf_pending = vmx->nested.mtf_pending;
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
-	/*
-	 * Clear the MTF state. If a higher priority VM-exit is delivered first,
-	 * this state is discarded.
-	 */
-	if (!block_nested_events)
-		vmx->nested.mtf_pending = false;
-
 	if (lapic_in_kernel(vcpu) &&
 		test_bit(KVM_APIC_INIT, &apic->pending_events)) {
 		if (block_nested_events)
@@ -3916,6 +3908,9 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 		clear_bit(KVM_APIC_INIT, &apic->pending_events);
 		if (vcpu->arch.mp_state != KVM_MP_STATE_INIT_RECEIVED)
 			nested_vmx_vmexit(vcpu, EXIT_REASON_INIT_SIGNAL, 0, 0);
+
+		/* MTF is discarded if the vCPU is in WFS. */
+		vmx->nested.mtf_pending = false;
 		return 0;
 	}
 
@@ -3938,6 +3933,11 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	 * fault-like exceptions, TSS T flag #DB (not emulated by KVM, but
 	 * could theoretically come in from userspace), and ICEBP (INT1).
 	 *
+	 * TODO: SMIs have higher priority than MTF and trap-like #DBs (except
+	 * for TSS T flag #DBs).  KVM also doesn't save/restore pending MTF
+	 * across SMI/RSM as it should; that needs to be addressed in order to
+	 * prioritize SMI over MTF and trap-like #DBs.
+	 *
 	 * Note that only a pending nested run can block a pending exception.
 	 * Otherwise an injected NMI/interrupt should either be
 	 * lost or delivered to the nested hypervisor in the IDT_VECTORING_INFO,
@@ -3953,7 +3953,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
-	if (mtf_pending) {
+	if (vmx->nested.mtf_pending) {
 		if (block_nested_events)
 			return -EBUSY;
 		nested_vmx_update_pending_dbg(vcpu);
@@ -4549,6 +4549,9 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 
+	/* Pending MTF traps are discarded on VM-Exit. */
+	vmx->nested.mtf_pending = false;
+
 	/* trying to cancel vmlaunch/vmresume is a bug */
 	WARN_ON_ONCE(vmx->nested.nested_run_pending);
 
-- 
2.37.0.170.g444d1eabd0-goog

