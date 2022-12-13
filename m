Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B96364AFA1
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 07:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234093AbiLMGJm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 01:09:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234392AbiLMGJY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 01:09:24 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A138D1AD80
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 22:09:23 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id x8-20020a17090a1f8800b0022153149290so1330820pja.5
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 22:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=NFEhFRkg0+nIHx94jx/VqF2L4sTiUmledWciOk7WPsw=;
        b=Mb6tzs3YFjNk5QMuKsNyQaWTpQK6Q7lsJPdTl4vbogpOKDC+ntZV7Jpct4rB9qejgS
         +TtDI14OD1/tbbyL0L1wge29Emn1TKCNDyUVIVW/9MyHaXI0nXK8IvBdIC6yg8guyoAF
         gfuWOj8X/Vo1tvZWFwPCHpGbpQmSokz4ohTqy8O5ywgy8xNUQdq25HZyfOn06xVPbeHz
         f1jN5vSQgRJo2tLg2dmUbtNrbiKUpHc6IEDkC93EvSlNUWgEFgWzh466hT2saqDJ4VPo
         6z92FRVBWysyeOs5/s4MlzrzvuBOUfUzSekVTf7PEWy4nB84hbdH6GhBOxMWrJyxaqJ0
         D0sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NFEhFRkg0+nIHx94jx/VqF2L4sTiUmledWciOk7WPsw=;
        b=gDbXnkaNuJohgnJrorb8d4hLRy/zV7vwAbR2IoSRN5zJctdJxQP6KAtaPjlOnQZTC0
         HCvoWcQKYdjOZhblvUIHsbCeexvdPm7yN4wX6gsxamV1Ik9v3NJUyw/BWhL3dJyIRs1e
         7vM2dUyCg31hQXrwzbhWl02dns6/x4TSTMMH7jcfxTkAXuc5YKTpN5aaLFdesOHQ8/aT
         hKot+0uhOjqfvuBMsDEnlm9KURCq67hIjjICFTCXX1w4ojKyNe6ndjY7wFrSS+6zOzN9
         VO0zq2YhHZoj/ilechLO+WqwNvaWnL5mqe0a2lou4dH6GVUrFDa5sYjLDj1fCX0Npb7K
         axpA==
X-Gm-Message-State: ANoB5pl4TyXQTEe6FE+2p84QgEn6wtNWsRsNshgTH5Wk5JKBExz4Q4g7
        flvSR4Cx/A1eOC+pfQAwxuuFO6termM=
X-Google-Smtp-Source: AA0mqf5jt5c245aUwJezKZHvkmsfBuO04Z+Vnt9FiIfW7ooVnZwK9K2l+TpVRWvrG4KVi9WhnTLJKZwG7M8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:2d90:b0:219:7904:6de with SMTP id
 sj16-20020a17090b2d9000b00219790406demr166821pjb.136.1670911763239; Mon, 12
 Dec 2022 22:09:23 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Dec 2022 06:09:09 +0000
In-Reply-To: <20221213060912.654668-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221213060912.654668-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213060912.654668-5-seanjc@google.com>
Subject: [PATCH 4/7] KVM: VMX: Always inline to_vmx() and to_kvm_vmx()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
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

Tag to_vmx() and to_kvm_vmx() __always_inline as they both just reflect
the passed in pointer (the embedded struct is the first field in the
container), and drop the @vmx param from vmx_vcpu_enter_exit(), which
likely existed purely to make noinstr validation happy.

Amusingly, when the compiler decides to not inline the helpers, e.g. for
KASAN builds, to_vmx() and to_kvm_vmx() may end up pointing at the same
symbol, which generates very confusing objtool warnings.  E.g. the use of
to_vmx() in a future patch led to objtool complaining about to_kvm_vmx(),
and only once all use of to_kvm_vmx() was commented out did to_vmx() pop
up in the obj tool report.

  vmlinux.o: warning: objtool: vmx_vcpu_enter_exit+0x160: call to to_kvm_vmx()
                               leaves .noinstr.text section

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 5 +++--
 arch/x86/kvm/vmx/vmx.h | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fe5615fd8295..e2c96f204b82 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7096,9 +7096,10 @@ static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 }
 
 static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
-					struct vcpu_vmx *vmx,
 					unsigned long flags)
 {
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
 	guest_state_enter_irqoff();
 
 	/* L1D Flush includes CPU buffer clear to mitigate MDS */
@@ -7216,7 +7217,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	kvm_wait_lapic_expire(vcpu);
 
 	/* The actual VMENTER/EXIT is in the .noinstr.text section. */
-	vmx_vcpu_enter_exit(vcpu, vmx, __vmx_vcpu_run_flags(vmx));
+	vmx_vcpu_enter_exit(vcpu, __vmx_vcpu_run_flags(vmx));
 
 	/* All fields are clean at this point */
 	if (static_branch_unlikely(&enable_evmcs)) {
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index bb720a2f11ab..2acdc54bc34b 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -640,12 +640,12 @@ BUILD_CONTROLS_SHADOW(tertiary_exec, TERTIARY_VM_EXEC_CONTROL, 64)
 				(1 << VCPU_EXREG_EXIT_INFO_1) | \
 				(1 << VCPU_EXREG_EXIT_INFO_2))
 
-static inline struct kvm_vmx *to_kvm_vmx(struct kvm *kvm)
+static __always_inline struct kvm_vmx *to_kvm_vmx(struct kvm *kvm)
 {
 	return container_of(kvm, struct kvm_vmx, kvm);
 }
 
-static inline struct vcpu_vmx *to_vmx(struct kvm_vcpu *vcpu)
+static __always_inline struct vcpu_vmx *to_vmx(struct kvm_vcpu *vcpu)
 {
 	return container_of(vcpu, struct vcpu_vmx, vcpu);
 }
-- 
2.39.0.rc1.256.g54fd8350bd-goog

